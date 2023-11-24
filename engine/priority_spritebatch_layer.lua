local prioritySpritebatchLayer = {}

prioritySpritebatchLayer.mtindex = {
	__index = prioritySpritebatchLayer
}
prioritySpritebatchLayer.drawColor = color(255, 255, 255, 255)

function prioritySpritebatchLayer:new()
	local new = {}
	
	setmetatable(new, self.mtindex)
	new:init()
	
	return new
end

function prioritySpritebatchLayer:init()
	self.drawColor = prioritySpritebatchLayer.drawColor
end

function prioritySpritebatchLayer:setDrawColor(clr)
	self.drawColor = clr
end

function prioritySpritebatchLayer:setSpriteBatch(batch)
	self.spriteBatch = batch
end

function prioritySpritebatchLayer:draw()
	love.graphics.setColor(self.drawColor:unpack())
	love.graphics.draw(self.spriteBatch, 0, 0)
	love.graphics.setColor(255, 255, 255, 255)
end

return prioritySpritebatchLayer
