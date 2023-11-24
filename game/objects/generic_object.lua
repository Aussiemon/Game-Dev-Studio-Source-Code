local genericObject = {}

genericObject.class = "generic_object"
genericObject.tileWidth = 1
genericObject.tileHeight = 1

function genericObject:init()
	genericObject.baseClass.init(self)
	self:setupSpritebatches()
end

function genericObject:getTextureQuad()
	return self.quad
end

function genericObject:getDrawAngles(rotation)
	return 0
end

function genericObject:getDirectionalOffset()
	return self.xDirectionalOffset, self.yDirectionalOffset
end

function genericObject:getDrawPosition(x, y, quad, rotation, xDirectionalOffset, yDirectionalOffset)
	local x = x or self.x
	local x, y = x, y or self.y
	local quadStruct = quadLoader:getQuadObjectStructure(quad or self:getTextureQuad())
	local w, h = quadStruct.w, quadStruct.h
	
	rotation = rotation or self.rotation
	
	local baseRotation = self:getDrawAngles(rotation)
	local radians = math.rad(baseRotation)
	local width, height = game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT
	local tileW, tileH = self.tileWidth - 1, self.tileHeight - 1
	
	if rotation == walls.LEFT or rotation == walls.RIGHT then
		tileW, tileH = tileH, tileW
	end
	
	tileW, tileH = tileW * width, tileH * height
	
	local xOff, yOff = self:getDirectionalOffset()
	
	xDirectionalOffset = xDirectionalOffset or xOff
	yDirectionalOffset = yDirectionalOffset or yOff
	x = x + tileW * 0.5 - width * 0.5 + self.xOffset + math.sin(radians) * xDirectionalOffset
	y = y + tileH * 0.5 - height * 0.5 + self.yOffset + math.cos(radians) * yDirectionalOffset
	
	return x, y, w, h, math.rad(baseRotation + self.addRotation)
end

function genericObject:enterVisibilityRange()
	entity.enterVisibilityRange(self)
	
	local wasVisible = self.visible
	
	self.visible = true
	
	if not wasVisible then
		self:increaseVisibility()
		self:updateSprite()
	end
end

function genericObject:leaveVisibilityRange()
	entity.leaveVisibilityRange(self)
	
	local wasVisible = self.visible
	
	self.visible = false
	
	if wasVisible then
		self:decreaseVisibility()
	end
	
	self:clearSprite()
end

function genericObject:increaseVisibility()
	for key, sb in ipairs(self.spriteBatches) do
		if sb:getVisibility() == 0 then
			shadowShader:addRenderableSpriteBatch(sb)
			buildingShadows:addRenderableSpriteBatch(sb)
		end
		
		sb:increaseVisibility()
	end
end

function genericObject:decreaseVisibility()
	for key, sb in ipairs(self.spriteBatches) do
		local vis = sb:getVisibility()
		
		sb:decreaseVisibility()
		
		if sb:getVisibility() == 0 then
			shadowShader:removeRenderableSpriteBatch(sb)
			buildingShadows:removeRenderableSpriteBatch(sb)
		end
	end
end

function genericObject:setupSpritebatches()
	self.spriteBatch = spriteBatchController:getContainer(self.objectAtlas)
	self.atlasTexture = self.spriteBatch:getTexture()
	
	self:_setupSpritebatches()
end

function genericObject:_setupSpritebatches()
	if not self.spriteBatches then
		self.spriteBatches = {}
		
		self:referenceSpritebatches()
	end
end

function genericObject:referenceSpritebatches()
	table.insert(self.spriteBatches, self.spriteBatch)
end

function genericObject:getScale()
	return self.scaleX, self.scaleY
end

function genericObject:updateSprite()
	if self.visible then
		local x, y, xOff, yOff, rotation = self:getDrawPosition()
		
		self.spriteID = self.spriteID or self.spriteBatch:allocateSlot()
		
		local scaleX, scaleY = self:getScale()
		
		self.spriteBatch:setColor(self:getDrawColor())
		self.spriteBatch:updateSprite(self.spriteID, self:getTextureQuad(), math.round(x), math.round(y), rotation, scaleX, scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
	end
end

function genericObject:clearSprite()
	if self.spriteID then
		self.spriteBatch:deallocateSlot(self.spriteID)
		
		self.spriteID = nil
	end
end

function genericObject:remove()
	genericObject.baseClass.remove(self)
	self:leaveVisibilityRange()
end

function genericObject:save()
	local saved = {}
	
	saved.x = self.x
	saved.y = self.y
	saved.class = self.class
	saved.rotation = self.rotation
	
	return saved
end

objects.registerNew(genericObject)
