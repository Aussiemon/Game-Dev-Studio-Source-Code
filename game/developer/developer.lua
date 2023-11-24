developer = {}
developer.baseClass = entity
developer.class = "developer"
developer.mtindex = {
	__index = developer
}
developer.EVENTS = {
	TASK_DONE = events:new(),
	SKILL_INCREASED = events:new(),
	ATTRIBUTE_INCREASED = events:new(),
	ATTRIBUTE_POINT_DRAINED = events:new(),
	LEVEL_UP = events:new(),
	DIED = events:new(),
	WORKPLACE_SET = events:new(),
	ROOM_SET = events:new(),
	TRAIT_ADDED = events:new(),
	TRAIT_REMOVED = events:new(),
	INTEREST_ADDED = events:new(),
	INTEREST_REMOVED = events:new(),
	SALARY_CHANGED = events:new(),
	TASK_CHANGED = events:new(),
	TASK_CANCELED = events:new(),
	SPECIALIZATION_SET = events:new(),
	DESIRED_SPECIALIZATION_SET = events:new(),
	SEX_CHANGED = events:new(),
	COMBOBOX_FILLED = events:new(),
	INFO_MENU_OPENED = events:new()
}
developer.ALWAYS_APPROVE_RAISES_PREFERENCE = "auto_approve_raises"
developer.ALWAYS_APPROVE_VACATIONS_PREFERENCE = "auto_approve_vacations"
developer.AUTO_SPEND_AP_PREFERENCE = "auto_spend_attribute_points"
developer.SKIP_RETIRE_DIALOGUE_PREFERENCE = "skip_retire_dialogue"
developer.BASE_ATTRIBUTE_POINTS = 15
developer.ATTRIBUTE_POINTS_PER_LEVEL = 1
developer.MAX_LEVEL = 10
developer.LEVEL_EXP_CURVE = {}
developer.BASE_LEVEL_EXP = -200
developer.EXP_PER_LEVEL = 300
developer.EXPONENT_PER_LEVEL = 1.4
developer.EXPERIENCE_SEGMENT = 50
developer.WALK_SPEED = {
	72,
	108
}
developer.ACTION_DELAY = 60
developer.PREFERRED_GENRE_DRIVE_LOSS_MULTIPLIER = 0.75
developer.CHANCE_TO_LEAVE_WHEN_NO_PAYCHECK = 5
developer.skillProgressionMultiplier = 1
developer.SKILL_EXP_TO_LEVEL_EXP = 5

for i = 1, developer.MAX_LEVEL do
	local requiredExp = developer.BASE_LEVEL_EXP + (developer.EXP_PER_LEVEL * i)^developer.EXPONENT_PER_LEVEL
	
	requiredExp = math.ceil(requiredExp / developer.EXPERIENCE_SEGMENT) * developer.EXPERIENCE_SEGMENT
	developer.LEVEL_EXP_CURVE[i] = requiredExp
end

developer.ASSIGNMENT_STATE = {
	CANT = 1,
	CAN = 0,
	SAME_DESK = 2,
	NO_DESK = 3
}
developer.START_DRIVE = {
	MAX = 80,
	MIN = 60
}
developer.MAX_DRIVE = 100
developer.MIN_DRIVE = 0
developer.DRIVE_BOOST_THRESHOLD = 50
developer.DRIVE_MAX_BOOST = 0.3
developer.DRIVE_MIN_DETER = -0.4
developer.SALARY_ROUND_SEGMENTS = 5
developer.SALARY_MODEL = 3
developer.SALARY_MODELS = {}
developer.BASE_SALARY = {
	addMin = 1,
	perLevel = 250,
	addMultiplier = 25,
	base = 150,
	addMax = 10
}
developer.MAX_SALARY_FROM_MAIN_SKILL = 25600
developer.SALARY_OFFSET_SKILL_LEVEL = -7
developer.SALARY_EXPONENT_SKILL_LEVEL = 2
developer.SALARY_ADD_PER_LEVEL = 75
developer.SALARY_ADD_PER_SKILL_LEVEL = 20
developer.SALARY_ADD_PER_DEVELOPMENT_LEVEL = 15
developer.TIME_BETWEEN_RAISE_REQUESTS = {
	90,
	200
}
developer.RAISE_DENY_POINT_MULTIPLIER = 1
developer.POST_HIRE_RAISE_ASK_DELAY = 60
developer.POST_DENY_RAISE_ASK_DELAY = {
	100,
	160
}
developer.RAISE_REQUEST_CHANCE = 40
developer.RAISE_POINTS_DECREASE_PER_SKILL_UP = 5
developer.APPROVE_RAISE_DRIVE_INCREASE = 25
developer.RAISE_DENY_TIME_DIVIDER = 1
developer.DRIVE_DROP_PER_RAISE_DENY = 10
developer.MAX_DRIVE_DROP_FROM_RAISE_DENY = 10
developer.LOW_DRIVE_LEVEL = 30
developer.MEDIUM_DRIVE_LEVEL = 65
developer.CONSIDER_LEAVING_DRIVE = 25
developer.LOW_DRIVE_LEAVE_CHANCE = 20
developer.LOW_DRIVE_LEAVE_TIME = {
	addMin = -3,
	maxDaysPerMonthWorked = 100,
	chance = 25,
	base = 40,
	addMax = 10,
	chanceAdd = 20,
	daysPerMonthWorked = 2.5
}
developer.LEAVE_RECONSIDERATION_CHANCE_ON_RAISE = 60
developer.DRIVE_INCREASE_PER_DAY = 2
developer.DRIVE_INCREASE_DECREASE_MODIFIER_PER_DAY_DENIED_RAISES = 0.25
developer.DRIVE_RECOVER_MULTIPLIER_INCREASE_PER_DAY = 0.1
developer.MIN_DAYS_UNTIL_DRIVE_LOSS = timeline.DAYS_IN_MONTH
developer.DAY_TO_DRIVE_LOSS = 1 / (timeline.DAYS_IN_MONTH * 3)
developer.DRIVE_FOR_VACATION = 35
developer.VACATION_REQUEST_BASE_CHANCE = 20
developer.VACATION_REQUEST_CHANCE_INCREASE_PER_DRIVE_POINT = 2
developer.VACATION_REQUEST_COOLDOWN = {
	timeline.DAYS_IN_MONTH * 3,
	timeline.DAYS_IN_MONTH * 4
}
developer.DRIVE_DROP_FROM_DENIED_VACATION = 5
developer.VACATION_DURATION = timeline.DAYS_IN_WEEK * 2
developer.NO_WORK_NO_VACATION_DRIVE_LOSS_MULTIPLIER = 0.2
developer.MAX_DRIVE_LOSS_PER_DAY = -1
developer.MAX_DRIVE_RECOVER_MULT_VACATION = 5
developer.GENERATE_AGE_MIN = 18
developer.GENERATE_AGE_MAX = 50
developer.RETIREMENT_AGE_MIN = 55
developer.RETIREMENT_AGE_MAX = 65
developer.GENERATE_LEVEL_MIN = 1
developer.GENERATE_LEVEL_MAX = 10
developer.STUDIO_REQUIREMENTS = {}
developer.FORGET_THANK_CHANCE = 50
developer.MINIMUM_KNOWLEDGE_FOR_DISPLAY = 10
developer.LEAVE_DUE_REPUTATION_CHANCE = 10
developer.JUSTAS_CHANCE = 3
developer.JUSTAS_GRUMPYNESS = 0.95
developer.GRUMPYNESS_CHANCE = 50
developer.MIN_GRUMPYNESS = 0
developer.MAX_GRUMPYNESS = 0.75
developer.LEAVE_AT_FRUSTRATION = 60
developer.MANAGING_OVERLOAD_TIME_PERIOD = 0
developer.NO_MANAGEMENT_PENALTY_MAX_DRIVE = 60
developer.NO_MANAGEMENT_PENALTY_MIN_DRIVE = 20
developer.NO_MANAGEMENT_PENALTY_DRIVE_DIST = math.dist(developer.NO_MANAGEMENT_PENALTY_MAX_DRIVE, developer.NO_MANAGEMENT_PENALTY_MIN_DRIVE)
developer.NO_MANAGEMENT_PENALTY_MAX_DROP = 0.4
developer.name = nil
developer.surname = nil
developer.CONVERSATION_DELAY_MIN = 240
developer.CONVERSATION_DELAY_MAX = 360
developer.PLAYER_CHARACTER_SKILL_ADVANCE_MODIFIER = 3
developer.FEMALE_CHANCE = 20
developer.PRACTICE_TIME_MIN = 1.5
developer.PRACTICE_TIME_MAX = 2
developer.PRACTICE_EXP_MIN = 30
developer.PRACTICE_EXP_MAX = 40
developer.PRACTICE_SESSIONS = 25
developer.PRACTICE_LEVEL_EXP_MULTIPLIER = 2
developer.HUNGRY_LEVEL = 50
developer.THIRSTY_LEVEL = 50
developer.SHIT_LEVEL = 75
developer.HYDRATION_LOSS_PER_DAY = 1
developer.SATIETY_LOSS_PER_DAY = 0.5
developer.FULLNESS_INCREASE_PER_DAY = 0.4
developer.SATIETY_TO_FULLNESS = 0.3
developer.FULLNESS_GAIN_FROM_COFFEE = 2
developer.HYDRATION_CHANGE_FROM_COFFEE = -2
developer.SATIETY_CHANGE_FROM_COFFEE = -2
developer.DEFAULT_OVERALL_EFFICIENCY = 1
developer.MAX_PEOPLE_IN_ROOM_UNTIL_EFFICIENCY_DROP = 20
developer.EFFICIENCY_DROP_PER_PERSON_OVER_MAX = 0.01
developer.EFFICIENCY_DROP_MIN_VALUE = 0.85
developer.LEAVE_REPUTATION_DIFFERENCE = 1000
developer.LEAVE_REPUTATION_PERCENTAGE_DIFFERENCE = 0.2
developer.KEYBOARD_CLICK_SOUND_DELAY = {
	7,
	9
}
developer.CATCHABLE_EVENTS = nil
developer.MIN_FAMILIARITY = 0.3
developer.NEW_PROJECT_FAMILIARITY = 0.8
developer.FAMILIARITY_REGAIN_PER_DAY = 0.02
developer.DAYS_AWAY_FROM_PROJECT_FAMILIARITY_LOSS = 10
developer.FAMILIARITY_LOSS_PER_DAY = 0.7 / timeline.DAYS_IN_YEAR
developer.FAMILIARITY_LOSS_FOR_WORK_OFFSET = 0.00023333333333333333
developer.PREFERRED_GAME_GENRE_MANAGEMENT_AFFECTOR = "preferred_game_genre"
developer.GREET_TEXT = {
	_T("DEVELOPER_GREET_TEXT_1", "Hey everyone!"),
	_T("DEVELOPER_GREET_TEXT_2", "Hey folks!"),
	_T("DEVELOPER_GREET_TEXT_3", "Hello everyone!"),
	_T("DEVELOPER_GREET_TEXT_4", "Good day, people!"),
	_T("DEVELOPER_GREET_TEXT_5", "Hey everyone!")
}
developer.DRIVE_TEXT = {
	{
		drive = 90,
		text = _T("DRIVE_LEVEL_FANTASTIC", "Fantastic")
	},
	{
		drive = 75,
		text = _T("DRIVE_LEVEL_GREAT", "Great")
	},
	{
		drive = 60,
		text = _T("DRIVE_LEVEL_GOOD", "Good")
	},
	{
		drive = 50,
		text = _T("DRIVE_LEVEL_OK", "OK")
	},
	{
		drive = 40,
		text = _T("DRIVE_LEVEL_DRAINED", "Drained")
	},
	{
		drive = 30,
		text = _T("DRIVE_LEVEL_TIRED", "Tired")
	},
	{
		drive = 15,
		text = _T("DRIVE_LEVEL_EXHAUSTED", "Exhausted")
	},
	{
		drive = 0,
		text = _T("DRIVE_LEVEL_AWFUL", "Awful")
	}
}
developer.STATE = {
	SITTING = 2,
	WALKING = 1,
	USING_OBJECT = 3
}

setmetatable(developer, entity.mtindex)

function developer.new()
	local new = {}
	
	setmetatable(new, developer.mtindex)
	new:init()
	
	return new
end

developer.CLOTHING_TYPE = {
	SHOES = 3,
	TORSO = 1,
	TROUSERS = 2
}
developer.CLOTHING_COLORS = {}

function developer.registerClothingColor(type, color)
	if not developer.CLOTHING_COLORS[type] then
		developer.CLOTHING_COLORS[type] = {}
	end
	
	table.insert(developer.CLOTHING_COLORS[type], color)
end

developer.registerClothingColor(developer.CLOTHING_TYPE.TORSO, color(255, 244, 245, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.TORSO, color(229, 52, 43, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.TORSO, color(201, 209, 255, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.TORSO, color(230, 230, 230, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.TORSO, color(25, 25, 25, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.TROUSERS, color(170, 217, 255, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.TROUSERS, color(124, 124, 124, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.TROUSERS, color(193, 123, 65, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.SHOES, color(255, 137, 161, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.SHOES, color(255, 198, 138, 255))
developer.registerClothingColor(developer.CLOTHING_TYPE.SHOES, color(177, 194, 211, 255))

function developer.pickRandomClothingColor(type)
	local list = developer.CLOTHING_COLORS[type]
	local index = math.random(1, #list)
	
	return list[index], index
end

function developer.getClothingColor(type, index)
	return developer.CLOTHING_COLORS[type][index]
end

function developer.registerSalaryModel(id, method)
	developer.SALARY_MODELS[id] = method
end

function developer.getSalaryModel(id)
	return developer.SALARY_MODELS[id]
end

developer.registerSalaryModel(1, function(devObj)
	local skillID, progressSpeed = attributes.profiler:getMainSkill(devObj.roleData)
	local curSkillLevel = devObj:getSkillLevel(skillID)
	local levelAffector = developer.SALARY_ADD_PER_LEVEL * devObj.level
	local skillAffector = developer.SALARY_ADD_PER_SKILL_LEVEL * curSkillLevel
	local developmentAffector = developer.SALARY_ADD_PER_DEVELOPMENT_LEVEL * devObj:getSkillLevel("development")
	
	return (levelAffector + skillAffector + developmentAffector) * devObj.salaryMultiplier
end)
developer.registerSalaryModel(2, function(devObj)
	local skillID, progressSpeed = attributes.profiler:getMainSkill(devObj.roleData)
	local curSkillLevel = devObj:getSkillLevel(skillID)
	local levelAffector = developer.SALARY_ADD_PER_LEVEL * devObj.level
	local skillAffector = math.min(developer.MAX_SALARY_FROM_MAIN_SKILL, math.max(1, curSkillLevel + developer.SALARY_OFFSET_SKILL_LEVEL)^developer.SALARY_EXPONENT_SKILL_LEVEL)
	local developmentAffector = developer.SALARY_ADD_PER_DEVELOPMENT_LEVEL * devObj:getSkillLevel("development")
	
	return (levelAffector + skillAffector + developmentAffector) * devObj.salaryMultiplier
end)

developer.THIRD_SALARY_MODEL_MULTIPLIER = 0.8

local secondModel = developer.getSalaryModel(2)

developer.registerSalaryModel(3, function(devObj)
	return secondModel(devObj) * developer.THIRD_SALARY_MODEL_MULTIPLIER
end)

function developer:init()
	developer.baseClass.init(self)
	
	self.issueDiscoverChanceMultipliers = {}
	self.skillSpeedBoosts = {}
	self.speedDevBoost = 1
	
	attributes:initAttributes(self)
	skills:initSkills(self)
	
	self.portrait = portrait.new(self)
	self.walkSpeed = math.random(developer.WALK_SPEED[1], developer.WALK_SPEED[2])
	self.level = 0
	self.experience = 0
	self.traitDiscovery = 0
	self.attributePoints = 0
	self.timeToAskForSalaryIncrease = 0
	self.stayConsiderationChance = 0
	self.pointsUntilRaise = 0
	self.deniedRaises = 0
	self.deniedVacations = 0
	self.vacationRequestCooldown = 0
	self.actionCooldown = 0
	self.hireTime = nil
	self.salaryOffset = 0
	
	self:setSalaryMultiplier(1)
	self:setBaseSalary(0)
	self:setSalary(0)
	
	self.facts = {}
	self.traits = {}
	self.interests = {}
	self.activityDesire = {}
	self.lastActivities = {}
	self.preferredGameGenres = {}
	self.involvedIn = {}
	self.lastInvolvement = {}
	self.lastInvolvementTime = {}
	self.familiarity = {}
	self.knowledge = {}
	self.knowledgeList = {}
	self.lastActionsByID = {}
	self.satiety = 100
	self.hydration = 100
	self.fullness = 0
	self.lastActivityTime = 0
	self.floor = 1
	self.bookExperienceGainModifiers = {}
	self.bookExperienceGainModifier = 1
	self.frustration = 0
	self.nextKeyboardClickSound = 0
	self.angleRotation = 0
	self.skillProgressMultiplier = 1
	self.interOfficePenaltyDiv = 0
	self.funds = 0
	self.conversationDelay = 0
	self.nextConversationDelay = 0
	self.talkText = nil
	self.currentRoom = nil
	self.talkTextTime = 0
	self.targetAngle = 0
	self.baseOverallEfficiency = developer.DEFAULT_OVERALL_EFFICIENCY
	self.overallEfficiency = developer.DEFAULT_OVERALL_EFFICIENCY
	self.maxPeopleUntilEfficiencyDrop = developer.MAX_PEOPLE_IN_ROOM_UNTIL_EFFICIENCY_DROP
	self.traitSpeedModifier = 1
	self.reputationAtHireTime = 0
	
	self:setExpoDriveDropMultiplier(1)
	self:rollGrumpyness()
	self:setDrive(math.random(developer.START_DRIVE.MIN, developer.START_DRIVE.MAX))
	self:setDriveRecoverSpeedMultiplier(1)
	
	self.driveChangeIndicator = objects.create("drive_change_display")
	
	self.driveChangeIndicator:setDeveloper(self)
	
	self.issueGenChanceMults = {}
	self.issueGenChanceMult = 1
	
	self:setIssueGenerateChanceMultiplier(1)
	
	self.driveLossSpeedMultipliers = {}
	self.driveLossSpeedMult = 1
	self.noManageDevSpeedAffectors = {}
	self.noManageDevSpeedAffector = 0
	self.officeDevSpeedMult = 1
	self.taskDriveLossMultiplier = 1
	self.developSpeedMultipliers = {}
	self.developSpeedMultiplier = 1
	
	self:setDaysWithoutVacation(0)
	self:initAvatar()
	self:setSize(studio.EMPLOYEE_SIZE, studio.EMPLOYEE_SIZE)
	self:resetRaisePoints()
	
	if game.worldObject then
		self:updateDevTree()
	end
end

function developer:initAvatar()
	local newAvatar = avatar.new()
	
	self:setAvatar(newAvatar)
end

function developer:setOfficeDevSpeedMultiplier(mult)
	self.officeDevSpeedMult = mult
	
	self:updateTaskProgressAmount()
end

function developer:getOfficeDevSpeedMultiplier()
	return self.officeDevSpeedMult
end

function developer:canAssignToTask()
	if self.employer == studio then
		return self.workplace and self.workplace:canBeUsed() and self.available
	end
	
	return true
end

function developer:enableRendering()
	self.employer:addRenderDeveloper(self)
	self.devTree:insert(self)
	
	self.canDrawAvatar = true
end

function developer:disableRendering()
	self.employer:removeRenderDeveloper(self)
	self.devTree:remove(self)
	
	self.canDrawAvatar = false
	
	self:leaveVisibilityRange()
end

function developer:setupVisualData()
	self:updateDevTree()
	
	self.grid = game.worldObject:getFloorTileGrid()
	self.objectGrid = game.worldObject:getObjectGrid()
end

function developer:onHired()
	self.roleData:onHired(self)
	self.avatar:setAnimation(self:getStandAnimation())
	
	if not self.awayUntil then
		self.available = true
		
		if self.employer:isPlayer() then
			self:enableRendering()
		end
	end
end

function developer:getDriveText()
	local valid, previous = nil, -math.huge
	local drive = self.drive
	
	for key, data in ipairs(developer.DRIVE_TEXT) do
		if drive >= data.drive and previous < data.drive then
			valid = key
			previous = data.drive
		end
	end
	
	return developer.DRIVE_TEXT[valid]
end

function developer:returnToWorkplace()
	self:removeQueuedPathSearch()
	self:abortCurrentAction()
	self:setWalkPath(nil)
	
	if self.workplace and self.workplace:canBeUsed() then
		self:setPos(self.workplace:getFacingPosition())
		self:faceObject(self.workplace)
		self:updateSitAnimation()
	end
end

function developer:playFootstep()
	if self.floor ~= camera:getViewFloor() then
		return 
	end
	
	local gridX, gridY = self:getTileCoordinates()
	local grid = self.grid
	local tile = grid:getTileID(grid:getTileIndex(gridX, gridY), self.floor)
	local surfaceType = floors:getSurfaceTypeForFloor(tile)
	local data = sound:play(surfaceType.stepSoundData, self, self:getCenterX(), self:getCenterY())
	
	data.soundObj:setPitch(math.randomf(0.7, 1.1))
end

function developer:playKeyboardClicks()
	if self.floor ~= camera:getViewFloor() then
		return 
	end
	
	if self.nextKeyboardClickSound > 0 then
		self.nextKeyboardClickSound = self.nextKeyboardClickSound - 1
		
		return 
	end
	
	if self.visible then
		sound:play("keyboard_clicks", self, self:getCenterX(), self:getCenterY())
		
		self.nextKeyboardClickSound = math.random(developer.KEYBOARD_CLICK_SOUND_DELAY[1], developer.KEYBOARD_CLICK_SOUND_DELAY[2])
	end
end

function developer:canSteal()
	return not self.playerCharacter and (not self.lastStealAttempt or timeline.curTime > self.lastStealAttempt + rivalGameCompanies.EMPLOYEE_STEAL_ATTEMPT_COOLDOWN)
end

function developer:attemptSteal(bonusPayment, rivalStudio)
	self.attemptedStealPayment = bonusPayment
	self.attemptedStealStudio = rivalStudio
	
	dialogueHandler:addDialogue("developer_rival_studio_steal_attempt", nil, self)
end

function developer:getAttemptedStealBonus()
	return self.attemptedStealPayment
end

function developer:getAttemptedStealStudio()
	return self.attemptedStealStudio
end

function developer:succeedSteal()
	self.baseSalary = self.baseSalary + self.attemptedStealPayment
	
	self:setSalary(self.unfinalizedSalary)
	self:resetRaisePoints(multiplier)
	self.attemptedStealStudio:onStealSuccess(self)
	
	self.attemptedStealPayment = nil
	self.attemptedStealStudio = nil
end

function developer:failSteal(bonusPaymentBoost)
	self.baseSalary = self.baseSalary + self.attemptedStealPayment + bonusPaymentBoost
	
	self:setSalary(self.unfinalizedSalary)
	self:resetRaisePoints(multiplier)
	
	self.lastStealAttempt = timeline.curTime
	
	self.attemptedStealStudio:onStealFail(self)
	
	self.lastFailedStealStudio = self.attemptedStealStudio:getID()
	self.attemptedStealPayment = nil
	self.attemptedStealStudio = nil
end

function developer:getLastFailStealStudio()
	return self.lastFailedStealStudio
end

function developer:getStealBonusDelta(extra)
	return self:finalizeSalary(self.unfinalizedSalary + extra + self.attemptedStealPayment) - self.salary
end

function developer:getMatchAcceptChance(extraMoney)
	local timeWorkedInStudio = self:getTimeWorkedInStudio()
	local financeMultiplier = self.employer:isGoingBankrupt() and rivalGameCompanies.STEAL_ACCEPT_CHANCE_BAD_FINANCES_MULTIPLIER or 1
	local playerChar = studio:getPlayerCharacter()
	local extraChance = 0
	
	if playerChar then
		extraChance = playerChar:getAttribute("charisma") * rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_CHARISMA_POINT
		
		if playerChar:hasTrait("silver_tongue") then
			extraChance = extraChance + rivalGameCompanies.MATCH_ACCEPT_CHANCE_FROM_SILVER_TONGUE
		end
	end
	
	return math.min(rivalGameCompanies.MINIMUM_MATCH_ACCEPT_CHANCE + extraChance + rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_MONTH_WORKED * timeWorkedInStudio + rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_DOLLAR * extraMoney + rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_DENIED_VACATION * self.deniedVacations + rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_DENIED_SALARY * self.deniedRaises, rivalGameCompanies.MAXIMUM_MATCH_ACCEPT_CHANCE) / financeMultiplier
end

function developer:getStealAttemptChance(extraMoney)
	local timeWorkedInStudio = self:getTimeWorkedInStudio()
	local financeMultiplier = self.employer:isGoingBankrupt() and rivalGameCompanies.STEAL_ACCEPT_CHANCE_BAD_FINANCES_MULTIPLIER or 1
	
	return math.min(rivalGameCompanies.MINIMUM_MATCH_ACCEPT_CHANCE + rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_MONTH_WORKED * timeWorkedInStudio + rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_DOLLAR * extraMoney, rivalGameCompanies.MAXIMUM_MATCH_ACCEPT_CHANCE) * financeMultiplier
end

function developer:getConsiderLeavingChance(offeredMoney)
	local financeMultiplier = self.employer:isGoingBankrupt() and rivalGameCompanies.STEAL_ACCEPT_CHANCE_BAD_FINANCES_MULTIPLIER or 1
	
	return math.min(rivalGameCompanies.LEAVE_CONSIDER_CHANCE_MINIMUM_CHANCE + math.max(rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_YEAR_IN_STUDIO_MAX, rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_YEAR_IN_STUDIO * math.floor(self:getTimeWorkedInStudio() / timeline.DAYS_IN_YEAR)) + rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_DENIED_VACATION * self.deniedVacations + rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_DENIED_SALARY * self.deniedRaises + rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_DOLLAR_OFFERED * rivalGameCompanies.LEAVE_CONSIDER_CHANCE_MAXIMUM_CHANCE) / financeMultiplier
end

function developer:getPortrait()
	return self.portrait
end

function developer:createPortrait()
	self.portrait:createRandomAppearance(self.nationality, self.female)
	self:setupAvatarColors()
end

function developer:updateSkinColors()
	local data = portrait.registeredDataByID
	
	self.avatar:setSkinColor(data[self.portrait:getSkinColor()].color)
	self.avatar:setHairColor(data[self.portrait:getHairColor()].color)
end

function developer:setupAvatarColors()
	self:updateSkinColors()
	
	local torsoColor, legColor, shoeColor
	
	if not self.torsoColor then
		local pickedColor, index = developer.pickRandomClothingColor(developer.CLOTHING_TYPE.TORSO)
		
		self.torsoColor = index
		torsoColor = pickedColor
		
		local pickedColor, index = developer.pickRandomClothingColor(developer.CLOTHING_TYPE.TROUSERS)
		
		self.legColor = index
		legColor = pickedColor
		
		local pickedColor, index = developer.pickRandomClothingColor(developer.CLOTHING_TYPE.SHOES)
		
		self.shoeColor = index
		shoeColor = pickedColor
	else
		torsoColor = developer.getClothingColor(developer.CLOTHING_TYPE.TORSO, self.torsoColor)
		legColor = developer.getClothingColor(developer.CLOTHING_TYPE.TROUSERS, self.legColor)
		shoeColor = developer.getClothingColor(developer.CLOTHING_TYPE.SHOES, self.shoeColor)
	end
	
	self.avatar:setTorsoColor(torsoColor)
	self.avatar:setLegColor(legColor)
	self.avatar:setShoeColor(shoeColor)
end

function developer:rebuildFonts()
	developer.talkTextFont = fonts.get("pix_world20")
end

function developer:setCanReachExit(can)
	self.canReachExit = can
end

function developer:getCanReachExit()
	return self.canReachExit
end

function developer:displayDriveChange(change)
	self.driveChangeIndicator:displayDriveChange(change)
end

function developer:rollForFemale()
	if math.random(1, 100) <= developer.FEMALE_CHANCE then
		self:setIsFemale(true)
	else
		self:setIsFemale(false)
	end
end

function developer:assignUniqueID()
	if self.uniqueID then
		return 
	end
	
	self.uniqueID = game.UNIQUE_ID_COUNTER
	game.UNIQUE_ID_COUNTER = game.UNIQUE_ID_COUNTER + 1
end

function developer:setUniqueID(uniqueID)
	self.uniqueID = uniqueID
end

function developer:getUniqueID()
	return self.uniqueID
end

function developer:setSkillLevel(skillID, level)
	self.skills[skillID].level = level
end

function developer:getPracticeableSkill()
	if self.roleData.mainSkill then
		if not self:canPracticeSkill(self.roleData.mainSkill) then
			return nil
		end
		
		return self.roleData.mainSkill
	end
	
	for key, skillData in ipairs(skills.registered) do
		if self.skills[skillData.id].level < self.roleData.maxSkillLevels[skillData.id] then
			return skillData.id
		end
	end
end

function developer:practiceSkill(skillID)
	if self.workplace and self.workplace:canBeUsed() then
		local task = game.createPracticeTask(skillID, developer.PRACTICE_EXP_MIN, developer.PRACTICE_EXP_MAX, developer.PRACTICE_TIME_MIN, developer.PRACTICE_TIME_MAX, developer.PRACTICE_SESSIONS)
		
		task:setSkillLevelExperienceIncreaseMultiplier(developer.PRACTICE_LEVEL_EXP_MULTIPLIER)
		self:setTask(task)
		
		return task
	end
end

function developer:practiceMainSkill()
	local skillID = self:getPracticeableSkill()
	
	if skillID then
		self:practiceSkill(skillID)
	end
end

function developer:addPreferredGameGenre(genreID)
	self.preferredGameGenres[genreID] = true
end

function developer:setBookExperienceGainModifier(id, mod)
	self.bookExperienceGainModifiers[id] = mod
	self.bookExperienceGainModifier = 1
	
	for id, modifier in pairs(self.bookExperienceGainModifiers) do
		self.bookExperienceGainModifier = self.bookExperienceGainModifier + modifier
	end
end

function developer:getBookExperienceGainModifier()
	return self.bookExperienceGainModifier
end

function developer:adjustBookExperienceBoost(boost)
	if boost > 1 then
		boost = boost * self.bookExperienceGainModifier
	end
	
	return boost
end

function developer:onProjectChanged(newProject, oldProject)
	self:calculateTraitDevelopSpeedModifier(newProject)
	
	if not self.team:isLoading() or not self.familiarity[newProject:getFamiliarityUniqueID()] then
		self:calculateFamiliarityAffector(newProject)
	end
	
	if newProject then
		if newProject.PROJECT_TYPE == gameProject.PROJECT_TYPE then
			if self.preferredGameGenres[newProject:getGenre()] then
				self:setNoManagementDevSpeedAffector(developer.PREFERRED_GAME_GENRE_MANAGEMENT_AFFECTOR, 1)
			else
				self:setNoManagementDevSpeedAffector(developer.PREFERRED_GAME_GENRE_MANAGEMENT_AFFECTOR, nil)
			end
		else
			self:setNoManagementDevSpeedAffector(developer.PREFERRED_GAME_GENRE_MANAGEMENT_AFFECTOR, nil)
		end
	else
		self:setNoManagementDevSpeedAffector(developer.PREFERRED_GAME_GENRE_MANAGEMENT_AFFECTOR, nil)
	end
	
	if oldProject and newProject ~= oldProject then
		local uid = oldProject:getFamiliarityUniqueID()
		
		self.lastInvolvementTime[uid] = timeline.curTime
		self.lastInvolvement[uid] = oldProject:getTotalFinishedWork()
	end
end

function developer:onProjectRemoved(oldProject)
	if oldProject then
		local uid = oldProject:getFamiliarityUniqueID()
		
		self.lastInvolvementTime[uid] = timeline.curTime
		self.lastInvolvement[uid] = oldProject:getTotalFinishedWork()
		
		if self.task and self.task:getTargetProject() == oldProject:getTargetProject() then
			self:setTask(nil)
		end
	end
end

function developer:calculateTraitDevelopSpeedModifier(newProject)
	local total = 1
	
	for key, traitID in ipairs(self.traits) do
		local traitData = traits.registeredByID[traitID]
		
		if traitData.getDevSpeedModifier then
			total = total + traitData:getDevSpeedModifier(self, curProject)
		end
	end
	
	self.traitSpeedModifier = total
	
	self:updateTaskProgressAmount()
end

function developer:getTraitDevelopSpeedModifiers()
	return self.traitSpeedModifier
end

function developer:offerWork(targetTeam)
	self.offeredWork = true
	
	if targetTeam then
		self.targetTeam = targetTeam:getUniqueID()
	end
end

function developer:getTargetTeam()
	return self.targetTeam
end

function developer:removeWorkOffer()
	self.offeredWork = false
	self.targetTeam = nil
end

developer.offerJob = developer.offerWork

function developer:hasOfferedWork()
	return self.offeredWork
end

developer.hasOfferedJob = developer.hasOfferedWork

function developer:canRetire()
	return game.canRetire and self:getAge() >= self.retirementAge
end

function developer:startDescendantCreationCallback()
	self.employee:_retire()
	self.employee:startDescendantCreation()
end

eventBoxText:registerNew({
	id = "employee_retired",
	getText = function(self, data)
		local nameData = data.name
		
		if data.team then
			return _format(_T("EMPLOYEE_RETIRED_TEAM_EVENT_BOX", "NAME has retired. They were ROLE of team 'TEAM'."), "NAME", names:getFullName(nameData[1], nameData[2], nameData[3], nameData[4]), "ROLE", attributes.profiler:getRoleData(data.role).personDisplay, "TEAM", data.team)
		end
		
		return _format(_T("EMPLOYEE_RETIRED_EVENT_BOX", "NAME has retired. They were ROLE."), "NAME", names:getFullName(nameData[1], nameData[2], nameData[3], nameData[4]), "ROLE", attributes.profiler:getRoleData(data.role).personDisplay)
	end
})

function developer:retire()
	if self.employer:isPlayer() then
		if self.playerCharacter then
			local popup = game.createPopup(500, _T("PLAYER_CHARACTER_RETIRED_TITLE", "Player Character Retired"), string.easyformatbykeys(_T("PLAYER_CHARACTER_RETIRED_DESC", "Having steered the company and worked on various game projects for years, you've grown old and have retired.\n\nYour descendant inherits the company, and now you will have to create a new player character."), "NAME", self:getFullName(true)), fonts.get("pix24"), fonts.get("pix20"), true)
			
			popup:hideCloseButton()
			
			popup:addButton("pix22", _T("CREATE_NEW_CHARACTER", "Create new character"), developer.startDescendantCreationCallback).employee = self
			
			popup:center()
			frameController:push(popup)
		else
			if preferences:get(developer.SKIP_RETIRE_DIALOGUE_PREFERENCE) then
				if self.team then
					game.addToEventBox("employee_retired", {
						name = {
							self:getNameConfig()
						},
						role = self.role,
						team = self.team:getName()
					}, 1, nil, "exclamation_point")
				else
					game.addToEventBox("employee_retired", {
						name = {
							self:getNameConfig()
						},
						role = self.role
					}, 1, nil, "exclamation_point")
				end
			else
				dialogueHandler:addDialogue("employee_retire_1", nil, self)
			end
			
			self:_retire()
		end
	else
		self:_retire()
	end
end

function developer:_retire()
	self.employer:fireEmployee(self, studio.EMPLOYEE_LEAVE_REASONS.RETIRED)
end

function developer:startDescendantCreation()
	characterDesigner:begin(true, game.DESCENDANT_STARTING_SKILL_LEVELS)
end

function developer:setRetirementAge(age)
	self.retirementAge = age
end

function developer:getRetirementAge()
	return self.retirementAge
end

function developer:setAge(age)
	self.age = math.abs(age - (timeline.baseYear + timeline.curTime / timeline.DAYS_IN_YEAR))
end

function developer:getAge()
	return math.floor(math.abs(self.age - (timeline.baseYear + timeline.curTime / timeline.DAYS_IN_YEAR)))
end

function developer:setBookedExpo(expoID)
	self.bookedExpo = expoID
end

function developer:getBookedExpo()
	return self.bookedExpo
end

function developer:autoSpendAttributePoints()
	if self.attributePoints > 0 then
		local speedData = attributes.registeredByID.speed
		local latestAttribute
		
		while self.attributePoints > 0 do
			local attributeID = self.roleData:getIncreasableAttribute(self)
			
			if attributeID then
				self:increaseAttribute(attributeID)
				
				latestAttribute = attributeID
			elseif self.attributes.speed < speedData.maxLevel then
				self:increaseAttribute("speed")
				
				latestAttribute = "speed"
			else
				break
			end
		end
		
		return latestAttribute
	end
end

function developer:setAwayUntil(time, skipReassignment)
	self.awayUntil = time
	self.available = not time
	
	if time then
		if self.employer then
			self.employer:removeActiveDeveloper(self)
			
			if self.devTree and self.employer:isPlayer() then
				self:disableRendering()
			end
		end
		
		local taskProject
		
		if self.task and self.task:canUnassignOnAway() then
			taskProject = self.task:getProject()
			
			self:setTask(nil)
		end
		
		if self.team then
			if not skipReassignment then
				local teamProject = self.team:getProject()
				
				if teamProject and teamProject == taskProject then
					self.team:reassignEmployees()
				end
			end
			
			self.team:onEmployeeAway(self)
		end
		
		if self.conversation then
			self.conversation:abort()
		end
		
		self.roleData:onAway(self, time)
	else
		if self.employer then
			self.employer:addActiveDeveloper(self)
			
			if self.avatar and self.employer:isPlayer() then
				self:enableRendering()
			end
		end
		
		if self.team then
			self.team:onEmployeeReturned(self)
		end
		
		self.roleData:onAway(self, time)
	end
end

function developer:getAwayUntil()
	return self.awayUntil
end

function developer:isAvailable()
	return self.available
end

function developer:queueVacation(date)
	date = date or math.floor(timeline.curTime) + timeline.DAYS_IN_WEEK * 2
	self.vacationDate = date
end

function developer:getDeniedVacations()
	return self.deniedVacations
end

function developer:denyVacation()
	self.deniedVacations = self.deniedVacations + 1
	self.vacationRequestCooldown = timeline.curTime + math.random(developer.VACATION_REQUEST_COOLDOWN[1], developer.VACATION_REQUEST_COOLDOWN[2])
	
	self:addDrive(-developer.DRIVE_DROP_FROM_DENIED_VACATION)
end

eventBoxText:registerNew({
	id = "auto_approved_vacation",
	getText = function(self, data)
		return _format(_T("AUTOMATIC_VACATION_APPROVAL", "Auto-approved vacation request for NAME. They will soon go on vacation for 2 weeks."), "NAME", names:getFullName(data[1], data[2], data[3], data[4]))
	end
})

function developer:approveVacation(vacationDate, automaticApproval)
	self:queueVacation(vacationDate)
	
	self.deniedVacations = 0
	
	if automaticApproval then
		game.addToEventBox("auto_approved_vacation", {
			self:getNameConfig()
		}, 1, nil, "exclamation_point")
	end
end

function developer:goOnVacation(duration)
	duration = duration or developer.VACATION_DURATION
	self.onVacation = true
	
	self:setAwayUntil(timeline.curTime + duration)
	
	self.daysWithoutVacation = 0
	
	self:setDriveRecoverSpeedMultiplier(developer.MAX_DRIVE_RECOVER_MULT_VACATION)
	
	self.deniedVacations = 0
	self.vacationDate = nil
	
	self.employer:changeOnVacationEmployeeCount(1)
end

function developer:approveVacationOption()
	self.developer:approveVacation()
end

function developer:alwaysApproveVacations()
	self.developer:approveVacation()
	preferences:set(developer.ALWAYS_APPROVE_VACATIONS_PREFERENCE, true)
end

function developer:denyVacationOption()
	self.developer:denyVacation()
end

function developer:askForVacation()
	if preferences:get(developer.ALWAYS_APPROVE_VACATIONS_PREFERENCE) then
		self:approveVacation(nil, true)
		
		return 
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("VACATION_REQUEST_TITLE", "Vacation Request"))
	popup:setTextFont(fonts.get("pix20"))
	
	local text = string.easyformatbykeys(_T("VACATION_REQUEST_TEMPLATE", "NAME wishes to go on vacation for 2 weeks. If you approve, he will be gone in 2 weeks."), "NAME", self:getFullName(true))
	
	popup:setText(text)
	popup:hideCloseButton()
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	extra:addText(self.roleData.display, "bh22", game.UI_COLORS.LIGHT_BLUE, 6, popup.rawW - 20, self.roleData:getRoleIconConfig(24))
	
	local skillID, mainSkillLevel
	
	if self.roleData.mainSkill then
		skillID = self.roleData.mainSkill
		mainSkillLevel = self:getSkillLevel(skillID)
	else
		skillID, mainSkillLevel = self:getHighestSkill()
	end
	
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_2, nil, "weak_gradient_horizontal")
	extra:addText(skills.registeredByID[skillID]:getSkillLevelText(self), "bh20", game.UI_COLORS.IMPORTANT_3, 0, popup.rawW - 20, self.roleData:getRoleIconConfig(24))
	
	popup:addButton(fonts.get("pix20"), _T("APPROVE_VACATION", "Approve vacation"), developer.approveVacationOption).developer = self
	popup:addButton(fonts.get("pix20"), _T("ALWAYS_APPROVE_VACATION", "Approve & always approve vacations"), developer.alwaysApproveVacations).developer = self
	popup:addButton(fonts.get("pix20"), _T("DENY_VACATION", "Deny vacation"), developer.denyVacationOption).developer = self
	
	popup:center()
	frameController:push(popup)
end

function developer:returnToStudio()
	self:setAwayUntil(nil)
	
	if self.team and self.team:getProject() then
		self.team:reassignEmployees()
	end
	
	if self.task then
		self.employer:addActiveDeveloper(self)
	end
	
	if self.onVacation then
		self.employer:changeOnVacationEmployeeCount(-1)
		
		self.onVacation = false
	end
end

function developer:setDaysWithoutVacation(days)
	self.daysWithoutVacation = days
end

function developer:getDaysWithoutVacation()
	return self.daysWithoutVacation
end

function developer:addDaysWithoutVacation(amt)
	self:setDaysWithoutVacation(math.max(0, self.daysWithoutVacation + amt))
end

function developer:queueThankForPurchase(object)
	self.thankForPurchaseOf = object:getClass()
end

function developer:getObjectToThankFor()
	return self.thankForPurchaseOf
end

function developer:setTeam(teamObj, skipStatUpdate)
	local lastTeam = self.team
	
	self.team = teamObj
	
	if not teamObj and lastTeam then
		local oldProj = lastTeam:getProject()
		
		if oldProj then
			local uid = oldProj:getFamiliarityUniqueID()
			
			self.lastInvolvementTime[uid] = timeline.curTime
			self.lastInvolvement[uid] = oldProj:getTotalFinishedWork()
		end
		
		if self.task and oldProj and oldProj:getTargetProject() == self.task:getTargetProject() then
			self:setTask(nil)
		end
	end
	
	if not skipStatUpdate then
		local projectObject = self.team and self.team:getProject()
		
		self:calculateFamiliarityAffector(projectObject)
	end
end

function developer:canAskForRaise()
	return not self.playerCharacter and timeline.curTime > self.timeToAskForSalaryIncrease and self.pointsUntilRaise <= 0 and math.random(1, 100) <= developer.RAISE_REQUEST_CHANCE
end

local skillDifference = {
	changed = {},
	unchanged = {}
}

developer.sortObject = nil

function developer.sortByBiggestChange(a, b)
	local self = developer.sortObject
	
	return self.skills[a].level - self.skillsBeforeRaiseRequest[a].level > self.skills[b].level - self.skillsBeforeRaiseRequest[b].level
end

function developer:approveRaiseOption()
	self.developer:approveRaise()
end

function developer:denyRaiseOption()
	self.developer:denyRaise()
end

function developer:getChangedSkills()
	local previousSkills = self.skillsBeforeRaiseRequest
	
	for key, skillData in ipairs(skills.registered) do
		local skillID = skillData.id
		local previous = previousSkills[skillID]
		
		if self.skills[skillID].level - previous.level ~= 0 then
			table.insert(skillDifference.changed, skillID)
		else
			table.insert(skillDifference.unchanged, skillID)
		end
	end
	
	developer.sortObject = self
	
	table.sort(skillDifference.changed, developer.sortByBiggestChange)
	
	developer.sortObject = nil
	
	return skillDifference, self.skillsBeforeRaiseRequest
end

function developer:addChangedSkillsToPopup(popup, previousSkills)
	local scroller = popup:createScroller(nil, 200)
	
	scroller:setSpacing(4)
	scroller:setPadding(4, 4)
	
	for skillID, data in pairs(self.skills) do
		local previous = previousSkills[skillID]
		
		if data.level - previous.level ~= 0 then
			table.insert(skillDifference.changed, skillID)
		else
			table.insert(skillDifference.unchanged, skillID)
		end
	end
	
	if #skillDifference.changed > 0 then
		local category = gui.create("Category")
		
		category:setHeight(28)
		category:setFont(fonts.get("pix28"))
		category:setText(_T("IMPROVED_SKILLS", "Improved skills"))
		category:assumeScrollbar(scroller)
		scroller:addItem(category)
		
		developer.sortObject = self
		
		table.sort(skillDifference.changed, developer.sortByBiggestChange)
		
		developer.sortObject = nil
		
		for key, skillID in ipairs(skillDifference.changed) do
			local cur = self.skills[skillID]
			local previous = previousSkills[skillID]
			local progressDisplay = gui.create("SkillChangeDisplay")
			
			progressDisplay:setHeight(26)
			progressDisplay:setSkill(skillID, cur.level)
			progressDisplay:setPreviousSkill(previous.level)
			category:addItem(progressDisplay)
		end
	end
	
	if #skillDifference.unchanged > 0 then
		local category = gui.create("Category")
		
		category:setHeight(28)
		category:setFont(fonts.get("pix28"))
		category:setText(_T("UNCHANGED_SKILLS", "Unchanged skills"))
		category:assumeScrollbar(scroller)
		scroller:addItem(category)
		
		for key, skillID in ipairs(skillDifference.unchanged) do
			local cur = self.skills[skillID]
			local previous = self.skillsBeforeRaiseRequest[skillID]
			local progressDisplay = gui.create("SkillChangeDisplay")
			
			progressDisplay:setHeight(26)
			progressDisplay:setSkill(skillID, cur.level)
			progressDisplay:setPreviousSkill(previous.level)
			category:addItem(progressDisplay)
		end
	end
end

function developer:createChangedSkillsPopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(400)
	popup:setFont(fonts.get("pix28"))
	popup:setTitle(_T("CHANGED_SKILLS_TITLE", "Changed Skills"))
	popup:setTextFont(fonts.get("pix24"))
	
	local text = string.easyformatbykeys(_T("CHANGED_SKILLS_DESCRIPTION", "The following skills were improved since NAME asked for a raise last time."), "NAME", self:getFullName(true))
	
	popup:setText(text)
	popup:hideCloseButton()
	self:addChangedSkillsToPopup(popup, self.skillsBeforeRaiseRequest)
	
	developer.sortObject = nil
	
	table.clear(skillDifference.changed)
	table.clear(skillDifference.unchanged)
	
	return popup
end

eventBoxText:registerNew({
	id = "auto_approved_raise",
	getText = function(self, data)
		return _format(_T("AUTO_APPROVED_RAISE", "Increased salary to $NEW_SALARY from $OLD_SALARY for NAME"), "NEW_SALARY", string.roundtobignumber(data.newSalary), "OLD_SALARY", string.roundtobignumber(data.prevSalary), "NAME", names:getFullName(data.name[1], data.name[2], data.name[3], data.name[4]))
	end
})

function developer:askForRaise()
	if preferences:get(developer.ALWAYS_APPROVE_RAISES_PREFERENCE) then
		local prevSalary = self:getSalary()
		
		self:approveRaise()
		
		local newSalary = self:getSalary()
		
		game.addToEventBox("auto_approved_raise", {
			newSalary = newSalary,
			prevSalary = prevSalary,
			name = {
				self:getNameConfig()
			}
		}, 1, nil, "wad_of_cash_plus")
		
		return 
	end
	
	dialogueHandler:addDialogue("developer_raise_question_1", nil, self)
end

function developer:getDeniedRaises()
	return self.deniedRaises
end

function developer:denyRaise()
	self.deniedRaises = self.deniedRaises + 1
	
	self:setDriveRecoverSpeedMultiplier(0)
	self:addDrive(-self.deniedRaises * developer.DRIVE_DROP_PER_RAISE_DENY)
	
	local lowDriveData = developer.LOW_DRIVE_LEAVE_TIME
	
	if self.drive <= developer.CONSIDER_LEAVING_DRIVE and not self.timeToConsiderLeaving and math.random(1, 100) <= lowDriveData.chance + lowDriveData.chanceAdd * (self.deniedRaises - 1) then
		self:resetLowDriveLeaveTime()
	end
	
	local rng = developer.POST_DENY_RAISE_ASK_DELAY
	
	self.timeToAskForSalaryIncrease = timeline.curTime + math.random(rng[1], rng[2])
	
	self:resetRaisePoints(developer.RAISE_DENY_POINT_MULTIPLIER)
end

function developer:approveRaise()
	self.deniedRaises = 0
	self.lastRaiseTime = timeline.curTime
	self.timeToConsiderLeaving = nil
	
	self:setSalary(self:calculateSalary())
	self:addDrive(developer.APPROVE_RAISE_DRIVE_INCREASE)
	self:setDriveRecoverSpeedMultiplier(1)
	self:resetRaisePoints()
	self:markPreRaiseRequestSkills()
end

function developer:getLastRaiseTime()
	return self.lastRaiseTime
end

function developer:setHireTime(time)
	self.hireTime = time
end

function developer:setDevelopSpeedMultiplier(id, mult)
	self.developSpeedMultipliers[id] = mult
	self.developSpeedMultiplier = self:calculateDevelopSpeedMultiplier()
	
	self:updateTaskProgressAmount()
end

function developer:updateTaskProgressAmount()
	local taskObj = self.task
	
	if taskObj then
		taskObj:queueProgressUpdate()
	end
end

function developer:calculateDevelopSpeedMultiplier()
	local total = 1
	
	for id, mult in pairs(self.developSpeedMultipliers) do
		total = total * mult
	end
	
	return total
end

function developer:getDevelopSpeedMultiplier()
	return self.developSpeedMultiplier
end

function developer:getTimeWorkedInStudio()
	if not self.hireTime then
		return 0
	end
	
	return math.dist(self.hireTime, timeline.curTime)
end

developer.getTimeEmployed = developer.getTimeWorkedInStudio

function developer:resetLowDriveLeaveTime()
	local monthsWorked = timeline:getMonths(self.hireTime, timeline.curTime)
	local data = developer.LOW_DRIVE_LEAVE_TIME
	local considerationDays = data.base
	
	considerationDays = considerationDays + math.random(data.addMin, data.addMax) + math.min(data.daysPerMonthWorked * monthsWorked, data.maxDaysPerMonthWorked)
	self.timeToConsiderLeaving = considerationDays
end

function developer:setIsFemale(state)
	self.female = state
	
	if state then
		self.portrait:setBeard(nil)
		self:setAnimationList(developer.ANIM_LIST.female)
	else
		self:setAnimationList(developer.ANIM_LIST.male)
	end
	
	events:fire(developer.EVENTS.SEX_CHANGED, self)
end

function developer:isFemale()
	return self.female
end

function developer:setNationality(nat)
	self.nationality = nat
end

function developer:getNationality()
	return self.nationality
end

function developer:assignRandomName()
	local first, last, nationality = names:getRandomSequentialName(self.female)
	
	self:setName(first)
	self:setSurname(last)
	self:setNationality(nationality)
	self:setupName()
end

function developer:setupName()
	if self.playerCharacter then
		self.displayName = _T("PLAYER_CHARACTER_NAME", "Player")
		self.displaySurname = _T("PLAYER_CHARACTER_SURNAME", "character")
	else
		if not self.name then
			return 
		end
		
		self.displayName = names:getFirstName(self.nationality, self.female, self.name)
		self.displaySurname = names:getLastName(self.nationality, self.female, self.surname)
	end
	
	self.displayFullname = _format("FIRST LAST", "FIRST", self.displayName, "LAST", self.displaySurname)
end

function developer:getNameConfig()
	return self.name, self.surname, self.nationality, self.female
end

function developer:getTeam()
	return self.team
end

function developer:isAssignedToTeam()
	return self.team ~= nil
end

function developer:traitHandleEvent(event, ...)
	for key, traitID in ipairs(self.traits) do
		traits.registeredByID[traitID]:onEvent(self, event, ...)
	end
end

function developer:roleHandleEvent(event, ...)
	self.roleData:onEvent(self, event, ...)
end

function developer:initEventHandler()
	events:addFunctionReceiver(self, developer.handleNewDay, timeline.EVENTS.NEW_DAY)
	events:addFunctionReceiver(self, developer.handleNewWeek, timeline.EVENTS.NEW_WEEK)
	events:addFunctionReceiver(self, developer.handleNewMonth, timeline.EVENTS.NEW_MONTH)
	events:addFunctionReceiver(self, developer.handleObjectRemoval, studio.expansion.EVENTS.REMOVED_OBJECT)
	events:addFunctionReceiver(self, developer.handleObjectPlacement, studio.expansion.EVENTS.PLACED_OBJECT)
	events:addFunctionReceiver(self, developer.handlePathInvalidation, pathCaching.EVENTS.PATHS_INVALIDATED)
	events:addFunctionReceiver(self, developer.handleInterestBoostRecalculation, officeBuilding.EVENTS.RECALCULATED_INTEREST_BOOSTS)
	self:startTraitEventHandler()
	self:startRoleEventHandler()
end

function developer:removeEventHandler()
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_DAY)
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_WEEK)
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_MONTH)
	events:removeFunctionReceiver(self, studio.expansion.EVENTS.REMOVED_OBJECT)
	events:removeFunctionReceiver(self, studio.expansion.EVENTS.PLACED_OBJECT)
	events:removeFunctionReceiver(self, pathCaching.EVENTS.PATHS_INVALIDATED)
	events:removeFunctionReceiver(self, officeBuilding.EVENTS.RECALCULATED_INTEREST_BOOSTS)
	self:removeTraitEventHandler()
	self:removeRoleEventHandler()
end

function developer:remove()
	developer.baseClass.remove(self)
	self:removeEventHandler()
	
	if self.workplace then
		self.workplace:clearAssignedEmployee()
	end
	
	if self.avatar then
		self.avatar:remove()
		
		self.avatar = nil
	end
	
	self.portrait = nil
	
	self.driveChangeIndicator:remove()
	
	self.driveChangeIndicator = nil
	
	if self.task then
		self.task:remove()
		
		self.task = nil
	end
	
	table.clear(self.facts)
	
	self.facts = nil
	self.traits = nil
	self.interests = nil
	self.activityDesire = nil
	self.lastActivities = nil
	self.preferredGameGenres = nil
	self.involvedIn = nil
	self.lastInvolvement = nil
	self.lastInvolvementTime = nil
	self.familiarity = nil
	self.knowledge = nil
	self.knowledgeList = nil
	self.lastActionsByID = nil
	
	if self.devTree then
		self.devTree:remove(self)
	end
end

function developer:setAvatar(avatar)
	self.avatar = avatar
	
	self.avatar:setOwner(self)
	self.avatar:updateAnimation()
end

function developer:setAnimation(anim, speed, type)
	return self.avatar:setAnimation(anim, speed, type)
end

function developer:getAvatar()
	return self.avatar
end

function developer:setName(name)
	self.name = name
end

function developer:setSurname(surname)
	self.surname = surname
end

function developer:getFullName(merged)
	if merged then
		return self.displayFullname
	end
	
	return self.displayName, self.displaySurname
end

function developer:getName()
	return self.displayName
end

function developer:getSurname()
	return self.displaySurname
end

function developer:getAttributes()
	return self.attributes
end

function developer:getAttribute(attribute)
	return self.attributes[attribute]
end

function developer:setAttributes(attributes)
	self.attributes = attributes
end

function developer:setAttribute(attributeID, level)
	self.attributes[attributeID] = level
end

function developer:setPos(x, y)
	developer.baseClass.setPos(self, x, y)
	
	local midX, midY = self:getCenter()
	
	self:checkForRoom(self.grid:worldToIndex(midX, midY))
	
	if self.employer:isPlayer() and self.canDrawAvatar then
		self.devTree:insert(self)
	end
end

function developer:canLeaveDueToLowReputation()
	return not self.facts[rivalGameCompany.CEO_FACT] and self.reputationAtHireTime - studio:getReputation() > developer.LEAVE_REPUTATION_DIFFERENCE + developer.LEAVE_REPUTATION_PERCENTAGE_DIFFERENCE * self.reputationAtHireTime
end

function developer:attemptConsiderLeaveDueToLowReputation()
	if not self.timeToConsiderLeaving and self:canLeaveDueToLowReputation() then
		if math.random(1, 100) <= developer.LEAVE_DUE_REPUTATION_CHANCE then
			self:resetLowDriveLeaveTime()
		else
			self.reputationAtHireTime = studio:getReputation()
		end
	end
end

function developer:setRoom(roomObject)
	local prevRoom = self.room
	
	developer.baseClass.setRoom(self, roomObject)
	self.roleData:setRoom(self, roomObject)
	
	for key, traitID in ipairs(self.traits) do
		traits.registeredByID[traitID]:onRoomChanged(self, self.room)
	end
	
	if prevRoom and prevRoom ~= self.room then
		prevRoom:removeAssignedEmployee(self)
	end
	
	if self.room and prevRoom ~= self.room then
		self.room:addAssignedEmployee(self)
	end
	
	if self.employer and self.employer:getCanUpdateOverallEfficiency() then
		if prevRoom and prevRoom ~= roomObject then
			prevRoom:calculateOverallEmployeeEfficiency()
		end
		
		if roomObject then
			roomObject:calculateOverallEmployeeEfficiency()
		end
	end
	
	events:fire(developer.EVENTS.ROOM_SET, self, roomObject)
end

function developer:removeFromRoom(dereferenceOnly)
	if dereferenceOnly then
		self.currentWalkRoom = nil
	elseif self.currentWalkRoom then
		self.currentWalkRoom:removeEmployee(self)
		
		self.currentWalkRoom = nil
	end
end

function developer:greetPeople()
	self:setTalkText(developer.GREET_TEXT[math.random(1, #developer.GREET_TEXT)], nil)
end

function developer:setShouldGreet(state)
	self.shouldGreetPeople = state
end

function developer:checkForRoom(index)
	local prevRoom = self.currentWalkRoom
	local room = self.employer:getRoomOfIndex(index, self.floor)
	
	if prevRoom ~= room then
		if prevRoom then
			prevRoom:removeEmployee(self)
		end
		
		if room then
			room:addEmployee(self)
			
			if self.shouldGreetPeople then
				if #room:getEmployees() > 0 then
					self:greetPeople()
				end
				
				self.shouldGreetPeople = false
			end
		end
	end
	
	if self.currentWalkObjects then
		for key, object in ipairs(self.currentWalkObjects) do
			object:onLeaveReach(self)
		end
	end
	
	if self.walkPath then
		local objects = self.objectGrid:getObjectsFromIndex(index, self.floor)
		
		if objects then
			for key, object in ipairs(objects) do
				object:onReach(self, index, self.currentWalkIndex, self.curWalkIndex and self.walkPath[self.curWalkIndex + 1])
			end
		end
	end
	
	self.currentWalkObjects = objects
	self.currentWalkIndex = index
	self.currentWalkRoom = room
end

function developer:getCurrentWalkRoom()
	return self.currentWalkRoom
end

function developer:setCurrentAction(action)
	self.currentAction = action
	
	if action then
		action:begin(self)
	elseif not self.walkPath then
		self:goToWorkplace()
	end
end

function developer:getCurrentAction()
	return self.currentAction
end

function developer:abortCurrentAction()
	if self.currentAction then
		self.currentAction:abort()
		
		self.currentAction = nil
		
		if not self.walkPath then
			self:goToWorkplace()
		end
		
		return true
	end
	
	return false
end

function developer:getActionCooldown()
	return self.actionCooldown
end

function developer:isCooldownOver()
	return timeline:getPassedTime() > self.actionCooldown
end

function developer:getLastActionIDTime(id)
	return self.lastActionsByID[id] or -developerActions.TIME_BETWEEN_SAME_ACTION_PERFORM
end

function developer:setAngleRotation(ang)
	self.angleRotation = math.normalizeAngle(ang)
	self.angleRotationRad = math.rad(self.angleRotation - 90)
end

function developer:getAngleRotation()
	return self.angleRotation
end

function developer:faceObject(obj, snapAngle)
	local angles = obj:getFacingAngles(self)
	
	if snapAngle then
		self:setAngleRotation(angles)
	end
	
	self:setTargetAngle(angles)
	obj:onBeingFaced(self)
end

function developer:setTargetAngle(ang)
	self.targetAngle = math.normalizeAngle(ang)
end

function developer:getWalkAnim()
	if self.carryObject then
		local anim = self.carryObjectData:getWalkAnim(self)
		
		if anim then
			return anim
		end
	end
	
	return self.animList.walk
end

function developer:setWalkPath(walkPath, skipTargetObjectReset)
	if walkPath then
		self:setIsOnWorkplace(false)
	end
	
	self.curWalkIndex = 1
	self.walkPath = walkPath
	
	if walkPath then
		self:checkForRoom(self.walkPath[1])
		self.avatar:setAnimation(self:getWalkAnim(), 1.5 * self.walkSpeed / 96)
		self.avatar:setDrawOffset(0, 0)
		
		self.walkPathDestinationIndex = self.walkPath[#self.walkPath]
		
		local objectGrid = self.objectGrid
		local x, y = objectGrid:getCoordinatesFromIndex(self.walkPathDestinationIndex)
		local objects = objectGrid:getObjects(x, y, self.floor)
		
		for key, object in ipairs(objects) do
			if object then
				self.walkPathDestinationObject = object
				
				break
			end
		end
	else
		self:updateSitAnimation()
		
		self.walkPathDestinationObject = nil
		self.walkPathDestinationIndex = nil
		
		if not skipTargetObjectReset then
			self:setTargetObject(nil)
		end
	end
end

function developer:onPathInvalidated()
	if self.walkPath then
		self.targetStaircase = nil
		self.staircasePath = nil
		self.walkPath = nil
		
		if self.currentAction then
			if self.currentAction:onPathInvalidated() then
				self:goTowardsTargetObject()
			else
				self:abortCurrentAction()
			end
		elseif self.targetObject then
			self:goTowardsTargetObject()
		end
	end
end

function developer:setCarryObject(objectType)
	self.carryObject = objectType
	self.carryObjectData = carryObjects.registeredByID[objectType]
	self.carryOffsets = self.carryObjectData:getFrameOffsets(self)
	
	local quadStruct, spritebatch = carryObjects.getDrawables(objectType)
	
	self.avatar:addProp(objectType, spritebatch, quadStruct)
end

function developer:getCarryObject()
	return self.carryObject
end

function developer:getCarryAnimation()
	return self.animList.walk_carry
end

function developer:clearCarryObject()
	if self.carryObject then
		self.avatar:removeProp(self.carryObject)
	end
	
	self.carryObject = nil
	self.carryObjectData = nil
end

function developer:getStandAnimation()
	return self.animList.stand
end

function developer:getInteractAnimation()
	return self.animList.interact
end

function developer:getToiletAnimation()
	return self.animList.toilet
end

function developer:getWorkplaceAnimation()
	return self.animList.work
end

function developer:getSitAnimation()
	return self.animList.sit
end

function developer:getWalkAnimation()
	return self.animList.walk
end

function developer:updateSitAnimation()
	if not self.walkPath then
		if self.workplace then
			if self.onWorkplace then
				self:faceObject(self.workplace)
				
				if self.task then
					local animList, animObjs = self.avatar:setAnimation(self.animList.work, 0.65, tdas.ANIMATION_TYPES.LOOP)
					
					self.avatar:randomizeAnimationProgress()
					
					for key, id in ipairs(animList) do
						local obj = animObjs[id]
						
						if obj then
							obj:setType(tdas.ANIMATION_TYPES.RANDOMFRAME)
						end
					end
				else
					self.avatar:setAnimation(self.animList.sit, 1, tdas.ANIMATION_TYPES.LOOP)
				end
				
				self:updateDeskObjects()
				self:clearCarryObject()
			end
		else
			self.avatar:setAnimation(self.animList.stand, 1)
		end
	end
end

function developer:hasCoffee()
	return (self:getFact("coffee") or 0) > 0
end

function developer:canDrinkCoffee()
	return self.avatar:getCurAnim() == avatar.ANIM_SIT_IDLE and self:hasCoffee() and timeline.curTime > (self:getFact("coffee_drink_wait") or 0)
end

function developer:drinkCoffee()
	self:setFact("coffee", (self:getFact("coffee") or 1) - 1)
	self:setFact("coffee_drink_wait", timeline.curTime + math.randomf(5, 10))
	self.avatar:addAnimToQueue(self.animList.drink_sit)
	self.workplace:removeCoffee()
	self:changeFullness(developer.FULLNESS_GAIN_FROM_COFFEE)
	self:changeHydration(developer.HYDRATION_CHANGE_FROM_COFFEE)
	self:changeSatiety(developer.SATIETY_CHANGE_FROM_COFFEE)
end

function developer:updateDeskObjects()
	if (self:getFact("coffee") or 0) > 0 then
		self.workplace:addCoffee()
	else
		self.workplace:removeCoffee()
	end
end

function developer:getWalkPath()
	return self.walkPath, self.curWalkIndex
end

function developer:setRole(role)
	self.role = role
	self.roleData = attributes.profiler.rolesByID[role]
	
	self:verifyBaseSalary()
end

function developer:startRoleEventHandler()
	if self.roleData.CATCHABLE_EVENTS then
		events:addDirectReceiver(self, self.roleData.CATCHABLE_EVENTS, "roleHandleEvent")
	end
end

function developer:removeRoleEventHandler()
	if self.roleData.CATCHABLE_EVENTS then
		events:removeDirectReceiver(self, self.roleData.CATCHABLE_EVENTS, "roleHandleEvent")
	end
end

function developer:getRole()
	return self.role
end

function developer:addExperience(amount)
	if self.level == developer.MAX_LEVEL then
		return 
	end
	
	local newExp = self.experience + amount
	local residue = newExp - self:getExperienceToLevelup()
	
	if residue > 0 then
		self.experience = 0
		
		self:levelUp(residue)
	else
		self.experience = newExp
	end
end

eventBoxText:registerNew({
	id = "auto_spent_attribute",
	getText = function(self, data)
		local text
		
		if data.playerCharacter then
			text = _T("PLAYER_CHARACTER", "Player character")
		else
			text = names:getFullName(data.name[1], data.name[2], data.name[3], data.name[4])
		end
		
		return _format(_T("CHARACTER_SPENT_ATTRIBUTE", "NAME has gained a level and spent their attribute points on ATTRIBUTE!"), "NAME", text, "ATTRIBUTE", attributes.registeredByID[data.attribute].display)
	end
})
eventBoxText:registerNew({
	id = "character_level_up",
	getText = function(self, data)
		local text
		
		if data.playerCharacter then
			text = _T("PLAYER_CHARACTER", "Player character")
		else
			text = names:getFullName(data.name[1], data.name[2], data.name[3], data.name[4])
		end
		
		return _format(_T("CHARACTER_LEVEL_UP", "NAME has gained a level and POINTS attribute point!"), "NAME", text, "POINTS", data.ap)
	end
})

function developer:levelUp(residue)
	self:setLevel(self.level + 1)
	self:addAttributePoints(developer.ATTRIBUTE_POINTS_PER_LEVEL)
	self:addExperience(residue)
	
	if self.employer:isPlayer() then
		if self.attributePoints > 0 then
			self.avatar:addStatusIcon("level_up")
		end
		
		if preferences:get(developer.AUTO_SPEND_AP_PREFERENCE) then
			local attributeID = self:autoSpendAttributePoints()
			
			if attributeID then
				game.addToEventBox("auto_spent_attribute", {
					name = {
						self:getNameConfig()
					},
					playerCharacter = self.playerCharacter,
					attribute = attributeID
				}, 1, nil, "increase")
			else
				game.addToEventBox("character_level_up", {
					name = {
						self:getNameConfig()
					},
					playerCharacter = self.playerCharacter,
					ap = developer.ATTRIBUTE_POINTS_PER_LEVEL
				}, 1, nil, "increase")
			end
		else
			game.addToEventBox("character_level_up", {
				name = {
					self:getNameConfig()
				},
				playerCharacter = self.playerCharacter,
				ap = developer.ATTRIBUTE_POINTS_PER_LEVEL
			}, 1, nil, "increase")
		end
	else
		self:autoSpendAttributePoints()
	end
	
	events:fire(developer.EVENTS.LEVEL_UP, self)
end

function developer:addAttributePoints(amount)
	self.attributePoints = self.attributePoints + amount
end

function developer:setAttributePoints(amount)
	self.attributePoints = amount
end

function developer:getAttributePoints()
	return self.attributePoints
end

function developer:setLevel(level)
	self.level = level
	
	self:verifyBaseSalary()
end

function developer:getLevel()
	return self.level
end

function developer:isLastLevel()
	return self.level == developer.MAX_LEVEL
end

function developer:getExperienceToLevelup()
	return developer.LEVEL_EXP_CURVE[math.min(self.level + 1, developer.MAX_LEVEL)]
end

function developer:getExperience()
	return self.experience
end

function developer:getSkills()
	return self.skills
end

function developer:getSkill(skill)
	return self.skills[skill]
end

function developer:changeHydration(change)
	self.hydration = math.clamp(self.hydration + change, 0, 100)
end

function developer:getHydration()
	return self.hydration
end

function developer:isThirsty()
	return self.hydration <= developer.THIRSTY_LEVEL
end

function developer:changeFullness(change)
	self.fullness = math.clamp(self.fullness + change, 0, 100)
end

function developer:getFullness()
	return self.fullness
end

function developer:canShit()
	return self:getFullness() >= developer.SHIT_LEVEL
end

function developer:changeSatiety(change)
	self.satiety = math.clamp(self.satiety + change, 0, 100)
	
	if change > 0 then
		self:changeFullness(change * developer.SATIETY_TO_FULLNESS)
	end
end

function developer:getSatiety()
	return self.satiety
end

function developer:isHungry()
	return self.satiety <= developer.HUNGRY_LEVEL
end

function developer:getSkillLevel(skill)
	return self.skills[skill].level
end

function developer:getSkillMasteryLevel(skillID)
	return self.skills[skillID].level - self:getMaxSkillLevel(skillID)
end

function developer:getSkillLevelDisplay(skill)
	return math.min(self.skills[skill].level, skills.registeredByID[skill].maxLevel)
end

function developer:isSkillHighEnough(skillID, level)
	return level <= self.skills[skillID].level
end

function developer:getSkillExperience(skill)
	return self.skills[skill].experience
end

function developer:getSkillProgressPercentage(skillID)
	return skills:getLevelUpProgress(self, skillID)
end

function developer:skillIncreased(skill, newLevel, gainedLevels)
	self.pointsUntilRaise = self.pointsUntilRaise - developer.RAISE_POINTS_DECREASE_PER_SKILL_UP * gainedLevels
	
	if self.team then
		self.team:onEmployeeSkillIncreased(self, skill, newLevel)
	end
	
	if self.playerCharacter and newLevel >= game.MAX_PC_SKILL_UNTIL_NO_MULT then
		self.skillProgressionMultiplier = 1
	end
end

function developer:setSkills(skillList, init)
	self.skills = skillList
	
	if not init then
		skills:updateSkillDevSpeedAffectors(self)
	end
end

function developer:onDevSpeedAffectorsUpdated()
	self:updateTaskProgressAmount()
end

function developer:getDevSpeedBoosts()
	return self.skillSpeedBoosts
end

function developer:getSkillDevBoost(skillID)
	return self.skillSpeedBoosts[skillID]
end

function developer:setSkill(skillID, level)
	self.skills[skillID].level = level
end

function developer:setOverallSkillProgressionMultiplier(mult)
	self.skillProgressionMultiplier = mult
end

function developer:getOverallSkillProgressionMultiplier()
	return self.skillProgressionMultiplier
end

function developer:setSkillProgressionMultipliers(mults)
	self.skillProgressMultipliers = mults
end

function developer:setSkillProgressionMultiplier(skillID, amount)
	self.skillProgressMultipliers[skillID] = amount
end

function developer:setSkillProgressionModifier(mult)
	self.skillProgressMultiplier = mult
end

function developer:getSkillProgressionMultiplier(skillID)
	return self.skillProgressMultipliers[skillID] * self.skillProgressMultiplier
end

function developer:setMaxSkillLevels(levels)
	self.maxSkills = levels
end

function developer:getMaxSkillLevels()
	return self.maxSkills
end

function developer:getMaxSkillLevel(skillID)
	if self.maxSkills then
		return self.maxSkills[skillID] or skills:getMaxSkillLevel(skillID)
	end
	
	return skills:getMaxSkillLevel(skillID)
end

function developer:isAttributeMaxed(desiredAttribute)
	return not attributes:canProgress(self, desiredAttribute)
end

function developer:canImproveAttribute(desiredAttribute)
	return self:hasAttributePoints(desiredAttribute) and not self:isAttributeMaxed(desiredAttribute)
end

function developer:hasAttributePoints(desiredAttribute)
	return self.attributePoints >= attributes:getRequiredAttributePoints(self, desiredAttribute)
end

function developer:changeAttribute(attributeID, changeAmount)
	attributes:increaseAttribute(self, attributeID, changeAmount)
	events:fire(developer.EVENTS.ATTRIBUTE_CHANGED, self, attributeID, changeAmount)
end

function developer:resetAttribute(attributeID)
	local previous = self.attributes[attributeID]
	
	self.attributes[attributeID] = 0
	
	return previous
end

function developer:increaseAttribute(attributeID, free)
	self:drainAttributePoint(free, attributeID)
	attributes:increaseAttribute(self, attributeID)
	
	if self.team then
		self.team:onEmployeeAttributeIncreased(self, attributeID)
	end
	
	if self.attributePoints <= 0 then
		self.avatar:removeStatusIcon("level_up")
	end
	
	events:fire(developer.EVENTS.ATTRIBUTE_INCREASED, self, attributeID, free)
end

function developer:drainAttributePoint(free, increasedAttribute)
	if not free then
		self.attributePoints = self.attributePoints - attributes:getRequiredAttributePoints(self, increasedAttribute)
	end
	
	events:fire(developer.EVENTS.ATTRIBUTE_POINT_DRAINED, self)
end

function developer:increaseSkill(skillID, experience)
	experience = experience * self:getSkillProgressionMultiplier(skillID) * self.skillProgressionMultiplier
	
	skills:progressSkill(self, skillID, experience)
	self:addExperience(experience / developer.SKILL_EXP_TO_LEVEL_EXP)
end

function developer:getFamiliarityAffector(projectUID)
	return self.familiarity[projectUID]
end

function developer:calculateFamiliarityAffector(newProject)
	if newProject then
		local isNewProject = newProject:getOverallCompletion() == 0
		local projectID = newProject:getFamiliarityUniqueID()
		
		if isNewProject then
			self.familiarity[projectID] = developer.NEW_PROJECT_FAMILIARITY
		else
			local lastInvolvement = self.lastInvolvement[projectID]
			
			if lastInvolvement then
				local timeAffector = math.max(0, timeline.curTime - developer.DAYS_AWAY_FROM_PROJECT_FAMILIARITY_LOSS - self.lastInvolvementTime[projectID]) * developer.FAMILIARITY_LOSS_PER_DAY
				
				self.familiarity[projectID] = math.max(developer.MIN_FAMILIARITY, self.familiarity[projectID] - (newProject:getTotalFinishedWork() - lastInvolvement) * developer.FAMILIARITY_LOSS_FOR_WORK_OFFSET - timeAffector)
			else
				self.familiarity[projectID] = developer.MIN_FAMILIARITY
				self.lastInvolvement[projectID] = self.totalFinishedWork
				self.lastInvolvementTime[projectID] = timeline.curTime
			end
		end
	end
end

function developer:regainFamiliarity(projectID)
	self.familiarity[projectID] = math.min(1, self.familiarity[projectID] + developer.FAMILIARITY_REGAIN_PER_DAY)
	
	self:updateTaskProgressAmount()
end

function developer:onProjectScrapped(scrappedProj)
	if self.task then
		self.task:onProjectScrapped(scrappedProj)
	end
end

function developer:setTask(task)
	if self.task and task ~= self.task then
		self.task:setAssignee(nil)
		self.task:validateIssueState()
	end
	
	self.task = task
	
	local validForVisuals = self.employer and self.employer:isPlayer()
	
	if validForVisuals then
		self:updateTaskIndication()
	end
	
	if task then
		task:setAssignee(self)
		task:validateIssueState()
		task:onBeginWork()
		
		local project = task:getProject()
		
		if project then
			local uniqueID = project:getUniqueID()
			
			self.involvedIn[uniqueID] = self.involvedIn[uniqueID] or 0
		end
		
		if self.employer then
			self.employer:addActiveDeveloper(self)
		end
	elseif self.employer then
		self.employer:removeActiveDeveloper(self)
	end
	
	if self.team then
		self.team:onEmployeeTaskChanged(self, task)
	end
	
	if validForVisuals then
		if self.mouseOver then
			self:updateMouseOverText()
		end
		
		self:updateSitAnimation()
	end
	
	self:updateTaskDriveLossMultiplier()
	events:fire(developer.EVENTS.TASK_CHANGED, self)
end

function developer:updateTaskDriveLossMultiplier()
	if self.task then
		self.taskDriveLossMultiplier = 1
		
		local project = self.task:getProject()
		
		if project and project.PROJECT_TYPE == gameProject.PROJECT_TYPE then
			local genre = project:getGenre()
			
			if self.preferredGameGenres[genre] then
				self.taskDriveLossMultiplier = developer.PREFERRED_GENRE_DRIVE_LOSS_MULTIPLIER
			end
		end
	else
		self.taskDriveLossMultiplier = developer.NO_WORK_NO_VACATION_DRIVE_LOSS_MULTIPLIER
	end
end

function developer:updateTaskIndication()
	if self.employer and self.employer:isPlayer() then
		self.avatar:onSetTask(self.task)
	end
end

function developer:cancelTask()
	if self.task then
		self.task:cancel()
		
		self.task = nil
	end
	
	self:updateSitAnimation()
	events:fire(developer.EVENTS.TASK_CANCELED, self)
end

function developer:getTask()
	return self.task
end

function developer:hasTask()
	return self.task ~= nil
end

function developer:setSalary(salary)
	self.unfinalizedSalary = salary
	self.salary = self:finalizeSalary(salary)
	
	events:fire(developer.EVENTS.SALARY_CHANGED, self)
end

function developer:getUnfinalizedSalary()
	return self.unfinalizedSalary
end

function developer:getSalary()
	return self.salary
end

function developer:finalizeSalary(desiredSalary)
	return math.round((desiredSalary + self.baseSalary + self.salaryOffset) / developer.SALARY_ROUND_SEGMENTS * EMPLOYEE_SALARY_MULTIPLIER) * developer.SALARY_ROUND_SEGMENTS
end

function developer:setDriveLossSpeedMultiplier(id, mult)
	self.driveLossSpeedMultipliers[id] = mult
	self.driveLossSpeedMult = 1
	
	for id, mod in pairs(self.driveLossSpeedMultipliers) do
		self.driveLossSpeedMult = self.driveLossSpeedMult + mod
	end
end

function developer:getDriveLossSpeedMultiplier()
	return self.driveLossSpeedMult
end

function developer:getSpecificDriveLossSpeedMultiplier(mult)
	return self.driveLossSpeedMultipliers[mult]
end

function developer:setBaseSalary(salary)
	self.baseSalary = salary
end

function developer:getBaseSalary()
	if self.playerCharacter then
		return 0
	end
	
	return self.baseSalary
end

function developer:setSalaryMultiplier(mult)
	self.salaryMultiplier = mult
end

function developer:addFunds(amount)
	self.funds = self.funds + amount
end

function developer:getFunds()
	return self.funds
end

function developer:getSalaryMultiplier()
	return self.salaryMultiplier
end

function developer:applyDefaultSalary()
	self:setBaseSalary(self:calculateBaseSalary())
	self:setSalary(self:calculateSalary())
end

function developer:rollGrumpyness()
	if self.playerCharacter then
		self:setGrumpyness(0)
		
		return 
	end
	
	if math.random(1, 100) <= developer.JUSTAS_CHANCE then
		self:setGrumpyness(developer.JUSTAS_GRUMPYNESS)
	elseif math.random(1, 100) <= developer.GRUMPYNESS_CHANCE then
		local amount = math.randomf(developer.MIN_GRUMPYNESS, developer.MAX_GRUMPYNESS)
		
		self:setGrumpyness(amount)
	else
		self:setGrumpyness(0)
	end
end

function developer:markActivityTime(activity, time)
	self.lastActivities[activity] = time
	self.lastActivityTime = time
end

function developer:findLastActivityTime()
	for activityID, time in pairs(self.lastActivities) do
		self.lastActivityTime = math.max(self.lastActivityTime, time)
	end
end

function developer:getLastActivityTime()
	return self.lastActivityTime
end

function developer:getActivityTime(activity)
	return self.lastActivities[activity]
end

function developer:setGrumpyness(amount)
	self.grumpyness = amount
end

function developer:getGrumpyness()
	return self.grumpyness
end

function developer:setActivityDesireToGo(activity, willGo)
	self.activityDesire[activity] = willGo
end

function developer:getActivityDesireToGo(activity)
	return self.activityDesire[activity]
end

function developer:getRoleData()
	return self.roleData
end

function developer:getHighestSkill()
	local highest, level = nil, -1
	
	for key, data in ipairs(skills.registered) do
		local skillData = self.skills[data.id]
		
		if level < skillData.level then
			highest = data.id
			level = skillData.level
		end
	end
	
	return highest, level
end

function developer:getMainSkill()
	return self.roleData.mainSkill
end

function developer:calculateSalary()
	return developer.getSalaryModel(game.salaryModel)(self)
end

function developer:getNewSalary()
	return self:finalizeSalary(self:calculateSalary())
end

function developer:verifyBaseSalary()
	if not self.baseSalary and self.level and self.role then
		self:setBaseSalary(self:calculateBaseSalary())
	end
end

function developer:calculateBaseSalary()
	local levelImpact = self.level * developer.BASE_SALARY.perLevel
	local additional = math.random(developer.BASE_SALARY.addMin, developer.BASE_SALARY.addMax) * developer.BASE_SALARY.addMultiplier
	
	return (developer.BASE_SALARY.base + levelImpact + additional) * self.salaryMultiplier
end

function developer:setLastPaycheck(time)
	self.lastPaycheck = time
end

function developer:testGame(projObj)
	self:setTask(projObj:createTestTask())
end

function developer:workOnTask(delta, progress)
	self.task:progress(delta, progress, self)
	
	if self.task:isDone() then
		self.task:onFinish()
		
		if self.task:getUnassignOnFinish() then
			self:setTask(nil)
			events:fire(developer.EVENTS.TASK_DONE, self)
			
			if self.team then
				self.team:onFinishedTask(self)
			end
		else
			events:fire(developer.EVENTS.TASK_DONE, self)
		end
	end
end

function developer:goToWorkplace()
	if not self.onWorkplace and self.workplace then
		self:setTargetObject(self.workplace)
	end
end

function developer:onPathFound(foundPath)
	self.queuedSearch = nil
	
	self:setWalkPath(foundPath)
	
	if self.currentAction then
		self.currentAction:onPathFound(foundPath)
	end
end

function developer:onPathfindFailed()
	self.queuedSearch = false
	self.targetStaircase = nil
	self.staircasePath = nil
	
	self:abortCurrentAction()
end

function developer:queuePathSearch(targetObject, x, y)
	if not x then
		x, y = targetObject:getEntranceInteractionCoordinates()
	end
	
	if pathComputeQueue:addToQueue(self, targetObject, x, y) then
		self.queuedSearch = true
	end
end

function developer:removeQueuedPathSearch()
	if self.queuedSearch then
		pathComputeQueue:cancelPathfind(self)
		
		self.queuedSearch = nil
	end
end

function developer:placeOutsideOffice()
	local tile = self.office:getSpawnTile()
	
	if tile then
		local grid = self.grid
		local tileX, tileY = grid:convertIndexToCoordinates(tile)
		local tileW, tileH = grid:getTileSize()
		
		self:setPos(tileX * tileW, tileY * tileH)
	end
end

developer.NEXT_CELL_DIRECTION_DISTANCE = 0.6
developer.NEXT_CELL_MAX_TURN_AMOUNT = 0.8

function developer:update(delta, progress)
	if self.task then
		self:workOnTask(delta, progress)
	end
end

function developer:canBeRendered()
	return self.canRender
end

function developer:setLastAction(id, delay)
	self.lastActionsByID[id] = delay
end

function developer:setActionCooldown(time)
	self.actionCooldown = time
end

function developer:setRequiresPathRecompute(state)
	self.requiresPathRecomputation = state
end

function developer:updateVisual(delta)
	if self.walkPath then
		self:useWalkPath(delta)
	end
	
	self.angleRotation = math.approachAngle(self.angleRotation, self.targetAngle, delta * 540)
	self.angleRotationRad = math.rad(self.angleRotation - 90)
	
	self.avatar:update(delta)
end

function developer:useWalkPath(dt)
	local index = self.curWalkIndex
	local path = self.walkPath
	local ourX, ourY = self.x, self.y
	local gridIndex = path[index]
	
	if gridIndex then
		local floorTileGrid = self.grid
		local gridX, gridY = floorTileGrid:convertIndexToCoordinates(gridIndex)
		local x, y = floorTileGrid:gridToWorld(gridX, gridY)
		local progress = dt * self.walkSpeed
		local deg = math.directiontodeg(ourY - y, ourX - x)
		local nextCell = path[index + 1]
		
		if nextCell then
			local dist = 1 - math.max(math.dist(ourX, x), math.dist(ourY, y)) / game.WORLD_TILE_WIDTH
			
			if dist >= developer.NEXT_CELL_DIRECTION_DISTANCE then
				local gridX, gridY = floorTileGrid:convertIndexToCoordinates(nextCell)
				local x, y = floorTileGrid:gridToWorld(gridX, gridY)
				
				deg = math.lerpAngle(deg, math.directiontodeg(ourY - y, ourX - x), (dist - developer.NEXT_CELL_DIRECTION_DISTANCE) / (1 - developer.NEXT_CELL_DIRECTION_DISTANCE) * developer.NEXT_CELL_MAX_TURN_AMOUNT)
			end
		end
		
		if self.targetAngle ~= deg then
			self:setTargetAngle(deg)
		end
		
		self.x = math.approach(ourX, x, progress)
		self.y = math.approach(ourY, y, progress)
		
		self.devTree:insert(self)
		
		if self.x == x and self.y == y then
			self.curWalkIndex = index + 1
			
			if nextCell then
				self:onNextWalkCell()
				self:checkForRoom(nextCell)
			end
		end
	else
		self:onFinishedWalking()
	end
end

function developer:onNextWalkCell()
end

function developer:onFinishedWalking()
	local targetObj = self.targetObject
	local ourFloor = self.floor
	local targetPath
	
	if targetObj then
		if self.targetStaircase then
			local objFloor = targetObj:getFloor()
			local usedPath
			
			if objFloor < ourFloor then
				targetPath = self.targetStaircase:getPathDown()
			elseif ourFloor < objFloor then
				targetPath = self.targetStaircase:getPathUp()
			end
			
			self.targetStaircase = nil
			self.staircasePath = targetPath
		elseif self.staircasePath then
			local objFloor = targetObj:getFloor()
			
			if objFloor < ourFloor then
				self:setFloor(ourFloor - 1)
			elseif ourFloor < objFloor then
				self:setFloor(ourFloor + 1)
			end
			
			self.staircasePath = nil
			
			self:setWalkPath(nil, true)
			self:goTowardsTargetObject()
			
			return 
		end
	end
	
	if not self.currentAction then
		if self.workplace and ourFloor == self.workplace:getFloor() then
			self:faceObject(self.workplace)
		end
	else
		self.currentAction:onFinishedWalking(self.walkPath[#self.walkPath])
	end
	
	self:setWalkPath(targetPath)
end

function developer:canResearch()
	return self.available and (not self.task or self.task:isDone() or self.task:canStopToResearch())
end

function developer:canContributeToTasks()
	return self.available and (not self.task or self.task and self.task:canCrossContribute())
end

function developer:isIdling()
	if not self.available then
		return false
	end
	
	if self.task and not self.task:isDone() then
		return false
	end
	
	return true
end

function developer:isHired()
	return self.hired
end

function developer:resetRaisePoints(multiplier)
	multiplier = multiplier or 1
	
	local rng = developer.TIME_BETWEEN_RAISE_REQUESTS
	
	self.pointsUntilRaise = math.random(rng[1], rng[2]) * multiplier
end

function developer:setAnimationList(list)
	self.animList = list
end

function developer:getAnimationList()
	return self.animList
end

function developer:setHired(state)
	self.hired = state
	
	if state then
		self:setupVisualData()
		
		if not self._loading then
			self.timeToAskForSalaryIncrease = timeline.curTime + developer.POST_HIRE_RAISE_ASK_DELAY
		end
		
		self.avatar:setAnimation(self:getStandAnimation())
	end
end

function developer:markPreRaiseRequestSkills()
	self.skillsBeforeRaiseRequest = table.copy(self.skills)
	
	return self.skillsBeforeRaiseRequest
end

function developer:markSkillsAtHireTime()
	self.skillsAtHireTime = table.copy(self.skills)
	
	return self.skillsAtHireTime
end

function developer:setExpoDriveDropMultiplier(mult)
	self.expoDriveDropMultiplier = mult
end

function developer:getExpoDriveDropMultiplier()
	return self.expoDriveDropMultiplier
end

function developer:addDrive(amount)
	self:setDrive(self.drive + amount)
end

function developer:setDrive(drive)
	self.drive = math.clamp(drive, developer.MIN_DRIVE, self:getMaxDrive())
	self.driveDevAffector = self:calculateDriveDevSpeedModifier()
	
	self:updateTaskProgressAmount()
end

function developer:isPlayerCharacter()
	return self.playerCharacter
end

function developer:setIsPlayerCharacter(is)
	self.playerCharacter = is
	
	if is and self.employer then
		self.employer:setPlayerCharacter(self)
	end
	
	if is then
		self:setupName()
	end
end

function developer:getDrive()
	if self.playerCharacter then
		return developer.MAX_DRIVE
	end
	
	return self.drive
end

function developer:setDriveRecoverSpeedMultiplier(mult)
	self.driveRecoverMult = math.clamp(mult, 0, 1)
end

function developer:addDriveRecoverSpeedMultiplier(amt)
	self:setDriveRecoverSpeedMultiplier(self.driveRecoverMult + amt)
end

function developer:getMaxDrive()
	return math.max(developer.MAX_DRIVE - self.deniedRaises * developer.MAX_DRIVE_DROP_FROM_RAISE_DENY, 0)
end

function developer:setSpeedBoost(boost)
	self.speedDevBoost = boost
	
	self:updateTaskProgressAmount()
end

function developer:getSpeedBoost()
	return self.speedDevBoost
end

function developer:addTrait(traitID)
	self.traits[#self.traits + 1] = traitID
	
	events:fire(developer.EVENTS.TRAIT_ADDED, self, traitID)
end

function developer:removeTrait(traitID)
	for key, otherTraitID in ipairs(self.traits) do
		if otherTraitID == traitID then
			table.remove(self.traits, key)
			events:fire(developer.EVENTS.TRAIT_REMOVED, self, traitID)
			
			return true
		end
	end
	
	return false
end

function developer:startTraitEventHandler()
	for key, traitID in ipairs(self.traits) do
		local data = traits.registeredByID[traitID]
		
		if data.CATCHABLE_EVENTS then
			events:addDirectReceiver(self, data.CATCHABLE_EVENTS, "traitHandleEvent")
		end
	end
end

function developer:removeTraitEventHandler()
	if self.traits then
		for key, traitID in ipairs(self.traits) do
			local data = traits.registeredByID[traitID]
			
			if data.CATCHABLE_EVENTS then
				events:removeDirectReceiver(self, data.CATCHABLE_EVENTS, "traitHandleEvent")
			end
		end
	end
end

function developer:getTraits()
	return self.traits
end

function developer:hasTrait(traitID)
	for key, otherTraitID in ipairs(self.traits) do
		if otherTraitID == traitID then
			return true
		end
	end
	
	return false
end

function developer:getManagedTeams()
	return self.managedTeams
end

function developer:removeManagedTeam(teamObj)
	for key, otherTeamObj in ipairs(self.managedTeams) do
		if teamObj == otherTeamObj then
			table.remove(self.managedTeams, key)
			
			return true
		end
	end
	
	return false
end

function developer:isManagingTeam(teamObj)
	for key, otherTeam in ipairs(self.managedTeams) do
		if otherTeam == teamObj then
			return true
		end
	end
	
	return false
end

function developer:addManagedTeam(teamObj)
	if self:isManagingTeam(teamObj) then
		return 
	end
	
	table.insert(self.managedTeams, teamObj)
end

function developer:getManagedMemberCount()
	local total = 0
	
	for key, teamObj in ipairs(self.managedTeams) do
		total = total + teamObj:getMemberCount() - 1
	end
	
	return total
end

function developer:setNoManagementDevSpeedAffector(id, affector)
	self.noManageDevSpeedAffectors[id] = affector
	self.noManageDevSpeedAffector = 0
	
	for key, affector in pairs(self.noManageDevSpeedAffectors) do
		self.noManageDevSpeedAffector = self.noManageDevSpeedAffector + affector
	end
	
	self.noManageDevSpeedAffector = math.min(self.noManageDevSpeedAffector, 1)
end

function developer:getDevSpeedAffectorFromNoManagement()
	local manager = self.team:getAvailableManager()
	
	if not manager then
		local finalMultiplier = 1
		
		if self.drive < developer.NO_MANAGEMENT_PENALTY_MAX_DRIVE then
			local curVal = self.drive - developer.NO_MANAGEMENT_PENALTY_MIN_DRIVE
			local percentage = math.clamp(1 - curVal / developer.NO_MANAGEMENT_PENALTY_DRIVE_DIST, 0, 1)
			
			finalMultiplier = finalMultiplier - percentage * developer.NO_MANAGEMENT_PENALTY_MAX_DROP
		end
		
		return math.max(self.noManageDevSpeedAffector, finalMultiplier)
	end
	
	return 1
end

function developer:talkTo()
	dialogueHandler:addDialogue("talk_to_employee", nil, self)
end

function developer:fillConversationOptions(dialogueObject, answerList)
	if self:canRaiseSalary() then
		table.insert(answerList, "developer_raise_offer")
	end
	
	if self.deniedVacations > 0 then
		table.insert(answerList, "developer_vacation_offer")
	end
	
	table.insert(answerList, "developer_inquire_about_workplace")
	table.insert(answerList, "developer_ask_about_role")
	self.roleData:fillConversationOptions(self, answerList, dialogueObject)
	
	if not self.playerCharacter then
		table.insert(answerList, "fire_employee")
	end
end

function developer:fillSuggestionList(list, dialogueObject)
	if self.overallEfficiency < 1 then
		table.insert(list, "developer_too_many_people_in_room")
	end
	
	if self.workplace and self.workplace:isOutdated() then
		table.insert(list, "developer_outdated_computer")
	end
	
	if self.team and not self.team:getManager() then
		table.insert(list, "developer_team_could_use_manager")
	end
	
	if self.drive <= developer.LOW_DRIVE_LEVEL then
		table.insert(list, "activity_organization_suggestion")
	end
	
	if self.team and self.team:getInterOfficeMultiplier() < 1 then
		table.insert(list, "inter_office_team_penalty_suggestion")
	end
	
	self.roleData:fillSuggestionList(self, list, dialogueObject)
	
	for key, trait in ipairs(self.traits) do
		traits.registeredByID[trait]:fillSuggestionList(self, list, dialogueObject)
	end
	
	if self.office then
		local officeDriveAffectors = self.office:getDriveAffectors()
		
		for key, data in ipairs(studio.driveAffectors.registered) do
			local aff = officeDriveAffectors[data.id]
			
			if aff and aff < 0 then
				table.insert(list, data.employeeInquirySuggestion)
			end
		end
	end
end

function developer:employeeInfoCallback()
	self.tree.employee:createEmployeeMenu()
end

function developer:cancelTaskCallback()
	self.employee:cancelTask()
end

function developer:researchNewTechCallback()
	local frame = gui.create("Frame")
	
	frame:setSize(476, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("SELECT_TECH_RESEARCH_TITLE", "Select tech research"))
	menuCreator:createResearchMenu(frame, _S(5), _S(30), 466, 565, self.developer)
	frame:center()
	frameController:push(frame)
end

function developer:practiceSkillCallback()
	self.tree.employee:practiceSkill(self.skillToPractice)
end

function developer:canRaiseSalary()
	return self:getSalary() < self:getNewSalary()
end

function developer:raiseSalaryOption()
	self.developer:approveRaise()
end

function developer:talkToCallback()
	self.developer:talkTo()
end

function developer:beginMotivationalSpeechCallback()
	motivationalSpeeches:start(self.developer)
end

function developer:goToCallback()
	frameController:pop()
	
	local x, y = self.developer:getAvatar():getRealDrawPosition(self.developer:getDrawPosition())
	
	camera:setPosition(x, y, nil, true)
end

function developer:researchTechCallback()
	local taskClass = task:getData("research_task")
	
	taskClass:setupResearchableTasks()
	taskClass:attemptBeginAutoResearch(self.developer)
end

function developer:canFire()
	return not self.playerCharacter
end

function developer:canPracticeSkill(skillID)
	return self.skills[skillID].level < self.roleData.maxSkillLevels[skillID]
end

developer.CANT_TALK_NOT_IN_OFFICE = {
	{
		font = "bh20",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("CANT_TALK_EMPLOYEE_NOT_IN_OFFICE", "Employee not in office")
	}
}
developer.COMBOBOX_ID = "employee_cbox"
developer.EMPLOYEE_INFO_ID = "employee_info"

function developer:addEmployeeInfoInteraction(comboBox)
	local opt = comboBox:addOption(0, 0, 0, 24, _T("EMPLOYEE_INFO", "Employee info"), fonts.get("pix20"), developer.employeeInfoCallback)
	
	opt:setID(developer.EMPLOYEE_INFO_ID)
end

function developer:fillInteractionComboBox(comboBox)
	comboBox:setID(developer.COMBOBOX_ID)
	
	comboBox.employee = self
	
	self:addEmployeeInfoInteraction(comboBox)
	self:addCancelTaskOption(comboBox)
	
	local available = self.available
	
	if available then
		if (not self.task or self.task and self.task:canCancel()) and self.workplace then
			comboBox:addOption(0, 0, 0, 24, _T("RESEARCH_NEW_TECH", "Research new tech"), fonts.get("pix20"), developer.researchNewTechCallback).developer = self
			
			local skillToPractice = self:getPracticeableSkill()
			
			if skillToPractice then
				local option = comboBox:addOption(0, 0, 0, 24, _T("PRACTICE_MAIN_SKILL", "Practice main skill"), fonts.get("pix20"), developer.practiceSkillCallback)
				
				option.skillToPractice = skillToPractice
			end
		end
		
		if not self.playerCharacter then
			local option = comboBox:addOption(0, 0, 0, 24, _T("TALK_TO", "Talk to"), fonts.get("pix20"), developer.talkToCallback)
			
			option.developer = self
			
			if not available then
				option:setCanClick(false)
				option:setHoverText(developer.CANT_TALK_NOT_IN_OFFICE)
			end
		elseif motivationalSpeeches:canStart(nil, self) then
			comboBox:addOption(0, 0, 0, 24, _T("START_MOTIVATIONAL_SPEECH", "Start motivational speech"), fonts.get("pix20"), developer.beginMotivationalSpeechCallback).developer = self
		end
		
		comboBox:addOption(0, 0, 0, 24, _T("GO_TO_EMPLOYEE", "Go to"), fonts.get("pix20"), developer.goToCallback).developer = self
		
		local curTask = self.task
		
		if not curTask or curTask.id ~= "research_task" then
			local taskClass = task:getData("research_task")
			
			taskClass:setupResearchableTasks()
			
			local researchList = taskClass:getResearchableTasks()
			
			if #researchList > 0 then
				local researchable = taskClass:countResearchableTasks(self)
				
				if researchable > 0 then
					comboBox:addOption(0, 0, 0, 24, _format(_T("RESEARCH_TECH_COUNTER", "Research tech (RESEARCHABLE_TECH)"), "RESEARCHABLE_TECH", researchable), fonts.get("pix20"), developer.researchTechCallback).developer = self
				end
			end
		end
	end
	
	for key, attributeData in ipairs(attributes.registered) do
		attributeData:fillInteractionComboBox(self, comboBox)
	end
	
	for key, skillData in ipairs(skills.registered) do
		skillData:fillInteractionComboBox(self, comboBox)
	end
	
	attributes.profiler:fillInteractionComboBox(self, comboBox)
	events:fire(developer.EVENTS.COMBOBOX_FILLED)
end

function developer:addCancelTaskOption(comboBox)
	if self.task and self.task:canCancel() then
		comboBox:addOption(0, 0, 0, 24, string.easyformatbykeys(_T("CANCEL_TASK", "Cancel TYPE NAME task"), "TYPE", self.task:getTaskTypeText(), "NAME", self.task:getName()), fonts.get("pix20"), developer.cancelTaskCallback).employee = self
	end
end

function developer:getManagementBoost()
	return skills:getData("management"):getManagementBoost(self)
end

function developer:setIssueGenerateChanceMultiplier(id, chance)
	self.issueGenChanceMults[id] = chance
	self.issueGenChanceMult = self:calculateIssueGenerateChanceMultiplier()
end

function developer:calculateIssueGenerateChanceMultiplier()
	local total = 1
	
	for id, mult in pairs(self.issueGenChanceMults) do
		total = total * mult
	end
	
	return total
end

function developer:getIssueGenerateChanceMultiplier()
	return self.issueGenChanceMult
end

function developer:setIssueDiscoverChanceMultiplier(id, chance)
	if id then
		self.issueDiscoverChanceMultipliers[id] = chance
	end
	
	local total = 1
	
	for key, modifier in pairs(self.issueDiscoverChanceMultipliers) do
		total = total * modifier
	end
	
	self.issueDiscoverChanceMult = total
end

function developer:getIssueDiscoverChanceMultiplier()
	return self.issueDiscoverChanceMult * 0.15
end

function developer:getDriveModifier()
	return self.driveDevAffector
end

function developer:calculateDriveDevSpeedModifier()
	local modifier = 0
	
	if self.drive < developer.DRIVE_BOOST_THRESHOLD then
		local percentage = 1 - self.drive / developer.DRIVE_BOOST_THRESHOLD
		
		modifier = percentage * developer.DRIVE_MIN_DETER
	else
		local percentage = (self.drive - developer.DRIVE_BOOST_THRESHOLD) / (100 - developer.DRIVE_BOOST_THRESHOLD)
		
		modifier = percentage * developer.DRIVE_MAX_BOOST
	end
	
	return 1 + modifier
end

function developer:leaveStudio()
	if not self.employer then
		return 
	end
	
	self.employer:fireEmployee(self, studio.EMPLOYEE_LEAVE_REASONS.LEFT)
end

function developer:isDead()
	return self.dead
end

function developer:canDie()
	return not self.playerCharacter
end

function developer:die(deathTitle, deathText, deathCauseData)
	self.dead = true
	
	self.employer:fireEmployee(self, studio.EMPLOYEE_LEAVE_REASONS.DIED)
	
	deathText = string.easyformatbykeys(deathText, "NAME", self:getFullName(true))
	
	local popup = gui.create("Popup")
	
	popup:setFont(fonts.get("pix28"))
	popup:setTextFont(fonts.get("pix24"))
	popup:setWidth(500)
	popup:setTitle(deathTitle)
	popup:setText(deathText)
	popup:center()
	popup:addOKButton(fonts.get("pix24"))
	frameController:push(popup)
	events:fire(developer.EVENTS.DIED, deathCauseData)
end

function developer:postLeaveStudio()
	self.roleData:onLeftStudio(self)
	self:setAwayUntil(nil)
	
	self.daysWithoutVacation = 0
	
	self:setHired(false)
	self:setWorkplace(nil)
	self:setTask(nil)
	self:resetRaisePoints()
	
	self.deniedRaises = 0
	self.timeToConsiderLeaving = nil
	
	self:setDriveRecoverSpeedMultiplier(1)
	self:leaveVisibilityRange()
	self.avatar:clearAllSprites()
	
	if self.devTree then
		self.devTree:remove(self)
	end
	
	local empl = self.employer
	
	if empl and empl:isPlayer() then
		self.employer:removeRenderDeveloper(self)
	end
	
	if self.conversation then
		self.conversation:abort()
	end
	
	if self.room then
		self.room:removeEmployee(self)
		self.room:removeAssignedEmployee(self)
	end
	
	self:abortCurrentAction()
	self:removeQueuedPathSearch()
	
	if self.onVacation then
		empl:changeOnVacationEmployeeCount(-1)
		
		self.onVacation = false
	end
	
	self:setEmployer(nil)
end

function developer:announceLeavingStudio(reconsiderChance)
	reconsiderChance = reconsiderChance or developer.LEAVE_RECONSIDERATION_CHANCE_ON_RAISE
	
	self:setStayConsiderationChance(reconsiderChance)
	dialogueHandler:addDialogue("generic_leave_1", nil, self)
end

function developer:setStayConsiderationChance(chance)
	self.stayConsiderationChance = chance
end

function developer:getStayConsiderationChance()
	return self.stayConsiderationChance
end

function developer:offerRaiseOption()
	local title, text
	local developer = self.developer
	
	if math.random(1, 100) <= developer:getStayConsiderationChance() then
		title = _T("RAISE_OFFER_ACCEPTED", "Raise offer accepted")
		text = string.easyformatbykeys(_T("RAISE_OFFER_ACCEPTED_TEXT", "NAME has accepted the raise offer you've given him and has reconsidered leaving the studio."), "NAME", developer:getFullName(true))
		
		developer:approveRaise()
	else
		title = _T("RAISE_OFFER_REFUSED", "Raise offer refused")
		text = string.easyformatbykeys(_T("RAISE_OFFER_REFUSED_TEXT", "NAME has refused the raise offer and has left the studio."), "NAME", developer:getFullName(true))
		
		developer:getEmployer():fireEmployee(developer, studio.EMPLOYEE_LEAVE_REASONS.LEFT)
	end
	
	local popup = gui.create("Popup")
	
	popup:setWidth(400)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(title)
	popup:setTextFont(fonts.get("pix20"))
	popup:setText(text)
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"))
	popup:center()
	frameController:push(popup)
end

function developer:finishLeaveOption()
	self.developer:getEmployer():fireEmployee(self.developer, studio.EMPLOYEE_LEAVE_REASONS.LEFT)
end

function developer:checkLeaveConsideration()
	if self.timeToConsiderLeaving <= 0 then
		self:announceLeavingStudio()
		
		self.timeToConsiderLeaving = nil
		
		return true
	end
	
	return false
end

function developer:setFact(fact, value)
	if value == nil then
		value = true
	end
	
	self.facts[fact] = value
end

function developer:removeFact(fact)
	self.facts[fact] = nil
end

function developer:getFact(fact)
	return self.facts[fact]
end

function developer:setEmployer(employer)
	self.employer = employer
	
	if employer == studio then
		self.canRender = true
	else
		self.canRender = false
	end
	
	if employer then
		self.reputationAtHireTime = employer:getReputation()
	end
end

function developer:getEmployer()
	return self.employer
end

function developer:receivePaycheck()
	local timelineTime = timeline.curTime
	local timePassed = timelineTime - self.lastPaycheck
	local paycheckSize = timePassed / timeline.DAYS_IN_MONTH
	local payAmount = math.round(paycheckSize * self:getSalary())
	
	self:setLastPaycheck(timelineTime)
	self.employer:deductFunds(payAmount)
	self:addFunds(payAmount)
	
	return payAmount
end

function developer:updateDriveIncreaseFromInterests()
	if not self.office then
		self.interestDriveIncrease = 0
		
		return 
	end
	
	self.interestDriveIncrease = self:calculateDriveIncreaseFromInterests()
end

function developer:calculateDriveIncreaseFromInterests()
	local interestBoosts = self.office:getInterestBoosts()
	local totalBoost = 0
	
	for key, interest in ipairs(self.interests) do
		local boost = interestBoosts[interest]
		
		if boost and boost > 0 then
			local boostData = interests:getData(interest)
			
			totalBoost = totalBoost + boost * boostData.drivePerPoint
		end
	end
	
	return totalBoost
end

function developer:getDriveDecreaseFromDeniedRaises()
	return developer.DRIVE_INCREASE_DECREASE_MODIFIER_PER_DAY_DENIED_RAISES * -self.deniedRaises
end

function developer:getNewDayDriveChange()
	if self.playerCharacter then
		return 1
	end
	
	local change = developer.DRIVE_INCREASE_PER_DAY
	
	change = change + self:getDriveDecreaseFromDeniedRaises() * self.driveLossSpeedMult
	
	if self.office then
		change = change + self.interestDriveIncrease + self.office:getTotalDriveAffector()
	end
	
	change = change * self.driveRecoverMult
	
	return math.max(change, 0)
end

function developer:setOffice(officeObject)
	local oldOffice = self.office
	
	self.office = officeObject
	
	if officeObject ~= oldOffice then
		if oldOffice then
			oldOffice:removeEmployee(self)
			studio.driveAffectors:calculateDriveAffection(oldOffice)
		end
		
		if officeObject then
			officeObject:addEmployee(self)
			studio.driveAffectors:calculateDriveAffection(officeObject)
		end
		
		if self.team then
			self.team:onEmployeeOfficeChanged(self)
		end
		
		self:abortCurrentAction()
		self:setWalkPath(nil)
	end
	
	self:updateDriveIncreaseFromInterests()
end

function developer:getOffice()
	return self.office
end

function developer:getDriveRegenLossFromNoVacation()
	if self.playerCharacter then
		return 0
	end
	
	return developer.DAY_TO_DRIVE_LOSS * self.daysWithoutVacation * self.taskDriveLossMultiplier
end

function developer:addInterest(interest)
	table.insert(self.interests, interest)
	events:fire(developer.EVENTS.INTEREST_ADDED, self, interest)
end

function developer:removeInterest(interestID)
	table.removeObject(self.interests, interestID)
	events:fire(developer.EVENTS.INTEREST_REMOVED, self, interestID)
end

function developer:hasInterest(interest)
	return table.find(self.interests, interest) ~= nil
end

function developer:getInterests()
	return self.interests
end

function developer:addKnowledge(id, amount)
	local knowledgeData = knowledge.registeredByID[id]
	local old = self.knowledge[id] or 0
	
	if not self.knowledge[id] then
		self.knowledge[id] = math.min(amount, knowledgeData.maximum)
		self.knowledgeList[#self.knowledgeList + 1] = id
	else
		self.knowledge[id] = math.min(self.knowledge[id] + amount, knowledgeData.maximum)
	end
	
	if self.employer then
		local diff = self.knowledge[id] - old
		
		if diff ~= 0 then
			self.employer:onKnowledgeChanged(id, diff)
			
			if self.team then
				self.team:onKnowledgeChanged(id, diff)
			end
		end
	end
end

function developer:getAllKnowledge()
	return self.knowledge
end

function developer:getKnowledge(id)
	return self.knowledge[id] or 0
end

function developer:hasKnowledge(id)
	return self.knowledge[id] ~= nil
end

function developer:getFreeWorkplace(x, y, floor)
	local objectGrid = self.objectGrid
	local objects = objectGrid:getObjects(x, y, floor)
	
	if objects then
		for key, object in ipairs(objects) do
			if object:getObjectType() == "workplace" then
				local assignedEmployee = object:getAssignedEmployee()
				
				if assignedEmployee then
					if assignedEmployee == self then
						return object, developer.ASSIGNMENT_STATE.SAME_DESK
					else
						return object, developer.ASSIGNMENT_STATE.CANT
					end
				else
					if not object:isValidForWork() then
						return object, developer.ASSIGNMENT_STATE.CANT
					end
					
					return object, developer.ASSIGNMENT_STATE.CAN
				end
			end
		end
	end
	
	return nil, developer.ASSIGNMENT_STATE.NO_DESK
end

function developer:getAssignmentState(object)
	local assignedEmployee = object:getAssignedEmployee()
	
	if assignedEmployee then
		if assignedEmployee == self then
			return developer.ASSIGNMENT_STATE.SAME_DESK
		else
			return developer.ASSIGNMENT_STATE.CANT
		end
	else
		if not object:isValidForWork() then
			return developer.ASSIGNMENT_STATE.CANT
		end
		
		return developer.ASSIGNMENT_STATE.CAN
	end
	
	return developer.ASSIGNMENT_STATE.NO_DESK
end

function developer:setWorkplace(object, onWorkplace)
	local oldWorkplace = self.workplace
	
	self.workplace = object
	
	if oldWorkplace and oldWorkplace ~= self.workplace and oldWorkplace:getAssignedEmployee() == self then
		oldWorkplace:clearAssignedEmployee()
	end
	
	if not self.walkPath and self.workplace then
		self:updateSitAnimation()
	elseif not self.walkPath and not self.workplace then
		self:updateSitAnimation()
	end
	
	if self.workplace then
		self:setOffice(self.workplace:getOffice())
		self:setRoom(self.workplace:getRoom())
		
		if self.team and not self.task then
			self.team:assignFreeEmployees()
		end
	else
		self:setOffice(nil)
		self:setRoom(nil)
	end
	
	self.roleData:setWorkplace(self, object)
	events:fire(developer.EVENTS.WORKPLACE_SET, self, object)
end

function developer:getWorkplace()
	return self.workplace
end

function developer:hasWorkplace()
	return self.workplace ~= nil
end

function developer:getProjectInvolvement(projectObj)
	return self.involvedIn[projectObj:getUniqueID()] or 0
end

function developer:abortConversation()
	if self.conversation then
		self.conversation:abort()
	end
end

function developer:removeConversation()
	self:setTalkText(nil)
	self:resetConversationData()
	
	self.nextConversationDelay = timeline:getPassedTime() + math.random(developer.CONVERSATION_DELAY_MIN, developer.CONVERSATION_DELAY_MAX)
end

function developer:getNextConversationDelay()
	return self.nextConversationDelay
end

function developer:canBeginConversation()
	return not self.conversation and not self.currentAction and timeline:getPassedTime() >= self.nextConversationDelay
end

function developer:finishConversation()
	self.nextConversationDelay = timeline:getPassedTime() + math.random(developer.CONVERSATION_DELAY_MIN, developer.CONVERSATION_DELAY_MAX)
	
	self:resetConversationData()
end

function developer:resetConversationData()
	self.conversation = nil
end

function developer:setConversation(convo)
	self.conversation = convo
end

function developer:getConversation()
	return self.conversation
end

function developer:setTalkText(text, displayTime)
	local rawTime = 0
	
	if text then
		rawTime = 1 + #text * 0.08
	end
	
	displayTime = displayTime or text and timeline:getPassedTime() + rawTime or 0
	
	if text then
		local wrapText, lineCount, height = string.wrap(text, developer.talkTextFont, 400)
		
		self.talkText = wrapText
		self.talkTextHeight = height
		self.talkTextWidth = developer.talkTextFont:getWidth(self.talkText)
	else
		self.talkText = nil
	end
	
	self.talkTextTime = displayTime
	
	return displayTime, rawTime
end

function developer:getTalkText()
	return self.talkText
end

function developer:onAnimQueueOver()
	if self.onWorkplace then
		self:updateSitAnimation()
	end
end

function developer:setTalkTime(time)
	self.talkTextTime = time
end

function developer:setFloor(floor)
	local floorContainer = game.worldObject:getDevFloorQuadTree()
	
	if self.canDrawAvatar then
		if self.floor then
			floorContainer:move(self, floor)
		else
			floorContainer:insert(self)
		end
	end
	
	self.floor = floor
	
	self:updateDevTree()
	
	if floor ~= camera:getViewFloor() then
		self.employer:removeDeveloperRenderData(self)
		self:leaveVisibilityRange()
	end
end

function developer:updateDevTree()
	self.devTree = game.worldObject:getDevFloorQuadTree():getQuadTree(self.floor)
end

function developer:getFloor()
	return self.floor
end

function developer:setIsOnWorkplace(state)
	self.onWorkplace = state
	
	if state then
		self:setFloor(self.workplace:getFloor())
	end
end

function developer:isOnWorkplace()
	return self.onWorkplace
end

function developer:handleNewMonth()
	if self:canRetire() then
		self:retire()
	end
end

function developer:handleNewWeek()
	knowledge:progress(self)
	self:attemptConsiderLeaveDueToLowReputation()
	
	if self.available then
		self.traitDiscovery = self.traitDiscovery + 1
	end
end

function developer:maxTraitDiscovery()
	self.traitDiscovery = traits.maxDiscoveryLevel
end

function developer:handleNewDay()
	self:changeHydration(-developer.HYDRATION_LOSS_PER_DAY)
	self:changeSatiety(-developer.SATIETY_LOSS_PER_DAY)
	self:changeFullness(developer.FULLNESS_INCREASE_PER_DAY)
	
	if self:canDrinkCoffee() and self.onWorkplace and self.avatar:isAnimQueueEmpty() then
		self:drinkCoffee()
	end
	
	local askedForRaise, announcedLeaving = false, false
	
	if self:canAskForRaise() then
		self:askForRaise()
		
		askedForRaise = true
	end
	
	if self.task then
		local taskProject = self.task:getProject()
		
		if taskProject then
			local projID = taskProject:getUniqueID()
			
			self.involvedIn[projID] = self.involvedIn[projID] + 1
		end
	end
	
	table.clear(self.activityDesire)
	
	if self.thankForPurchaseOf and (self.employer:attemptThankForObjectPurchase(self, self.thankForPurchaseOf) or math.random(1, 100) <= developer.FORGET_THANK_CHANCE) then
		self.thankForPurchaseOf = nil
	end
	
	local away = self.awayUntil
	
	if away and away <= timeline.curTime then
		self:returnToStudio()
	end
	
	local change = self:getNewDayDriveChange() - self:getDriveRegenLossFromNoVacation() * self.driveLossSpeedMult
	
	self:addDrive(math.max(change, developer.MAX_DRIVE_LOSS_PER_DAY))
	self:addDriveRecoverSpeedMultiplier(developer.DRIVE_RECOVER_MULTIPLIER_INCREASE_PER_DAY)
	
	if self.timeToConsiderLeaving then
		self.timeToConsiderLeaving = self.timeToConsiderLeaving - 1
		announcedLeaving = self:checkLeaveConsideration()
	end
	
	if self.available then
		self.daysWithoutVacation = self.daysWithoutVacation + 1
	end
	
	if not self.playerCharacter then
		if self.vacationDate and timeline.curTime >= self.vacationDate then
			self:goOnVacation()
		elseif not announcedLeaving and not askedForRaise and self:canAskForVacation() then
			local chance = developer.VACATION_REQUEST_BASE_CHANCE + (developer.DRIVE_FOR_VACATION - self.drive) * developer.VACATION_REQUEST_CHANCE_INCREASE_PER_DRIVE_POINT
			
			if chance >= math.random(1, 100) then
				self:askForVacation()
			end
		end
		
		if self.office then
			local change = self.office:getFrustrationChange()
			
			self.frustration = math.max(0, self.frustration + change)
			
			if change > 0 and self.frustration >= developer.LEAVE_AT_FRUSTRATION and studio:getFrustrationLeavings() < studio.MAX_FRUSTRATION_LEAVE_PER_MONTH then
				self:initFrustrationLeaveDialogue()
			end
		end
	end
end

function developer:initFrustrationLeaveDialogue()
	local dialogue = dialogueHandler:addDialogue("frustration_leave_1", nil, self)
	
	dialogue:setFact("frustrator", self.office:getLargestFrustrator())
	self.employer:changeFrustrationLeaving(1)
end

function developer:handleObjectRemoval(object)
	if self.thankForPurchaseOf and object == self.thankForPurchaseOf then
		self.thankForPurchaseOf = nil
	end
end

function developer:handleObjectPlacement(object, purchased)
	if purchased then
		for key, interest in ipairs(self.interests) do
			if object:boostsInterest(interest) and object:getOffice() == self.office then
				self:queueThankForPurchase(object)
			end
		end
	end
end

function developer:handlePathInvalidation()
	self:onPathInvalidated()
end

function developer:handleInterestBoostRecalculation(object)
	if object == self.office then
		self:updateDriveIncreaseFromInterests()
	end
end

function developer:calculateOverallEfficiency()
	if self.room then
		local delta = #self.room:getAssignedEmployees() - 1 - self.maxPeopleUntilEfficiencyDrop
		
		if delta > 0 then
			self.overallEfficiency = math.max(self.baseOverallEfficiency - delta * developer.EFFICIENCY_DROP_PER_PERSON_OVER_MAX, developer.EFFICIENCY_DROP_MIN_VALUE)
			
			self.avatar:addStatusIcon("crowded_room")
		else
			self.overallEfficiency = self.baseOverallEfficiency
			
			self.avatar:removeStatusIcon("crowded_room")
		end
	end
end

function developer:getOverallEfficiency()
	return self.overallEfficiency
end

function developer:getBaseOverallEfficiency()
	return self.baseOverallEfficiency
end

function developer:canAskForVacation()
	return self.daysWithoutVacation > developer.MIN_DAYS_UNTIL_DRIVE_LOSS and self.drive < developer.DRIVE_FOR_VACATION and timeline.curTime > self.vacationRequestCooldown and not self.vacationDate
end

function developer:canWalk()
	return not self.conversationTarget
end

function developer:setTargetObject(object)
	self.targetObject = object
	
	if self.queuedSearch then
		pathComputeQueue:cancelPathfind(self)
	end
	
	if object then
		self:goTowardsTargetObject()
	end
end

function developer:goTowardsTargetObject()
	local object = self.targetObject
	
	if not self:attemptUseStairs(object:getFloor()) then
		self:queuePathSearch(object)
	end
end

function developer:attemptUseStairs(targetFloor)
	local ourFloor = self.floor
	
	if ourFloor < targetFloor then
		local staircase = self.office:getStaircaseUp(ourFloor)
		
		self:queuePathSearch(staircase)
		
		self.targetStaircase = staircase
		
		return true
	elseif targetFloor < ourFloor then
		local staircase = self.office:getStaircaseDown(ourFloor)
		
		self:queuePathSearch(staircase, staircase:getTransitionCoordinates())
		
		self.targetStaircase = staircase
		
		return true
	end
	
	return false
end

function developer:handleClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:setInteractionObject(self)
		
		return true
	end
end

function developer:handleMouseWheel(direction)
end

function developer.postKillEmployeeMenu(frame)
	gui.getClassTable(frame.class).postKill(frame)
	
	for key, list in ipairs(frame.lists) do
		list:kill()
	end
end

function developer.postHideEmployeeMenu(frame)
	gui.getClassTable(frame.class).postHide(frame)
	
	for key, list in ipairs(frame.lists) do
		list:hide()
	end
end

function developer.postShowEmployeeMenu(frame)
	gui.getClassTable(frame.class).postShow(frame)
	
	for key, list in ipairs(frame.lists) do
		list:show()
	end
end

developer.employeeMenuListColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
developer.levelIconColor = color(105, 177, 229, 255)
developer.smallIconsPad = 20
developer.traitDescriptionTextTable = {
	{
		font = "pix20",
		wrapWidth = 400,
		text = _T("TRAITS_DESCRIPTION", "Traits are things related to the mentality or personality of an employee.")
	}
}
developer.interestsDescriptionTextTable = {
	{
		font = "pix20",
		wrapWidth = 400,
		lineSpace = 10,
		text = _T("INTERESTS_DESCRIPTION1", "Employees may have interests upon joining the office, or may develop them when going on team-building activities.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		text = _T("INTERESTS_DESCRIPTION2", "They engage in their interests outside of work, and as a result gain knowledge related to the interest.")
	}
}
developer.rivalInterestsDescriptionTextTable = {
	{
		font = "bh20",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("UNKNOWN_INTEREST_DESCRIPTION_1", "This interest is not known to you.")
	},
	{
		font = "pix20",
		wrapWidth = 400,
		text = _T("INTERESTS_NOT_KNOWN_DESCRIPTION1", "Interests not known, because the employee is part of a rival game company and is not actively looking for work.")
	}
}
developer.expoEfficiencyDescriptionTextTable = {
	{
		font = "pix20",
		wrapWidth = 400,
		lineSpace = 10,
		text = _T("EXPO_EFFICIENCY_DESCRIPTION_1", "Efficiency indicates how well the booth can attract more people.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		text = _T("EXPO_EFFICIENCY_DESCRIPTION_2", "Employees with high charisma attribute and public speaking knowledge levels will increase the amount of people attracted to the booth, which in turn means more people interested in your games.\n\nAn efficiency level of 100% means the booth will attract the standard amount of people.")
	}
}
developer.preferredGameGenresDescText = {
	{
		font = "pix18",
		wrapWidth = 400,
		text = _T("EMPLOYEE_PREFERRED_GAME_GENRE_DESCRIPTION_1", "Employees may or may not have genres they prefer working on.\nWhen working on a preferred genre they do not suffer an efficiency penalty from lack of team management.")
	}
}
developer.rivalPreferredGameGenresDescText = {
	{
		font = "bh20",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("UNKNOWN_PREFERRED_GENRE_DESCRIPTION_1", "This preferred genre is not known to you.")
	},
	{
		font = "pix20",
		wrapWidth = 400,
		text = _T("EMPLOYEE_PREFERRED_GAME_GENRE_NOT_KNOWN_DESCRIPTION_1", "Preferred game genres not known, because the employee is part of a rival game company and is not actively looking for work.")
	}
}
developer.driveDescText = {
	{
		font = "pix20",
		wrapWidth = 400,
		lineSpace = 5,
		text = _T("EMPLOYEE_DRIVE_DESCRIPTION_1", "The drive (motivation) level of the employee.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		text = _T("EMPLOYEE_DRIVE_DESCRIPTION_2", "The higher it is, the faster they work on tasks.\nEventually when it gets low enough they will ask for a vacation.")
	}
}
developer.driveDescUnknownText = {
	{
		font = "bh20",
		wrapWidth = 400,
		text = _T("EMPLOYEE_DRIVE_DESCRIPTION_UNKNOWN", "In order to see the drive level you must assign a manager to the team this member is part of.")
	}
}
developer.projectFamiliarityDescText = {
	{
		font = "bh20",
		wrapWidth = 400,
		icon = "question_mark",
		iconWidth = 24,
		lineSpace = 5,
		iconHeight = 24,
		text = _T("PROJECT_FAMILIARITY_DESCRIPTION_1", "Project familiarity directly influences the speed at which an employee works on a project.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		lineSpace = 5,
		text = _T("PROJECT_FAMILIARITY_DESCRIPTION_2", "Employees lose familiarity with projects they've worked on when spending time away from them, or if the project had progressed significantly since they last worked on it.")
	}
}
developer.alphabetSortedInterests = {}

function developer:createLevelDisplayElement(list, font, skipHoverText)
	local levelDisplay = gui.create("LevelGradientIconPanel", list)
	
	levelDisplay:setEmployee(self)
	levelDisplay:setIcon("arrow")
	levelDisplay:setIconColor(developer.levelIconColor)
	levelDisplay:setFont(font)
	levelDisplay:setText(string.easyformatbykeys(_T("CURRENT_LEVEL", "Level LEVEL"), "LEVEL", self.level))
	
	if not skipHoverText then
		levelDisplay:setHoverText(_T("EMPLOYEE_LEVEL_DESCRIPTION", "The current level of the employee.\n\nEmployees gain experience whenever they gain experience in any skill they possess. When an employee levels up, he gains an attribute point, which you can spend on any attribute.\n\nThe amount of attribute points an employee can have is limited, so spend them wisely!"))
	end
	
	return levelDisplay
end

function developer:createSalaryDisplayElement(list, font, shortSalaryText, skipHoverText)
	local salaryDisplay = gui.create("GradientIconPanel", list)
	
	salaryDisplay:setIcon("wad_of_cash")
	salaryDisplay:setFont(font)
	
	if not skipHoverText then
		salaryDisplay:setHoverText(_T("SALARY_DESCRIPTION", "The monthly salary of this employee.\nEmployees will ask for a raise in pay once they are confident that they have improved their skills a lot since the last time they had talked to you about their pay.\n\nYou don't have to wait for them to ask for a salary increase, you can do that yourself at any time one of their skills is improved."))
	end
	
	local salaryText
	
	if self.playerCharacter then
		if shortSalaryText then
			salaryText = _T("CURRENT_SALARY_ITS_YOU_SHORT", "No salary")
		else
			salaryText = _T("CURRENT_SALARY_ITS_YOU", "Salary: None, it's you!")
		end
	else
		salaryText = string.easyformatbykeys(_T("CURRENT_SALARY", "$SALARY/month"), "SALARY", string.comma(self:getSalary()))
	end
	
	salaryDisplay:setText(salaryText)
	
	return salaryDisplay
end

function developer:createAttributeDisplayElement(list, font, skipHoverText, minimal)
	local apDisplay = gui.create("AttributeGradientIconPanel", list, self)
	
	apDisplay:setIcon("attribute_points")
	apDisplay:setFont(font)
	apDisplay:setIconOffset(1, 1)
	
	if minimal then
		apDisplay:setMinimalText(true)
	end
	
	apDisplay:updateText()
	
	if skipHoverText then
		apDisplay:setHoverText(nil)
	end
	
	return apDisplay
end

function developer:createRoleDisplayElement(list, font, skipHoverText)
	local roleData = self.roleData
	local roleDisplay = gui.create("RoleGradientIconPanel", list)
	
	roleDisplay:setRoleData(self.roleData)
	roleDisplay:setIcon(roleData.roleIcon)
	roleDisplay:setFont(font)
	roleDisplay:setText(roleData.display)
	
	if not skipHoverText then
		roleDisplay:setHoverText(roleData.description)
	end
	
	return roleDisplay
end

function developer:createSpecializationDisplayElement(list, font, skipHoverText)
	local roleData = self.roleData
	local specData = roleData.specializationMap[self.specialization]
	local roleDisplay = gui.create("GradientIconPanel", list)
	
	roleDisplay:setIcon(roleData.roleIcon)
	roleDisplay:setFont(font)
	roleDisplay:setText(specData.displayLong)
	
	if not skipHoverText then
		roleDisplay:setHoverText(specData.description)
	end
	
	return roleDisplay
end

function developer:createExpoEfficiencyDisplayElement(list, font, skipHoverText)
	local roleDisplay = gui.create("GradientIconPanel", list)
	
	roleDisplay:setIcon(knowledge:getData("public_speaking").icon)
	roleDisplay:setFont(font)
	roleDisplay:setText(string.easyformatbykeys(_T("EMPLOYEE_EXPO_EFFICIENCY", "EFFICIENCY% efficiency"), "EFFICIENCY", math.round((gameConventions.BASE_BOOST_EFFICIENCY + gameConventions:calculateEmployeeBoost(self)) * 100)))
	
	if not skipHoverText then
		roleDisplay:setHoverText(developer.expoEfficiencyDescriptionTextTable)
	end
	
	return roleDisplay
end

developer.peopleCountFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s людей", "%s человека", "%s человек", true)
	end
}

function developer:getPeopleCountText(amt)
	local method = developer.peopleCountFormatMethods[translation.currentLanguage]
	
	if method then
		return method(amt)
	end
	
	if amt == 1 then
		return _T("PERSON_SINGLE", "1 person")
	end
	
	return _format(_T("PERSON_MULTIPLE", "AMOUNT people"), "AMOUNT", string.comma(amt))
end

function developer:createMainSkillDisplayElement(list, font, skipHoverText, skillID)
	local skillData = skillID and skills.registeredByID[skillID]
	
	if not skillData then
		local mainSkill = self.roleData.mainSkill
		
		if mainSkill then
			skillData = skills.registeredByID[mainSkill]
		else
			local highest, id = -math.huge
			
			for key, skillData in pairs(self.skills) do
				if highest < skillData.level then
					highest = skillData.level
					id = key
				end
			end
			
			skillData = skills.registeredByID[id]
		end
	end
	
	local skillDisplay = gui.create("GradientIconPanel", list)
	
	skillDisplay:setIcon(skillData.icon)
	skillDisplay:setFont(font)
	skillDisplay:setText(string.easyformatbykeys(_T("MAIN_SKILL_DISPLAY_LAYOUT", "NAME Lv. LEVEL"), "NAME", skillData.display, "LEVEL", self:getSkillLevelDisplay(skillData.id)))
	
	if not skipHoverText then
		skillDisplay:setHoverText(self.roleData.description)
	end
	
	return skillDisplay
end

developer.ageFormatFuncs = {
	ru = function(employee)
		return timeline.formatFuncs.ru.years(employee:getAge())
	end
}

function developer:getAgeString()
	local method = developer.ageFormatFuncs[translation.currentLanguage]
	
	if method then
		return method(self)
	end
	
	return _format(_T("EMPLOYEE_AGE", "AGE years old"), "AGE", self:getAge())
end

function developer:createAgeDisplayElement(list, font, skipHoverText)
	local ageDisplay = gui.create("GradientIconPanel", list)
	
	ageDisplay:setIcon("hud_employee")
	ageDisplay:setFont(font)
	ageDisplay:setText(self:getAgeString())
	
	if not skipHoverText then
		ageDisplay:setHoverText(_T("EMPLOYEE_AGE_DESCRIPTION", "The age of the employee.\n\nWhen employees get old, they will retire from work. It's a good idea to hire young, inexperienced employees, because they will be loyal, as long as you treat them well, and will work for much longer."))
	end
	
	return ageDisplay
end

developer.unknownTraitDesc = {
	{
		font = "bh20",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("UNKNOWN_TRAIT_1", "This trait is not yet known to you.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		text = _T("UNKNOWN_TRAIT_2", "Employee traits take time to discover, and they're discovered only when the employee is in-office.")
	}
}
developer.curSortEmployee = nil

function developer.sortByDescendingKnowledge(a, b)
	return developer.curSortEmployee:getKnowledge(a) > developer.curSortEmployee:getKnowledge(b)
end

function developer:canShowThoroughInfo()
	return not self.employer or self.employer:isPlayer()
end

function developer:createEmployeeMenu(frameClass)
	frameClass = frameClass or "Frame"
	
	local frame = gui.create(frameClass)
	
	frame:setSize(500, 600)
	frame:center()
	frame:setFont("pix24")
	frame:setTitle(string.easyformatbykeys(_T("NAME_EMPLOYEE_INFO_TITLE", "NAME - Info"), "NAME", self:getFullName(true)))
	
	frame.lists = {}
	frame.postKill = developer.postKillEmployeeMenu
	frame.postShow = developer.postShowEmployeeMenu
	frame.postHide = developer.postHideEmployeeMenu
	
	local scrollbarPanel = gui.create("ScrollbarPanel", frame)
	
	scrollbarPanel:setPos(_S(5), _S(35))
	scrollbarPanel:setSize(490, 560)
	scrollbarPanel:setAdjustElementSize(true)
	scrollbarPanel:setAdjustElementPosition(true)
	scrollbarPanel:setSpacing(3)
	scrollbarPanel:setPadding(3, 3)
	scrollbarPanel:addDepth(100)
	
	local elementSize = frame.rawW - _S(17)
	local totalHeight = 0
	local baseInfoCategory = gui.create("Category")
	
	baseInfoCategory:setFont(fonts.get("pix24"))
	baseInfoCategory:setText(_T("BASIC_INFO", "Basic info"))
	scrollbarPanel:addItem(baseInfoCategory)
	baseInfoCategory:assumeScrollbar(scrollbarPanel)
	
	local levelDisplay = self:createLevelDisplayElement(nil, "pix24")
	
	levelDisplay:setBaseSize(elementSize, 0)
	levelDisplay:setIconSize(22, 22, 26)
	levelDisplay:setIconOffset(2, 2)
	baseInfoCategory:addItem(levelDisplay)
	
	local roleDisplay = self:createRoleDisplayElement(nil, "pix24")
	
	roleDisplay:setBaseSize(elementSize, 0)
	roleDisplay:setIconSize(20, 20, 22)
	roleDisplay:setIconOffset(1, 1)
	baseInfoCategory:addItem(roleDisplay)
	
	if self.specialization then
		local specDisplay = self:createSpecializationDisplayElement(nil, "pix24")
		
		specDisplay:setBaseSize(elementSize, 0)
		specDisplay:setIconSize(20, 20, 22)
		specDisplay:setIconOffset(1, 1)
		baseInfoCategory:addItem(specDisplay)
	end
	
	local ageDisplay = self:createAgeDisplayElement(nil, "pix22")
	
	ageDisplay:setBaseSize(baseElementSize, 0)
	ageDisplay:setIconOffset(1, 1)
	ageDisplay:setIconSize(20, nil, 22)
	baseInfoCategory:addItem(ageDisplay)
	
	if self.hired then
		local workedTimeDisplay = gui.create("GradientIconPanel", nil)
		
		workedTimeDisplay:setIcon("clock_full")
		workedTimeDisplay:setBaseSize(elementSize, 0)
		workedTimeDisplay:setIconSize(20, 20, 22)
		workedTimeDisplay:setFont("pix22")
		workedTimeDisplay:setIconOffset(1, 1)
		workedTimeDisplay:setHoverText(string.easyformatbykeys(_T("WORKED_TIME_DESCRIPTION", "An employee that was once of a low level and low skills will never ask for higher pay than an employee that was hired at a high level, even if the low level employee may surpass them one day."), "LEVELS", developer.MAX_LEVEL))
		
		local time = timeline.curTime
		local timeDistance = math.dist(time, self.hireTime)
		
		workedTimeDisplay:setText(_format(_T("WORKED_FOR_TIME", "Worked for TIME"), "TIME", timeline:getTimePeriodText(timeDistance)))
		baseInfoCategory:addItem(workedTimeDisplay)
		
		local canSeeDrive = self.team and self.team:getManager()
		local driveDisplay = gui.create("GradientIconPanel", nil)
		
		driveDisplay:setIcon("motivation")
		driveDisplay:setBaseSize(elementSize, 0)
		driveDisplay:setBackdropVisible(false)
		driveDisplay:setIconSize(22, 22, 0)
		driveDisplay:setFont("bh22")
		driveDisplay:setIconOffset(0, 0)
		
		if canSeeDrive or self.playerCharacter then
			local driveTextData = self:getDriveText()
			
			driveDisplay:setText(_format(_T("DRIVE_DISPLAY", "Drive level: DRIVE% (TEXT)"), "DRIVE", math.round(self.drive, 1), "TEXT", driveTextData.text))
			driveDisplay:setHoverText(developer.driveDescText)
		else
			driveDisplay:setText(_T("DRIVE_UNKNOWN", "Drive level: ???%"))
			driveDisplay:setHoverText(developer.driveDescUnknownText)
		end
		
		baseInfoCategory:addItem(driveDisplay)
	end
	
	local salaryDisplay = self:createSalaryDisplayElement(nil, "pix22")
	
	salaryDisplay:setBaseSize(elementSize, 0)
	salaryDisplay:setBackdropSize(22)
	salaryDisplay:setIconSize(20, 20)
	salaryDisplay:setIconOffset(1, 1)
	baseInfoCategory:addItem(salaryDisplay)
	
	if self.hired then
		local officeDisplay = gui.create("GradientIconPanel", nil)
		
		officeDisplay:setIcon("hud_property")
		officeDisplay:setBaseSize(elementSize, 0)
		officeDisplay:setIconSize(20, 20, 22)
		officeDisplay:setFont("bh22")
		
		if self.office then
			officeDisplay:setText(_format(_T("EMPLOYEE_WITHIN_OFFICE", "Within 'OFFICE'"), "OFFICE", self.office:getName()))
		else
			officeDisplay:setText(_T("EMPLOYEE_NOT_IN_OFFICE", "Not in any office (not assigned)"))
		end
		
		officeDisplay:setIconOffset(1, 1)
		baseInfoCategory:addItem(officeDisplay)
	end
	
	if #self.traits > 0 then
		local traitsCategory = gui.create("Category")
		
		traitsCategory:setFont(fonts.get("pix24"))
		traitsCategory:setText(_T("TRAITS", "Traits"))
		traitsCategory:setHoverText(developer.traitDescriptionTextTable)
		scrollbarPanel:addItem(traitsCategory)
		traitsCategory:assumeScrollbar(scrollbarPanel)
		
		for key, traitID in ipairs(self.traits) do
			local traitData = traits.registeredByID[traitID]
			local traitDisplay = gui.create("TraitGradientIconPanel")
			
			traitDisplay:setBaseSize(elementSize, 0)
			traitDisplay:setFont("pix24")
			traitDisplay:setEmployee(self)
			
			if self.traitDiscovery >= traitData.discoveryLevel or self.playerCharacter then
				traitDisplay:setIcon(traitData.quad)
				traitDisplay:setTraitData(traitData)
				traitDisplay:setText(traitData.display)
			else
				traitDisplay:setIcon("big_question_mark")
				traitDisplay:setText(_T("UNKNOWN_THREE_QUESTION_MARKS", "???"))
				traitDisplay:setHoverText(developer.unknownTraitDesc)
			end
			
			traitDisplay:setIconSize(24, nil, 26)
			traitDisplay:setIconOffset(1, 1)
			traitsCategory:addItem(traitDisplay)
		end
	end
	
	local canShowThoroughInfo = self:canShowThoroughInfo()
	
	if #self.interests > 0 then
		local interestCategory = gui.create("Category")
		
		interestCategory:setFont(fonts.get("pix24"))
		interestCategory:setText(_T("INTERESTS", "Interests"))
		interestCategory:setHoverText(developer.interestsDescriptionTextTable)
		scrollbarPanel:addItem(interestCategory)
		interestCategory:assumeScrollbar(scrollbarPanel)
		
		for state, interest in ipairs(self.interests) do
			developer.alphabetSortedInterests[#developer.alphabetSortedInterests + 1] = interest
		end
		
		for key, interest in ipairs(developer.alphabetSortedInterests) do
			local interestData = interests.registeredByID[interest]
			local interestDisplay = gui.create("GradientIconPanel")
			
			interestDisplay:setBaseSize(elementSize, 0)
			interestDisplay:setIconSize(20, 20, 22)
			interestDisplay:setFont("pix24")
			
			if canShowThoroughInfo then
				interestDisplay:setIcon(interestData.quad)
				interestDisplay:setText(interestData.display)
				interestDisplay:setHoverText(interests:generateInterestDescription(interest))
			else
				interestDisplay:setIcon("big_question_mark")
				interestDisplay:setText(_T("UNKNOWN_THREE_QUESTION_MARKS", "???"))
				interestDisplay:setHoverText(developer.rivalInterestsDescriptionTextTable)
			end
			
			interestDisplay:setIconOffset(1, 1)
			interestCategory:addItem(interestDisplay)
		end
		
		table.clearArray(developer.alphabetSortedInterests)
	end
	
	if self.hired then
		local projectInfoCategory = gui.create("Category")
		
		projectInfoCategory:setFont(fonts.get("pix24"))
		projectInfoCategory:setText(_T("PROJECT_INFO", "Project info"))
		scrollbarPanel:addItem(projectInfoCategory)
		projectInfoCategory:assumeScrollbar(scrollbarPanel)
		
		local projectDisplay = gui.create("GradientIconPanel")
		
		projectDisplay:setIcon("project_stuff")
		projectDisplay:setBaseSize(elementSize, 0)
		projectDisplay:setIconSize(20, 20, 22)
		projectDisplay:setFont("pix24")
		
		local projectText, projectObject
		
		if self.team then
			projectObject = self.team:getProject()
			projectText = string.easyformatbykeys(_T("WORKING_ON_PROJECT", "Working on: NAME"), "NAME", projectObject and projectObject:getName() or _T("NA", "N/A"))
		else
			projectText = _T("NOT_WORKING_ON_ANYTHING", "Working on: N/A")
		end
		
		projectDisplay:setText(projectText)
		projectDisplay:setIconOffset(1, 1)
		projectInfoCategory:addItem(projectDisplay)
		
		if projectObject then
			local fam = self.familiarity[projectObject:getFamiliarityUniqueID()]
			local famDisplay = gui.create("GradientIconPanel", nil, self)
			
			famDisplay:setIcon("efficiency")
			famDisplay:setBackdropVisible(false)
			famDisplay:setIconSize(22, 22, 22)
			famDisplay:setFont("pix24")
			
			local projectText = string.easyformatbykeys(_T("PROJECT_FAMILIARITY", "Project familiarity: PERCENTAGE%"), "PERCENTAGE", math.round(fam * 100))
			
			famDisplay:setText(projectText)
			famDisplay:setIconOffset(0, 0)
			famDisplay:setHoverText(developer.projectFamiliarityDescText)
			projectInfoCategory:addItem(famDisplay)
		end
		
		local taskDisplay = gui.create("TaskGradientIconPanel", nil, self)
		
		taskDisplay:setIcon("current_task")
		taskDisplay:setBaseSize(elementSize, 0)
		
		if self.task then
			taskDisplay:setBackdropSize(33.800000000000004)
			taskDisplay:setIconSize(28.6, 28.6)
		else
			taskDisplay:setBackdropSize(26)
			taskDisplay:setIconSize(22, 22)
		end
		
		taskDisplay:setFont("pix24")
		
		local projectText = string.easyformatbykeys(_T("CURRENT_TASK", "Task: NAME"), "NAME", self.task and self.task:getName() or _T("NA", "N/A"))
		
		taskDisplay:setText(projectText)
		taskDisplay:setIconOffset(2, 2)
		projectInfoCategory:addItem(taskDisplay)
	end
	
	if table.count(self.preferredGameGenres) > 0 then
		local preferredCat = gui.create("Category")
		
		preferredCat:setFont("pix24")
		preferredCat:setText(_T("PREFERRED_GAME_GENRES", "Preferred game genres"))
		preferredCat:setHoverText(developer.preferredGameGenresDescText)
		scrollbarPanel:addItem(preferredCat)
		preferredCat:assumeScrollbar(scrollbarPanel)
		
		for genreID, state in pairs(self.preferredGameGenres) do
			local genreData = genres:getData(genreID)
			local quadData = quadLoader:getQuadStructure(genreData.icon)
			local scaler = quadData:getScaleToSize(20)
			local realW = quadData.w * scaler
			local genreDisplay = gui.create("GradientIconPanel")
			
			genreDisplay:setBaseSize(elementSize, 0)
			genreDisplay:setIconSize(realW, quadData.h * scaler, 22)
			genreDisplay:setFont("pix24")
			genreDisplay:setIconOffset(math.floor(11 - realW * 0.5), 1)
			
			if canShowThoroughInfo then
				genreDisplay:setIcon(genreData.icon)
				genreDisplay:setText(genreData.display)
			else
				genreDisplay:setIcon("big_question_mark")
				genreDisplay:setText(_T("UNKNOWN_THREE_QUESTION_MARKS", "???"))
				genreDisplay:setHoverText(developer.rivalPreferredGameGenresDescText)
			end
			
			preferredCat:addItem(genreDisplay)
		end
	end
	
	local skillList = self:createSkillList(frame.x - _S(10), frame.y, gui.SIDES.LEFT)
	
	table.insert(frame.lists, skillList)
	
	local attributeList = gui.create("TitledList")
	
	attributeList:setFont("pix20")
	attributeList:setTitle(_T("ATTRIBUTES_TITLE", "Attributes"))
	attributeList:setBasePoint(frame.x + _S(10) + frame.w, frame.y)
	attributeList:setAlignment(gui.SIDES.RIGHT, nil)
	
	if canShowThoroughInfo then
		local attributeDisplay = gui.create("AttributePointDisplay", attributeList)
		
		attributeDisplay:setEmployee(self)
		attributeDisplay:setSize(100, 30)
	end
	
	for key, attributeData in ipairs(attributes.registered) do
		local attributeDisplay = gui.create("AttributeLevelDisplay", attributeList)
		
		attributeDisplay:setEmployee(self)
		attributeDisplay:setSize(100, 30)
		attributeDisplay:setAttributeData(attributeData)
		attributeDisplay:setFlashOffset((key - 1) * 0.5)
	end
	
	table.insert(frame.lists, attributeList)
	attributeList:updateLayout()
	
	if #self.knowledgeList > 0 and canShowThoroughInfo then
		local canAdvance = false
		
		for key, knowledgeID in ipairs(self.knowledgeList) do
			if self.knowledge[knowledgeID] >= developer.MINIMUM_KNOWLEDGE_FOR_DISPLAY then
				canAdvance = true
				
				break
			end
		end
		
		if canAdvance then
			local knowledgeList = gui.create("TitledList")
			
			knowledgeList:setFont("pix20")
			knowledgeList:setTitle(_T("KNOWLEDGE_TITLE", "Knowledge"))
			knowledgeList:setBasePoint(attributeList.x, attributeList.y + attributeList.h + _S(10))
			knowledgeList:setAlignment(gui.SIDES.RIGHT, nil)
			knowledgeList:updateLayout()
			
			developer.curSortEmployee = self
			
			table.sort(self.knowledgeList, developer.sortByDescendingKnowledge)
			
			developer.curSortEmployee = nil
			
			for key, knowledgeID in ipairs(self.knowledgeList) do
				if self.knowledge[knowledgeID] >= developer.MINIMUM_KNOWLEDGE_FOR_DISPLAY then
					local knowledgeDisplay = gui.create("KnowledgeLevelDisplay", knowledgeList)
					
					knowledgeDisplay:setEmployee(self)
					knowledgeDisplay:setSize(100, 36)
					knowledgeDisplay:setData(knowledge.registeredByID[knowledgeID])
				end
			end
			
			knowledgeList:setWidth(knowledgeList:getWidth())
			table.insert(frame.lists, knowledgeList)
			knowledgeList:updateLayout()
		end
	end
	
	frameController:push(frame)
	events:fire(developer.EVENTS.INFO_MENU_OPENED, frame)
	
	return frame
end

function developer:createSkillList(baseX, baseY, alignment)
	local skillList = gui.create("TitledList")
	
	skillList:setFont("pix24")
	skillList:setTitle(_T("SKILLS_TITLE", "Skills"))
	skillList:setBasePoint(baseX, baseY)
	skillList:setAlignment(alignment, nil)
	
	for key, skillData in ipairs(skills.registered) do
		local skillDisplay = gui.create("SkillLevelDisplay", skillList)
		
		skillDisplay:setSize(100, 35)
		skillDisplay:setEmployee(self)
		skillDisplay:setData(skillData)
	end
	
	return skillList
end

function developer:updateMouseOverText()
	objectSelector:updateDescbox(true)
end

function developer:onMouseOver()
	if self.available then
		game.setMouseOverObject(self)
	end
	
	self.mouseOver = true
	
	objectSelector:onMouseOverObject(self)
	outlineShader:setDrawObject(self)
end

function developer:setupMouseOverDescbox(descbox, wrapWidth)
	descbox:addText(self.displayFullname, "pix_world22", nil, 3, wrapWidth)
	descbox:addText(self.roleData.display, "bh_world20", nil, 0, wrapWidth, self.roleData.roleIcon, 24, 24)
	
	if self.task then
		descbox:addSpaceToNextText(4)
		descbox:addText(_format(_T("EMPLOYEE_CURRENT_TASK", "Task: TASK"), "TASK", self.task:getText()), "bh_world18", nil, 0, wrapWidth)
	end
end

function developer:onMouseLeft()
	game.setMouseOverObject(nil)
	
	self.mouseOver = false
	
	outlineShader:setDrawObject(nil)
end

function developer:isMouseOver()
	local mouseX, mouseY = camera:mousePosition()
	local worldW, worldH = game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT
	local distX, distY = self.width - worldW, self.height - worldH
	local x, y = self.avatar:getDrawPosition()
	
	if mouseX < x - worldW or mouseX > x + distX or mouseY < y - worldH or mouseY > y + distY then
		return false
	end
	
	return true
end

function developer:setInterOfficePenaltyDivider(mult)
	self.interOfficePenaltyDiv = mult
end

function developer:getInterOfficePenaltyDivider()
	return self.interOfficePenaltyDiv
end

function developer:canDrawMouseOver()
	return developer.baseClass.canDrawMouseOver(self) and self.available and not studio.expansion:isActive()
end

function developer:setDesiredSpec(spec)
	self.desiredSpec = spec
	
	events:fire(developer.EVENTS.DESIRED_SPECIALIZATION_SET, self, spec)
end

function developer:getDesiredSpec()
	return self.desiredSpec
end

function developer:setSpecialization(spec)
	self.specialization = spec
	
	attributes.profiler.specializationsByID[spec]:applyToDeveloper(self)
	
	if self.team then
		self.team:onEmployeeSpecialized(self)
	end
	
	if self.task then
		self.task:updateSpecializationBoost()
	end
	
	events:fire(developer.EVENTS.SPECIALIZATION_SET, self, spec)
end

function developer:getSpecialization()
	return self.specialization
end

function developer:enterVisibilityRange()
	self.visible = true
	
	developer.baseClass.enterVisibilityRange(self)
	self.avatar:enterVisibilityRange()
	
	if self.task then
		self.task:enterVisibilityRange()
	end
end

function developer:leaveVisibilityRange()
	self.visible = false
	
	developer.baseClass.leaveVisibilityRange(self)
	self.avatar:leaveVisibilityRange()
	
	if self.task then
		self.task:leaveVisibilityRange()
	end
end

function developer:isVisible()
	return self.visible
end

function developer:getObjectGrid()
	return self.workplace:getObjectGrid()
end

developer.progressBarSize = 15

function developer:faceEmployee(otherEmployee, targetAngle)
	local midX, midY = self:getAvatar():getDrawPosition()
	local hisMidX, hisMidY = otherEmployee:getAvatar():getDrawPosition()
	local deg = math.directiontodeg(midY - hisMidY, midX - hisMidX)
	
	if targetAngle then
		self:setTargetAngle(deg)
	else
		self:setAngleRotation(deg)
	end
end

function developer:drawMouseOver()
end

function developer:getDrawPosition()
	return self.x - 48, self.y - 48
end

function developer:preDraw()
	self.avatar:draw(self:getDrawPosition())
end

function developer:drawOutline()
	local torsoSection = avatar.SECTION_IDS.TORSO
	local sect = self.avatar:getAnimBySection(torsoSection)
	
	if sect then
		outlineShader:setupThickness(sect:getQuad())
		self.avatar:rawDrawSection(torsoSection, self:getDrawPosition())
	end
end

function developer:postDraw()
	self.avatar:postDraw(self.x - 48, self.y - 48)
	
	if self.task then
		self.task:draw(self)
	end
	
	if timeline.passedTime < self.talkTextTime and not self.mouseOver and not studio.expansion:isActive() and self.talkText and camera.zoomLevels[camera:getZoomLevel()] >= 1 then
		self:drawTalkText()
	end
end

function developer:drawTalkText()
	camera:unset()
	
	local x, y = camera:getLocalMousePosition(self.x, self.y)
	
	love.graphics.setColor(0, 0, 0, 150)
	love.graphics.rectangle("fill", x, y, self.talkTextWidth + 4, self.talkTextHeight)
	love.graphics.setFont(developer.talkTextFont)
	love.graphics.printST(self.talkText, x + 2, y, 255, 255, 255, 255, 0, 0, 0, 255)
	camera:set()
end

function developer:save()
	return {
		playerCharacter = self.playerCharacter,
		skillProgressionMultiplier = self.skillProgressionMultiplier,
		name = self.name,
		awayUntil = self.awayUntil,
		surname = self.surname,
		role = self.role,
		level = self.level,
		experience = self.experience,
		attributePoints = self.attributePoints,
		timeToAskForSalaryIncrease = self.timeToAskForSalaryIncrease,
		pointsUntilRaise = self.pointsUntilRaise,
		deniedRaises = self.deniedRaises,
		deniedVacations = self.deniedVacations,
		vacationRequestCooldown = self.vacationRequestCooldown,
		vacationDate = self.vacationDate,
		hireTime = self.hireTime,
		salary = self.salary,
		baseSalary = self.baseSalary,
		facts = self.facts,
		traits = self.traits,
		interests = self.interests,
		activityDesire = self.activityDesire,
		lastActivities = self.lastActivities,
		lastRaiseTime = self.lastRaiseTime,
		preferredGameGenres = self.preferredGameGenres,
		involvedIn = self.involvedIn,
		knowledge = self.knowledge,
		funds = self.funds,
		skills = self.skills,
		bookedExpo = self.bookedExpo,
		attributes = self.attributes,
		team = self.team and self.team:getUniqueID() or nil,
		uniqueID = self.uniqueID,
		lastPaycheck = self.lastPaycheck,
		roleData = attributes.profiler:saveRoleData(self),
		skillsBeforeRaiseRequest = self.skillsBeforeRaiseRequest,
		female = self.female,
		skillsAtHireTime = self.skillsAtHireTime,
		timeToConsiderLeaving = self.timeToConsiderLeaving,
		task = self.task and self.task:canSave() and self.task:save() or nil,
		daysWithoutVacation = self.daysWithoutVacation,
		onVacation = self.onVacation,
		skillProgressMultiplier = self.skillProgressMultiplier,
		dead = self.dead,
		age = self.age,
		drive = self.drive,
		retirementAge = self.retirementAge,
		nationality = self.nationality,
		playerCharacter = self.playerCharacter,
		portrait = self.portrait:save(),
		salaryOffset = self.salaryOffset,
		unfinalizedSalary = self.unfinalizedSalary,
		lastStealAttempt = self.lastStealAttempt,
		reputationAtHireTime = self.reputationAtHireTime,
		lastFailedStealStudio = self.lastFailedStealStudio,
		lastInvolvement = self.lastInvolvement,
		lastInvolvementTime = self.lastInvolvementTime,
		offeredWork = self.offeredWork,
		familiarity = self.familiarity,
		thankForPurchaseOf = self.thankForPurchaseOf and self.employer:getObjectListPosition(self.thankForPurchaseOf),
		frustration = self.frustration,
		specialization = self.specialization,
		traitDiscovery = self.traitDiscovery,
		targetTeam = self.targetTeam,
		torsoColor = self.torsoColor,
		legColor = self.legColor,
		shoeColor = self.shoeColor
	}
end

function developer:load(data)
	self._loading = true
	
	self:setIsPlayerCharacter(data.playerCharacter)
	
	self.skillProgressionMultiplier = data.skillProgressionMultiplier
	self.name = data.name
	self.surname = data.surname
	self.nationality = data.nationality
	
	self:setIsFemale(data.female)
	self:setupName()
	self:setRole(data.role)
	
	self.level = data.level
	self.experience = data.experience
	self.attributePoints = data.attributePoints or 0
	self.timeToAskForSalaryIncrease = data.timeToAskForSalaryIncrease
	self.deniedRaises = data.deniedRaises
	self.deniedVacations = data.deniedVacations or self.deniedVacations
	self.vacationDate = data.vacationDate
	self.vacationRequestCooldown = data.vacationRequestCooldown or 0
	
	self:setHireTime(data.hireTime)
	
	self.bookedExpo = data.bookedExpo
	self.offeredWork = data.offeredWork
	self.lastRaiseTime = data.lastRaiseTime
	self.frustration = data.frustration or self.frustration
	self.specialization = data.specialization
	self.traitDiscovery = data.traitDiscovery or self.traitDiscovery
	self.torsoColor = data.torsoColor
	self.legColor = data.legColor
	self.shoeColor = data.shoeColor
	self.awayUntil = data.awayUntil
	
	self:setBaseSalary(data.baseSalary)
	self:setSalary(data.unfinalizedSalary or data.salary)
	
	self.facts = data.facts
	self.fullness = data.fullness or self.fullness
	self.hydration = data.hydration or self.hydration
	self.satiety = data.satiety or self.satiety
	self.traits = data.traits
	self.interests = data.interests
	self.activityDesire = data.activityDesire
	self.lastActivities = data.lastActivities
	
	self:findLastActivityTime()
	
	self.preferredGameGenres = data.preferredGameGenres
	self.involvedIn = data.involvedIn
	self.knowledge = data.knowledge
	
	for knowledgeID, level in pairs(self.knowledge) do
		self.knowledgeList[#self.knowledgeList + 1] = knowledgeID
	end
	
	self.attributes = data.attributes
	
	for attributeID, level in pairs(self.attributes) do
		attributes.registeredByID[attributeID]:onChanged(self, level)
	end
	
	self:setDrive(data.drive or self.drive)
	self:setSkills(data.skills)
	
	self.funds = data.funds
	self.uniqueID = data.uniqueID
	self.lastPaycheck = data.lastPaycheck
	self.pointsUntilRaise = data.pointsUntilRaise or self.pointsUntilRaise
	self.skillsBeforeRaiseRequest = data.skillsBeforeRaiseRequest or self:markPreRaiseRequestSkills()
	self.skillsAtHireTime = data.skillsAtHireTime or self:markSkillsAtHireTime()
	self.timeToConsiderLeaving = data.timeToConsiderLeaving
	self.daysWithoutVacation = data.daysWithoutVacation or 0
	self.onVacation = data.onVacation
	self.salaryOffset = data.salaryOffset or 0
	self.unfinalizedSalary = data.unfinalizedSalary or 0
	self.lastStealAttempt = data.lastStealAttempt
	self.reputationAtHireTime = data.reputationAtHireTime or self.reputationAtHireTime
	self.lastFailedStealStudio = data.lastFailedStealStudio
	self.lastInvolvement = data.lastInvolvement or self.lastInvolvement
	self.lastInvolvementTime = data.lastInvolvementTime or self.lastInvolvementTime
	self.familiarity = data.familiarity or self.familiarity
	self.nextKeyboardClickSound = math.random(0, developer.KEYBOARD_CLICK_SOUND_DELAY[1])
	
	for key, data in ipairs(skills.registered) do
		data:postInit(self)
	end
	
	if self.onVacation == 0 then
		self.onVacation = false
	end
	
	self.skillProgressMultiplier = data.skillProgressMultiplier or 1
	self.dead = data.dead
	self.age = data.age or 0
	self.retirementAge = data.retirementAge or developer.RETIREMENT_AGE_MAX
	self.thankForPurchaseOf = data.thankForPurchaseOf
	
	if data.portrait then
		self.portrait:load(data.portrait)
	end
	
	self:setupAvatarColors()
	
	if data.task then
		local loadedTask = task.new(data.task.id)
		
		loadedTask:load(data.task, self)
		self:setTask(loadedTask)
	else
		self:updateTaskDriveLossMultiplier()
	end
	
	attributes.profiler:loadRoleData(self, data.roleData)
	
	if data.team then
		local teamObj = self.employer:getTeamByUniqueID(data.team)
		
		teamObj:addMember(self, true)
	end
	
	if self.attributePoints > 0 then
		self.avatar:addStatusIcon("level_up")
	end
	
	for key, traitID in ipairs(self.traits) do
		traits.registeredByID[traitID]:assignTrait(self)
	end
	
	if self.specialization then
		attributes.profiler.specializationsByID[self.specialization]:applyToDeveloper(self)
	elseif self.roleData.mainSkill and self.employer and self.employer:isPlayer() then
		self.roleData:checkSpecializationPopup(self, self:getSkillLevel(self.roleData.mainSkill))
	end
end

function developer:postLoad()
	self._loading = nil
	
	self:setAwayUntil(self.awayUntil)
	
	if self.employer:isPlayer() then
		self.thankForPurchaseOf = self.thankForPurchaseOf and self.employer:getObjectByIndex(self.thankForPurchaseOf)
		
		self:updateTaskIndication()
	end
end

developer:rebuildFonts()
require("game/developer/avatar")
require("game/developer/skills")
require("game/developer/attributes")
require("game/developer/names")
require("game/developer/traits")
require("game/developer/interests")
require("game/developer/conversations")
require("game/developer/actions")
require("game/developer/carry_objects")
require("game/developer/portrait")

developer.ANIM_LIST = {
	male = {
		interact = avatar.ANIM_INTERACT,
		toilet = avatar.ANIM_SHIT,
		stand = avatar.ANIM_STAND,
		work = avatar.ANIM_WORK,
		walk = avatar.ANIM_WALK,
		sit = avatar.ANIM_SIT_IDLE,
		drink = avatar.ANIM_DRINK,
		eat = avatar.ANIM_EAT,
		drink_sit = avatar.ANIM_DRINK_COFFEE,
		walk_carry = avatar.ANIM_WALK_CARRY
	},
	female = {
		interact = avatar.ANIM_INTERACT_F,
		toilet = avatar.ANIM_SHIT_F,
		stand = avatar.ANIM_STAND_F,
		work = avatar.ANIM_WORK_F,
		walk = avatar.ANIM_WALK_F,
		sit = avatar.ANIM_SIT_IDLE_F,
		drink = avatar.ANIM_DRINK_F,
		eat = avatar.ANIM_EAT_F,
		drink_sit = avatar.ANIM_DRINK_COFFEE_F,
		walk_carry = avatar.ANIM_WALK_CARRY_F
	}
}
developer.animList = developer.ANIM_LIST.male
