spriteBatchController = {}
spriteBatchController.spriteBatches = {}
spriteBatchController.renderOrder = {}
spriteBatchController.defaultSize = 8
spriteBatchController.defaultUsageHint = "stream"
spriteBatchController.defaultDepth = 1
spriteBatchController.defaultResetPostDraw = true
spriteBatchController.defaultFillWhenNecessary = true
spriteBatchController.defaultAlwaysActive = false
spriteBatchController.SLOT_COUNT_INCREASE = 512

local function sortByDepth_Ascending(a, b)
	return a.depth < b.depth
end

local controlledSpriteBatch = {}

controlledSpriteBatch.mtindex = {
	__index = controlledSpriteBatch
}
controlledSpriteBatch.SPRITEBATCH = true

function controlledSpriteBatch.defaultDrawCallback()
	return false
end

controlledSpriteBatch.drawCallback = controlledSpriteBatch.defaultDrawCallback

function controlledSpriteBatch.defaultPostDrawCallback()
end

controlledSpriteBatch.postDrawCallback = controlledSpriteBatch.defaultPostDrawCallback

function controlledSpriteBatch:init()
	self.seenSprites = {}
	self.queuedSpriteUpdates = {}
	self.queuedSpriteUpdatesMap = {}
	self.spriteUpdateBuffer = {}
	self.updateBufferCount = 0
	self.visibility = 0
	
	self:setColor(255, 255, 255, 255)
end

function controlledSpriteBatch:getTexture()
	return self.imageObj
end

function controlledSpriteBatch:setShouldSortSprites(should)
	if should then
		self.allocateSlot = self.allocateSlotWithSorting
	else
		self.allocateSlot = self._allocateSlot
	end
end

function controlledSpriteBatch:retrieveUpdateBuffer()
	if self.updateBufferCount > 0 then
		local buffer = self.spriteUpdateBuffer[self.updateBufferCount]
		
		self:resetBuffer(buffer)
		table.remove(self.spriteUpdateBuffer, self.updateBufferCount)
		
		self.updateBufferCount = self.updateBufferCount - 1
		
		return buffer
	end
	
	return {}
end

function controlledSpriteBatch:storeUpdateBuffer(list)
	self.updateBufferCount = self.updateBufferCount + 1
	self.spriteUpdateBuffer[self.updateBufferCount] = list
end

function controlledSpriteBatch:resetBuffer(list)
	list.quad, list.x, list.y, list.r, list.sx, list.sy, list.ox, list.oy = nil
end

function controlledSpriteBatch:updateSprites()
	local list, map = self.queuedSpriteUpdates, self.queuedSpriteUpdatesMap
	
	for i = #list, 1, -1 do
		local slot = list[i]
		local b = map[slot]
		
		self.spriteBatch:setColor(b.r, b.g, b.b, b.a)
		self.spriteBatch:set(slot, b.quad, b.x, b.y, b.rot, b.sx, b.sy, b.ox, b.oy)
		
		list[i] = nil
		map[slot] = nil
		
		self:storeUpdateBuffer(b)
	end
end

function controlledSpriteBatch:draw(x, y, scaleX, scaleY)
	if not self.active and not self.alwaysActive then
		return false
	end
	
	return self:_draw(x, y, scaleX, scaleY)
end

function controlledSpriteBatch:_draw(x, y, scaleX, scaleY)
	self:updateSprites()
	
	if not self:drawCallback(x, y, scaleX, scaleY) then
		local sb = self.spriteBatch
		
		love.graphics.draw(sb, x, y, 0, scaleX, scaleY)
		
		if self.resetPostDraw then
			local list = self.updatedSprites
			
			for k, spriteID in ipairs(list) do
				sb:set(spriteID, 0, 0, 0, 0, 0)
				
				list[k] = nil
			end
		end
		
		self:postDrawCallback()
		
		if self.visibility == 0 then
			self.active = false
		end
		
		return true
	end
	
	self:postDrawCallback()
	
	return false
end

function controlledSpriteBatch:increaseVisibility()
	if self.visibility == 0 then
		priorityRenderer:add(self, self.depth)
	end
	
	self.visibility = self.visibility + 1
end

function controlledSpriteBatch:decreaseVisibility()
	self.visibility = self.visibility - 1
	
	if self.visibility < 0 then
		assert(false, "spritebatch visibility below 0")
	end
	
	if self.visibility == 0 then
		priorityRenderer:remove(self)
	end
end

function controlledSpriteBatch:getVisibility()
	return self.visibility
end

function controlledSpriteBatch:getSpritebatch()
	return self.spriteBatch
end

function controlledSpriteBatch:markAsActive()
	self.active = true
end

function controlledSpriteBatch:setAlwaysActive(state)
	self.alwaysActive = state
end

function controlledSpriteBatch:setDrawCallback(callback)
	self.drawCallback = callback or controlledSpriteBatch.defaultDrawCallback
end

function controlledSpriteBatch:setPostDrawCallback(callback)
	self.postDrawCallback = callback
end

function controlledSpriteBatch:setVisible(state)
	if state and not self.visible then
		self:show()
	elseif not state and self.visible then
		self:hide()
	end
end

function controlledSpriteBatch:show()
	if not self.visible then
		spriteBatchController:addToRenderOrder(self)
	end
	
	self.visible = true
end

function controlledSpriteBatch:hide()
	if self.visible then
		spriteBatchController:removeFromRenderOrder(self)
	end
	
	self.visible = false
end

function controlledSpriteBatch:setColor(r, g, b, a)
	self.r, self.g, self.b, self.a = r, g, b, a
end

function controlledSpriteBatch:resetColor()
	self.r, self.g, self.b, self.a = 255, 255, 255, 255
end

function controlledSpriteBatch:remove()
	self.spriteBatch = nil
	self.batchID = nil
	self.image = nil
	self.imageObj = nil
	self.spriteBatch = nil
	self.freeSlots = nil
	self.usedSlots = nil
	self.filledSlots = nil
	self.depth = nil
	self.size = nil
	self.active = nil
	self.resetPostDraw = nil
	self.fillWhenNecessary = nil
	
	priorityRenderer:remove(self)
end

local function sortByDepth(a, b)
	return b < a
end

function controlledSpriteBatch:_allocateSlot()
	local freeSlotCount = #self.freeSlots
	
	if freeSlotCount > 0 then
		local desiredSlot = self.freeSlots[freeSlotCount]
		
		self.usedSlots[desiredSlot] = true
		self.freeSlots[freeSlotCount] = nil
		
		if desiredSlot >= self.filledSlots then
			self.spriteBatch:add(0, 0, 0, 0, 0)
			
			self.filledSlots = self.filledSlots + 1
		end
		
		return desiredSlot, self.spriteBatch
	end
	
	self.size = self.size + 1
	self.filledSlots = self.filledSlots + 1
	self.usedSlots[self.size] = true
	
	self.spriteBatch:setBufferSize(self.spriteBatch:getBufferSize() + 1)
	self.spriteBatch:add(0, 0, 0, 0, 0)
	
	return self.size, self.spriteBatch
end

function controlledSpriteBatch:allocateSlotWithSorting()
	if self.requiresSorting then
		table.sortl(self.freeSlots, sortByDepth)
		
		self.requiresSorting = false
	end
	
	return self:_allocateSlot()
end

controlledSpriteBatch.allocateSlotWithoutSorting = controlledSpriteBatch._allocateSlot
controlledSpriteBatch.allocateSlot = controlledSpriteBatch.allocateSlotWithSorting

local dummyQuad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)

function controlledSpriteBatch:deallocateSlot(slot)
	if self.usedSlots[slot] then
		self.freeSlots[#self.freeSlots + 1] = slot
		self.usedSlots[slot] = false
		self.requiresSorting = true
		
		local buffer = self.queuedSpriteUpdatesMap[slot] or self:retrieveUpdateBuffer()
		
		self:resetBuffer(buffer)
		
		buffer.quad = dummyQuad
		buffer.x = 0
		buffer.y = 0
		buffer.rot = 0
		buffer.sx = 0
		buffer.sy = 0
		buffer.r = 255
		buffer.g = 255
		buffer.b = 255
		buffer.a = 0
		
		if not self.queuedSpriteUpdatesMap[slot] then
			self.queuedSpriteUpdates[#self.queuedSpriteUpdates + 1] = slot
			self.queuedSpriteUpdatesMap[slot] = buffer
		end
		
		return true
	else
		return false
	end
end

function controlledSpriteBatch:getAllocatedSlot(spriteID)
	return self.usedSlots[spriteID]
end

function controlledSpriteBatch:getDepth()
	return self.depth
end

function controlledSpriteBatch:getID()
	return self.batchID
end

function controlledSpriteBatch:updateSprite(slot, quad, x, y, r, sx, sy, ox, oy)
	self.active = true
	
	if not self.queuedSpriteUpdatesMap[slot] then
		local buffer = self:retrieveUpdateBuffer()
		
		buffer.quad = quad
		buffer.x = x
		buffer.y = y
		buffer.rot = r
		buffer.sx = sx
		buffer.sy = sy
		buffer.ox = ox
		buffer.oy = oy
		buffer.r, buffer.g, buffer.b, buffer.a = self.r, self.g, self.b, self.a
		
		local list = self.queuedSpriteUpdates
		
		list[#list + 1] = slot
		self.queuedSpriteUpdatesMap[slot] = buffer
	else
		local buffer = self.queuedSpriteUpdatesMap[slot]
		
		buffer.quad = quad
		buffer.x = x
		buffer.y = y
		buffer.rot = r
		buffer.sx = sx
		buffer.sy = sy
		buffer.ox = ox
		buffer.oy = oy
		buffer.r, buffer.g, buffer.b, buffer.a = self.r, self.g, self.b, self.a
	end
	
	if self.resetPostDraw then
		self.updatedSprites[#self.updatedSprites + 1] = slot
	end
end

function controlledSpriteBatch:setSprite(desiredSlot, quad, x, y, r, sx, sy, ox, oy)
	if not desiredSlot or not self.usedSlots[desiredSlot] then
		desiredSlot = self:allocateSlot()
	end
	
	self:updateSprite(desiredSlot, quad, x, y, r, sx, sy, ox, oy)
	
	return desiredSlot
end

function controlledSpriteBatch:remove()
	self.spriteBatch = nil
	self.freeSlots = nil
	self.usedSlots = nil
	
	self:_resetSpriteData()
	
	self.updatedSprites = nil
end

function controlledSpriteBatch:_resetSpriteData()
	if self.updatedSprites then
		table.clearArray(self.updatedSprites)
	end
	
	for key, value in ipairs(self.queuedSpriteUpdates) do
		self.queuedSpriteUpdatesMap[value] = nil
		self.queuedSpriteUpdates[key] = nil
	end
end

function controlledSpriteBatch:resetContainer()
	self.filledSlots = self.fillWhenNecessary and 0 or self.size
	
	local spriteBatch = self.spriteBatch
	
	for i = 1, spriteBatch:getBufferSize() do
		self.freeSlots[i] = self.size - i + 1
		self.usedSlots[i] = nil
		
		spriteBatch:set(i, 0, 0, 0, 0, 0)
	end
	
	self:_resetSpriteData()
	
	self.requiresSorting = true
	self.active = false
	self.visibility = 0
end

function controlledSpriteBatch:hideSprite(slot)
	local buffer = self.queuedSpriteUpdatesMap[slot] or self:retrieveUpdateBuffer()
	
	self:resetBuffer(buffer)
	
	buffer.quad = dummyQuad
	buffer.x = 0
	buffer.y = 0
	buffer.rot = 0
	buffer.sx = 0
	buffer.sy = 0
	buffer.r = 255
	buffer.g = 255
	buffer.b = 255
	buffer.a = 0
	
	if not self.queuedSpriteUpdatesMap[slot] then
		self.queuedSpriteUpdates[#self.queuedSpriteUpdates + 1] = slot
		self.queuedSpriteUpdatesMap[slot] = buffer
	end
end

function spriteBatchController:newSpriteBatch(batchID, image, size, usageHint, depth, resetPostDraw, fillWhenNecessary, alwaysActive, skipPriorityRendererAdd)
	local imageFile
	
	if type(image) == "string" then
		imageFile = cache.getImage(image)
	else
		imageFile = image
	end
	
	if self.spriteBatches[batchID] then
		return self.spriteBatches[batchID]
	end
	
	size = size or self.defaultSize
	usageHint = usageHint or self.defaultUsageHint
	depth = depth or self.defaultDepth
	
	if resetPostDraw == nil then
		resetPostDraw = self.defaultResetPostDraw
	end
	
	if fillWhenNecessary == nil then
		fillWhenNecessary = self.defaultFillWhenNecessary
	end
	
	if alwaysActive == nil then
		alwaysActive = self.defaultAlwaysActive
	end
	
	local spriteBatch = love.graphics.newSpriteBatch(imageFile, size, usageHint)
	local freeSlots = {}
	local usedSlots = {}
	local filledSlots = fillWhenNecessary and 0 or size
	
	if not fillWhenNecessary then
		for i = 1, size do
			freeSlots[#freeSlots + 1] = size - i + 1
			
			spriteBatch:add(0, 0, 0, 0, 0)
		end
	else
		for i = 1, size do
			freeSlots[#freeSlots + 1] = size - i + 1
		end
	end
	
	local container = {
		resetPostDraw = false,
		active = false,
		batchID = batchID,
		image = image,
		imageObj = imageFile,
		spriteBatch = spriteBatch,
		freeSlots = freeSlots,
		usedSlots = usedSlots,
		filledSlots = filledSlots,
		depth = depth,
		size = size,
		fillWhenNecessary = fillWhenNecessary
	}
	
	if resetPostDraw then
		container.updatedSprites = {}
		container.resetPostDraw = true
	end
	
	self.spriteBatches[batchID] = container
	
	setmetatable(container, controlledSpriteBatch.mtindex)
	container:init()
	container:setAlwaysActive(alwaysActive)
	
	if not skipPriorityRendererAdd then
		priorityRenderer:add(container, depth)
	end
	
	return container
end

function spriteBatchController:removeSpriteBatch(batchID)
	local container = self.spriteBatches[batchID]
	
	priorityRenderer:remove(container)
	container:remove()
	
	self.spriteBatches[batchID] = nil
end

function spriteBatchController:removeSpriteBatchObject(obj)
	priorityRenderer:remove(obj)
	obj:remove()
	
	self.spriteBatches[obj.batchID] = nil
end

function spriteBatchController:getContainer(batchID)
	return self.spriteBatches[batchID]
end

function spriteBatchController:getContainerTexture(batchID)
	return self.spriteBatches[batchID].spriteBatch:getTexture()
end

function spriteBatchController:allocateSlot(batchID, depth)
	if not batchID then
		return nil, nil
	end
	
	local container = self.spriteBatches[batchID]
	
	if not container then
		spriteBatchController:newSpriteBatch(batchID, batchID, nil, nil, depth)
		
		return self:allocateSlot(batchID)
	end
	
	return container:allocateSlot()
end

spriteBatchController.reserveSlot = spriteBatchController.allocateSlot
spriteBatchController.allocateSprite = spriteBatchController.allocateSlot
spriteBatchController.reserveSprite = spriteBatchController.reserveSprite

function spriteBatchController:deallocateSlot(batchID, slot)
	if not batchID then
		return nil
	end
	
	local container = self.spriteBatches[batchID]
	
	if container then
		return container:deallocateSlot(slot)
	else
		return false
	end
end

spriteBatchController.freeSlot = spriteBatchController.deallocateSlot
spriteBatchController.freeSprite = spriteBatchController.deallocateSlot
spriteBatchController.releaseSlot = spriteBatchController.deallocateSlot
spriteBatchController.releaseSprite = spriteBatchController.deallocateSlot
spriteBatchController.deallocateSprite = spriteBatchController.deallocateSlot

function spriteBatchController:resetContainer(container)
	container:resetContainer()
end

function spriteBatchController:pseudoClearAll()
	for key, value in pairs(self.spriteBatches) do
		self:resetContainer(value)
	end
end

function spriteBatchController:markAsActive(batchID)
	local container = self.spriteBatches[batchID]
	
	if container then
		container.active = true
	end
end

function spriteBatchController:setColor(batchID, r, g, b, a)
	local container = self.spriteBatches[batchID]
	
	container:setColor(r, g, b, a)
end

function spriteBatchController:updateSprite(batchID, slot, quad, x, y, r, sx, sy, ox, oy)
	local container = self.spriteBatches[batchID]
	
	container:updateSprite(slot, quad, x, y, r, sx, sy, ox, oy)
end

function spriteBatchController:clearSprite(batchID, slot)
	local container = self.spriteBatches[batchID]
	
	if container then
		local spriteBatch = container.spriteBatch
		
		spriteBatch:set(slot, 0, 0, 0, 0, 0)
	end
end

function spriteBatchController:addToRenderOrder(container)
	table.insert(self.renderOrder, container)
	table.sortl(self.renderOrder, sortByDepth_Ascending)
end

function spriteBatchController:removeFromRenderOrder(container)
	for key, otherContainer in ipairs(self.renderOrder) do
		if otherContainer == container then
			table.remove(self.renderOrder, key)
			
			return true
		end
	end
	
	return false
end

function spriteBatchController:draw()
	for key, container in ipairs(self.renderOrder) do
		self:_draw(container)
	end
end

function spriteBatchController:_draw(container)
	container:draw()
end

function spriteBatchController:manualDraw(batchID)
	local container = self.spriteBatches[batchID]
	
	if not container then
		return 
	end
	
	self:_draw(container)
end
