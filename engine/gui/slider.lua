local slider = {}

slider.font = fonts.pix14
slider.text = "no text"
slider.curPercentage = 0
slider.rounding = 0
slider.valueMult = 1
slider.centerTextX = true
slider.sliderOffX = 2
slider.sliderOffY = 2
slider.switchToMinValueOnBoundsChanged = true

function slider:init()
	slider.curPercentage = 0
	slider.value = 0
end

function slider:setFont(font)
	self.font = font
	
	self:updateFontObject()
end

function slider:updateFontObject()
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
	
	self:setHeight(math.max(self.rawH, _US(self.fontHeight) + 5))
end

function slider:setDisplayPercentage(state)
	self.displayPercentage = state
end

function slider:setBaseText(baseText)
	self.baseText = baseText
	
	if not self.minValue or not self.maxValue or not self.value then
		return 
	end
	
	self:updateText()
end

function slider:setText(text)
	if not self.baseText then
		self.baseText = text
	end
	
	self.text = text
	self.textHeight = self.fontObject:getHeight()
	self.textWidth = self.fontObject:getWidth(text)
end

function slider:updateText()
	local sliderValue
	
	if self.displayPercentage then
		local minMaxDist = math.dist(self.minValue, self.maxValue)
		local displayPercentage = self.value / minMaxDist
		local newPercentage = math.ceil(displayPercentage * 100)
		
		if self.oldPercentage ~= newPercentage then
			sliderValue = newPercentage
		end
		
		self.oldPercentage = newPercentage
	else
		sliderValue = self.value
	end
	
	self:formatText(sliderValue)
end

function slider:formatText(value)
	if value then
		self:setText(string.easyformatbykeys(self.baseText, "SLIDER_VALUE", value * self.valueMult))
	end
end

function slider:setDisplayValueMultiplier(mult)
	self.valueMult = mult
end

function slider:setRounding(rounding)
	self.rounding = rounding
end

function slider:setSegmentRound(segment)
	self.segmentRound = segment
end

function slider:getProgressToMax()
	return math.dist(self.minValue, self.maxValue)
end

function slider:getSliderMousePercentage(mouseX)
	return (mouseX - _S(self.sliderOffX)) / (self.w - _S(self.sliderOffX) * 2)
end

function slider:think()
	local minMaxDist = self:getProgressToMax()
	
	if self:isHeldDown() then
		local mouseX, mouseY = self:getRelativePos(love.mouse.getX(), love.mouse.getY())
		
		self:setValue(self:finalizeSliderValue(mouseX))
	end
end

function slider:finalizeSliderValue(mouseX)
	return math.lerp(self.minValue, self.maxValue, self:getSliderMousePercentage(mouseX))
end

function slider:onRelease()
	sound:saveSoundSettings()
end

function slider:setCenterText(horizontal, vertical)
	if horizontal ~= nil then
		self.centerTextX = horizontal
	end
	
	if vertical ~= nil then
		self.centerTextY = vertical
	end
end

function slider:getTextY()
	return self.centerTextY and (self.h - self.fontHeight) * 0.5 or 0
end

function slider:getTextX()
	return self.centerTextX and self.w * 0.5 - self.textWidth * 0.5 or 5
end

function slider:setSliderOffset(x, y)
	self.sliderOffX = x
	self.sliderOffY = y
end

function slider:draw(w, h)
	local minMaxDist = self:getProgressToMax()
	local displayPercentage = math.min(math.max((self.value - self.minValue) / minMaxDist, 0), 1)
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self:getTextX(), self:getTextY())
	love.graphics.setColor(0, 0, 0, 255)
	
	local textY = self.textHeight + _S(5)
	local scaledSliderOffX = _S(self.sliderOffX)
	local scaledSliderOffY = _S(self.sliderOffY)
	local scaledTwo = _S(2)
	
	love.graphics.rectangle("fill", scaledSliderOffX, textY, w - scaledSliderOffX * 2, h - textY - scaledSliderOffY)
	love.graphics.setColor(40, 40, 40, 255)
	love.graphics.rectangle("fill", scaledTwo + scaledSliderOffX, textY + _S(1), w - scaledSliderOffX * 2 - _S(2) * 2, h - textY - scaledSliderOffY - scaledTwo)
	love.graphics.setColor(180, 255, 180, 255)
	love.graphics.rectangle("fill", scaledTwo + scaledSliderOffX, textY + _S(1), (w - scaledSliderOffX * 2 - _S(2) * 2) * displayPercentage, h - textY - scaledSliderOffY - scaledTwo)
end

function slider:setClickCallback(callback)
	self.clickCallback = callback
end

function slider:setMin(min)
	self.minValue = min
	
	self:verifyCurrentValue()
end

function slider:setMax(max)
	self.maxValue = max
	
	self:verifyCurrentValue()
end

function slider:setMinMax(min, max)
	self.minValue = min
	self.maxValue = max
	
	self:verifyCurrentValue()
end

function slider:getPercentageToMax()
	return (self.value - self.minValue) / (self.maxValue - self.minValue)
end

function slider:verifyCurrentValue()
	if self.switchToMinValueOnBoundsChanged and self.minValue and self.maxValue then
		self:setValue(self.minValue)
	end
end

function slider:onSetValue(oldValue)
end

function slider:setValue(value)
	if self.segmentRound then
		value = math.ceil(value / self.segmentRound) * self.segmentRound
	end
	
	local oldvalue = self.value
	
	self.value = math.round(math.clamp(value, self.minValue, self.maxValue), self.rounding)
	
	self:onSetValue(oldvalue)
	
	if self.clickCallback then
		self:clickCallback(self.value)
	end
	
	self:updateText()
end

function slider:getValue(value)
	return self.value
end

gui.register("Slider", slider)
