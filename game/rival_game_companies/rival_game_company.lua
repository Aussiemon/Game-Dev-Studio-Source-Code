rivalGameCompany = {}
rivalGameCompany.mtindex = {
	__index = rivalGameCompany
}
rivalGameCompany.EMPLOYEE_STEAL_ATTEMPT_EVENT = timeline.EVENTS.NEW_WEEK
rivalGameCompany.SLANDER_ATTEMPT_EVENT = timeline.EVENTS.NEW_WEEK
rivalGameCompany.USED_ENGINE_FEATURE_COUNT_MULTIPLIER = 0.8
rivalGameCompany.GENRE_MASTERY_INCREASE = 0.02
rivalGameCompany.THEME_MASTERY_INCREASE = 0.02
rivalGameCompany.MAX_ANGER = 200
rivalGameCompany.MAX_INTIMIDATION = 200
rivalGameCompany.PROGRESS_MULTIPLIER = 1.5
rivalGameCompany.RELEASE_POP_INCREASE = {
	max = 50000,
	min = 5000
}
rivalGameCompany.ANGER_CHANGE_REASON = {
	EMPLOYEE_STEALING = 1,
	MISC = 3,
	SLANDER = 2
}
rivalGameCompanies.LEGAL_ACTION_STATE = {
	IMMINENT = 2,
	SCHEDULED = 1
}
rivalGameCompany.RECONSIDERATION_STATE = {
	TAUNT = 2,
	RECONSIDER = 1
}
rivalGameCompany.BASE_THEME_WEIGHT = 100
rivalGameCompany.BASE_GENRE_WEIGHT = 100
rivalGameCompany.MASTERY_TO_GENRE_WEIGHT = 700
rivalGameCompany.MASTERY_TO_THEME_WEIGHT = 700
rivalGameCompany.TRENDING_TO_GENRE_WEIGHT = 150
rivalGameCompany.TRENDING_TO_THEME_WEIGHT = 150
rivalGameCompany.AUDIENCE_MIN_WEIGHT = 10
rivalGameCompany.AUDIENCE_BASE_WEIGHT = 100
rivalGameCompany.MINIMUM_WORK_AMOUNT = 0.15
rivalGameCompany.SINGLE_SCALE_TO_SKILL_LEVEL = 200
rivalGameCompany.PERCENTAGE_OF_FUNDS_IN_BUDGET = 0.2
rivalGameCompany.PERCENTAGE_OF_BUDGET_FOR_ONE_FEATURE = 0.5
rivalGameCompany.MONTH_IN_SALARIES_TO_INCREASE_SCALE = 10
rivalGameCompany.MAX_SCALE_MAX_AFFECTOR = 0.5
rivalGameCompany.MONTH_IN_SALARIES_TO_SCALE = 0.5
rivalGameCompany.NEW_GAME_COOLDOWN = timeline.DAYS_IN_WEEK * 2
rivalGameCompany.GENERIC_PLATFORM_COUNT = 3
rivalGameCompany.MANY_PLATFORMS_CHANCE = 30
rivalGameCompany.MANY_PLATFORMS_AMOUNT = 5
rivalGameCompany.PLATFORM_LICENSING_BUDGET = 0.15
rivalGameCompany.EMPLOYEE_STEAL_REPLY_TIME = {
	1,
	14
}
rivalGameCompany.THREATEN_TIME_AFTER_PROVOCATION = {
	1,
	7
}
rivalGameCompany.EMPLOYEE_STEAL_RETRY_COOLDOWN = timeline.DAYS_IN_MONTH * 3
rivalGameCompany.SLANDER_INSTANT_RETALIATION_TIME = timeline.DAYS_IN_MONTH
rivalGameCompany.MONTHS_IN_SALARIES_FOR_SLANDER = 8
rivalGameCompany.SLANDER_COOLDOWN = timeline.DAYS_IN_MONTH * 2
rivalGameCompany.RETURN_TO_EMPLOYEE_CIRCULATION_CHANCE_ON_DEFUNCT = 60
rivalGameCompany.MAX_STORED_PROJECT_DURATION = timeline.DAYS_IN_YEAR * 5
rivalGameCompany.TIME_UNTIL_BANRKUPTCY = timeline.DAYS_IN_MONTH
rivalGameCompany.BUYOUT_SALARY_MULTIPLIER = 10
rivalGameCompany.MAX_ADVERTISEMENT_BUDGET = 0.65
rivalGameCompany.PRICE_TO_MAX_ADVERTISEMENT_SPENDING = 50000
rivalGameCompany.ADVERT_FACT = "advertised_game"
rivalGameCompany.EMPLOYEE_STEAL_FACT = "player_steal_attempt"
rivalGameCompany.OFFERED_MONEY_FACT = "player_offered_extra_money"
rivalGameCompany.SWITCH_IN_TIME_FACT = "player_switch_in"
rivalGameCompany.SCHEDULED_LEAVE_FACT = "scheduled_leave"
rivalGameCompany.SCHEDULED_LEAVE_FACT_CHANCE = 50
rivalGameCompany.RIVAL_STEAL_COOLDOWN_FACT = "rival_steal_cooldown"
rivalGameCompany.PLAYER_STEAL_COOLDOWN_FACT = "player_steal_cooldown"
rivalGameCompany.CEO_FACT = "rival_ceo"
rivalGameCompany.CEO_LEARN_SPEED_MULTIPLIER = 2
rivalGameCompany.CEO_ROLE = "ceo"
rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_ID = "steal_employee_fail"
rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_SUCCESS_ID = "steal_employee_success"
rivalGameCompany.CONVO_TOPIC_SLANDER_ID = "rival_slander"
rivalGameCompany.CONVO_TOPIC_PLAYER_SLANDER_ID = "player_slander"
rivalGameCompany.HANG_UP_ANGER_CHANGE = 5
rivalGameCompany.HANG_UP_INTIMIDATION_CHANGE = 1
rivalGameCompany.HANG_UP_RELATIONSHIP_CHANGE = -1
rivalGameCompany.INSULT_AND_HANG_UP_ANGER_CHANGE = 10
rivalGameCompany.INSULT_AND_HANG_UP_INTIMIDATION_CHANGE = 4
rivalGameCompany.INSULT_AND_HANG_UP_RELATIONSHIP_CHANGE = -3
rivalGameCompany.RELATIONSHIP_RESTORE_COOLDOWN_MULTIPLIER = 3
rivalGameCompany.HIRE_EMPLOYEE_COOLDOWN = timeline.DAYS_IN_MONTH * 1.5
rivalGameCompany.HIRE_EMPLOYEE_ON_AFFORDABLE_SALARIES = 40
rivalGameCompany.PREMADE_NAMES = {
	_T("RIVAL_RANDOM_NAME_1", "606 Games"),
	_T("RIVAL_RANDOM_NAME_2", "Triple Blast Games"),
	_T("RIVAL_RANDOM_NAME_3", "GOGH Games"),
	_T("RIVAL_RANDOM_NAME_4", "3K Games"),
	_T("RIVAL_RANDOM_NAME_5", "999 Studios"),
	_T("RIVAL_RANDOM_NAME_6", "underfl0w Studios"),
	_T("RIVAL_RANDOM_NAME_7", "JIJA Games"),
	_T("RIVAL_RANDOM_NAME_8", "Bytes Studios"),
	_T("RIVAL_RANDOM_NAME_9", "Arian Studios"),
	_T("RIVAL_RANDOM_NAME_10", "Dog Head Studios"),
	_T("RIVAL_RANDOM_NAME_11", "Clutch Studios"),
	_T("RIVAL_RANDOM_NAME_12", "Implosion Games"),
	_T("RIVAL_RANDOM_NAME_13", "Codeblasters"),
	_T("RIVAL_RANDOM_NAME_14", "Gapcom"),
	_T("RIVAL_RANDOM_NAME_15", "MEGA Game Studios"),
	_T("RIVAL_RANDOM_NAME_16", "Facekick Studios"),
	_T("RIVAL_RANDOM_NAME_17", "CSG Games"),
	_T("RIVAL_RANDOM_NAME_18", "BO Studios"),
	_T("RIVAL_RANDOM_NAME_19", "Overplay Studios"),
	_T("RIVAL_RANDOM_NAME_20", "Benpsis Productions"),
	_T("RIVAL_RANDOM_NAME_21", "Ariga Studios"),
	_T("RIVAL_RANDOM_NAME_22", "Buzzard Entertainment"),
	_T("RIVAL_RANDOM_NAME_23", "Sandstorm Games"),
	_T("RIVAL_RANDOM_NAME_24", "WooHoo! Games"),
	_T("RIVAL_RANDOM_NAME_25", "LaughTek"),
	_T("RIVAL_RANDOM_NAME_26", "Molten Bits Entertainment"),
	_T("RIVAL_RANDOM_NAME_27", "300CK Games"),
	_T("RIVAL_RANDOM_NAME_28", "I-H-H-L Games"),
	_T("RIVAL_RANDOM_NAME_29", "Extraversion Software"),
	_T("RIVAL_RANDOM_NAME_30", "Gonemi"),
	_T("RIVAL_RANDOM_NAME_31", "Triforce Interactive"),
	_T("RIVAL_RANDOM_NAME_32", "Hervalt Entertainment"),
	_T("RIVAL_RANDOM_NAME_33", "DVD Scheme Blue")
}
rivalGameCompany.REP_MULT_RANGE = {
	1.15,
	1.25
}
rivalGameCompany.LOWER_REP_MULT_RANGE = {
	0.85,
	0.95
}
rivalGameCompany.CASH_MULT_RANGE = {
	1.25,
	1.35
}
rivalGameCompany.THREAT_REP_MULT_RANGE = {
	0.8,
	0.95
}
rivalGameCompany.MAX_EMPLOYEES_MULT_RANGE = {
	0.8,
	0.95
}
rivalGameCompany.BUYOUT_COST_MULT_RANGE = {
	0.15,
	0.25
}
rivalGameCompany.MINIMUM_BUYOUT_COST = 10000000
rivalGameCompany.GENRE_MASTERY_RANGE = {
	0,
	0.7
}
rivalGameCompany.THEME_MASTERY_RANGE = {
	0,
	0.7
}
rivalGameCompany.LEVEL_OFFSET_RANGE = {
	1,
	5
}
rivalGameCompany.STARTING_EMPLOYEES_MULT = {
	1.4,
	1.6
}
rivalGameCompany.STARTING_EMPLOYEES_MULT_MAX_EMPLOYEES = {
	0.7,
	0.8
}
rivalGameCompany.MAX_GENERATION_EMPLOYEES = 80
rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT = "rgc"
rivalGameCompany.EVENTS = {
	ATTEMPT_STEAL = events:new(),
	FAIL_STEAL = events:new(),
	SUCCEED_STEAL = events:new(),
	PLAYER_FAIL_STEAL = events:new(),
	PLAYER_SUCCEED_STEAL = events:new(),
	THREATENED_PLAYER = events:new(),
	PERFORMED_SLANDER = events:new(),
	SLANDER_FOUND_OUT = events:new(),
	SCHEDULED_COURT = events:new(),
	FINISHED_COURT = events:new(),
	SLANDER_POPUP_CLOSED = events:new(),
	COURT_POPUP_CLOSED = events:new(),
	RIVAL_DEFUNCT_POPUP_CLOSED = events:new(),
	RIVAL_BUYOUT_POPUP_CLOSED = events:new(),
	FILED_FOR_BANKRUPTCY = events:new(),
	FILL_INTERACTION = events:new(),
	ASKED_ABOUT_BRIBE = events:new()
}
rivalGameCompany.GAME_FIRST_NAME = {
	_T("GAME_NAME_GEN_FIRST_1", "Call of"),
	_T("GAME_NAME_GEN_FIRST_2", "Rise of the"),
	_T("GAME_NAME_GEN_FIRST_3", "Knights and"),
	_T("GAME_NAME_GEN_FIRST_4", "Knights of"),
	_T("GAME_NAME_GEN_FIRST_5", "Counter "),
	_T("GAME_NAME_GEN_FIRST_6", "My Wonderful"),
	_T("GAME_NAME_GEN_FIRST_7", "Full"),
	_T("GAME_NAME_GEN_FIRST_9", "Five Days of"),
	_T("GAME_NAME_GEN_FIRST_10", "Need for"),
	_T("GAME_NAME_GEN_FIRST_11", "Holy"),
	_T("GAME_NAME_GEN_FIRST_12", "Big"),
	_T("GAME_NAME_GEN_FIRST_13", "Big Little"),
	_T("GAME_NAME_GEN_FIRST_14", "Sea"),
	_T("GAME_NAME_GEN_FIRST_15", "Path to"),
	_T("GAME_NAME_GEN_FIRST_16", "Hand of"),
	_T("GAME_NAME_GEN_FIRST_17", "Deity of"),
	_T("GAME_NAME_GEN_FIRST_18", "The Evil"),
	_T("GAME_NAME_GEN_FIRST_19", "Streets of"),
	_T("GAME_NAME_GEN_FIRST_20", "World of"),
	_T("GAME_NAME_GEN_FIRST_21", "Soul of"),
	_T("GAME_NAME_GEN_FIRST_22", "Dungeon of"),
	_T("GAME_NAME_GEN_FIRST_23", "Den"),
	_T("GAME_NAME_GEN_FIRST_24", "Strength & Spells:"),
	_T("GAME_NAME_GEN_FIRST_25", "Sword of"),
	_T("GAME_NAME_GEN_FIRST_26", "Anonymous"),
	_T("GAME_NAME_GEN_FIRST_27", "From God"),
	_T("GAME_NAME_GEN_FIRST_28", "Power of"),
	_T("GAME_NAME_GEN_FIRST_29", "Dungeons and"),
	_T("GAME_NAME_GEN_FIRST_30", "The Oldest Parchments:"),
	_T("GAME_NAME_GEN_FIRST_31", "Death to"),
	_T("GAME_NAME_GEN_FIRST_32", "Right for"),
	_T("GAME_NAME_GEN_FIRST_33", "Zombie"),
	_T("GAME_NAME_GEN_FIRST_34", "Universal"),
	_T("GAME_NAME_GEN_FIRST_35", "Anime"),
	_T("GAME_NAME_GEN_FIRST_36", "Shadow"),
	_T("GAME_NAME_GEN_FIRST_37", "Special Service:"),
	_T("GAME_NAME_GEN_FIRST_38", "Life is"),
	_T("GAME_NAME_GEN_FIRST_39", "Trial of"),
	_T("GAME_NAME_GEN_FIRST_40", "Crypt Searcher:"),
	_T("GAME_NAME_GEN_FIRST_41", "The Dynasty of"),
	_T("GAME_NAME_GEN_FIRST_42", "Day of the"),
	_T("GAME_NAME_GEN_FIRST_43", "Avenger Stranger:")
}
rivalGameCompany.GAME_LAST_NAME = {
	_T("GAME_NAME_GEN_SECOND_1", "Exile"),
	_T("GAME_NAME_GEN_SECOND_2", "Blast"),
	_T("GAME_NAME_GEN_SECOND_3", "Terrorism"),
	_T("GAME_NAME_GEN_SECOND_4", "Dominator"),
	_T("GAME_NAME_GEN_SECOND_5", "God"),
	_T("GAME_NAME_GEN_SECOND_6", "Warfare"),
	_T("GAME_NAME_GEN_SECOND_7", "Outside"),
	_T("GAME_NAME_GEN_SECOND_8", "Impact"),
	_T("GAME_NAME_GEN_SECOND_9", "Discord"),
	_T("GAME_NAME_GEN_SECOND_10", "Storm"),
	_T("GAME_NAME_GEN_SECOND_11", "Dead"),
	_T("GAME_NAME_GEN_SECOND_12", "Hexagon"),
	_T("GAME_NAME_GEN_SECOND_13", "Destroyer"),
	_T("GAME_NAME_GEN_SECOND_14", "Heaven"),
	_T("GAME_NAME_GEN_SECOND_15", "Destruction"),
	_T("GAME_NAME_GEN_SECOND_16", "Annihilation"),
	_T("GAME_NAME_GEN_SECOND_17", "Grace"),
	_T("GAME_NAME_GEN_SECOND_18", "Limit"),
	_T("GAME_NAME_GEN_SECOND_19", "Intervention"),
	_T("GAME_NAME_GEN_SECOND_20", "Origins"),
	_T("GAME_NAME_GEN_SECOND_21", "Warrior"),
	_T("GAME_NAME_GEN_SECOND_22", "Victory"),
	_T("GAME_NAME_GEN_SECOND_23", "Ruin"),
	_T("GAME_NAME_GEN_SECOND_24", "Overworld"),
	_T("GAME_NAME_GEN_SECOND_25", "Underworld"),
	_T("GAME_NAME_GEN_SECOND_26", "Induction"),
	_T("GAME_NAME_GEN_SECOND_27", "Sacrifice"),
	_T("GAME_NAME_GEN_SECOND_28", "Fusion"),
	_T("GAME_NAME_GEN_SECOND_29", "War"),
	_T("GAME_NAME_GEN_SECOND_30", "Honor"),
	_T("GAME_NAME_GEN_SECOND_31", "Deliverance")
}
rivalGameCompany.SLANDER_OPTION_ID = "slander_rival"
rivalGameCompany.genresByWeight = {
	start = {},
	finish = {}
}
rivalGameCompany.themesByWeight = {
	start = {},
	finish = {}
}
rivalGameCompany.audiencesByWeight = {
	start = {},
	finish = {}
}
rivalGameCompany.sortedPlatforms = {}
rivalGameCompany.purchasePlatformLicense = studio.purchasePlatformLicense
rivalGameCompany.changeSlanderSuspicion = studio.changeSlanderSuspicion
rivalGameCompany.getSlanderSuspicion = studio.getSlanderSuspicion
rivalGameCompany.calculateRecoupAmount = studio.calculateRecoupAmount
rivalGameCompany.finishLegalAction = studio.finishLegalAction
rivalGameCompany.recountHighestSkills = studio.recountHighestSkills
rivalGameCompany.recountEmployeesByRole = studio.recountEmployeesByRole
rivalGameCompany.changeEmployeeRoleCount = studio.changeEmployeeRoleCount
rivalGameCompany.updateHighestEmployeeSkills = studio.updateHighestEmployeeSkills
rivalGameCompany.handleBankruptcy = studio.handleBankruptcy
rivalGameCompany.getPatchByUniqueID = studio.getPatchByUniqueID
rivalGameCompany.resetHighestSkillInfo = studio.resetHighestSkillInfo
rivalGameCompany.rebuildKnowledgeLevel = studio.rebuildKnowledgeLevel
rivalGameCompany.changeKnowledgeLevel = studio.changeKnowledgeLevel
rivalGameCompany.onKnowledgeChanged = studio.onKnowledgeChanged
rivalGameCompany.getCollectiveKnowledge = studio.getCollectiveKnowledge
rivalGameCompany.addActiveDeveloper = studio.addActiveDeveloper
rivalGameCompany.removeActiveDeveloper = studio.removeActiveDeveloper
rivalGameCompany.addGameAwardData = studio.addGameAwardData

function rivalGameCompany:resetSlanderReputationLoss(slanderer)
	self.slanderReputationLoss = 0
end

function rivalGameCompany:logSlanderReputationLoss(repLoss, slanderer)
	self.slanderReputationLoss = self.slanderReputationLoss + repLoss
end

function rivalGameCompany:getSlanderReputationLoss(slandererID)
	return self.slanderReputationLoss
end

function rivalGameCompany:onRevealIntentionsInDialogue(dialogueObject)
	local object = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
	
	object:markThreatenedPlayer()
	object:markAsHostile()
end

function rivalGameCompany.new(id, procedural)
	local new = {}
	
	setmetatable(new, rivalGameCompany.mtindex)
	new:init(id, procedural)
	
	return new
end

function rivalGameCompany:init(id, procedural)
	self.procedural = procedural
	self.intimidation = 0
	self.anger = 0
	self.totalAnger = 0
	self.funds = 0
	self.spentInSalaries = 0
	self.reputation = 0
	self.nextProjectTime = 0
	self.currentBudget = 0
	self.relationship = 0
	self.slanderSuspicion = 0
	self.slanderReputationLoss = 0
	self.bankruptcyMonths = 0
	self.relationshipRestoreCooldown = 0
	self.nextHireTime = 0
	self.threatenedPlayer = false
	self.threatenTime = nil
	self.playerIntroduced = false
	self.hostile = false
	self.id = id
	self.data = rivalGameCompanies.registeredByID[id]
	self.slanderCooldown = 0
	self.angerReasonAmounts = {}
	self.knownBribeChances = {}
	self.highestSkills = {}
	self.ownedBuildings = {}
	self.totalKnowledge = {}
	self.activeGameProjects = {}
	self.gameAwardWins = {}
	self.totalGameAwards = 0
	self.activeEmployees = {}
	self.activeEmployeesMap = {}
	self.employeeIter = 1
	self.threatRepRange = self.data.threatToPlayerOnReputation
	self.maxEmployees = self.data.maximumEmployees
	
	for key, knowledgeData in ipairs(knowledge.registered) do
		self.totalKnowledge[knowledgeData.id] = 0
	end
	
	self.canStealEmployees = true
	self.canSlander = true
	
	self:resetHighestSkillInfo()
	
	self.employeeCountByRole = {}
	
	for key, roleData in ipairs(attributes.profiler.roles) do
		self.employeeCountByRole[roleData.id] = 0
	end
	
	for reasonKey, reasonID in pairs(rivalGameCompany.ANGER_CHANGE_REASON) do
		self.angerReasonAmounts[reasonID] = 0
	end
	
	self.scheduledSlander = nil
	self.playerSuccessfulSlander = 0
	self.playerFailedSlander = 0
	self.playerStolenEmployees = 0
	self.playerFailedStolenEmployees = 0
	self.stolenEmployees = 0
	self.failedStolenEmployees = 0
	self.playerStealChanceMult = 1
	self.playerSlanderDiscoveryChanceMult = 1
	self.employees = table.reuse(self.employees)
	self.employeesByUID = table.reuse(self.employeesByUID)
	self.facts = table.reuse(self.facts)
	self.engines = table.reuse(self.engines)
	self.projects = table.reuse(self.projects)
	self.releasedGames = table.reuse(self.releasedGames)
	self.licensedPlatforms = table.reuse(self.licensedPlatforms)
	self.licensedPlatformsMap = table.reuse(self.licensedPlatformsMap)
	self.playerStealAttemptEmployees = table.reuse(self.playerStealAttemptEmployees)
	self.timeUntilEmployeeSwitch = table.reuse(self.timeUntilEmployeeSwitch)
	self.team = team.new()
	
	self.team:setOwner(self)
	self.team:setCanDismantle(false)
	self:initGenreThemeMasteries()
	self:initEventHandler()
	
	if procedural then
		self:applyRandomization()
	end
end

function rivalGameCompany:changeOpinion(change)
end

function rivalGameCompany:setOpinion(set)
end

function rivalGameCompany:getOpinion()
	return 1000
end

function rivalGameCompany:getCEO()
	return self.ceo
end

function rivalGameCompany:findCEO()
	local ceo = rivalGameCompany.CEO_ROLE
	
	for key, employee in ipairs(self.employees) do
		if employee:getRole() == ceo then
			self.ceo = employee
			
			break
		end
	end
end

function rivalGameCompany:createCEO()
	local employee = developer.new()
	
	employee:setLevel(self.data.ceoLevel)
	employee:setRole(rivalGameCompany.CEO_ROLE)
	
	if not self.data.maleCEO then
		employee:rollForFemale()
	end
	
	employee:createPortrait()
	employee:setRetirementAge(math.random(developer.RETIREMENT_AGE_MIN, developer.RETIREMENT_AGE_MAX))
	employee:setEmployer(self)
	employee:setOverallSkillProgressionMultiplier(rivalGameCompany.CEO_LEARN_SPEED_MULTIPLIER)
	employee:setAge(20)
	employee:setFact(rivalGameCompany.CEO_FACT, true)
	employee:assignUniqueID()
	employee:setBaseSalary(0)
	employee:setSalary(0)
	
	for key, skillData in ipairs(skills.registered) do
		employee:setSkillLevel(skillData.id, self.data.ceoSkillLevels or game.PLAYER_CHARACTER_STARTING_SKILL_LEVELS)
	end
	
	attributes.profiler:distributeAttributePoints(employee)
	attributes.profiler:rollPreferredGenres(employee)
	skills:updateSkillDevSpeedAffectors(employee)
	factValidity:validateEmployee(employee)
	traits:assignFittingTraits(employee)
	interests:assignToEmployee(employee)
	knowledge:assignFromInterests(employee)
	
	self.portrait = employee:getPortrait()
	
	self.portrait:createRandomAppearance(nil, employee:isFemale())
	
	self.ceo = employee
	
	return employee
end

function rivalGameCompany:getProjectByUniqueID(id)
	for key, projectObj in ipairs(self.projects) do
		if projectObj:getUniqueID() == id then
			return projectObj
		end
	end
	
	return nil
end

function rivalGameCompany:doBankruptcy()
	self:fileForBankruptcy()
end

function rivalGameCompany:addPlatformLicense(platformID)
	if not table.find(self.licensedPlatforms, platformID) then
		self.licensedPlatforms[#self.licensedPlatforms + 1] = platformID
	end
end

function rivalGameCompany:isGoingBankrupt()
	return self.funds < 0 or self.timeUntilDefunct
end

function rivalGameCompany:initBuildingOwnership(buildingID)
	local officeObject = game.worldObject:getOfficeObject(buildingID)
	
	officeObject:setRivalOwner(self.id)
	self:addOwnedBuilding(officeObject)
end

function rivalGameCompany:addOwnedBuilding(buildingObject)
	table.insert(self.ownedBuildings, buildingObject)
end

function rivalGameCompany:getOwnedBuildings()
	return self.ownedBuildings
end

function rivalGameCompany:setCanSlander(can)
	self.canSlander = can
end

function rivalGameCompany:setCanStealEmployees(can)
	self.canStealEmployees = can
end

function rivalGameCompany:setPlayerStealChanceMultiplier(mult)
	self.playerStealChanceMult = mult
end

function rivalGameCompany:setPlayerRivalSlanderDiscoveryChanceMultiplier(mult)
	self.playerSlanderDiscoveryChanceMult = mult
end

function rivalGameCompany:getPlayerRivalSlanderDiscoveryChanceMultiplier()
	return self.playerSlanderDiscoveryChanceMult
end

function rivalGameCompany:getAngerReasonAmount(id)
	return self.angerReasonAmounts[id]
end

function rivalGameCompany:lock()
	self:removeEventHandler()
end

function rivalGameCompany:unlock()
	self:initEventHandler()
end

function rivalGameCompany:remove()
	self:removeEventHandler()
	self:removeActiveProjects()
	self.team:remove()
	
	if self.frame and self.frame:isValid() then
		self.frame:kill()
	end
	
	self.frame = nil
	
	for key, projectObj in ipairs(self.projects) do
		projectObj:remove()
	end
	
	for key, projectObj in ipairs(self.releasedGames) do
		projectObj:remove()
	end
	
	for key, projectObj in ipairs(self.engines) do
		projectObj:remove()
	end
	
	for i = 1, #self.reservedGameNames / 2 do
		local last = table.remove(self.reservedGameNames, #self.reservedGameNames)
		local first = table.remove(self.reservedGameNames, #self.reservedGameNames)
		
		rivalGameCompanies:unreserveNameIDs(first, last)
	end
	
	while #self.employees > 0 do
		local employeeObj = self.employees[1]
		
		employeeObj:remove()
		table.remove(self.employees, 1)
	end
	
	table.clear(self.employeesByUID)
	table.clear(self.licensedPlatforms)
	table.clear(self.playerStealAttemptEmployees)
	table.clear(self.timeUntilEmployeeSwitch)
end

function rivalGameCompany:hangUp()
	self:changeAnger(rivalGameCompany.HANG_UP_ANGER_CHANGE, rivalGameCompany.ANGER_CHANGE_REASON.MISC)
	self:changeIntimidation(rivalGameCompany.HANG_UP_INTIMIDATION_CHANGE)
	self:changeRelationship(rivalGameCompany.HANG_UP_RELATIONSHIP_CHANGE)
end

function rivalGameCompany:insultAndHangUp()
	self:changeAnger(rivalGameCompany.INSULT_AND_HANG_UP_ANGER_CHANGE, rivalGameCompany.ANGER_CHANGE_REASON.MISC)
	self:changeIntimidation(rivalGameCompany.INSULT_AND_HANG_UP_INTIMIDATION_CHANGE)
	self:changeRelationship(rivalGameCompany.INSULT_AND_HANG_UP_RELATIONSHIP_CHANGE)
end

function rivalGameCompany:getReleasedGames()
	return self.releasedGames
end

function rivalGameCompany:getInitialCallDialogue()
	return self.data.initialCallDialogue
end

function rivalGameCompany:getCallDialogue()
	return self.data.callDialogue
end

function rivalGameCompany:showRecentGames()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setTitle(_format(_T("RIVAL_RECENT_GAMES_TITLE", "Recent 'COMPANY' Games"), "COMPANY", self:getName()))
	frame:setSize(400, 500)
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setSize(390, 460)
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setAdjustElementSize(true)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:addDepth(100)
	
	if #self.releasedGames > 0 then
		for key, gameObj in ipairs(self.releasedGames) do
			local selection = gui.create("GameProjectInfoSelection")
			
			selection:setWidth(370)
			selection:setProject(gameObj)
			scrollbar:addItem(selection)
		end
	else
		local title = gui.create("Category")
		
		title:setFont("bh24")
		title:setText(_T("NO_RECENTLY_RELEASED_GAMES", "No recently released games"))
		scrollbar:addItem(title)
	end
	
	frame:center()
	frameController:push(frame)
end

function rivalGameCompany:openEmployeeListCallback()
	self.company:createStealEmployeePopup()
end

function rivalGameCompany:viewRecentGamesCallback()
	self.company:showRecentGames()
end

function rivalGameCompany:openSlanderMenuCallback()
	self.company:createSlanderMenu()
end

function rivalGameCompany:callCEOCallback()
	if self.company:isAnnoyed() then
		local popup = game.createPopup(400, _T("CEO_NOT_ANSWERING_TITLE", "CEO Not Answering"), _T("CEO_NOT_ANSWERING_EXTRA", "The CEO is not answering your phone call. Try again tomorrow."), "pix24", "pix20", skipButton)
		
		frameController:push(popup)
	elseif not self.company:wasPlayerIntroduced() then
		self.company:startDialogue(self.company:getInitialCallDialogue())
	else
		self.company:startDialogue(self.company:getCallDialogue())
	end
end

function rivalGameCompany:buyOutCallback()
	if studio:getFunds() < self.cost then
		frameController:push(game.createPopup(500, _T("NOT_ENOUGH_FUNDS_TITLE", "Not Enough Funds"), _format(_T("BUYOUT_NOT_ENOUGH_FUNDS", "You do not have enough funds to buyout the rival.\n\nYou have $MONEY, but the buyout costs $COST"), "MONEY", string.comma(studio:getFunds()), "COST", string.comma(self.cost)), "pix24", "pix20", nil))
		
		return 
	end
	
	local costString = string.comma(self.cost)
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("CONFIRM_RIVAL_BUYOUT_TITLE", "Confirm Buyout"))
	popup:setTextFont("pix20")
	
	local baseSpace = false
	local left, right, extra = popup:getDescboxes()
	
	if self.timeUntilDefunct then
		popup:setText(_format(_T("CONFIRM_RIVAL_BUYOUT_DESC", "Buying out the rival will cost you $COST. You will attain all office buildings (if any) that belong to the rival, as well as the employees that work there, however there is no guarantee that the employees will sign the contract to work under you.\n\nThe rival will go bankrupt in TIME.\nAre you sure you want to continue?"), "COST", costString, "TIME", timeline:getTimePeriodText(self.timeUntilDefunct or 20)))
	else
		popup:setText(_format(_T("CONFIRM_RIVAL_BUYOUT_NON_BANKRUPT_DESC", "Buying out the rival will cost you $COST. You will attain all office buildings (if any) that belong to the rival, as well as the employees that work there, however there is no guarantee that the employees will sign the contract to work under you.\n\nAre you sure you want to continue?"), "COST", costString))
		extra:addSpaceToNextText(10)
		
		baseSpace = true
		
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_T("RIVAL_BUYOUT_PRICE_BANKRUPTCY_HINT", "Buying out a rival game company can be a lot cheaper when they file for bankruptcy."), "bh20", nil, 0, popup.rawW - 20, {
			{
				height = 22,
				icon = "question_mark",
				width = 22,
				x = 2
			}
		})
	end
	
	if not baseSpace then
		extra:addSpaceToNextText(10)
	end
	
	local hireable, workplaces = studio:getHireableEmployeeCount()
	
	workplaces = workplaces or 0
	
	local delta = #self.company:getEmployees() - workplaces
	
	if delta > 0 then
		local text
		
		if delta > 1 then
			text = _format(_T("RIVAL_BUYOUT_NOT_ENOUGH_WORKPLACES", "You are lacking workplaces for AMOUNT employees."), "AMOUNT", delta)
		else
			text = _T("RIVAL_BUYOUT_LACKING_1_WORKPLACE", "You are lacking 1 workplace.")
		end
		
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		extra:addText(text, "bh20", nil, 0, popup.rawW - 20, {
			{
				height = 22,
				icon = "exclamation_point_yellow",
				width = 22,
				x = 2
			}
		})
	end
	
	local button = popup:addButton("pix20", _format(_T("BUY_OUT_RIVAL", "Buyout rival for $COST"), "COST", costString), rivalGameCompany.confirmBuyOutCallback)
	
	button.target = self.company
	button.cost = self.cost
	
	popup:addButton("pix20", _T("DO_NOTHING", "Do nothing"), nil)
	popup:center()
	frameController:push(popup)
end

function rivalGameCompany:confirmBuyOutCallback()
	self.target:buyOut(self.cost)
end

function rivalGameCompany:fillInteractionComboBox(comboBox)
	comboBox:setAutoCloseTime(0.5)
	
	if interactionRestrictor:canPerformAction("player_steal_employees") then
		comboBox:addOption(0, 0, 200, 18, _T("VIEW_RIVAL_EMPLOYEES", "View employees"), fonts.get("pix20"), rivalGameCompany.openEmployeeListCallback).company = self
	end
	
	comboBox:addOption(0, 0, 200, 18, _T("VIEW_RECENT_GAMES", "View recent games"), fonts.get("pix20"), rivalGameCompany.viewRecentGamesCallback).company = self
	
	if interactionRestrictor:canPerformAction("player_slander") and not self:getScheduledPlayerSlander() then
		local option = comboBox:addOption(0, 0, 200, 18, _T("RIVAL_SLANDER_BUTTON", "Slander"), fonts.get("pix20"), rivalGameCompany.openSlanderMenuCallback)
		
		option.company = self
		
		option:setID(rivalGameCompany.SLANDER_OPTION_ID)
	end
	
	comboBox:addOption(0, 0, 200, 18, _T("CALL_CEO", "Call CEO"), fonts.get("pix20"), rivalGameCompany.callCEOCallback).company = self
	
	if interactionRestrictor:canPerformAction("buyout_rivals") then
		local option = comboBox:addOption(0, 0, 200, 18, _T("BUY_OUT", "Buyout"), fonts.get("pix20"), rivalGameCompany.buyOutCallback)
		
		option.timeUntilDefunct = self.timeUntilDefunct
		option.company = self
		option.cost = self:getBuyOutCost()
	end
	
	events:fire(rivalGameCompany.EVENTS.FILL_INTERACTION, comboBox, self)
end

function rivalGameCompany:markThreatenedPlayer()
	self.threatenedPlayer = true
	self.threatenTime = nil
end

function rivalGameCompany:getEngineByUniqueID(uniqueID)
	for key, engineObj in ipairs(self.engines) do
		if engineObj:getUniqueID() == uniqueID then
			return engineObj
		end
	end
	
	return nil
end

function rivalGameCompany:getEmployeeByUniqueID(id)
	return self.employeesByUID[id]
end

function rivalGameCompany:getRelationship()
	return self.relationship
end

function rivalGameCompany:changeRelationship(change)
	self.relationship = math.min(math.max(rivalGameCompanies.MIN_RELATIONSHIP, self.relationship + change), rivalGameCompanies.MAX_RELATIONSHIP)
end

function rivalGameCompany:markAskedAboutReviewers()
	self.askedAboutReviewers = true
end

function rivalGameCompany:hasAskedAboutReviewers()
	return self.askedAboutReviewers
end

function rivalGameCompany:getAngerForLegalAction()
	return self.data.angerForLegalAction
end

function rivalGameCompany:scheduleLegalAction()
	if self.legalActionState ~= rivalGameCompanies.LEGAL_ACTION_STATE.IMMINENT then
		self.legalActionState = rivalGameCompanies.LEGAL_ACTION_STATE.SCHEDULED
		
		events:fire(rivalGameCompany.EVENTS.SCHEDULED_COURT, self)
	end
	
	self.scheduledSlander = nil
end

function rivalGameCompany:scheduleLegalPlayerAction(noDialogue)
	self.legalPlayerActionState = rivalGameCompanies.LEGAL_ACTION_STATE.IMMINENT
	self.scheduledSlander = nil
	self.scheduledPlayerSlander = nil
	
	if not noDialogue then
		self:startDialogue(self.data.playerLegalActionDialogue)
	end
	
	events:fire(rivalGameCompany.EVENTS.SCHEDULED_COURT, self)
end

function rivalGameCompany:skipLegalAction()
	self.legalActionState = nil
end

function rivalGameCompany:markAsHostile()
	self.hostile = true
end

function rivalGameCompany:markPlayerIntroduced()
	self.playerIntroduced = true
end

function rivalGameCompany:wasPlayerIntroduced()
	return self.playerIntroduced
end

function rivalGameCompany:markCalledPlayer()
	self.hadCalledPlayer = true
end

function rivalGameCompany:getHadCalledPlayer()
	return self.hadCalledPlayer
end

function rivalGameCompany:isHostile()
	return self.relationship < 0 or self.hostile
end

function rivalGameCompany:setAnger(anger)
	self.anger = anger
end

function rivalGameCompany:getAnger()
	return self.anger
end

function rivalGameCompany:changeAnger(change, angerReason)
	self.anger = math.min(rivalGameCompany.MAX_ANGER, self.anger + change)
	
	if change > 0 then
		self.totalAnger = self.totalAnger + change
		self.relationshipRestoreCooldown = math.ceil(self.relationshipRestoreCooldown + change * rivalGameCompany.RELATIONSHIP_RESTORE_COOLDOWN_MULTIPLIER)
	end
	
	if change > 0 and (angerReason == rivalGameCompany.ANGER_CHANGE_REASON.EMPLOYEE_STEALING or angerReason == rivalGameCompany.ANGER_CHANGE_REASON.SLANDER) and not self.threatenedPlayer and not self.threatenTime and self.totalAnger >= self.data.retaliationFactor then
		local minmax = rivalGameCompany.THREATEN_TIME_AFTER_PROVOCATION
		
		self.threatenTime = timeline.curTime + math.random(minmax[1], minmax[2])
	end
	
	if angerReason then
		self.angerReasonAmounts[angerReason] = (self.angerReasonAmounts[angerReason] or 0) + 1
	end
end

function rivalGameCompany:changeIntimidation(change)
	self.intimidation = math.min(rivalGameCompany.MAX_INTIMIDATION, self.intimidation + change)
end

function rivalGameCompany:setIntimidation(new)
	self.intimidation = new
end

function rivalGameCompany:getSuccessfulSlander()
	return self.playerSuccessfulSlander
end

function rivalGameCompany:getFailedSlander()
	return self.playerFailedSlander
end

function rivalGameCompany:createEmployeeCountDisplay(list, font)
	local employeeDisplay = gui.create("GradientIconPanel", list, self)
	
	employeeDisplay:setIcon("employees")
	employeeDisplay:setFont(font)
	employeeDisplay:setText(string.easyformatbykeys(_T("RIVAL_GAME_COMPANY_EMPLOYEE_COUNT", "COUNT employees"), "COUNT", #self.employees))
	
	return employeeDisplay
end

function rivalGameCompany:startDialogue(dialogueID)
	local dialogueObject = dialogueHandler:addDialogue(dialogueID, _format(_T("CEO_OF_RIVAL_COMPANY", "'COMPANY' CEO"), "COMPANY", self:getName()), nil, nil)
	
	dialogueObject:setFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT, self)
	dialogueObject:setEmployee(self.ceo)
	dialogueObject:setPortrait(self.portrait)
	
	return dialogueObject
end

function rivalGameCompany:fillConversationOptions(dialogueObject, answerList)
	table.insert(answerList, "ask_ceo_about_reviewers")
	
	if studio:knowsOfRivalSlander(self.id) then
		table.insert(answerList, "player_legal_action_1_generic")
	end
end

function rivalGameCompany:updatePaycheckTime()
	local time = timeline.curTime
	
	for key, employee in ipairs(self.employees) do
		employee:setLastPaycheck(time)
		self:applyScheduledLeave(employee)
	end
end

function rivalGameCompany:initEventHandler()
	if rivalGameCompanies:isLocked() then
		return 
	end
	
	events:addFunctionReceiver(self, rivalGameCompany.handleNewDay, timeline.EVENTS.NEW_DAY)
end

function rivalGameCompany:removeEventHandler()
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_DAY)
end

function rivalGameCompany:fileForBankruptcy()
	self.timeUntilDefunct = rivalGameCompany.TIME_UNTIL_BANRKUPTCY
	
	local popup = game.createPopup(600, _T("RIVAL_GOING_DEFUNCT_TITLE", "Rival Filed For Bankruptcy"), _format(_T("RIVAL_GOING_DEFUNCT_DETAILED", "'COMPANY' has filed for bankruptcy. You can buy them out now and gain their office as well as their employees.\n\nThe buyout period ends in  DAYS."), "COMPANY", self:getName(), "DAYS", timeline:getTimePeriodText(self.timeUntilDefunct)), "pix24", "pix20", false)
	
	frameController:push(popup)
	events:fire(rivalGameCompany.EVENTS.FILED_FOR_BANKRUPTCY, self)
end

function rivalGameCompany:handleNewDay()
	if self.timeUntilDefunct then
		self.timeUntilDefunct = self.timeUntilDefunct - 1
		
		if self.timeUntilDefunct <= 0 then
			self:goDefunct()
		end
		
		return 
	end
	
	if self.annoyed then
		self.annoyed = false
	end
	
	if self.slanderSuspicion > 0 then
		self.slanderSuspicion = math.max(0, self.slanderSuspicion - rivalGameCompanies.SUSPICION_DROP_PER_DAY)
	end
	
	if self.relationshipRestoreCooldown > 0 then
		self.relationshipRestoreCooldown = self.relationshipRestoreCooldown - 1
	end
	
	if self.currentProject then
		local progressTime = timeline.SINGLE_DAY_DURATION * rivalGameCompany.PROGRESS_MULTIPLIER
		
		self.employeeIter = 1
		
		local activeList = self.activeEmployees
		
		for i = 1, #activeList do
			local dev = activeList[self.employeeIter]
			
			dev:update(1, progressTime)
			
			self.employeeIter = self.employeeIter + 1
		end
		
		self.team:progress(progressTime)
	end
	
	if self.threatenTime then
		self:markCalledPlayer()
		
		local dialogueObject = self:startDialogue(self.data.threatenDialogue)
		
		if not self.playerIntroduced then
			dialogueObject:hidePortrait()
		end
		
		self:markPlayerIntroduced()
		
		self.threatenTime = nil
		
		events:fire(rivalGameCompany.EVENTS.THREATENED_PLAYER, self, dialogueObject)
	end
	
	local curTime = timeline.curTime
	
	if #self.playerStealAttemptEmployees > 0 then
		local index = 1
		
		for i = 1, #self.playerStealAttemptEmployees do
			local employeeObj = self.playerStealAttemptEmployees[index]
			
			if curTime > employeeObj:getFact(rivalGameCompany.EMPLOYEE_STEAL_FACT) then
				self:finishPlayerStealAttempt(index, employeeObj)
			else
				index = index + 1
			end
		end
	end
	
	if #self.timeUntilEmployeeSwitch > 0 then
		local index = 1
		
		for i = 1, #self.timeUntilEmployeeSwitch do
			local employeeObj = self.timeUntilEmployeeSwitch[index]
			
			if curTime > employeeObj:getFact(rivalGameCompany.SWITCH_IN_TIME_FACT) then
				employeeObj:removeFact(rivalGameCompany.SWITCH_IN_TIME_FACT)
				self:fireEmployee(employeeObj, nil)
				self:finishEmployeeSwitch(employeeObj)
				table.remove(self.timeUntilEmployeeSwitch, index)
			else
				index = index + 1
			end
		end
	end
end

function rivalGameCompany:finishEmployeeSwitch(employee)
	employee:removeFact(rivalGameCompany.SWITCH_IN_TIME_FACT)
	
	if studio:getEmployeeByUniqueID(employee:getUniqueID()) then
		return 
	end
	
	studio:hireEmployee(employee)
	
	local popup = game.createPopup(600, _T("RIVAL_GAME_EMPLOYEE_ARRIVED_TITLE", "Persuaded Employee in Office"), _format(_T("RIVAL_GAME_EMPLOYEE_ARRIVED_DETAILED", "NAME has finished work at 'COMPANY' and is now available in the office starting today."), "NAME", employee:getFullName(true), "COMPANY", self:getName()), "pix24", "pix20", false)
	
	frameController:push(popup)
end

function rivalGameCompany:handleEvent(event, employee)
	if self.timeUntilDefunct then
		return 
	end
	
	if event == developer.EVENTS.SALARY_CHANGED and employee:getEmployer() == self then
		self:calculateTotalSalaries()
	end
	
	if event == rivalGameCompany.SLANDER_ATTEMPT_EVENT then
		print("woah?", self.canSlander, self.canSlander, self:canAttemptSlander())
		
		if self.canSlander and self:canAttemptSlander() then
			self:attemptSlander()
		end
	end
	
	if event == timeline.EVENTS.NEW_WEEK then
		if self.legalActionState == rivalGameCompanies.LEGAL_ACTION_STATE.SCHEDULED then
			self.legalActionState = rivalGameCompanies.LEGAL_ACTION_STATE.IMMINENT
			
			self:startDialogue(self.data.legalActionDialogue)
		elseif self.legalActionState == rivalGameCompanies.LEGAL_ACTION_STATE.IMMINENT then
			self:finishLegalAction(studio)
			
			self.legalActionState = nil
		elseif self.legalPlayerActionState == rivalGameCompanies.LEGAL_ACTION_STATE.IMMINENT then
			studio:finishLegalAction(self)
			
			self.legalPlayerActionState = nil
		end
		
		if self.scheduledPlayerSlander then
			local data = rivalGameCompanies.registeredSlanderByID[self.scheduledPlayerSlander]
			local success, foundOut, reputationDrop = data:finishSlander(studio, self)
			
			conversations:addTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_PLAYER_SLANDER_ID)
			
			self.scheduledPlayerSlander = nil
			
			if success then
				self.playerSuccessfulSlander = self.playerSuccessfulSlander + 1
				
				local curIndex = 1
				local employees = self.employees
				
				for i = 1, #employees do
					local employee = employees[curIndex]
					
					if employee:canLeaveDueToLowReputation() then
						self:fireEmployee(employee)
						self:returnToEmployeeCirculation(employee)
					else
						curIndex = curIndex + 1
					end
				end
			else
				self.playerFailedSlander = self.playerFailedSlander + 1
			end
			
			if foundOut then
				self.foundOutPlayerSlander = true
				self.mostRecentFoundOutPlayerSlander = timeline.curTime
				self.slanderCooldown = 0
			elseif self.foundOutPlayerSlander then
				self.mostRecentFoundOutPlayerSlander = timeline.curTime
			end
			
			self:createPlayerSlanderResultPopup(reputationDrop, success, data)
			events:fire(rivalGameCompany.EVENTS.PERFORMED_SLANDER, studio)
			
			if foundOut then
				events:fire(rivalGameCompany.EVENTS.SLANDER_FOUND_OUT, studio)
			end
		end
		
		if self.scheduledSlander then
			local data = rivalGameCompanies.registeredSlanderByID[self.scheduledSlander]
			local success, foundOut, reputationDrop = data:finishSlander(self, studio)
			
			conversations:addTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_SLANDER_ID)
			
			if foundOut then
				self:markAsHostile()
			end
			
			self:deductFunds(data:getCost())
			
			self.scheduledSlander = nil
			self.mostRecentFoundOutPlayerSlander = nil
			
			self:createSlanderResultPopup(reputationDrop, success, foundOut, data)
			events:fire(rivalGameCompany.EVENTS.PERFORMED_SLANDER, self)
			
			if foundOut then
				events:fire(rivalGameCompany.EVENTS.SLANDER_FOUND_OUT, self)
			end
		end
		
		if self.currentProject then
			if self.currentProject:isDone() then
				self:releaseGameProject()
			else
				self:performAdvertisement(self.currentProject)
			end
		elseif timeline.curTime >= self.nextProjectTime then
			self:beginNewProject()
		end
	elseif event == timeline.EVENTS.NEW_MONTH then
		if self.relationshipRestoreCooldown == 0 and self.relationship < 0 then
			self:changeRelationship(self.data.relationshipRestoreAmount)
			
			self.relationship = math.min(self.relationship, 0)
		end
		
		local hadMoney = self.funds > 0
		
		if self.firstPaymentDone then
			local curIndex = 1
			local curTime = timeline.curTime
			local ceoRetired = false
			local employees = self.employees
			local leaveFact = rivalGameCompany.SCHEDULED_LEAVE_FACT
			
			for i = 1, #employees do
				local employee = employees[curIndex]
				
				self.spentInSalaries = self.spentInSalaries + employee:receivePaycheck()
				
				if employee:canRetire() then
					if not employee:getFact(rivalGameCompany.SWITCH_IN_TIME_FACT) then
						employee:retire()
						
						if employee:getFact(rivalGameCompany.CEO_FACT) then
							ceoRetired = true
						end
					else
						curIndex = curIndex + 1
					end
				else
					local leaveTime = employee:getFact(leaveFact)
					
					if leaveTime then
						if leaveTime < curTime then
							self:fireEmployee(employee)
							self:returnToEmployeeCirculation(employee)
						else
							curIndex = curIndex + 1
						end
					else
						curIndex = curIndex + 1
					end
				end
			end
			
			if ceoRetired then
				self:hireEmployee(self:createCEO())
			end
		else
			self.firstPaymentDone = true
		end
		
		if self.funds < 0 then
			if hadMoney then
				self:releaseUnreleasedGameProject()
			else
				self:handleBankruptcy()
			end
		else
			self:hireEmployees()
		end
		
		if self.currentProject and not self.bribeRevealed then
			local reviewers = review:getReviewers()
			
			if #reviewers > 0 then
				local reviewer = reviewers[math.random(1, #reviewers)]
				
				if not reviewer:getBribeChancesRevealed() and reviewer:attemptRevealFakeBribe(self) then
					self.knownBribeChances[reviewer:getID()] = true
					self.bribeRevealed = true
					
					self:decreaseReputation(self.reputation * rivalGameCompanies.REPUTATION_LOSS_ON_BRIBE_REVEAL)
				end
			end
		end
	end
	
	if event == rivalGameCompany.EMPLOYEE_STEAL_ATTEMPT_EVENT and self:canAttemptStealEmployee() then
		self:attemptStealEmployee()
	end
end

function rivalGameCompany:knowsReviewerBribeChances(reviewerID)
	return self.knownBribeChances[reviewerID]
end

function rivalGameCompany:hasFoundOutPlayerSlander()
	return self.foundOutPlayerSlander
end

function rivalGameCompany:isPlayer()
	return false
end

function rivalGameCompany:removeEmployeeFromTeam()
end

local removedNames = {}

function rivalGameCompany:applyRandomization()
	math.random(1, #rivalGameCompany.PREMADE_NAMES)
	
	for key, rivalObj in ipairs(rivalGameCompanies:getCompanies()) do
		local idx = rivalObj:getNameIndex()
		
		if idx then
			local name = rivalObj:getName()
			
			table.removeObject(rivalGameCompany.PREMADE_NAMES, name)
			table.insert(removedNames, name)
		end
	end
	
	self:setNameIndex(math.random(1, #rivalGameCompany.PREMADE_NAMES))
	
	for key, name in ipairs(removedNames) do
		rivalGameCompany.PREMADE_NAMES[#rivalGameCompany.PREMADE_NAMES + 1] = name
		removedNames[key] = nil
	end
	
	local repRange = rivalGameCompany.REP_MULT_RANGE
	local repRangeLower = rivalGameCompany.LOWER_REP_MULT_RANGE
	
	self:increaseReputation(math.max(self.data.startingReputation * math.randomf(repRangeLower[1], repRangeLower[2]), math.floor(studio:getReputation() * math.randomf(repRange[1], repRange[2]))))
	
	local cashRange = rivalGameCompany.CASH_MULT_RANGE
	
	self.funds = math.max(self.data.startingFunds, math.floor(studio:getFunds() * math.randomf(cashRange[1], cashRange[2])))
	
	if self.data.threatToPlayerOnReputation ~= math.huge then
		local threatRange = rivalGameCompany.THREAT_REP_MULT_RANGE
		
		self.threatRepRange = math.floor(self.data.threatToPlayerOnReputation * math.randomf(threatRange[1], threatRange[2]))
	end
	
	local configEmployees = self.data.maximumEmployees
	local emplRange = rivalGameCompany.MAX_EMPLOYEES_MULT_RANGE
	
	self.maxEmployees = math.min(rivalGameCompany.MAX_GENERATION_EMPLOYEES, math.max(configEmployees, math.floor(#studio:getEmployees() * math.randomf(emplRange[1], emplRange[2]))))
	
	local totalPeople = 0
	
	for key, data in ipairs(self.data.startingEmployees) do
		totalPeople = totalPeople + (data.repeatFor or 1)
	end
	
	local startMult = rivalGameCompany.STARTING_EMPLOYEES_MULT
	local startMultMax = rivalGameCompany.STARTING_EMPLOYEES_MULT_MAX_EMPLOYEES
	local employeeMultiplier = math.max(self.maxEmployees * math.randomf(startMultMax[1], startMultMax[2]), totalPeople * math.randomf(startMult[1], startMult[2])) / totalPeople
	local levelOffsetRange = rivalGameCompany.LEVEL_OFFSET_RANGE
	local employeeLevelOffset = math.random(levelOffsetRange[1], levelOffsetRange[2])
	
	if employeeMultiplier > 1 then
		employeeCirculation:generateEmployeesFromConfig(self.data.startingEmployees, self, employeeMultiplier, employeeLevelOffset)
	else
		employeeCirculation:generateEmployeesFromConfig(self.data.startingEmployees, self, nil, employeeLevelOffset)
	end
	
	self:rollRandomCostOffset()
	
	local genreRange = rivalGameCompany.GENRE_MASTERY_RANGE
	local themeRange = rivalGameCompany.THEME_MASTERY_RANGE
	local genre, theme = genres.registered[math.random(1, #genres.registered)], themes.registered[math.random(1, #themes.registered)]
	
	self.genreMastery[genre] = math.randomf(genreRange[1], genreRange[2])
	self.themeMastery[theme] = math.randomf(themeRange[1], themeRange[2])
	
	self:hireEmployee(self:createCEO())
end

function rivalGameCompany:rollRandomCostOffset()
	local buyoutCostRange = rivalGameCompany.BUYOUT_COST_MULT_RANGE
	
	self.baseBuyoutCost = math.randomf(buyoutCostRange[1], buyoutCostRange[2]) * math.max(rivalGameCompany.MINIMUM_BUYOUT_COST, studio:getFunds())
end

function rivalGameCompany:setNameIndex(id)
	self.nameIndex = id
	self.name = rivalGameCompany.PREMADE_NAMES[id]
end

function rivalGameCompany:getNameIndex()
	return self.nameIndex
end

function rivalGameCompany:applyStartingStats()
	self.funds = self.data.startingFunds
	
	self:increaseReputation(self.data.startingReputation)
	employeeCirculation:generateEmployeesFromConfig(self.data.startingEmployees, self)
	self:hireEmployee(self:createCEO())
end

function rivalGameCompany:hireEmployee(employeeObject)
	employeeObject:setLastPaycheck(timeline.curTime)
	employeeObject:setEmployer(self)
	employeeObject:setHireTime(timeline.curTime)
	employeeObject:onHired()
	self:addEmployee(employeeObject)
	self:applyScheduledLeave(employeeObject)
	self:calculateTotalSalaries()
end

function rivalGameCompany:applyScheduledLeave(employeeObj)
	if employeeObj:getFact(rivalGameCompany.CEO_FACT) or self.employeeCountByRole[employeeObj:getRole()] == 1 then
		return 
	end
	
	if math.random(1, 100) <= rivalGameCompany.SCHEDULED_LEAVE_FACT_CHANCE then
		employeeObj:setFact(rivalGameCompany.SCHEDULED_LEAVE_FACT, timeline.curTime + math.random(self.data.employeeCirculation.leaveTime[1], self.data.employeeCirculation.leaveTime[2]))
	end
end

function rivalGameCompany:fireEmployee(employee, leaveReason)
	leaveReason = leaveReason or studio.EMPLOYEE_LEAVE_REASONS.FIRED
	
	local leaveTime = employee:getFact(rivalGameCompany.SWITCH_IN_TIME_FACT)
	local stealTime = employee:getFact(rivalGameCompany.EMPLOYEE_STEAL_FACT)
	
	self:removeEmployee(employee)
	employee:removeEventHandler()
	employee:postLeaveStudio()
	
	if self.currentProject then
		self.team:unassignEmployees()
		self.team:assignFreeEmployees()
	end
	
	if leaveTime then
		table.removeObject(self.timeUntilEmployeeSwitch, employee)
		self:finishEmployeeSwitch(employee)
	end
	
	if stealTime then
		table.removeObject(self.playerStealAttemptEmployees, employee)
		self:finishEmployeeSwitch(employee)
	end
end

function rivalGameCompany:removeAllEmployeeFacts(employee)
	employee:removeFact(rivalGameCompany.SCHEDULED_LEAVE_FACT)
	employee:removeFact(rivalGameCompany.EMPLOYEE_STEAL_FACT)
	employee:removeFact(rivalGameCompany.OFFERED_MONEY_FACT)
	employee:removeFact(rivalGameCompany.SWITCH_IN_TIME_FACT)
	employee:removeFact(rivalGameCompany.PLAYER_STEAL_COOLDOWN_FACT)
end

function rivalGameCompany:returnToEmployeeCirculation(employee, successChance)
	if not employee:getEmployer() then
		if successChance and successChance >= math.random(1, 100) or not successChance then
			employeeCirculation:addJobSeeker(employee, nil)
		else
			employee:setTask(nil)
			employee:remove()
		end
	end
end

function rivalGameCompany:addEmployee(employee, skipUpdate)
	if self.employeesByUID[employee:getUniqueID()] or table.find(self.employees, employee) then
		error("attempt to insert duplicate employee")
	end
	
	table.insert(self.employees, employee)
	employee:setDrive(developer.MAX_DRIVE)
	
	self.employeesByUID[employee:getUniqueID()] = employee
	
	employee:setEmployer(self)
	self:changeEmployeeRoleCount(employee:getRole(), 1)
	self:updateHighestEmployeeSkills(employee)
	self.team:addMember(employee, skipUpdate)
	self:changeKnowledgeLevel(employee, 1)
end

function rivalGameCompany:removeEmployee(employee, key)
	if key then
		table.remove(self.employees, key)
	else
		table.removeObject(self.employees, employee)
	end
	
	self:removeActiveDeveloper(employeeObj)
	
	self.employeesByUID[employee:getUniqueID()] = nil
	
	self:removeAllEmployeeFacts(employee)
	self.team:removeMember(employee)
	employee:setEmployer(nil)
	self:changeEmployeeRoleCount(employee:getRole(), -1)
	self:recountHighestSkills(self.employees)
	self:changeKnowledgeLevel(employee, -1)
end

function rivalGameCompany:deductFunds(amount)
	self.funds = self.funds - amount
end

rivalGameCompany.removeFunds = rivalGameCompany.deductFunds

function rivalGameCompany:addFunds(amount)
	self.funds = self.funds + amount
end

rivalGameCompany.increaseFunds = rivalGameCompany.addFunds

function rivalGameCompany:setFunds(amount)
	self.funds = amount
end

function rivalGameCompany:getFunds()
	return self.funds
end

function rivalGameCompany:removeProject(projectObject)
	table.removeObject(self.projects, projectObject)
end

function rivalGameCompany:addProject(projectObject)
	if table.find(self.projects, projectObject) then
		return 
	end
	
	table.insert(self.projects, projectObject)
end

function rivalGameCompany:addEngine(projectObject)
end

function rivalGameCompany:removeEngine(projectObject)
end

function rivalGameCompany:addGame(gameProject)
end

function rivalGameCompany:increaseReputation(amount)
	self.reputation = self.reputation + amount
	
	self:capReputation()
end

function rivalGameCompany:decreaseReputation(amount)
	self.reputation = self.reputation - amount
	
	self:capReputation()
end

function rivalGameCompany:getAverageGameScore()
	local total = 0
	
	for key, gameProj in ipairs(self.releasedGames) do
		local averageScore = gameProj:getReviewRating()
		
		if averageScore > 0 then
			total = total + averageScore
		end
	end
	
	return math.min(total / #self.releasedGames, 0)
end

function rivalGameCompany:capReputation()
	return math.max(self.reputation, 0)
end

function rivalGameCompany:getReputation()
	return self.reputation
end

function rivalGameCompany:getEmployees()
	return self.employees
end

function rivalGameCompany:postInitWorld()
end

function rivalGameCompany:postKillRivalDefunct()
	events:fire(rivalGameCompany.EVENTS.RIVAL_DEFUNCT_POPUP_CLOSED, self.rival)
end

function rivalGameCompany:removeActiveProjects()
	local projects = self.activeGameProjects
	
	for i = 1, #self.activeGameProjects do
		local projectObj = projects[1]
		
		projectObj:onRanOutMarketTime()
		projectObj:remove()
	end
end

eventBoxText:registerNew({
	id = "rival_gone_bankrupt",
	getText = function(self, data)
		return _format(_T("RIVAL_GONE_BANKRUPT", "'RIVAL' has gone defunct. Most its employees should now be up for hire."), "RIVAL", data)
	end
})

function rivalGameCompany:goDefunct()
	self.defunct = timeline.curTime
	
	self:removeEventHandler()
	self:removeActiveProjects()
	
	while #self.employees > 0 do
		local employee = self.employees[1]
		
		self:fireEmployee(employee)
		
		if not employee:getFact(rivalGameCompany.CEO_FACT) then
			self:returnToEmployeeCirculation(employee, rivalGameCompany.RETURN_TO_EMPLOYEE_CIRCULATION_CHANCE_ON_DEFUNCT)
		end
	end
	
	for key, buildingObject in ipairs(self.ownedBuildings) do
		buildingObject:setRivalOwner(nil)
		
		local objectList = buildingObject:getObjects()
		local key = 1
		
		for i = 1, #objectList do
			local object = objectList[key]
			
			if object:getObjectType() == employeeAssignment.VALID_WORKPLACE_TYPE then
				object:remove()
			else
				key = key + 1
			end
		end
		
		self.ownedBuildings[key] = nil
	end
	
	rivalGameCompanies:onCompanyDefunct(self)
	
	if self.hostile then
		local popup = game.createPopup(600, _T("RIVAL_GONE_DEFUNCT_TITLE", "Rival Defunct"), _format(_T("RIVAL_GONE_DEFUNCT_DETAILED", "One of your rivals, 'RIVAL', has gone defunct due to monetary problems. Most employees the rival had should now be hireable."), "RIVAL", self:getName()), "pix24", "pix20", nil)
		
		popup.rival = self
		popup.postKill = rivalGameCompany.postKillRivalDefunct
		
		frameController:push(popup)
	else
		local element = game.addToEventBox("rival_gone_bankrupt", self:getName(), 1, nil, "exclamation_point")
		
		element:setFlash(true, true)
		events:fire(rivalGameCompany.EVENTS.RIVAL_DEFUNCT_POPUP_CLOSED, self)
	end
end

function rivalGameCompany:getBuyOutCost()
	local buildingCost = 0
	
	for key, buildingObject in ipairs(self.ownedBuildings) do
		buildingCost = buildingCost + buildingObject:getCost()
		
		for key, object in ipairs(buildingObject:getObjects()) do
			if object:getObjectType() == employeeAssignment.VALID_WORKPLACE_TYPE then
				buildingCost = buildingCost + object:getCost()
			end
		end
	end
	
	local empCost = 0
	
	for key, employee in ipairs(self.employees) do
		empCost = empCost + employee:getSalary()
	end
	
	buildingCost = buildingCost + empCost * rivalGameCompany.BUYOUT_SALARY_MULTIPLIER
	
	if not self.timeUntilDefunct then
		buildingCost = buildingCost * self.data.preBankruptBuyoutCostMultiplier
	end
	
	if self.baseBuyoutCost then
		buildingCost = buildingCost + self.baseBuyoutCost
	end
	
	return buildingCost
end

local switchableEmployees = {}

function rivalGameCompany:postBuyoutRival()
	events:fire(rivalGameCompany.EVENTS.RIVAL_BUYOUT_POPUP_CLOSED, self.rival)
end

function rivalGameCompany:buyOut(cost)
	studio:deductFunds(cost, nil, "office_expansion")
	
	self.boughtOut = true
	
	local newTeam = team.new()
	
	newTeam:setName(_format(_T("RIVAL_COMPANY_TEAM", "'RIVAL' team"), "RIVAL", self:getName()))
	studio:addTeam(newTeam, false)
	
	local skipAssignment = self.ownedBuildings[1] == nil
	local employeeCount = #self.employees
	
	while #self.employees > 0 do
		local employee = self.employees[1]
		
		self:fireEmployee(employee)
		
		if not employee:getFact(rivalGameCompany.CEO_FACT) and not studio:getEmployeeByUniqueID(employee:getUniqueID()) then
			if math.random(1, 100) <= employeeCirculation:getAcceptChance(employee) then
				studio:hireEmployee(employee, newTeam, true)
				
				switchableEmployees[#switchableEmployees + 1] = employee
			else
				self:returnToEmployeeCirculation(employee, rivalGameCompany.RETURN_TO_EMPLOYEE_CIRCULATION_CHANCE_ON_DEFUNCT)
			end
		end
	end
	
	for key, buildingObject in ipairs(self.ownedBuildings) do
		buildingObject:onPurchased()
		buildingObject:upgradeWorkplaces()
	end
	
	if not skipAssignment and #switchableEmployees > 0 then
		employeeAssignment:assignTeamToOffice(newTeam, self.ownedBuildings[1])
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("RIVAL_BUYOUT_RESULTS_TITLE", "Buyout Results"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("RIVAL_BUYOUT_RESULTS_DESC", "You've bought out the assets of 'RIVAL'.\nOut of EMPLOYEES employees SWITCHED have signed the contract to work in your studio, the rest left to seek work elsewhere.\n\nThe new employees have been assigned to a new team named 'TEAM'."), "RIVAL", self:getName(), "EMPLOYEES", employeeCount, "SWITCHED", #switchableEmployees, "TEAM", newTeam:getName()))
	
	if #switchableEmployees > 0 then
		local unassigned = 0
		
		for key, dev in ipairs(switchableEmployees) do
			if not dev:getWorkplace() then
				unassigned = unassigned + 1
			end
		end
		
		if unassigned > 0 then
			local left, right, extra = popup:getDescboxes()
			local text
			
			if unassigned == 1 then
				text = _T("POST_BUYOUT_TRANSFER_1_EMPLOYEE", "1 employee is without a workplace.")
			else
				text = _format(_T("POST_BUYOUT_TRANSFER_MULTIPLE_EMPLOYEES", "EMPLOYEES employees are without a workplace."), "EMPLOYEES", unassigned)
			end
			
			extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
			extra:addText(text, "bh20", nil, 0, popup.rawW - 20, {
				{
					height = 22,
					icon = "exclamation_point_yellow",
					width = 22,
					x = 2
				}
			})
		end
	end
	
	popup:addOKButton("pix20")
	popup:hideCloseButton()
	
	popup.rival = self
	popup.postKill = rivalGameCompany.postBuyoutRival
	
	popup:center()
	frameController:push(popup)
	studio:onBoughtOutCompany(self)
	table.clearArray(switchableEmployees)
	rivalGameCompanies:onCompanyDefunct(self)
	achievements:attemptSetAchievement(achievements.ENUM.BUYOUT_RIVAL)
end

function rivalGameCompany:getID()
	return self.id
end

function rivalGameCompany:getReconsiderLegalActionState()
	local playerLostRep = studio:getSlanderReputationLoss(self.data.id)
	local ourLostRep = self.slanderReputationLoss
	
	if playerLostRep >= 0 and ourLostRep == 0 then
		return rivalGameCompany.RECONSIDERATION_STATE.RECONSIDER
	end
	
	local reputationLossDelta = playerLostRep - ourLostRep
	
	if math.abs(reputationLossDelta) >= self.data.legalActionReconsiderReputationDifference then
		return rivalGameCompany.RECONSIDERATION_STATE.RECONSIDER
	end
	
	return rivalGameCompany.RECONSIDERATION_STATE.TAUNT
end

function rivalGameCompany:resetRivalry()
	self.hostile = false
	self.anger = 0
	self.intimidation = 0
	self.relationship = 0
	self.legalActionState = nil
	self.threatenTime = nil
	self.scheduledSlander = nil
	self.legalPlayerActionState = nil
	self.legalActionState = nil
	
	studio:clearRivalSlanderKnowledge(self:getID())
	achievements:attemptSetAchievement(achievements.ENUM.RIVAL_PEACE)
	
	self.disabledEmployeeStealing = true
end

function rivalGameCompany:getName()
	if self.name then
		return self.name
	end
	
	return self.data.name
end

function rivalGameCompany:setFact(fact, value)
	if value == nil then
		value = true
	end
	
	self.facts[fact] = value
end

function rivalGameCompany:getFact(fact)
	return self.facts[fact]
end

function rivalGameCompany:initGenreThemeMasteries()
	self.themeMastery = {}
	self.genreMastery = {}
	
	for key, themeData in ipairs(themes.registered) do
		self.themeMastery[themeData.id] = 1
	end
	
	for key, genreData in ipairs(genres.registered) do
		self.genreMastery[genreData.id] = 1
	end
end

function rivalGameCompany:getCurrentProject()
	return self.currentProject
end

function rivalGameCompany:improveMastery()
	local gameProj = self.currentProject
	local theme, genre = gameProj:getTheme(), gameProj:getGenre()
	
	self.genreMastery[genre] = math.min(1, self.genreMastery[genre] + rivalGameCompany.GENRE_MASTERY_INCREASE)
	self.themeMastery[theme] = math.min(1, self.themeMastery[theme] + rivalGameCompany.THEME_MASTERY_INCREASE)
end

function rivalGameCompany:getReputationSaleMultiplier()
	return math.max(math.min(self.reputation / studio.REPUTATION_TO_SALE_MULTIPLIER_DIVIDER, studio.MAX_REPUTATION_TO_SALE_MULTIPLIER), 1)
end

function rivalGameCompany:canThreatenPlayer()
	return studio:getReputation() >= self.threatRepRange
end

function rivalGameCompany:hireEmployees()
	if #self.employees >= self.maxEmployees or timeline.curTime < self.nextHireTime then
		return 
	end
	
	local monthsInSalaries, totalExpenses = self:getMonthsInSalaries(0)
	
	if monthsInSalaries > rivalGameCompany.HIRE_EMPLOYEE_ON_AFFORDABLE_SALARIES then
		local avgSalary = totalExpenses / monthsInSalaries
		local delta = math.max(0, monthsInSalaries - rivalGameCompany.HIRE_EMPLOYEE_ON_AFFORDABLE_SALARIES)
		local maxSalary = avgSalary + delta / monthsInSalaries * avgSalary
		local lowestSkills = self.team:getLowestSkills()
		local lowestSkill, lowestLevel = nil, math.huge
		
		for skillID, level in pairs(self.team:getTotalSkills()) do
			local skillData = skills.registeredByID[skillID]
			
			if skillData.developmentSkill and lowestLevel > level / skillData.rivalWeight then
				lowestSkill = skillID
				lowestLevel = level / skillData.rivalWeight
			end
		end
		
		lowestLevel = lowestSkills[lowestSkill] - self.data.maximumEmployeeSkillRange
		
		local highestSkill = self.team:getHighestSkillLevels()[lowestSkill]
		local highestWeight, bestEmployee = 0
		local rolesByID = attributes.profiler.rolesByID
		
		for key, jobSeeker in ipairs(employeeCirculation:getJobSeekers()) do
			if not jobSeeker:hasOfferedWork() and rolesByID[jobSeeker:getRole()].mainSkill == lowestSkill then
				local level = jobSeeker:getSkillLevel(lowestSkill)
				
				if lowestLevel <= level then
					local weight = level / jobSeeker:getSalary() * (level / highestSkill)
					
					if highestWeight < weight then
						highestWeight = weight
						bestEmployee = jobSeeker
					end
				end
			end
		end
		
		if bestEmployee then
			self:hireEmployee(bestEmployee)
			employeeCirculation:removeEmployee(bestEmployee)
			
			self.nextHireTime = timeline.curTime + rivalGameCompany.HIRE_EMPLOYEE_COOLDOWN
		end
	end
end

rivalGameCompany.filteredAvailableNames = {}
rivalGameCompany.filteredLastNames = {}
rivalGameCompany.MAX_GAME_NAME_RESERVES = 8

function rivalGameCompany:reserveGameNames()
	local filteredNames = self.filteredAvailableNames
	local filteredLast = self.filteredLastNames
	local reservedIDs = rivalGameCompanies:getReservedNameIDs()
	
	self.reservedGameNames = {}
	self.gameNameCounts = {}
	
	local lastNames = rivalGameCompany.GAME_LAST_NAME
	
	for key, name in ipairs(rivalGameCompany.GAME_FIRST_NAME) do
		local subTable = reservedIDs[key]
		
		if subTable then
			for lastKey, lastName in ipairs(lastNames) do
				if not subTable[lastKey] then
					filteredLast[#filteredLast + 1] = lastKey
				end
			end
		else
			for lastKey, lastName in ipairs(lastNames) do
				filteredLast[#filteredLast + 1] = lastKey
			end
		end
		
		if #filteredLast > 0 then
			filteredNames[#filteredNames + 1] = key
			filteredNames[#filteredNames + 1] = table.remove(filteredLast, math.random(1, #filteredLast))
			
			table.clearArray(filteredLast)
		end
	end
	
	for i = 1, math.min(rivalGameCompany.MAX_GAME_NAME_RESERVES, #filteredNames / 2) do
		local randomIndex = math.random(1, #filteredNames / 2)
		local index = randomIndex * 2 - 1
		local first = table.remove(filteredNames, index)
		local last = table.remove(filteredNames, index)
		
		table.insert(self.reservedGameNames, first)
		table.insert(self.reservedGameNames, last)
		rivalGameCompanies:reserveNameIDs(first, last)
	end
	
	table.clearArray(filteredNames)
end

function rivalGameCompany:generateGameName(gameProj)
	local nameIndex = math.random(1, #self.reservedGameNames / 2) * 2 - 1
	local first = self.reservedGameNames[nameIndex]
	local last = self.reservedGameNames[nameIndex + 1]
	local count = self.gameNameCounts[first]
	
	if count then
		count = count + 1
		self.gameNameCounts[first] = count
	else
		count = 1
		self.gameNameCounts[first] = 1
	end
	
	local gameName = self:finalizeGameName(first, last, count)
	
	gameProj:setName(gameName)
end

function rivalGameCompany:finalizeGameName(first, last, gameCount)
	local firstName = rivalGameCompany.GAME_FIRST_NAME[first]
	local lastName = rivalGameCompany.GAME_LAST_NAME[last]
	local append = false
	
	if gameCount > 1 then
		if string.find(firstName, "REPLACE") then
			firstName = _format(firstName, "REPLACE", gameCount)
		elseif string.find(lastName, "REPLACE") then
			lastName = _format(lastName, "REPLACE", gameCount)
		else
			append = true
		end
	end
	
	if append then
		return _format("FIRST LAST COUNT", "FIRST", firstName, "LAST", lastName, "COUNT", gameCount)
	end
	
	return _format("FIRST LAST", "FIRST", firstName, "LAST", lastName)
end

function rivalGameCompany:beginNewProject()
	if self.currentProject then
		return 
	end
	
	self:purchasePlatformLicenses()
	
	self.currentEngine = engineLicensing:generateEngine(nil, rivalGameCompany.USED_ENGINE_FEATURE_COUNT_MULTIPLIER)
	
	self.currentEngine:assignUniqueID()
	self.currentEngine:setOwner(self)
	self.currentEngine:setName(_T("IN_HOUSE_ENGINE", "In-house engine"))
	table.insert(self.engines, self.currentEngine)
	table.insert(self.projects, self.currentEngine)
	
	self.currentProject = gameProject.new(self)
	
	self.currentProject:setProjectType("game_project")
	self:generateGameName(self.currentProject)
	self.currentProject:assignUniqueID()
	self.currentProject:setEngine(self.currentEngine:getUniqueID(), self.currentEngine)
	self:addProject(self.currentProject)
	
	local genre, theme = self:pickGenreAndTheme()
	
	self.currentProject:setGenre(genre)
	self.currentProject:setTheme(theme)
	self:pickPlatforms()
	self.currentProject:setAudience(self:selectProjectAudience())
	self:fillProjectWithDesiredFeatures()
	self.team:setProject(self.currentProject, 1, gameProject.DEVELOPMENT_TYPE.NEW)
end

function rivalGameCompany:getProjects()
	return self.projects
end

function rivalGameCompany:releaseGameProject()
	local projectObject = self.currentProject
	local requiresEval = review:setReviewStandard(projectObject)
	
	projectObject:release()
	projectObject:updateGameRating()
	table.insert(self.activeGameProjects, projectObject)
	projectObject:addReviewRatingReputation(projectObject:getRealRating(), #review:getReviewers())
	projectObject:setRating(projectObject:getReviewRating())
	
	if requiresEval then
		review:evaluateGameStandard(projectObject)
	end
	
	projectObject:increasePopularity(math.max(rivalGameCompany.RELEASE_POP_INCREASE.min, math.min(self.reputation, rivalGameCompany.RELEASE_POP_INCREASE.max)), false)
	projectObject:updateTrendContribution()
	self:improveMastery()
	
	self.currentProject = nil
	self.nextProjectTime = timeline.curTime + rivalGameCompany.NEW_GAME_COOLDOWN
end

function rivalGameCompany:releaseGame(gameObject)
	local teamObj = gameObject:getTeam()
	
	if teamObj then
		teamObj:clearProject()
	end
	
	gameObject:onReleaseGame()
	table.insert(self.releasedGames, gameObject)
	
	local oldestProject = self.releasedGames[1]
	
	if timeline.curTime > oldestProject:getReleaseDate() + rivalGameCompany.MAX_STORED_PROJECT_DURATION then
		table.remove(self.releasedGames, 1)
		
		local oldestProjectEngine = oldestProject:getEngine()
		
		self:removeProject(oldestProject)
		table.removeObject(self.engines, oldestProjectEngine)
	end
	
	gameObject:addToPlatforms(nil, true)
end

function rivalGameCompany:cleanupOldGames()
	local index = 1
	local cleanups = 0
	local gameProjectType = gameProject.PROJECT_TYPE
	
	for i = 1, #self.projects do
		local gameObj = self.projects[index]
		
		if gameObj.PROJECT_TYPE == gameProjectType and gameObj:getReleaseDate() and timeline.curTime > gameObj:getReleaseDate() + rivalGameCompany.MAX_STORED_PROJECT_DURATION then
			table.remove(self.projects, index)
			
			cleanups = cleanups + 1
		else
			index = index + 1
		end
	end
end

function rivalGameCompany:releaseUnreleasedGameProject()
	if self.currentProject and self.currentProject:canReleaseGame() then
		self:releaseGameProject()
		
		return true
	end
	
	return false
end

function rivalGameCompany:selectProjectAudience()
	local genre = self.currentProject:getGenre()
	local bestMatch, worstMatch = -math.huge, math.huge
	local mastery = self.genreMastery[genre] - 1
	
	for key, audienceData in ipairs(audience.registered) do
		local match = audienceData.genreMatching[genre]
		
		bestMatch = math.max(bestMatch, match)
		worstMatch = math.min(worstMatch, match)
	end
	
	local normalizedBestMatch = bestMatch - worstMatch
	local totalWeight = 1
	
	for key, audienceData in ipairs(audience.registered) do
		self.audiencesByWeight.start[key] = totalWeight
		totalWeight = totalWeight + math.round(math.lerp(rivalGameCompany.AUDIENCE_BASE_WEIGHT, rivalGameCompany.AUDIENCE_MIN_WEIGHT, mastery))
		self.audiencesByWeight.finish[key] = totalWeight
		totalWeight = totalWeight + 1
	end
	
	local rolledWeight = math.random(1, totalWeight)
	local pickedAudience
	
	for key, audienceData in ipairs(audience.registered) do
		if rolledWeight >= self.audiencesByWeight.start[key] and rolledWeight <= self.audiencesByWeight.finish[key] then
			pickedAudience = audienceData.id
			
			break
		end
	end
	
	table.clearArray(self.audiencesByWeight.start)
	table.clearArray(self.audiencesByWeight.finish)
	
	return pickedAudience
end

function rivalGameCompany:adjustProjectPriorities()
	local gameProj = self.currentProject
	local genre = gameProj:getGenre()
	local genreData = genres.registeredByID[genre]
	local genreMastery = self.genreMastery[genre] - 1
	
	for qualityID, multiplier in pairs(genreData.scoreImpact) do
		local categories = taskTypes:getCategoriesOfQuality(qualityID)
		
		if categories then
			local priority = math.lerp(1, math.min(math.max(multiplier, gameProject.PRIORITY_MIN), gameProject.PRIORITY_MAX), genreMastery)
			
			for key, categoryID in ipairs(categories) do
				gameProj:setCategoryPriority(categoryID, priority)
			end
		end
	end
end

function rivalGameCompany:pickGenreAndTheme()
	local totalWeight = 1
	
	for key, genreData in ipairs(genres.registered) do
		self.genresByWeight.start[key] = totalWeight
		totalWeight = totalWeight + rivalGameCompany.BASE_GENRE_WEIGHT + self.genreMastery[genreData.id] * rivalGameCompany.MASTERY_TO_GENRE_WEIGHT + (trends:isGenreTrending(genreData.id) and rivalGameCompany.TRENDING_TO_GENRE_WEIGHT or 0)
		self.genresByWeight.finish[key] = totalWeight
		totalWeight = totalWeight + 1
	end
	
	totalWeight = totalWeight - 1
	
	local rolledWeight = math.random(1, totalWeight)
	local pickedGenre
	
	for i = 1, #self.genresByWeight.start do
		local start, finish = self.genresByWeight.start[i], self.genresByWeight.finish[i]
		
		if start <= rolledWeight and rolledWeight <= finish then
			pickedGenre = genres.registered[i]
			
			break
		end
	end
	
	table.clear(self.genresByWeight.start)
	table.clear(self.genresByWeight.finish)
	
	local totalWeight = 1
	
	for key, themeData in ipairs(themes.registered) do
		self.themesByWeight.start[key] = totalWeight
		totalWeight = totalWeight + rivalGameCompany.BASE_THEME_WEIGHT + self.themeMastery[themeData.id] * rivalGameCompany.MASTERY_TO_THEME_WEIGHT + (trends:isThemeTrending(themeData.id) and rivalGameCompany.TRENDING_TO_THEME_WEIGHT or 0)
		self.themesByWeight.finish[key] = totalWeight
		totalWeight = totalWeight + 1
	end
	
	totalWeight = totalWeight - 1
	
	local rolledWeight = math.random(1, totalWeight)
	local pickedTheme
	
	for i = 1, #self.themesByWeight.start do
		local start, finish = self.themesByWeight.start[i], self.themesByWeight.finish[i]
		
		if start <= rolledWeight and rolledWeight <= finish then
			pickedTheme = themes.registered[i]
			
			break
		end
	end
	
	table.clear(self.themesByWeight.start)
	table.clear(self.themesByWeight.finish)
	
	return pickedGenre.id, pickedTheme.id
end

function rivalGameCompany.sortByMarketShare(a, b)
	return a:getMarketShare() < b:getMarketShare()
end

function rivalGameCompany:pickPlatforms()
	local platformCount = math.random(1, 100) <= rivalGameCompany.MANY_PLATFORMS_CHANCE and rivalGameCompany.MANY_PLATFORMS_AMOUNT or rivalGameCompany.GENERIC_PLATFORM_COUNT
	
	for key, platformObj in ipairs(platformShare:getOnMarketPlatforms()) do
		if table.find(self.licensedPlatforms, platformObj:getID()) then
			local valid = true
			
			if platformObj:hasExpired() and platformObj:getTimeSinceExpiration() >= self.data.maximumPlatformExpirationAge then
				valid = false
			end
			
			if valid then
				rivalGameCompany.sortedPlatforms[#rivalGameCompany.sortedPlatforms + 1] = platformObj
			end
		end
	end
	
	table.sort(rivalGameCompany.sortedPlatforms, rivalGameCompany.sortByMarketShare)
	
	self.maxProjectScale = math.huge
	
	for i = 1, platformCount do
		local object = rivalGameCompany.sortedPlatforms[#rivalGameCompany.sortedPlatforms]
		
		if object then
			local id = object:getID()
			
			self.currentProject:setPlatformState(id, true)
			
			self.maxProjectScale = math.min(self.maxProjectScale, object:getMaxProjectScale())
			
			table.remove(rivalGameCompany.sortedPlatforms, #rivalGameCompany.sortedPlatforms)
		else
			break
		end
	end
	
	table.clear(rivalGameCompany.sortedPlatforms)
end

function rivalGameCompany:purchasePlatformLicenses()
	local ourBudget = self.funds * rivalGameCompany.PLATFORM_LICENSING_BUDGET
	local highestMarketShare, platformID = -math.huge
	
	for key, platformObj in ipairs(platformShare:getOnMarketPlatforms()) do
		if not platformObj.PLAYER then
			local currentID = platformObj:getID()
			
			if not platformObj:hasExpired() and not table.find(self.licensedPlatforms, currentID) then
				local marketShare = platformObj:getMarketShare()
				
				if highestMarketShare < marketShare and ourBudget >= platformObj:getLicenseCost() then
					highestMarketShare = marketShare
					platformID = currentID
				end
			end
		end
	end
	
	if platformID then
		self:purchasePlatformLicense(platformID)
	end
end

local availableFreeFeatures, availablePaidFeatures, conflictableFeatures, costByTask, tasksByCategory = {}, {}, {}, {}, {}

function rivalGameCompany:fillProjectWithDesiredFeatures()
	local scale, budget = self:calculateScaleAndBudget()
	
	self.currentBudget = budget
	
	self.currentProject:setScale(scale)
	
	local maxScale = self.currentProject:calculateMaxPriceScale()
	local calculatedPrice = math.min(scale / maxScale, 1) * self.data.maximumPrice
	local finalPrice = self.data.minimumPrice
	
	for key, price in ipairs(gameProject.PRICE_POINTS) do
		if price <= calculatedPrice and finalPrice < price then
			finalPrice = price
		end
	end
	
	self.currentProject:setPrice(math.min(self.data.maximumPrice, math.max(self.data.minimumPrice, finalPrice)))
	
	local halfBudget = budget * rivalGameCompany.PERCENTAGE_OF_BUDGET_FOR_ONE_FEATURE
	local remainingBudget = halfBudget
	local highestSkills = self.team:getHighestSkillLevels()
	local gameProj = self.currentProject
	local perspectiveCategory = gameProject.PERSPECTIVE_CATEGORY
	local standardTable = review:getCurrentYearStandard()
	local desiredWorkAmount = math.ceil(math.max(rivalGameCompany.MINIMUM_WORK_AMOUNT, standardTable.workAmounts[self.currentProject:getGameType()] * self.currentProject:getRequiredFeatureCountPercentage()))
	
	for key, category in ipairs(gameProject.DEVELOPMENT_CATEGORIES) do
		local listOfTasks = taskTypes:getTasksByCategory(category)
		
		if listOfTasks then
			for key, taskTypeData in ipairs(listOfTasks) do
				if not taskTypeData:isInvisible() and taskTypeData:wasReleased() and taskTypeData.optionCategory ~= perspectiveCategory then
					local skilledEnough = false
					
					if taskTypeData.minimumLevel then
						if highestSkills[taskTypeData.workField] >= taskTypeData.minimumLevel then
							skilledEnough = true
						end
					else
						skilledEnough = true
					end
					
					if skilledEnough then
						local cost = taskTypeData:getCost(nil, gameProj)
						
						if cost > 0 then
							if cost <= halfBudget then
								availablePaidFeatures[#availablePaidFeatures + 1] = taskTypeData
								costByTask[taskTypeData] = cost
							end
						else
							availableFreeFeatures[#availableFreeFeatures + 1] = taskTypeData
						end
					end
				end
			end
		end
	end
	
	local perspectiveTasks = taskTypes:getTasksByCategory(perspectiveCategory)
	
	perspectiveTasks[math.random(1, #perspectiveTasks)]:setDesiredFeature(gameProj, true)
	
	local expenditures = 0
	
	if #availablePaidFeatures > 0 then
		while desiredWorkAmount > 0 do
			local randomIndex = math.random(1, #availablePaidFeatures)
			local randomData = availablePaidFeatures[randomIndex]
			
			if randomData.optionCategory then
				local tasks = taskTypes:getTasksByOptionCategory(randomData.optionCategory)
				
				for key, taskData in ipairs(tasks) do
					if remainingBudget >= taskData:getCost(nil, gameProj) then
						conflictableFeatures[#conflictableFeatures + 1] = taskData
					end
				end
				
				randomData = conflictableFeatures[math.random(1, #conflictableFeatures)]
				
				if randomData then
					for key, taskData in ipairs(conflictableFeatures) do
						for otherKey, otherTaskData in ipairs(availablePaidFeatures) do
							if taskData == otherTaskData then
								table.remove(availablePaidFeatures, otherKey)
								
								break
							end
						end
						
						conflictableFeatures[key] = nil
					end
				end
			end
			
			if randomData then
				randomData:setDesiredFeature(gameProj, true, true)
				
				desiredWorkAmount = desiredWorkAmount - randomData.totalWork
				
				local cost = costByTask[randomData] or randomData:getCost(nil, gameProj)
				
				remainingBudget = remainingBudget - cost
				expenditures = expenditures + cost
				
				local curIndex = 1
				
				for i = 1, #availablePaidFeatures do
					local featureData = availablePaidFeatures[curIndex]
					
					if remainingBudget < costByTask[featureData] then
						table.remove(availablePaidFeatures, curIndex)
						
						costByTask[featureData] = nil
					else
						curIndex = curIndex + 1
					end
				end
				
				if #availablePaidFeatures == 0 then
					break
				end
			end
		end
		
		table.clear(costByTask)
		table.clear(conflictableFeatures)
	end
	
	while #availableFreeFeatures > 0 and desiredWorkAmount > 0 do
		local randomIndex = math.random(1, #availableFreeFeatures)
		local randomData = availableFreeFeatures[randomIndex]
		
		if randomData.optionCategory then
			local tasks = taskTypes:getTasksByOptionCategory(randomData.optionCategory)
			
			for key, taskData in ipairs(tasks) do
				conflictableFeatures[#conflictableFeatures + 1] = taskData
			end
			
			randomData = conflictableFeatures[math.random(1, #conflictableFeatures)]
			
			for key, taskData in ipairs(conflictableFeatures) do
				for otherKey, otherTaskData in ipairs(availableFreeFeatures) do
					if taskData == otherTaskData then
						table.remove(availableFreeFeatures, otherKey)
						
						break
					end
				end
				
				conflictableFeatures[key] = nil
			end
		else
			table.remove(availableFreeFeatures, randomIndex)
		end
		
		randomData:setDesiredFeature(gameProj, true, true)
		
		desiredWorkAmount = desiredWorkAmount - randomData.totalWork
	end
	
	local optionalCats = gameProject.OPTIONAL_DEVELOPMENT_CATEGORIES
	local selectedByCategory = gameProj:getSelectedTasksByCategory()
	
	for key, category in ipairs(gameProject.DEVELOPMENT_CATEGORIES) do
		local taskCount = selectedByCategory[category]
		
		if not optionalCats[category] and (not taskCount or taskCount == 0) then
			for key, taskData in ipairs(availableFreeFeatures) do
				if taskData.category == category then
					tasksByCategory[#tasksByCategory + 1] = taskData
				end
			end
			
			if #tasksByCategory > 0 then
				local randomData = table.remove(tasksByCategory, math.random(1, #tasksByCategory))
				
				randomData:setDesiredFeature(gameProj, true, true)
				table.removeObject(availableFreeFeatures, randomData)
				table.clearArray(tasksByCategory)
			end
		end
	end
	
	if gameProj:hasDesiredFeature("in_app_purchases") then
		for key, id in ipairs(gameProj:getTargetPlatforms()) do
			local object = platformShare:getPlatformByID(id)
			
			if object:isFrustratedWithMicrotransactions() then
				taskTypes.registeredByID.in_app_purchases:setDesiredFeature(gameProj, false, true)
				
				break
			end
		end
	end
	
	table.clearArray(availableFreeFeatures)
	table.clearArray(availablePaidFeatures)
end

function rivalGameCompany:calculateScaleAndBudget()
	local totalSkillLevels, totalEvaluatedSkills = 0, 0
	local totalSkills = self.team:getTotalSkills()
	
	for skillID, skillLevel in pairs(totalSkills) do
		local skillData = skills.registeredByID[skillID]
		
		if skillData.developmentSkill then
			totalSkillLevels = totalSkillLevels + skillLevel * skillData.rivalWeight
			totalEvaluatedSkills = totalEvaluatedSkills + 1
		end
	end
	
	local scaleRange = gameProject.SCALE[gameProject.DEVELOPMENT_TYPE.NEW]
	local maxScale = math.min(self.maxProjectScale, math.max(scaleRange[1], math.min(self.maxProjectScale, totalSkillLevels / totalEvaluatedSkills / rivalGameCompany.SINGLE_SCALE_TO_SKILL_LEVEL)))
	local desiredScale = 1
	local monthsInSalaries = self:getMonthsInSalaries(0) * rivalGameCompany.MONTH_IN_SALARIES_TO_SCALE
	
	if monthsInSalaries > rivalGameCompany.MONTH_IN_SALARIES_TO_INCREASE_SCALE then
		local scaleAffector = rivalGameCompany.MONTH_IN_SALARIES_TO_SCALE * (monthsInSalaries - rivalGameCompany.MONTH_IN_SALARIES_TO_INCREASE_SCALE)
		
		desiredScale = desiredScale + scaleAffector
		maxScale = math.min(self.maxProjectScale, maxScale + scaleAffector * rivalGameCompany.MAX_SCALE_MAX_AFFECTOR)
	end
	
	return math.max(scaleRange[1], math.min(desiredScale, maxScale)), math.floor(self.funds * 0.5)
end

function rivalGameCompany:getMonthsInSalaries(cashOffset)
	if not self.totalSalaries then
		self:calculateTotalSalaries()
	end
	
	return (self.funds + cashOffset) / self.totalSalaries, self.totalSalaries
end

rivalGameCompany.advertTypes = {}

function rivalGameCompany:performAdvertisement(gameProj)
	if gameProj:getFact(rivalGameCompany.ADVERT_FACT) then
		return 
	end
	
	local stageID, stageObject = gameProj:getStage()
	
	if stageID < gameProject.POLISHING_STAGE or stageObject:getCompletion() < 0.5 then
		return 
	end
	
	local availableMoney = math.min(self.funds * rivalGameCompany.MAX_ADVERTISEMENT_BUDGET, gameProj:getPrice() * rivalGameCompany.PRICE_TO_MAX_ADVERTISEMENT_SPENDING)
	local data = advertisement:getData("mass_advertisement")
	
	for key, data in ipairs(data.additionalAdvertOptions) do
		if availableMoney > data.cost then
			rivalGameCompany.advertTypes[#rivalGameCompany.advertTypes + 1] = data
		end
	end
	
	if #rivalGameCompany.advertTypes > 0 then
		local advertTypes = {}
		local cost = 0
		
		while availableMoney > 0 do
			if #rivalGameCompany.advertTypes > 0 then
				local randomKey = math.random(1, #rivalGameCompany.advertTypes)
				local randomData = rivalGameCompany.advertTypes[randomKey]
				
				if availableMoney >= randomData.cost then
					advertTypes[randomData.id] = true
					availableMoney = availableMoney - randomData.cost
					cost = cost + randomData.cost
				end
				
				table.remove(rivalGameCompany.advertTypes, randomKey)
			else
				break
			end
		end
		
		self:deductFunds(cost)
		data:applyCampaignDataToGame(gameProj, advertTypes, cost, 1, 1)
	end
	
	gameProj:setFact(rivalGameCompany.ADVERT_FACT, true)
	table.clearArray(rivalGameCompany.advertTypes)
end

function rivalGameCompany:calculateTotalSalaries()
	if self._loading then
		return 
	end
	
	self.totalSalaries = 0
	
	for key, employeeObject in ipairs(self.employees) do
		self.totalSalaries = self.totalSalaries + employeeObject:getSalary()
	end
end

function rivalGameCompany:canRivalStealEmployee(employee)
	local cooldown = employee:getFact(rivalGameCompany.RIVAL_STEAL_COOLDOWN_FACT)
	
	return not cooldown or cooldown <= timeline.curTime
end

function rivalGameCompany:canPlayerStealEmployee(employee)
	local cooldown = employee:getFact(rivalGameCompany.PLAYER_STEAL_COOLDOWN_FACT)
	
	return (not cooldown or cooldown <= timeline.curTime) and not employee:getFact(rivalGameCompany.EMPLOYEE_STEAL_FACT) and not employee:getFact(rivalGameCompany.SWITCH_IN_TIME_FACT)
end

rivalGameCompany.STEAL_DIALOGUE_FACT = "steal_dialogue"

function rivalGameCompany:attemptStealEmployee()
	if not self:canThreatenPlayer() then
		return 
	end
	
	local employeeStealing = self.data.employeeStealing
	
	if math.random(1, 100) > employeeStealing.chance + self.anger * employeeStealing.chancePerAnger + self.intimidation * employeeStealing.chancePerIntimidation then
		return 
	end
	
	local bestEmployee, highestSkill, cashOffer = nil, 0, 0
	
	for key, employee in ipairs(studio:getEmployees()) do
		if not employee:isPlayerCharacter() and not employee:getFact(rivalGameCompany.STEAL_DIALOGUE_FACT) then
			local currentSalary = employee:getSalary()
			local delta = employee:getNewSalary() - currentSalary
			
			if delta >= employeeStealing.minimumOfferedCash and self:canRivalStealEmployee(employee) then
				local skillLevel
				local roleData = employee:getRoleData()
				local valid = false
				
				if roleData.mainSkill then
					skillLevel = employee:getSkillLevel(roleData.mainSkill)
					
					if highestSkill < skillLevel then
						valid = true
					end
				else
					local skillID, level = employee:getHighestSkill()
					
					if highestSkill < level then
						valid = true
						skillLevel = level
					end
				end
				
				if valid then
					local targetCash = math.min(employeeStealing.minimumOfferedCash + employeeStealing.extraCashPerCurrentSalary * currentSalary + math.floor((delta - employeeStealing.minimumOfferedCash) / employeeStealing.roundingSegment) / employeeStealing.roundingSegment, employeeStealing.maximumOfferedCash)
					
					if math.random(1, 100) <= employee:getConsiderLeavingChance(targetCash) then
						bestEmployee = employee
						highestSkill = skillLevel
						cashOffer = targetCash
					end
				end
			end
		end
	end
	
	if bestEmployee then
		self.lastStealAttempt = timeline.curTime
		
		bestEmployee:attemptSteal(cashOffer, self)
		bestEmployee:removeFact(rivalGameCompany.STEAL_DIALOGUE_FACT)
		rivalGameCompanies:setLatestEmployeeStealAttempt(timeline.curTime)
		events:fire(rivalGameCompany.EVENTS.ATTEMPT_STEAL, bestEmployee)
	end
end

function rivalGameCompany:canAttemptStealEmployee()
	if self.disabledEmployeeStealing then
		return false
	end
	
	local prevTime = rivalGameCompanies:getLatestEmployeeStealAttempt()
	local time = timeline.curTime
	
	return (not prevTime or time >= prevTime + self.data.employeeStealing.cooldown) and (not self.lastStealAttempt or time >= self.lastStealAttempt + self.data.employeeStealing.cooldown)
end

function rivalGameCompany:getLastStealAttempt()
	return self.lastStealAttempt
end

function rivalGameCompany:getLastPlayerStealAttempt()
	return self.lastPlayerStealAttempt
end

function rivalGameCompany:getMostRecentStolenEmployee()
	if self.mostRecentStolenEmployee then
		return self:getEmployeeByUniqueID(self.mostRecentStolenEmployee) or studio:getEmployeeByUniqueID(self.mostRecentStolenEmployee)
	end
end

function rivalGameCompany:getPlayerStolenEmployees()
	return self.playerStolenEmployees
end

function rivalGameCompany:getPlayerFailedStolenEmployees()
	return self.playerFailedStolenEmployees
end

function rivalGameCompany:getStolenEmployees()
	return self.stolenEmployees
end

function rivalGameCompany:getFailedStolenEmployees()
	return self.failedStolenEmployees
end

function rivalGameCompany:getStealCooldownTime()
	return timeline.curTime + rivalGameCompany.EMPLOYEE_STEAL_RETRY_COOLDOWN
end

function rivalGameCompany:onStealSuccess(employee)
	local employeeStealing = self.data.employeeStealing
	
	self:hireEmployee(employee)
	
	self.stolenEmployees = self.stolenEmployees + 1
	
	self:changeAnger(employeeStealing.angerOnStealSuccess)
	self:changeIntimidation(employeeStealing.intimidationOnStealSuccess)
	employee:setFact(rivalGameCompany.PLAYER_STEAL_COOLDOWN_FACT, self:getStealCooldownTime(employee))
	conversations:addTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_SUCCESS_ID, employee:getUniqueID())
	studio:getStats():changeStat("employees_stolen_from_you", 1)
	events:fire(rivalGameCompany.EVENTS.SUCCEED_STEAL, employee)
end

function rivalGameCompany:onStealFail(employee)
	local employeeStealing = self.data.employeeStealing
	
	self.failedStolenEmployees = self.failedStolenEmployees + 1
	
	self:changeAnger(employeeStealing.angerOnStealFail)
	self:changeIntimidation(employeeStealing.intimidationOnStealFail)
	employee:setFact(rivalGameCompany.RIVAL_STEAL_COOLDOWN_FACT, self:getStealCooldownTime(employee))
	conversations:addTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_ID, employee:getUniqueID())
	events:fire(rivalGameCompany.EVENTS.FAIL_STEAL, employee)
end

function rivalGameCompany:onPlayerStealSuccess(employeeObject)
	local employeeStealing = self.data.employeeStealing
	
	self.playerStolenEmployees = self.playerStolenEmployees + 1
	self.mostRecentStolenEmployee = employeeObject:getUniqueID()
	
	self:changeAnger(employeeStealing.angerOnPlayerStealSuccess, rivalGameCompany.ANGER_CHANGE_REASON.EMPLOYEE_STEALING)
	self:changeIntimidation(employeeStealing.intimidationOnPlayerStealSuccess)
	self:changeRelationship(self.data.stealEmployeeRelationshipChange)
	
	self.disabledEmployeeStealing = false
	
	employeeObject:removeFact(rivalGameCompany.SCHEDULED_LEAVE_FACT)
	employeeObject:setFact(rivalGameCompany.SWITCH_IN_TIME_FACT, timeline:getTime() + self.data.switchToPlayerTime)
	employeeObject:setFact(rivalGameCompany.RIVAL_STEAL_COOLDOWN_FACT, self:getStealCooldownTime(employeeObject))
	table.insert(self.timeUntilEmployeeSwitch, employeeObject)
	
	local popup = game.createPopup(600, _T("RIVAL_GAME_COMPANY_WORK_OFFER_ACCEPTED_TITLE", "Rival Company: Employee Persuasion Success!"), _format(_T("RIVAL_GAME_COMPANY_WORK_OFFER_ACCEPTED_DETAILED", "NAME, who is currently working at 'COMPANY' has accepted your offer of switching to your company.\nHe is obliged to spend TIME before being able to switch to your team."), "NAME", employeeObject:getFullName(true), "COMPANY", self:getName(), "TIME", timeline:getTimePeriodText(self.data.switchToPlayerTime)), "pix24", "pix20", false)
	
	frameController:push(popup)
	studio:getStats():changeStat("employees_stolen_from_rivals", 1)
	events:fire(rivalGameCompany.EVENTS.PLAYER_SUCCEED_STEAL, employeeObject)
end

function rivalGameCompany:onPlayerStealFail(employeeObject, acceptChance)
	local employeeStealing = self.data.employeeStealing
	
	self.playerFailedStolenEmployees = self.playerFailedStolenEmployees + 1
	
	employeeObject:setFact(rivalGameCompany.PLAYER_STEAL_COOLDOWN_FACT, timeline.curTime + rivalGameCompany.EMPLOYEE_STEAL_RETRY_COOLDOWN)
	
	if math.random(1, 100) <= 100 - acceptChance then
		self:changeAnger(employeeStealing.angerOnPlayerStealFail, rivalGameCompany.ANGER_CHANGE_REASON.EMPLOYEE_STEALING)
		self:changeIntimidation(employeeStealing.intimidationOnPlayerStealFail)
		self:changeRelationship(self.data.failStealEmployeeRelationshipChange)
		
		self.disabledEmployeeStealing = false
	end
	
	local popup = game.createPopup(600, _T("RIVAL_GAME_COMPANY_WORK_OFFER_DECLINED_TITLE", "Rival Company: Employee Persuasion Failed"), _format(_T("RIVAL_GAME_COMPANY_WORK_OFFER_DECLINED_DETAILED", "Your attempt at persuading NAME to join your company, who is currently working at 'COMPANY', has failed - the employee has refused your work offer."), "NAME", employeeObject:getFullName(true), "COMPANY", self:getName()), "pix24", "pix20", false)
	
	frameController:push(popup)
	events:fire(rivalGameCompany.EVENTS.PLAYER_FAIL_STEAL, employeeObject)
end

function rivalGameCompany:markPlayerStealEmployee(employeeObject)
	self.lastPlayerStealAttempt = timeline.curTime
	
	local replyTime = timeline:getTime() + math.random(rivalGameCompany.EMPLOYEE_STEAL_REPLY_TIME[1], rivalGameCompany.EMPLOYEE_STEAL_REPLY_TIME[2])
	
	self.playerStealAttemptEmployees[#self.playerStealAttemptEmployees + 1] = employeeObject
	
	employeeObject:setFact(rivalGameCompany.EMPLOYEE_STEAL_FACT, replyTime)
end

function rivalGameCompany:hasMarkedEmployee(employeeObject)
	for key, otherEmployee in ipairs(self.playerStealAttemptEmployees) do
		if otherEmployee == employeeObject then
			return true
		end
	end
	
	return false
end

function rivalGameCompany:finishPlayerStealAttempt(index, employeeObject, extraMoney)
	extraMoney = extraMoney or 0
	
	local chance = employeeObject:getStealAttemptChance(extraMoney) * self.playerStealChanceMult
	
	if chance >= math.random(1, 100) then
		self:onPlayerStealSuccess(employeeObject)
	else
		self:onPlayerStealFail(employeeObject, chance)
	end
	
	employeeObject:removeFact(rivalGameCompany.OFFERED_MONEY_FACT)
	employeeObject:removeFact(rivalGameCompany.EMPLOYEE_STEAL_FACT)
	
	if index then
		table.remove(self.playerStealAttemptEmployees, index)
	else
		table.removeObject(self.playerStealAttemptEmployees, employeeObject)
	end
end

function rivalGameCompany.postKillStealFrame(frame)
	if frame.roleCountList then
		frame.roleCountList:kill()
	end
end

rivalGameCompany.AVAILABLE_CATEGORY_UI_ID = "available_employees_category"
rivalGameCompany.UNAVAILABLE_CATEGORY_UI_ID = "unavailable_employees_category"
rivalGameCompany.UNAVAILABLE_EMPLOYEES_HOVER_TEXT = {
	{
		font = "pix20",
		text = _T("UNAVAILABLE_RIVAL_GAME_EMPLOYEES_1", "Employees that you've sent a job offer to, or employees that have accepted your offer, that still have to finish their work there.")
	}
}

function rivalGameCompany:createStealEmployeePopup()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = gui.create("Frame")
	
	self.frame:setSize(450, 600)
	self.frame:setFont(fonts.get("pix24"))
	self.frame:setTitle(_T("RIVAL_COMPANY_EMPLOYEES_TITLE", "Rival Company Employees"))
	self.frame:center()
	
	self.frame.postKill = rivalGameCompany.postKillStealFrame
	
	local infoBox = gui.create("StudioEmploymentInfoDescbox")
	
	infoBox:setPos(self.frame.x + self.frame.w + _S(10), self.frame.y)
	infoBox:setHeaderText(_T("EMPLOYEES_IN_YOUR_OFFICE", "Your employees"))
	infoBox:updateDisplay()
	infoBox:tieVisibilityTo(self.frame)
	infoBox:setShowEmployeeOverview(true)
	
	local scrollBarPanel = gui.create("RoleScrollbarPanel", self.frame)
	
	scrollBarPanel:setPos(_S(10), _S(35))
	scrollBarPanel:setSize(430, 550)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:setSpacing(3)
	scrollBarPanel:addDepth(50)
	
	local list = game.createRoleFilter(scrollBarPanel)
	
	list:setPos(self.frame.x - list.w - _S(10), self.frame.y)
	scrollBarPanel:setRoleFilterList(list)
	
	self.frame.roleCountList = roleCountList
	
	local availableCategory = gui.create("Category")
	
	availableCategory:setFont(fonts.get("pix24"))
	availableCategory:setText(_T("AVAILABLE_EMPLOYEES", "Available employees"))
	availableCategory:setHeight(26)
	availableCategory:assumeScrollbar(scrollBarPanel)
	availableCategory:setID(rivalGameCompany.AVAILABLE_CATEGORY_UI_ID)
	scrollBarPanel:addItem(availableCategory)
	
	local unavailableCategory = gui.create("Category")
	
	unavailableCategory:setFont(fonts.get("pix24"))
	unavailableCategory:setText(_T("UNAVAILABLE_EMPLOYEES", "Unavailable employees"))
	unavailableCategory:setHeight(26)
	unavailableCategory:assumeScrollbar(scrollBarPanel)
	unavailableCategory:setID(rivalGameCompany.UNAVAILABLE_CATEGORY_UI_ID)
	unavailableCategory:setHoverText(rivalGameCompany.UNAVAILABLE_EMPLOYEES_HOVER_TEXT)
	scrollBarPanel:addItem(unavailableCategory)
	
	for key, employeeObj in ipairs(self.employees) do
		if not employeeObj:getFact(rivalGameCompany.CEO_FACT) then
			local seekerDisplay = gui.create("StealEmployeeDisplay")
			
			seekerDisplay:setSize(410, 20)
			seekerDisplay:setEmployee(employeeObj)
			seekerDisplay:setBasePanel(self.frame)
			
			if self:canPlayerStealEmployee(employeeObj) then
				availableCategory:addItem(seekerDisplay, true, nil)
			else
				unavailableCategory:addItem(seekerDisplay, true, nil)
			end
			
			scrollBarPanel:accountEmployeeItem(seekerDisplay)
		end
	end
	
	frameController:push(self.frame)
end

rivalGameCompanies.SLANDER_INFO_PANEL_ID = "slander_info_panel"

function rivalGameCompany:schedulePlayerSlander(slanderID)
	local data = rivalGameCompanies.registeredSlanderByID[slanderID]
	
	self.scheduledPlayerSlander = slanderID
	
	studio:deductFunds(data.cost, nil, "misc")
	self:createSlanderConfirmPopup(data)
	achievements:attemptSetAchievement(achievements.ENUM.START_SLANDER)
end

function rivalGameCompany:getScheduledPlayerSlander()
	return self.scheduledPlayerSlander
end

function rivalGameCompany:createSlanderConfirmPopup(slanderData)
	local popupText
	
	if slanderData.getBeginSlanderText then
		popupText = slanderData:getBeginSlanderText(self)
	else
		popupText = _T("SLANDER_STARTED_DETAILED", "You've hired an outside company to handle writing slanderous articles about 'RIVAL'.\n\nThe results will become known to you on the start of the next week.")
	end
	
	local popup = game.createPopup(600, _T("SLANDER_STARTED_TITLE", "Slander Started"), _format(popupText, "RIVAL", self:getName()), "pix24", "pix20", false)
	
	frameController:push(popup)
end

function rivalGameCompany:createPlayerSlanderResultPopup(repLoss, success, slanderData)
	local mainText = _T("PLAYER_SLANDER_FINISHED_DETAILED", "The slander articles have been published.\n\nSUCCESS_TEXT")
	local successText
	
	if slanderData.getSlanderResultText then
		successText = slanderData:getSlanderResultText(success, repLoss, self)
	elseif success then
		successText = _format(_T("PLAYER_SLANDER_FINISHED_DETAILED_SUCCESS", "The slander campaign was a success - the general public believed the slander articles and 'RIVAL' has lost REPLOSS reputation points."), "REPLOSS", string.comma(repLoss), "RIVAL", self:getName())
	else
		successText = _format(_T("PLAYER_SLANDER_FINISHED_DETAILED_FAILURE", "The slander campaign was a failure - the general public did not believe any part of the slander campaign and as a result, 'RIVAL' has not lost any reputation."), "RIVAL", self:getName())
	end
	
	mainText = _format(mainText, "SUCCESS_TEXT", successText)
	
	local popup = game.createPopup(600, _T("PLAYER_SLANDER_FINISHED_TITLE", "Slander Finished"), mainText, "pix24", "pix20", false)
	
	frameController:push(popup)
end

function rivalGameCompany:goToCourtCallback()
	self.target:scheduleLegalPlayerAction()
end

function rivalGameCompany.slanderPopupPostKill()
	events:fire(rivalGameCompany.EVENTS.SLANDER_POPUP_CLOSED)
end

function rivalGameCompany:onGameOffMarket(gameObj)
	table.removeObject(self.activeGameProjects, gameObj)
end

function rivalGameCompany:createSlanderResultPopup(repLoss, success, foundOut, slanderData)
	local mainText
	local canShowCourtButtons = false
	
	if foundOut and not self.legalPlayerActionState and (not self.legalActionState or self.legalActionState ~= rivalGameCompanies.LEGAL_ACTION_STATE.IMMINENT) then
		canShowCourtButtons = true
	end
	
	if foundOut then
		if not canShowCourtButtons then
			mainText = _format(_T("SLANDER_FINISHED_DETAILED_FOUND_OUT_EXTRA_AMMO", "A rival game company has published slanderous articles about you. All the evidence suggests that 'RIVAL' was behind this. You're already scheduled to go to court with the CEO of that company, so this will be used as extra legal ammo in court.\n\nSUCCESS_TEXT"), "RIVAL", self:getName())
		else
			mainText = _format(_T("SLANDER_FINISHED_DETAILED_FOUND_OUT", "A rival game company has published slanderous articles about you. All the evidence suggests that 'RIVAL' was behind this. You can pursue legal action against them to receive reparations.\n\nSUCCESS_TEXT"), "RIVAL", self:getName())
		end
	else
		mainText = _T("SLANDER_FINISHED_DETAILED", "Some rival game company has published slanderous articles about you.\n\nSUCCESS_TEXT")
	end
	
	local successText, foundOutText
	
	if success then
		successText = _format(_T("SLANDER_FINISHED_DETAILED_SUCCESS_PART", "The slander campaign was a success - the general public believed the slander articles and you've lost REPLOSS reputation points."), "REPLOSS", string.comma(repLoss))
	else
		successText = _format(_T("SLANDER_FINISHED_DETAILED_FAILURE_PART", "The slander campaign was a failure - the general public did not believe any part of the slander campaign and as a result you have not lost any reputation."))
	end
	
	mainText = _format(mainText, "SUCCESS_TEXT", successText)
	
	local popup = game.createPopup(600, _T("SLANDER_FINISHED_TITLE", "Slanderous Articles"), mainText, "pix24", "pix20", true)
	
	if foundOut then
		if not canShowCourtButtons or not interactionRestrictor:canPerformAction(rivalGameCompanies.INSTANT_COURT_BUTTONS) then
			popup:addOKButton()
		else
			popup:addButton("pix22", _T("GO_TO_COURT", "Call CEO & go to court"), rivalGameCompany.goToCourtCallback).target = self
			
			popup:addButton("pix22", _T("DO_NOTHING", "Do nothing"), nil)
		end
	else
		popup:addOKButton()
	end
	
	popup.postKill = rivalGameCompany.slanderPopupPostKill
	
	frameController:push(popup)
end

function rivalGameCompany:createSlanderMenu()
	local frame = gui.create("SlanderSelectionFrame")
	
	frame:setSize(350, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("SELECT_SLANDER_TYPE_TITLE", "Select Slander Type"))
	frame:center()
	
	local scrollBarPanel = gui.create("ScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(10), _S(35))
	scrollBarPanel:setSize(330, 550)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:setSpacing(3)
	scrollBarPanel:addDepth(50)
	
	for key, slanderData in ipairs(rivalGameCompanies.registeredSlander) do
		local slanderSelection = gui.create("SlanderSelection")
		
		slanderSelection:setSize(310, 20)
		slanderSelection:setSlanderData(slanderData)
		slanderSelection:setCompany(self)
		slanderSelection:setBasePanel(frame)
		scrollBarPanel:addItem(slanderSelection)
	end
	
	local extraInfoPanel = gui.create("SlanderInfoDisplay")
	
	extraInfoPanel:setPos(frame.x + _S(10) + frame.w, frame.y)
	extraInfoPanel:setID(rivalGameCompanies.SLANDER_INFO_PANEL_ID)
	extraInfoPanel:setWidth(250)
	extraInfoPanel:hideDisplay()
	frameController:push(frame)
end

function rivalGameCompany:canAttemptSlander()
	local slanderCfg = self.data.slander
	
	print(self.legalActioNState, self.legalPlayerActionState, timeline.curTime > self.slanderCooldown, self.scheduledSlander, self.anger >= slanderCfg.minimumAnger, self.foundOutPlayerSlander and self.mostRecentFoundOutPlayerSlander and timeline.curTime < self.mostRecentFoundOutPlayerSlander + rivalGameCompany.SLANDER_INSTANT_RETALIATION_TIME)
	
	return not self.legalActionState and not self.legalPlayerActionState and timeline.curTime > self.slanderCooldown and not self.scheduledSlander and self.anger >= slanderCfg.minimumAnger or self.foundOutPlayerSlander and self.mostRecentFoundOutPlayerSlander and timeline.curTime < self.mostRecentFoundOutPlayerSlander + rivalGameCompany.SLANDER_INSTANT_RETALIATION_TIME
end

rivalGameCompany.validSlanderTypes = {}

function rivalGameCompany:attemptSlander()
	local slanderCfg = self.data.slander
	
	print("slander chance", slanderCfg.chance + (self.anger - slanderCfg.minimumAnger) * slanderCfg.chancePerAnger + self.intimidation * slanderCfg.chancePerIntimidation + slanderCfg.chancePerSuspicion * self.slanderSuspicion)
	
	if math.random(1, 100) <= slanderCfg.chance + (self.anger - slanderCfg.minimumAnger) * slanderCfg.chancePerAnger + self.intimidation * slanderCfg.chancePerIntimidation + slanderCfg.chancePerSuspicion * self.slanderSuspicion then
		return false
	end
	
	for key, slanderData in ipairs(rivalGameCompanies.registeredSlander) do
		if not slanderData.unusableByRivals then
			local monthsInSalaries = self:getMonthsInSalaries(-slanderData.cost)
			
			print("wat", monthsInSalaries, rivalGameCompany.MONTHS_IN_SALARIES_FOR_SLANDER, self.funds, self.totalSalaries, (self.funds + -slanderData.cost) / self.totalSalaries)
			
			if monthsInSalaries >= rivalGameCompany.MONTHS_IN_SALARIES_FOR_SLANDER then
				rivalGameCompany.validSlanderTypes[#rivalGameCompany.validSlanderTypes + 1] = slanderData
			end
		end
	end
	
	print("valid slander types?", #rivalGameCompany.validSlanderTypes)
	
	if #rivalGameCompany.validSlanderTypes > 0 then
		local slander = rivalGameCompany.validSlanderTypes[math.random(1, #rivalGameCompany.validSlanderTypes)]
		
		self.scheduledSlander = slander.id
		self.slanderCooldown = timeline.curTime + rivalGameCompany.SLANDER_COOLDOWN
	end
	
	table.clear(rivalGameCompany.validSlanderTypes)
	
	return true
end

function rivalGameCompany:makeAnnoyed()
	self.annoyed = true
end

function rivalGameCompany:isAnnoyed()
	return self.annoyed
end

function rivalGameCompany:save()
	local saved = {
		procedural = self.procedural,
		id = self.id,
		lastPlayerStealAttempt = self.lastPlayerStealAttempt,
		anger = self.anger,
		totalAnger = self.totalAnger,
		defunct = self.defunct,
		threatenedPlayer = self.threatenedPlayer,
		threatenTime = self.threatenTime,
		intimidation = self.intimidation,
		team = self.team:save(),
		facts = self.facts,
		themeMastery = self.themeMastery,
		genreMastery = self.genreMastery,
		funds = self.funds,
		reservedGameNames = self.reservedGameNames,
		lastStealAttempt = self.lastStealAttempt,
		spentInSalaries = self.spentInSalaries,
		nextProjectTime = self.nextProjectTime,
		currentBudget = self.currentBudget,
		licensedPlatforms = self.licensedPlatforms,
		playerIntroduced = self.playerIntroduced,
		relationship = self.relationship,
		hostile = self.hostile,
		playerStolenEmployees = self.playerStolenEmployees,
		playerFailedStolenEmployees = self.playerFailedStolenEmployees,
		stolenEmployees = self.stolenEmployees,
		failedStolenEmployees = self.failedStolenEmployees,
		slanderSuspicion = self.slanderSuspicion,
		scheduledSlander = self.scheduledSlander,
		scheduledPlayerSlander = self.scheduledPlayerSlander,
		playerSuccessfulSlander = self.playerSuccessfulSlander,
		playerFailedSlander = self.playerFailedSlander,
		foundOutPlayerSlander = self.foundOutPlayerSlander,
		mostRecentFoundOutPlayerSlander = self.mostRecentFoundOutPlayerSlander,
		slanderCooldown = self.slanderCooldown,
		slanderReputationLoss = self.slanderReputationLoss,
		legalActionState = self.legalActionState,
		legalPlayerActionState = self.legalPlayerActionState,
		hadCalledPlayer = self.hadCalledPlayer,
		askedAboutReviewers = self.askedAboutReviewers,
		bribeRevealed = self.bribeRevealed,
		nextHireTime = self.nextHireTime,
		annoyed = self.annoyed,
		knownBribeChances = self.knownBribeChances,
		firstPaymentDone = self.firstPaymentDone,
		canStealEmployees = self.canStealEmployees,
		canSlander = self.canSlander,
		playerStealChanceMult = self.playerStealChanceMult,
		playerSlanderDiscoveryChanceMult = self.playerSlanderDiscoveryChanceMult,
		timeUntilDefunct = self.timeUntilDefunct,
		totalGameAwards = self.totalGameAwards,
		engines = {},
		releasedGames = {},
		projects = {},
		employees = {},
		playerStealAttemptEmployees = {},
		timeUntilEmployeeSwitch = {},
		activeGameProjects = {},
		reputation = self.reputation,
		bankruptcyMonths = self.bankruptcyMonths,
		disabledEmployeeStealing = self.disabledEmployeeStealing,
		boughtOut = self.boughtOut,
		reservedGameNames = self.reservedGameNames,
		gameNameCounts = self.gameNameCounts,
		gameAwardWins = self.gameAwardWins
	}
	
	if self.portrait then
		saved.portrait = self.portrait:save()
	end
	
	if self.procedural then
		saved.nameIndex = self.nameIndex
		saved.threatRepRange = self.threatRepRange
		saved.maxEmployees = self.maxEmployees
	end
	
	for key, projectObj in ipairs(self.projects) do
		saved.projects[#saved.projects + 1] = projectObj:save()
	end
	
	for key, projObj in ipairs(self.activeGameProjects) do
		saved.activeGameProjects[#saved.activeGameProjects + 1] = projObj:getUniqueID()
	end
	
	for key, gameObj in ipairs(self.releasedGames) do
		saved.releasedGames[#saved.releasedGames + 1] = gameObj:getUniqueID()
	end
	
	for key, engineObj in ipairs(self.engines) do
		saved.engines[#saved.engines + 1] = engineObj:getUniqueID()
	end
	
	if self.currentProject then
		saved.currentProject = self.currentProject:getUniqueID()
	end
	
	for key, employeeObject in ipairs(self.employees) do
		saved.employees[#saved.employees + 1] = employeeObject:save()
	end
	
	for key, employeeObject in ipairs(self.playerStealAttemptEmployees) do
		saved.playerStealAttemptEmployees[#saved.playerStealAttemptEmployees + 1] = employeeObject:getUniqueID()
	end
	
	for key, employeeObject in ipairs(self.timeUntilEmployeeSwitch) do
		saved.timeUntilEmployeeSwitch[#saved.timeUntilEmployeeSwitch + 1] = employeeObject:getUniqueID()
	end
	
	return saved
end

function rivalGameCompany:load(data)
	self._loading = true
	self.procedural = data.procedural
	
	if self.procedural and not self.baseBuyoutCost then
		self:rollRandomCostOffset()
	end
	
	self.defunct = data.defunct
	self.boughtOut = data.boughtOut
	self.threatenedPlayer = data.threatenedPlayer
	self.intimidation = data.intimidation or self.intimidation
	self.anger = data.anger or self.anger
	self.threatenTime = data.threatenTime or self.threatenTime
	self.facts = data.facts or self.facts
	self.funds = data.funds or self.funds
	
	if self.funds ~= self.funds then
		self.funds = self.data.startingFunds
	end
	
	self.lastStealAttempt = data.lastStealAttempt
	self.spentInSalaries = data.spentInSalaries or self.spentInSalaries
	self.nextProjectTime = data.nextProjectTime or self.nextProjectTime
	self.currentBudget = data.currentBudget or self.currentBudget
	self.licensedPlatforms = data.licensedPlatforms or self.licensedPlatforms
	self.gameAwardWins = data.gameAwardWins or self.gameAwardWins
	self.totalGameAwards = data.totalGameAwards or self.totalGameAwards
	
	for key, id in ipairs(self.licensedPlatforms) do
		self.licensedPlatformsMap[id] = true
	end
	
	self.reservedGameNames = data.reservedGameNames
	self.gameNameCounts = data.gameNameCounts
	
	local oldSave = false
	
	if not self.reservedGameNames then
		oldSave = true
		
		self:reserveGameNames()
	end
	
	self.relationship = data.relationship or self.relationship
	self.hostile = data.hostile or self.hostile
	self.playerStolenEmployees = data.playerStolenEmployees or self.playerStolenEmployees
	self.playerFailedStolenEmployees = data.playerFailedStolenEmployees or self.playerFailedStolenEmployees
	self.stolenEmployees = data.stolenEmployees or self.stolenEmployees
	self.failedStolenEmployees = data.failedStolenEmployees or self.failedStolenEmployees
	self.lastPlayerStealAttempt = data.lastPlayerStealAttempt or self.lastPlayerStealAttempt
	self.slanderSuspicion = data.slanderSuspicion or self.slanderSuspicion
	self.scheduledPlayerSlander = data.scheduledPlayerSlander or self.scheduledPlayerSlander
	self.playerSuccessfulSlander = data.playerSuccessfulSlander or self.playerSuccessfulSlander
	self.playerFailedSlander = data.playerFailedSlander or self.playerFailedSlander
	self.foundOutPlayerSlander = data.foundOutPlayerSlander or self.foundOutPlayerSlander
	self.mostRecentFoundOutPlayerSlander = data.mostRecentFoundOutPlayerSlander or self.mostRecentFoundOutPlayerSlander
	self.scheduledSlander = data.scheduledSlander or self.scheduledSlander
	self.slanderCooldown = data.slanderCooldown or self.slanderCooldown
	self.angerReasonAmounts = self.angerReasonAmounts or self.angerReasonAmounts
	self.slanderReputationLoss = data.slanderReputationLoss or self.slanderReputationLoss
	self.legalActionState = data.legalActionState or self.legalActionState
	self.legalPlayerActionState = data.legalPlayerActionState or self.legalPlayerActionState
	self.playerIntroduced = data.playerIntroduced or self.playerIntroduced
	self.hadCalledPlayer = data.hadCalledPlayer
	self.askedAboutReviewers = data.askedAboutReviewers
	self.annoyed = data.annoyed
	self.knownBribeChances = data.knownBribeChances or self.knownBribeChances
	self.bribeRevealed = data.bribeRevealed
	self.nextHireTime = data.nextHireTime or self.nextHireTime
	self.firstPaymentDone = data.firstPaymentDone
	self.canStealEmployees = data.canStealEmployees
	self.canSlander = data.canSlander
	self.playerStealChanceMult = data.playerStealChanceMult or self.playerStealChanceMult
	self.playerSlanderDiscoveryChanceMult = data.playerSlanderDiscoveryChanceMult or self.playerSlanderDiscoveryChanceMult
	self.timeUntilDefunct = data.timeUntilDefunct
	self.reputation = data.reputation or self.reputation
	self.bankruptcyMonths = data.bankruptcyMonths or self.bankruptcyMonths
	self.disabledEmployeeStealing = data.disabledEmployeeStealing
	self.baseBuyoutCost = data.baseBuyoutCost
	
	if self.procedural then
		self:setNameIndex(data.nameIndex)
		
		self.threatRepRange = data.threatRepRange
		self.maxEmployees = data.maxEmployees
	end
	
	if self.mostRecentStolenEmployee then
		self.mostRecentStolenEmployee = self.mostRecentStolenEmployee
	end
	
	local uniqueIDToProjectObjects = {}
	
	for key, projectData in ipairs(data.projects) do
		local object = projectLoader:load(projectData, self)
		
		uniqueIDToProjectObjects[projectData.uniqueID] = object
	end
	
	if data.activeGameProjects then
		for key, projectID in ipairs(data.activeGameProjects) do
			local projObj = self:getProjectByUniqueID(projectID)
			
			if projObj then
				self.activeGameProjects[#self.activeGameProjects + 1] = projObj
			end
		end
	end
	
	for key, uniqueID in ipairs(data.engines) do
		table.insert(self.engines, self:getProjectByUniqueID(uniqueID))
	end
	
	for key, uniqueID in ipairs(data.releasedGames) do
		table.insert(self.releasedGames, self:getProjectByUniqueID(uniqueID))
	end
	
	if oldSave then
		for key, object in ipairs(self.releasedGames) do
			self:generateGameName(object)
		end
	end
	
	for key, projectData in pairs(data.projects) do
		uniqueIDToProjectObjects[projectData.uniqueID]:postLoad(projectData)
	end
	
	if data.team then
		self.team:setOwner(self)
		self.team:load(data.team)
	end
	
	if data.currentProject then
		self.currentProject = self:getProjectByUniqueID(data.currentProject)
	end
	
	if data.themeMastery then
		for themeID, mastery in pairs(data.themeMastery) do
			self.themeMastery[themeID] = mastery
		end
		
		for genreID, mastery in pairs(data.genreMastery) do
			self.genreMastery[genreID] = mastery
		end
	end
	
	for key, employeeData in ipairs(data.employees) do
		local employeeObject = developer.new()
		
		employeeObject:setEmployer(self)
		employeeObject:load(employeeData)
		self:addEmployee(employeeObject, true)
		
		if employeeObject:getFact(rivalGameCompany.CEO_FACT) then
			self.portrait = employeeObject:getPortrait()
		end
	end
	
	if data.playerStealAttemptEmployees then
		for key, employeeID in ipairs(data.playerStealAttemptEmployees) do
			local employee = self:getEmployeeByUniqueID(employeeID)
			
			if employee and employee:getFact(rivalGameCompany.EMPLOYEE_STEAL_FACT) then
				self.playerStealAttemptEmployees[#self.playerStealAttemptEmployees + 1] = employee
			end
		end
	end
	
	if data.timeUntilEmployeeSwitch then
		for key, employeeID in ipairs(data.timeUntilEmployeeSwitch) do
			local employee = self:getEmployeeByUniqueID(employeeID)
			
			if employee and employee:getFact(rivalGameCompany.SWITCH_IN_TIME_FACT) then
				self.timeUntilEmployeeSwitch[#self.timeUntilEmployeeSwitch + 1] = employee
			end
		end
	end
	
	if data.portrait and self.portrait then
		self.portrait:load(data.portrait)
	end
	
	local aliveCompany = not self.defunct and not self.boughtOut
	
	if aliveCompany then
		self.team:postLoad(data.team)
		
		for key, dev in ipairs(self.employees) do
			dev:postLoad()
		end
	end
	
	self._loading = false
	
	if aliveCompany then
		self:calculateTotalSalaries()
	end
	
	self:findCEO()
end
