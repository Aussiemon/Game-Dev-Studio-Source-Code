local checkbox = {}

checkbox.boxOutlineColor = color(40, 40, 40, 255)
checkbox.boxColor = color(80, 80, 80, 255)
checkbox.font = "pix20"
checkbox.text = nil
checkbox.labelHorizontalPad = 5
checkbox.horizontalAlignment = gui.SIDES.RIGHT
checkbox.verticalAlignment = gui.SIDES.BOTTOM

function checkbox:isDisabledFunc()
	return false
end

function checkbox:isOnFunc()
	return false
end

function checkbox:init()
	self:setFont(checkbox.font)
end

function checkbox:setCheckCallback(callback)
	self.checkCallback = callback
end

function checkbox:setIsOnFunction(func)
	self.isOnFunc = func
end

function checkbox:setIsDisabledFunction(func)
	self.isDisabledFunc = func
end

function checkbox:isOn()
	return self:isOnFunc()
end

function checkbox:isDisabled()
	return self:isDisabledFunc()
end

function checkbox:onClick()
	if self:isDisabled() then
		return 
	end
	
	self:checkCallback()
	self:queueSpriteUpdate()
end

function checkbox:getLabel()
	return self.label
end

function checkbox:setText(text)
	self.text = text
	self.label = self.label or gui.create("Label", self)
	
	self:updateLabel()
end

function checkbox:onKill()
	if self.label then
		self.label:kill()
		
		self.label = nil
	end
end

function checkbox:setTextAlignment(horizontal, vertical)
	self.horizontalAlignment = horizontal or self.horizontalAlignment
	self.verticalAlignment = vertical or self.verticalAlignment
end

function checkbox:setFont(font)
	self.font = font
	
	self:updateLabel()
	self:updateFontObject()
end

function checkbox:updateFontObject()
	self.fontObject = fonts.get(self.font)
end

function checkbox:performLayout()
	self:updateLabel()
end

function checkbox:updateLabel()
	if self.label then
		self.label:setFont(fonts.get(self.font))
		self.label:setText(self.text)
		self:updateLabelPosition()
	end
end

function checkbox:updateLabelPosition()
	if self.label then
		local newX, newY = 0, 0
		
		if self.horizontalAlignment == gui.SIDES.LEFT then
			newX = -_S(self.labelHorizontalPad) - self.label:getWidth()
		else
			newX = newX + _S(self.labelHorizontalPad) + self.w
		end
		
		newY = newY + (self.h * 0.5 - self.label:getHeight() * 0.5)
		
		self.label:setPos(newX, newY)
	end
end

function checkbox:setPos(x, y)
	checkbox.baseClass.setPos(self, x, y)
	
	if self.label then
		self:updateLabelPosition()
	end
end

function checkbox:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)
	love.graphics.rectangle("fill", 0, 0, w, h)
	
	local smallest = math.min(w, h)
	local outlineColor = self.boxOutlineColor
	
	love.graphics.setColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
	love.graphics.rectangle("line", _S(1), _S(1), smallest - _S(2), smallest - _S(2))
	
	local boxColor = self.boxColor
	
	love.graphics.setColor(boxColor.r, boxColor.g, boxColor.b, boxColor.a)
	love.graphics.rectangle("fill", _S(3), _S(3), smallest - _S(6), smallest - _S(6))
end

gui.register("Checkbox", checkbox, "Button")
