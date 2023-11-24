local bitser = require("engine/bitser")

game.showingConsole = false
game.canInitHUD = true
game.canRetire = true
game.DLCS = {
	"developer_commentary"
}
game.STARTING_FUND_AMOUNT = 10000000
game.BASE_SALE_AMOUNT = 12000
game.MAX_TEAMS = 20
game.WORLD_GRID_WIDTH = 200
game.WORLD_GRID_HEIGHT = 100
game.WORLD_TILE_WIDTH = 48
game.WORLD_TILE_HEIGHT = 48
game.BASE_CAMERA_BOUNDARY = 0
game.time = 0
game.hudElements = {}
game.dynamicObjects = {}
game.objectSpriteBatches = {}
game.saleDisplays = {}
game.bufferedEvents = {}
game.DEFAULT_STUDIO_START_W = 4
game.DEFAULT_STUDIO_START_H = 4
game.STUDIO_START_W = 4
game.STUDIO_START_H = 4
game.STUDIO_START_X = math.round(game.WORLD_GRID_WIDTH / 2 - game.STUDIO_START_W * 0.5)
game.STUDIO_START_Y = 12
game.STUDIO_START_TILE = "wood_floor"
game.UNIQUE_ID_COUNTER = 1
game.UNIQUE_PROJECT_ID = 1
game.UNIQUE_TEAM_ID = 1
game.SAVE_DIRECTORY = "savegames/"
game.SAVE_FILE_NAME = "save_"
game.SAVE_FILE_FORMAT = ".gds"
game.SAVE_FILE_FORMAT_PREVIEW = "_preview"
game.MAP_DIRECTORY = "maps/"
game.MAP_FILE_FORMAT = ".gdsmap"
game.MAP_COMPRESSION_ALGORITHM = "zlib"
game.MAP_COMPRESSION_LEVEL = 9
game.RESEARCH_MIN_EXP = 5
game.RESEARCH_MAX_EXP = 10
game.RESEARCH_EXP_MIN_TIME = 1
game.RESEARCH_EXP_MAX_TIME = 1
game.RESEARCH_WORK_AMOUNT_MULTIPLIER = 0.75
game.PROJECT_EXP_GAIN_MIN = 15
game.PROJECT_EXP_GAIN_MAX = 20
game.PROJECT_EXP_GAIN_TIME_MIN = 1.5
game.PROJECT_EXP_GAIN_TIME_MAX = 2
game.PREVIEW_SCREENSHOT_SCALER = 4
game.MAIN_DOOR_FACT = "main_door"
game.IGNORE_WALLS_FACT = "ignore_walls_fact"
game.DEFAULT_GAMETYPE = "standard"
game.GAME_OVER_TIPS = {}
game.SHOW_SPLASH_SCREEN = true
game.GAME_DATA_FILE = "gamedata.gdsd"
game.RANDOMIZATION_STATES = {
	GENRE_QUALITY_MATCHING = 2,
	THEME_GENRE_MATCHING = 1,
	PLATFORM_STATS = 4,
	STARTING_GENRES = 8
}
game.UI_COLORS = {
	WHITE = color(255, 255, 255, 255),
	IMPORTANT_1 = color(247, 226, 190, 255),
	IMPORTANT_2 = color(238, 247, 190, 255),
	IMPORTANT_3 = color(217, 232, 185, 255),
	AVAILABLE = color(188, 224, 166, 255),
	LIGHT_RED = color(255, 225, 216, 255),
	RED = color(255, 138, 127, 255),
	DEEP_RED = color(255, 81, 81, 255),
	DARK_RED = color(188, 58, 56, 255),
	GREEN = color(217, 255, 191, 255),
	GREEN_2 = color(215, 255, 204, 255),
	LIGHT_GREEN = color(174, 204, 153, 255),
	WHITE = color(255, 255, 255, 255),
	BLACK = color(0, 0, 0, 255),
	LIGHT_GREY = color(200, 200, 200, 255),
	GREY = color(150, 150, 150, 255),
	DARK_GREY = color(100, 100, 100, 255),
	LIGHT_BLUE = color(187, 211, 234, 255),
	LIGHT_BLUE_TEXT = color(204, 230, 255, 255),
	DARK_LIGHT_BLUE = color(155, 175, 193, 255),
	VERY_DARK_LIGHT_BLUE = color(82, 92, 102, 255),
	CATEGORY_SEPARATOR_COLOR = color(201, 206, 171, 255),
	LINE_COLOR_ONE = color(0, 0, 0, 75),
	LINE_COLOR_TWO = color(0, 0, 0, 50),
	ORANGE = color(255, 121, 76, 255),
	YELLOW = color(252, 255, 196, 255),
	STAT_POPUP_PANEL_COLOR = color(86, 104, 135, 200),
	STAT_LINE_COLOR_ONE = color(0, 0, 0, 75),
	STAT_LINE_COLOR_TWO = color(0, 0, 0, 50),
	NEW_HUD_SHADOW = color(45, 127, 174, 255),
	NEW_HUD_FILL = color(98, 162, 180, 255),
	NEW_HUD_FILL_WEAK = color(70, 115, 127, 255),
	NEW_HUD_FILL_2 = color(124, 166, 178, 255),
	NEW_HUD_FILL_3 = color(153, 173, 204, 255),
	NEW_HUD_FILL_3_WEAK = color(153, 173, 204, 255),
	NEW_HUD_OUTER = color(206, 224, 250, 255),
	NEW_HUD_OUTER_WEAK = color(186, 202, 224, 255),
	NEW_HUD_HOVER = color(255, 214, 172, 255),
	NEW_HUD_HOVER_DESATURATED = color(229, 192, 156, 255)
}
game.UI_COLORS.UI_PENALTY_LINE = game.UI_COLORS.DARK_RED:duplicate()
game.UI_COLORS.UI_PENALTY_LINE.a = 100
game.UI_COLORS.BOOST_LINE = game.UI_COLORS.VERY_DARK_LIGHT_BLUE:duplicate()
game.UI_COLORS.BOOST_LINE.a = 50
game.PLAYER_CHARACTER_STARTING_LEVEL = 1
game.PLAYER_CHARACTER_ROLE = "ceo"
game.PLAYER_CHARACTER_STARTING_AGE = 20
game.PLAYER_CHARACTER_STARTING_SKILL_LEVELS = 20
game.MAX_PC_SKILL_UNTIL_NO_MULT = 65
game.DESCENDANT_STARTING_SKILL_LEVELS = 40
game.GAME_SAVE_IN_CHANNEL = love.thread.getChannel("GAME_SAVER_IN")
game.GAME_SAVER_THREAD = love.thread.newThread("game/game_saver_thread.lua")

game.GAME_SAVER_THREAD:start()

game.playthroughRandomization = 0
game.canOpenMainMenu = true
game.CAMERA_MOVE_KEYS = {
	{
		x = 0,
		y = -800,
		keys = {
			w = true,
			up = true
		}
	},
	{
		x = 800,
		y = 0,
		keys = {
			right = true,
			d = true
		}
	},
	{
		x = 0,
		y = 800,
		keys = {
			down = true,
			s = true
		}
	},
	{
		x = -800,
		y = 0,
		keys = {
			left = true,
			a = true
		}
	}
}
game.FASTER_CAMERA_KEYS = {
	lshift = true,
	rshift = true
}
game.EVENTS = {
	FINISHED_LOAD = events:new(),
	ENTER_GAMEPLAY = events:new(),
	GAME_LOGIC_STARTED = events:new(),
	RESOLUTION_CHANGED = events:new(),
	NEW_GAME_STARTED = events:new(),
	SAVEGAME_DELETED = events:new(),
	SNAPSHOT_DELETED = events:new(),
	RANDOMIZE_PLAYTHROUGH_STATE_CHANGED = events:new(),
	DESIRED_GAMETYPE_SET = events:new(),
	DIFFICULTY_CHANGED = events:new(),
	GAME_UNLOADED = events:new(),
	PRE_GAME_UNLOAD = events:new(),
	RETURNING_TO_MAIN_MENU = events:new(),
	RETURNED_TO_MAIN_MENU = events:new(),
	ON_START_FINISH = events:new(),
	POST_MODS_LOADED = events:new(),
	START_REMOVING = events:new()
}
game.LOAD_COMPONENTS = {}

resolutionHandler:setPreResolutionChanged(function()
	resolutionHandler.oldW, resolutionHandler.oldH = resolutionHandler:getRealScreenResolution()
end)
resolutionHandler:setOnScreenModeChanged(function()
	game.onScreenModeChanged()
end)
resolutionHandler:setOnResolutionChanged(function(w, h)
	game.onResolutionChanged(w, h)
end)

game.activeCameraKeys = {}

love.filesystem.createDirectory(game.SAVE_DIRECTORY)

function game.addGameOverTip(tip)
	table.insert(game.GAME_OVER_TIPS, tip)
end

function game.openConsole()
	if not game.showingConsole then
		love._openConsole()
		
		game.showingConsole = true
		
		game.saveUserPreferences()
	end
end

function game.hideConsole()
	game.showingConsole = false
	
	game.saveUserPreferences()
end

function game.pickRandomGameOverTip()
	return game.GAME_OVER_TIPS[math.random(1, #game.GAME_OVER_TIPS)]
end

game.BASE_LOAD_COMPONENT_PRIORITY = 1

local function sortLoadComponents(a, b)
	return a.priority > b.priority
end

function game.addLoadComponent(classObj, id, priority)
	table.insert(game.LOAD_COMPONENTS, {
		obj = classObj,
		id = id,
		priority = priority
	})
	table.sort(game.LOAD_COMPONENTS, sortLoadComponents)
end

function game.setGametype(gametypeID, initialSet)
	game.curGametype = game.GAME_TYPES_BY_ID[gametypeID]
	
	game.curGametype:setPlaylist(initialSet)
	
	if initialSet then
		local gametypeData = game.curGametype
		local rivals = gametypeData:getRivals()
		
		if rivals then
			rivalGameCompanies:initCompanies(rivals)
		end
		
		gametypeData:start()
	end
end

function game.readMap(mapPath)
	local decompressed = love.math.decompress(love.filesystem.read(mapPath), game.MAP_COMPRESSION_ALGORITHM)
	
	return bitser.loads(decompressed), decompressed
end

function game.setDesiredOfficeSize(w, h)
	game.STUDIO_START_W = w
	game.STUDIO_START_H = h
	game.STUDIO_START_X = math.round(game.WORLD_GRID_WIDTH / 2 - game.STUDIO_START_W * 0.5)
end

game.setDesiredOfficeSize(game.DEFAULT_STUDIO_START_W, game.DEFAULT_STUDIO_START_H)

function game.removeGametype()
	if game.curGametype then
		game.curGametype:remove()
	end
	
	game.curGametype = nil
end

function game.loadDLCS()
	for key, dlcFolder in ipairs(game.DLCS) do
		local entryFile = "dlc/" .. dlcFolder .. "/" .. "main"
		
		if love.filesystem.isFile(entryFile .. ".lua") then
			require(entryFile)
		end
	end
end

function game.saveGametype()
	local saved = {}
	
	saved.id = game.curGametype.id
	
	game.curGametype:saveStartTime(saved)
	game.curGametype:save(saved)
	
	return saved
end

function game.setResolution(width, height)
	if scrW == width and scrH == height then
		return 
	end
	
	resolutionHandler:setDesiredResolution(width, height)
end

function game.onScreenModeChanged()
	game.onResolutionChanged(nil, nil)
end

function game.logFinishedCampaign(campaignID)
	local before = game.areGametypesFinished()
	
	if not game.gameData.finishedCampaigns then
		game.gameData.finishedCampaigns = {}
	end
	
	game.gameData.finishedCampaigns[campaignID] = (game.gameData.finishedCampaigns[campaignID] or 0) + 1
	
	if not game.gameData.thankYouPopup and not before and game.areGametypesFinished() then
		game.createGameFinishPopup()
		
		game.gameData.thankYouPopup = true
	end
	
	local data = game.GAME_TYPES_BY_ID[campaignID]
	
	if data.achievementOnFinish then
		achievements:attemptSetAchievement(data.achievementOnFinish)
	end
	
	if not data.tutorial and game.difficultyID == "normal" then
		achievements:attemptSetAchievement(achievements.ENUM.SCENARIO_NORMAL_DIFFICULTY)
	end
	
	game.saveGameData()
end

function game.wasCampaignFinished(campaignID)
	if not game.gameData.finishedCampaigns then
		return false
	end
	
	return game.gameData.finishedCampaigns[campaignID] ~= nil
end

game.MAX_TUTORIAL_BOTHERS = 3

function game.increaseTutorialBother()
	if not game.gameData.tutorialBothers then
		game.gameData.tutorialBothers = 1
	else
		game.gameData.tutorialBothers = game.gameData.tutorialBothers + 1
	end
	
	game.saveGameData()
end

function game.getTutorialBothers()
	return game.gameData.tutorialBothers
end

function game.canDisableTutorialBothering()
	return game.gameData.tutorialBothers and game.gameData.tutorialBothers >= game.MAX_TUTORIAL_BOTHERS
end

function game.markNoTutorialBother()
	game.gameData.skipTutorialBother = true
	
	game.saveGameData()
end

function game.canBotherWithTutorial()
	return not game.gameData.skipTutorialBother
end

function game.logStartedCampaign(campaignID)
	local before = game.areGametypesFinished()
	
	if not game.gameData.startedCampaigns then
		game.gameData.startedCampaigns = {}
	end
	
	game.gameData.startedCampaigns[campaignID] = (game.gameData.startedCampaigns[campaignID] or 0) + 1
	
	game.saveGameData()
end

function game.wasCampaignStarted(campaignID)
	if not game.gameData.startedCampaigns then
		return false
	end
	
	return game.gameData.startedCampaigns[campaignID] ~= nil
end

function game.saveGameData()
	love.filesystem.write(game.GAME_DATA_FILE, bitser.dumps(game.gameData))
end

function game.loadGameData()
	local read = love.filesystem.read(game.GAME_DATA_FILE)
	
	if read then
		game.gameData = bitser.loads(read)
		
		if type(game.gameData) == "number" then
			game.gameData = {}
		end
	else
		game.gameData = {}
	end
end

function game.createGameFinishPopup()
	local resultFrame = gui.create("GameConventionResultPopup")
	
	resultFrame:setFont("pix24")
	resultFrame:setTitle(_T("THANK_YOU_TITLE", "Thank You"))
	resultFrame:setTextFont("pix20")
	resultFrame:setText("")
	resultFrame:setSize(650, 390)
	resultFrame:setBaseHeight(400)
	resultFrame:setDescboxOffset(210)
	resultFrame:hideCloseButton()
	
	local panel = gui.create("Panel", resultFrame)
	
	panel:setScissor(true)
	panel:setSize(640, 360)
	panel:setPos(_S(5), _S(30))
	
	panel.shouldDraw = false
	
	panel:addDepth(40)
	
	local resultDisplay = gui.create("ThankYouPeepAnimation", panel)
	
	resultDisplay:setSize(640, 360)
	resultDisplay:setPeepCount(150)
	
	local left, right, extra = resultFrame:getDescboxes()
	local wrapWidth = resultFrame.rawW - 25
	
	left:addText(_T("THANK_YOU_TEXT_1", "Congratulations!"), "bh24", nil, 0, wrapWidth)
	left:addText(_T("THANK_YOU_TEXT_2", "You've finished every single Scenario available in the game!"), "bh20", nil, 10, wrapWidth)
	left:addText(_T("THANK_YOU_TEXT_3", "I've put a lot of time, effort and love into this game and I hope you've had as much fun playing Game Dev Studio as I did making it."), "pix20", nil, 15, wrapWidth)
	left:addText(_T("THANK_YOU_TEXT_4", "From the bottom of my heart - thank you for playing and enjoying Game Dev Studio!"), "bh24", nil, 0, wrapWidth)
	resultFrame:addOKButton("bh20")
	resultFrame:center()
	frameController:push(resultFrame)
end

function game.setCanInitHUD(can)
	game.canInitHUD = can
end

function game.onResolutionChanged(w, h)
	local newW, newH = resolutionHandler:getRealScreenResolution()
	
	if resolutionHandler.oldW and game.worldObject then
		local deltaX, deltaY = newW - resolutionHandler.oldW, newH - resolutionHandler.oldH
		
		resolutionHandler.oldW, resolutionHandler.oldH = nil
		
		camera:setPosition(camera.x - deltaX * 0.5 / camera.scaleX, camera.y - deltaY * 0.5 / camera.scaleY, true, nil)
	end
	
	love.window.setScreenSizeVariables()
	developer:rebuildFonts()
	
	game.mainFrameBuffer = frameBuffer.new(newW, newH, false, nil, true)
	
	game.mainFrameBuffer:setDrawPosition(0, 0)
	
	game.mainFrameBufferObject = game.mainFrameBuffer:getBuffer()
	
	camera:adjustScale()
	shadowShader:onResolutionChanged()
	buildingShadows:onResolutionChanged()
	weather:onResolutionChanged()
	cullingTester:setupRenderBounds()
	game.clearHUDElements()
	
	if game.currentLoadedSaveFile or game.worldObject and game.canInitHUD then
		game.initNewHUD(true)
	elseif not game.worldObject then
		gui.removeAllUIElements()
		mainMenu:createMainMenu()
	end
	
	lightingManager:onResolutionChanged()
	game.updateCameraBounds()
	
	if not configLoader:isReading() then
		game.saveUserPreferences()
	end
	
	shaders.horizontalGaussianBlur:send("resolution", {
		resolutionHandler.curW,
		resolutionHandler.curH
	})
	shaders.verticalGaussianBlur:send("resolution", {
		resolutionHandler.curW,
		resolutionHandler.curH
	})
	
	if game.worldObject then
		game.worldObject:queueQuadtreeUpdate()
	end
	
	collectgarbage("collect")
	collectgarbage("collect")
	events:fire(game.EVENTS.RESOLUTION_CHANGED)
end

function game.setCanRetire(state)
	game.canRetire = state
end

function game.getCanRetire()
	return game.canRetire
end

function game.loadGametype(data)
	game.setGametype(data.id)
	game.curGametype:loadStartTime(data)
	game.curGametype:load(data)
	game.curGametype:initEventHandler()
end

function game.hasRandomizationState(state)
	return bit.band(game.playthroughRandomization, state) == state
end

function game.removeRandomizationState(state)
	if game.hasRandomizationState(state) then
		game.playthroughRandomization = game.playthroughRandomization - state
		
		events:fire(game.EVENTS.RANDOMIZE_PLAYTHROUGH_STATE_CHANGED, state, false)
	end
end

function game.addRandomizationState(state)
	if not game.hasRandomizationState(state) then
		game.playthroughRandomization = game.playthroughRandomization + state
		
		events:fire(game.EVENTS.RANDOMIZE_PLAYTHROUGH_STATE_CHANGED, state, true)
	end
end

function game.toggleRandomizationState(state)
	if game.hasRandomizationState(state) then
		game.playthroughRandomization = game.playthroughRandomization - state
		
		events:fire(game.EVENTS.RANDOMIZE_PLAYTHROUGH_STATE_CHANGED, state, false)
		
		return false
	else
		game.playthroughRandomization = game.playthroughRandomization + state
		
		events:fire(game.EVENTS.RANDOMIZE_PLAYTHROUGH_STATE_CHANGED, state, true)
		
		return true
	end
end

function game.onStarted()
	consoleManufacturers:buildPlatformList()
	taskTypes:onStartedBuild()
	knowledge:onGameStarted()
	review:buildStandardsByYear()
	game.loadGameData()
	game.loadUserPreferences()
	
	if steam then
		steam.LoadMods()
	end
	
	themes:postLoadedMods()
	genres:postLoadedMods()
	events:fire(game.EVENTS.POST_MODS_LOADED)
	gameQuality:rebuildContributionImportanceLists()
	
	if game.SHOW_SPLASH_SCREEN then
		game.initSplashScreen()
	else
		game.initMainState()
	end
	
	game.loadDLCS()
	events:fire(game.EVENTS.ON_START_FINISH)
end

function game.initSplashScreen()
	splash:insertNew("textures/love2d_logo.png", 3, nil, nil, mainMenu.backgroundColor, function(alpha)
		local text, font = _T("MADE_WITH_LOVE", "Made with love using LÖVE2D"), fonts.get("bh36")
		
		love.graphics.setFont(font)
		
		local textW = font:getWidth(text)
		
		love.graphics.setColor(255, 255, 255, alpha)
		love.graphics.print(text, scrW * 0.5 - textW * 0.5, scrH - _S(100))
	end)
	splash:show()
end

function game.initMainState()
	game.mainInputHandler = require("game/input_handler")
	game.mainRenderer = require("game/main_renderer")
	game.mainMenuRenderer = require("game/main_menu_renderer")
	game.mainState = require("game/main_state")
	
	inputService:addHandler(game.mainInputHandler)
	mainMenu:show()
end

function game.getSaveFileName(baseFileName)
	return game.SAVE_DIRECTORY .. (baseFileName or game.SAVE_FILE_NAME .. #love.filesystem.getDirectoryItems(game.SAVE_DIRECTORY) + 1) .. game.SAVE_FILE_FORMAT
end

function game.getPreviewFile(savePath)
	return savePath .. game.SAVE_FILE_FORMAT_PREVIEW
end

local readData

local function readSavePreview()
	readData = bitser.loads(love.math.decompress(readData, "lz4"))
end

function game.readSavePreview(previewPath)
	local data = love.filesystem.read(previewPath)
	
	if data then
		readData = data
		
		if pcall(readSavePreview) then
			local data = readData
			
			readData = nil
			
			return data
		else
			return nil, _T("PREVIEW_FILE_CORRUPT", "Preview file corrupt!")
		end
	end
	
	return nil
end

function game.beginSaving(path, skipSaveGameStringUpdate, quitOnSave)
	game.savingGame = true
	
	inputService:removeHandler(game.mainInputHandler)
	
	game.savePath = path
	game.skipSaveGameStringUpdate = skipSaveGameStringUpdate
	game.quitOnSave = quitOnSave
end

function game.finishSaving()
	game.save(game.savePath, game.skipSaveGameStringUpdate)
end

function game.addSaleDisplay(display)
	table.insert(game.saleDisplays, display)
	game.repositionSaleDisplays()
end

function game.removeSaleDisplay(display)
	if table.removeObject(game.saleDisplays, display) then
		game.repositionSaleDisplays()
	end
end

function game.repositionSaleDisplays()
	local y = _S(10)
	local ySpacing = _S(7)
	local xOffset = _S(10)
	
	for key, display in ipairs(game.saleDisplays) do
		display:alignToRight(xOffset)
		display:setY(y)
		
		y = y + display.h + ySpacing
	end
end

function game.canHaveInput()
	return not game.savingGame
end

function game.validateSavefile(saveData)
	do return  end
	
	for a, b in pairs(saveData) do
		game._validateSavefile(a, b, "")
	end
end

function game._validateSavefile(key, value, root)
	if type(key) == "number" then
		root = root .. "[" .. key .. "]"
	else
		root = root .. "." .. tostring(key)
	end
	
	if type(key) == "function" or type(value) == "function" then
		error("function found in save file, key: '" .. tostring(root) .. "' value: '" .. tostring(value) .. "'")
	end
	
	if type(value) == "table" then
		for a, b in pairs(value) do
			game._validateSavefile(a, b, root)
		end
	end
end

function game.randomizePlaythrough()
	if game.hasRandomizationState(game.RANDOMIZATION_STATES.THEME_GENRE_MATCHING) then
		themes:randomizeMatches()
	end
	
	if game.hasRandomizationState(game.RANDOMIZATION_STATES.GENRE_QUALITY_MATCHING) then
		genres:randomizeScoreImpact()
	end
	
	if game.hasRandomizationState(game.RANDOMIZATION_STATES.PLATFORM_STATS) then
		platforms:randomizePlatformData()
	end
end

function game.save(path, skipSaveGameStringUpdate)
	inputService:removeHandler(game.mainInputHandler)
	
	local data = {}
	
	data.playthroughRandomization = game.playthroughRandomization
	data.playthroughStartTime = game.playthroughStartTime or 1
	data.salaryModel = game.salaryModel
	
	if game.playthroughRandomization ~= 0 then
		if game.hasRandomizationState(game.RANDOMIZATION_STATES.THEME_GENRE_MATCHING) then
			data.themes = themes:saveMatches()
		end
		
		if game.hasRandomizationState(game.RANDOMIZATION_STATES.GENRE_QUALITY_MATCHING) then
			data.genres = genres:saveScoreImpacts()
		end
		
		if game.hasRandomizationState(game.RANDOMIZATION_STATES.PLATFORM_STATS) then
			data.platformRandomization = platforms:saveRandomization()
		end
	end
	
	data.achievements = achievements:save()
	data.difficulty = game.difficultyID
	data.platformParts = platformParts:save()
	
	game.validateSavefile(data.timeline)
	
	data.timeline = timeline:save()
	
	game.validateSavefile(data.timeline)
	
	data.objectiveHandler = objectiveHandler:save()
	
	game.validateSavefile(data.objectiveHandler)
	
	data.review = review:save()
	
	game.validateSavefile(data.review)
	
	data.gameConventions = gameConventions:save()
	
	game.validateSavefile(data.gameConventions)
	
	data.studio = studio:save()
	
	game.validateSavefile(data.studio)
	
	data.employeeCirculation = employeeCirculation:save()
	
	game.validateSavefile(data.employeeCirculation)
	
	data.platforms = platformShare:save()
	
	game.validateSavefile(data.platforms)
	
	data.manufacturers = consoleManufacturers:save()
	
	game.validateSavefile(data.manufacturers)
	
	data.engineLicensing = engineLicensing:save()
	
	game.validateSavefile(data.engineLicensing)
	
	data.yearlyGoalController = yearlyGoalController:save()
	
	game.validateSavefile(data.yearlyGoalController)
	
	data.preferences = preferences:save()
	
	game.validateSavefile(data.preferences)
	
	data.trends = trends:save()
	
	game.validateSavefile(data.trends)
	
	data.contractWork = contractWork:save()
	
	game.validateSavefile(data.contractWork)
	
	data.conversations = conversations:save()
	
	game.validateSavefile(data.conversations)
	
	data.gametype = game.saveGametype()
	
	game.validateSavefile(data.gametype)
	
	data.scheduledEvents = scheduledEvents:save()
	
	game.validateSavefile(data.scheduledEvents)
	
	data.hintSystem = hintSystem:save()
	
	game.validateSavefile(data.hintSystem)
	
	data.bookController = bookController:save()
	
	game.validateSavefile(data.bookController)
	
	data.world = game.worldObject:save()
	
	game.validateSavefile(data.world)
	
	data.interactionRestrictor = interactionRestrictor:save()
	
	game.validateSavefile(data.interactionRestrictor)
	
	data.camera = camera:save()
	
	game.validateSavefile(data.camera)
	
	data.rivalGameCompanies = rivalGameCompanies:save()
	
	game.validateSavefile(data.rivalGameCompanies)
	
	data.unlocks = unlocks:save()
	
	game.validateSavefile(data.unlocks)
	
	data.weather = weather:save()
	
	game.validateSavefile(data.weather)
	
	data.letsPlayers = letsPlayers:save()
	
	game.validateSavefile(data.letsPlayers)
	
	data.gameAwards = gameAwards:save()
	data.serverRenting = serverRenting:save()
	
	if game.eventBox then
		data.eventBoxElements = {}
		
		for key, element in ipairs(game.eventBox:getElements()) do
			data.eventBoxElements[#data.eventBoxElements + 1] = element:saveData()
		end
	end
	
	data.UNIQUE_ID_COUNTER = game.UNIQUE_ID_COUNTER
	data.UNIQUE_PROJECT_ID = game.UNIQUE_PROJECT_ID
	data.WORLD_WIDTH, data.WORLD_HEIGHT = game.worldObject:getGridSize()
	data.WORLD_HEIGHT = game.WORLD_HEIGHT
	data.UNIQUE_TEAM_ID = game.UNIQUE_TEAM_ID
	
	local components = {}
	
	data.loadComponents = components
	
	for key, component in ipairs(game.LOAD_COMPONENTS) do
		components[component.id] = component.obj:save(data)
	end
	
	if not path or string.gsub(path, "%s+", "") == "" then
		path = game.getSaveFileName()
	end
	
	hook.call("saveGame", data)
	
	if not game.playthroughHash then
		game.playthroughHash = saveSnapshot:generateHash()
	end
	
	local sendData = {
		saveData = tostring(bitser.dumps(data)),
		savePath = path,
		saveDate = os.time(),
		gameTime = timeline.curTime,
		funds = studio:getFunds(),
		employeeCount = #studio:getEmployees(),
		screenshot = love.graphics.newScreenshot(true),
		screenW = scrW,
		screenH = scrH,
		screenshotScale = game.PREVIEW_SCREENSHOT_SCALER,
		playthroughHash = game.playthroughHash,
		previewPath = path .. game.SAVE_FILE_FORMAT_PREVIEW,
		activeModData = workshop:getActiveModData()
	}
	
	game.GAME_SAVE_IN_CHANNEL:push(sendData)
	
	sendData.screenshot = nil
	
	if not skipSaveGameStringUpdate then
		game.currentLoadedSaveFile = path
	end
	
	if game.quitOnSave then
		game.returnToMainMenu()
	end
	
	game.quitOnSave = false
	game.savingGame = false
	
	inputService:addHandler(game.mainInputHandler)
end

function game.addDynamicObject(object)
	if object.IN_DYNAMIC_LIST then
		return 
	end
	
	object.IN_DYNAMIC_LIST = true
	
	table.insert(game.dynamicObjects, object)
end

function game.removeDynamicObject(object)
	for key, otherObject in ipairs(game.dynamicObjects) do
		if object == otherObject then
			table.remove(game.dynamicObjects, key)
			
			object.IN_DYNAMIC_LIST = false
			
			return true
		end
	end
	
	return false
end

function game.getDynamicObject(object)
	for key, otherObject in ipairs(game.dynamicObjects) do
		if object == otherObject then
			return key
		end
	end
	
	return nil, nil
end

function game.setEditorState(state)
	game.editorActive = state
end

function game.getEditorState()
	return game.editorActive
end

function game.disableSaving()
	game.savingDisabled = true
end

function game.enableSaving()
	game.savingDisabled = false
end

function game.getSavingDisabled()
	return game.savingDisabled
end

function game.remove()
	events:fire(game.EVENTS.START_REMOVING)
	
	game._removing = true
	
	sound.manager:clearAll()
	gui.removeAllUIElements()
	game.clearHUDElements()
	
	game.playthroughHash = nil
	game.playthroughStartTime = nil
	game.salaryModel = nil
	game.canOpenMainMenu = true
	
	game.resetDifficulty()
	game.setCanRetire(true)
	camera:reset()
	
	if game.playthroughRandomization ~= 0 and game.worldObject then
		if game.hasRandomizationState(game.RANDOMIZATION_STATES.THEME_GENRE_MATCHING) then
			themes:restoreMatches()
		end
		
		if game.hasRandomizationState(game.RANDOMIZATION_STATES.GENRE_QUALITY_MATCHING) then
			genres:restoreScoreImpacts()
		end
		
		if game.hasRandomizationState(game.RANDOMIZATION_STATES.PLATFORM_STATS) then
			platforms:restoreMatches()
		end
		
		game.playthroughRandomization = 0
	end
	
	if game.mouseOverBuilding then
		game.mouseOverBuilding:onMouseLeft()
		
		game.mouseOverBuilding = nil
	end
	
	for key, object in ipairs(game.dynamicObjects) do
		object:remove()
		
		game.dynamicObjects[key] = nil
	end
	
	if not game.initialGameStarted then
		game.finishRemoving()
		
		return 
	end
	
	game.canSendGridUpdateToThreads = false
	
	if game.worldObject then
		game.worldObject:remove()
		
		game.worldObject = nil
	end
	
	employeeAssignment:removeEventHandler()
	randomEvents:remove()
	review:remove()
	weather:remove()
	ambientSounds:remove()
	unlocks:remove()
	logicPieces:remove()
	studio.driveAffectors:remove()
	employeeAssignment:remove()
	serverRenting:remove()
	platformParts:remove()
	achievements:remove()
	pathComputeQueue:remove()
	
	for key, saleDisplay in ipairs(game.saleDisplays) do
		saleDisplay:kill()
		
		game.saleDisplays[key] = nil
	end
	
	game.sendToPathfinderThreads(pathfinderThread.MESSAGE_TYPE.CLEAR_GRID)
	platformShare:destroy()
	consoleManufacturers:destroy()
	employeeCirculation:remove()
	scheduledEvents:remove()
	engineLicensing:remove()
	developerActions:remove()
	hintSystem:remove()
	pathCaching:remove()
	yearlyGoalController:remove()
	trends:remove()
	contractWork:remove()
	conversations:remove()
	dialogueHandler:remove()
	lightingManager:remove()
	autosave:remove()
	preferences:remove()
	motivationalSpeeches:remove()
	bookController:remove()
	gameConventions:remove()
	objectiveHandler:remove()
	rivalGameCompanies:remove()
	activities:remove()
	interactionRestrictor:remove()
	objectSelector:remove()
	saveSnapshot:remove()
	pedestrianController:remove()
	letsPlayers:remove()
	shadowShader:remove()
	timeline:reset()
	gameAwards:remove()
	
	for key, data in ipairs(game.LOAD_COMPONENTS) do
		data.obj:remove()
	end
	
	table.clearArray(game.bufferedEvents)
	game.removeGametype()
	game.setMouseOverObject(nil)
	layerRenderer:removeLayer(game.mainRenderer)
	gameStateService:removeState(game.mainState)
	gui:clearClickIDs()
	game.finishRemoving()
	collectgarbage("collect")
	collectgarbage("collect")
end

function game.removeState()
	layerRenderer:removeLayer(game.mainRenderer)
	gameStateService:removeState(game.mainState)
	inputService:removeHandler(game.mainInputHandler)
end

function game.finishRemoving()
	events:fire(game.EVENTS.PRE_GAME_UNLOAD)
	
	game.currentLoadedSaveFile = nil
	game._removing = false
	
	events:fire(game.EVENTS.GAME_UNLOADED)
end

function game.quit()
	game.destroyPathfinderThreads()
	lightingManager:stopAllThreads()
	love.event.quit()
end

function game.returnToMainMenu()
	game.remove()
	events:fire(game.EVENTS.RETURNING_TO_MAIN_MENU)
	mainMenu:closeInGameMenu()
	mainMenu:show()
	events:fire(game.EVENTS.RETURNED_TO_MAIN_MENU)
end

function game.getSavedGames()
	return love.filesystem.getDirectoryItems(game.SAVE_DIRECTORY)
end

function game.load(path, playthroughHash, skipSaveFileNameSet)
	local time = os.clock()
	
	game.remove()
	
	game._removing = false
	
	game.initPathfinderThreads()
	game.hideHUD()
	mainMenu:hide()
	inputService:removeHandler(game.mainInputHandler)
	
	game.canSendGridUpdateToThreads = true
	path = path or game.SAVE_DIRECTORY .. game.SAVE_FILE_NAME .. #love.filesystem.getDirectoryItems(game.SAVE_DIRECTORY) .. game.SAVE_FILE_FORMAT
	
	loadingScreen:start(0, function()
		achievements:init()
		loadingScreen:updateProgress(0, _T("LOADING_READING_SAVEFILE", "Reading savefile"))
		
		local decoded = bitser.loads(love.math.decompress(love.filesystem.read(path), "lz4"))
		
		game.difficultyID = decoded.difficulty or "normal"
		
		game.applyDifficulty(game.difficultyID)
		
		game.saveData = decoded
		game.playthroughStartTime = decoded.playthroughStartTime
		game.salaryModel = decoded.salaryModel or 1
		
		math.randomseed(game.playthroughStartTime or 1)
		
		game.playthroughHash = playthroughHash
		game.playthroughRandomization = decoded.playthroughRandomization or game.playthroughRandomization
		
		if game.playthroughRandomization ~= 0 then
			if game.hasRandomizationState(game.RANDOMIZATION_STATES.THEME_GENRE_MATCHING) then
				themes:loadMatches(decoded.themes)
			end
			
			if game.hasRandomizationState(game.RANDOMIZATION_STATES.GENRE_QUALITY_MATCHING) then
				genres:loadScoreImpacts(decoded.genres)
			end
			
			if game.hasRandomizationState(game.RANDOMIZATION_STATES.PLATFORM_STATS) then
				platforms:loadRandomization(decoded.platformRandomization)
			end
		end
		
		game.WORLD_WIDTH = decoded.WORLD_WIDTH
		game.WORLD_HEIGHT = decoded.WORLD_HEIGHT
		game.UNIQUE_ID_COUNTER = decoded.UNIQUE_ID_COUNTER
		game.UNIQUE_PROJECT_ID = decoded.UNIQUE_PROJECT_ID
		game.UNIQUE_TEAM_ID = decoded.UNIQUE_TEAM_ID
		
		loadingScreen:updateProgress(0.1, _T("LOADING_INITIALIZING_WORLD", "Initializing world"))
		game.initWorld(true, nil, nil, decoded.world)
		loadingScreen:updateProgress(0.2, _T("LOADING_BASIC_SYSTEMS", "Loading basic systems"))
		timeline:load(decoded.timeline)
		engineLicensing:load(decoded.engineLicensing)
		review:load(decoded.review)
		review:findLatestStandardByYear()
		pathCaching:init()
		contractWork:init()
		dialogueHandler:init()
		autosave:init()
		preferences:init()
		motivationalSpeeches:init()
		ambientSounds:init()
		letsPlayers:init()
		gameAwards:init()
		pathComputeQueue:init()
		
		if decoded.unlocks then
			unlocks:load(decoded.unlocks)
		end
		
		if decoded.achievements then
			achievements:load(decoded.achievements)
		end
		
		loadingScreen:updateProgress(0.25, _T("LOADING_INITIALIZE_OBJECTIVES", "Initializing objective system"))
		objectiveHandler:init()
		objectSelector:init()
		saveSnapshot:init()
		loadingScreen:updateProgress(0.3, _T("LOADING_OBJECTIVES", "Loading objectives"))
		interactionRestrictor:init()
		
		if decoded.objectiveHandler then
			objectiveHandler:load(decoded.objectiveHandler)
		end
		
		loadingScreen:updateProgress(0.35, _T("LOADING_MISC_SYSTEMS", "Initializing miscellaneous systems"))
		bookController:init()
		bookController:load(decoded.bookController)
		consoleManufacturers:load(decoded.manufacturers)
		platformShare:load(decoded.platforms)
		consoleManufacturers:postLoad(decoded.manufacturers)
		studio.expansion:reset()
		loadingScreen:updateProgress(0.4, _T("LOADING_STUDIO", "Loading studio data"))
		serverRenting:init()
		
		if decoded.serverRenting then
			serverRenting:load(decoded.serverRenting)
		end
		
		studio:load(decoded.studio)
		studio:getBrightnessMap():setFloorTileGrid(game.worldObject:getFloorTileGrid())
		review:postLoad(decoded.review)
		gameConventions:init()
		
		if decoded.gameConventions then
			gameConventions:load(decoded.gameConventions)
		end
		
		loadingScreen:updateProgress(0.45, _T("LOADING_JOB_SEEKERS", "Loading job seekers"))
		employeeCirculation:init()
		employeeCirculation:load(decoded.employeeCirculation)
		loadingScreen:updateProgress(0.5, _T("LOADING_SCHEDULED_EVENTS", "Scheduling timed events"))
		scheduledEvents:init()
		yearlyGoalController:init()
		yearlyGoalController:load(decoded.yearlyGoalController)
		loadingScreen:updateProgress(0.55, _T("LOADING_MISC_SYSTEMS_DATA", "Loading miscellaneous systems"))
		trends:init()
		trends:load(decoded.trends)
		conversations:load(decoded.conversations)
		contractWork:load(decoded.contractWork)
		preferences:load(decoded.preferences)
		hintSystem:load(decoded.hintSystem)
		game.loadGametype(decoded.gametype)
		platformParts:init()
		
		if decoded.platformParts then
			platformParts:load(decoded.platformParts)
		end
		
		loadingScreen:updateProgress(0.6, _T("LOADING_WORLD", "Loading the world"))
		game.worldObject:load(decoded.world)
		loadingScreen:updateProgress(0.75, _T("LOADING_RIVALS", "Loading rivals"))
		rivalGameCompanies:init()
		
		if decoded.rivalGameCompanies then
			rivalGameCompanies:load(decoded.rivalGameCompanies)
		end
		
		if decoded.letsPlayers then
			letsPlayers:load(decoded.letsPlayers)
		end
		
		loadingScreen:updateProgress(0.8, _T("LOADING_MISC_SYSTEMS_DATA", "Loading miscellaneous systems"))
		activities:init()
		
		if decoded.interactionRestrictor then
			interactionRestrictor:load(decoded.interactionRestrictor)
		end
		
		lightingManager:init()
		
		if decoded.scheduledEvents then
			scheduledEvents:load(decoded.scheduledEvents)
		end
		
		if decoded.camera then
			camera:load(decoded.camera)
		end
		
		loadingScreen:updateProgress(0.95, _T("LOADING_FINALIZING", "Finalizing"))
		platformShare:postLoad(decoded.platforms)
		game.sendWholeGridToPathfinderThreads()
		game.postInitWorld()
		pedestrianController:init()
		weather:init()
		
		if decoded.weather then
			weather:load(decoded.weather)
		end
		
		if decoded.gameAwards then
			gameAwards:load(decoded.gameAwards)
		end
		
		timeOfDay:postLoad()
		
		local components = decoded.loadComponents
		
		if components then
			for key, component in ipairs(game.LOAD_COMPONENTS) do
				local savedData = components[component.id]
				
				if savedData then
					component.obj:load(savedData)
				end
			end
		end
		
		pedestrianController:postInitUpdate()
		hook.call("loadGame", decoded)
		events:fire(game.EVENTS.FINISHED_LOAD)
		
		path = string.gsub(path, autosave.APPEND_STRING, "")
		
		if not skipSaveFileNameSet then
			game.currentLoadedSaveFile = path
		end
		
		serverRenting:postLoad()
		objectiveHandler:fillObjectives(true)
		bookController:postLoad()
		studio:onFinishLoad()
		game.worldObject:onFinishLoad()
		scheduledEvents:activateInactiveEvents()
		randomEvents:init()
		employeeCirculation:postLoad()
		gameConventions:postLoad()
		
		game.saveData = nil
		
		game.finalizeWorld()
		
		if decoded.eventBoxElements then
			for key, savedData in ipairs(decoded.eventBoxElements) do
				game.eventBox:addEvent(nil, nil, nil, nil, savedData)
			end
		end
		
		print("loading took", os.clock() - time, "seconds")
		loadingScreen:finish()
	end)
end

function game.startGameLogic()
	inputService:addHandler(game.mainInputHandler)
	layerRenderer:addLayer(game.mainRenderer)
	gameStateService:addState(game.mainState)
	objectiveHandler:onGameLogicStarted()
	events:fire(game.EVENTS.GAME_LOGIC_STARTED)
end

function game.deleteSavefile(path, fileName, playthroughHash, snapshot)
	if not snapshot then
		local path = path .. fileName .. game.SAVE_FILE_FORMAT
		
		love.filesystem.remove(path)
		love.filesystem.remove(path .. game.SAVE_FILE_FORMAT_PREVIEW)
		
		if playthroughHash then
			local snapshotDirectory = saveSnapshot:getSnapshotSavePath(playthroughHash)
			local snapshots = saveSnapshot:getPlaythroughSnapshots(playthroughHash)
			
			for key, snapshotName in ipairs(snapshots) do
				love.filesystem.remove(snapshotDirectory .. snapshotName)
			end
			
			love.filesystem.remove(snapshotDirectory)
		end
		
		events:fire(game.EVENTS.SAVEGAME_DELETED, fileName, playthroughHash)
	else
		local snapshotDirectory = saveSnapshot:getSnapshotSavePath(playthroughHash)
		local path = path .. fileName .. game.SAVE_FILE_FORMAT
		
		love.filesystem.remove(path)
		love.filesystem.remove(path .. game.SAVE_FILE_FORMAT_PREVIEW)
		events:fire(game.EVENTS.SNAPSHOT_DELETED, fileName)
	end
end

function game.performMouseOverOffice(grid)
	if gui.elementHovered and not gui.elementHovered.OFFICE_DISPLAY then
		if game.mouseOverBuilding then
			game.mouseOverBuilding:onMouseLeft()
			
			game.mouseOverBuilding = nil
		end
		
		return 
	end
	
	grid = grid or game.worldObject:getFloorTileGrid()
	
	local tileW, tileH = grid:getTileSize()
	local mouseX, mouseY = grid:getMouseTileCoordinates()
	local mouseIndex = grid:getTileIndex(mouseX, mouseY)
	local mouseOverOffice = studio:getOfficeAtIndex(mouseIndex)
	
	if mouseOverOffice then
		if mouseOverOffice ~= game.mouseOverBuilding then
			if game.mouseOverBuilding then
				game.mouseOverBuilding:onMouseLeft()
			end
			
			mouseOverOffice:onMouseEntered()
		end
	elseif game.mouseOverBuilding then
		game.mouseOverBuilding:onMouseLeft()
	end
	
	game.mouseOverBuilding = mouseOverOffice
end

function game.clearMouseOverOffice()
	if game.mouseOverBuilding then
		game.mouseOverBuilding:onMouseLeft()
		
		game.mouseOverBuilding = nil
	end
end

function game.propertySwitchToFloor()
	studio.expansion:setConstructionMode(studio.expansion.CONSTRUCTION_MODE.FLOORS)
end

function game.propertySwitchToWalls()
	studio.expansion:setConstructionMode(studio.expansion.CONSTRUCTION_MODE.WALLS)
end

function game.propertySwitchToObjects(panel)
	studio.expansion:setObjectList(panel.categoryObjects)
	studio.expansion:setConstructionMode(studio.expansion.CONSTRUCTION_MODE.OBJECTS)
end

function game.attemptCreateHintPopup(hintID)
	if preferences:get(hintID) then
		return nil
	end
	
	return gui.create("HintPopup")
end

game.TEAM_INFO_DESCBOX = "team_info_descbox"

function game.createTeamManagementMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(450, 600)
	frame:setFont(fonts.get("pix20"))
	frame:setTitle(_T("TEAM_MANAGEMENT_TITLE", "Team Management"))
	frame:setCloseKey(keyBinding:getCommandKey(keyBinding.COMMANDS.EMPLOYEE_MANAGE))
	frame:center()
	
	local propertysheet = gui.create("PropertySheet", frame)
	
	propertysheet:setPos(_S(5), _S(29))
	propertysheet:setTabOffset(4, 4)
	propertysheet:setSize(440, 590)
	propertysheet:setFont(fonts.get("bh24"))
	
	local employeePanel = gui.create("Panel")
	
	employeePanel:setSize(440, 533)
	
	employeePanel.shouldDraw = false
	
	local infoBox = gui.create("StudioEmploymentInfoDescbox")
	
	infoBox:setPos(frame.x + frame.w + _S(10), frame.y)
	infoBox:updateDisplay()
	infoBox:tieVisibilityTo(employeePanel)
	infoBox:setShowEmployeeOverview(true)
	
	local panelScroll = gui.create("RoleScrollbarPanel", employeePanel)
	
	panelScroll:setSize(440, 533)
	panelScroll:setAdjustElementPosition(true)
	panelScroll:setPadding(3, 3)
	panelScroll:addDepth(5)
	
	local list = game.createRoleFilter(panelScroll, true)
	
	list:setPos(frame.x - list.w - _S(10), frame.y)
	panelScroll:setRoleFilterList(list)
	
	for key, employee in ipairs(studio:getEmployees()) do
		local managementButton = gui.create("EmployeeTeamAssignmentButton")
		
		managementButton:addComboBoxOption("assignworkplace", "fire", "fillroleoptions", "info")
		managementButton:setFont(fonts.get("pix20"))
		managementButton:setSize(408, 40)
		managementButton:setEmployee(employee)
		managementButton:setThoroughDescription(true)
		panelScroll:addEmployeeItem(managementButton)
	end
	
	local employeesButton = propertysheet:addItem(employeePanel, _T("EMPLOYEES", "Employees"), 128, 28)
	
	employeesButton:addHoverText(_T("EMPLOYEE_MANAGEMENT_TITLE", "Employee management"), "pix24")
	employeesButton:addHoverText(_T("EMPLOYEE_MANAGEMENT_DESCRIPTION", "See what your employees are working on, check their stats, fire them if need be."), "pix20")
	
	local teamPanel = gui.create("Panel")
	
	teamPanel:setSize(440, 533)
	
	teamPanel.shouldDraw = false
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(game.TEAM_INFO_DESCBOX)
	teamDescbox:tieVisibilityTo(teamPanel)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	
	local scrollFrame = gui.create("TeamScrollbarPanel", teamPanel)
	
	scrollFrame:setSize(440, 503)
	scrollFrame:setAdjustElementPosition(true)
	scrollFrame:setPadding(3, 3)
	
	local curTeams = gui.create("Category")
	
	curTeams:setFont(fonts.get("pix24"))
	curTeams:setText(_T("CURRENT_TEAMS", "Current teams"))
	curTeams:setWidth(408)
	curTeams:setHeight(28)
	curTeams:assumeScrollbar(scrollFrame)
	scrollFrame:addItem(curTeams)
	scrollFrame:setCategoryTitle(curTeams)
	scrollFrame:fillWithElements()
	
	local newTeam = gui.create("NewTeamButton", teamPanel)
	
	newTeam:setSize(440, 25)
	newTeam:setY(_S(508))
	newTeam:centerX()
	
	local teamsButton = propertysheet:addItem(teamPanel, _T("TEAMS", "Teams"), 128, 28)
	
	teamsButton:addHoverText(_T("TEAM_MANAGEMENT", "Team management"), "pix24")
	teamsButton:addHoverText(_T("TEAM_MANAGEMENT_DESCRIPTION", "Create new teams, manage employees within existing teams."), "pix20")
	
	local activityPanel = gui.create("Panel")
	
	activityPanel:setSize(440, 533)
	
	activityPanel.shouldDraw = false
	
	local panelScroll = gui.create("ScrollbarPanel", activityPanel)
	
	panelScroll:setSize(440, 533)
	panelScroll:setAdjustElementPosition(true)
	panelScroll:setPadding(3, 3)
	
	for key, activity in ipairs(activities.sortedByPrice) do
		local managementButton = gui.create("ActivitySelectionButton")
		
		managementButton:setActivity(activity)
		managementButton:setSize(408, 44)
		panelScroll:addItem(managementButton)
	end
	
	local activitiesButton = propertysheet:addItem(activityPanel, _T("ACTIVITIES", "Activities"), 128, 28)
	
	activitiesButton:addHoverText(_T("TEAM_BUILDING_ACTIVITIES", "Team building activities"), "pix24")
	
	if not studio:canStartNewActivity() then
		activitiesButton:setIcon("lock_red")
		activitiesButton:setCanClick(false)
		activitiesButton:addHoverText(_T("TEAM_BUILDING_ACTIVITIES_BUSY", "A team building activity has already been scheduled."), "bh18")
	else
		activitiesButton:addHoverText(_T("TEAM_BUILDING_ACTIVITIES_DESCRIPTION", "Schedule activities to boost employee Drive levels."), "pix20")
	end
	
	frameController:push(frame)
	
	return frame
end

function game.createObjectivesMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 150)
	frame:setFont("pix24")
	frame:setTitle(_T("OBJECTIVES_TITLE", "Objectives"))
	
	local elementY = _S(35)
	local scaledXOffset = _S(5)
	local scaledSpacing = _S(3)
	
	for key, objectiveObject in ipairs(objectiveHandler:getObjectives()) do
		print("what", objectiveObject)
		
		local display = gui.create("ObjectiveDisplay", frame)
		
		display:setPos(scaledXOffset, elementY)
		display:setSize(frame.rawW - 10, 0)
		display:setObjective(objectiveObject)
		
		elementY = elementY + display.h + scaledSpacing
	end
	
	frame:setHeight(_US(elementY) + 3)
	frame:center()
	objectiveHandler:setViewedTasks(true)
	frameController:push(frame)
	
	return frame
end

game.playthroughRandomizationHoverText = {
	{
		font = "bh20",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		lineSpace = 5,
		text = _T("PLAYTHROUGH_RANDOMIZATION_DESC_1", "Enable randomization to increase replayability value")
	},
	{
		font = "bh18",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "exclamation_point",
		text = _T("PLAYTHROUGH_RANDOMIZATION_DESC_RECOMMENDATION", "Recommended to those that have already played the base game and are looking for more variety in gameplay.")
	}
}

function game.createNewGameMenu()
	if game.gameData.finishedCampaigns then
		if not game.gameData.finishedCampaigns.story_mode then
			game.setDesiredDifficulty("ultra_easy")
		else
			game.setDesiredDifficulty("easy")
		end
	else
		game.setDesiredDifficulty("ultra_easy")
	end
	
	timeline:setTimescaleMultiplier(timeline.DEFAULT_TIMESCALE_MULTIPLIER)
	
	local frame = gui.create("Frame")
	
	frame:setSize(700, 500)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("NEW_GAME_TITLE", "New Game"))
	frame:center()
	
	local scroller = gui.create("ScrollbarPanel", frame)
	
	scroller:setPos(_S(5), _S(35))
	scroller:setSize(200, 273)
	scroller:setAdjustElementPosition(true)
	scroller:setSpacing(4)
	scroller:setPadding(4, 4)
	scroller:setPanelOutlineColor(59, 79, 109, 100)
	scroller:addDepth(100)
	
	local gametypeFrame = gui.create("GametypeDisplay", frame)
	
	gametypeFrame:setSize(frame.rawW - scroller.rawW - 15, frame.rawH - 80)
	gametypeFrame:setPos(scroller.w + _S(10), _S(35))
	gametypeFrame:addDepth(10)
	
	local buttonW = 190 - scroller:getScrollerSize()
	
	for key, gametypeData in ipairs(game.SORTED_GAME_TYPES) do
		local element = gui.create("GametypeSelection")
		
		element:setWidth(buttonW)
		element:setGametypeData(gametypeData)
		element:setGametypeDisplayFrame(gametypeFrame)
		scroller:addItem(element)
	end
	
	local x, y = scroller:getPos()
	local category = gui.create("Category", frame)
	
	category:setFont("bh22")
	category:setText(_T("PLAYTHROUGH_RANDOMIZATION", "Randomization"))
	category:setSize(200, 24)
	category:setPos(x, y + scroller.h + _S(5))
	category:setHoverText(game.playthroughRandomizationHoverText)
	
	local genreTheme = gui.create("RandomizeGenreMatchingDisplay", frame)
	local checkbox = genreTheme:getCheckbox()
	
	checkbox:setTextAlignment(gui.SIDES.RIGHT)
	checkbox:setFont("bh18")
	checkbox:setText(_T("RANDOMIZE_GENRE_THEME_MATCHING", "Genre-theme matching"))
	genreTheme:setSize(200, 24)
	genreTheme:setPos(x, category.localY + category.h + _S(5))
	
	local genreQuality = gui.create("RandomizeGenreQualityDisplay", frame)
	local checkbox = genreQuality:getCheckbox()
	
	checkbox:setTextAlignment(gui.SIDES.RIGHT)
	checkbox:setFont("bh18")
	checkbox:setText(_T("RANDOMIZE_GENRE_QUALITY_MATCHING", "Genre-quality matching"))
	genreQuality:setSize(200, 24)
	genreQuality:setPos(x, genreTheme.localY + genreTheme.h + _S(5))
	
	local platformRandom = gui.create("RandomizePlatformStatsDisplay", frame)
	local checkbox = platformRandom:getCheckbox()
	
	checkbox:setTextAlignment(gui.SIDES.RIGHT)
	checkbox:setFont("bh18")
	checkbox:setText(_T("RANDOMIZE_PLATFORM_STATS", "Platform stats"))
	platformRandom:setSize(200, 24)
	platformRandom:setPos(x, genreQuality.localY + genreQuality.h + _S(5))
	
	local startingThemesGenres = gui.create("RandomizeStartingThemesGenresDisplay", frame)
	local checkbox = startingThemesGenres:getCheckbox()
	
	checkbox:setTextAlignment(gui.SIDES.RIGHT)
	checkbox:setFont("bh18")
	checkbox:setText(_T("RANDOMIZE_STARTING_GENRES_THEMES", "Starting themes & genres"))
	startingThemesGenres:setSize(200, 24)
	startingThemesGenres:setPos(x, platformRandom.localY + platformRandom.h + _S(5))
	
	local startGame = gui.create("NewGameConfirmationButton", frame)
	
	startGame:setSize(200, 34)
	startGame:setFont(fonts.get("pix24"))
	startGame:setText(_T("START_GAME", "Start game"))
	startGame:setPos(x, startingThemesGenres.localY + startingThemesGenres.h + _S(5))
	
	local difficulty = gui.create("DifficultySelectionButton", frame)
	
	difficulty:setSize(200, 34)
	difficulty:setFont(fonts.get("bh24"))
	difficulty:updateText()
	difficulty:setPos(startGame.localX + _S(5) + startGame.w, startGame.localY)
	
	local slider = mainMenu:createTimescaleAdjustmentSlider(frame)
	
	slider:setSize(280, 34)
	slider:setPos(difficulty.localX + difficulty.w + _S(5), difficulty.localY)
	frameController:push(frame)
end

function game.createStatsPopup(text)
	local popup = gui.create("PlaythroughStatsPopup")
	
	popup:setWidth(400)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLAYTHROUGH_STATS_TITLE", "Playthrough Stats"))
	popup:setText(text or "")
	popup:setupDisplay()
	popup:center()
	frameController:push(popup)
end

game.CREDITS = {
	{
		header = _T("CREDITS_DESIGN_AND_PROGRAMMING", "Design & programming"),
		contents = {
			_T("CREDITS_DESIGN_AND_PROGRAMMING_CREDITEE", "Roman \"spy\" Glebenkov")
		}
	},
	{
		header = _T("CREDITS_ART_ASSETS", "Art assets"),
		contents = {
			_T("CREDITS_ART_ASSETS_CREDITEE_1", "@cpmilans"),
			_T("CREDITS_ART_ASSETS_CREDITEE_2", "HarveyDentMustDie"),
			_T("CREDITS_ART_ASSETS_CREDITEE_3", "Sasa Jovanovic"),
			_T("CREDITS_ART_ASSETS_CREDITEE_4", "Zielach"),
			_T("CREDITS_ART_ASSETS_CREDITEE_5", "grisknuckle")
		}
	},
	{
		header = _T("CREDITS_SOUND_ASSETS", "Sound assets"),
		contents = {
			_T("CREDITS_SOUND_ASSETS_CREDITEE_1", "Xtrullor"),
			_T("CREDITS_SOUND_ASSETS_CREDITEE_5", "Navaro"),
			_T("CREDITS_SOUND_ASSETS_CREDITEE_2", "beatscribe"),
			_T("CREDITS_SOUND_ASSETS_CREDITEE_3", "www.freesfx.co.uk"),
			_T("CREDITS_SOUND_ASSETS_CREDITEE_4", "freesound.org")
		}
	},
	{
		header = _T("CREDITS_SOUNDTRACK", "Soundtrack"),
		contents = {
			_T("CREDITS_SOUNDTRACK_CREDITEE_1", "Xtrullor")
		}
	},
	{
		header = _T("CREDITS_TRANSLATION_GERMAN", "Translation - German"),
		contents = {
			_T("CREDITS_TRANSLATION_GERMAN_CREDITEE", "Westman")
		}
	},
	{
		header = _T("CREDITS_TRANSLATION_FRENCH", "Translation - French"),
		contents = {
			_T("CREDITS_TRANSLATION_FRENCH_CREDITEE", "Kimitatsu")
		}
	},
	{
		header = _T("CREDITS_TRANSLATION_CHINESE", "Translation - Chinese"),
		contents = {
			_T("CREDITS_TRANSLATION_CHINESE_CREDITEE", "Mochongli")
		}
	},
	{
		header = _T("CREDITS_SPECIAL_THANKS", "Special thanks"),
		contents = {
			_T("CREDITS_SPECIAL_THANKS_CREDITEE_1", "imitatsiya"),
			_T("CREDITS_SPECIAL_THANKS_CREDITEE_2", "Yoyo"),
			_T("CREDITS_SPECIAL_THANKS_CREDITEE_3", "Konstantin \"fst3a\" Shablya"),
			_T("CREDITS_SPECIAL_THANKS_CREDITEE_4", "Ha_ru"),
			_T("CREDITS_SPECIAL_THANKS_CREDITEE_5", "Trifors"),
			_T("CREDITS_SPECIAL_THANKS_CREDITEE_6", "onlIMoD"),
			_T("CREDITS_SPECIAL_THANKS_CREDITEE_7", "ThereIsNoSpoon")
		}
	},
	{
		header = _T("CREDITS_COOL_GUY", "Cool guy"),
		contents = {
			_T("CREDITS_COOL_GUY_CREDITEE", "Nikolay \"CGNick\" Valkov")
		}
	}
}

function game.createCreditsPopup()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(400)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("GAME_CREDITS_TITLE", "Credits"))
	popup:setText("")
	
	popup.skinPanelFillColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
	popup.skinPanelHoverColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
	
	local scaledLineWidth = _S(383)
	local left, right, extra = popup:getDescboxes()
	
	right:setAlignToRight(true)
	
	local one, two = game.UI_COLORS.STAT_LINE_COLOR_ONE, game.UI_COLORS.STAT_LINE_COLOR_TWO
	local iter = 0
	
	for key, data in ipairs(game.CREDITS) do
		local lineClr = iter % 2 == 0 and one or two
		
		iter = iter + 1
		
		local length = #data.contents
		local headerSpace = length > 1 and 0 or 5
		
		left:addTextLine(scaledLineWidth, lineClr)
		left:addText(data.header, "bh18", nil, headerSpace, 390)
		right:addText(data.contents[1], "bh18", game.UI_COLORS.IMPORTANT_2, headerSpace, 390)
		
		for i = 2, #data.contents do
			local content = data.contents[i]
			local lineClr = iter % 2 == 0 and one or two
			local headerSpace = i == length and 5 or 0
			
			if length > 1 then
				left:addTextLine(scaledLineWidth, lineClr)
				left:addText("", "bh18", nil, headerSpace, 390)
			end
			
			right:addText(content, "bh18", game.UI_COLORS.IMPORTANT_2, headerSpace, 390)
			
			iter = iter + 1
		end
	end
	
	popup:addButton("pix20", _T("CLOSE", "Close"))
	popup:center()
	frameController:push(popup)
end

function game.createFinancesPopup()
	local frame = gui.create("FinancesFrame")
	
	frame:setFont("pix24")
	frame:setTitle(_T("FINANCES_TITLE", "Finances"))
	frame:center()
	frameController:push(frame)
end

function game.attemptCreateDesignSelectionMenu()
	if studio:getEmployeeCountByRole("designer") == 0 then
		local popup = game.createPopup(600, _T("NO_DESIGNERS_AVAILABLE_TITLE", "No Designers Available"), _T("MUST_HIRE_DESIGNERS_TO_DESIGN", "You must first hire a Designer to design new game genres and themes."), "pix24", "pix20", nil)
		
		frameController:push(popup)
	else
		game.createDesignSelectionMenu()
	end
end

function game.createDesignSelectionMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(500, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("SELECT_DESIGNER_TITLE", "Select Designer"))
	frame:center()
	
	local scroller = gui.create("DesignerScrollbarPanel", frame)
	
	scroller:setPos(_S(5), _S(35))
	scroller:setSize(490, 560)
	scroller:setAdjustElementSize(true)
	scroller:setAdjustElementPosition(true)
	scroller:setSpacing(4)
	scroller:setPadding(4, 4)
	scroller:addDepth(50)
	
	local available = gui.create("Category")
	
	available:setFont("bh24")
	available:setText(_T("AVAILABLE_DESIGNERS", "Available designers"))
	available:assumeScrollbar(scroller)
	scroller:setAvailableCategory(available)
	scroller:addItem(available)
	
	local unavailable = gui.create("Category")
	
	unavailable:setFont("bh24")
	unavailable:setText(_T("UNAVAILABLE_DESIGNERS", "Unavailable designers"))
	unavailable:assumeScrollbar(scroller)
	scroller:setUnavailableCategory(unavailable)
	scroller:addItem(unavailable)
	
	for key, employee in ipairs(studio:getEmployees()) do
		if employee:getRole() == "designer" then
			local display = gui.create("EmployeeRoleInteractionButton")
			
			display:setFont(fonts.get("pix20"))
			display:setWidth(470)
			display:setEmployee(employee)
			
			local task = employee:getTask()
			
			if employee:canResearch() and employee:getWorkplace() then
				available:addItem(display, true)
			else
				if not employee:isAvailable() then
					display:setCanClick(false)
				end
				
				unavailable:addItem(display, true)
			end
			
			scroller:addDesigner(display, employee)
		end
	end
	
	frame:center()
	frameController:push(frame)
end

function game.setDesiredGametype(gametype, descbox)
	local prevGametype = game.desiredGametype
	
	if prevGametype and prevGametype ~= gametype then
		local prevData = game.GAME_TYPES_BY_ID[prevGametype]
		
		prevData:onDeselected(descbox)
	end
	
	game.desiredGametype = gametype
	
	if gametype then
		local gametypeData = game.GAME_TYPES_BY_ID[gametype]
		
		gametypeData:onSelected(descbox)
		events:fire(game.EVENTS.DESIRED_GAMETYPE_SET, gametype)
	end
end

function game.getDesiredGametype()
	return game.desiredGametype
end

function game.addObjectSpritebatch(spritebatch, shouldSort)
	table.insert(game.objectSpriteBatches, spritebatch)
	
	if not shouldSort then
		spritebatch:setShouldSortSprites(false)
	end
end

function game.setDesiredDifficulty(id)
	game.desiredDifficulty = id
	
	events:fire(game.EVENTS.DIFFICULTY_CHANGED, id)
end

function game.getDesiredDifficulty()
	return game.desiredDifficulty
end

function game.getMapName(mapFilePath)
	return mapFilePath:gsub(game.MAP_DIRECTORY, ""):gsub(game.MAP_FILE_FORMAT, "")
end

function game.setupFloorData()
	local bMap = studio:getBrightnessMap()
	
	for i = 1, game.worldObject:getFloorCount() do
		pathCaching:setupFloor(i)
		bMap:setupFloor(i)
	end
end

function game.startNewGame(mapID)
	inputService:removeHandler(game.mainInputHandler)
	
	local desiredGametype = game.desiredGametype
	
	game.canSendGridUpdateToThreads = false
	
	game.remove()
	
	game.salaryModel = developer.SALARY_MODEL
	
	game.initPathfinderThreads()
	game.hideHUD()
	
	game.playthroughStartTime = os.time()
	
	game.applyDifficulty(game.desiredDifficulty)
	
	game.desiredDifficulty = nil
	
	math.randomseed(game.playthroughStartTime)
	mainMenu:hide()
	
	if game.playthroughRandomization ~= 0 then
		game.randomizePlaythrough()
	end
	
	game.canSendGridUpdateToThreads = true
	
	loadingScreen:start(0, function()
		game.startingNewGame = true
		
		loadingScreen:updateProgress(0, _T("LOADING_PREPARING_WORLD", "Preparing world"))
		
		game.UNIQUE_ID_COUNTER = 1
		game.UNIQUE_PROJECT_ID = 1
		game.UNIQUE_TEAM_ID = 1
		
		achievements:init()
		studio:init()
		studio:createDefaultTeam()
		employeeCirculation:init()
		scheduledEvents:init()
		engineLicensing:init()
		pathCaching:init()
		autosave:init()
		preferences:init()
		ambientSounds:init()
		serverRenting:init()
		loadingScreen:updateProgress(0.2, _T("LOADING_MISC_SYSTEMS", "Initializing miscellaneous systems"))
		consoleManufacturers:destroyAllManufacturers()
		consoleManufacturers:init()
		platformShare:init()
		review:init()
		yearlyGoalController:init()
		yearlyGoalController:startNewGoal()
		trends:init()
		contractWork:init()
		dialogueHandler:init()
		motivationalSpeeches:init()
		bookController:init()
		objectiveHandler:init()
		rivalGameCompanies:init()
		activities:init()
		objectSelector:init()
		saveSnapshot:init()
		letsPlayers:init()
		platformParts:init()
		gameAwards:init()
		interactionRestrictor:init()
		loadingScreen:updateProgress(0.5, _T("LOADING_GENERATING_STARTING_EMPLOYEES", "Generating starting employees"))
		
		for key, roleData in ipairs(attributes.profiler.visibleRoles) do
			employeeCirculation:generateJobSeeker(roleData.id)
		end
		
		mapID = mapID or game.GAME_TYPES_BY_ID[desiredGametype]:getMap()
		
		loadingScreen:updateProgress(0.55, _T("LOADING_INITIALIZING_WORLD", "Initializing world"))
		game.initWorld(nil, mapID)
		review:findLatestStandardByYear()
		pathComputeQueue:init()
		studio.expansion:init()
		studio:initStartingOfficeCells()
		studio:fillBorderTileWalls(1)
		studio:centerCamera()
		camera:setViewFloor(1)
		lightingManager:init()
		loadingScreen:updateProgress(0.95, _T("LOADING_FINALIZING", "Finalizing"))
		game.setGametype(desiredGametype or game.DEFAULT_GAMETYPE, true)
		game.curGametype:placeObjectsIntoWorld()
		
		for i = 1, game.curGametype:getDefaultJobSeekers() do
			employeeCirculation:generateJobSeeker()
		end
		
		game.sendWholeGridToPathfinderThreads()
		
		game.desiredGametype = nil
		
		gameConventions:init()
		rivalGameCompanies:applyStartingStats()
		platformParts:onNewGame()
		platformShare:onNewGame()
		platformShare:setupMarketSaturation()
		studio:onStartNewGame()
		game.postInitWorld(true)
		pedestrianController:init()
		weather:init()
		timeOfDay:postLoad()
		pedestrianController:postInitUpdate()
		hook.call("startGame")
		objectiveHandler:fillObjectives()
		scheduledEvents:activateInactiveEvents(true)
		randomEvents:init()
		game.curGametype:postStart()
		studio:createNamingPopup()
		events:fire(game.EVENTS.NEW_GAME_STARTED)
		game.finalizeWorld()
		
		game.startingNewGame = false
		
		loadingScreen:finish()
	end)
end

function game.postInitWorld(initialWorld)
	game.cameraPanState = true
	
	game.worldObject:postInit()
	playerPlatform:calculateMinimumDevTime()
	
	if initialWorld then
		for key, officeBuilding in ipairs(studio:getOwnedBuildings()) do
			officeBuilding:upgradeWorkplaces()
		end
		
		studio:reevaluateOffices()
	end
end

function game.getHUD()
	return game.officeStatsDisplay
end

function game.finalizeWorld()
	game.worldObject:startRenderers()
	studio:finalize()
end

function game.getContributionSign(baseValue, currentValue, signSection, maxSigns, positiveColor, negativeColor, skipSignInvertion)
	positiveColor = positiveColor or activities.POSITIVE_TEXT_COLOR
	negativeColor = negativeColor or activities.NEGATIVE_TEXT_COLOR
	
	local positive, negative = "+", "-"
	
	if baseValue < currentValue then
		if not skipSignInvertion then
			positive, negative = negative, positive
		end
	else
		negativePresent = true
	end
	
	local realSection
	
	if type(signSection) == "table" then
		if currentValue < baseValue then
			realSection = signSection[2]
		else
			realSection = signSection[1]
		end
	else
		realSection = signSection
	end
	
	local reppedString, repAmount = string.specificrep(positive, negative, baseValue, baseValue < currentValue and currentValue - baseValue or baseValue - currentValue, realSection, maxSigns)
	local color = baseValue < currentValue and positiveColor[repAmount] or negativeColor[repAmount]
	
	return reppedString, color, repAmount
end

function game.createNewGamePopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("WELCOME_TITLE", "Welcome!"))
	popup:setText(_T("NEW_GAME_INTRO_TEXT", "Welcome to Game Dev Studio! Acquiring a tiny room that will essentially turn into a huge office is the first step towards creating a successful game development studio.\n\nIf you're ever stuck on what to do, click on the question mark bubble at the top of the screen - in most cases it will give you a useful hint."))
	popup:addOKButton(fonts.get("pix20"))
	popup:center()
	frameController:push(popup)
end

function game.updateCameraBounds()
	if game.worldObject then
		local worldWidth, worldHeight = game.worldObject:getFloorTileGrid():getSize()
		
		camera:setBounds(-game.BASE_CAMERA_BOUNDARY, worldWidth * game.WORLD_TILE_WIDTH - scrW / camera.scaleX + game.BASE_CAMERA_BOUNDARY, -game.BASE_CAMERA_BOUNDARY, worldHeight * game.WORLD_TILE_HEIGHT - scrH / camera.scaleY + game.BASE_CAMERA_BOUNDARY)
	end
end

function game.initWorld(wasLoad, mapID, mapData, savedWorldData)
	hook.call("preInitWorld")
	employeeAssignment:initEventHandler()
	studio.driveAffectors:init()
	
	local worldWidth, worldHeight, readData, decompressedMapData
	
	if wasLoad then
		worldWidth, worldHeight = game.WORLD_WIDTH, game.WORLD_HEIGHT
	else
		readData, decompressedMapData = maps:readMap(mapID)
		mapData = readData
		worldWidth, worldHeight = readData.width, readData.height
	end
	
	game.worldObject = world.new(worldWidth, worldHeight, game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT, nil, readData, savedWorldData)
	
	studio.expansion:initGrids()
	
	if not wasLoad then
		studio:setupFloorData()
		game.setupFloorData()
		game.worldObject:loadMap(mapID, readData, decompressedMapData)
	else
		game.setupFloorData()
	end
	
	conversations:init()
	game.updateCameraBounds()
	game.initNewHUD()
	studio:getBrightnessMap():setFloorTileGrid(game.worldObject:getFloorTileGrid())
	
	game.initialGameStarted = true
	
	hook.call("initWorld")
	collectgarbage("collect")
	collectgarbage("collect")
end

game.TIMELINE_POPUP_WIDTH = 300
game.TIMELINE_POPUP_HEIGHT = 500
game.GAME_AWARDS_FRAME_WIDTH = 400
game.TIMELINE_HORIZONTAL_PAD = 5
game.TIMELINE_VERTICAL_PAD = 5
game.EXTRA_CONTRACT_INFO_PANEL_ID = "extra_contract_info_panel"

function game._validateCurrentContractElement(element, scrollbar)
	if element then
		return element
	end
	
	element = gui.create("Category")
	
	element:setFont(fonts.get("pix24"))
	element:setText(_T("CURRENT_CONTRACTS", "Current contracts"))
	element:setHeight(26)
	element:assumeScrollbar(scrollbar)
	scrollbar:addItem(element)
	
	return element
end

function game.createTimelineMenu()
	local frame = gui.create("TimelineFrame")
	
	frame:setSize(game.TIMELINE_POPUP_WIDTH, game.TIMELINE_POPUP_HEIGHT)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("TIMELINE_TITLE", "Timeline"))
	frame:setCloseKey(keyBinding:getCommandKey(keyBinding.COMMANDS.TIMELINE))
	
	local horPad = game.TIMELINE_HORIZONTAL_PAD
	local scaledHorPad = _S(horPad)
	local scaledVerPad = _S(game.TIMELINE_VERTICAL_PAD)
	local baseElementWidth = game.TIMELINE_POPUP_WIDTH - horPad * 2
	local goal = yearlyGoalController:getGoal()
	local x, y = 0, 0
	
	if goal then
		local display = goal:createDisplayElement()
		
		display:setParent(frame)
		display:setWidth(game.TIMELINE_POPUP_WIDTH - horPad * 2)
		display:setPos(scaledHorPad, frame:getTopPartBottom() + scaledVerPad)
		display:addDepth(5)
		display:setCanFold(false)
		display:createTrackCheckbox()
		goal:updateDisplay(display)
		
		x, y = display:getPos()
		y = y + display.h
	else
		x = scaledHorPad
		y = _S(30)
	end
	
	local contractTitle = gui.create("Category", frame)
	
	contractTitle:setPos(x, y + scaledVerPad)
	contractTitle:setFont(fonts.get("pix24"))
	contractTitle:setText(_T("CONTRACT_WORK", "Contract work"))
	contractTitle:setSize(baseElementWidth, 26)
	
	local bottom = contractTitle:getBottom()
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(scaledHorPad, bottom + scaledVerPad)
	scrollbar:setPadding(3, 3)
	scrollbar:setSpacing(3)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setAdjustElementSize(true)
	scrollbar:setSize(baseElementWidth, _US(_S(game.TIMELINE_POPUP_HEIGHT) - scrollbar.y - scaledVerPad))
	scrollbar:addDepth(100)
	
	local w = scrollbar.rawW - _US(scrollbar:getScrollerSize())
	local currentProject = contractWork:getCurrentProject()
	local currentContract
	
	if currentProject then
		currentContract = game._validateCurrentContractElement(currentContract, scrollbar)
		
		local contractDisplay = gui.create("ContractWorkDisplay")
		
		contractDisplay:setSize(w, 104)
		contractDisplay:setProject(currentProject)
		currentContract:addItem(contractDisplay)
	end
	
	for key, contractorObj in ipairs(contractWork:getContractors()) do
		for key, projectObj in ipairs(contractorObj:getProjects()) do
			if projectObj ~= currentProject then
				currentContract = game._validateCurrentContractElement(currentContract, scrollbar)
				
				local contractDisplay = gui.create("ContractWorkDisplay")
				
				contractDisplay:setSize(w, 104)
				contractDisplay:setProject(projectObj)
				currentContract:addItem(contractDisplay)
			end
		end
	end
	
	local pastContracts = gui.create("Category")
	
	pastContracts:setFont(fonts.get("pix24"))
	pastContracts:setText(_T("PAST_CONTRACTS", "Past contracts"))
	pastContracts:assumeScrollbar(scrollbar)
	pastContracts:setHeight(26)
	pastContracts:assumeScrollbar(scrollbar)
	scrollbar:addItem(pastContracts)
	
	local gameIDs = studio:getContractorGames()
	local gameList = studio:getGamesByUniqueID()
	
	for i = #gameIDs, 1, -1 do
		local projectObject = gameList[gameIDs[i]]
		
		if projectObject ~= currentProject and (projectObject:getContractor() or projectObject:getPublisher() and projectObject:getReleaseDate()) then
			local contractDisplay = gui.create("ContractWorkDisplay")
			
			contractDisplay:setShowMilestones(false)
			contractDisplay:setSize(w, 84)
			contractDisplay:setProject(projectObject)
			pastContracts:addItem(contractDisplay)
		end
	end
	
	local totalWidth = 0
	local awardsUnlocked = unlocks:isAvailable(gameAwards.UNLOCK_ID)
	
	if awardsUnlocked then
		totalWidth = _S(game.GAME_AWARDS_FRAME_WIDTH + game.TIMELINE_POPUP_WIDTH + 10)
	else
		totalWidth = _S(game.TIMELINE_POPUP_WIDTH)
	end
	
	frame:setX(scrW * 0.5 - totalWidth * 0.5 - _S(5))
	frame:centerY()
	
	local extraInfoPanel = gui.create("ContractInfo")
	
	extraInfoPanel:setPos(frame.x + _S(10) + frame.w, frame.y)
	extraInfoPanel:setID(game.EXTRA_CONTRACT_INFO_PANEL_ID)
	extraInfoPanel:setWidth(250)
	extraInfoPanel:hideDisplay()
	
	if awardsUnlocked then
		local awardsFrame = gui.create("Frame")
		
		awardsFrame:tieVisibilityTo(frame)
		awardsFrame:setFont("pix24")
		awardsFrame:setText(_T("GAME_AWARDS", "Game Awards"))
		awardsFrame:setSize(game.GAME_AWARDS_FRAME_WIDTH, game.TIMELINE_POPUP_HEIGHT)
		awardsFrame:setPos(frame.x + _S(5) + frame.w, frame.y)
		frame:tieVisibilityTo(awardsFrame)
		
		local infoDisplay = gui.create("GameAwardRegistrationInfo", awardsFrame)
		
		infoDisplay:setPos(scaledHorPad, _S(30) + scaledVerPad)
		infoDisplay:setSize(awardsFrame.rawW - horPad * 2, 95)
		infoDisplay:createButtons()
		infoDisplay:setupDisplay()
		
		local yPos = _S(30) + scaledVerPad + infoDisplay.h
		local scrollbar = gui.create("ScrollbarPanel", awardsFrame)
		
		scrollbar:setPos(scaledHorPad, yPos)
		scrollbar:setPadding(3, 3)
		scrollbar:setSpacing(3)
		scrollbar:setAdjustElementPosition(true)
		scrollbar:setAdjustElementSize(true)
		scrollbar:setSize(awardsFrame.rawW - horPad * 2, awardsFrame.rawH - horPad * 2 - (30 + infoDisplay.rawH))
		scrollbar:addDepth(150)
		
		local cat = gui.create("Category")
		
		cat:setFont("bh26")
		cat:setHeight(29)
		cat:setText(_T("GAME_AWARDS_PARTICIPATION_RESULTS", "Participation Results"))
		cat:assumeScrollbar(scrollbar)
		scrollbar:addItem(cat)
		
		local elemSize = scrollbar.rawW - 30
		
		for key, data in ipairs(studio:getGameAwardWins()) do
			local element = gui.create("GameAwardEntry")
			
			element:setWidth(elemSize)
			element:setData(data)
			cat:addItem(element)
		end
	end
	
	frameController:push(frame)
	
	return frame
end

function game.makePlayerCharacter(employeeObject, age, attributeLevels)
	local employee = game.generateSpecificEmployee("player", "character", game.PLAYER_CHARACTER_STARTING_LEVEL, game.PLAYER_CHARACTER_ROLE, age, false, true)
	
	for key, skillData in ipairs(skills.registered) do
		employee:setSkillLevel(skillData.id, game.PLAYER_CHARACTER_STARTING_SKILL_LEVELS)
	end
	
	employee:setIsPlayerCharacter(true)
	
	return employee
end

function game:loadGameOption()
	mainMenu:createLoadMenu(true, game.getSavedGames(), game.SAVE_DIRECTORY)
end

function game:goToMenuOption()
	game.returnToMainMenu()
end

function game.gameOver(text)
	local popup = gui.create("DescboxPopup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("GAME_OVER_TITLE", "Game Over"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setWidth(500)
	
	text = text or _T("GAME_OVER_DESCRIPTION", "Your studio has stayed in an unacceptable financial situation for an extended period of time, as such you've filed for bankruptcy.")
	
	popup:setText(text)
	popup:hideCloseButton()
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addText(game.pickRandomGameOverTip(), "bh18", nil, 0, popup.rawW - 25, "question_mark", 22, 22)
	popup:addButton(fonts.get("pix20"), _T("LOAD_GAME", "Load game"), game.loadGameOption)
	popup:addButton(fonts.get("pix20"), _T("MAIN_MENU", "Main menu"), game.goToMenuOption)
	popup:center()
	frameController:push(popup)
end

function game.assignUniqueProjectID()
	game.UNIQUE_PROJECT_ID = game.UNIQUE_PROJECT_ID + 1
	
	return game.UNIQUE_PROJECT_ID - 1
end

function game.assignUniqueTeamID()
	game.UNIQUE_TEAM_ID = game.UNIQUE_TEAM_ID + 1
	
	return game.UNIQUE_TEAM_ID - 1
end

function game.getWorld()
	return game.worldObject
end

function game.update(dt)
	game.time = game.time + dt
	
	pathComputeQueue:update()
	game.attemptMoveCamera(dt)
end

game.FASTER_CAMERA_SPEED = 2
game.BASE_CAMERA_SPEED = 1

function game.attemptMoveCamera(dt)
	if game.cameraPanState then
		dt = dt * (game.fasterCameraSpeed and game.FASTER_CAMERA_SPEED or game.BASE_CAMERA_SPEED)
		
		for key, index in ipairs(game.activeCameraKeys) do
			local data = game.CAMERA_MOVE_KEYS[index]
			
			camera:resetVelocities()
			camera:scroll(data.x * dt, data.y * dt)
			interactionController:attemptHide()
		end
	end
end

function game.setCameraPanState(state)
	game.cameraPanState = state
end

function game.clearActiveCameraKeys()
	for key, state in ipairs(game.activeCameraKeys) do
		game.activeCameraKeys[key] = nil
	end
end

function game.attemptSetCameraKey(key, state)
	if camera:isInputAvailable() then
		if game.FASTER_CAMERA_KEYS[key] then
			game.fasterCameraSpeed = state
		else
			for index, list in ipairs(game.CAMERA_MOVE_KEYS) do
				if list.keys[key] then
					if state then
						game.activeCameraKeys[#game.activeCameraKeys + 1] = index
					else
						table.removeObject(game.activeCameraKeys, index)
					end
				end
			end
		end
	end
end

function game.generateRandomEmployee()
	local newEmployee = developer.new()
	
	newEmployee:setAge(math.random(developer.GENERATE_AGE_MIN, developer.GENERATE_AGE_MAX))
	newEmployee:setRetirementAge(math.random(developer.RETIREMENT_AGE_MIN, developer.RETIREMENT_AGE_MAX))
	newEmployee:setLevel(math.random(developer.GENERATE_LEVEL_MIN, developer.GENERATE_LEVEL_MAX))
	newEmployee:assignRandomName()
	newEmployee:assignUniqueID()
	newEmployee:rollForFemale()
	newEmployee:createPortrait()
	attributes.profiler:distributeAttributePoints(newEmployee)
	attributes.profiler:distributeSkillPoints(newEmployee)
	attributes.profiler:rollPreferredGenres(newEmployee)
	skills:updateSkillDevSpeedAffectors(newEmployee)
	factValidity:validateEmployee(newEmployee)
	traits:assignFittingTraits(newEmployee)
	interests:assignToEmployee(newEmployee)
	knowledge:assignFromInterests(newEmployee)
	
	return newEmployee
end

function game.generateSpecificEmployee(name, surname, level, role, age, isFemale, skipFactValidation, addInterests, nationality)
	local newEmployee = developer.new()
	
	newEmployee:setLevel(level or 1)
	
	if nationality then
		newEmployee:setNationality(nationality)
	end
	
	newEmployee:setAge(age or math.random(developer.GENERATE_AGE_MIN, developer.GENERATE_AGE_MAX))
	newEmployee:setRetirementAge(math.random(developer.RETIREMENT_AGE_MIN, developer.RETIREMENT_AGE_MAX))
	
	if isFemale then
		newEmployee:setIsFemale(true)
	else
		newEmployee:rollForFemale()
	end
	
	if name and surname then
		newEmployee:setName(name)
		newEmployee:setSurname(surname)
	else
		newEmployee:assignRandomName()
	end
	
	if role then
		newEmployee:setRole(role)
	end
	
	newEmployee:createPortrait()
	newEmployee:assignUniqueID()
	attributes.profiler:distributeAttributePoints(newEmployee)
	attributes.profiler:distributeSkillPoints(newEmployee)
	skills:updateSkillDevSpeedAffectors(newEmployee)
	attributes.profiler:rollPreferredGenres(newEmployee)
	
	if not skipFactValidation then
		factValidity:validateEmployee(newEmployee)
	end
	
	traits:assignFittingTraits(newEmployee)
	
	if addInterests then
		for key, interestID in ipairs(addInterests) do
			newEmployee:addInterest(interestID)
		end
	else
		interests:assignToEmployee(newEmployee)
	end
	
	knowledge:assignFromInterests(newEmployee)
	
	return newEmployee
end

function game.setCurrentWindow(window)
	game.window = window
	
	if window and window:getCanBlockCamera() then
		game.setCameraPanState(false)
	else
		game.setCameraPanState(true)
	end
end

function game.setSuppressMiscInfoWindows(state)
	game.suppressMiscInfoWindows = state
end

function game.getSuppressMiscInfoWindows()
	return game.suppressMiscInfoWindows
end

function game.getCurrentWindow()
	return game.window
end

function game.setCanOpenMainMenu(can)
	game.canOpenMainMenu = can
end

function game.attemptCloseViaEscape(key)
	local wasKilled = false
	local canOpenMainMenu = true
	
	if game.window and game.window:isValid() then
		canOpenMainMenu = game.window:canCloseViaEscape()
		
		if canOpenMainMenu and game.window:getVisible() then
			wasKilled = true
			
			game.window:kill()
		end
	end
	
	if canOpenMainMenu and not wasKilled and not frameController:preventsMouseOver() and not mainMenu:isShowing() then
		mainMenu:handleKeyPress(key)
	end
end

function game.handleKeyPress(key, isrepeat)
	if game.canOpenMainMenu and key == "escape" then
		game.attemptCloseViaEscape(key)
	end
end

function game.createScroller(parent, width, height, adjustElementPosition)
	if adjustElementPosition == nil then
		adjustElementPosition = true
	end
	
	local scrollBarPanel = gui.create("ScrollbarPanel", parent)
	
	scrollBarPanel:setSize(width, height)
	scrollBarPanel:setAdjustElementPosition(true)
	
	return scrollBarPanel
end

local function fireFunc(self)
	studio:fireEmployee(self.fireTarget)
	
	if self.targetButton then
		self.targetButton.scrollPanel:removeItem(self.targetButton, true)
	end
end

local formatTable = {}

function game.createFireConfirmationPopup(employee, targetButton)
	local popup = gui.create("Popup")
	
	popup:setWidth(350)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("CONFIRM_FIRE_EMPLOYEE_TITLE", "Fire Employee?"))
	
	formatTable.NAME = employee:getFullName(true)
	
	popup:setTextFont(fonts.get("pix20"))
	popup:setText(string.formatByKeys(_T("CONFIRM_FIRE_EMPLOYEE_CONTENT", "Are you sure you want to fire NAME from the studio?\nIt's unlikely that they will be available for hire later on."), formatTable))
	
	local button = popup:addButton(fonts.get("pix20"), "Yes", fireFunc)
	
	button.fireTarget = employee
	button.targetButton = targetButton
	
	popup:addButton(fonts.get("pix20"), "No")
	popup:center()
	frameController:push(popup)
end

function game.createPopup(width, title, text, titleFont, textFont, skipButton, popupClass)
	titleFont = titleFont or fonts.get("pix24")
	textFont = textFont or fonts.get("pix20")
	
	local popup = gui.create(popupClass or "Popup")
	
	popup:setWidth(width or 600)
	popup:setTextFont(textFont)
	popup:setFont(titleFont)
	
	if title then
		popup:setTitle(title)
	end
	
	if text then
		popup:setText(text)
	end
	
	popup:setDepth(105)
	
	if not skipButton then
		popup:addButton(fonts.get("pix20"), "OK")
	end
	
	popup:performLayout()
	popup:center()
	
	return popup
end

function game.createNotEnoughFundsPopup(cost, text)
	text = _format(text or _T("NOT_ENOUGH_FUNDS_DESC", "You do not have enough funds to perform this action.\n\nYou are lacking $MISSING."), "MISSING", string.comma(cost - studio:getFunds()))
	
	local popup = game.createPopup(600, _T("NOT_ENOUGH_FUNDS_TITLE", "Not Enough Funds"), text, "pix24", "pix20", nil)
	
	frameController:push(popup)
	
	return popup
end

function game:genericClearFrameControllerCallback()
	frameController:clearAll()
end

game.filteredAvailableEmployees = {}
game.filteredBusyEmployees = {}
game.developerSkillFilter = ""

function game.getAvailableBusyEmployees(employeeList)
	employeeList = employeeList or studio:getEmployees()
	
	for k, employeeObj in ipairs(employeeList) do
		if not employeeObj:isIdling() then
			game.filteredBusyEmployees[#game.filteredBusyEmployees + 1] = employeeObj
		else
			game.filteredAvailableEmployees[#game.filteredAvailableEmployees + 1] = employeeObj
		end
	end
	
	return game.filteredAvailableEmployees, game.filteredBusyEmployees
end

function game.filterByDeveloperSkill(a, b)
	return a:getSkillLevel(game.developerSkillFilter) > b:getSkillLevel(game.developerSkillFilter)
end

function game.createResearchTask(featureID)
	local featureData = taskTypes.registeredByID[featureID]
	local researchSkill = featureData:getResearchWorkField()
	local researchTask = task.new("research_task")
	
	researchTask:setTaskType(featureID)
	researchTask:setWorkField(researchSkill)
	researchTask:addTrainedSkill(researchSkill, game.RESEARCH_MIN_EXP, game.RESEARCH_MAX_EXP, game.RESEARCH_EXP_MIN_TIME, game.RESEARCH_EXP_MAX_TIME)
	researchTask:setTimeToProgress(0.5)
	researchTask:setRequiredWork(featureData.workAmount * game.RESEARCH_WORK_AMOUNT_MULTIPLIER)
	
	return researchTask
end

function game.updateResearchTask(taskObj, newData)
	local researchSkill = newData:getResearchWorkField()
	local state = taskObj:hasTrainedSkill(researchSkill)
	
	taskObj:setTaskType(newData.id)
	taskObj:setWorkField(researchSkill)
	
	if not state then
		if state == nil then
			taskObj:addTrainedSkill(researchSkill, game.RESEARCH_MIN_EXP, game.RESEARCH_MAX_EXP, game.RESEARCH_EXP_MIN_TIME, game.RESEARCH_EXP_MAX_TIME)
		else
			taskObj:clearPracticeTasks()
			taskObj:addTrainedSkill(researchSkill, game.RESEARCH_MIN_EXP, game.RESEARCH_MAX_EXP, game.RESEARCH_EXP_MIN_TIME, game.RESEARCH_EXP_MAX_TIME)
		end
		
		local assignee = taskObj:getAssignee()
		
		for key, practice in ipairs(taskObj:getTrainedSkills()) do
			practice:setAssignee(assignee)
		end
	end
	
	taskObj:setFinishedWork(0)
	taskObj:setRequiredWork(newData.workAmount * game.RESEARCH_WORK_AMOUNT_MULTIPLIER)
end

function game.createPracticeTask(skillID, expMin, expMax, practiceMin, practiceMax, sessions)
	sessions = sessions or -1
	
	local practice = task.new("practice_skill")
	
	practice:setPracticeSkill(skillID)
	practice:setSessions(sessions)
	practice:setExperienceIncrease(expMin, expMax)
	practice:setPracticeInterval(practiceMin, practiceMax)
	
	return practice
end

function game.createFeatureResearchMenu(featureID)
	local featureData = taskTypes.registeredByID[featureID]
	local frame = gui.create("Frame")
	
	frame:setSize(450, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("SELECT_RESEARCH_ASSIGNEE_TITLE", "Select Research Assignee"))
	
	local scrollbarPanel = game.createScroller(frame, frame.rawW - 8, frame.rawH - 67, true)
	
	scrollbarPanel:setPos(_S(4), _S(30))
	scrollbarPanel:setSpacing(3)
	scrollbarPanel:setPadding(3, 3)
	scrollbarPanel:addDepth(50)
	
	local researchTask = game.createResearchTask(featureID)
	local employees = studio:getEmployees()
	local available, busy = game.getAvailableBusyEmployees(employees)
	
	game.developerSkillFilter = featureData:getResearchWorkField()
	
	table.sortl(busy, game.filterByDeveloperSkill)
	table.sortl(available, game.filterByDeveloperSkill)
	
	if #available > 0 then
		local availableCategory = gui.create("Category")
		
		availableCategory:setHeight(26)
		availableCategory:setFont(fonts.get("pix24"))
		availableCategory:setText(_T("AVAILABLE_EMPLOYEES", "Available employees"))
		availableCategory:assumeScrollbar(scrollbarPanel)
		scrollbarPanel:addItem(availableCategory)
		
		for key, employee in ipairs(available) do
			local element = gui.create("ResearchEmployeeSelection")
			
			element:setSize(410, 60)
			element:setResearchTask(researchTask)
			element:setEmployee(employee)
			availableCategory:addItem(element)
		end
	end
	
	if #busy > 0 then
		local busyEmployees = gui.create("Category")
		
		busyEmployees:setHeight(26)
		busyEmployees:setFont(fonts.get("pix24"))
		busyEmployees:setText(_T("BUSY_EMPLOYEES", "Busy employees"))
		busyEmployees:assumeScrollbar(scrollbarPanel)
		scrollbarPanel:addItem(busyEmployees)
		
		for key, employee in ipairs(busy) do
			local element = gui.create("ResearchEmployeeSelection")
			
			element:setSize(410, 60)
			element:setResearchTask(researchTask)
			element:setEmployee(employee)
			busyEmployees:addItem(element)
		end
	end
	
	table.clear(available)
	table.clear(busy)
	
	local x, y = scrollbarPanel:getPos()
	local startButton = gui.create("BeginResearchButton", frame)
	
	startButton:setSize(scrollbarPanel.rawW, 30)
	startButton:setPos(x, y + _S(scrollbarPanel.rawH + 3))
	startButton:setFont(fonts.get("pix28"))
	startButton:setText(_T("BEGIN_TECH_RESEARCH", "Begin tech research"))
	startButton:setTask(researchTask)
	frame:center()
	frameController:push(frame)
end

function game.removeHUD()
	for i = #game.hudElements, 1, -1 do
		local element = game.hudElements[i]
		
		element:kill()
		table.remove(game.hudElements, i)
	end
end

function game.clearHUDElements()
	game.removeHUD()
	table.clearArray(game.hudElements)
	
	game.engineButton = nil
	game.updateEngineButton = nil
	game.teamManagementButton = nil
	game.propertyButton = nil
	game.jobSeekersButton = nil
	game.hintBubble = nil
	game.eventBox = nil
	game.projectBox = nil
	
	frameController:clearAll()
end

function game.addHUDElement(elem)
	if game.hudHidden then
		elem:hide()
	end
	
	table.insert(game.hudElements, elem)
end

game.addButton = game.addHUDElement

function game.removeHUDElement(elem)
	for key, otherElement in ipairs(game.hudElements) do
		if otherElement == elem then
			table.remove(game.hudElements, key)
			
			break
		end
	end
end

function game.initNewHUD(reinit)
	game.hudElements = game.hudElements and table.clear(game.hudElements) or {}
	game.topHUD = gui.create("HUDTop")
	
	game.topHUD:setSize(scrW, 52)
	game.topHUD:initElements()
	game.topHUD:addDepth(1000)
	
	if reinit then
		game.topHUD:makeTimeAlwaysDisplay()
	end
	
	game.addHUDElement(game.topHUD)
	
	game.bottomHUD = gui.create("HUDBottom")
	
	game.bottomHUD:position()
	game.bottomHUD:createElements()
	game.addHUDElement(game.bottomHUD)
	game.initScrollers()
end

function game.initHUD()
	game.hudElements = game.hudElements and table.clear(game.hudElements) or {}
	game.officeStatsDisplay = gui.create("MainHUD")
	
	game.officeStatsDisplay:setPos(_S(10), _S(10))
	game.officeStatsDisplay:setSize(0, 0)
	game.officeStatsDisplay:createElements()
	game.addHUDElement(game.officeStatsDisplay)
	
	local hintBubble = gui.create("HintBubble")
	
	hintBubble:setSize(45, 45)
	hintBubble:centerX()
	hintBubble:setY(_S(30))
	
	game.hintBubble = hintBubble
	
	game.addHUDElement(game.hintBubble)
	
	local zoomInButton = gui.create("MagnificationButton")
	
	zoomInButton:setSize(32, 32)
	zoomInButton:setDirection(1)
	zoomInButton:setPos(game.projectBox.x + game.projectBox.w + _S(5), game.projectBox.y + game.projectBox.h - zoomInButton.h)
	game.addHUDElement(zoomInButton)
	
	local zoomOutButton = gui.create("MagnificationButton")
	
	zoomOutButton:setSize(32, 32)
	zoomOutButton:setDirection(-1)
	zoomOutButton:setPos(zoomInButton.x, zoomInButton.y - zoomOutButton.h - _S(5))
	game.addHUDElement(zoomOutButton)
end

function game.initScrollers()
	game.eventBox = gui.create("EventBox")
	
	game.eventBox:setSize(400, 200)
	game.eventBox:alignToRight(_S(10))
	game.eventBox:alignToBottom(_S(10))
	game.eventBox:addDepth(1100)
	game.addHUDElement(game.eventBox)
	
	game.projectBox = gui.create("ActiveProjectBox")
	
	game.projectBox:setSize(300, 200)
	game.projectBox:addDepth(200)
	game.projectBox:setX(game.eventBox.x - game.projectBox.w - _S(5))
	game.projectBox:alignToBottom(_S(10))
	game.addHUDElement(game.projectBox)
	
	for key, data in ipairs(game.bufferedEvents) do
		local element = game.eventBox:addEvent(data[2], data[1], data[3])
		
		element:setIcon(data[4])
		
		game.bufferedEvents[key] = nil
	end
	
	local topX, topY = game.topHUD:getPos(true)
	local topH = game.topHUD.h
	local topPad = _US(topH + topY, game.topHUD:getScaler())
	local h = _US(scrH) - topPad - _US(game.eventBox.h) + 4
	local frame = gui.create("InvisibleFrame")
	
	frame:setSize(220, h)
	frame:alignToRight(_S(10))
	frame:setY(_S(54, "new_hud"))
	frame:setCanHover(false)
	game.addHUDElement(frame)
	
	game.projectScroller = gui.create("ProjectScrollbarPanel", frame)
	
	game.projectScroller:setSize(220, h)
	game.projectScroller:setAdjustElementPosition(true)
	game.projectScroller:setAdjustElementSize(false)
	game.projectScroller:setSpacing(3)
	game.projectScroller:setPadding(0, 0)
	game.projectScroller:setCanClick(false)
	game.addHUDElement(game.projectScroller)
end

function game.addToEventBox(textID, data, importance, elementType, icon)
	if not game.eventBox then
		table.insert(game.bufferedEvents, {
			textID,
			data,
			importance,
			elementType,
			icon
		})
		
		return nil
	end
	
	local element = game.eventBox:addEvent(importance, textID, data, elementType)
	
	if icon then
		element:setIcon(icon)
	end
	
	return element
end

function game.addToProjectScroller(element, projectObject)
	game.projectScroller:addItem(element, projectObject)
end

function game.getObjectAtMousePos(employeeList, skipEmployee)
	if gui.elementHovered or gui:isLimitingClicks() then
		objectSelector:reset(true)
		
		return 
	end
	
	if not skipEmployee then
		employeeList = employeeList or studio:getVisibleDevelopers()
		
		for key, dev in ipairs(employeeList) do
			if dev:isMouseOver() and dev:canDrawMouseOver() then
				return dev
			end
		end
	end
	
	if not interactionController:getInteractionObject() then
		local objectGrid = game.worldObject:getObjectGrid()
		local x, y = objectGrid:getRealMouseTileCoordinates()
		local office = studio:getOfficeAtIndex(objectGrid:getTileIndex(x, y))
		
		if office and office:isPlayerOwned() then
			objectSelector:updateInteractionList(objectGrid:getObjects(x, y, camera:getViewFloor()), true)
		elseif objectSelector:getCurrentInteractableObject() then
			objectSelector:reset(true)
			
			return nil
		end
		
		return objectSelector:getCurrentInteractableObject()
	end
end

function game.getObjectsAtMousePos()
	local objectGrid = game.worldObject:getObjectGrid()
	local x, y = objectGrid:getRealMouseTileCoordinates()
	local objects = objectGrid:getObjects(x, y)
	
	return objects
end

function game.showHUD(firstTimeShow)
	if firstTimeShow then
		game.topHUD:makeTimeAlwaysDisplay()
	end
	
	if dialogueHandler:isActive() or frameController:getFrameCount() > 0 or motivationalSpeeches:isActive() or loadingScreen:isActive() then
		return 
	end
	
	game.hudHidden = false
	
	for key, button in ipairs(game.hudElements) do
		if not button:getVisible() then
			button:show()
		end
	end
	
	for key, element in ipairs(game.saleDisplays) do
		if not element:getVisible() then
			element:show()
		end
	end
	
	if game.eventBox then
		game.eventBox:show()
		game.projectBox:show()
	end
end

function game.hideHUD()
	game.hudHidden = true
	
	for key, button in ipairs(game.hudElements) do
		if button:getVisible() then
			button:hide()
		end
	end
	
	for key, element in ipairs(game.saleDisplays) do
		if element:getVisible() then
			element:hide()
		end
	end
	
	if game.eventBox then
		game.eventBox:hide()
		game.projectBox:hide()
	end
end

function game.resetMouseOver()
	game._mouseOverDeveloper = nil
end

function game.getMouseOverObject()
	return game._mouseOverDeveloper
end

function game.setMouseOverObject(object)
	game._mouseOverDeveloper = object
end

function game.createRoleFilter(scrollerObject, showCEO)
	local list = gui.create("RoleFiltererList")
	
	list:setFont("pix24")
	list:setBaseWidth(80)
	list:setTitle(_T("ROLE_FILTER_TITLE", "Filter"))
	list:setDepth(10000)
	list:setScroller(scrollerObject)
	
	local roleList = showCEO and attributes.profiler.roles or attributes.profiler.visibleRoles
	
	for key, roleData in ipairs(roleList) do
		local filter = gui.create("RoleFilterer", list)
		
		filter:setRole(roleData.id)
		filter:setHeight(_S(25))
	end
	
	list:updateLayout()
	
	return list
end

function game.createInvisibleRoleFilter(scrollerObject, showCEO, scaler)
	local list = gui.create("InvisibleRoleFilter")
	
	list:setDepth(10000)
	list:setScroller(scrollerObject)
	
	if scaler then
		list:setScaler(scaler)
	end
	
	local roleList = showCEO and attributes.profiler.roles or attributes.profiler.visibleRoles
	
	list:createElements(48)
	list:updateLayout()
	
	return list
end

function game.openTeamInfoMenu(teamObj)
	local frame = gui.create("Frame")
	
	frame:setFont(fonts.get("pix20"))
	frame:setTitle(teamObj:getName())
	frame:setSize(450, 600)
	frame:performLayout()
	frame:center()
	
	local scrollBarPanel = gui.create("RoleScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(10), _S(35))
	scrollBarPanel:setSize(430, 550)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:addDepth(50)
	
	local list = game.createRoleFilter(scrollBarPanel, true)
	
	list:setPos(frame.x - list.w - _S(10), frame.y)
	scrollBarPanel:setRoleFilterList(list)
	
	local curMembers = gui.create("Category")
	
	curMembers:setFont(fonts.get("pix24"))
	curMembers:setText(_T("CURRENT_TEAM_MEMBERS", "Current team members"))
	curMembers:setWidth(410)
	scrollBarPanel:addItem(curMembers)
	
	for key, memberObj in ipairs(teamObj:getMembers()) do
		local memberPanel = gui.create("EmployeeTeamAssignmentButton")
		
		memberPanel:setCanClick(false)
		memberPanel:setFont(fonts.get("pix20"))
		memberPanel:setSize(410, 20)
		memberPanel:setShortDescription(true)
		memberPanel:setEmployee(memberObj)
		scrollBarPanel:addEmployeeItem(memberPanel)
	end
	
	frameController:push(frame)
end

function game.openTeamManagementMenu(teamObj)
	local frame = gui.create("Frame")
	
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(teamObj:getName())
	frame:setSize(450, 600)
	frame:performLayout()
	frame:center()
	
	local scrollBarPanel = gui.create("RoleScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(10), _S(35))
	scrollBarPanel:setSize(430, 550)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:addDepth(50)
	
	local list = game.createRoleFilter(scrollBarPanel, true)
	
	list:setPos(frame.x - list.w - _S(10), frame.y)
	scrollBarPanel:setRoleFilterList(list)
	
	local curMembers = gui.create("Category")
	
	curMembers:setFont(fonts.get("pix24"))
	curMembers:setText(_T("CURRENT_TEAM_MEMBERS", "Current team members"))
	curMembers:setWidth(360)
	curMembers:assumeScrollbar(scrollBarPanel)
	
	curMembers.teamObj = teamObj
	
	scrollBarPanel:addItem(curMembers)
	
	for key, memberObj in ipairs(teamObj:getMembers()) do
		local memberPanel = gui.create("EmployeeTeamAssignmentButton")
		
		memberPanel:setSize(410, 20)
		memberPanel:addComboBoxOption("unassign")
		memberPanel:setFont(fonts.get("pix20"))
		memberPanel:setShortDescription(true)
		memberPanel:setEmployee(memberObj)
		memberPanel:setTeam(teamObj)
		curMembers:addItem(memberPanel)
		scrollBarPanel:addEmployeeItem(memberPanel, true)
	end
	
	local curMembers = gui.create("Category")
	
	curMembers:setFont(fonts.get("pix24"))
	curMembers:setText(_T("UNASSIGNED_EMPLOYEES", "Unassigned employees"))
	curMembers:setWidth(410)
	curMembers:assumeScrollbar(scrollBarPanel)
	
	curMembers.teamObj = "none"
	
	scrollBarPanel:addItem(curMembers)
	
	local teamless = studio:getTeamlessEmployees()
	
	for key, memberObj in ipairs(teamless) do
		local memberPanel = gui.create("EmployeeTeamAssignmentButton")
		
		memberPanel:setSize(410, 20)
		memberPanel:addComboBoxOption("assign")
		memberPanel:setFont(fonts.get("pix20"))
		memberPanel:setShortDescription(true)
		memberPanel:setEmployee(memberObj)
		memberPanel:setTeam(teamObj)
		curMembers:addItem(memberPanel)
		scrollBarPanel:addEmployeeItem(memberPanel, true)
	end
	
	frameController:push(frame)
end

function game.openTeamCreationMenu()
	if #studio:getTeams() >= game.MAX_TEAMS then
		local popup = game.createPopup(500, _T("MAX_TEAMS_REACHED_TITLE", "Maximum Teams Created"), _T("MAX_TEAMS_REACHED_DESC", "Can not create more teams as you've reached the team count limit."), "pix24", "pix20")
		
		frameController:push(popup)
		
		return 
	end
	
	local newTeam = team.new()
	
	newTeam:setOwner(studio)
	
	local frame = gui.create("Frame")
	
	frame:setSize(450, 600)
	frame:setFont(fonts.get("pix20"))
	frame:setTitle(_T("CREATE_NEW_TEAM_TITLE", "Create New Team"))
	frame:center()
	
	local nameTextbox = gui.create("TeamNameTextBox", frame)
	
	nameTextbox:setTeam(newTeam)
	nameTextbox:setFont(fonts.get("pix24"))
	nameTextbox:setHeight(30)
	nameTextbox:setSize(438, 30)
	nameTextbox:setY(_S(30))
	nameTextbox:setLimitTextToWidth(true)
	nameTextbox:setGhostText(_T("ENTER_TEAM_NAME", "Enter team name"))
	nameTextbox:setShouldCenter(true)
	nameTextbox:centerX()
	
	local scrollBarPanel = gui.create("RoleScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(5), _S(65))
	scrollBarPanel:setSize(440, 500)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:setSpacing(3)
	scrollBarPanel:addDepth(100)
	
	local list = game.createRoleFilter(scrollBarPanel, true)
	
	list:setPos(frame.x - list.w - _S(10), frame.y)
	scrollBarPanel:setRoleFilterList(list)
	
	local curMembers = gui.create("Category")
	
	curMembers:setSize(410, 25)
	curMembers:setFont(fonts.get("pix24"))
	curMembers:setText(_T("ASSIGNED_EMPLOYEES", "Assigned employees"))
	curMembers:assumeScrollbar(scrollBarPanel)
	
	curMembers.teamObj = newTeam
	
	scrollBarPanel:addItem(curMembers)
	
	local unassignedEmployees = gui.create("Category")
	
	unassignedEmployees:setSize(410, 25)
	unassignedEmployees:setFont(fonts.get("pix24"))
	unassignedEmployees:setText(_T("UNASSIGNED_EMPLOYEES", "Unassigned employees"))
	
	unassignedEmployees.teamObj = "none"
	
	unassignedEmployees:assumeScrollbar(scrollBarPanel)
	scrollBarPanel:addItem(unassignedEmployees)
	
	local teamless = studio:getTeamlessEmployees()
	
	for key, memberObj in ipairs(teamless) do
		local memberPanel = gui.create("EmployeeTeamAssignmentButton")
		
		memberPanel:setSize(410, 20)
		memberPanel:addComboBoxOption("desire")
		memberPanel:setFont(fonts.get("pix20"))
		memberPanel:setShortDescription(true)
		memberPanel:setEmployee(memberObj)
		memberPanel:setTeam(newTeam)
		memberPanel:setEmployeeInteractionFill(false)
		unassignedEmployees:addItem(memberPanel)
		scrollBarPanel:addEmployeeItem(memberPanel, true)
	end
	
	local createTeam = gui.create("CreateTeamButton", frame)
	
	createTeam:setFont(fonts.get("pix24"))
	createTeam:setText(_T("CREATE_TEAM", "Create team"))
	createTeam:setSize(440, 25)
	createTeam:setY(_S(570))
	createTeam:centerX()
	createTeam:setTeam(newTeam)
	
	for key, teamObj in ipairs(studio:getTeams()) do
		local curMembers = gui.create("Category")
		
		curMembers:setSize(410, 20)
		curMembers:setFont(fonts.get("pix24"))
		curMembers:setText(string.easyformatbykeys(_T("TEAM_MEMBERS_FORMAT_LAYOUT", "Team 'TEAM' members"), "TEAM", teamObj:getName()))
		
		curMembers.teamObj = teamObj
		
		curMembers:assumeScrollbar(scrollBarPanel)
		scrollBarPanel:addItem(curMembers)
		
		for key, member in ipairs(teamObj:getMembers()) do
			local memberPanel = gui.create("EmployeeTeamAssignmentButton")
			
			memberPanel:setSize(410, 20)
			memberPanel:addComboBoxOption("desire")
			memberPanel:setFont(fonts.get("pix20"))
			memberPanel:setShortDescription(true)
			memberPanel:setEmployee(member)
			memberPanel:setTeam(newTeam)
			memberPanel:setEmployeeInteractionFill(false)
			curMembers:addItem(memberPanel)
			scrollBarPanel:addEmployeeItem(memberPanel, true)
		end
	end
	
	frameController:push(frame)
end

game.DISMANTLING_TEAM_DESCBOX_ID = "dismantling_team_descbox"

function game.openDismantlingMenu(teamToDismantle)
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("REASSIGN_EMPLOYEES_TO_OTHER_TEAM_TITLE", "Switch Employees to Other Team (optional)"))
	frame:center()
	
	local dismantleButton = gui.create("DismantleTeamButton", frame)
	
	dismantleButton:setPos(_S(5), _S(565))
	dismantleButton:setSize(390, 30)
	dismantleButton:setFont("pix26")
	dismantleButton:setTeam(teamToDismantle)
	dismantleButton:updateText()
	
	local scrollBarPanel = gui.create("ScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(5), _S(35))
	scrollBarPanel:setSize(390, 525)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:setSpacing(3)
	scrollBarPanel:addDepth(100)
	
	for key, teamObj in ipairs(studio:getTeams()) do
		if teamObj ~= teamToDismantle then
			local button = gui.create("TeamReassignmentSelection")
			
			button:setFont("pix24")
			button:setSize(360, 25)
			button:setTeam(teamObj)
			button:setConfirmButton(dismantleButton)
			button:updateDescbox()
			scrollBarPanel:addItem(button)
		end
	end
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(game.DISMANTLING_TEAM_DESCBOX_ID)
	teamDescbox:tieVisibilityTo(frame)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	frame:center()
	frameController:push(frame)
end

game.TEAM_MANAGEMENT_DESCBOX_ID = "team_management_descbox"

function game.openManagerAssignmentMenu(manager)
	local frame = gui.create("Frame")
	
	frame:setSize(402, 600)
	frame:setFont(fonts.get("pix20"))
	frame:setTitle(_T("MANAGER_ASSIGNMENT_TITLE", "Manager Assignment"))
	frame:center()
	
	local scrollFrame = gui.create("ScrollbarPanel", frame)
	
	scrollFrame:setPos(_S(5), _S(30))
	scrollFrame:setSize(392, 525)
	scrollFrame:setAdjustElementPosition(true)
	scrollFrame:setPadding(3, 3)
	
	local managementDisplay = gui.create("ManagementLoadDisplay", frame)
	
	managementDisplay:setSize(frame.rawW - 10, 35)
	managementDisplay:setPos(_S(5), frame.h - _S(5) - managementDisplay.h)
	managementDisplay:setManager(manager)
	
	local curTeams = gui.create("Category")
	
	curTeams:setFont(fonts.get("pix24"))
	curTeams:setText(_T("ALL_TEAMS", "All teams"))
	curTeams:setWidth(360)
	scrollFrame:addItem(curTeams)
	
	for key, curTeam in ipairs(studio:getTeams()) do
		local TeamButton = gui.create("TeamButton")
		
		TeamButton:setFont(fonts.get("pix24"))
		TeamButton:setSize(360, 65)
		TeamButton:setBasePanel(frame)
		TeamButton:addComboBoxOption("assignmanager")
		
		TeamButton.manager = manager
		
		TeamButton:setTeam(curTeam)
		TeamButton:setThoroughDescription(true)
		TeamButton:updateDescbox()
		
		TeamButton.descboxID = game.TEAM_MANAGEMENT_DESCBOX_ID
		
		scrollFrame:addItem(TeamButton)
	end
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(game.TEAM_MANAGEMENT_DESCBOX_ID)
	teamDescbox:tieVisibilityTo(frame)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	frameController:push(frame)
end

require("game/game_over_tips")
