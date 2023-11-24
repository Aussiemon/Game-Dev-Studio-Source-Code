dialogueHandler.registerQuestion({
	id = "call_ceo_initial",
	text = _T("INITIAL_CEO_CALL", "Hello?"),
	answers = {
		"call_ceo_initial_answer"
	}
})
dialogueHandler.registerAnswer({
	question = "call_ceo_main",
	id = "call_ceo_initial_answer",
	getText = function(self, dialogueObject)
		return _format(_T("INITIAL_CEO_CALL_INTRODUCE_PLAYER", "Hello, this is the CEO of 'COMPANY' calling."), "COMPANY", studio:getName())
	end,
	onPick = function(self, dialogueObject)
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		dialogueObject:setFact("had_been_introduced", rgc:wasPlayerIntroduced())
		rgc:markPlayerIntroduced()
	end,
	getReturnText = function(self, dialogueObject)
		if dialogueObject:setFact("had_been_introduced") then
			local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
			
			if rgc:getRelationship() < 0 or rgc:getHadCalledPlayer() then
				return _T("INITIAL_CEO_CALL_ALREADY_KNOWN", "Yeah, I know who you are. What do you want?")
			end
		end
		
		return _T("INITIAL_CEO_CALL_NOT_KNOWN_YET", "Ah, hello, is there something you need?")
	end
})
dialogueHandler.registerQuestion({
	id = "call_ceo_main",
	getText = function(self, dialogueObject)
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		local relationship = rgc:getRelationship()
		
		if relationship >= 50 then
			return _T("IN_CALL_WITH_RIVAL_VERY_POSITIVE", "Hey, good of you to call! How can I help you?")
		elseif relationship > 0 then
			return _T("IN_CALL_WITH_RIVAL_POSITIVE", "Hey, what's up man?")
		elseif relationship <= -50 then
			return _T("IN_CALL_WITH_RIVAL_HARD_FOE", "Make it quick.")
		elseif relationship < 0 then
			return _T("IN_CALL_WITH_RIVAL_FOE", "You need something?")
		end
		
		return _T("IN_CALL_WITH_RIVAL_NEUTRAL", "Was there something you wanted?")
	end,
	getAnswers = function(self, dialogueObject)
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		local answers = {}
		
		rgc:fillConversationOptions(self, answers)
		table.insert(answers, "finish_ceo_call")
		
		return answers
	end
})
dialogueHandler.registerAnswer({
	id = "finish_ceo_call",
	text = {
		_T("FINISH_CEO_CONVERSATION_1", "That's all. [HANG UP]"),
		_T("FINISH_CEO_CONVERSATION_2", "We'll talk later. [HANG UP]")
	}
})
dialogueHandler.registerAnswer({
	id = "generic_hang_up",
	text = {
		_T("GENERIC_HANG_UP", "[HANG UP]")
	}
})
dialogueHandler.registerQuestion({
	id = "ask_ceo_about_reviewers_no_help",
	nextQuestion = "call_ceo_main",
	answers = {
		"return_from_no_ceo_help"
	},
	getText = function(self, dialogueObject)
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		dialogueObject:setFact("help_request_attempts", (dialogueObject:getFact("help_request_attempts") or 0) + 1)
		
		local attempts = dialogueObject:getFact("help_request_attempts")
		
		if attempts == 2 then
			return _T("ASK_CEO_ABOUT_REVIEWERS_NO_HELP_2", "Did you not hear me the first time? I said I'm not going to help you.")
		elseif attempts > 2 then
			return _T("ASK_CEO_ABOUT_REVIEWERS_NO_HELP_3", "Stop wasting my time.")
		end
		
		if rgc:getAngerReasonAmount(rivalGameCompany.ANGER_CHANGE_REASON.SLANDER) > 0 then
			return _T("ASK_CEO_ABOUT_REVIEWERS_NO_HELP_SLANDER", "You know, I would have helped you on this, except you tried ruining my reputation with slander before, so don't expect any help from me.")
		elseif rgc:getAngerReasonAmount(rivalGameCompany.ANGER_CHANGE_REASON.EMPLOYEE_STEALING) > 0 then
			return _T("ASK_CEO_ABOUT_REVIEWERS_NO_HELP_STEALING", "Why don't you ask that one of my employees you've stolen, huh?")
		end
		
		return _T("ASK_CEO_ABOUT_REVIEWERS_NO_HELP_1", "You and I are both on bad terms. I'm not going to help you.")
	end
})
dialogueHandler.registerQuestion({
	id = "ask_ceo_about_reviewers_continue",
	text = _T("ASK_CEO_ABOUT_REVIEWERS_CONTINUE", "No problem, which community do you want to know about?"),
	getAnswers = function(self, dialogueObject)
		local reviewerList = {}
		local answers = {}
		
		for key, reviewerObject in ipairs(review:getReviewers()) do
			if not reviewerObject:getBribeChancesRevealed() then
				table.insert(reviewerList, reviewerObject)
				table.insert(answers, "inquire_about_reviewer")
			end
		end
		
		dialogueObject:setFact("reviewer_list", reviewerList)
		table.insert(answers, "ask_ceo_about_reviewers_return")
		
		return answers
	end
})
dialogueHandler.registerAnswer({
	id = "ask_ceo_about_reviewers",
	text = _T("ASK_ABOUT_REVIEWERS", "I would like to find out about potential 'partnerships' with reviewer communities. Would you share your knowledge?"),
	getNextQuestion = function(self, dialogueObject)
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		if rgc:isHostile() then
			return "ask_ceo_about_reviewers_no_help"
		end
		
		return "ask_ceo_about_reviewers_continue"
	end
})
dialogueHandler.registerAnswer({
	id = "return_from_no_ceo_help",
	text = _T("RETURN_FROM_NO_CEO_HELP", "[...]"),
	returnText = _T("RETURN_FROM_NO_CEO_HELP_RETURN_TEXT", "Anything else?"),
	canEndDialogue = function(self, dialogueObject)
		if dialogueObject:getFact("help_request_attempts") > 2 then
			dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):makeAnnoyed()
			
			return true
		end
		
		return false
	end
})
dialogueHandler.registerAnswer({
	id = "inquire_about_reviewer",
	question = "ask_ceo_about_reviewers_continue",
	getText = function(self, dialogueObject, answerKey)
		return dialogueObject:getFact("reviewer_list")[answerKey]:getName()
	end,
	onPick = function(self, dialogueObject, previousQuestion, answerKey)
		dialogueObject:setFact("picked_reviewer_index", answerKey)
	end,
	getReturnText = function(self, dialogueObject)
		local reviewerObject = dialogueObject:getFact("reviewer_list")[dialogueObject:getFact("picked_reviewer_index")]
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		events:fire(rivalGameCompany.EVENTS.ASKED_ABOUT_BRIBE)
		
		if rgc:knowsReviewerBribeChances(reviewerObject:getID()) then
			reviewerObject:setBribeChancesRevealed(true)
			
			return reviewerObject:getData():getInquireText()
		end
		
		return _T("REVIEWER_CHANCES_UNKNOWN_RIVAL", "Sorry, I haven't got any experience with them.")
	end
})
dialogueHandler.registerAnswer({
	id = "ask_ceo_about_reviewers_return",
	question = "call_ceo_main",
	text = _T("ASK_CEO_ABOUT_REVIEWERS_RETURN", "[RETURN]"),
	returnText = _T("ASK_CEO_ABOUT_REVIEWERS_RETURN_DIALOGUE", "Was there something else you needed?")
})
