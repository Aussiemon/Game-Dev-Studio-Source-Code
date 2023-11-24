platforms = {}
platforms.registered = {}
platforms.registeredByID = {}
platforms.BASE_DEVELOPMENT_TIME_AFFECTOR = 0.5
platforms.DEFAULT_DEVELOPMENT_TIME_AFFECTOR = 0.5
platforms.DEFAULT_POST_EXPIRE_ON_MARKET_TIME = timeline.DAYS_IN_YEAR
platforms.NOTIFY_OF_EXPIRATION_TIME = timeline.DAYS_IN_MONTH * 6
platforms.leastDifficultDevelopment = math.huge
platforms.mostDifficultDevelopment = -math.huge
platforms.lowestCutPerSale = math.huge
platforms.highestCutPerSale = -math.huge
platforms.lowestPlatformCost = math.huge
platforms.highestPlatformCost = -math.huge
platforms.CUT_PER_SALE_STEP_SIZE = 0.025
platforms.DEV_DIFFICULTY_STEP_SIZE = 0.05
platforms.GAME_SCALE_EVALUATION_TIME_PERIOD = timeline.DAYS_IN_YEAR
platforms.PLATFORM_COST_AMOUNT_PER_STEP = 0.05
platforms.PLATFORM_COST_DELTA_ROUNDING = 500
platforms.LOWEST_CUT_PER_SALE_OFFSET = -0.05
platforms.MINIMUM_PLATFORM_COST = 1000

local defaultPlatformFuncs = {}

defaultPlatformFuncs.mtindex = {
	__index = defaultPlatformFuncs
}

function defaultPlatformFuncs:getMaxProjectScale(targetTime)
	return self.maxProjectScale
end

function defaultPlatformFuncs:getReleaseText()
	if type(self.releaseText) == "string" then
		return self.releaseText
	else
		return _format(_T("NEW_PLATFORM_RELEASED", "'MANUFACTURER' has just released their new 'PLATFORM' platform."), "MANUFACTURER", consoleManufacturers:getData(self.manufacturer).display, "PLATFORM", self.display)
	end
end

function defaultPlatformFuncs:getReleaseDateTime()
	return timeline:yearToTime(self.releaseDate.year) + timeline:monthToTime(self.releaseDate.month)
end

function defaultPlatformFuncs:getDisplayQuad()
	return self.quad
end

function platforms:getData(platformID)
	return platforms.registeredByID[platformID]
end

platforms.DEFAULT_PLATFORM_MATCH = 1

function platforms:registerNew(data, inherit)
	if data.releaseDate and not data.releaseDate.year then
		error("Can not register a platform without a year of release. Proper structure: {year = <1980 - any>, month = <1 - 12>}")
	end
	
	if data.releaseDate then
		local eventID = "released_" .. data.id
		
		scheduledEvents:registerNew({
			inactive = false,
			id = eventID,
			platformID = data.id,
			date = data.releaseDate
		}, "release_platform_event")
		consoleManufacturers:addScheduledPlatformEvent(data.manufacturer, eventID)
	end
	
	if data.expiryDate then
		local time = timeline:getDateTime(data.expiryDate.year, data.expiryDate.month or 1)
		
		time = time - platforms.NOTIFY_OF_EXPIRATION_TIME
		
		local year, month = timeline:getYear(time), timeline:getMonth(time)
		local eventID = "expiry_notification_" .. data.id
		
		scheduledEvents:registerNew({
			inactive = false,
			id = eventID,
			platformID = data.id,
			date = {
				year = year,
				month = month
			}
		}, "console_expiration_heads_up")
		consoleManufacturers:addScheduledPlatformEvent(data.manufacturer, eventID)
	end
	
	local genreMatch = data.genreMatching
	local defMatch = platforms.DEFAULT_PLATFORM_MATCH
	
	for key, data in ipairs(genres.registered) do
		if not genreMatch[data.id] then
			genreMatch[data.id] = defMatch
		end
	end
	
	table.insert(consoleManufacturers.registeredByID[data.manufacturer], data)
	
	data.frustrationMultiplier = data.frustrationMultiplier or 1
	data.defaultAttractiveness = data.defaultAttractiveness or 0
	data.licenseCost = data.licenseCost or 0
	data.quad = data.quad or "platform_pc_1"
	data.cutPerSale = data.cutPerSale or 0
	data.developmentTimeAffector = data.developmentTimeAffector or platforms.DEFAULT_DEVELOPMENT_TIME_AFFECTOR
	data.postExpireOnMarketTime = data.postExpireOnMarketTime or platforms.DEFAULT_POST_EXPIRE_ON_MARKET_TIME
	data.startingFakeGames = data.startingFakeGames or platformShare.FAKE_GAME_CREATION_ON_PLATFORM_CREATION
	platforms.leastDifficultDevelopment = math.min(platforms.leastDifficultDevelopment, data.developmentTimeAffector)
	platforms.mostDifficultDevelopment = math.max(platforms.mostDifficultDevelopment, data.developmentTimeAffector)
	platforms.lowestCutPerSale = math.min(platforms.lowestCutPerSale, data.cutPerSale)
	platforms.highestCutPerSale = math.max(platforms.highestCutPerSale, data.cutPerSale)
	platforms.lowestPlatformCost = math.min(platforms.lowestPlatformCost, data.licenseCost)
	platforms.highestPlatformCost = math.max(platforms.highestPlatformCost, data.licenseCost)
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		setmetatable(data, platforms.registeredByID[inherit].mtindex)
	else
		setmetatable(data, defaultPlatformFuncs.mtindex)
	end
	
	table.insert(platforms.registered, data)
	
	platforms.registeredByID[data.id] = data
end

function platforms:preserveOriginalMatches()
	self.originalMatches = {}
	
	for key, data in ipairs(platforms.registered) do
		data.originalCutPerSale = data.cutPerSale
		data.originalLicenseCost = data.licenseCost
		data.originalDevelopmentTimeAffector = data.developmentTimeAffector
		self.originalMatches[data.id] = {}
		
		local matchList = self.originalMatches[data.id]
		local matching = data.genreMatching
		
		for key, genre in ipairs(genres.registered) do
			matchList[genre.id] = matching[genre.id]
		end
	end
end

function platforms:restoreMatches()
	for key, data in ipairs(platforms.registered) do
		data.cutPerSale = data.originalCutPerSale
		data.licenseCost = data.originalLicenseCost
		data.developmentTimeAffector = data.originalDevelopmentTimeAffector
		
		local matchList = self.originalMatches[data.id]
		local matching = data.genreMatching
		
		for key, genreData in ipairs(genres.registered) do
			matching[genreData.id] = matchList[genreData.id]
		end
	end
end

function platforms:randomizePlatformData()
	self:preserveOriginalMatches()
	
	local keyList, matchList, genreMatchCorrelationList = {}, {}, {}
	
	for key, data in ipairs(platforms.registered) do
		for key, genreData in ipairs(genres.registered) do
			keyList[#keyList + 1] = genreData.id
			matchList[#matchList + 1] = data.genreMatching[genreData.id]
			genreMatchCorrelationList[#genreMatchCorrelationList + 1] = genreData.id
		end
		
		data.replacedMatches = {}
		
		while #keyList > 0 do
			local randomGenre = table.remove(keyList, math.random(1, #keyList))
			local randomMatchIndex = math.random(1, #matchList)
			local randomMatch = table.remove(matchList, randomMatchIndex)
			local selectedMatchReplacement = table.remove(genreMatchCorrelationList, randomMatchIndex)
			
			data.genreMatching[randomGenre] = randomMatch
			data.replacedMatches[#data.replacedMatches + 1] = {
				from = selectedMatchReplacement,
				to = randomGenre
			}
		end
		
		if data.licenseCost > 0 then
			local normalized = data.cutPerSale - platforms.lowestCutPerSale + platforms.LOWEST_CUT_PER_SALE_OFFSET
			local normalizedHighest = platforms.highestCutPerSale
			local delta = normalizedHighest - normalized
			local negativeSteps = normalized / platforms.CUT_PER_SALE_STEP_SIZE
			local positiveSteps = delta / platforms.CUT_PER_SALE_STEP_SIZE
			local offset = math.random(-negativeSteps, positiveSteps)
			
			data.cutPerSaleOffset = offset * platforms.CUT_PER_SALE_STEP_SIZE
			data.cutPerSale = data.cutPerSale + data.cutPerSaleOffset
			
			local baseCostOffset = 0
			
			if offset < 0 then
				baseCostOffset = platforms.highestPlatformCost - data.licenseCost
			elseif offset > 0 then
				baseCostOffset = data.licenseCost - platforms.lowestPlatformCost
			end
			
			if baseCostOffset ~= 0 then
				local cashOffset = math.max(platforms.PLATFORM_COST_DELTA_ROUNDING, baseCostOffset * platforms.PLATFORM_COST_AMOUNT_PER_STEP) * -offset
				
				data.licenseCostOffset = cashOffset
				data.licenseCost = math.max(platforms.MINIMUM_PLATFORM_COST, data.originalLicenseCost + data.licenseCostOffset)
			end
		end
		
		local normalized = data.developmentTimeAffector - platforms.leastDifficultDevelopment
		local normalizedHighest = platforms.mostDifficultDevelopment - platforms.leastDifficultDevelopment
		local negativeSteps = math.min(0, normalized / platforms.DEV_DIFFICULTY_STEP_SIZE)
		local positiveSteps = math.max(0, normalizedHighest / platforms.DEV_DIFFICULTY_STEP_SIZE)
		local offset = math.random(-negativeSteps, positiveSteps)
		
		data.developmentTimeAffectorOffset = offset * platforms.DEV_DIFFICULTY_STEP_SIZE
		data.developmentTimeAffector = data.originalDevelopmentTimeAffector + data.developmentTimeAffectorOffset
	end
end

function platforms:saveRandomization()
	local saved = {}
	
	for key, data in ipairs(platforms.registered) do
		saved[#saved + 1] = {
			id = data.id,
			replacedMatches = data.replacedMatches,
			cutPerSaleOffset = data.cutPerSaleOffset,
			licenseCostOffset = data.licenseCostOffset,
			developmentTimeAffectorOffset = data.developmentTimeAffectorOffset
		}
	end
	
	return saved
end

function platforms:loadRandomization(data)
	self:preserveOriginalMatches()
	
	for key, platformData in ipairs(data) do
		local targetPlatform = platforms.registeredByID[platformData.id]
		local originalMatches = self.originalMatches[platformData.id]
		
		if platformData.replacedMatches then
			for key, replacementData in ipairs(platformData.replacedMatches) do
				targetPlatform.genreMatching[replacementData.to] = originalMatches[replacementData.from]
			end
			
			targetPlatform.replacedMatches = platformData.replacedMatches
			
			if platformData.cutPerSaleOffset then
				targetPlatform.cutPerSale = targetPlatform.originalCutPerSale + platformData.cutPerSaleOffset
			end
			
			targetPlatform.cutPerSaleOffset = platformData.cutPerSaleOffset
			
			if platformData.licenseCostOffset then
				targetPlatform.licenseCost = math.max(platforms.MINIMUM_PLATFORM_COST, targetPlatform.originalLicenseCost + platformData.licenseCostOffset)
			end
			
			targetPlatform.licenseCostOffset = platformData.licenseCostOffset
			targetPlatform.developmentTimeAffector = targetPlatform.originalDevelopmentTimeAffector + platformData.developmentTimeAffectorOffset
			targetPlatform.developmentTimeAffectorOffset = platformData.developmentTimeAffectorOffset
		end
	end
end

function platforms:isPlatformManufacturerAlive(platformID)
	local data = platforms.registeredByID[platformID]
	
	if not data.manufacturer then
		return true
	end
	
	return not consoleManufacturers:hasManufacturerClosedDown(data.manufacturer)
end

function platforms:hasExpired(data)
	local expiryDate = data.expiryDate
	
	if expiryDate then
		local year, month = timeline:getYear(), timeline:getMonth()
		local totalExpiry = 1
		local expiryState = 0
		
		if year == expiryDate.year then
			expiryState = expiryState + 1
			
			if expiryDate.month then
				totalExpiry = totalExpiry + 1
				
				if month >= expiryDate.month then
					expiryState = expiryState + 1
				end
			end
		elseif year > expiryDate.year then
			expiryState = expiryState + 1
		end
		
		if totalExpiry <= expiryState then
			return true
		end
	end
	
	return false
end

function platforms:reachedReleaseTime(data)
	if not data.releaseDate then
		return true
	end
	
	local releaseDate = data.releaseDate
	local year, month = timeline:getYear(), timeline:getMonth()
	local totalRelease = 1
	local releaseState = 0
	
	if year == releaseDate.year then
		if releaseDate.month and month >= releaseDate.month then
			releaseState = releaseState + 1
		end
	elseif year > releaseDate.year then
		releaseState = releaseState + 1
	end
	
	if totalRelease <= releaseState then
		return true
	end
	
	return false
end

function platforms:canBeReleased(data)
	if data.manufacturer and consoleManufacturers:hasManufacturerClosedDown(data.manufacturer) then
		return false
	end
	
	return self:reachedReleaseTime(data) and not self:hasExpired(data)
end

function platforms:shouldExpire(data)
	if not data.manufacturer then
		return false
	end
	
	if platformShare:isPlatformOnShareList(data.id) and self:hasExpired(data) then
		return true
	end
	
	return false
end

function platforms:getPlatformGenreMatch(id, genre)
	local data = platforms.registeredByID[id]
	
	if data.genreMatching then
		return data.genreMatching[genre] or 1
	end
	
	return 1
end

local sortedMatches = {
	positive = {},
	indifferent = {},
	negative = {}
}

function platforms:getSortedMatches(platObj)
	local platformID = platObj:getID()
	
	for key, sublist in pairs(sortedMatches) do
		table.clearArray(sublist)
	end
	
	local matches = platObj:getGenreMatch()
	
	if matches then
		for key, data in ipairs(genres.registered) do
			local genreID = data.id
			
			if platObj.PLAYER or studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.PLATFORM_MATCHING, platformID, genreID, nil) then
				local matchValue = matches[genreID]
				
				if matchValue > 1 then
					sortedMatches.positive[#sortedMatches.positive + 1] = genreID
				elseif matchValue == 1 then
					sortedMatches.indifferent[#sortedMatches.indifferent + 1] = genreID
				else
					sortedMatches.negative[#sortedMatches.negative + 1] = genreID
				end
			end
		end
	end
	
	return sortedMatches.positive, sortedMatches.indifferent, sortedMatches.negative
end

require("game/platform/platform")
require("game/scheduled_events/console_expiration_heads_up")
require("game/platform/pc")
require("game/platform/polystation")
require("game/platform/vertice")
require("game/platform/mintmendo_platforms")
require("game/platform/pos")
require("game/platform/mega")
require("game/platform/agari")
require("game/platform/abacaxi")
require("game/platform/platform_parts")
require("game/platform/player_platform")
require("game/platform/create_platform_task")
