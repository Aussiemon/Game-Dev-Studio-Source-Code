gridWallSpriteBatchCollection = {}

setmetatable(gridWallSpriteBatchCollection, gridSpriteBatchCollection.mtindex)

gridWallSpriteBatchCollection.mtindex = {
	__index = gridWallSpriteBatchCollection
}

function gridWallSpriteBatchCollection.new()
	local new = {}
	
	setmetatable(new, gridWallSpriteBatchCollection.mtindex)
	new:init()
	
	return new
end

function gridWallSpriteBatchCollection:deallocateSlot(id, index)
end

function gridWallSpriteBatchCollection:init()
	gridSpriteBatchCollection.init(self)
	
	self.spriteUsageByID = {}
end

function gridWallSpriteBatchCollection:addSpriteBatch(object, depth)
	local image = object:getTexture()
	local id = cache.getImageID(image)
	
	self.spriteBatches[id] = object
	self.drawnSprites[id] = 0
	self.spriteIDs[id] = {}
	self.textureIDs[#self.textureIDs + 1] = id
	self.spriteBatchPriorities[id] = depth
	self.spriteUsageByID[id] = {}
	self.spriteBatchList[#self.spriteBatchList + 1] = object
end

function gridWallSpriteBatchCollection:allocateSlot(id, index)
	local new = self.spriteUsageByID[id][index]
	
	if not new then
		self.spriteUsageByID[id][index] = 1
		new = 1
	else
		new = new + 1
		self.spriteUsageByID[id][index] = new
	end
	
	if new == 1 then
		local activeList = self.activeSprites[index]
		
		if not activeList then
			self.activeSprites[index] = {
				id
			}
		else
			activeList[#activeList + 1] = id
		end
	end
	
	local slot = self.spriteBatches[id]:allocateSlot()
	local list = self.spriteIDs[id][index]
	
	if not list then
		list = {
			slot
		}
		self.spriteIDs[id][index] = list
	else
		list[#list + 1] = slot
	end
	
	return slot
end

function gridWallSpriteBatchCollection:clearSprite(index)
	local list = self.activeSprites[index]
	
	if list and #list > 0 then
		local sbs = self.spriteBatches
		local drawn = self.drawnSprites
		local spriteIDs = self.spriteIDs
		local usageByID = self.spriteUsageByID
		local realIndex = 1
		
		for i = 1, #list do
			local id = list[realIndex]
			local slots = spriteIDs[id][index]
			local count = #slots
			local new = drawn[id] - count
			local indexByID = usageByID[id][index] - count
			local batch = sbs[id]
			
			drawn[id] = new
			usageByID[id][index] = indexByID
			
			for key, slot in ipairs(slots) do
				batch:deallocateSlot(slot)
				
				slots[key] = nil
			end
			
			if indexByID == 0 then
				table.remove(list, realIndex)
			else
				realIndex = realIndex + 1
			end
			
			if new == 0 then
				priorityRenderer:remove(batch)
				table.removeObject(self.activeSpriteBatches, batch)
			end
		end
	end
end
