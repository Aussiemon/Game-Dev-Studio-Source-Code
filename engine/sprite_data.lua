spriteDataContainer = {}
spriteDataContainer.mtindex = {
	__index = spriteDataContainer
}
spriteDataContainer.SPRITE_CONTAINER = true

function spriteDataContainer.new(slot, quad, x, y, rotation, scaleX, scaleY, centerOffsetX, centerOffsetY, depth)
	local new = {}
	
	setmetatable(new, spriteDataContainer.mtindex)
	new:apply(slot, quad, x, y, rotation, scaleX, scaleY, centerOffsetX, centerOffsetY)
	
	return new
end

function spriteDataContainer:apply(slot, quad, x, y, rotation, scaleX, scaleY, centerOffsetX, centerOffsetY, depth)
	self.slot = slot
	self.quad = quad
	self.x = x
	self.y = y
	self.rotation = rotation
	self.scaleX = scaleX
	self.scaleY = scaleY
	self.centerOffsetX = centerOffsetX
	self.centerOffsetY = centerOffsetY
	self.depth = depth
end

function spriteDataContainer:setColor(color)
	self.color = color
end

function spriteDataContainer:getColor()
	return self.color
end

function spriteDataContainer:getQuad()
	return self.quad
end

function spriteDataContainer:getSlot()
	return self.slot
end

function spriteDataContainer:setSpriteBatch(batch)
	self.spriteBatch = batch
end

function spriteDataContainer:getSpriteBatch()
	return self.spriteBatch
end

function spriteDataContainer:unpack()
	return self.slot, self.quad, self.x, self.y, self.rotation, self.scaleX, self.scaleY, self.centerOffsetX, self.centerOffsetY, self.depth
end
