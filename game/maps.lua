maps = {}
maps.registered = {}
maps.registeredByID = {}

local defaultMapFuncs = {}

defaultMapFuncs.mtindex = {
	__index = defaultMapFuncs
}

function defaultMapFuncs:getFullPath()
	return game.MAP_DIRECTORY .. self.path .. game.MAP_FILE_FORMAT
end

function defaultMapFuncs:readMapFile()
	local path = self:getFullPath()
	local mapData, decompressed
	
	if self.modDirectory then
		love.filesystem.clearFilesystem()
		love.filesystem.setCurrentDirectory(self.modDirectory)
		
		mapData, decompressed = game.readMap(path)
		
		love.filesystem.clearCurrentDirectory(self.modDirectory)
		love.filesystem.restoreFilesystem()
	else
		mapData, decompressed = game.readMap(path)
	end
	
	return mapData, decompressed, path
end

function maps:registerNew(data)
	table.insert(maps.registered, data)
	
	maps.registeredByID[data.id] = data
	
	if MOD_DIRECTORY then
		data.modDirectory = MOD_DIRECTORY
	end
	
	setmetatable(data, defaultMapFuncs.mtindex)
end

function maps:getData(id)
	return maps.registeredByID[id]
end

function maps:getMapPath(mapID)
	local data = self.registeredByID[mapID]
	local path = game.MAP_DIRECTORY .. data.path .. game.MAP_FILE_FORMAT
	
	return path
end

function maps:readMap(mapID)
	local data = self.registeredByID[mapID]
	
	return data:readMapFile()
end

maps:registerNew({
	id = "back_in_the_game",
	path = "back_in_the_game"
})
maps:registerNew({
	id = "console_domination",
	path = "console_domination"
})
maps:registerNew({
	id = "pay_denbts",
	path = "pay_denbts"
})
maps:registerNew({
	id = "ravioli_and_pepperoni",
	path = "ravioli_and_pepperoni"
})
maps:registerNew({
	id = "story_mode",
	path = "story_mode"
})
maps:registerNew({
	id = "tutorial",
	path = "tutorial"
})
