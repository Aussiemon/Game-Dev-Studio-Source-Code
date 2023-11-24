local rainDropletRenderer = require("game/rain_droplet_renderer")
local prioritySpritebatchLayer = require("engine/priority_spritebatch_layer")

weather = {}
weather.waterPuddles = {}
weather.durationRange = {
	180,
	360
}
weather.rainDropletColor = color(132, 132, 132, 100)
weather.fadeOutSpeed = 0.05
weather.fadeInSpeed = 0.06666666666666667
weather.minIntensity = 0.25
weather.maxIntensity = 1
weather.rainChance = 3
weather.rainCooldown = {
	300,
	600
}
weather.lightningIntensity = 0.8
weather.lightningChance = 60
weather.lightnings = {
	10,
	15
}
weather.lightningCooldown = {
	10,
	15
}
weather.lightningSoundDelay = {
	0.5,
	1
}
weather.lightningLightLevel = 180
weather.lightningFrequency = 0.1
weather.lightningDuration = math.pi * weather.lightningFrequency
weather.maxDroplets = 500
weather.dropletsPerSecond = 240
weather.splashesPerSecond = 720
weather.dropletEdge = 200
weather.rainDropSpeed = 800
weather.renderDepth = 1500
weather.rainDirectionRange = {
	math.pi * 0.25,
	math.pi * 0.4
}
weather.lightLevelDrop = 120
weather.darknessFromLightLevel = 50
weather.wetnessGain = 0.008333333333333333
weather.wetnessDrop = 0.05
weather.dropletQuads = {
	{
		quad = quadLoader:load("rain_droplet"),
		speed = {
			0.5,
			1
		},
		scale = {
			0.75,
			1
		}
	},
	{
		quad = quadLoader:load("rain_droplet_2"),
		speed = {
			0.75,
			1
		},
		scale = {
			0.5,
			1
		}
	}
}
weather.rainSplashRenderDepth = 1.5
weather.maxSplashes = 400
weather.splashTransitSpeed = 0.05
weather.rainSplashQuads = {
	quadLoader:load("rainsplash_1"),
	quadLoader:load("rainsplash_2"),
	quadLoader:load("rainsplash_3"),
	quadLoader:load("rainsplash_4"),
	quadLoader:load("rainsplash_5"),
	quadLoader:load("rainsplash_6")
}
weather.lightningColor = color(255, 255, 255, 255)
weather.rainSplashColor = color(200, 200, 200, 200)
weather.splashQuadCount = #weather.rainSplashQuads
weather.DESCRIPTION = {
	{
		font = "pix20",
		text = _T("WEATHER_INTENSITY_DESCRIPTION", "Set the intensity of rain effects")
	}
}
weather.DEFAULT_QUALITY_PRESET = 3
weather.QUALITY_PRESETS = {
	{
		droplets = 100,
		name = _T("WEATHER_INTENSITY_MINIMAL", "Minimal")
	},
	{
		droplets = 250,
		name = _T("WEATHER_INTENSITY_REDUCED", "Reduced")
	},
	{
		droplets = 500,
		name = _T("WEATHER_INTENSITY_NORMAL", "Normal")
	},
	{
		droplets = 1000,
		name = _T("WEATHER_INTENSITY_INCREASED", "Increased")
	},
	{
		droplets = 1500,
		name = _T("WEATHER_INTENSITY_INTENSE", "Intense")
	}
}
weather.PUDDLE_OFFSET_X = 5
weather.PUDDLE_OFFSET_Y = 5
weather.MAX_PUDDLES = 400
weather.PUDDLE_SPAWN_TIME = 0.5
weather.wetness = 0
weather.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK
}
weather.EVENTS = {
	STARTED = events:new(),
	ENDED = events:new()
}

function weather:init()
	self.grid = game.worldObject:getFloorTileGrid()
	self.officeBuildingMap = studio:getOfficeBuildingMap():getTileIndexes()
	self.puddleTime = 0
	self.curIntensity = 0
	self.intensity = 0
	self.dropletProgress = 0
	self.splashProgress = 0
	self.rainDelay = 0
	self.rainDuration = 0
	self.lightingDelay = 0
	self.lightningHold = 0
	self.lightningFlash = 0
	self.cachedDroplets = {}
	self.cachedSplashes = {}
	self.rainSplashes = {}
	self.droplets = {}
	self.puddleIndexes = {}
	
	local image = cache.getImage("textures/spritesheets/environmental.png")
	
	if not self.rainSplashSpriteBatch then
		self.rainSplashSpriteBatch = love.graphics.newSpriteBatch(image, self.maxSplashes, "dynamic")
		
		for i = 1, self.maxSplashes do
			self.rainSplashSpriteBatch:add(0, 0, 0, 0, 0)
		end
	end
	
	self.rainSplashRenderer = prioritySpritebatchLayer:new()
	
	self.rainSplashRenderer:setSpriteBatch(self.rainSplashSpriteBatch)
	self.rainSplashRenderer:setDrawColor(self.rainSplashColor)
	
	if not self.spriteBatch then
		self.spriteBatch = love.graphics.newSpriteBatch(image, self.maxDroplets, "dynamic")
		
		for i = 1, self.maxDroplets do
			self.spriteBatch:add(0, 0, 0, 0, 0)
		end
	end
	
	self.rainRenderer = rainDropletRenderer:new()
	
	self.rainRenderer:setSpriteBatch(self.spriteBatch)
	self:setupPuddleBoundaries()
	events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function weather:setupPuddleBoundaries()
	local minX, minY, maxX, maxY = game.worldObject:getBuildingBoundaries()
	local gridW, gridH = game.worldObject:getGridSize()
	
	self.puddleMinX = math.max(1, minX - self.PUDDLE_OFFSET_X)
	self.puddleMinY = math.max(1, minY - self.PUDDLE_OFFSET_Y)
	self.puddleMaxX = math.min(maxX + self.PUDDLE_OFFSET_X, gridW)
	self.puddleMaxY = math.min(maxY + self.PUDDLE_OFFSET_Y, gridH)
end

function weather:onResolutionChanged()
	self.dropletSpeed = _S(self.rainDropSpeed)
	self.dropletSize = _S(0.7)
	
	self:updateScreenValues()
	self:updateRainBoundaries()
	
	if self:isWeatherActive() then
		self:initializeRandomRain(true, true)
	end
end

function weather:isWeatherActive()
	return self.curIntensity and (self.curIntensity > 0 or self.rainDuration > 0)
end

function weather:updateMaxCurDroplets()
	self.maxCurDroplets = math.floor(self.maxDroplets * self.curIntensity / self.smallestScale)
end

function weather:updateScreenValues()
	local scaledW, scaledH = scrW / camera.scaleX, scrH / camera.scaleY
	
	self.scaledW = scaledW
	self.scaledH = scaledH
	self.smallestScale = math.max(camera.scaleX, camera.scaleY)
	
	if self.curIntensity then
		self:updateMaxCurDroplets()
	end
end

function weather:updateRainBoundaries()
	self.minX, self.maxX, self.minY, self.maxY = camera.x - self.dropletEdge, camera.x + self.scaledW + self.dropletEdge, camera.y - self.dropletEdge, camera.y + self.scaledH + self.dropletEdge
end

function weather:remove()
	self.curIntensity = 0
	self.intensity = 0
	self.dropletProgress = 0
	self.splashProgress = 0
	self.puddleTime = 0
	self.rainDelay = 0
	self.lightingDelay = 0
	self.lightningHold = 0
	self.lightningsToDo = 0
	self.wetness = 0
	
	table.clearArray(self.cachedDroplets)
	table.clearArray(self.droplets)
	table.clearArray(self.rainSplashes)
	table.clearArray(self.cachedSplashes)
	table.clearArray(self.waterPuddles)
	
	for i = 1, self.maxSplashes do
		self.rainSplashSpriteBatch:set(i - 1, 0, 0, 0, 0, 0)
	end
	
	for i = 1, self.maxDroplets do
		self.spriteBatch:set(i - 1, 0, 0, 0, 0, 0)
	end
	
	self:stopRain()
	events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function weather:onZoomLevelChanged()
	self:updateScreenValues()
	self:updateRainBoundaries()
	self:initializeRandomRain(true, true)
end

function weather:getQualitySettings()
	return self.maxDroplets
end

function weather:getQualityPresets()
	return weather.QUALITY_PRESETS
end

function weather:isActive()
	return self.rainDuration > 0
end

function weather:getPresetBySettings(droplets)
	for key, data in pairs(weather.QUALITY_PRESETS) do
		if data.droplets == droplets then
			return data
		end
	end
	
	return weather.QUALITY_PRESETS[2]
end

function weather:setQualityPreset(realPresetId)
	local presetId = realPresetId or weather.DEFAULT_QUALITY_PRESET
	local oldID = self.qualityPreset
	
	self.qualityPreset = presetId
	
	local presetData = weather.QUALITY_PRESETS[self.qualityPreset]
	
	self.maxDroplets = presetData.droplets
	
	if self.curIntensity then
		self:updateMaxCurDroplets()
	end
	
	if oldID ~= presetId and self:isWeatherActive() then
		self:initializeRandomRain(true, true, true)
	end
end

function weather:handleEvent(event)
	if self.curIntensity == 0 then
		self.wetness = math.max(0, self.wetness - self.wetnessDrop)
	end
	
	if self.intensity == 0 then
		if event == timeline.EVENTS.NEW_WEEK then
			if math.randomf(1, 100) <= self.rainChance then
				self:startRain()
			end
		elseif event == timeline.EVENTS.NEW_DAY then
			self.rainDelay = self.rainDelay - 1
		end
	end
end

function weather:getWetness()
	return self.wetness
end

function weather:cacheDroplet(dropletData)
	self.cachedDroplets[#self.cachedDroplets + 1] = dropletData
end

function weather:cacheSplash(splashData)
	self.cachedSplashes[#self.cachedSplashes + 1] = splashData
end

function weather:startRain()
	local prevIntensity = self.intensity
	
	if prevIntensity ~= 0 then
		return 
	end
	
	self.intensity = math.round(math.randomf(self.minIntensity, self.maxIntensity), 2)
	
	if self.intensity >= self.lightningIntensity and math.random(1, 100) <= weather.lightningChance then
		self.lightningsToDo = math.random(self.lightnings[1], self.lightnings[2])
	else
		self.lightningsToDo = 0
	end
	
	self.rainDuration = math.random(math.lerp(self.durationRange[1], self.durationRange[2], self.intensity * 0.75), self.durationRange[2])
	self.rainDelay = self.rainDuration + math.random(self.rainCooldown[1], self.rainCooldown[2])
	
	self:activate()
	self:setupRainDirection()
end

function weather:placeWaterPuddle()
	local x, y = math.random(self.puddleMinX, self.puddleMaxX), math.random(self.puddleMinY, self.puddleMaxY)
	local index = self.grid:getTileIndex(x, y)
	
	if not studio.officeBuildingMap:getTileBuilding(index) and not self.puddleIndexes[index] then
		local puddle = objects.create("water_puddle")
		
		puddle:setPos(x * game.WORLD_TILE_WIDTH, y * game.WORLD_TILE_HEIGHT)
		game.worldObject:addDecorEntity(puddle, true)
		
		self.puddleIndexes[index] = true
	end
end

function weather:setupRainDirection()
	self.rainRad = math.randomf(self.rainDirectionRange[1], self.rainDirectionRange[2])
	self.rainDirX, self.rainDirY = math.normalfromrad(self.rainRad)
	self.slowestDirection = math.min(self.rainDirX, self.rainDirY)
end

function weather:activate()
	self.lightingDelay = 0
	self.lightningHold = 0
	self.maxCurDroplets = 0
	
	self:enableLogic()
	self:enableRenderer()
	
	self.active = true
	
	events:fire(weather.EVENTS.STARTED)
end

function weather:enableLogic()
	gameStateService:addState(self)
end

function weather:enableRenderer()
	priorityRenderer:add(self.rainSplashRenderer, self.rainSplashRenderDepth)
	priorityRenderer:add(self.rainRenderer, self.renderDepth)
end

function weather:stopRain()
	priorityRenderer:remove(self.rainRenderer)
	priorityRenderer:remove(self.rainSplashRenderer)
	gameStateService:removeState(self)
	events:fire(weather.EVENTS.ENDED)
	
	self.intensity = 0
	self.active = false
end

function weather:getIntensity()
	return self.curIntensity
end

function weather:createSplash(x, y)
	local data = {
		spriteID = #self.rainSplashes
	}
	
	self:_applySplashData(data, x, y, 1)
	
	return data
end

function weather:_applySplashData(data, x, y, frame)
	data.x = x
	data.y = y
	data.progress = 0
	data.frame = frame
	data.rotation = math.randomf(-math.pi, math.pi)
	data.scale = math.randomf(0.75, 1)
end

function weather:pickSplashPosition(splashData)
	local randomX, randomY = math.random(self.splashStartX, self.splashEndX), math.random(self.splashStartY, self.splashEndY)
	local tileIndex = self.grid:getTileIndex(randomX, randomY)
	
	if not self.officeBuildingMap[tileIndex] then
		local centerX, centerY = randomX * game.WORLD_TILE_WIDTH + math.random(-24, 8), randomY * game.WORLD_TILE_WIDTH + math.random(-24, 8)
		
		splashData.x = centerX
		splashData.y = centerY
		
		self:_applySplashData(splashData, x, y)
		
		return true
	end
	
	return false
end

function weather:attemptCreateSplash(frame)
	local randomX, randomY = math.random(self.splashStartX, self.splashEndX), math.random(self.splashStartY, self.splashEndY)
	local tileIndex = self.grid:getTileIndex(randomX, randomY)
	
	if not self.officeBuildingMap[tileIndex] then
		local centerX, centerY = randomX * game.WORLD_TILE_WIDTH + math.random(-24, 0) - game.WORLD_TILE_WIDTH, randomY * game.WORLD_TILE_HEIGHT + math.random(-24, 0) - game.WORLD_TILE_HEIGHT
		local splash = self:createSplash(centerX, centerY)
		
		self:_applySplashData(splash, centerX, centerY, frame)
		
		return splash
	end
	
	return nil
end

function weather:attemptPlaceDropletSplash(data)
	local tileIndex = self.grid:getTileIndex(self.grid:worldToGrid(data.x, data.y))
	
	if not self.officeBuildingMap[tileIndex] then
		local cached = #self.cachedSplashes
		local reused = self.cachedSplashes[cached]
		
		if reused then
			table.remove(self.cachedSplashes, cached)
			self:_applySplashData(reused, data.x, data.y, 1)
			
			self.rainSplashes[#self.rainSplashes + 1] = reused
		else
			local splash = self:createSplash(data.x, data.y)
			
			self.rainSplashes[#self.rainSplashes + 1] = splash
		end
		
		self:applyRainData(data)
	end
end

function weather:updateSplashes(dt)
	local key = 1
	local minX, maxX, minY, maxY = self.minX, self.maxX, self.minY, self.maxY
	
	for i = 1, #self.rainSplashes do
		local data = self.rainSplashes[key]
		
		data.progress = data.progress + dt
		
		if data.progress >= self.splashTransitSpeed then
			local frames = math.floor(data.progress / self.splashTransitSpeed)
			
			data.progress = data.progress - self.splashTransitSpeed * frames
			data.frame = data.frame + frames
		end
		
		if data.frame > self.splashQuadCount or minY > data.y or maxY < data.y or minX > data.x or maxX < data.x then
			self:cacheSplash(data)
			self.rainSplashSpriteBatch:set(data.spriteID, 0, 0, 0, 0, 0)
			table.remove(self.rainSplashes, key)
		else
			self.rainSplashSpriteBatch:set(data.spriteID, self.rainSplashQuads[data.frame], data.x, data.y, data.rotation, data.scale, data.scale)
			
			key = key + 1
		end
	end
end

function weather:updateDroplets(dt)
	local dropSpeed = self.dropletSpeed * dt
	local key = 1
	
	self:updateRainBoundaries()
	
	local minX, maxX, minY, maxY = self.minX, self.maxX, self.minY, self.maxY
	local scaledH = self.scaledH
	local xDist, yDist = math.dist(minX, maxX), math.dist(minY, maxY)
	local renderAngle = self.rainRad + math.pi * 0.5
	local slowest = self.slowestDirection
	local rainDur = self.rainDuration
	
	for i = 1, #self.droplets do
		local data = self.droplets[key]
		local speed = data.speed * dropSpeed
		
		data.x = data.x + self.rainDirX * speed
		data.y = data.y + self.rainDirY * speed
		data.distance = data.distance - speed * slowest
		
		local splash = data.distance <= 0
		
		if rainDur <= 0 then
			if i > self.maxCurDroplets then
				if splash then
					self:cacheDroplet(data)
					self:attemptPlaceDropletSplash(data)
					table.remove(self.droplets, key)
					self.spriteBatch:set(data.spriteID, 0, 0, 0, 0, 0)
				elseif minY > data.y or maxY < data.y or minX > data.x or maxX < data.x then
					self:cacheDroplet(data)
					self.spriteBatch:set(data.spriteID, 0, 0, 0, 0, 0)
					table.remove(self.droplets, key)
				else
					self.spriteBatch:set(data.spriteID, data.quad, data.x, data.y, renderAngle, data.scale, data.scale)
					
					key = key + 1
				end
			else
				if splash then
					self:attemptPlaceDropletSplash(data)
				end
				
				if minX > data.x then
					data.x = data.x + xDist
					data.distance = math.random(0, scaledH)
				elseif maxX < data.x then
					data.x = data.x - xDist
					data.distance = math.random(0, scaledH)
				end
				
				if minY > data.y then
					data.y = data.y + yDist
					data.distance = math.random(0, scaledH)
				elseif maxY < data.y then
					data.y = data.y - yDist
					data.distance = math.random(0, scaledH)
				end
				
				self.spriteBatch:set(data.spriteID, data.quad, data.x, data.y, renderAngle, data.scale, data.scale)
				
				key = key + 1
			end
		else
			if splash then
				self:attemptPlaceDropletSplash(data)
			end
			
			if minX > data.x then
				data.x = data.x + xDist
				data.distance = math.random(0, scaledH)
			elseif maxX < data.x then
				data.x = data.x - xDist
				data.distance = math.random(0, scaledH)
			end
			
			if minY > data.y then
				data.y = data.y + yDist
				data.distance = math.random(0, scaledH)
			elseif maxY < data.y then
				data.y = data.y - yDist
				data.distance = math.random(0, scaledH)
			end
			
			self.spriteBatch:set(data.spriteID, data.quad, data.x, data.y, renderAngle, data.scale, data.scale)
			
			key = key + 1
		end
	end
end

function weather:update(dt, dropStep)
	local xMin, yMin, xMax, yMax = self.grid:getVisibleTiles()
	
	if not timeline.paused and timeline.speed > 0 then
		local step = dt * timeline.speed
		local prevDur = self.rainDuration
		
		self.rainDuration = math.max(0, self.rainDuration - step)
		
		if prevDur > 0 and self.rainDuration == 0 then
			for key, puddle in ipairs(self.waterPuddles) do
				if not puddle.visible then
					puddle:updateState(true)
				end
			end
		end
		
		if self.rainDuration > 0 then
			self.curIntensity = math.approach(self.curIntensity, self.intensity, self.fadeInSpeed * step)
			self.dropletProgress = self.dropletProgress + step * self.dropletsPerSecond * self.curIntensity
			self.splashProgress = self.splashProgress + step * self.splashesPerSecond * self.curIntensity
			
			self:updateMaxCurDroplets()
			
			if self.dropletProgress >= 1 then
				local floored = math.floor(self.dropletProgress)
				
				for i = 1, math.max(0, math.min(self.maxCurDroplets - #self.droplets, floored)) do
					local cached = #self.cachedDroplets
					local reused = self.cachedDroplets[cached]
					
					if reused then
						table.remove(self.cachedDroplets, cached)
						self:applyRainData(reused)
						
						self.droplets[#self.droplets + 1] = reused
					else
						self.droplets[#self.droplets + 1] = self:createRainDroplet()
					end
				end
				
				self.dropletProgress = self.dropletProgress - floored
				
				self:updateVisibleSplashArea()
			end
		else
			self.curIntensity = math.approach(self.curIntensity, 0, self.fadeOutSpeed * step)
			
			self:updateMaxCurDroplets()
			
			if self.curIntensity == 0 and #self.droplets == 0 then
				self:stopRain()
			end
		end
		
		if #self.waterPuddles < weather.MAX_PUDDLES and self.curIntensity > 0 then
			self.puddleTime = self.puddleTime + dt * self.curIntensity
			
			if self.puddleTime > self.PUDDLE_SPAWN_TIME then
				self:placeWaterPuddle()
				
				self.puddleTime = self.puddleTime - self.PUDDLE_SPAWN_TIME
			end
		end
		
		self.wetness = math.min(1, self.wetness + step * self.curIntensity * self.wetnessGain)
		
		if self.curIntensity >= self.lightningIntensity and self.lightningsToDo > 0 then
			if self.lightingDelay <= 0 then
				sound.addTimed("rain_lightning", math.randomf(self.lightningSoundDelay[1], self.lightningSoundDelay[2]))
				
				self.lightningsToDo = self.lightningsToDo - 1
				self.lightningHold = self.lightningDuration
				self.lightingDelay = self.lightingDelay + math.randomf(self.lightningCooldown[1], self.lightningCooldown[2])
				self.lightningFlash = 0
			else
				self.lightingDelay = self.lightingDelay - dt
			end
		end
		
		if self.lightningHold > 0 then
			self.lightningHold = self.lightningHold - dt
			self.lightningFlash = self.lightningFlash + step
			self.lightningFlashValue = math.sin(self.lightningFlash / self.lightningFrequency * math.pi)
			
			local level = math.max(timeOfDay.brightness, self.lightningLightLevel * 0.75 + self.lightningFlashValue * self.lightningLightLevel * 0.25)
			
			self.lightningColor:setColor(level, level, level, 255)
			timeOfDay:overrideLightColor(self.lightningColor)
			timeOfDay:overrideLightLevel(level)
			
			if self.lightningHold <= 0 then
				self.lightningHold = 0
				self.lightningFlash = 0
				
				timeOfDay:overrideLightLevel(nil)
				timeOfDay:overrideLightColor(nil)
			end
		end
	end
	
	if not dropStep then
		dropStep = dt * (1 + (timeline.speed - 1) * 0.5)
		
		if timeline.paused or timeline.speed == 0 then
			dropStep = 0
		end
	end
	
	self:updateDroplets(dropStep)
	self:updateSplashes(dropStep)
end

function weather:updateVisibleSplashArea()
	local startX, startY = self.grid:getCameraStartTile()
	local visX, visY = self.grid:getVisibleScreenTiles()
	
	self.splashStartX = startX
	self.splashEndX = startX + visX
	self.splashStartY = startY
	self.splashEndY = startY + visY
end

function weather:adjustLightLevel(level)
	return level - self.lightLevelDrop * self.curIntensity
end

function weather:adjustLightColor(colorObject)
	local leastVibrantColor = math.max(20, colorObject:getLeastVibrant() - self.lightLevelDrop * self.curIntensity)
	
	colorObject:lerp(self.curIntensity, leastVibrantColor, leastVibrantColor, leastVibrantColor, 255)
end

function weather:createRainDroplet()
	local droplet = {
		spriteID = #self.droplets
	}
	
	self:applyRainData(droplet)
	
	return droplet
end

function weather:createRandomRainDroplet()
	local droplet = {
		spriteID = #self.droplets
	}
	
	self:applyRandomRainData(droplet)
	
	return droplet
end

function weather:applyRainData(droplet)
	droplet.x = math.random(camera.x - self.dropletEdge, camera.x + self.scaledW + self.dropletEdge)
	droplet.y = math.random(camera.y - self.dropletEdge, camera.y + self.dropletEdge)
	
	self:_applyRainData(droplet)
end

function weather:_applyRainData(droplet)
	local dropletData = weather.dropletQuads[math.random(1, #weather.dropletQuads)]
	
	droplet.quad = dropletData.quad
	droplet.speed = math.randomf(dropletData.speed[1], dropletData.speed[2])
	droplet.scale = math.randomf(dropletData.scale[1], dropletData.scale[2]) * self.dropletSize
	droplet.distance = math.random(0, self.scaledH)
end

function weather:applyRandomRainData(droplet)
	droplet.x = math.random(camera.x - self.dropletEdge, camera.x + self.scaledW + self.dropletEdge)
	droplet.y = math.random(camera.y - self.dropletEdge, camera.y + self.scaledH + self.dropletEdge)
	
	self:_applyRainData(droplet)
end

function weather:removeOverflowDroplets()
	local total = #self.droplets
	
	for i = total, math.max(1, self.maxCurDroplets), -1 do
		local top = self.droplets[i]
		
		self.spriteBatch:set(top.spriteID, 0, 0, 0, 0, 0)
		self:cacheDroplet(top)
		
		self.droplets[i] = nil
	end
end

function weather:placeMissingDroplets()
	local total = #self.droplets
	
	for i = 1, self.maxCurDroplets - total do
		self.droplets[total + 1] = self:createRandomRainDroplet()
		total = total + 1
	end
end

function weather:initializeRandomRain(randomizeExisting, skipSplashes, skipRandomizationOfExisting)
	if not game.worldObject or not self.droplets then
		return 
	end
	
	if randomizeExisting then
		if #self.droplets > self.maxCurDroplets then
			self:removeOverflowDroplets()
		elseif #self.droplets < self.maxCurDroplets then
			self:placeMissingDroplets()
		end
		
		if not skipRandomizationOfExisting then
			for key, data in ipairs(self.droplets) do
				self:applyRandomRainData(data)
			end
		end
	else
		for i = 1, math.floor(self.maxDroplets * self.curIntensity) do
			self.droplets[#self.droplets + 1] = self:createRandomRainDroplet()
		end
	end
	
	if not skipSplashes then
		for i = 1, math.floor(self.maxSplashes * self.curIntensity) do
			local splash = self:attemptCreateSplash(math.random(1, self.splashQuadCount - 1))
			
			if splash then
				self.rainSplashes[#self.rainSplashes + 1] = splash
			end
		end
	end
end

function weather:addPuddle(puddle)
	if puddle.IN_LIST then
		return 
	end
	
	table.insert(self.waterPuddles, puddle)
	
	puddle.IN_LIST = true
end

function weather:removePuddle(puddle)
	if not puddle.IN_LIST then
		return 
	end
	
	table.removeObject(self.waterPuddles, puddle)
	
	puddle.IN_LIST = false
	self.puddleIndexes[puddle:getTileCoordinates()] = nil
end

function weather:save()
	return {
		intensity = self.intensity,
		curIntensity = self.curIntensity,
		dropletProgress = self.dropletProgress,
		lightingDelay = self.lightingDelay,
		lightningHold = self.lightningHold,
		lightningsToDo = self.lightningsToDo,
		rainDuration = self.rainDuration,
		rainRad = self.rainRad,
		wetness = self.wetness,
		rainDelay = self.rainDelay,
		puddleTime = self.puddleTime
	}
end

function weather:load(data)
	self:updateRainBoundaries()
	
	self.intensity = data.intensity
	self.curIntensity = data.curIntensity
	self.dropletProgress = data.dropletProgress
	self.lightingDelay = data.lightingDelay
	self.lightningHold = data.lightningHold
	self.lightningsToDo = data.lightningsToDo or 0
	self.rainDuration = data.rainDuration
	self.wetness = data.wetness or self.wetness
	self.rainDelay = data.rainDelay or self.rainDelay
	self.puddleTime = data.puddleTime or self.puddleTime
	
	self:setupRainDirection()
	
	if self.curIntensity > 0 or self.rainDuration > 0 then
		self:activate()
		self:updateVisibleSplashArea()
		self:initializeRandomRain()
	end
end
