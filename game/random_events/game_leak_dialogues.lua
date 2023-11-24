dialogueHandler.registerQuestion({
	id = "game_leak_question_start",
	text = {
		_T("GAME_LEAK_QUESTION_START_1", "Uh, boss, something bad just happened."),
		_T("GAME_LEAK_QUESTION_START_2", "Hey boss, there is a really important matter we need to talk about."),
		_T("GAME_LEAK_QUESTION_START_3", "Boss, you won't believe what just happened.")
	},
	answers = {
		"game_leak_answer_start_proceed",
		"game_leak_answer_start_end"
	}
})
dialogueHandler.registerQuestion({
	id = "game_leak_question_start_retry",
	text = {
		_T("GAME_LEAK_QUESTION_START_RETRY_1", "Boss, I'm serious, one of the games we worked on had been leaked onto the internet."),
		_T("GAME_LEAK_QUESTION_START_RETRY_2", "Look, this isn't trivial stuff, one of the games we worked on has leaked on the internet."),
		_T("GAME_LEAK_QUESTION_START_RETRY_3", "Listen, this is serious, a game we haven't released yet has leaked on the internet.")
	},
	onStart = function(self, dialogueObject, answerID)
		dialogueObject:setFact("retried_to_talk_about_leak", true)
	end,
	answers = {
		"game_leak_answer_retry_proceed",
		"game_leak_answer_retry_end"
	}
})
dialogueHandler.registerQuestion({
	id = "game_leak_main_decision",
	baseText = _T("GAME_LEAK_MAIN_DECISION_TEXT", "We've noticed that our 'GAMENAME' game project, that has not yet been released, is leaked on the internet. THEIR_REACTION\n\nWe need to provide a response of some kind, but if we say the wrong things the people might lose faith in us. With that kept in mind, what should we do?"),
	baseTextRetried = _T("GAME_LEAK_MAIN_DECISION_TEXT_RETRIED", "Our 'GAMENAME' game project, that has not yet been released, is leaked on the internet. THEIR_REACTION\n\nWe need to provide a response of some kind, but if we say the wrong things the people might lose faith in us. With that kept in mind, what should we do?"),
	getText = function(self, dialogueObject)
		local retried = dialogueObject:getFact("retried_to_talk_about_leak")
		local baseText
		
		if retried then
			baseText = self.baseTextRetried
		else
			baseText = self.baseText
		end
		
		return string.easyformatbykeys(baseText, "GAMENAME", dialogueObject:getFact("game_project_object"):getName(), "THEIR_REACTION", dialogueObject:getFact("reaction_text"))
	end,
	answers = {
		"game_leak_answer_thank",
		"game_leak_answer_reassure",
		"game_leak_answer_assert",
		"game_leak_answer_warn"
	}
})
dialogueHandler.registerQuestion({
	id = "game_leak_question_community_response_start",
	text = {
		_T("GAME_LEAK_QUESTION_COMMUNITY_RESPONSE_START_1", "Hey boss, we've been monitoring the response of the community and I think we have a consensus on what they thought of it."),
		_T("GAME_LEAK_QUESTION_COMMUNITY_RESPONSE_START_2", "Boss, we've been checking online forums for some time and I think we have a general idea on what they thought of what we've said.")
	},
	answers = {
		"game_leak_answer_community_response_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "game_leak_question_community_response",
	getText = function(self, dialogueObject)
		local eventObject = dialogueObject:getFact("response_event")
		local gameLeak = randomEvents:getData("game_leak")
		local responseType = eventObject:getResponseType()
		local playerResponse = eventObject:getPlayerResponse()
		local gameProj = eventObject:getProject()
		local popularityLoss = eventObject:getPopularityLoss()
		local resultText
		
		if playerResponse == gameLeak.PLAYER_RESPONSE_TYPE.ASSERT then
			if responseType == gameLeak.QUALITY_TYPE.LOW then
				resultText = _T("LOW_RESPONSE_ASSERT_OPTION", "The people took to our assertion negatively, and the project has lost additional POPLOSS popularity points.")
			elseif responseType == gameLeak.QUALITY_TYPE.AVERAGE then
				resultText = _T("AVERAGE_RESPONSE_ASSERT_OPTION", "The people took to our assertion very positively, we've regained about half of the popularity we've lost, which is POPLOSS points.")
			elseif responseType == gameLeak.QUALITY_TYPE.HIGH then
				resultText = _T("HIGH_RESPONSE_ASSERT_OPTION", "Some people took to our assertion positively, we've regained POPLOSS popularity points. We could have done something other than asserting that it will get even better, because even in its' current state the majority love the game.")
			end
		elseif playerResponse == gameLeak.PLAYER_RESPONSE_TYPE.REASSURE then
			if responseType == gameLeak.QUALITY_TYPE.LOW then
				resultText = _T("LOW_RESPONSE_REASSURE_OPTION", "Some people have responded to our reassurance positively. We've regained POPLOSS popularity points.")
			elseif responseType == gameLeak.QUALITY_TYPE.AVERAGE then
				resultText = _T("AVERAGE_RESPONSE_REASSURE_OPTION", "Our attempted reassurance seemed to have no effect on the interest of people, we've neither lost nor regained any popularity points.")
			elseif responseType == gameLeak.QUALITY_TYPE.HIGH then
				resultText = _T("HIGH_RESPONSE_REASSURE_OPTION", "A small amount of people reacted to our reassurance negatively. Some people started questioning why we'd respond like this, even though most people loved what they saw.\n\nThis has cost the project POPLOSS popularity points.")
			end
		elseif responseType == gameLeak.QUALITY_TYPE.LOW then
			resultText = _T("LOW_RESPONSE_THANK_OPTION", "The project has lost POPLOSS popularity points. The people are furious because they thought that thanking for providing feedback on a game they consider to be bad and beyond saving is not the right thing to do.")
		elseif responseType == gameLeak.QUALITY_TYPE.AVERAGE then
			resultText = _T("AVERAGE_RESPONSE_THANK_OPTION", "About a quarter took to our thanks in a positive way, and the project has regained POPLOSS popularity.")
		elseif responseType == gameLeak.QUALITY_TYPE.HIGH then
			resultText = _T("HIGH_RESPONSE_THANK_OPTION", "Everyone took to our thanks in a positive way, and we've regained all popularity loss there has been. I think this is the best outcome there could have been!")
		end
		
		resultText = string.easyformatbykeys(resultText, "POPLOSS", math.abs(popularityLoss))
		
		gameProj:increasePopularity(popularityLoss)
		
		return resultText
	end,
	answers = {
		"game_leak_answer_community_response_finish"
	}
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_start_proceed",
	question = "game_leak_main_decision",
	text = _T("GAME_LEAK_ANSWER_START_PROCEED", "Alright, I'm listening.")
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_start_end",
	question = "game_leak_question_start_retry",
	text = _T("GAME_LEAK_ANSWER_START_END", "Sorry, I'm busy right now, maybe another time?")
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_retry_proceed",
	question = "game_leak_main_decision",
	text = _T("GAME_LEAK_ANSWER_RETRY_PROCEED", "[CONTINUE]")
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_retry_end",
	endDialogue = true,
	text = _T("GAME_LEAK_ANSWER_RETRY_END", "Figure something out, I'm sure it's not as bad as it seems.")
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_community_response_continue",
	question = "game_leak_question_community_response",
	text = _T("GAME_LEAK_ANSWER_COMMUNITY_RESPONSE_CONTINUE", "What did they think?")
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_community_response_finish",
	endDialogue = true,
	text = _T("GAME_LEAK_ANSWER_COMMUNITY_RESPONSE_FINISH", "Thank you for the info.")
})

local function scheduleRevelationDialogue(responseType, lostPopularity, gameProj, pickedAnswerType)
	local eventObject = scheduledEvents:instantiateEvent("game_leak_response_event")
	
	eventObject:setResponseType(responseType)
	eventObject:setProject(gameProj)
	eventObject:setPopularityLoss(lostPopularity)
	eventObject:setPlayerResponse(pickedAnswerType)
end

dialogueHandler.registerAnswer({
	id = "game_leak_answer_reassure",
	text = _T("GAME_LEAK_ANSWER_REASSURE", "Reassure that the game will be good."),
	onPick = function(self, dialogueObject)
		local gameLeak = randomEvents:getData("game_leak")
		local responseType = dialogueObject:getFact("quality_id")
		local gameProject = dialogueObject:getFact("game_project_object")
		local lostPopularity = dialogueObject:getFact("popularity_loss")
		local resultText
		local change = 0
		
		if responseType == gameLeak.QUALITY_TYPE.LOW then
			change = lostPopularity * 0.2
		elseif responseType == gameLeak.QUALITY_TYPE.HIGH then
			change = lostPopularity * -0.1
		end
		
		change = math.ceil(change)
		
		scheduleRevelationDialogue(responseType, change, gameProject, gameLeak.PLAYER_RESPONSE_TYPE.REASSURE)
	end
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_assert",
	text = _T("GAME_LEAK_ANSWER_ASSERT", "Assert that the game will get even better."),
	onPick = function(self, dialogueObject)
		local gameLeak = randomEvents:getData("game_leak")
		local responseType = dialogueObject:getFact("quality_id")
		local gameProject = dialogueObject:getFact("game_project_object")
		local lostPopularity = dialogueObject:getFact("popularity_loss")
		local resultText
		local change = 0
		
		if responseType == gameLeak.QUALITY_TYPE.LOW then
			change = lostPopularity * -0.05
		elseif responseType == gameLeak.QUALITY_TYPE.AVERAGE then
			change = lostPopularity * 0.5
		elseif responseType == gameLeak.QUALITY_TYPE.HIGH then
			change = lostPopularity * 0.25
		end
		
		change = math.ceil(change)
		
		scheduleRevelationDialogue(responseType, change, gameProject, gameLeak.PLAYER_RESPONSE_TYPE.ASSERT)
	end
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_thank",
	text = _T("GAME_LEAK_ANSWER_THANK", "Thank everyone for providing feedback."),
	onPick = function(self, dialogueObject)
		local gameLeak = randomEvents:getData("game_leak")
		local responseType = dialogueObject:getFact("quality_id")
		local gameProject = dialogueObject:getFact("game_project_object")
		local lostPopularity = dialogueObject:getFact("popularity_loss")
		local resultText
		local change = 0
		
		if responseType == gameLeak.QUALITY_TYPE.LOW then
			change = lostPopularity * -0.1
		elseif responseType == gameLeak.QUALITY_TYPE.AVERAGE then
			change = lostPopularity * 0.25
		elseif responseType == gameLeak.QUALITY_TYPE.HIGH then
			change = lostPopularity
		end
		
		change = math.ceil(change)
		
		scheduleRevelationDialogue(responseType, change, gameProject, gameLeak.PLAYER_RESPONSE_TYPE.THANK)
	end
})
dialogueHandler.registerAnswer({
	id = "game_leak_answer_warn",
	text = _T("GAME_LEAK_ANSWER_WARN", "Make a public warning directed at whoever leaked the game."),
	onPick = function(self, dialogueObject)
		local popup = gui.create("Popup")
		
		popup:setWidth(600)
		popup:setFont(fonts.get("pix24"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setTitle(_T("RESPONSE_REACTION_TITLE", "Response Reaction"))
		popup:setText(_T("WARNED_LEAKER_RESPONSE", "You've decided to play it safe and simply issue a warning to whoever was responsible for leaking the game.\n\nThe game project has not regained, nor lost any additional popularity."))
		popup:addOKButton(fonts.get("pix20"))
		popup:center()
		frameController:push(popup)
	end
})
