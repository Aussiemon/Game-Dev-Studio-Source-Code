sound = {}
sound.timedSounds = {}
sound.maxIdenticalSounds = 8
sound.VOLUME_TYPES = {
	AMBIENT = "ambientVolume",
	MISC = "miscVolume",
	SPEECH = "speechVolume",
	MUSIC = "musicVolume",
	EFFECTS = "effectVolume"
}
sound.VOLUME_TYPE_DISPLAY = {
	[sound.VOLUME_TYPES.EFFECTS] = _T("EFFECT_VOLUME", "Effect volume"),
	[sound.VOLUME_TYPES.AMBIENT] = _T("AMBIENT_SOUND_VOLUME", "Ambient sound volume"),
	[sound.VOLUME_TYPES.SPEECH] = _T("SPEECH_VOLUME", "Speech volume"),
	[sound.VOLUME_TYPES.MUSIC] = _T("MUSIC_VOLUME", "Music volume"),
	[sound.VOLUME_TYPES.MISC] = _T("MISC_SOUND_VOLUME", "Miscellaneous sound volume")
}
sound.defaultVolumeLevels = {}
sound.configFile = "sound.cfg"
sound.initialText = {
	"// The sound settings have the following minimum and maximum values:\n"
}
sound.settingLibraries = {
	sound = {}
}

local soundLimits = {
	default = 1,
	min = 0,
	max = 1
}

sound.settingLimits = {
	effectVolume = soundLimits,
	musicVolume = soundLimits,
	speechVolume = soundLimits,
	miscVolume = soundLimits,
	ambientVolume = soundLimits
}
registered.soundChannels = {}
registered.soundData = {}

local soundContainer = {}

soundContainer.mtindex = {
	__index = soundContainer
}
soundContainer.soundObj = nil
soundContainer.soundData = nil
soundContainer.curVolume = nil
soundContainer.volumeType = nil

function soundContainer.new(soundObj, soundData)
	local new = {}
	
	setmetatable(new, soundContainer.mtindex)
	new:init(soundObj, soundData)
	
	return new
end

function soundContainer:init(soundObj, soundData)
	self.soundObj = soundObj
	self.soundChannels = soundObj:getChannels()
	self.soundData = soundData
	self.curVolume = soundData.volume
	self.volumeType = soundData.volumeType
end

function soundContainer:remove()
	self.soundObj:stop()
end

function register.newSoundData(soundData, numSounds)
	soundData.volumeType = soundData.volumeType or sound.VOLUME_TYPES.EFFECTS
	soundData.volume = soundData.volume or 0.35
	soundData.maxDistance = soundData.maxDistance
	
	if soundData.maxDistance then
		if soundData.fadeDistance then
			soundData.fadeDistance = soundData.fadeDistance
		else
			soundData.fadeDistance = soundData.maxDistance * (soundData.fadeDistanceScale or 0.25)
		end
	end
	
	registered.soundData[soundData.name] = soundData
	
	if numSounds then
		register.newSoundChannel(soundData.name, numSounds)
	end
end

function register.newSoundChannel(soundDataName, numSounds)
	local soundData = sound.getSoundData(soundDataName)
	
	if type(soundData.sound) == "table" then
		for k, v in ipairs(soundData.sound) do
			registered.soundChannels[v] = registered.soundChannels[v] or {}
			
			local source = cache.newSoundNamed(v, v, soundData.soundType, soundData.volume, soundData.looping)
			
			table.insert(registered.soundChannels[v], sound.makeSoundContainer(soundData, source))
			
			if numSounds > 1 then
				for i = 1, numSounds - 1 do
					table.insert(registered.soundChannels[v], sound.makeSoundContainer(soundData, source:clone()))
				end
			end
		end
	else
		registered.soundChannels[soundData.sound] = registered.soundChannels[soundData.sound] or {}
		
		local source = cache.newSoundNamed(soundData.name or soundData.sound, soundData.sound, soundData.soundType, soundData.volume, soundData.looping)
		
		table.insert(registered.soundChannels[soundData.sound], sound.makeSoundContainer(soundData, source))
		
		if numSounds > 1 then
			for i = 1, numSounds do
				table.insert(registered.soundChannels[soundData.sound], sound.makeSoundContainer(soundData, source:clone()))
			end
		end
	end
	
	local destination = registered.soundChannels[soundData.name]
end

function sound.getVolumeTypeName(type)
	return sound.VOLUME_TYPE_DISPLAY[type]
end

function sound.pickContainer(snd, camX, camY)
	local soundChannelTable = registered.soundChannels[snd]
	
	for k, v in ipairs(soundChannelTable) do
		if not v.soundObj:isPlaying() or not sound.manager:updateSound(v, camX, camY) then
			return v
		end
	end
	
	return soundChannelTable[math.random(1, #soundChannelTable)]
end

function sound.getSoundData(name)
	return registered.soundData[name]
end

function sound.makeSoundContainer(soundData, soundObj)
	local newSoundContainer = soundContainer.new(soundObj, soundData)
	
	return newSoundContainer
end

function sound:setupVolumeLevels()
	local soundValues = self.settingLibraries.sound
	
	for key, value in pairs(self.VOLUME_TYPES) do
		soundValues[#soundValues + 1] = value
		self[value] = 1
	end
end

function sound:setVolumeLevel(type, level)
	self[type] = level
end

function sound:getVolumeLevel(type)
	return self[type]
end

sound:setupVolumeLevels()

function sound:saveSoundSettings()
	configLoader:writeFile(self.configFile, self.initialText, nil, self.settingLibraries, self.settingLimits)
end

function sound:loadSoundSettings()
	if not configLoader:readFile(self.configFile, self.settingLimits) then
		self:saveSoundSettings()
	end
end

function sound:remove()
	table.clear(sound.timedSounds)
end

function sound:play(desiredSound, parent, x, y)
	local soundData
	
	if type(desiredSound) == "string" then
		soundData = sound.getSoundData(desiredSound)
	else
		soundData = desiredSound
	end
	
	return self.manager:play(soundData.sound, parent, x, y, soundData)
end

function sound:think()
	for k, v in ipairs(self.timedSounds) do
		if curTime > v.time then
			sound:play(v.snd, nil, v.x, v.y)
			
			self.timedSounds[k] = nil
		end
	end
	
	self.manager:process()
end

function sound.addTimed(snd, time, x, y)
	table.insert(sound.timedSounds, {
		snd = snd,
		time = curTime + time,
		x = x,
		y = y
	})
end

require("engine/soundmanager")
