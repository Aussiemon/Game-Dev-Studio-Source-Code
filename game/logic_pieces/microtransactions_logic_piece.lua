local logicPiece = {}

logicPiece.id = "microtransactions_logic_piece"

local mmoData = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)

logicPiece.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_WEEK,
	gameProject.EVENTS.COPIES_SOLD,
	mmoData.EVENTS.FEE_CHANGED
}
logicPiece.SCALE_FRUSTRATION_MAX = 100
logicPiece.SCALE_FRUSTRATION_MIN = 10
logicPiece.PRIORITY_FRUSTRATION_MAX = 500
logicPiece.PRIORITY_FRUSTRATION_MIN = 50
logicPiece.MIN_FRUSTRATION = 1
logicPiece.MAX_FRUSTRATION = 600
logicPiece.MIN_LONGEVITY = timeline.DAYS_IN_MONTH * 2
logicPiece.MAX_LONGEVITY = timeline.DAYS_IN_YEAR * 2
logicPiece.FRUSTRATION_TO_LONGEVITY = 1
logicPiece.MIN_MONEY_PER_IAP = 1
logicPiece.MAX_MONEY_PER_IAP = 20
logicPiece.FRUSTRATED_PENALTY = 0.04
logicPiece.MIN_IAP_DIVIDER = 20
logicPiece.SALE_TO_FRUSTRATION = 0.1
logicPiece.SALE_TO_REPUTATION_LOSS = 0.02
logicPiece.RATING_MIN_SOFTEN = 7
logicPiece.RATING_MAX_SOFTEN = 10
logicPiece.SOFTEN_MIN = 1
logicPiece.SOFTEN_MAX = 0.5
logicPiece.MMO_SALE_MULT = 0.4
logicPiece.MICROTRANSACTIONS_DIVIDER_EXP = math.log(5, 19.99)
logicPiece.FEATURE_FRUSTRATION_CHANGE = {
	{
		"multiplayer",
		-30
	},
	{
		"multiplayer_coop",
		-10
	},
	{
		"multiplayer_splitscreen",
		-10
	}
}
logicPiece.FEATURE_LONGEVITY_CHANGE = {
	{
		"multiplayer",
		30
	},
	{
		"multiplayer_coop",
		10
	},
	{
		"multiplayer_splitscreen",
		10
	}
}
logicPiece.EVENTS = {
	OVER = events:new(),
	PROGRESSED = events:new(),
	STARTED = events:new()
}

function logicPiece:setupLongevity(gameProj)
	self:setProject(gameProj)
end

function logicPiece:getMMOFeeDivider()
	return self.mmoLogic:getFee()^logicPiece.MICROTRANSACTIONS_DIVIDER_EXP - 1
end

function logicPiece:setProject(gameProj)
	self.gameProject = gameProj
	self.projectOwner = self.gameProject:getOwner()
	self.platformCount = #self.gameProject:getTargetPlatforms()
	self.frustratedPlatformCount = self.frustratedPlatformCount or 0
	self.isMMO = gameProj:getGameType() == gameProject.DEVELOPMENT_TYPE.MMO
	
	if self.isMMO then
		self.extraSaleMult = logicPiece.MMO_SALE_MULT
		self.mmoLogic = gameProj.mmoLogic or gameProj:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
		
		if self.mmoLogic then
			self.mmoFeeDivider = self:getMMOFeeDivider()
		end
	else
		self.extraSaleMult = 1
	end
	
	self:setupSaleData()
	
	if gameProj:getOwner():isPlayer() then
		local inappDataDisplay = gui.create("InappsDisplayFrame")
		
		inappDataDisplay:setLogicPiece(self)
		game.addToProjectScroller(inappDataDisplay, gameProj)
	end
end

logicPiece.frustratedPlatforms = {}
logicPiece.concatTable = {}

function logicPiece:getPurchaseList()
	return self.purchasesByWeek
end

function logicPiece:_setupFrustratedPlatformsString()
	local platformCount = #logicPiece.frustratedPlatforms
	local lastPlatform = table.remove(logicPiece.frustratedPlatforms, platformCount)
	local newCount = platformCount - 1
	local comma = _T("COMMA_WITH_SPACE", ", ")
	local cct = logicPiece.concatTable
	
	for key, platformObject in ipairs(logicPiece.frustratedPlatforms) do
		logicPiece.frustratedPlatforms[key] = nil
		cct[#cct + 1] = _format(_T("QUOTATION_MARKS_STRING", "'THING'"), "THING", platformObject:getName())
		
		if key ~= newCount then
			cct[#cct + 1] = comma
		end
	end
	
	cct[#cct + 1] = _T("AND_LOWERCASE_SPACE", " and ")
	cct[#cct + 1] = _format(_T("QUOTATION_MARKS_STRING", "'THING'"), "THING", lastPlatform:getName())
	
	local result = table.concat(cct, "")
	
	table.clearArray(cct)
	
	return result
end

function logicPiece:handleEvent(event, gameProj, copiesSold)
	if event == gameProject.EVENTS.COPIES_SOLD then
		if gameProj == self.gameProject then
			local minFrust, maxFrust = logicPiece.MIN_FRUSTRATION, logicPiece.MAX_FRUSTRATION
			local frustrationChange = self.frustrationChange * self:calculateRatingSoftening()
			
			self.realFrustrationChange = frustrationChange
			
			local frustratedPlatforms = 0
			
			for key, platformID in ipairs(gameProj:getTargetPlatforms()) do
				local platformObject = platformShare:getPlatformByID(platformID)
				
				if platformObject then
					local delta = math.min(1, copiesSold / (platformObject:getMarketShare() * logicPiece.SALE_TO_FRUSTRATION))
					local prevLevel = self.frustrationLevels[platformID] or 0
					local finalFrustration = math.max(minFrust, math.min(frustrationChange * platformObject:getFrustrationMultiplier() * delta, maxFrust - prevLevel))
					
					if platformObject:isFrustratedWithMicrotransactions() then
						frustratedPlatforms = frustratedPlatforms + 1
					end
					
					self.frustrationLevels[platformID] = prevLevel + finalFrustration
					
					if platformObject:changeFrustration(platform.FRUSTRATOR_IAP, finalFrustration) then
						logicPiece.frustratedPlatforms[#logicPiece.frustratedPlatforms + 1] = platformObject
					end
				end
			end
			
			self.frustratedPlatformCount = frustratedPlatforms
			
			local platformCount = #logicPiece.frustratedPlatforms
			
			if platformCount > 0 then
				local text
				local isPlayer = gameProj:getOwner():isPlayer()
				
				if isPlayer then
					if platformCount == 1 then
						local platformObj = table.remove(logicPiece.frustratedPlatforms, 1)
						
						text = _format(_T("PLATFORM_USERS_FRUSTRATED_PLAYER_YOUR_GAME", "Users of the 'PLATFORM' platform are frustrated with microtransactions in games, specifically with your 'GAME' game."), "PLATFORM", platformObj:getName(), "GAME", self.gameProject:getName())
					else
						text = _format(_T("PLATFORM_USERS_FRUSTRATED_MULTIPLE_PLAYER_YOUR_GAME", "Users of PLATFORMS are frustrated with microtransactions in games, specifically with your 'GAME' game."), "PLATFORMS", self:_setupFrustratedPlatformsString(), "GAME", self.gameProject:getName())
					end
				elseif platformCount == 1 then
					local platformObj = table.remove(logicPiece.frustratedPlatforms, 1)
					
					text = _format(_T("PLATFORM_USERS_FRUSTRATED_PLAYER", "Users of the 'PLATFORM' platform are frustrated with microtransactions in games."), "PLATFORM", platformObj:getName())
				else
					text = _format(_T("PLATFORM_USERS_FRUSTRATED_MULTIPLE_PLAYER", "Users of PLATFORMS are frustrated with microtransactions in games."), "PLATFORMS", self:_setupFrustratedPlatformsString())
				end
				
				local repLoss = math.floor(gameProj:getSales() * logicPiece.SALE_TO_REPUTATION_LOSS)
				local popup = gui.create("DescboxPopup")
				
				popup:setWidth(600)
				popup:setFont("pix24")
				popup:setTitle(_T("PLATFORM_USERS_FRUSTRATED_TITLE", "Platform Users Frustrated"))
				popup:setTextFont("pix20")
				popup:setText(text)
				popup:setShowSound("bad_jingle")
				popup:hideCloseButton()
				
				local left, right, extra = popup:getDescboxes()
				
				extra:addText(_T("PLATFORM_USERS_FRUSTRATED_AFTERMATH", "Games with microtransactions will now receive much lower sales until frustration of the playerbase subsides."), "bh20", nil, 0, popup.rawW - 20, "exclamation_point_red", 22, 22)
				
				if isPlayer then
					extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
					extra:addText(_format(_T("PLATFORM_USERS_FRUSTRATED_REPLOSS", "You've lost REPLOSS reputation points."), "REPLOSS", string.comma(repLoss)), "bh20", nil, 0, popup.rawW - 20, "exclamation_point_red", 22, 22)
				end
				
				gameProj:getOwner():decreaseReputation(repLoss)
				popup:addOKButton("pix20")
				popup:center()
				frameController:push(popup)
			end
		end
	elseif event == mmoData.EVENTS.FEE_CHANGED then
		if self.gameProject == gameProj and self.mmoLogic then
			self.mmoFeeDivider = self:getMMOFeeDivider()
		end
	else
		self.longevity = self.longevity - timeline.DAYS_IN_WEEK
		
		if self.longevity <= 0 then
			self:remove()
		else
			self:makeMoney()
		end
	end
end

function logicPiece:calculateRatingSoftening()
	local realRating = self.gameProject:getRealRating()
	local frustrationSoften = 1
	local minSoft, maxSoft = logicPiece.RATING_MIN_SOFTEN, logicPiece.RATING_MAX_SOFTEN
	
	if minSoft < realRating then
		frustrationSoften = math.lerp(logicPiece.SOFTEN_MIN, logicPiece.SOFTEN_MAX, (realRating - minSoft) / (maxSoft - minSoft))
	end
	
	return frustrationSoften
end

function logicPiece:setupSaleData()
	if not self.frustrationLevels then
		self.purchasesByWeek = {}
		self.totalPurchases = 0
		self.totalMoneyMade = 0
		self.lastMoneyMade = 0
		self.frustrationLevels = {}
		
		local gameProj = self.gameProject
		
		self.microtransactionAmount = gameProj:getCategoryPriority(gameProject.MICROTRANSACTIONS_PRIORITY)
		
		local frustrationChange = 0
		
		frustrationChange = frustrationChange + math.lerp(logicPiece.SCALE_FRUSTRATION_MAX, logicPiece.SCALE_FRUSTRATION_MIN, (gameProj:getScale() - gameProject.SCALE_MIN) / (gameProject.SCALE_MAX - gameProject.SCALE_MIN))
		frustrationChange = frustrationChange + math.lerp(logicPiece.PRIORITY_FRUSTRATION_MIN, logicPiece.PRIORITY_FRUSTRATION_MAX, (gameProj:getCategoryPriority(gameProject.MICROTRANSACTIONS_CATEGORY) - gameProject.PRIORITY_MIN) / (gameProject.PRIORITY_MAX - gameProject.PRIORITY_MIN))
		
		for key, data in ipairs(logicPiece.FEATURE_FRUSTRATION_CHANGE) do
			if gameProj:hasFeature(data[1]) then
				frustrationChange = frustrationChange + data[2]
			end
		end
		
		frustrationChange = frustrationChange / gameProj:getFeatureCountSaleAffector()
		frustrationChange = frustrationChange * self.microtransactionAmount
		self.frustrationChange = frustrationChange
		
		local longevity = 0
		
		for key, data in ipairs(logicPiece.FEATURE_LONGEVITY_CHANGE) do
			if gameProj:hasFeature(data[1]) then
				longevity = longevity + data[2]
			end
		end
		
		self.longevity = math.max(logicPiece.MIN_LONGEVITY, math.min(logicPiece.MAX_LONGEVITY, longevity + logicPiece.MAX_LONGEVITY - self.frustrationChange * logicPiece.FRUSTRATION_TO_LONGEVITY))
		self.startingLongevity = self.longevity
	end
	
	self.realFrustrationChange = self.frustrationChange * self:calculateRatingSoftening()
	self.scaleDelta = (self.gameProject:getScale() - gameProject.SCALE_MIN) / (gameProject.SCALE_MAX - gameProject.SCALE_MIN)
end

function logicPiece:makeMoney()
	local scaledLongevity = self.longevity / self.startingLongevity
	local sales = self.gameProject:getSales() / math.max(logicPiece.MIN_IAP_DIVIDER, self.realFrustrationChange) * scaledLongevity * math.lerp(1, logicPiece.FRUSTRATED_PENALTY, self.frustratedPlatformCount / self.platformCount) * self.extraSaleMult
	
	if self.isMMO then
		sales = sales / self.mmoFeeDivider
	end
	
	sales = math.max(0, sales)
	
	local moneyEarned = math.lerp(logicPiece.MIN_MONEY_PER_IAP, logicPiece.MAX_MONEY_PER_IAP, math.min(1, math.max(self.scaleDelta + math.randomf(-0.05, 0.03), 0)))
	local finalMoney = moneyEarned * sales * gameProject.SALE_POST_TAX_PERCENTAGE
	
	self.purchasesByWeek[#self.purchasesByWeek + 1] = finalMoney
	self.totalPurchases = self.totalPurchases + sales
	self.totalMoneyMade = self.totalMoneyMade + finalMoney
	self.lastMoneyMade = finalMoney
	
	self.projectOwner:addFunds(finalMoney)
	self.gameProject:trackSoldCopies(nil, finalMoney)
	self.gameProject:increaseRealMoneyMade(finalMoney)
	events:fire(logicPiece.EVENTS.PROGRESSED, self.gameProject)
end

function logicPiece:getSaleData()
	return self.totalPurchases, self.totalMoneyMade, self.lastMoneyMade
end

eventBoxText:registerNew({
	id = "microtransactions_over",
	getText = function(self, data)
		return _format(_T("MICROTRANSACTIONS_OVER", "Micro-transaction sales for 'GAME' seem to have stopped."), "GAME", data:getName())
	end,
	saveData = function(self, data)
		return data:getUniqueID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getGameByUniqueID(data)
	end
})

function logicPiece:onRemoved()
	logicPiece.baseClass.onRemoved(self)
	self.gameProject:removeLogicPiece(self)
	
	if self.gameProject:getOwner():isPlayer() then
		events:fire(logicPiece.EVENTS.OVER, self.gameProject)
		game.addToEventBox("microtransactions_over", self.gameProject, 1, nil, "exclamation_point")
	end
end

function logicPiece:save()
	local saved = logicPiece.baseClass.save(self)
	
	saved.longevity = self.longevity
	saved.microtransactionAmount = self.microtransactionAmount
	saved.frustrationChange = self.frustrationChange
	saved.startingLongevity = self.startingLongevity
	saved.frustrationLevels = self.frustrationLevels
	saved.purchasesByWeek = self.purchasesByWeek
	saved.totalPurchases = self.totalPurchases
	saved.totalMoneyMade = self.totalMoneyMade
	saved.lastMoneyMade = self.lastMoneyMade
	saved.frustratedPlatformCount = self.frustratedPlatformCount
	
	return saved
end

function logicPiece:load(data)
	self.longevity = data.longevity
	self.microtransactionAmount = data.microtransactionAmount
	self.frustrationChange = data.frustrationChange
	self.startingLongevity = data.startingLongevity
	self.frustrationLevels = data.frustrationLevels
	self.purchasesByWeek = data.purchasesByWeek
	self.totalPurchases = data.totalPurchases
	self.totalMoneyMade = data.totalMoneyMade
	self.lastMoneyMade = data.lastMoneyMade
	self.frustratedPlatformCount = data.frustratedPlatformCount or self.frustratedPlatformCount
end

function logicPiece:postLoad()
	if self.isMMO then
		local proj = self.gameProject
		
		self.mmoLogic = proj.mmoLogic or proj:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
		self.mmoFeeDivider = self:getMMOFeeDivider()
	end
end

function logicPiece:canLoad(data, gameProj)
	return not data.finished
end

logicPieces:registerNew(logicPiece, "event_handling_logic_piece")
