gameAwards = {}
gameAwards.POST_WIN_QUOTE = {
	_T("GAME_AWARDS_POST_WIN_QUOTE_1", "'STUDIO' has won the Annual Game Awards.\n\n'QUOTE' said the CEO of STUDIO. Well said."),
	_T("GAME_AWARDS_POST_WIN_QUOTE_2", "We were delighted to see 'STUDIO' win the Annual Game Awards!\n\n'QUOTE' said the CEO of STUDIO. What a fantastic speech to end the show."),
	_T("GAME_AWARDS_POST_WIN_QUOTE_3", "'STUDIO' has left the Annual Game Awards with the Game of the Year award!\n\n'QUOTE' said the CEO of STUDIO. An incredible quote for game developers around the world to take into their hearts."),
	_T("GAME_AWARDS_POST_WIN_QUOTE_4", "'STUDIO' winning the Game of the Year award should be of no surprise given their track record!\n\n'QUOTE' said the CEO of STUDIO. Well said, truly well said."),
	_T("GAME_AWARDS_POST_WIN_QUOTE_5", "'STUDIO' surprised everyone and went home with the Game of the Year award.\n\n'QUOTE' said the CEO of STUDIO. This is truly a quote to be remembered for decades.")
}
gameAwards.MIN_GAME_RATING_PARTICIPATION = 8
gameAwards.GOTY_PENALTY_RATING_CUTOFF = 8.5
gameAwards.GOTY_REP_GAIN_WIN = {
	1000,
	3000
}
gameAwards.GOTY_REP_PENALTY = {
	1500,
	500
}
gameAwards.CATEGORY_REP_GAIN_WIN = {
	200,
	1000
}
gameAwards.AVAILABILITY_YEAR = 1998
gameAwards.REGISTRATION_MONTH = 9
gameAwards.REGISTRATION_DURATION = 2
gameAwards.START_MONTH = 12
gameAwards.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_MONTH
}
gameAwards.UNLOCK_ID = "game_awards"

game.registerTimedPopup("game_awards_availability", _T("ANNUAL_GAME_AWARDS_TITLE", "Annual Game Awards"), _T("ANNUAL_GAME_AWARDS_DESC", "The Annual Game Awards are now available! Participating with a game that's best out of all the nominated ones will yield you extra Reputation.\n\nCheck the Timeline menu for more information."), "pix24", "pix20", {
	year = gameAwards.AVAILABILITY_YEAR,
	month = math.max(1, gameAwards.REGISTRATION_MONTH - 6)
}, nil, gameAwards.UNLOCK_ID)

gameAwards.INTRO_SPEECH = {
	_T("GAME_AWARDS_SPEECH_INTRO_1", "Welcome to the Annual Game Awards, where we award game developers for their hard efforts and advancements in the game industry!")
}
gameAwards.CATEGORY_COUNT_SPEECH_SINGLE = _T("GAME_AWARDS_CATEGORIES_SINGLE", "This year we have only 1 category in which game developers will be competing.")
gameAwards.CATEGORY_COUNT_SPEECH_MULTIPLE = _T("GAME_AWARDS_CATEGORIES_MULTIPLE", "This year we have only CATEGORIES categories in which game developers will be competing.")
gameAwards.CATEGORY_WINNER_TEXT = {
	_T("GAME_AWARDS_CATEGORY_WINNER_1", "The winner of the 'Best GENRE Game' This Year is..."),
	_T("GAME_AWARDS_CATEGORY_WINNER_2", "And the 'Best GENRE Game' award goes to..."),
	_T("GAME_AWARDS_CATEGORY_WINNER_3", "The 'Best GENRE game' award goes to...")
}
gameAwards.GOTY_WINNER_TEXT_INTRO = {
	_T("GAME_AWARDS_GOTY_WINNER_INTRO_1", "And now, the moment you've all been waiting for...")
}
gameAwards.GOTY_WINNER_TEXT_MAIN = {
	_T("GAME_AWARDS_GOTY_WINNER_MAIN_1", "The winner of the Game of the Year award is...")
}
gameAwards.CATEGORY_LIST = _T("GAME_AWARDS_CATEGORIES_THIS_YEAR", "The categories this year are: CATEGORIES")
gameAwards.RATING_RANGES = {
	{
		weight = 15,
		range = {
			8,
			8.6
		}
	},
	{
		weight = 30,
		range = {
			8.6,
			9.1
		}
	},
	{
		weight = 20,
		range = {
			9.1,
			9.5
		}
	},
	{
		weight = 10,
		range = {
			9.5,
			9.8
		}
	},
	{
		weight = 5,
		range = {
			9.8,
			10
		}
	}
}
gameAwards.SCALE_RANGES = {
	{
		weight = 30,
		range = {
			0.5,
			0.7
		}
	},
	{
		weight = 20,
		range = {
			0.7,
			0.8
		}
	},
	{
		weight = 15,
		range = {
			0.8,
			0.85
		}
	},
	{
		weight = 10,
		range = {
			0.85,
			0.9
		}
	},
	{
		weight = 5,
		range = {
			0.9,
			1
		}
	}
}
gameAwards.STAGES = {
	CEO_IN = 6,
	CROWD_IN = 2,
	CEO_OUT = 8,
	ANNOUNCER_OUT = 5,
	ANNOUNCER_BACK_IN = 9,
	CEO_TALK = 7,
	FADE_OUT = 10,
	ANNOUNCER_IN = 3,
	FADE_IN = 1,
	ANNOUNCER_TALK = 4
}
gameAwards.SPEECH_STAGES = {
	OUTRO = 3,
	INTRO = 1,
	MAIN = 2
}
gameAwards.DEFAULT_TEXT = {
	[gameAwards.SPEECH_STAGES.INTRO] = _T("GAME_AWARDS_INTRO_DEFAULT", "Thank you for having me here, it is a great pleasure."),
	[gameAwards.SPEECH_STAGES.MAIN] = _T("GAME_AWARDS_MAIN_DEFAULT", "I would like to thank every person that worked on the game, without them this would not be possible."),
	[gameAwards.SPEECH_STAGES.OUTRO] = _T("GAME_AWARDS_OUTRO_DEFAULT", "You can expect even more great games from us, as we're just getting started!")
}
gameAwards.SPEECH_ORDER = {
	gameAwards.SPEECH_STAGES.INTRO,
	gameAwards.SPEECH_STAGES.MAIN,
	gameAwards.SPEECH_STAGES.OUTRO
}
gameAwards.SPEECH_LIMITS = {
	[gameAwards.SPEECH_STAGES.INTRO] = 100,
	[gameAwards.SPEECH_STAGES.MAIN] = 120,
	[gameAwards.SPEECH_STAGES.OUTRO] = 100
}
gameAwards.WIN_TYPE = {
	CATEGORY = 1,
	GOTY = 2
}
gameAwards.WIN_TYPE_TEXT = {
	[gameAwards.WIN_TYPE.CATEGORY] = function(data, descBox, wrapWidth)
		descBox:addTextLine(-1, game.UI_COLORS.GREEN, nil, "weak_gradient_horizontal")
		
		local genreData = genres.registeredByID[data.data]
		
		descBox:addText(_format(_T("GAME_AWARDS_CATEGORY_WIN_TEXT", "Won the 'Best GENRE Game of the Year' award"), "GENRE", genreData.display), "bh20", game.UI_COLORS.LIGHT_GREEN, 0, wrapWidth, genres:getGenreUIIconConfig(genreData, 24, 24, 22))
	end,
	[gameAwards.WIN_TYPE.GOTY] = function(data, descBox, wrapWidth)
		descBox:addTextLine(-1, game.UI_COLORS.GREEN, nil, "weak_gradient_horizontal")
		descBox:addText(_T("GAME_AWARDS_GOTY_WIN_TEXT", "Won the 'Game of the Year' award"), "bh20", game.UI_COLORS.LIGHT_GREEN, 0, wrapWidth, "hud_objectives", 22, nil)
	end
}
gameAwards.PENALTY_TYPES = {
	GOTY_OUTRAGE = 1
}
gameAwards.PENALTY_ORDER = {
	gameAwards.PENALTY_TYPES.GOTY_OUTRAGE
}
gameAwards.PENALTY_TEXT = {
	[gameAwards.PENALTY_TYPES.GOTY_OUTRAGE] = _T("GAME_AWARD_PENALTY_GOTY_OUTRAGE", "Viewer outrage (disapproval of GOTY award)")
}
gameAwards.OCCURENCE_MONTH = 10
gameAwards.GAMES_PER_CATEGORY = 3
gameAwards.MIN_CATEGORIES = 3
gameAwards.FIRST_TIME_POPUP_FACT = "game_awards_first_time_popup"
gameAwards.EVENTS = {
	STARTED = events:new(),
	FINISHED = events:new(),
	DEFAULT_SPEECH = events:new(),
	LAST_SPEECH = events:new(),
	ANNOUNCER_FADED_IN = events:new()
}

function gameAwards:setupRatingWeights()
	local maxWeight = 1
	
	for key, data in ipairs(gameAwards.RATING_RANGES) do
		data.startWeight = maxWeight
		maxWeight = maxWeight + data.weight
		data.finishWeight = maxWeight
		maxWeight = maxWeight + 1
	end
	
	self.maxRatingWeight = maxWeight - 1
end

function gameAwards:setupScaleWeights()
	local maxWeight = 1
	
	for key, data in ipairs(gameAwards.SCALE_RANGES) do
		data.startWeight = maxWeight
		maxWeight = maxWeight + data.weight
		data.finishWeight = maxWeight
		maxWeight = maxWeight + 1
	end
	
	self.maxScaleWeight = maxWeight - 1
end

gameAwards:setupRatingWeights()
gameAwards:setupScaleWeights()

function gameAwards:init()
	self.gamesToRate = {}
	self.allGames = {}
	self.fakeGames = {}
	self.scoreByGame = {}
	self.speechEntries = {}
	self.genreCategories = {}
	self.gamesByGenre = {}
	self.bestGamesByGenre = {}
	self.validGameNameIds = {}
	self.playerSpeech = {}
	self.prevPlayerSpeech = {}
	self.awards = {}
	self.validCompanyNameIds = {}
	self.generatedGameCount = 0
	
	self:initEventHandler()
end

function gameAwards:getLastSpeech()
	return self.prevPlayerSpeech
end

function gameAwards:hasPreviousSpeech()
	for key, stageID in ipairs(gameAwards.SPEECH_STAGES) do
		if self.prevPlayerSpeech[stageID] then
			return true
		end
	end
	
	return false
end

function gameAwards:lock()
	self:removeEventHandler()
end

function gameAwards:unlock()
	self:initEventHandler()
end

function gameAwards:initEventHandler()
	events:addDirectReceiver(self, gameAwards.CATCHABLE_EVENTS)
end

function gameAwards:removeEventHandler()
	events:removeDirectReceiver(self, gameAwards.CATCHABLE_EVENTS)
end

function gameAwards:remove()
	self:resetVariables()
	self:removeEventHandler()
end

function gameAwards:getStartTime()
	return timeline:getDateTime(timeline:getYear(), gameAwards.START_MONTH)
end

function gameAwards:getPlayerSpeech()
	return self.playerSpeech
end

function gameAwards:getSpeechEntries()
	return self.speechEntries
end

function gameAwards:setupFakeGames()
	local necessary = gameAwards.GAMES_PER_CATEGORY
	local categories = gameAwards.MIN_CATEGORIES
	local genreCategories = self.genreCategories
	local gamesByGenre = self.gamesByGenre
	
	self:setupGameNamesToRoll()
	self:setupCompanyNamesToRoll()
	math.randomseed(self.generatedGameCount)
	
	local old = #self.fakeGames
	
	if categories > #genreCategories then
		local validGenres = {}
		
		for key, data in ipairs(genres.registered) do
			if not gamesByGenre[data.id] then
				validGenres[#validGenres + 1] = data.id
			end
		end
		
		for i = 1, categories - #genreCategories do
			local rnd = table.remove(validGenres, math.random(1, #validGenres))
			
			self:addGameGenre(rnd)
		end
	end
	
	local maxGameScale = platformShare:getMaxGameScale()
	
	for key, genreID in ipairs(genreCategories) do
		local gameList = gamesByGenre[genreID]
		
		if necessary > #gameList then
			for i = 1, necessary - #gameList do
				local fakeGame = self:generateFakeGame()
				
				fakeGame.genre = genreID
				fakeGame.scale = maxGameScale * self:rollGameScale()
				
				table.insert(self.allGames, fakeGame)
				table.insert(self.fakeGames, fakeGame)
				table.insert(gameList, fakeGame)
			end
		end
	end
	
	self.generatedGameCount = self.generatedGameCount + (#self.fakeGames - old)
	
	self:restoreBorrowedCompanyNames()
end

function gameAwards:generateFakeGame()
	return {
		fakeGameAwardGame = true,
		genre = genreID,
		rating = self:rollGameRating(),
		name = self:rollGameName(),
		company = self:rollCompanyName()
	}
end

function gameAwards:verifyGenreGameCount(genreID)
	local necessary = gameAwards.GAMES_PER_CATEGORY
	local gameList = self.gamesByGenre[genreID]
	
	if necessary > #gameList then
		self:fillWithFakeGames(genreID, necessary)
	end
end

function gameAwards:fillWithFakeGames(genreID, maxGames)
	local gameList = self.gamesByGenre[genreID]
	local maxGameScale = platformShare:getMaxGameScale()
	
	self:setupGameNamesToRoll()
	self:setupCompanyNamesToRoll()
	
	if maxGames > #gameList then
		for i = 1, maxGames - #gameList do
			local struct = self:generateFakeGame()
			
			struct.genre = genreID
			struct.scale = maxGameScale * self:rollGameScale()
			gameList[#gameList + 1] = struct
			
			table.insert(self.allGames, struct)
			table.insert(self.fakeGames, struct)
		end
	end
	
	table.clearArray(self.validGameNameIds)
	self:restoreBorrowedCompanyNames()
end

function gameAwards:getGOTYReputationChange(rating)
	local cutoff = gameAwards.GOTY_PENALTY_RATING_CUTOFF
	
	if rating < cutoff then
		local cutoffDelta = cutoff - gameAwards.MIN_GAME_RATING_PARTICIPATION
		local delta = cutoff - rating
		local penalty = gameAwards.GOTY_REP_PENALTY
		
		return -math.lerp(penalty[1], penalty[2], math.max(0, math.min(1, delta / cutoffDelta)))
	end
	
	local maxRatingDelta = review.maxRating - cutoff
	local ratingDelta = rating - cutoff
	local boost = gameAwards.GOTY_REP_GAIN_WIN
	
	return math.lerp(boost[1], boost[2], math.max(0, math.min(1, ratingDelta / maxRatingDelta)))
end

function gameAwards:getCategoryReputationChange(rating)
	local cutoff = gameAwards.MIN_GAME_RATING_PARTICIPATION
	local maxRatingDelta = review.maxRating - cutoff
	local ratingDelta = rating - cutoff
	local boost = gameAwards.CATEGORY_REP_GAIN_WIN
	
	return math.lerp(boost[1], boost[2], math.max(0, math.min(1, ratingDelta / maxRatingDelta)))
end

local lastIDs = {}

function gameAwards:setupGameNamesToRoll()
	local reservedMap = rivalGameCompanies:getReservedNameIDs()
	local gameNameIDs = self.validGameNameIds
	
	for firstKey, name in ipairs(rivalGameCompany.GAME_FIRST_NAME) do
		for secondKey, lastName in ipairs(rivalGameCompany.GAME_LAST_NAME) do
			if not reservedMap[firstKey] or not reservedMap[firstKey][secondKey] then
				lastIDs[#lastIDs + 1] = secondKey
			end
		end
		
		if #lastIDs > 0 then
			local last = lastIDs[math.random(1, #lastIDs)]
			
			table.insert(gameNameIDs, {
				first = firstKey,
				last = last
			})
			table.clearArray(lastIDs)
		end
	end
end

function gameAwards:setupCompanyNamesToRoll()
	self.companyNamesToReadd = {}
	
	local names = rivalGameCompany.PREMADE_NAMES
	
	for key, rivalObj in ipairs(rivalGameCompanies:getCompanies()) do
		local idx = rivalObj:getNameIndex()
		
		if not idx then
			local name = rivalObj:getName()
			
			table.removeObject(names, name)
			
			self.companyNamesToReadd[#self.companyNamesToReadd + 1] = name
		end
	end
	
	local validIDs = self.validCompanyNameIds
	
	for key, name in ipairs(names) do
		validIDs[#validIDs + 1] = key
	end
end

function gameAwards:rollCompanyName()
	return rivalGameCompany.PREMADE_NAMES[table.remove(self.validCompanyNameIds, math.random(1, #self.validCompanyNameIds))]
end

function gameAwards:rollGameName()
	local struct = table.remove(self.validGameNameIds, math.random(1, #self.validGameNameIds))
	local first = struct.first
	local lastName = struct.last
	
	return rivalGameCompany:finalizeGameName(first, lastName, 1)
end

function gameAwards:rollGameScale()
	local weightValue = math.random(1, self.maxScaleWeight)
	local foundRange
	
	for key, data in ipairs(gameAwards.SCALE_RANGES) do
		if weightValue >= data.startWeight and weightValue <= data.finishWeight then
			foundRange = data.range
			
			break
		end
	end
	
	return math.round(math.randomf(foundRange[1], foundRange[2]), 2)
end

function gameAwards:rollGameRating()
	local weightValue = math.random(1, self.maxRatingWeight)
	local foundRange
	
	for key, data in ipairs(gameAwards.RATING_RANGES) do
		if weightValue >= data.startWeight and weightValue <= data.finishWeight then
			foundRange = data.range
			
			break
		end
	end
	
	return math.round(math.randomf(foundRange[1], foundRange[2]), 2)
end

function gameAwards:verifySpeechFinishClickability()
	local valid = true
	
	for key, id in ipairs(gameAwards.SPEECH_ORDER) do
		if not self.playerSpeech[id] then
			valid = false
			
			break
		end
	end
	
	self.speechNextButton:setCanClick(valid)
	self.speechNextButton:queueSpriteUpdate()
end

function gameAwards.finishSwitchCallback(button)
	gameAwards:verifySpeechFinishClickability()
	button:setText(_T("FINISH", "Finish"))
	
	return true
end

function gameAwards:verifyGameSelection()
	if self.desiredPlayerGame then
		self.speechNextButton:setCanClick(true)
	else
		self.speechNextButton:setCanClick(false)
	end
	
	self.speechNextButton:queueSpriteUpdate()
end

function gameAwards.switchToSpeechPageCallback(button)
	gameAwards:verifyGameSelection()
	
	return true
end

function gameAwards.finishGameAwardsSetupCallback(button)
	frameController:pop()
	gameAwards:finishSpeechPrep()
end

function gameAwards:getMinimumParticipationRating()
	return gameAwards.MIN_GAME_RATING_PARTICIPATION
end

gameAwards.GAME_INFO_DESCBOX_ID = "ga_game_descbox"

function gameAwards:createGameSelectionFrame()
	local frame = gui.create("Frame")
	
	frame:setSize(500, 400)
	frame:setFont("pix24")
	frame:setText(_T("GAME_AWARDS_NOMINATE_GAME", "Nominate Game"))
	
	local pageCtrl = gui.create("PageController", frame)
	
	pageCtrl:setPos(_S(5), _S(35))
	pageCtrl:setSize(frame.rawW - 10, frame.rawH - 40)
	
	self.speechNextButton = pageCtrl:initNextButton(_T("NEXT", "Next"), 100, 30, nil)
	self.speechPreviousButton = pageCtrl:initPrevButton(_T("PREVIOUS", "Previous"), 100, 30, nil)
	
	pageCtrl:positionButtons()
	
	local gameSelectionPage = pageCtrl:createPage(pageCtrl.rawW, pageCtrl.rawH - 40)
	local scroll = gui.create("ScrollbarPanel", gameSelectionPage)
	
	scroll:setSize(gameSelectionPage.rawW, gameSelectionPage.rawH)
	scroll:setSpacing(3)
	scroll:setPadding(3, 3)
	scroll:setAdjustElementPosition(true)
	scroll:setAdjustElementSize(true)
	scroll:addDepth(100)
	
	local cat = gui.create("Category")
	
	cat:setSize(200, 28)
	cat:setFont("pix24")
	cat:setText(_T("GAME_AWARDS_VALID_GAMES", "Valid games"))
	cat:assumeScrollbar(scroll)
	
	local invalidCat = gui.create("Category")
	
	invalidCat:setSize(200, 28)
	invalidCat:setFont("pix24")
	invalidCat:setText(_T("GAME_AWARDS_INVALID_GAMES", "Invalid games"))
	invalidCat:assumeScrollbar(scroll)
	
	local minRating = self:getMinimumParticipationRating()
	
	scroll:addItem(cat)
	scroll:addItem(invalidCat)
	
	local startTime = timeline:getDateTime(timeline:getYear(), 1)
	local relGames = studio:getReleasedGames()
	local elemWidth = scroll.rawW - 15
	
	for i = #relGames, 1, -1 do
		local gameObj = relGames[i]
		local relDate = gameObj:getReleaseDate()
		
		if startTime < relDate then
			local element = gui.create("GameAwardNomineeSelection")
			
			element:setWidth(elemWidth)
			element:setProject(gameObj)
			
			if minRating > gameObj:getReviewRating() then
				invalidCat:addItem(element, true, true)
			else
				cat:addItem(element, true, true)
			end
		else
			break
		end
	end
	
	local speechPage = pageCtrl:createPage(pageCtrl.rawW, pageCtrl.rawH - 40)
	local label = gui.create("Label", speechPage)
	
	label:setFont("bh22")
	label:setText(_T("GAME_AWARDS_INTRO_DESC", "Start the speech with..."))
	
	local introEntry = gui.create("GameAwardSpeechEntry", speechPage)
	
	introEntry:setPos(0, label.localY + _S(25))
	introEntry:setFont("pix20")
	introEntry:setText("")
	introEntry:setGhostText(_T("GAME_AWARDS_ENTER_INTRO_SPEECH", "Enter intro speech"))
	introEntry:setSize(speechPage.rawW, 65)
	introEntry:setSpeechStage(gameAwards.SPEECH_STAGES.INTRO)
	
	local label = gui.create("Label", speechPage)
	
	label:setFont("bh22")
	label:setPos(0, introEntry.localY + introEntry.h + _S(5))
	label:setText(_T("GAME_AWARDS_MAIN_DESC", "Continue it with..."))
	
	local mainEntry = gui.create("GameAwardSpeechEntry", speechPage)
	
	mainEntry:setPos(0, label.localY + label.h + _S(5))
	mainEntry:setFont("pix20")
	mainEntry:setText("")
	mainEntry:setGhostText(_T("GAME_AWARDS_ENTER_MAIN_SPEECH", "Enter main speech"))
	mainEntry:setSize(speechPage.rawW, 65)
	mainEntry:setSpeechStage(gameAwards.SPEECH_STAGES.MAIN)
	
	local label = gui.create("Label", speechPage)
	
	label:setFont("bh22")
	label:setPos(0, mainEntry.localY + mainEntry.h + _S(5))
	label:setText(_T("GAME_AWARDS_OUTRO_DESC", "End the speech with..."))
	
	local outroEntry = gui.create("GameAwardSpeechEntry", speechPage)
	
	outroEntry:setPos(0, label.localY + label.h + _S(5))
	outroEntry:setFont("pix20")
	outroEntry:setText("")
	outroEntry:setGhostText(_T("GAME_AWARDS_ENTER_OUTRO_SPEECH", "Enter outro speech"))
	outroEntry:setSize(speechPage.rawW, 65)
	outroEntry:setSpeechStage(gameAwards.SPEECH_STAGES.OUTRO)
	
	local defSpeech = gui.create("SetDefaultSpeechButton", speechPage)
	
	defSpeech:setSize(160, 28)
	defSpeech:setPos(speechPage.w - defSpeech.w - _S(5), speechPage.h - defSpeech.h - _S(5))
	defSpeech:setFont("bh20")
	defSpeech:setText(_T("GAME_AWARDS_USE_DEFAULT_SPEECH", "Use Default Speech"))
	
	local lastSpeech = gui.create("UseLastSpeechButton", speechPage)
	
	lastSpeech:setSize(160, 28)
	lastSpeech:setPos(defSpeech.localX - lastSpeech.w - _S(5), defSpeech.localY)
	lastSpeech:setFont("bh20")
	lastSpeech:setText(_T("GAME_AWARDS_USE_Last_SPEECH", "Use Last Speech"))
	lastSpeech:updateState()
	pageCtrl:setPageButtonShowCallback(2, pageCtrl.BUTTONS.NEXT, gameAwards.finishSwitchCallback)
	pageCtrl:setPageButtonShowCallback(1, pageCtrl.BUTTONS.NEXT, gameAwards.switchToSpeechPageCallback)
	pageCtrl:setPageButtonCallback(2, pageCtrl.BUTTONS.NEXT, gameAwards.finishGameAwardsSetupCallback)
	pageCtrl:setPage(1)
	frame:center()
	frameController:push(frame)
end

function gameAwards:createSpeechPopup()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText(_T("GAME_AWARDS_CELEBRATORY_SPEECH", "Celebratory Speech"))
	frame:setSize(500, 360)
	frame:addDepth(400)
	
	local label = gui.create("Label", frame)
	
	label:setFont("bh22")
	label:setPos(_S(5), _S(35))
	label:setText(_T("GAME_AWARDS_INTRO_DESC", "Start the speech with..."))
	
	local introEntry = gui.create("GameAwardSpeechEntry", frame)
	
	introEntry:setPos(_S(5), _S(60))
	introEntry:setFont("pix20")
	introEntry:setText("")
	introEntry:setGhostText(_T("GAME_AWARDS_ENTER_INTRO_SPEECH", "Enter intro speech"))
	introEntry:setSize(frame.rawW - 10, 65)
	introEntry:setSpeechStage(gameAwards.SPEECH_STAGES.INTRO)
	
	local label = gui.create("Label", frame)
	
	label:setFont("bh22")
	label:setPos(_S(5), introEntry.localY + introEntry.h + _S(5))
	label:setText(_T("GAME_AWARDS_MAIN_DESC", "Continue it with..."))
	
	local mainEntry = gui.create("GameAwardSpeechEntry", frame)
	
	mainEntry:setPos(_S(5), label.localY + label.h + _S(5))
	mainEntry:setFont("pix20")
	mainEntry:setText("")
	mainEntry:setGhostText(_T("GAME_AWARDS_ENTER_MAIN_SPEECH", "Enter main speech"))
	mainEntry:setSize(frame.rawW - 10, 65)
	mainEntry:setSpeechStage(gameAwards.SPEECH_STAGES.MAIN)
	
	local label = gui.create("Label", frame)
	
	label:setFont("bh22")
	label:setPos(_S(5), mainEntry.localY + mainEntry.h + _S(5))
	label:setText(_T("GAME_AWARDS_OUTRO_DESC", "End the speech with..."))
	
	local outroEntry = gui.create("GameAwardSpeechEntry", frame)
	
	outroEntry:setPos(_S(5), label.localY + label.h + _S(5))
	outroEntry:setFont("pix20")
	outroEntry:setText("")
	outroEntry:setGhostText(_T("GAME_AWARDS_ENTER_OUTRO_SPEECH", "Enter outro speech"))
	outroEntry:setSize(frame.rawW - 10, 65)
	outroEntry:setSpeechStage(gameAwards.SPEECH_STAGES.OUTRO)
	
	local finishButton = gui.create("FinishSpeechPrepButton", frame)
	
	finishButton:setSize(100, 28)
	finishButton:setFont("bh24")
	finishButton:setText(_T("GAME_AWARDS_FINISH", "Finish"))
	finishButton:setPos(frame.w - finishButton.w - _S(5), frame.h - finishButton.h - _S(5))
	
	local defSpeech = gui.create("SetDefaultSpeechButton", frame)
	
	defSpeech:setSize(160, 28)
	defSpeech:setPos(finishButton.localX - defSpeech.w - _S(5), finishButton.localY)
	defSpeech:setFont("bh20")
	defSpeech:setText(_T("GAME_AWARDS_USE_DEFAULT_SPEECH", "Use Default Speech"))
	
	local lastSpeech = gui.create("UseLastSpeechButton", frame)
	
	lastSpeech:setSize(160, 28)
	lastSpeech:setPos(defSpeech.localX - lastSpeech.w - _S(5), finishButton.localY)
	lastSpeech:setFont("bh20")
	lastSpeech:setText(_T("GAME_AWARDS_USE_Last_SPEECH", "Use Last Speech"))
	frame:center()
	frameController:push(frame)
end

gameAwards.BG_LAYERS = {
	{
		quad = "ga_row_3_floor",
		stageID = 1,
		h = 50,
		y = 294,
		w = 640,
		x = 0
	},
	{
		quad = "ga_row_2_floor",
		stageID = 1,
		h = 70,
		y = 342,
		w = 640,
		x = 0
	},
	{
		quad = "ga_row_1_floor",
		stageID = 1,
		h = 82,
		y = 398,
		w = 640,
		x = 0
	},
	{
		quad = "ga_stage",
		stageID = 1,
		h = 286,
		y = 8,
		w = 640,
		x = 0
	},
	{
		quad = "ga_podium",
		stageID = 1,
		h = 82,
		y = 144,
		w = 56,
		x = 292
	},
	{
		quad = "ga_row_3",
		extraDepth = 5,
		h = 58,
		y = 284,
		w = 640,
		stageID = 2,
		x = 0
	},
	{
		quad = "ga_row_2",
		extraDepth = 5,
		h = 78,
		y = 320,
		w = 640,
		stageID = 2,
		x = 0
	},
	{
		quad = "ga_row_1",
		extraDepth = 5,
		h = 90,
		y = 380,
		w = 640,
		stageID = 2,
		x = 0
	}
}
gameAwards.DEPTH_PER_ELEMENT = 5

function gameAwards:createEventPopup()
	local frame = gui.create("GameAwardsFrame")
	
	frame:addDepth(1000)
	frame:setSize(640, 500)
	frame:setFont("pix24")
	frame:setText(_T("ANNUAL_GAME_AWARDS", "Annual Game Awards"))
	frame:setAnnouncerPos(_S(298), _S(110))
	frame:setDescboxCenterPos(_S(290), _S(130))
	frame:hideCloseButton()
	frame:setScissor(true)
	
	local skipStageButton = gui.create("GameAwardsSkipStageButton", frame)
	
	skipStageButton:setSize(32, 32)
	skipStageButton:addDepth(500)
	skipStageButton:setPos(frame.localX + frame.w - skipStageButton.w - _S(5), frame.localY + frame.h - skipStageButton.h - _S(5))
	
	if self.bestGame and not self.bestGame.fakeGameAwardGame then
		local owner = self.bestGame:getOwner()
		
		if owner:isPlayer() then
			frame:setSpeaker(owner:getPlayerCharacter())
		else
			frame:setSpeaker(owner:getCEO())
		end
	else
		frame:setFakeAward(true)
	end
	
	frame:createCrowd()
	
	local baseX, baseY = 0, _S(20)
	
	for key, data in ipairs(gameAwards.BG_LAYERS) do
		local elem = gui.create("GameAwardsBackgroundElement", frame)
		
		elem:setSize(data.w, data.h)
		elem:setPos(_S(data.x) + baseX, _S(data.y) + baseY)
		elem:setQuad(data.quad)
		elem:setAlpha(0)
		
		if data.extraDepth then
			elem:addDepth((key - 1) * gameAwards.DEPTH_PER_ELEMENT + data.extraDepth)
		else
			elem:addDepth((key - 1) * gameAwards.DEPTH_PER_ELEMENT)
		end
		
		frame:addStageProp(data.stageID, elem)
	end
	
	frame:setStage(gameAwards.STAGES.FADE_IN)
	frame:center()
	frameController:push(frame)
end

function gameAwards:restoreLastSpeech()
	local speech = self.playerSpeech
	local prevSpeech = self.prevPlayerSpeech
	
	for key, id in ipairs(gameAwards.SPEECH_ORDER) do
		local text = prevSpeech[id]
		
		if text then
			speech[id] = text
		end
	end
	
	events:fire(gameAwards.EVENTS.LAST_SPEECH)
end

function gameAwards:setSpeechText(stage, text)
	if string.withoutspaces(text) == "" then
		self.playerSpeech[stage] = nil
	else
		self.playerSpeech[stage] = text
	end
	
	self:verifySpeechFinishClickability()
end

function gameAwards:getSpeechText(stage)
	return self.playerSpeech[stage]
end

function gameAwards:finishSpeechPrep()
	self.playerParticipating = true
	
	self:setPlayerGame(self.desiredPlayerGame)
	
	local popup = game.createPopup(500, _T("GAME_AWARDS_PREPARATIONS_FINISHED_TITLE", "Preparations Finished"), _format(_T("GAME_AWARDS_PREPARATIONS_FINISHED_DESCRIPTION", "Preparations for Annual Game Awards are finished! You will participate in the Annual Game Awards at the beginning of MONTH"), "MONTH", timeline:getMonthName(gameAwards.START_MONTH)), "pix24", "pix20")
	
	frameController:push(popup)
	
	local speech = self.playerSpeech
	local prevSpeech = self.prevPlayerSpeech
	
	for key, id in ipairs(gameAwards.SPEECH_ORDER) do
		prevSpeech[id] = speech[id]
	end
	
	studio:increaseGameAwardParticipation()
end

function gameAwards:setDefaultSpeech()
	local def = gameAwards.DEFAULT_TEXT
	local speech = self.playerSpeech
	
	for key, id in ipairs(gameAwards.SPEECH_ORDER) do
		speech[id] = def[id]
	end
	
	self:verifySpeechFinishClickability()
	events:fire(gameAwards.EVENTS.DEFAULT_SPEECH)
end

function gameAwards:setDesiredPlayerGame(projObj)
	self.desiredPlayerGame = projObj
	
	if self.speechNextButton then
		self:verifyGameSelection()
	end
end

function gameAwards:getDesiredPlayerGame()
	return self.desiredPlayerGame
end

function gameAwards:setPlayerGame(projObj)
	self.playerPresentedGame = projObj
	
	if projObj then
		local genreID = projObj:getGenre()
		
		self:addGameGenre(genreID)
		table.insert(self.allGames, projObj)
		table.insert(self.gamesByGenre[genreID], projObj)
		self:verifyGenreGameCount(genreID)
	end
end

function gameAwards:getPlayerGame()
	return self.playerPresentedGame
end

gameAwards.ALWAYS_SHOW_POPUP = false

function gameAwards:begin()
	local playerGame = self.playerPresentedGame
	
	if playerGame then
		self:factorInPlayer()
	end
	
	self:setupGamesToRate()
	self:setupFakeGames()
	self:findBestGame()
	self:findBestCategoryGames()
	
	if gameAwards.ALWAYS_SHOW_POPUP or playerGame then
		self:prepareAnnouncerSpeech()
		self:createEventPopup()
	else
		self:finish()
	end
end

function gameAwards:restoreBorrowedCompanyNames()
	local names = rivalGameCompany.PREMADE_NAMES
	local idsToReadd = self.companyNamesToReadd
	
	for key, name in ipairs(idsToReadd) do
		names[#names + 1] = name
		idsToReadd[key] = nil
	end
end

function gameAwards:createOutragePopup(repLoss)
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("GAME_AWARDS_OUTRAGE_TITLE", "Viewers Outraged"))
	popup:setTextFont("pix20")
	popup:setText(_T("GAME_AWARDS_OUTRAGE_DESC", "Viewers of the game awards are outraged with the fact that you've won the Game of the Year award. They don't think the game deserved the win."))
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(-1, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	extra:addText(_T("GAME_AWARDS_OUTRAGE_DESCRIPTION", "The public won't agree with the Game of the Year award winner if it's not very close to the higher end range of the rating scale."), "bh18", game.UI_COLORS.IMPORTANT_1, 5, popup.rawW - 20, "question_mark", 24, 24)
	extra:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("YOUVE_LOST_REPUTATION_POINTS", "You've lost REPLOSS reputation points."), "REPLOSS", string.comma(math.abs(repLoss))), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 20, "exclamation_point_red", 24, 24)
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
end

function gameAwards:postFinishGameAwardsWindow()
	self:finish()
end

gameAwards.FIRST_TIME_GOTY_OUTRAGE_FACT = "first_time_goty_outrage_popup"

function gameAwards:finish()
	if self.bestGame and not self.bestGame.fakeGameAwardGame then
		local repChange = self:getGOTYReputationChange(self.bestGame:getRealRating())
		local owner = self.bestGame:getOwner()
		
		if repChange < 0 and owner:isPlayer() then
			if not studio:getFact(gameAwards.FIRST_TIME_GOTY_OUTRAGE_FACT) then
				self:createOutragePopup(repChange)
			end
			
			self:addPenalty(owner, gameAwards.PENALTY_TYPES.GOTY_OUTRAGE, 0)
		end
	end
	
	self:transferAwards()
	self:createResultPopup()
	self:resetVariables()
end

eventBoxText:registerNew({
	id = "game_awards",
	getText = function(self, data)
		return _format(_T("GAME_AWARDS_EVENT_BOX", "This year's Game of the Year award winner is 'GAME' by 'STUDIO'"), "GAME", data.game, "STUDIO", data.studio)
	end
})

function gameAwards:createResultPopup()
	local gameName, studioName
	
	if self.bestGame.fakeGameAwardGame then
		gameName = self.bestGame.name
		studioName = self.bestGame.company
	else
		gameName = self.bestGame:getName()
		studioName = self.bestGame:getOwner():getName()
	end
	
	if not self.playerPresentedGame then
		game.addToEventBox("game_awards", {
			game = gameName,
			studio = studioName
		}, gui.getClassTable("EventBox").IMPORTANCE.GAME_AWARDS, nil, "exclamation_point")
		
		return 
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("ANNUAL_GAME_AWARDS_RECAP", "Annual Game Awards Recap"))
	popup:setTextFont("pix20")
	popup:setText(_T("ANNUAL_GAME_AWARDS_RESULT_DESC", "The Annual Game Awards have concluded and the winners have been picked!"))
	popup:hideCloseButton()
	
	local left, right, extra = popup:getDescboxes()
	local wrapW = popup.rawW - 25
	
	extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("GAME_OF_THE_YEAR_RESULT", "The winner of the Game of the Year award this time is 'GAME' by 'STUDIO'"), "GAME", gameName, "STUDIO", studioName), "bh20", game.UI_COLORS.LIGHT_BLUE, 6, wrapW, "exclamation_point", 24, 24)
	
	local data = self:findAwardsByTarget(studio, true)
	
	if data then
		if #data.awards > 0 then
			for key, awardData in ipairs(data.awards) do
				self:formatWinText(awardData, extra, wrapW)
			end
		end
		
		local penalty = data.penalties
		
		if penalty > 0 then
			local penText = gameAwards.PENALTY_TEXT
			
			for key, id in ipairs(gameAwards.PENALTY_ORDER) do
				if bit.band(penalty, id) == id then
					extra:addTextLine(-1, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
					extra:addText(penText[id], "bh20", game.UI_COLORS.IMPORTANT_1, 0, wrapW, "exclamation_point_red", 24, 24)
				end
			end
		end
	else
		extra:addText(_T("ANNUAL_GAME_AWARDS_NO_AWARDS", "You've earned no awards this year."), "bh20", nil, 0, wrapW, "question_mark", 24, 24)
	end
	
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
end

function gameAwards:resetVariables()
	local gameList, ratings = self.gamesToRate, self.scoreByGame
	
	for key, gameProj in ipairs(self.gamesToRate) do
		ratings[gameProj] = nil
		gameList[key] = nil
	end
	
	self.playerPresentedGame = nil
	self.playerParticipating = false
	self.bestGame = nil
	
	table.clearArray(self.speechEntries)
	
	for key, genreID in ipairs(self.genreCategories) do
		self.genreCategories[key] = nil
		self.bestGamesByGenre[genreID] = nil
	end
	
	for key, id in ipairs(gameAwards.SPEECH_ORDER) do
		self.playerSpeech[id] = nil
	end
	
	table.clearArray(self.allGames)
	table.clearArray(self.fakeGames)
	table.clearArray(self.validGameNameIds)
	table.clearArray(self.validCompanyNameIds)
	table.clearArray(self.awards)
	table.clear(self.gamesByGenre)
end

function gameAwards:setupGamesToRate()
	local rates = self.gamesToRate
	local yearTime = timeline:getDateTime(timeline:getYear(), 1)
	local gamesByGenre = self.gamesByGenre
	
	for key, rival in ipairs(rivalGameCompanies:getCompanies()) do
		local projList = rival:getProjects()
		
		for i = #projList, 1, -1 do
			local proj = projList[i]
			local relDate = proj:getReleaseDate()
			
			if relDate then
				if yearTime < relDate then
					rates[#rates + 1] = proj
					
					local genre = proj:getGenre()
					
					self:addGameGenre(genre)
					table.insert(self.gamesByGenre[genre], proj)
					table.insert(self.allGames, proj)
					
					break
				else
					break
				end
			end
		end
	end
	
	table.insert(rates, self.playerPresentedGame)
end

function gameAwards:addGameGenre(genreID)
	if not table.find(self.genreCategories, genreID) then
		self.genreCategories[#self.genreCategories + 1] = genreID
		self.gamesByGenre[genreID] = {}
	end
end

gameAwards.categoryCountFormatMethods = {}

function gameAwards:formatCategoryText(categoryList)
	local categoryCount = #categoryList
	local method = self.categoryCountFormatMethods[translation.currentLanguage]
	
	if method then
		return method(categoryCount)
	end
	
	if categoryCount == 1 then
		return gameAwards.CATEGORY_COUNT_SPEECH_SINGLE
	end
	
	return _format(gameAwards.CATEGORY_COUNT_SPEECH_MULTIPLE, "CATEGORIES", categoryCount)
end

gameAwards.TEXT_SINGLE_CATEGORY_COMPETITION = _T("GAME_AWARDS_SINGLE_CATEGORY", "The category is: GENRE")
gameAwards.TEXT_TWO_CATEGORIES_COMPETITION = _T("GAME_AWARDS_TWO_CATEGORIES", "The categories are: FIRST and SECOND")
gameAwards.TEXT_MULTIPLE_CATEGORIES_COMPETITION = _T("GAME_AWARDS_THREE_CATEGORIES", "The categories are: CATEGORIES")
gameAwards.textConcatTable = {}

function gameAwards:formatThoroughCategoryText(categoryList)
	local categories = categoryList
	local genreMap = genres.registeredByID
	
	if #categories == 1 then
		return _format(gameAwards.TEXT_SINGLE_CATEGORY_COMPETITION, "GENRE", genreMap[categories[1]].display)
	elseif #categories == 2 then
		return _format(gameAwards.TEXT_TWO_CATEGORIES_COMPETITION, "FIRST", genreMap[categories[1]].display, "SECOND", genreMap[categories[2]].display)
	end
	
	local concatDest = gameAwards.textConcatTable
	
	for i = 1, #categories - 1 do
		local genreID = categories[i]
		
		concatDest[#concatDest + 1] = genreMap[genreID].display
	end
	
	concatDest[#concatDest + 1] = _T("AND", "and")
	
	local spaceComma = _T("COMMA_WITH_SPACE", ", ")
	local final = table.concat(concatDest, spaceComma)
	
	table.clearArray(concatDest)
	
	concatDest[#concatDest + 1] = final
	concatDest[#concatDest + 1] = genreMap[categories[#categories]].display
	
	local realFinal = table.concat(concatDest, " ")
	
	table.clearArray(concatDest)
	
	return _format(gameAwards.CATEGORY_LIST, "CATEGORIES", realFinal)
end

function gameAwards:formatCategoryWinnerText(genreID)
	return _format(gameAwards.CATEGORY_WINNER_TEXT[math.random(1, #gameAwards.CATEGORY_WINNER_TEXT)], "GENRE", genres.registeredByID[genreID].display)
end

function gameAwards:formatGameWinnerText(gameProj)
	if gameProj.fakeGameAwardGame then
		return _format(_T("GAME_AWARDS_GAME_WINNER", "'GAME' by 'STUDIO'!"), "GAME", gameProj.name, "STUDIO", gameProj.company)
	end
	
	return _format(_T("GAME_AWARDS_GAME_WINNER", "'GAME' by 'STUDIO'!"), "GAME", gameProj:getName(), "STUDIO", gameProj:getOwner():getName())
end

function gameAwards.openRegistrationCallback(button)
	gameAwards:createGameSelectionFrame()
end

function gameAwards:createFirstTimePopup()
	studio:setFact(gameAwards.FIRST_TIME_POPUP_FACT, true)
	
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("GAME_AWARDS_TITLE", "Annual Game Awards"))
	popup:setText(_format(_T("GAME_AWARDS_FIRST_TIME_DESC", "Game nomination for the Annual Game Awards is now open! If you have a game that's at least RATING/MAX, you can nominate it for this event!\n\nThe winner gets extra Reputation and a shiny trophy to remember any such victory."), "RATING", gameAwards.MIN_GAME_RATING_PARTICIPATION, "MAX", review.maxRating))
	popup:hideCloseButton()
	
	local button = popup:addButton("bh20", _T("GAME_AWARDS_SHOW_MORE_INFO", "Show more info..."), gameAwards.openRegistrationCallback)
	
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
end

function gameAwards:prepareAnnouncerSpeech()
	local entries = self.speechEntries
	local talkCategories = {}
	
	table.copyOver(self.genreCategories, talkCategories)
	
	local playerGameGenre
	
	if self.playerPresentedGame then
		playerGameGenre = self.playerPresentedGame:getGenre()
		
		table.removeObject(talkCategories, playerGameGenre)
	end
	
	for i = 1, math.max(1, math.min(3, #talkCategories - 2)) do
		table.remove(talkCategories, math.random(1, #talkCategories))
	end
	
	if playerGameGenre then
		table.insert(talkCategories, playerGameGenre)
	end
	
	table.insert(entries, gameAwards.INTRO_SPEECH[math.random(1, #gameAwards.INTRO_SPEECH)])
	table.insert(entries, self:formatCategoryText(talkCategories))
	table.insert(entries, self:formatThoroughCategoryText(talkCategories))
	
	local bestByGenre = self.bestGamesByGenre
	
	for key, genreID in ipairs(talkCategories) do
		table.insert(entries, self:formatCategoryWinnerText(genreID))
		table.insert(entries, {
			crowdIntensity = 10,
			crowdMagnitude = 2,
			sound = "crowd_applause",
			text = self:formatGameWinnerText(bestByGenre[genreID])
		})
	end
	
	table.insert(entries, gameAwards.GOTY_WINNER_TEXT_INTRO[math.random(1, #gameAwards.GOTY_WINNER_TEXT_INTRO)])
	table.insert(entries, gameAwards.GOTY_WINNER_TEXT_MAIN[math.random(1, #gameAwards.GOTY_WINNER_TEXT_MAIN)])
	table.insert(entries, {
		crowdIntensity = 10,
		crowdMagnitude = 2,
		sound = "crowd_applause_goty",
		text = self:formatGameWinnerText(self.bestGame)
	})
end

function gameAwards:findAwardsByTarget(target, rawFind)
	local destination
	
	for key, data in ipairs(self.awards) do
		if data.awardee == target then
			destination = data
			
			break
		end
	end
	
	if not destination and not rawFind then
		destination = self:_initAwardStructure(target)
		
		table.insert(self.awards, destination)
	end
	
	return destination
end

function gameAwards:addAward(target, award, data, repChange)
	local destination = self:findAwardsByTarget(target)
	
	if repChange then
		destination.repChange = destination.repChange + repChange
	end
	
	if not table.find(destination.awards, award) then
		table.insert(destination.awards, {
			award = award,
			data = data
		})
	end
end

function gameAwards:_initAwardStructure(target)
	return {
		repChange = 0,
		penalties = 0,
		awardee = target,
		awards = {}
	}
end

function gameAwards:addPenalty(target, penalty, repChange)
	local destination = self:findAwardsByTarget(target)
	
	if repChange then
		destination.repChange = destination.repChange + repChange
	end
	
	destination.penalties = destination.penalties + penalty
end

function gameAwards:formatWinText(data, descBox, wrapWidth)
	return gameAwards.WIN_TYPE_TEXT[data.award](data, descBox, wrapWidth)
end

function gameAwards:transferAwards()
	local hasPlayerWon = false
	local year = timeline:getYear()
	local gameName
	
	if self.playerPresentedGame then
		gameName = self.playerPresentedGame:getName()
	end
	
	for key, data in ipairs(self.awards) do
		local finalAwardData = {}
		
		for key, awardData in ipairs(data.awards) do
			finalAwardData[#finalAwardData + 1] = awardData
		end
		
		if data.awardee:isPlayer() then
			hasPlayerWon = true
			
			data.awardee:addGameAwardData(finalAwardData, year, gameName, data.repChange, data.penalties)
		elseif gameName then
			data.awardee:addGameAwardData(finalAwardData, year, gameName)
		end
		
		data.awardee:increaseReputation(data.repChange)
	end
	
	if not hasPlayerWon and gameName then
		studio:addGameAwardData({}, year, gameName)
	end
end

function gameAwards:findBestGame()
	local ratings = self.scoreByGame
	local bestGame, highestScore = nil, -math.huge
	local topByGenre = {}
	
	for key, gameProj in ipairs(self.allGames) do
		local score
		
		if gameProj.fakeGameAwardGame then
			score = gameProj.rating * gameProj.scale
		else
			score = gameProj:getRealRating() * gameProj:getScale()
		end
		
		ratings[gameProj] = score
		
		if highestScore < score then
			bestGame = gameProj
			highestScore = score
		end
	end
	
	self.highestGameScore = highestScore
	self.bestGame = bestGame
	
	if not self.bestGame.fakeGameAwardGame then
		local repChange = self:getGOTYReputationChange(highestScore)
		local owner = self.bestGame:getOwner()
		
		self:addAward(owner, gameAwards.WIN_TYPE.GOTY, nil, repChange)
	end
end

function gameAwards:findBestCategoryGames()
	local ratings = self.scoreByGame
	local gamesByGenre = self.gamesByGenre
	local bestByGenre = self.bestGamesByGenre
	
	for k, genreID in ipairs(self.genreCategories) do
		local bestCatGame, bestGenre, highestRating = nil, nil, -math.huge
		
		for j, game in ipairs(gamesByGenre[genreID]) do
			local rating
			
			if game.fakeGameAwardGame then
				rating = ratings[game]
			else
				genre = game:getGenre()
				rating = ratings[game]
			end
			
			if highestRating < rating then
				highestRating = rating
				bestCatGame = game
			end
		end
		
		bestByGenre[genreID] = bestCatGame
		
		if not bestCatGame.fakeGameAwardGame then
			local change = self:getCategoryReputationChange(highestRating)
			local owner = bestCatGame:getOwner()
			
			self:addAward(owner, gameAwards.WIN_TYPE.CATEGORY, bestCatGame:getGenre(), change)
		end
	end
end

function gameAwards:handleEvent(event)
	if event == timeline.EVENTS.NEW_MONTH and timeline:getYear() >= gameAwards.AVAILABILITY_YEAR then
		local month = timeline:getMonth()
		
		if month == gameAwards.REGISTRATION_MONTH then
			self:onRegistrationAvailable()
		elseif month == gameAwards.START_MONTH then
			self:begin()
		end
	end
end

function gameAwards:onRegistrationAvailable()
	if not studio:getFact(gameAwards.FIRST_TIME_POPUP_FACT) then
		self:createFirstTimePopup()
	end
	
	self:attemptCreateUpcomingDisplay()
	self:setupFakeGames()
end

function gameAwards:verifyCompetitors()
	self:setupFakeGames()
end

function gameAwards:getTimeUntilBegin()
	local month = timeline:getMonth()
	
	if month >= gameAwards.START_MONTH then
		return timeline:getTimePeriodText(timeline:yearToTime(timeline:getYear() + 1) + (gameAwards.START_MONTH - 1) * timeline.DAYS_IN_MONTH - timeline.curTime)
	end
	
	return timeline:getTimePeriodText(timeline:yearToTime(timeline:getYear()) + (gameAwards.START_MONTH - 1) * timeline.DAYS_IN_MONTH - timeline.curTime)
end

function gameAwards:getTimeUntilRegistrationEnd()
	local month = timeline:getMonth()
	local start = gameAwards.REGISTRATION_MONTH
	
	return timeline:getTimePeriodText((start + gameAwards.REGISTRATION_DURATION) * timeline.DAYS_IN_MONTH - (timeline.curTime - timeline:yearToTime(timeline:getYear())))
end

function gameAwards:getTimeUntilRegistration()
	local month = timeline:getMonth()
	local time
	
	if month >= gameAwards.REGISTRATION_MONTH then
		time = timeline:getTimePeriodText(timeline:yearToTime(timeline:getYear() + 1) + timeline:monthToTime(gameAwards.REGISTRATION_MONTH) - timeline.curTime)
	else
		time = timeline:getTimePeriodText(timeline:yearToTime(timeline:getYear()) + (gameAwards.REGISTRATION_MONTH - 1) * timeline.DAYS_IN_MONTH - timeline.curTime)
	end
	
	return time
end

function gameAwards:canRegisterFor()
	if self.playerPresentedgame then
		return false
	end
	
	return self:isRegistrationTime()
end

function gameAwards:isRegistrationTime()
	local month = timeline:getMonth()
	local start = gameAwards.REGISTRATION_MONTH
	
	return start <= month and month < start + gameAwards.REGISTRATION_DURATION
end

function gameAwards:canViewNominees()
	local month = timeline:getMonth()
	
	return month >= gameAwards.REGISTRATION_MONTH and month <= gameAwards.START_MONTH
end

function gameAwards:shouldDestroyUpcomingDisplay()
	local month = timeline:getMonth()
	local start = gameAwards.REGISTRATION_MONTH
	
	return month >= start + gameAwards.REGISTRATION_DURATION or month < start
end

function gameAwards:registerForCallback()
	gameAwards:createGameSelectionFrame()
end

function gameAwards:fillInteractionComboBox(cbox)
	if self.playerParticipating then
		return 
	end
	
	cbox:addOption(0, 0, 150, 20, _T("GAME_AWARDS_REGISTER", "Register..."), fonts.get("pix20"), gameAwards.registerForCallback)
end

function gameAwards:attemptCreateUpcomingDisplay()
	if self:isRegistrationTime() then
		local element = gui.create("UpcomingGameAwardsDisplay")
		
		game.addToProjectScroller(element, self)
		element:fullSetup()
	end
end

function gameAwards:createVictoryPopup()
	local text = _format(gameAwards.POST_WIN_QUOTE[math.random(1, #gameAwards.POST_WIN_QUOTE)], "STUDIO", studio:getName(), "QUOTE", self.playerSpeech[math.random(2, 3)])
	local popup = game.createPopup(500, _T("GAME_AWARDS_POST_WIN_TITLE", "Game of the Year!"), text, "pix24", "pix20")
	
	frameController:push(popup)
end

function gameAwards:viewCompetitors()
	gameAwards:verifyCompetitors()
	
	local frame = gui.create("Frame")
	
	frame:setSize(450, 400)
	frame:setFont("pix24")
	frame:setText(_T("ANNUAL_GAME_AWARDS_COMPETITORS", "Competitors"))
	
	local scroll = gui.create("ScrollbarPanel", frame)
	
	scroll:setPos(_S(5), _S(35))
	scroll:setSize(frame.rawW - 10, frame.rawH - 40)
	scroll:setSpacing(3)
	scroll:setPadding(3, 3)
	scroll:setAdjustElementPosition(true)
	scroll:addDepth(100)
	
	local tempWidth = frame.rawW - 14
	
	for key, genreID in ipairs(self.genreCategories) do
		local category = gui.create("Category", frame)
		
		category:setFont("bh24")
		category:setHeight(26)
		category:setText(genres.registeredByID[genreID].display)
		category:assumeScrollbar(scroll)
		scroll:addItem(category)
		
		for key, gameData in ipairs(self.gamesByGenre[genreID]) do
			local elem = gui.create("GameAwardsCompetitor")
			
			elem:setWidth(tempWidth)
			elem:setGameData(gameData)
			category:addItem(elem)
		end
	end
	
	frame:center()
	frameController:push(frame)
end

function gameAwards:factorInPlayer()
	local playerGenre = self.playerPresentedGame:getGenre()
	
	self:addGameGenre(playerGenre)
	
	if not table.find(self.gamesByGenre[playerGenre], self.playerPresentedGame) then
		table.insert(self.allGames, self.playerPresentedGame)
		table.insert(self.gamesByGenre[playerGenre], self.playerPresentedGame)
	end
end

function gameAwards:save()
	local saved = {}
	
	if self.playerPresentedGame then
		saved.playerPresentedGame = self.playerPresentedGame:getUniqueID()
	end
	
	saved.fakeGames = self.fakeGames
	saved.generatedGameCount = self.generatedGameCount
	saved.playerParticipating = self.playerParticipating
	saved.playerSpeech = self.playerSpeech
	saved.prevPlayerSpeech = self.prevPlayerSpeech
	
	return saved
end

function gameAwards:load(data)
	if data.playerPresentedGame then
		self.playerPresentedGame = studio:getGameByUniqueID(data.playerPresentedGame)
		
		self:factorInPlayer()
	end
	
	if data.fakeGames then
		for key, gameData in ipairs(data.fakeGames) do
			self:addGameGenre(gameData.genre)
			table.insert(self.gamesByGenre[gameData.genre], gameData)
			
			self.allGames[#self.allGames + 1] = gameData
			self.fakeGames[key] = gameData
		end
	end
	
	self.playerParticipating = data.playerParticipating
	self.playerSpeech = data.playerSpeech
	self.prevPlayerSpeech = data.prevPlayerSpeech
	self.generatedGameCount = data.generatedGameCount or self.generatedGameCount
	
	gameAwards:attemptCreateUpcomingDisplay()
end
