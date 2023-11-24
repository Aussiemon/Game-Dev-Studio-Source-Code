platformShare = {}
platformShare.allPlatforms = {}
platformShare.allPlatformsByID = {}
platformShare.attractivePlatforms = {}
platformShare.attractivenessByPlatforms = {}
platformShare.onMarketPlatforms = {}
platformShare.onMarketPlatformsByID = {}
platformShare.EVENTS = {
	SHARE_CHANGED = events:new(),
	NEW_PLATFORM = events:new(),
	PLATFORM_REMOVED = events:new()
}
platformShare.DEFAULT_PLATFORMS = {
	"pc"
}
platformShare.STARTING_SHARE = 200000
platformShare.DAILY_SHARE_INCREASE_MULTIPLIER = 0.5
platformShare.ATTRACTIVENESS_PERCENTAGE_TO_SWITCH_TO_OTHER_PLATFORM = 0.15
platformShare.MAX_SWITCH_PER_SHARE = 0.01
platformShare.EXPIRED_PLATFORM_ATTRACTIVENESS_MULTIPLIER = 0.3
platformShare.USER_DELTA_TO_PURCHASERS = 0.15
platformShare.PURCHASING_POWER_LOSS_PER_SALE = 1
platformShare.PURCHASING_POWER_REGAIN_PER_DAY = 0.005
platformShare.AMOUNT_OF_FAKE_GAMES_TO_MAKE = {
	1,
	2
}
platformShare.MONTHLY_FAKE_GAME_RELEASE_CHANCE = 90
platformShare.MAX_FAKE_GAMES_ON_RECORD = 80
platformShare.SANITISE_OLD_GAMES_ON_RECORD_TIME = timeline.DAYS_IN_MONTH * 9
platformShare.FAKE_GAME_CREATION_ON_PLATFORM_CREATION = 10
platformShare.PLAYER_GAMES_ATTRACTIVENESS_MULTIPLIER = 5
platformShare.RIVAL_GAMES_ATTRACTIVENESS_MULTIPLIER = 2
platformShare.FAKE_GAMES_TO_TOTAL_ATTRACTIVENESS = 0.2
platformShare.MAX_NEW_USERS_PER_DAY = 300
platformShare.MAX_TOTAL_PLATFORM_USERS = 2500000000

function platformShare:init()
	self.totalUsers = platformShare.STARTING_SHARE
	self.platformUsers = 0
	self.fakeGames = {}
	self.totalPlatformAttractiveness = {}
	self.gamesByGenre = {}
	self.gamesByTheme = {}
	self.fakeGameRecipients = {}
	self.userChangeDelta = 0
	
	for key, genreData in ipairs(genres.registered) do
		self.gamesByGenre[genreData.id] = 0
	end
	
	for key, themeData in ipairs(themes.registered) do
		self.gamesByTheme[themeData.id] = 0
	end
	
	events:addDirectReceiver(self, platformShare.CATCHABLE_EVENTS)
end

function platformShare:setTotalUsers(users)
	self.totalUsers = users
end

function platformShare:onNewGame()
	self.totalUsers = self.totalUsers + game.curGametype:getStartingYearExtraUsers(timeline:getYear())
	
	self:initDefaultPlatforms()
	self:recalculateSharePercentages()
end

platformShare.PLATFORMS_PER_ON_MARKET_PLATFORMS = 3
platformShare.SCORE_RANGE_WEIGHT_SUM = 0
platformShare.SCORE_RANGES = {}

function platformShare:addRatingRange(data)
	table.insert(platformShare.SCORE_RANGES, data)
	
	platformShare.SCORE_RANGE_WEIGHT_SUM = platformShare.SCORE_RANGE_WEIGHT_SUM + data.weight
end

platformShare:addRatingRange({
	min = 1,
	weight = 5,
	max = 3
})
platformShare:addRatingRange({
	min = 4,
	weight = 10,
	max = 5
})
platformShare:addRatingRange({
	min = 6,
	weight = 20,
	max = 7
})
platformShare:addRatingRange({
	min = 8,
	weight = 10,
	max = 8
})
platformShare:addRatingRange({
	min = 9,
	weight = 6,
	max = 9
})
platformShare:addRatingRange({
	min = 10,
	weight = 2,
	max = 10
})

function platformShare:getRandomFakeGameRating()
	local section = math.random(1, platformShare.SCORE_RANGE_WEIGHT_SUM)
	local curWeight = 0
	local finalRange
	
	for key, data in ipairs(platformShare.SCORE_RANGES) do
		curWeight = curWeight + data.weight
		
		if section <= curWeight then
			finalRange = data
			
			break
		end
	end
	
	return math.random(finalRange.min, finalRange.max)
end

function platformShare:createFakeGameStruct(rating)
	rating = rating or self:getRandomFakeGameRating()
	
	local themes, genres = themes.registered, genres.registered
	local gameData = {
		platforms = {},
		rating = rating,
		time = timeline.curTime,
		theme = themes[math.random(1, #themes)].id,
		genre = genres[math.random(1, #genres)].id
	}
	
	return gameData
end

function platformShare:createFakeGame(specificPlatform)
	local gameData = self:createFakeGameStruct()
	local recipients = self.fakeGameRecipients
	
	self:addPlatformToList(recipients[math.random(1, #recipients)], gameData)
	
	if specificPlatform then
		self:addPlatformToList(specificPlatform, gameData)
	end
	
	local platforms = math.ceil(#recipients / platformShare.PLATFORMS_PER_ON_MARKET_PLATFORMS) - 1
	
	if platforms > 0 then
		for i = 1, platforms do
			self:addPlatformToList(recipients[math.random(1, #recipients)], gameData)
		end
	end
	
	return gameData
end

function platformShare:removeManufacturerPlatforms(manufacturerID)
	local curIndex = 1
	local onMarket = self.onMarketPlatforms
	
	for i = 1, #onMarket do
		local platformObj = onMarket[curIndex]
		
		if platformObj:getManufacturerID() == manufacturerID then
			table.remove(onMarket, curIndex)
			table.removeObject(self.fakeGameRecipients, platformObj)
		else
			curIndex = curIndex + 1
		end
	end
end

function platformShare:addPlatformToList(platformObj, fakeGameData)
	local id = platformObj:getID()
	
	if not fakeGameData.platforms[id] then
		platformObj:countFakeGame(fakeGameData)
		
		fakeGameData.platforms[id] = true
		self.totalPlatformAttractiveness[id] = (self.totalPlatformAttractiveness[id] or 0) + fakeGameData.rating
	end
end

function platformShare:getBasePlatformAttractiveness(id)
	return self.totalPlatformAttractiveness[id] or 0
end

function platformShare:changePlatformAttractiveness(id, change)
	self.totalPlatformAttractiveness[id] = self.totalPlatformAttractiveness[id] + change
end

function platformShare:attemptMakeFakeGame(specificPlatform)
	for i = 1, math.random(platformShare.AMOUNT_OF_FAKE_GAMES_TO_MAKE[1], platformShare.AMOUNT_OF_FAKE_GAMES_TO_MAKE[2]) do
		self.fakeGames[#self.fakeGames + 1] = self:createFakeGame(specificPlatform)
	end
end

function platformShare:onFakeGameRemoved(fakeGameData)
	local attr = fakeGameData.rating
	local map = self.totalPlatformAttractiveness
	local platMap = self.allPlatformsByID
	
	for id, state in pairs(fakeGameData.platforms) do
		platMap[id]:forgetFakeGame(fakeGameData)
		
		map[id] = map[id] - attr
	end
end

function platformShare:removeOldFakeGames()
	local fakeGames = self.fakeGames
	
	while #fakeGames > platformShare.MAX_FAKE_GAMES_ON_RECORD do
		self:onFakeGameRemoved(fakeGames[#fakeGames])
		
		fakeGames[#fakeGames] = nil
	end
	
	local curIndex = 1
	
	for i = 1, #fakeGames do
		local fakeGame = fakeGames[curIndex]
		
		if fakeGame.time + platformShare.SANITISE_OLD_GAMES_ON_RECORD_TIME < timeline.curTime then
			self:onFakeGameRemoved(fakeGame)
			table.remove(fakeGames, curIndex)
		else
			curIndex = curIndex + 1
		end
	end
end

function platformShare:destroy()
	for key, platformObj in ipairs(self.allPlatforms) do
		platformObj:destroy()
		
		self.allPlatforms[key] = nil
	end
	
	events:removeDirectReceiver(self, platformShare.CATCHABLE_EVENTS)
	table.clear(self.onMarketPlatforms)
	table.clear(self.onMarketPlatformsByID)
	table.clear(self.allPlatformsByID)
	table.clearArray(self.fakeGameRecipients)
end

function platformShare:initDefaultPlatforms()
	for key, platformID in ipairs(platformShare.DEFAULT_PLATFORMS) do
		studio:purchasePlatformLicense(platformID, true)
		rivalGameCompanies:addPlatformOwnership(platformID)
		
		if not self:getPlatformByID(platformID) then
			local platformObj = self:initPlatformByID(platformID)
			
			self:addPlatformToShareList(platformObj)
		end
	end
	
	local startingShare = self.totalUsers
	local buffer = startingShare
	
	for key, platformObj in ipairs(self.allPlatforms) do
		local platformData = platformObj:getPlatformData()
		local amountToGrab = math.min(buffer, math.ceil(startingShare * platformData.startingSharePercentage))
		
		if amountToGrab > 0 then
			platformObj:setMarketShare(amountToGrab)
			
			buffer = buffer - amountToGrab
		else
			break
		end
	end
end

function platformShare:isPlatformOnShareList(platformID)
	return self.onMarketPlatformsByID[platformID] ~= nil
end

function platformShare:getPlatformOwners(platformID)
	if not self.onMarketPlatformsByID[platformID] then
		return 0
	end
	
	return self.onMarketPlatformsByID[platformID]:getMarketShare()
end

function platformShare:getMultiplePlatformOwners(...)
	local totalUsers = 0
	
	for i = 1, select("#", ...) do
		local cur = select(i, ...)
		
		if type(cur) == "table" then
			for key, platformID in ipairs(cur) do
				totalUsers = totalUsers + self:getPlatformOwners(platformID)
			end
		else
			totalUsers = totalUsers + self:getPlatformOwners(cur)
		end
	end
	
	return totalUsers
end

function platformShare:getOnMarketPlatforms()
	return self.onMarketPlatforms
end

function platformShare:getMaxGameScale()
	local max = 0
	
	for key, platformObj in ipairs(self.onMarketPlatforms) do
		max = math.max(max, platformObj:getMaxProjectScale())
	end
	
	return max
end

function platformShare:changeGamesByGenre(genreID, change)
	self.gamesByGenre[genreID] = self.gamesByGenre[genreID] + change
end

function platformShare:changeGamesByTheme(themeID, change)
	self.gamesByTheme[themeID] = self.gamesByTheme[themeID] + change
end

function platformShare:addGameToPlatform(platformID, gameObj, increaseCounter, recalculateAttract)
	local platformObject = self.onMarketPlatformsByID[platformID]
	
	if platformObject then
		platformObject:addGame(gameObj, increaseCounter)
		platformObject:setupMarketSaturation()
		
		if recalculateAttract then
			platformObject:recalculateGameAttractiveness()
		end
		
		return true
	end
	
	return false
end

function platformShare:getMarketSaturation()
	return self.gamesByGenre, self.gamesByTheme
end

function platformShare:updateAttractiveness()
	local attr = 0
	local totalAttr = self.totalPlatformAttractiveness
	local idx = 1
	local regain = platformShare.PURCHASING_POWER_REGAIN_PER_DAY
	
	for key, somePlatform in ipairs(self.onMarketPlatforms) do
		local id = somePlatform:getID()
		local attractiveness = (somePlatform:getPlatformAttractiveness() + (totalAttr[id] or 0)) * somePlatform:getPlatformAttractivenessMultiplier()
		
		if not somePlatform.PLAYER then
			if somePlatform:hasExpired() then
				attractiveness = attractiveness * platformShare.EXPIRED_PLATFORM_ATTRACTIVENESS_MULTIPLIER
			end
			
			local manufacturer = somePlatform:getManufacturer()
			
			if timeline.curTime < manufacturer:getAdvertisementDuration() then
				local target = manufacturer:getAdvertisementTarget()
				
				if target == id then
					attractiveness = attractiveness * manufacturer:getAdvertisementMultiplier()
				end
			end
			
			attr = attr + attractiveness
		end
		
		somePlatform:setAttractiveness(attractiveness)
		somePlatform:changePurchasingPower(somePlatform:getMarketShare() * regain)
	end
	
	self.totalAttractiveness = attr
end

platformShare.fakeGameAttractiveness = {}
platformShare.SWITCH_DIVIDER_MULTIPLIER = 3
platformShare.BASE_SWITCH_AMOUNT = 10000

function platformShare:handleEvent(event, ...)
	if event == timeline.EVENTS.NEW_MONTH then
		self:removeExpiredPlatforms()
		self:attemptMakeFakeGame()
		self:removeOldFakeGames()
	elseif event == timeline.EVENTS.NEW_DAY then
		self:updateAttractiveness()
		
		local userDelta = self.totalUsers - self.platformUsers
		local newPeople = math.ceil(math.min(platformShare.MAX_TOTAL_PLATFORM_USERS - self.totalUsers, platformShare.MAX_NEW_USERS_PER_DAY, math.ceil(timeline.curTime * platformShare.DAILY_SHARE_INCREASE_MULTIPLIER)) + math.max(0, math.ceil(userDelta * platformShare.USER_DELTA_TO_PURCHASERS)))
		local index = 1
		local peoplePool = newPeople + userDelta
		local attr = self.totalAttractiveness
		local attrPlatforms = self.attractivePlatforms
		local platList = self.onMarketPlatforms
		
		while true do
			local platform = platList[index]
			
			if platform and peoplePool > 0 then
				if not platform.PLAYER then
					local attractiveness = platform:getAttractiveness()
					
					if attractiveness > 0 then
						local desiredAmount = math.round(newPeople * (attractiveness / attr))
						local availablePeople = math.min(peoplePool, desiredAmount)
						
						if availablePeople > 0 then
							index = index + 1
							
							platform:changeMarketShare(availablePeople)
							
							peoplePool = peoplePool - availablePeople
						else
							break
						end
					else
						index = index + 1
					end
				else
					index = index + 1
				end
			else
				break
			end
		end
	elseif event == timeline.EVENTS.NEW_WEEK then
		local attrPercToSwitch = platformShare.ATTRACTIVENESS_PERCENTAGE_TO_SWITCH_TO_OTHER_PLATFORM
		local maxSwitchPerShare = platformShare.MAX_SWITCH_PER_SHARE
		local percOfNew = playerPlatform.PERCENTAGE_OF_SWITCHES_TO_SALES
		local attr = self.totalAttractiveness
		local onMarket = self.onMarketPlatforms
		local mult = platformShare.SWITCH_DIVIDER_MULTIPLIER
		local maxSwitchPlayer = (platformShare.BASE_SWITCH_AMOUNT + studio:getReputation()) / #onMarket
		
		for key, platformObj in ipairs(onMarket) do
			local percentage = platformObj:getAttractiveness() / attr
			local salePool = 0
			local ply = platformObj.PLAYER
			
			if ply then
				salePool = platformObj:getSales() - platformObj:getMarketShare()
			end
			
			for key, otherPlatform in ipairs(onMarket) do
				if platformObj ~= otherPlatform then
					local theirPercentage = otherPlatform:getAttractiveness() / attr
					local delta = percentage - theirPercentage
					
					if attrPercToSwitch <= delta then
						local theirShare = otherPlatform:getMarketShare()
						local max = math.ceil(theirShare * maxSwitchPerShare)
						local switchedPeople = math.ceil(max * delta)
						
						if ply then
							switchedPeople = math.min(maxSwitchPlayer, switchedPeople)
							
							if salePool > 0 then
								local switch = math.min(salePool, math.floor(platformObj:modulateSales(math.floor(switchedPeople * percOfNew), mult)))
								
								if switch > 0 then
									salePool = salePool - switch
									switchedPeople = switchedPeople - switch
									
									platformObj:changePotentialSales(switch)
								end
								
								platformObj:changeMarketShare(switchedPeople)
							else
								switchedPeople = math.floor(platformObj:modulateSales(switchedPeople, mult))
								
								platformObj:changePotentialSales(switchedPeople)
							end
							
							otherPlatform:changeMarketShare(-switchedPeople)
						else
							platformObj:changeMarketShare(switchedPeople)
							otherPlatform:changeMarketShare(-switchedPeople)
						end
					end
				end
			end
		end
	end
	
	if self.changedMarketShare then
		self:recalculateSharePercentages()
		
		self.changedMarketShare = nil
	end
	
	consoleManufacturers:handleEvent(event, ...)
end

function platformShare:validatePlatforms()
	self:removeExpiredPlatforms()
end

function platformShare:getFreeShare()
	local totalAssigned = 0
	
	for key, platformObj in ipairs(self.allPlatforms) do
		totalAssigned = totalAssigned + platformObj:getMarketShare()
	end
	
	return self.totalUsers - totalAssigned
end

function platformShare:releaseUnreleasedPlatforms()
	for key, data in ipairs(platforms.registered) do
		if not self.onMarketPlatformsByID[data.id] and platforms:canBeReleased(data) then
			local platformObj = self:initPlatform(data)
			
			self:addPlatformToShareList(platformObj)
		end
	end
end

function platformShare:removeExpiredPlatforms()
	local curPos = 1
	
	for i = 1, #self.onMarketPlatforms do
		local curPlatform = self.onMarketPlatforms[curPos]
		
		if not curPlatform.PLAYER then
			local platData = curPlatform:getPlatformData()
			
			if not curPlatform:hasExpired() then
				if platforms:shouldExpire(platData) then
					curPlatform:expire()
					self:createPlatformExpiryPopup(platData)
				end
				
				curPos = curPos + 1
			elseif not curPlatform:shouldBeOnMarket() then
				self:removePlatformFromShareList(curPlatform, curPos)
				curPlatform:goOffMarket()
			else
				curPos = curPos + 1
			end
		end
	end
end

function platformShare:referencePlatformID(platID, obj)
	self.allPlatformsByID[platID] = obj
end

function platformShare:dereferencePlatformID(platID)
	self.allPlatformsByID[platID] = nil
end

function platformShare:initPlatformByID(id, noShareActions)
	local platformObj = platform.new(id)
	local platformData = platformObj:getPlatformData()
	
	if not noShareActions and platformData.startingSharePercentage then
		local totalUsers = self.totalUsers
		local freeShare = self:getFreeShare()
		local desiredAmount = math.floor(totalUsers * platformData.startingSharePercentage)
		local grabbedAmount
		
		if desiredAmount <= freeShare then
			grabbedAmount = desiredAmount
		else
			grabbedAmount = desiredAmount
			
			local delta = desiredAmount - freeShare
			
			self:addTotalUsers(delta)
		end
		
		platformObj:setMarketShare(grabbedAmount)
		
		self.platformUsers = self.platformUsers + grabbedAmount
	end
	
	table.insert(self.allPlatforms, platformObj)
	
	self.allPlatformsByID[id] = platformObj
	
	return platformObj
end

function platformShare:initPlatform(data)
	return self:initPlatformByID(data.id)
end

platformShare.FIRST_TIME_PLATFORM_RELEASE_FACT = "first_time_platform_release_notif"

eventBoxText:registerNew({
	id = "new_platform_release",
	getText = function(self, data)
		local platData = platforms:getData(data)
		
		return platData:getReleaseText()
	end
})

function platformShare:createPlatformReleasePopup(data)
	if not data.releaseText then
		return 
	end
	
	if studio:getFact(platformShare.FIRST_TIME_PLATFORM_RELEASE_FACT) then
		local element = game.addToEventBox("new_platform_release", data.id, 1, nil, "exclamation_point")
		
		element:setFlash(true, true)
		
		return 
	end
	
	local newPopup = gui.create("Popup")
	
	newPopup:setWidth(400)
	newPopup:setDepth(105)
	newPopup:centerX()
	newPopup:setTextFont(fonts.get("pix20"))
	newPopup:setFont(fonts.get("pix24"))
	newPopup:setTitle(string.easyformatbykeys(_T("CONSOLE_HAS_BEEN_RELEASED_TITLE", "'NAME' Released"), "NAME", data.display))
	newPopup:setText(data:getReleaseText())
	newPopup:addOKButton()
	newPopup:performLayout()
	newPopup:centerY()
	studio:setFact(platformShare.FIRST_TIME_PLATFORM_RELEASE_FACT, true)
	frameController:push(newPopup)
end

function platformShare:createPlatformExpiryPopup(data)
	local newPopup = gui.create("Popup")
	
	newPopup:setWidth(400)
	newPopup:setDepth(105)
	newPopup:centerX()
	newPopup:setTextFont(fonts.get("pix20"))
	newPopup:setFont(fonts.get("pix24"))
	newPopup:setTitle(string.easyformatbykeys(_T("CONSOLE_SUPPORT_STOPPED_TITLE", "'NAME' No Longer Supported"), "NAME", data.display))
	
	if data.expiryText then
		newPopup:setText(data.expiryText)
	else
		newPopup:setText(string.easyformatbykeys(_T("CONSOLE_SUPPORT_STOPPED_DESCRIPTION", "'MANUFACTURER' has announced that their 'NAME' platform is no longer supported.\n\nIt will stay on-market for TIME."), "NAME", data.display, "MANUFACTURER", consoleManufacturers:getData(data.manufacturer).display, "TIME", timeline:getTimePeriodText(data.postExpireOnMarketTime)))
	end
	
	newPopup:addButton(fonts.get("pix24"), "OK")
	newPopup:performLayout()
	newPopup:centerY()
	frameController:push(newPopup)
end

function platformShare:getPlatformByID(id)
	return self.allPlatformsByID[id]
end

function platformShare:initPlatformAttractiveness(id)
	self.totalPlatformAttractiveness[id] = 0
end

function platformShare:addPlatformToShareList(platformObj, loading)
	if self:isPlatformOnShareList(platformObj:getID()) then
		return 
	end
	
	table.insert(self.onMarketPlatforms, platformObj)
	
	local playerPlat = platformObj.PLAYER
	
	if not playerPlat then
		self.fakeGameRecipients[#self.fakeGameRecipients + 1] = platformObj
	else
		self.allPlatformsByID[platformObj:getID()] = platformObj
	end
	
	local id = platformObj:getID()
	
	self.onMarketPlatformsByID[id] = platformObj
	
	platformObj:initEventHandler()
	events:fire(platformShare.EVENTS.NEW_PLATFORM, platformObj)
	self:recalculateSharePercentages()
	
	local manufacturerID = platformObj:getManufacturerID()
	
	if manufacturerID then
		local manufacturer = consoleManufacturers:getManufacturerByID(manufacturerID)
		
		if manufacturer then
			manufacturer:addOnMarketPlatform(id)
		end
	end
	
	platformObj:setAttractiveness(0)
	
	if not self.totalPlatformAttractiveness[id] then
		self.totalPlatformAttractiveness[id] = 0
	end
	
	if not loading and not game.startingNewGame and not playerPlat then
		self:createPlatformReleasePopup(platformObj:getPlatformData())
	end
	
	if not loading then
		if not playerPlat then
			for i = 1, math.min(platformShare.MAX_FAKE_GAMES_ON_RECORD, platformObj:getStartingFakeGames()) do
				self.fakeGames[#self.fakeGames + 1] = self:createFakeGame(platformObj)
			end
		end
		
		platformObj:setupMarketSaturation()
		
		if not playerPlat then
			platformObj:addShareToManufacturer()
		end
	end
end

function platformShare:removePlatformFromShareList(platformObj, arrayPosition)
	local objID = platformObj:getID()
	
	self.onMarketPlatformsByID[objID] = nil
	
	if not platformObj.PLAYER then
		table.removeObject(self.fakeGameRecipients, platformObj)
	end
	
	if arrayPosition then
		table.remove(self.onMarketPlatforms, arrayPosition)
	else
		for key, obj in ipairs(self.onMarketPlatforms) do
			if obj:getID() == objID then
				table.remove(self.onMarketPlatforms, key)
				
				break
			end
		end
	end
	
	local manufacturer = consoleManufacturers:getManufacturerByID(platformObj:getManufacturerID())
	
	if manufacturer then
		manufacturer:removeOnMarketPlatform(objID)
	end
	
	self.platformUsers = self.platformUsers - platformObj:getMarketShare()
	
	if studio:hasPlatformLicense(objID) then
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTextFont("pix20")
		popup:setTitle(_T("PLATFORM_OFF_MARKET_TITLE", "Platform Off-market"))
		popup:setText(_format(_T("PLATFORM_OFF_MARKET_NOTIFICATION", "The 'PLATFORM' platform, a license for which you own, has gone off-market."), "PLATFORM", platformObj:getName()))
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addText(_T("PLATFORM_NOT_AVAILABLE_FOR_DEVELOPMENT", "You will no longer be able to develop games for this platform."), "bh20", nil, 0, popup.rawW - 20, "question_mark", 24, 24)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
	end
	
	events:fire(platformShare.EVENTS.PLATFORM_REMOVED, platformObj)
	self:recalculateSharePercentages()
end

function platformShare:onChange(platformObj, amount)
	local manufacturer = platformObj:getManufacturerID()
	
	if manufacturer then
		consoleManufacturers:changeHealth(manufacturer, amount)
	end
	
	self.platformUsers = self.platformUsers + amount
	self.totalUsers = self.totalUsers + math.max(0, self.platformUsers - self.totalUsers)
	
	events:fire(platformShare.EVENTS.SHARE_CHANGED, platformObj, amount)
	
	self.changedMarketShare = true
end

function platformShare:getPlatformShare(id)
	return self.onMarketPlatformsByID[id]:getMarketShare()
end

function platformShare:getOnMarketPlatformByID(id)
	return self.onMarketPlatformsByID[id]
end

function platformShare:getTotalUsers()
	return self.totalUsers
end

function platformShare:getPlatformUsers()
	return self.platformUsers
end

function platformShare:addTotalUsers(amount)
	self.totalUsers = self.totalUsers + amount
end

function platformShare:recalculateSharePercentages()
	local oldUsers = self.totalUsers
	local totalUsers = self.platformUsers
	
	for key, obj in ipairs(self.allPlatforms) do
		obj:setMarketSharePercentage(obj:getMarketShare() / totalUsers)
	end
	
	for key, obj in ipairs(studio:getPlayerPlatforms()) do
		obj:setMarketSharePercentage(obj:getMarketShare() / totalUsers)
	end
	
	self.userChangeDelta = totalUsers - oldUsers
end

function platformShare:getUserChangeDelta()
	return self.userChangeDelta
end

function platformShare:setupMarketSaturation()
	for key, platformObj in ipairs(self.onMarketPlatforms) do
		platformObj:setupMarketSaturation()
	end
end

function platformShare:save()
	local saved = {}
	
	saved.platforms = {}
	saved.onMarketPlatforms = {}
	saved.totalUsers = self.totalUsers
	saved.fakeGames = self.fakeGames
	saved.totalPlatformAttractiveness = self.totalPlatformAttractiveness
	saved.userChangeDelta = self.userChangeDelta
	saved.platformUsers = self.platformUsers
	
	for key, platformObj in ipairs(self.allPlatforms) do
		table.insert(saved.platforms, platformObj:save())
	end
	
	for key, platformObj in ipairs(self.onMarketPlatforms) do
		table.insert(saved.onMarketPlatforms, platformObj:getID())
	end
	
	return saved
end

function platformShare:load(data)
	self:init()
	
	self.totalUsers = data.totalUsers
	self.fakeGames = data.fakeGames or self.fakeGames
	self.userChangeDelta = data.userChangeDelta or self.userChangeDelta
	
	local themes, genres = themes.registered, genres.registered
	
	for key, fakeGameData in ipairs(self.fakeGames) do
		fakeGameData.theme = fakeGameData.theme or themes[math.random(1, #themes)].id
		fakeGameData.genre = fakeGameData.genre or genres[math.random(1, #genres)].id
	end
	
	self.totalPlatformAttractiveness = data.totalPlatformAttractiveness or self.totalPlatformAttractiveness
	
	for key, platformData in ipairs(data.platforms) do
		local platformObj = self:getPlatformByID(platformData.platformID) or self:initPlatformByID(platformData.platformID, true)
		
		platformObj:load(platformData)
	end
	
	for key, platformID in ipairs(data.onMarketPlatforms) do
		local platformObject = self:getPlatformByID(platformID)
		
		if platformObject then
			self:addPlatformToShareList(platformObject, true)
		end
	end
	
	self:validatePlatforms()
	
	self.platformUsers = data.platformUsers
end

function platformShare:postLoad(data)
	for key, platformObj in ipairs(self.onMarketPlatforms) do
		platformObj:postLoad()
	end
	
	self:setupMarketSaturation()
	self:recalculateSharePercentages()
	self:updateAttractiveness()
end

require("game/platform/platforms")
