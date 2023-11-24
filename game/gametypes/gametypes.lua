local defaultGametypeFuncs = {}

defaultGametypeFuncs.mtindex = {
	__index = defaultGametypeFuncs
}
defaultGametypeFuncs.display = "default gametype 'display' var"
defaultGametypeFuncs.description = "change me in the config file 'description' var"
defaultGametypeFuncs.orderWeight = 100
defaultGametypeFuncs.usersPerYear = 125000
defaultGametypeFuncs.usersPerYearExponent = 2
defaultGametypeFuncs.usersPerYearMultiplier = 20000
defaultGametypeFuncs.headerText = "header at the top!"
defaultGametypeFuncs.headerIcon = "exclamation_point"
defaultGametypeFuncs.headerLineColor = game.UI_COLORS.YELLOW
defaultGametypeFuncs.headerTextColor = game.UI_COLORS.LIGHT_BLUE_TEXT
defaultGametypeFuncs.playlistID = musicPlayback.PLAYLIST_IDS.GAMEPLAY_PARTIAL
defaultGametypeFuncs.checkTutorial = true
defaultGametypeFuncs.startingJobSeekers = 15
defaultGametypeFuncs.allowPlatformAdvertisement = true
defaultGametypeFuncs.allowTrends = true
defaultGametypeFuncs.hudRestrictions = {}
defaultGametypeFuncs.objects = {}

function defaultGametypeFuncs:getHUDRestrictions()
	return self.hudRestrictions
end

function defaultGametypeFuncs:getPlacementObjects()
	return self.objects
end

function defaultGametypeFuncs:getStartingYearExtraUsers(startYear)
	return (startYear - timeline.baseYear)^self.usersPerYearExponent * self.usersPerYear
end

function defaultGametypeFuncs:placeObjectsIntoWorld()
	local grid = game.worldObject:getFloorTileGrid()
	
	for key, data in ipairs(self:getPlacementObjects()) do
		local gridX, gridY = data.pos[1], data.pos[2]
		local inst = objects.create(data.class)
		
		inst:setPos(grid:gridToWorld(gridX, gridY))
		inst:setRotation(data.rotation or walls.UP)
		inst:finalizeGridPlacement(gridX, gridY, data.floor or 1, true)
		inst:onPurchased()
	end
end

function defaultGametypeFuncs:getDefaultJobSeekers()
	return self.startingJobSeekers
end

function defaultGametypeFuncs:initEventHandler()
	if self.catchableEvents then
		events:addDirectReceiver(self, self.catchableEvents)
	end
end

function defaultGametypeFuncs:removeEventHandler()
	if self.catchableEvents then
		events:removeDirectReceiver(self, self.catchableEvents)
	end
end

function defaultGametypeFuncs:setPlaylist(initialSet)
	musicPlayback:setPlaylist(self.playlistID)
end

function defaultGametypeFuncs:canStartGame()
	return true
end

function defaultGametypeFuncs:preBegin()
	if not self:verifyTutorialPlaythrough() then
		return false
	end
	
	return true
end

function defaultGametypeFuncs:confirmPlaythroughCallback()
	self.campaignData:begin()
end

function defaultGametypeFuncs:confirmPlaythroughDontBotherCallback()
	self.campaignData:begin()
	game.markNoTutorialBother()
end

function defaultGametypeFuncs:verifyTutorialPlaythrough()
	if self.checkTutorial and game.canBotherWithTutorial() then
		local tutorID = game.TUTORIAL_CAMPAIGN_ID
		local wasCompleted = game.wasCampaignFinished(tutorID)
		
		if wasCompleted then
			return true
		end
		
		local wasStarted = game.wasCampaignStarted(tutorID)
		local popup = gui.create("Popup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("CONFIRM_PLAYTHROUGH_TITLE", "Confirm Playthrough"))
		popup:setTextFont("pix20")
		
		if not wasStarted then
			popup:setText(_format(_T("NO_TUTORIAL_STARTED_PLAYTHROUGH_CONFIRM", "You have not played through the Tutorial, are you sure you wish to start a new game of 'CAMPAIGN'?\n\nIt is highly recommended you play through the tutorial first, as playing in any scenario without knowing how it works will not be easy."), "CAMPAIGN", self.display))
		else
			popup:setText(_format(_T("NO_TUTORIAL_COMPLETED_PLAYTHROUGH_CONFIRM", "You have not finished playing through the Tutorial, are you sure you wish to start a new game of 'CAMPAIGN'?\n\nIt is highly recommended you play through the tutorial first, as playing in any scenario without knowing how it works will not be easy."), "CAMPAIGN", self.display))
		end
		
		popup:addButton("pix20", _T("CONFIRM", "Confirm"), defaultGametypeFuncs.confirmPlaythroughCallback).campaignData = self
		
		if game.canDisableTutorialBothering() then
			popup:addButton("pix20", _T("CONFIRM_AND_DONT_SHOW_THIS_AGAIN", "Confirm & don't show this again"), defaultGametypeFuncs.confirmPlaythroughDontBotherCallback).campaignData = self
		end
		
		popup:addButton("pix20", _T("CANCEL", "Cancel"))
		popup:center()
		frameController:push(popup)
		game.increaseTutorialBother()
		
		return false
	end
	
	return true
end

function defaultGametypeFuncs:setupInvalidityDescbox(descbox)
end

function defaultGametypeFuncs:setPlayerCharacter(pc)
	self.playerCharacter = pc
end

function defaultGametypeFuncs:getMap()
	return self.map
end

function defaultGametypeFuncs:getID()
	return self.id
end

function defaultGametypeFuncs:setupText(descBox, frame)
	descBox:addSpaceToNextText(5)
	descBox:addTextLine(frame.w - _S(20), self.headerLineColor, _S(24), "weak_gradient_horizontal")
	descBox:addText(self.headerText, "bh20", self.headerTextColor, 0, frame.rawW, {
		{
			width = 22,
			x = 2,
			height = 22,
			icon = self.headerIcon
		}
	})
	
	local text = self:formatDescription()
	
	if text then
		descBox:addText(text, "pix20", nil, 0, frame.rawW)
	end
end

function defaultGametypeFuncs:formatDescription()
	return self.description
end

function defaultGametypeFuncs:handleEvent(event, ...)
end

function defaultGametypeFuncs:start()
	self:initEventHandler()
	self:startCallback()
end

function defaultGametypeFuncs:postStart()
	self:postStartCallback()
end

function defaultGametypeFuncs:begin()
	game.startNewGame()
end

function defaultGametypeFuncs:remove()
	self:removeEventHandler()
	self:removeCallback()
end

function defaultGametypeFuncs:giveStartingThemesGenres()
	if game.hasRandomizationState(game.RANDOMIZATION_STATES.STARTING_GENRES) then
		local temporaryGenres = {}
		
		for key, data in ipairs(genres.registered) do
			temporaryGenres[#temporaryGenres + 1] = data.id
		end
		
		local chosenGenres = {}
		
		for i = 1, #self.startingGenres do
			local genreID = table.remove(temporaryGenres, math.random(1, #temporaryGenres))
			
			studio:addResearchedGenre(genreID)
			
			chosenGenres[#chosenGenres + 1] = genreID
		end
		
		local goodMatch = true
		local validThemes = {}
		
		for i = 1, #self.startingThemes do
			local randomGenre = chosenGenres[math.random(1, #chosenGenres)]
			
			for key, themeData in ipairs(themes.registered) do
				if not studio:isThemeResearched(themeData.id) then
					local matchValue = themeData.match[randomGenre]
					
					if goodMatch then
						if matchValue > 1 then
							validThemes[#validThemes + 1] = themeData.id
						end
					elseif matchValue < 1 then
						validThemes[#validThemes + 1] = themeData.id
					end
				end
			end
			
			local randomTheme = validThemes[math.random(1, #validThemes)]
			
			if randomTheme then
				studio:addResearchedTheme(randomTheme)
			end
			
			goodMatch = not goodMatch
			
			table.clearArray(validThemes)
		end
		
		return 
	end
	
	for key, themeID in ipairs(self.startingThemes) do
		studio:addResearchedTheme(themeID)
	end
	
	for key, genreID in ipairs(self.startingGenres) do
		studio:addResearchedGenre(genreID)
	end
end

function defaultGametypeFuncs:getRivals()
	return self.rivals
end

function defaultGametypeFuncs:getRivalBuildings()
	return self.rivalBuildings
end

function defaultGametypeFuncs:getStartingEmployees()
	return self.startingEmployees
end

function defaultGametypeFuncs:getStartingMoney()
	return self.startMoney
end

function defaultGametypeFuncs:fillOptionsMenu()
end

function defaultGametypeFuncs:giveStartingEmployees()
	local list = self:getStartingEmployees()
	
	if list then
		employeeCirculation:generateEmployeesFromConfig(list, studio)
		
		for key, dev in ipairs(studio:getEmployees()) do
			dev:maxTraitDiscovery()
		end
	end
end

function defaultGametypeFuncs:setupStartingRivals()
	local rivalBuildings = self:getRivalBuildings()
	
	if rivalBuildings then
		for key, rivalID in ipairs(self:getRivals()) do
			local rivalObject = rivalGameCompanies:getCompanyByID(rivalID)
			local building = rivalBuildings[rivalID]
			
			if building then
				if type(building) == "table" then
					for key, buildingID in ipairs(building) do
						rivalObject:initBuildingOwnership(buildingID)
					end
				else
					rivalObject:initBuildingOwnership(building)
				end
			end
		end
	end
end

function defaultGametypeFuncs:getStartingTime()
	return self.startTime
end

function defaultGametypeFuncs:setupStartingTime()
	local startTime = self:getStartingTime()
	
	if type(startTime) == "table" then
		timeline:setTime(timeline:getDateTime(startTime.year, startTime.month))
		
		self.startingYear = startTime.year
	else
		local year = timeline:getYear(startTime)
		
		timeline:setTime(startTime)
		
		self.startingYear = year
	end
end

function defaultGametypeFuncs:unlockStartingTech()
	if not self.unlockTechAtStartTime then
		return 
	end
	
	local startTime = self:getStartingTime()
	
	if type(startTime) == "table" then
		taskTypes:unlockTechOfDate(startTime.year, startTime.month)
	else
		taskTypes:unlockTechOfDate(timeline:getYear(startTime), 1)
	end
end

function defaultGametypeFuncs:loadStartTime(data)
	self.startingYear = data.startingYear or timeline.baseYear
end

function defaultGametypeFuncs:saveStartTime(data)
	data.startingYear = self.startingYear
end

function defaultGametypeFuncs:getStartTime()
	return self.startingYear
end

function defaultGametypeFuncs:startCallback()
end

function defaultGametypeFuncs:postStartCallback()
end

function defaultGametypeFuncs:removeCallback()
end

function defaultGametypeFuncs:onDeselected()
end

function defaultGametypeFuncs:onSelected()
end

function defaultGametypeFuncs:preventAchievements()
	return false
end

function defaultGametypeFuncs:save()
end

function defaultGametypeFuncs:load(data)
end

game.GAME_TYPES = {}
game.GAME_TYPES_BY_ID = {}
game.SORTED_GAME_TYPES = {}
game.GAMETYPES_TO_FINISH = {}

local function sortByWeight(a, b)
	return a.orderWeight < b.orderWeight
end

function game.registerGameType(data, baseClassID)
	data.mtindex = {
		__index = data
	}
	
	if data.invisible == nil then
		data.invisible = false
	end
	
	if baseClassID then
		local baseClass = game.GAME_TYPES_BY_ID[baseClassID]
		
		setmetatable(data, baseClass.mtindex)
		
		data.baseClass = baseClass
	else
		setmetatable(data, defaultGametypeFuncs.mtindex)
		
		data.baseClass = defaultGametypeFuncs
	end
	
	table.insert(game.GAME_TYPES, data)
	
	if not data.invisible then
		table.insert(game.SORTED_GAME_TYPES, data)
	end
	
	game.GAME_TYPES_BY_ID[data.id] = data
	
	table.sortl(game.SORTED_GAME_TYPES, sortByWeight)
	
	if data.trackCompletion then
		table.insert(game.GAMETYPES_TO_FINISH, data.id)
	end
end

function game.getGameTypeData(id)
	return game.GAME_TYPES_BY_ID[id]
end

function game.fillPlaythroughRandomizationDescbox(descBox, wrapwidth)
	descBox:addText(_T("PLAYTHROUGH_RANDOMIZATION_DESC_2", "This will randomize theme-genre matching, genre-quality matching and various platform stats."), "pix18", nil, 0, wrapwidth)
end

function game.areGametypesFinished()
	local campaignList = game.gameData.finishedCampaigns
	
	if not campaignList then
		return false
	end
	
	for key, id in ipairs(game.GAMETYPES_TO_FINISH) do
		if not campaignList[id] then
			return false
		end
	end
	
	return true
end

require("game/gametypes/standard")
require("game/gametypes/story_mode")
require("game/gametypes/storytest")
require("game/gametypes/scenario_back_in_the_game")
require("game/gametypes/scenario_pay_denbts")
require("game/gametypes/scenario_ravioli_and_pepperoni")
require("game/gametypes/scenario_console_domination")
require("game/gametypes/tutorial_construction")
require("game/gametypes/tutorial_employees")
require("game/gametypes/tutorial_projects")

if DEBUG_MODE then
	require("game/gametypes/scenario_console_domination_dev")
end

require("game/gametypes/freeplay")
require("game/gametypes/scenario_developer_commentary")
