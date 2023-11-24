local progressBarWithText = {}

progressBarWithText.barXOffset = 3
progressBarWithText.barYOffset = 3
progressBarWithText.textVerticalOffset = 1
progressBarWithText.skinPanelFillColor = color(86, 104, 135, 255)
progressBarWithText.skinPanelHoverColor = color(150, 163, 183, 255)
progressBarWithText.skinPanelDisableColor = color(69, 84, 112, 255)
progressBarWithText.progressBarUnderColor = color(47, 57, 73, 255)
progressBarWithText.progressBarUnderHoverColor = color(66, 80, 102, 255)
progressBarWithText.progressBarColor = color(132, 160, 206, 255)
progressBarWithText.progressBarHoverColor = color(157, 189, 242, 255)
progressBarWithText.text = "text not set"

function progressBarWithText:init()
end

function progressBarWithText:initVisual()
	self:setFont("pix20")
end

function progressBarWithText:setFont(font)
	self.font = fonts.get(font)
	self.fontHeight = self.font:getHeight()
	self.unscaledFontHeight = _US(self.fontHeight)
end

function progressBarWithText:setText(text)
	self.text = text
end

function progressBarWithText:setProgress(progress)
	self.progress = progress
	
	self:queueSpriteUpdate()
end

function progressBarWithText:getProgress()
	return self.progress or 1
end

function progressBarWithText:getBarColor()
	return self:isMouseOver() and self.progressBarHoverColor or self.progressBarColor
end

function progressBarWithText:setIcon(icon, width, height)
	self.icon = icon
	self.iconWidth = width
	self.iconHeight = height
	
	self:queueSpriteUpdate()
end

function progressBarWithText:updateSprites()
	local pCol, tCol = self:getStateColor()
	local poutline = self:getPanelOutlineColor()
	
	self:setNextSpriteColor(poutline:unpack())
	
	self.outlineSprite = self:allocateSprite(self.outlineSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.5)
	
	if self.icon then
		self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, _S(3), _S(3), 0, self.iconWidth, self.iconHeight, 0, 0, -0.5)
	end
	
	local scaledOffsetX, scaledOffsetY = _S(self.barXOffset), _S(self.barYOffset)
	local scaledTextVertOffset = _S(self.textVerticalOffset)
	local barHeight = self.rawH - self.textVerticalOffset - self.unscaledFontHeight - self.barYOffset * 2
	local underColor
	local overColor = self:getBarColor()
	
	if self:isMouseOver() then
		underColor = self.progressBarUnderHoverColor
	else
		underColor = self.progressBarUnderColor
	end
	
	local progressScale = self:getProgress()
	
	self:setNextSpriteColor(underColor:unpack())
	
	self.progressBarUnderSprite = self:allocateSprite(self.progressBarUnderSprite, "vertical_gradient_75", scaledOffsetX, scaledOffsetY + self.fontHeight, 0, self.rawW - self.barXOffset * 2, barHeight, 0, 0, -0.45)
	
	self:setNextSpriteColor(overColor:unpack())
	
	self.progressBarSprite = self:allocateSprite(self.progressBarSprite, "vertical_gradient_75", scaledOffsetX, scaledOffsetY + self.fontHeight, 0, (self.rawW - self.barXOffset * 2) * progressScale, barHeight, 0, 0, -0.44)
end

function progressBarWithText:onMouseEntered()
	self:queueSpriteUpdate()
end

function progressBarWithText:onMouseLeft()
	self:queueSpriteUpdate()
end

function progressBarWithText:getTextColor()
	return select(2, self:getStateColor())
end

function progressBarWithText:draw(w, h)
	local tCol = self:getTextColor()
	
	love.graphics.setFont(self.font)
	
	local x = _S(3)
	
	if self.icon then
		x = x + _S(self.iconWidth + 3)
	end
	
	love.graphics.printST(self.text, x, _S(self.textVerticalOffset), tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
end

gui.register("ProgressBarWithText", progressBarWithText)
