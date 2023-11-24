local speedAdjust = {}

speedAdjust.skinPanelSelectColor = color(200, 200, 200, 255)
speedAdjust.skinPanelDisableColor = color(75, 75, 75, 255)
speedAdjust.skinPanelHoverColor = color(255, 255, 255, 255)

function speedAdjust:setIcon(icon)
	self.icon = icon
end

function speedAdjust:setSpeed(speed)
	self.speed = speed
end

function speedAdjust:onClick(key, x, y)
	timeline:attemptSetSpeed(self.speed)
end

function speedAdjust:isOn()
	local theirSpeed = timeline:getSpeed()
	
	if self.speed == 0 and (theirSpeed == self.speed or timeline:isPaused()) then
		return true
	end
	
	return theirSpeed > 0 and theirSpeed <= self.speed and math.dist(theirSpeed, self.speed) <= 1
end

function speedAdjust:isDisabled()
	return not self:isOn()
end

function speedAdjust:getText()
end

function speedAdjust:onMouseEntered()
	self.descBox = gui.create("GenericDescbox")
	
	if self.speed == 0 then
		self.descBox:addText(_T("PAUSE_SIMULATION", "Pause time"), "pix24", nil, 0, 500)
		self.descBox:addText(_T("CLICK_TO_PAUSE", "Click to pause time"), "pix20", nil, 0, 500)
	else
		self.descBox:addText(string.easyformatbykeys(_T("SPEED_ADJUSTMENT_LEVEL", "xSPEED speed"), "SPEED", self.speed), "pix24", nil, 0, 500)
		self.descBox:addText(_T("CLICK_TO_ENABLE_SPEED_LEVEL", "Click to set speed"), "pix20", nil, 0, 500)
	end
	
	self.descBox:centerToElement(self)
	self:queueSpriteUpdate()
end

function speedAdjust:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function speedAdjust:handleEvent(event)
	if event == timeline.EVENTS.SPEED_CHANGED then
		self:queueSpriteUpdate()
	end
end

function speedAdjust:onHide()
	self:killDescBox()
end

function speedAdjust:updateSprites()
	local baseColor = self:isMouseOver() and self.skinPanelHoverColor or self:getStateColor()
	
	self:setNextSpriteColor(baseColor:unpack())
	
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

gui.register("SpeedAdjustmentButton", speedAdjust)
