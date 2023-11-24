musicPlaylist = {}
musicPlaylist.mtindex = {
	__index = musicPlaylist
}
musicPlaylist.fadeInTime = 0.25
musicPlaylist.fadeOutTime = 0.3333333333333333
musicPlaylist.shufflePlaylist = true
musicPlaylist.maxTracksInMemory = math.huge

function musicPlaylist.new(id)
	local new = {}
	
	setmetatable(new, musicPlaylist.mtindex)
	new:init(id)
	
	return new
end

function musicPlaylist:init(id, startVolume)
	if MOD_DIRECTORY then
		self.modDirectory = MOD_DIRECTORY
	end
	
	self.id = id
	self.volume = startVolume or 0
	self.trackPaths = {}
	self.tracks = {}
	self.loadedObjects = {}
	self.loadedObjectPaths = {}
	self.currentMusicIndexes = {}
	self.objectsByPath = {}
end

function musicPlaylist:getID()
	return self.id
end

function musicPlaylist:performPlaylistShuffle()
	for i = 1, #self.currentMusicIndexes do
		local randomIndex = math.random(1, #self.currentMusicIndexes)
		local trackIdx = self.currentMusicIndexes[randomIndex]
		
		table.remove(self.currentMusicIndexes, randomIndex)
		
		self.tracks[#self.tracks + 1] = trackIdx
	end
end

function musicPlaylist:resetMusicIndexes()
	for i = 1, #self.trackPaths do
		self.currentMusicIndexes[i] = i
	end
end

function musicPlaylist:queuePlaylistClear()
	self.clearQueue = true
end

function musicPlaylist:clearPlaylist()
	local objects = self.loadedObjects
	local paths = self.loadedObjectPaths
	
	while #objects > 0 do
		table.remove(objects, 1)
		
		local path = table.remove(paths, 1)
		
		self.objectsByPath[path] = nil
		
		cache.removeSound(path)
	end
end

function musicPlaylist:addTrack(path, loadTrack)
	self.trackPaths[#self.trackPaths + 1] = path
	
	if loadTrack then
		self:initTrack(path)
	end
end

function musicPlaylist:getTrackByPath(path)
	local obj = self.objectsByPath[path]
	
	if not obj then
		return self:initTrack(path)
	end
	
	return obj
end

function musicPlaylist:initTrack(path)
	if self.modDirectory then
		love.filesystem.clearFilesystem()
		love.filesystem.setCurrentDirectory(self.modDirectory)
		
		object = cache.newSound(path, "stream", musicPlayback.curVolume, false)
		
		love.filesystem.clearCurrentDirectory(self.modDirectory)
		love.filesystem.restoreFilesystem()
	else
		object = cache.newSound(path, "stream", musicPlayback.curVolume, false)
	end
	
	self.objectsByPath[path] = object
	
	table.insert(self.loadedObjects, object)
	
	self.loadedObjectPaths[#self.loadedObjects] = path
	
	return object
end

function musicPlaylist:initPlaylist(lastIndex)
	self:resetMusicIndexes()
	table.clearArray(self.tracks)
	
	if self.shufflePlaylist then
		self:performPlaylistShuffle()
	else
		for i = 1, #self.trackPaths do
			self.tracks[i] = i
		end
	end
	
	if lastIndex and self.tracks[1] == lastIndex then
		table.remove(self.tracks, 1)
		table.insert(self.tracks, math.min(math.random(2, #self.tracks), #self.tracks + 1), lastIndex)
	end
end

function musicPlaylist:togglePause()
	if self.paused then
		self:unpause()
	else
		self:pause()
	end
end

function musicPlaylist:pause()
	if self.currentTrack then
		self.currentTrack:pause()
	end
	
	self.paused = true
end

function musicPlaylist:unpause()
	if self.currentTrack then
		self.currentTrack:resume()
	end
	
	self.paused = false
end

function musicPlaylist:setFinishCallback(callback)
	self.finishCallback = callback
end

function musicPlaylist:setFirstTrack(trackID)
	self.firstTrack = trackID
end

function musicPlaylist:disable(fadeTime)
	self.disabled = true
end

function musicPlaylist:enable()
	self.disabled = false
	self.clearQueue = false
end

function musicPlaylist:pickTrack()
	self:verifyPlaylist()
	
	local objects = self.loadedObjects
	local paths = self.loadedObjectPaths
	local max = musicPlaylist.maxTracksInMemory
	
	if max < #objects then
		while max < #objects do
			table.remove(objects, 1)
			
			local path = table.remove(paths, 1)
			
			self.objectsByPath[path] = nil
			
			cache.removeSound(path)
		end
	end
	
	local index, object
	
	if self.firstTrack then
		object = self:getTrackByPath(self.firstTrack)
		
		for key, path in ipairs(self.trackPaths) do
			if path == self.firstTrack then
				index = key
				
				break
			end
		end
		
		self.firstTrack = nil
	end
	
	index = index or self.tracks[1]
	
	local listIndex = table.find(self.tracks, index)
	
	object = object or self:getTrackByPath(self.trackPaths[index])
	self.currentTrack = object
	self.currentTrackIndex = index
	
	self.currentTrack:setVolume(musicPlayback.curVolume)
	
	if self.currentTrack:play() and not self.currentTrack:isPlaying() then
		self.noOutputDevice = true
	end
	
	self.currentTrack:seek(0)
	
	if musicPlayback:getPlaybackVolume() == 0 then
		self.currentTrack:pause()
	end
	
	table.remove(self.tracks, listIndex)
end

function musicPlaylist:verifyPlaylist()
	if #self.tracks == 0 then
		self:initPlaylist(self.currentTrackIndex)
		
		if self.currentTrack and self.finishCallback then
			self:finishCallback()
		end
	end
end

function musicPlaylist:skipTrack()
	if self.currentTrack then
		self.currentTrack:stop()
	end
	
	self:pickTrack()
end

function musicPlaylist:setFadeInTime(time)
	self.fadeInTime = time
end

function musicPlaylist:getFadeInTime()
	return self.fadeInTime
end

function musicPlaylist:setFadeOutTime(time)
	self.fadeOutTime = time
end

function musicPlaylist:getFadeOutTime()
	return self.fadeOutTime
end

function musicPlaylist:setVolume(vol)
	self.volume = vol
end

function musicPlaylist:update(dt)
	if not self.paused then
		if self.disabled then
			if self.currentTrack then
				if self.fadeOutTime <= -1 then
					self.volume = 0
				else
					self.volume = math.approach(self.volume, 0, dt * self.fadeOutTime)
				end
				
				if self.volume == 0 then
					self.currentTrack:setVolume(sound:getVolumeLevel(sound.VOLUME_TYPES.MUSIC) * self.volume)
					self.currentTrack:stop()
					self:initPlaylist(self.currentTrackIndex)
					
					if self.clearQueue then
						self:clearPlaylist()
					end
					
					return false
				end
			end
		elseif self.noOutputDevice then
			if self.currentTrack:play() and self.currentTrack:isPlaying() then
				self:pickTrack()
				
				self.noOutputDevice = false
			end
		else
			if self.fadeInTime <= -1 then
				self.volume = 1
			else
				self.volume = math.approach(self.volume, 1, dt * self.fadeInTime)
			end
			
			local track = self.currentTrack
			
			if not track then
				self:pickTrack()
			elseif not track:isPlaying() then
				self:pickTrack()
			end
		end
		
		if self.currentTrack then
			self.currentTrack:setVolume(sound:getVolumeLevel(sound.VOLUME_TYPES.MUSIC) * self.volume)
		end
	end
	
	return true
end
