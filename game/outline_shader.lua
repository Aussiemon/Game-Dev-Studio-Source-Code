outlineShader = {}
outlineShader.outColor = {}
outlineShader.defaultOutlineColor = {}
outlineShader.stepSize = {}
outlineShader.RENDER_PRIORITY = 60
outlineShader.OUTLINE_COLOR = {
	192,
	219,
	255
}
outlineShader.CATCHABLE_EVENTS = {
	game.EVENTS.RESOLUTION_CHANGED
}

function outlineShader:setOutlineColor(r, g, b)
	self.outColor[1] = r / 255
	self.outColor[2] = g / 255
	self.outColor[3] = b / 255
	
	shaders.outline:send("outlineColor", self.outColor)
end

function outlineShader:setupThickness(quad)
	if quad == self.lastSendQuad then
		return 
	end
	
	local data = quadLoader:getQuadObjectStructure(quad)
	
	self.stepSize[1] = 1 / data.imgW
	self.stepSize[2] = 1 / data.imgH
	
	shaders.outline:send("stepSize", self.stepSize)
	
	self.lastSendQuad = quad
end

function outlineShader:attemptDisableObject(object)
	if self.drawObject and self.drawObject == object then
		self:setDrawObject(nil)
	end
end

function outlineShader:handleEvent(event)
	outlineShader:setOutlineColor(unpack(outlineShader.OUTLINE_COLOR))
end

function outlineShader:setDrawObject(object)
	if object and object:canDrawOutline() then
		if self.drawObject then
			self.drawObject:resetOutline()
		end
		
		self.drawObject = object
		
		self.drawObject:setupOutline()
		priorityRenderer:add(self, outlineShader.RENDER_PRIORITY)
	else
		if self.drawObject then
			self.drawObject:resetOutline()
			priorityRenderer:remove(self)
		end
		
		self.lastSendQuad = nil
		self.drawObject = nil
	end
end

function outlineShader:draw()
	love.graphics.setShader(shaders.outline)
	self.drawObject:drawOutline()
	love.graphics.setShader()
end

events:addDirectReceiver(outlineShader, outlineShader.CATCHABLE_EVENTS)
