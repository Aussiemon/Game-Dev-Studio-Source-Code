local beginAdvert = {}

beginAdvert.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.ADVERT_DURATION_ADJUSTED
}

function beginAdvert:handleEvent(event, obj, duration)
	if obj == self.platform then
		self:updateState(duration)
	end
end

function beginAdvert:updateState(duration)
	if studio:getFunds() < self.platform:getAdvertDurationCost(duration) then
		self:setCanClick(false)
	else
		self:setCanClick(true)
	end
end

function beginAdvert:setPlatform(plat)
	self.platform = plat
end

function beginAdvert:setDurationSlider(slider)
	self.slider = slider
end

function beginAdvert:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local dur = self.slider:getValue()
		
		frameController:pop()
		self.platform:beginAdvertisement(dur)
	end
end

gui.register("BeginPlatformAdvertButton", beginAdvert, "Button")
