consoleManufacturer = {}
consoleManufacturer.mtindex = {
	__index = consoleManufacturer
}
consoleManufacturer.defaultCloseDownText = _T("MANUFACTURER_HAS_CLOSED_DOWN", "'MANUFACTURER' has closed down due to bankruptcy. Any possible future consoles this manufacturer could have made will not be released.")
consoleManufacturer.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_MONTH,
	studio.EVENTS.RELEASED_GAME
}

function consoleManufacturer.new(data)
	local new = {}
	
	setmetatable(new, consoleManufacturer.mtindex)
	new:init(data)
	
	return new
end

function consoleManufacturer:init(data)
	self.data = data
	self.hitpoints = consoleManufacturers.START_HITPOINTS
	self.health = 0
	self.releasedPlatformCount = 0
	self.advertisementMultiplier = 0
	self.advertisementDuration = 0
	self.advertisementCooldown = 0
	self.countedReleasedPlatforms = {}
	self.onMarketPlatformIDs = {}
	self.releasedPlatforms = {}
end

function consoleManufacturer:setAdvertisementInfo(multiplier, duration, targetPlatform)
	self.advertisementMultiplier = multiplier
	self.advertisementDuration = timeline.curTime + duration
	self.advertisementCooldown = self.advertisementDuration + consoleManufacturers.ADVERTISEMENT_COOLDOWN + multiplier * timeline.DAYS_IN_WEEK
	self.advertisementPlatform = targetPlatform
	self.hadAdvertisement = true
end

function consoleManufacturer:isPlayer()
	return false
end

function consoleManufacturer:wasAdvertisementPerformed()
	return self.hadAdvertisement
end

function consoleManufacturer:getAdvertisementCooldown()
	return self.advertisementCooldown
end

function consoleManufacturer:getAdvertisementDuration()
	return self.advertisementDuration
end

function consoleManufacturer:getAdvertisementMultiplier()
	return self.advertisementMultiplier
end

function consoleManufacturer:getAdvertisementTarget()
	return self.advertisementPlatform
end

function consoleManufacturer:addOnMarketPlatform(id)
	self.onMarketPlatformIDs[id] = true
	
	self:changeReleasedPlatformCount(1)
	
	local mostRecent, recentPlatform = -math.huge
	
	for platformID, state in pairs(self.onMarketPlatformIDs) do
		local data = platforms.registeredByID[platformID]
		
		if data.releaseDate then
			local time = timeline:getDateTime(data.releaseDate.year, data.releaseDate.month)
			
			if mostRecent < time then
				mostRecent = time
				recentPlatform = platformID
			end
		end
	end
	
	self.mostRecentPlatform = recentPlatform
end

function consoleManufacturer:removeOnMarketPlatform(id)
	self.onMarketPlatformIDs[id] = nil
	
	self:changeReleasedPlatformCount(-1)
end

function consoleManufacturer:getMostRecentPlatform()
	return self.mostRecentPlatform
end

function consoleManufacturer:startReceivingEvents()
	events:addDirectReceiver(self, consoleManufacturer.CATCHABLE_EVENTS)
end

function consoleManufacturer:destroy()
	events:removeDirectReceiver(self, consoleManufacturer.CATCHABLE_EVENTS)
end

function consoleManufacturer:closeDown(quiet)
	self:destroy()
	
	self.closedDown = true
	
	consoleManufacturers:closeDown(self)
	
	if not quiet then
		local popup = gui.create("Popup")
		
		popup:setWidth(500)
		popup:setFont(fonts.get("pix24"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setTitle(_T("CLOSING_DOWN_OF_MANUFACTURER_TITLE", "Manufacturer Close-down"))
		
		if self.data.closeDownText then
			popup:setText(self.data.closeDownText)
		else
			popup:setText(string.easyformatbykeys(consoleManufacturer.defaultCloseDownText, "MANUFACTURER", self.data.display))
		end
		
		popup:addButton(fonts.get("pix24"), "OK")
		popup:center()
		frameController:push(popup)
	end
	
	for key, eventID in ipairs(self.data.scheduledPlatformEvents) do
		if not scheduledEvents:wasActivated(eventID) then
			scheduledEvents:cancel(eventID)
		end
	end
end

function consoleManufacturer:hasClosedDown()
	return self.closedDown
end

function consoleManufacturer:canGoBankrupt()
	return not self.data.noBankruptcy
end

function consoleManufacturer:handleEvent(event, gameObj)
	if event == timeline.EVENTS.NEW_DAY then
		if self.hitpoints == 0 and not self.data.noBankruptcy then
			self:closeDown()
		end
	elseif event == timeline.EVENTS.NEW_MONTH and self.evaluatePlayerBonus then
		self.evaluatePlayerBonus = false
		
		local playerGames = studio:getReleasedGames()
		local data = self.data
		local desiredRating = data.exclusivityBonusGameRating
		local ratingOffset = 0
		local validGames = 0
		
		for i = #playerGames, math.max(1, #playerGames - data.exclusivityBonusGameCount * 2), -1 do
			local gameObj = playerGames[i]
			
			if gameObj:getManufacturerConsoleCount(data.id) > 0 and gameObj:isNewGame() then
				local realRating = gameObj:getRealRating()
				
				ratingOffset = ratingOffset + (realRating - desiredRating)
				
				if desiredRating <= realRating then
					validGames = validGames + 1
				end
			end
		end
		
		if ratingOffset >= data.minimumRatingOffsetForBonus then
			if not self.playerBonusActive then
				if validGames >= data.exclusivityBonusGameCount then
					self:activatePlayerCutBonus()
				elseif data.exclusivityBonusGameCount - validGames == 1 then
					self:notifyOfPlayerCutBonus()
				end
			end
		elseif self.playerBonusActive and ratingOffset <= data.ratingOffsetRemoveBonus then
			self:removePlayerCutBonus()
		end
	elseif event == studio.EVENTS.RELEASED_GAME and gameObj:getOwner():isPlayer() and self.releasedPlatformCount > 0 then
		self.evaluatePlayerBonus = true
	end
end

function consoleManufacturer:notifyOfPlayerCutBonus()
	if self.playerBonusHint then
		return 
	end
	
	local descboxPopup = gui.create("DescboxPopup")
	
	descboxPopup:setWidth(600)
	descboxPopup:setFont("pix24")
	descboxPopup:setTextFont("pix20")
	descboxPopup:setTitle(_T("EXCLUSIVITY_BONUS_HINT_TITLE", "Exclusivity Bonus"))
	descboxPopup:setText(_format(_T("EXCLUSIVITY_BONUS_HINT_DESCRIPTION", "'MANUFACTURER' has recently taken note of the games you've been releasing on their platforms and are very impressed with your games."), "MANUFACTURER", self.data.display))
	
	local left, right, extra = descboxPopup:getDescboxes()
	
	extra:addSpaceToNextText(5)
	extra:addText(_format(_T("EXCLUSIVITY_BONUS_HINT_DESCRIPTION_DETAILS", "Continuing to make good games for platforms manufactured by 'MANUFACTURER' will bring a reduction in their cut per game sale."), "MANUFACTURER", self.data.display), "bh20", nil, 0, descboxPopup.rawW - 20, "exclamation_point", 24, 24)
	descboxPopup:addButton("pix20", _T("GREAT", "Great"))
	descboxPopup:center()
	descboxPopup:setShowSound("good_jingle")
	frameController:push(descboxPopup)
	
	self.playerBonusHint = true
end

function consoleManufacturer:activatePlayerCutBonus()
	local descboxPopup = gui.create("DescboxPopup")
	
	descboxPopup:setWidth(600)
	descboxPopup:setFont("pix24")
	descboxPopup:setTextFont("pix20")
	descboxPopup:setTitle(_T("EXCLUSIVITY_BONUS_AVAILABLE_TITLE", "Exclusivity Bonus Available"))
	descboxPopup:setText(_format(_T("EXCLUSIVITY_BONUS_AVAILABLE_DESCRIPTION", "'MANUFACTURER' is very impressed with the track record of your games. \n\nThey are willing to provide benefits to you when developing games for their platforms."), "MANUFACTURER", self.data.display))
	
	local left, right, extra = descboxPopup:getDescboxes()
	
	extra:addSpaceToNextText(5)
	extra:addText(_format(_T("EXCLUSIVITY_BONUS_AVAILABLE_DETAILS", "Full or partial exclusivity to platforms of 'MANUFACTURER' now provides a reduced cut in share per sale."), "MANUFACTURER", self.data.display), "bh20", nil, 0, descboxPopup.rawW - 20, "exclamation_point", 24, 24)
	descboxPopup:setShowSound("good_jingle")
	descboxPopup:addButton("pix20", _T("GREAT", "Great"))
	descboxPopup:center()
	frameController:push(descboxPopup)
	
	self.playerBonusActive = true
end

function consoleManufacturer:removePlayerCutBonus()
	local descboxPopup = gui.create("DescboxPopup")
	
	descboxPopup:setWidth(600)
	descboxPopup:setFont("pix24")
	descboxPopup:setTextFont("pix20")
	descboxPopup:setTitle(_T("EXCLUSIVITY_BONUS_REVOKED_TITLE", "Exclusivity Bonus Revoked"))
	descboxPopup:setText(_format(_T("EXCLUSIVITY_BONUS_REVOKED_DESCRIPTION", "'MANUFACTURER' has revoked their exclusivity bonus due to the fact that the quality of your recent games has dropped, compared to what they used to be."), "MANUFACTURER", self.data.display))
	descboxPopup:setShowSound("bad_jingle")
	
	local left, right, extra = descboxPopup:getDescboxes()
	
	extra:addSpaceToNextText(5)
	extra:addTextLine(descboxPopup.w - _S(20), game.UI_COLORS.UI_PENALTY_LINE)
	extra:addText(_format(_T("EXCLUSIVITY_BONUS_REVOKED_DETAILS", "Exclusivity bonus no longer applies to platforms of 'MANUFACTURER'."), "MANUFACTURER", self.data.display), "bh20", game.UI_COLORS.RED, 0, descboxPopup.rawW - 20, "exclamation_point_red", 24, 24)
	descboxPopup:addButton("pix20", _T("GREAT", "Great"))
	descboxPopup:center()
	frameController:push(descboxPopup)
	
	self.playerBonusActive = false
end

function consoleManufacturer:isExclusivityBonusActive()
	return self.playerBonusActive
end

function consoleManufacturer:getReleasedPlatformCount()
	return self.releasedPlatformCount
end

function consoleManufacturer:changeReleasedPlatformCount(amount)
	self.releasedPlatformCount = self.releasedPlatformCount + amount
end

function consoleManufacturer:getData()
	return self.data
end

function consoleManufacturer:getID()
	return self.data.id
end

function consoleManufacturer:getName()
	return self.data.display
end

function consoleManufacturer:getHealth()
	return self.health
end

function consoleManufacturer:getHitpoints()
	return self.hitpoints
end

function consoleManufacturer:getHitpointsText()
	if self.hitpoints <= 30 then
		return _T("HITPOINTS_LEVEL_VERYBAD", "Very bad"), game.UI_COLORS.RED
	elseif self.hitpoints <= 60 then
		return _T("HITPOINTS_LEVEL_BAD", "Bad"), game.UI_COLORS.LIGHT_RED
	elseif self.hitpoints <= 110 then
		return _T("HITPOINTS_LEVEL_OK", "OK"), nil
	elseif self.hitpoints <= 150 then
		return _T("HITPOINTS_LEVEL_GOOD", "Good"), game.UI_COLORS.LIGHT_BLUE
	else
		return _T("HITPOINTS_LEVEL_VERYGOOD", "Very good"), game.UI_COLORS.LIGHT_BLUE
	end
end

function consoleManufacturer:changeHealth(amount)
	self.health = self.health + amount
end

function consoleManufacturer:changeHitpoints(amount)
	self.hitpoints = math.clamp(self.hitpoints + amount, consoleManufacturers.DEATH_HITPOINTS, consoleManufacturers.MAX_HITPOINTS)
	
	self:postChangeHitpoints()
end

function consoleManufacturer:postChangeHitpoints()
	if self.hitpoints <= consoleManufacturers.DEATH_HITPOINTS then
		self:closeDown()
	end
end

function consoleManufacturer:save()
	return {
		health = self.health,
		hitpoints = self.hitpoints,
		id = self.data.id,
		countedReleasedPlatforms = self.countedReleasedPlatforms,
		closedDown = self.closedDown,
		advertisementMultiplier = self.advertisementMultiplier,
		advertisementDuration = self.advertisementDuration,
		advertisementCooldown = self.advertisementCooldown,
		advertisementPlatform = self.advertisementPlatform,
		hadAdvertisement = self.hadAdvertisement,
		mostRecentPlatform = self.mostRecentPlatform,
		releasedPlatforms = self.releasedPlatforms,
		evaluatePlayerBonus = self.evaluatePlayerBonus,
		playerBonusActive = self.playerBonusActive,
		playerBonusHint = self.playerBonusHint
	}
end

function consoleManufacturer:load(data)
	self.health = data.health
	self.hitpoints = data.hitpoints
	self.countedReleasedPlatforms = data.countedReleasedPlatforms or self.countedReleasedPlatforms
	self.closedDown = data.closedDown
	self.advertisementMultiplier = data.advertisementMultiplier or self.advertisementMultiplier
	self.advertisementDuration = data.advertisementDuration or self.advertisementDuration
	self.advertisementCooldown = data.advertisementCooldown or self.advertisementCooldown
	self.advertisementPlatform = data.advertisementPlatform
	self.hadAdvertisement = data.hadAdvertisement
	self.mostRecentPlatform = data.mostRecentPlatform
	self.releasedPlatforms = data.releasedPlatforms or self.releasedPlatforms
	self.evaluatePlayerBonus = data.evaluatePlayerBonus
	self.playerBonusActive = data.playerBonusActive
	self.playerBonusHint = data.playerBonusHint
end

function consoleManufacturer:inheritHealth()
	self.health = 0
	
	for key, platformObj in ipairs(platformShare.allPlatforms) do
		if platformObj:getManufacturerID() == self.data.id then
			self.health = self.health + platformObj:getMarketShare()
		end
	end
end

function consoleManufacturer:postLoad()
	self:inheritHealth()
end
