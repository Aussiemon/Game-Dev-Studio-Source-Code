timeOfDay = {}
timeOfDay.time = 0
timeOfDay.maxTime = 1440
timeOfDay.brightness = 255
timeOfDay.currentColor = color(255, 255, 255, 255)
timeOfDay.lightLevels = {
	night = color(25, 29, 40, 255),
	earlyDawn = color(188, 160, 126, 255),
	dawn = color(198, 183, 139, 255),
	morning = color(221, 216, 179, 255),
	day = color(255, 249, 216, 255),
	evening = color(142, 138, 114, 255)
}
timeOfDay.lowestLightLevel = 255

for level, colorObject in pairs(timeOfDay.lightLevels) do
	timeOfDay.lowestLightLevel = math.min(timeOfDay.lowestLightLevel, colorObject.r, colorObject.g, colorObject.b)
end

timeOfDay.EVENTS = {
	NEW_HOUR = events:new()
}

function timeOfDay:init()
	self.brightness = 0
	self.time = 0
	self.currentColor = color(255, 255, 255, 255)
	self.hour = -1
end

function timeOfDay:remove()
	self.brightness = 255
	self.time = 0
	self.lightLevelOverride = nil
end

function timeOfDay:getShadowSampleDirection()
	return self.time / timeOfDay.maxTime * 360
end

function timeOfDay:findTimeDifference(start, finish)
	return math.clamp((start - self.currentTime) / (start - finish), 0, 1)
end

function timeOfDay:getBrightness()
	return self.lightLevelOverride or self.brightness
end

function timeOfDay:getLightColor()
	return self.colorOverride or self.currentColor
end

function timeOfDay:overrideLightLevel(override)
	self.lightLevelOverride = override
end

function timeOfDay:overrideLightColor(color)
	self.colorOverride = color
end

function timeOfDay:updateHour(time)
	local hour = math.floor(time / 60)
	
	if hour ~= self.hour then
		events:fire(timeOfDay.EVENTS.NEW_HOUR, hour)
	end
	
	self.hourTime = time / 60
	self.hour = hour
	self.time = time
end

function timeOfDay:getHour()
	return self.hour
end

function timeOfDay:getHourTime()
	return self.hourTime
end

function timeOfDay:postLoad()
	self:updateHour(timeline:getYearProgress() * timeOfDay.maxTime)
end

function timeOfDay:updateLightValues()
	local time = timeline:getYearProgress() * timeOfDay.maxTime
	
	self.currentTime = time
	
	local fromBrightness, toBrightness, timeDifference
	local lightLevels = self.lightLevels
	
	if time >= 0 and time < 150 then
		timeDifference = self:findTimeDifference(0, 150)
		fromBrightness = lightLevels.night
		toBrightness = lightLevels.night
	elseif time >= 150 and time < 240 then
		timeDifference = self:findTimeDifference(150, 240)
		fromBrightness = lightLevels.night
		toBrightness = lightLevels.earlyDawn
	elseif time >= 240 and time < 300 then
		timeDifference = self:findTimeDifference(240, 300)
		fromBrightness = lightLevels.earlyDawn
		toBrightness = lightLevels.dawn
	elseif time >= 300 and time < 480 then
		timeDifference = self:findTimeDifference(300, 480)
		fromBrightness = lightLevels.dawn
		toBrightness = lightLevels.morning
	elseif time >= 480 and time < 600 then
		timeDifference = self:findTimeDifference(480, 600)
		fromBrightness = lightLevels.morning
		toBrightness = lightLevels.day
	elseif time >= 600 and time < 1080 then
		timeDifference = self:findTimeDifference(600, 1080)
		fromBrightness = lightLevels.day
		toBrightness = lightLevels.day
	elseif time >= 1080 and time < 1200 then
		timeDifference = self:findTimeDifference(1080, 1200)
		fromBrightness = lightLevels.day
		toBrightness = lightLevels.evening
	elseif time >= 1200 and time <= 1440 then
		timeDifference = self:findTimeDifference(1200, 1440)
		fromBrightness = lightLevels.evening
		toBrightness = lightLevels.night
	end
	
	self:updateHour(time)
	self.currentColor:lerpFromTo(timeDifference, fromBrightness, toBrightness)
	
	self.brightness = self.currentColor:getMostVibrant()
	
	weather:adjustLightColor(self.currentColor)
	
	self.brightness = math.max(weather:adjustLightLevel(self.brightness), timeOfDay.lowestLightLevel)
	
	return self.currentColor, self.brightness
end

function timeOfDay:getTime()
	return self.time
end
