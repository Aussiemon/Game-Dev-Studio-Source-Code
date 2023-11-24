gridSpriteBatchCollection = {}
gridSpriteBatchCollection.mtindex = {
	__index = gridSpriteBatchCollection
}

function gridSpriteBatchCollection.new()
	local new = {}
	
	setmetatable(new, gridSpriteBatchCollection.mtindex)
	new:init()
	
	return new
end

function gridSpriteBatchCollection:init()
	self.spriteBatchList = {}
	self.spriteBatches = {}
	self.activeSpriteBatches = {}
	self.spriteIDs = {}
	self.activeSprites = {}
	self.textureIDs = {}
	self.drawnSprites = {}
	self.spriteBatchPriorities = {}
end

function gridSpriteBatchCollection:remove()
	local pr = priorityRenderer
	local sbs = self.spriteBatches
	
	for key, id in ipairs(self.textureIDs) do
		local spriteBatch = sbs[id]
		
		spriteBatch:resetContainer()
		pr:remove(spriteBatch)
		
		sbs[id] = nil
	end
end

function gridSpriteBatchCollection:setupDrawing(drawMethod, postDrawMethod, sortSprites)
	for key, id in ipairs(self.textureIDs) do
		local sb = self.spriteBatches[id]
		
		sb:setDrawCallback(drawMethod)
		sb:setPostDrawCallback(postDrawMethod)
		sb:setShouldSortSprites(sortSprites)
	end
end

function gridSpriteBatchCollection:addSpriteBatch(object, depth)
	local image = object:getTexture()
	local id = cache.getImageID(image)
	
	self.spriteBatches[id] = object
	self.drawnSprites[id] = 0
	self.spriteIDs[id] = {}
	self.textureIDs[#self.textureIDs + 1] = id
	self.spriteBatchPriorities[id] = depth
	self.spriteBatchList[#self.spriteBatchList + 1] = object
end

function gridSpriteBatchCollection:getSpriteBatches()
	return self.spriteBatchList
end

function gridSpriteBatchCollection:allocateSlot(id, index)
	local prevID = self.activeSprites[index]
	
	if prevID then
		if id == prevID then
			local prevSlot = self.spriteIDs[id][index]
			
			if prevSlot then
				return prevSlot
			end
		else
			self:_clearSprite(prevID, index)
		end
	end
	
	self.activeSprites[index] = id
	
	local slot = self.spriteBatches[id]:allocateSlot()
	
	self.spriteIDs[id][index] = slot
	
	return slot
end

function gridSpriteBatchCollection:deallocateSlot(id, index)
	self.spriteBatches[id]:deallocateSlot(self.spriteIDs[id][index])
	
	self.activeSprites[index] = nil
end

function gridSpriteBatchCollection:clearSprite(index)
	local id = self.activeSprites[index]
	
	if id then
		local batch = self.spriteBatches[id]
		
		batch:deallocateSlot(self.spriteIDs[id][index])
		
		self.spriteIDs[id][index] = nil
		self.activeSprites[index] = nil
		
		local new = self.drawnSprites[id] - 1
		
		self.drawnSprites[id] = new
		
		if new == 0 then
			priorityRenderer:remove(batch)
			table.removeObject(self.activeSpriteBatches, batch)
		end
	end
end

function gridSpriteBatchCollection:_clearSprite(id, index)
	local batch = self.spriteBatches[id]
	
	batch:deallocateSlot(self.spriteIDs[id][index])
	
	self.activeSprites[index] = nil
	
	local new = self.drawnSprites[id] - 1
	
	self.drawnSprites[id] = new
	
	if new == 0 then
		priorityRenderer:remove(batch)
		table.removeObject(self.activeSpriteBatches, batch)
	end
end

function gridSpriteBatchCollection:getTextureID(index)
	return self.activeSprites[index]
end

function gridSpriteBatchCollection:getSpriteSlot(id, index)
	return self.spriteIDs[id][index]
end

function gridSpriteBatchCollection:newSprite(id, index, x, y, rotation, quad, scaleX, scaleY, halfWidth, halfHeight)
	local new = self.drawnSprites[id] + 1
	local batch = self.spriteBatches[id]
	
	if new == 1 then
		priorityRenderer:add(batch, self.spriteBatchPriorities[id])
		table.insert(self.activeSpriteBatches, batch)
	end
	
	local slot = self:allocateSlot(id, index)
	
	batch:updateSprite(slot, quad, x, y, rotation, scaleX, scaleY, halfWidth, halfHeight)
	
	self.drawnSprites[id] = new
end

function gridSpriteBatchCollection:applySprite(id, oldID, index, x, y, rotation, quad, scaleX, scaleY, halfWidth, halfHeight)
	local batch = self.spriteBatches[id]
	local new = self.drawnSprites[id] + 1
	local slot
	
	if oldID then
		if id ~= oldID then
			self.spriteBatches[oldID]:deallocateSlot(self.spriteIDs[oldID][index])
			
			self.activeSprites[index] = nil
			
			local new = self.drawnSprites[oldID] - 1
			
			self.drawnSprites[oldID] = new
			
			if new == 0 then
				priorityRenderer:remove(batch)
				table.removeObject(self.activeSpriteBatches, batch)
			end
		else
			slot = self.spriteIDs[oldID][index]
		end
	else
		slot = self:allocateSlot(id, index)
		
		if new == 1 then
			priorityRenderer:add(batch, self.spriteBatchPriorities[id])
			table.insert(self.activeSpriteBatches, batch)
		end
		
		self.drawnSprites[id] = new
	end
	
	batch:updateSprite(slot, quad, x, y, rotation, scaleX, scaleY, halfWidth, halfHeight)
end

function gridSpriteBatchCollection:draw(x, y, scaleX, scaleY)
	for key, batch in ipairs(self.activeSpriteBatches) do
		batch:updateSprites()
		love.graphics.draw(batch:getSpritebatch(), x, y, 0, scaleX, scaleY)
	end
end
