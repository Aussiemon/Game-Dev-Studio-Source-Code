musicPlayback = {}
musicPlayback.folder = "music/"
musicPlayback.files = {
	"placeholder1.mp3",
	"placeholder2.mp3",
	"placeholder3.mp3"
}

sound:setVolumeLevel(sound.VOLUME_TYPES.MUSIC, 0.08)

musicPlayback.curVolume = sound.musicVolume
musicPlayback.readMusicFolderContents = true
musicPlayback.shufflePlaylist = true
musicPlayback.playlists = {}
musicPlayback.activePlaylists = {}
musicPlayback.PLAYLIST_IDS = {
	GAMEPLAY_ALL = "gameplay_all",
	GAMEPLAY_PARTIAL = "gameplay",
	MENU = "menu"
}

function musicPlayback:addPlaylist(playlist)
	self.playlists[playlist:getID()] = playlist
end

function musicPlayback:getPlaylist(id)
	return self.playlists[id]
end

function musicPlayback:setPlaylist(id)
	local playlistObject = self.playlists[id]
	local canAdd = true
	
	playlistObject:enable()
	
	if self.curVolume == 0 then
		playlistObject:pause()
	end
	
	local snapToZero = playlistObject:getFadeInTime() <= -1
	
	for key, playlist in ipairs(self.activePlaylists) do
		if playlist == playlistObject then
			canAdd = false
		else
			playlist:disable()
			playlist:queuePlaylistClear()
			
			if snapToZero then
				playlist:setVolume(0)
			end
		end
	end
	
	if canAdd then
		table.insert(self.activePlaylists, playlistObject)
	end
end

function musicPlayback:init()
end

function musicPlayback:getPlaybackVolume()
	return self.curVolume
end

function musicPlayback:setPlaybackVolume(vol)
	self.curVolume = vol
	
	if self.curVolume == 0 then
		for i = 1, #self.activePlaylists do
			local playlist = self.activePlaylists[i]
			
			playlist:pause()
		end
	else
		for i = 1, #self.activePlaylists do
			local playlist = self.activePlaylists[i]
			
			playlist:unpause()
		end
	end
end

function musicPlayback:update(dt)
	local curIndex = 1
	
	for i = 1, #self.activePlaylists do
		local playlist = self.activePlaylists[curIndex]
		
		if playlist:update(dt) then
			curIndex = curIndex + 1
		else
			table.remove(self.activePlaylists, curIndex)
		end
	end
end

require("game/music_playlist")

local gameplayPlaylist = musicPlaylist.new(musicPlayback.PLAYLIST_IDS.GAMEPLAY_ALL)

musicPlayback.GAMEPLAY_TRACKS_FOLDER = musicPlayback.folder .. "gameplay/"

local realFolder = musicPlayback.GAMEPLAY_TRACKS_FOLDER

if musicPlayback.readMusicFolderContents then
	for key, filename in ipairs(love.filesystem.getDirectoryItems(realFolder)) do
		local pathToFile = realFolder .. filename
		
		if not love.filesystem.isDirectory(pathToFile) then
			gameplayPlaylist:addTrack(pathToFile)
		end
	end
else
	for key, filename in ipairs(musicPlayback.files) do
		if not love.filesystem.isDirectory(filename) then
			gameplayPlaylist:addTrack(musicPlayback.folder .. filename)
		end
	end
end

musicPlayback:addPlaylist(gameplayPlaylist)

local partialGameplayPlaylist = musicPlaylist.new(musicPlayback.PLAYLIST_IDS.GAMEPLAY_PARTIAL)

partialGameplayPlaylist:addTrack(realFolder .. "dream_project.ogg")
partialGameplayPlaylist:addTrack(realFolder .. "night_owl.ogg")
partialGameplayPlaylist:addTrack(realFolder .. "work_of_love.ogg")
partialGameplayPlaylist:addTrack(realFolder .. "clean_code.ogg")
partialGameplayPlaylist:addTrack(realFolder .. "flow.ogg")
partialGameplayPlaylist:addTrack(realFolder .. "morning_session.ogg")
partialGameplayPlaylist:addTrack(realFolder .. "content_content.ogg")
musicPlayback:addPlaylist(partialGameplayPlaylist)

local mainMenuPlaylist = musicPlaylist.new(musicPlayback.PLAYLIST_IDS.MENU)

mainMenuPlaylist:addTrack(musicPlayback.folder .. "menu/" .. "menu.ogg")
musicPlayback:addPlaylist(mainMenuPlaylist)
