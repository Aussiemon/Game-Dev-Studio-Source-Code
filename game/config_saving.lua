local bitser = require("engine/bitser")

configLoader:associateSaving("game", "showingConsole", function(value)
	return game.showingConsole and 1 or 0
end)
configLoader:associateLoading("game", "showingConsole", function(value)
	local cnsl = tonumber(value)
	
	if cnsl == 1 then
		love._openConsole()
	end
end)
configLoader:associateSaving("render", "resolution", function()
	local w, h = resolutionHandler:getDesiredResolution()
	
	return w .. "x" .. h
end)
configLoader:associateLoading("render", "resolution", function(value)
	local values = string.explode(value, "x")
	
	resolutionHandler:setDesiredResolution(tonumber(values[1]), tonumber(values[2]))
end)
configLoader:associateSaving("render", "vsync", function()
	local vsync = resolutionHandler:getVsync()
	
	return vsync and 1 or 0
end)
configLoader:associateLoading("render", "vsync", function(value)
	local vsync = tonumber(value)
	
	if vsync == 1 then
		resolutionHandler:setVsync(true)
	else
		resolutionHandler:setVsync(false)
	end
end)
configLoader:associateSaving("render", "screenMode", function()
	return resolutionHandler:getScreenModeNumber()
end)
configLoader:associateLoading("render", "screenMode", function(value)
	resolutionHandler:setScreenMode(tonumber(value))
end)
configLoader:associateSaving("render", "display", function()
	return resolutionHandler:getDisplay() or 1
end)
configLoader:associateLoading("render", "display", function(value)
	local value = math.min(love.window.getDisplayCount(), tonumber(value))
	
	resolutionHandler:setDisplay(value, true)
end)
configLoader:setLoadCallback(function(data)
end)
configLoader:associateLoading("shadowShader", "qualityPreset", function(value)
	shadowShader:setQualityPreset(tonumber(value))
end)
configLoader:associateSaving("buildingShadows", "enabled", function()
	return buildingShadows.enabled and 1 or 0
end)
configLoader:associateLoading("buildingShadows", "enabled", function(value)
	if tonumber(value) >= 1 then
		buildingShadows:enable()
	else
		buildingShadows:disable()
	end
end)
configLoader:associateLoading("lightingManager", "qualityPreset", function(value)
	lightingManager:setQualityPreset(tonumber(value))
end)
configLoader:associateLoading("weather", "qualityPreset", function(value)
	weather:setQualityPreset(tonumber(value))
end)
configLoader:associateSaving("autosave", "enabled", function()
	return autosave.enabled and 1 or 0
end)
configLoader:associateLoading("autosave", "enabled", function(value)
	if tonumber(value) >= 1 then
		autosave:enable()
	else
		autosave:disable()
	end
end)
configLoader:associateSaving("autosave", "savePeriod", function()
	return autosave.savePeriod
end)
configLoader:associateLoading("autosave", "savePeriod", function(value)
	local value = tonumber(value)
	
	autosave:setSavePeriod(value or autosave.DEFAULT_SAVE_PERIOD)
end)
configLoader:associateSaving("saveSnapshot", "disabled", function()
	return saveSnapshot.disabled and 1 or 0
end)
configLoader:associateLoading("saveSnapshot", "disabled", function(value)
	local value = tonumber(value)
	
	if value == 1 then
		saveSnapshot:disable()
	else
		saveSnapshot:enable()
	end
end)
configLoader:associateSaving("keyBinding", "assignedKeys", function()
	return keyBinding:save()
end)
configLoader:associateLoading("keyBinding", "assignedKeys", function(keyBinds)
	keyBinding:load(bitser.loads(keyBinds))
end)

if steam then
	configLoader:associateSaving("workshop", "disabledMods", function()
		return bitser.dumps(workshop:getDisabledModMap())
	end)
	configLoader:associateLoading("workshop", "disabledMods", function(val)
		return workshop:setDisabledModMap(bitser.loads(val))
	end)
end

configLoader:associateSaving("game", "instantPopups", function()
	return game.instantPopups and 1 or 0
end)
configLoader:associateLoading("game", "instantPopups", function(value)
	local value = tonumber(value)
	
	if value == 1 then
		game.instantPopups = true
	else
		game.instantPopups = false
	end
end)
configLoader:associateLoading("pedestrianController", "pedestrianCountIndex", function(data)
	pedestrianController:setPedestrianCountIndex(data)
end)

game.USER_PREFERENCES_FILE = "user_settings.cfg"
game.CONFIG_TOP_TEXT = "// the following are minimum and maximum values for each setting\n// if a setting says <undefined> - that means there are no specific limits set on it, but you shouldn't mess with it unless you know what you're doing\n// boolean type values (true/false) are not used, instead you'll see 0 and 1 for \"false\" and \"true\"\n\n"

local saveList = {
	render = {
		"vsync",
		"resolution",
		"screenMode",
		"display"
	},
	shadowShader = {
		"qualityPreset"
	},
	lightingManager = {
		"qualityPreset"
	},
	autosave = {
		"enabled",
		"savePeriod"
	},
	saveSnapshot = {
		"disabled"
	},
	keyBinding = {
		"assignedKeys"
	},
	weather = {
		"qualityPreset"
	},
	buildingShadows = {
		"enabled"
	},
	game = {
		"showingConsole",
		"instantPopups"
	},
	pedestrianController = {
		"pedestrianCountIndex"
	}
}

if steam then
	saveList.workshop = {
		"disabledMods"
	}
end

function game.saveUserPreferences()
	configLoader:writeFile(game.USER_PREFERENCES_FILE, game.CONFIG_TOP_TEXT, nil, saveList, nil)
	sound:saveSoundSettings()
end

function game.loadUserPreferences()
	if not configLoader:readFile(game.USER_PREFERENCES_FILE) then
		game.setupDefaultPreferences()
		game.saveUserPreferences()
	end
	
	sound:loadSoundSettings()
	resolutionHandler:applyScreenMode()
end

function game.setupDefaultPreferences()
	keyBinding:assignDefaultKeys()
end
