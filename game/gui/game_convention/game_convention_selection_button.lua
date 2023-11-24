local gameConventionButton = {}

gameConventionButton.backgroundOffset = 3
gameConventionButton.innerOffset = 2
gameConventionButton.iconSize = 24
gameConventionButton.baseBackgroundColor = color(0, 0, 0, 100)
gameConventionButton.baseBackgroundColorHover = color(0, 0, 0, 20)
gameConventionButton.underIconColor = color(0, 0, 0, 150)

function gameConventionButton:init()
	self.bigFont = fonts.get("pix22")
	self.smallFont = fonts.get("pix20")
end

function gameConventionButton:proceedToBooking()
	frameController:pop()
	self.conventionData:createConventionBookingMenu(self.project)
end

function gameConventionButton:setProject(project)
	self.project = project
end

function gameConventionButton:setConventionData(data)
	self.conventionData = data
	
	local lowest, highest = math.huge, -math.huge
	
	for key, boothData in ipairs(self.conventionData.booths) do
		lowest = math.min(lowest, boothData.cost)
		highest = math.max(highest, boothData.cost)
	end
	
	lowest = lowest + self.conventionData.entryFee
	highest = highest + self.conventionData.entryFee
	self.titleText = self.conventionData.display
	self.costText = string.easyformatbykeys(_T("BOOTH_PRICE_RANGE", "Booth cost: MINIMUM - MAXIMUM"), "MINIMUM", string.roundtobigcashnumber(lowest), "MAXIMUM", string.roundtobigcashnumber(highest))
	
	local inProgress = gameConventions:isConventionInProgress(self.conventionData.id)
	
	if inProgress then
		self.beginText = _T("EXPO_IN_PROGRESS_SHORT", "Expo already in progress.")
	else
		self.beginText = string.easyformatbykeys(_T("EXPO_BEGINS_IN", "Begins in TIME."), "TIME", timeline:getTimePeriodText(self.conventionData:getTimeUntil(timeline.curTime)))
	end
	
	self.registrationTextColor = game.UI_COLORS.WHITE
	
	if self.conventionData:canBookPresentation() then
		self.registrationText = string.easyformatbykeys(_T("EXPO_REGISTRATION_ENDS_IN", "Expo registration ends in TIME."), "TIME", timeline:getTimePeriodText(self.conventionData:getExpoRegistrationEndTime()))
	elseif inProgress then
		self.registrationText = _T("EXPO_REGISTRATION_UNAVAILABLE", "Expo registration is unavailable.")
	elseif self.conventionData:isBookedByPlayer() then
		self.registrationText = _T("EXPO_SPOT_ALREADY_BOOKED", "You've already booked a spot here.")
		self.registrationTextColor = game.UI_COLORS.IMPORTANT_1
	else
		self.registrationText = _T("EXPO_REGISTRATION_ENDED", "Expo registration has ended.")
	end
end

function gameConventionButton:addPresentedGames(descBox, wrapWidth)
	descBox:addSpaceToNextText(7)
	descBox:addText(_T("YOU_ARE_PRESENTING_GAMES", "You are showcasing:"), "bh20", nil, 4, wrapWidth)
	
	local gameList = self.conventionData:getGameList()
	local gameCount = #gameList
	
	for key, gameObj in ipairs(gameList) do
		descBox:addText(gameObj:getName(), "pix20", nil, key ~= gameCount and 3 or 0, wrapWidth, genres:getGenreUIIconConfig(genres.registeredByID[gameObj:getGenre()], 24, 24, 20))
	end
end

function gameConventionButton:onMouseEntered()
	gameConventionButton.baseClass.onMouseEntered(self)
	
	local descBox = gui.create("GenericDescbox")
	
	descBox:addText(string.easyformatbykeys(_T("GAME_EXPO_TEXT_LAYOUT", "Exposition - EXPO"), "EXPO", self.conventionData.display), "bh24", nil, 10, 600)
	
	local inProgress = gameConventions:isConventionInProgress(self.conventionData.id)
	local participating = self.conventionData:isPlayerParticipating()
	local wrapWidth = 600
	
	if inProgress then
		descBox:addText(_T("EXPO_IN_PROGRESS", "This expo is currently in-progress."), "bh22", nil, 0, wrapWidth)
		
		if participating then
			descBox:addSpaceToNextText(10)
			descBox:addText(string.easyformatbykeys(_T("YOU_ARE_PARTICIPATING_IN_EXPO", "Your studio is participating in this expo."), "EXPO", self.conventionData.display), "bh20", nil, 2, wrapWidth, "question_mark", 24, 24)
			descBox:addText(string.easyformatbykeys(_T("DETAILED_EXPO_INFO_AFTER_FINISH", "More information will become available once the exposition finishes."), "EXPO", self.conventionData.display), "bh20", nil, 10, wrapWidth, "question_mark", 24, 24)
			self:addPresentedGames(descBox, wrapWidth)
		else
			descBox:addSpaceToNextText(10)
			descBox:addText(string.easyformatbykeys(_T("YOU_ARE_NOT_PARTICIPATING_IN_EXPO", "Your studio is not participating in this expo."), "EXPO", self.conventionData.display), "bh20", nil, 3, wrapWidth, "question_mark", 24, 24)
		end
	end
	
	if not inProgress or inProgress and not participating then
		local participationDate = self.conventionData:getParticipationDate()
		
		descBox:addSpaceToNextText(10)
		
		if participationDate then
			local year = timeline:getYear(participationDate)
			
			if year == timeline:getYear() then
				descBox:addText(_T("EXPO_PARTICIPATED_THIS_YEAR", "Your studio has participated here this year."), "bh20", nil, 2, wrapWidth, "question_mark", 24, 24)
			else
				descBox:addText(string.easyformatbykeys(_T("EXPO_PARTICIPATED_IN_YEAR", "Your studio has last attended this expo in the year YEAR."), "YEAR", year), "bh20", nil, 2, wrapWidth, "question_mark", 24, 24)
			end
			
			descBox:addText(string.easyformatbykeys(_T("EXPO_ATTRACTED_PEOPLE_COUNT", "Your booth attracted approximately PEOPLE, which got your presented projects POPULARITY popularity points."), "PEOPLE", developer:getPeopleCountText(gameConventions:getAttractedVisitors(self.conventionData.id)), "POPULARITY", string.comma(gameConventions:getGainedPopularity(self.conventionData.id))), "bh18", nil, 0, wrapWidth, "question_mark", 24, 24)
		else
			descBox:addText(_T("EXPO_NOT_PARTICIPATED_YET", "Your studio has not participated in this game exposition yet."), "bh20", nil, 0, wrapWidth, "question_mark", 24, 24)
		end
		
		if self.conventionData:isBookedByPlayer() then
			descBox:addText(_format(_T("EXPO_BOOKED_FOR_PARTICIPATION", "Your studio is due for participation in TIME."), "TIME", timeline:getTimePeriodText(self.conventionData:getTimeUntil(timeline.curTime))), "bh20", game.UI_COLORS.DARK_LIGHT_BLUE, 0, wrapWidth, "exclamation_point", 24, 24)
			self:addPresentedGames(descBox, wrapWidth)
		end
	end
	
	self.descBox = descBox
	
	self.descBox:centerToElement(self)
end

function gameConventionButton:onHide()
	self:killDescBox()
end

function gameConventionButton:onMouseLeft()
	gameConventionButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function gameConventionButton:fillInteractionComboBox(comboBox)
	if not gameConventions:isConventionInProgress(self.conventionData.id) and self.conventionData:canBookPresentation() then
		local option = comboBox:addOption(0, 0, 0, 24, _T("CONTINUE", "Continue"), fonts.get("pix20"), gameConventionButton.proceedToBooking)
		
		option.project = self.project
		option.conventionData = self.conventionData
	else
		local option = comboBox:addOption(0, 0, 0, 24, _T("EXPO_UNAVAILABLE", "Expo unavailable"), fonts.get("pix20"), nil)
	end
end

function gameConventionButton:onClick(x, y, key)
	interactionController:startInteraction(self, x, y)
end

function gameConventionButton:updateSprites()
	gameConventionButton.baseClass.updateSprites(self)
	
	local iconSize = gameConventionButton.iconSize
	local offset = gameConventionButton.backgroundOffset
	local innerOffset = gameConventionButton.innerOffset
	local scaledOff = _S(offset)
	local scaledInnerOffset = _S(innerOffset)
	local totalOffset = scaledOff + scaledInnerOffset
	local quadData = quadLoader:getQuadStructure(self.conventionData.icon)
	local iconW, iconH = quadData.w, quadData.h
	local iconScale = self.conventionData.quad:getScaleToSize(self.rawH - (offset + innerOffset) * 2)
	local adjustedIconW, adjustedIconH = iconW * iconScale, iconH * iconScale
	local scaledW, scaledH = _S(adjustedIconW), _S(adjustedIconH)
	local smallestIconSize = math.min(scaledW, scaledH)
	local scaledIconSize = _S(iconSize)
	local baseIconOffset = totalOffset + smallestIconSize
	
	self.textX = scaledOff * 2 + scaledW + scaledIconSize + _S(5)
	self.titleTextY = scaledOff
	self.costTextY = scaledOff + scaledIconSize
	self.beginTextY = scaledOff + scaledIconSize * 2.5 + scaledInnerOffset - self.smallFont:getHeight() * 0.5
	self.registrationTextY = scaledOff + scaledIconSize * 3.5 + scaledInnerOffset * 2 - self.smallFont:getHeight() * 0.5
	
	if self:isMouseOver() then
		self:setNextSpriteColor(gameConventionButton.baseBackgroundColorHover:unpack())
	else
		self:setNextSpriteColor(gameConventionButton.baseBackgroundColor:unpack())
	end
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", scaledOff, scaledOff, 0, self.rawW - offset * 2, self.rawH - offset * 2, 0, 0, -0.15)
	
	self:setNextSpriteColor(gameConventionButton.underIconColor:unpack())
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", baseIconOffset, scaledOff, 0, iconSize + innerOffset * 2, self.rawH - offset * 2, 0, 0, -0.15)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.conventionData.icon, scaledOff + scaledInnerOffset, scaledOff + scaledInnerOffset, 0, adjustedIconW, adjustedIconH, 0, 0, -0.1)
	
	local iconX = baseIconOffset + scaledInnerOffset
	
	self.cashSprite = self:allocateSprite(self.cashSprite, "wad_of_cash", iconX, scaledOff + scaledIconSize, 0, iconSize, iconSize, 0, 0, -0.1)
	self.clockSprite = self:allocateSprite(self.clockSprite, "clock_full", iconX, scaledOff + scaledIconSize * 2 + scaledInnerOffset, 0, iconSize, iconSize, 0, 0, -0.1)
	self.calendarSprite = self:allocateSprite(self.calendarSprite, "calendar", iconX, scaledOff + scaledIconSize * 3 + scaledInnerOffset * 2, 0, iconSize, iconSize, 0, 0, -0.1)
end

function gameConventionButton:draw(w, h)
	local pCol, tCol = self:getStateColor()
	
	love.graphics.setFont(self.bigFont)
	love.graphics.printST(self.titleText, self.textX, self.titleTextY, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
	love.graphics.printST(self.costText, self.textX, self.costTextY, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
	love.graphics.setFont(self.smallFont)
	love.graphics.printST(self.beginText, self.textX, self.beginTextY, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
	
	local registrationColor = self.conventionData:isBookedByPlayer() and self.registrationTextColor or tCol
	
	love.graphics.printST(self.registrationText, self.textX, self.registrationTextY, registrationColor.r, registrationColor.g, registrationColor.b, registrationColor.a, 0, 0, 0, 255)
end

gui.register("GameConventionSelectionButton", gameConventionButton, "Button")
