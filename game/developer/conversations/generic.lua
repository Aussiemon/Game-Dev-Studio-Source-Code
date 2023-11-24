local discussRaise = {}

discussRaise.id = "received_raise"
discussRaise.maxDiscussTime = timeline.DAYS_IN_MONTH * 2
discussRaise.lastRaiseConvoTimeFact = "last_raise_convo"
discussRaise.displayText = {
	_T("RECEIVED_RAISE_CONVO_1", "Did you get that raise yet?"),
	_T("RECEIVED_RAISE_CONVO_2", "How about that raise you mentioned, you get it yet?")
}

function discussRaise:begin(convoObj)
	discussRaise.baseClass.begin(self, convoObj)
	convoObj:getTarget():setFact(discussRaise.lastRaiseConvoTimeFact, timeline.curTime)
end

function discussRaise:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() then
		return 
	end
	
	local lastTime = target:getFact(discussRaise.lastRaiseConvoTimeFact)
	
	if lastTime and lastTime + discussRaise.maxDiscussTime > timeline.curTime then
		return false
	end
	
	local time = target:getLastRaiseTime()
	
	return time and time + discussRaise.maxDiscussTime > timeline.curTime
end

conversations:registerTopic(discussRaise)

local raiseReceivedAnswer = {}

raiseReceivedAnswer.id = "received_raise_answer"
raiseReceivedAnswer.displayText = {
	_T("RECEIVED_RAISE_CONVO_ANSWER_1", "Sure did!"),
	_T("RECEIVED_RAISE_CONVO_ANSWER_2", "Yep, life is good.")
}
raiseReceivedAnswer.topicID = "received_raise"

conversations:registerAnswer(raiseReceivedAnswer)

local newOfficePurchased = {}

newOfficePurchased.id = "purchased_new_office"
newOfficePurchased.displayText = {
	_T("NEW_OFFICE_PURCHASED_CONVO_1", "Did you hear? Our boss just purchased a new office building!"),
	_T("NEW_OFFICE_PURCHASED_CONVO_2", "Our boss just bought a new office building!")
}

function newOfficePurchased:begin(...)
	newOfficePurchased.baseClass.begin(self, ...)
	conversations:removeTopicToTalkAbout(officeBuilding.CONVERSATION_NEWLY_PURCHASED)
end

function newOfficePurchased:isTopicValid(initiator, target)
	local officeID = conversations:canTalkAboutTopic(officeBuilding.CONVERSATION_NEWLY_PURCHASED)
	
	if not officeID or initiator:isPlayerCharacter() or target:isPlayerCharacter() then
		return false
	end
	
	local office = initiator:getOffice()
	
	if office and office:getID() == officeID then
		return false
	end
	
	return true
end

conversations:registerTopic(newOfficePurchased)

local officePurchasedAnswer = {}

officePurchasedAnswer.id = "purchased_new_office_answer"
officePurchasedAnswer.displayText = {
	_T("NEW_OFFICE_PURCHASED_ANSWER_1", "Oh, that's great!"),
	_T("NEW_OFFICE_PURCHASED_ANSWER_2", "That's awesome!"),
	_T("NEW_OFFICE_PURCHASED_ANSWER_3", "We're expanding? Fantastic!")
}
officePurchasedAnswer.topicID = "purchased_new_office"

conversations:registerAnswer(officePurchasedAnswer)

local badFinancial = {}

badFinancial.id = "bad_financial_situation"
badFinancial.displayText = {
	_T("BAD_FINANCIAL_SITUATION_CONVO_1", "Our finances aren't looking too good. We're in deep, aren't we?"),
	_T("BAD_FINANCIAL_SITUATION_CONVO_2", "Did you hear? The studio's having some financial problems.")
}

function badFinancial:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() or target:isPlayerCharacter() then
		return false
	end
	
	return studio:getFunds() < 0
end

conversations:registerTopic(badFinancial)

local badFinancialAnswer = {}

badFinancialAnswer.id = "bad_financial_situation_answer"
badFinancialAnswer.displayText = {
	_T("BAD_FINANCIAL_SITUATION_ANSWER_1", "Let's hope our boss has got an ace up his sleeve."),
	_T("BAD_FINANCIAL_SITUATION_ANSWER_2", "It'd be a shame if this studio went bankrupt."),
	_T("BAD_FINANCIAL_SITUATION_ANSWER_3", "Just keep your fingers crossed it doesn't get worse.")
}
badFinancialAnswer.topicID = "bad_financial_situation"

conversations:registerAnswer(badFinancialAnswer)

local recentGameReviews = {}

recentGameReviews.id = "recent_game_reviews"
recentGameReviews.displayText = {
	_T("GAME_REVIEWS_CONVO_1", "Have you seen the reviews for 'GAME'?"),
	_T("GAME_REVIEWS_CONVO_2", "Did you see the recent reviews for 'GAME'?"),
	_T("GAME_REVIEWS_CONVO_3", "'GAME' just got reviewed, have you seen the score?")
}

function recentGameReviews:isTopicValid(initiator, target)
	local gameID = conversations:canTalkAboutTopic(gameProject.REVIEW_CONVERSATION_TOPIC)
	
	if gameID then
		local gameProject = studio:getGameByUniqueID(gameID)
		
		if not gameProject:getFact(gameProject.TALKED_ABOUT_REVIEWS_FACT) then
			return true
		end
	end
	
	return false
end

function recentGameReviews:pickTalkText()
	local gameID = conversations:canTalkAboutTopic(gameProject.REVIEW_CONVERSATION_TOPIC)
	local gameProject = studio:getGameByUniqueID(gameID)
	
	gameProject:setFact(gameProject.TALKED_ABOUT_REVIEWS_FACT, true)
	
	local text = recentGameReviews.baseClass.pickTalkText(self)
	
	return _format(text, "GAME", gameProject:getName())
end

conversations:registerTopic(recentGameReviews)

local reviewAnswer = {}

reviewAnswer.badGameRating = 4
reviewAnswer.averageGameRating = 6
reviewAnswer.goodGameRating = 8
reviewAnswer.greatGameRating = 10
reviewAnswer.id = "recent_game_reviews_answer"
reviewAnswer.displayText = {
	bad = {
		_T("GAME_REVIEWS_CONVO_BAD_1", "It got RATING out of MAX. That's not good."),
		_T("GAME_REVIEWS_CONVO_BAD_2", "Yes, I have, and I'm not happy."),
		_T("GAME_REVIEWS_CONVO_BAD_3", "Don't remind me. RATING out of MAX... What a joke.")
	},
	medium = {
		_T("GAME_REVIEWS_CONVO_MEDIUM_1", "Eh, a RATING is not too bad, I guess."),
		_T("GAME_REVIEWS_CONVO_MEDIUM_2", "RATING out of MAX is average territory."),
		_T("GAME_REVIEWS_CONVO_MEDIUM_3", "Yeah, could have been better.")
	},
	good = {
		_T("GAME_REVIEWS_CONVO_GOOD_1", "A RATING is pretty good. I'm happy."),
		_T("GAME_REVIEWS_CONVO_GOOD_2", "Yeah, we did a good job on the game."),
		_T("GAME_REVIEWS_CONVO_GOOD_3", "RATING out of MAX... That's good.")
	},
	great = {
		_T("GAME_REVIEWS_CONVO_GREAT_1", "RATING out of MAX?! I knew people would love it!"),
		_T("GAME_REVIEWS_CONVO_GREAT_2", "Yes! RATING out of MAX! This is so good!"),
		_T("GAME_REVIEWS_CONVO_GREAT_3", "RATING out of MAX. I can't wait for more reviews!")
	}
}

function reviewAnswer:pickTalkText()
	local gameID = conversations:canTalkAboutTopic(gameProject.REVIEW_CONVERSATION_TOPIC)
	local gameProject = studio:getGameByUniqueID(gameID)
	local reviewList = gameProject:getReviews()
	local randomReview = reviewList[math.random(1, #reviewList)]
	local rating = randomReview:getRating()
	local baseText
	
	if rating <= self.badGameRating then
		baseText = self.displayText.bad
	elseif rating <= self.averageGameRating then
		baseText = self.displayText.medium
	elseif rating <= self.goodGameRating then
		baseText = self.displayText.good
	elseif rating <= self.greatGameRating then
		baseText = self.displayText.great
	end
	
	return _format(baseText[math.random(1, #baseText)], "RATING", rating, "MAX", review.maxRating)
end

reviewAnswer.topicID = "recent_game_reviews"

conversations:registerAnswer(reviewAnswer)

local outsellDevCostsConvo = {}

outsellDevCostsConvo.id = "outsell_dev_costs"
outsellDevCostsConvo.displayText = {
	_T("OUTSELL_DEV_COSTS_CONVO_1", "Oh yeah, we're rolling in it!"),
	_T("OUTSELL_DEV_COSTS_CONVO_2", "Ka-ching! 'GAME' is selling like hot cakes!")
}

function outsellDevCostsConvo:isTopicValid(initiator, target)
	local gameID = conversations:canTalkAboutTopic(gameProject.OUTSOLD_DEV_COSTS_TOPIC)
	
	if gameID then
		local gameObj = studio:getGameByUniqueID(gameID)
		
		if not gameObj:getFact(gameProject.TALKED_ABOUT_OUTSELLING_DEV_COSTS_FACT) then
			return true
		end
	end
	
	return false
end

function outsellDevCostsConvo:pickTalkText()
	local gameID = conversations:canTalkAboutTopic(gameProject.OUTSOLD_DEV_COSTS_TOPIC)
	
	conversations:removeTopicToTalkAbout(gameProject.OUTSOLD_DEV_COSTS_TOPIC)
	
	local gameObj = studio:getGameByUniqueID(gameID)
	
	gameObj:setFact(gameProject.TALKED_ABOUT_OUTSELLING_DEV_COSTS_FACT, true)
	
	local text = outsellDevCostsConvo.baseClass.pickTalkText(self)
	
	return _format(text, "GAME", gameObj:getName())
end

conversations:registerTopic(outsellDevCostsConvo)

local reviewAnswer = {}

reviewAnswer.id = "outsell_dev_costs_answer"
reviewAnswer.displayText = {
	_T("OUTSELL_DEV_COSTS_CONVO_ANSWER_1", "All that hard work paid off."),
	_T("OUTSELL_DEV_COSTS_CONVO_ANSWER_2", "Dosh!"),
	_T("OUTSELL_DEV_COSTS_CONVO_ANSWER_3", "So, when are we celebrating?")
}

function reviewAnswer:pickTalkText()
	return self.displayText[math.random(1, #self.displayText)]
end

reviewAnswer.topicID = "outsell_dev_costs"

conversations:registerAnswer(reviewAnswer)
