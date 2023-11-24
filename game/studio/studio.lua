studio = {}
studio.funds = nil
studio.hiredDevelopers = nil
studio.hiredDevelopersByUID = nil
studio.ID = "player_studio"
studio.EVENTS = {
	TEAM_ADDED = events:new(),
	TEAM_DISMANTLED = events:new(),
	EMPLOYEE_HIRED = events:new(),
	EMPLOYEE_FIRED = events:new(),
	EMPLOYEE_LEFT = events:new(),
	EMPLOYEE_COUNT_CHANGED = events:new(),
	FUNDS_CHANGED = events:new(),
	FUNDS_SET = events:new(),
	RELEASED_GAME = events:new(),
	NEW_ENGINE = events:new(),
	BEGUN_FEATURE_RESEARCH = events:new(),
	PURCHASED_PLATFORM_LICENSE = events:new(),
	OFFERED_BRIBE = events:new(),
	ROOMS_UPDATED = events:new(),
	ROOM_UPDATED = events:new(),
	REPUTATION_CHANGED = events:new(),
	REPUTATION_SET = events:new(),
	TEAM_CREATED = events:new(),
	CONFIRM_STUDIO_NAME = events:new(),
	CHANGED_LOAN = events:new(),
	STARTED_SELLING_ENGINE = events:new(),
	BEGUN_AUTO_RESEARCH = events:new(),
	UPDATE_MMO_HAPPINESS = events:new(),
	OPINION_CHANGED = events:new()
}
studio.EMPLOYEE_LEAVE_REASONS = {
	RIVAL_GAME_STUDIO = 5,
	DIED = 3,
	FIRED = 1,
	LEFT = 2,
	RETIRED = 4
}
studio.REPUTATION_TO_SALE_MULTIPLIER_DIVIDER = 200000
studio.MAX_REPUTATION_TO_SALE_MULTIPLIER = 1
studio.BOUGHT_FIRST_PLATFORM_LICENSE_FACT = "bought_first_platform_license"
studio.FIRST_TIME_NEGATIVE_FACT = "first_time_negative_funds"
studio.CONTRIBUTION_REVEAL_TYPES = {
	GAME_QUALITY = "gamequality",
	AUDIENCE_MATCHING = "audiencematching",
	PLATFORM_MATCHING = "platformmatching",
	KNOWLEDGE = "knowledge",
	SUBGENRE_MATCHING = "subgenrematching",
	PERSPECTIVE_MATCHING = "perspectivematching",
	THEME_MATCHING = "themematching",
	EDITION_PART = "editionpart"
}
studio.ROOM_TYPE_COUNT = 0
studio.ROOM_TYPES = {}
studio.ROOM_TYPES_BY_INDEX = {}
studio.ROOM_TYPE_NAMES = {}
studio.WORKPLACE_STATUS = {
	AVAILABLE = 4,
	ALL_IN_USE = 1,
	NO_WORKPLACES = 2,
	MAX_EMPLOYEES_REACHED = 5,
	WOULD_REACH_MAX_EMPLOYEES = 6,
	MAX_WORK_OFFERS = 3
}
studio.MAX_STUDIO_NAME = 25
studio.ROW_X_DISTANCE = 80
studio.ROW_Y_DISTANCE = 80
studio.EMPLOYEES_PER_COLUMN = 5
studio.EMPLOYEE_SIZE = 48
studio.TILE_COST = 500
studio.DEFAULT_BORDER_WALL_ID = 1
studio.BANKRUPTCY_TIME_PERIOD = 5
studio.NEW_TECH_UNTIL_CONVERSATION_NOTIFICATION = 12
studio.MAX_FRUSTRATION_LEAVE_PER_MONTH = 2
studio.COURT_LOSS_REPUTATION_LOSS = 0.3
studio.MONTHLY_COST_PER_EMPLOYEE = monthlyCost.new()

studio.MONTHLY_COST_PER_EMPLOYEE:setCostType("water", 3)

studio.ACTIVITY_FUND_TYPE = {
	BRING_YOUR_OWN = 0,
	ON_THE_HOUSE = 1
}
studio.SCHEDULE_FAILURE_REASON = {
	NO_ACTIVITY = 0,
	NO_FUND_TYPE = 1,
	NO_PARTICIPANTS = 2
}
studio.REVEALED_BRIBES = "revealed_bribes"
studio.LAST_BRIBE_TIME = "last_bribe_time"
studio.TOTAL_QA_SESSIONS = "total_qa_sessions"
studio.BAD_GAME_SCORE_THRESHOLD = 5
studio.BAD_GAME_COUNT_BEFORE_REP_LOSS = 3
studio.BAD_GAME_REP_LOSS_DURATION = timeline.WEEKS_IN_MONTH * timeline.DAYS_IN_WEEK
studio.BAD_GAME_REP_LOSS_PER_SCORE = 100
studio.BAD_GAME_REP_LOSS_FROM_REPUTATION = 0.0001
studio.BAD_GAME_REP_LOSS_PER_GAME = 0.03
studio.BAD_GAME_REP_LOSS_MAX = 0.09
studio.MIN_REP_TO_LOSE_REP_TO_BAD_GAMES = 5000
studio.REP_LOSS_PER_WEEK = 1 / timeline.WEEKS_IN_MONTH
studio.CASH_RECOUP_PER_REPUTATION_POINT = 250
studio.CATCHABLE_EVENTS = {}
studio.SERVERS_OVERLOADED_COOLDOWN = timeline.DAYS_IN_WEEK * 2
studio.SERVER_OVERLOAD_DIALOGUE_FACT = "server_overload_dialogue"
studio.OPINION = {
	1,
	1000
}
studio.DEFAULT_OPINION = 500
studio.brightnessMap = brightnessMap.new()

function studio:registerRoomType(stringID, name)
	studio.ROOM_TYPE_COUNT = studio.ROOM_TYPE_COUNT + 1
	studio.ROOM_TYPES[stringID] = studio.ROOM_TYPE_COUNT
	studio.ROOM_TYPES_BY_INDEX[studio.ROOM_TYPE_COUNT] = stringID
	studio.ROOM_TYPE_NAMES[stringID] = name
end

function studio:getRoomTypeName(roomType)
	if type(roomType) == "string" then
		return studio.ROOM_TYPE_NAMES[roomType]
	end
	
	return studio.ROOM_TYPE_NAMES[studio.ROOM_TYPES_BY_INDEX[roomType]]
end

studio:registerRoomType("OFFICE", _T("ROOM_TYPE_OFFICE", "Work room"))
studio:registerRoomType("TOILET", _T("ROOM_TYPE_TOILET", "Restroom"))
studio:registerRoomType("KITCHEN", _T("ROOM_TYPE_KITCHEN", "Kitchen"))
studio:registerRoomType("CONFERENCE", _T("ROOM_TYPE_CONFERENCE", "Conference room"))
studio:registerRoomType("SERVER", _T("ROOM_TYPE_SERVER", "Server room"))

function studio:init()
	self.canUpdateOverallEfficiency = true
	self.fundChange = 0
	self.loan = 0
	self.serverOverloadCooldown = 0
	self.employeeAchvID = 1
	self.fundAchvID = 1
	
	self.brightnessMap:init()
	
	self.officeBuildingMap = officeBuildingMap.new()
	self.ownedBuildings = {}
	self.hiredDevelopers = {}
	self.hiredDevelopersByUID = {}
	self.hiredManagers = {}
	self.sortedBySkill = {}
	self.teamlessEmployees = {}
	self.engines = {}
	self.researchedFeatures = {}
	self.games = {}
	self.gamesByUniqueID = {}
	self.releasedGames = {}
	self.projects = {}
	self.teams = {}
	self.ownedTiles = {}
	self.ownedObjects = {}
	self.ownedObjectsByClass = {}
	self.interestBoost = {}
	self.lastActivities = {}
	self.scheduledActivity = {
		participants = {}
	}
	self.willingParticipants = {}
	self.nonParticipants = {}
	self.knownActivityAffectors = {}
	self.monthlyCosts = {}
	self.sameRoomObjects = {}
	self.validRoomTypes = {}
	self.facts = {}
	self.newTechThisMonth = {}
	self.computerLevels = {}
	self.newIncompatibleTech = 0
	self.licensedPlatforms = {}
	self.licensedPlatformsMap = {}
	self.licensedEngines = {}
	self.boughtEngineLicenses = {}
	self.onVacationEmployees = 0
	self.bankruptcyMonths = 0
	self.devSpeedMultiplier = 1
	self.frustrationLeavings = 0
	self.lastActivityTime = 0
	self.highestQualityScores = {}
	self.highestSkills = {}
	self.boughtOutCompanies = {}
	self.inDevGames = {}
	self.financeHistory = financeHistory.new()
	self.stats = playthroughStats.new()
	self.firstPaymentDone = false
	self.totalKnowledge = {}
	self.tasks = {}
	self.renderDevelopers = {}
	self.renderDeveloperMap = {}
	self.gameAwardWins = {}
	self.revealedEditionMatches = {}
	self.revealedEditionMatchCount = 0
	self.totalGameAwards = 0
	self.gameAwardParticipations = 0
	self.viewableFloors = 1
	self.activeEmployees = {}
	self.activeEmployeesMap = {}
	self.employeeIter = 1
	self.playerPlatforms = {}
	self.activePlayerPlatforms = {}
	self.devPlayerPlatforms = {}
	self.totalPlatformCount = 0
	self.serverCapacity = 0
	self.realServerCapacity = 0
	self.serverUse = 0
	self.rentedServers = 0
	self.ignoreRentedServers = 0
	self.ignoreCustomerSupport = 0
	self.opinion = studio.DEFAULT_OPINION
	self.customerSupport = 0
	self.customerSupportValue = 0
	self.customerSupportUse = 0
	
	for key, knowledgeData in ipairs(knowledge.registered) do
		self.totalKnowledge[knowledgeData.id] = 0
	end
	
	self:resetHighestSkillInfo()
	
	self.researchedGenreCount = 0
	self.activePathfinderCount = 0
	self.pathfindingInProgress = {}
	self.pathfinderSanitisation = {}
	self.revealedMatches = {}
	self.revealedFeatures = {}
	self.researchedThemes = {}
	self.researchedGenres = {}
	self.badGameScores = {}
	self.nonPlayerCharacterEmployees = {}
	self.inResearchTasks = {}
	self.employeeCountByRole = {}
	
	for key, roleData in ipairs(attributes.profiler.roles) do
		self.employeeCountByRole[roleData.id] = 0
	end
	
	self.rooms = {}
	self.roomMap = {}
	self.lastBadGameDate = nil
	self.contractorGames = {}
	self.visibleDevelopers = {}
	self.slanderSuspicion = 0
	self.slanderReputationLoss = {}
	self.slanderAttemptKnowledge = {}
	self.name = _T("DEFAULT_STUDIO_NAME", "My studio")
	self.gamesByGenre = {}
	self.gamesByTheme = {}
	self.previousGamesByGenre = {}
	self.previousGamesByTheme = {}
	
	if self.devPathfinder then
		pf.removePathfinder(self.devPathfinder)
	end
	
	self.devPathfinder = pf.new(false, 10000)
	
	self.devPathfinder:setSeparatePathObjects(true)
	self.devPathfinder:setFilterFunc(function(self, neighborX, neighborY, startX, startY)
		local directionX, directionY = neighborX - startX, neighborY - startY
		local wallSides = walls:getSideFromDirection(directionX, directionY)
		local worldTileGrid = game.worldObject:getFloorTileGrid()
		local gridObjects = game.worldObject:getObjectGrid():getObjects(neighborX, neighborY)
		local initialIndex = worldTileGrid:getTileIndex(startX, startY)
		
		if gridObjects then
			for key, object in ipairs(gridObjects) do
				if object.preventsMovement and object ~= studio.pathfinderTargetObject then
					return false
				end
			end
		end
		
		local initialWallSides = walls:getSideFromDirection(-directionX, -directionY)
		
		for key, wallSide in ipairs(initialWallSides) do
			if worldTileGrid:hasWall(initialIndex, wallSide) then
				return nil
			end
		end
		
		local targetIndex = worldTileGrid:getTileIndex(neighborX, neighborY)
		
		for key, wallSide in ipairs(wallSides) do
			if worldTileGrid:hasWall(targetIndex, wallSide) then
				return nil
			end
		end
		
		return true
	end)
	self.devPathfinder:setEligibleBlockCheck(function(x, y)
		return self.ownedTiles[game.worldObject:getFloorTileGrid():getTileIndex(x, y)] ~= nil
	end)
	self:setFunds(game.STARTING_FUND_AMOUNT)
	self:setReputation(0)
	
	self.totalMonthlyCost = 0
	
	events:addDirectReceiver(self, studio.CATCHABLE_EVENTS)
	self:buildHighestQualityScoreList()
end

function studio:setupFloorData()
	for i = 1, game.worldObject:getFloorCount() do
		self.roomMap[i] = {}
	end
end

function studio:changeOpinion(change)
	local bound = studio.OPINION
	
	self.opinion = math.max(bound[1], math.min(bound[2], self.opinion + change))
	
	events:fire(studio.EVENTS.OPINION_CHANGED, change)
end

function studio:setOpinion(set)
	self.opinion = set
	
	events:fire(studio.EVENTS.OPINION_CHANGED, set)
end

function studio:getOpinion()
	return self.opinion
end

function studio:getResearchTaskList()
	return self.inResearchTasks
end

function studio:setResearchTask(id, state)
	self.inResearchTasks[id] = state
end

function studio:addActivePlayerPlatform(plat)
	table.insert(self.activePlayerPlatforms, plat)
end

function studio:removeActivePlayerPlatform(plat)
	table.removeObject(self.activePlayerPlatforms, plat)
end

function studio:getActivePlayerPlatforms()
	return self.activePlayerPlatforms
end

function studio:addPlayerPlatform(obj)
	self.playerPlatforms[#self.playerPlatforms + 1] = obj
	self.totalPlatformCount = self.totalPlatformCount + 1
	
	platformShare:referencePlatformID(obj:getID(), obj)
end

function studio:getPlayerPlatforms()
	return self.playerPlatforms
end

function studio:addDevPlayerPlatform(obj)
	self.devPlayerPlatforms[#self.devPlayerPlatforms + 1] = obj
	
	platformShare:referencePlatformID(obj:getID(), obj)
end

function studio:removeDevPlayerPlatform(obj)
	table.removeObject(self.devPlayerPlatforms, obj)
end

function studio:getDevPlayerPlatforms()
	return self.devPlayerPlatforms
end

function studio:getPlatformByID(id)
	for key, obj in ipairs(self.playerPlatforms) do
		if obj:getID() == id then
			return obj
		end
	end
	
	for key, obj in ipairs(self.devPlayerPlatforms) do
		if obj:getID() == id then
			return obj
		end
	end
	
	return nil
end

function studio:changeFrustrationLeaving(change)
	self.frustrationLeavings = self.frustrationLeavings + change
end

function studio:getFrustrationLeavings()
	return self.frustrationLeavings
end

function studio:getID()
	return studio.ID
end

function studio:getTotalPlatformCount()
	return self.totalPlatformCount
end

function studio:createNamingPopup()
	local frame = gui.create("Frame")
	
	frame:setAnimated(false)
	frame:setSize(380, 105)
	frame:setFont("pix24")
	frame:setTitle(_T("ENTER_STUDIO_NAME_TITLE", "Enter Studio Name"))
	frame:hideCloseButton()
	
	local textbox = gui.create("TextBox", frame)
	
	textbox:setPos(_S(5), _S(35))
	textbox:setFont("pix24")
	textbox:setAutoAdjustFonts(fonts.GENERIC_TEXT_AUTO_ADJUST_FONTS)
	textbox:setGhostText(_T("ENTER_STUDIO_NAME", "Enter Studio Name"))
	textbox:setText(self.name)
	textbox:setShouldCenter(true)
	textbox:setMaxText(studio.MAX_STUDIO_NAME)
	textbox:setSize(370, 30)
	
	local confirm = gui.create("ConfirmOfficeNameButton", frame)
	
	confirm:setPos(_S(5), textbox.y + textbox.h + _S(5))
	confirm:setText(_T("CONFIRM_STUDIO_NAME", "Confirm studio name"))
	confirm:setFont("pix26")
	confirm:setSize(370, 30)
	confirm:setTextBox(textbox)
	frame:center()
	frameController:push(frame)
end

function studio:confirmStudioName(studioName)
	self:setName(studioName)
	events:fire(studio.EVENTS.CONFIRM_STUDIO_NAME)
end

function studio:confirmStudioNameCallback()
	frameController:pop()
	studio:confirmStudioName(self.studioName)
end

function studio:createNameConfirmationPopup(studioName)
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("CONFIRM_STUDIO_NAME_TITLE", "Confirm Studio Name"))
	popup:setTextFont("pix20")
	popup:hideCloseButton()
	popup:setText(_T("CONFIRM_STUDIO_NAME_DESC", "Are you sure you want to use this company name?\nYou won't be able to change the name of your company later."))
	
	local button = popup:addButton("pix20", _T("YES", "Yes"), studio.confirmStudioNameCallback)
	
	button.studioName = studioName
	
	popup:addButton("pix20", _T("NO", "No"), nil)
	popup:center()
	frameController:push(popup)
end

function studio:setName(name)
	self.name = name
end

function studio:getName()
	return self.name
end

function studio:getFinanceHistory()
	return self.financeHistory
end

function studio:isPlayer()
	return true
end

function studio:getBrightnessMap()
	return self.brightnessMap
end

function studio:getOfficeBuildingMap()
	return self.officeBuildingMap
end

function studio:getOfficeAtIndex(index)
	return self.officeBuildingMap:getTileBuilding(index)
end

function studio:setFact(factID, state)
	self.facts[factID] = state
end

function studio:updateComputerLevels()
	table.clear(self.computerLevels)
	
	local lowestLevel = math.huge
	local highestLevel = -math.huge
	
	for key, object in ipairs(self.ownedObjects) do
		if object.COMPUTER then
			local progression = object:getProgression()
			
			lowestLevel = math.min(lowestLevel, progression)
			highestLevel = math.max(highestLevel, progression)
			self.computerLevels[progression] = (self.computerLevels[progression] or 0) + 1
		end
	end
	
	self.lowestComputerLevel = lowestLevel
	self.highestComputerLevel = highestLevel
end

function studio:getComputerLevels()
	return self.computerLevels
end

function studio:getStats()
	return self.stats
end

function studio:addNewTechThisMonth(data)
	table.insert(self.newTechThisMonth, data)
	
	if self.lowestComputerLevel then
		local taskTypeData = taskTypes:getTaskByFactRequirement(data.id)
		local computerLevel = taskTypeData:getComputerLevelRequirement()
		
		if computerLevel and computerLevel > self.lowestComputerLevel then
			self.newIncompatibleTech = self.newIncompatibleTech + 1
		end
	end
end

function studio:purchasePlatformLicense(id, isFree)
	self.licensedPlatforms[#self.licensedPlatforms + 1] = id
	self.licensedPlatformsMap[id] = true
	
	if not isFree then
		local data = platforms.registeredByID[id]
		
		self:deductFunds(data.licenseCost, nil, "platform_licensing")
	end
	
	if self:isPlayer() and not self.facts[studio.BOUGHT_FIRST_PLATFORM_LICENSE_FACT] and not isFree then
		local popup = game.createPopup(600, _T("FIRST_PLATFORM_LICENSE_PURCHASED_TITLE", "First Platform License Purchased"), _T("FIRST_PLATFORM_LICENSE_PURCHASED_DESC", "You've purchased your first platform license, congratulations!\n\nMost platforms will require that you add support for them in your game engines before you can develop a game for them, so be sure to check out the engine task list."), fonts.get("pix24"), fonts.get("pix20"))
		
		frameController:push(popup)
		self:setFact(studio.BOUGHT_FIRST_PLATFORM_LICENSE_FACT, true)
	end
	
	events:fire(studio.EVENTS.PURCHASED_PLATFORM_LICENSE, id, self)
end

function studio:getAverageSkillLevel(skillID)
	local members, skillLevel = 0, 0
	
	for key, employee in ipairs(self.hiredDevelopers) do
		if employee.roleData.mainSkill == skillID then
			members = members + 1
			skillLevel = skillLevel + employee:getSkillLevel(skillID)
		end
	end
	
	return math.round(skillLevel / members)
end

function studio:getLoan()
	return self.loan
end

function studio:changeLoan(change)
	self.loan = math.max(0, self.loan + change)
	
	self:addFunds(change, true, "loans")
	events:fire(studio.EVENTS.CHANGED_LOAN, change)
end

function studio:buildHighestQualityScoreList()
	for key, qualityData in ipairs(gameQuality.registered) do
		local scoreTable = self.highestQualityScores[qualityData.id] or {}
		
		self.highestQualityScores[qualityData.id] = scoreTable
		scoreTable.score = 0
		scoreTable.game = nil
	end
	
	for key, gameObj in ipairs(self.releasedGames) do
		self:updateHighestQualityScore(gameObj)
	end
end

function studio:updateHighestQualityScore(gameObj)
	for scoreID, score in pairs(gameObj:getQualityPoints()) do
		local scoreTable = self.highestQualityScores[scoreID]
		
		highestScore = scoreTable.score
		
		if score > highestScore then
			scoreTable.score = score
			scoreTable.game = gameObj
		end
	end
end

function studio:getHighestQualityScoreGame(qualityID)
	return self.highestQualityScores[qualityID]
end

function studio:hasPlatformLicense(id)
	return self.licensedPlatformsMap[id] ~= nil
end

function studio:getLicensedPlatforms()
	return self.licensedPlatforms
end

function studio:getLicensedPlatformsMap()
	return self.licensedPlatformsMap
end

function studio:changeOnVacationEmployeeCount(change)
	self.onVacationEmployees = self.onVacationEmployees + change
end

function studio:getOnVacationEmployees()
	return self.onVacationEmployees
end

function studio:getWorkOffersCount()
	local jobSeekers = employeeCirculation:getJobSeekers()
	local total = 0
	
	for key, employeeObj in ipairs(jobSeekers) do
		if employeeObj:hasOfferedWork() then
			total = total + 1
		end
	end
	
	return total
end

function studio:getFreeWorkplaceCount()
	return employeeAssignment:getStudioWorkplaceCount()
end

function studio:getHireableEmployeeCount()
	local workplaces = self:getFreeWorkplaceCount()
	
	if workplaces <= 0 then
		return 0
	end
	
	return workplaces - self:getWorkOffersCount(), workplaces
end

function studio:canHireEmployee(employee)
	return self:getHireableEmployeeCount() > 0
end

function studio:getBestEmployeeBySkill(skill)
	local bestEmpl, highestSkill = nil, -math.huge
	
	for key, employee in ipairs(self.hiredDevelopers) do
		if employee:isAvailable() then
			local task = employee:getTask()
			
			if not task or task:canReassign(employee) then
				local level = employee:getSkillLevel(skill)
				
				if highestSkill <= level then
					highestSkill = level
					bestEmpl = employee
				end
			end
		end
	end
	
	return bestEmpl
end

function studio:getWorkplaceStatus()
	local freeWorkplaces = 0
	local validWorkplaces = 0
	
	for key, officeObject in ipairs(self.ownedBuildings) do
		local workplaces = officeObject:getWorkplaces()
		
		validWorkplaces = validWorkplaces + employeeAssignment:getValidWorkplaceCount(workplaces)
		freeWorkplaces = freeWorkplaces + employeeAssignment:getWorkplaceCount(workplaces)
	end
	
	freeWorkplaces = freeWorkplaces - #self.hiredDevelopers
	
	if freeWorkplaces == 0 then
		if validWorkplaces > 0 then
			return studio.WORKPLACE_STATUS.ALL_IN_USE
		else
			return studio.WORKPLACE_STATUS.NO_WORKPLACES
		end
		
		return false
	elseif freeWorkplaces - self:getWorkOffersCount() <= 0 then
		return studio.WORKPLACE_STATUS.MAX_WORK_OFFERS
	end
	
	return studio.WORKPLACE_STATUS.AVAILABLE
end

function studio:getImplementedEngineFeatures()
	return self.implementedFeatures
end

function studio:buildImplementedEngineFeatures()
	self.implementedFeatures = {}
	
	for key, engineObj in ipairs(self.engines) do
		for feature, state in pairs(engineObj:getFeatures()) do
			if state then
				self.implementedFeatures[feature] = true
			end
		end
	end
	
	return self.implementedFeatures
end

function studio:revealFeature(featureID)
	if self.revealedFeatures[featureID] then
		return false
	end
	
	self.revealedFeatures[featureID] = true
	
	return true
end

function studio:isFeatureRevealed(featureID)
	return self.revealedFeatures[featureID]
end

function studio:revealGameQualityMatching(type, match, projectObject)
	if not self.revealedMatches[type] then
		self.revealedMatches[type] = {}
	end
	
	local contrib = studio.CONTRIBUTION_REVEAL_TYPES
	
	if type == contrib.GAME_QUALITY then
		local genre = projectObject:getGenre()
		
		self.revealedMatches[type][genre] = self.revealedMatches[type][genre] or {}
		
		local isNew = self.revealedMatches[type][genre][match] == nil
		
		self.revealedMatches[type][genre][match] = true
		
		return isNew
	elseif type == contrib.THEME_MATCHING then
		local theme, genre = projectObject:getTheme(), projectObject:getGenre()
		
		self.revealedMatches[type][theme] = self.revealedMatches[type][theme] or {}
		
		local isNew = self.revealedMatches[type][theme][genre] == nil
		
		self.revealedMatches[type][theme][genre] = true
		
		return isNew
	elseif type == contrib.PERSPECTIVE_MATCHING then
		local genre, perspective = projectObject:getGenre(), projectObject:getFact("perspective")
		
		self.revealedMatches[type][genre] = self.revealedMatches[type][genre] or {}
		
		local isNew = self.revealedMatches[type][genre][perspective] == nil
		
		self.revealedMatches[type][genre][perspective] = true
		
		return isNew
	elseif type == contrib.AUDIENCE_MATCHING then
		local audience, genre = projectObject:getAudience(), projectObject:getGenre()
		
		self.revealedMatches[type][audience] = self.revealedMatches[type][audience] or {}
		
		local isNew = self.revealedMatches[type][audience][genre] == nil
		
		self.revealedMatches[type][audience][genre] = true
		
		return isNew
	elseif type == contrib.PLATFORM_MATCHING or type == contrib.SUBGENRE_MATCHING then
		local genre = projectObject:getGenre()
		
		self.revealedMatches[type][match] = self.revealedMatches[type][match] or {}
		
		local isNew = self.revealedMatches[type][match][genre] == nil
		
		self.revealedMatches[type][match][genre] = true
		
		return isNew
	end
	
	return nil
end

function studio:revealEditionMatch(partID, genre)
	local partList = self.revealedEditionMatches[partID]
	
	if not partList then
		partList = {}
		self.revealedEditionMatches[partID] = partList
	end
	
	if not partList[genre] then
		self.revealedEditionMatchCount = self.revealedEditionMatchCount + 1
		partList[genre] = true
		
		return true
	end
	
	return false
end

function studio:getEditionMatches(partID)
	return self.revealedEditionMatches[partID]
end

function studio:isEditionMatchRevealed(partID, genre)
	local list = self.revealedEditionMatches[partID]
	
	if list then
		return list[genre]
	end
	
	return false
end

function studio:isGameQualityMatchRevealed(type, match, extraData, projectObject)
	if self.revealedMatches[type] then
		local contrib = studio.CONTRIBUTION_REVEAL_TYPES
		
		if type == contrib.GAME_QUALITY then
			if projectObject then
				extraData = projectObject:getGenre()
			end
			
			if self.revealedMatches[type][extraData] then
				return self.revealedMatches[type][extraData][match]
			end
		elseif type == contrib.THEME_MATCHING then
			if projectObject then
				match = projectObject:getTheme()
				extraData = projectObject:getGenre()
			end
			
			if self.revealedMatches[type][match] then
				return self.revealedMatches[type][match][extraData]
			end
		elseif type == contrib.PERSPECTIVE_MATCHING then
			if not extraData and projectObject then
				match = projectObject:getGenre()
				extraData = projectObject:getFact("perspective")
			end
			
			if self.revealedMatches[type][match] then
				return self.revealedMatches[type][match][extraData]
			end
		elseif type == contrib.AUDIENCE_MATCHING then
			local genre
			
			if not extraData and projectObject then
				genre = projectObject:getGenre()
			else
				genre = extraData
			end
			
			if self.revealedMatches[type] and self.revealedMatches[type][match] then
				return self.revealedMatches[type][match][genre]
			end
		elseif (type == contrib.PLATFORM_MATCHING or type == contrib.SUBGENRE_MATCHING) and self.revealedMatches[type] and self.revealedMatches[type][match] then
			return self.revealedMatches[type][match][extraData]
		end
	end
	
	return nil
end

function studio:getTotalEmployeesBySpecialization(specID)
	local total = 0
	
	for key, teamObj in ipairs(self.teams) do
		total = total + teamObj:getSpecializationCount(specID)
	end
	
	return total
end

function studio:getNonPlayerCharacterEmployees()
	table.clearArray(self.nonPlayerCharacterEmployees)
	
	for key, employee in ipairs(self.hiredDevelopers) do
		if not employee:isPlayerCharacter() then
			self.nonPlayerCharacterEmployees[#self.nonPlayerCharacterEmployees + 1] = employee
		end
	end
	
	return self.nonPlayerCharacterEmployees
end

function studio:setPlayerCharacter(object)
	self.playerCharacter = object
end

function studio:getPlayerCharacter()
	return self.playerCharacter
end

eventBoxText:registerNew({
	id = "new_tech",
	getText = function(self, data)
		local techString = ""
		local count = #data
		
		for key, techID in ipairs(data) do
			local taskType = taskTypes:getData(techID)
			
			techString = techString .. taskType.display
			
			if key < count then
				techString = techString .. ", "
			end
		end
		
		return _format(_T("NEW_TECH_AVAILABLE", "New tech available: TECH"), "TECH", techString)
	end
})

function studio:postScheduledEventActivated(quiet)
	if quiet then
		table.clearArray(self.newTechThisMonth)
		
		self.newIncompatibleTech = 0
		
		return 
	end
	
	if #self.newTechThisMonth > 0 then
		local newTech = {}
		
		for key, data in ipairs(self.newTechThisMonth) do
			local taskType = taskTypes:getTaskByFactRequirement(data.id)
			
			if taskType then
				newTech[#newTech + 1] = taskType.id
			end
			
			self.newTechThisMonth[key] = nil
		end
		
		game.addToEventBox("new_tech", newTech, 1, nil, "exclamation_point")
	end
	
	if self.newIncompatibleTech >= studio.NEW_TECH_UNTIL_CONVERSATION_NOTIFICATION then
		local employeeList = self:getNonPlayerCharacterEmployees()
		
		if #employeeList > 0 then
			local randomEmployee = employeeList[math.random(1, #employeeList)]
			
			dialogueHandler:addDialogue("developer_outdated_tech_start", nil, randomEmployee)
			
			self.newIncompatibleTech = 0
		end
	end
end

function studio:changeEmployeeRoleCount(role, change)
	self.employeeCountByRole[role] = self.employeeCountByRole[role] + change
end

function studio:resetHighestSkillInfo()
	for key, data in ipairs(skills.registered) do
		self.highestSkills[data.id] = 0
	end
end

function studio:getRandomEmployeeOfRole(role)
	local rolled = math.random(1, self.employeeCountByRole[role])
	local curKey = 0
	
	for key, employee in ipairs(self.hiredDevelopers) do
		if employee:getRole() == role then
			curKey = curKey + 1
			
			if curKey == rolled then
				return employee
			end
		end
	end
	
	return nil
end

function studio.defaultBestValidityCallback(employee)
	return true
end

function studio.genericAvailabilityCheck(employee)
	local taskObj = employee:getTask()
	
	return employee:canAssignToTask() and (not taskObj or taskObj:canReassign(employee))
end

function studio:getMostExperiencedEmployee(role, validCallback)
	validCallback = validCallback or studio.defaultBestValidityCallback
	
	local roleData = attributes.profiler.rolesByID[role]
	local skill = roleData.mainSkill
	local highest, valid = 0
	
	for key, employee in ipairs(self.hiredDevelopers) do
		if employee:getRole() == role then
			local level = employee:getSkillLevel(skill)
			
			if highest < level and validCallback(employee) then
				highest = level
				valid = employee
			end
		end
	end
	
	return valid
end

function studio:updateHighestEmployeeSkills(employee)
	local employeeSkills = employee:getSkills()
	
	for key, skillData in ipairs(skills.registered) do
		local skillID = skillData.id
		local skillLevel = employeeSkills[skillID].level
		
		self.highestSkills[skillID] = math.max(self.highestSkills[skillID], skillLevel)
	end
end

function studio:recountEmployeesByRole(employeeList)
	for key, roleData in ipairs(attributes.profiler.roles) do
		self.employeeCountByRole[roleData.id] = 0
	end
	
	for key, employee in ipairs(employeeList or self.hiredDevelopers) do
		local role = employee:getRole()
		
		self.employeeCountByRole[role] = self.employeeCountByRole[role] + 1
	end
end

function studio:getEmployeeCountByRole(roleID)
	return self.employeeCountByRole[roleID]
end

function studio:recountHighestSkills(employeeList)
	self:resetHighestSkillInfo()
	
	for key, employee in ipairs(employeeList or self.hiredDevelopers) do
		local skillData = employee:getSkills()
		
		for key, data in ipairs(skills.registered) do
			local skillID = data.id
			local skillLevel = skillData[skillID].level
			
			self.highestSkills[skillID] = math.max(self.highestSkills[skillID], skillLevel)
		end
	end
end

function studio:updateHighestSkill(skillID, newLevel)
	self.highestSkills[skillID] = math.max(self.highestSkills[skillID], newLevel)
end

function studio:getHighestSkillLevel(skillID)
	return self.highestSkills[skillID]
end

function studio:getNewTechOnDate(year, month, tableInput)
	for key, taskData in ipairs(taskTypes.registered) do
		if taskData.releaseDate then
			tableInput[#tableInput + 1] = taskData
		end
	end
	
	return tableInput
end

function studio:getFact(factID)
	return self.facts[factID]
end

function studio:getPathfinder()
	return self.devPathfinder
end

function studio:isPathfinderFree()
	return not self.pathfindTarget and not self.devPathfinder:isBusy()
end

function studio:clearPathfinder()
	self.pathfindTarget = nil
	
	self.devPathfinder:clearResult()
	
	self.pathfinderTargetObject = nil
	self.pathfinderIgnorePosition = nil
end

function studio:abortPathfinding()
	table.clear(self.pathfindingInProgress)
	game.sendToPathfinderThreads(pathfinderThread.MESSAGE_TYPE.ABORT)
end

function studio:changeRentedServers(change)
	self.rentedServers = self.rentedServers + change
	self.ignoreRentedServers = self.ignoreRentedServers + change
	
	self:onRentedServersChanged()
end

function studio:getRentedServers()
	return self.rentedServers
end

eventBoxText:registerNew({
	id = "mmo_customer_support_overload",
	getText = function(self, data)
		return _T("MMO_CUSTOMER_SUPPORT_OVERLOADED", "MMO customer support overloaded!")
	end,
	fillInteractionComboBox = function(self, comboBox, uiElement)
		serverRenting:addMenuOption(comboBox, "pix20")
	end
})

function studio:changeCustomerSupport(change)
	self.customerSupport = self.customerSupport + change
	self.ignoreCustomerSupport = self.ignoreCustomerSupport + change
	
	self:onCustomerSupportChanged()
end

function studio:getCustomerSupport()
	return self.customerSupport
end

function studio:getCustomerSupportValue()
	return self.customerSupportValue
end

studio.CUSTOMER_SUPPORT_DIALOGUE_FACT = "mmo_customer_support_dialogue"
studio.CUSTOMER_SUPPORT_DIALOGUE = "manager_mmo_customer_support_1"

function studio:changeCustomerSupportUse(change, quiet)
	local oldUse = self.customerSupportUse
	local newUse = self.customerSupportUse + change
	local cap = self.customerSupportValue
	
	self.customerSupportUse = newUse
	
	if oldUse < cap and cap < newUse then
		if not quiet and not self.facts[studio.CUSTOMER_SUPPORT_DIALOGUE_FACT] then
			local soft = "manager"
			
			for key, employee in ipairs(studio:getEmployees()) do
				if employee:getRole() == soft then
					dialogueHandler:addDialogue(studio.CUSTOMER_SUPPORT_DIALOGUE, nil, employee)
					
					self.facts[studio.CUSTOMER_SUPPORT_DIALOGUE_FACT] = true
					
					break
				end
			end
		end
		
		local elem = game.addToEventBox("mmo_customer_support_overload", nil, 4, nil, "exclamation_point_red")
		
		elem:setFlash(true, true)
	end
end

function studio:getCustomerSupportUse()
	return self.customerSupportUse
end

function studio:getCustomerSupportUsePercentage()
	return self.customerSupportUse / self.customerSupportValue
end

function studio:getCustomerSupportDelta()
	return self.customerSupportValue - self.customerSupportUse
end

function studio:onCustomerSupportChanged()
	self.customerSupportValue = self.customerSupport * serverRenting:getCustomerSupportValue()
end

function studio:getRentedServerCapacity()
	return serverRenting:getCapacity() * self.rentedServers
end

function studio:getPendingRentedServers()
	return self.ignoreRentedServers
end

function studio:getPendingCustomerSupport()
	return self.ignoreCustomerSupport
end

function studio:changeServerCapacity(change)
	self.serverCapacity = self.serverCapacity + change
	
	self:onServerCapacityChanged()
end

function studio:onRentedServersChanged()
	self:onServerCapacityChanged()
end

function studio:onServerCapacityChanged()
	self.realServerCapacity = self.serverCapacity
	
	if self.rentedServers > 0 then
		self.realServerCapacity = self.realServerCapacity + serverRenting:getCapacity() * self.rentedServers
	end
end

function studio:getServerCapacity()
	return self.serverCapacity
end

function studio:getRealServerCapacity()
	return self.realServerCapacity
end

eventBoxText:registerNew({
	id = "mmo_servers_overloaded",
	getText = function(self, data)
		return _T("MMO_SERVERS_OVERLOADED", "MMO servers are overloaded!")
	end,
	fillInteractionComboBox = function(self, comboBox, uiElement)
		serverRenting:addMenuOption(comboBox, "pix20")
	end
})

function studio:changeServerUse(change)
	local prevUse = self.serverUse
	local newUse = math.max(0, self.serverUse + change)
	
	self.serverUse = newUse
	
	local realCap = self.realServerCapacity
	
	if realCap < newUse and prevUse < realCap and timeline.curTime > self.serverOverloadCooldown then
		self.serverOverloadCooldown = studio.SERVERS_OVERLOADED_COOLDOWN
		
		if not self.facts[studio.SERVER_OVERLOAD_DIALOGUE_FACT] then
			for key, employee in ipairs(self.hiredDevelopers) do
				if employee:getRole() == "software_engineer" then
					dialogueHandler:addDialogue("mmo_servers_overloaded_1", nil, employee)
					
					self.facts[studio.SERVER_OVERLOAD_DIALOGUE_FACT] = true
					
					return 
				end
			end
			
			local elem = game.addToEventBox("mmo_servers_overloaded", nil, 4, nil, "exclamation_point_red")
			
			elem:setFlash(true, true)
		else
			local elem = game.addToEventBox("mmo_servers_overloaded", nil, 4, nil, "exclamation_point_red")
			
			elem:setFlash(true, true)
		end
	end
end

function studio:getServerUse()
	return self.serverUse
end

function studio:getServerUsePercentage()
	return self.serverUse / self.realServerCapacity
end

function studio:beginAutoResearch()
	if #self.hiredDevelopers == 0 then
		return 
	end
	
	local taskClass = task:getData("research_task")
	
	taskClass:setupResearchableTasks()
	
	local success = false
	
	if #taskClass:getResearchableTasks() > 0 then
		for key, employeeObj in ipairs(self.hiredDevelopers) do
			if employeeObj:getWorkplace() and employeeObj:canResearch() then
				taskClass:attemptBeginAutoResearch(employeeObj)
				
				success = true
			end
		end
	end
	
	if success then
		events:fire(studio.EVENTS.BEGUN_AUTO_RESEARCH)
	end
end

function studio:sanitiseClearedPathfinders()
	local san = self.pathfinderSanitisation
	local realIndex = 1
	
	for i = 1, #san do
		local data = san[realIndex]
		local threadObj = data[1]
		
		if threadObj:cancelPath() then
			table.remove(san, realIndex)
			
			self.activePathfinderCount = self.activePathfinderCount - 1
			self.pathfindingInProgress[data[2]] = nil
		else
			realIndex = realIndex + 1
		end
	end
end

function studio:getPath(startX, startY, endX, endY, floor, destinationObject, retriever)
	self:sanitiseClearedPathfinders()
	
	local floorTileGrid = game.worldObject:getFloorTileGrid()
	
	floor = floor or 1
	
	if startX then
		local validPath = pathCaching:getPath(floorTileGrid:getTileIndex(startX, startY), floorTileGrid:getTileIndex(endX, endY), floor)
		
		if validPath then
			return validPath, true
		end
	end
	
	if self.activePathfinderCount >= game.MAX_PATHFINDER_THREADS and not self.pathfindingInProgress[retriever] then
		return nil, nil, false
	end
	
	local threadObj = self.pathfindingInProgress[retriever]
	
	if threadObj then
		local path, state, floor = threadObj:checkForPath()
		
		if state then
			pathCaching:addPath(path, floor)
			
			self.pathfindingInProgress[retriever] = nil
			self.activePathfinderCount = self.activePathfinderCount - 1
			
			return path, true, true
		elseif state == false then
			self.pathfindingInProgress[retriever] = nil
			self.activePathfinderCount = self.activePathfinderCount - 1
			
			return nil, false, true
		else
			return nil, nil, true
		end
	end
	
	local availableThread = game.searchThreadedPath(startX, startY, endX, endY, floor, {
		floorTileGrid:getTileIndex(startX, startY)
	})
	local newSearch = false
	
	if availableThread then
		self.pathfindingInProgress[retriever] = availableThread
		self.activePathfinderCount = self.activePathfinderCount + 1
		newSearch = true
	end
	
	return nil, nil, self.activePathfinderCount < game.MAX_PATHFINDER_THREADS, newSearch
end

function studio:clearPathfinder(retriever)
	local threadObj = self.pathfindingInProgress[retriever]
	
	if threadObj then
		if not threadObj:cancelPath() then
			table.insert(self.pathfinderSanitisation, {
				threadObj,
				retriever
			})
		else
			self.activePathfinderCount = self.activePathfinderCount - 1
			self.pathfindingInProgress[retriever] = nil
		end
	end
end

function studio:getActivePathfinders()
	return self.activePathfinderCount
end

function studio:getPathToObject(object1, object2)
	if self.pathfindTarget then
		return self:getPath(nil, nil, nil, nil, nil, object1)
	end
	
	local floorTileGrid = game.worldObject:getFloorTileGrid()
	local x1, y1 = floorTileGrid:worldToGrid(object1:getPos())
	local x2, y2 = floorTileGrid:worldToGrid(object2:getPos())
	
	return self:getPath(x1, y1, x2, y2, object1, object2, object1)
end

function studio:getPathToObjectEntrance(object1, object2)
	if self.pathfindTarget then
		return self:getPath(nil, nil, nil, nil, nil, object1)
	end
	
	local floorTileGrid = game.worldObject:getFloorTileGrid()
	local x1, y1 = floorTileGrid:worldToGrid(object1:getPos())
	local randomX, randomY = object2:getEntranceInteractionCoordinates()
	
	return self:getPath(x1, y1, randomX, randomY, object1:getFloor(), nil, object1)
end

function studio:getTeamEfficiency(team)
	local highest = -math.huge
	local bestTeam
	local ownEfficiency = 0
	
	for key, otherTeam in ipairs(self.teams) do
		local score = otherTeam:getEfficiencyScore()
		
		if team == otherTeam then
			ownEfficiency = score
		end
		
		if highest < score then
			highest = score
			bestTeam = otherTeam
		end
	end
	
	return ownEfficiency / highest, bestTeam, highest / ownEfficiency
end

function studio:handleKeyPress(key, isrepeat)
	if dialogueHandler:handleKeyPress(key, isrepeat) then
		return true
	end
	
	if self.expansion:handleKeyPress(key, isrepeat) then
		return true
	end
	
	if employeeAssignment:handleKeyPress(key, isrepeat) then
		return true
	end
	
	game.attemptSetCameraKey(key, true)
end

function studio:handleKeyRelease(key)
	game.attemptSetCameraKey(key, false)
end

function studio:isFeatureBeingResearched(featureID)
	local researchTaskClass = task:getData("research_task")
	
	for key, employee in ipairs(self.hiredDevelopers) do
		local task = employee:getTask()
		
		if task and task.mtindex == researchTaskClass.mtindex and task:getTaskType() == featureID then
			return true
		end
	end
	
	return false
end

function studio:handleClick(x, y, key, xVel, yVel)
	if self.expansion:handleClick(x, y, key, xVel, yVel) then
		return true
	end
	
	if employeeAssignment:handleClick(x, y, key, xVel, yVel) then
		return true
	end
	
	return false
end

function studio:passClickToObjects(x, y, key, xVel, yVel)
	if not frameController:preventsMouseOver() and not dialogueHandler:isActive() and not studio.expansion:isActive() and not gui:isLimitingClicks() then
		local obj = game.getMouseOverObject() or game.getObjectAtMousePos()
		
		if obj then
			if yVel ~= 0 then
				if obj.handleMouseWheel then
					return obj:handleMouseWheel(yVel)
				end
			elseif obj:handleClick(x, y, key) then
				return true
			end
		end
	end
	
	return false
end

function studio:handleClickRelease(x, y, key)
	return self.expansion:handleClickRelease(x, y, key)
end

function studio:handleMouseDrag(dx, dy)
	return self.expansion:handleMouseDrag(dx, dy)
end

function studio:doesGameHaveSequel(gameProj)
	for key, otherGame in ipairs(self.releasedGames) do
		if otherGame:getSequelTo() == gameProj then
			return true
		end
	end
	
	return false
end

function studio:getProjectByUniqueID(id)
	for key, projectObj in ipairs(self.projects) do
		if projectObj:getUniqueID() == id then
			return projectObj
		end
	end
	
	return self:getPatchByUniqueID(id)
end

function studio:getEmployeeByUniqueID(id)
	return self.hiredDevelopersByUID[id]
end

function studio:getTeamlessEmployees()
	table.clearArray(self.teamlessEmployees)
	
	for key, employeeObj in ipairs(self.hiredDevelopers) do
		if not employeeObj:isAssignedToTeam() then
			table.insert(self.teamlessEmployees, employeeObj)
		end
	end
	
	return self.teamlessEmployees
end

function studio:remove()
	self._disableReregistration = true
	self.soldEngineObj = nil
	
	table.clear(self.nonPlayerCharacterEmployees)
	table.clear(self.previousDevs)
	table.clearArray(self.teamlessEmployees)
	self.brightnessMap:remove()
	self.officeBuildingMap:scrub()
	
	self.playerCharacter = nil
	
	self:removeAllCreatedObjects()
	self:clearPathfinder()
	self.devPathfinder:abort()
	pf.removePathfinder(self.devPathfinder)
	
	local tasks = self.tasks
	
	while #tasks > 0 do
		tasks[#tasks]:cancel()
	end
	
	for key, plat in ipairs(self.playerPlatforms) do
		plat:destroy()
		
		self.playerPlatforms[key] = nil
	end
	
	for key, room in ipairs(self.rooms) do
		self.rooms[key] = nil
		
		local floor = room:getFloor()
		
		for key, index in ipairs(room:getTiles()) do
			self.roomMap[floor][index] = nil
		end
		
		room:remove()
	end
	
	events:removeDirectReceiver(self, studio.CATCHABLE_EVENTS)
end

function studio:removeAllCreatedObjects()
	self:removeAllObjects()
	self:removeAllDevelopers()
	self:removeAllTeams()
	self:removeAllProjects()
end

function studio:removeAllObjects()
	while self.ownedObjects[1] do
		local object = self.ownedObjects[#self.ownedObjects]
		
		object:remove()
		self:removeOwnedObject(object)
	end
end

function studio:removeAllDevelopers()
	for key, devObj in ipairs(self.hiredDevelopers) do
		self.hiredDevelopers[key] = nil
		
		devObj:remove()
	end
	
	for key, devObj in ipairs(self.visibleDevelopers) do
		self.visibleDevelopers[key] = nil
		self.previousDevs[devObj] = nil
	end
	
	for key, dev in ipairs(self.renderDevelopers) do
		self.renderDevelopers[key] = nil
		self.renderDeveloperMap[dev] = nil
	end
end

function studio:removeAllTeams()
	for key, teamObj in ipairs(self.teams) do
		teamObj:remove()
	end
end

function studio:removeAllProjects()
	for key, projectObj in ipairs(self.projects) do
		self.projects[key] = nil
		
		projectObj:remove()
	end
	
	for key, engineObj in ipairs(self.engines) do
		self.engines[key] = nil
		
		engineObj:remove()
	end
	
	for key, gameObj in ipairs(self.games) do
		self.games[key] = nil
		
		gameObj:remove()
	end
	
	for key, gameObj in ipairs(self.releasedGames) do
		self.releasedGames[key] = nil
		
		gameObj:remove()
	end
	
	table.clearArray(self.inDevGames)
end

function studio:addOwnedObject(object)
	table.insert(self.ownedObjects, object)
	
	local class = object:getClass()
	
	self.ownedObjectsByClass[class] = (self.ownedObjectsByClass[class] or 0) + 1
	
	local office = object:getOffice()
	
	office:calculateInterestBoost()
end

function studio:getOwnedObjectCountByClass(class)
	return self.ownedObjectsByClass[class] or 0
end

local allByClass = {}

function studio:getAllObjectsByClass(className)
	table.clear(allByClass)
	
	for key, object in ipairs(self.ownedObjects) do
		if object.class == className then
			table.insert(allByClass, object)
		end
	end
	
	return allByClass
end

function studio:getViewableFloors()
	return self.viewableFloors
end

function studio:removeOwnedObject(object)
	if object._removed then
		return 
	end
	
	local floor = object:getFloor()
	
	for key, otherObject in ipairs(self.ownedObjects) do
		if otherObject == object then
			local class = object:getClass()
			
			self.ownedObjectsByClass[class] = self.ownedObjectsByClass[class] and self.ownedObjectsByClass[class] - 1 or 0
			
			local x, y, w, h = object:getUsedTiles()
			
			game.sendGridUpdateToThreads(game.worldObject:getFloorTileGrid(), pathfinderThread.MESSAGE_TYPE.GRID_UPDATE, x, y, w, h, object:getFloor(), nil)
			table.remove(self.ownedObjects, key)
			
			break
		end
	end
	
	local office = object:getOffice()
	
	office:removeObject(object)
	
	if not self._disableReregistration then
		office:reRegisterRooms(floor)
		office:updateMonthlyCosts(object:getFloor())
		self:updateMonthlyCosts()
		office:calculateInterestBoost()
	end
end

function studio:getOwnedObjects()
	return self.ownedObjects
end

function studio:getObjectListPosition(object)
	for key, otherObject in ipairs(self.ownedObjects) do
		if otherObject == object then
			return key
		end
	end
end

function studio:getObjectByIndex(index)
	return self.ownedObjects[index]
end

function studio:attemptThankForObjectPurchase(employee, objectClass)
	if not self.thanksPopupCreatedToday then
		local object = objects.getClassData(objectClass)
		local thankText = interests:prepareInterestThankText(employee, object)
		local popup = gui.create("Popup")
		
		popup:setWidth(400)
		popup:setFont(fonts.get("pix24"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setText(thankText)
		popup:setTitle(_T("INFO_TITLE", "Info"))
		popup:setDepth(105)
		popup:addButton(fonts.get("pix24"), "OK")
		popup:performLayout()
		popup:center()
		frameController:push(popup)
		
		self.thanksPopupCreatedToday = true
		
		return true
	end
	
	return false
end

function studio:createDefaultTeam()
	local newTeam = team.new()
	
	newTeam:setOwner(self)
	newTeam:setName(_T("STUDIO_TEAM", "Studio"))
	newTeam:setCanDismantle(false)
	self:addTeam(newTeam)
	
	self.studioTeam = newTeam
end

function studio:getNewTileCost()
	return studio.TILE_COST
end

function studio:getTileCost(index, floorID)
	local cost = 0
	
	if index and not self.ownedTiles[index] then
		cost = cost + studio.TILE_COST
	end
	
	if floorID then
		cost = cost + floors:getCost(floorID)
	end
	
	return cost
end

function studio:getBoughtTiles()
	return self.ownedTiles
end

function studio:addOwnedTile(index)
	self.ownedTiles[index] = true
end

function studio:hasBoughtTile(index)
	return self.ownedTiles[index]
end

local borderTiles = {}

function studio:getBorderTiles()
	table.clearArray(borderTiles)
	
	local grid = game.worldObject:getFloorTileGrid()
	local defaultWall = studio.DEFAULT_BORDER_WALL_ID
	
	for index, state in pairs(self.ownedTiles) do
		local x, y = grid:convertIndexToCoordinates(index)
		
		for rotation, offset in pairs(walls.DIRECTION) do
			local curX, curY = x + offset[1], y + offset[2]
			local curIndex = grid:getTileIndex(curX, curY)
			
			if grid:outOfBounds(curX, curY) or not self.ownedTiles[curIndex] then
				borderTiles[#borderTiles + 1] = curIndex
			end
		end
	end
	
	return borderTiles
end

function studio:hasWallInDirection(index, floor, rotation, direction)
	local newRotation = direction[rotation]
	local grid = game.worldObject:getFloorTileGrid()
	
	return grid:hasWall(index, floor, newRotation)
end

local visitedTiles = {}
local roomCache = {}
local pendingEntryPoints = {}

studio.latestObjectGridReference = nil
studio.curIterRoomObj = nil
studio.curRoomFloor = nil
studio.curRoomMap = nil

function studio.markTileAsVisited(index, blockedDirections)
	visitedTiles[index] = true
	
	if not studio.curRoomMap[index] then
		studio.curRoomMap[index] = studio.curIterRoomObj
	end
	
	local objects = studio.latestObjectGridReference:getObjectsFromIndex(index, studio.curRoomFloor)
	
	if objects then
		for key, object in ipairs(objects) do
			studio.curIterRoomObj:addObject(object)
		end
	end
	
	for rotation, object in pairs(blockedDirections) do
		if object:getObjectType() == "door" then
			pendingEntryPoints[studio.curIterRoomObj][object] = true
		end
	end
end

function studio.onBlockedByObject(rotationOfBlock, blockObject)
	if blockObject:getObjectType() == "door" then
		pendingEntryPoints[studio.curIterRoomObj][blockObject] = true
	end
end

function studio:getRoomOfIndex(index, floor)
	return self.roomMap[floor][index]
end

function studio:getRoomAtCoordinates(x, y)
	return self.roomMap[game.worldObject:getFloorTileGrid():getTileIndex(x, y)]
end

function studio:updateRooms(updateObjectsOnly, officeObject, floorID)
	self._updatingRooms = true
	self._blockLightBuild = true
	
	local objects = officeObject:getObjectsByFloor(floorID)
	local rooms = officeObject:getRoomsByFloor(floorID)
	
	for key, object in ipairs(objects) do
		object:onRebuildingRooms()
	end
	
	local start = os.clock()
	local grid = game.worldObject:getFloorTileGrid()
	local tileMap, tileList = officeObject:getTileIndexes()
	local roomMap = self.roomMap[floorID]
	
	for key, index in ipairs(tileList) do
		roomMap[index] = nil
	end
	
	self.latestObjectGridReference = game.worldObject:getObjectGrid()
	
	for key, roomObject in ipairs(rooms) do
		roomCache[key] = roomObject
		
		roomObject:reset()
		
		rooms[key] = nil
	end
	
	local expansion = studio.expansion
	
	for key, index in ipairs(tileList) do
		if not visitedTiles[index] then
			local x, y = grid:convertIndexToCoordinates(index)
			local roomObject = roomCache[#roomCache]
			
			if not roomObject then
				roomObject = room.new()
			else
				roomCache[#roomCache] = nil
			end
			
			roomObject:setOffice(officeObject)
			roomObject:setFloor(floorID)
			
			self.curIterRoomObj = roomObject
			self.curRoomFloor = floorID
			self.curRoomMap = roomMap
			pendingEntryPoints[self.curIterRoomObj] = {}
			
			local roomTiles = expansion:updateRoomTiles(x, y, floorID, true, nil, self.markTileAsVisited, self.onBlockedByObject)
			
			rooms[#rooms + 1] = roomObject
			
			roomObject:setTiles(roomTiles)
			roomObject:countWallTypes()
		end
	end
	
	for key, employee in ipairs(officeObject:getEmployees()) do
		local midX, midY = employee:getPos()
		local index = grid:worldToIndex(midX, midY)
		
		employee:checkForRoom(index)
	end
	
	for roomObject, objectList in pairs(pendingEntryPoints) do
		for entryPointObject, state in pairs(objectList) do
			roomObject:addEntryPoint(entryPointObject)
		end
	end
	
	for key, object in ipairs(objects) do
		object:onRebuiltRooms()
	end
	
	for key, roomObject in ipairs(rooms) do
		roomObject:register()
	end
	
	self._blockLightBuild = false
	
	for key, object in ipairs(objects) do
		object:postRegisteredRooms()
	end
	
	self.curIterRoomObj = nil
	self.latestObjectGridReference = nil
	self._updatingRooms = false
	
	officeObject:onRoomsUpdated(floorID)
	table.clearArray(roomCache)
	table.clear(visitedTiles)
	table.clear(pendingEntryPoints)
	events:fire(studio.EVENTS.ROOMS_UPDATED, officeObject)
end

function studio:getRoomMap()
	return self.roomMap
end

studio.foundOtherRooms = {}
studio.foundEmployees = {}

function studio.markTileAsVisitedSingleRoom(index)
	visitedTiles[index] = true
	
	local roomObject = studio.roomMap[index]
	
	if roomObject and roomObject ~= studio.curIterRoomObj then
		studio.foundOtherRooms[roomObject] = true
	end
	
	studio.roomMap[index] = studio.curIterRoomObj
	
	local objects = studio.latestObjectGridReference:getObjectsFromIndex(index, studio.curRoomFloor)
	
	if objects then
		for key, object in ipairs(objects) do
			studio.curIterRoomObj:addObject(object)
		end
	end
end

function studio:getCanUpdateOverallEfficiency()
	return self.canUpdateOverallEfficiency
end

local roomsToRegister = {}

function studio:updateRoom(x, y, checkDirection)
	do return  end
	
	local start = os.clock()
	
	self.latestObjectGridReference = game.worldObject:getObjectGrid()
	
	local buildingObject = self:_updateRoom(x, y)
	
	if checkDirection then
		local direction = walls.DIRECTION[checkDirection]
		
		if self.ownedTiles[self.latestObjectGridReference:getTileIndex(x + direction[1], y + direction[2])] then
			self:_updateRoom(x + direction[1], y + direction[2])
		end
	end
	
	local grid = game.worldObject:getFloorTileGrid()
	
	for key, employee in ipairs(self.foundEmployees) do
		local midX, midY = employee:getCenter()
		local index = grid:worldToIndex(midX, midY)
		
		employee:checkForRoom(index)
		
		self.foundEmployees[key] = nil
	end
	
	self.curIterRoomObj = nil
	self.latestObjectGridReference = nil
	
	table.clearArray(roomCache)
	table.clear(visitedTiles)
	
	for key, roomObject in ipairs(roomsToRegister) do
		roomObject:register()
		
		roomsToRegister[key] = nil
	end
	
	events:fire(studio.EVENTS.ROOM_UPDATED)
end

local prevTiles = {}

function studio:_updateRoom(x, y)
	if x == 0 or y == 0 then
		return 
	end
	
	local index = self.latestObjectGridReference:getTileIndex(x, y)
	local grid = game.worldObject:getFloorTileGrid()
	
	if visitedTiles[index] then
		return 
	end
	
	local currentRoomObject = self.roomMap[index]
	local wasNewRoom = false
	
	if not currentRoomObject then
		currentRoomObject = room.new()
		wasNewRoom = true
	end
	
	local building
	
	if currentRoomObject then
		self.curIterRoomObj = currentRoomObject
		
		self.curIterRoomObj:resetEntryPoints()
		
		pendingEntryPoints[self.curIterRoomObj] = {}
		
		local expansion = studio.expansion
		
		building = self.officeBuildingMap:getTileBuilding(index)
		
		local rooms = building:getRooms()
		local curTiles = currentRoomObject:getTiles()
		
		if curTiles then
			for index, state in pairs(curTiles) do
				prevTiles[index] = true
			end
		end
		
		local iteratedTiles = expansion:updateRoomTiles(x, y, floorID, true, nil, studio.markTileAsVisitedSingleRoom, studio.onBlockedByObject)
		
		currentRoomObject:setTiles(iteratedTiles)
		
		for key, employee in ipairs(currentRoomObject:getEmployees()) do
			table.insert(self.foundEmployees, employee)
		end
		
		for roomObject, state in pairs(self.foundOtherRooms) do
			for key, employee in ipairs(roomObject:getEmployees()) do
				table.insert(self.foundEmployees, employee)
			end
			
			building:removeRoom(roomObject, true)
			roomObject:reset()
		end
		
		if wasNewRoom then
			rooms[#rooms + 1] = currentRoomObject
		end
		
		for tile, state in pairs(prevTiles) do
			if not iteratedTiles[tile] then
				currentRoomObject:removeTile(tile)
				
				self.roomMap[tile] = nil
			end
			
			prevTiles[tile] = nil
		end
		
		currentRoomObject:countWallTypes()
		
		local objects = currentRoomObject:getObjects()
		
		for key, object in ipairs(objects) do
			object:onRebuildingRooms()
		end
		
		for key, object in ipairs(objects) do
			object:onRebuiltRooms()
		end
		
		for roomObject, objectList in pairs(pendingEntryPoints) do
			for entryPointObject, state in pairs(objectList) do
				roomObject:addEntryPoint(entryPointObject)
			end
		end
		
		roomsToRegister[#roomsToRegister + 1] = currentRoomObject
	end
	
	table.clear(self.foundOtherRooms)
	table.clear(pendingEntryPoints)
	
	return building
end

local roomWallTiles = {}

function studio:clearBorderTileWalls(borderTiles, targetDirectionWalls, floor)
	local grid = game.worldObject:getFloorTileGrid()
	
	borderTiles = borderTiles or self:getBorderTiles()
	
	local rooms = {}
	
	for key, index in ipairs(borderTiles) do
		local foundRoom = false
		
		for key, room in ipairs(rooms) do
			if room[index] then
				foundRoom = true
				
				break
			end
		end
		
		if not foundRoom then
			local x, y = grid:convertIndexToCoordinates(index)
			local roomObj = studio.expansion:updateRoomTiles(x, y, floor, true)
			
			table.insert(rooms, roomObj)
		end
	end
	
	local defaultWall = studio.DEFAULT_BORDER_WALL_ID
	
	if #rooms == 1 then
		if targetDirectionWalls then
			local dir = walls.DIRECTION[targetDirectionWalls]
			local dirX, dirY = dir[1], dir[2]
			
			for key, index in ipairs(borderTiles) do
				local x, y = grid:convertIndexToCoordinates(index)
				local curX, curY = x + dirX, y + dirY
				local curIndex = grid:getTileIndex(curX, curY)
				
				if grid:outOfBounds(curX, curY) or not self.ownedTiles[curIndex] then
					grid:removeWall(index, floor, targetDirectionWalls)
				end
			end
		else
			for key, index in ipairs(borderTiles) do
				local x, y = grid:convertIndexToCoordinates(index)
				
				for rotation, offset in pairs(walls.DIRECTION) do
					local curX, curY = x + offset[1], y + offset[2]
					local curIndex = grid:getTileIndex(curX, curY)
					
					if grid:outOfBounds(curX, curY) or not self.ownedTiles[curIndex] then
						grid:removeWall(index, floor, rotation)
					end
				end
			end
		end
	end
	
	table.clear(roomWallTiles)
end

function studio:fillBorderTileWalls()
	for key, office in ipairs(self.ownedBuildings) do
		office:fillBorderWalls()
	end
end

function studio:updateMonthlyCosts()
	if self._loading or game._removing then
		return 
	end
	
	table.clear(self.monthlyCosts)
	
	self.totalMonthlyCost = 0
	
	for key, officeObject in ipairs(self.ownedBuildings) do
		for cost, amount in pairs(officeObject:getMonthlyCosts()) do
			self.monthlyCosts[cost] = (self.monthlyCosts[cost] or 0) + amount
			self.totalMonthlyCost = self.totalMonthlyCost + amount
		end
	end
	
	return self.monthlyCosts
end

function studio:getMonthlyCosts()
	return self.monthlyCosts
end

function studio:getMonthlyCost(id)
	return self.monthlyCosts[id]
end

function studio:getHighestMonthlyCost()
	local id, amount = nil, 0
	
	for costID, costAmount in pairs(self.monthlyCosts) do
		if amount < costAmount then
			amount = costAmount
			id = costID
		end
	end
	
	return id, amount
end

function studio:getMonthlyCostAmount()
	return self.totalMonthlyCost
end

function studio:getMonthlyEmployeeSalaries()
	local total = 0
	
	for key, employee in ipairs(self.hiredDevelopers) do
		total = total + employee:getSalary()
	end
	
	return total
end

function studio:getOverallExpenses()
	return self:getMonthlyCostAmount() + self:getMonthlyEmployeeSalaries()
end

function studio:canAffordWall(id, isFree)
	if isFree then
		return true
	end
	
	local data = walls.registeredByID[id]
	local cost = data.cost
	
	return cost <= self.funds
end

function studio:buyWall(index, floor, rotation, wallID, isFree, costMultiplier)
	local grid = game.worldObject:getFloorTileGrid()
	
	grid:insertWall(index, floor, wallID, rotation)
	
	local data = walls.registeredByID[wallID]
	local cost = isFree and 0 or data.cost * costMultiplier
	
	self:deductFunds(cost, nil, "office_expansion")
end

function studio:canDemolishWall(index, floor, rotation)
	if not self.ownedTiles[index] then
		return false
	end
	
	local grid = game.worldObject:getFloorTileGrid()
	local rotatedID = grid:getWallID(index, floor, rotation)
	
	if not walls:canSell(rotatedID) then
		return false
	end
	
	local direction = walls.DIRECTION[rotation]
	
	return self.ownedTiles[grid:offsetIndex(index, direction[1], direction[2])]
end

function studio:demolishWall(index, floor, rotation)
	local grid = game.worldObject:getFloorTileGrid()
	local rotatedID = grid:getWallID(index, floor, rotation)
	local wallData = walls.registered[rotatedID]
	
	if wallData then
		grid:removeWall(index, floor, rotation)
		studio:addFunds(math.round(wallData.cost * 0.5), nil, "office_expansion")
	end
end

function studio:canAffordTile(tileID, isFree)
	if isFree then
		return true
	end
	
	local data = floors.registeredByID[tileID]
	
	return data and self.funds >= data.cost
end

function studio:canBuyTile(x, y)
	local grid = game.worldObject:getFloorTileGrid()
	
	if grid:outOfBounds(x, y) then
		return false
	end
	
	return true
end

function studio:buyTile(x, y, floor, isFree, floorID, noMonthlyTileCostUpdate, resetWallIDs)
	local cost = 0
	local grid = game.worldObject:getFloorTileGrid()
	local index = grid:getTileIndex(x, y)
	
	if not isFree then
		cost = cost + self:getTileCost(index, floorID)
	end
	
	if cost > 0 then
		self:deductFunds(cost, nil, "office_expansion")
	end
	
	if floorID then
		grid:setTileValue(index, floor, floorID)
	end
	
	self.ownedTiles[index] = true
	
	if not noMonthlyTileCostUpdate then
		self:updateMonthlyCosts()
	end
end

function studio:initStartingOfficeCells()
	local floorID = floors:getData(game.STUDIO_START_TILE).id
	
	for key, officeObject in ipairs(self.ownedBuildings) do
		for i = 1, officeObject:getPurchasedFloors() do
			self:updateRooms(nil, officeObject, i)
			officeObject:updateMonthlyCosts(i)
		end
	end
	
	self:updateMonthlyCosts()
end

function studio:centerCamera()
	local grid = game.worldObject:getFloorTileGrid()
	local totalTiles = 0
	local x, y = 0, 0
	
	for index, state in pairs(self.ownedTiles) do
		totalTiles = totalTiles + 1
		
		local tileX, tileY = grid:convertIndexToCoordinates(index)
		
		x = x + tileX
		y = y + tileY
	end
	
	local camX, camY = x * grid:getTileWidth() / totalTiles, y * grid:getTileHeight() / totalTiles
	
	camera:setPosition(camX - halfScrW - game.WORLD_TILE_WIDTH * 0.5, camY - halfScrH - game.WORLD_TILE_HEIGHT * 0.5, true)
end

function studio:getStudioTeam()
	return self.studioTeam
end

function studio:addEmployee(employee)
	if self.hiredDevelopersByUID[employee:getUniqueID()] then
		error("attempt to insert duplicate employee into employee list " .. employee:getFullName(true))
	end
	
	table.insert(self.hiredDevelopers, employee)
	self:changeKnowledgeLevel(employee, 1)
	self:changeEmployeeRoleCount(employee:getRole(), 1)
	self:updateHighestEmployeeSkills(employee)
	
	self.hiredDevelopersByUID[employee:getUniqueID()] = employee
	
	employee:initEventHandler()
	employee:setHired(true)
end

function studio:rebuildKnowledgeLevel()
	for key, knowledgeData in ipairs(knowledge.registered) do
		self.totalKnowledge[knowledgeData.id] = 0
	end
	
	for key, employee in ipairs(self.hiredDevelopers) do
		for knowledgeID, amount in pairs(employee:getAllKnowledge()) do
			self.totalKnowledge[knowledgeID] = (self.totalKnowledge[knowledgeID] or 0) + amount
		end
	end
end

function studio:changeKnowledgeLevel(employee, direction)
	for knowledgeID, amount in pairs(employee:getAllKnowledge()) do
		self.totalKnowledge[knowledgeID] = math.max(0, (self.totalKnowledge[knowledgeID] or 0) + amount * direction)
	end
end

function studio:getCollectiveKnowledge()
	return self.totalKnowledge
end

function studio:onKnowledgeChanged(id, amount)
	self.totalKnowledge[id] = self.totalKnowledge[id] + amount
end

studio.employeeCountAchievements = {
	{
		10,
		achievements.ENUM.HAVE_10_EMPLOYEES
	},
	{
		20,
		achievements.ENUM.HAVE_20_EMPLOYEES
	},
	{
		50,
		achievements.ENUM.HAVE_50_EMPLOYEES
	},
	{
		100,
		achievements.ENUM.HAVE_100_EMPLOYEES
	}
}

function studio:verifyEmployeeCountAchievements(devCount)
	if not self.employeeAchvID then
		self.employeeAchvID = 1
	end
	
	local count = studio.employeeCountAchievements
	
	if not count[self.employeeAchvID] then
		return 
	end
	
	while true do
		local data = count[self.employeeAchvID]
		
		if not data then
			return 
		end
		
		if devCount >= data[1] then
			achievements:attemptSetAchievement(data[2])
			
			self.employeeAchvID = self.employeeAchvID + 1
		else
			break
		end
	end
end

function studio:hireEmployee(employee, targetTeam, skipAutoAssign)
	self:addEmployee(employee)
	
	local employeeCount = #self.hiredDevelopers
	
	employee:setEmployer(self)
	employee:setLastPaycheck(timeline.curTime)
	employee:markSkillsAtHireTime()
	employee:markPreRaiseRequestSkills()
	employee:setHireTime(timeline.curTime)
	employee:onHired()
	
	targetTeam = targetTeam or self.studioTeam
	
	targetTeam:addMember(employee)
	self.stats:setStat("most_employees_at_once", math.max(employeeCount, self.stats:getStat("most_employees_at_once")))
	
	if not skipAutoAssign then
		employeeAssignment:attemptAutoAssign(employee)
	end
	
	if office then
		studio:updateMonthlyCosts()
	end
	
	self:verifyEmployeeCountAchievements(employeeCount)
	events:fire(studio.EVENTS.EMPLOYEE_HIRED, employee)
	events:fire(studio.EVENTS.EMPLOYEE_COUNT_CHANGED, self)
end

function studio:assignToRandomTeam(employee)
	local randIndex = math.random(1, #self.teams)
	local randomTeam = self.teams[randIndex]
	
	randomTeam:addMember(employee)
end

function studio:assignEmployeeToTeam(employee, teamObj)
	teamObj:addMember(employee)
end

function studio:removeEmployeeFromTeam(employee, teamObj)
	teamObj = teamObj or employee:getTeam()
	
	if teamObj then
		teamObj:removeMember(employee)
		
		return true
	else
		return nil
	end
	
	for key, teamObj in ipairs(self.teams) do
		if teamObj:hasMember(employee) then
			teamObj:removeMember(employee)
			
			return true
		end
	end
	
	return false
end

function studio:getEmployees()
	return self.hiredDevelopers
end

studio.getHiredDevelopers = studio.getEmployees

local validEmployeesByCriteria = {}

local function returnTrueFallback()
	return true
end

function studio:getRandomEmployeeByCriteria(criteriaCheckFunc)
	criteriaCheckFunc = criteriaCheckFunc or returnTrueFallback
	
	for key, employee in ipairs(self.hiredDevelopers) do
		if criteriaCheckFunc(employee) then
			validEmployeesByCriteria[#validEmployeesByCriteria + 1] = employee
		end
	end
	
	local validEmployee = validEmployeesByCriteria[math.random(1, #validEmployeesByCriteria)]
	
	table.clear(validEmployeesByCriteria)
	
	return validEmployee
end

function studio:getRandomNonPlayerEmployee()
	if #self.hiredDevelopers == 1 and self.hiredDevelopers[1]:isPlayerCharacter() then
		return nil
	end
	
	if not self.playerCharacter then
		return self.hiredDevelopers[math.random(1, #self.hiredDevelopers)]
	end
	
	local success, employeePosition = table.removeObject(self.hiredDevelopers, self.playerCharacter)
	local randomEmployee = self.hiredDevelopers[math.random(1, #self.hiredDevelopers)]
	
	table.insert(self.hiredDevelopers, employeePosition, self.playerCharacter)
	
	return randomEmployee
end

function studio.returnTrue(employeeObj)
	return true
end

function studio:getMostExperiencedInSkill(employeeList, skillID, filter)
	employeeList = employeeList or self.hiredDevelopers
	filter = filter or studio.returnTrue
	
	local highest = -math.huge
	local mostFitting
	
	for key, employee in ipairs(employeeList) do
		local skillLevel = employee:getSkill(skillID).level
		
		if filter(employee) and highest < skillLevel then
			highest = skillLevel
			mostFitting = employee
		end
	end
	
	return mostFitting, highest
end

local workplaceEmployees = {}

function studio:getEmployeesWithWorkplaces(employeeList)
	table.clearArray(workplaceEmployees)
	
	for key, dev in ipairs(employeeList or self.hiredDevelopers) do
		if dev:getWorkplace() then
			table.insert(workplaceEmployees, dev)
		end
	end
	
	return workplaceEmployees
end

function studio:getManagers()
	table.clearArray(self.hiredManagers)
	
	if self.employeeCountByRole.manager > 0 then
		for key, employee in ipairs(self.hiredDevelopers) do
			if employee:getRole() == "manager" then
				self.hiredManagers[#self.hiredManagers + 1] = employee
			end
		end
	end
	
	return self.hiredManagers
end

function studio:clearManagers()
	table.clearArray(self.hiredManagers)
end

function studio:getEmployeesByUID()
	return self.hiredDevelopersByUID
end

function studio:getWillingActivityParticipants(activity)
	table.clearArray(self.willingParticipants)
	table.clearArray(self.nonParticipants)
	
	for key, employee in ipairs(self.hiredDevelopers) do
		if activities:willEmployeeGo(activity, employee) then
			table.inserti(self.willingParticipants, employee)
		else
			table.inserti(self.nonParticipants, employee)
		end
	end
	
	return self.willingParticipants, self.nonParticipants
end

function studio:setLastActivityTime(time)
	self.lastActivityTime = time
end

function studio:getLastActivityTime()
	return self.lastActivityTime
end

function studio:markActivityTime(activity, time)
	self.lastActivities[activity] = time
	self.lastActivityTime = time
end

function studio:findLastActivityTime()
	self.lastActivityTime = 0
	
	for actID, time in pairs(self.lastActivities) do
		self.lastActivityTime = math.max(self.lastActivityTime, time)
	end
end

function studio:getActivityTime(activity)
	return self.lastActivities[activity]
end

function studio:discoverActivityAffector(activity, interestID)
	self.knownActivityAffectors[activity] = self.knownActivityAffectors[activity] or {}
	
	local justDiscovered = self.knownActivityAffectors[activity][interestID] == nil
	
	self.knownActivityAffectors[activity][interestID] = true
	
	return justDiscovered
end

function studio:hasDiscoveredActivityAffector(activity, interestID)
	if self.knownActivityAffectors[activity] and self.knownActivityAffectors[activity][interestID] then
		return true
	end
	
	return false
end

function studio:canStartNewActivity()
	return self.scheduledActivity.id == nil
end

function studio:canScheduleActivity()
	if not self.scheduleActivity.fundType then
		return false, studio.SCHEDULE_FAILURE_REASON.NO_FUND_TYPE
	end
	
	return true
end

function studio:setScheduleFunding(fundType)
	self.scheduleActivity.fundType = fundType
end

function studio:isActivityOnTheHouse()
	return self.scheduledActivity.onTheHouse
end

function studio:onStartNewGame()
	self.financeHistory:onStartNewGame()
	activities:onStartNewGame()
end

studio.MAX_GAME_AWARD_TRACK_RECORD = 20

function studio:increaseGameAwardParticipation()
	self.gameAwardParticipations = self.gameAwardParticipations + 1
end

function studio:addGameAwardData(data, year, presentedGame, repChange, penalties)
	repChange = repChange or 0
	penalties = penalties or 0
	
	table.insert(self.gameAwardWins, {
		year = year,
		repChange = repChange,
		game = presentedGame,
		data = data,
		penalties = penalties
	})
	
	if #self.gameAwardWins > studio.MAX_GAME_AWARD_TRACK_RECORD then
		table.remove(self.gameAwardWins, 1)
	end
	
	self.totalGameAwards = self.totalGameAwards + 1
end

function studio:getTotalGameAwards()
	return self.totalGameAwards
end

function studio:getGameAwardWins()
	return self.gameAwardWins
end

function studio:scheduleActivity(activity, date, autoOrganized)
	self:resetScheduledActivity()
	
	date = date or math.floor(timeline.curTime) + 1
	
	local schedAct = self.scheduledActivity
	
	schedAct.id = activity
	schedAct.date = date
	schedAct.onTheHouse = schedAct.fundType == studio.ACTIVITY_FUND_TYPE.ON_THE_HOUSE
	schedAct.autoOrganized = autoOrganized
	
	for key, employee in ipairs(self.willingParticipants) do
		self:addActivityParticipant(employee)
		
		self.willingParticipants[key] = nil
	end
	
	self:deductFunds(activities:getData(activity):getPrice(#self.scheduledActivity.participants), nil, "activities")
end

function studio:addActivityParticipant(employee)
	table.insert(self.scheduledActivity.participants, employee:getUniqueID())
end

function studio:resetScheduledActivity()
	local schedAct = self.scheduledActivity
	
	table.clear(schedAct.participants)
	
	schedAct.id = nil
	schedAct.date = nil
	schedAct.autoOrganized = nil
end

function studio:getActivitySchedule()
	return self.scheduledActivity
end

function studio:removeEmployee(employeeObj)
	for key, value in ipairs(self.hiredDevelopers) do
		if value == employeeObj then
			table.remove(self.hiredDevelopers, key)
			
			break
		end
	end
	
	self.previousDevs[employeeObj] = nil
	self.renderDeveloperMap[employeeObj] = nil
	
	table.removeObject(self.visibleDevelopers, employeeObj)
	table.removeObject(self.renderDevelopers, employeeObj)
	self:removeActiveDeveloper(employeeObj)
	self:changeEmployeeRoleCount(employeeObj:getRole(), -1)
	self:recountHighestSkills()
	self:changeKnowledgeLevel(employeeObj, -1)
end

studio.BUFFER_EMPLOYEE_EXCLUSION_REASONS = {
	[studio.EMPLOYEE_LEAVE_REASONS.DIED] = true,
	[studio.EMPLOYEE_LEAVE_REASONS.RETIRED] = true,
	[studio.EMPLOYEE_LEAVE_REASONS.RIVAL_GAME_STUDIO] = true
}
studio.ACHIEVEMENT_RESET_EXCLUSION_REASONS = {
	[studio.EMPLOYEE_LEAVE_REASONS.DIED] = true,
	[studio.EMPLOYEE_LEAVE_REASONS.RETIRED] = true
}

function studio:fireEmployee(employee, leaveReason)
	leaveReason = leaveReason or studio.EMPLOYEE_LEAVE_REASONS.FIRED
	
	self:removeEmployee(employee)
	
	if not studio.BUFFER_EMPLOYEE_EXCLUSION_REASONS[leaveReason] then
		employeeCirculation:bufferEmployee(employee)
	end
	
	if not studio.ACHIEVEMENT_RESET_EXCLUSION_REASONS[leaveReason] then
		achievements:setProgress(achievements.ENUM.NO_EMPLOYEES_LEAVE_5_YEARS, 0)
	end
	
	local officeObject = employee:getOffice()
	local workplace = employee:getWorkplace()
	
	self.hiredDevelopersByUID[employee:getUniqueID()] = nil
	
	self:removeEmployeeFromTeam(employee)
	employee:removeEventHandler()
	employee:postLeaveStudio()
	
	if officeObject then
		officeObject:updateMonthlyCosts(workplace:getFloor())
	end
	
	self:updateMonthlyCosts()
	employee:removeConversation()
	
	if table.removeObject(self.scheduledActivity.participants, employee:getUniqueID()) then
		studio:addFunds(activities:getData(self.scheduledActivity.id).costPerEmployee, nil, "activities")
	end
	
	events:fire(studio.EVENTS.EMPLOYEE_FIRED, employee, leaveReason)
	events:fire(studio.EVENTS.EMPLOYEE_COUNT_CHANGED)
	employee:setBookedExpo(nil)
	employee:setOffice(nil)
end

function studio:addEngine(newEngine)
	for key, existEngine in ipairs(self.engines) do
		if existEngine == newEngine then
			return false
		end
	end
	
	newEngine:assignUniqueID()
	newEngine:setFact(engineLicensing.GENERATED_ENGINE_FACT, nil)
	self:addProject(newEngine)
	events:fire(studio.EVENTS.NEW_ENGINE, newEngine)
	table.insert(self.engines, newEngine)
	
	return true
end

function studio:removeEngine(removeEngine)
	for key, existEngine in ipairs(self.engines) do
		if existEngine == removeEngine then
			table.remove(self.engines, key)
			
			return true
		end
	end
	
	return false
end

function studio:removeObjectFromRoom(object)
	local index = game.worldObject:getFloorTileGrid():worldToIndex(object:getPos())
	local room = self.roomMap[index]
	
	if room then
		room:removeObject(object)
	end
end

function studio:getEngines()
	return self.engines
end

function studio:getEngine(engineID)
	for key, engineObj in ipairs(self.engines) do
		if engineObj:getName() == engineID then
			return engineObj
		end
	end
	
	return nil
end

function studio:getEngineByUniqueID(uniqueID)
	for key, engineObj in ipairs(self.engines) do
		if engineObj:getUniqueID() == uniqueID then
			return engineObj
		end
	end
	
	for key, engineObj in ipairs(self.boughtEngineLicenses) do
		if engineObj:getUniqueID() == uniqueID then
			return engineObj
		end
	end
	
	return nil
end

function studio:addGame(projectObj)
	if projectObj:getFact(gameProject.ADDED_TO_GAME_LIST_FACT) or table.find(self.games, projectObj) then
		return 
	end
	
	self:addProject(projectObj)
	
	if projectObj.PROJECT_TYPE == gameProject.PROJECT_TYPE and projectObj:getContractData() then
		self:addContractorGame(projectObj)
	end
	
	projectObj:assignUniqueID()
	projectObj:setFact(gameProject.ADDED_TO_GAME_LIST_FACT, true)
	table.insert(self.games, projectObj)
	table.insert(self.inDevGames, projectObj)
	
	self.gamesByUniqueID[projectObj:getUniqueID()] = projectObj
end

function studio:onGameOffMarket(gameObj)
end

function studio:addContractorGame(gameObj)
	self.contractorGames[#self.contractorGames + 1] = gameObj:getUniqueID()
end

function studio:removeContractorGame(gameObj)
	local uid = gameObj:getUniqueID()
	
	for key, otherUID in ipairs(self.contractorGames) do
		if uid == otherUID then
			table.remove(self.contractorGames, key)
			
			break
		end
	end
end

function studio:getGameByUniqueID(id)
	return self.gamesByUniqueID[id]
end

function studio:getGamesByUniqueID()
	return self.gamesByUniqueID
end

function studio:removeGame(obj)
	for key, otherObj in ipairs(self.games) do
		if obj == otherObj then
			table.remove(self.games, key)
			
			self.gamesByUniqueID[obj:getUniqueID()] = nil
			
			break
		end
	end
	
	if not obj:getReleaseDate() then
		table.removeObject(self.inDevGames, obj)
	end
end

function studio:releaseGame(gameProj)
	if gameProj:getTeam() then
		gameProj:getTeam():clearProject()
	end
	
	gameProj:onReleaseGame()
	table.insert(self.releasedGames, gameProj)
	table.removeObject(self.inDevGames, gameProj)
	events:fire(studio.EVENTS.RELEASED_GAME, gameProj)
	self.stats:changeStat("games_released", 1)
	gameProj:addToPlatforms(true, true)
	self:updateHighestQualityScore(gameProj)
	self:storeGameByGenre(gameProj)
	self:storeGameByTheme(gameProj)
end

function studio:attemptAddBadGame(gameObj)
	local realRating = review:getGameVerdict(gameObj, true)
	
	if realRating <= studio.BAD_GAME_SCORE_THRESHOLD then
		self.badGameScores[#self.badGameScores + 1] = realRating
		self.lastBadGameDate = timeline.curTime
	else
		table.clear(self.badGameScores)
	end
end

function studio:storeGameByGenre(gameProj)
	local genre = gameProj:getGenre()
	
	self.gamesByGenre[genre] = self.gamesByGenre[genre] or {}
	
	table.insert(self.gamesByGenre[genre], gameProj:getUniqueID())
	
	self.previousGamesByGenre[genre] = gameProj:getUniqueID()
end

function studio:getGamesByGenre(genreID)
	return self.gamesByGenre[genreID]
end

function studio:storeGameByTheme(gameProj)
	local theme = gameProj:getTheme()
	
	self.gamesByTheme[theme] = self.gamesByTheme[theme] or {}
	
	table.insert(self.gamesByTheme[theme], gameProj:getUniqueID())
	
	self.previousGamesByTheme[theme] = gameProj:getUniqueID()
end

function studio:getGamesByTheme(themeID)
	return self.gamesByTheme[themeID]
end

function studio:getAverageRatingOfGames(gameAmount, fromEnd, ageRestriction)
	local total = 0
	
	gameAmount = gameAmount or #self.releasedGames
	ageRestriction = ageRestriction or math.huge
	
	if fromEnd then
		local startIter, endIter = #self.releasedGames, math.max(#self.releasedGames - gameAmount, 1)
		local evalGames = 0
		
		for i = startIter, endIter, -1 do
			local gameObj = self.releasedGames[i]
			
			if ageRestriction > gameObj:getDaysSinceRelease() then
				total = total + gameObj:getReviewRating()
				evalGames = evalGames + 1
			else
				break
			end
		end
		
		if evalGames > 0 then
			total = total / evalGames
		end
	else
		local startIter, endIter = 1, math.min(gameAmount, #self.releasedGames)
		local evalGames = 0
		
		for i = startIter, endIter do
			local gameObj = self.releasedGames[i]
			
			if ageRestriction > gameObj:getDaysSinceRelease() then
				total = total + gameObj:getReviewRating()
				evalGames = evalGames + 1
			end
		end
		
		if evalGames > 0 then
			total = total / evalGames
		end
	end
	
	return math.max(total, 0)
end

function studio:getLastGameOfGenre(genre)
	return self:getProjectByUniqueID(self.previousGamesByGenre[genre])
end

function studio:getLastGameOfTheme(theme)
	return self:getProjectByUniqueID(self.previousGamesByTheme[theme])
end

function studio:getGameCountByGenre(genre)
	return self.gamesByGenre[genre] and #self.gamesByGenre[genre] or 0
end

function studio:getGameCountByGenre(theme)
	return self.gamesByGenre[theme] and #self.gamesByGenre[theme] or 0
end

function studio:getGames()
	return self.games
end

function studio:getInDevGames()
	return self.inDevGames
end

function studio:removeInDevGame(gameObj)
	table.removeObject(self.inDevGames, gameObj)
end

function studio:getPatchByUniqueID(uid)
	for key, obj in ipairs(self.games) do
		local patch = obj:getCurrentPatch()
		
		if patch and patch:getUniqueID() == uid then
			return patch
		end
	end
end

function studio:getReleasedGames()
	return self.releasedGames
end

function studio:licenseEngine(desiredEngine)
	local engineUID = desiredEngine:getUniqueID()
	
	self.licensedEngines[engineUID] = (self.licensedEngines[engineUID] or 0) + 1
end

function studio:getAverageGameScore()
	local total = 0
	
	for key, gameProj in ipairs(self.releasedGames) do
		local averageScore = gameProj:getReviewRating()
		
		if averageScore > 0 then
			total = total + averageScore
		end
	end
	
	return math.max(total / #self.releasedGames, 0)
end

function studio:isGoingBankrupt()
	return self.funds < 0
end

function studio:addTeam(teamObj, wasCreation)
	table.insert(self.teams, teamObj)
	teamObj:setOwner(self)
	
	if teamObj:canDismantle() then
		events:fire(studio.EVENTS.TEAM_ADDED, teamObj)
	end
	
	if not teamObj:getUniqueID() then
		teamObj:assignUniqueID()
	end
	
	if wasCreation then
		events:fire(studio.EVENTS.TEAM_CREATED, teamObj)
	end
end

function studio:getTeams()
	return self.teams
end

function studio:getTeamByName(name)
	for key, teamObj in ipairs(self.teams) do
		if teamObj:getName() == name then
			return teamObj
		end
	end
	
	return nil
end

function studio:getTeamByUniqueID(uid)
	for key, teamObj in ipairs(self.teams) do
		if teamObj:getUniqueID() == uid then
			return teamObj
		end
	end
	
	return nil
end

function studio:dismantleTeam(teamObj)
	for key, otherTeam in ipairs(self.teams) do
		if otherTeam == teamObj then
			table.remove(self.teams, key)
			
			break
		end
	end
	
	teamObj:dismantle()
	events:fire(studio.EVENTS.TEAM_DISMANTLED, teamObj)
end

function studio:changeFinanceHistory(id, amount)
	self.financeHistory:changeValue(nil, id, amount)
end

function studio:deductFunds(amount, quiet, financeType, skipSound)
	self.funds = self.funds - amount
	self.fundChange = self.fundChange - amount
	
	if amount >= 0 then
		self.stats:changeStat("money_spent", amount)
		self.stats:setStat("worst_financial_situation", math.min(self.funds, self.stats:getStat("worst_financial_situation")))
	else
		self.stats:changeStat("money_earned", -amount)
		self.stats:setStat("best_financial_situation", math.max(self.funds, self.stats:getStat("best_financial_situation")))
	end
	
	if financeType then
		self.financeHistory:changeValue(nil, financeType, -amount)
	end
	
	events:fire(studio.EVENTS.FUNDS_CHANGED, -amount, self.funds, quiet)
end

studio.removeFunds = studio.deductFunds
studio.fundAchievements = {
	{
		1000000,
		achievements.ENUM.ONE_MILLION
	},
	{
		100000000,
		achievements.ENUM.HUNDRED_MILLION
	},
	{
		1000000000,
		achievements.ENUM.ONE_BILLION
	},
	{
		1000000000000,
		achievements.ENUM.ONE_TRILLION
	}
}

function studio:verifyFundAchievements()
	if not self.fundAchvID then
		self.fundAchvID = 1
	end
	
	local count = studio.fundAchievements
	
	if not count[self.fundAchvID] then
		return 
	end
	
	local funds = self.funds
	
	while true do
		local data = count[self.fundAchvID]
		
		if not data then
			return 
		end
		
		if funds >= data[1] then
			achievements:attemptSetAchievement(data[2])
			
			self.fundAchvID = self.fundAchvID + 1
		else
			break
		end
	end
end

function studio:addFunds(amount, quiet, financeType, skipSound)
	self.funds = self.funds + amount
	self.fundChange = self.fundChange + amount
	
	if amount < 0 then
		self.stats:changeStat("money_spent", -amount)
		self.stats:setStat("worst_financial_situation", math.min(self.funds, self.stats:getStat("worst_financial_situation")))
	else
		self.stats:changeStat("money_earned", amount)
		self.stats:setStat("best_financial_situation", math.max(self.funds, self.stats:getStat("best_financial_situation")))
	end
	
	if financeType then
		self.financeHistory:changeValue(nil, financeType, amount)
	end
	
	self:verifyFundAchievements()
	events:fire(studio.EVENTS.FUNDS_CHANGED, amount, self.funds, quiet)
end

function studio:getFundChange()
	return self.fundChange
end

studio.increaseFunds = studio.addFunds

function studio:setFunds(amount)
	self.funds = amount
	
	events:fire(studio.EVENTS.FUNDS_SET, self.funds)
end

function studio:getFunds()
	return self.funds
end

function studio:getFundsText()
	return string.roundtobigcashnumber(self.funds)
end

function studio:hasFunds(amount)
	return amount <= self.funds
end

function studio:setReputation(rep)
	self.reputation = math.max(rep, 0)
	
	events:fire(studio.EVENTS.REPUTATION_SET, self.reputation, self)
end

function studio:increaseReputation(amount)
	self.reputation = math.max(self.reputation + amount, 0)
	
	events:fire(studio.EVENTS.REPUTATION_CHANGED, amount, self)
end

function studio:decreaseReputation(amount)
	self.reputation = math.max(self.reputation - amount, 0)
	
	events:fire(studio.EVENTS.REPUTATION_CHANGED, amount, self)
end

function studio:getReputation()
	return self.reputation
end

function studio:getReputationSaleMultiplier()
	return math.max(1 + math.min(self.reputation / studio.REPUTATION_TO_SALE_MULTIPLIER_DIVIDER, studio.MAX_REPUTATION_TO_SALE_MULTIPLIER), 1)
end

function studio:revealBribe(gameProj)
	self:setFact(studio.REVEALED_BRIBES, (self:getFact(studio.REVEALED_BRIBES) or 0) + 1)
	self:setFact(studio.LAST_BRIBE_TIME, timeline.curTime)
	gameProj:setFact(gameProject.REVEALED_BRIBE_COUNT_FACT, (gameProj:getFact(gameProject.REVEALED_BRIBE_COUNT) or 0) + 1)
end

studio.reachedReleaseStateProject = nil

function studio.onReachedReleaseStateHint(dialogueObject)
	dialogueObject:setFact("projectInQuestion", studio.reachedReleaseStateProject)
end

function studio.financeReportCallback()
	game.createFinancesPopup()
end

eventBoxText:registerNew({
	id = "monthly_expenses",
	getText = function(self, data)
		if data.employeeCosts > 0 and data.monthlyCosts > 0 then
			local employeeText = data.employeeCount > 1 and _T("EMPLOYEES_LOWERCASE", "employees") or _T("EMPLOYEE_LOWERCASE", "employee")
			
			return _format(_T("MONTHLY_EXPENSES_EMPLOYEES_AND_OFFICE", "New month, paid $TOTAL_SALARIES to EMPLOYEE_COUNT EMPLOYEES and $MONTHLY_COST for various office expenses."), "TOTAL_SALARIES", string.roundtobignumber(data.employeeCosts), "EMPLOYEE_COUNT", data.employeeCount, "EMPLOYEES", employeeText, "MONTHLY_COST", string.roundtobignumber(data.monthlyCosts))
		elseif data.employeeCosts > 0 then
			local employeeText = data.employeeCount > 1 and _T("EMPLOYEES_LOWERCASE", "employees") or _T("EMPLOYEE_LOWERCASE", "employee")
			
			return _format(_T("MONTHLY_EXPENSES_EMPLOYEES", "New month, paid $TOTAL_SALARIES to EMPLOYEE_COUNT EMPLOYEES."), "TOTAL_SALARIES", string.roundtobignumber(data.employeeCosts), "EMPLOYEE_COUNT", data.employeeCount, "EMPLOYEES", employeeText)
		elseif data.monthlyCosts > 0 then
			return _format(_T("MONTHLY_EXPENSES_OFFICE", "New month, paid $MONTHLY_COST for various office expenses."), "MONTHLY_COST", string.roundtobignumber(data.monthlyCosts))
		end
	end,
	fillInteractionComboBox = function(self, comboBox, uiElement)
		comboBox:addOption(0, 0, 0, 20, _T("FINANCES_REPORT", "Finance report"), fonts.get("pix20"), studio.financeReportCallback)
	end
})
eventBoxText:registerNew({
	id = "loan_interest",
	getText = function(self, data)
		return _format(_T("LOAN_INTEREST_PAID", "Loan interest of $INTEREST paid."), "INTEREST", string.roundtobignumber(data))
	end
})

function studio:onBoughtOutCompany(companyObj)
	table.insert(self.boughtOutCompanies, companyObj:getID())
end

function studio:hasBoughtOutCompany(id)
	return table.find(self.boughtOutCompanies, id)
end

function studio:addTask(taskObj)
	table.insert(self.tasks, taskObj)
end

function studio:removeTask(taskObj)
	table.removeObject(self.tasks, taskObj)
end

studio.MIN_EMPLOYEES_FOR_ACHIEVEMENT = 20

function studio:handleEvent(event, data, data2, data3)
	if event == timeline.EVENTS.NEW_DAY then
		self.thanksPopupCreatedToday = false
		self.slanderSuspicion = math.max(0, self.slanderSuspicion - rivalGameCompanies.SUSPICION_DROP_PER_DAY)
		
		if self.scheduledActivity.id and timeline.curTime > self.scheduledActivity.date then
			activities:visit(self.scheduledActivity.id, self.scheduledActivity.participants, self.scheduledActivity.autoOrganized)
			self:resetScheduledActivity()
		end
	elseif event == timeline.EVENTS.NEW_WEEK then
		if #self.badGameScores <= studio.BAD_GAME_COUNT_BEFORE_REP_LOSS and self.lastBadGameDate and timeline.curTime < self.lastBadGameDate + studio.BAD_GAME_REP_LOSS_DURATION and self.reputation >= MIN_REP_TO_LOSE_REP_TO_BAD_GAMES then
			local avg = table.average(self.badGameScores)
			local dist = studio.BAD_GAME_SCORE_THRESHOLD - avg
			
			studio:decreaseReputation(studio.BAD_GAME_REP_LOSS_PER_SCORE * dist * (1 + self.reputation * studio.BAD_GAME_REP_LOSS_FROM_REPUTATION))
			
			local badGameCountDifference = #self.badGameScores - studio.BAD_GAME_REP_LOSS_PER_GAME
			
			if badGameCountDifference > 0 then
				studio:decreaseReputation(self.reputation * studio.BAD_GAME_REP_LOSS_PER_GAME * badGameCountDifference * studio.REP_LOSS_PER_WEEK)
			end
		end
	elseif event == timeline.EVENTS.NEW_MONTH then
		if self.firstPaymentDone then
			self.fundChange = 0
			self.frustrationLeavings = 0
			
			if #self.hiredDevelopers > 0 then
				self:deductFunds(self.totalMonthlyCost)
			end
			
			for key, data in ipairs(monthlyCost.text) do
				local value = self.monthlyCosts[data.id]
				
				if value then
					self.financeHistory:changeValue(nil, data.financeHistoryID, -value)
				end
			end
			
			local employeeCosts = 0
			local startedLeaveConversation = false
			
			for key, employee in ipairs(self.hiredDevelopers) do
				local paidMoney = employee:receivePaycheck()
				
				employeeCosts = employeeCosts + paidMoney
				
				local team = employee:getTeam()
				
				if team then
					team:onPaycheck(paidMoney)
				end
				
				if self.funds < 0 and not employee:isPlayerCharacter() and not startedLeaveConversation and math.random(1, 100) <= developer.CHANCE_TO_LEAVE_WHEN_NO_PAYCHECK then
					dialogueHandler:addDialogue("employee_leaves_work_late_salaries", nil, employee)
					
					startedLeaveConversation = true
				end
			end
			
			self.financeHistory:changeValue(nil, "paychecks", -employeeCosts)
			
			for key, teamObj in ipairs(self.teams) do
				teamObj:postPaycheck()
			end
			
			local displayEmployeeCount = #self.hiredDevelopers
			
			if self.playerCharacter then
				displayEmployeeCount = displayEmployeeCount - 1
			end
			
			if employeeCosts > 0 or self.totalMonthlyCost > 0 then
				game.addToEventBox("monthly_expenses", {
					employeeCosts = employeeCosts,
					monthlyCosts = self.totalMonthlyCost,
					employeeCount = displayEmployeeCount
				}, 1, nil, "wad_of_cash")
			end
			
			if self.soldEngineObj then
				engineLicensing:attemptSellPlayerEngine(self.soldEngineObj, self.soldEngineObj:getCost())
			end
			
			if self.loan > 0 then
				local loanInterest = monthlyCost.getInterestForLoan(self.loan)
				
				self:deductFunds(loanInterest, nil, "loans")
				game.addToEventBox("loan_interest", loanInterest, 2, nil, "wad_of_cash_minus")
			end
			
			local sleeping = serverRenting:isSleeping()
			
			if sleeping then
				if self.rentedServers > 0 then
					local change = self.rentedServers - self.ignoreRentedServers
					
					if change > 0 then
						self:deductFunds(change * serverRenting:getMonthlyRentFee(), nil, "server_expenses")
					end
					
					self.ignoreRentedServers = 0
				end
				
				local sup = self.customerSupport
				
				if sup > 0 then
					local change = sup - self.ignoreCustomerSupport
					
					if change > 0 then
						self:deductFunds(change * serverRenting:getMonthlyCustomerSupportFee(), nil, "server_expenses")
					end
					
					self.ignoreCustomerSupport = 0
				end
			end
			
			if self.funds < 0 and not self.facts[studio.FIRST_TIME_NEGATIVE_FACT] then
				self:createLoanNotificationPopup()
				
				self.facts[studio.FIRST_TIME_NEGATIVE_FACT] = true
			end
			
			self:handleBankruptcy()
		end
		
		if #self.hiredDevelopers >= studio.MIN_EMPLOYEES_FOR_ACHIEVEMENT then
			achievements:changeProgress(achievements.ENUM.NO_EMPLOYEES_LEAVE_5_YEARS, 1, achievements.STATS.PASSED_MONTHS)
		end
		
		self.firstPaymentDone = true
		
		self.financeHistory:beginNewMonth()
	elseif event == project.EVENTS.SCRAPPED_PROJECT then
		self:removeProject(data)
	elseif event == pathCaching.EVENTS.PATHS_INVALIDATED then
		self:abortPathfinding()
	elseif event == gameProject.EVENTS.REACHED_RELEASE_STATE then
		if data:isPlayerOwned() and not self:getFact("showed_release_state_hint") and interactionRestrictor:canPerformAction("generic_game_interaction") then
			local employees = self:getNonPlayerCharacterEmployees()
			
			if #employees > 0 then
				studio.reachedReleaseStateProject = data
				
				local randomEmployee = employees[math.random(1, #employees)]
				
				dialogueHandler:addDialogue("project_reached_release_state", nil, randomEmployee, studio.onReachedReleaseStateHint)
				
				studio.reachedReleaseStateProject = nil
			else
				local popup = game.createPopup(600, _T("HINT_RELEASE_STATE_REACHED_TITLE", "Project can now be Released"), string.easyformatbykeys(_T("HINT_RELEASE_STATE_REACHED_DESCRIPTION", "Your 'PROJECT' game project can now be released. It is currently in it's last (polishing) stage which is optional, but can provide extra quality points if given the time to finish it."), "PROJECT", data:getName()), fonts.get("pix24"), fonts.get("pix20"))
				
				popup:center()
				frameController:push(popup)
			end
			
			self:setFact("showed_release_state_hint", true)
		end
	elseif event == developer.EVENTS.SKILL_INCREASED and data:getEmployer() == self then
		self:updateHighestSkill(data2, data3)
	end
end

function studio:createLoanNotificationPopup()
	local popup = game.createPopup(600, _T("LOANS_TITLE", "Loans"), _T("LOANS_HINT_DESCRIPTION", "Owing people money will not allow your studio to stay in business for long.\n\nIf you're ever in a bad financial situation, you can always take a loan out in the Expenses & finances menu."), "pix24", "pix20", false)
	
	popup:hideCloseButton()
	frameController:push(popup)
end

function studio:startSellingEngine(engineObj)
	self.soldEngineObj = engineObj
	
	events:fire(studio.EVENTS.STARTED_SELLING_ENGINE, engineObj)
end

function studio:getSoldEngine()
	return self.soldEngineObj
end

function studio:getValidRoomTypeCount(roomID)
	return self.validRoomTypes[roomID] or 0
end

function studio:getValidRoomTypes()
	return self.validRoomTypes
end

function studio:isLoading()
	return self._loading
end

function studio:changeValidRoomTypeCount(roomID, change)
	self.validRoomTypes[roomID] = (self.validRoomTypes[roomID] or 0) + change
end

function studio:reRegisterRooms()
	for key, roomObject in ipairs(self.rooms) do
		roomObject:register()
	end
end

function studio:wasAlreadyInRoom(object)
	return self.sameRoomObjects[object]
end

function studio:markSameRoomObject(object)
	self.sameRoomObjects[object] = true
end

function studio:getDriveRegenMultiplier()
	return self.driveMultiplier
end

function studio:addValidRoomType(object)
	local roomType = object:getRoomType()
	
	if not self.sameRoomObjects[object] then
		self.validRoomTypes[roomType] = self.validRoomTypes[roomType] and self.validRoomTypes[roomType] + 1 or 1
		
		object:setContributesToRoom(true)
	end
	
	self:markSameRoomObject(object)
	object:setIsPartOfValidRoom(true)
end

function studio:isFeatureResearched(featureID)
	return self.researchedFeatures[featureID] == true
end

function studio:addFeature(featureID)
	self.researchedFeatures[featureID] = true
end

function studio:isThemeResearched(themeID)
	return self.researchedThemes[themeID] == true
end

function studio:getResearchedThemes()
	return self.researchedThemes
end

function studio:addResearchedTheme(themeID)
	self.researchedThemes[themeID] = true
end

function studio:isGenreResearched(genreID)
	return self.researchedGenres[genreID] == true
end

function studio:getResearchedGenres()
	return self.researchedGenres
end

function studio:addResearchedGenre(genreID)
	if not self.researchedGenres[genreID] then
		self.researchedGenres[genreID] = true
		self.researchedGenreCount = self.researchedGenreCount + 1
		
		self:verifySubgenreDialogue()
	end
end

function studio:countResearchedGenres()
	self.researchedGenreCount = table.count(self.researchedGenres)
	
	self:verifySubgenreDialogue()
end

function studio:canSelectSubgenre()
	return self.researchedGenreCount >= gameProject.MIN_GENRES_FOR_SUBGENRE
end

studio.SUBGENRE_DIALOGUE_FACT = "had_subgenre_dialogue"

function studio:verifySubgenreDialogue()
	if self.researchedGenreCount >= gameProject.MIN_GENRES_FOR_SUBGENRE and not self.facts[studio.SUBGENRE_DIALOGUE_FACT] then
		local designer = self:getRandomEmployeeOfRole("designer")
		
		if designer then
			dialogueHandler:addDialogue("designer_subgenre_1", nil, designer)
			
			self.facts[studio.SUBGENRE_DIALOGUE_FACT] = true
		end
	end
end

function studio:getResearchedGenreCount()
	return self.researchedGenreCount
end

function studio:getContractorGames()
	return self.contractorGames
end

local closest = {}

studio.DEFAULT_CLOSEST_EMPLOYEE_RANGE = 200

function studio:findClosestEmployees(targetEmployee, range, employeeList)
	range = range or studio.DEFAULT_CLOSEST_EMPLOYEE_RANGE
	
	table.clear(closest)
	
	local ourX, ourY = targetEmployee:getPos()
	
	ourFloor = targetEmployee:getFloor()
	
	for key, employee in ipairs(employeeList or self.hiredDevelopers) do
		if employee ~= targetEmployee and targetEmployee:getFloor() == ourFloor then
			local x, y = employee:getPos()
			
			if range >= math.distXY(ourX, x, ourY, y) then
				closest[#closest + 1] = employee
			end
		end
	end
	
	return closest
end

function studio:addProject(projObj)
	if not projObj:shouldAddToProjectList() then
		return false
	end
	
	for key, obj in ipairs(self.projects) do
		if obj == projObj then
			return false
		end
	end
	
	table.insert(self.projects, projObj)
	
	return true
end

function studio:removeProject(projObj)
	for key, otherProject in ipairs(self.projects) do
		if otherProject == projObj then
			table.remove(self.projects, key)
			
			return true
		end
	end
	
	return false
end

function studio:getProjects()
	return self.projects
end

function studio:convertOwnedTiles()
	local converted = {}
	
	for index, state in pairs(self.ownedTiles) do
		converted[#converted + 1] = index
	end
	
	return converted
end

function studio:hasEngineLicense(engineObj)
	for key, otherEngine in ipairs(self.boughtEngineLicenses) do
		if engineObj == otherEngine then
			return true
		end
	end
	
	return false
end

function studio:canAffordEngineLicense(engineObj)
	return self.funds >= engineObj:getCost()
end

function studio:canPurchaseEngineLicense(engineObj)
	if self:hasEngineLicense(engineObj) then
		return false
	end
	
	return self:canAffordEngineLicense(engineObj)
end

function studio:purchaseEngineLicense(engineObj)
	local cost = engineObj:getCost()
	
	if cost > 0 then
		self:deductFunds(cost, nil, "engine_licensing")
	end
	
	table.insert(self.boughtEngineLicenses, engineObj)
	engineLicensing:postPurchaseEngineLicense(engineObj)
	achievements:attemptSetAchievement(achievements.ENUM.PURCHASE_LICENSE)
	events:fire(engineLicensing.EVENTS.PURCHASED)
end

function studio:changeSlanderSuspicion(change)
	self.slanderSuspicion = math.min(rivalGameCompanies.SUSPICION_MAX, self.slanderSuspicion + change)
end

function studio:getSlanderSuspicion()
	return self.slanderSuspicion
end

function studio:getSlanderReputationLoss(slandererID)
	return self.slanderReputationLoss[slandererID] or 0
end

function studio:logSlanderReputationLoss(repLoss, slanderer)
	self.slanderReputationLoss[slanderer:getID()] = (self.slanderReputationLoss[slanderer:getID()] or 0) + repLoss
end

function studio:logSlanderKnowledge(slanderer)
	self.slanderAttemptKnowledge[slanderer:getID()] = true
end

function studio:knowsOfRivalSlander(slandererID)
	return self.slanderAttemptKnowledge[slandererID]
end

function studio:clearRivalSlanderKnowledge(slandererID)
	self.slanderAttemptKnowledge[slandererID] = nil
end

function studio:resetSlanderReputationLoss(slandererID)
	self.slanderReputationLoss[slandererID] = 0
end

function studio:calculateRecoupAmount(repLoss)
	return repLoss * studio.CASH_RECOUP_PER_REPUTATION_POINT
end

function studio.closeCourtPopupPostKill()
	events:fire(rivalGameCompany.EVENTS.COURT_POPUP_CLOSED)
end

studio.MINIMUM_COURT_RECOUP = 100000

function studio:finishLegalAction(target)
	local baseText
	local ourRepLoss, theirRepLoss = self:getSlanderReputationLoss(target:getID()), target:getSlanderReputationLoss(self:getID())
	local payout = math.max(studio.MINIMUM_COURT_RECOUP, math.abs(self:calculateRecoupAmount(ourRepLoss - theirRepLoss)))
	local payoutTarget, loserTarget, rivalName
	
	if self:isPlayer() then
		if not target:hasFoundOutPlayerSlander() then
			theirRepLoss = 0
		end
		
		if theirRepLoss > 0 then
			if theirRepLoss < ourRepLoss then
				payoutTarget = self
				loserTarget = target
				baseText = _T("LEGAL_ACTION_PLAYER_MORE_AFFECTED", "You've gone to court with the CEO of 'RIVAL' and presented your evidence of defamation, but so has their CEO. However the court still ruled in your favor, as the damage done to you was greater than you had done to your rival.\n\n'RIVAL' will now pay out a reparation sum of $REPARATIONS.")
			elseif ourRepLoss == theirRepLoss then
				baseText = _T("LEGAL_ACTION_PLAYER_EQUAL_LOSS", "You've gone to court with the CEO of 'RIVAL' and presented your evidence of defamation, but so has their CEO. The court decided that both of you did the same amount of damage in reputation to each other.\n\nNeither side has to pay out any reparations.")
			else
				payoutTarget = target
				loserTarget = self
				baseText = _T("LEGAL_ACTION_PLAYER_RIVAL_MORE_AFFECTED", "You've gone to court with the CEO of 'RIVAL' and presented your evidence of defamation, but so has their CEO. However the court ruled in favor of 'RIVAL', as the damage done to them was greater than they had done to you.\n\nYou will now pay out a reparation sum of $REPARATIONS.")
			end
		else
			payoutTarget = self
			loserTarget = target
			baseText = _T("LEGAL_ACTION_PLAYER", "You've gone to court with the CEO of 'RIVAL' and presented your evidence of defamation. The court has ruled in your favor.\n\n'RIVAL' will now pay out a reparation sum of $REPARATIONS.")
		end
		
		rivalName = target:getName()
	else
		if not self:hasFoundOutPlayerSlander() then
			ourRepLoss = 0
		end
		
		if theirRepLoss > 0 then
			if ourRepLoss < theirRepLoss then
				payoutTarget = target
				loserTarget = self
				baseText = _T("LEGAL_ACTION_RIVAL_MORE_AFFECTED", "You've gone to court with the CEO of 'RIVAL' and they have presented their evidence of defamation, but so have you. However the court still ruled in your favor, as the damage done to you was greater than you had done to your rival.\n\n'RIVAL' will now pay out a reparation sum of $REPARATIONS.")
			elseif ourRepLoss == theirRepLoss then
				baseText = _T("LEGAL_ACTION_RIVAL_EQUAL_LOSS", "You've gone to court with the CEO of 'RIVAL' and they have presented their evidence of defamation, but so have you. The court decided that both of you did the same amount of damage in reputation to each other.\n\nNeither side has to pay out any reparations.")
			else
				payoutTarget = self
				loserTarget = target
				baseText = _T("LEGAL_ACTION_RIVAL_RIVAL_MORE_AFFECTED", "You've gone to court with the CEO of 'RIVAL' and they have presented their evidence of defamation, but so have you. However the court ruled in favor of 'RIVAL', as the damage done to them was greater than they had done to you.\n\nYou will now pay out a reparation sum of $REPARATIONS.")
			end
		else
			payoutTarget = self
			loserTarget = target
			baseText = _T("LEGAL_ACTION_RIVAL", "You've gone to court with the CEO of 'RIVAL' and they have presented their evidence of defamation. The court has ruled in their favor.\n\nYou will now pay out a reparation sum of $REPARATIONS.")
		end
		
		rivalName = self:getName()
	end
	
	local repLoss
	
	if payoutTarget and loserTarget then
		if payoutTarget:isPlayer() and payout > 0 then
			achievements:attemptSetAchievement(achievements.ENUM.WIN_COURT)
		end
		
		payoutTarget:addFunds(payout, nil, "penalties")
		loserTarget:deductFunds(payout, nil, "penalties")
		
		repLoss = loserTarget:getReputation() * studio.COURT_LOSS_REPUTATION_LOSS
		
		loserTarget:decreaseReputation(repLoss)
	end
	
	if target:isPlayer() then
		target:clearRivalSlanderKnowledge(self:getID())
		self:setAnger(0)
	elseif self:isPlayer() then
		self:clearRivalSlanderKnowledge(target:getID())
		target:setAnger(0)
	end
	
	self:resetSlanderReputationLoss(target:getID())
	target:resetSlanderReputationLoss(self:getID())
	
	baseText = _format(baseText, "RIVAL", rivalName, "REPARATIONS", string.comma(payout))
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont("pix24")
	popup:setTitle(_T("LEGAL_ACTION_RESULTS_TITLE", "Legal Action Results"))
	popup:setTextFont("pix20")
	popup:setText(baseText)
	
	local left, right, extra = popup:getDescboxes()
	
	if repLoss then
		local text, icon
		
		if loserTarget:isPlayer() then
			text = _format(_T("LEGAL_ACTION_YOU_LOST_REPUTATION", "You've lost REP reputation"), "REP", string.roundtobignumber(repLoss))
			icon = "exclamation_point_red"
		else
			text = _format(_T("LEGAL_ACTION_RIVAL_LOST_REPUTATION", "'RIVAL' has lost REP reputation"), "RIVAL", loserTarget:getName(), "REP", string.roundtobignumber(repLoss))
			icon = "exclamation_point"
		end
		
		extra:addSpaceToNextText(10)
		extra:addText(text, "bh20", nil, 0, 580, icon, 22, 22)
	end
	
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
	
	popup.postKill = studio.closeCourtPopupPostKill
	
	achievements:attemptSetAchievement(achievements.ENUM.GO_TO_COURT)
	events:fire(rivalGameCompany.EVENTS.FINISHED_COURT, self)
end

function studio:getPurchasedEngines()
	return self.boughtEngineLicenses
end

function studio:hasPurchasedEngineLicense(engineObj)
	for key, otherEngine in ipairs(self.boughtEngineLicenses) do
		if engineObj == otherEngine then
			return true
		end
	end
	
	return false
end

eventBoxText:registerNew({
	id = "imminent_bankruptcy",
	getText = function(self, data)
		if studio.BANKRUPTCY_TIME_PERIOD - data == 1 then
			return _format(_T("INFORM_OF_IMMINENT_BANKRUPTCY", "Not enough funds to cover monthly expenses! You will go bankrupt next month!"))
		else
			return _format(_T("INFORM_OF_IMMINENT_BANKRUPTCY_TIME", "Not enough funds to cover monthly expenses! You will go bankrupt in TIME!"), "TIME", timeline:getTimePeriodText((studio.BANKRUPTCY_TIME_PERIOD - data) * timeline.DAYS_IN_MONTH))
		end
	end
})

function studio:handleBankruptcy()
	if self.funds <= 0 then
		self.bankruptcyMonths = self.bankruptcyMonths + 1
		
		if self:isPlayer() then
			game.addToEventBox("imminent_bankruptcy", self.bankruptcyMonths, 4, nil, "exclamation_point_red")
		end
	else
		self.bankruptcyMonths = math.max(self.bankruptcyMonths - 1, 0)
	end
	
	if self.bankruptcyMonths >= studio.BANKRUPTCY_TIME_PERIOD then
		self:doBankruptcy()
	end
end

function studio:doBankruptcy()
	game.gameOver()
end

function studio:save()
	local saved = {}
	
	saved.engines = {}
	saved.employees = {}
	saved.teams = {}
	saved.projects = {}
	saved.objects = {}
	saved.researchedFeatures = self.researchedFeatures
	saved.funds = self.funds
	saved.licensedEngines = {}
	saved.boughtEngineLicenses = {}
	saved.knownActivityAffectors = self.knownActivityAffectors
	saved.lastActivities = self.lastActivities
	saved.scheduledActivity = self.scheduledActivity
	saved.willingParticipants = {}
	saved.nonParticipants = {}
	saved.facts = self.facts
	saved.licensedPlatforms = self.licensedPlatforms
	saved.bankruptcyMonths = self.bankruptcyMonths
	saved.onVacationEmployees = self.onVacationEmployees
	saved.revealedMatches = self.revealedMatches
	saved.reputation = self.reputation
	saved.gamesByGenre = self.gamesByGenre
	saved.gamesByTheme = self.gamesByTheme
	saved.previousGamesByGenre = self.previousGamesByGenre
	saved.previousGamesByTheme = self.previousGamesByTheme
	saved.badGameScores = self.badGameScores
	saved.lastBadGameDate = self.lastBadGameDate
	saved.researchedThemes = self.researchedThemes
	saved.researchedGenres = self.researchedGenres
	saved.newIncompatibleTech = self.newIncompatibleTech
	saved.contractorGames = self.contractorGames
	saved.firstPaymentDone = self.firstPaymentDone
	saved.slanderSuspicion = self.slanderSuspicion
	saved.slanderReputationLoss = self.slanderReputationLoss
	saved.slanderAttemptKnowledge = self.slanderAttemptKnowledge
	saved.lastActivityTime = self.lastActivityTime
	saved.stats = self.stats:save()
	saved.revealedFeatures = self.revealedFeatures
	saved.financeHistory = self.financeHistory:save()
	saved.name = self.name
	saved.boughtOutCompanies = self.boughtOutCompanies
	saved.loan = self.loan
	saved.rentedServers = self.rentedServers
	saved.ignoreRentedServers = self.ignoreRentedServers
	saved.customerSupport = self.customerSupport
	saved.ignoreCustomerSupport = self.ignoreCustomerSupport
	saved.frustrationLeavings = self.frustrationLeavings
	saved.gameAwardWins = self.gameAwardWins
	saved.totalGameAwards = self.totalGameAwards
	saved.gameAwardParticipations = self.gameAwardParticipations
	saved.fundChange = self.fundChange
	saved.tasks = {}
	saved.opinion = self.opinion
	saved.revealedEditionMatches = self.revealedEditionMatches
	saved.revealedEditionMatchCount = self.revealedEditionMatchCount
	saved.expansionDisabled = self.expansion:getExpansionDisabled()
	
	for key, taskObj in ipairs(self.tasks) do
		saved.tasks[#saved.tasks + 1] = taskObj:save()
	end
	
	if self.soldEngineObj then
		saved.soldEngine = self.soldEngineObj:getUniqueID()
	end
	
	if #self.playerPlatforms > 0 then
		saved.playerPlatforms = {}
		
		for key, obj in ipairs(self.playerPlatforms) do
			saved.playerPlatforms[key] = obj:save()
		end
		
		saved.totalPlatformCount = self.totalPlatformCount
	end
	
	for key, employee in ipairs(self.willingParticipants) do
		table.insert(saved.nonParticipants, employee:getUniqueID())
	end
	
	for key, employee in ipairs(self.nonParticipants) do
		table.insert(saved.nonParticipants, employee:getUniqueID())
	end
	
	for key, engineObj in ipairs(self.boughtEngineLicenses) do
		table.insert(saved.boughtEngineLicenses, engineObj:getUniqueID())
	end
	
	for key, data in ipairs(self.licensedEngines) do
		table.insert(saved.licensedEngines, {
			engine = data.engine:getUniqueID(),
			licenses = data.licenses
		})
	end
	
	saved.ownedTiles = self.ownedTiles
	
	for key, employee in ipairs(self.hiredDevelopers) do
		saved.employees[key] = employee:save()
	end
	
	for key, projectObj in ipairs(self.projects) do
		table.insert(saved.projects, projectObj:save())
	end
	
	for key, curEngine in ipairs(self.engines) do
		table.insert(saved.engines, curEngine:getUniqueID())
	end
	
	for key, teamObj in ipairs(self.teams) do
		table.insert(saved.teams, teamObj:save())
	end
	
	return saved
end

function studio:addOwnedBuilding(building)
	table.insert(self.ownedBuildings, building)
	
	for index, state in pairs(building:getTileIndexes()) do
		self.ownedTiles[index] = true
	end
	
	self:updateViewableFloors(building:getPurchasedFloors())
end

function studio:getOwnedBuildings()
	return self.ownedBuildings
end

function studio:getOwnedBuildingByID(id)
	for key, buildingObj in ipairs(self.ownedBuildings) do
		if buildingObj:getID() == id then
			return buildingObj
		end
	end
end

function studio:load(data)
	self._disableReregistration = false
	self._loading = true
	
	self:init()
	self:setupFloorData()
	
	self.canUpdateOverallEfficiency = false
	self.researchedFeatures = data.researchedFeatures
	self.licensedPlatforms = data.licensedPlatforms or self.licensedPlatforms
	
	for key, id in ipairs(self.licensedPlatforms) do
		self.licensedPlatformsMap[id] = true
	end
	
	self.facts = data.facts or self.facts
	self.revealedMatches = data.revealedMatches or self.revealedMatches
	
	self:setReputation(data.reputation or self.reputation)
	
	self.gamesByTheme = data.gamesByTheme or self.gamesByTheme
	self.gamesByGenre = data.gamesByGenre or self.gamesByGenre
	self.badGameScores = data.badGameScores or self.badGameScores
	self.researchedGenres = data.researchedGenres or self.researchedGenres
	self.researchedThemes = data.researchedThemes or self.researchedThemes
	self.lastBadGameDate = data.lastBadGameDate
	self.newIncompatibleTech = data.newIncompatibleTech or 0
	self.contractorGames = data.contractorGames or self.contractorGames
	self.fundChange = data.fundChange or 0
	self.firstPaymentDone = data.firstPaymentDone
	self.slanderReputationLoss = data.slanderReputationLoss or self.slanderReputationLoss
	self.slanderAttemptKnowledge = data.slanderAttemptKnowledge or self.slanderAttemptKnowledge
	self.lastActivityTime = data.lastActivityTime or self.lastActivityTime
	self.gameAwardWins = data.gameAwardWins or self.gameAwardWins
	self.totalGameAwards = data.totalGameAwards or self.totalGameAwards
	self.gameAwardParticipations = data.gameAwardParticipations or self.gameAwardParticipations
	self.revealedEditionMatches = data.revealedEditionMatches or self.revealedEditionMatches
	self.revealedEditionMatchCount = data.revealedEditionMatchCount or self.revealedEditionMatchCount
	
	if data.expansionDisabled then
		self.expansion:disableExpansion()
	end
	
	if not data.lastActivityTime then
		self:findLastActivityTime()
	else
		self.lastActivityTime = data.lastActivityTime
	end
	
	self.revealedFeatures = data.revealedFeatures or self.revealedFeatures
	self.name = data.name or self.name
	self.boughtOutCompanies = data.boughtOutCompanies or self.boughtOutCompanies
	self.loan = data.loan or self.loan
	self.rentedServers = data.rentedServers or self.rentedServers
	self.ignoreRentedServers = data.ignoreRentedServers or self.ignoreRentedServers
	self.customerSupport = data.customerSupport or self.customerSupport
	self.ignoreCustomerSupport = data.ignoreCustomerSupport or self.ignoreCustomerSupport
	self.frustrationLeavings = data.frustrationLeavings or self.frustrationLeavings
	self.totalPlatformCount = data.totalPlatformCount or self.totalPlatformCount
	
	self:onCustomerSupportChanged()
	
	if data.financeHistory then
		self.financeHistory:load(data.financeHistory)
	end
	
	if data.stats then
		self.stats:load(data.stats)
	end
	
	if data.tasks then
		for key, data in ipairs(data.tasks) do
			local obj = task.new(data.id)
			
			obj:load(data)
			
			self.tasks[key] = obj
		end
	end
	
	self.previousGamesByGenre = data.previousGamesByGenre or self.previousGamesByGenre
	self.previousGamesByTheme = data.previousGamesByTheme or self.previousGamesByTheme
	self.ownedTiles = data.ownedTiles
	
	self:setOpinion(data.opinion or self.opinion)
	self:setFunds(data.funds)
	
	for key, engineID in ipairs(data.boughtEngineLicenses) do
		local engineObj = select(1, engineLicensing:getEngineByUniqueID(engineID))
		
		engineObj:setOwner(self)
		table.insert(self.boughtEngineLicenses, engineObj)
	end
	
	for key, teamData in ipairs(data.teams) do
		local newTeam = team.new()
		
		newTeam:setOwner(self)
		newTeam:load(teamData)
		self:addTeam(newTeam)
	end
	
	self.studioTeam = self:getTeamByUniqueID(1)
	
	local projDataToProjectObjects = {}
	local gamesToLoad, releasedGamesToLoad = {}, {}
	
	if data.playerPlatforms then
		for key, data in ipairs(data.playerPlatforms) do
			local obj = playerPlatform.new()
			
			obj:load(data)
			
			self.playerPlatforms[#self.playerPlatforms + 1] = obj
			
			if not obj:isDiscontinued() and obj:isReleased() then
				platformShare:addPlatformToShareList(obj, true)
			end
			
			platformShare:referencePlatformID(obj:getID(), obj)
		end
	end
	
	for key, projectData in ipairs(data.projects) do
		if projectData.PROJECT_TYPE == gameProject.PROJECT_TYPE then
			if projectData.releaseDate then
				table.insert(releasedGamesToLoad, projectData)
			else
				table.insert(gamesToLoad, projectData)
			end
		elseif projectData.PROJECT_TYPE == engine.PROJECT_TYPE then
			local newObj = projectLoader:load(projectData, self)
			
			projDataToProjectObjects[projectData] = newObj
			
			table.insert(self.engines, newObj)
		end
	end
	
	for key, projectData in ipairs(releasedGamesToLoad) do
		local newObj = projectLoader:load(projectData, self)
		
		projDataToProjectObjects[projectData] = newObj
		self.gamesByUniqueID[newObj:getUniqueID()] = newObj
		
		table.insert(self.games, newObj)
		table.insert(self.releasedGames, newObj)
	end
	
	for key, projectData in ipairs(gamesToLoad) do
		local newObj = projectLoader:load(projectData, self)
		
		projDataToProjectObjects[projectData] = newObj
		self.gamesByUniqueID[newObj:getUniqueID()] = newObj
		
		table.insert(self.games, newObj)
		table.insert(self.inDevGames, newObj)
	end
	
	for key, employeeData in ipairs(data.employees) do
		if not self.hiredDevelopersByUID[employeeData.uniqueID] then
			local loadedEmployee = developer.new()
			
			loadedEmployee:setEmployer(self)
			loadedEmployee:load(employeeData)
			self:addEmployee(loadedEmployee)
		else
			print("WARNING: duplicate unique ID employee with ID ", employeeData.uniqueID)
		end
	end
	
	if data.soldEngine then
		self.soldEngineObj = self:getEngineByUniqueID(data.soldEngine)
	end
	
	for key, projectData in pairs(data.projects) do
		projDataToProjectObjects[projectData]:postLoad(projectData)
	end
	
	self.licensedEngines = data.licensedEngines or self.licensedEngines
	
	for key, data in ipairs(self.licensedEngines) do
		data.engine = studio:getProjectByUniqueID(data.engine)
	end
	
	for key, employee in ipairs(self.hiredDevelopers) do
		employee:postLoad()
	end
	
	self.knownActivityAffectors = data.knownActivityAffectors or self.knownActivityAffectors
	self.lastActivities = data.lastActivities or self.lastActivities
	self.scheduledActivity = data.scheduledActivity or self.scheduledActivity
	self.willingParticipants = data.willingParticipants or self.willingParticipants
	self.nonParticipants = data.nonParticipants or self.nonParticipants
	self.bankruptcyMonths = data.bankruptcyMonths or self.bankruptcyMonths
	self.onVacationEmployees = data.onVacationEmployees or self.onVacationEmployees
	
	for key, uniqueID in ipairs(self.scheduledActivity.participants) do
		self.scheduledActivity.participants[key] = uniqueID
	end
	
	for key, uniqueID in ipairs(self.willingParticipants) do
		self.willingParticipants[key] = self:getEmployeeByUniqueID(uniqueID)
	end
	
	for key, uniqueID in ipairs(self.nonParticipants) do
		self.nonParticipants[key] = self:getEmployeeByUniqueID(uniqueID)
	end
	
	self:buildImplementedEngineFeatures()
	self:buildHighestQualityScoreList()
	
	self.canUpdateOverallEfficiency = true
	
	for key, roomObject in ipairs(self.rooms) do
		roomObject:calculateOverallEmployeeEfficiency()
	end
end

function studio:onFinishLoad()
	for key, project in ipairs(self.projects) do
		project:onFinishLoad()
	end
	
	self._loading = false
	self._preventAssignment = true
	
	self:reevaluateOffices()
	
	for key, teamObj in ipairs(self.teams) do
		teamObj:postLoad()
	end
	
	if not self.playerCharacter then
		characterDesigner:begin(true, game.DESCENDANT_STARTING_SKILL_LEVELS)
	end
	
	self:countResearchedGenres()
	self:onServerCapacityChanged()
	self:verifyEmployeeCountAchievements(#self.hiredDevelopers)
	self:verifyFundAchievements()
	events:fire(studio.EVENTS.UPDATE_MMO_HAPPINESS)
end

function studio:finalize()
	self._preventAssignment = false
	self._allowCostRecalc = true
	
	for key, officeObject in ipairs(self.ownedBuildings) do
		for i = 1, officeObject:getPurchasedFloors() do
			officeObject:updateMonthlyCosts(i)
		end
		
		employeeAssignment:assignEmployeesToFreeWorkplaces(officeObject:getWorkplaces())
	end
	
	self:updateMonthlyCosts()
end

function studio:reevaluateOffices()
	for key, object in ipairs(self.ownedBuildings) do
		for i = 1, object:getPurchasedFloors() do
			self:reevaluateOffice(nil, object, i)
		end
	end
end

function studio:reevaluateOffice(skipRoomUpdate, officeObject, floorEval)
	self.expansion:evaluateReach(officeObject, floorEval)
	
	if not skipRoomUpdate then
		self:updateRooms(nil, officeObject, floorEval)
	else
		officeObject:onRoomsUpdated()
	end
	
	officeObject:attemptUseEvalQueue()
	self.expansion:checkOfficeValidity(officeObject)
	self:updateComputerLevels()
	hook.call("officeReevaluation")
end

function studio:addActiveDeveloper(emp)
	if self.activeEmployeesMap[emp] then
		return 
	end
	
	self.activeEmployees[#self.activeEmployees + 1] = emp
	self.activeEmployeesMap[emp] = true
	self.employeeIter = self.employeeIter - 1
end

function studio:removeActiveDeveloper(emp)
	if not self.activeEmployeesMap[emp] then
		return 
	end
	
	table.removeObject(self.activeEmployees, emp)
	
	self.activeEmployeesMap[emp] = nil
	self.employeeIter = self.employeeIter - 1
end

function studio:addInactiveDeveloper(emp)
	if self.inactiveEmployeesMap[emp] then
		return 
	end
	
	self.inactiveEmployees[#self.inactiveEmployees + 1] = emp
end

function studio:removeInactiveDeveloper(emp)
	if not self.inactiveEmployeesMap[emp] then
		return 
	end
	
	table.removeObject(self.inactiveEmployees, emp)
	
	self.inactiveEmployeesMap[emp] = nil
end

function studio:update(delta, progress)
	self.employeeIter = 1
	
	local activeList = self.activeEmployees
	
	for i = 1, #activeList do
		local dev = activeList[self.employeeIter]
		
		dev:update(delta, progress)
		
		self.employeeIter = self.employeeIter + 1
	end
	
	for key, teamObj in ipairs(self.teams) do
		teamObj:progress(delta, progress)
	end
end

function studio:postTimelineUpdate(delta, simDelta)
	if simDelta > 0 then
		conversations:update(delta, simDelta)
		developerActions:update(simDelta)
		
		for key, dev in ipairs(self.renderDevelopers) do
			dev:updateVisual(simDelta)
		end
	end
end

studio.previousDevs = {}

function studio:addRenderDeveloper(dev)
	if self.renderDeveloperMap[dev] then
		return 
	end
	
	table.insert(self.renderDevelopers, dev)
	
	self.renderDeveloperMap[dev] = true
end

function studio:removeRenderDeveloper(dev)
	if not self.renderDeveloperMap[dev] then
		return 
	end
	
	table.removeObject(self.renderDevelopers, dev)
	
	self.renderDeveloperMap[dev] = nil
	
	self:removeDeveloperRenderData(dev)
end

function studio:removeDeveloperRenderData(dev)
	if self.previousDevs[dev] then
		table.removeObject(self.visibleDevelopers, dev)
		
		self.previousDevs[dev] = nil
	end
end

function studio:executeOnDevelopers(dev)
	local wasVis = self.previousDevs[dev]
	
	if not wasVis then
		dev:enterVisibilityRange()
		
		self.visibleDevelopers[#self.visibleDevelopers + 1] = dev
		self.previousDevs[dev] = true
	end
	
	dev:preDraw()
end

function studio:preDraw()
	local tileW, tileH = game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT
	local visDevs = game.worldObject.devQuadTree:query(camera.x + tileW, camera.y + tileH, (scrW + tileW * 2) / camera.scaleX, (scrH + tileH * 2) / camera.scaleY)
	
	for key, dev in ipairs(visDevs) do
		local wasVis = self.previousDevs[dev]
		
		if not wasVis then
			dev:enterVisibilityRange()
			
			self.visibleDevelopers[#self.visibleDevelopers + 1] = dev
			self.previousDevs[dev] = true
		end
		
		dev:preDraw()
		
		visDevs[key] = nil
	end
	
	self.expansion:preDraw()
end

function studio:postWorldDraw()
	employeeAssignment:draw()
end

function studio:onFloorViewChanged()
	local list, devMap = self.visibleDevelopers, self.previousDevs
	
	for key, obj in ipairs(list) do
		obj:leaveVisibilityRange()
		
		devMap[obj] = nil
		list[key] = nil
	end
	
	if self.expansion:isActive() then
		self.expansion:onFloorViewChanged()
	end
	
	objectSelector:onFloorViewChanged()
end

function studio:onFloorPurchased(floor)
	self:updateViewableFloors(floor)
end

function studio:updateViewableFloors(floorCount)
	self.viewableFloors = math.max(self.viewableFloors, floorCount)
end

function studio:getVisibleDevelopers()
	return self.visibleDevelopers
end

function studio:draw()
	for key, teamObj in ipairs(self.teams) do
		teamObj:draw()
	end
	
	self.expansion:draw()
	
	local canHover = objectSelector:canMouseOver()
	local mouseOverDev, mouseOverStatusIcon, iconDev = nil, false
	local rIdx = 1
	local mouseX, mouseY = camera.absMouseX, camera.absMouseY
	
	for i = 1, #self.visibleDevelopers do
		local dev = self.visibleDevelopers[rIdx]
		
		if cullingTester:shouldCull(dev) then
			dev:leaveVisibilityRange()
			
			self.previousDevs[dev] = nil
			
			table.remove(self.visibleDevelopers, rIdx)
		else
			dev:postDraw()
			
			if canHover then
				local avatar = dev:getAvatar()
				local statusIconObject, devObject = avatar:isMouseOverStatusIcon(mouseX, mouseY)
				
				if statusIconObject then
					mouseOverStatusIcon = statusIconObject
					iconDev = devObject
				end
				
				if not mouseOverStatusIcon and not mouseOverDev and dev:isMouseOver() and dev:canDrawMouseOver() then
					mouseOverDev = dev
				end
			end
			
			rIdx = rIdx + 1
		end
	end
	
	if not mouseOverStatusIcon then
		if canHover then
			local mouseOverObject = mouseOverDev or game.getObjectAtMousePos(self.visibleDevelopers, true)
			
			if mouseOverObject then
				local prevObject = game.getMouseOverObject()
				
				if prevObject ~= mouseOverObject then
					if prevObject then
						objectSelector:onMouseOverObjectSwitched(mouseOverObject)
						prevObject:onMouseLeft()
					end
					
					mouseOverObject:onMouseOver()
					game.setMouseOverObject(mouseOverObject)
				end
			else
				local prevObject = game.getMouseOverObject()
				
				if prevObject then
					prevObject:onMouseLeft()
					game.setMouseOverObject(nil)
					objectSelector:onMouseOverObjectSwitched(nil)
				end
			end
		else
			local prevObject = game.getMouseOverObject()
			
			if prevObject then
				objectSelector:onMouseOverObjectSwitched(nil)
				game.setMouseOverObject(nil)
				prevObject:onMouseLeft()
			end
		end
	else
		local prevObject = game.getMouseOverObject()
		
		if prevObject ~= mouseOverStatusIcon then
			if prevObject then
				prevObject:onMouseLeft()
				objectSelector:onMouseOverObjectSwitched(nil)
			end
			
			mouseOverStatusIcon:onMouseEntered(iconDev)
			game.setMouseOverObject(mouseOverStatusIcon)
		end
	end
end

require("game/studio/expansion")
require("game/studio/drive_affectors")
require("game/studio/employee_assignment")
require("game/studio/interaction_controller")
require("game/studio/object_selector")
require("game/studio/research_task")
require("game/studio/room")
require("game/studio/office_building")
require("game/studio/office_building_map")
require("game/studio/office_building_inserter")
studio:init()
