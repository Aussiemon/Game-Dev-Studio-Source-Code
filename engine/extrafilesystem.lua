local screenshotName = "screenshot"
local screenshotFormat = "png"
local screenshotExtension = "." .. screenshotFormat

function love.filesystem.countScreenshots()
	local screenshotCount = 0
	
	for k, v in ipairs(love.filesystem.getDirectoryItems("")) do
		if v:find(screenshotName) and v:find(screenshotExtension) then
			screenshotCount = screenshotCount + 1
		end
	end
	
	return screenshotCount
end

function love.filesystem.writeScreenshot(screenshotData)
	local screenshotCount = love.filesystem.countScreenshots() + 1
	
	screenshotData:encode(screenshotFormat, screenshotName .. screenshotCount .. screenshotExtension)
end

love.filesystem.modFolder = "mods/"
love.filesystem.loadedMods = {}
love.filesystem.modEnv = nil
love.filesystem.modEnvInitializer = nil
love.filesystem.mainModFile = nil
love.filesystem.loadedModDirectories = {}
love.filesystem.failedLoadModDirectories = {}

function love.filesystem.getModFolder(dir, release)
	if release then
		return string.gsub(dir, BASE_GAME_FOLDER, "")
	end
	
	return dir
end

function love.filesystem.clearFilesystem()
	local dirs = love.filesystem.getCurrentDirectory()
	
	for key, dir in ipairs(dirs) do
		love.filesystem.clearCurrentDirectory(dir)
	end
	
	love.filesystem.lastDirectoryList = dirs
end

function love.filesystem.restoreFilesystem()
	for key, dir in ipairs(love.filesystem.lastDirectoryList) do
		love.filesystem.setCurrentDirectory(dir)
	end
	
	love.filesystem.lastDirectoryList = nil
end

function love.filesystem.getModsFolder(release)
	if release then
		return love.filesystem.getWorkingDirectory() .. "/", BASE_GAME_FOLDER .. love.filesystem.modFolder
	end
	
	return love.filesystem.getSource() .. "/", love.filesystem.modFolder
end

love.filesystem.loadedMods = 0

function love.filesystem.loadMods()
	local dirs = love.filesystem.getCurrentDirectory()
	local source, modFolder = love.filesystem.getModsFolder(RELEASE)
	local items = love.filesystem.getDirectoryItems(modFolder)
	local modFolders = {}
	local realIndex = 1
	
	for i = 1, #items do
		local startPath = items[realIndex]
		
		modFolders[realIndex] = startPath
		
		local path = modFolder .. startPath .. "/"
		
		if not love.filesystem.isDirectory(path) then
			table.remove(items, realIndex)
		else
			items[realIndex] = path
			realIndex = realIndex + 1
		end
	end
	
	for key, path in ipairs(dirs) do
		love.filesystem.clearCurrentDirectory(path)
	end
	
	local loadedMods = love.filesystem.loadedModDirectories
	local failedLoad = love.filesystem.failedLoadModDirectories
	
	for key, dir in ipairs(items) do
		local folder = modFolders[key]
		
		if love.filesystem.loadLocalMod(source .. love.filesystem.getModFolder(dir, RELEASE) .. "files/", folder) then
			loadedMods[#loadedMods + 1] = folder
			love.filesystem.loadedMods = love.filesystem.loadedMods + 1
		else
			failedLoad[#failedLoad + 1] = folder
		end
	end
	
	for key, path in ipairs(dirs) do
		love.filesystem.setCurrentDirectory(path)
	end
end

function love.filesystem.loadLocalMod(path, modFolder)
	MOD_DIRECTORY = path
	
	love.filesystem.setCurrentDirectory(path)
	
	local success = false
	local handle = io.open(path .. love.filesystem.mainModFileFull)
	
	if not handle then
		print("failed to load mod (no main.lua)", path)
	else
		handle:close()
		love.filesystem.modEnvInitializer(path, "mods/" .. modFolder)(love.filesystem.mainModFile)
		
		success = true
	end
	
	love.filesystem.clearCurrentDirectory(path)
	
	MOD_DIRECTORY = nil
	
	return success
end
