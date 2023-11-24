local advertDurationSlider = {}

advertDurationSlider.rounding = 0

function advertDurationSlider:setPlatform(plat)
	self.platform = plat
end

function advertDurationSlider:onSetValue(oldValue)
	if oldValue ~= self.value then
		events:fire(playerPlatform.EVENTS.ADVERT_DURATION_ADJUSTED, self.platform, self.value)
	end
end

function advertDurationSlider:formatText(value)
	if value then
		self:setText(_format(_T("PLATFORM_ADVERTISEMENT_DURATION", "Advertisement duration: SLIDER_VALUE"), "SLIDER_VALUE", timeline:getTimePeriodText(tonumber(self.value) * timeline.DAYS_IN_WEEK)))
	end
end

gui.register("PlatformAdvertDurationSlider", advertDurationSlider, "Slider")
