playerPlatform = {}
playerPlatform.mtindex = {
	__index = playerPlatform
}
playerPlatform.baseClass = platform
playerPlatform.PLAYER = true

setmetatable(playerPlatform, platform.mtindex)

playerPlatform.EVENTS = {
	DISCONTINUED = events:new(),
	SUPPORT_DROPPED = events:new(),
	PART_SET = events:new(),
	DEV_TIME_SET = events:new(),
	SPECIALIST_SET = events:new(),
	COST_SET = events:new(),
	LICENSE_COST_SET = events:new(),
	CANCELLED_DEVELOPMENT = events:new(),
	DEV_STAGE_SET = events:new(),
	PROGRESSED = events:new(),
	FUNDS_CHANGED = events:new(),
	GAME_FINISHED = events:new(),
	FIRMWARE_UPDATED = events:new(),
	DEV_SEARCH_STARTED = events:new(),
	DEV_SEARCH_FINISHED = events:new(),
	ADVERT_DURATION_ADJUSTED = events:new(),
	ADVERT_STARTED = events:new(),
	CASE_DISPLAY_CHANGED = events:new(),
	BEGUN_WORK_ON_PLATFORM = events:new(),
	PLATFORM_RELEASED = events:new(),
	OPENED_INTERACTION_MENU = events:new(),
	CHANGED_PRODUCTION = events:new(),
	CHANGED_SUPPORT = events:new(),
	NAME_SET = events:new()
}
playerPlatform.BASE_PLATFORM_ID = "player_platform_"
playerPlatform.FIRST_TIME_UI_FACT = "first_time_platform_ui"
playerPlatform.MANUFACTURING_COST_TO_DEV_COST = 400
playerPlatform.MANUFACTURING_COST_BASE_MONTHLY_FEE = 100000
playerPlatform.PLATFORM_DEV_TIME_MULTIPLIER = 20
playerPlatform.DEFAULT_DEV_TIME = 12
playerPlatform.MINIMUM_DEV_TIME = 0
playerPlatform.MAXIMUM_DEV_TIME = 36
playerPlatform.DEV_ATTRACT_DECREASE = 50
playerPlatform.BASE_DEV_ATTRACT = 50
playerPlatform.ATTRACT_TO_DEV_ATTRACT = 1.5
playerPlatform.MIN_LICENSE_COST = 0
playerPlatform.MAX_LICENSE_COST = 130000
playerPlatform.DEFAULT_LICENSE_COST = 10000
playerPlatform.LICENSE_SELL_TAX = 0.75
playerPlatform.LICENSE_COST_TO_DEV_ATTRACTIVENESS = math.log(200, 80000)
playerPlatform.SELL_TAX = 0.75
playerPlatform.MINIMUM_COST = 0
playerPlatform.MAXIMUM_COST = 1000
playerPlatform.MINIMUM_DEV_ATTRACT = 0
playerPlatform.ATTRACT_TO_MAX_BEST_PRICE = 2
playerPlatform.DEV_ATTRACT_PRICE_DELTA_DIVIDER = 8
playerPlatform.DEV_ATTRACT_PRICE_DELTA_EXPONENT = 1.6
playerPlatform.FIRST_STAGE_DURATION = 0.2
playerPlatform.PLANNING_STAGE = 1
playerPlatform.DEV_STAGE = 2
playerPlatform.FINISHED_STAGE = 3
playerPlatform.name = ""
playerPlatform.ATTRACTIVENESS_TO_DEVS = 10
playerPlatform.ATTRACT_DELTA_MINIMUM = 10
playerPlatform.ATTRACT_DELTA_DEV_LOSS = 20
playerPlatform.DEV_DIFFICULTY_TO_EXTRA_DEV = 0.7
playerPlatform.DEV_DIFFICULTY_DELTA_DIVIDER_BOOST = 8
playerPlatform.MINIMUM_DEVS = 0
playerPlatform.MAX_GAMES_PER_DEV = 4
playerPlatform.MAX_DEVS_BASE = 5
playerPlatform.DEV_ATTRACT_TO_MAX_DEVS = 15
playerPlatform.BASE_DEV_CHANCE = 15
playerPlatform.DEV_CHANCE_EXPONENT = 2
playerPlatform.MIN_DEVS_PER_MONTH = 1
playerPlatform.MINIMUM_DEV_TIME = 60
playerPlatform.DEV_TIME_PER_SCALE = 15
playerPlatform.GAME_TIME_DELAY = {
	timeline.DAYS_IN_MONTH * 3,
	timeline.DAYS_IN_MONTH * 6
}
playerPlatform.ATTRACTIVENESS_TO_SALE = 2
playerPlatform.PRICE_DELTA_SALE_DIVIDER = 50
playerPlatform.PRICE_DELTA_EXPONENT = 1.5
playerPlatform.PRICE_DELTA_SALE_BOOST = math.log(1, 100)
playerPlatform.SALE_BOOST = 2
playerPlatform.FAKE_GAME_ON_MARKET_TIME = timeline.WEEKS_IN_MONTH * 8
playerPlatform.RATING_FAKE_GAME_MARKET_TIME_AFFECTOR = timeline.WEEKS_IN_MONTH * 4
playerPlatform.INTEREST_TO_PLATFORM_SALE = 0.5
playerPlatform.PERCENTAGE_OF_SWITCHES_TO_SALES = 0.33
playerPlatform.GAME_SALE_PER_USER = 0.35
playerPlatform.RATING_SALE_DIVIDER_EXPONENT = 1.25
playerPlatform.PLAYERS_CUT = 0.3
playerPlatform.MIN_REPAIRS = 0.05
playerPlatform.BASE_REPAIRS = 0.2
playerPlatform.MAX_REPAIRS = 0.8
playerPlatform.REPAIRS_PER_MONTH = 0.05
playerPlatform.REPAIRS_REDUCTION_PER_MONTH = 0.0125
playerPlatform.REPAIRS_PER_DELTA = {
	0.3,
	0.35
}
playerPlatform.REPAIR_COST_RANGE = {
	0.4,
	0.85
}
playerPlatform.LIFETIME_VALUE = timeline.MONTHS_IN_YEAR * 8
playerPlatform.LIFE_SALE_DROPOFF = timeline.MONTHS_IN_YEAR * 6
playerPlatform.LIFE_SALE_EXPONENT = math.log(100, playerPlatform.LIFE_SALE_DROPOFF)
playerPlatform.LIFE_SALE_DIVIDER = 10
playerPlatform.LIFE_SHUTDOWN_PENALTY = 0.5
playerPlatform.LIFE_SHUTDOWN_PENALTY_MULT = 2
playerPlatform.SALE_GENERATION_DRAIN_PERCENTAGE = 0.5
playerPlatform.LIFE_REPUTATION_LOSS = 0.95
playerPlatform.TIME_UNTIL_NO_DISCONTINUE_PENALTY = timeline.DAYS_IN_MONTH * 4
playerPlatform.REP_LOSS_PER_SALE = 0.4
playerPlatform.MIN_REP_LOSS = 0.1
playerPlatform.POST_SUPPORT_DROP_DEV_MULTIPLIER = 0.5
playerPlatform.POST_SUPPORT_SALE_DROP = 0.1 / timeline.WEEKS_IN_MONTH
playerPlatform.MIN_OVERALL_SALE_MULT = 0.1
playerPlatform.IMPRESS_LIFE_LOSS_EXPONENT = 2
playerPlatform.IMPRESS_LIFE_LOSS_MULT = 2
playerPlatform.TEMP_ATTRACT_TO_IMPRESS_OFFSET = 400
playerPlatform.COMPLETION_VALUE_DELTA_TO_IMPRESSION = 0.05
playerPlatform.COMPLETION_DELTA_DIVIDER = 20
playerPlatform.IMPRESSION_MIN = 0.1
playerPlatform.INTEREST_PER_MANUFACTURE_COST = 100
playerPlatform.INTEREST_DELTA_PENALTY_DIVIDER = 50000
playerPlatform.ATTRACTIVENESS_TO_LAUNCH_GAME = 12
playerPlatform.IMPRESSION_GAME_MAX_PENALTY = 0.7
playerPlatform.IMPRESSION_LOSS_PER_GAME_PENALTY_DIVIDER = 80
playerPlatform.IMPRESSION_LOSS_PER_GAME_PENALTY_EXPONENT = 2
playerPlatform.PRICE_INCREASE_TO_IMPRESSION_LOSS = 10
playerPlatform.PRICE_DECREASE_TO_IMPRESSION_REGAIN = 30
playerPlatform.INTEREST_PER_GAME_EXPONENT = 2
playerPlatform.INTEREST_PER_GAME_DIVIDER = 20.25
playerPlatform.INTEREST_PER_GAME = 1000
playerPlatform.INTEREST_DROP_PER_WEEK = 0.5
playerPlatform.INTEREST_OFFSET = 25000
playerPlatform.INTEREST_DECAY_EXPONENT = math.log(10, 20000)
playerPlatform.ADVERT_INTEREST_GAIN = {
	7000,
	10500
}
playerPlatform.ADVERT_INTEREST_GAIN_SEGMENT = 10
playerPlatform.ADVERT_MIN_DURATION = 2
playerPlatform.ADVERT_MAX_DURATION = 24
playerPlatform.ADVERT_DEFAULT_DURATION = 4
playerPlatform.ADVERT_COST_PER_DURATION = 500000
playerPlatform.SUPPORT_VALUE_MULTIPLIER = 10000
playerPlatform.PRODUCTION_VALUE_MULTIPLIER = 5000
playerPlatform.SUPPORT_COST_MULTIPLIER = 20000
playerPlatform.PRODUCTION_COST_MULTIPLIER = 20000
playerPlatform.HAPPINESS_LOSS_PER_REPAIR_LACK = 1e-05
playerPlatform.HAPPINESS_REGAIN_PER_WEEK = 0.005
playerPlatform.MINIMUM_HAPPINESS = 0.05
playerPlatform.MAXIMUM_HAPPINESS = 1
playerPlatform.INSUFFICIENT_REPAIRS_DIALOGUE = "manager_not_enough_repairs_1"
playerPlatform.REPAIRS_DIALOGUE_FACT = "had_repairs_dialogue"
playerPlatform.INSUFFICIENT_PRODUCTION_DIALOGUE = "manager_not_enough_production_1"
playerPlatform.PRODUCTION_DIALOGUE_FACT = "had_production_dialogue"
playerPlatform.LOOK_FOR_DEVS_BUTTON_ID = "look_for_developers"
playerPlatform.ATTRACTIVENESS_TO_REP_CEILING = 500
playerPlatform.REP_RANDOM_RANGE = {
	0.85,
	1.05
}
playerPlatform.REPUTATION_GAIN_DIVIDER = 10
playerPlatform.REPUTATION_GAIN_BASE_AMOUNT = 500
playerPlatform.REPUTATION_LOSS_BASE_AMOUNT = 500
playerPlatform.REPUTATION_GAIN_HAPPINESS = 0.85
playerPlatform.REPUTATION_GAIN_POTENTIAL_MULT = 0.5
playerPlatform.REPUTATION_GAIN_BASE_MULT = 1 - playerPlatform.REPUTATION_GAIN_POTENTIAL_MULT
playerPlatform.REPUTATION_LOSS_HAPPINESS = 0.5
playerPlatform.CONVERSATION_RELEASE = "conversation_plat_release"
playerPlatform.CONVERSATION_DISCONTINUED = "conversation_plat_discontinued"
playerPlatform.CONVERSATION_POWER_OUTAGE = "conversation_plat_power_outage"
playerPlatform.CONVERSATION_FIRMWARE_CRACK = "conversation_plat_firmware_crack"
playerPlatform.CONVERSATION_MEMORY_SHORTAGE = "conversation_plat_memory_shortage"
playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT = "conversation_plat_rival_dev_buyout"
playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS = "conversation_plat_architecture_problems"
playerPlatform.CONVERSATION_IDS = {
	playerPlatform.CONVERSATION_POWER_OUTAGE,
	playerPlatform.CONVERSATION_FIRMWARE_CRACK,
	playerPlatform.CONVERSATION_MEMORY_SHORTAGE,
	playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT,
	playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS
}
playerPlatform.POST_REPAIR_EBO_TIME = 2
playerPlatform.POST_PRODUCTION_EBO_TIME = 2
playerPlatform.MARKET_CAP = {
	log = 10000,
	repIncreasePrice = 500,
	base = 0.1,
	extra = 0.5,
	salesDivider = 10,
	baseRep = 100000
}

function playerPlatform.new()
	local new = {}
	
	setmetatable(new, playerPlatform.mtindex)
	new:init()
	
	return new
end

local baseEventFuncs = {}

baseEventFuncs.mtindex = {
	__index = baseEventFuncs
}

function baseEventFuncs:prepareData(logic)
	local data = {
		id = self.id
	}
	
	setmetatable(data, data.mtindex)
	
	return data
end

function baseEventFuncs:canStart()
	return true
end

function baseEventFuncs:onNewWeek(logic)
end

function baseEventFuncs:occur(logic)
end

function baseEventFuncs:removePlatform()
end

function baseEventFuncs:onCloseDown(logic)
end

function baseEventFuncs:setupAffectorCategory(categoryObj, elementW)
end

function baseEventFuncs:fillInteractionComboBox(box)
end

function baseEventFuncs:setPlatform(plat)
	self.platform = plat
end

function baseEventFuncs:save()
	return {
		id = self.id
	}
end

function baseEventFuncs:load(data)
	self.id = data.id
end

playerPlatform.RANDOM_EVENTS = {}
playerPlatform.RANDOM_EVENTS_BY_ID = {}
playerPlatform.RANDOM_EVENTS_BY_DEV_STAGE = {}

function playerPlatform:registerRandomEvent(data, inherit)
	if inherit then
		local inData = self.RANDOM_EVENTS_BY_ID[inherit]
		
		data.baseClass = inData
		
		setmetatable(data, inData)
	else
		data.baseClass = baseEventFuncs
		
		setmetatable(data, baseEventFuncs.mtindex)
	end
	
	table.insert(self.RANDOM_EVENTS, data)
	
	self.RANDOM_EVENTS_BY_ID[data.id] = data
	
	local stage = data.devStage
	local byStage = self.RANDOM_EVENTS_BY_DEV_STAGE
	
	if not byStage[stage] then
		byStage[stage] = {}
	end
	
	table.insert(byStage[stage], data)
	
	data.mtindex = {
		__index = data
	}
end

function playerPlatform.initRandomEvent(id)
	local new = {}
	local data = playerPlatform.RANDOM_EVENTS_BY_ID[id]
	
	setmetatable(new, data.mtindex)
	
	return new
end

function playerPlatform.loadRandomEvent(data, platObj)
	local id = data.id
	local baseData = playerPlatform.RANDOM_EVENTS_BY_ID[id]
	local loaded = playerPlatform.initRandomEvent(id)
	
	loaded:setPlatform(platObj)
	loaded:load(data, platObj)
	
	return loaded
end

playerPlatform.IMPRESSION_FORMATTERS = {}
playerPlatform.IMPRESSION_FORMATTERS_BY_ID = {}

function playerPlatform.registerImpressionFormat(data)
	table.insert(playerPlatform.IMPRESSION_FORMATTERS, data)
	
	playerPlatform.IMPRESSION_FORMATTERS_BY_ID[data.id] = data
end

playerPlatform.registerImpressionFormat({
	minorValue = 0.15,
	id = "incompletion",
	textMinor = _T("PLATFORM_INCOMPLETION_MINOR", "Minor hardware failure has slightly hurt the first impression of the platform."),
	textMajor = _T("PLATFORM_INCOMPLETION_MAJOR", "Hardware failure has hurt the first impression of the platform."),
	addToPopup = function(self, extra, wrapWidth, rawW, drop)
		extra:addTextLine(rawW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text = drop <= self.minorValue and self.textMinor or self.textMajor
		
		extra:addText(text, "bh18", nil, 0, wrapWidth, "exclamation_point_red", 22, 22)
	end
})
playerPlatform.registerImpressionFormat({
	minorValue = 0.15,
	id = "lack_of_interest",
	textMinor = _T("PLATFORM_LACK_OF_INTEREST_MINOR", "A minor lack of interest has left the impression that there won't be many games on the platform."),
	textMajor = _T("PLATFORM_LACK_OF_INTEREST_MAJOR", "A lack of interest has left the impression that there won't be many games on the platform."),
	addToPopup = function(self, extra, wrapWidth, rawW, drop)
		extra:addTextLine(rawW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text = drop <= self.minorValue and self.textMinor or self.textMajor
		
		extra:addText(text, "bh18", nil, 0, wrapWidth, "exclamation_point_red", 22, 22)
	end
})
playerPlatform.registerImpressionFormat({
	hugeValue = 0.4,
	minorValue = 0.15,
	id = "lack_of_games",
	textMinor = _T("PLATFORM_LACK_OF_GAMES_MINOR", "A minor lack of launch-day games has made the console looks slightly worse."),
	textAvg = _T("PLATFORM_LACK_OF_GAMES_AVG", "A lack of launch-day games has made people think the console won't have many games made for it."),
	textMajor = _T("PLATFORM_LACK_OF_GAMES_MAJOR", "The huge lack of launch-day games has left a very bad impression on potential customers."),
	addToPopup = function(self, extra, wrapWidth, rawW, drop)
		extra:addTextLine(rawW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		
		if drop <= self.minorValue then
			text = self.textMinor
		elseif drop >= self.hugeValue then
			text = self.textMajor
		else
			text = self.textAvg
		end
		
		extra:addText(text, "bh18", nil, 0, wrapWidth, "exclamation_point_red", 22, 22)
	end
})

function playerPlatform:init()
	playerPlatform.baseClass.init(self)
	
	self.parts = {}
	self.minimumWork = 0
	self.completionValue = 0
	self.devDifficulty = 0
	self.totalGamesReleased = 0
	self.marketSharePercentage = 0
	self.interest = 0
	self.moneyMade = 0
	self.moneySpent = 0
	self.sales = 0
	self.developers = 0
	self.repairs = 0
	self.repairExpenses = 0
	self.manufacturingExpenses = 0
	self.unitSales = 0
	self.devCosts = 0
	self.advertRounds = 0
	self.advertInterest = 0
	self.devStage = 1
	self.temporaryAttractiveness = 0
	self.tempAttractLoss = 0
	self.weekFundChange = 0
	self.happiness = 1
	self.production = 0
	self.support = 0
	self.ignoreSupport = 0
	self.supportValue = 0
	self.productionAmount = 0
	self.ignoreProduction = 0
	self.repairsWeek = 0
	
	self:changeSupport(1, true)
	self:changeProduction(1, true)
	
	self.weekSales = 0
	self.monthSales = 0
	self.potentialSales = 0
	self.salePool = 0
	self.overallSaleMult = 1
	self.productionBother = 0
	self.supportBother = 0
	self.cost = playerPlatform.MINIMUM_COST
	self.devLicenseCost = playerPlatform.DEFAULT_LICENSE_COST
	
	self:setupGameRatingRange()
	self:resetModifiers()
	
	local partList = platformParts.registeredByPartType
	local partEnum = platformParts.TYPES
	
	for key, typeId in ipairs(platformParts.TYPES_LIST) do
		local enum = partEnum[typeId]
		
		self.parts[enum] = partList[enum][1].id
	end
	
	self:calculateStats(true)
	self:finalizeStats()
end

playerPlatform.SCORE_RANGES = {}
playerPlatform.SCORE_RANGE_WEIGHT_SUM = 0

function playerPlatform:addRatingRange(data)
	table.insert(playerPlatform.SCORE_RANGES, data)
	
	playerPlatform.SCORE_RANGE_WEIGHT_SUM = playerPlatform.SCORE_RANGE_WEIGHT_SUM + data.weight
end

playerPlatform.SCORE_RANGES = {
	{
		cost = 10000,
		weightStart = 5,
		ratingMin = 1,
		weightFinish = 2,
		ratingMax = 3
	},
	{
		cost = 15000,
		weightStart = 10,
		ratingMin = 4,
		weightFinish = 6,
		ratingMax = 5
	},
	{
		cost = 1,
		weightStart = 20,
		ratingMin = 6,
		weightFinish = 15,
		ratingMax = 7
	},
	{
		cost = 25000,
		weightStart = 10,
		ratingMin = 8,
		weightFinish = 15,
		ratingMax = 8
	},
	{
		cost = 30000,
		weightStart = 6,
		ratingMin = 9,
		weightFinish = 9,
		ratingMax = 9
	},
	{
		cost = 50000,
		weightStart = 2,
		ratingMin = 10,
		weightFinish = 4,
		ratingMax = 10
	}
}

function playerPlatform:setupGameRatingRange()
	local devCost = self.devLicenseCost
	
	if not self.scoreRanges then
		self.scoreRanges = {}
		
		for i = 1, #playerPlatform.SCORE_RANGES do
			local data = playerPlatform.SCORE_RANGES[i]
			
			self.scoreRanges[i] = {
				weight = 0,
				min = data.ratingMin,
				max = data.ratingMax
			}
		end
	end
	
	self.scoreRangeWeight = 0
	
	local ranges = self.scoreRanges
	
	for key, data in ipairs(playerPlatform.SCORE_RANGES) do
		local method
		
		if data.weightStart > data.weightFinish then
			method = math.floor
		else
			method = math.ceil
		end
		
		local dist = math.min(data.cost, devCost) / data.cost
		local weightVal = method(math.lerp(data.weightStart, data.weightFinish, dist))
		
		ranges[key].weight = weightVal
		self.scoreRangeWeight = self.scoreRangeWeight + weightVal
	end
end

function playerPlatform:rollRandomGameRating()
	local section = math.random(1, self.scoreRangeWeight)
	local curWeight = 0
	local finalRange
	
	for key, data in ipairs(self.scoreRanges) do
		curWeight = curWeight + data.weight
		
		if section <= curWeight then
			finalRange = data
			
			break
		end
	end
	
	return math.random(finalRange.min, finalRange.max)
end

function playerPlatform:getTotalGamesReleased()
	return self.totalGamesReleased
end

function playerPlatform:getMonthlySupportFee()
	return playerPlatform.SUPPORT_COST_MULTIPLIER
end

function playerPlatform:getSupportCost()
	return self.support * self:getMonthlySupportFee()
end

function playerPlatform:changeSupport(change, free)
	local fee = self:getMonthlySupportFee()
	
	if not free and change > 0 and not studio:hasFunds(fee * change) then
		return 
	end
	
	local support = self.support
	
	if change < 0 and support == 0 then
		return 
	end
	
	local abs = math.abs(change)
	
	if change < 0 then
		if not self.released then
			local delta = support - abs
			
			if delta <= 0 then
				change = -(abs - math.abs(delta - 1))
			end
		else
			change = -math.min(support, abs)
		end
	end
	
	if not free then
		if change > 0 then
			studio:deductFunds(fee * change)
		else
			local returnFee = math.max(0, math.min(self.ignoreSupport, math.abs(change)))
			
			studio:addFunds(fee * returnFee)
		end
	end
	
	self.support = self.support + change
	self.ignoreSupport = self.ignoreSupport + change
	
	self:updateSupportValue()
	events:fire(playerPlatform.EVENTS.CHANGED_SUPPORT, self)
end

function playerPlatform:updateSupportValue()
	self.supportValue = self.support * playerPlatform.SUPPORT_VALUE_MULTIPLIER
end

function playerPlatform:getSupportIncrease()
	return playerPlatform.SUPPORT_VALUE_MULTIPLIER
end

function playerPlatform:getSupport()
	return self.support
end

function playerPlatform:getSupportValue()
	return self.supportValue
end

function playerPlatform:getMonthlyProductionCost()
	return playerPlatform.PRODUCTION_COST_MULTIPLIER
end

function playerPlatform:getProductionCost()
	return self.production * self:getMonthlyProductionCost()
end

function playerPlatform:changeProduction(change, free)
	local fee = self:getMonthlyProductionCost()
	
	if not free and change > 0 and not studio:hasFunds(fee * change) then
		return 
	end
	
	local prod = self.production
	
	if change < 0 and prod == 0 then
		return 
	end
	
	local abs = math.abs(change)
	
	if change < 0 then
		if not self.released then
			local delta = prod - abs
			
			if delta <= 0 then
				change = -(abs - math.abs(delta - 1))
			end
		else
			change = -math.min(prod, abs)
		end
	end
	
	if not free then
		if change > 0 then
			studio:deductFunds(fee * change)
		else
			local returnFee = math.max(0, math.min(self.ignoreProduction, math.abs(change)))
			
			studio:addFunds(fee * returnFee)
		end
	end
	
	self.production = self.production + change
	self.ignoreProduction = self.ignoreProduction + change
	
	self:updateProductionValue()
	
	if self.released then
		self.salePool = math.max(0, self.salePool + change * playerPlatform.PRODUCTION_VALUE_MULTIPLIER)
	end
	
	events:fire(playerPlatform.EVENTS.CHANGED_PRODUCTION, self)
end

function playerPlatform:updateProductionValue()
	self.productionAmount = self.production * playerPlatform.PRODUCTION_VALUE_MULTIPLIER
end

function playerPlatform:getProduction()
	return self.production
end

function playerPlatform:getProductionIncrease()
	return playerPlatform.PRODUCTION_VALUE_MULTIPLIER
end

function playerPlatform:getProductionValue()
	return self.productionAmount
end

function playerPlatform:setDevTask(taskObj)
	self.devTask = taskObj
end

function playerPlatform:getDevTask()
	return self.devTask
end

function playerPlatform:isReleased()
	return self.released
end

function playerPlatform:getSelectabilityState(gameProj, skipListFill)
	if self.devStage == playerPlatform.PLANNING_STAGE then
		return platform.SELECTABILITY_STATE.INCOMPLETE_PLATFORM
	end
	
	return platform.getSelectabilityState(self, gameProj, skipListFill)
end

function playerPlatform:canInDevGames()
	local games = studio:getInDevGames()
	local idx = 1
	local ownID = self.platformID
	local scrapped = 0
	
	for i = 1, #games do
		local gameObj = games[idx]
		local plats = gameObj:getTargetPlatforms()
		
		if #plats == 1 and plats[1] == ownID then
			gameObj:scrap()
			
			scrapped = scrapped + 1
		else
			idx = idx + 1
		end
	end
	
	return scrapped
end

function playerPlatform:discontinue()
	local event = scheduledEvents:instantiateEvent("platform_discontinue_penalty")
	
	event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
	event:setPlatform(self)
	event:setSales(self.sales)
	event:setRemainingTime(self:getDiscontinuePenaltyTime())
	event:setLife(self.life)
	
	self.discontinued = true
	
	platformShare:removePlatformFromShareList(self, nil)
	self:removeEventHandler()
	
	local scrapped = self:canInDevGames()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLATFORM_DISCONTINUED_TITLE", "Platform Discontinued"))
	popup:setText(_format(_T("PLATFORM_DISCONTINUED_DESC", "You've discontinued your 'PLATFORM' console.\n\nSales for it will now come to a stop, new games won't be made."), "PLATFORM", self.name))
	
	local left, right, extra = popup:getDescboxes()
	local scrapText
	
	if scrapped == 1 then
		scrapText = _T("PLATFORM_POST_DISCONTINUE_SCRAPPED_GAME", "1 game had to be canned due to discontinuation of the platform.")
	elseif scrapped > 1 then
		scrapText = _format(_T("PLATFORM_POST_DISCONTINUE_SCRAPPED_GAMES", "GAMES had to be canned due to discontinuation of the platform."), "GAMES", gameProject:getGameCountString(scrapped))
	end
	
	if scrapText then
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		extra:addText(scrapText, "bh18", nil, 0, popup.rawW - 20, "exclamation_point_yellow", 22, 22)
	end
	
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
	studio:removeActivePlayerPlatform(self)
	conversations:addTopicToTalkAbout(playerPlatform.CONVERSATION_DISCONTINUED, self.platformID)
	events:fire(playerPlatform.EVENTS.DISCONTINUED, self)
end

function playerPlatform:isDiscontinued()
	return self.discontinued
end

function playerPlatform:isEarlyDiscontinuation()
	return self.life / playerPlatform.LIFETIME_VALUE >= playerPlatform.LIFE_SHUTDOWN_PENALTY
end

function playerPlatform:getLife()
	return self.life
end

function playerPlatform:getTimeUntilNormalDiscontinuation()
	return math.max(0, self.life - playerPlatform.LIFETIME_VALUE * playerPlatform.LIFE_SHUTDOWN_PENALTY)
end

function playerPlatform:canPirateGames()
	return not self.activeRandomEventMap.firmware_crack
end

function playerPlatform:announceSupportDrop()
	self.supportDrop = true
	self.supportDropTime = timeline.curTime
	
	local popup = game.createPopup(500, _T("PLATFORM_SUPPORT_DROP_ANNOUNCED_TITLE", "Support Drop Announced"), _format(_T("PLATFORM_SUPPORT_DROP_ANNOUNCED_DESC", "You've announced the drop of support for your 'PLATFORM' console. Allowing enough time to pass will allow for a smooth platform discontinuation."), "PLATFORM", self.name), "pix24", "pix20")
	
	frameController:push(popup)
	
	self.maxDevs = self:calculateMaxDevelopers()
	
	events:fire(playerPlatform.EVENTS.SUPPORT_DROPPED, self)
end

function playerPlatform:wasSupportDropAnnounced()
	return self.supportDrop
end

function playerPlatform:discontinuePlatformCallback()
	self.platform:discontinue()
end

function playerPlatform:consultWithManagerDiscontinueCallback()
	local object = dialogueHandler:addDialogue("manager_platform_discontinue_consult_1", nil, self.manager)
	
	object:setFact("platform", self.platform)
end

function playerPlatform:_attemptAddSpace(extra)
	if not self.spaceAdded then
		extra:addSpaceToNextText(10)
		
		self.spaceAdded = true
	end
end

playerPlatform.formatIndevLostMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s находящихся под разработкой игр станут бесполезными если эта консоль будет отменена.", "%s находящиеся под разработкой игры станут бесполезными если эта консоль будет отменена.", "%s находящаяся под разработкой игра станет бесполезной если эта консоль будет отменена.")
	end
}
playerPlatform.formatIndevCannedMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s находящихся под разработкой игр должны будут быть отменены если эта консоль будет отменена.", "%s находящиеся под разработкой игры должны будут быть отменены если эта консоль будет отменена.", "%s находящаяся под разработкой игра должна будет быть отменена если эта консоль будет отменена.")
	end
}
playerPlatform.formatIndevMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s находящихся под разработкой игр будут продаваться на 1 консоли меньше если вы отмените эту консоль.", "%s находящиеся под разработкой игры будут продаваться на 1 консоли меньше если вы отмените эту консоль.", "%s находящаяся под разработкой игра будет продаваться на 1 консоли меньше если вы отмените эту консоль.")
	end
}

function playerPlatform:confirmDiscontinuationCallback()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("PLATFORM_DISCONTINUE_TITLE", "Discontinue Platform?"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("PLATFORM_DISCONTINUE_DESCRIPTION", "Are you sure you want to discontinue your 'PLATFORM' console? There is no going back after this."), "PLATFORM", self.platform:getName()))
	
	local left, right, extra = popup:getDescboxes()
	local wrapW = popup.rawW - 20
	local lineW = _S(wrapW)
	local spaceAdded = false
	
	if not self.platform:wasSupportDropAnnounced() then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_T("PLATFORM_SUPPORT_DROP_NOT_ANNOUNCED", "You have not announced the drop of support for this platform. The discontinuation of the platform will be a sudden disappointment."), "bh18", nil, 0, wrapW, "exclamation_point_red", 22, 22)
	end
	
	local releasedLost, released, inDevLost, inDev = 0, 0, 0, 0
	local ownID = self.platformID
	
	for key, gameObj in ipairs(self.platform:getPlayerGames()) do
		if not gameObj:isOffMarket() then
			local plats = gameObj:getTargetPlatforms()
			
			if #plats == 1 and plats[1] == ownID then
				releasedLost = releasedLost + 1
			elseif table.find(plats, ownID) then
				released = released + 1
			end
		end
	end
	
	for key, gameObj in ipairs(studio:getInDevGames()) do
		local plats = gameObj:getTargetPlatforms()
		
		if #plats == 1 and plats[1] == ownID then
			inDevLost = inDevLost + 1
		elseif table.find(plats, ownID) then
			inDev = inDev + 1
		end
	end
	
	if releasedLost == 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_T("PLATFORM_DISCONTINUE_RELEASED_LOST_SINGLE", "1 released game will see very limited sales if this console is discontinued."), "bh18", nil, 0, wrapW)
	elseif releasedLost > 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("PLATFORM_DISCONTINUE_RELEASED_LOST_MANY", "AMOUNT will see very limited sales if this console is discontinued."), "AMOUNT", gameProject:getGameCountString(releasedLost)), "bh18", nil, 0, wrapW)
	end
	
	if released == 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_T("PLATFORM_DISCONTINUE_RELEASED_LESS_SALES_SINGLE", "1 game will sell on 1 platform less if this console is cancelled."), "bh18", nil, 0, wrapW)
	elseif released > 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("PLATFORM_DISCONTINUE_RELEASED_LESS_SALES_MANY", "AMOUNT will sell on 1 platform less if this console is cancelled."), "AMOUNT", releasedLost), "bh18", nil, 0, wrapW)
	end
	
	if inDevLost == 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevLostMethods[translation.currentLanguage]
		
		if method then
			text = method(inDevLost)
		else
			text = _T("PLATFORM_CANCEL_GAME_INDEV_LOST_ONE_DISCONTINUE", "1 in-development game will be rendered useless if this console is cancelled.")
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW)
	elseif inDevLost > 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevLostMethods[translation.currentLanguage]
		
		if method then
			text = method(inDevLost)
		else
			text = _format(_T("PLATFORM_CANCEL_GAME_INDEV_LOST_MANY_DISCONTINUE", "AMOUNT in-development games will be rendered useless if this console is cancelled."), "AMOUNT", inDevLost)
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW)
	end
	
	if inDev == 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevMethods[translation.currentLanguage]
		
		if method then
			text = method(inDev)
		else
			text = _T("PLATFORM_CANCEL_GAME_INDEV_SINGLE", "1 in-development game will sell on 1 platform less if this console is cancelled.")
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW)
	elseif inDev > 1 then
		playerPlatform._attemptAddSpace(self, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevMethods[translation.currentLanguage]
		
		if method then
			text = method(inDev)
		else
			text = _format(_T("PLATFORM_CANCEL_GAME_INDEV_MANY", "AMOUNT in-development games will sell on AMOUNT platforms less if this console is cancelled."), "AMOUNT", inDev)
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW)
	end
	
	popup:addButton("pix20", _T("PLATFORM_DISCONTINUE_BUTTON", "Discontinue platform"), playerPlatform.discontinuePlatformCallback).platform = self.platform
	
	if studio:getEmployeeCountByRole("manager") > 0 then
		local managers = studio:getManagers()
		local randomManager = managers[math.random(1, #managers)]
		local button = popup:addButton("pix20", _T("PLATFORM_DISCONTINUE_CONSULT_WITH_MANAGER", "Consult with a manager"), playerPlatform.consultWithManagerDiscontinueCallback)
		
		button.manager = randomManager
		button.platform = self.platform
	end
	
	popup:addButton("pix20", _T("CANCEL", "Cancel"))
	popup:center()
	frameController:push(popup)
end

function playerPlatform:dropSupportCallback()
	self.platform:announceSupportDrop()
end

function playerPlatform:consultWithManagerSupportDropCallback()
	local object = dialogueHandler:addDialogue("manager_platform_support_drop_consult_1", nil, self.manager)
	
	object:setFact("platform", self.platform)
end

function playerPlatform:confirmSupportDropCallback()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("PLATFORM_DROP_SUPPORT_TITLE", "Drop Support?"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("PLATFORM_DROP_SUPPORT_DESCRIPTION", "Are you sure you want to announce the drop of support for your 'PLATFORM' console? There is no going back after this."), "PLATFORM", self.platform:getName()))
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	extra:addText(_T("HINT_CONSULT_WITH_MANAGER", "Consider consulting with a manager before going through with this."), "bh18", nil, 0, popup.rawW - 30, "exclamation_point_yellow", 22, 22)
	
	popup:addButton("pix20", _T("PLATFORM_DROP_SUPPORT_BUTTON", "Drop support for platform"), playerPlatform.dropSupportCallback).platform = self.platform
	
	if studio:getEmployeeCountByRole("manager") > 0 then
		local managers = studio:getManagers()
		local randomManager = managers[math.random(1, #managers)]
		local button = popup:addButton("pix20", _T("PLATFORM_DISCONTINUE_CONSULT_WITH_MANAGER", "Consult with a manager"), playerPlatform.consultWithManagerSupportDropCallback)
		
		button.manager = randomManager
		button.platform = self.platform
	end
	
	popup:addButton("pix20", _T("CANCEL", "Cancel"))
	popup:center()
	frameController:push(popup)
end

function playerPlatform:getDiscontinuePenaltyTime()
	if not self.supportDropTime then
		return playerPlatform.TIME_UNTIL_NO_DISCONTINUE_PENALTY
	end
	
	local time = math.max(0, self.supportDropTime + playerPlatform.TIME_UNTIL_NO_DISCONTINUE_PENALTY - timeline.curTime)
	
	return time
end

function playerPlatform:applyParts()
	local partsByID = platformParts.registeredByID
	local partEnum = platformParts.TYPES
	local parts = self.parts
	
	for key, typeId in ipairs(platformParts.TYPES_LIST) do
		local enum = partEnum[typeId]
		
		partsByID[parts[enum]]:apply(self)
	end
end

function playerPlatform:destroy()
	platform.destroy(self)
	
	if self.activeRandomEvents then
		for key, data in ipairs(self.activeRandomEvents) do
			data:removePlatform()
			
			self.activeRandomEventMap[data.id] = nil
		end
	end
end

function playerPlatform:goOffMarket()
	platform.goOffMarket(self)
	
	for key, data in ipairs(self.activeRandomEvents) do
		data:removePlatform()
		
		self.activeRandomEventMap[data.id] = nil
	end
end

function playerPlatform:startRandomEvent(data)
	local id = data.id
	local amount = self.eventAmount[id]
	
	if not amount then
		self.eventAmount[id] = 1
	else
		self.eventAmount[id] = amount + 1
	end
	
	local instance = data
	
	if data.addToList then
		local inst = playerPlatform.initRandomEvent(data.id)
		
		inst:setPlatform(self)
		inst:prepareData()
		table.insert(self.activeRandomEvents, inst)
		
		self.activeRandomEventMap[id] = true
		instance = inst
	end
	
	instance:occur(self)
end

function playerPlatform:getEventDataByID(id)
	for key, data in ipairs(self.activeRandomEvents) do
		if data.id == id then
			return data
		end
	end
	
	return nil
end

function playerPlatform:setEventCooldown(id, time)
	self.eventCooldown[id] = time
end

function playerPlatform:getEventCooldown(id)
	return self.eventCooldown[id] or 0
end

function playerPlatform:getEventTimes(id)
	return self.eventAmount[id] or 0
end

function playerPlatform:isEventActive(id)
	return self.activeRandomEventMap[id]
end

function playerPlatform:stopRandomEvent(data)
	table.removeObject(self.activeRandomEvents, data)
	
	self.activeRandomEventMap[data.id] = nil
end

function playerPlatform:initEventHandler()
	if not self.initHandler then
		platform.initEventHandler(self)
		events:addFunctionReceiver(self, playerPlatform.handleNewWeek, timeline.EVENTS.NEW_WEEK)
		
		self.initHandler = true
	end
end

function playerPlatform:removeEventHandler()
	if self.initHandler then
		platform.removeEventHandler(self)
		events:removeFunctionReceiver(self, timeline.EVENTS.NEW_WEEK)
		
		self.initHandler = false
	end
end

function playerPlatform:setCaseDisplay(id)
	self.caseDisplay = id
	
	events:fire(playerPlatform.EVENTS.CASE_DISPLAY_CHANGED, self)
end

function playerPlatform:getCaseDisplay()
	return self.caseDisplay
end

function playerPlatform:createSaleDisplay()
	local subsDisplay = gui.create("PlatformSalesDisplayFrame", nil)
	
	game.addToProjectScroller(subsDisplay, self)
end

playerPlatform.MAX_FUND_CHANGE_HISTORY = 12

function playerPlatform:handleNewMonth()
	self.fundChange[#self.fundChange + 1] = {
		timeline:getMonth(),
		0
	}
	
	if self.released then
		platform.handleNewMonth(self)
		
		local idx = self.currentSaleIndex + 1
		
		self.currentSaleIndex = idx
		self.saleData[idx] = 0
		self.manufactureExpenses[idx] = 0
		
		if #self.fundChange > playerPlatform.MAX_FUND_CHANGE_HISTORY then
			table.remove(self.fundChange, 1)
		end
		
		self.gameMoneyMonth = 0
		self.life = self.life - (1 + math.min(1, self.impression - 1 + self.temporaryAttractiveness / playerPlatform.TEMP_ATTRACT_TO_IMPRESS_OFFSET) * playerPlatform.IMPRESS_LIFE_LOSS_MULT)^playerPlatform.IMPRESS_LIFE_LOSS_EXPONENT
		
		local devDelta = self.maxDevs - self.developers
		
		if devDelta > 0 and math.random(1, 100) <= self:getNewDevChance(devDelta) then
			local newDevs = self:getNewDevs(devDelta)
			
			self.developers = self.developers + newDevs
			
			local inDev = self.inDevGames
			
			for i = 1, newDevs do
				local new = self:rollNewDevGame()
				
				inDev[#inDev + 1] = new
				
				self:updateLastGameDev(new)
			end
			
			if self.devLicenseCost > 0 then
				local earnedMoney = math.round(newDevs * self.devLicenseCost * playerPlatform.LICENSE_SELL_TAX)
				
				studio:addFunds(earnedMoney)
				
				self.moneyMade = self.moneyMade + earnedMoney
				
				self:updateFundChange(earnedMoney)
				
				self.licenseMoney = self.licenseMoney + earnedMoney
				
				events:fire(playerPlatform.EVENTS.FUNDS_CHANGED, earnedMoney)
			end
			
			self.newDevsMonth = newDevs
		else
			self.newDevsMonth = 0
		end
		
		local costs = 0
		local prod = self.production
		local support = self.support
		
		if prod > 0 then
			costs = (prod - self.ignoreProduction) * self:getMonthlyProductionCost()
			self.ignoreProduction = 0
		end
		
		if support > 0 then
			costs = costs + (support - self.ignoreSupport) * self:getMonthlySupportFee()
			self.ignoreSupport = 0
		end
		
		if costs > 0 then
			self.moneySpent = self.moneySpent + costs
			self.manufacturingExpenses = self.manufacturingExpenses + costs
			
			self:updateFundChange(-costs)
			studio:deductFunds(costs)
		end
		
		self.monthSales = 0
		
		self:adjustReputation()
		self:calculateLifeSaleAffector()
	end
end

function playerPlatform:adjustReputation()
	local hap = self.happiness
	local gain = playerPlatform.REPUTATION_GAIN_HAPPINESS
	
	if gain < hap then
		local randomRange = playerPlatform.REP_RANDOM_RANGE
		local exponent = math.max(1, math.log(playerPlatform.REPUTATION_GAIN_DIVIDER, self.baseAttractiveness * playerPlatform.ATTRACTIVENESS_TO_REP_CEILING))
		local expGain = playerPlatform.REPUTATION_GAIN_BASE_AMOUNT / exponent * (playerPlatform.REPUTATION_GAIN_BASE_MULT + (hap - gain) / (1 - gain) * playerPlatform.REPUTATION_GAIN_POTENTIAL_MULT) * math.randomf(randomRange[1], randomRange[2])
		
		studio:increaseReputation(expGain)
	else
		local cutoff = playerPlatform.REPUTATION_LOSS_HAPPINESS
		local lossDelta = hap - cutoff
		
		if lossDelta < 0 then
			local abs = -lossDelta
			local scalar = abs / cutoff
			
			studio:decreaseReputation(playerPlatform.REPUTATION_LOSS_BASE_AMOUNT * scalar)
		end
	end
end

function playerPlatform:calculateLifeSaleAffector()
	if self.life < playerPlatform.LIFE_SALE_DROPOFF then
		self.lifeSaleAffector = (playerPlatform.LIFE_SALE_DROPOFF - (self.life - 1))^playerPlatform.LIFE_SALE_EXPONENT / playerPlatform.LIFE_SALE_DIVIDER
	end
end

function playerPlatform:getFundData()
	return self.moneyMade, self.moneySpent
end

function playerPlatform:getFundChange()
	return self.moneyMade - self.moneySpent
end

function playerPlatform:getMonthFundChangeData()
	return self.fundChange
end

function playerPlatform:getGameMoney()
	return self.gameMoney, self.gameMoneyMonth
end

function playerPlatform:getSales()
	return self.sales
end

function playerPlatform:getWeekSales()
	return self.weekSales
end

function playerPlatform:getMonthSales()
	return self.monthSales
end

function playerPlatform:getHappiness()
	return self.happiness
end

function playerPlatform:getWeekRepairs()
	return self.repairsWeek
end

function playerPlatform:repairPlatforms()
	local mult = self.repairRangeMultiplier
	local valid = math.floor(self.sales * mult)
	local delta = valid - self.repairedPlatforms
	local range = playerPlatform.REPAIRS_PER_DELTA
	local repairs = math.ceil(delta * math.randomf(range[1], range[2]))
	
	if repairs > 0 then
		local support = self.supportValue
		local missing = repairs - support
		local finalRepairs = math.min(support, repairs)
		
		if missing > 0 then
			local lostHap = missing * playerPlatform.HAPPINESS_LOSS_PER_REPAIR_LACK
			
			self.happinessChange = self.happinessChange - lostHap
			
			if not studio:getFact(playerPlatform.REPAIRS_DIALOGUE_FACT) then
				local managers = studio:getEmployeeCountByRole("manager")
				
				if managers > 0 then
					local obj = dialogueHandler:addDialogue(playerPlatform.INSUFFICIENT_REPAIRS_DIALOGUE, nil, studio:getRandomEmployeeOfRole("manager"))
					
					obj:setFact("platform", self)
					studio:setFact(playerPlatform.REPAIRS_DIALOGUE_FACT, true)
				else
					local popup = gui.create("DescboxPopup")
					
					popup:setWidth(500)
					popup:setFont("pix24")
					popup:setTextFont("pix20")
					popup:setTitle(_T("PLATFORM_INSUFFICIENT_REPAIRS_TITLE", "Insufficient Repairs"))
					popup:setShowSound("bad_jingle")
					popup:setText(_format(_T("PLATFORM_INSUFFICIENT_REPAIRS_DESC", "People with defective units of your 'CONSOLE' console are complaining that repairs are taking too much time. This has a negative effect on the happiness of the people that buy the platforms."), "CONSOLE", self.name))
					
					local left, right, extra = popup:getDescboxes()
					
					extra:addSpaceToNextText(10)
					extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
					extra:addText(_T("PLATFORM_INSUFFICIENT_REPAIRS_HINT", "You can increase the customer support capacity in the Platform Info menu."), "bh18", nil, 0, popup.rawW - 20, "exclamation_point_yellow", 22, 22)
					extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
					extra:addText(_T("PLATFORM_INSUFFICIENT_REPAIRS_HINT_2", "A low happiness value will negatively affect the sales of the console, and sales of the games made for it."), "bh18", nil, 0, popup.rawW - 20, "exclamation_point_red", 22, 22)
					popup:addOKButton("pix20")
					popup:center()
					frameController:push(popup)
					studio:setFact(playerPlatform.REPAIRS_DIALOGUE_FACT, true)
				end
			end
			
			if self.supportBother == 0 then
				game.addToEventBox("platform_insufficient_repairs", self, 4, nil, "exclamation_point_red")
				
				self.supportBother = playerPlatform.POST_REPAIR_EBO_TIME
			end
		end
		
		if finalRepairs > 0 then
			self.repairedPlatforms = self.repairedPlatforms + finalRepairs
			
			local range = playerPlatform.REPAIR_COST_RANGE
			local cost = self.manufactureCost * math.randomf(range[1], range[2])
			local idx = self.currentSaleIndex
			local final = cost * finalRepairs
			
			self.manufactureExpenses[idx] = self.manufactureExpenses[idx] + final
			self.moneySpent = self.moneySpent + final
			self.repairs = self.repairs + finalRepairs
			self.repairsWeek = finalRepairs
			self.repairExpenses = self.repairExpenses + final
			
			self:updateFundChange(-final)
			studio:deductFunds(final)
			
			self.weekFundChange = self.weekFundChange - final
		end
	end
end

function playerPlatform:handleNewWeek()
	local days = timeline.DAYS_IN_WEEK
	local idx = 1
	local inDev = self.inDevGames
	
	self.weekFundChange = 0
	
	if inDev and #inDev > 0 then
		local maxGames = self.maxGamesPerDev
		local released = self.released
		
		for i = 1, #inDev do
			local data = inDev[idx]
			local newVal = data[1] - days
			
			data[1] = newVal
			
			if newVal <= 0 then
				if maxGames > data[4] + 1 then
					if released then
						self:startNewGameDev(data)
						
						idx = idx + 1
					else
						self.bufferedDevs[#self.bufferedDevs + 1] = data
						
						table.remove(inDev, idx)
					end
				else
					table.remove(inDev, idx)
				end
				
				self:finishDevGame(data)
			else
				idx = idx + 1
			end
		end
	end
	
	local bother = self.productionBother
	
	if bother > 0 then
		self.productionBother = bother - 1
	end
	
	local bother = self.supportBother
	
	if bother > 0 then
		self.supportBother = bother - 1
	end
	
	if #self.activeRandomEvents > 0 then
		for key, data in ipairs(self.activeRandomEvents) do
			data:onNewWeek(self)
		end
	end
	
	if self.advertRounds > 0 then
		self:performAdvertisement()
		
		self.advertRounds = self.advertRounds - 1
		
		if self.advertRounds <= 0 then
			local popup = gui.create("DescboxPopup")
			
			popup:setWidth(400)
			popup:setFont("pix24")
			popup:setTextFont("pix20")
			popup:setTitle(_T("PLATFORM_ADVERT_FINISHED_TITLE", "Platform Advert Finished"))
			popup:setText(_format(_T("PLATFORM_ADVERT_FINISHED_DESC", "The advertisement campaign for 'PLATFORM' is finished."), "PLATFORM", self.name))
			
			local left, right, extra = popup:getDescboxes()
			local wrapW = popup.rawW - 20
			local halfWrapW = wrapW * 0.5
			local lineW = _S(wrapW)
			
			extra:addSpaceToNextText(10)
			extra:addTextLine(lineW, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("PLATFORM_ADVERT_MONEY_SPENT", "Money spent: SPENT"), "SPENT", string.roundtobigcashnumber(self.advertCost)), "bh20", nil, 0, wrapW, {
				{
					height = 24,
					icon = "checkbox_off",
					width = 24
				},
				{
					width = 20,
					height = 20,
					y = 1,
					icon = "wad_of_cash_minus",
					x = 1
				}
			})
			extra:addTextLine(lineW, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("PLATFORM_ADVERT_INTEREST_GAINED", "Interest gained: INTEREST points"), "INTEREST", string.comma(self.advertInterest)), "bh20", nil, 0, wrapW, "star", 24, 24)
			extra:addTextLine(lineW, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("PLATFORM_ADVERT_CAMPAIGN_DURATION", "Campaign duration: TIME"), "TIME", timeline:getTimePeriodText(self.initialAdvertDuration * timeline.DAYS_IN_WEEK)), "bh20", nil, 0, wrapW, "clock_full", 24, 24)
			popup:addOKButton("pix20")
			popup:center()
			frameController:push(popup)
			
			self.advertInterest = 0
			self.advertCost = 0
		end
	else
		local tempAttr = self.temporaryAttractiveness
		
		if tempAttr > 0 then
			self.temporaryAttractiveness = math.max(0, tempAttr - self.tempAttractLoss)
			self.tempAttractLoss = self.tempAttractLoss + playerPlatform.TEMP_ATTRACTIVENESS_DROP_PER_WEEK
		end
	end
	
	if self.eventList then
		local cooldown = self.eventCooldown
		local data = self.eventList[math.random(1, #self.eventList)]
		
		if data then
			local id = data.id
			
			if not self.activeRandomEventMap[id] and data:canStart(self) then
				self:startRandomEvent(data)
			end
		end
	end
	
	if self.released then
		local interest = self.interest
		local genSales = self:calculateSales()
		
		self.happinessChange = playerPlatform.HAPPINESS_REGAIN_PER_WEEK
		self.salePool = self.productionAmount
		self.lostSales = 0
		
		self:generateSales(genSales + self.potentialSales)
		
		if self.lostSales > 0 then
			if not studio:getFact(playerPlatform.PRODUCTION_DIALOGUE_FACT) then
				if studio:getEmployeeCountByRole("manager") > 0 then
					local obj = dialogueHandler:addDialogue(playerPlatform.INSUFFICIENT_PRODUCTION_DIALOGUE, nil, studio:getRandomEmployeeOfRole("manager"))
					
					obj:setFact("platform", self)
					studio:setFact(playerPlatform.PRODUCTION_DIALOGUE_FACT, true)
				else
					local popup = gui.create("DescboxPopup")
					
					popup:setWidth(500)
					popup:setFont("pix24")
					popup:setTextFont("pix20")
					popup:setTitle(_T("PLATFORM_INSUFFICIENT_PRODUCTION_TITLE", "Insufficient Production"))
					popup:setShowSound("bad_jingle")
					popup:setText(_format(_T("PLATFORM_INSUFFICIENT_PRODUCTION_DESC", "The production of your 'CONSOLE' console is unable to keep up with the demand. This results in lost platform sales."), "CONSOLE", self.name))
					
					local left, right, extra = popup:getDescboxes()
					
					extra:addSpaceToNextText(10)
					extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
					extra:addText(_T("PLATFORM_INSUFFICIENT_PRODUCTION_HINT", "You can increase the production capacity in the Platform Info menu."), "bh18", nil, 0, popup.rawW - 20, "exclamation_point_yellow", 22, 22)
					popup:addOKButton("pix20")
					popup:center()
					frameController:push(popup)
					studio:setFact(playerPlatform.PRODUCTION_DIALOGUE_FACT, true)
				end
			end
			
			if self.productionBother == 0 then
				game.addToEventBox("platform_insufficient_production", self, 4, nil, "exclamation_point_red")
				
				self.productionBother = playerPlatform.POST_PRODUCTION_EBO_TIME
			end
		end
		
		self.potentialSales = 0
		
		self:repairPlatforms()
		
		idx = 1
		
		local active = self.activeGames
		local salePerUser = playerPlatform.GAME_SALE_PER_USER * self.gameSaleMult
		local expo = playerPlatform.RATING_SALE_DIVIDER_EXPONENT
		local playerCut = playerPlatform.PLAYERS_CUT
		local sales = self.marketShare
		local money = 0
		local totalChange = 0
		local happ = self.happiness
		local ovMult = self.overallSaleMult
		local baseAmount = (sales + interest) * happ * ovMult * salePerUser
		
		for i = 1, #active do
			local data = active[idx]
			local marketTimeAffector = data.marketTime / data.baseMarketTime
			local gameSales = data.sales
			local madeSales = math.min(sales - gameSales, math.floor(baseAmount / data.normalizedRating^expo * marketTimeAffector))
			
			data.sales = gameSales + madeSales
			money = money + madeSales * data.price
			
			local time = data.marketTime - 1
			
			if time <= 0 then
				totalChange = totalChange + data.rating
				
				self:forgetFakeGame(data)
				table.remove(active, idx)
			else
				data.marketTime = time
				idx = idx + 1
			end
		end
		
		if totalChange > 0 then
			platformShare:changePlatformAttractiveness(self.platformID, -totalChange)
		end
		
		money = money * playerCut * gameProject.SALE_POST_TAX_PERCENTAGE
		
		if money > 0 then
			self.gameMoney = self.gameMoney + money
			self.gameMoneyMonth = self.gameMoneyMonth + money
			self.moneyMade = self.moneyMade + money
			
			self:updateFundChange(money)
			
			local index = self.currentSaleIndex
			
			self.saleData[index] = self.saleData[index] + money
			
			studio:addFunds(money)
			
			self.weekFundChange = self.weekFundChange + money
		end
		
		if self.happinessChange ~= 0 then
			self.happiness = math.min(playerPlatform.MAXIMUM_HAPPINESS, math.max(playerPlatform.MINIMUM_HAPPINESS, self.happiness + self.happinessChange))
			self.happinessChange = 0
		end
		
		self.interest = math.max(0, self.interest - genSales * playerPlatform.INTEREST_DROP_PER_WEEK)
		
		if self.supportDrop then
			local minMult = playerPlatform.MIN_OVERALL_SALE_MULT
			
			if minMult < ovMult then
				self.overallSaleMult = math.max(minMult, self.overallSaleMult - playerPlatform.POST_SUPPORT_SALE_DROP)
			end
		end
	end
	
	events:fire(playerPlatform.EVENTS.FUNDS_CHANGED, self.weekFundChange)
	
	self.weekFundChange = 0
	
	events:fire(playerPlatform.EVENTS.PROGRESSED, self)
end

function playerPlatform:getActiveGames()
	return self.activeGames
end

function playerPlatform:setupMarketSaturation()
	self:removeMarketSaturation()
	
	local time = timeline.curTime
	local maxAge = platform.MARKET_SATURATION_MAX_GAME_AGE
	local byGenre, byTheme = self.gamesByGenre, self.gamesByTheme
	local gameList = self.games
	
	for i = #gameList, 1, -1 do
		local gameObject = gameList[i]
		local monthsSinceRelease = timeline:getMonths(time, gameObject:getReleaseDate())
		
		if monthsSinceRelease <= maxAge then
			local genreID, themeID = gameObject:getGenre(), gameObject:getTheme()
			
			byGenre[genreID] = byGenre[genreID] + 1
			byTheme[themeID] = byTheme[themeID] + 1
		else
			break
		end
	end
	
	for genreID, amount in pairs(self.fakeGamesByGenre) do
		local val = byGenre[genreID] + amount
		
		byGenre[genreID] = val
		
		platformShare:changeGamesByGenre(genreID, val)
	end
	
	for themeID, amount in pairs(self.fakeGamesByTheme) do
		local val = byTheme[themeID] + amount
		
		byTheme[themeID] = val
		
		platformShare:changeGamesByTheme(themeID, val)
	end
end

eventBoxText:registerNew({
	id = "platform_advert_performed",
	getText = function(self, data)
		return _format(_T("PLATFORM_ADVERTISEMENT_PERFORMED", "Advertisement for 'PLATFORM' increased interest by INTEREST points."), "PLATFORM", data[1], "INTEREST", string.roundtobignumber(data[2]))
	end
})
eventBoxText:registerNew({
	id = "platform_insufficient_production",
	getText = function(self, data)
		return _format(_T("PLATFORM_INSUFFICIENT_PRODUCTION_EVENT", "Insufficient production of units for 'CONSOLE'!"), "CONSOLE", data:getName())
	end,
	saveData = function(self, data)
		return data:getID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getPlatformByID(data)
	end,
	fillInteractionComboBox = function(self, comboBox, uiElement)
		uiElement:getData():fillInteractionComboBox(comboBox)
	end
})
eventBoxText:registerNew({
	id = "platform_insufficient_repairs",
	getText = function(self, data)
		return _format(_T("PLATFORM_INSUFFICIENT_REPAIRS_EVENT", "Insufficient repairs for 'CONSOLE'!"), "CONSOLE", data:getName())
	end,
	saveData = function(self, data)
		return data:getID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getPlatformByID(data)
	end,
	fillInteractionComboBox = function(self, comboBox, uiElement)
		uiElement:getData():fillInteractionComboBox(comboBox)
	end
})

playerPlatform.TEMP_ATTRACTIVENESS_MAX = 600
playerPlatform.TEMP_ATTRACTIVENESS_DROP_PER_WEEK = 2
playerPlatform.TEMP_ATTRACT_GAIN = {
	50,
	80
}

function playerPlatform:performAdvertisement()
	local rng = playerPlatform.ADVERT_INTEREST_GAIN
	local normalizedMax = rng[2] - rng[1]
	local gain = math.random(rng[1], rng[2])
	local intGain = self:changeInterest(math.round(gain / playerPlatform.ADVERT_INTEREST_GAIN_SEGMENT) * playerPlatform.ADVERT_INTEREST_GAIN_SEGMENT)
	local tRange = playerPlatform.TEMP_ATTRACT_GAIN
	
	self.tempAttractLoss = 0
	self.advertInterest = self.advertInterest + intGain
	self.temporaryAttractiveness = math.min(playerPlatform.TEMP_ATTRACTIVENESS_MAX, self.temporaryAttractiveness + math.lerp(tRange[1], tRange[2], (gain - rng[1]) / normalizedMax))
	
	local element = game.addToEventBox("platform_advert_performed", {
		self.name,
		intGain
	}, 6, nil, "quality_gameplay")
end

function playerPlatform:changeDevCosts(change)
	self.devCosts = self.devCosts + change
end

function playerPlatform:changeMoneySpent(spent)
	self.moneySpent = self.moneySpent + spent
end

function playerPlatform:changeInterest(change)
	local prev = self.interest
	local newVal = self.interest
	local max = studio:getReputation() + playerPlatform.INTEREST_OFFSET
	
	if max < newVal + change then
		local delta = newVal + change - max
		
		if newVal < max then
			newVal = max
		end
		
		local divider = 1 + delta^playerPlatform.INTEREST_DECAY_EXPONENT
		
		self.interest = newVal + change / divider
	else
		self.interest = newVal + change
	end
	
	return self.interest - prev
end

function playerPlatform:finishDevGame(data)
	local scale = data[3]
	local id = self.platformID
	local rating = self:rollRandomGameRating()
	local price = gameProject:getScaleIdealPriceAffector(nil, scale)
	local fakeData = platformShare:createFakeGameStruct(rating)
	
	fakeData.platforms[id] = true
	fakeData.price = price
	fakeData.scale = scale
	fakeData.sales = 0
	
	local count = self.gamesByRating[rating]
	
	if count then
		self.gamesByRating[rating] = count + 1
	else
		self.gamesByRating[rating] = 1
	end
	
	platformShare:changePlatformAttractiveness(id, fakeData.rating)
	
	local pointsGained = fakeData.rating^playerPlatform.INTEREST_PER_GAME_EXPONENT / playerPlatform.INTEREST_PER_GAME_DIVIDER * playerPlatform.INTEREST_PER_GAME
	
	self:changeInterest(pointsGained)
	
	local minRating = review.minRating
	local normalRating = fakeData.rating - minRating
	local marketTime = playerPlatform.FAKE_GAME_ON_MARKET_TIME - playerPlatform.RATING_FAKE_GAME_MARKET_TIME_AFFECTOR * (1 - normalRating / (review.maxRating - minRating))
	
	fakeData.marketTime = marketTime
	fakeData.baseMarketTime = marketTime
	fakeData.normalizedRating = normalRating
	
	if not self.released then
		table.insert(self.pendingReleaseGames, fakeData)
	else
		table.insert(self.activeGames, fakeData)
	end
	
	self.totalGamesReleased = self.totalGamesReleased + 1
	
	self:countFakeGame(fakeData)
	events:fire(playerPlatform.EVENTS.GAME_FINISHED, self, fakeData)
end

function playerPlatform:updateLastGameDev(data)
	if not self.inDevGames then
		return 
	end
	
	local time = timeline.curTime
	
	if data then
		local relDate = data[1]
		
		if self.lastDevGameRelease then
			self.lastDevGameRelease = math.max(self.lastDevGameRelease, time + relDate)
		else
			self.lastDevGameRelease = time + relDate
		end
		
		local earliest = math.huge
		
		for key, data in ipairs(self.inDevGames) do
			earliest = math.min(earliest, data[1])
		end
		
		self.earliestDevGameRelease = time + earliest
	else
		local last, earliest = 0, math.huge
		
		for key, data in ipairs(self.inDevGames) do
			local relDate = data[1]
			
			last = math.max(relDate, last)
			earliest = math.min(earliest, relDate)
		end
		
		self.earliestDevGameRelease = time + earliest
		self.lastDevGameRelease = time + last
	end
end

function playerPlatform:getLastGameDev()
	return self.lastDevGameRelease
end

function playerPlatform:getGameDevText()
	return _format("FIRST\nLAST", "FIRST", self:getEarliestGameDevText(), "LAST", self:getLastGameDevText())
end

function playerPlatform:getLastGameDevText()
	return _format(_T("PLATFORM_IN_DEV_GAMES_LAST", "The last game will be finished in TIME."), "TIME", timeline:getTimePeriodText(self.lastDevGameRelease - timeline.curTime))
end

function playerPlatform:getEarliestGameDevText()
	return _format(_T("PLATFORM_IN_DEV_GAMES_EARLIEST", "The earliest game will be finished in TIME."), "TIME", timeline:getTimePeriodText(self.earliestDevGameRelease - timeline.curTime))
end

function playerPlatform:openInfoPopupCallback()
	self.platform:createInfoPopup()
end

function playerPlatform:cancelDevelopmentCallback()
	self.platform:createCancelConfirmation()
end

function playerPlatform:lookForDevelopersCallback()
	self.platform:startLookingForDevs()
end

function playerPlatform:confirmCancelCallback()
	self.platform:cancelDevelopment()
end

function playerPlatform:setupEventList()
	self.eventList = playerPlatform.RANDOM_EVENTS_BY_DEV_STAGE[self.devStage]
end

function playerPlatform:setDevStage(stage)
	self.devStage = stage
	
	self:setupEventList()
	events:fire(playerPlatform.EVENTS.DEV_STAGE_SET, self)
end

function playerPlatform:getDevStage()
	return self.devStage
end

function playerPlatform:getInDevGames()
	return self.inDevGames
end

function playerPlatform:getFinishedLaunchDayGames()
	return self.pendingReleaseGames
end

function playerPlatform:createCancelConfirmation()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("CANCEL_PLATFORM_DEVELOPMENT_TITLE", "Cancel Platform Development"))
	popup:setText(_format(_T("CANCEL_PLATFORM_DEVELOPMENT_DESC", "Are you sure you want to cancel development of the 'PLATFORM' console?\n\nAll progress will be lost, and money that was spent on it during development will not be reimbursed."), "PLATFORM", self.name))
	
	local button = popup:addButton("pix20", _T("CANCEL_PLATFORM_DEVELOPMENT", "Cancel platform development"), playerPlatform.confirmCancelCallback)
	
	button.platform = self
	
	local inDevLost, inDev = 0, 0
	local ownID = self.platformID
	
	for key, gameObj in ipairs(studio:getInDevGames()) do
		local plats = gameObj:getTargetPlatforms()
		
		if #plats == 1 and plats[1] == ownID then
			inDevLost = inDevLost + 1
		elseif table.find(plats, ownID) then
			inDev = inDev + 1
		end
	end
	
	local left, right, extra = popup:getDescboxes()
	local wrapW = popup.rawW - 20
	local lineW = _S(wrapW)
	
	if inDevLost == 1 then
		playerPlatform._attemptAddSpace(popup, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevCannedMethods[translation.currentLanguage]
		
		if method then
			text = method(inDevLost)
		else
			text = _T("PLATFORM_CANCEL_GAME_INDEV_LOST_ONE", "1 in-development game will have to be canned if this console is cancelled.")
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW, "exclamation_point_red", 22, 22)
	elseif inDevLost > 1 then
		playerPlatform._attemptAddSpace(popup, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevCannedMethods[translation.currentLanguage]
		
		if method then
			text = method(inDevLost)
		else
			text = _format(_T("PLATFORM_CANCEL_GAME_INDEV_LOST_MANY", "AMOUNT in-development games will have to be canned if this console is cancelled."), "AMOUNT", inDevLost)
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW, "exclamation_point_red", 22, 22)
	end
	
	if inDev == 1 then
		playerPlatform._attemptAddSpace(popup, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevMethods[translation.currentLanguage]
		
		if method then
			text = method(inDev)
		else
			text = _T("PLATFORM_CANCEL_GAME_INDEV_SINGLE", "1 in-development game will sell on 1 platform less if this console is cancelled.")
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW)
	elseif inDev > 1 then
		playerPlatform._attemptAddSpace(popup, extra)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local text
		local method = playerPlatform.formatIndevMethods[translation.currentLanguage]
		
		if method then
			text = method(inDev)
		else
			text = _format(_T("PLATFORM_CANCEL_GAME_INDEV_MANY", "AMOUNT in-development games will sell on AMOUNT platforms less if this console is cancelled."), "AMOUNT", inDev)
		end
		
		extra:addText(text, "bh18", nil, 0, wrapW)
	end
	
	popup:addButton("pix20", _T("GO_BACK", "Go back"))
	popup:center()
	frameController:push(popup)
end

function playerPlatform:startLookingForDevs()
	local event = scheduledEvents:instantiateEvent("platform_dev_search")
	
	event:setPlatform(self)
	event:setActivationDate(timeline.curTime + timeline.DAYS_IN_WEEK)
	
	self.devsSearched = true
	
	local popup = game.createPopup(500, _T("DEVELOPER_SEARCH_STARTED_TITLE", "Dev Search Started"), _format(_T("DEVELOPER_SEARCH_STARTED_DESC", "You've begun searching for developers to make games for your 'PLATFORM' console.\n\nThese developers will not have to pay a license fee, but they will provide your console with launch-day games."), "PLATFORM", self.name), "pix24", "pix20")
	
	frameController:push(popup)
	events:fire(playerPlatform.EVENTS.DEV_SEARCH_STARTED, self)
end

function playerPlatform:revertPriceChangeCallback()
	self.platform:setCost(self.oldCost)
end

function playerPlatform:confirmPriceChangeCallback()
	self.platform:resetSearchData()
end

function playerPlatform:confirmPriceChangePostRelCallback()
	self.platform:setupCostEvaluation()
end

function playerPlatform:createCloseVerificationPopup(oldCost)
	if not self.released then
		if self.devSearchFinished and #self.inDevGames > 0 and self.cost > self.lastDevSearchCost then
			local popup = game.createPopup(500, _T("CONFIRM_PRICE_CHANGE_TITLE", "Confirm Price Change"), _format(_T("DEV_SEARCH_PRICE_CHANGE", "Are you sure you want to change the price of 'PLATFORM'? Changing it will require you to search for new developers again, since not all of the currently on-board developers might be happy with the price increase.\n\nThere are currently GAMES in development."), "PLATFORM", self.name, "GAMES", gameProject:getGameCountString(#self.inDevGames)), "pix24", "pix20", true)
			local button = popup:addButton("pix20", _T("REVERT_PRICE_CHANGE", "Revert price change"), playerPlatform.revertPriceChangeCallback)
			
			button.platform = self
			button.oldCost = oldCost
			
			local button = popup:addButton("pix20", _T("CONFIRM_PRICE_CHANGE", "Confirm price change"), playerPlatform.confirmPriceChangeCallback)
			
			button.platform = self
			
			popup:hideCloseButton()
			frameController:push(popup)
		end
	elseif self.cost ~= oldCost then
		if oldCost < self.cost and self.cost > self.releaseCost then
			local popup = game.createPopup(500, _T("CONFIRM_PRICE_CHANGE_TITLE", "Confirm Price Change"), _T("POST_RELEASE_PRICE_CHANGE", "Are you sure you want to increase the cost of the platform?\n\nIncreasing it post-release is bound to make potential customers unhappy."), "pix24", "pix20", true)
			local button = popup:addButton("pix20", _T("REVERT_PRICE_CHANGE", "Revert price change"), playerPlatform.revertPriceChangeCallback)
			
			button.platform = self
			button.oldCost = oldCost
			
			local button = popup:addButton("pix20", _T("CONFIRM_PRICE_CHANGE", "Confirm price change"), playerPlatform.confirmPriceChangePostRelCallback)
			
			button.platform = self
			
			popup:hideCloseButton()
			frameController:push(popup)
		else
			self:setupCostEvaluation()
		end
	end
end

function playerPlatform:resetSearchData()
	table.clearArray(self.inDevGames)
	
	self.mostDevsFound = 0
	self.lastDevSearchCost = nil
	self.devSearchFinished = false
end

playerPlatform.devCountFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s разработчиков согласились делать для вас игры", "%s разработчика согласились делать для вас игры", "%s разработчик согласился делать для вас игры")
	end
}
playerPlatform.devCountLossFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s разработчиков сказали что они не могут принять этот риск из-за высокой цены консоли.", "%s разработчика сказали что они не могут принять этот риск из-за высокой цены консоли.", "%s разработчик сказал что они не могут принять этот риск из-за высокой цены консоли.")
	end
}

function playerPlatform:onFinishDevSearch()
	self.devSearchFinished = true
	self.devsSearched = false
	
	local inDev = self.inDevGames
	local total = #inDev
	local rolledDevs, lossDueToPrice, preLoss = self:getBaseDevCount()
	
	self:addDevelopers(rolledDevs)
	
	for i = 1, rolledDevs do
		total = total + 1
		
		local data = self:rollNewDevGame()
		
		inDev[total] = data
		
		self:updateLastGameDev(data)
	end
	
	self.lastDevSearchCost = self.cost
	
	if not self.mostDevsFound then
		self.mostDevsFound = rolledDevs
	else
		self.mostDevsFound = math.max(rolledDevs, self.mostDevsFound)
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("DEVELOPER_SEARCH_FINISHED_TITLE", "Dev Search Finished"))
	popup:hideCloseButton()
	popup:setText(_format(_T("DEVELOPER_SEARCH_FINISHED_DESC", "You've finished searching for developers to make launch-day games for your 'PLATFORM' console."), "PLATFORM", self.name, "DEVS", total))
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	
	local wrapW = popup.rawW - 20
	
	if rolledDevs == 0 then
		extra:addTextLine(_S(popup.rawW - 20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("DEVELOPER_SEARCH_NOONE_AGREED", "Out of the TOTAL developers we reached out to, every single one of them declined the offer to make games for our platform."), "TOTAL", preLoss), "bh20", nil, 0, wrapW, "exclamation_point_red", 22, 22)
	else
		if rolledDevs == 1 then
			extra:addTextLine(_S(popup.rawW - 20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
			
			local method = playerPlatform.devCountFormatMethods[translation.currentLanguage]
			local text
			
			if method then
				text = method(rolledDevs)
			else
				text = _T("DEVELOPER_SEARCH_AGREED_ONE", "1 developer has decided to make games for you.")
			end
			
			extra:addText(text, "bh20", game.UI_COLORS.IMPORTANT_1, 5, wrapW)
		else
			extra:addTextLine(_S(popup.rawW - 20), game.UI_COLORS.GREEN, nil, "weak_gradient_horizontal")
			
			local method = playerPlatform.devCountFormatMethods[translation.currentLanguage]
			local text
			
			if method then
				text = method(rolledDevs)
			else
				text = _format(_T("DEVELOPER_SEARCH_AGREED_AMOUNT", "DEVS developers have decided to make games for you."), "DEVS", rolledDevs)
			end
			
			extra:addText(text, "bh20", game.UI_COLORS.GREEN, 5, wrapW)
		end
		
		extra:addTextLine(_S(popup.rawW - 20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_T("DEVELOPER_SEARCH_DEV_TIME", "Note that they might need more time to finish the games than there is remaining console development time."), "bh18", nil, 0, wrapW, "question_mark", 22, 22)
	end
	
	if lossDueToPrice ~= 0 then
		extra:addSpaceToNextText(5)
		extra:addTextLine(_S(popup.rawW - 20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		
		local method = playerPlatform.devCountLossFormatMethods[translation.currentLanguage]
		
		if method then
			extra:addText(method(lossDueToPrice), "bh20", nil, 0, wrapW, "exclamation_point_red", 22, 22)
		elseif lossDueToPrice == 1 then
			extra:addText(_T("DEVELOPER_SEARCH_RISK_HIGH_PRICE_SINGLE", "1 developer said they can't take the risk, because the platform is priced too high."), "bh20", nil, 0, wrapW, "exclamation_point_red", 22, 22)
		else
			extra:addText(_format(_T("DEVELOPER_SEARCH_RISK_HIGH_PRICE_MULTIPLE", "DEVS developers said they can't take the risk, because the platform is priced too high."), "DEVS", lossDueToPrice), "bh20", nil, 0, wrapW, "exclamation_point_red", 22, 22)
		end
	end
	
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
	events:fire(playerPlatform.EVENTS.DEV_SEARCH_FINISHED, self, rolledDevs)
	
	return total
end

function playerPlatform:getBaseDevCount()
	local range = self.realAttractiveness / playerPlatform.ATTRACTIVENESS_TO_DEVS
	local devDiff = self.realDevDifficulty
	
	if devDiff < playerPlatform.DEV_DIFFICULTY_TO_EXTRA_DEV then
		range = math.ceil(range + (playerPlatform.DEV_DIFFICULTY_TO_EXTRA_DEV - devDiff) / playerPlatform.DEV_DIFFICULTY_DELTA_DIVIDER_BOOST)
	else
		range = math.ceil(range)
	end
	
	local preLoss = range
	local cashDevLoss = math.floor(self:getDevAttractivenessPriceLoss() / 20)
	
	range = range - cashDevLoss
	
	return math.max(playerPlatform.MINIMUM_DEVS, range), cashDevLoss, preLoss
end

function playerPlatform:calculateMaxDevelopers()
	local baseAmt = (self:getBaseDevCount() + playerPlatform.MAX_DEVS_BASE + math.ceil(self.devAttractiveness / playerPlatform.DEV_ATTRACT_TO_MAX_DEVS)) * self.maxGamesMult
	
	if self.supportDrop then
		baseAmt = math.ceil(baseAmt * playerPlatform.POST_SUPPORT_DROP_DEV_MULTIPLIER)
	end
	
	return baseAmt
end

function playerPlatform:calculateMaxGamesPerDev()
	self.maxGamesPerDev = math.floor(playerPlatform.MAX_GAMES_PER_DEV * self.maxGamesMult)
end

function playerPlatform:getNewDevChance(devDelta)
	return playerPlatform.BASE_DEV_CHANCE + devDelta^playerPlatform.DEV_CHANCE_EXPONENT
end

playerPlatform.DEV_DELTA_TO_NEW_DEVS = 6

function playerPlatform:getNewDevs(devDelta)
	return math.max(playerPlatform.MIN_DEVS_PER_MONTH, math.round((devDelta + playerPlatform.MAX_DEVS_BASE) / playerPlatform.DEV_DELTA_TO_NEW_DEVS))
end

function playerPlatform:rollNewDevGame()
	local new = {}
	
	self:applyDevVars(new)
	
	return new
end

function playerPlatform:startNewGameDev(data)
	local range = playerPlatform.GAME_TIME_DELAY
	
	self:applyDevVars(data)
	
	local devTime = data[1] + math.random(range[1], range[2])
	
	data[1], data[2] = devTime, devTime
	
	self:updateLastGameDev(data)
end

function playerPlatform:applyDevVars(struct)
	local maxScale = self.realMaxProjectScale
	local max = playerPlatform.MINIMUM_DEV_TIME + playerPlatform.DEV_TIME_PER_SCALE * maxScale
	local devTime = math.random(playerPlatform.MINIMUM_DEV_TIME, max)
	local scale = devTime / max * maxScale
	local games = struct[4]
	
	struct[1] = devTime
	struct[2] = devTime
	struct[3] = scale
	
	if games then
		struct[4] = games + 1
	else
		struct[4] = 1
	end
end

function playerPlatform:addDevelopers(amount)
	self.developers = self.developers + amount
end

function playerPlatform:createFirmwareUpdateTask()
	local obj = task.new("firmware_update_task")
	
	return obj
end

function playerPlatform:setFirmwareUpdateState(state)
	self.firmwareUpdate = state
end

function playerPlatform:getFirmwareUpdateState()
	return self.firmwareUpdate
end

function playerPlatform:advertisePlatformCallback()
	self.platform:createAdvertisementSetupPopup()
end

function playerPlatform:createAdvertisementSetupPopup()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setTitle(_T("PLATFORM_ADJUST_ADVERT_DURATION_TITLE", "Adjust Advertisement Duration"))
	frame:setSize(400, 140)
	
	local frameH = 35
	local descbox = gui.create("PlatformAdvertDescbox", frame)
	
	descbox:setShowRectSprites(false)
	descbox:setFadeInSpeed(0)
	descbox:setPos(_S(5), _S(30))
	descbox:setPlatform(self)
	descbox:setWrapWidth(frame.rawW - 10)
	descbox:insertBaseText()
	
	frameH = frameH + _US(descbox.h)
	
	local buttonWidth = (frame.rawW - 15) / 2
	local buttonHeight = 28
	
	frame:setHeight(frameH + buttonHeight + 45)
	
	local slider = gui.create("PlatformAdvertDurationSlider", frame)
	
	slider:setPlatform(self)
	slider:setFont("bh22")
	slider:setText(_T("PLATFORM_ADVERTISEMENT_DURATION", "Advertisement duration: SLIDER_VALUE"))
	slider:setMinMax(playerPlatform.ADVERT_MIN_DURATION, playerPlatform.ADVERT_MAX_DURATION)
	slider:setSize(frame.rawW - 10, 38)
	slider:setPlatform(self)
	slider:setValue(playerPlatform.ADVERT_DEFAULT_DURATION)
	slider:setPos(_S(5), descbox.h + descbox.y + _S(5))
	
	local startButton = gui.create("BeginPlatformAdvertButton", frame)
	
	startButton:setSize(buttonWidth, buttonHeight)
	startButton:setFont("bh24")
	startButton:setText(_T("CONFIRM", "Confirm"))
	startButton:setPlatform(self)
	startButton:setPos(_S(5), frame.h - startButton.h - _S(5))
	startButton:updateState(playerPlatform.ADVERT_DEFAULT_DURATION)
	startButton:setDurationSlider(slider)
	
	local cancelButton = gui.create("GenericFrameControllerPopButton", frame)
	
	cancelButton:setSize(buttonWidth, buttonHeight)
	cancelButton:setFont("bh24")
	cancelButton:setText(_T("CANCEL", "Cancel"))
	cancelButton:setPos(frame.w - _S(5) - cancelButton.w, startButton.y)
	frame:center()
	frameController:push(frame)
end

function playerPlatform:getAdvertDurationCost(duration)
	return duration * playerPlatform.ADVERT_COST_PER_DURATION
end

function playerPlatform:beginAdvertisement(duration)
	self:addAdvertisementRounds(duration)
	
	local cost = self:getAdvertDurationCost(duration)
	
	self.initialAdvertDuration = duration
	self.advertCost = cost
	self.moneySpent = self.moneySpent + cost
	
	self:updateFundChange(-cost)
	studio:deductFunds(cost)
	
	local popup = game.createPopup(500, _T("PLATFORM_ADVERTISEMENT_BEGUN", "Platform Advertisement Begun"), _format(_T("PLATFORM_ADVERTISEMENT_BEGUN_DESC", "You've begun an advertisement campaign for your 'PLATFORM' console. It will last for TIME, and the platform will accumulate interest over its duration."), "PLATFORM", self.name, "TIME", timeline:getTimePeriodText(duration * timeline.DAYS_IN_WEEK)), "pix24", "pix20")
	
	frameController:push(popup)
	events:fire(playerPlatform.EVENTS.ADVERT_STARTED, self)
end

function playerPlatform:fillInteractionComboBox(combobox)
	local option = combobox:addOption(0, 0, 0, 24, _T("SHOW_PLATFORM_INFO", "Show platform info..."), fonts.get("pix20"), playerPlatform.openInfoPopupCallback)
	
	option.platform = self
	
	if not self.finished then
		local option = combobox:addOption(0, 0, 0, 24, _T("PLATFORM_CANCEL_DEVELOPMENT", "Cancel development..."), fonts.get("pix20"), playerPlatform.cancelDevelopmentCallback)
		
		option.platform = self
		
		if not interactionRestrictor:canPerformAction("cancel_platform") then
			option:setCanClick(false)
		end
		
		if interactionRestrictor:canPerformAction("look_for_developers") and not self.devsSearched and (not self.devSearchFinished or self.lastDevSearchCost and self.cost ~= self.lastDevSearchCost) then
			combobox:setOptionButtonType("LookForDevsOption")
			
			local option = combobox:addOption(0, 0, 0, 24, _T("PLATFORM_LOOK_FOR_DEVELOPERS", "Look for developers..."), fonts.get("pix20"), playerPlatform.lookForDevelopersCallback)
			
			option:setID(playerPlatform.LOOK_FOR_DEVS_BUTTON_ID)
			option:setPlatform(self)
			option:verifyClickState()
			combobox:setOptionButtonType("ComboBoxOption")
		end
	else
		for key, data in ipairs(self.activeRandomEvents) do
			data:fillInteractionComboBox(combobox, self)
		end
	end
	
	if self.advertRounds == 0 then
		local option = combobox:addOption(0, 0, 0, 24, _T("PLATFORM_ADVERTISE_PLATFORM", "Advertise platform..."), fonts.get("pix20"), playerPlatform.advertisePlatformCallback)
		
		option.platform = self
	end
	
	if self.released then
		local canPerform = interactionRestrictor:canPerformAction("discontinue_platform")
		
		if not self.supportDrop then
			local option = combobox:addOption(0, 0, 0, 24, _T("PLAYER_DROP_SUPPORT", "Drop support..."), fonts.get("pix20"), playerPlatform.confirmSupportDropCallback)
			
			option.platform = self
			
			if not canPerform then
				option:setCanClick(false)
			end
		end
		
		local option = combobox:addOption(0, 0, 0, 24, _T("PLATFORM_DISCONTINUE", "Discontinue platform..."), fonts.get("pix20"), playerPlatform.confirmDiscontinuationCallback)
		
		option.platform = self
		
		if not canPerform then
			option:setCanClick(false)
		end
	end
	
	events:fire(playerPlatform.EVENTS.OPENED_INTERACTION_MENU, self)
end

playerPlatform.FIRMWARE_UPDATE_WORK_AMOUNT = 400

function playerPlatform:_addIncompleteReason(reasonList, data)
	reasonList = reasonList or {}
	
	table.insert(reasonList, data)
	
	return reasonList
end

function playerPlatform:getPlatformWorkState()
	local reasonList
	
	if not self.name or string.withoutspaces(self.name) == "" then
		reasonList = self:_addIncompleteReason(reasonList, {
			font = "bh20",
			wrapWidth = 450,
			iconHeight = 22,
			icon = "exclamation_point_yellow",
			iconWidth = 22,
			text = _T("PLATFORM_NAME_INCORRECT", "Must set a name for the platform")
		})
	end
	
	if self.cost <= 0 then
		reasonList = self:_addIncompleteReason(reasonList, {
			font = "bh20",
			wrapWidth = 450,
			iconHeight = 22,
			icon = "exclamation_point_yellow",
			iconWidth = 22,
			text = _T("PLATFORM_PRICE_INCORRECT", "Must set a price for the platform")
		})
	end
	
	return reasonList
end

function playerPlatform:updateFirmwareCallback()
	local bestEmployee = studio:getMostExperiencedEmployee("software_engineer", studio.genericAvailabilityCheck)
	
	if bestEmployee then
		local taskObj = self.platform:createFirmwareUpdateTask()
		
		taskObj:setRequiredWork(playerPlatform.FIRMWARE_UPDATE_WORK_AMOUNT)
		taskObj:setPlatform(self.platform)
		taskObj:setAssignee(bestEmployee)
		bestEmployee:setTask(taskObj)
		self.platform:setFirmwareUpdateState(true)
		
		local popup = game.createPopup(500, _T("FIRMWARE_UPDATE_STARTED_TITLE", "Firmware Update Started"), _format(_T("FIRMWARE_UPDATE_STARTED_DESC", "NAME has been assigned to make a firmware update for 'PLATFORM'.\n\nThe update will be released once it is finished."), "NAME", bestEmployee:getFullName(true), "PLATFORM", self.platform:getName()), "pix24", "pix20")
		
		frameController:push(popup)
	else
		local popup = game.createPopup(500, _T("NO_SOFTWARE_ENGINEERS_TITLE", "No Software Engineers"), _T("FIRMWARE_UPDATE_NOT_AVAILABLE", "Can not start work on a firmware update as you have no software engineers available."), "pix24", "pix20")
		
		frameController:push(popup)
	end
end

function playerPlatform:releaseFirmwareUpdate()
	self.firmwareUpdate = false
	
	events:fire(playerPlatform.EVENTS.FIRMWARE_UPDATED, self)
end

function playerPlatform:addFirmwareUpdateOption(combobox)
	if combobox.firmwareOption then
		return 
	end
	
	combobox.firmwareOption = true
	
	local option = combobox:addOption(0, 0, 0, 24, _T("UPDATE_FIRMWARE", "Update firmware"), fonts.get("pix20"), playerPlatform.updateFirmwareCallback)
	
	option.platform = self
end

playerPlatform.scrappedGamesFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s игр было отменено из-за прекращения разработки консоли", "%s игры были отменены из-за прекращения разработки консоли", "%s игра была отменена из-за прекращения разработки консоли")
	end
}

function playerPlatform:cancelDevelopment()
	platformShare:dereferencePlatformID(self.platformID)
	
	local scrapped = self:canInDevGames()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLATFORM_CANCELLED_TITLE", "Platform Cancelled"))
	popup:setText(_format(_T("PLATFORM_CANCELLED_DESC", "You've cancelled the development of your 'PLATFORM' console."), "PLATFORM", self.name))
	
	local left, right, extra = popup:getDescboxes()
	local scrapText
	local method = playerPlatform.scrappedGamesFormatMethods[translation.currentLanguage]
	
	if method and scrapped > 0 then
		scrapText = method(scrapped)
	elseif scrapped == 1 then
		scrapText = _T("PLATFORM_POST_CANCEL_SCRAPPED_GAME", "1 game had to be canned due to cancellation of the platform.")
	elseif scrapped > 1 then
		scrapText = _format(_T("PLATFORM_POST_CANCEL_SCRAPPED_GAMES", "GAMES games had to be canned due to cancellation of the platform."), "GAMES", scrapped)
	end
	
	if scrapText then
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		extra:addText(scrapText, "bh18", nil, 0, popup.rawW - 20, "exclamation_point_yellow", 22, 22)
	end
	
	popup:addOKButton("pix20")
	popup:center()
	
	local ourID = self.platformID
	
	for key, id in ipairs(playerPlatform.CONVERSATION_IDS) do
		if conversations:canTalkAboutTopic(id) == ourID then
			conversations:removeTopicToTalkAbout(id)
		end
	end
	
	frameController:push(popup)
	events:fire(playerPlatform.EVENTS.CANCELLED_DEVELOPMENT, self)
end

function playerPlatform:setName(name)
	self.name = name
	
	events:fire(playerPlatform.EVENTS.NAME_SET, self)
end

function playerPlatform:getName()
	return self.name
end

function playerPlatform:postKillInfoPopup()
	self.platform:createCloseVerificationPopup(self.oldCost)
end

playerPlatform.IN_DEV_HOVER_TEXT = {
	{
		font = "bh18",
		iconHeight = 22,
		icon = "question_mark",
		lineSpace = 5,
		iconWidth = 22
	},
	{
		font = "bh18"
	}
}
playerPlatform.ATTRACT_HOVER_TEXT = {
	{
		font = "bh18",
		wrapWidth = 350,
		lineSpace = 5,
		text = _T("PLATFORM_ATTRACTIVENESS_DESC_1", "Indicates how attractive the platform is to potential customers.")
	},
	{
		iconHeight = 22,
		wrapWidth = 350,
		icon = "question_mark",
		iconWidth = 22,
		lineSpace = 5,
		font = "bh18",
		text = _T("PLATFORM_ATTRACTIVENESS_DESC_2", "A higher value means more sales, and slower migration to other competing platforms."),
		textColor = game.UI_COLORS.LIGHT_BLUE
	},
	{
		font = "bh18",
		wrapWidth = 350,
		text = _T("PLATFORM_ATTRACTIVENESS_DESC_3", "Can be temporarily boosted by performing advertisement.")
	}
}
playerPlatform.DEV_DIFFICULTY_HOVER_TEXT = {
	{
		font = "bh18",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("PLATFORM_DEV_DIFFICULTY_DESC_1", "Indicates how difficult it is to develop games for this platform. A low difficulty rating will attract more game developers.")
	}
}
playerPlatform.DEV_MAX_GAME_SCALE_HOVER_TEXT = {
	{
		font = "bh18",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("PLATFORM_MAX_GAME_SCALE_DESC", "Determines the maximum game project scale for this platform. Larger projects can carry a greater price-tag, and therefore net more money.")
	},
	{
		iconWidth = 22,
		font = "bh18",
		wrapWidth = 400,
		iconHeight = 22,
		icon = "game_scale",
		textColor = game.UI_COLORS.LIGHT_BLUE
	}
}
playerPlatform.INTEREST_HOVER_TEXT = {
	{
		font = "bh18",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("PLATFORM_INTEREST_DESC", "Influences platform sales, can be increased by advertisement.")
	}
}

function playerPlatform:createInfoPopup()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 540)
	frame:setFont("pix24")
	frame:setTitle(_format(_T("PLATFORM_INFO_TITLE", "'PLATFORM' - Info"), "PLATFORM", self.name))
	
	frame.oldCost = self.cost
	frame.platform = self
	frame.postKill = playerPlatform.postKillInfoPopup
	
	local scroll = gui.create("ScrollbarPanel", frame)
	
	scroll:setPos(_S(5), _S(35))
	scroll:setSize(frame.rawW - 10, frame.rawH - 145)
	scroll:setAdjustElementPosition(true)
	scroll:setSpacing(3)
	scroll:setPadding(3, 3)
	scroll:addDepth(100)
	
	local elemW = frame.rawW - _S(17)
	local statsCat = gui.create("Category")
	
	statsCat:setFont("bh24")
	statsCat:setText(_T("PLATFORM_BASIC_STATS", "Stats"))
	statsCat:assumeScrollbar(scroll)
	scroll:addItem(statsCat)
	
	local attractDisplay = gui.create("GradientIconPanel", nil)
	
	attractDisplay:setIcon("platform_attractiveness")
	attractDisplay:setBaseSize(elemW, 0)
	attractDisplay:setIconSize(20, nil, 22)
	attractDisplay:setFont("bh20")
	attractDisplay:setHoverText(playerPlatform.ATTRACT_HOVER_TEXT)
	
	local attrValue
	
	if not self.released then
		attrValue = self.realAttractiveness + platformShare:getBasePlatformAttractiveness(self.platformID)
	else
		attrValue = self.attractiveness
	end
	
	attractDisplay:setText(_format(_T("PLATFORM_ATTRACTIVENESS", "Attractiveness: ATTRACT pts."), "ATTRACT", math.round(attrValue)))
	statsCat:addItem(attractDisplay)
	
	local devAttractDisp = gui.create("DevAttractivenessIconPanel", nil)
	
	devAttractDisp:setPlatform(self)
	devAttractDisp:setIcon("platform_dev_attractiveness")
	devAttractDisp:setBaseSize(elemW, 0)
	devAttractDisp:setIconSize(20, nil, 22)
	devAttractDisp:setFont("bh20")
	devAttractDisp:updateText()
	statsCat:addItem(devAttractDisp)
	
	local devDiffDisp = gui.create("GradientIconPanel", nil)
	
	devDiffDisp:setIcon("platform_dev_difficulty")
	devDiffDisp:setBaseSize(elemW, 0)
	devDiffDisp:setIconSize(20, nil, 22)
	devDiffDisp:setFont("bh20")
	devDiffDisp:setText(_format(_T("PLATFORM_DEVELOPMENT_DIFFICULTY", "Development difficulty: DIFF%"), "DIFF", math.round(self:getDevelopmentDifficulty() * 100, 1)))
	devDiffDisp:setHoverText(playerPlatform.DEV_DIFFICULTY_HOVER_TEXT)
	statsCat:addItem(devDiffDisp)
	
	local maxScale = gui.create("GradientIconPanel", nil)
	
	maxScale:setIcon("platform_max_game_scale")
	maxScale:setBaseSize(elemW, 0)
	maxScale:setIconSize(20, nil, 22)
	maxScale:setFont("bh20")
	
	local maxGameScale = self.realMaxProjectScale
	
	maxScale:setText(_format(_T("PLATFORM_MAX_GAME_SCALE", "Max. game scale: xSCALE"), "SCALE", maxGameScale))
	maxScale:setHoverText(playerPlatform.DEV_MAX_GAME_SCALE_HOVER_TEXT)
	
	playerPlatform.DEV_MAX_GAME_SCALE_HOVER_TEXT[2].text = _format(_T("PLATFORM_HIGHEST_BEST_GAME_PRICE", "Highest best game price: $PRICE"), "PRICE", gameProject:getScaleIdealPriceAffector(nil, maxGameScale))
	
	statsCat:addItem(maxScale)
	
	local attractDisplay = gui.create("GradientIconPanel", nil)
	
	attractDisplay:setIcon("platform_interest")
	attractDisplay:setBaseSize(elemW, 0)
	attractDisplay:setIconSize(20, nil, 22)
	attractDisplay:setFont("bh20")
	attractDisplay:setIconOffset(1, 1)
	attractDisplay:setText(_format(_T("PLATFORM_INTEREST", "Interest: INTEREST pts."), "INTEREST", string.roundtobignumber(self.interest)))
	attractDisplay:setHoverText(playerPlatform.INTEREST_HOVER_TEXT)
	statsCat:addItem(attractDisplay)
	
	local inDev = gui.create("GradientIconPanel", nil)
	
	inDev:setIcon("platform_games_indev_24")
	inDev:setBaseSize(elemW, 0)
	inDev:setIconSize(20, nil, 22)
	inDev:setFont("bh20")
	inDev:setText(_format(_T("PLATFORM_GAMES_IN_DEV", "Games in-development: AMOUNT"), "AMOUNT", string.comma(#self.inDevGames)))
	
	if #self.inDevGames > 0 then
		playerPlatform.IN_DEV_HOVER_TEXT[1].text = self:getGameDevText()
		
		if self.newDevsMonth > 0 then
			playerPlatform.IN_DEV_HOVER_TEXT[2].text = _format(_T("PLATFORM_NEW_DEVS_THIS_MONTH", "New developers this month: GAMES"), "GAMES", self.newDevsMonth)
		else
			playerPlatform.IN_DEV_HOVER_TEXT[2].text = _T("PLATFORM_NEW_DEVS_THIS_MONTH_NONE", "No new developers this month.")
		end
		
		inDev:setHoverText(playerPlatform.IN_DEV_HOVER_TEXT)
	end
	
	statsCat:addItem(inDev)
	
	if self.advertRounds > 0 then
		local advertRoundDisplay = gui.create("GradientIconPanel", nil)
		
		advertRoundDisplay:setIcon("advertisement")
		advertRoundDisplay:setBaseSize(elemW, 0)
		advertRoundDisplay:setIconSize(20, nil, 22)
		advertRoundDisplay:setFont("bh20")
		advertRoundDisplay:setText(_format(_T("PLATFORM_ADVERT_ROUNDS", "Advertisement rounds: AMOUNT"), "AMOUNT", string.comma(self.advertRounds)))
		advertRoundDisplay:setTextColor(game.UI_COLORS.LIGHT_GREEN)
		advertRoundDisplay:setGradientColor(game.UI_COLORS.LIGHT_GREEN)
		statsCat:addItem(advertRoundDisplay)
	end
	
	local financesCat = gui.create("Category")
	
	financesCat:setFont("bh24")
	financesCat:setText(_T("PLATFORM_FINANCES", "Finances"))
	financesCat:assumeScrollbar(scroll)
	scroll:addItem(financesCat)
	
	local net = self.moneyMade - self.moneySpent
	local netChange = gui.create("GradientIconPanel", nil)
	
	if net < 0 then
		netChange:setIcon("wad_of_cash_minus")
		netChange:setTextColor(game.UI_COLORS.RED)
		netChange:setGradientColor(game.UI_COLORS.RED)
	elseif net > 0 then
		netChange:setIcon("wad_of_cash_plus")
		netChange:setTextColor(game.UI_COLORS.LIGHT_GREEN)
		netChange:setGradientColor(game.UI_COLORS.LIGHT_GREEN)
	else
		netChange:setTextColor(game.UI_COLORS.GREY)
		netChange:setIcon("wad_of_cash")
	end
	
	netChange:setBaseSize(elemW, 0)
	netChange:setIconSize(20, nil, 22)
	netChange:setFont("bh20")
	
	local hover = {}
	
	if self.released then
		table.insert(hover, {
			font = "bh18",
			wrapWidth = 300,
			iconWidth = 22,
			icon = "platform_units_sold",
			iconHeight = 22,
			text = _format(_T("PLATFORM_UNIT_SALES", "Unit sales: SALES"), "SALES", string.roundtobigcashnumber(self.unitSales)),
			textColor = game.UI_COLORS.LIGHT_BLUE
		})
		table.insert(hover, {
			font = "bh18",
			wrapWidth = 300,
			iconWidth = 22,
			icon = "platform_max_game_scale",
			iconHeight = 22,
			text = _format(_T("PLATFORM_GAME_REVENUE_TOTAL", "Game revenue: REVENUE"), "REVENUE", string.roundtobigcashnumber(self.gameMoney)),
			textColor = game.UI_COLORS.LIGHT_BLUE
		})
		table.insert(hover, {
			font = "bh18",
			wrapWidth = 300,
			iconWidth = 22,
			icon = "platform_license_sales",
			iconHeight = 22,
			text = _format(_T("PLATFORM_DEV_LICENSES_TOTAL", "Dev licenses: REVENUE"), "REVENUE", string.roundtobigcashnumber(self.licenseMoney)),
			textColor = game.UI_COLORS.LIGHT_BLUE
		})
		table.insert(hover, {
			font = "bh18",
			wrapWidth = 300,
			iconWidth = 22,
			icon = "platform_manufacture_cost",
			iconHeight = 22,
			text = _format(_T("PLATFORM_UNIT_MANUFACTURING_EXPENSES", "Manufacturing expenses: -EXP"), "EXP", string.roundtobigcashnumber(self.manufacturingExpenses)),
			textColor = game.UI_COLORS.RED
		})
		table.insert(hover, {
			font = "bh18",
			wrapWidth = 300,
			iconWidth = 22,
			icon = "platform_repair_cost",
			iconHeight = 22,
			text = _format(_T("PLATFORM_UNIT_REPAIR_EXPENSES", "Repair expenses: -EXP"), "EXP", string.roundtobigcashnumber(self.repairExpenses)),
			textColor = game.UI_COLORS.RED
		})
	end
	
	table.insert(hover, {
		font = "bh18",
		iconWidth = 22,
		iconHeight = 22,
		icon = "platform_manufacture_cost",
		text = _format(_T("PLATFORM_DEVELOPMENT_EXPENSES", "Development expenses: -EXP"), "EXP", string.roundtobigcashnumber(self.devCosts)),
		textColor = game.UI_COLORS.RED
	})
	netChange:setHoverText(hover)
	netChange:setText(_format(_T("PLATFORM_LIFETIME_NET_CHANGE", "Lifetime net change: CHANGE"), "CHANGE", string.roundtobigcashnumber(net)))
	financesCat:addItem(netChange)
	
	local manufacCost = self.realManufactureCost
	local manCost = gui.create("GradientIconPanel", nil)
	
	manCost:setIcon("platform_manufacture_cost")
	manCost:setBaseSize(elemW, 0)
	manCost:setIconSize(20, nil, 22)
	manCost:setFont("bh20")
	manCost:setText(_format(_T("PLATFORM_MANUFACTURING_COST", "Manufacturing cost: $COST"), "COST", manufacCost))
	financesCat:addItem(manCost)
	
	local net = self.moneyMade - self.moneySpent
	local netChange = gui.create("PlatformNetChangeIconPanel", nil)
	
	netChange:setBaseSize(elemW, 0)
	netChange:setIconSize(20, nil, 22)
	netChange:setFont("bh20")
	netChange:setPlatform(self)
	
	local range = playerPlatform.REPAIR_COST_RANGE
	
	netChange:updateText()
	financesCat:addItem(netChange)
	
	local soldPlatforms = gui.create("GradientIconPanel", nil)
	
	soldPlatforms:setIcon("platform_units_sold")
	soldPlatforms:setBaseSize(elemW, 0)
	soldPlatforms:setIconSize(20, nil, 22)
	soldPlatforms:setFont("bh20")
	soldPlatforms:setText(_format(_T("PLATFORM_UNITS_SOLD", "Units sold: COST"), "COST", string.comma(self.sales)))
	soldPlatforms:setTextColor(game.UI_COLORS.LIGHT_BLUE)
	soldPlatforms:setGradientColor(game.UI_COLORS.LIGHT_BLUE)
	financesCat:addItem(soldPlatforms)
	
	local soldPlatforms = gui.create("GradientIconPanel", nil)
	
	soldPlatforms:setIcon("platform_units_repaired")
	soldPlatforms:setBaseSize(elemW, 0)
	soldPlatforms:setIconSize(20, nil, 22)
	soldPlatforms:setFont("bh20")
	soldPlatforms:setText(_format(_T("PLATFORM_UNITS_REPAIRED", "Units repaired: REPAIRS"), "REPAIRS", string.comma(self.repairs)))
	soldPlatforms:setTextColor(game.UI_COLORS.IMPORTANT_1)
	soldPlatforms:setGradientColor(game.UI_COLORS.IMPORTANT_1)
	financesCat:addItem(soldPlatforms)
	
	local repairCost = gui.create("GradientIconPanel", nil)
	
	repairCost:setIcon("platform_repair_cost")
	repairCost:setBaseSize(elemW, 0)
	repairCost:setIconSize(20, nil, 22)
	repairCost:setFont("bh20")
	repairCost:setTextColor(game.UI_COLORS.IMPORTANT_1)
	repairCost:setGradientColor(game.UI_COLORS.IMPORTANT_1)
	
	local range = playerPlatform.REPAIR_COST_RANGE
	
	repairCost:setText(_format(_T("PLATFORM_REPAIR_COST", "Repair cost: $MIN - $MAX"), "MIN", math.round(manufacCost * range[1], 1), "MAX", math.round(manufacCost * range[2], 1)))
	financesCat:addItem(repairCost)
	
	local boostCat = gui.create("Category")
	
	boostCat:setFont("bh24")
	boostCat:setText(_T("PLATFORM_BASIC_AFFECTORS", "Affectors"))
	boostCat:assumeScrollbar(scroll)
	scroll:addItem(boostCat)
	
	if self.specialist then
		local data = platformParts.registeredSpecialistsByID[self.specialist]
		
		data:addToBoostCategory(boostCat, elemW)
	end
	
	if not boostCat:getItems() then
		boostCat:setText(_T("PLATFORM_BASIC_AFFECTORS_NONE", "No boosts"))
	end
	
	for key, data in ipairs(self.activeRandomEvents) do
		data:setupAffectorCategory(boostCat, elemW)
	end
	
	local scaledFive = _S(5)
	local x, y = scaledFive, scroll.y + scroll.h + scaledFive
	local size, gap = platformParts.elementSize, platformParts.elementGap
	local sSize, sGap = _S(size), _S(gap)
	
	for key, typeID in ipairs(platformParts.TYPES_ENUM) do
		local element = gui.create("SelectedPlatformPart", frame)
		
		element:setPlatform(self)
		element:setCanShowOptions(false)
		element:setSize(size, size)
		element:setPos(x, y)
		element:setPartType(typeID)
		
		x = x + sSize + sGap
	end
	
	local changeSize = size / 2
	local displayWidth = 70
	local supportDisp = gui.create("PlatformSupportDisplay", frame)
	
	supportDisp:setPos(x, y)
	supportDisp:setSize(displayWidth, size)
	supportDisp:setFont("bh24")
	supportDisp:setPlatform(self)
	supportDisp:setText(self.support)
	supportDisp:updateText()
	
	x = x + scaledFive + supportDisp.w
	
	local incSup = gui.create("ChangePlatformSupportButton", frame)
	
	incSup:setPos(x, y)
	incSup:setPlatform(self)
	incSup:setIcon("increase")
	incSup:setDirection(1)
	incSup:setSize(changeSize, changeSize)
	
	local decSup = gui.create("ChangePlatformSupportButton", frame)
	
	decSup:setPos(x, y + _S(changeSize + 1))
	decSup:setPlatform(self)
	decSup:setIcon("decrease")
	decSup:setDirection(-1)
	decSup:setSize(changeSize, changeSize)
	
	x = x + scaledFive + decSup.w
	
	local prodDisp = gui.create("PlatformProductionDisplay", frame)
	
	prodDisp:setPos(x, y)
	prodDisp:setSize(displayWidth, size)
	prodDisp:setFont("bh24")
	prodDisp:setPlatform(self)
	prodDisp:setText(self.production)
	prodDisp:updateText()
	
	x = x + scaledFive + prodDisp.w
	
	local incSup = gui.create("ChangePlatformProductionButton", frame)
	
	incSup:setPos(x, y)
	incSup:setPlatform(self)
	incSup:setIcon("increase")
	incSup:setDirection(1)
	incSup:setSize(changeSize, changeSize)
	
	local decSup = gui.create("ChangePlatformProductionButton", frame)
	
	decSup:setPos(x, y + _S(changeSize + 1))
	decSup:setPlatform(self)
	decSup:setIcon("decrease")
	decSup:setDirection(-1)
	decSup:setSize(changeSize, changeSize)
	
	local elem = self:createCostAdjustmentPanel(frame, frame.rawW - 10)
	
	elem:setPos(scroll.x, scroll.y + scroll.h + _S(45))
	frame:center()
	
	local y = 0
	local x = frame.x + frame.w + _S(10)
	
	if self.released and self.totalGamesReleased > 0 then
		local gameDisp = gui.create("PlatformGameRatingsFrame", nil, true)
		
		gameDisp:setPos(x, frame.y + y)
		gameDisp:setWidth(220)
		gameDisp:setData(self)
		gameDisp:tieVisibilityTo(frame)
		
		y = y + gameDisp.h + _S(5)
	end
	
	local fundDisp = gui.create("PlatformFundChangeDisplayFrame", nil, true)
	
	fundDisp:setPos(x, frame.y + y)
	fundDisp:setWidth(220)
	fundDisp:setData(self)
	fundDisp:tieVisibilityTo(frame)
	frameController:push(frame)
end

function playerPlatform:createCostAdjustmentPanel(parent, width)
	local backdrop = gui.create("GenericBackdrop", parent)
	
	backdrop:setSize(width, 58)
	
	local boxW = width / 2 - 5
	local textbox = gui.create("PlatformCostTextbox", backdrop)
	
	textbox:setPlatform(self)
	textbox:setSize(boxW, 28)
	textbox:setFont("bh22")
	textbox:setMinValue(playerPlatform.MINIMUM_COST)
	textbox:setMaxValue(playerPlatform.MAXIMUM_COST)
	textbox:setText(self:getCost())
	textbox:setPos(_S(3), backdrop.h - textbox.h - _S(3))
	textbox:addDepth(10)
	
	local costLabel = gui.create("Label", backdrop)
	
	costLabel:setFont("bh24")
	costLabel:setText(_T("PLATFORM_COST", "Platform cost"))
	costLabel:setPos(textbox.x, textbox.y - costLabel.h - _S(3))
	backdrop:setPos(_S(5), costLabel.y)
	
	local licenseCost = gui.create("PlatformLicenseCostTextbox", backdrop)
	
	licenseCost:setPlatform(self)
	licenseCost:setSize(boxW, 28)
	licenseCost:setFont("bh22")
	licenseCost:setMinValue(playerPlatform.MIN_LICENSE_COST)
	licenseCost:setMaxValue(playerPlatform.MAX_LICENSE_COST)
	licenseCost:setText(self:getDevLicenseCost())
	licenseCost:setPos(backdrop.w - _S(3) - licenseCost.w, textbox.y)
	
	local costLabel = gui.create("Label", backdrop)
	
	costLabel:setFont("bh24")
	costLabel:setText(_T("PLATFORM_DEV_LICENSE_COST", "Dev. license cost"))
	costLabel:setPos(licenseCost.x + licenseCost.w - costLabel.w - _S(6), licenseCost.y - costLabel.h - _S(3))
	
	return backdrop
end

function playerPlatform:changePotentialSales(amt)
	self.potentialSales = self.potentialSales + amt
end

playerPlatform.COST_PENALTY_DELTA_OFFSET = 20

function playerPlatform:modulateSales(sales, divMult)
	divMult = divMult or 1
	
	local cost = self.cost
	local baseAttr = self.baseAttractiveness
	local maxBestPrice = baseAttr * playerPlatform.ATTRACT_TO_MAX_BEST_PRICE
	local delta = self.cost - maxBestPrice
	
	sales = sales * self.impression * self.happiness
	
	if delta > 0 then
		delta = delta * math.max(1, (cost - playerPlatform.COST_PENALTY_DELTA_OFFSET) / maxBestPrice)
		
		return sales / ((1 + (delta / playerPlatform.PRICE_DELTA_SALE_DIVIDER)^playerPlatform.PRICE_DELTA_EXPONENT) * divMult)
	else
		local abs = -delta
		
		return sales * ((1 + abs^playerPlatform.PRICE_DELTA_SALE_BOOST) * divMult) * playerPlatform.SALE_BOOST
	end
end

function playerPlatform:calculateSales()
	local attr = self.attractiveness
	local sales = attr * playerPlatform.ATTRACTIVENESS_TO_SALE + self.interest * playerPlatform.INTEREST_TO_PLATFORM_SALE * self.saleMult
	local cost = self.cost
	
	sales = self:modulateSales(sales, 1)
	
	local users = platformShare:getTotalUsers()
	local cap = playerPlatform.MARKET_CAP
	local marketCap = cap.base
	local baseCap = marketCap * users
	local curSales = self.sales
	local reqRep = cap.baseRep + cost * cap.repIncreasePrice
	local log = cap.log
	local extra = studio:getReputation()^math.log(log, reqRep) / log * cap.extra
	
	if baseCap < curSales then
		local divider = (curSales - baseCap)^math.log(cap.salesDivider, extra * users)
		
		sales = sales / divider
	end
	
	return math.floor(sales)
end

function playerPlatform:generateSales(sales)
	local pool = self.salePool
	
	if pool == 0 then
		self.lostSales = self.lostSales + sales
		
		return 
	end
	
	if pool < sales then
		self.lostSales = self.lostSales + (sales - pool)
	end
	
	sales = math.min(pool, sales)
	
	local manufacCost, gainedMoney = sales * self.manufactureCost, sales * self.cost * playerPlatform.SELL_TAX * self.overallSaleMult
	local fundChange = gainedMoney - manufacCost
	
	self:changeMarketShare(sales)
	
	local salesToDrain = math.floor(sales * playerPlatform.SALE_GENERATION_DRAIN_PERCENTAGE)
	local saleBuffer = salesToDrain
	local attr = self.attractiveness
	
	for key, platObj in ipairs(platformShare.onMarketPlatforms) do
		if platObj ~= self then
			local drained = math.floor(math.min(saleBuffer, salesToDrain * (attr / platObj:getAttractiveness())))
			
			salesToDrain = salesToDrain - drained
			
			platObj:changeMarketShare(-drained)
			
			if salesToDrain <= 0 then
				break
			end
		end
	end
	
	self.moneyMade = self.moneyMade + gainedMoney
	self.manufacturingExpenses = self.manufacturingExpenses + manufacCost
	self.moneySpent = self.moneySpent + manufacCost
	self.unitSales = self.unitSales + gainedMoney
	
	if fundChange < 0 then
		studio:deductFunds(-fundChange)
		
		self.weekFundChange = self.weekFundChange - fundChange
	else
		studio:addFunds(fundChange)
		
		self.weekFundChange = self.weekFundChange + fundChange
	end
	
	local idx = self.currentSaleIndex
	
	self.sales = self.sales + sales
	
	self:updateFundChange(gainedMoney - manufacCost)
	
	self.saleData[idx] = self.saleData[idx] + gainedMoney
	self.manufactureExpenses[idx] = self.manufactureExpenses[idx] + manufacCost
	self.weekSales = sales
	self.monthSales = self.monthSales + sales
	self.salePool = pool - sales
end

function playerPlatform:updateFundChange(amt)
	local list = self.fundChange
	local data = list[#list]
	
	data[2] = data[2] + amt
end

function playerPlatform:getMaxDevs()
	return self.maxDevs
end

function playerPlatform:resetModifiers()
	if not self.platformAttractivenessMods then
		self.platformAttractivenessMods = {}
		self.maxScaleMods = {}
		self.devAttractMods = {}
		self.priceMods = {}
		self.devDifficultyMods = {}
		self.saleMods = {}
		self.gameSaleMods = {}
		self.maxGamesMods = {}
		self.licenseChanceMods = {}
		self.partCostMods = {}
		self.partCostMult = {}
		self.maxDevsMods = {}
		
		for key, value in ipairs(platformParts.TYPES_ENUM) do
			self.partCostMods[value] = {}
			self.partCostMult[value] = 1
		end
	else
		table.clear(self.platformAttractivenessMods)
		table.clear(self.maxScaleMods)
		table.clear(self.devAttractMods)
		table.clear(self.priceMods)
		table.clear(self.devDifficultyMods)
		table.clear(self.saleMods)
		table.clear(self.gameSaleMods)
		
		for key, value in ipairs(platformParts.TYPES_ENUM) do
			table.clear(self.partCostMods[value])
			
			self.partCostMult[value] = 1
		end
	end
	
	self.platformAttractivenessMult = 1
	self.maxScaleMult = 1
	self.devAttractivenessMod = 0
	self.priceMult = 1
	self.devDifficultyMult = 1
	self.saleMult = 1
	self.gameSaleMult = 1
	self.maxGamesMult = 1
	self.licenseChanceMult = 1
	self.maxDevsMult = 1
end

function playerPlatform:setCost(cost)
	self.cost = cost
	
	self:calculateDevAttractiveness()
	events:fire(playerPlatform.EVENTS.COST_SET, self)
end

function playerPlatform:setupCostEvaluation()
	if self.released and not self.evaluatingPriceChange then
		local event = scheduledEvents:instantiateEvent("platform_cost_evaluation")
		
		event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
		event:setPlatform(self)
		
		self.evaluatingPriceChange = true
	end
end

function playerPlatform:evaluateCost()
	if not self.evaluatedCost and self.cost ~= self.releaseCost or self.cost ~= self.evaluatedCost then
		local delta
		local change = 0
		local lostBoost = 0
		local evalCost, cost, relCost = self.evaluatedCost, self.cost, self.releaseCost
		
		if evalCost then
			delta = cost - evalCost
			
			if evalCost < relCost and evalCost < cost then
				lostBoost = (math.min(cost, relCost) - evalCost) / playerPlatform.PRICE_DECREASE_TO_IMPRESSION_REGAIN / 100
			end
		else
			delta = cost - relCost
		end
		
		if delta > 0 and relCost < cost then
			change = -delta / playerPlatform.PRICE_INCREASE_TO_IMPRESSION_LOSS
		elseif delta < 0 then
			change = -delta / playerPlatform.PRICE_DECREASE_TO_IMPRESSION_REGAIN
		end
		
		change = change / 100
		change = change - lostBoost
		
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTextFont("pix20")
		popup:setTitle(_T("PLATFORM_PRICE_CHANGE_REACTION", "Price Change Reaction"))
		
		local text
		
		if change > 0 then
			popup:setShowSound("good_jingle")
			
			text = _T("PLATFORM_PRICE_CHANGE_REACTION_POSITIVE", "People reacted positively to the price drop of your 'PLATFORM' console.")
		elseif change < 0 and lostBoost ~= math.abs(change) then
			popup:setShowSound("bad_jingle")
			
			text = _T("PLATFORM_PRICE_CHANGE_REACTION_NEGATIVE", "People reacted negatively to the price increase of your 'PLATFORM' console, since it is now priced higher than it was on launch day.")
		elseif lostBoost > 0 then
			popup:setShowSound("generic_jingle")
			
			text = _T("PLATFORM_PRICE_CHANGE_REACTION_LOST_BOOST", "People didn't react negatively as a whole, but were slightly disappointed to see an increase in price closer towards its launch day cost.")
		else
			popup:setShowSound("generic_jingle")
			
			text = _T("PLATFORM_PRICE_CHANGE_REACTION_UNCHANGED", "People did not react in any particular way to the price change of your 'PLATFORM' console, seeing as the price is still lower than what it used to be on launch day.")
		end
		
		popup:setText(_format(text, "PLATFORM", self.name))
		
		local left, right, extra = popup:getDescboxes()
		local wrapW = popup.rawW - 20
		local lineW = _S(wrapW)
		
		if change < 0 then
			extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("PLATFORM_IMPRESSION_LOWERED", "Overall platform sales permanently decreased by DEC%."), "DEC", math.round(math.abs(change) * 100, 1)), "bh18", nil, 0, wrapW, "decrease_red", 22, 22)
		elseif change > 0 then
			extra:addTextLine(lineW, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("PLATFORM_IMPRESSION_INCREASED", "Overall platform sales permanently increased by INC%."), "INC", math.round(change * 100, 1)), "bh18", nil, 0, wrapW, "increase", 22, 22)
		else
			extra:addTextLine(lineW, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
			extra:addText(_T("PLATFORM_IMPRESSION_UNCHANGED", "Overall platform sales remain unchanged."), "bh18", nil, 0, wrapW, "question_mark", 22, 22)
		end
		
		self.impression = math.max(playerPlatform.IMPRESSION_MIN, self.impression + change)
		
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		
		self.evaluatedCost = cost
	end
	
	self.evaluatingPriceChange = false
end

function playerPlatform:getCost()
	return self.cost
end

function playerPlatform:getLicenseCost()
	return self.devLicenseCost
end

function playerPlatform:setDevLicenseCost(cost)
	self.devLicenseCost = cost
	
	self:calculateDevAttractiveness()
	
	self.maxDevs = self:calculateMaxDevelopers()
	
	self:setupGameRatingRange()
	events:fire(playerPlatform.EVENTS.LICENSE_COST_SET, cost, self)
end

function playerPlatform:getDevLicenseCost()
	return self.devLicenseCost
end

function playerPlatform:getSaleData()
	return self.saleData, self.manufactureExpenses
end

function playerPlatform:onFinish()
	self.saleData = {}
	self.manufactureExpenses = {}
	self.devTask = nil
	
	if not self.inDevGames then
		self.inDevGames = {}
	end
	
	self.activeGames = {}
	self.currentSaleIndex = 1
	
	self:setDevStage(playerPlatform.FINISHED_STAGE)
	
	self.finished = true
	self.gameMoney = 0
	self.gameMoneyMonth = 0
	self.repairedPlatforms = 0
	self.life = playerPlatform.LIFETIME_VALUE
	self.saleData[1] = 0
	self.manufactureExpenses[1] = 0
	
	if self.specialist then
		local data = platformParts.registeredSpecialistsByID[self.specialist]
		
		data:applyAffectors(self)
	end
end

function playerPlatform:releasePlatformAndGamesCallback()
	local list = studio:getInDevGames()
	local id = self.platform:getID()
	
	self.platform:release(true, true)
	
	local index = 1
	
	for i = 1, #list do
		local gameObj = list[index]
		
		if gameObj:isPlatformSelected(id) and gameObj:isFinished() then
			gameObj:release()
		else
			index = index + 1
		end
	end
	
	self.platform:calculateImpression()
end

function playerPlatform:releasePlatformCallback()
	self.platform:release(true)
end

playerPlatform.inDevReleaseFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "У вас для выпуска на готове есть %s игр.\n\nХотите ли вы выпустить их совместно с выпуском консоли? Иметь достаточно игр при запуске игровой приставки очень важно для хорошего первого впечатления.", "У вас для выпуска на готове есть %s игры.\n\nХотите ли вы выпустить их совместно с выпуском консоли? Иметь достаточно игр при запуске игровой приставки очень важно для хорошего первого впечатления.", "У вас для выпуска на готове есть %s игра.\n\nХотите ли вы выпустить её совместно с выпуском консоли? Иметь достаточно игр при запуске игровой приставки очень важно для хорошего первого впечатления.")
	end
}

function playerPlatform:release(skipChecks, skipImpression)
	if not skipChecks then
		local id = self.platformID
		local devGames = 0
		
		for key, gameObj in ipairs(studio:getInDevGames()) do
			if gameObj:isPlatformSelected(id) and gameObj:isFinished() then
				devGames = devGames + 1
			end
		end
		
		if devGames > 0 then
			local popup = gui.create("DescboxPopup")
			
			popup:setWidth(500)
			popup:setFont("pix24")
			popup:setTextFont("pix20")
			popup:setTitle(_T("PLATFORM_RELEASE_GAMES_IN_DEV_TITLE", "Release in-dev Games?"))
			
			local method = playerPlatform.inDevReleaseFormatMethods[translation.currentLanguage]
			
			if method then
				local text = method(devGames)
				
				popup:setText(text)
			elseif devGames == 1 then
				popup:setText(_T("PLATFORM_RELEASE_GAME_IN_DEV_DESC", "You have 1 game ready to be released for this platform.\n\nWould you like to release this game in conjunction with the platform itself? Having enough launch-day games is crucial for a good first impression."))
			else
				popup:setText(_format(_T("PLATFORM_RELEASE_GAMES_IN_DEV_DESC", "You have GAMES games ready to be released for this platform.\n\nWould you like to release these games in conjunction with the platform itself? Having enough launch-day games is crucial for a good first impression."), "GAMES", devGames))
			end
			
			local left, right, extra = popup:getDescboxes()
			local button = popup:addButton("pix20", _T("RELEASE_PLATFORM_AND_GAMES", "Release platform and games"), playerPlatform.releasePlatformAndGamesCallback)
			
			button.platform = self
			
			local button = popup:addButton("pix20", _T("RELEASE_PLATFORM_ONLY", "Release just the platform"), playerPlatform.releasePlatformCallback)
			
			button.platform = self
			
			popup:addButton("pix20", _T("CANCEL", "Cancel"), nil)
			popup:center()
			frameController:push(popup)
			
			return 
		end
	end
	
	conversations:addTopicToTalkAbout(playerPlatform.CONVERSATION_RELEASE, self.platformID)
	self:calculateStats(true)
	self:finalizeStats()
	
	self.maxDevs = self:calculateMaxDevelopers()
	
	local pending = self.pendingReleaseGames
	local active = self.activeGames
	local time = timeline.curTime
	
	for key, data in ipairs(pending) do
		data.time = time
		self.activeGames[key] = data
		pending[key] = nil
	end
	
	local buffered = self.bufferedDevs
	local dev = self.inDevGames
	
	for key, data in ipairs(buffered) do
		self:startNewGameDev(data)
		
		dev[#dev + 1] = data
		buffered[key] = nil
	end
	
	if not skipImpression then
		self:calculateImpression()
	end
	
	self.releaseDate = timeline.curTime
	self.releaseCost = self.cost
	
	local event = scheduledEvents:instantiateEvent("platform_impression_result")
	
	event:setPlatform(self)
	event:setActivationDate(timeline.curTime + timeline.DAYS_IN_WEEK)
	
	self.released = true
	
	platformShare:addPlatformToShareList(self, false)
	platformShare:updateAttractiveness()
	self:createSaleDisplay()
	studio:removeDevPlayerPlatform(self)
	studio:addPlayerPlatform(self)
	studio:addActivePlayerPlatform(self)
	achievements:attemptSetAchievement(achievements.ENUM.RELEASE_CONSOLE)
	events:fire(playerPlatform.EVENTS.PLATFORM_RELEASED, self)
end

function playerPlatform:finalizeStats()
	self:finalizeMaxGameScale()
	self:finalizeManufacturingCost()
	self:finalizeAttractiveness()
	self:finalizeDevDifficulty()
	self:calculateDevAttractiveness()
	self:finalizeDevAttractiveness()
end

function playerPlatform:finalizeMaxGameScale()
	self.realMaxProjectScale = math.round(self.maxProjectScale * self.maxScaleMult, 1)
end

function playerPlatform:finalizeManufacturingCost()
	self.realManufactureCost = self.manufactureCost * self.priceMult
end

function playerPlatform:finalizeAttractiveness()
	self.realAttractiveness = self.baseAttractiveness * self.platformAttractivenessMult
end

function playerPlatform:finalizeDevAttractiveness()
	self.realDevAttractiveness = self.devAttractiveness + self.devAttractivenessMod
end

function playerPlatform:getDeveloperAttractiveness()
	return self.realDevAttractiveness
end

function playerPlatform:finalizeDevDifficulty()
	self.realDevDifficulty = self.devDifficulty * self.devDifficultyMult
end

function playerPlatform:setPartCostAffector(id, partID, val)
	local prev = self.partCostMods[partID][id]
	local curVal = self.partCostMult[partID]
	
	if prev then
		curVal = curVal - prev
	end
	
	self.partCostMods[partID][id] = val
	
	if val then
		self.partCostMult[partID] = curVal + val
	else
		self.partCostMult[partID] = curVal
	end
	
	self:calculateManufacturingCost()
	self:finalizeManufacturingCost()
end

function playerPlatform:setDevDifficultyAffector(id, val)
	local prev = self.devDifficultyMods[id]
	local curVal = self.devDifficultyMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.devDifficultyMods[id] = val
	
	if val then
		self.devDifficultyMult = curVal + val
	else
		self.devDifficultyMult = curVal
	end
	
	self:finalizeDevAttractiveness()
	self:calculateDevAttractiveness()
end

function playerPlatform:setSaleAffector(id, val)
	local prev = self.saleMods[id]
	local curVal = self.saleMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.saleMods[id] = val
	
	if val then
		self.saleMult = curVal + val
	else
		self.saleMult = curVal
	end
end

function playerPlatform:setGameSaleAffector(id, val)
	local prev = self.gameSaleMods[id]
	local curVal = self.gameSaleMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.gameSaleMods[id] = val
	
	if val then
		self.gameSaleMult = curVal + val
	else
		self.gameSaleMult = curVal
	end
end

function playerPlatform:setMaxGamesAffector(id, val)
	local prev = self.maxGamesMods[id]
	local curVal = self.maxGamesMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.maxGamesMods[id] = val
	
	if val then
		self.maxGamesMult = curVal + val
	else
		self.maxGamesMult = curVal
	end
	
	self:calculateMaxGamesPerDev()
end

function playerPlatform:setLicenseChanceAffector(id, val)
	local prev = self.licenseChanceMods[id]
	local curVal = self.licenseChanceMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.licenseChanceMods[id] = val
	
	if val then
		self.licenseChanceMult = curVal + val
	else
		self.licenseChanceMult = curVal
	end
end

function playerPlatform:setMaxDevsAffector(id, val)
	local prev = self.maxDevsMods[id]
	local curVal = self.maxDevsMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.maxDevsMods[id] = val
	
	if val then
		self.maxDevsMult = curVal + val
	else
		self.maxDevsMult = curVal
	end
	
	self.maxDevs = self:calculateMaxDevelopers()
end

function playerPlatform:setPlatformAttractModifier(id, val)
	local prev = self.platformAttractivenessMods[id]
	local curVal = self.platformAttractivenessMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.platformAttractivenessMods[id] = val
	
	if val then
		self.platformAttractivenessMult = curVal + val
	else
		self.platformAttractivenessMult = curVal
	end
end

function playerPlatform:setGameScaleModifier(id, val)
	local prev = self.maxScaleMods[id]
	local curVal = self.maxScaleMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.maxScaleMods[id] = val
	
	if val then
		self.maxScaleMult = curVal + val
	else
		self.maxScaleMult = curVal
	end
end

function playerPlatform:setDevAttractivenessModifier(id, val)
	local prev = self.devAttractMods[id]
	local curVal = self.devAttractivenessMod
	
	if prev then
		curVal = curVal - prev
	end
	
	self.devAttractMods[id] = val
	
	if val then
		self.devAttractivenessMod = curVal + val
	else
		self.devAttractivenessMod = curVal
	end
end

function playerPlatform:setPriceModifier(id, val)
	local prev = self.priceMods[id]
	local curVal = self.priceMult
	
	if prev then
		curVal = curVal - prev
	end
	
	self.priceMods[id] = val
	
	if val then
		self.priceMult = curVal + val
	else
		self.priceMult = curVal
	end
end

function playerPlatform:getRealCost()
	return self.cost * playerPlatform.SELL_TAX
end

function playerPlatform:getDevAttractivenessPriceLoss()
	local delta = self.cost - self.realAttractiveness * playerPlatform.ATTRACT_TO_MAX_BEST_PRICE
	
	if delta > 0 then
		return (delta / playerPlatform.DEV_ATTRACT_PRICE_DELTA_DIVIDER)^playerPlatform.DEV_ATTRACT_PRICE_DELTA_EXPONENT
	else
		return 0
	end
end

function playerPlatform:calculateDevAttractiveness()
	self.devAttractiveness = math.max(playerPlatform.MINIMUM_DEV_ATTRACT, playerPlatform.BASE_DEV_ATTRACT - self.realDevDifficulty * playerPlatform.DEV_ATTRACT_DECREASE + self.realAttractiveness * playerPlatform.ATTRACT_TO_DEV_ATTRACT - self.devLicenseCost^playerPlatform.LICENSE_COST_TO_DEV_ATTRACTIVENESS - self:getDevAttractivenessPriceLoss())
	
	self:finalizeDevAttractiveness()
end

function playerPlatform:calculateMinimumDevTime()
	local total = 0
	
	for key, partList in ipairs(platformParts.registeredByPartType) do
		local least = math.huge
		
		for key, data in ipairs(partList) do
			least = math.min(least, data:getDevTime())
		end
		
		total = total + least
	end
	
	playerPlatform.MINIMUM_DEV_TIME = math.floor(total / timeline.DAYS_IN_MONTH)
end

function playerPlatform:setupID()
	self.platformID = playerPlatform.BASE_PLATFORM_ID .. studio:getTotalPlatformCount() + 1
end

function playerPlatform:calculateMinimumWork()
	local work = 0
	local partDatas = platformParts.registeredByID
	local partEnum = platformParts.TYPES
	local parts = self.parts
	
	for key, typeId in ipairs(platformParts.TYPES_LIST) do
		local enum = partEnum[typeId]
		
		work = work + partDatas[parts[enum]]:getDevTime()
	end
	
	self.minimumWork = work
end

function playerPlatform:calculateStats(everything)
	local attr, maxScale, devDiff, work, cost = 0, 0, 0, 0, 0
	local partDatas = platformParts.registeredByID
	local partEnum = platformParts.TYPES
	local parts = self.parts
	local levels = self.partLevels
	
	for key, typeId in ipairs(platformParts.TYPES_LIST) do
		local enum = partEnum[typeId]
		local data = partDatas[parts[enum]]
		
		attr = attr + data:getAttractiveness()
		maxScale = maxScale + data:getGameScaleChange(levels and levels[enum])
		devDiff = devDiff + data:getDevDifficultyChange()
		
		if everything then
			work = work + data:getDevTime()
			cost = cost + data:getPrice() * self.partCostMult[enum]
		end
	end
	
	self.baseAttractiveness = attr
	self.maxProjectScale = maxScale
	self.devDifficulty = devDiff
	
	if everything then
		self.minimumWork = work
		self.manufactureCost = cost
	end
end

function playerPlatform:calculateManufacturingCost()
	local cost = 0
	local partDatas = platformParts.registeredByID
	local partEnum = platformParts.TYPES
	local parts = self.parts
	
	for key, typeId in ipairs(platformParts.TYPES_LIST) do
		local enum = partEnum[typeId]
		local data = partDatas[parts[enum]]
		
		cost = cost + data:getPrice() * self.partCostMult[enum]
	end
	
	self.manufactureCost = math.round(cost)
end

function playerPlatform:setDevTime(time)
	self.devTime = time
	
	events:fire(playerPlatform.EVENTS.DEV_TIME_SET, self)
end

function playerPlatform:getDevTime()
	return self.devTime
end

function playerPlatform:getDevCost()
	return self.devCost
end

function playerPlatform:getGamesByRating()
	return self.gamesByRating
end

function playerPlatform:beginWork()
	self:setupID()
	self:calculateStats(true)
	self:finalizeStats()
	
	self.devCost = self:calculateDevCost()
	self.activeRandomEvents = {}
	self.activeRandomEventMap = {}
	self.eventCooldown = {}
	self.eventAmount = {}
	self.pendingReleaseGames = {}
	self.inDevGames = {}
	self.partLevels = {}
	self.bufferedDevs = {}
	self.fundChange = {}
	self.fundChange[1] = {
		timeline:getMonth(),
		0
	}
	self.gamesByRating = {}
	
	self:calculateMaxGamesPerDev()
	platformShare:initPlatformAttractiveness(self.platformID)
	
	local partEnum = platformParts.TYPES
	local partsByID = platformParts.registeredByID
	
	for key, typeId in ipairs(platformParts.TYPES_LIST) do
		local enum = partEnum[typeId]
		local partID = self.parts[enum]
		local data = partsByID[partID]
		
		if data.progression then
			self.partLevels[enum] = data:getLevel()
		else
			self.partLevels[enum] = 1
		end
	end
	
	self.interest = 0
	self.newDevsMonth = 0
	self.licenseMoney = 0
	
	local taskObj = task.new("new_platform_task")
	
	taskObj:setFinishedWork(0)
	
	local devTime = self.devTime * playerPlatform.PLATFORM_DEV_TIME_MULTIPLIER
	
	taskObj:setRequiredWork(devTime)
	taskObj:setFirstStageWorkAmount(math.ceil(devTime * playerPlatform.FIRST_STAGE_DURATION))
	taskObj:setPlatform(self)
	taskObj:start()
	self:setupEventList()
	studio:addTask(taskObj)
	self:applyParts()
	self:initEventHandler()
	platformShare:referencePlatformID(self.platformID, self)
	events:fire(playerPlatform.EVENTS.BEGUN_WORK_ON_PLATFORM, self)
end

function playerPlatform:getMinimumWork()
	return self.minimumWork
end

function playerPlatform:getMinimumWorkMonths()
	return math.ceil(self.minimumWork / timeline.DAYS_IN_MONTH)
end

function playerPlatform:setCompletionValue(val)
	self.completionValue = val
	self.completionValueDelta = self.completionValue - self.minimumWork
	
	self:calculateRepairAffector()
end

function playerPlatform:getCompletionValue()
	return self.completionValue
end

function playerPlatform:getCompletionValueDelta()
	return self.completionValueDelta
end

function playerPlatform:addAdvertisementRounds(amt)
	self.advertRounds = self.advertRounds + amt
end

function playerPlatform:setGenreMatch(match)
	self.genreMatching = match
end

function playerPlatform:getGenreMatch()
	return self.genreMatching
end

function playerPlatform:calculateImpression()
	local delta = self.minimumWork - self.completionValue
	
	self.impressionResults = {}
	
	if delta > 0 then
		local change = delta / playerPlatform.COMPLETION_DELTA_DIVIDER * playerPlatform.COMPLETION_VALUE_DELTA_TO_IMPRESSION
		
		table.insert(self.impressionResults, {
			"incompletion",
			change
		})
		
		self.impression = 1 - change
	else
		self.impression = 1
	end
	
	local minInterest = self.cost * playerPlatform.INTEREST_PER_MANUFACTURE_COST
	local delta = minInterest - self.interest
	
	if delta > 0 then
		local change = delta / playerPlatform.INTEREST_DELTA_PENALTY_DIVIDER
		
		table.insert(self.impressionResults, {
			"lack_of_interest",
			change
		})
		
		self.impression = self.impression - change
	end
	
	local gameCount = #self.activeGames + #self.games
	
	if gameCount == 0 then
		table.insert(self.impressionResults, {
			"lack_of_games",
			playerPlatform.IMPRESSION_GAME_MAX_PENALTY
		})
		
		self.impression = self.impression - playerPlatform.IMPRESSION_GAME_MAX_PENALTY
	else
		local gameDelta = self.realAttractiveness / playerPlatform.ATTRACTIVENESS_TO_LAUNCH_GAME - gameCount
		
		if gameDelta > 0 then
			local change = math.min((1 + gameDelta)^playerPlatform.IMPRESSION_LOSS_PER_GAME_PENALTY_EXPONENT / playerPlatform.IMPRESSION_GAME_MAX_PENALTY, playerPlatform.IMPRESSION_GAME_MAX_PENALTY)
			
			table.insert(self.impressionResults, {
				"lack_of_games",
				change
			})
			
			self.impression = self.impression - change
		end
	end
	
	self.impression = math.max(playerPlatform.IMPRESSION_MIN, self.impression)
end

playerPlatform.IMPRESSION_RESULT_TEXT = {
	{
		value = 1,
		text = _T("PLATFORM_IMPRESSION_FLAWLESS", "Flawless"),
		lineColor = game.UI_COLORS.GREEN
	},
	{
		value = 0.9,
		text = _T("PLATFORM_IMPRESSION_GREAT", "Great"),
		lineColor = game.UI_COLORS.GREEN
	},
	{
		value = 0.7,
		text = _T("PLATFORM_IMPRESSION_GOOD", "Good"),
		lineColor = game.UI_COLORS.GREEN
	},
	{
		value = 0.5,
		text = _T("PLATFORM_IMPRESSION_OK", "OK"),
		lineColor = game.UI_COLORS.IMPORTANT_1
	},
	{
		value = 0.3,
		text = _T("PLATFORM_IMPRESSION_BAD", "Bad"),
		lineColor = game.UI_COLORS.RED,
		textColor = game.UI_COLORS.RED
	},
	{
		value = 0.15,
		text = _T("PLATFORM_IMPRESSION_AWFUL", "Awful"),
		lineColor = game.UI_COLORS.RED,
		textColor = game.UI_COLORS.RED
	}
}

function playerPlatform:createImpressionPopup()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLATFORM_IMPRESSION_RESULT_TITLE", "Platform First Impression"))
	popup:setText(_format(_T("PLATFORM_IMPRESSION_RESULT_DESC", "Enough time has passed to gauge the first impression that the release of the 'PLATFORM' console has left on people."), "PLATFORM", self.name))
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	
	local byID = playerPlatform.IMPRESSION_FORMATTERS_BY_ID
	local rawW = popup.w - _S(20)
	local wrapWidth = popup.rawW - 20
	
	for key, data in ipairs(self.impressionResults) do
		byID[data[1]]:addToPopup(extra, wrapWidth, rawW, data[2])
	end
	
	local lowest, mostFit = -math.huge
	local impr = self.impression
	
	for key, data in ipairs(playerPlatform.IMPRESSION_RESULT_TEXT) do
		local val = data.value
		
		if val <= impr and lowest < val then
			lowest = val
			mostFit = data
		end
	end
	
	mostFit = mostFit or playerPlatform.IMPRESSION_RESULT_TEXT[#playerPlatform.IMPRESSION_RESULT_TEXT]
	
	extra:addSpaceToNextText(15)
	extra:addTextLine(rawW, mostFit.lineColor, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("PLATFORM_LAUNCH_IMPRESSION_LAYOUT", "Overall platform launch impression: IMPRESS"), "IMPRESS", mostFit.text), "bh20", mostFit.textColor, 0, wrapWidth)
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
end

function playerPlatform:getImpressionResults()
	return self.impressionResults, self.impression
end

function playerPlatform:calculateRepairAffector()
	local val = playerPlatform.BASE_REPAIRS
	local delta = (self.completionValue - self.minimumWork) / timeline.DAYS_IN_MONTH
	
	if delta > 0 then
		val = math.max(playerPlatform.MIN_REPAIRS, val - playerPlatform.REPAIRS_REDUCTION_PER_MONTH * delta)
	elseif delta < 0 then
		val = math.min(playerPlatform.MAX_REPAIRS, val + playerPlatform.REPAIRS_PER_MONTH * math.abs(delta))
	end
	
	self.repairRangeMultiplier = val
end

function playerPlatform:getManufacturingCost()
	return self.realManufactureCost
end

function playerPlatform:getDevelopmentDifficulty()
	return self.realDevDifficulty
end

function playerPlatform:calculateDevCost()
	local finalCost = playerPlatform.MANUFACTURING_COST_BASE_MONTHLY_FEE
	local partCost = 0
	local partEnum = platformParts.TYPES
	local partDatas = platformParts.registeredByID
	
	for key, typeId in ipairs(platformParts.TYPES_LIST) do
		local enum = partEnum[typeId]
		local data = partDatas[self.parts[enum]]
		
		partCost = partCost + data:getPrice() * data:getDevCostMult()
	end
	
	if self.specialist then
		local data = platformParts.registeredSpecialistsByID[self.specialist]
		
		finalCost = finalCost + data:getCost()
	end
	
	finalCost = finalCost + partCost * playerPlatform.MANUFACTURING_COST_TO_DEV_COST
	
	return finalCost
end

function playerPlatform:setPartID(partType, id)
	local prevPart = self.parts[partType]
	local byID = platformParts.registeredByID
	
	if prevPart then
		local data = byID[prevPart]
		
		self.baseAttractiveness = self.baseAttractiveness - data:getAttractiveness()
		self.maxProjectScale = self.maxProjectScale - data:getGameScaleChange()
		self.devDifficulty = self.devDifficulty - data:getDevDifficultyChange()
		self.minimumWork = self.minimumWork - data:getDevTime()
		self.manufactureCost = self.manufactureCost - data:getPrice()
	end
	
	self.parts[partType] = id
	
	local data = byID[id]
	
	self.baseAttractiveness = self.baseAttractiveness + data:getAttractiveness()
	self.maxProjectScale = self.maxProjectScale + data:getGameScaleChange()
	self.devDifficulty = self.devDifficulty + data:getDevDifficultyChange()
	self.minimumWork = self.minimumWork + data:getDevTime()
	self.manufactureCost = self.manufactureCost + data:getPrice()
	
	self:finalizeStats()
	events:fire(playerPlatform.EVENTS.PART_SET, id)
end

function playerPlatform:getPartID(partType)
	return self.parts[partType]
end

function playerPlatform:setSpecialist(spec)
	if self.specialist then
		local data = platformParts.registeredSpecialistsByID[self.specialist]
		
		data:removeAffectors(self)
	end
	
	self.specialist = spec
	
	self:calculateStats(true)
	
	if spec then
		local data = platformParts.registeredSpecialistsByID[spec]
		
		data:applyAffectors(self)
	end
	
	self:finalizeStats()
	events:fire(playerPlatform.EVENTS.SPECIALIST_SET, spec)
end

function playerPlatform:getSpecialist()
	return self.specialist
end

function playerPlatform:save()
	local saved = playerPlatform.baseClass.save(self)
	
	saved.parts = self.parts
	saved.name = self.name
	saved.evaluatingPriceChange = self.evaluatingPriceChange
	saved.fundChange = self.fundChange
	saved.completionValue = self.completionValue
	saved.devTime = self.devTime
	saved.specialist = self.specialist
	saved.saleData = self.saleData
	saved.manufactureExpenses = self.manufactureExpenses
	saved.totalGamesReleased = self.totalGamesReleased
	saved.moneyMade = self.moneyMade
	saved.moneySpent = self.moneySpent
	saved.sales = self.sales
	saved.finished = self.finished
	saved.cost = self.cost
	saved.devLicenseCost = self.devLicenseCost
	saved.currentSaleIndex = self.currentSaleIndex
	saved.devStage = self.devStage
	saved.developers = self.developers
	saved.inDevGames = self.inDevGames
	saved.activeGames = self.activeGames
	saved.devSearchFinished = self.devSearchFinished
	saved.platformID = self.platformID
	saved.released = self.released
	saved.gameMoney = self.gameMoney
	saved.gameMoneyMonth = self.gameMoneyMonth
	saved.repairedPlatforms = self.repairedPlatforms
	saved.life = self.life
	saved.interest = self.interest
	saved.impression = self.impression
	saved.eventCooldown = self.eventCooldown
	saved.eventAmount = self.eventAmount
	saved.firmwareUpdate = self.firmwareUpdate
	saved.devsSearched = self.devsSearched
	saved.repairs = self.repairs
	saved.repairExpenses = self.repairExpenses
	saved.manufacturingExpenses = self.manufacturingExpenses
	saved.unitSales = self.unitSales
	saved.devCosts = self.devCosts
	saved.advertRounds = self.advertRounds
	saved.advertInterest = self.advertInterest
	saved.pendingReleaseGames = self.pendingReleaseGames
	saved.lastDevSearchCost = self.lastDevSearchCost
	saved.mostDevsFound = self.mostDevsFound
	saved.impressionResults = self.impressionResults
	saved.initialAdvertDuration = self.initialAdvertDuration
	saved.advertCost = self.advertCost
	saved.releaseDate = self.releaseDate
	saved.newDevsMonth = self.newDevsMonth
	saved.licenseMoney = self.licenseMoney
	saved.supportDrop = self.supportDrop
	saved.discontinued = self.discontinued
	saved.supportDropTime = self.supportDropTime
	saved.partLevels = self.partLevels
	saved.bufferedDevs = self.bufferedDevs
	saved.releaseCost = self.releaseCost
	saved.evaluatedCost = self.evaluatedCost
	saved.temporaryAttractiveness = self.temporaryAttractiveness
	saved.tempAttractLoss = self.tempAttractLoss
	saved.caseDisplay = self.caseDisplay
	saved.happiness = self.happiness
	saved.production = self.production
	saved.support = self.support
	saved.ignoreSupport = self.ignoreSupport
	saved.ignoreProduction = self.ignoreProduction
	saved.weekSales = self.weekSales
	saved.monthSales = self.monthSales
	saved.potentialSales = self.potentialSales
	saved.salePool = self.salePool
	saved.overallSaleMult = self.overallSaleMult
	saved.repairsWeek = self.repairsWeek
	saved.productionBother = self.productionBother
	saved.supportBother = self.supportBother
	saved.gamesByRating = self.gamesByRating
	
	if self.activeRandomEvents and #self.activeRandomEvents > 0 then
		saved.activeRandomEvents = {}
		
		for key, data in ipairs(self.activeRandomEvents) do
			saved.activeRandomEvents[#saved.activeRandomEvents + 1] = data:save()
		end
	end
	
	saved.platformAttractivenessMods = self.platformAttractivenessMods
	saved.maxScaleMods = self.maxScaleMods
	saved.devAttractMods = self.devAttractMods
	saved.priceMods = self.priceMods
	
	return saved
end

function playerPlatform:load(data)
	playerPlatform.baseClass.load(self, data)
	
	self.parts = data.parts
	self.fundChange = data.fundChange
	self.evaluatingPriceChange = data.evaluatingPriceChange or self.evaluatingPriceChange
	self.name = data.name or self.name
	self.completionValue = data.completionValue
	self.devTime = data.devTime
	self.saleData = data.saleData
	self.manufactureExpenses = data.manufactureExpenses
	self.totalGamesReleased = data.totalGamesReleased or self.totalGamesReleased
	self.moneyMade = data.moneyMade or self.moneyMade
	self.moneySpent = data.moneySpent or self.moneySpent
	self.sales = data.sales or self.sales
	self.finished = data.finished
	self.cost = data.cost or self.cost
	self.devLicenseCost = data.devLicenseCost or self.devLicenseCost
	self.currentSaleIndex = data.currentSaleIndex
	self.devStage = data.devStage or self.devStage
	self.developers = data.developers or self.developers
	self.inDevGames = data.inDevGames or {}
	self.activeGames = data.activeGames
	self.devSearchFinished = data.devSearchFinished
	self.platformID = data.platformID
	self.released = data.released
	self.gameMoney = data.gameMoney
	self.gameMoneyMonth = data.gameMoneyMonth
	self.repairedPlatforms = data.repairedPlatforms
	self.life = data.life
	self.interest = data.interest or self.interest
	self.impression = data.impression or 1
	self.eventCooldown = data.eventCooldown or {}
	self.eventAmount = data.eventAmount or {}
	self.firmwareUpdate = data.firmwareUpdate
	self.devsSearched = data.devsSearched
	self.repairs = data.repairs or self.repairs
	self.repairExpenses = data.repairExpenses or self.repairExpenses
	self.manufacturingExpenses = data.manufacturingExpenses or self.manufacturingExpenses
	self.unitSales = data.unitSales or self.unitSales
	self.devCosts = data.devCosts or self.devCosts
	self.advertRounds = data.advertRounds or self.advertRounds
	self.advertInterest = data.advertInterest or self.advertInterest
	self.pendingReleaseGames = data.pendingReleaseGames or {}
	self.lastDevSearchCost = data.lastDevSearchCost
	self.mostDevsFound = data.mostDevsFound
	self.impressionResults = data.impressionResults
	self.initialAdvertDuration = data.initialAdvertDuration or 0
	self.advertCost = data.advertCost or 0
	self.releaseDate = data.releaseDate
	self.newDevsMonth = data.newDevsMonth or 0
	self.licenseMoney = data.licenseMoney or 0
	self.supportDrop = data.supportDrop
	self.discontinued = data.discontinued
	self.supportDropTime = data.supportDropTime
	self.partLevels = data.partLevels
	self.bufferedDevs = data.bufferedDevs
	self.releaseCost = data.releaseCost or data.cost
	self.evaluatedCost = data.evaluatedCost
	self.temporaryAttractiveness = data.temporaryAttractiveness or 0
	self.tempAttractLoss = data.tempAttractLoss or 0
	self.caseDisplay = data.caseDisplay or platformParts.registeredCases[1].id
	self.happiness = data.happiness or self.happiness
	self.production = data.production or self.production
	self.support = data.support or self.support
	self.ignoreSupport = data.ignoreSupport or self.ignoreSupport
	self.ignoreProduction = data.ignoreProduction or self.ignoreProduction
	self.weekSales = data.weekSales or self.weekSales
	self.monthSales = data.monthSales or self.monthSales
	self.potentialSales = data.potentialSales or self.potentialSales
	self.salePool = data.salePool or self.salePool
	self.overallSaleMult = data.overallSaleMult or self.overallSaleMult
	self.repairsWeek = data.repairsWeek or self.repairsWeek
	self.productionBother = data.productionBother or self.productionBother
	self.supportBother = data.supportBother or self.supportBother
	self.gamesByRating = data.gamesByRating
	
	self:setupEventList()
	
	local rel = self.released
	local disc = self.discontinued
	
	if not disc then
		if not rel then
			self:initEventHandler()
		end
		
		self:updateSupportValue()
		self:updateProductionValue()
		self:updateLastGameDev()
		
		if not self.finished then
			self.devCost = self:calculateDevCost()
		else
			self.completionValueDelta = self.completionValue - self.minimumWork
		end
		
		self.activeRandomEvents = {}
		self.activeRandomEventMap = {}
		
		if data.activeRandomEvents then
			for key, data in ipairs(data.activeRandomEvents) do
				self.activeRandomEvents[#self.activeRandomEvents + 1] = playerPlatform.loadRandomEvent(data, self)
				self.activeRandomEventMap[data.id] = true
			end
		end
	end
	
	self:applyParts()
	
	self.platformAttractivenessMods = data.platformAttractivenessMods or self.platformAttractivenessMods
	self.maxScaleMods = data.maxScaleMods or self.maxScaleMods
	self.devAttractMods = data.devAttractMods or self.devAttractMods
	self.priceMods = data.priceMods or self.priceMods
	
	self:applyMultiplier(data.platformAttractivenessMods, "platformAttractivenessMult")
	self:applyMultiplier(data.maxScaleMods, "maxScaleMult")
	self:applyMultiplier(data.devAttractMods, "devAttractivenessMod", 0)
	self:applyMultiplier(data.priceMods, "priceMult")
	self:finalizeMaxGameScale()
	
	if not disc then
		self:calculateMinimumWork()
	end
	
	if data.specialist then
		self:setSpecialist(data.specialist)
	else
		self:calculateStats(true)
		self:finalizeStats()
	end
	
	self:calculateMaxGamesPerDev()
	
	if not disc then
		self:finalizeManufacturingCost()
		
		if rel then
			studio:addActivePlayerPlatform(self)
			self:createSaleDisplay()
			self:calculateLifeSaleAffector()
		end
		
		self.maxDevs = self:calculateMaxDevelopers()
		
		self:setupGameRatingRange()
		
		if self.finished then
			self:calculateRepairAffector()
		end
	end
end

function playerPlatform:applyMultiplier(list, varName, baseVal)
	local val = baseVal or 1
	
	for id, value in pairs(list) do
		val = val + value
	end
	
	self[varName] = val
end

function playerPlatform:getDefaultAttractiveness()
	return self.realAttractiveness
end

function playerPlatform:getDisplayQuad()
	return platformParts.registeredCasesByID[self.caseDisplay].quad
end

function playerPlatform:getManufacturerID()
	return nil
end

function playerPlatform:getMaxProjectScale()
	return self.realMaxProjectScale
end

function playerPlatform:getStartingFakeGames()
	return 10
end

function playerPlatform:getID()
	return self.platformID
end

function playerPlatform:getReleaseDate()
	return self.releaseDate
end

function playerPlatform:getPlatformAttractiveness()
	return self.baseGameAttractiveness + self.temporaryAttractiveness
end

function playerPlatform:getFrustrationMultiplier()
	return 1
end

require("game/platform/player_platform_events")
require("game/platform/firmware_update_task")
require("game/developer/conversations/player_platforms")
