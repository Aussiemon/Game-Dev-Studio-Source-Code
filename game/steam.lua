local function makeRequire(path, modSource, skipEnv, envTable)
	return function(mainFile)
		mainFile = mainFile .. ".lua"
		
		local f, err = loadstring(io.open(path .. "/" .. mainFile, "r"):read("*all"), modSource .. mainFile)
		
		if err then
			error(err)
		end
		
		if not skipEnv then
			for k, v in pairs(MODENV) do
				envTable[k] = v
			end
			
			envTable.require = makeRequire(path, modSource, true, envTable)
		end
		
		setfenv(f, envTable)
		
		return f()
	end
end

local function makeRequireMethod(path, modSource)
	if modSource and modSource ~= "" then
		modSource = modSource .. "/"
	else
		modSource = ""
	end
	
	return makeRequire(path, modSource, nil, {})
end

love.filesystem.modEnv = MODENV
love.filesystem.modEnvInitializer = makeRequireMethod
love.filesystem.mainModFile = "main"
love.filesystem.mainModFileFull = love.filesystem.mainModFile .. ".lua"

if not steam then
	return 
end

steam.makeRequireMethod = makeRequireMethod

function steam.OnAchievementSet(id)
	achievements:setAchievement(id)
end

function steam.OnUserStatsReceived(statData)
	achievements:setStatData(statData)
end

function steam.OnAchievementsReceived(achvList)
	achievements:setAchievements(achvList)
end

steam.MAIN_MOD_FILE = "main"
steam.MAIN_MOD_FILE_FULL = "main.lua"

function steam.LoadMod(path)
	MOD_DIRECTORY = path
	
	love.filesystem.setCurrentDirectory(path)
	
	local handle = io.open(path .. "/" .. steam.MAIN_MOD_FILE_FULL)
	local success = false
	
	if not handle then
		print("failed to load mod (no main.lua)", path)
	else
		handle:close()
		steam.makeRequireMethod(path)(steam.MAIN_MOD_FILE)
		
		love.filesystem.loadedMods = love.filesystem.loadedMods + 1
		success = true
	end
	
	love.filesystem.clearCurrentDirectory(path)
	
	MOD_DIRECTORY = nil
	
	return success
end

function steam.LoadMods()
	workshop:loadMods()
end

function steam.OnWorkshopUploadSuccess()
	workshop:onUploadedItem()
end

function steam.OnWorkshopUploadFailure()
	workshop:onFailedUploadItem()
end

function steam.OnWorkshopCreationSuccess()
	workshop:onCreatedItem()
end

function steam.ReportCreationFailureToLua()
	workshop:onFailedCreateItem()
end

function steam.OnModQueryFinished(data, queryType, queryPage, lastPage)
	workshop:onModQueryFinished(data, queryType, queryPage, lastPage)
end

function steam.OnPreviewImageReceived(id, data)
	workshop:onPreviewImageReceived(id, data)
end

function steam.OnPreviewImageDownloadFailed()
	workshop:onPreviewImageDownloadFailed()
end

function steam.OnModQueryLastPage(queryType, queriedPage)
	workshop:onModQueryLastPage(queryType, queriedPage)
end
