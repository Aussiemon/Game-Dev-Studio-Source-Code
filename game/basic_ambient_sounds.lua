local function genericTimeOfDayCheck(self)
	local time = timeOfDay:getTime()
	
	if self.timeOfDay.min > self.timeOfDay.max then
		return time > self.timeOfDay.min or time < self.timeOfDay.max
	end
	
	return time > self.timeOfDay.min and time <= self.timeOfDay.max
end

local function genericRainIntensityCheck(self)
	local intensity = weather:getIntensity()
	
	return intensity >= self.rainIntensity.min and intensity <= self.rainIntensity.max
end

local birds = {}

birds.id = "birds"
birds.type = ambientSounds.playType.PLAYONCE
birds.timeOfDay = {
	max = 1260,
	min = 260
}
birds.sound = {
	"ambient_birds"
}
birds.frequency = {
	max = 20,
	min = 15
}
birds.vol = 0.05
birds.meetsRequirements = genericTimeOfDayCheck

ambientSounds.registerSound(birds)

local wind = {}

wind.id = "wind"
wind.type = ambientSounds.playType.PLAYONCE
wind.timeOfDay = {
	max = 1260,
	min = 260
}
wind.sound = {
	"ambient_wind"
}
wind.frequency = {
	max = 20,
	min = 15
}
wind.vol = 0.1
wind.meetsRequirements = genericTimeOfDayCheck

ambientSounds.registerSound(wind)

local nightWind = {}

nightWind.id = "wind_night"
nightWind.type = ambientSounds.playType.PLAYONCE
nightWind.timeOfDay = {
	max = 240,
	min = 1260
}
nightWind.sound = {
	"ambient_wind_night"
}
nightWind.frequency = {
	max = 20,
	min = 15
}
nightWind.vol = 0.15
nightWind.meetsRequirements = genericTimeOfDayCheck

ambientSounds.registerSound(nightWind)

local rainWind = {}

rainWind.id = "rain_wind"
rainWind.type = ambientSounds.playType.PLAYONCE
rainWind.rainIntensity = 0.4
rainWind.sound = {
	"ambient_wind_night"
}
rainWind.frequency = {
	max = 20,
	min = 15
}
rainWind.vol = 0.2

function rainWind:meetsRequirements()
	return weather:getIntensity() >= self.rainIntensity
end

ambientSounds.registerSound(rainWind)

local crickets = {}

crickets.id = "crickets"
crickets.type = ambientSounds.playType.LOOP
crickets.timeOfDay = {
	max = 240,
	min = 1260
}
crickets.sound = {
	"ambient_crickets"
}
crickets.frequency = {
	max = 20,
	min = 15
}
crickets.vol = 0.2
crickets.meetsRequirements = genericTimeOfDayCheck

ambientSounds.registerSound(crickets)

local weakRain = {}

weakRain.id = "rain_light"
weakRain.type = ambientSounds.playType.LOOP
weakRain.sound = {
	"rain_light"
}
weakRain.vol = 0.5
weakRain.rainIntensity = {
	max = 0.3,
	min = 0.1
}
weakRain.meetsRequirements = genericRainIntensityCheck

ambientSounds.registerSound(weakRain)

local mediumRain = {}

mediumRain.id = "rain_medium"
mediumRain.type = ambientSounds.playType.LOOP
mediumRain.sound = {
	"rain_medium"
}
mediumRain.vol = 0.5
mediumRain.rainIntensity = {
	max = 0.65,
	min = 0.31
}
mediumRain.meetsRequirements = genericRainIntensityCheck

ambientSounds.registerSound(mediumRain)

local strongRain = {}

strongRain.id = "rain_strong"
strongRain.type = ambientSounds.playType.LOOP
strongRain.sound = {
	"rain_strong"
}
strongRain.vol = 0.5
strongRain.rainIntensity = {
	max = 1,
	min = 0.66
}
strongRain.meetsRequirements = genericRainIntensityCheck

ambientSounds.registerSound(strongRain)
