frameBuffer = {}
frameBuffer.mtindex = {
	__index = frameBuffer
}
frameBuffer.xScale = 1
frameBuffer.yScale = 1

function frameBuffer.drawCallback()
	return false
end

function frameBuffer.new(w, h, priority, format, skipAdd)
	local new = {}
	
	setmetatable(new, frameBuffer.mtindex)
	new:init(w, h, priority, format, skipAdd)
	
	return new
end

function frameBuffer:init(w, h, priority, format, skipAdd)
	w = w or love.graphics.getWidth()
	h = h or love.graphics.getHeight()
	
	if priority ~= false then
		priority = priority or 1
	end
	
	self.priority = priority
	self.buffer = love.graphics.newCanvas(w, h, format)
	
	if priority and not skipAdd then
		priorityRenderer:add(self, priority)
	end
end

function frameBuffer:getPriority()
	return self.priority
end

function frameBuffer:getBuffer()
	return self.buffer
end

function frameBuffer:setDrawPosition(x, y)
	self.drawX, self.drawY = x, y
end

function frameBuffer:setDrawScale(x, y)
	self.xScale = x
	self.yScale = y
end

function frameBuffer:setShader(shader)
	self.shader = shader
end

function frameBuffer:getShader()
	return self.shader
end

function frameBuffer:setDrawCallback(callback)
	self.drawCallback = callback
end

function frameBuffer:draw()
	local x = self.drawX or camera.x
	local y = self.drawY or camera.y
	
	if not self:drawCallback(x, y) then
		love.graphics.setShader(self.shader)
		love.graphics.draw(self.buffer, x, y, 0, self.xScale, self.yScale)
		love.graphics.setShader()
	end
end
