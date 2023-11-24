love.audio.setDistanceModel("linear")

sound.manager = {}
sound.manager.sounds = {}
sound.manager.volumeModifier = 1
sound.manager.pitch = 1
sound.manager.paused = false

function sound.manager:process()
	local camX, camY = camera:getCenter()
	local curIndex = 1
	
	for i = 1, #self.sounds do
		local sound = self.sounds[curIndex]
		
		if sound.soundObj:isPlaying() then
			self:updateSound(sound, camX, camY)
			
			curIndex = curIndex + 1
		elseif sound.soundObj:isPaused() then
			curIndex = curIndex + 1
		elseif not sound.soundData.looping then
			table.remove(self.sounds, curIndex)
			sound.soundObj:stop()
			
			sound.processing = false
		end
	end
end

function sound.manager:isPlaying(soundID)
	for key, data in ipairs(self.sounds) do
		if data.soundData.name == soundID then
			if data.soundObj:isPlaying() then
				return true
			else
				return false
			end
		end
	end
	
	return false
end

function sound.manager:removeSound(soundData)
	soundData.soundObj:stop()
	
	soundData.processing = false
end

function sound.manager:clearAll()
	for key, sound in ipairs(self.sounds) do
		sound.soundObj:stop()
		
		self.sounds[key] = nil
		sound.processing = false
	end
end

function sound.manager:pause()
	for key, sound in ipairs(self.sounds) do
		if not sound.soundData.playAlways then
			sound.soundObj:pause()
		end
	end
	
	self.paused = true
end

function sound.manager:setPitch(pitch)
	self.pitch = pitch
	
	for key, sound in ipairs(self.sounds) do
		if not sound.soundObj:isPlaying() then
			sound.soundObj:setPitch(pitch)
		end
	end
end

function sound.manager:resume()
	if self.paused then
		for key, sound in ipairs(self.sounds) do
			if not sound.soundObj:isPlaying() then
				sound.soundObj:play()
			end
		end
		
		self.paused = false
	end
end

function sound.manager:play(soundName, parent, x, y, soundData)
	if type(soundName) == "table" then
		soundName = soundName[math.random(1, #soundName)]
	end
	
	local camX, camY = camera:getCenter()
	local soundContainer = sound.pickContainer(soundName, camX, camY)
	
	soundContainer.parent = parent
	soundContainer.soundX = x
	soundContainer.soundY = y
	
	local volumeLevel, soundX, soundY = self:getPlaybackData(soundContainer, camX, camY)
	
	if volumeLevel > 0 then
		soundContainer.soundObj:rewind()
		soundContainer.soundObj:setPitch(self.pitch)
		
		if not soundContainer.soundObj:play() then
			for key, data in ipairs(self.sounds) do
				if not data.soundData.noStopping then
					data.soundObj:stop()
					
					data.processing = false
					
					table.remove(self.sounds, key)
					self:_updateSound(soundContainer, volumeLevel, camX, camY, soundX, soundY)
					self:_play(soundContainer)
					
					break
				end
			end
		else
			self:_updateSound(soundContainer, volumeLevel, camX, camY, soundX, soundY)
			self:_play(soundContainer)
		end
	end
	
	return soundContainer
end

function sound.manager:_play(soundContainer)
	if self.paused and not soundContainer.soundData.playAlways then
		soundContainer.soundObj:pause()
	end
	
	if not soundContainer.processing then
		table.insert(self.sounds, soundContainer)
		
		soundContainer.processing = true
	end
end

function sound.manager:setGlobalVolumeModifier(global)
	self.volumeModifier = global
end

function sound.manager:updateSound(soundContainer, camX, camY)
	local volumeLevel, soundX, soundY = self:getPlaybackData(soundContainer, camX, camY)
	
	return self:_updateSound(soundContainer, volumeLevel, camX, camY, soundX, soundY)
end

function sound.manager:_updateSound(soundContainer, volumeLevel, camX, camY, soundX, soundY)
	if not soundContainer.soundData.noVolumeAdjust then
		soundContainer.curVolume = volumeLevel
		
		soundContainer.soundObj:setVolume(volumeLevel)
	end
	
	if volumeLevel > 0 then
		if soundX then
			soundContainer.soundObj:setPosition(soundX, soundY, 0)
			
			return true
		else
			if soundContainer.soundChannels == 1 then
				soundContainer.soundObj:setPosition(camX, camY, 0)
			end
			
			return true
		end
	end
	
	return false
end

function sound.manager:getSoundPosition(container)
	local soundX, soundY
	
	if container.parent then
		if container.parent:isValid() then
			soundX, soundY = container.parent:getCenterX(), container.parent:getCenterY()
		else
			container.parent = nil
		end
	else
		soundX = container.soundX
		soundY = container.soundY
	end
	
	return soundX, soundY
end

function sound.manager:getPlaybackData(soundContainer, camX, camY)
	local soundData = soundContainer.soundData
	
	if soundData.playAlways then
		return sound[soundData.volumeType] * soundData.volume
	end
	
	local soundX, soundY = self:getSoundPosition(soundContainer)
	local volumeLevel, volumeScale = soundData.volume, 1
	
	if soundX and soundY and soundData.maxDistance then
		local dist = math.distXY(camX, soundX, camY, soundY)
		
		if dist > soundData.fadeDistance then
			if dist - soundData.fadeDistance > soundData.maxDistance then
				volumeScale = 0
			else
				local relativeDist = dist - soundData.fadeDistance
				
				volumeScale = math.clamp(1 - relativeDist / soundData.maxDistance, 0, 1)
			end
		else
			volumeScale = 1
		end
	end
	
	if not soundContainer.soundData.noVolumeAdjust then
		volumeScale = volumeScale * self.volumeModifier
	end
	
	return volumeScale * volumeLevel * sound[soundData.volumeType], soundX, soundY
end
