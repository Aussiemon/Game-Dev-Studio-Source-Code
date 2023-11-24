local volumeSlider = {}

volumeSlider.switchToMinValueOnBoundsChanged = false
volumeSlider.skinPanelFillColor = game.UI_COLORS.NEW_HUD_FILL_3
volumeSlider.skinPanelHoverColor = game.UI_COLORS.NEW_HUD_HOVER
volumeSlider.skinPanelDisableColor = color(48, 59, 76, 255)

function volumeSlider:clickCallback(value)
	sound:setVolumeLevel(self.volumeType, value)
end

function volumeSlider:postInit()
	self:setFont("pix22")
	self:setDisplayPercentage(true)
	self:setRounding(3)
	self:setMinMax(0, 1)
	self:setSliderOffset(10, 4)
	self:setValue(sound:getVolumeLevel(self.volumeType))
end

function volumeSlider:setVolumeType(type)
	self.volumeType = type
end

function volumeSlider:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.2)
	
	self:setNextSpriteColor(self:getStateColor():unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.19)
	
	local minMaxDist = self:getProgressToMax()
	local displayPercentage = math.min(math.max((self.value - self.minValue) / minMaxDist, 0), 1)
	local textY = self.textHeight + _S(5)
	local scaledSliderOffX = _S(self.sliderOffX)
	local scaledSliderOffY = _S(self.sliderOffY)
	local scaledTwo = _S(2)
	
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.bottomSliderSprite = self:allocateSprite(self.bottomSliderSprite, "generic_1px", scaledSliderOffX, textY, 0, self.rawW - self.sliderOffX * 2, self.rawH - _US(textY) - self.sliderOffY, 0, 0, -0.1)
	
	self:setNextSpriteColor(81, 102, 119, 255)
	
	self.middleSliderSprite = self:allocateSprite(self.middleSliderSprite, "generic_1px", scaledTwo + scaledSliderOffX, textY + _S(1), 0, self.rawW - self.sliderOffX * 2 - 4, self.rawH - _US(textY) - self.sliderOffY - 2, 0, 0, -0.1)
	
	self:setNextSpriteColor(147, 183, 216, 255)
	
	self.sliderSprite = self:allocateSprite(self.sliderSprite, "vertical_gradient_75", scaledTwo + scaledSliderOffX, textY + _S(1), 0, (self.rawW - self.sliderOffX * 2 - 4) * displayPercentage, self.rawH - _US(textY) - self.sliderOffY - 2, 0, 0, -0.1)
end

function volumeSlider:onSetValue()
	self:queueSpriteUpdate()
end

function volumeSlider:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self:getTextX(), self:getTextY())
end

gui.register("VolumeAdjustmentSlider", volumeSlider, "Slider")
