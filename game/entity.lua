entity = {}
entity.mtindex = {
	__index = entity
}
entity.width = 0
entity.height = 0
entity.WORLD_OBJECT = true

function entity:init()
	self.propSprites = {}
	self.x = 0
	self.y = 0
	self._isValid = true
	self.castingLight = true
end

function entity:getClass()
	return self.class
end

function entity:onRegister()
end

function entity:setTileGrid(grid)
	self.tileGrid = grid
end

function entity:getLightColor()
	return self.lightColor
end

function entity:enableLightCasting()
	local wasCast = self.castingLight
	
	if self.lightCaster then
		self.castingLight = true
		
		if self.lightInitialized then
			if not wasCast then
				lightingManager:enableLightCaster(self)
			end
		else
			lightingManager:initializeLightCaster(self)
			
			self.lightInitialized = true
		end
	else
		print("attempt cast light of nil class for", self.class)
	end
end

function entity:disableLightCasting(removal)
	if self.lightCaster and self.lightInitialized then
		local wasCast = self.castingLight
		
		if removal then
			lightingManager:removeLightCaster(self)
		elseif wasCast and not studio._blockLightBuild then
			self.castingLight = false
			
			lightingManager:disableLightCaster(self)
		end
	end
end

function entity:getRoom()
	return self.room
end

function entity:setRoom(roomObject)
	if roomObject then
		if self.room ~= roomObject then
			self:onRoomChanged(roomObject)
		else
			self:onRoomSet()
		end
	end
	
	self.room = roomObject
end

function entity:onRoomSet()
end

function entity:onRoomChanged()
end

function entity:preDrawExpansion(startX, startY, endX, endY)
end

function entity:postDrawExpansion(startX, startY, endX, endY)
end

function entity:onEmployeeEntered(employee)
end

function entity:onEmployeeLeft(employee)
end

function entity:dummyCastLight()
end

function entity:castLight(imageData, pixelX, pixelY)
end

function entity:drawOutline()
end

function entity:setupOutline()
end

function entity:resetOutline()
end

function entity:canDrawOutline()
	return true
end

function entity:getTileCoordinates()
	return game.worldObject:getObjectGrid():worldToGrid(self.x, self.y)
end

function entity:getTileIndex()
	local grid = game.worldObject:getObjectGrid()
	
	return grid:getTileIndex(grid:worldToGrid(self.x, self.y))
end

function entity:getMidTileCoordinates()
	return game.worldObject:getObjectGrid():worldToGrid(self:getCenter())
end

function entity:clearSoundReferences()
	if self.activeSounds then
		local iteration = 1
		
		for key, soundContainer in ipairs(self.activeSounds) do
			if not soundContainer.soundObj:isPlaying() then
				table.remove(self.activeSounds, iteration)
			else
				iteration = iteration + 1
			end
		end
	end
end

function entity:playSound(soundName, middle)
	local x, y = self.x, self.y
	
	if middle then
		x, y = self:getCenter()
	end
	
	local soundContainer = sound:play(soundName, nil, x, y)
	
	self.activeSounds = self.activeSounds or {}
	
	table.insert(self.activeSounds, soundContainer)
end

function entity:setPos(x, y)
	self.x = x or self.x
	self.y = y or self.y
	
	if self.lightInitialized then
		lightingManager:updateLightCaster(self)
	end
end

function entity:getPos()
	return self.x, self.y
end

entity.getPosition = entity.getPos

function entity:getDrawColor()
	return 255, 255, 255, 255
end

function entity:setSize(w, h)
	self.width = w
	self.height = h
end

function entity:getSize()
	return self.width, self.height
end

function entity:getBoundingBox()
	return self.x, self.y, self.width, self.height
end

function entity:getMouseBoundingBox()
	return self.x, self.y, self.width, self.height
end

function entity:getMouseOverBounds()
	return self.x, self.y, self.width, self.height
end

function entity:getHalfSize()
	return self.width / 2, self.height / 2
end

function entity:onMouseOver()
end

function entity:onMouseLeft()
end

function entity:drawMouseOver()
end

function entity:draw()
end

function entity:postDraw()
end

function entity:getPropAngles()
	return 0
end

function entity:addProp(propType, spritebatchName, quad, x, y, rotation, offsetX, offsetY, scaleX, scaleY)
	if self.propSprites[propType] then
		self:showProp(self.propSprites[propType])
		
		return 
	end
	
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	rotation = rotation or 0
	
	local container = spriteBatchController:getContainer(spritebatchName)
	local propData = {
		spritebatchName = spritebatchName,
		quad = quad,
		container = container,
		x = x,
		y = y,
		baseRot = rotation,
		rotation = self:getPropAngles() + rotation,
		scaleX = scaleX,
		scaleY = scaleY,
		offsetX = offsetX,
		offsetY = offsetY
	}
	
	self.propSprites[propType] = propData
	
	if self.visible then
		self:showProp(propData)
	end
end

function entity:updatePropAngles()
	for key, data in pairs(self.propSprites) do
		data.rotation = data.baseRot + self:getPropAngles()
	end
end

function entity:showProps()
	if self.propSprites then
		for propType, propData in pairs(self.propSprites) do
			self:showProp(propData)
		end
	end
end

function entity:hideProps()
	if self.propSprites then
		for propType, propData in pairs(self.propSprites) do
			self:hideProp(propType)
		end
	end
end

function entity:getProp(type)
	return self.propSprites[type]
end

function entity:getDrawPosition()
	return self.x, self.y
end

function entity:showProp(propData)
	local container = propData.container
	
	if not propData.spriteID then
		propData.spriteID = container:allocateSlot()
		
		container:increaseVisibility()
	end
	
	local x, y = self:getDrawPosition()
	
	container:setColor(255, 255, 255, 255)
	container:updateSprite(propData.spriteID, propData.quad, x, y, propData.rotation, propData.scaleX, propData.scaleY, propData.offsetX, propData.offsetY)
end

function entity:drawProp(type, x, y, rot, scaleX, scaleY, offsetX, offsetY)
	local propData = self.propSprites[type]
	local container = propData.container
	
	container:setColor(255, 255, 255, 255)
	container:updateSprite(propData.spriteID, propData.quad, x, y, rot, scaleX, scaleY, offsetX, offsetY)
end

function entity:makePropInvis(type)
	local propData = self.propSprites[type]
	local container = propData.container
	
	container:setColor(255, 255, 255, 0)
	container:updateSprite(propData.spriteID, propData.quad, 0, 0, 0, 0, 0)
end

function entity:allocatePropSprite(propData)
	propData.spriteID = propData.spriteID or spriteBatchController:allocateSlot(propData.spritebatchName)
end

function entity:hideProp(propType)
	local data = self.propSprites[propType]
	
	if data and data.spriteID then
		local container = data.container
		
		container:deallocateSlot(data.spriteID)
		container:decreaseVisibility()
		
		data.spriteID = nil
	end
end

function entity:removeProp(propType)
	local data = self.propSprites[propType]
	
	if data then
		if data.spriteID then
			local container = data.container
			
			container:deallocateSlot(data.spriteID)
			container:decreaseVisibility()
			
			data.spriteID = nil
		end
		
		self.propSprites[propType] = nil
	end
end

function entity:clearPropSprites()
	for propType, propData in pairs(self.propSprites) do
		if propData.spriteID then
			local container = propData.container
			
			container:deallocateSlot(propData.spriteID)
			container:decreaseVisibility()
			
			propData.spriteID = nil
		end
	end
end

function entity:enterVisibilityRange()
	self:showProps()
end

function entity:leaveVisibilityRange()
	self:clearPropSprites()
end

function entity:canDrawMouseOver()
	return not frameController:preventsMouseOver()
end

function entity:isMouseOver()
	local mouseX, mouseY = camera:mousePosition()
	local worldW, worldH = game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT
	local x, y, w, h = self:getMouseBoundingBox()
	local distX, distY = w - worldW, h - worldH
	
	if mouseX < x - worldW or mouseX > x + distX or mouseY < y - worldH or mouseY > y + distY then
		return false
	end
	
	return true
end

function entity:remove()
	self._isValid = false
	
	self:clearPropSprites()
	
	if self.activeSounds then
		for key, soundContainer in ipairs(self.activeSounds) do
			soundContainer:remove()
			
			self.activeSounds[key] = nil
		end
	end
end

function entity:isValid()
	return self._isValid
end

function entity:getCenter()
	return self.x + self.width * 0.5, self.y + self.height * 0.5
end

function entity:getCenterX()
	return self.x + self.width * 0.5
end

function entity:getCenterY()
	return self.y + self.height * 0.5
end

function entity:getLeft()
	return self.x
end

function entity:getRight()
	return self.x + self.width
end

function entity:getTop()
	return self.y
end

function entity:getBottom()
	return self.y + self.height
end
