gameConventions = {}
gameConventions.registered = {}
gameConventions.registeredByID = {}
gameConventions.availableConventions = {}
gameConventions.EXTRA_MAX_PEOPLE_ATTRACTED_PER_VISITOR = 0.01
gameConventions.EXTRA_MAX_PEOPLE_ATTRACTED_PER_REPUTATION = 0.001
gameConventions.MINIMUM_ATTRACTED_PEOPLE = 0.01
gameConventions.MAX_ATTRACT_LOWER_PER_VISITOR = 0.05
gameConventions.VISITOR_ROUNDING_SEGMENT = 10
gameConventions.ISSUE_SCORE_AFFECTOR = 0.75
gameConventions.BASE_BOOTH_ATTRACTIVENESS = 0.2
gameConventions.BASE_BOOST_EFFICIENCY = 0.8
gameConventions.CHARISMA_BOOST = 0.2
gameConventions.PUBLIC_KNOWLEDGE_BOOST = 0.3
gameConventions.BASE_DEVELOPER_PRESENCE_ATTRACTIVENESS_BOOST = 0.2
gameConventions.ATTRACTED_PEOPLE_TO_POPULARITY = 1.75
gameConventions.INCREASED_EFFICIENCY = 2.5
gameConventions.BOOKING_IN_ADVANCE = timeline.DAYS_IN_MONTH * 2
gameConventions.MAX_EXTRA_VISITORS_FROM_PLAYER = 0.1
gameConventions.RATING_FOR_MAX_EXTRA_VISITORS = 48
gameConventions.RATING_FOR_EXTRA_VISITORS_PRAISE = 42
gameConventions.DRIVE_DROP_PER_DAY = 2
gameConventions.MINIMUM_GAME_POPULARITY_AFFECTOR = 0.01
gameConventions.DISLIKE_RATING_CUTOFF = 5
gameConventions.POST_RELEASE_POPULARITY_GAIN_DROP = 0.05
gameConventions.POST_RELEASE_POPULARITY_MAX_DROP = 0.1
gameConventions.INCREASED_EFFICIENCY_FACT = "increased_game_conventions_efficiency"
gameConventions.GAME_RESPONSE_BY_RATING = {
	_T("EXPO_GAME_RESPONSE_1", "thought 'GAME' was a joke"),
	_T("EXPO_GAME_RESPONSE_2", "thought 'GAME' was really bad"),
	_T("EXPO_GAME_RESPONSE_3", "thought 'GAME' was bad"),
	_T("EXPO_GAME_RESPONSE_4", "thought 'GAME' was not good"),
	_T("EXPO_GAME_RESPONSE_5", "thought 'GAME' was average"),
	_T("EXPO_GAME_RESPONSE_6", "said 'GAME' was not bad"),
	_T("EXPO_GAME_RESPONSE_7", "said 'GAME' was pretty good"),
	_T("EXPO_GAME_RESPONSE_8", "said 'GAME' was good"),
	_T("EXPO_GAME_RESPONSE_9", "said 'GAME' was great"),
	(_T("EXPO_GAME_RESPONSE_10", "said 'GAME' was fantastic"))
}
gameConventions.BOOTH_TYPES = {
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3
}
gameConventions.BACKGROUNDS = {
	[gameConventions.BOOTH_TYPES.SMALL] = {
		"convention_bg_small_1",
		"convention_bg_small_2",
		"convention_bg_small_3"
	},
	[gameConventions.BOOTH_TYPES.MEDIUM] = {
		"convention_bg_medium_1",
		"convention_bg_medium_2",
		"convention_bg_medium_3"
	},
	[gameConventions.BOOTH_TYPES.LARGE] = {
		"convention_bg_large_1",
		"convention_bg_large_2",
		"convention_bg_large_3"
	}
}
gameConventions.VISUAL_BOOTH_TYPES = {
	leftmost = {
		x = 2,
		y = 90,
		quads = {
			"convention_booth_bottom_1_1",
			"convention_booth_bottom_1_2",
			"convention_booth_bottom_1_3",
			"convention_booth_bottom_1_4"
		}
	},
	left = {
		x = 40,
		y = 90,
		quads = {
			"convention_booth_bottom_2_1",
			"convention_booth_bottom_2_2",
			"convention_booth_bottom_2_3",
			"convention_booth_bottom_2_4",
			"convention_booth_bottom_2_5",
			"convention_booth_bottom_2_6"
		}
	},
	right = {
		x = 98,
		y = 90,
		quads = {
			"convention_booth_bottom_3_1",
			"convention_booth_bottom_3_2",
			"convention_booth_bottom_3_3"
		},
		extra = {
			x = 102,
			y = 80,
			quads = {
				"convention_booth_banner_2_1",
				"convention_booth_banner_2_2",
				"convention_booth_banner_2_3",
				"convention_booth_banner_2_4"
			}
		}
	},
	rightmost = {
		x = 139,
		y = 90,
		quads = {
			"convention_booth_bottom_4_1",
			"convention_booth_bottom_4_2",
			"convention_booth_bottom_4_3"
		}
	},
	topright = {
		depthOffset = -0.1,
		x = 94,
		y = 16,
		quads = {
			"convention_booth_top_1_1",
			"convention_booth_top_1_2",
			"convention_booth_top_1_3",
			"convention_booth_top_1_4",
			"convention_booth_top_1_5",
			"convention_booth_top_1_6"
		}
	},
	toprightmost = {
		depthOffset = -0.1,
		x = 117,
		y = 16,
		quads = {
			"convention_booth_top_2_1",
			"convention_booth_top_2_2",
			"convention_booth_top_2_3",
			"convention_booth_top_2_4",
			"convention_booth_top_2_5",
			"convention_booth_top_2_6",
			"convention_booth_top_2_7",
			"convention_booth_top_2_8",
			"convention_booth_top_2_9",
			"convention_booth_top_2_10",
			"convention_booth_top_2_11",
			"convention_booth_top_2_12"
		}
	}
}
gameConventions.BOOTH_CONFIGS = {
	[gameConventions.BOOTH_TYPES.SMALL] = {
		gameConventions.VISUAL_BOOTH_TYPES.leftmost,
		gameConventions.VISUAL_BOOTH_TYPES.left,
		gameConventions.VISUAL_BOOTH_TYPES.right,
		gameConventions.VISUAL_BOOTH_TYPES.rightmost,
		gameConventions.VISUAL_BOOTH_TYPES.topright,
		gameConventions.VISUAL_BOOTH_TYPES.toprightmost
	},
	[gameConventions.BOOTH_TYPES.MEDIUM] = {
		gameConventions.VISUAL_BOOTH_TYPES.left,
		gameConventions.VISUAL_BOOTH_TYPES.right,
		gameConventions.VISUAL_BOOTH_TYPES.rightmost,
		gameConventions.VISUAL_BOOTH_TYPES.topright,
		gameConventions.VISUAL_BOOTH_TYPES.toprightmost
	},
	[gameConventions.BOOTH_TYPES.LARGE] = {
		gameConventions.VISUAL_BOOTH_TYPES.right,
		gameConventions.VISUAL_BOOTH_TYPES.rightmost,
		gameConventions.VISUAL_BOOTH_TYPES.topright,
		gameConventions.VISUAL_BOOTH_TYPES.toprightmost
	}
}
gameConventions.EVENTS = {
	ADD_PLAYER_PRESENTED_GAME = events:new(),
	REMOVE_PLAYER_PRESENTED_GAME = events:new(),
	STARTED = events:new(),
	FINISHED = events:new(),
	BOOTH_CHANGED = events:new(),
	PARTICIPANT_ADDED = events:new(),
	PARTICIPANT_REMOVED = events:new(),
	PARTICIPANTS_FULL = events:new(),
	GAME_TO_PRESENT_ADDED = events:new(),
	GAME_TO_PRESENT_REMOVED = events:new(),
	PARTICIPANTS_REMOVED = events:new()
}
gameConventions.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_MONTH,
	studio.EVENTS.EMPLOYEE_FIRED
}

local baseConventionFuncs = {}

baseConventionFuncs.mtindex = {
	__index = baseConventionFuncs
}

function baseConventionFuncs:init()
	self.hiredStaff = 0
	self.desiredEmployees = {}
	self.desiredGames = {}
	self.playerPresentedGames = {}
	self.exhibitingEmployees = {}
	self.scoresByGame = {}
	self.requiresReconfirmation = false
end

function baseConventionFuncs:remove()
	self:reset()
	self:clearDesiredData()
end

function baseConventionFuncs:reset()
	table.clearArray(self.playerPresentedGames)
	table.clearArray(self.exhibitingEmployees)
	table.clear(self.scoresByGame)
	table.clearArray(self.desiredGames)
	table.clearArray(self.desiredEmployees)
	
	self.bookedByPlayer = false
	self.playerBooth = false
	self.hiredStaff = 0
	self.bestGame = nil
	self.worstGame = nil
	self.totalGameScore = 0
	self.employeeAttractivenessBoost = 0
	self.playerParticipating = false
	self.playerParticipationDate = nil
	self.spentMoney = nil
	self.conventionTime = 0
	self.conventionFinishTime = 0
	self.inProgress = nil
	self.requiresReconfirmation = false
end

baseConventionFuncs.expoEfficiencyDisplaySize = 35

function baseConventionFuncs:getPresentableGameCount()
	local total = 0
	
	for key, projectObject in ipairs(studio:getGames()) do
		if not projectObject:canPresentAtConvention() then
			total = total + 1
		end
	end
	
	return total
end

baseConventionFuncs.sortedByEfficiency = {}

function baseConventionFuncs:createConventionBookingMenu(gameProj, reconfirmation, owner)
	self:setDesiredBooth(1)
	
	if gameProj and gameProj:canPresentAtConvention() then
		self:addDesiredGame(gameProj)
	end
	
	local frame = gui.create("ExpoSetupFrame", nil, reconfirmation and "CancelBookingCloseButton")
	
	frame:setSize(450, 600)
	frame:setFont("pix24")
	frame:setTitle(string.easyformatbykeys(_T("EXPO_BOOKING_FORMAT_TITLE", "EXPO Booking"), "EXPO", self.display))
	frame:setReconfirmation(reconfirmation)
	frame:setConventionData(self)
	
	if reconfirmation then
		local closeButton = frame:getCloseButton()
		
		closeButton:setConventionData(self)
	end
	
	local employeeParticipants = gui.create("ExpoParticipantsCategory", frame)
	
	employeeParticipants:setPos(_S(5), _S(33))
	employeeParticipants:setFont("pix24")
	employeeParticipants:setSize(frame.rawW - 10, 28)
	employeeParticipants:setConventionData(self)
	employeeParticipants:updateText()
	employeeParticipants:addDepth(50)
	
	local scrollerHeight = (frame.rawH - 36 - baseConventionFuncs.expoEfficiencyDisplaySize) / 2 - employeeParticipants:getRawHeight() * 2
	local participantsScroller = gui.create("ScrollbarPanel", frame)
	
	participantsScroller:setPos(_S(5), employeeParticipants.y + _S(5) + employeeParticipants.h)
	participantsScroller:setSize(frame.rawW - 10, scrollerHeight)
	participantsScroller:setAdjustElementPosition(true)
	participantsScroller:setPadding(3, 3)
	participantsScroller:setSpacing(3)
	participantsScroller:addDepth(75)
	
	local availableEmployees = gui.create("Category")
	
	availableEmployees:setFont("pix22")
	availableEmployees:setText(_T("AVAILABLE_EMPLOYEES", "Available employees"))
	availableEmployees:assumeScrollbar(participantsScroller)
	participantsScroller:addItem(availableEmployees)
	
	local unavailableEmployees = gui.create("Category")
	
	unavailableEmployees:setFont("pix22")
	unavailableEmployees:setText(_T("UNAVAILABLE_EMPLOYEES", "Unavailable employees"))
	unavailableEmployees:assumeScrollbar(participantsScroller)
	participantsScroller:addItem(unavailableEmployees)
	
	local desiredWidth = participantsScroller:getElementWidth()
	
	if gameProj then
		owner = owner or gameProj:getOwner()
	end
	
	owner = owner or studio
	
	local employees = owner:getEmployees()
	local eCount = #employees
	local sortedByEfficiency = baseConventionFuncs.sortedByEfficiency
	
	for key, employee in ipairs(employees) do
		sortedByEfficiency[key] = employee
	end
	
	for key, employee in ipairs(sortedByEfficiency) do
		local eff = gameConventions:calculateEmployeeBoost(employee)
		local swapKey = key
		local swapEmployee
		local curEff = eff
		
		for oKey = key, eCount do
			local oEmployee = sortedByEfficiency[oKey]
			
			if oEmployee ~= employee then
				local oEff = gameConventions:calculateEmployeeBoost(oEmployee)
				
				if oEff < curEff then
					swapKey = oKey
					swapEmployee = oEmployee
					curEff = oEff
				end
			end
		end
		
		if swapKey ~= key then
			sortedByEfficiency[key], sortedByEfficiency[swapKey] = swapEmployee, employee
		else
			sortedByEfficiency[key] = employee
		end
	end
	
	for key, employee in ipairs(sortedByEfficiency) do
		local element = gui.create("ExpoParticipantSelection")
		
		element:setWidth(desiredWidth)
		element:setConventionData(self)
		
		if self:canEmployeeBeBooked(employee) then
			availableEmployees:addItem(element, true)
		else
			unavailableEmployees:addItem(element, true)
		end
		
		element:setEmployee(employee)
	end
	
	local gamesToPresent = gui.create("ExpoGamesCategory", frame)
	
	gamesToPresent:setPos(_S(5), participantsScroller.y + _S(5) + participantsScroller.h)
	gamesToPresent:setFont("pix24")
	gamesToPresent:setSize(frame.rawW - 10, 28)
	gamesToPresent:setConventionData(self)
	gamesToPresent:updateText()
	gamesToPresent:addDepth(200)
	
	local gamesScroller = gui.create("ScrollbarPanel", frame)
	
	gamesScroller:setPos(_S(5), gamesToPresent.y + _S(5) + gamesToPresent.h)
	gamesScroller:setSize(frame.rawW - 10, scrollerHeight)
	gamesScroller:setAdjustElementPosition(true)
	gamesScroller:setPadding(3, 3)
	gamesScroller:setSpacing(3)
	gamesScroller:addDepth(225)
	
	for key, projectObject in ipairs(owner:getGames()) do
		if projectObject:canPresentAtConvention() then
			local element = gui.create("GameToPresentSelection")
			
			element:setWidth(desiredWidth)
			element:setConventionData(self)
			gamesScroller:addItem(element)
			element:setProject(projectObject)
		end
	end
	
	local efficiencyDisplay = gui.create("ExpoEfficiencyBarDisplay", frame)
	
	efficiencyDisplay:setPos(_S(5), gamesScroller.y + gamesScroller.h + _S(5))
	efficiencyDisplay:setSize(frame.rawW - 10, baseConventionFuncs.expoEfficiencyDisplaySize)
	efficiencyDisplay:setConventionData(self)
	efficiencyDisplay:addDepth(1000)
	
	local costDisplay = gui.create("ExpoCostDisplay", frame)
	
	costDisplay:setConventionData(self)
	costDisplay:setFont("pix22")
	costDisplay:setSize(250, 28)
	costDisplay:setPos(_S(5), frame.h - costDisplay.h - _S(5))
	costDisplay:updateCost()
	costDisplay:addDepth(1000)
	
	local bookExpoButton = gui.create("BookExpoButton", frame)
	
	bookExpoButton:setConventionData(self)
	bookExpoButton:setPos(costDisplay.w + costDisplay.x + _S(5), costDisplay.y)
	bookExpoButton:setSize(frame.rawW - costDisplay.rawW - 15, 28)
	bookExpoButton:setFont("pix24")
	bookExpoButton:setText(_T("BOOK_EXPO", "Book expo"))
	bookExpoButton:addDepth(1000)
	frame:center()
	
	local boothList = gui.create("TitledList")
	
	boothList:setFont("bh20")
	boothList:setTitle(_T("BOOTHS_TITLE", "Booths"))
	boothList:setBasePoint(frame.x + frame.w + _S(10), frame.y)
	boothList:setAlignment(gui.SIDES.RIGHT, nil)
	boothList:setDepth(1000)
	boothList:setWidth(100)
	
	local buttonSize = 100
	
	for key, boothData in ipairs(self.booths) do
		local boothSelection = gui.create("ExpoBoothSelection", boothList)
		
		boothSelection:setConventionData(self)
		boothSelection:setBoothID(key)
		boothSelection:setSize(buttonSize, buttonSize)
	end
	
	frame:setBoothList(boothList)
	frameController:push(frame)
end

function baseConventionFuncs:getSortedByEfficiencyList()
	return baseConventionFuncs.sortedByEfficiency
end

function baseConventionFuncs:isAvailable()
	if self.availability then
		return unlocks:isAvailable(self.availabilityFact)
	end
	
	return true
end

function baseConventionFuncs:getID()
	return self.id
end

function baseConventionFuncs:getName()
	return self.display
end

function baseConventionFuncs:getDesiredFee()
	local total, entry, booth, staff = self:calculateFee(self:getDesiredBooth(), #self:getDesiredEmployees())
	
	return total, entry, booth, staff, self.paidFee and total - self.paidFee or total
end

function baseConventionFuncs:getPaidFee()
	return self.paidFee
end

function baseConventionFuncs:calculateFee(boothID, ownStaff)
	if not boothID then
		return 0
	end
	
	local boothData = self.booths[boothID]
	local entryFee = self.entryFee
	local boothCost = boothData.cost
	local staffCost = (boothData.requiredParticipants - ownStaff) * self.staffCost * self.duration
	
	return entryFee + boothCost + staffCost, entryFee, boothCost, staffCost
end

function baseConventionFuncs:book()
	local amountToPay = self:getDesiredFee()
	
	self.bookedByPlayer = true
	self.hiredStaff = self.booths[self.desiredBooth].requiredParticipants - #self.desiredEmployees
	
	for key, employee in ipairs(self.desiredEmployees) do
		employee:setBookedExpo(self.id)
	end
	
	local previousPaidFee = self.paidFee
	
	self.paidFee = amountToPay
	
	if previousPaidFee then
		amountToPay = amountToPay - previousPaidFee
	end
	
	if not self.spentMoney then
		self.spentMoney = amountToPay
	else
		self.spentMoney = self.spentMoney + amountToPay
	end
	
	studio:deductFunds(amountToPay, nil, "marketing")
	
	local popup = game.createPopup(500, _T("EXPO_BOOKED_TITLE", "Expo Spot Booked"), string.easyformatbykeys(_T("EXPO_BOOKED_DESCRIPTION", "'EXPO' exhibitor spot booked!\nThe expo will begin in TIME."), "EXPO", self.display, "TIME", timeline:getTimePeriodText(self:getTimeUntil(timeline.curTime))), "pix24", "pix20")
	
	frameController:push(popup)
	table.clearArray(baseConventionFuncs.sortedByEfficiency)
	
	self.requiresReconfirmation = false
end

function baseConventionFuncs:findBestGame()
	local highestScore = 0
	local bestGame
	local lowestScore = math.huge
	local worstGame
	local totalScore = 0
	
	for key, gameObj in ipairs(self.playerPresentedGames) do
		local thisScore = review:getCurrentGameVerdict(gameObj, gameConventions.ISSUE_SCORE_AFFECTOR)
		
		self.scoresByGame[gameObj] = thisScore
		
		if highestScore <= thisScore then
			highestScore = thisScore
			bestGame = gameObj
		end
		
		if thisScore < lowestScore then
			lowestScore = thisScore
			worstGame = gameObj
		end
		
		totalScore = totalScore + thisScore
	end
	
	self.bestGame = bestGame
	
	if bestGame ~= worstGame then
		self.worstGame = worstGame
	end
	
	self.totalGameScore = totalScore
end

function baseConventionFuncs:handleGameScrap(projectObj)
	local valid = table.removeObject(self.desiredGames, projectObj)
	
	valid = valid or table.removeObject(self.playerPresentedGames, projectObj)
	
	if valid then
		self:createPostScrapBookingPopup(projectObj)
	end
end

function baseConventionFuncs:handleGameOffMarket(projectObj)
	if self.playerParticipating or self:canBegin(timeline:getMonth()) and not gameConventions:isConventionInProgress(self.id) then
		return 
	end
	
	local valid = table.removeObject(self.desiredGames, projectObj)
	
	valid = valid or table.removeObject(self.playerPresentedGames, projectObj)
	
	if valid then
		self:createPostOffMarketPopup(projectObj)
	end
end

function baseConventionFuncs:addMoreGames()
	self.conventionData:createConventionBookingMenu(nil, true, studio)
end

function baseConventionFuncs:resetConfirmationRequirementCallback()
	self.conventionData:resetConfirmationRequirement()
end

function baseConventionFuncs:createPostScrapBookingPopup(scrappedGame)
	if self.requiresReconfirmation then
		return 
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:hideCloseButton()
	popup:setFont("pix24")
	popup:setTitle(_T("GAME_PROJECT_SCRAPPED_TITLE", "Game Project Scrapped"))
	popup:setTextFont("pix20")
	
	local baseText
	local remainingGames = math.max(#self.desiredGames, #self.playerPresentedGames)
	local doNothing = false
	
	if remainingGames > 0 then
		if remainingGames == 1 then
			baseText = _format(_T("GAME_PROJECT_SCRAPPED_CONVENTION_DETAIL_SINGLE_GAME", "You've scrapped 'GAME' which was booked for presentation at 'CONVENTION'. You are booked to present one more game."), "GAME", scrappedGame:getName(), "CONVENTION", self.display)
		else
			baseText = _format(_T("GAME_PROJECT_SCRAPPED_CONVENTION_DETAIL_MULTIPLE_GAMES", "You've scrapped 'GAME' which was booked for presentation at 'CONVENTION'. You are booked to present MORE more games."), "GAME", scrappedGame:getName(), "CONVENTION", self.display, "MORE", remainingGames)
		end
		
		doNothing = true
	else
		baseText = _format(_T("GAME_PROJECT_SCRAPPED_CONVENTION_DETAIL_NO_GAMES", "You've scrapped 'GAME' which was booked for presentation at 'CONVENTION'. This was the only game you were going to present at the convention."), "GAME", scrappedGame:getName(), "CONVENTION", self.display)
	end
	
	popup:setText(baseText)
	
	local left, right, extra = popup:getDescboxes()
	local button = popup:addButton("pix20", _T("ADD_MORE_GAMES", "Add more games"), baseConventionFuncs.addMoreGames)
	
	button.conventionData = self
	
	local button = popup:addButton("pix20", _T("CANCEL_EXPO_BOOKING", "Cancel expo booking"), baseConventionFuncs.cancelExpoBookingCallback)
	
	button.conventionData = self
	
	if doNothing then
		local button = popup:addButton("pix20", _T("DO_NOTHING", "Do nothing"), baseConventionFuncs.resetConfirmationRequirementCallback)
		
		button.conventionData = self
	end
	
	popup:center()
	frameController:push(popup)
	
	self.requiresReconfirmation = true
end

function baseConventionFuncs:createPostOffMarketPopup(offmarketGame)
	if self.requiresReconfirmation then
		return 
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:hideCloseButton()
	popup:setFont("pix24")
	popup:setTitle(_T("GAME_PROJECT_OFFMARKET_TITLE", "Game Project Off-market"))
	popup:setTextFont("pix20")
	
	local baseText
	local remainingGames = math.max(#self.desiredGames, #self.playerPresentedGames)
	local doNothing = false
	
	if remainingGames > 0 then
		if remainingGames == 1 then
			baseText = _format(_T("GAME_OFFMARKET_CONVENTION_DETAIL_SINGLE_GAME", "'GAME', which was booked for presentation at 'CONVENTION', has gone off-market. There is no point in presenting it if it isn't going to yield any sales.\n\nYou are booked to present one more game."), "GAME", offmarketGame:getName(), "CONVENTION", self.display)
		else
			baseText = _format(_T("GAME_OFFMARKET_CONVENTION_DETAIL_MULTIPLE_GAMES", "'GAME', which was booked for presentation at 'CONVENTION', has gone off-market. There is no point in presenting it if it isn't going to yield any sales.\n\nYou are booked to present MORE more games."), "GAME", offmarketGame:getName(), "CONVENTION", self.display, "MORE", remainingGames)
		end
		
		doNothing = true
	else
		baseText = _format(_T("GAME_OFFMARKET_CONVENTION_DETAIL_NO_GAMES", "'GAME', which was booked for presentation at 'CONVENTION', has gone off-market. There is no point in presenting it if it isn't going to yield any sales.\n\nThis was the only game you were going to present at the convention."), "GAME", offmarketGame:getName(), "CONVENTION", self.display)
	end
	
	popup:setText(baseText)
	
	local left, right, extra = popup:getDescboxes()
	local button = popup:addButton("pix20", _T("ADD_MORE_GAMES", "Add more games"), baseConventionFuncs.addMoreGames)
	
	button.conventionData = self
	
	local button = popup:addButton("pix20", _T("CANCEL_EXPO_BOOKING", "Cancel expo booking"), baseConventionFuncs.cancelExpoBookingCallback)
	
	button.conventionData = self
	
	if doNothing then
		local button = popup:addButton("pix20", _T("DO_NOTHING", "Do nothing"), baseConventionFuncs.resetConfirmationRequirement)
		
		button.conventionData = self
	end
	
	popup:center()
	frameController:push(popup)
	
	self.requiresReconfirmation = true
end

function baseConventionFuncs:createPostLoadRebookingPopup()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:hideCloseButton()
	popup:setFont("pix24")
	popup:setTitle(_T("NO_GAMES_FOR_CONVENTION_TITLE", "No Games for Convention"))
	popup:setTextFont("pix20")
	
	local baseText = _format(_T("CONVENTION_NO_GAMES_TO_PRESENT", "You have no games booked for presentation at 'CONVENTION'\n\nYou must now either select new games to present there, or cancel the expo booking altogether."), "CONVENTION", self.display)
	
	popup:setText(baseText)
	
	local left, right, extra = popup:getDescboxes()
	local button = popup:addButton("pix20", _T("ADD_MORE_GAMES", "Add more games"), baseConventionFuncs.addMoreGames)
	
	button.conventionData = self
	
	local button = popup:addButton("pix20", _T("CANCEL_EXPO_BOOKING", "Cancel expo booking"), baseConventionFuncs.cancelExpoBookingCallback)
	
	button.conventionData = self
	
	popup:center()
	frameController:push(popup)
end

function baseConventionFuncs:calculateDesiredEmployeeBoost()
	return self:_calculateEmployeeBoost(self.desiredEmployees, self.desiredBooth)
end

function baseConventionFuncs:calculateEmployeeBoost(employeeList, boothID)
	self.employeeAttractivenessBoost = self:_calculateEmployeeBoost(employeeList, boothID)
end

function baseConventionFuncs:_calculateEmployeeBoost(employeeList, boothID)
	employeeList = employeeList or self.exhibitingEmployees
	boothID = boothID or self.playerBooth
	
	local requiredStaff = self.booths[boothID].requiredParticipants
	local hiredStaff = self.hiredStaff or requiredStaff - #employeeList
	local totalBoostScore = 0
	
	for key, employee in ipairs(employeeList) do
		totalBoostScore = totalBoostScore + gameConventions:calculateEmployeeBoost(employee)
	end
	
	return math.min(gameConventions:getMaxEmployeeBoost(), gameConventions.BASE_BOOST_EFFICIENCY + totalBoostScore / requiredStaff)
end

function baseConventionFuncs:attractPeople(boothID)
	if not self.bestGame then
		error("no best game found in presentable games during expo!")
	end
	
	local visitors = gameConventions:getVisitors(self.id)
	local attractedVisitors = gameConventions:getAttractedVisitors(self.id)
	local boothSize = self.booths[boothID].maxPeopleHoused
	local gameScoreAffector = gameConventions.BASE_BOOTH_ATTRACTIVENESS * math.max(gameConventions.MINIMUM_GAME_POPULARITY_AFFECTOR, (self.scoresByGame[self.bestGame] - review.minRating) / (review.maxRating - review.minRating))
	local attractedPeople = visitors * gameScoreAffector * self.employeeAttractivenessBoost
	local maxAttractedPeople = math.max(boothSize * gameConventions.MINIMUM_ATTRACTED_PEOPLE, boothSize + gameConventions.EXTRA_MAX_PEOPLE_ATTRACTED_PER_VISITOR * visitors + studio:getReputation() * gameConventions.EXTRA_MAX_PEOPLE_ATTRACTED_PER_REPUTATION - attractedVisitors * gameConventions.MAX_ATTRACT_LOWER_PER_VISITOR) * self.employeeAttractivenessBoost
	local realAttractedPeople = math.min(maxAttractedPeople, attractedPeople)
	
	return math.round(realAttractedPeople)
end

function baseConventionFuncs:handleEvent(event, data)
	if event == timeline.EVENTS.NEW_DAY then
		for key, employeeObj in ipairs(self.exhibitingEmployees) do
			employeeObj:addDrive(-gameConventions.DRIVE_DROP_PER_DAY * employeeObj:getExpoDriveDropMultiplier())
		end
		
		if self.playerParticipating then
			gameConventions:addAttractedVisitors(self.id, self:attractPeople(self.playerBooth))
		end
		
		if self:shouldFinish() then
			self:finish()
		end
	end
end

function baseConventionFuncs:setHiredStaff(amount)
	self.hiredStaff = amount
end

function baseConventionFuncs:setBooth(boothID)
	self.playerBooth = boothID
end

function baseConventionFuncs:getParticipationDate()
	return self.playerParticipationDate
end

function baseConventionFuncs:isPlayerParticipating()
	return self.playerParticipating
end

function baseConventionFuncs:clearDesiredData()
	for key, employeeObj in ipairs(self.desiredEmployees) do
		employeeObj:setBookedExpo(nil)
		
		self.desiredEmployees[key] = nil
	end
	
	table.clearArray(self.desiredGames)
	table.clearArray(baseConventionFuncs.sortedByEfficiency)
	
	self.desiredBooth = nil
end

function baseConventionFuncs:transferDesiredStuff()
	self:setBooth(self.desiredBooth)
	
	for key, gameObj in ipairs(self.desiredGames) do
		table.insert(self.playerPresentedGames, gameObj)
		
		self.desiredGames[key] = nil
	end
	
	for key, participant in ipairs(self.desiredEmployees) do
		table.insert(self.exhibitingEmployees, participant)
		
		self.desiredEmployees[key] = nil
	end
end

local participantTeamsReevaluate = {}

eventBoxText:registerNew({
	id = "expo_begun",
	getText = function(self, data)
		return _format(_T("EXPO_HAS_BEGUN", "'EXPO' has begun!"), "EXPO", gameConventions.registeredByID[data].display)
	end
})

function baseConventionFuncs:begin()
	self.conventionTime = timeline.curTime
	self.conventionFinishTime = self.conventionTime + self.duration
	self.totalGameScore = 0
	self.playerParticipating = false
	self.inProgress = true
	
	if self.bookedByPlayer then
		self:transferDesiredStuff()
		
		if #self.playerPresentedGames == 0 then
			error("attempt to participate in expo with 0 presented games!")
		end
		
		self:calculateEmployeeBoost()
		self:findBestGame()
		
		self.playerParticipationDate = timeline.curTime
		self.playerParticipating = true
		self.bookedByPlayer = false
		
		gameConventions:resetAttractedVisitors(self.id)
		
		for key, participant in ipairs(self.exhibitingEmployees) do
			participant:setAwayUntil(self.conventionFinishTime, true)
			
			local team = participant:getTeam()
			
			if team then
				participantTeamsReevaluate[team] = true
			end
		end
		
		for team, state in pairs(participantTeamsReevaluate) do
			team:reassignEmployees()
			
			participantTeamsReevaluate[team] = nil
		end
	end
	
	self:clearDesiredData()
	game.addToEventBox("expo_begun", self.id, 1)
end

function baseConventionFuncs:isInProgress()
	return self.inProgress
end

function baseConventionFuncs:getGameScore(gameObj)
	return review:getCurrentGameVerdict(gameProj, gameConventions.ISSUE_SCORE_AFFECTOR)
end

function baseConventionFuncs:getLastYearsPlayerRating()
	return self.lastYearsTotalRating or 0
end

function baseConventionFuncs:canEmployeeBeBooked(employee)
	if employee:getAwayUntil() then
		return false
	end
	
	local expo = employee:getBookedExpo()
	
	if expo and expo ~= self.id then
		return false
	end
	
	return true
end

eventBoxText:registerNew({
	id = "expo_finished",
	getText = function(self, data)
		return _format(_T("EXPO_HAS_ENDED", "'EXPO' has finished."), "EXPO", gameConventions.registeredByID[data].display)
	end
})

function baseConventionFuncs:finish()
	if self.playerParticipating then
		local visitorCount = gameConventions:getAttractedVisitors(self.id)
		local gameCount = #self.playerPresentedGames
		local maxScale = platformShare:getMaxGameScale()
		local gainedPopularity = visitorCount * gameConventions:getAttractivenessMultiplier()
		local realPopGain = 0
		local highestScore = self.scoresByGame[self.bestGame]
		local time = timeline.curTime
		
		for gameObj, score in pairs(self.scoresByGame) do
			local releaseDate = gameObj:getReleaseDate()
			local gain = highestScore / score / gameCount * gainedPopularity * (gameObj:getScale() / maxScale)
			
			if releaseDate then
				gain = gain * math.max(gameConventions.POST_RELEASE_POPULARITY_MAX_DROP, 1 - (time - releaseDate) * gameConventions.POST_RELEASE_POPULARITY_GAIN_DROP)
			end
			
			realPopGain = realPopGain + gain
			
			gameObj:increasePopularity(gain, true)
			
			if not gameObj:wasAnnounced() then
				gameObj:announce()
			end
		end
		
		for key, participant in ipairs(self.exhibitingEmployees) do
			participant:setBookedExpo(nil)
			
			self.exhibitingEmployees[key] = nil
		end
		
		local sizeMult = 3
		local width, height = 160 * sizeMult, 89 * sizeMult
		local resultFrame = gui.create("GameConventionResultPopup")
		
		resultFrame:setFont("pix24")
		resultFrame:setTitle(_T("EXPO_RESULTS_TITLE", "Expo Results"))
		resultFrame:setTextFont("pix20")
		resultFrame:setText("")
		resultFrame:setSize(width + 10, height + 30)
		resultFrame:setBaseHeight(100 * sizeMult)
		resultFrame:setDescboxOffset(52 * sizeMult)
		resultFrame:addDepth(400)
		
		local panel = gui.create("Panel", resultFrame)
		
		panel:setScissor(true)
		panel:setSize(width, height)
		panel:setPos(_S(5), _S(30))
		
		panel.shouldDraw = false
		
		panel:addDepth(40)
		
		local resultDisplay = gui.create("GameConventionResultFrame", panel)
		
		resultDisplay:setSize(width, height)
		resultDisplay:setBoothSize(self:getBoothType(self.playerBooth))
		resultDisplay:setVisitorCount(visitorCount)
		
		local left, right, extra = resultFrame:getDescboxes()
		
		left:addSpaceToNextText(10)
		right:addSpaceToNextText(10)
		
		local wrapWidth = resultFrame.rawW * 0.5 - 20
		local fullWrapWidth = resultFrame.rawW - 20
		
		left:addText(_format(_T("EXPO_VISITORS", "Expo visitors: VISITORS"), "VISITORS", string.comma(gameConventions:getVisitors(self.id))), "pix20", nil, 0, wrapWidth, {
			{
				height = 24,
				icon = "generic_backdrop",
				width = 24
			},
			{
				width = 20,
				icon = "employees",
				x = 2,
				height = 20
			}
		})
		left:addText(_format(_T("BOOTH_VISITORS", "Booth visitors: VISITORS"), "VISITORS", string.comma(gameConventions:getAttractedVisitors(self.id))), "pix20", nil, 0, wrapWidth, {
			{
				height = 24,
				icon = "generic_backdrop",
				width = 24
			},
			{
				width = 20,
				icon = "employees",
				x = 2,
				height = 20
			}
		})
		left:addText(_format(_T("EXPO_GAINED_REPUTATION", "Gained popularity: POP"), "POP", string.comma(realPopGain)), "pix20", nil, 0, wrapWidth, "star", 24, 24)
		right:addText(_format(_T("EXPO_PRESENTED_GAMES", "Presented games: GAMES"), "GAMES", #self.playerPresentedGames), "pix20", nil, 0, wrapWidth, {
			{
				height = 24,
				icon = "generic_backdrop",
				width = 24
			},
			{
				width = 20,
				icon = "icon_games_tab",
				x = 2
			}
		})
		right:addText(_format(_T("EXPO_SPENT_MONEY", "Spent money: $GAMES"), "GAMES", string.comma(self.spentMoney or 0)), "pix20", nil, 0, wrapWidth, {
			{
				height = 24,
				icon = "generic_backdrop",
				width = 24
			},
			{
				width = 20,
				icon = "wad_of_cash_minus",
				x = 2,
				height = 20
			}
		})
		
		local bestGameRating = self.scoresByGame[self.bestGame]
		local responses = gameConventions.GAME_RESPONSE_BY_RATING
		
		if self.worstGame then
			extra:addText(_format(_T("EXPO_GAME_REACTION_2_GAMES", "Booth visitors BESTGAME and WORSTGAME"), "BESTGAME", _format(responses[math.floor(bestGameRating)], "GAME", self.bestGame:getName()), "WORSTGAME", _format(responses[math.floor(self.scoresByGame[self.worstGame])], "GAME", self.worstGame:getName())), "pix20", nil, 0, fullWrapWidth, "exclamation_point", 22, 22)
		else
			local formatText = _format(responses[math.floor(bestGameRating)], "GAME", self.bestGame:getName())
			local extraInfo, icon
			
			if bestGameRating < gameConventions.DISLIKE_RATING_CUTOFF then
				extraInfo = _format(_T("EXPO_GAME_REACTION_1_GOOD_GAME", "Booth visitors didn't particularly like the game you were presenting and FORMAT."), "FORMAT", formatText)
				icon = "exclamation_point_red"
			else
				extraInfo = _format(_T("EXPO_GAME_REACTION_1_BAD_GAME", "Booth visitors seemed to like the game you were presenting and FORMAT."), "FORMAT", formatText)
				icon = "exclamation_point"
			end
			
			extra:addText(extraInfo, "pix20", nil, 0, fullWrapWidth, icon, 22, 22)
		end
		
		extra:addText(_T("EXPO_GAINED_POPULARITY_SPLIT", "Gained popularity has been split between all presented games."), "bh20", nil, 0, fullWrapWidth, "question_mark", 24, 24)
		
		if self.visitorPlayerAffector >= gameConventions.RATING_FOR_EXTRA_VISITORS_PRAISE then
			extra:addText(_T("EXPO_SUCCESS_DESCRIPTION", "The quality of the games you've showcased last year increased the amount of visitors here this year. As a result, more people visited your booth."), "pix20", nil, fullWrapWidth, "exclamation_point", 22, 22)
		end
		
		resultFrame:addOKButton("pix20")
		resultFrame:center()
		frameController:push(resultFrame)
		gameConventions:setGainedPopularity(self.id, realPopGain)
		table.clear(self.scoresByGame)
		
		for key, gameObj in ipairs(self.playerPresentedGames) do
			self.playerPresentedGames[key] = nil
		end
	end
	
	self.previousPaidFee = self.paidFee
	self.paidFee = nil
	self.conventionFinishTime = timeline.curTime
	self.lastYearsTotalRating = self.totalGameScore
	self.totalGameScore = nil
	self.playerParticipating = false
	self.bestGame = nil
	self.worstGame = nil
	self.inProgress = nil
	self.spentMoney = nil
	
	game.addToEventBox("expo_finished", self.id, 1)
	gameConventions:removeConventionFromInProgress(self)
end

function baseConventionFuncs:addDesiredGame(game)
	if self:hasDesiredGame(game) then
		return 
	end
	
	self.desiredGames[#self.desiredGames + 1] = game
	
	events:fire(gameConventions.EVENTS.GAME_TO_PRESENT_ADDED, game)
end

function baseConventionFuncs:removeDesiredGame(game)
	local has, key = self:hasDesiredGame(game)
	
	if key then
		table.remove(self.desiredGames, key)
		events:fire(gameConventions.EVENTS.GAME_TO_PRESENT_REMOVED, game)
	end
end

function baseConventionFuncs:hasDesiredGame(game)
	for key, gameObj in ipairs(self.desiredGames) do
		if gameObj == game then
			return true, key
		end
	end
	
	return false, nil
end

function baseConventionFuncs:getDesiredGames()
	return self.desiredGames
end

function baseConventionFuncs:getPlayerPresentedGames()
	return self.playerPresentedGames
end

function baseConventionFuncs:getGameList()
	if #self.desiredGames > 0 then
		return self.desiredGames
	end
	
	return self.playerPresentedGames
end

function baseConventionFuncs:addDesiredEmployee(employee)
	if #self.desiredEmployees >= self.booths[self.desiredBooth].requiredParticipants then
		local ourBoost = gameConventions:calculateEmployeeBoost(employee)
		local lowestContributor, index = ourBoost
		
		for key, desiredEmployee in ipairs(self.desiredEmployees) do
			local theirBoost = gameConventions:calculateEmployeeBoost(desiredEmployee)
			
			if theirBoost < ourBoost and theirBoost < lowestContributor then
				lowestContributor = theirBoost
				index = key
			end
		end
		
		if not index then
			events:fire(gameConventions.EVENTS.PARTICIPANTS_FULL, employee)
			
			return 
		else
			self:removeDesiredEmployee(self.desiredEmployees[index])
		end
	end
	
	self.desiredEmployees[#self.desiredEmployees + 1] = employee
	
	events:fire(gameConventions.EVENTS.PARTICIPANT_ADDED, employee)
end

function baseConventionFuncs:removeDesiredEmployee(employee)
	local has, key = self:hasDesiredEmployee(employee)
	
	if key then
		table.remove(self.desiredEmployees, key)
		events:fire(gameConventions.EVENTS.PARTICIPANT_REMOVED, employee)
	end
end

function baseConventionFuncs:removeDesiredEmployees()
	table.clearArray(self.desiredEmployees)
	events:fire(gameConventions.EVENTS.PARTICIPANTS_REMOVED, self)
end

function baseConventionFuncs:hasDesiredEmployee(employee)
	for key, employeeObj in ipairs(self.desiredEmployees) do
		if employeeObj == employee then
			return true, key
		end
	end
	
	return false, nil
end

function baseConventionFuncs:isGameBeingPresented(gameObj)
	if not table.find(self.desiredGames, gameObj) then
		return table.find(self.playerPresentedGames, gameObj)
	else
		return true
	end
	
	return false
end

function baseConventionFuncs:getDesiredEmployees()
	return self.desiredEmployees
end

local sortedByBoost = {}
local precalculatedBoostLevels = {}

local function sortByBoost(a, b)
	return precalculatedBoostLevels[a] < precalculatedBoostLevels[b]
end

function baseConventionFuncs:removeExhibitingEmployee(employee)
	table.removeObject(self.exhibitingEmployees, employee)
end

function baseConventionFuncs:cancel()
	self.bookedByPlayer = false
	self.playerParticipating = false
	self.hiredStaff = 0
	
	self:clearDesiredData()
	table.clear(self.scoresByGame)
	table.clearArray(self.playerPresentedGames)
	self:createCancellationPopup()
	
	if self.spentMoney then
		studio:addFunds(self.spentMoney)
		
		self.spentMoney = nil
	end
	
	self.paidFee = nil
	self.requiresReconfirmation = false
end

function baseConventionFuncs:createCancellationPopup()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont("pix24")
	popup:setTitle(_T("EXPO_BOOKING_CANCELLED_TITLE", "Expo Booking Cancelled"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("EXPO_BOOKING_CANCELLED_DESC", "You've cancelled your booth booking for 'CONVENTION'."), "CONVENTION", self.display))
	
	local left, right, extra = popup:getDescboxes()
	
	if self.spentMoney then
		local wrapWidth = popup.rawW - 25
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("EXPO_BOOKING_CANCELLED_MONEY_BACK", "The $FUNDS you had reserved for it have been recouped."), "FUNDS", string.roundtobignumber(self.spentMoney)), "bh20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
	end
	
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
end

function baseConventionFuncs:onEmployeeLeft(employee)
	if self.playerParticipating then
		self:removeExhibitingEmployee(employee)
		self:calculateEmployeeBoost()
	else
		self:removeDesiredEmployee(employee)
		
		if self:canBegin(timeline:getMonth()) and not gameConventions:isConventionInProgress(self.id) then
			return 
		end
		
		self:createReconfirmationPopup()
	end
end

function baseConventionFuncs:goToConventionReconfirmationCallback()
	local data = self.conventionData
	local list = data:getDesiredGames()
	local gameObj
	
	if #list > 0 then
		gameObj = list[1]
	else
		gameObj = data:getPlayerPresentedGames()[1]
	end
	
	data:createConventionBookingMenu(gameObj, true, studio)
end

function baseConventionFuncs:cancelExpoBookingCallback()
	self.conventionData:cancel()
end

function baseConventionFuncs:resetConfirmationRequirement()
	self.requiresReconfirmation = false
end

function baseConventionFuncs:createReconfirmationPopup()
	if self.requiresReconfirmation then
		return 
	end
	
	local popup = game.createPopup(500, _T("EXPO_BOOKING_RECONFIRMATION_NEEDED_TITLE", "Expo Booking Re-confirmation Needed"), string.easyformatbykeys(_T("EXPO_BOOKING_RECONFIRMATION_NEEDED_DESCRIPTION", "An employee that was supposed to take part in the 'EXPO' game exposition is no longer part of this office.\n\nYou will now need to either re-confirm the expo booking or cancel it altogether."), "EXPO", self.display), "pix24", "pix20", true)
	local button = popup:addButton("pix20", _T("PROCEED", "Proceed"), baseConventionFuncs.goToConventionReconfirmationCallback)
	
	button.conventionData = self
	
	local button = popup:addButton("pix20", _T("CANCEL_EXPO_BOOKING", "Cancel expo booking"), baseConventionFuncs.cancelExpoBookingCallback)
	
	button.conventionData = self
	
	popup:hideCloseButton()
	frameController:push(popup)
	
	self.requiresReconfirmation = true
end

function baseConventionFuncs:setDesiredBooth(id)
	local prevID = self.desiredBooth
	
	self.desiredBooth = id
	
	if prevID == id then
		return 
	end
	
	if prevID then
		local currentDesiredEmployeeCount = #self.desiredEmployees
		local currentDesiredGameCount = #self.desiredGames
		local boothData = self.booths[id]
		local requiredParticipants = boothData.requiredParticipants
		local maxGames = boothData.maxPresentedGames
		
		if requiredParticipants < currentDesiredEmployeeCount then
			for key, participant in ipairs(self.desiredEmployees) do
				sortedByBoost[#sortedByBoost + 1] = participant
				precalculatedBoostLevels[participant] = gameConventions:calculateEmployeeBoost(participant)
				self.desiredEmployees[key] = nil
			end
			
			table.sort(sortedByBoost, sortByBoost)
			
			local addedPeople = 0
			
			while #sortedByBoost > 0 and addedPeople < requiredParticipants do
				local participant = sortedByBoost[#sortedByBoost]
				
				self.desiredEmployees[#self.desiredEmployees + 1] = participant
				addedPeople = addedPeople + 1
				
				table.remove(sortedByBoost, #sortedByBoost)
			end
			
			table.clear(sortedByBoost)
			table.clear(precalculatedBoostLevels)
		end
		
		if maxGames < currentDesiredGameCount then
			while maxGames < #self.desiredGames do
				table.remove(self.desiredGames, #self.desiredGames)
			end
		end
	end
	
	events:fire(gameConventions.EVENTS.BOOTH_CHANGED, addedPeople)
end

function baseConventionFuncs:getRequiredParticipants(boothID)
	return self.booths[boothID].requiredParticipants
end

function baseConventionFuncs:getBoothType(boothID)
	return self.booths[boothID].type
end

function baseConventionFuncs:getDesiredBooth()
	return self.desiredBooth
end

function baseConventionFuncs:canBegin(month)
	return month == self.conventionMonth
end

eventBoxText:registerNew({
	id = "expo_begins_soon",
	getText = function(self, data)
		return _format(_T("EXPO_STARTS_SOON_NOTIFICATION", "The game exposition 'EXPO' will begin in 1 month."), "EXPO", gameConventions.registeredByID[data].display)
	end
})

function baseConventionFuncs:attemptNotifyOfAvailability()
	local timeUntil = self:getTimeUntil(timeline.curTime)
	
	if timeUntil > 1 and timeUntil <= timeline.DAYS_IN_MONTH then
		game.addToEventBox("expo_begins_soon", self.id, 1)
	end
end

function baseConventionFuncs:setVisitorPlayerAffector(affector)
	self.visitorPlayerAffector = affector
end

function baseConventionFuncs:getYearlyVisitors()
	return self.yearlyVisitors
end

function baseConventionFuncs:shouldFinish()
	return timeline.curTime >= self.conventionTime + self.duration
end

function baseConventionFuncs:getTimeToBook()
	return self.bookingMonthTime or gameConventions.BOOKING_IN_ADVANCE
end

function baseConventionFuncs:isBookedByPlayer()
	return self.bookedByPlayer
end

function baseConventionFuncs:canBookPresentation()
	local timeLeft = self:getTimeUntil(timeline.curTime)
	
	return timeLeft >= self:getTimeToBook() and not self.bookedByPlayer
end

function baseConventionFuncs:getExpoRegistrationEndTime()
	local timeLeft = self:getTimeUntil(timeline.curTime)
	
	return timeLeft - self:getTimeToBook()
end

function baseConventionFuncs:getTimeUntil(time)
	local eventMonthTime = timeline:monthToTime(self.conventionMonth)
	local currentYear = timeline:getYear()
	local eventTime = timeline:yearToTime(currentYear) + eventMonthTime
	
	if eventTime < time then
		return timeline:yearToTime(currentYear + 1) + eventMonthTime - timeline.curTime
	end
	
	return eventMonthTime - (timeline.curTime - timeline:yearToTime(timeline:getYear()))
end

function baseConventionFuncs:save()
	local saved = {
		id = self.id,
		conventionTime = self.conventionTime,
		desiredBooth = self.desiredBooth,
		playerBooth = self.playerBooth,
		hiredStaff = self.hiredStaff,
		playerParticipating = self.playerParticipating,
		bookedByPlayer = self.bookedByPlayer,
		lastYearsTotalRating = self.lastYearsTotalRating,
		visitorPlayerAffector = self.visitorPlayerAffector,
		playerParticipationDate = self.playerParticipationDate,
		paidFee = self.paidFee,
		previousPaidFee = self.previousPaidFee,
		spentMoney = self.spentMoney,
		inProgress = self.inProgress,
		playerPresentedGames = {},
		exhibitingEmployees = {},
		desiredEmployees = {},
		desiredGames = {}
	}
	
	for key, gameObj in ipairs(self.playerPresentedGames) do
		table.insert(saved.playerPresentedGames, gameObj:getUniqueID())
	end
	
	for key, gameObj in ipairs(self.desiredGames) do
		table.insert(saved.desiredGames, gameObj:getUniqueID())
	end
	
	for key, employee in ipairs(self.desiredEmployees) do
		table.insert(saved.desiredEmployees, employee:getUniqueID())
	end
	
	for key, employee in ipairs(self.exhibitingEmployees) do
		table.insert(saved.exhibitingEmployees, employee:getUniqueID())
	end
	
	return saved
end

function baseConventionFuncs:load(data)
	self.conventionTime = data.conventionTime
	self.playerBooth = data.playerBooth
	self.hiredStaff = data.hiredStaff or 0
	self.playerParticipating = data.playerParticipating
	self.bookedByPlayer = data.bookedByPlayer
	self.lastYearsTotalRating = data.lastYearsTotalRating
	self.visitorPlayerAffector = data.visitorPlayerAffector
	self.playerParticipationDate = data.playerParticipationDate
	self.desiredBooth = data.desiredBooth
	self.paidFee = data.paidFee
	self.previousPaidFee = data.previousPaidFee
	self.spentMoney = data.spentMoney
	self.inProgress = data.inProgress
	
	for key, gameID in ipairs(data.playerPresentedGames) do
		table.insert(self.playerPresentedGames, studio:getProjectByUniqueID(gameID))
	end
	
	for key, gameID in ipairs(data.desiredGames) do
		table.insert(self.desiredGames, studio:getProjectByUniqueID(gameID))
	end
	
	for key, employeeID in ipairs(data.desiredEmployees) do
		table.insert(self.desiredEmployees, studio:getEmployeeByUniqueID(employeeID))
	end
	
	for key, employeeID in ipairs(data.exhibitingEmployees) do
		table.insert(self.exhibitingEmployees, studio:getEmployeeByUniqueID(employeeID))
	end
	
	if self.playerParticipating then
		self:calculateEmployeeBoost()
		self:findBestGame()
	end
end

function baseConventionFuncs:postLoad()
	if self.bookedByPlayer and #self.desiredGames == 0 then
		self:createPostLoadRebookingPopup()
	elseif self.playerParticipating and #self.playerPresentedGames == 0 then
		self:cancel()
		
		return false
	end
	
	return true
end

function gameConventions:registerNew(data)
	table.insert(self.registered, data)
	
	self.registeredByID[data.id] = data
	data.mtindex = {
		__index = data
	}
	
	if MAIN_THREAD then
		data.quad = quadLoader:load(data.icon)
		
		if data.availability then
			data.availabilityFact = "conventions_" .. data.id .. "_availability"
			
			scheduledEvents:registerNew({
				textFont = "pix20",
				titleFont = "pix24",
				inactive = false,
				id = data.availabilityFact,
				conventionID = data.id,
				unlockID = data.availabilityFact,
				date = data.availability,
				title = data.unlockTitle,
				text = data.unlockText
			}, "convention_availability")
		end
	end
	
	setmetatable(data, baseConventionFuncs.mtindex)
end

function gameConventions:getData(id)
	return gameConventions.registeredByID[id]
end

function gameConventions:init()
	self.inProgressConventions = {}
	self.conventionVisitors = {}
	self.attractedVisitors = {}
	self.gainedPopularity = {}
	
	for key, conventionData in ipairs(gameConventions.availableConventions) do
		conventionData:init()
	end
	
	self:initEventHandler()
end

function gameConventions:initEventHandler()
	events:addDirectReceiver(self, gameConventions.CATCHABLE_EVENTS)
	events:addFunctionReceiver(self, gameConventions.handleGameScrap, project.EVENTS.SCRAPPED_PROJECT)
	events:addFunctionReceiver(self, gameConventions.handleGameOffMarket, gameProject.EVENTS.GAME_OFF_MARKET)
end

function gameConventions:removeEventHandler()
	events:removeDirectReceiver(self, gameConventions.CATCHABLE_EVENTS)
	events:removeFunctionReceiver(self, project.EVENTS.SCRAPPED_PROJECT)
	events:removeFunctionReceiver(self, gameProject.EVENTS.GAME_OFF_MARKET)
end

function gameConventions:remove()
	table.clear(self.inProgressConventions)
	table.clear(self.conventionVisitors)
	table.clear(self.attractedVisitors)
	
	for key, conventionData in ipairs(gameConventions.availableConventions) do
		conventionData:remove()
		
		gameConventions.availableConventions[key] = nil
	end
	
	self:removeEventHandler()
end

function gameConventions:lock()
	self:removeEventHandler()
end

function gameConventions:unlock()
	self:initEventHandler()
end

function gameConventions:isConventionInProgress(id)
	for key, data in ipairs(self.inProgressConventions) do
		if data.id == id then
			return true
		end
	end
	
	return false
end

function gameConventions:removeConventionFromInProgress(conventionData)
	table.removeObject(self.inProgressConventions, conventionData)
end

function gameConventions:getMaxEmployeeBoost()
	return 1 + gameConventions.CHARISMA_BOOST + gameConventions.PUBLIC_KNOWLEDGE_BOOST + gameConventions.BASE_DEVELOPER_PRESENCE_ATTRACTIVENESS_BOOST
end

function gameConventions:getCharismaBoost(level)
	return level / attributes:getData("charisma").maxLevel * gameConventions.CHARISMA_BOOST
end

function gameConventions:getPublicSpeakingBoost(knowledgeLevel)
	return knowledgeLevel / knowledge:getData("public_speaking").maximum * gameConventions.PUBLIC_KNOWLEDGE_BOOST
end

function gameConventions:calculateEmployeeBoost(employee)
	local boost = self:getCharismaBoost(employee:getAttribute("charisma")) + self:getPublicSpeakingBoost(employee:getKnowledge("public_speaking"))
	
	for key, traitID in ipairs(employee:getTraits()) do
		boost = traits.registeredByID[traitID]:adjustGameConventionScore(employee, boost)
	end
	
	return math.max(0, boost) + gameConventions.BASE_DEVELOPER_PRESENCE_ATTRACTIVENESS_BOOST
end

function gameConventions:rollConventionVisitors(conventionData)
	local amount = conventionData:getYearlyVisitors()
	
	if conventionData.visitorsMinMaxRange then
		amount = math.ceil(amount * math.randomf(conventionData.visitorsMinMaxRange[1], conventionData.visitorsMinMaxRange[2]) / gameConventions.VISITOR_ROUNDING_SEGMENT) * gameConventions.VISITOR_ROUNDING_SEGMENT
	end
	
	local playerRatingBoost = math.min(1, conventionData:getLastYearsPlayerRating() / gameConventions.RATING_FOR_MAX_EXTRA_VISITORS)
	
	return amount + amount * playerRatingBoost * gameConventions.MAX_EXTRA_VISITORS_FROM_PLAYER, playerRatingBoost
end

function gameConventions:getAttractivenessMultiplier()
	return studio:getFact(gameConventions.INCREASED_EFFICIENCY_FACT) and gameConventions.INCREASED_EFFICIENCY or gameConventions.ATTRACTED_PEOPLE_TO_POPULARITY
end

function gameConventions:handleEvent(event, employee)
	for key, conventionData in ipairs(self.inProgressConventions) do
		conventionData:handleEvent(event)
	end
	
	if event == timeline.EVENTS.NEW_MONTH then
		local month = timeline:getMonth()
		
		for key, conventionData in ipairs(gameConventions.availableConventions) do
			conventionData:attemptNotifyOfAvailability()
			
			if conventionData:canBegin(month) and not self:isConventionInProgress(conventionData.id) then
				local conventionID = conventionData:getID()
				local visitors, playerAffector = self:rollConventionVisitors(conventionData)
				
				conventionData:setVisitorPlayerAffector(playerAffector)
				
				self.conventionVisitors[conventionID] = visitors
				
				conventionData:begin()
				table.insert(self.inProgressConventions, conventionData)
			end
		end
	elseif event == studio.EVENTS.EMPLOYEE_FIRED then
		local bookedExpo = employee:getBookedExpo()
		
		if bookedExpo then
			gameConventions.registeredByID[bookedExpo]:onEmployeeLeft(employee)
		end
	end
end

function gameConventions:handleGameScrap(projectObj)
	if projectObj.PROJECT_TYPE == gameProject.PROJECT_TYPE then
		for key, conventionData in ipairs(gameConventions.availableConventions) do
			if conventionData:isGameBeingPresented(projectObj) then
				conventionData:handleGameScrap(projectObj)
			end
		end
	end
end

function gameConventions:handleGameOffMarket(projectObj)
	for key, conventionData in ipairs(gameConventions.availableConventions) do
		if conventionData:isGameBeingPresented(projectObj) then
			conventionData:handleGameOffMarket(projectObj)
		end
	end
end

function gameConventions:getEntryFee(conventionData, boothSize, ownStaff)
	return conventionData:calculateFee(boothSize, ownStaff)
end

function gameConventions:addAttractedVisitors(conventionID, amount)
	self.attractedVisitors[conventionID] = math.min(self.conventionVisitors[conventionID], self.attractedVisitors[conventionID] + amount)
end

function gameConventions:resetAttractedVisitors(conventionID)
	self.attractedVisitors[conventionID] = 0
end

function gameConventions:setAttractedVisitors(conventionID, visitors)
	self.attractedVisitors[conventionID] = visitors
end

function gameConventions:getAttractedVisitors(conventionID)
	return self.attractedVisitors[conventionID]
end

function gameConventions:getVisitors(conventionID)
	return self.conventionVisitors[conventionID]
end

function gameConventions:setGainedPopularity(conventionID, popularity)
	self.gainedPopularity[conventionID] = popularity
end

function gameConventions:getGainedPopularity(conventionID)
	return self.gainedPopularity[conventionID]
end

function gameConventions:getTargetConventionForGame(gameObj)
	for key, data in ipairs(gameConventions.availableConventions) do
		if data:isGameBeingPresented(gameObj) then
			return data
		end
	end
	
	return nil
end

function gameConventions:isGameActivelyPresented(gameObj)
	for key, data in ipairs(gameConventions.availableConventions) do
		if data:isInProgress() and data:isGameBeingPresented(gameObj) then
			return true
		end
	end
	
	return false
end

function gameConventions:fillAvailableConventions()
	for key, data in ipairs(gameConventions.registered) do
		if data:isAvailable() and not table.find(gameConventions.availableConventions, data) then
			data:init()
			table.insert(gameConventions.availableConventions, data)
		end
	end
end

function gameConventions:addAvailableConvention(conventionID)
	local data = gameConventions.registeredByID[conventionID]
	
	data:init()
	table.insert(gameConventions.availableConventions, data)
end

function gameConventions:getAvailableConventions()
	return gameConventions.availableConventions
end

function gameConventions:save()
	local saved = {
		conventions = {},
		inProgressConventions = {},
		gainedPopularity = self.gainedPopularity,
		attractedVisitors = self.attractedVisitors,
		conventionVisitors = self.conventionVisitors
	}
	
	for key, conventionData in ipairs(gameConventions.availableConventions) do
		table.insert(saved.conventions, conventionData:save())
	end
	
	for key, conventionData in ipairs(self.inProgressConventions) do
		table.insert(saved.inProgressConventions, conventionData.id)
	end
	
	return saved
end

function gameConventions:load(data)
	self.attractedVisitors = data.attractedVisitors or self.attractedVisitors
	self.conventionVisitors = data.conventionVisitors or self.conventionVisitors
	self.gainedPopularity = data.gainedPopularity or self.gainedPopularity
	
	self:fillAvailableConventions()
	
	for key, conventionData in ipairs(data.conventions) do
		local data = gameConventions.registeredByID[conventionData.id]
		
		data:init()
		data:load(conventionData)
	end
	
	for key, conventionID in ipairs(data.inProgressConventions) do
		table.insert(self.inProgressConventions, gameConventions.registeredByID[conventionID])
	end
end

function gameConventions:postLoad()
	local idx = 1
	local convs = gameConventions.availableConventions
	
	for i = 1, #convs do
		local convData = convs[idx]
		
		if convData:postLoad() then
			idx = idx + 1
		end
	end
end

require("game/game_conventions/basic_game_conventions")
require("game/game_conventions/game_conventions_scheduled_events")
