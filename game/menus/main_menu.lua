mainMenu = {}
mainMenu.showing = false
mainMenu.buttonWidth = 200
mainMenu.buttonHeight = 35
mainMenu.buttonSpacing = 5
mainMenu.buttonXOffset = 50
mainMenu.optionsMenuDistance = 5
mainMenu.backgroundColor = color(0, 19, 28, 255)

function mainMenu:show()
	self.showing = true
	
	self:createMainMenu()
	musicPlayback:setPlaylist(musicPlayback.PLAYLIST_IDS.MENU)
	layerRenderer:addLayer(game.mainMenuRenderer)
	gameStateService:removeState(game.mainState)
end

function mainMenu:hide()
	self.showing = false
	
	layerRenderer:removeLayer(game.mainMenuRenderer)
end

function mainMenu:isShowing()
	if self.loadFrame and self.loadFrame:isValid() then
		return true
	end
	
	if self.inGameFrame and self.inGameFrame:isValid() then
		return true
	end
	
	return false
end

mainMenu.genericOutlineColor = color(0, 0, 0, 75)

function mainMenu:createTimescaleAdjustmentSlider(parent, timeValue)
	local timescaleRange = timeline.ADJUST_TIMESCALE_RANGE
	local timescaleSlider = gui.create("TimescaleAdjustmentSlider", parent)
	
	timescaleSlider:setFont("bh20")
	timescaleSlider:setText(_T("TIMESCALE_ADJUSTMENT", "Timescale: xSLIDER_VALUE"))
	timescaleSlider:setRounding(2)
	timescaleSlider:setMinMax(timescaleRange[1], timescaleRange[2])
	timescaleSlider:setValue(timeValue or timeline.DEFAULT_TIMESCALE_MULTIPLIER)
	
	return timescaleSlider
end

function mainMenu:createOptionsMenu()
	if gui:isLimitingClicks() then
		gui:disableClickIDs()
	end
	
	local frame = gui.create("Frame")
	
	frame:setSize(470, 400)
	frame:setFont(fonts.get("pix20"))
	frame:setTitle(_T("OPTIONS_TITLE", "Options"))
	
	local propertySheet = gui.create("PropertySheet", frame)
	
	propertySheet:setSize(460, frame.rawH - 30)
	propertySheet:setPos(_S(5), _S(30))
	propertySheet:setFont(fonts.get("pix22"))
	
	local panelHeight = propertySheet.rawH - 35
	local videoPanel = gui.create("Panel")
	
	videoPanel:setSize(460, panelHeight)
	
	videoPanel.alpha = mainMenu.genericOutlineColor.a
	videoPanel.drawColor = mainMenu.genericOutlineColor
	
	local resolutionSelection = gui.create("ResolutionButton", videoPanel)
	
	resolutionSelection:setSize(200, 30)
	resolutionSelection:setFont(fonts.get("pix24"))
	resolutionSelection:setDepth(1000)
	self:addOptionCombo(_T("RESOLUTION", "Resolution"), resolutionSelection)
	
	local displaySel = gui.create("DisplaySelectionButton", videoPanel)
	
	displaySel:setSize(200, 30)
	displaySel:setFont(fonts.get("pix24"))
	displaySel:setDepth(1000)
	self:addOptionCombo(_T("DISPLAY", "Display"), displaySel)
	
	local screenModeSelection = gui.create("ScreenModeButton", videoPanel)
	
	screenModeSelection:setSize(200, 30)
	screenModeSelection:setFont(fonts.get("pix24"))
	screenModeSelection:setDepth(1000)
	self:addOptionCombo(_T("SCREEN_MODE", "Screen mode"), screenModeSelection)
	
	local vsyncButton = gui.create("VsyncButton", videoPanel)
	
	vsyncButton:setSize(200, 30)
	vsyncButton:setFont(fonts.get("pix24"))
	vsyncButton:setDepth(1000)
	self:addOptionCombo(_T("VERTICAL_SYNC", "Vertical sync"), vsyncButton)
	
	local shadowsButton = gui.create("ShadowsButton", videoPanel)
	
	shadowsButton:setSize(200, 30)
	shadowsButton:setFont(fonts.get("pix24"))
	shadowsButton:setDepth(1000)
	self:addOptionCombo(_T("CAST_SHADOWS", "Cast shadows"), shadowsButton)
	
	local ambientOcclusionButton = gui.create("ShadowShaderButton", videoPanel)
	
	ambientOcclusionButton:setSize(200, 30)
	ambientOcclusionButton:setFont(fonts.get("pix24"))
	ambientOcclusionButton:setDepth(1000)
	self:addOptionCombo(_T("SHADOW_SHADER", "Ambient occlusion"), ambientOcclusionButton)
	
	local lightmapQualityButton = gui.create("LightmapQualityButton", videoPanel)
	
	lightmapQualityButton:setSize(200, 30)
	lightmapQualityButton:setFont(fonts.get("pix24"))
	lightmapQualityButton:setDepth(1000)
	self:addOptionCombo(_T("LIGHTMAP_SIZE", "Lightmap size"), lightmapQualityButton)
	
	local weatherIntensityCombo = gui.create("WeatherIntensityButton", videoPanel)
	
	weatherIntensityCombo:setSize(200, 30)
	weatherIntensityCombo:setFont(fonts.get("pix24"))
	weatherIntensityCombo:setDepth(1000)
	self:addOptionCombo(_T("WEATHER_INTENSITY", "Weather intensity"), weatherIntensityCombo)
	
	local pedCount = gui.create("PedestrianCountButton", videoPanel)
	
	pedCount:setSize(200, 30)
	pedCount:setFont(fonts.get("pix24"))
	pedCount:setDepth(1000)
	self:addOptionCombo(_T("PEDESTRIAN_COUNT", "Pedestrian count"), pedCount)
	propertySheet:addItem(videoPanel, _T("VIDEO", "Video"), nil, nil, nil)
	
	local generalPanel = gui.create("Panel")
	
	generalPanel:setSize(460, panelHeight)
	
	generalPanel.alpha = mainMenu.genericOutlineColor.a
	generalPanel.drawColor = mainMenu.genericOutlineColor
	
	propertySheet:addItem(generalPanel, _T("GENERAL_SETTINGS", "General"), nil, nil, nil)
	
	local autosaveButton = gui.create("AutosaveButton", generalPanel)
	
	autosaveButton:setSize(200, 30)
	autosaveButton:setFont(fonts.get("pix24"))
	autosaveButton:setDepth(1000)
	self:addOptionCombo(_T("AUTOSAVE", "Autosave"), autosaveButton)
	
	local snapshotButton = gui.create("SnapshotButton", generalPanel)
	
	snapshotButton:setSize(200, 30)
	snapshotButton:setFont(fonts.get("pix24"))
	snapshotButton:setDepth(1000)
	self:addOptionCombo(_T("SAVEFILE_SNAPSHOT", "Savefile snapshot"), snapshotButton)
	
	local languageButton = gui.create("LanguageSelectionButton", generalPanel)
	
	languageButton:setSize(200, 30)
	languageButton:setFont(fonts.get("pix24"))
	languageButton:setDepth(1000)
	self:addOptionCombo(_T("LANGUAGE_BUTTON", "Language"), languageButton)
	
	local languageButton = gui.create("InstantPopupsButton", generalPanel)
	
	languageButton:setSize(200, 30)
	languageButton:setFont(fonts.get("pix24"))
	languageButton:setDepth(1000)
	self:addOptionCombo(_T("INSTANT_POPUPS", "Instant popups"), languageButton)
	
	if game.worldObject then
		local languageButton = gui.create("GenerateRivalsButton", generalPanel)
		
		languageButton:setSize(200, 30)
		languageButton:setFont(fonts.get("pix24"))
		languageButton:setDepth(1000)
		self:addOptionCombo(_T("GENERATE_RIVALS_BUTTON", "Generate rivals"), languageButton)
		
		local slider = mainMenu:createTimescaleAdjustmentSlider(generalPanel, timeline:getTimescaleMultiplier())
		
		slider:setSize(450, 34)
		slider:setPos(_S(5), languageButton.localY + languageButton.h + _S(10))
		
		generalPanel.totalOptionsHeight = generalPanel.totalOptionsHeight + _S(10) + slider.h
	end
	
	local keyBindPanel = gui.create("Panel")
	
	keyBindPanel:setSize(460, panelHeight)
	
	keyBindPanel.alpha = mainMenu.genericOutlineColor.a
	keyBindPanel.drawColor = mainMenu.genericOutlineColor
	
	propertySheet:addItem(keyBindPanel, _T("CONTROLS", "Controls"), nil, nil, nil)
	
	for key, commandName in ipairs(keyBinding:getCommandNameOrder()) do
		local commandBinding = gui.create("KeyBindingOption", keyBindPanel)
		
		commandBinding:setSize(200, 28)
		commandBinding:setFont(fonts.get("pix24"))
		commandBinding:setDepth(1000)
		commandBinding:setCommand(commandName)
		self:addOptionCombo(keyBinding:getCommandName(commandName), commandBinding)
	end
	
	local audioPanel = gui.create("Panel")
	
	audioPanel:setSize(460, panelHeight)
	
	audioPanel.alpha = mainMenu.genericOutlineColor.a
	audioPanel.drawColor = mainMenu.genericOutlineColor
	
	local effectSlider = gui.create("EffectVolumeAdjustmentSlider", audioPanel)
	
	effectSlider:setSize(0, 40)
	self:addOptionCombo(nil, effectSlider)
	
	local effectSlider = gui.create("SpeechVolumeAdjustmentSlider", audioPanel)
	
	effectSlider:setSize(0, 40)
	self:addOptionCombo(nil, effectSlider)
	
	local ambientSlider = gui.create("AmbientVolumeAdjustmentSlider", audioPanel)
	
	ambientSlider:setSize(0, 40)
	self:addOptionCombo(nil, ambientSlider)
	
	local musicSlider = gui.create("MusicVolumeAdjustmentSlider", audioPanel)
	
	musicSlider:setSize(0, 40)
	self:addOptionCombo(nil, musicSlider)
	propertySheet:addItem(audioPanel, _T("AUDIO_SETTINGS", "Audio"), nil, nil, nil)
	
	if game.curGametype then
		game.curGametype:fillOptionsMenu(generalPanel)
	end
	
	frame:center()
	frameController:push(frame)
end

function mainMenu:addOptionCombo(headerText, element)
	local parent = element:getParent()
	
	parent.totalOptionsHeight = parent.totalOptionsHeight or _S(self.optionsMenuDistance)
	
	if headerText then
		local label = gui.create("Label", parent)
		
		label:setFont(fonts.get("pix22"))
		label:setText(headerText)
		label:setPos(_S(self.optionsMenuDistance), parent.totalOptionsHeight + (element.h * 0.5 - label.h * 0.5))
		label:setDepth(element:getDepth() + 10)
		element:setPos(parent.w - element.w - _S(self.optionsMenuDistance), parent.totalOptionsHeight)
	else
		element:setPos(_S(self.optionsMenuDistance), parent.totalOptionsHeight)
		element:setWidth(parent.rawW - self.optionsMenuDistance * 2)
	end
	
	parent.totalOptionsHeight = parent.totalOptionsHeight + element:getHeight() + _S(self.optionsMenuDistance)
end

function mainMenu:createModMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(300, 210)
	frame:setFont("pix24")
	frame:setTitle(_T("MODDING_TITLE", "Modding"))
	
	local buttonWidth = frame.rawW - 10
	local workButton = gui.create("OpenWorkshopButton", frame)
	
	workButton:setPos(_S(5), _S(35))
	workButton:setSize(buttonWidth, 30)
	workButton:setFont("bh24")
	workButton:setText(_T("STEAM_WORKSHOP", "Steam Workshop"))
	
	if not steam then
		workButton:setCanClick(false)
	end
	
	local localMods = gui.create("ShowLocalModsButton", frame)
	
	localMods:setPos(workButton.x, workButton.y + workButton.h + _S(5))
	localMods:setSize(buttonWidth, 30)
	localMods:setFont("bh24")
	localMods:setText(_T("LOCAL_MODS", "Local mods"))
	
	local mapEditorButton = gui.create("MapEditorButton", frame)
	
	mapEditorButton:setSize(buttonWidth, 30)
	mapEditorButton:setPos(localMods.x, localMods.y + localMods.h + _S(5))
	mapEditorButton:setFont("bh24")
	
	local prefabEditorButton = gui.create("PrefabEditorButton", frame)
	
	prefabEditorButton:setSize(buttonWidth, 30)
	prefabEditorButton:setPos(mapEditorButton.x, mapEditorButton.y + mapEditorButton.h + _S(5))
	prefabEditorButton:setFont("bh24")
	
	if love.system.getOS() == "Windows" then
		local cbox = gui.create("ConsoleCheckbox", frame)
		
		cbox:setSize(30, 30)
		cbox:setFont("bh24")
		cbox:setText(_T("OPEN_CONSOLE", "Open console"))
		cbox:setPos(_S(5), frame.h - cbox.h - _S(5))
	end
	
	frame:center()
	frameController:push(frame)
end

function mainMenu:createMainMenu()
	mapEditor:leave()
	gui.removeAllUIElements()
	
	if game.SHOW_SPLASH_SCREEN then
		local fader = gui.create("ScreenFader")
		
		fader:setTargetAlpha(1)
		fader:setAlpha(1)
		fader:setFadeState(fader.STATES.OUT)
		fader:addDepth(100)
		fader:setSize(scrW, scrH)
		fader:setFadeColor(mainMenu.backgroundColor)
	end
	
	local decor = gui.create("MainMenuDecor")
	
	decor:setSprite("main_menu_background")
	decor:setSize(1680, 720)
	decor:addDepth(-11)
	
	local yOffset = scrH - decor.h
	local xOffset = scrW - decor.w
	
	decor:setPos(xOffset, yOffset)
	
	local lightDecor = gui.create("MainMenuLight")
	
	lightDecor:setSize(624, 608)
	lightDecor:setPos(decor.w - lightDecor.w + xOffset, _S(112) + yOffset)
	lightDecor:addDepth(-5)
	
	local propXOffset = _S(400)
	local lightDecor = gui.create("MainMenuCeilingFan")
	
	lightDecor:setSize(252, 224)
	lightDecor:setPos(_S(800) + xOffset + propXOffset, yOffset)
	lightDecor:addDepth(-10)
	
	local exitGame = gui.create("MainMenuExitGame")
	
	exitGame:setSize(196, 356)
	exitGame:setPos(_S(172) + xOffset + propXOffset, _S(116) + yOffset)
	exitGame:addDepth(-10)
	
	local loadGame = gui.create("MainMenuLoadGame")
	
	loadGame:setSize(88, 168)
	loadGame:setPos(exitGame.x + _S(140) + exitGame.w, exitGame.y + _S(28))
	loadGame:addDepth(-9)
	
	local options = gui.create("MainMenuOptions")
	
	options:setSize(152, 304)
	options:setPos(loadGame.x + _S(196) + loadGame.w, loadGame.y + _S(32))
	options:addDepth(-9)
	
	local newGame = gui.create("MainMenuNewGame")
	
	newGame:setSize(160, 136)
	newGame:setPos(loadGame.x - _S(24) + loadGame.w, loadGame.y + _S(216))
	newGame:addDepth(-9)
	
	local modding = gui.create("MainMenuModding")
	
	modding:setSize(188, 116)
	modding:setPos(newGame.x + newGame.w + _S(120), newGame.y + _S(216))
	modding:addDepth(-2)
	
	local coffeeDecor = gui.create("MainMenuCoffee")
	
	coffeeDecor:setSize(160, 136)
	coffeeDecor:setPos(newGame.x + newGame.w + _S(48), newGame.y + newGame.h - _S(68))
	coffeeDecor:addDepth(-4)
	
	local credits = gui.create("MainMenuCredits")
	
	credits:setSize(48, 56)
	credits:setPos(newGame.x - _S(20) - credits.w, newGame.y + _S(80))
	credits:addDepth(-9)
	
	if DEBUG_MODE then
		local mapEditorButton = gui.create("MapEditorButton")
		
		mapEditorButton:setSize(self.buttonWidth, self.buttonHeight)
		self:registerButton(mapEditorButton)
	end
	
	self:positionButtons()
end

function mainMenu:registerButton(button)
	game.addButton(button)
end

function mainMenu:positionButtons()
	local midPoint = scrH * 0.5
	local scaledGap = _S(mainMenu.buttonHeight + mainMenu.buttonSpacing)
	local totalHeight = #game.hudElements * scaledGap
	local halfHeight = totalHeight * 0.5
	local curY = midPoint - halfHeight
	local scaledPad = _S(mainMenu.buttonXOffset)
	
	for key, button in ipairs(game.hudElements) do
		button:setPos(scaledPad, curY)
		
		curY = curY + scaledGap
	end
end

local function onCloseLoadMenu(self)
	frameController:pop()
end

local function sortBySaveDate(a, b)
	local aData = a:getPreviewData()
	local bData = b:getPreviewData()
	
	return aData.saveDate > bData.saveDate
end

function mainMenu:createLoadMenu(hideCloseButton, savegameList, pathToFolder, title, snapshots, deleteSavefiles)
	if not self.showing and not self.inGameFrame and not snapshots then
		local validSave = false
		
		for key, path in ipairs(savegameList) do
			if string.find(path, game.SAVE_FILE_FORMAT) and not string.find(path, game.SAVE_FILE_FORMAT_PREVIEW) then
				validSave = true
				
				break
			end
		end
		
		if not validSave then
			local popup = gui.create("Popup")
			
			popup:setWidth(500)
			popup:setFont("pix24")
			popup:setTitle(_T("NO_SAVEGAMES_AVAILABLE_TITLE", "No Savegames Available"))
			popup:setTextFont("pix20")
			popup:setText(_T("NO_SAVEGAMES_AVAILABLE_DESC", "You do not have any savegames to load."))
			popup:hideCloseButton()
			popup:addButton(fonts.get("pix20"), _T("MAIN_MENU", "Main menu"), game.goToMenuOption)
			popup:center()
			frameController:push(popup)
			
			return 
		end
	end
	
	title = title or _T("SELECT_SAVE_GAME", "Select save game")
	
	local frame = gui.create("Frame")
	
	frame:setSize(500, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setText(title)
	frame:center()
	
	if hideCloseButton then
		frame:hideCloseButton()
	end
	
	frame.onKill = onCloseLoadMenu
	self.loadFrame = frame
	
	local scrollBar = gui.create("SaveGameScrollbarPanel", frame)
	
	scrollBar:setPos(_S(5), _S(35))
	scrollBar:setSize(490, 560)
	scrollBar:setAdjustElementPosition(true)
	scrollBar:setSpacing(4)
	scrollBar:setPadding(4, 4)
	scrollBar:addDepth(100)
	
	local curSave = 1
	local insertOrder = {}
	local missingPreview = {}
	
	for key, path in ipairs(savegameList) do
		if string.find(path, game.SAVE_FILE_FORMAT) and not string.find(path, game.SAVE_FILE_FORMAT_PREVIEW) then
			local loadSaveButton = gui.create("SaveGameSelectionButton")
			
			loadSaveButton:setHeight(90)
			
			if snapshots ~= nil then
				loadSaveButton:setIsSnapshot(snapshots)
			end
			
			loadSaveButton:setCanDeleteSavefiles(deleteSavefiles)
			loadSaveButton:setSavegameIndex(curSave)
			loadSaveButton:setFile(path, pathToFolder)
			
			if loadSaveButton:getPreviewData() then
				insertOrder[#insertOrder + 1] = loadSaveButton
			else
				missingPreview[#missingPreview + 1] = loadSaveButton
			end
			
			curSave = curSave + 1
		end
	end
	
	table.sort(insertOrder, sortBySaveDate)
	
	for key, button in ipairs(insertOrder) do
		scrollBar:addItem(button)
		
		insertOrder[key] = nil
	end
	
	for key, button in ipairs(missingPreview) do
		scrollBar:addItem(button)
		
		missingPreview[key] = nil
	end
	
	for key, item in ipairs(scrollBar:getItems()) do
		if item:canDraw() then
			item:verifyScreenshot()
		end
	end
	
	frameController:push(frame)
end

function mainMenu:closeLoadMenu()
	self.loadFrame.onKill = nil
	
	self.loadFrame:kill()
	
	self.loadFrame = nil
end

function mainMenu:handleKeyPress(key)
	if key == "escape" and game.worldObject then
		mainMenu:toggleInGameMenu()
	end
end

function mainMenu:toggleInGameMenu()
	if not self:isShowing() then
		self:createInGameMenu()
	else
		self:closeInGameMenu()
	end
end

function mainMenu:draw()
	love.graphics.setBackgroundColor(mainMenu.backgroundColor:unpack())
end

mainMenu.SAVE_GAME_BUTTON_ID = "save_game"
mainMenu.SAVE_AND_QUIT_BUTTON_ID = "save_and_quit"
mainMenu.QUIT_TO_MAIN_MENU_ID = "quit_to_main_menu"
mainMenu.OPTIONS_BUTTON_ID = "options_button"
mainMenu.PLAYTHROUGH_STATS_BUTTON_ID = "playthrough_stats"
mainMenu.LOAD_GAME_BUTTON_ID = "load_game"

function mainMenu:postKillQuickMenu()
	gui:enableClickIDs()
	mainMenu:closeInGameMenu()
end

function mainMenu:canSaveGame()
	return not motivationalSpeeches:isActive()
end

function mainMenu:createInGameMenu()
	local frame = gui.create("Frame")
	
	frame:setFont(fonts.get("pix24"))
	frame:setText(_T("IN_GAME_MENU", "Game"))
	
	frame.postKill = mainMenu.postKillQuickMenu
	
	frame:setAnimated(false)
	
	self.inGameFrame = frame
	self.inGameButtons = self.inGameButtons or {}
	self.totalButtonHeight = _S(35)
	
	local disabledSaving = game.getSavingDisabled() or not self:canSaveGame()
	local editorState = game.getEditorState()
	local playthroughStatsButton = gui.create("PlaythroughStatsButton", frame)
	
	self:addInGameMenuButton(playthroughStatsButton)
	playthroughStatsButton:setFont(fonts.get("pix20"))
	playthroughStatsButton:setID(mainMenu.PLAYTHROUGH_STATS_BUTTON_ID)
	
	if editorState then
		playthroughStatsButton:setCanClick(false)
	end
	
	local options = gui.create("OptionsMenuButton", frame)
	
	self:addInGameMenuButton(options)
	options:setFont("pix20")
	options:setID(mainMenu.OPTIONS_BUTTON_ID)
	
	local loadButton = gui.create("LoadGameButton", frame)
	
	self:addInGameMenuButton(loadButton)
	loadButton:setFont(fonts.get("pix20"))
	loadButton:setID(mainMenu.LOAD_GAME_BUTTON_ID)
	
	if editorState then
		loadButton:setCanClick(false)
	end
	
	local saveButton = gui.create("SaveGameButton", frame)
	
	if disabledSaving or editorState then
		saveButton:setCanClick(false)
	end
	
	self:addInGameMenuButton(saveButton)
	saveButton:setFont(fonts.get("pix20"))
	saveButton:setID(mainMenu.SAVE_GAME_BUTTON_ID)
	
	local saveAndQuitButton = gui.create("SaveAndQuitButton", frame)
	
	self:addInGameMenuButton(saveAndQuitButton)
	
	if disabledSaving or editorState then
		saveAndQuitButton:setCanClick(false)
	end
	
	saveAndQuitButton:setFont(fonts.get("pix20"))
	saveAndQuitButton:setID(mainMenu.SAVE_AND_QUIT_BUTTON_ID)
	
	local quitButton = gui.create("QuitToMainMenuButton", frame)
	
	self:addInGameMenuButton(quitButton)
	quitButton:setFont(fonts.get("pix20"))
	quitButton:setID(mainMenu.QUIT_TO_MAIN_MENU_ID)
	frame:setSize(160, _US(self.totalButtonHeight))
	frame:center()
	frameController:push(frame)
	gui:disableClickIDs()
	
	return frame
end

function mainMenu:addInGameMenuButton(button)
	button:setSize(140, 20)
	button:setPos(_S(10), self.totalButtonHeight)
	
	self.inGameButtons[#self.inGameButtons + 1] = button
	self.totalButtonHeight = self.totalButtonHeight + button.h + _S(5)
end

function mainMenu:getInGameMenu()
	return self.inGameFrame
end

function mainMenu:closeInGameMenu()
	if self.inGameFrame then
		self.inGameFrame:kill()
		
		self.inGameFrame = nil
	end
	
	if self.inGameButtons then
		table.clearArray(self.inGameButtons)
	end
	
	self.showing = false
end

function mainMenu:setupDesiredSaveName()
	game.desiredSaveName = game.currentLoadedSaveFile or ""
	
	if game.currentLoadedSaveFile then
		local finalText = string.gsub(game.currentLoadedSaveFile, game.SAVE_DIRECTORY, "")
		
		finalText = string.gsub(finalText, game.SAVE_FILE_FORMAT, "")
		game.desiredSaveName = finalText
	else
		game.desiredSaveName = ""
	end
end

function mainMenu:createSavegameNamingPopup(quitAfterSaving)
	self:setupDesiredSaveName()
	
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText(_T("ENTER_SAVEGAME_NAME", "Save game"))
	frame:setSize(285, 95)
	frame:setAnimated(false)
	
	local confirmButton = gui.create("GameSaveConfirmButton", frame)
	
	confirmButton:setSize(135, 24)
	confirmButton:setFont("pix24")
	confirmButton:setText(_T("SAVE_CONFIRM", "Save"))
	
	local textBox = gui.create("SaveFileNameTextBox", frame)
	
	textBox:setPos(_S(5), _S(35))
	textBox:setSize(frame.rawW - 10, 25)
	textBox:setFont("pix24")
	textBox:setConfirmButton(confirmButton)
	textBox:updateSaveName()
	textBox:setLimitTextToWidth(true)
	confirmButton:setPos(_S(5), textBox.y + textBox.h + _S(5))
	confirmButton:setQuitToMenuAfterSaving(quitAfterSaving)
	
	local cancelButton = gui.create("GameSaveCancelButton", frame)
	
	cancelButton:setSize(135, 24)
	cancelButton:setFont("pix24")
	cancelButton:setText(_T("SAVE_CANCEL", "Cancel"))
	cancelButton:setPos(confirmButton.x + confirmButton.w + _S(5), confirmButton.y)
	frame:center()
	frameController:push(frame)
end
