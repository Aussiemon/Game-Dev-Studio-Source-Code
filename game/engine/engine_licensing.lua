engineLicensing = {}
engineLicensing.otherEngines = {}
engineLicensing.onMarketEngines = {}
engineLicensing.allAvailableFeatures = {}
engineLicensing.currentAvailable = {}
engineLicensing.currentAvailableWithReleaseDates = {}
engineLicensing.evaluatedFeatures = {}
engineLicensing.validSequelEngines = {}
engineLicensing.availableFeatureCount = 0
engineLicensing.desiredFeatures = 0
engineLicensing.addedFeatures = 0
engineLicensing.BASE_COST = {
	5000,
	10000
}
engineLicensing.COST_PER_FEATURE_COUNT_ATTRACTIVENESS_DELTA = 1000
engineLicensing.COST_PER_STAT_ATTRACTIVENESS = 200
engineLicensing.BASE_STAT_ATTRACTIVENESS_VALUE = 15
engineLicensing.COST_DELTA_MULTIPLIER = {
	0.9,
	1.3
}
engineLicensing.COST_SEGMENT_ROUNDING = 100
engineLicensing.HIGH_COST_EXCEPTION_CHANCE = 20
engineLicensing.HIGH_COST_EXCEPTION_RANGE = {
	0.2,
	0.3
}
engineLicensing.NEW_ENGINE_ON_EVENT = timeline.EVENTS.NEW_MONTH
engineLicensing.EVENTS = {
	ENGINE_SELECTED = events:new(),
	PURCHASED = events:new()
}
engineLicensing.CATCHABLE_EVENTS = {
	engineLicensing.NEW_ENGINE_ON_EVENT
}
engineLicensing.NEW_ENGINE_CHANCE = 20
engineLicensing.TIME_ON_MARKET_UNTIL_SEQUEL = timeline.DAYS_IN_MONTH * 6
engineLicensing.SEQUEL_CHANCE = 20
engineLicensing.SEQUEL_FREE_CHANCE = 10
engineLicensing.SEQUEL_NUMBER_FACT = "sequel_number"
engineLicensing.ALWAYS_FREE_FACT = "always_free"
engineLicensing.UNIQUE_CHAIN_FACT = "unique_chain"
engineLicensing.GENERATED_ENGINE_FACT = "generated_engine"
engineLicensing.STAT_PERFORMANCE_RANGE = {
	50,
	85
}
engineLicensing.STAT_INTEGRITY_RANGE = {
	30,
	90
}
engineLicensing.STAT_EASE_OF_USE = {
	40,
	90
}
engineLicensing.GOOD_STATS_CHANCE = 35
engineLicensing.FREE_ENGINE_GOOD_STATS_CHANCE = 15
engineLicensing.FREE_ENGINE_STATS_MULTIPLIER = {
	1,
	1.4
}
engineLicensing.FREE_CHANCE = 15
engineLicensing.FREE_ENGINE_REGULAR_FEATURE_COUNT_CHANCE = 50
engineLicensing.FREE_ENGINE_FEATURE_AMOUNT_MULTIPLIER = 0.5
engineLicensing.MAX_LICENSEABLE_ENGINES = 10
engineLicensing.LEAST_ATTRACTIVE_ENGINE_MARKET_ELIMINATION_TIME = timeline.DAYS_IN_WEEK * timeline.WEEKS_IN_MONTH * 3
engineLicensing.TIME_DELTA_FOR_LOWER_CHANCE = timeline.DAYS_IN_WEEK * timeline.WEEKS_IN_MONTH * 3
engineLicensing.LOWERED_CHANCE = 30
engineLicensing.CHANCE_INCREASE_MULTIPLIER = 1
engineLicensing.MANY_FEATURES_CHANCE = 15
engineLicensing.MONTLY_ENGINE_CHANCE = 10
engineLicensing.NOTABLE_FEATURE_TIME_PERIOD = timeline.DAYS_IN_WEEK * timeline.WEEKS_IN_MONTH * 3
engineLicensing.MIN_ENGINE_SELL_AMOUNT = 1
engineLicensing.MAX_ENGINE_SELL_AMOUNT = 4
engineLicensing.ENGINE_SELL_AMOUNT_DECREASE_PER_PRICE = 0.2
engineLicensing.PRICE_OFFSET_MAX = 10000
engineLicensing.MIN_IDEAL_PRICE = 1000
engineLicensing.MIN_ENGINE_SELL_CHANCE = 5
engineLicensing.MAX_ENGINE_SELL_CHANCE = 60
engineLicensing.SELL_CHANCE_PENALTY_PRICE = 2000
engineLicensing.SELL_CHANCE_DROP = 15
engineLicensing.MIN_ATTRACTIVENESS_OFFSET = 0.33
engineLicensing.ENGINE_LICENSING_TAX = 0.25
engineLicensing.ALL_ENGINES_FREE_IDEAL_PRICE_MULTIPLIER = 0.5
engineLicensing.NAME_GENERATION = {
	templates = {
		_T("ENGINE_NAME_TEMPLATE", "GameREPLACE Engine")
	},
	replacements = {
		_T("ENGINE_REPLACEMENT_PRO", "Pro"),
		_T("ENGINE_REPLACEMENT_MAKER", "Maker"),
		_T("ENGINE_REPLACEMENT_CONVEYOR", "Conveyor"),
		_T("ENGINE_REPLACEMENT_FOUNDATION", "Foundation"),
		_T("ENGINE_REPLACEMENT_BOOTLEG", "Bootleg"),
		_T("ENGINE_REPLACEMENT_JAM", "Jam")
	},
	fullNames = {
		_T("ENGINE_LOVE2D", "LOVE2D"),
		_T("BURN_ENGINE", "Burn Engine"),
		_T("BENZINE_ENGINE", "Benzine Engine"),
		_T("BLUE_ENGINE", "BLUE Engine"),
		_T("YOAI_ENGINE", "YOAI Engine"),
		_T("EPTA_ENGINE", "EPTA Engine"),
		_T("YOBA_ENGINE", "YOBA Engine"),
		_T("ORIGIN_ENGINE", "Origin Engine"),
		_T("UNBELIEVABLE_ENGINE", "Unbelievable Engine"),
		_T("MATTE_ENGINE", "Matte Engine"),
		_T("AGGRO_ENGINE", "Aggro"),
		_T("FORGE_ENGINE", "Forge"),
		_T("KOKOS3D_ENGINE", "Kokos3D Engine"),
		_T("LIGHT_ENGINE", "Light Engine"),
		_T("INERTIA_ENGINE", "Inertia Engine"),
		_T("BLAST_ENGINE", "Blast Engine")
	}
}
engineLicensing.NAME_INDEX_AVAILABILITY = {
	used = {
		templates = {},
		replacements = {},
		fullNames = {}
	},
	available = {
		templates = {},
		replacements = {},
		fullNames = {}
	}
}
engineLicensing.UI_ELEMENTS = {}

function engineLicensing:init()
	self:initEventHandler()
	
	self.mentionedNewTech = {}
end

function engineLicensing:remove()
	table.clearArray(self.otherEngines)
	table.clearArray(self.onMarketEngines)
	self:removeEventHandler()
	
	self.mostAttractiveEngine = nil
end

function engineLicensing:initEventHandler()
	events:addDirectReceiver(self, engineLicensing.CATCHABLE_EVENTS)
end

function engineLicensing:removeEventHandler()
	events:removeDirectReceiver(self, engineLicensing.CATCHABLE_EVENTS)
end

function engineLicensing:lock()
	self:removeEventHandler()
end

function engineLicensing:unlock()
	self:initEventHandler()
end

eventBoxText:registerNew({
	id = "sold_engine_licenses",
	getText = function(self, data)
		local amount = data[1]
		local cashGain = data[2]
		
		if amount == 1 then
			return _format(_T("SOLD_ONE_ENGINE_LICENSE", "Sold 1 engine license, totalling at MONEY"), "MONEY", string.roundtobigcashnumber(cashGain))
		else
			return _format(_T("SOLD_ENGINE_LICENSES", "Sold AMOUNT engine licenses, totalling at MONEY"), "AMOUNT", amount, "MONEY", string.roundtobigcashnumber(cashGain))
		end
	end
})

function engineLicensing:getBestEngine()
	return self.mostAttractiveEngine
end

function engineLicensing:attemptSellPlayerEngine(engineObj, price)
	local bestEngine = self.mostAttractiveEngine
	local bestEngineAttractiveness, bestEnginePrice = 0, 0
	
	if bestEngine then
		bestEngineAttractiveness = self.mostAttractiveEngine:getLicensingAttractiveness()
		bestEnginePrice = self.mostAttractiveEngine:getCost()
		
		if bestEnginePrice == 0 then
			bestEnginePrice = self.mostAttractiveEngine.idealPrice
		end
		
		if engineObj.idealPrice then
			engineObj.idealPrice = nil
		end
	else
		if not engineObj.idealPrice then
			engineObj.idealPrice = self:_calculateEngineCost(engineObj, true) * engineLicensing.ALL_ENGINES_FREE_IDEAL_PRICE_MULTIPLIER
		end
		
		bestEngineAttractiveness = engineObj:getLicensingAttractiveness()
		bestEnginePrice = engineObj.idealPrice
	end
	
	local ourAttractiveness = engineObj:getLicensingAttractiveness()
	local minimumOffset = engineLicensing.MIN_ATTRACTIVENESS_OFFSET * bestEngineAttractiveness
	local normalizedAttract = bestEngineAttractiveness - minimumOffset
	local ourNormalAttract = ourAttractiveness - minimumOffset
	local engineSellChance = math.lerp(engineLicensing.MIN_ENGINE_SELL_CHANCE, engineLicensing.MAX_ENGINE_SELL_CHANCE, math.min(normalizedAttract, math.max(0, ourNormalAttract)) / normalizedAttract)
	local maxPriceOffset = ourAttractiveness / bestEngineAttractiveness - 1
	local ourEnginePrice = price
	local idealPrice = math.max(engineLicensing.MIN_IDEAL_PRICE, bestEnginePrice + engineLicensing.PRICE_OFFSET_MAX * maxPriceOffset)
	local priceDiff = math.max(0, ourEnginePrice - idealPrice)
	local engineSaleAmount = engineLicensing.MAX_ENGINE_SELL_AMOUNT
	
	if priceDiff > 0 then
		local lostSalePer = idealPrice * engineLicensing.ENGINE_SELL_AMOUNT_DECREASE_PER_PRICE
		local lostSales = math.floor(priceDiff / lostSalePer)
		
		engineSaleAmount = math.max(engineLicensing.MIN_ENGINE_SELL_AMOUNT, engineLicensing.MAX_ENGINE_SELL_AMOUNT - lostSales)
		engineSellChance = math.max(engineLicensing.MIN_ENGINE_SELL_CHANCE, engineSellChance - priceDiff / engineLicensing.SELL_CHANCE_PENALTY_PRICE * engineLicensing.SELL_CHANCE_DROP)
	end
	
	if engineSellChance >= math.random(1, 100) then
		local sales = math.random(1, engineSaleAmount)
		local money = math.round(price * sales * (1 - engineLicensing.ENGINE_LICENSING_TAX))
		
		engineObj:increaseLicensesSold(sales)
		engineObj:increaseMoneyMade(money)
		studio:addFunds(money, false, "engine_licensing")
		game.addToEventBox("sold_engine_licenses", {
			sales,
			money
		}, 2, nil, "wad_of_cash_plus")
	end
end

function engineLicensing:findBestEngine()
	self.mostAttractiveEngine = nil
	
	local object, attractiveness = nil, 0
	local freeObject, freeAttract = nil, 0
	
	for key, data in ipairs(self.onMarketEngines) do
		if data.engine:getCost() > 0 then
			local curAttract = data.engine:getLicensingAttractiveness()
			
			if attractiveness < curAttract then
				object = data.engine
				attractiveness = curAttract
			end
		else
			local curAttract = data.engine:getLicensingAttractiveness()
			
			if freeAttract < curAttract then
				freeObject = data.engine
				freeAttract = curAttract
			end
		end
	end
	
	self.mostAttractiveEngine = object or freeObject
	
	if not object and freeObject then
		self.mostAttractiveEngine.idealPrice = self:_calculateEngineCost(self.mostAttractiveEngine, true) * engineLicensing.ALL_ENGINES_FREE_IDEAL_PRICE_MULTIPLIER
	end
end

function engineLicensing:handleEvent(event)
	if event == engineLicensing.NEW_ENGINE_ON_EVENT and math.random(1, 100) <= engineLicensing.NEW_ENGINE_CHANCE then
		local engineObj, isFree = self:generateLicenseableEngine()
		
		if engineObj then
			engineObj:setCost(self:calculateEngineCost(engineObj, isFree))
			self:addEngineToMarket(engineObj)
			self:findBestEngine()
			table.insert(self.otherEngines, engineObj)
			self:createReleasePopup(engineObj)
		end
	end
end

function engineLicensing:generateEngines(engineCount)
	for i = 1, engineCount do
		local engineObj, isFree = self:generateLicenseableEngine()
		
		if engineObj then
			engineObj:setCost(self:calculateEngineCost(engineObj, isFree))
			self:addEngineToMarket(engineObj)
			table.insert(self.otherEngines, engineObj)
		end
	end
	
	self:findBestEngine()
end

function engineLicensing:removeLowAttractivenessEngines()
	local engineObj = self:findLeastAttractiveEngine()
	
	if engineObj then
		if not engineObj:getFact(engine.LEAST_ATTRACTIVE_TIMESTAMP_FACT) then
			engineObj:setFact(engine.LEAST_ATTRACTIVE_TIMESTAMP_FACT, timeline.curTime)
		end
		
		local delta = timeline.curTime - engineObj:getFact(engine.LEAST_ATTRACTIVE_TIMESTAMP_FACT)
		
		if delta >= engineLicensing.LEAST_ATTRACTIVE_ENGINE_MARKET_ELIMINATION_TIME then
			self:removeEngineFromMarket(engineObj)
		end
	end
end

function engineLicensing:findLeastAttractiveEngine()
	local attractiveness, object = math.huge
	
	for key, data in ipairs(self.onMarketEngines) do
		if data.engine:getCost() > 0 then
			local curAttract = data.engine:getLicensingAttractiveness()
			
			if curAttract < attractiveness then
				object = data.engine
				attractiveness = curAttract
			end
		end
	end
	
	return object
end

eventBoxText:registerNew({
	id = "new_licenseable_engine",
	getText = function(self, data)
		return _format(_T("LICENSEABLE_ENGINE_RELEASED_POPUP_TEXT", "NEW_ENGINE has been released.IS_SEQUEL NOTABLE_FEATURES"), "NEW_ENGINE", data.engine, "IS_SEQUEL", data.isSequel and _T("LICENSEABLE_ENGINE_IS_SEQUEL", " The engine is a large update to their previous engine.") or "", "NOTABLE_FEATURES", "")
	end
})

function engineLicensing:createReleasePopup(engineObj)
	local isSequel = engineObj:getFact(engineLicensing.SEQUEL_NUMBER_FACT) > 1
	local newestFeature = self:getNewestFeature(engineObj)
	
	if newestFeature and isSequel and not self.mentionedNewTech[newestFeature.id] then
		local popup = gui.create("Popup")
		
		popup:setWidth(500)
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(_T("NEW_ENGINE_RELEASED_TITLE", "New Engine Available"))
		popup:setTextFont(fonts.get("pix20"))
		
		local template = _T("LICENSEABLE_ENGINE_RELEASED_POPUP_TEXT", "NEW_ENGINE has been released.IS_SEQUEL NOTABLE_FEATURES")
		local notableFeatureText = newestFeature and (newestFeature.notableFeatureText or string.easyformatbykeys(_T("LICENSEABLE_ENGINE_NOTABLE_FEATURE", "One notable feature that this engine has is 'NOTABLE_FEATURE', which is new tech."), "NOTABLE_FEATURE", newestFeature.display))
		
		template = string.easyformatbykeys(template, "NEW_ENGINE", engineObj:getName(), "IS_SEQUEL", isSequel and _T("LICENSEABLE_ENGINE_IS_SEQUEL", " The engine is a large update to their previous engine.") or "", "NOTABLE_FEATURES", notableFeatureText)
		
		popup:setText(template)
		popup:addButton(fonts.get("pix24"), "OK")
		popup:center()
		frameController:push(popup)
		
		self.mentionedNewTech[newestFeature.id] = true
	else
		game.addToEventBox("new_licenseable_engine", {
			engine = engineObj:getName(),
			isSequel = isSequel
		}, 1)
	end
end

function engineLicensing:getNewestFeature(engineObj)
	if preferences:get("quietly_notify_of_new_engines") then
		return nil
	end
	
	local curDateTime = timeline:getDateTime(timeline:getYear(), timeline:getMonth())
	local newest, newestFeature = math.huge
	
	for featureID, state in pairs(engineObj:getRevisionFeatures(engineObj:getRevisionCount())) do
		local featureData = taskTypes.registeredByID[featureID]
		
		if featureData.releaseDate then
			local time = timeline:getDateTime(featureData.releaseDate.year, featureData.releaseDate.month)
			local delta = curDateTime - time
			
			if delta <= engineLicensing.NOTABLE_FEATURE_TIME_PERIOD and delta < newest then
				newest = delta
				newestFeature = featureData
			end
		end
	end
	
	return newestFeature
end

function engineLicensing:getEngineByUniqueID(id)
	for key, engineObj in ipairs(self.otherEngines) do
		if engineObj:getUniqueID() == id then
			return engineObj, key
		end
	end
	
	return nil
end

function engineLicensing:addEngineToMarket(engineObj)
	engineObj:setReleaseDate(timeline.curTime)
	engineObj:assignUniqueID()
	table.insert(self.onMarketEngines, {
		engine = engineObj,
		time = timeline.curTime
	})
end

function engineLicensing:removeEngineFromMarket(engineObj, index)
	if index then
		table.remove(self.onMarketEngines, index)
		
		return 
	end
	
	for key, data in ipairs(self.onMarketEngines) do
		if data.engine == engineObj then
			table.remove(self.onMarketEngines, key)
		end
	end
end

function engineLicensing:canAddFeature(engineObj, data)
	return engineObj:canHaveFeature(data.id, false, false, true) and data:canHaveTask(engineObj)
end

function engineLicensing:canMeetRequirements(data)
	if data.requirements then
		for requiredID, state in pairs(data.requirements) do
			if engineLicensing.evaluatedFeatures[requiredID] then
				return false
			end
		end
	end
	
	return true
end

function engineLicensing:addFeatureToEngine(engineObj, data)
	engineObj:addFeature(data.id)
	
	engineLicensing.allAvailableFeatures[data.id] = nil
	engineLicensing.evaluatedFeatures[data.id] = true
	self.availableFeatureCount = self.availableFeatureCount - 1
	self.addedFeatures = self.addedFeatures + 1
end

function engineLicensing.sortByReleaseDate(a, b)
	return timeline:getDateTime(a.releaseDate.year, a.releaseDate.month) < timeline:getDateTime(b.releaseDate.year, b.releaseDate.month)
end

function engineLicensing:rollBetweenTwoFeatures(newest, secondNewest)
	local chance = 50
	local timeDelta = self.curDateTime - timeline:getDateTime(newest.releaseDate.year, newest.releaseDate.month)
	
	if timeDelta < engineLicensing.TIME_DELTA_FOR_LOWER_CHANCE then
		local scalar = timeDelta / engineLicensing.TIME_DELTA_FOR_LOWER_CHANCE
		
		chance = chance - scalar * engineLicensing.LOWERED_CHANCE
	else
		local timePastLowerChance = timeDelta - engineLicensing.TIME_DELTA_FOR_LOWER_CHANCE
		
		chance = chance + timePastLowerChance * engineLicensing.CHANCE_INCREASE_MULTIPLIER
	end
	
	local featureToAdd
	
	if chance >= math.random(1, 100) then
		featureToAdd = newest
	elseif secondNewest then
		featureToAdd = secondNewest
	else
		featureToAdd = newest
	end
	
	return featureToAdd
end

function engineLicensing:isNameIndexUsed(subList, index)
	return engineLicensing.NAME_INDEX_AVAILABILITY.used[subList][index]
end

function engineLicensing:setLicensingScrollbar(obj)
	self.licensingScrollbar = obj
end

function engineLicensing:postPurchaseEngineLicense(boughtEngine)
	if self.licensingScrollbar then
		for key, obj in ipairs(self.licensingScrollbar:getItems()) do
			if obj.onMarketEngines then
				engineLicensing.UI_ELEMENTS.onMarketCategory = obj
			elseif obj.licensedEngines then
				engineLicensing.UI_ELEMENTS.purchasedCategory = obj
			elseif obj.engine == boughtEngine then
				engineLicensing.UI_ELEMENTS.curBoughtElement = obj
			end
		end
		
		engineLicensing.UI_ELEMENTS.onMarketCategory:removeItem(engineLicensing.UI_ELEMENTS.curBoughtElement)
		engineLicensing.UI_ELEMENTS.purchasedCategory:addItem(engineLicensing.UI_ELEMENTS.curBoughtElement)
		engineLicensing.UI_ELEMENTS.curBoughtElement:setCanPurchase(false)
	end
	
	table.clear(engineLicensing.UI_ELEMENTS)
end

function engineLicensing:clearNameGeneration()
	for key, data in pairs(engineLicensing.NAME_INDEX_AVAILABILITY) do
		for key, subData in pairs(data) do
			table.clear(subData)
		end
	end
end

function engineLicensing:pickName()
	local used = engineLicensing.NAME_INDEX_AVAILABILITY.used
	local available = engineLicensing.NAME_INDEX_AVAILABILITY.available
	local replacements = engineLicensing.NAME_GENERATION.replacements
	local templates = used.templates
	local replacementsAvailable = false
	local fullNamesAvailable = false
	
	for key, template in ipairs(engineLicensing.NAME_GENERATION.templates) do
		for replaceKey, replacement in ipairs(replacements) do
			if not templates[key] or templates[key] and not templates[key][replaceKey] then
				available.templates[key] = available.templates[key] or {}
				
				table.insert(available.templates[key], replaceKey)
				
				replacementsAvailable = true
			end
		end
	end
	
	for key, fullName in ipairs(engineLicensing.NAME_GENERATION.fullNames) do
		if not used.fullNames[key] then
			table.insert(available.fullNames, key)
			
			fullNamesAvailable = true
		end
	end
	
	if replacementsAvailable and math.random(1, 100) <= 50 then
		local randomData, randomTemplate = table.random(available.templates)
		local randomReplacement = table.random(randomData)
		
		self:clearNameGeneration()
		
		return randomTemplate, randomReplacement
	end
	
	if fullNamesAvailable then
		local randomName = table.random(available.fullNames)
		
		self:clearNameGeneration()
		
		return randomName
	end
	
	self:clearNameGeneration()
	
	return nil, nil
end

function engineLicensing:setupUsedNameState(engineList)
	local used = engineLicensing.NAME_INDEX_AVAILABILITY.used
	
	for key, data in ipairs(engineList) do
		local nameData = data:getFact("name")
		
		if nameData.template then
			used.templates[nameData.nameIndex] = used.templates[nameData.nameIndex] or {}
			used.templates[nameData.nameIndex][nameData.replacementIndex] = true
		else
			used.fullNames[nameData.nameIndex] = true
		end
	end
end

function engineLicensing:generateLicenseableEngine()
	self.availableFeatureCount = 0
	
	self:findAllAvailableFeatures()
	
	local isFree
	local regularFeatures = false
	local rolledSequel = false
	
	self:setupUsedNameState(self.otherEngines)
	
	local baseNameIndex, replacementIndex = self:pickName()
	local sequelOnly = false
	
	if not baseNameIndex and not replacementIndex then
		sequelOnly = true
	end
	
	local newEngine = engine.new()
	
	newEngine:setIsLicenseableEngine(true)
	
	if math.random(1, 100) <= engineLicensing.SEQUEL_CHANCE then
		local curTime = timeline.curTime
		
		for key, data in ipairs(self.onMarketEngines) do
			if curTime - data.time >= engineLicensing.TIME_ON_MARKET_UNTIL_SEQUEL then
				table.insert(self.validSequelEngines, data.engine)
			end
		end
		
		if #self.validSequelEngines > 0 then
			local randIndex = math.random(1, #self.validSequelEngines)
			local rand = self.validSequelEngines[randIndex]
			
			table.clearArray(self.validSequelEngines)
			self:removeEngineFromMarket(rand)
			
			if rand:getCost() > 0 then
				if math.random(1, 100) <= engineLicensing.SEQUEL_FREE_CHANCE then
					isFree = true
					regularFeatures = true
				end
			elseif rand:getFact(engineLicensing.ALWAYS_FREE_FACT) then
				isFree = true
				regularFeatures = true
			end
			
			if isFree then
				newEngine:setFact(engineLicensing.ALWAYS_FREE_FACT, true)
			end
			
			local prevEngineName = rand:getFact("name")
			local baseName
			
			if prevEngineName.template then
				baseName = string.easyformatbykeys(engineLicensing.NAME_GENERATION.templates[prevEngineName.nameIndex], "REPLACE", engineLicensing.NAME_GENERATION.replacements[prevEngineName.replacementIndex])
			else
				baseName = engineLicensing.NAME_GENERATION.fullNames[prevEngineName.nameIndex]
			end
			
			newEngine:setName(baseName .. " v" .. rand:getFact(engineLicensing.SEQUEL_NUMBER_FACT) + 1 .. ".0")
			newEngine:setFact(engineLicensing.SEQUEL_NUMBER_FACT, rand:getFact(engineLicensing.SEQUEL_NUMBER_FACT) + 1)
			newEngine:setFact("name", {
				template = prevEngineName.template,
				nameIndex = prevEngineName.nameIndex,
				replacementIndex = prevEngineName.replacementIndex
			})
			
			rolledSequel = rand
		else
			table.clearArray(self.validSequelEngines)
			
			if sequelOnly then
				return nil
			end
		end
	else
		if sequelOnly then
			return nil
		end
		
		isFree = math.random(1, 100) <= engineLicensing.FREE_CHANCE
	end
	
	if not rolledSequel then
		newEngine:setFact(engineLicensing.SEQUEL_NUMBER_FACT, 1)
		
		local isTemplate = replacementIndex ~= nil
		local name
		
		if isTemplate then
			name = _format(engineLicensing.NAME_GENERATION.templates[baseNameIndex], "REPLACE", engineLicensing.NAME_GENERATION.replacements[replacementIndex])
		else
			name = engineLicensing.NAME_GENERATION.fullNames[baseNameIndex]
		end
		
		newEngine:setName(name .. " v1.0")
		newEngine:setFact("name", {
			template = isTemplate,
			nameIndex = baseNameIndex,
			replacementIndex = replacementIndex
		})
	end
	
	local featureAmountMultiplier
	
	if isFree and (regularFeatures or math.random(1, 100) <= engineLicensing.FREE_ENGINE_REGULAR_FEATURE_COUNT_CHANCE) then
		featureAmountMultiplier = engineLicensing.FREE_ENGINE_FEATURE_AMOUNT_MULTIPLIER
	elseif math.random(1, 100) <= engineLicensing.MANY_FEATURES_CHANCE then
		featureAmountMultiplier = math.randomf(0.7, 0.85)
	else
		featureAmountMultiplier = math.randomf(0.5, 0.7)
	end
	
	self.addedFeatures = 0
	
	newEngine:advanceRevision()
	self:fillWithFeatures(newEngine, featureAmountMultiplier)
	self:applyEngineStats(newEngine)
	
	local chance = isFree and engineLicensing.FREE_ENGINE_GOOD_STATS_CHANCE or engineLicensing.GOOD_STATS_CHANCE
	
	if chance >= math.random(1, 100) then
		for statID, level in pairs(newEngine:getRevisionStats(newEngine:getRevision())) do
			newEngine:setStat(statID, math.round(level * math.randomf(engineLicensing.FREE_ENGINE_STATS_MULTIPLIER[1], engineLicensing.FREE_ENGINE_STATS_MULTIPLIER[2]), 2))
		end
	end
	
	self:resetGenerationData()
	
	return newEngine, isFree
end

function engineLicensing:generateEngine(newEngine, featureCountMultiplier, noFact)
	newEngine = newEngine or engine.new()
	
	newEngine:advanceRevision()
	
	if not noFact then
		newEngine:setFact(engineLicensing.GENERATED_ENGINE_FACT, true)
	end
	
	newEngine:setProjectType("engine_project", true)
	self:findAllAvailableFeatures(newEngine)
	self:fillWithFeatures(newEngine, featureCountMultiplier)
	self:applyEngineStats(newEngine)
	self:resetGenerationData()
	
	return newEngine
end

function engineLicensing:findAllAvailableFeatures(engineObject)
	local curYear, curMonth = timeline:getYear(), timeline:getMonth()
	
	self.curDateTime = timeline:getDateTime(curYear, curMonth)
	
	if engineObject then
		for key, taskTypeData in ipairs(taskTypes:getTasksByTaskID("engine_task")) do
			if not engineObject:hasFeature(taskTypeData.id) and (taskTypeData.releaseDate and taskTypeData:wasReleased() or not taskTypeData.releaseDate) and taskTypeData:canHaveTask(engineObject) then
				engineLicensing.allAvailableFeatures[taskTypeData.id] = taskTypeData
				self.availableFeatureCount = self.availableFeatureCount + 1
			end
		end
	else
		for key, taskTypeData in ipairs(taskTypes:getTasksByTaskID("engine_task")) do
			if (taskTypeData.releaseDate and taskTypeData:wasReleased() or not taskTypeData.releaseDate) and taskTypeData:canHaveTask(engineObject) then
				engineLicensing.allAvailableFeatures[taskTypeData.id] = taskTypeData
				self.availableFeatureCount = self.availableFeatureCount + 1
			end
		end
	end
end

function engineLicensing:applyEngineStats(newEngine)
	newEngine:setStat("performance", math.random(engineLicensing.STAT_PERFORMANCE_RANGE[1], engineLicensing.STAT_PERFORMANCE_RANGE[2]) / 100)
	newEngine:setStat("integrity", math.random(engineLicensing.STAT_INTEGRITY_RANGE[1], engineLicensing.STAT_INTEGRITY_RANGE[2]) / 100)
	newEngine:setStat("easeOfUse", math.random(engineLicensing.STAT_EASE_OF_USE[1], engineLicensing.STAT_EASE_OF_USE[2]) / 100)
end

function engineLicensing:fillWithFeatures(newEngine, featureCountMultiplier)
	featureCountMultiplier = featureCountMultiplier or 1
	self.desiredFeatures = math.ceil(self.availableFeatureCount * featureCountMultiplier)
	
	while true do
		table.clearArray(engineLicensing.currentAvailable)
		table.clearArray(engineLicensing.currentAvailableWithReleaseDates)
		
		for id, featureData in pairs(engineLicensing.allAvailableFeatures) do
			if self:canAddFeature(newEngine, featureData) then
				if self:canMeetRequirements(featureData) then
					if featureData.releaseDate then
						engineLicensing.currentAvailableWithReleaseDates[#engineLicensing.currentAvailableWithReleaseDates + 1] = featureData
					else
						engineLicensing.currentAvailable[#engineLicensing.currentAvailable + 1] = featureData
					end
				else
					engineLicensing.evaluatedFeatures[featureData.id] = true
					engineLicensing.currentAvailable[featureData.id] = nil
				end
			end
		end
		
		table.sort(engineLicensing.currentAvailableWithReleaseDates, engineLicensing.sortByReleaseDate)
		
		local newest = engineLicensing.currentAvailableWithReleaseDates[1]
		local secondNewest = engineLicensing.currentAvailableWithReleaseDates[2]
		local failState = 0
		
		if newest then
			self:addFeatureToEngine(newEngine, self:rollBetweenTwoFeatures(newest, secondNewest))
		else
			failState = failState + 1
		end
		
		local randIndex = math.random(1, #engineLicensing.currentAvailable)
		local randFeature = engineLicensing.currentAvailable[randIndex]
		
		if randFeature then
			self:addFeatureToEngine(newEngine, randFeature)
		else
			failState = failState + 1
		end
		
		if failState == 2 then
			break
		elseif self.addedFeatures >= self.desiredFeatures then
			break
		end
	end
end

function engineLicensing:calculateEngineCost(engineObject, isFree)
	local engineCost = 0
	
	engineObject:calculateLicensingAttractiveness()
	
	if not isFree then
		engineCost = self:_calculateEngineCost(engineObject, false)
	end
	
	return engineCost
end

function engineLicensing:_calculateEngineCost(engineObject, minimal)
	local attractiveness, featureCount, featureAttractiveness, statAttractiveness = engineObject:getAttractivenessStats()
	local engineCost = 0
	local featureCountAttractivenessDelta = featureAttractiveness - featureCount
	local statAttrCost = math.max(0, statAttractiveness - engineLicensing.BASE_STAT_ATTRACTIVENESS_VALUE) * engineLicensing.COST_PER_STAT_ATTRACTIVENESS
	
	engineCost = math.random(engineLicensing.BASE_COST[1], engineLicensing.BASE_COST[2])
	
	local featureAffector = featureCountAttractivenessDelta * engineLicensing.COST_PER_FEATURE_COUNT_ATTRACTIVENESS_DELTA
	
	if not minimal then
		featureAffector = featureAffector * math.randomf(engineLicensing.COST_DELTA_MULTIPLIER[1], engineLicensing.COST_DELTA_MULTIPLIER[2])
	end
	
	engineCost = engineCost + featureAffector + statAttrCost
	
	if not minimal and math.random(1, 100) <= engineLicensing.HIGH_COST_EXCEPTION_CHANCE then
		engineCost = engineCost * math.randomf(engineLicensing.HIGH_COST_EXCEPTION_RANGE[1], engineLicensing.HIGH_COST_EXCEPTION_RANGE[2])
	end
	
	return math.round(engineCost / engineLicensing.COST_SEGMENT_ROUNDING) * engineLicensing.COST_SEGMENT_ROUNDING
end

function engineLicensing:resetGenerationData()
	table.clear(engineLicensing.allAvailableFeatures)
	table.clearArray(engineLicensing.currentAvailable)
	table.clear(engineLicensing.evaluatedFeatures)
	table.clearArray(engineLicensing.currentAvailableWithReleaseDates)
	
	for key, list in pairs(engineLicensing.NAME_INDEX_AVAILABILITY) do
		for key, sublist in pairs(list) do
			table.clear(sublist)
		end
	end
	
	self.desiredFeatures = 0
	self.addedFeatures = 0
	self.availableFeatureCount = 0
end

function engineLicensing:save()
	local saved = {}
	
	saved.otherEngines = {}
	saved.onMarketEngines = {}
	saved.mentionedNewTech = self.mentionedNewTech
	
	for key, engineObj in ipairs(self.otherEngines) do
		table.insert(saved.otherEngines, engineObj:save())
	end
	
	for key, data in ipairs(self.onMarketEngines) do
		table.insert(saved.onMarketEngines, {
			engine = data.engine:getUniqueID(),
			time = data.time
		})
	end
	
	return saved
end

function engineLicensing:load(data)
	self:init()
	
	self.mentionedNewTech = data.mentionedNewTech or self.mentionedNewTech
	
	for key, engineData in ipairs(data.otherEngines) do
		local object = projectLoader:load(engineData)
		
		table.insert(self.otherEngines, object)
	end
	
	for key, engineData in ipairs(data.onMarketEngines) do
		local object = self:getEngineByUniqueID(engineData.engine)
		
		table.insert(self.onMarketEngines, {
			engine = object,
			time = engineData.time
		})
	end
	
	self:findBestEngine()
end
