pedestrianController = {}
pedestrianController.SLEEP_DURATION = {
	60,
	360
}
pedestrianController.SLEEP_UPDATE_COOLDOWN = 1
pedestrianController.RAIN_WALK_SPEED = 2
pedestrianController.BEDTIME_HOURS = {
	7,
	19
}
pedestrianController.WAKE_TIME_DELTA = {
	-2,
	6
}
pedestrianController.EMPTY_STREETS_UPON_LOAD_WEATHER_INTENSITY = 0.4
pedestrianController.COUNT_INDEXES = {
	0,
	25,
	50,
	100,
	200
}
pedestrianController.pedestrianCountIndex = 3
pedestrianController.pedestrianCount = pedestrianController.COUNT_INDEXES[pedestrianController.pedestrianCountIndex]

function pedestrianController:init()
	self.allPedestrians = {}
	self.pedestrians = {}
	self.previousPeds = {}
	self.visiblePeds = {}
	self.sleepingPedestrians = {}
	self.sleepUpdateTime = 0
	self.buildingsPresent = #game.worldObject:getPedestrianBuildings()
	self.quadTree = game.worldObject:getPedestrianQuadTree()
	
	if self.buildingsPresent and self.pedestrianCount > 0 then
		for i = 1, self.pedestrianCount do
			self:spawnPedestrian()
		end
		
		self.active = true
		
		self:initEventHandler()
	else
		self.active = false
	end
end

function pedestrianController:getPedestrianCount()
	return self.pedestrianCount
end

function pedestrianController:setPedestrianCountIndex(index)
	index = math.max(1, math.min(index, #pedestrianController.COUNT_INDEXES))
	
	local prevCount = pedestrianController.COUNT_INDEXES[self.pedestrianCountIndex]
	
	self.pedestrianCountIndex = index
	
	local count = pedestrianController.COUNT_INDEXES[index]
	local delta = count - prevCount
	local pedTable = self.allPedestrians
	
	self.pedestrianCount = count
	
	if buildingsPresent then
		if prevCount == 0 and count > 0 then
			self:initEventHandler()
			
			self.active = true
		elseif prevCount > 0 and count == 0 then
			self:removeEventHandler()
			
			self.active = false
		end
	end
	
	if not game.worldObject then
		return 
	end
	
	if delta > 0 then
		for i = 1, delta do
			self:spawnPedestrian()
		end
	elseif delta < 0 then
		local sleepingPedestrians = self.sleepingPedestrians
		
		for i = 1, math.abs(delta) do
			local ped = pedTable[#pedTable]
			
			ped:remove()
			
			for key, data in ipairs(sleepingPedestrians) do
				if data.pedestrian == ped then
					table.remove(sleepingPedestrians, key)
					
					break
				end
			end
			
			self.previousPeds[ped] = nil
			
			table.remove(pedTable, #pedTable)
			table.removeObject(self.pedestrians, ped)
			table.removeObject(self.visiblePeds, ped)
		end
	end
end

function pedestrianController:remove()
	for key, ped in ipairs(self.allPedestrians) do
		ped:remove()
		
		self.allPedestrians[key] = nil
	end
	
	table.clearArray(self.sleepingPedestrians)
	table.clearArray(self.pedestrians)
	table.clearArray(self.visiblePeds)
	table.clear(self.previousPeds)
	self:removeEventHandler()
end

function pedestrianController:initEventHandler()
	events:addDirectReceiver(self, pedestrianController.CATCHABLE_EVENTS)
end

function pedestrianController:removeEventHandler()
	events:removeDirectReceiver(self, pedestrianController.CATCHABLE_EVENTS)
end

function pedestrianController:postInitUpdate()
	local hour = timeOfDay:getHour()
	
	self.bedTime = hour < pedestrianController.BEDTIME_HOURS[1] or hour > pedestrianController.BEDTIME_HOURS[2]
	
	local postInitUpdateDelta = 0.06666666666666667
	local percentage = not (not self.bedTime and not (weather:getIntensity() >= pedestrianController.EMPTY_STREETS_UPON_LOAD_WEATHER_INTENSITY)) and 1 or 0.75
	
	for i = 1, math.floor(#self.pedestrians * percentage) do
		local ped = self.pedestrians[1]
		
		self:makeSleeping(ped, math.random(pedestrianController.SLEEP_DURATION[1], pedestrianController.SLEEP_DURATION[2]))
		ped:moveHome()
	end
	
	if self.bedTime then
		return 
	end
end

function pedestrianController:handleEvent(event, hour)
	if event == weather.EVENTS.STARTED then
		for key, ped in ipairs(self.pedestrians) do
			ped:onRainStarted()
		end
	elseif event == weather.EVENTS.ENDED then
		for key, ped in ipairs(self.pedestrians) do
			ped:onRainEnded()
		end
	elseif event == timeOfDay.EVENTS.NEW_HOUR then
		if hour <= pedestrianController.BEDTIME_HOURS[1] or hour >= pedestrianController.BEDTIME_HOURS[2] then
			if not self.bedTime then
				for key, ped in ipairs(self.pedestrians) do
					ped:goHome()
				end
			end
			
			self.bedTime = true
		else
			self.bedTime = false
		end
	end
end

function pedestrianController:update(dt)
	if not self.active then
		return 
	end
	
	self.sleepUpdateTime = self.sleepUpdateTime - dt
	
	if self.sleepUpdateTime <= 0 and not self.bedTime then
		self.sleepUpdateTime = self.sleepUpdateTime + pedestrianController.SLEEP_UPDATE_COOLDOWN
		
		local index = 1
		local hour = timeOfDay:getHourTime()
		local weatherActive = weather:isActive()
		
		for i = 1, #self.sleepingPedestrians do
			local data = self.sleepingPedestrians[index]
			
			data.time = data.time - 1
			
			if data.time <= 0 and not weatherActive and hour >= data.pedestrian.wakeTime then
				table.insert(self.pedestrians, data.pedestrian)
				table.remove(self.sleepingPedestrians, index)
			else
				index = index + 1
			end
		end
	end
	
	for key, pedestrian in ipairs(self.pedestrians) do
		pedestrian:update(dt)
	end
end

function pedestrianController:spawnPedestrian()
	local randomIndex = game.worldObject:getRandomPedestrianTile()
	local x, y = game.worldObject:getFloorTileGrid():indexToWorld(randomIndex)
	local pedestrian = objects.create("pedestrian")
	
	pedestrian:setPos(x, y)
	pedestrian:setController(self)
	
	local time = pedestrianController.BEDTIME_HOURS[1]
	local delta = pedestrianController.WAKE_TIME_DELTA
	
	pedestrian:setWakeTime(math.random(time + delta[1], time + delta[2]))
	table.insert(self.pedestrians, pedestrian)
	
	self.allPedestrians[#self.allPedestrians + 1] = pedestrian
end

function pedestrianController:onFinishedPath(pedestrian)
	if pedestrian:getPathType() == pedestrian.PATH_TYPE.HOME then
		self:makeSleeping(pedestrian, math.random(pedestrianController.SLEEP_DURATION[1], pedestrianController.SLEEP_DURATION[2]))
	end
end

function pedestrianController:makeSleeping(pedestrian, duration)
	table.removeObject(self.pedestrians, pedestrian)
	
	local data = {
		pedestrian = pedestrian,
		time = duration
	}
	
	self.sleepingPedestrians[#self.sleepingPedestrians + 1] = data
end

function pedestrianController:draw()
	if not self.active then
		return 
	end
	
	local visPeds = self.quadTree:query(camera.x - game.WORLD_TILE_WIDTH, camera.y - game.WORLD_TILE_WIDTH, scrW / camera.scaleX + game.WORLD_TILE_WIDTH * 2, scrH / camera.scaleY + game.WORLD_TILE_HEIGHT * 2)
	local peds = self.visiblePeds
	local pedCount = #visPeds
	
	for i = 1, #visPeds do
		local ped = visPeds[i]
		local wasVis = self.previousPeds[ped]
		
		if not wasVis then
			ped:enterVisibilityRange()
			
			peds[#peds + 1] = ped
			self.previousPeds[ped] = true
		end
		
		visPeds[i] = nil
	end
	
	self.pedc = pedCount
	
	local rIdx = 1
	
	for i = 1, #peds do
		local ped = peds[rIdx]
		
		if cullingTester:shouldCull(ped) then
			ped:leaveVisibilityRange()
			
			self.previousPeds[ped] = nil
			
			table.remove(peds, rIdx)
		else
			ped:draw()
			
			rIdx = rIdx + 1
		end
	end
end
