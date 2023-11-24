local logicPiece = {}

logicPiece.id = gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID
logicPiece.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_MONTH,
	gameProject.EVENTS.COPIES_SOLD,
	studio.EVENTS.ROOMS_UPDATED,
	serverRenting.EVENTS.CHANGED_RENTED_SERVERS,
	serverRenting.EVENTS.CHANGED_CUSTOMER_SUPPORT,
	studio.EVENTS.UPDATE_MMO_HAPPINESS
}
logicPiece.EVENTS = {
	PROGRESSED = events:new(),
	HAPPINESS_CHANGED = events:new(),
	SUBSCRIBERS_CHANGED = events:new(),
	FEE_CHANGED = events:new(),
	OVER = events:new(),
	DDOS_STARTED = events:new(),
	DDOS_ENDED = events:new()
}
logicPiece.RANDOM_EVENTS = {}
logicPiece.RANDOM_EVENTS_BY_ID = {}
logicPiece.CONTENT_MULTIPLIER = 0.45
logicPiece.BASE_SERVER_COST = 20000
logicPiece.SERVER_COST_PER_COMPLEXITY = 0.9
logicPiece.SANE_SUBSCRIPTION_FEE = 14.99
logicPiece.FEE_PENALTY_EXPONENT = 2
logicPiece.FEE_PENALTY_DIVIDER = 16
logicPiece.SUBSCRIPTION_FEE_BOOST_PRICE = 14.99
logicPiece.LONGEVITY_FEE_BOOST = 5
logicPiece.LONGEVITY_FEE_AFFECTOR = 0.1
logicPiece.BEST_PRICE_OFFSET = 5.49
logicPiece.SALES_DROP_MIN_FEE = 4.99
logicPiece.MAX_SUB_FEE_BEFORE_SALES_DROP = 14.99
logicPiece.MAX_SCALE_MULT = 0.75
logicPiece.MIN_SALE_MULT = 0.1
logicPiece.SCALE_TO_SALE_AFFECTOR_EXPONENT = math.log(4, 16)
logicPiece.SUBS_LOSS_AT_CONTENT_AMOUNT = 0.66
logicPiece.SUBS_LOSS_MULTIPLIER = 0.05
logicPiece.SUBS_LOSS_EXPONENT = 2
logicPiece.SUBS_LOSS_EXPONENT_CAP = 16
logicPiece.EXPANSION_CONTENT_MULTIPLIER = 0.5
logicPiece.EXPANSION_FACTOR_OF_PEAK_FOR_COODLOWN = 0.5
logicPiece.SUBS_REGAIN_PERCENTAGE = 0.07
logicPiece.SCALE_TO_EXTRA_EVALUATION = 5.5
logicPiece.EVALUATION_REGAIN_PER_WEEK = 0.1
logicPiece.MAX_EVALUATIONS = 2
logicPiece.PRICE_HAPPINESS_DIVIDER = 12
logicPiece.PRICE_HAPPINESS_EXPONENT = 2
logicPiece.MIN_RATING_FOR_EXTRA_COST = 7.5
logicPiece.EXTRA_PRICE_PER_RATING_DELTA = 3 / (review.maxRating - logicPiece.MIN_RATING_FOR_EXTRA_COST)
logicPiece.PRICE_HAPPINESS_LOSS_DIVIDER = 45
logicPiece.PRICE_HAPPINESS_LOSS_EXPONENT = 2
logicPiece.MINIMUM_HAPPINESS = 0.1
logicPiece.MAXIMUM_HAPPINESS = 1
logicPiece.HAPPINESS_REGAIN_RATE = 0.02
logicPiece.CAPACITY_EXCEED = 1.1
logicPiece.CAPACITY_EXCEED_MULT = 2
logicPiece.CAPACITY_EXCEED_EXPO = 2
logicPiece.CAPACITY_EXCEED_MULT_LOSS = 0.1
logicPiece.CAPACITY_EXCEED_EXPO_LOSS = 1
logicPiece.HAPPINESS_LOSS_NO_SERVERS = 0.1
logicPiece.FEEDBACK_COOLDOWN = {
	timeline.WEEKS_IN_MONTH * 2,
	timeline.WEEKS_IN_MONTH * 3
}
logicPiece.INITIAL_COOLDOWN = 2
logicPiece.SCALE_TO_CONTENT_EXPONENT = math.log(3, 19)
logicPiece.SUB_LOSS_BEFORE_DIALOGUE = 3
logicPiece.SUB_LOSS_DIALOGUE = "manager_subs_loss_content"
logicPiece.NOTIFIED_OF_LOSS_FACT = "notified_of_sub_loss"
logicPiece.MMO_DATABASE_CORRUPTION_DIALOGUE_FACT = "mmo_database_corrupt"
logicPiece.FIRST_TIME_UI_FACT = "mmo_ftue_ui"
logicPiece.SHUTDOWN_NO_PENALTY_CUTOFF = 2000
logicPiece.SHUTDOWN_REP_LOSS_PER_SUB = 0.16666666666666666
logicPiece.SHUTDOWN_NO_PENALTY_CUTOFF_ANNOUNCED = 10000
logicPiece.SHUTDOWN_REP_LOSS_PER_SUB_ANNOUNCED = 0.08333333333333333
logicPiece.SHUTDOWN_ANNOUNCE_LOSS_DELTA = 3
logicPiece.SHUTDOWN_ANNOUNCE_LONGEVITY_MULT = 4
logicPiece.OVERALL_LONGEVITY = timeline.DAYS_IN_YEAR * 10
logicPiece.OVERALL_LONGEVITY_RESUB_PENALTY = 0.5
logicPiece.LONGEVITY_SALE_PENALTY = 0.4
logicPiece.LONGEVITY_MIN_SALE_MULT = 0.1
logicPiece.MIN_RESUB_MULT = 0.01
logicPiece.HAPPINESS_MIN_SALES = 0.7
logicPiece.LONGEVITY_SHUTDOWN_PENALTY = 0.9
logicPiece.LONGEVITY_SHUTDOWN_PENALTY_MULT = 2
logicPiece.LONGEVITY_SHUTDOWN_PENALTY_BASE_LOSS = 3000
logicPiece.MINIMUM_SUBS_FOR_DDOS = 200000
logicPiece.PERCENTAGE_OF_SUBS_TO_DDOS = 1
logicPiece.DDOS_ID = "ddos"
logicPiece.DDOS_COOLDOWN = timeline.WEEKS_IN_MONTH * 9
logicPiece.DDOS_INTENSITY_RANGE = {
	6,
	9
}
logicPiece.DDOS_DURATION = {
	12,
	16
}
logicPiece.DDOS_CHANCE_ROLL_RANGE = 200
logicPiece.DDOS_CHANCE = 2
logicPiece.DDOS_CHANCE_INC_MINIMUM = 5
logicPiece.DDOS_CHANCE_INC_PER_RATING = 0.75
logicPiece.DDOS_DIALOGUE = "mmo_ddos_1"
logicPiece.DDOS_DIALOGUE_FACT = "mmo_ddos_dialogue"
logicPiece.DDOS_PREVENTION_AFFECTOR = 0.5
logicPiece.HAPPINESS_LOSS_TO_SUB_LOSS = 0.5
logicPiece.CUSTOMER_SUPPORT_HAPPINESS_LOSS_EXPONENT = math.log(10, 1.7)
logicPiece.CUSTOMER_SUPPORT_MAX_HAPPINESS_LOSS = 15
logicPiece.CUSTOMER_SUPPORT_TARGET_HAPPINESS_CHANGE = math.log(30, 1.4)
logicPiece.CUSTOMER_SUPPORT_BASE_HAPPINESS_DROP = 2
logicPiece.CUSTOMER_SUPPORT_LACK_HAPPINESS_DROP = 1
logicPiece.CUSTOMER_SUPPORT_LACK_HAPPINESS_SPEED = 0.1
logicPiece.MISC_ANALYSIS_COOLDOWN = timeline.DAYS_IN_MONTH * 4
logicPiece.ON_END_SERVER_USE_CALLBACKS = {}

function logicPiece.registerOnEndServerUseAffectorCallback(id, call)
	logicPiece.ON_END_SERVER_USE_CALLBACKS[id] = call
end

logicPiece.registerOnEndServerUseAffectorCallback(logicPiece.DDOS_ID, function(logic)
	logic:stopDDOS()
end)

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

function baseEventFuncs:onCloseDown(logic)
end

function baseEventFuncs:setupInfobox(infobox)
end

function baseEventFuncs:save()
	return {
		id = self.id
	}
end

function baseEventFuncs:load(data)
	self.id = data.id
end

function logicPiece.registerRandomEvent(data, inherit)
	if inherit then
		local inData = logicPiece.RANDOM_EVENTS_BY_ID[inherit]
		
		data.baseClass = inData
		
		setmetatable(data, inData)
	else
		data.baseClass = baseEventFuncs
		
		setmetatable(data, baseEventFuncs.mtindex)
	end
	
	table.insert(logicPiece.RANDOM_EVENTS, data)
	
	logicPiece.RANDOM_EVENTS_BY_ID[data.id] = data
	data.mtindex = {
		__index = data
	}
end

function logicPiece.initRandomEvent(id)
	local new = {}
	local data = logicPiece.RANDOM_EVENTS_BY_ID[id]
	
	setmetatable(new, data.mtindex)
	
	return new
end

function logicPiece.loadRandomEvent(data)
	local id = data.id
	local baseData = logicPiece.RANDOM_EVENTS_BY_ID[id]
	local loaded = logicPiece.initRandomEvent(id)
	
	loaded:load(data)
	
	return loaded
end

eventBoxText:registerNew({
	id = "mmo_customer_support_rush_over",
	getText = function(self, data)
		return _format(_T("CUSTOMER_SUPPORT_RUSH_OVER", "Customer support rush for 'GAME' is over."), "GAME", data:getName())
	end,
	saveData = function(self, data)
		return data:getUniqueID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getGameByUniqueID(data)
	end
})

local databaseCorruption = {
	addToList = true,
	occurChancePerComplexity = 0.125,
	occurChance = 0.5,
	maxChance = 2,
	reoccurChanceDivider = 4,
	minSubscribers = 300000,
	customerSupportUseFadePerWeek = 0.01,
	happinessLoss = 1.25,
	id = "database_corruption",
	percentageOfSubsToLose = {
		0.15,
		0.25
	},
	cooldown = timeline.DAYS_IN_MONTH * 6,
	lifetimeRequirement = timeline.DAYS_IN_MONTH * 3,
	subsToExtraCustomerSupportLoad = {
		1.5,
		2.5
	},
	canStart = function(self, logic)
		return logic:getSubscribers() >= self.minSubscribers and math.random() * 100 <= math.min(self.maxChance, self.occurChance + self.occurChancePerComplexity * logic:getServerComplexity()) / (1 + logic:getEventOccurTimes(id) * self.reoccurChanceDivider)
	end,
	onCloseDown = function(self, logic)
		if self.customerSupportUse > 0 then
			studio:changeCustomerSupportUse(-self.customerSupportUse)
		end
	end,
	setupInfobox = function(self, infobox, wrapWidth, lineWidth)
		infobox:addSpaceToNextText(4)
		infobox:addTextLine(lineWidth, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		infobox:addText(_T("MMO_CUSTOMER_SUPPORT_RUSH", "Customer support rush"), "bh20", nil, 2, wrapWidth, "exclamation_point_red", 24, 24)
	end,
	onNewWeek = function(self, logic)
		local old = self.customerSupportUse
		
		self.customerSupportUse = math.max(0, math.floor(self.customerSupportUse - self.customerSupportUsePeak * self.customerSupportUseFadePerWeek * self.weeksPassed))
		
		local delta = self.customerSupportUse - old
		
		studio:changeCustomerSupportUse(delta)
		
		self.weeksPassed = self.weeksPassed + 1
		
		if self.customerSupportUse <= 0 then
			logic:stopRandomEvent(self)
			game.addToEventBox("mmo_customer_support_rush_over", logic:getProject(), 4, nil, "exclamation_point_red")
		end
	end,
	occur = function(self, logic)
		local subLoss = self.percentageOfSubsToLose
		local rolled = math.randomf(subLoss[1], subLoss[2])
		local delta = (rolled - subLoss[1]) / (subLoss[2] - subLoss[1])
		local custUse = self.subsToExtraCustomerSupportLoad
		local min = custUse[1]
		
		self.customerSupportUsePeak = math.floor(min + (custUse[2] - min) * delta * logic:getSubscribers())
		self.customerSupportUse = self.customerSupportUsePeak
		self.weeksPassed = 0
		
		local lostSubs = math.round(logic:getSubscribers() * rolled)
		local lostHap = math.round(self.happinessLoss * rolled, 2)
		local projObj = logic:getProject()
		
		if not studio:getFact(logicPiece.MMO_DATABASE_CORRUPTION_DIALOGUE_FACT) and studio:getEmployeeCountByRole("software_engineer") > 0 then
			for key, dev in ipairs(studio:getHiredDevelopers()) do
				if dev:getRole() == "software_engineer" and dev:isAvailable() then
					local object = dialogueHandler:addDialogue("mmo_database_corruption_1", nil, dev)
					
					object:setFact("game", projObj)
					object:setFact("subs", lostSubs)
					studio:setFact(logicPiece.MMO_DATABASE_CORRUPTION_DIALOGUE_FACT, true)
					
					break
				end
			end
		end
		
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("MMO_DATABASE_CORRUPTION_TITLE", "Database Corruption"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("MMO_DATABASE_CORRUPTION", "The server database of the 'GAME' MMO has become corrupt, erasing and setting back the progress of our players. This has left a sizeable amount of people upset."), "GAME", projObj:getName()))
		popup:setShowSound("bad_jingle")
		popup:hideCloseButton()
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("MMO_DATABASE_CORRUPTION_SUB_LOSS", "AMOUNT of people have unsubscribed."), "AMOUNT", string.comma(lostSubs)), "bh20", nil, 0, popup.rawW - 20, "exclamation_point", 22, 22)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("MMO_HAPPINESS_DECREASE", "The players are now CHANGE% less happy."), "CHANGE", math.round(lostHap * 100)), "bh20", nil, 0, popup.rawW - 20, "exclamation_point", 22, 22)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		logic:changeSubscribers(-lostSubs, true)
		logic:changeHappiness(-lostHap)
		studio:changeCustomerSupportUse(self.customerSupportUse)
		logic:setEventCooldown(self.id, timeline.curTime + self.cooldown)
	end
}

function databaseCorruption:save()
	local saved = self.baseClass.save(self)
	
	saved.customerSupportUse = self.customerSupportUse
	saved.customerSupportUsePeak = self.customerSupportUsePeak
	saved.weeksPassed = self.weeksPassed
	
	return saved
end

function databaseCorruption:load(data)
	databaseCorruption.baseClass.load(self, data)
	
	self.customerSupportUse = data.customerSupportUse
	self.customerSupportUsePeak = data.customerSupportUsePeak
	self.weeksPassed = data.weeksPassed
	
	studio:changeCustomerSupportUse(self.customerSupportUse)
end

logicPiece.registerRandomEvent(databaseCorruption)

function logicPiece:init()
	logicPiece.baseClass.init(self)
	
	self.subLossTimes = 0
	self.happiness = 1
	self.purchases = 0
	self.moneyMade = 0
	self.subChange = 0
	self.subscribers = 0
	self.subscriberPeak = 0
	self.serverUse = 0
	self.expansionContent = 0
	self.ddosCooldown = 0
	self.listIndex = 1
	self.longevity = 0
	self.serverUseAffector = 0
	self.purchaseSubChange = 0
	self.miscAnalysis = 0
	self.totalServerCosts = 0
	self.totalMoneyMade = 0
	self.serverCostData = {}
	self.serverUseAffectors = {}
	self.serverUseAffectorMap = {}
	self.activeRandomEvents = {}
	self.activeRandomEventMap = {}
	self.eventCooldown = {}
	self.eventAmount = {}
end

function logicPiece:getFinanceInfo()
	return self.totalMoneyMade, self.totalServerCosts
end

function logicPiece:getActiveRandomEvents()
	return self.activeRandomEvents
end

function logicPiece:setEventCooldown(id, time)
	self.eventCooldown[id] = time
end

function logicPiece:getEventCooldown(id)
	return self.eventCooldown[id] or 0
end

function logicPiece:getEventOccurTimes(id)
	return self.eventAmount[id] or 0
end

function logicPiece:startRandomEvent(data)
	local id = data.id
	local amount = self.eventAmount[id]
	
	if not amount then
		self.eventAmount[id] = 1
	else
		self.eventAmount[id] = amount + 1
	end
	
	if data.addToList then
		local inst = logicPiece.initRandomEvent(data.id)
		
		inst:prepareData()
		table.insert(self.activeRandomEvents, inst)
		
		self.activeRandomEventMap[id] = true
	end
	
	data:occur(self)
end

function logicPiece:stopRandomEvent(data)
	table.removeObject(self.activeRandomEvents, data)
	
	self.activeRandomEventMap[data.id] = nil
end

function logicPiece:setup(projObj)
	projObj.mmoLogic = self
	self.contentAmount = self:getContentChange(projObj)
	self.feedbackCooldown = logicPiece.INITIAL_COOLDOWN
	self.subscriberList = {}
	self.evaluatableTasks = {}
	self.longevity = logicPiece.OVERALL_LONGEVITY
	
	table.copyOver(projObj:getMMOTasks(), self.evaluatableTasks)
	
	self.evaluationsRemaining = 1 + math.floor(projObj:getScale() / logicPiece.SCALE_TO_EXTRA_EVALUATION)
	
	self:setSubscriptionFee(projObj:getFact(gameProject.MMO_SUBSCRIPTION_FEE_FACT))
	self:setProject(projObj)
	self:calculateSaleAffector()
	self:updateContentPeak()
end

function logicPiece:getServerCostData()
	return self.serverCostData
end

function logicPiece:addServerUseAffector(id, duration, change)
	local data = {
		id = id,
		duration = duration,
		change = change
	}
	
	table.insert(self.serverUseAffectors, data)
	studio:changeServerUse(data.change)
	
	self.serverUseAffectorMap[id] = data
	self.serverUseAffector = self.serverUseAffector + data.change
end

function logicPiece:removeServerUseAffector(data, index)
	local id = data.id
	
	if index then
		table.remove(self.serverUseAffectors, index)
	else
		table.removeObject(self.serverUseAffectors, data)
	end
	
	self.serverUseAffectorMap[id] = nil
	self.serverUseAffector = self.serverUseAffector - data.change
	
	studio:changeServerUse(-data.change)
	
	local callback = logicPiece.ON_END_SERVER_USE_CALLBACKS[id]
	
	if callback then
		callback(self)
	end
end

logicPiece.projectLink = nil

function logicPiece.preStartDDOSDialogue(dialogue)
	dialogue:setFact("game", logicPiece.projectLink)
	
	logicPiece.projectLink = nil
end

eventBoxText:registerNew({
	id = "ddos_started",
	getText = function(self, data)
		return _format(_T("DDOS_OF_GAME", "Game servers of 'GAME' are under a DDoS attack."), "GAME", data:getName())
	end,
	saveData = function(self, data)
		return data:getUniqueID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getGameByUniqueID(data)
	end
})

function logicPiece:getServerCostDisplayValue()
	local subs = self.subscribers
	
	return self:calculateServerCosts() / (self.fee * gameProject.SALE_POST_TAX_PERCENTAGE * subs) * subs
end

function logicPiece:startDDOS()
	self.ddos = true
	
	local dur, range = logicPiece.DDOS_DURATION, logicPiece.DDOS_INTENSITY_RANGE
	local duration = math.random(dur[1], dur[2])
	local ddosSubs = self.subscribers * logicPiece.PERCENTAGE_OF_SUBS_TO_DDOS * math.round(math.randomf(range[1], range[2]), 1)
	
	self.ddosCooldown = duration + logicPiece.DDOS_COOLDOWN
	
	self:addServerUseAffector(logicPiece.DDOS_ID, duration, ddosSubs)
	
	self.serverCostData[self.listIndex] = self:getServerCostDisplayValue()
	
	if studio:getEmployeeCountByRole("software_engineer") > 0 then
		if not studio:getFact(logicPiece.DDOS_DIALOGUE_FACT) then
			local soft = "software_engineer"
			
			for key, employee in ipairs(studio:getEmployees()) do
				if employee:getRole() == soft then
					logicPiece.projectLink = self.project
					
					dialogueHandler:addDialogue(logicPiece.DDOS_DIALOGUE, nil, employee, logicPiece.preStartDDOSDialogue)
					studio:setFact(logicPiece.DDOS_DIALOGUE_FACT, true)
					
					break
				end
			end
		else
			game.addToEventBox("ddos_started", self.project, 4, nil, "exclamation_point_red")
		end
	end
	
	events:fire(logicPiece.EVENTS.DDOS_STARTED, self.project)
end

eventBoxText:registerNew({
	id = "ddos_over",
	getText = function(self, data)
		return _format(_T("DDOS_OF_GAME_OVER", "DDoS of 'GAME' game servers is over."), "GAME", data:getName())
	end,
	saveData = function(self, data)
		return data:getUniqueID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getGameByUniqueID(data)
	end
})

function logicPiece:stopDDOS()
	self.ddos = false
	
	game.addToEventBox("ddos_over", self.project, 2, nil, "checkmark_dark_borders")
	
	self.serverCostData[self.listIndex] = self:getServerCostDisplayValue()
	
	events:fire(logicPiece.EVENTS.DDOS_ENDED, self.project)
end

function logicPiece:getDDOS()
	return self.ddos
end

function logicPiece:getHighestFee(projObj)
	local progressToMax = projObj:getScale() / (platformShare:getMaxGameScale() * logicPiece.MAX_SCALE_MULT)
	local maxFee = logicPiece.MAX_SUB_FEE_BEFORE_SALES_DROP
	local complex = projObj:getFact(gameProject.MMO_COMPLEXITY_FACT)
	
	complex = complex or select(2, projObj:countMMOValues())
	
	local complex = complex + logicPiece.BEST_PRICE_OFFSET
	
	return math.max(logicPiece.SALES_DROP_MIN_FEE, math.min(complex, progressToMax * maxFee))
end

function logicPiece:getBestFee(projObj)
	local fee = self:getHighestFee(projObj)
	local curHighest, curKey = 0, 0
	local pricePoints = gameProject.SUBSCRIPTION_PRICE_POINTS
	
	for key, otherFee in ipairs(pricePoints) do
		if otherFee <= fee and curHighest < otherFee then
			curHighest = otherFee
			curKey = key
		end
	end
	
	return pricePoints[math.min(curKey + 1, #pricePoints)], pricePoints[curKey]
end

function logicPiece:calculateSaleAffector(projObj)
	projObj = projObj or self.project
	
	if not projObj then
		return 
	end
	
	local mult = self:calculateScaleSaleAffector(projObj)
	
	projObj:setFact(gameProject.MMO_SALE_AFFECTOR, mult)
	
	projObj.mmoSaleAffector = mult
end

function logicPiece:getMiscAnalysisText(dialogueObject, gameObj)
	if timeline.curTime < self.miscAnalysis then
		return 
	end
	
	local results = {}
	local saleAff = self:calculateScaleSaleAffector(gameObj)
	
	if saleAff < 1 then
		local complex = self.complexity
		local pricePerPerson = complex * logicPiece.SERVER_COST_PER_COMPLEXITY
		local bestFee = self:getBestFee(gameObj)
		local baseText = _format(_T("MMO_SALE_SCALE_AFFECTOR", "People are complaining about the monthly subscription fee, they say it's too high compared to the game's scale. The current fee is $CURFEE, and they say it should be somewhere around $DESIREDFEE. Lowering it would drive sales of the game upwards."), "CURFEE", self.fee, "DESIREDFEE", bestFee)
		
		self.miscAnalysis = timeline.curTime + logicPiece.MISC_ANALYSIS_COOLDOWN
		
		if bestFee < pricePerPerson then
			self.miscAnalysis = timeline.curTime + logicPiece.MISC_ANALYSIS_COOLDOWN
			
			table.insert(results, {
				baseText,
				_T("MMO_SALE_SCALE_AFFECTOR_LOSS", "Keep in mind that, because of the complexity of our MMO game servers, lowering the subscription fee to what they're wishing for would leave us operating at a loss.")
			})
		else
			table.insert(results, {
				baseText
			})
		end
	end
	
	if self.serverHappinessAffector < 1 then
		table.insert(results, {
			_T("MMO_SERVER_USE_AFFECTOR", "Our game servers are overloaded, this results in issues ranging from lengthy log-in times, to laggy gameplay. If we want our players to be happy, we have to increase the capacity of our servers.")
		})
	end
	
	if self.customerSupportAffector > 0 then
		table.insert(results, {
			_T("MMO_CUSTOMER_SUPPORT_AFFECTOR", "Our customer support services are overloaded with work, this undoubtedly will leave our players less happy, as they can't go through all support tickets fast enough. How much depends on how overloaded it is. Increasing our customer support side of things would help.")
		})
	end
	
	if #results > 0 then
		return results[math.random(1, #results)]
	end
	
	return nil
end

function logicPiece:calculateScaleSaleAffector(projObj)
	local delta = self.fee - self:getHighestFee(projObj)
	local mult = 1
	
	if delta > 0 then
		mult = math.max(logicPiece.MIN_SALE_MULT, 1 / delta^logicPiece.SCALE_TO_SALE_AFFECTOR_EXPONENT)
	end
	
	return mult
end

function logicPiece:getHappinessSaleAffector()
end

function logicPiece:getRealScaleMultiplier(scale)
	return (1 + (scale - project.SCALE_MIN)^logicPiece.SCALE_TO_CONTENT_EXPONENT) * self.CONTENT_MULTIPLIER
end

function logicPiece:getEvaluatableTasks()
	return self.evaluatableTasks
end

function logicPiece:getContentChange(projObj)
	return projObj:getFact(gameProject.MMO_CONTENT_AMOUNT_FACT) * self:getRealScaleMultiplier(projObj:getScale())
end

function logicPiece:getSaleData()
	return self.subscribers, self.moneyMade, self.subChange
end

function logicPiece:getSubscriberList()
	return self.subscriberList
end

function logicPiece:getSubChange()
	return self.subChange
end

function logicPiece:getServerUseAffector()
	return self.serverUseAffector
end

function logicPiece:getSubscribers()
	return self.subscribers
end

function logicPiece:updateContentPeak(potentialPeak)
	if not self.contentPeak then
		self.contentPeak = self.contentAmount
	else
		self.contentPeak = math.max(self.contentPeak, self.contentAmount)
	end
	
	if potentialPeak and potentialPeak > self.contentPeak then
		self.contentPeak = potentialPeak
	end
end

function logicPiece:canLoad(data)
	return true
end

logicPiece.REP_LOSS_INCREASED_FEE = 0.02
logicPiece.REP_GAIN_DECREASED_FEE = 0.01

function logicPiece:changeHappiness(change)
	self.happiness = math.max(logicPiece.MINIMUM_HAPPINESS, math.min(logicPiece.MAXIMUM_HAPPINESS, self.happiness + change))
	
	events:fire(logicPiece.EVENTS.HAPPINESS_CHANGED, self.project)
end

function logicPiece:evaluateSubscriptionFeeChange()
	local priceDelta = self.fee - self.evaluateFee
	
	if priceDelta == 0 then
		self.evaluateFee = nil
		
		return 
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("MMO_SUBSCRIPTION_FEE_TITLE", "Subscription Fee"))
	
	local happinessChange, text
	
	if priceDelta < 0 then
		happinessChange = math.abs(priceDelta) * logicPiece.REP_GAIN_DECREASED_FEE
		self.happiness = math.min(logicPiece.MAXIMUM_HAPPINESS, self.happiness + happinessChange)
		text = _T("MMO_SUBSCRIPTION_FEE_HAPPY", "The subscribers of 'GAME' are happy with the lowered monthly subscription fee.")
	elseif priceDelta > 0 then
		happinessChange = priceDelta * logicPiece.REP_LOSS_INCREASED_FEE
		self.happiness = math.max(logicPiece.MINIMUM_HAPPINESS, self.happiness - happinessChange)
		text = _T("MMO_SUBSCRIPTION_FEE_UNHAPPY", "The subscribers of 'GAME' are not happy with the increased monthly subscription fee.")
	end
	
	popup:setText(_format(text, "GAME", self.project:getName()))
	
	local left, right, extra = popup:getDescboxes()
	
	if priceDelta < 0 then
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("MMO_HAPPINESS_INCREASE", "The players are now CHANGE% happier."), "CHANGE", math.round(happinessChange * 100, 1)), "bh20", nil, 0, popup.rawW - 20, "exclamation_point", 24, 24)
		popup:setShowSound("good_jingle")
	else
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("MMO_HAPPINESS_DECREASE", "The players are now CHANGE% less happy."), "CHANGE", math.round(happinessChange * 100, 1)), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 20, "exclamation_point_red", 24, 24)
		popup:setShowSound("bad_jingle")
	end
	
	popup:addOKButton("pix20")
	popup:hideCloseButton()
	popup:center()
	frameController:push(popup)
	events:fire(logicPiece.EVENTS.HAPPINESS_CHANGED, self.project)
	
	self.evaluateFee = nil
end

function logicPiece:getServerComplexity()
	return self.complexity
end

function logicPiece:getAttractiveness()
	return self.attractiveness
end

local data = logicPieces:getData("base_logic")

logicPiece.start = data.start

function logicPiece:setProject(projObj)
	projObj.mmoLogic = self
	self.project = projObj
	self.complexity = projObj:getFact(gameProject.MMO_COMPLEXITY_FACT)
	self.attractiveness = projObj:getFact(gameProject.MMO_ATTRACTIVENESS_FACT)
	
	if not self.finished then
		if self.loadSubscribers then
			self:changeSubscribers(self.loadSubscribers)
			
			self.loadSubscribers = nil
		end
		
		if self.loadFee then
			self:setSubscriptionFee(self.loadFee)
			
			self.loadFee = nil
		end
		
		if projObj:getOwner():isPlayer() then
			local subsDisplay = self:createSubFrame()
			
			game.addToProjectScroller(subsDisplay, projObj)
		end
		
		projObj.mmoSaleAffector = projObj:getFact(gameProject.MMO_SALE_AFFECTOR)
		
		self:calculateTargetHappiness()
		events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
	else
		self.fee = self.loadFee
		self.loadFee = nil
	end
end

function logicPiece:createSubFrame(skipButton)
	local subsDisplay = gui.create("MMOSubsDisplayFrame", nil, skipButton)
	
	subsDisplay:setLogicPiece(self)
	
	return subsDisplay
end

function logicPiece:onReleaseExpansionPack(expPack)
	self:clampContent()
	
	local contentIncrease = self:getContentChange(expPack)
	
	self:addContent(contentIncrease)
	
	if self.expansionContent >= self.contentPeak * logicPiece.EXPANSION_FACTOR_OF_PEAK_FOR_COODLOWN then
		expPack:setFact(gameProject.MMO_EXPANSION_PACK_COOLDOWN_FACT, true)
		
		local event = scheduledEvents:instantiateEvent("mmo_expansion_cooldown")
		
		event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
		event:setProject(self.project)
	end
	
	self.expansionContent = self.expansionContent + contentIncrease
end

function logicPiece:clampContent()
	self.contentAmount = math.max(self.contentAmount, 0)
end

function logicPiece:addContent(change)
	self.contentAmount = self.contentAmount + change
	
	self:updateContentPeak(change)
end

function logicPiece:getFee()
	return self.fee
end

function logicPiece:getServerUse()
	return self.serverUse + self.serverUseAffector
end

function logicPiece:isFeedbackCooldownOver()
	return not self.feedbackCooldown or self.feedbackCooldown <= 0
end

function logicPiece:canEvaluateFeedback()
	return self.evaluationsRemaining >= 1
end

function logicPiece:onFinishFeedback(success, genreID, taskID)
	if success then
		self.feedbackCooldown = math.random(logicPiece.FEEDBACK_COOLDOWN[1], logicPiece.FEEDBACK_COOLDOWN[2])
		self.evaluationsRemaining = self.evaluationsRemaining - 1
		
		gameProject.revealMMOMatch(taskID, genreID)
	end
end

function logicPiece:beginFeedbackAnalysis(manager)
	local newTask = task.new("feedback_analysis_task")
	
	newTask:setRequiredWork(newTask.DEFAULT_REQUIRED_WORK_AMOUNT)
	newTask:setProject(self.project)
	newTask:setWorkField("management")
	newTask:setAssignee(manager)
	newTask:setTimeToProgress(newTask.DEFAULT_TIME_TO_PROGRESS)
	manager:setTask(newTask)
end

function logicPiece:setSubscriptionFee(fee, popup)
	if not self.startingFee then
		self.startingFee = fee
		self.acceptedFee = fee
	end
	
	if self.fee and not self.evaluateFee and fee ~= self.fee then
		self.evaluateFee = self.fee
		
		local event = scheduledEvents:instantiateEvent("mmo_evaluate_sub_fee")
		
		event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
		event:setGame(self.project)
	end
	
	if popup then
		local prevFee = self.fee
		
		self.fee = fee
		
		if self.listIndex then
			self.serverCostData[self.listIndex] = self:getServerCostDisplayValue()
		end
		
		events:fire(logicPiece.EVENTS.FEE_CHANGED, self.project)
		
		if self.fee == self.startingFee then
			return 
		end
		
		local text
		
		if fee ~= prevFee then
			if prevFee < fee then
				text = _format(_T("SUBSCRIPTION_FEE_CHANGED_INCREASED", "You've increased the monthly subscription fee to $NEW_FEE, up from the previous $OLD_FEE.\n\nIncreasing the monthly subscription fee after release is generally not a good idea, since it can make existing subscribers unhappy."), "NEW_FEE", fee, "OLD_FEE", prevFee)
			elseif fee < self.startingFee then
				text = _format(_T("SUBSCRIPTION_FEE_CHANGED_DECREASED_BELOW_STARTING", "You've decreased the monthly subscription fee to $NEW_FEE, down from the previous $OLD_FEE\n\nDecreasing the fee below the starting point can have a positive effect on the happiness of your subscribers."), "NEW_FEE", fee, "OLD_FEE", prevFee)
			else
				text = _format(_T("SUBSCRIPTION_FEE_CHANGED_DECREASED", "You've decreased the monthly subscription fee to $NEW_FEE, down from the previous $OLD_FEE."), "NEW_FEE", fee, "OLD_FEE", prevFee)
			end
		end
		
		if text then
			local popup = gui.create("Popup")
			
			popup:setWidth(500)
			popup:setFont("pix24")
			popup:setTitle(_T("SUBSCRIPTION_FEE_CHANGED_TITLE", "Subscription Fee Changed"))
			popup:setTextFont("pix20")
			popup:setText(text)
			popup:addOKButton("pix20")
			popup:center()
			frameController:push(popup)
		end
	else
		self.fee = fee
		
		if self.listIndex then
			self.serverCostData[self.listIndex] = self:getServerCostDisplayValue()
		end
		
		events:fire(logicPiece.EVENTS.FEE_CHANGED, self.project)
	end
	
	self:calculateSaleAffector()
	self:calculateTargetHappiness()
end

logicPiece.MAX_PRICE_DIFFERENCE_FOR_ACCEPTANCE = 2.5

function logicPiece:calculateTargetHappiness()
	if not self.project then
		return 
	end
	
	self.priceHappinessAffector = 0
	self.serverHappinessAffector = 1
	self.customerSupportAffector = 0
	
	local owner = self.project:getOwner()
	
	if owner:getRealServerCapacity() == 0 then
		self.targetHappiness = logicPiece.MINIMUM_HAPPINESS
		self.happinessChange = logicPiece.HAPPINESS_LOSS_NO_SERVERS
		
		return 
	end
	
	local saneFee = logicPiece.SANE_SUBSCRIPTION_FEE
	local ratingDelta = self.project:getRealRating() - logicPiece.MIN_RATING_FOR_EXTRA_COST
	local ratingAffector = 0
	
	if ratingDelta > 0 then
		saneFee = saneFee + logicPiece.EXTRA_PRICE_PER_RATING_DELTA * ratingDelta
	end
	
	local hapChange = 0
	local targetHappiness = logicPiece.MAXIMUM_HAPPINESS
	local difference = self.fee - saneFee
	
	if self.fee - saneFee <= logicPiece.MAX_PRICE_DIFFERENCE_FOR_ACCEPTANCE or self.fee <= self.acceptedFee then
		self.acceptedFee = self.fee
		difference = 0
	end
	
	if difference > 0 then
		self.priceHappinessAffector = (difference / logicPiece.PRICE_HAPPINESS_DIVIDER)^logicPiece.PRICE_HAPPINESS_EXPONENT
		hapChange = hapChange + (difference / logicPiece.PRICE_HAPPINESS_LOSS_DIVIDER)^logicPiece.PRICE_HAPPINESS_LOSS_EXPONENT
		targetHappiness = logicPiece.MAXIMUM_HAPPINESS - self.priceHappinessAffector
	end
	
	local serverUse = owner:getServerUsePercentage()
	local excess = serverUse - logicPiece.CAPACITY_EXCEED
	
	if excess > 0 then
		local excessAffector = 1 - (excess * logicPiece.CAPACITY_EXCEED_MULT)^logicPiece.CAPACITY_EXCEED_EXPO
		
		self.serverHappinessAffector = excessAffector
		targetHappiness = targetHappiness * excessAffector
		hapChange = hapChange + (excess * logicPiece.CAPACITY_EXCEED_MULT_LOSS)^logicPiece.CAPACITY_EXCEED_EXPO_LOSS
	end
	
	if studio:getCustomerSupport() == 0 then
		targetHappiness = targetHappiness - logicPiece.CUSTOMER_SUPPORT_LACK_HAPPINESS_DROP
		hapChange = hapChange + logicPiece.CUSTOMER_SUPPORT_LACK_HAPPINESS_SPEED
		self.customerSupportAffector = logicPiece.CUSTOMER_SUPPORT_LACK_HAPPINESS_DROP
	else
		local delta = studio:getCustomerSupportDelta()
		
		if delta < 0 then
			local abs = math.abs(delta)
			local scalar = abs / self.subscribers
			local increased = 1 + scalar
			local happinessLoss = math.min(logicPiece.CUSTOMER_SUPPORT_MAX_HAPPINESS_LOSS, increased^logicPiece.CUSTOMER_SUPPORT_HAPPINESS_LOSS_EXPONENT) / 100
			
			hapChange = hapChange + happinessLoss
			
			local final = (logicPiece.CUSTOMER_SUPPORT_BASE_HAPPINESS_DROP + increased^logicPiece.CUSTOMER_SUPPORT_TARGET_HAPPINESS_CHANGE) / 100
			
			targetHappiness = targetHappiness - final
			self.customerSupportAffector = happinessLoss
		end
	end
	
	if hapChange == 0 then
		self.happinessChange = logicPiece.HAPPINESS_REGAIN_RATE
	else
		self.happinessChange = hapChange
	end
	
	self.targetHappiness = math.max(logicPiece.MINIMUM_HAPPINESS, targetHappiness)
end

function logicPiece:calculateServerCosts()
	return self.BASE_SERVER_COST + (self.serverUse + self.serverUseAffector) * logicPiece.SERVER_COST_PER_COMPLEXITY
end

function logicPiece:changeSubscribers(change, updateSubs)
	local oldUse = self.serverUse
	local oldSubs = self.subscribers
	
	self.subscribers = oldSubs + change
	self.subChange = self.subChange + change
	
	local use = self.subscribers * self.complexity
	
	self.serverUse = use
	
	local delta = use - oldUse
	
	if updateSubs then
		self.subscriberList[self.listIndex] = self.subscribers
		self.serverCostData[self.listIndex] = self:getServerCostDisplayValue()
	end
	
	studio:changeServerUse(delta)
	studio:changeCustomerSupportUse(self.subscribers - oldSubs)
	events:fire(logicPiece.EVENTS.SUBSCRIBERS_CHANGED, self.project)
end

function logicPiece:getProject()
	return self.project
end

function logicPiece:onRemoved()
	logicPiece.baseClass.onRemoved(self)
	studio:changeServerUse(-(self.serverUse + self.serverUseAffector))
	
	if self.project:getOwner():isPlayer() then
		events:fire(logicPiece.EVENTS.OVER, self.project)
	end
end

function logicPiece:setFeeCallback()
	self.tree.logicPiece:setSubscriptionFee(self.fee, true)
end

logicPiece.currentPriceText = {
	{
		font = "bh18",
		wrapWidth = 250,
		iconWidth = 20,
		iconHeight = 20,
		icon = "question_mark",
		text = _T("MMO_SUBSCRIPTION_CURRENT_FEE", "This is the current monthly subscription fee.")
	}
}

function logicPiece:changeFeeCallback()
	local comboBox = gui.create("ComboBox")
	
	comboBox:setAutoCloseTime(0.5)
	
	comboBox.logicPiece = self.logicPiece
	
	comboBox:setInteractionObject(self.theirObj)
	
	local curFee = self.logicPiece:getFee()
	
	for key, fee in ipairs(gameProject.SUBSCRIPTION_PRICE_POINTS) do
		local option = comboBox:addOption(0, 0, 100, 20, _format("$COST", "COST", fee), "pix20", logicPiece.setFeeCallback)
		
		if fee == curFee then
			option:highlight(true)
			option:setHoverText(logicPiece.currentPriceText)
		end
		
		option.fee = fee
	end
	
	local x, y = self.tree:getPos(true)
	
	comboBox:setPos(x + self.tree.w - comboBox.w, y)
end

function logicPiece.createNoManagersPopup()
	local popup = game.createPopup(500, _T("NO_MANAGERS_AVAILABLE_TITLE", "No Managers Available"), _T("MMO_CANT_ANALYZE_FEEDBACK", "Can't analyze feedback as you have no managers available for this action."), "pix24", "pix20")
	
	frameController:push(popup)
end

function logicPiece:feedbackAnalysisCallback()
	if studio:getEmployeeCountByRole("manager") == 0 then
		logicPiece.createNoManagersPopup()
		
		return 
	end
	
	local managers = studio:getManagers()
	local success = false
	
	for key, manager in ipairs(managers) do
		if manager:isAvailable() and manager:getWorkplace() then
			local taskObj = manager:getTask()
			
			if not taskObj or taskObj:canReassign(manager) then
				self.logicPiece:beginFeedbackAnalysis(manager)
				
				success = true
				
				break
			end
		end
	end
	
	if not success then
		logicPiece.createNoManagersPopup()
		
		return 
	end
	
	table.clearArray(managers)
end

function logicPiece:shutdownServersCallback()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("MMO_SHUTDOWN_SERVERS_TITLE", "Shutdown Servers?"))
	popup:setTextFont("pix20")
	popup:setText(_T("MMO_SHUTDOWN_SERVERS_DESCRIPTION", "Are you sure you want to shut down the MMO servers? There is no going back after this."))
	
	local left, right, extra = popup:getDescboxes()
	
	if not self.logicPiece:wasShutdownAnnounced() then
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_T("MMO_SHUTDOWN_NOT_ANNOUNCED", "You have not announced shutdown of servers. The shutdown of game servers will be a sudden disappointment."), "bh18", nil, 0, popup.rawW - 30, "exclamation_point_red", 22, 22)
	end
	
	popup:addButton("pix20", _T("MMO_SHUTDOWN_SERVERS", "Shutdown servers"), logicPiece.shutdownServersConfirmCallback).logicPiece = self.logicPiece
	
	if studio:getEmployeeCountByRole("manager") > 0 then
		local managers = studio:getManagers()
		local randomManager = managers[math.random(1, #managers)]
		local button = popup:addButton("pix20", _T("MMO_SHUTDOWN_CONSULT_WITH_MANAGER", "Consult with a manager"), logicPiece.consultWithManagerCallback)
		
		button.manager = randomManager
		button.logicPiece = self.logicPiece
	end
	
	popup:addButton("pix20", _T("CANCEL", "Cancel"))
	popup:center()
	frameController:push(popup)
end

function logicPiece:announceShutdownCallback()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("MMO_ANNOUNCE_SERVER_SHUTDOWN_TITLE", "Announce Server Shutdown?"))
	popup:setTextFont("pix20")
	popup:setText(_T("MMO_ANNOUNCE_SERVER_SHUTDOWN_DESCRIPTION", "Are you sure you want to announce a shutdown of servers to happen in the near future? If you do, players will begin unsubscribing much faster, and there will be no going back after this."))
	
	popup:addButton("pix20", _T("MMO_ANNOUNCE_SERVER_SHUTDOWN", "Announce server shutdown"), logicPiece.announceShutdownConfirmCallback).logicPiece = self.logicPiece
	
	popup:addButton("pix20", _T("CANCEL", "Cancel"))
	popup:center()
	frameController:push(popup)
end

function logicPiece:shutdownServersConfirmCallback()
	self.logicPiece:shutdownServers()
end

function logicPiece:announceShutdownConfirmCallback()
	self.logicPiece:announceShutdown()
end

function logicPiece:consultWithManagerCallback()
	local object = dialogueHandler:addDialogue("manager_mmo_shutdown_consult", nil, self.manager)
	
	object:setFact("mmo", self.logicPiece)
end

function logicPiece:isFinished()
	return self.finished
end

function logicPiece:onOpenProjectsMenu(frame)
	local subs = self:createSubFrame(true)
	
	subs:setWidth(220)
	subs:setData(self.project)
	subs:tieVisibilityTo(frame)
	
	local x, y = frame:getPos(true)
	
	subs:setPos(x + frame.w + _S(5), y)
end

function logicPiece:fillInteractionComboBox(comboBox)
	if not self.finished then
		local theirObj = comboBox:getObject()
		local option = comboBox:addOption(0, 0, 0, 24, _T("CHANGE_SUBSCRIPTION_FEE", "Change subscription fee"), "pix20", logicPiece.changeFeeCallback)
		
		option.logicPiece = self
		option.theirObj = theirObj
		
		if self.evaluationsRemaining > 0 then
			comboBox:addOption(0, 0, 0, 24, _T("START_FEEDBACK_ANALYSIS", "Start feedback analysis"), "pix20", logicPiece.feedbackAnalysisCallback).logicPiece = self
		end
		
		serverRenting:addMenuOption(comboBox, "pix20")
		
		if not self.shutdownAnnounced then
			comboBox:addOption(0, 0, 0, 24, _T("ANNOUNCE_SERVER_SHUTDOWN", "Announce server shutdown..."), "pix20", logicPiece.announceShutdownCallback).logicPiece = self
		end
		
		comboBox:addOption(0, 0, 0, 24, _T("SHUTDOWN_SERVERS", "Shutdown servers..."), "pix20", logicPiece.shutdownServersCallback).logicPiece = self
	end
end

function logicPiece:shutdownServers()
	local event = scheduledEvents:instantiateEvent("mmo_shutdown_penalty")
	
	event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
	event:setProject(self.project)
	event:setShutdownAnnounced(self.shutdownAnnounced)
	event:setSubsAtShutdown(self.subscribers)
	event:setLongevity(self.longevity)
	
	for key, data in ipairs(self.activeRandomEvents) do
		data:onCloseDown()
	end
	
	studio:changeCustomerSupportUse(-self.subscribers)
	self.project:onRanOutMarketTime()
	
	self.finished = true
	self.subscribers = 0
	
	self:remove()
end

function logicPiece:announceShutdown()
	self.shutdownAnnounced = true
	
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("MMO_SHUTDOWN_ANNOUNCED_TITLE", "Shutdown Announced"))
	popup:setTextFont("pix20")
	popup:setText(_T("MMO_SHUTDOWN_ANNOUNCED", "You've announced the shutdown of game servers. Players will now begin to unsubscribe quickly."))
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
end

function logicPiece:wasShutdownAnnounced()
	return self.shutdownAnnounced
end

function logicPiece:getHappiness()
	return self.happiness
end

function logicPiece:getMoneyMade()
	return self.moneyMade
end

function logicPiece:getLongevity()
	return self.longevity
end

function logicPiece:getLongevitySaleAffector()
	local happinessAff = 1 - (1 - self.happiness / self.MAXIMUM_HAPPINESS) * logicPiece.HAPPINESS_MIN_SALES
	local scalar = self.longevity / logicPiece.OVERALL_LONGEVITY
	
	if scalar <= logicPiece.LONGEVITY_SALE_PENALTY then
		return (1 - scalar / logicPiece.LONGEVITY_SALE_PENALTY) * logicPiece.LONGEVITY_MIN_SALE_MULT * happinessAff
	end
	
	return 1 * happinessAff
end

function logicPiece:getMonthlyFees()
	return self.fee * gameProject.SALE_POST_TAX_PERCENTAGE * self.subscribers
end

function logicPiece:loseHappiness(loss)
	self.happiness = math.max(logicPiece.MINIMUM_HAPPINESS, math.min(logicPiece.MAXIMUM_HAPPINESS, self.happiness - loss))
	
	events:fire(logicPiece.EVENTS.HAPPINESS_CHANGED, self.project)
end

logicPiece.OPINION_LOSS_CS = 1
logicPiece.OPINION_LOSS_SV = 1
logicPiece.OPINION_GAIN = 0.1

function logicPiece:handleEvent(event, gameProj, change)
	if event == timeline.EVENTS.NEW_WEEK then
		for key, data in ipairs(self.activeRandomEvents) do
			data:onNewWeek(self)
		end
		
		local hapLevel = self.happiness
		local targetHap = self.targetHappiness
		
		if hapLevel ~= targetHap then
			if hapLevel < targetHap then
				self.happiness = math.min(hapLevel + logicPiece.HAPPINESS_REGAIN_RATE, targetHap)
				
				self.project:getOwner():changeOpinion(logicPiece.OPINION_GAIN)
			else
				self.happiness = math.max(hapLevel - self.happinessChange, targetHap)
				
				local delta = hapLevel - self.happiness
				
				if delta > 0 then
					local own = self.project:getOwner()
					local opinionLoss = 0
					
					if studio:getServerUsePercentage() > 1 then
						opinionLoss = opinionLoss + logicPiece.OPINION_LOSS_SV
					end
					
					if studio:getCustomerSupportUsePercentage() > 1 then
						opinionLoss = opinionLoss + logicPiece.OPINION_LOSS_CS
					end
					
					own:changeOpinion(-opinionLoss)
					self:changeSubscribers(math.floor(-delta * logicPiece.HAPPINESS_LOSS_TO_SUB_LOSS * self.subscribers), true)
				end
			end
			
			events:fire(logicPiece.EVENTS.HAPPINESS_CHANGED, self.project)
		end
		
		if self.feedbackCooldown then
			self.feedbackCooldown = self.feedbackCooldown - 1
			
			if self.feedbackCooldown == 0 then
				self.feedbackCooldown = nil
			end
		end
		
		local evals = self.evaluationsRemaining
		
		if evals < logicPiece.MAX_EVALUATIONS then
			self.evaluationsRemaining = evals + logicPiece.EVALUATION_REGAIN_PER_WEEK
		end
		
		if #self.serverUseAffectors > 0 then
			local idx = 1
			
			for i = 1, #self.serverUseAffectors do
				local data = self.serverUseAffectors[idx]
				
				data.duration = data.duration - 1
				
				if data.duration <= 0 then
					self:removeServerUseAffector(data, idx)
				else
					idx = idx + 1
				end
			end
		end
		
		if not self.ddos and self.subscribers >= logicPiece.MINIMUM_SUBS_FOR_DDOS then
			if self.ddosCooldown <= 0 then
				local realChance = logicPiece.DDOS_CHANCE + math.max(0, self.project:getRealRating() - logicPiece.DDOS_CHANCE_INC_MINIMUM) * logicPiece.DDOS_CHANCE_INC_PER_RATING
				
				if realChance >= math.randomf(1, logicPiece.DDOS_CHANCE_ROLL_RANGE) then
					self:startDDOS()
				end
			else
				self.ddosCooldown = self.ddosCooldown - 1
			end
		end
		
		local map = self.activeRandomEventMap
		local time = timeline.curTime
		local cooldown = self.eventCooldown
		
		for key, data in ipairs(logicPiece.RANDOM_EVENTS) do
			local id = data.id
			
			if not map[id] and (not cooldown[id] or time > cooldown[id]) and data:canStart(self) then
				self:startRandomEvent(data)
			end
		end
	elseif event == studio.EVENTS.UPDATE_MMO_HAPPINESS then
		self:calculateTargetHappiness()
	elseif event == timeline.EVENTS.NEW_MONTH then
		local serverCost = self:calculateServerCosts()
		
		self.totalServerCosts = self.totalServerCosts + serverCost
		
		local fundsChange = -serverCost
		local history = studio:getFinanceHistory()
		
		history:changeValue(nil, "server_expenses", fundsChange)
		
		local purchases = self.purchases
		local subs = self.subscribers
		local attractiveness = self.attractiveness
		local changeAffector = self.project:getRealRating() * attractiveness / review.maxRating
		local fee = self.fee
		
		if fee < logicPiece.SUBSCRIPTION_FEE_BOOST_PRICE then
			changeAffector = changeAffector * (1 + (logicPiece.SUBSCRIPTION_FEE_BOOST_PRICE - fee) / logicPiece.LONGEVITY_FEE_BOOST * logicPiece.LONGEVITY_FEE_AFFECTOR)
		elseif fee > logicPiece.SANE_SUBSCRIPTION_FEE then
			changeAffector = changeAffector / (1 + ((fee - logicPiece.SANE_SUBSCRIPTION_FEE) / logicPiece.FEE_PENALTY_DIVIDER)^logicPiece.FEE_PENALTY_EXPONENT)
		end
		
		local contentAffector = self.contentAmount / self.contentPeak * changeAffector * self.happiness
		local delta = logicPiece.SUBS_LOSS_AT_CONTENT_AMOUNT - contentAffector
		local oldSubs = self.subscribers
		local longevityMult = 1
		
		if self.shutdownAnnounced then
			delta = logicPiece.SHUTDOWN_ANNOUNCE_LOSS_DELTA
			longevityMult = logicPiece.SHUTDOWN_ANNOUNCE_LONGEVITY_MULT
		end
		
		if delta > 0 and subs > 0 then
			local realDelta = (delta + math.min(logicPiece.SUBS_LOSS_EXPONENT_CAP, delta^logicPiece.SUBS_LOSS_EXPONENT)) * logicPiece.SUBS_LOSS_MULTIPLIER
			local change = subs * realDelta
			
			if not self.shutdownAnnounced then
				change = change * (subs / purchases)
			end
			
			change = math.floor(change)
			
			self:changeSubscribers(-math.min(subs, change))
			self:calculateTargetHappiness()
			
			self.subLossTimes = self.subLossTimes + 1
			
			if self.subLossTimes > logicPiece.SUB_LOSS_BEFORE_DIALOGUE and not self.project:getFact(logicPiece.NOTIFIED_OF_LOSS_FACT) and studio:getEmployeeCountByRole("manager") > 0 then
				local managerRole = "manager"
				
				for key, manager in ipairs(studio:getEmployees()) do
					if manager:getRole() == managerRole and manager:isAvailable() then
						local object = dialogueHandler:addDialogue(logicPiece.SUB_LOSS_DIALOGUE, nil, manager)
						
						object:setFact("game", self.project)
						
						local reasons = {}
						
						if self.priceHappinessAffector ~= 0 then
							table.insert(reasons, "price")
						end
						
						if self.serverHappinessAffector < 1 then
							table.insert(reasons, "server")
						end
						
						object:setFact("reasons", reasons)
						object:setFact("had_reasons", #reasons > 0)
						self.project:setFact(logicPiece.NOTIFIED_OF_LOSS_FACT, true)
						
						break
					end
				end
			end
		elseif delta < 0 then
			local realDelta = math.abs(delta)
			local resubMult = 1
			local dist = self.longevity / logicPiece.OVERALL_LONGEVITY
			
			if dist < logicPiece.OVERALL_LONGEVITY_RESUB_PENALTY then
				resubMult = math.max(logicPiece.MIN_RESUB_MULT, dist / logicPiece.OVERALL_LONGEVITY_RESUB_PENALTY)
			end
			
			local regainPercentage = math.min(logicPiece.SUBS_REGAIN_PERCENTAGE, realDelta / (1 - logicPiece.SUBS_LOSS_AT_CONTENT_AMOUNT) * logicPiece.SUBS_REGAIN_PERCENTAGE * attractiveness) * resubMult / longevityMult
			
			self:changeSubscribers(math.min(purchases - subs, purchases * regainPercentage))
			self:calculateTargetHappiness()
		end
		
		local subFees = fee * gameProject.SALE_POST_TAX_PERCENTAGE * self.subscribers
		
		self.totalMoneyMade = self.totalMoneyMade + subFees
		fundsChange = fundsChange + subFees
		self.moneyMade = self.moneyMade + fundsChange
		self.subChange = self.subscribers - oldSubs + self.purchaseSubChange
		self.purchaseSubChange = 0
		
		studio:addFunds(fundsChange)
		
		self.subscriberList[self.listIndex] = self.subscribers
		self.serverCostData[self.listIndex] = serverCost / subFees * self.subscribers
		self.listIndex = self.listIndex + 1
		
		history:changeValue(nil, "game_projects", subFees)
		
		local daysInMonth = timeline.DAYS_IN_MONTH
		
		self.contentAmount = self.contentAmount - daysInMonth
		self.longevity = math.max(0, self.longevity - daysInMonth * math.max(1, 1 / attractiveness) * longevityMult * (1 + self.priceHappinessAffector))
		
		if not self.mentionedLongevity and self.longevity / logicPiece.OVERALL_LONGEVITY <= logicPiece.OVERALL_LONGEVITY_RESUB_PENALTY then
			if studio:getEmployeeCountByRole("manager") > 0 then
				local managers = studio:getManagers()
				
				if #managers > 0 then
					local randomManager = managers[math.random(1, #managers)]
					local obj = dialogueHandler:addDialogue("manager_mmo_longevity_1", nil, randomManager)
				end
			end
			
			self.mentionedLongevity = true
		end
		
		if self.expansionContent > 0 then
			self.expansionContent = math.max(0, self.expansionContent - daysInMonth)
		end
		
		events:fire(logicPiece.EVENTS.PROGRESSED, self.project)
	elseif event == studio.EVENTS.ROOMS_UPDATED or event == serverRenting.EVENTS.CHANGED_RENTED_SERVERS or event == serverRenting.EVENTS.CHANGED_CUSTOMER_SUPPORT then
		self:calculateTargetHappiness()
	elseif gameProj == self.project then
		self:changeSubscribers(change)
		self:calculateTargetHappiness()
		
		self.subscriberPeak = math.max(self.subscribers, self.subscriberPeak)
		self.purchaseSubChange = self.purchaseSubChange + change
		self.subscriberList[self.listIndex] = self.subscribers
		self.serverCostData[self.listIndex] = self:getServerCostDisplayValue()
		self.purchases = self.purchases + change
	end
end

function logicPiece:save()
	local saved = logicPiece.baseClass.save(self)
	
	saved.subscribers = self.subscribers
	saved.contentAmount = self.contentAmount
	saved.contentPeak = self.contentPeak
	saved.fee = self.fee
	saved.happiness = self.happiness
	saved.purchases = self.purchases
	saved.subscriberList = self.subscriberList
	saved.moneyMade = self.moneyMade
	saved.subChange = self.subChange
	saved.evaluatableTasks = self.evaluatableTasks
	saved.evaluationsRemaining = self.evaluationsRemaining
	saved.startingFee = self.startingFee
	saved.previousFee = self.previousFee
	saved.evaluateFee = self.evaluateFee
	saved.feedbackCooldown = self.feedbackCooldown
	saved.subscriberPeak = self.subscriberPeak
	saved.acceptedFee = self.acceptedFee
	saved.subLossTimes = self.subLossTimes
	saved.shutdownAnnounced = self.shutdownAnnounced
	saved.expansionContent = self.expansionContent
	saved.longevity = self.longevity
	saved.mentionedLongevity = self.mentionedLongevity
	saved.serverCostData = self.serverCostData
	saved.serverUseAffectors = self.serverUseAffectors
	saved.ddos = self.ddos
	saved.ddosCooldown = self.ddosCooldown
	saved.miscAnalysis = self.miscAnalysis
	saved.activeRandomEvents = {}
	saved.eventCooldown = self.eventCooldown
	saved.eventAmount = self.eventAmount
	saved.finished = self.finished
	saved.totalServerCosts = self.totalServerCosts
	saved.totalMoneyMade = self.totalMoneyMade
	
	for key, data in ipairs(self.activeRandomEvents) do
		saved.activeRandomEvents[#saved.activeRandomEvents + 1] = data:save()
	end
	
	return saved
end

function logicPiece:load(data)
	self.finished = data.finished
	self.subscribers = 0
	self.loadSubscribers = data.subscribers
	self.contentAmount = data.contentAmount
	self.contentPeak = data.contentPeak
	self.happiness = data.happiness
	self.purchases = data.purchases
	self.subscriberList = data.subscriberList
	self.moneyMade = data.moneyMade
	self.subChange = data.subChange
	self.evaluatableTasks = data.evaluatableTasks
	self.evaluationsRemaining = data.evaluationsRemaining
	self.startingFee = data.startingFee
	self.previousFee = data.previousFee
	self.evaluateFee = data.evaluateFee
	self.loadFee = data.fee
	self.listIndex = math.max(1, #self.subscriberList)
	self.feedbackCooldown = data.feedbackCooldown
	self.subscriberPeak = data.subscriberPeak
	self.acceptedFee = data.acceptedFee
	self.subLossTimes = data.subLossTimes or self.subLossTimes
	self.shutdownAnnounced = data.shutdownAnnounced
	self.expansionContent = data.expansionContent or self.expansionContent
	self.longevity = data.longevity or logicPiece.OVERALL_LONGEVITY
	self.mentionedLongevity = data.mentionedLongevity
	self.serverCostData = data.serverCostData or self.serverCostData
	self.serverUseAffectors = data.serverUseAffectors or self.serverUseAffectors
	self.ddos = data.ddos
	self.ddosCooldown = data.ddosCooldown
	self.miscAnalysis = data.miscAnalysis or self.miscAnalysis
	self.eventCooldown = data.eventCooldown or self.eventCooldown
	self.eventAmount = data.eventAmount or self.eventAmount
	self.totalServerCosts = data.totalServerCosts or self.totalServerCosts
	self.totalMoneyMade = data.totalMoneyMade or self.totalMoneyMade
	
	for key, data in ipairs(self.serverUseAffectors) do
		self.serverUseAffectorMap[data.id] = data
		
		studio:changeServerUse(data.change)
		
		self.serverUseAffector = self.serverUseAffector + data.change
	end
	
	if data.activeRandomEvents then
		for key, data in ipairs(data.activeRandomEvents) do
			self.activeRandomEvents[#self.activeRandomEvents + 1] = logicPiece.loadRandomEvent(data)
			self.activeRandomEventMap[data.id] = true
		end
	end
end

logicPieces:registerNew(logicPiece, "event_handling_logic_piece")
require("game/logic_pieces/feedback_analysis_task")
