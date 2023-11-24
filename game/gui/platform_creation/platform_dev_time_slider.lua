local devTimeSlider = {}

devTimeSlider.rounding = 0
devTimeSlider.valueMult = 1
devTimeSlider.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.PART_SET,
	playerPlatform.EVENTS.DEV_TIME_SET
}

function devTimeSlider:handleEvent(event)
	self.workIndicator:queueSpriteUpdate()
	self:updateWorkIndicatorPosition()
end

function devTimeSlider:init()
	self:createMinimumWorkIndicator()
end

function devTimeSlider:onSizeChanged()
	self:updateWorkIndicatorSize()
	self:updateWorkIndicatorPosition()
end

function devTimeSlider:createMinimumWorkIndicator()
	self.workIndicator = gui.create("MinimumDevTimePin", self)
	
	self.workIndicator:setCanClick(false)
end

function devTimeSlider:updateWorkIndicatorSize()
	if self.workIndicator then
		local height = self:getBarHeight()
		
		self.workIndicator:setSize(6, height - 1)
	end
end

function devTimeSlider:isEnoughWork()
	local obj = platformParts:getPlatformObject()
	
	return obj:getDevTime() < obj:getMinimumWorkMonths()
end

function devTimeSlider:updateWorkIndicatorPosition()
	if self.workIndicator then
		local obj = platformParts:getPlatformObject()
		local barX = self:getBarX()
		local barY = self:getBarY()
		local width = _S(self:getBarWidth() - self.workIndicator.rawW) * ((obj:getMinimumWorkMonths() - playerPlatform.MINIMUM_DEV_TIME) / (playerPlatform.MAXIMUM_DEV_TIME - playerPlatform.MINIMUM_DEV_TIME))
		
		self.workIndicator:setPos(barX + width, barY)
	end
end

function devTimeSlider:onMouseLeft()
	devTimeSlider.baseClass.onMouseLeft(self)
end

function devTimeSlider:onSetValue(oldvalue)
	if oldvalue ~= self.value then
		platformParts:getPlatformObject():setDevTime(self.value)
	end
end

gui.register("PlatformDevTimeSlider", devTimeSlider, "Slider")
