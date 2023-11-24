platform = {}
platform.mtindex = {
	__index = platform
}
platform.MIN_PURCHASING_POWER = 0.4
platform.EXPIRED_ATTRACTIVENESS_MULTIPLIER = 0.25
platform.POST_EXPIRATION_ATTRACTIVENESS_DROP_PER_DAY = 1
platform.MARKET_SATURATION_MAX_GAME_AGE = timeline.MONTHS_IN_YEAR * 5
platform.MARKET_SATURATION_MAX_BOOST = 1.2
platform.MARKET_SATURATION_BASELINE_AFFECTOR = 1
platform.MARKET_SATURATION_MIN_BOOST = 0.6
platform.MARKET_SATURATION_BOOST_CUTOFF = 7
platform.MARKET_SATURATION_PENALTY_CUTOFF = 25
platform.FRUSTRATOR_IAP = "iap"
platform.IAP_FRUSTRATION_THRESHOLD = 1000
platform.IAP_UNFRUSTRATE_THRESHOLD = 200
platform.SALE_MULTIPLIER_FRUSTRATOR = 0.2
platform.WEEKLY_IAP_FRUSTRATION_DROP = 10
platform.PLAYER = false
platform.MAX_PLATFORMS_BEFORE_CROSS_PLATFORM = 2
platform.CROSS_PLATFORM_FEATURE_ID = "cross_platform_support"
platform.SELECTABILITY_STATE = {
	NO_ENGINE_SELECTED = 3,
	CROSS_PLATFORM_MISSING = 2,
	SCALE_TOO_SMALL = 5,
	SELECTABLE = 0,
	MMO_TOO_MANY_PLATFORMS = 6,
	INCOMPLETE_PLATFORM = 7,
	MISSING_FEATURES = 1,
	NOT_IN_BASE_GAME = 4
}
platform.MAX_GAME_AGE = timeline.DAYS_IN_YEAR * 8

function platform.new(id)
	local initID = type(id) == "table" and id.id or id
	local new = {}
	
	setmetatable(new, platform.mtindex)
	new:setID(initID)
	new:init()
	
	return new
end

platform.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_WEEK
}

function platform:init()
	self.purchasingPower = 0
	self.moneyMadeOnPlatform = 0
	self.playerMadeGames = 0
	self.attractiveness = 0
	self.gamesByGenre = {}
	self.gamesByTheme = {}
	self.frustration = {
		[platform.FRUSTRATOR_IAP] = 0
	}
	self.fakeGamesByGenre = {}
	self.fakeGamesByTheme = {}
	
	for key, data in ipairs(genres.registered) do
		self.gamesByGenre[data.id] = 0
		self.fakeGamesByGenre[data.id] = 0
	end
	
	for key, data in ipairs(themes.registered) do
		self.gamesByTheme[data.id] = 0
		self.fakeGamesByTheme[data.id] = 0
	end
	
	self:setMarketShare(0)
	
	self.games = {}
end

function platform:initEventHandler()
	events:addDirectReceiver(self, platform.CATCHABLE_EVENTS)
	events:addFunctionReceiver(self, self.handleNewMonth, timeline.EVENTS.NEW_MONTH)
	self:recalculateGameAttractiveness()
end

function platform:removeEventHandler()
	events:removeDirectReceiver(self, platform.CATCHABLE_EVENTS)
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_MONTH)
end

function platform:handleEvent(event)
	if self.frustration[platform.FRUSTRATOR_IAP] > 0 then
		self.frustration[platform.FRUSTRATOR_IAP] = math.max(0, self.frustration[platform.FRUSTRATOR_IAP] - platform.WEEKLY_IAP_FRUSTRATION_DROP)
		
		if self.frustratedIAP and self.frustration[platform.FRUSTRATOR_IAP] <= platform.IAP_UNFRUSTRATE_THRESHOLD then
			self.frustratedIAP = false
		end
	elseif self.frustratedIAP then
		self.frustratedIAP = false
	end
end

function platform:handleNewMonth()
	self:recalculateGameAttractiveness()
end

function platform:isFrustratedWithMicrotransactions()
	return self.frustratedIAP
end

function platform:changeFrustration(type, amount)
	self.frustration[type] = (self.frustration[type] or 0) + amount
	
	if type == platform.FRUSTRATOR_IAP and not self.frustratedIAP and self.frustration[type] > platform.IAP_FRUSTRATION_THRESHOLD then
		self.frustratedIAP = true
		
		return true
	end
	
	return false
end

function platform:getFrustration(type)
	return self.frustration[type]
end

function platform:getFrustrationMultiplier()
	return self.platformData.frustrationMultiplier
end

function platform:getEngineFeatureRequirements()
	return self.platformData.engineFeatureRequirements
end

function platform:getMaxProjectScale(targetTime)
	return self.platformData:getMaxProjectScale(targetTime)
end

local missingFeatures = {}

function platform:canSelect(gameProj)
	local state, missingFeatures = self:getSelectabilityState(gameProj, true)
	
	return state == platform.SELECTABILITY_STATE.SELECTABLE, missingFeatures
end

function platform:canPirateGames()
	return true
end

function platform:getFrustrationSaleAffector(gameProj)
	if self.frustratedIAP then
		local level = self.frustration[platform.FRUSTRATOR_IAP]
		
		if level > platform.IAP_UNFRUSTRATE_THRESHOLD then
			if level > platform.IAP_FRUSTRATION_THRESHOLD then
				return platform.SALE_MULTIPLIER_FRUSTRATOR
			else
				return math.min(1, math.lerp(1, platform.SALE_MULTIPLIER_FRUSTRATOR, (level - platform.IAP_UNFRUSTRATE_THRESHOLD) / (platform.IAP_FRUSTRATION_THRESHOLD - platform.IAP_UNFRUSTRATE_THRESHOLD)))
			end
		end
	end
	
	return 1
end

function platform:getSelectabilityState(gameProj, skipListFill)
	if gameProj:getPlatformState(self.platformID) then
		return platform.SELECTABILITY_STATE.SELECTABLE, missingFeatures
	end
	
	if not gameProj:isNewGame() and not table.find(gameProj:getSequelTo():getTargetPlatforms(), self.platformID) then
		return platform.SELECTABILITY_STATE.NOT_IN_BASE_GAME
	end
	
	if gameProj:getGameType() == gameProj.DEVELOPMENT_TYPE.MMO and #gameProj:getTargetPlatforms() >= gameProject.MMO_MAX_PLATFORMS then
		return platform.SELECTABILITY_STATE.MMO_TOO_MANY_PLATFORMS
	end
	
	local engineObj = gameProj:getEngine()
	
	if not engineObj then
		return platform.SELECTABILITY_STATE.NO_ENGINE_SELECTED, missingFeatures
	end
	
	if gameProj:getPlatformCount() >= platform.MAX_PLATFORMS_BEFORE_CROSS_PLATFORM and not engineObj:hasFeature(platform.CROSS_PLATFORM_FEATURE_ID) then
		return platform.SELECTABILITY_STATE.CROSS_PLATFORM_MISSING, missingFeatures
	end
	
	local contractData = gameProj:getContractData()
	
	if contractData and contractData:getScale() > self:getMaxProjectScale() then
		return platform.SELECTABILITY_STATE.SCALE_TOO_SMALL
	end
	
	local platData = self.platformData
	
	if platData then
		if not platData.engineFeatureRequirements then
			return platform.SELECTABILITY_STATE.SELECTABLE, missingFeatures
		end
		
		local engineFeatures = gameProj:getEngineRevisionFeatures()
		local canSelect = true
		
		for key, featureID in ipairs(platData.engineFeatureRequirements) do
			if not engineFeatures[featureID] then
				if not skipListFill then
					missingFeatures[#missingFeatures + 1] = featureID
				end
				
				canSelect = false
			end
		end
		
		return canSelect and platform.SELECTABILITY_STATE.SELECTABLE or platform.SELECTABILITY_STATE.MISSING_FEATURES, missingFeatures
	end
	
	return platform.SELECTABILITY_STATE.SELECTABLE, missingFeatures
end

function platform:countFakeGame(fakeGameData)
	local genre, theme = fakeGameData.genre, fakeGameData.theme
	
	self.fakeGamesByGenre[genre] = self.fakeGamesByGenre[genre] + 1
	self.fakeGamesByTheme[theme] = self.fakeGamesByTheme[theme] + 1
	self.gamesByGenre[genre] = self.gamesByGenre[genre] + 1
	self.gamesByTheme[theme] = self.gamesByTheme[theme] + 1
end

function platform:forgetFakeGame(fakeGameData)
	local genre, theme = fakeGameData.genre, fakeGameData.theme
	
	self.fakeGamesByGenre[genre] = self.fakeGamesByGenre[genre] - 1
	self.fakeGamesByTheme[theme] = self.fakeGamesByTheme[theme] - 1
	self.gamesByGenre[genre] = self.gamesByGenre[genre] - 1
	self.gamesByTheme[theme] = self.gamesByTheme[theme] - 1
end

function platform:setID(id)
	self.platformID = id
	
	self:setupPlatformData()
	
	self.manufacturer = consoleManufacturers:getManufacturerByID(self.platformData.manufacturer)
end

function platform:getID()
	return self.platformID
end

function platform:getDisplayQuad()
	return self.platformData:getDisplayQuad()
end

function platform:destroy()
	self:removeEventHandler()
end

function platform:getManufacturer()
	return self.manufacturer
end

function platform:getManufacturerID()
	return self.platformData.manufacturer
end

function platform:getReleaseDate()
	return self.platformData.releaseDate
end

function platform:setupPlatformData()
	self.platformData = platforms.registeredByID[self.platformID]
end

function platform:addGame(game, increaseCounter)
	if increaseCounter and game:getOwner():isPlayer() then
		self.playerMadeGames = self.playerMadeGames + 1
	end
	
	table.insert(self.games, game)
	
	if increaseCounter then
		self:recalculateGameAttractiveness()
	end
end

function platform:getPlayerGames()
	return self.games
end

function platform:getPlayerMadeGames()
	return self.playerMadeGames
end

function platform:getPlatformAttractiveness()
	return self.baseGameAttractiveness
end

function platform:getDefaultAttractiveness()
	return self.platformData.defaultAttractiveness
end

function platform:recalculateGameAttractiveness()
	self.baseGameAttractiveness = 0
	
	local attract = self:getDefaultAttractiveness()
	local time = timeline.curTime
	local maxAge = platform.MAX_GAME_AGE
	local plMult = platformShare.PLAYER_GAMES_ATTRACTIVENESS_MULTIPLIER
	local rivalMult = platformShare.RIVAL_GAMES_ATTRACTIVENESS_MULTIPLIER
	
	for i = #self.games, 1, -1 do
		local gameObj = self.games[i]
		
		if maxAge > time - gameObj:getReleaseDate() then
			if gameObj:getOwner():isPlayer() then
				attract = attract + gameObj:getRealRating() * plMult
			else
				attract = attract + gameObj:getRealRating() * rivalMult
			end
		else
			break
		end
	end
	
	self.baseGameAttractiveness = attract
end

function platform:getPlatformData()
	return self.platformData
end

function platform:getLicenseCost()
	return self.platformData.licenseCost
end

function platform:getName()
	return self.platformData.display
end

function platform:changePurchasingPower(change)
	self.purchasingPower = math.max(math.floor(platform.MIN_PURCHASING_POWER * self.marketShare), math.min(self.purchasingPower + change, self.marketShare))
end

function platform:getPurchasingPower()
	return self.purchasingPower
end

function platform:getPurchasingPowerPercentage()
	return self.purchasingPower / self.marketShare
end

function platform:setMarketShare(amount)
	self.marketShare = amount
	self.purchasingPower = self.marketShare
end

function platform:changeMoneyMade(money)
	self.moneyMadeOnPlatform = self.moneyMadeOnPlatform + money
end

function platform:getMoneyMade()
	return self.moneyMadeOnPlatform
end

function platform:changeMarketShare(amount)
	local oldShare = self.marketShare
	
	self.marketShare = math.clamp(self.marketShare + amount, 0, math.huge)
	
	self:changePurchasingPower(amount)
	
	local shareDifference = self.marketShare - oldShare
	
	platformShare:onChange(self, shareDifference)
end

function platform:removeMarketSaturation()
	local byGenre, byTheme = self.gamesByGenre, self.gamesByTheme
	
	for key, data in ipairs(genres.registered) do
		if byGenre[data.id] > 0 then
			platformShare:changeGamesByGenre(data.id, -byGenre[data.id])
			
			byGenre[data.id] = 0
		end
	end
	
	for key, data in ipairs(themes.registered) do
		if byTheme[data.id] > 0 then
			platformShare:changeGamesByTheme(data.id, -byTheme[data.id])
			
			byTheme[data.id] = 0
		end
	end
end

function platform:addShareToManufacturer()
	self.manufacturer:changeHealth(self.marketShare)
end

function platform:setupMarketSaturation()
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
	
	local byid = genres.registeredByID
	
	for genreID, amount in pairs(self.fakeGamesByGenre) do
		if byid[genreID] then
			local val = byGenre[genreID] + amount
			
			byGenre[genreID] = val
			
			platformShare:changeGamesByGenre(genreID, val)
		else
			print(_format("WARNING: non-existent genre with ID 'GENRE'. Removing its fake game genre data.", "GENRE", genreID))
			
			self.fakeGamesByGenre[genreID] = nil
		end
	end
	
	local byid = themes.registeredByID
	
	for themeID, amount in pairs(self.fakeGamesByTheme) do
		if byid[themeID] then
			local val = byTheme[themeID] + amount
			
			byTheme[themeID] = val
			
			platformShare:changeGamesByTheme(themeID, val)
		else
			print(_format("WARNING: non-existent theme with ID 'THEME'. Removing its fake game genre data.", "THEME", themeID))
			
			self.fakeGamesByTheme[themeID] = nil
		end
	end
end

local mostSaturated = {}
local currentSaturationList

local function sortBySaturation(a, b)
	return currentSaturationList[a] > currentSaturationList[b]
end

function platform:getThreeMostSaturated(list)
	currentSaturationList = list
	
	table.clear(mostSaturated)
	
	for id, gameCount in pairs(list) do
		if gameCount > platform.MARKET_SATURATION_BOOST_CUTOFF then
			mostSaturated[#mostSaturated + 1] = id
		end
	end
	
	table.sort(mostSaturated, sortBySaturation)
	
	currentSaturationList = nil
	
	if #mostSaturated > 3 then
		for i = 3, #mostSaturated do
			mostSaturated[i] = nil
		end
	end
	
	return mostSaturated
end

function platform:getMarketSaturation()
	return self.gamesByGenre, self.gamesByTheme
end

function platform:getCutPerSale(gameProj)
	if not self.manufacturer:isExclusivityBonusActive() or not gameProj then
		return self.platformData.cutPerSale, nil
	end
	
	local offset = 0
	
	if gameProj:getManufacturerConsoleCount(self.manufacturer:getID()) == 0 then
		offset = 1
	end
	
	local exclusivityType = consoleManufacturers:getExclusivityType(gameProj:getManufacturerCount() + offset)
	local cut = self.platformData.cutPerSale
	
	if exclusivityType == consoleManufacturers.EXCLUSIVITY_TYPE.FULL then
		cut = cut * self.manufacturer:getData().fullExclusivityCutReduction
	elseif exclusivityType == consoleManufacturers.EXCLUSIVITY_TYPE.PARTIAL then
		cut = cut * self.manufacturer:getData().partialExclusivityCutReduction
	end
	
	return cut, exclusivityType
end

function platform:getDevelopmentDifficulty()
	return self.platformData.developmentTimeAffector
end

function platform:setupDescbox(descbox, wrapWidth, gameProj, skipManufacturerInfo)
	local platformData = self.platformData
	local requiresSpace = false
	local playerPlat = self.PLAYER
	
	if not playerPlat and platformData.expiryDate then
		local expirationText
		local hasExpired = platforms:hasExpired(platformData)
		
		if hasExpired then
			expirationText = _format(_T("PLATFORM_NOT_SUPPORTED", "This platform is not supported by the manufacturer as of YEAR/MONTH."), "YEAR", platformData.expiryDate.year, "MONTH", platformData.expiryDate.month or 1)
		elseif self.showExpirationTime then
			expirationText = _format(_T("PLATFORM_NOT_SUPPORTED_NOTIFIED", "This platform will stop being supported by the manufacturer in YEAR/MONTH."), "YEAR", platformData.expiryDate.year, "MONTH", platformData.expiryDate.month or 1)
		end
		
		if expirationText then
			descbox:addText(expirationText, "bh18", game.UI_COLORS.RED, 4, wrapWidth)
			
			requiresSpace = true
		end
		
		if hasExpired then
			descbox:addText(_format(_T("PLATFORM_WILL_GO_OFFMARKET", "It will go off-market in TIME."), "TIME", timeline:getTimePeriodText(self:getOffMarketTime() - timeline.curTime)), "bh16", nil, 0, wrapWidth, "question_mark", 20, 20)
			
			requiresSpace = true
		end
	end
	
	if requiresSpace then
		descbox:addSpaceToNextText(10)
	end
	
	descbox:addText(_T("PLATFORM_INFO", "Platform info"), "bh22", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 6, 320)
	
	if self.frustratedIAP then
		descbox:addText(_T("FRUSTRATED_WITH_MICROTRANSACTIONS", "Frustrated with microtransactions"), "bh18", game.UI_COLORS.LIGHT_RED, 0, 320, "frustrated", 22, 22)
	end
	
	if not playerPlat or playerPlat and self.released then
		descbox:addText(_format(_T("MARKET_SHARE", "Market share: PERCENTAGE% (USERS users)"), "PERCENTAGE", math.round(self:getMarketSharePercentage() * 100, 1), "USERS", string.roundtobignumber(self:getMarketShare())), "pix18", nil, 0, 320, "trait_extraverted", 24, 24)
		descbox:addText(_format(_T("PLATFORM_POPULARITY", "Popularity: ATTRACTIVENESSPP"), "ATTRACTIVENESS", string.comma(self.attractiveness)), "pix18", nil, 0, 320, "star", 22, 22)
		descbox:addText(_format(_T("PLATFORM_PURCHASING_POWER", "User purchasing power: POWER%"), "POWER", math.round(math.max(0, self.purchasingPower / self.marketShare) * 100, 1)), "pix18", nil, 0, 320, "percentage", 22, 22)
	end
	
	descbox:addText(_format(_T("PLATFORM_DEVELOPMENT_DIFFICULTY", "Development difficulty: DIFF%"), "DIFF", math.round(self:getDevelopmentDifficulty() * 100, 1)), "pix18", nil, 0, 320, "platform_dev_difficulty", 22, 22)
	descbox:addText(_format(_T("MAX_PLATFORM_PROJECT_SCALE", "Max project scale: xSCALE"), "SCALE", self:getMaxProjectScale()), "pix18", nil, 0, 320, "project_stuff", 22, 22)
	
	if not self.PLAYER then
		local cutPerSale, exclusivityType = self:getCutPerSale(gameProj)
		
		descbox:addText(_format(_T("MANUFACTURERS_SHARE", "Their share per sale: SHARE%"), "SHARE", math.round(cutPerSale * 100, 1), "USERS", string.roundtobignumber(self:getMarketShare())), "bh18", nil, 4, 320, "wad_of_cash_minus", 22, 22)
		
		if exclusivityType and self.platformData.cutPerSale ~= 0 then
			local text, icon = consoleManufacturers:getExclusivityTypeText(exclusivityType)
			
			descbox:addText(text, "bh18", game.UI_COLORS.LIGHT_BLUE, 4, 320, icon, 20, 20)
		end
	end
	
	if playerPlat or studio:hasPlatformLicense(self:getID()) then
		descbox:addText(_format(_T("MONEY_MADE_ON_PLATFORM", "Money made on platform: MONEY"), "MONEY", string.roundtobigcashnumber(self:getMoneyMade())), "pix18", nil, 0, 320, "wad_of_cash_plus", 22, 22)
		descbox:addText(_format(_T("GAMES_MADE_FOR_PLATFORM", "Games made for platform: GAMES"), "GAMES", self.playerMadeGames), "pix18", nil, 0, 320)
	end
	
	if not skipManufacturerInfo and not self.PLAYER then
		descbox:addSpaceToNextText(10)
		descbox:addText(_T("MANUFACTURER_INFO", "Manufacturer info"), "bh22", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 6, 400)
		descbox:addText(_format(_T("MANUFACTURER_NAME", "Name: MANUFACTURER"), "MANUFACTURER", self.manufacturer:getName()), "pix18", nil, 6, 400)
		descbox:addText(_format(_T("MANUFACTURER_MARKET_SHARE", "Market share: SHARE%"), "SHARE", math.round(self.manufacturer:getHealth() / platformShare:getTotalUsers() * 100, 1)), "bh18", nil, 0, 400, "percentage", 24, 24)
		
		local text, color = self.manufacturer:getHitpointsText()
		
		descbox:addText(_format(_T("MANUFACTURER_HEALTH", "Health: HITPOINTS (LEVELHP)"), "HITPOINTS", text, "LEVEL", self.manufacturer:getHitpoints()), "bh18", color, 0, 400)
	end
	
	local genreList, themeList = self:getMarketSaturation()
	local threeMostSaturated = self:getThreeMostSaturated(genreList)
	
	if #threeMostSaturated > 0 then
		descbox:addSpaceToNextText(6)
		descbox:addText(_T("THREE_MOST_SATURATED_GENRES", "Most saturated genres"), "bh20", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 0, 320)
		
		for key, genreID in ipairs(threeMostSaturated) do
			local gameCount = genreList[genreID]
			
			if gameCount == 1 then
				descbox:addText(_format(_T("GENRE_ONE_GAME", "GENRE - 1 game"), "GENRE", genres.registeredByID[genreID].display), "pix18", nil, 0, 320)
			else
				descbox:addText(_format(_T("GENRE_GAME_COUNT", "GENRE - GAMES games"), "GENRE", genres.registeredByID[genreID].display, "GAMES", gameCount), "pix18", nil, 0, 320)
			end
		end
	end
	
	local threeMostSaturated = self:getThreeMostSaturated(themeList)
	
	if #threeMostSaturated > 0 then
		descbox:addSpaceToNextText(6)
		descbox:addText(_T("THREE_MOST_SATURATED_THEMES", "Most saturated themes"), "bh20", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 0, 320)
		
		for key, genreID in ipairs(threeMostSaturated) do
			local gameCount = themeList[genreID]
			
			if gameCount == 1 then
				descbox:addText(_format(_T("THEME_ONE_GAME", "GENRE - 1 game"), "GENRE", themes.registeredByID[genreID].display), "pix18", nil, 0, 320)
			else
				descbox:addText(_format(_T("THEME_GAME_COUNT", "GENRE - GAMES games"), "GENRE", themes.registeredByID[genreID].display, "GAMES", gameCount), "pix18", nil, 0, 320)
			end
		end
	end
end

function platform:fillMatchingDescbox(descbox)
	descbox:addText(_T("GENRE_PLATFORM_MATCHING", "Genre-platform matching"), "bh22", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, 400)
	
	local goodMatch, avgMatch, badMatch = platforms:getSortedMatches(self)
	local addedGood = self:addMatchDisplay(descbox, goodMatch, _T("GOOD_PLATFORM_MATCHES", "Good match:"), nil, nil, "increase")
	local addedAvg = self:addMatchDisplay(descbox, avgMatch, _T("AVERAGE_PLATFORM_MATCHES", "Average match:"), nil, addedGood > 0 and 5, "tilde_yellow")
	local addedBad = self:addMatchDisplay(descbox, badMatch, _T("BAD_PLATFORM_MATCHES", "Bad match:"), nil, (addedAvg > 0 or addedGood > 0) and 5, "decrease_red")
	
	if addedGood == 0 and addedAvg == 0 and addedBad == 0 then
		descbox:addText(_T("NONE_KNOWN_YET", "None known yet"), "bh20", nil, 0, 400)
	end
end

function platform:getGenreMatch()
	return self.platformData.genreMatching
end

function platform:getCutPerSale()
	return self.platformData.cutPerSale
end

function platform:addMatchDisplay(descbox, matchList, header, headerColor, spacing, icon)
	local added = 0
	
	if #matchList > 0 then
		if spacing then
			descbox:addSpaceToNextText(spacing)
		end
		
		descbox:addText(header, "bh18", headerColor, 4, 400, icon, 20, 20)
	end
	
	local matchData = self:getGenreMatch()
	
	for key, genreID in ipairs(matchList) do
		local genreData = genres.registeredByID[genreID]
		local match = matchData[genreData.id]
		local contributionSign, textColor = game.getContributionSign(1, match, 0.25, 3, nil, nil, false)
		
		descbox:addText(_format(_T("GENRE_AUDIENCE_CONTRIBUTION_LAYOUT", "CONTRIBUTION GENRE"), "CONTRIBUTION", contributionSign, "GENRE", genreData.display), "pix18", textColor or game.UI_COLORS.IMPORTANT_1, 0, 400, genres:getGenreUIIconConfig(genreData, 24, 24, 20))
		
		added = added + 1
	end
	
	return added
end

function platform:getMarketSaturationSaleAffector(gameProj)
	local theme, genre = gameProj:getTheme(), gameProj:getGenre()
	local totalGames = self.gamesByGenre[genre] + self.gamesByTheme[theme] - 2
	local cutoff = platform.MARKET_SATURATION_BOOST_CUTOFF
	
	if totalGames <= cutoff then
		return math.lerp(platform.MARKET_SATURATION_MAX_BOOST, platform.MARKET_SATURATION_BASELINE_AFFECTOR, totalGames / cutoff)
	else
		local penaltyCutoff = platform.MARKET_SATURATION_PENALTY_CUTOFF
		
		if totalGames < penaltyCutoff then
			return math.lerp(platform.MARKET_SATURATION_BASELINE_AFFECTOR, platform.MARKET_SATURATION_MIN_BOOST, (totalGames - cutoff) / (penaltyCutoff - cutoff))
		end
	end
	
	return platform.MARKET_SATURATION_MIN_BOOST
end

function platform:getMarketShare()
	return self.marketShare
end

function platform:expire()
	self.expired = true
	self.expirationDate = timeline.curTime
end

function platform:goOffMarket()
	self.offMarket = true
	
	self:removeMarketSaturation()
	self:removeEventHandler()
end

function platform:isOffMarket()
	return self.offMarket
end

function platform:getOffMarketTime()
	local expiry = self.platformData.expiryDate
	
	return timeline:getDateTime(expiry.year, expiry.month) + self.platformData.postExpireOnMarketTime
end

function platform:shouldBeOnMarket()
	local expiry = self.platformData.expiryDate
	
	return timeline.curTime < self:getOffMarketTime()
end

function platform:getExpirationDate()
	return self.expirationDate
end

function platform:getTimeSinceExpiration()
	return timeline.curTime - self.expirationDate
end

function platform:hasExpired()
	return self.expired
end

function platform:getPlatformAttractivenessMultiplier()
	return self.expired and platform.EXPIRED_ATTRACTIVENESS_MULTIPLIER or 1
end

function platform:setAttractiveness(attractiveness)
	self.attractiveness = attractiveness
end

function platform:getAttractiveness()
	return self.attractiveness
end

function platform.purchaseLicenseCallback(element)
	local cost = element.platform:getLicenseCost()
	
	if studio:hasFunds(cost) then
		studio:purchasePlatformLicense(element.platform:getID())
	else
		local popup = gui.create("Popup")
		
		popup:setWidth(500)
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(_T("NOT_ENOUGH_MONEY_TITLE", "Not Enough Money"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setText(_T("CANT_PURCHASE_PLATFORM_LICENSE_NO_MONEY", "Can not make purchase of platform license due to a lack of funds."))
		popup:center()
		popup:addOKButton()
		frameController:push(popup)
	end
end

function platform:fillInteractionComboBox(combobox)
	if not studio:hasPlatformLicense(self.platformID) then
		local option = combobox:addOption(0, 0, 0, 24, string.easyformatbykeys(_T("PURCHASE_PLATFORM_LICENSE", "Purchase PLATFORM_NAME for $PLATFORM_COST"), "PLATFORM_NAME", self:getName(), "PLATFORM_COST", self:getLicenseCost()), fonts.get("pix20"), platform.purchaseLicenseCallback)
		
		option.platform = self
	end
end

function platform:setMarketSharePercentage(perc)
	self.marketSharePercentage = perc
end

function platform:getMarketSharePercentage()
	return self.marketSharePercentage
end

function platform:getStartingFakeGames()
	return self.platformData.startingFakeGames
end

function platform:save()
	return {
		marketShare = self.marketShare,
		purchasingPower = self.purchasingPower,
		platformID = self.platformID,
		expired = self.expired,
		offMarket = self.offMarket,
		expirationDate = self.expirationDate,
		moneyMadeOnPlatform = self.moneyMadeOnPlatform,
		fakeGamesByGenre = self.fakeGamesByGenre,
		fakeGamesByTheme = self.fakeGamesByTheme,
		attractiveness = self.attractiveness,
		playerMadeGames = self.playerMadeGames,
		showExpirationTime = self.showExpirationTime,
		frustration = self.frustration,
		frustratedIAP = self.frustratedIAP
	}
end

function platform:load(data)
	self.marketShare = data.marketShare
	self.purchasingPower = data.purchasingPower or self.purchasingPower
	self.expired = data.expired
	self.offMarket = data.offMarket
	self.expirationDate = data.expirationDate
	self.moneyMadeOnPlatform = data.moneyMadeOnPlatform or self.moneyMadeOnPlatform
	self.fakeGamesByGenre = data.fakeGamesByGenre or self.fakeGamesByGenre
	self.fakeGamesByTheme = data.fakeGamesByTheme or self.fakeGamesByTheme
	self.attractiveness = data.attractiveness or self.attractiveness
	self.playerMadeGames = data.playerMadeGames or self.playerMadeGames
	self.showExpirationTime = data.showExpirationTime
	self.frustration = data.frustration or self.frustration
	self.frustratedIAP = data.frustratedIAP
	
	if self.expired and not self.platformData.expiryDate then
		self.expired = false
	end
	
	for key, data in ipairs(genres.registered) do
		self.fakeGamesByGenre[data.id] = self.fakeGamesByGenre[data.id] or 0
	end
	
	for key, data in ipairs(themes.registered) do
		self.fakeGamesByTheme[data.id] = self.fakeGamesByTheme[data.id] or 0
	end
end

function platform:postLoad()
	if not self.offMarket then
		self:recalculateGameAttractiveness()
	end
end
