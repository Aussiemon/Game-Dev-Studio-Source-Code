projectsMenu = {}
projectsMenu.frame = nil
projectsMenu.projectRecordScrollbar = nil
projectsMenu.inProgressCategory = nil
projectsMenu.unreleasedCategory = nil
projectsMenu.finishedCategory = nil
projectsMenu.inProgressCategory = nil
projectsMenu.projectElementObjects = {}
projectsMenu.platformElementObjects = {}
projectsMenu.researchCategories = {}
projectsMenu.switchableTabs = {}
projectsMenu.categoryTitlesByTaskCategory = {}
projectsMenu.infoDisplays = {}
projectsMenu.featuresInResearch = nil
projectsMenu.OPEN_MENU_ACTION = "open_projects_menu"
projectsMenu.EVENTS = {
	OPENED = events:new(),
	CLOSED = events:new(),
	ENGINES_TAB_OPENED = events:new(),
	NEW_GAME_TAB_OPENED = events:new(),
	PLATFORMS_TAB_OPENED = events:new(),
	RESEARCH_TAB_OPENED = events:new(),
	PROJECTS_TAB_OPENED = events:new()
}
projectsMenu.ELEMENT_IDS = {
	RESEARCH = "research_tab_button",
	ENGINES = "engine_tab_button",
	PLATFORM_INFO_DESCBOX = "platform_info_descbox",
	LICENSING = "licensing_engine_tab_button",
	NEW_ENGINE = "new_engine_tab_button",
	PROJECTS = "projects_tab_button",
	RECORD = "project_record_tab_button",
	UPDATE_ENGINE = "update_engine_tab_button",
	NEW_PLATFORM_BUTTON = "new_platform_button",
	REVAMP_ENGINE = "revamp_engine_tab_button",
	OWN_ENGINES = "own_engines_tab_button",
	PLATFORMS = "platforms_tab_button",
	NEW_GAME = "new_game_project_tab_button"
}

local researchTaskData = task:getData("research_task")
local pastOnKill = gui.getElementType("Frame").onKill

function projectsMenu:onFrameKill()
	pastOnKill(self)
	projectsMenu:close()
end

function projectsMenu:open()
	if not interactionRestrictor:canPerformAction(projectsMenu.OPEN_MENU_ACTION) then
		local popup = game.createPopup(600, _T("PROJECTS_MENU_UNAVAILABLE_TITLE", "Projets menu Unavailable"), _T("PROJECTS_MENU_UNAVAILABLE_DESCRIPTION", "The Projects menu is currently unavailable, please check back later."), fonts.get("pix24"), fonts.get("pix20"))
		
		frameController:push(popup)
		
		return 
	end
	
	self:createProjectsMenu()
	events:fire(projectsMenu.EVENTS.OPENED, self.frame)
	events:addReceiver(self)
end

function projectsMenu:close()
	if not self.frame then
		return 
	end
	
	self.elementFont = nil
	self.elementCostFont = nil
	self.playerPlatformsCategory = nil
	self.licenseablePlatformsCategory = nil
	self.licensedPlatformsCategory = nil
	self.pastPlayerPlatforms = nil
	
	events:removeReceiver(self)
	
	if self.frame and self.frame:isValid() then
		self.frame:kill()
	end
	
	self.frame = nil
	self.projectsFrame = nil
	self.researchScrollPanel = nil
	
	for key, display in ipairs(self.infoDisplays) do
		display:kill()
		
		self.infoDisplays[key] = nil
	end
	
	table.clear(self.projectElementObjects)
	table.clear(self.platformElementObjects)
	table.clear(self.researchCategories)
	table.clear(self.featuresInResearch)
	table.clear(self.categoryTitlesByTaskCategory)
	events:fire(projectsMenu.EVENTS.CLOSED)
	self:resetClickableTabs()
end

function projectsMenu:show()
end

function projectsMenu:update()
end

function projectsMenu:updateProjectRecordTab()
	self:resetClickableTabs()
end

function projectsMenu:hideCloseButton()
	self.projectsFrame:hideCloseButton()
	self.frame:setCanCloseViaEscape(false)
end

function projectsMenu:switchToNewGameTab()
	gui:getElementByID(projectsMenu.ELEMENT_IDS.PROJECTS):switchTo()
	gui:getElementByID(projectsMenu.ELEMENT_IDS.NEW_GAME):switchTo()
end

function projectsMenu:handleEvent(event, data)
	if event == studio.EVENTS.RELEASED_GAME then
		self:moveGameObjectElement(data)
	elseif event == studio.EVENTS.PURCHASED_PLATFORM_LICENSE then
		self:moveLicensingElement(data)
	elseif event == researchTaskData.EVENTS.BEGIN then
		self:updateResearchTab(data)
	end
end

function projectsMenu:addGameProjectToCategoryTitle(gameObj, category, width)
	local element = gui.create("GameProjectInfoSelection")
	
	element:setWidth(width)
	element:setProject(gameObj)
	category:addItem(element)
	
	element.categoryObject = category
	
	table.insert(self.projectElementObjects, element)
end

function projectsMenu:addPlatformToCategoryTitle(platformObj, category, width)
	local element = gui.create("PlatformInfoButton")
	
	element:setWidth(width)
	element:setPlatform(platformObj)
	category:addItem(element, true)
	table.insert(self.platformElementObjects, element)
end

function projectsMenu:createPlatformItem(platformObj, width)
	local element = gui.create("PlatformInfoButton")
	
	element:setWidth(width)
	element:setPlatform(platformObj)
	
	return element
end

function projectsMenu:removeGameObjectElement(gameObj)
	for key, element in ipairs(self.projectElementObjects) do
		if element:getProject() == gameObj then
			element.categoryObject:removeItem(element)
			element:kill()
			table.remove(self.projectElementObjects, key)
			
			break
		end
	end
end

function projectsMenu:moveGameObjectElement(gameObj)
	for key, element in ipairs(self.projectElementObjects) do
		if element:getProject() == gameObj then
			element:updateDescBox()
			self.unreleasedCategory:removeItem(element)
			self.finishedCategory:addItem(element, true)
			
			break
		end
	end
end

function projectsMenu:moveLicensingElement(platformID)
	for key, element in ipairs(self.platformElementObjects) do
		if element:getPlatform():getID() == platformID then
			self.licenseablePlatformsCategory:removeItem(element)
			self.licensedPlatformsCategory:addItem(element, true)
			
			break
		end
	end
end

function projectsMenu:updateResearchTab(researchTask)
	for key, category in ipairs(self.researchCategories) do
		if self:attemptMoveResearchElement(category, researchTask) and #category:getItems() == 0 then
			category:getScrollbar():removeItem(category)
			category:kill()
		end
	end
end

function projectsMenu:attemptMoveResearchElement(categoryObject, researchTask)
	local researchID = researchTask:getTaskType()
	
	for key, item in ipairs(categoryObject:getItems()) do
		if item:getFeatureID() == researchID then
			categoryObject:removeItem(item)
			self.inProgressCategory:addItem(item)
			item:setProgress(researchTask:getCompletion())
			
			return true
		end
	end
	
	return false
end

local gameProjects = {}

function projectsMenu:setClickableTabs(projects, engines, research, record, newGame, platforms)
	self.switchableTabs.projects = projects
	self.switchableTabs.engines = engines
	self.switchableTabs.research = research
	self.switchableTabs.record = record
	self.switchableTabs.newGame = newGame
	self.switchableTabs.platforms = platforms
end

function projectsMenu:resetClickableTabs()
	table.clear(self.switchableTabs)
end

function projectsMenu:attemptSetTabClickable(tab, stateID)
	if self.switchableTabs[stateID] ~= nil then
		tab:setCanClick(self.switchableTabs[stateID])
	else
		tab:setCanClick(true)
	end
end

function projectsMenu:getGameProjectObject()
	return self.newGameProject
end

function projectsMenu:switchToTab(tabID, propertySheet)
	propertySheet = propertySheet or self.mainPropertySheet
end

function projectsMenu:switchToGameTabCallback()
end

projectsMenu.REVAMP_ENGINE_INFO_DISPLAY_ID = "revamp_engine_info_display"
projectsMenu.UPDATE_ENGINE_INFO_DISPLAY_ID = "update_engine_info_display"
projectsMenu.LICENSEABLE_ENGINE_INFO = "licenseable_engine_info_display"
projectsMenu.SELLABLE_ENGINE_INFO = "sellable_engine_info_display"

function hideAllPostKill(self)
	projectsMenu:close()
end

projectsMenu.nameFonts = {
	"pix24",
	"pix22",
	"pix20",
	"pix18",
	"pix16"
}

function projectsMenu:isOpen()
	return self.frame and self.frame:isValid()
end

function projectsMenu:createProjectsMenu()
	self.elementFont = fonts.get("pix20")
	self.elementCostFont = fonts.get("bh20")
	
	if self.frame and self.frame:isValid() then
		self.frame = nil
		self.projectsFrame = nil
		
		frameController:pop()
	end
	
	local invisibleFrame = gui.create("ProjectsMenuFrame")
	
	invisibleFrame:setSize(_US(scrW), _US(scrH))
	
	invisibleFrame.onKill = projectsMenu.onFrameKill
	
	invisibleFrame:setCloseKey(keyBinding:getCommandKey(keyBinding.COMMANDS.PROJECTS))
	
	local projectsFrame = gui.create("Frame", invisibleFrame)
	
	projectsFrame:setSize(482, 632)
	projectsFrame:setFont("pix24")
	projectsFrame:setTitle(_T("GAME_PROJECTS_TITLE", "Game Projects"))
	projectsFrame:center()
	
	projectsFrame.postKill = hideAllPostKill
	self.projectsFrame = projectsFrame
	self.frameController = gui.create("ProjectsMenuFrameController", invisibleFrame)
	
	local projectsTabButton = gui.create("ProjectsMenuTabButton")
	
	projectsTabButton:setSize(64, 64)
	projectsTabButton:setIcon("icon_games_tab")
	projectsTabButton:setFrame(projectsFrame)
	projectsTabButton:setID(projectsMenu.ELEMENT_IDS.PROJECTS)
	projectsTabButton:setOnSwitchEvent(projectsMenu.EVENTS.PROJECTS_TAB_OPENED)
	projectsTabButton:setNearbyText(_T("GAME_PROJECTS_TITLE", "Game Projects"))
	self:attemptSetTabClickable(projectsTabButton, "projects")
	self.frameController:addButton(projectsTabButton)
	
	local projectsPropSheet = gui.create("PropertySheet", projectsFrame)
	
	projectsPropSheet:setPos(_S(5), _S(35))
	projectsPropSheet:setTabOffset(4, 4)
	projectsPropSheet:setSize(471, 670)
	projectsPropSheet:setFont(fonts.get("bh24"))
	
	local inProgressPanel = gui.create("Panel")
	
	inProgressPanel:setSize(470, 556)
	
	inProgressPanel.shouldDraw = false
	
	local scrollFrame = gui.create("ScrollbarPanel", inProgressPanel)
	
	scrollFrame:setPos(0, 0)
	scrollFrame:setSize(470, inProgressPanel.rawH)
	scrollFrame:setAdjustElementPosition(true)
	scrollFrame:setPadding(3, 3)
	
	local elementWidth = scrollFrame.rawW - 20
	
	self.projectRecordScrollbar = scrollFrame
	
	local inProgressCategory = gui.create("Category")
	
	inProgressCategory:setIcon("projects_in_progress")
	inProgressCategory:setHeight(26)
	inProgressCategory:setFont(fonts.get("pix24"))
	inProgressCategory:setText(_T("IN_PROGRESS", "In progress"))
	inProgressCategory:assumeScrollbar(scrollFrame)
	
	self.inProgressCategory = inProgressCategory
	
	scrollFrame:addItem(inProgressCategory)
	
	for key, gameObj in ipairs(studio:getProjects()) do
		if gameObj.mtindex == gameProject.mtindex then
			gameProjects[#gameProjects + 1] = gameObj
		end
	end
	
	for i = #gameProjects, 1, -1 do
		local gameObj = gameProjects[i]
		
		if not gameObj:isDone() and not gameObj:getReleaseDate() then
			self:addGameProjectToCategoryTitle(gameObj, inProgressCategory, elementWidth)
		end
	end
	
	local unreleasedCategory = gui.create("Category")
	
	unreleasedCategory:setIcon("projects_unfinished")
	unreleasedCategory:setHeight(26)
	unreleasedCategory:setFont(fonts.get("pix24"))
	unreleasedCategory:setText(_T("UNRELEASED_PROJECTS", "Unreleased"))
	unreleasedCategory:assumeScrollbar(scrollFrame)
	
	self.unreleasedCategory = unreleasedCategory
	
	scrollFrame:addItem(unreleasedCategory)
	
	for i = #gameProjects, 1, -1 do
		local gameObj = gameProjects[i]
		
		if gameObj:isDone() and not gameObj:getReleaseDate() then
			self:addGameProjectToCategoryTitle(gameObj, unreleasedCategory, elementWidth)
		end
	end
	
	local finishedCategory = gui.create("Category")
	
	finishedCategory:setIcon("projects_finished")
	finishedCategory:setHeight(26)
	finishedCategory:setFont(fonts.get("pix24"))
	finishedCategory:setText(_T("FINISHED_PROJECTS", "Finished"))
	finishedCategory:assumeScrollbar(scrollFrame)
	
	self.finishedCategory = finishedCategory
	
	scrollFrame:addItem(finishedCategory)
	
	for i = #gameProjects, 1, -1 do
		local gameObj = gameProjects[i]
		
		if gameObj:getReleaseDate() then
			self:addGameProjectToCategoryTitle(gameObj, finishedCategory, elementWidth)
		end
	end
	
	table.clear(gameProjects)
	
	local buttonWidth = 114
	local gap = 5
	local spacing = scaling.ui(buttonWidth + gap)
	local gamePanel = gui.create("Panel")
	
	gamePanel:setSize((buttonWidth + gap) * 4 - 4, 557)
	
	gamePanel.shouldDraw = false
	
	local newGameProject = gameProject.new(studio)
	
	newGameProject:setProjectType("game_project")
	newGameProject:setName(_T("UNTITLED_GAME", "Untitled Game"))
	
	self.newGameProject = newGameProject
	
	local nameTextbox = gui.create("ProjectNameTextBox", gamePanel)
	
	nameTextbox:setProject(newGameProject)
	nameTextbox:setFont(fonts.get("pix20"))
	nameTextbox:setHeight(30)
	nameTextbox:setY(0)
	nameTextbox:setMaxText(gameProject.MAX_NAME_SYMBOLS)
	nameTextbox:setWidth(gamePanel.rawW - 2)
	nameTextbox:setGhostText(_T("ENTER_GAME_NAME", "Enter game name"))
	nameTextbox:setShouldCenter(true)
	nameTextbox:centerX()
	nameTextbox:setAutoAdjustFonts(projectsMenu.nameFonts)
	
	local baseX, baseY = nameTextbox:getPos()
	local themeSelection = gui.create("ThemeListComboBoxButton", gamePanel)
	
	themeSelection:setSize(buttonWidth, 24)
	themeSelection:setPos(baseX, _S(35))
	themeSelection:setFont(fonts.get("pix20"))
	themeSelection:setProject(newGameProject)
	
	local genreSelection = gui.create("GenreListComboBoxButton", gamePanel)
	
	genreSelection:setSize(buttonWidth, 24)
	genreSelection:setPos(baseX + spacing, _S(35))
	genreSelection:setFont(fonts.get("pix20"))
	genreSelection:setProject(newGameProject)
	
	local engineListButton = gui.create("EngineListComboBoxButton", gamePanel)
	
	engineListButton:setSize(buttonWidth, 24)
	engineListButton:setPos(baseX + spacing * 2, _S(35))
	engineListButton:setFont(fonts.get("pix20"))
	engineListButton:setProject(newGameProject)
	engineListButton:setListDisplayOwner(self)
	
	local priceSelection = gui.create("PriceListComboBoxButton", gamePanel)
	
	priceSelection:setSize(buttonWidth, 24)
	priceSelection:setPos(baseX + spacing * 3, _S(35))
	priceSelection:setFont(fonts.get("pix20"))
	priceSelection:setProject(newGameProject)
	
	local teamListButton = gui.create("TeamListComboBoxButton", gamePanel)
	
	teamListButton:setSize(buttonWidth, 24)
	teamListButton:setPos(baseX + spacing * 2, _S(65))
	teamListButton:setFont(fonts.get("pix20"))
	teamListButton:setProject(newGameProject)
	
	local gameTypeSelection = gui.create("GameTypeListComboBoxButton", gamePanel)
	
	gameTypeSelection:setSize(buttonWidth, 24)
	gameTypeSelection:setPos(baseX + spacing * 3, _S(65))
	gameTypeSelection:setFont(fonts.get("pix20"))
	gameTypeSelection:setProject(newGameProject)
	
	local scaleSelection = gui.create("AudienceListComboBoxButton", gamePanel)
	
	scaleSelection:setSize(buttonWidth, 24)
	scaleSelection:setPos(baseX, _S(65))
	scaleSelection:setFont(fonts.get("pix20"))
	scaleSelection:setProject(newGameProject)
	
	local platformListButton = gui.create("PlatformListComboBoxButton", gamePanel)
	
	platformListButton:setSize(buttonWidth, 24)
	platformListButton:setPos(baseX + spacing, _S(65))
	platformListButton:setFont(fonts.get("pix20"))
	platformListButton:setProject(newGameProject)
	
	local scaleAdjust = gui.create("GameScaleAdjustment", gamePanel)
	
	scaleAdjust:setPos(0, _S(93))
	scaleAdjust:setSize(nameTextbox.rawW, 22)
	scaleAdjust:setProject(newGameProject)
	
	local scrollFrame = gui.create("GameUpdateTasklist", gamePanel)
	
	scrollFrame:setPos(nil, _S(93 + scaleAdjust.rawH + 5))
	scrollFrame:setSize(nameTextbox.rawW, 393 - scaleAdjust.rawH)
	scrollFrame:setAdjustElementPosition(true)
	scrollFrame:setPadding(3, 3)
	scrollFrame:setProject(newGameProject)
	scrollFrame:centerX()
	scrollFrame:addDepth(100)
	
	self.scrollbarPanel = scrollFrame
	
	scrollFrame:updateList()
	
	local featureExpenses = gui.create("FeatureExpensesDisplay", gamePanel)
	
	featureExpenses:setSize(nameTextbox.rawW, 28)
	featureExpenses:setProject(newGameProject)
	featureExpenses:setX(baseX)
	featureExpenses:setY(scrollFrame.localY + scrollFrame.h + _S(5))
	
	local buttonsGap = 4
	local buttonsWidth = math.ceil(gamePanel.rawW / 2 + 1 - buttonsGap)
	local lowestY = featureExpenses.localY + featureExpenses.h + _S(5)
	local prequelSelect = gui.create("OpenPrequelSelectionButton", gamePanel)
	
	prequelSelect:setSize(buttonsWidth, 28)
	prequelSelect:setFont(fonts.get("pix24"))
	prequelSelect:setProject(newGameProject)
	prequelSelect:setY(lowestY)
	prequelSelect:setPos(baseX, nil)
	gameTypeSelection:setRelatedGameButton(prequelSelect)
	
	local inheritButton = gui.create("InheritGameSetupButton", gamePanel)
	
	inheritButton:setPos(prequelSelect.localX + prequelSelect.w + _S(3), prequelSelect.localY)
	inheritButton:setSize(28, 28)
	inheritButton:setCanClick(false)
	inheritButton:setProject(newGameProject)
	prequelSelect:setInheritButton(inheritButton)
	
	local begin = gui.create("BeginGameDevelopmentButton", gamePanel)
	
	begin:setSize(200, 28)
	begin:setFont(fonts.get("bh24"))
	begin:setText(_T("BEGIN_DEVELOPMENT", "Begin development"))
	begin:setDevelopmentType(gameProject.DEVELOPMENT_TYPE.NEW)
	begin:setProject(newGameProject)
	begin:setY(lowestY)
	begin:setPos(inheritButton.localX + inheritButton.w + _S(3), nil)
	newGameProject:onProjectMenuCreated()
	
	local platformsPanel = gui.create("Panel")
	
	platformsPanel:setSize(470, 556)
	
	platformsPanel.shouldDraw = false
	
	local platformsScrollbar = gui.create("ScrollbarPanel", platformsPanel)
	
	platformsScrollbar:setSize(470, platformsPanel.rawH)
	platformsScrollbar:setAdjustElementPosition(true)
	platformsScrollbar:setPadding(3, 3)
	platformsScrollbar:setSpacing(3)
	
	self.platformsScrollbar = platformsScrollbar
	
	local playerPlatforms = studio:getPlayerPlatforms()
	
	if #playerPlatforms > 0 then
		local playerPlatforms = gui.create("Category")
		
		playerPlatforms:setFont(fonts.get("pix28"))
		playerPlatforms:setText(_T("PLAYER_PLATFORMS", "Player platforms"))
		playerPlatforms:assumeScrollbar(platformsScrollbar)
		playerPlatforms:setSize(150, 30)
		platformsScrollbar:addItem(playerPlatforms)
		
		self.playerPlatformsCategory = playerPlatforms
	end
	
	local foldedPlayerPlats = gui.create("PastPlatformsCategory")
	
	foldedPlayerPlats:setFont("pix28")
	foldedPlayerPlats:setText(_T("DISCONTINUED_PLATFORMS", "Discontinued player platforms"))
	foldedPlayerPlats:assumeScrollbar(platformsScrollbar)
	foldedPlayerPlats:fold()
	platformsScrollbar:addItem(foldedPlayerPlats)
	
	self.pastPlayerPlatforms = foldedPlayerPlats
	
	local licenseableCategory = gui.create("Category")
	
	licenseableCategory:setFont(fonts.get("pix28"))
	licenseableCategory:setText(_T("LICENSEABLE_PLATFORMS", "Licenseable platforms"))
	licenseableCategory:assumeScrollbar(platformsScrollbar)
	licenseableCategory:setSize(150, 30)
	
	self.licenseablePlatformsCategory = licenseableCategory
	
	platformsScrollbar:addItem(licenseableCategory)
	
	local licensedPlatforms = gui.create("Category")
	
	licensedPlatforms:setFont(fonts.get("pix28"))
	licensedPlatforms:setText(_T("LICENSED_PLATFORMS", "Licensed platforms"))
	licensedPlatforms:assumeScrollbar(platformsScrollbar)
	licensedPlatforms:setSize(150, 30)
	
	self.licensedPlatformsCategory = licensedPlatforms
	
	platformsScrollbar:addItem(licensedPlatforms)
	
	for key, platformObj in ipairs(platformShare:getOnMarketPlatforms()) do
		if platformObj.PLAYER then
			if platformObj:isDiscontinued() then
				foldedPlayerPlats:addPendingPlatform(platformObj)
			else
				self:addPlatformToCategoryTitle(platformObj, self.playerPlatformsCategory, 460)
			end
		elseif not studio:hasPlatformLicense(platformObj:getID()) then
			if platformObj:getLicenseCost() then
				self:addPlatformToCategoryTitle(platformObj, licenseableCategory, 460)
			end
		else
			self:addPlatformToCategoryTitle(platformObj, licensedPlatforms, 460)
		end
	end
	
	local enginesFrame = gui.create("Frame", invisibleFrame)
	
	enginesFrame:setSize(482, 632)
	enginesFrame:setFont("pix24")
	enginesFrame:setTitle(_T("ENGINES_TITLE", "Engines"))
	enginesFrame:center()
	
	enginesFrame.postKill = hideAllPostKill
	
	enginesFrame:setAnimated(false)
	
	local enginesTabButton = gui.create("ProjectsMenuTabButton")
	
	enginesTabButton:setSize(64, 64)
	enginesTabButton:setIcon("icon_engines_tab")
	enginesTabButton:setFrame(enginesFrame)
	enginesTabButton:setID(projectsMenu.ELEMENT_IDS.ENGINES)
	enginesTabButton:setNearbyText(_T("ENGINES", "Engines"))
	enginesTabButton:setOnSwitchEvent(projectsMenu.EVENTS.ENGINES_TAB_OPENED)
	self:attemptSetTabClickable(enginesTabButton, "engines")
	self.frameController:addButton(enginesTabButton)
	
	local enginesPropSheet = gui.create("PropertySheet", enginesFrame)
	
	enginesPropSheet:setPos(_S(5), _S(35))
	enginesPropSheet:setTabOffset(4, 4)
	enginesPropSheet:setSize(471, enginesFrame.rawH - 20)
	enginesPropSheet:setFont(fonts.get("bh24"))
	
	local newEnginePanel = gui.create("Panel")
	
	newEnginePanel:setSize(480, 555)
	
	newEnginePanel.shouldDraw = false
	
	local newEngineProject = engine.new(studio)
	
	newEngineProject:setProjectType("engine_project")
	newEngineProject:setName("Untitled")
	
	local nameTextbox = gui.create("ProjectNameTextBox", newEnginePanel)
	
	nameTextbox:setProject(newEngineProject)
	nameTextbox:setFont(fonts.get("pix24"))
	nameTextbox:setSize(310, 30)
	nameTextbox:setPos(_S(1), _S(1))
	nameTextbox:setMaxText(29)
	nameTextbox:setGhostText(_T("ENTER_ENGINE_NAME", "Enter engine name"))
	nameTextbox:setShouldCenter(true)
	nameTextbox:setAutoAdjustFonts(projectsMenu.nameFonts)
	
	local teamSelection = gui.create("TeamListComboBoxButton", newEnginePanel)
	
	teamSelection:setSize(152, 30)
	teamSelection:setPos(_S(317), _S(1))
	teamSelection:setFont(fonts.get("pix24"))
	teamSelection:setProject(newEngineProject)
	
	local begin = gui.create("BeginProjectButton", newEnginePanel)
	
	begin:setSize(250, 30)
	begin:setPos(_S(110), newEnginePanel.h - begin.h)
	begin:setFont(fonts.get("pix28"))
	begin:setText(_T("CREATE_GAME_ENGINE", "Create game engine"))
	begin:setDevelopmentType(engine.DEVELOPMENT_TYPE.NEW)
	begin:setProject(newEngineProject)
	
	begin.closeMenu = invisibleFrame
	
	local tasklist = gui.create("NewEngineTasklist", newEnginePanel)
	
	tasklist:setPos(0, _S(36))
	tasklist:setSize(470, 485)
	tasklist:setAdjustElementPosition(true)
	tasklist:setPadding(2, 2)
	tasklist:setSpacing(2)
	tasklist:addDepth(5)
	tasklist:setEngine(newEngineProject)
	tasklist:updateList()
	
	local updateEnginePanel = gui.create("Panel")
	
	updateEnginePanel:setSize(480, 555)
	
	updateEnginePanel.shouldDraw = false
	
	local begin = gui.create("BeginProjectButton", updateEnginePanel)
	
	begin:setSize(250, 30)
	begin:setPos(_S(110), updateEnginePanel.h - begin.h)
	begin:setFont(fonts.get("pix28"))
	begin:setText(_T("UPDATE_GAME_ENGINE", "Update game engine"))
	begin:setDevelopmentType(engine.DEVELOPMENT_TYPE.UPDATE)
	
	begin.closeMenu = invisibleFrame
	
	local selectUpdateEngine = gui.create("EngineListComboBox", updateEnginePanel)
	
	selectUpdateEngine:setFont(fonts.get("pix24"))
	selectUpdateEngine:setSize(310, 30)
	selectUpdateEngine:setPos(_S(1), _S(1))
	selectUpdateEngine:setAllowPurchasedEngines(false)
	selectUpdateEngine:setDisplayToUpdate(projectsMenu.UPDATE_ENGINE_INFO_DISPLAY_ID)
	
	local selectUpdateTeam = gui.create("EngineTeamComboBox", updateEnginePanel)
	
	selectUpdateTeam:setFont(fonts.get("pix24"))
	selectUpdateTeam:setSize(152, 30)
	selectUpdateTeam:setPos(_S(317), _S(1))
	
	local tasklist = gui.create("EngineUpdateTasklist", updateEnginePanel)
	
	tasklist:setPos(0, _S(36))
	tasklist:setSize(470, 485)
	tasklist:setAdjustElementPosition(true)
	tasklist:setPadding(2, 2)
	tasklist:setSpacing(2)
	tasklist:setBeginProject(begin)
	tasklist:setSelectTeam(selectUpdateTeam)
	tasklist:addDepth(25)
	selectUpdateEngine:setFeatureList(tasklist)
	selectUpdateTeam:setFeatureList(tasklist)
	
	local revampEnginePanel = gui.create("Panel")
	
	revampEnginePanel:setSize(480, 555)
	
	revampEnginePanel.shouldDraw = false
	
	local selectRevampEngine = gui.create("EngineListComboBox", revampEnginePanel)
	
	selectRevampEngine:setFont(fonts.get("pix24"))
	selectRevampEngine:setSize(310, 30)
	selectRevampEngine:setPos(_S(1), _S(1))
	selectRevampEngine:setAllowPurchasedEngines(false)
	selectRevampEngine:setDisplayToUpdate(projectsMenu.REVAMP_ENGINE_INFO_DISPLAY_ID)
	
	local selectUpdateTeam = gui.create("EngineTeamComboBox", revampEnginePanel)
	
	selectUpdateTeam:setFont(fonts.get("pix24"))
	selectUpdateTeam:setSize(152, 30)
	selectUpdateTeam:setPos(_S(317), _S(1))
	
	local begin = gui.create("BeginProjectButton", revampEnginePanel)
	
	begin:setSize(250, 28)
	begin:setPos(_S(110), revampEnginePanel.h - begin.h)
	begin:setFont(fonts.get("pix24"))
	begin:setText(_T("REVAMP_GAME_ENGINE", "Revamp game engine"))
	begin:setDevelopmentType(engine.DEVELOPMENT_TYPE.REVAMP)
	
	begin.closeMenu = invisibleFrame
	
	local engineStatDisplay = gui.create("EngineStatsDisplay", revampEnginePanel)
	
	engineStatDisplay:setSize(470, 95)
	engineStatDisplay:setPos(_S(0), begin.localY - _S(5) - engineStatDisplay.h)
	
	local scrollFrame = gui.create("EngineRevampTasklist", revampEnginePanel)
	
	scrollFrame:setPos(0, _S(36))
	scrollFrame:setSize(470, _US(math.dist(scrollFrame.localY, engineStatDisplay.localY)) - 5)
	scrollFrame:setAdjustElementPosition(true)
	scrollFrame:setPadding(2, 2)
	scrollFrame:setSpacing(2)
	scrollFrame:addDepth(50)
	scrollFrame:setBeginProject(begin)
	scrollFrame:setSelectTeam(selectUpdateTeam)
	scrollFrame:setEngineStats(engineStatDisplay)
	selectRevampEngine:setFeatureList(scrollFrame)
	selectUpdateTeam:setFeatureList(scrollFrame)
	
	local licensingFrame = gui.create("Frame", invisibleFrame)
	
	licensingFrame:setSize(482, 632)
	licensingFrame:setFont("pix24")
	licensingFrame:setTitle(_T("ENGINE_LICENSING_TITLE", "Engine Licensing"))
	licensingFrame:center()
	
	licensingFrame.postKill = hideAllPostKill
	
	licensingFrame:setAnimated(false)
	
	local licensingTabButton = gui.create("ProjectsMenuTabButton")
	
	licensingTabButton:setSize(64, 64)
	licensingTabButton:setIcon("icon_engine_licensing_tab")
	licensingTabButton:setFrame(licensingFrame)
	licensingTabButton:setID(projectsMenu.ELEMENT_IDS.LICENSING)
	licensingTabButton:setNearbyText(_T("ENGINE_LICENSING_TITLE", "Engine Licensing"))
	self:attemptSetTabClickable(licensingTabButton, "engines")
	self.frameController:addButton(licensingTabButton)
	
	local licensingPropSheet = gui.create("PropertySheet", licensingFrame)
	
	licensingPropSheet:setPos(_S(5), _S(35))
	licensingPropSheet:setTabOffset(4, 4)
	licensingPropSheet:setSize(471, licensingFrame.rawH - 20)
	licensingPropSheet:setFont(fonts.get("bh24"))
	
	local licenseBuyPanel = gui.create("Panel")
	
	licenseBuyPanel:setSize(472, 555)
	
	licenseBuyPanel.shouldDraw = false
	
	local licensingScrollPanel = gui.create("ScrollbarPanel", licenseBuyPanel)
	
	licensingScrollPanel:setSize(472, 555)
	licensingScrollPanel:setPos(0, 0)
	licensingScrollPanel:setAdjustElementPosition(true)
	licensingScrollPanel:setSpacing(2)
	licensingScrollPanel:setPadding(2, 2)
	licensingScrollPanel:addDepth(100)
	
	local catTitle = gui.create("Category")
	
	catTitle:setHeight(25)
	catTitle:setFont(fonts.get("pix24"))
	catTitle:setText(_T("ON_MARKET_ENGINES", "On-market engines"))
	catTitle:assumeScrollbar(licensingScrollPanel)
	
	catTitle.onMarketEngines = true
	
	licensingScrollPanel:addItem(catTitle)
	
	for key, engineData in ipairs(engineLicensing.onMarketEngines) do
		if not studio:hasPurchasedEngineLicense(engineData.engine) then
			local engineElement = gui.create("EngineLicensingSelection")
			
			engineElement:setWidth(472)
			engineElement:setEngine(engineData.engine)
			catTitle:addItem(engineElement)
		end
	end
	
	local licensedTitle = gui.create("Category")
	
	licensedTitle:setHeight(25)
	licensedTitle:setFont(fonts.get("pix24"))
	licensedTitle:setText(_T("LICENSED_ENGINES", "Licensed engines"))
	licensedTitle:assumeScrollbar(licensingScrollPanel)
	
	licensedTitle.licensedEngines = true
	
	licensingScrollPanel:addItem(licensedTitle)
	
	for key, engineObj in ipairs(studio.boughtEngineLicenses) do
		local engineElement = gui.create("EngineLicensingSelection")
		
		engineElement:setWidth(472)
		engineElement:setEngine(engineObj)
		engineElement:setCanPurchase(false)
		licensedTitle:addItem(engineElement)
	end
	
	engineLicensing:setLicensingScrollbar(licensingScrollPanel)
	
	local tabButton = licensingPropSheet:addItem(licenseBuyPanel, _T("PURCHASE_ENGINE_LICENSES_TAB", "Purchase"), 154, 32)
	
	tabButton:addHoverText(_T("PURCHASE_LICENSES_TAB_DESCRIPTION", "Purchase a game engine license for use in development."), "pix20")
	
	local engineStatsDescbox = gui.create("EngineStatsDescbox")
	
	engineStatsDescbox:setPos(licensingFrame.x + _S(10) + licensingFrame.w, licensingFrame.y)
	engineStatsDescbox:setWidth(250)
	engineStatsDescbox:setID(projectsMenu.LICENSEABLE_ENGINE_INFO)
	engineStatsDescbox:hideDisplay()
	engineStatsDescbox:tieVisibilityTo(tabButton.bar)
	engineStatsDescbox:setCanHover(false)
	engineStatsDescbox:overwriteDepth(2000)
	table.insert(self.infoDisplays, engineStatsDescbox)
	
	local licenseSellPanel = gui.create("Panel")
	
	licenseSellPanel:setSize(472, 555)
	
	licenseSellPanel.shouldDraw = false
	
	local licenseSellScroll = gui.create("EngineSellScrollbarPanel", licenseSellPanel)
	
	licenseSellScroll:setSize(472, 400)
	licenseSellScroll:setPos(0, 0)
	licenseSellScroll:setAdjustElementPosition(true)
	licenseSellScroll:setSpacing(2)
	licenseSellScroll:setPadding(2, 2)
	licenseSellScroll:addDepth(200)
	
	local playerEngines = studio:getEngines()
	
	if #playerEngines == 0 then
		local catTitle = gui.create("Category")
		
		catTitle:setHeight(25)
		catTitle:setFont(fonts.get("pix24"))
		catTitle:setText(_T("NO_PLAYER_MADE_ENGINES", "No engines made!"))
		catTitle:assumeScrollbar(licenseSellScroll)
		licenseSellScroll:addItem(catTitle)
	else
		local catTitle = gui.create("Category")
		
		catTitle:setHeight(25)
		catTitle:setFont(fonts.get("pix24"))
		catTitle:setText(_T("AVAILABLE_PLAYER_ENGINES", "Available engines"))
		catTitle:assumeScrollbar(licenseSellScroll)
		licenseSellScroll:setEnginesCategory(catTitle)
		licenseSellScroll:addItem(catTitle)
		
		for key, engineObj in ipairs(playerEngines) do
			local engineElement = gui.create("EngineSellingSelection")
			
			engineElement:setWidth(472)
			engineElement:setEngine(engineObj)
			catTitle:addItem(engineElement)
		end
		
		licenseSellScroll:setupSoldEngine()
	end
	
	local licensePrep = gui.create("EngineLicensePreparationPanel", licenseSellPanel)
	
	licensePrep:setSize(472, 0)
	licensePrep:createDisplays()
	licensePrep:setPos(0, _S(licenseSellPanel.rawH - licensePrep.rawH))
	
	local tabButton = licensingPropSheet:addItem(licenseSellPanel, _T("SELL_ENGINE_LICENSES_TAB", "Sell"), 154, 32)
	
	tabButton:addHoverText(_T("SELL_LICENSES_TAB_DESCRIPTION", "Start selling a game engine you've made."), "pix20")
	
	local engineStatsDescbox = gui.create("EngineStatsDescbox")
	
	engineStatsDescbox:setPos(licensingFrame.x + _S(10) + licensingFrame.w, licensingFrame.y)
	engineStatsDescbox:setWidth(250)
	engineStatsDescbox:setID(projectsMenu.SELLABLE_ENGINE_INFO)
	engineStatsDescbox:hideDisplay()
	engineStatsDescbox:tieVisibilityTo(tabButton.bar)
	engineStatsDescbox:setCanHover(false)
	engineStatsDescbox:overwriteDepth(2000)
	table.insert(self.infoDisplays, engineStatsDescbox)
	
	local researchFrame = gui.create("Frame", invisibleFrame)
	
	researchFrame:setSize(482, 632)
	researchFrame:setFont("pix24")
	researchFrame:setTitle(_T("RESEARCH_TITLE", "Research"))
	researchFrame:center()
	
	researchFrame.postKill = hideAllPostKill
	
	researchFrame:setAnimated(false)
	
	local researchTabButton = gui.create("ProjectsMenuTabButton")
	
	researchTabButton:setSize(64, 64)
	researchTabButton:setIcon("icon_research_tab")
	researchTabButton:setFrame(researchFrame)
	researchTabButton:setID(projectsMenu.ELEMENT_IDS.RESEARCH)
	researchTabButton:setNearbyText(_T("RESEARCH", "Research"))
	researchTabButton:setOnSwitchEvent(projectsMenu.EVENTS.RESEARCH_TAB_OPENED)
	self:attemptSetTabClickable(researchTabButton, "research")
	self.frameController:addButton(researchTabButton)
	
	self.researchScrollPanel, self.inProgressCategory = menuCreator:createResearchMenu(researchFrame, _S(5), _S(35), 470, 590)
	self.featuresInResearch = menuCreator:getInResearchFeatureList()
	
	local recordButton = projectsPropSheet:addItem(inProgressPanel, _T("RECORD", "Record"), 154, 32)
	
	recordButton:setID(projectsMenu.ELEMENT_IDS.RECORD)
	recordButton:addHoverText(_T("RECORD_TAB_DESCRIPTION", "View all your game projects"), "pix20")
	self:attemptSetTabClickable(recordButton, "record")
	
	local newGameTab = projectsPropSheet:addItem(gamePanel, _T("NEW_GAME", "New game"), 154, 32, projectsMenu.switchToGameTabCallback)
	
	newGameTab:setOnSwitchEvent(projectsMenu.EVENTS.NEW_GAME_TAB_OPENED)
	newGameTab:setID(projectsMenu.ELEMENT_IDS.NEW_GAME)
	newGameTab:addHoverText(_T("NEW_GAME_DESCRIPTION", "Begin work on a new game project"), "pix20")
	self:attemptSetTabClickable(newGameTab, "newGame")
	
	local extraInfoPanel = gui.create("GameInfoDisplay")
	
	extraInfoPanel:setPos(projectsFrame.x + _S(10) + projectsFrame.w, projectsFrame.y)
	extraInfoPanel:setWidth(250)
	extraInfoPanel:setProject(newGameProject)
	extraInfoPanel:hideDisplay()
	extraInfoPanel:setCanHover(false)
	extraInfoPanel:tieVisibilityTo(newGameTab.bar)
	table.insert(self.infoDisplays, extraInfoPanel)
	
	local platformsTab = projectsPropSheet:addItem(platformsPanel, _T("PLATFORMS", "Platforms"), 154, 32)
	
	platformsTab:setOnSwitchEvent(projectsMenu.EVENTS.PLATFORMS_TAB_OPENED)
	platformsTab:setID(projectsMenu.ELEMENT_IDS.PLATFORMS)
	platformsTab:addHoverText(_T("PLATFORMS_TAB_DESCRIPTION", "View and purchase platform licenses"), "pix20")
	self:attemptSetTabClickable(platformsTab, "platforms")
	
	local platformInfo = gui.create("PlatformInfoDescbox")
	
	platformInfo:setPos(projectsFrame.x + _S(10) + projectsFrame.w, projectsFrame.y)
	platformInfo:setWidth(250)
	platformInfo:overwriteDepth(5000)
	platformInfo:hideDisplay()
	platformInfo:setID(projectsMenu.ELEMENT_IDS.PLATFORM_INFO_DESCBOX)
	platformInfo:setCanHover(false)
	platformInfo:tieVisibilityTo(platformsTab.bar)
	table.insert(self.infoDisplays, platformInfo)
	
	local tabButton = enginesPropSheet:addItem(newEnginePanel, _T("NEW_ENGINE", "New Engine"), 154, 32)
	
	tabButton:setID(projectsMenu.ELEMENT_IDS.NEW_ENGINE)
	tabButton:addHoverText(_T("NEW_ENGINE_DESCRIPTION", "Create a new engine, no money needed to be spent."), "pix20")
	
	local extraInfoPanel = gui.create("ProjectInfoDisplay")
	
	extraInfoPanel:setPos(enginesFrame.x + _S(10) + enginesFrame.w, enginesFrame.y)
	extraInfoPanel:setWidth(250)
	extraInfoPanel:setProject(newEngineProject)
	extraInfoPanel:hideDisplay()
	extraInfoPanel:setCanHover(false)
	extraInfoPanel:tieVisibilityTo(tabButton.bar)
	table.insert(self.infoDisplays, extraInfoPanel)
	
	local tabButton = enginesPropSheet:addItem(updateEnginePanel, _T("UPDATE_ENGINE", "Update Engine"), 154, 32)
	
	tabButton:setID(projectsMenu.ELEMENT_IDS.UPDATE_ENGINE)
	tabButton:addHoverText(_T("UPDATE_ENGINE_DESCRIPTION", "Update an existing engine with new features and tech."), "pix20")
	
	local extraInfoPanel = gui.create("EngineInfoDisplay")
	
	extraInfoPanel:setPos(enginesFrame.x + _S(10) + enginesFrame.w, enginesFrame.y)
	extraInfoPanel:setWidth(250)
	extraInfoPanel:setID(projectsMenu.UPDATE_ENGINE_INFO_DISPLAY_ID)
	extraInfoPanel:hideDisplay()
	extraInfoPanel:setCanHover(false)
	extraInfoPanel:tieVisibilityTo(tabButton.bar)
	table.insert(self.infoDisplays, extraInfoPanel)
	
	local tabButton = enginesPropSheet:addItem(revampEnginePanel, _T("REVAMP_ENGINE", "Revamp Engine"), 154, 32)
	
	tabButton:setID(projectsMenu.ELEMENT_IDS.REVAMP_ENGINE)
	tabButton:addHoverText(_T("REVAMP_ENGINE_DESCRIPTION", "Revamp an existing engine to improve its performance, ease of use and integrity stats."), "pix20")
	
	local extraInfoPanel = gui.create("EngineRevampInfoDisplay")
	
	extraInfoPanel:setPos(enginesFrame.x + _S(10) + enginesFrame.w, enginesFrame.y)
	extraInfoPanel:setWidth(250)
	extraInfoPanel:setID(projectsMenu.REVAMP_ENGINE_INFO_DISPLAY_ID)
	extraInfoPanel:hideDisplay()
	extraInfoPanel:setCanHover(false)
	extraInfoPanel:tieVisibilityTo(tabButton.bar)
	table.insert(self.infoDisplays, extraInfoPanel)
	self.frameController:setPos(projectsFrame.x - self.frameController.w - _S(10), projectsFrame.y)
	self.frameController:setFrame(projectsTabButton)
	
	local newPlatIcon = gui.create("PlatformCreationMenuButton", invisibleFrame)
	
	newPlatIcon:setSize(64, 64)
	newPlatIcon:setIcon("increase")
	newPlatIcon:tieVisibilityTo(platformsTab.bar)
	newPlatIcon:setPos(self.frameController.x + self.frameController.w * 0.5 - newPlatIcon.w * 0.5, self.frameController.y + self.frameController.h + _S(10))
	newPlatIcon:addDepth(500)
	newPlatIcon:setID(projectsMenu.ELEMENT_IDS.NEW_PLATFORM_BUTTON)
	
	self.frame = invisibleFrame
	
	frameController:push(invisibleFrame)
	sound:play("popup_in")
end

function projectsMenu:createGameTaskCategory(categoryID, projectObject)
	local categoryData = taskTypes:getTaskCategory(categoryID)
	local categoryTitle = gui.create("TaskCategory")
	
	categoryTitle:setSize(360, 25)
	categoryTitle:setFont(fonts.get("pix24"))
	categoryTitle:setText(categoryData.title)
	categoryTitle:assumeScrollbar(self.scrollbarPanel)
	categoryTitle:setProject(projectObject)
	categoryTitle:setCategory(categoryID)
	categoryTitle:createPriorityAdjustment()
	
	if categoryData.icon then
		categoryTitle:setIcon(categoryData.icon)
	end
	
	self.categoryTitlesByTaskCategory[categoryID] = categoryTitle
	
	return categoryTitle
end

function projectsMenu:createEngineTaskCategory(categoryID, scrollbar)
	local categoryData = taskTypes:getTaskCategory(categoryID)
	local categoryTitle = gui.create("Category")
	
	categoryTitle:setSize(150, 25)
	categoryTitle:setFont(fonts.get("pix28"))
	categoryTitle:setText(categoryData.title)
	categoryTitle:assumeScrollbar(scrollbar)
	
	if categoryData.icon then
		categoryTitle:setIcon(categoryData.icon)
	end
	
	return categoryTitle
end

function projectsMenu:updateGameFeatureList()
	table.clear(self.categoryTitlesByTaskCategory)
	
	local scrollbarPanel = self.scrollbarPanel
	
	scrollbarPanel:removeItems()
	scrollbarPanel:updateList()
end

function projectsMenu:createTaskTypeElement(taskTypeData, project, class)
	project = project or self.newGameProject
	class = class or "TaskTypeSelection"
	
	local taskSelection = gui.create(class)
	
	taskSelection:setProject(self.newGameProject)
	taskSelection:setCostFont(self.elementCostFont)
	taskSelection:setFeatureID(taskTypeData.id)
	taskSelection:setFont(self.elementFont)
	taskSelection:setText(taskTypeData.display)
	taskSelection:setSize(360, 20)
	
	return taskSelection
end
