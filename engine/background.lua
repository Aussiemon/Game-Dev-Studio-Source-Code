background = {}
background.mtindex = {
	__index = background
}

function background.new(texture)
	local new = {}
	
	setmetatable(new, background.mtindex)
	new:init(texture)
	
	return new
end

function background:init(texture)
	if texture then
		self:setTexture(texture)
	end
end

function background:setTexture(texture)
	self.texture = texture
	self.scaleX, self.scaleY = 1, 1
end

function background:draw()
	love.graphics.draw(self.texture, 0, 0, 0, self.scaleX, self.scaleY)
end
