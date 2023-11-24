ambientSounds = {}
ambientSounds.scanRangeX = 10
ambientSounds.scanRangeY = 5
ambientSounds.scanFrequency = 1
ambientSounds.soundPickFrequency = 1
ambientSounds.loopCheckFrequency = 0.5
ambientSounds.soundDelays = {}
ambientSounds.loopingSounds = {}
ambientSounds.loopingSoundsMap = {}
ambientSounds.blocks = {}
ambientSounds.playType = {
	LOOP = 2,
	PLAYONCE = 1
}
ambientSounds.registered = {}
ambientSounds.registeredByID = {}
ambientSounds.totalSounds = 0

local baseSoundFuncs = {}

baseSoundFuncs.mtindex = {
	__index = baseSoundFuncs
}

function baseSoundFuncs:meetsRequirements()
	return true
end

function ambientSounds.registerSound(tbl, inherit)
	ambientSounds.totalSounds = ambientSounds.totalSounds + 1
	tbl.vol = tbl.vol or 0.35
	tbl.fadeInSpeed = tbl.fadeInSpeed or 0.2
	tbl.fadeOutSpeed = tbl.fadeOutSpeed or 0.12
	
	if inherit then
		local class = ambientSounds.registeredByID[inherit]
		
		tbl.baseClass = class
		
		setmetatable(tbl, class.mtindex)
	else
		tbl.baseClass = tbl
		
		setmetatable(tbl, baseSoundFuncs.mtindex)
	end
	
	tbl.mtindex = {
		__index = tbl
	}
	
	table.inserti(ambientSounds.registered, tbl)
	
	ambientSounds.registeredByID[tbl.id] = tbl
end

function ambientSounds:init()
	self.nextScan = 0
	self.nextSoundPick = 0
	self.nextLoopCheck = 0
end

function ambientSounds:remove()
	for k, v in pairs(self.soundDelays) do
		self.soundDelays[k] = nil
	end
	
	while #self.loopingSounds > 0 do
		local data = self.loopingSounds[#self.loopingSounds]
		
		sound.manager:removeSound(data.soundData)
		table.remove(self.loopingSounds, #self.loopingSounds)
		
		self.loopingSoundsMap[data.data.id] = nil
	end
end

function ambientSounds:update(dt, skipTime)
	local step = 0
	
	if not skipTime then
		step = timeline.paused and 0 or dt * math.max(0, timeline.speed)
	end
	
	if self.nextSoundPick <= 0 then
		self:pickAppropriateSound()
		
		self.nextSoundPick = self.soundPickFrequency
	else
		self.nextSoundPick = self.nextSoundPick - step
	end
	
	if self.nextLoopCheck <= 0 then
		self:pickLoop()
		self:checkLoopingSounds()
		
		self.nextLoopCheck = self.loopCheckFrequency
	else
		self.nextLoopCheck = self.nextLoopCheck - step
	end
	
	self:loopSoundLogic(dt)
end

function ambientSounds:loopSoundLogic(step)
	local ambientVolume = sound:getVolumeLevel(sound.VOLUME_TYPES.AMBIENT)
	local key = 1
	
	for i = 1, #self.loopingSounds do
		local v = self.loopingSounds[key]
		local soundData = v.data
		local speed
		
		if v.fade then
			v.targetvol = 0
			speed = soundData.fadeOutSpeed
			v.vol = math.approach(v.vol, v.targetvol * ambientVolume, speed * step)
			
			if v.vol == 0 then
				table.remove(self.loopingSounds, key)
				
				self.loopingSoundsMap[soundData.id] = nil
				
				sound.manager:removeSound(v.soundData)
			else
				key = key + 1
			end
		else
			v.targetvol = v.soundvol
			speed = soundData.fadeInSpeed
			key = key + 1
			v.vol = math.approach(v.vol, v.targetvol * ambientVolume, speed * step)
		end
		
		if not v.sound:isPlaying() and not v.sound:isPaused() then
			v.sound:play()
		end
		
		v.sound:setVolume(v.vol)
	end
end

function ambientSounds:checkLoopingSounds()
	for k, data in ipairs(self.loopingSounds) do
		if not data.data:meetsRequirements() then
			data.fade = true
		else
			data.fade = false
		end
	end
end

function ambientSounds:isSoundLooping(id)
	if not self.loopingSoundsMap[id] then
		return false
	end
	
	return true
end

function ambientSounds:checkBlockTable(b, i)
	if not b then
		return true
	elseif not b[i] then
		return false
	end
	
	return true
end

function ambientSounds:loopNewSound(tbl)
	if not self:isSoundLooping(tbl.id) then
		local soundID
		
		if type(tbl.sound) == "table" then
			soundID = tbl.sound[math.random(1, #tbl.sound)]
		else
			soundID = tbl.sound
		end
		
		local returned = sound:play(soundID)
		
		self.loopingSounds[#self.loopingSounds + 1] = {
			vol = 0,
			sound = returned.soundObj,
			soundData = returned,
			soundvol = tbl.vol,
			data = tbl
		}
		self.loopingSoundsMap[tbl.id] = true
	end
end

function ambientSounds:pickLoop()
	local loop = ambientSounds.playType.LOOP
	
	for key, soundData in ipairs(ambientSounds.registered) do
		if soundData.type == loop and soundData:meetsRequirements() and not self.loopingSoundsMap[soundData.id] then
			self:loopNewSound(soundData)
		end
	end
end

function ambientSounds:pickAppropriateSound(t, maxsnd)
	maxsnd = maxsnd or 1
	
	local total = 0
	local ambientVolume = sound:getVolumeLevel(sound.VOLUME_TYPES.AMBIENT)
	local playOnce = ambientSounds.playType.PLAYONCE
	local time = timeline.passedTime
	
	for k, data in ipairs(ambientSounds.registered) do
		if (not self.soundDelays[k] or time > self.soundDelays[k]) and data:meetsRequirements() then
			if data.type == playOnce then
				local soundID
				
				if type(data.sound) == "table" then
					soundID = data.sound[math.random(1, #data.sound)]
				else
					soundID = data.sound
				end
				
				local returned = sound:play(soundID)
				
				returned.soundObj:setVolume(data.vol * ambientVolume)
				
				self.soundDelays[k] = time + math.randomf(data.frequency.min, data.frequency.max)
			end
			
			total = total + 1
		end
	end
end

require("game/basic_ambient_sounds")
