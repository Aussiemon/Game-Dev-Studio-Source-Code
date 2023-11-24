dialogueHandler.registerQuestion({
	id = "call_ceo_rnp_initial",
	text = _T("INITIAL_CEO_RNP_INITIAL", "Hello?"),
	answers = {
		"call_ceo_rnp_initial_answer"
	}
})
dialogueHandler.registerQuestion({
	id = "call_ceo_rnp_initial_2",
	text = _T("CALL_CEO_RNP_INITIAL_2", "Ah, it's you! I've heard you recently started your own company. It's a shame what happened recently, but I'm sure you understand that it's just business. It had nothing to do with you as a game designer, the investors were just worried that your future projects would be a financial liability."),
	answers = {
		"call_ceo_rnp_initial_answer_2"
	}
})
dialogueHandler.registerQuestion({
	id = "call_ceo_rnp_initial_3",
	text = _T("CALL_CEO_RNP_INITIAL_3", "I know, but you have to understand - the game sold badly. As far as I'm concerned, and as far as the people investing into this company are involved, you're at fault here. I can't do anything about that. Remember, it's business in the end, so we had to cut our losses."),
	answers = {
		"call_ceo_rnp_initial_answer_3_a",
		"call_ceo_rnp_initial_answer_3_b"
	}
})
dialogueHandler.registerQuestion({
	id = "call_ceo_rnp_initial_4_a",
	text = _T("CALL_CEO_RNP_INITIAL_4_A", "Right, I think you're still a bit heated regarding the whole situation. Let's talk later, once you've cooled off."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "call_ceo_rnp_initial_4_b",
	text = _T("CALL_CEO_RNP_INITIAL_4_B", "You're not listening to what I'm saying. I told you - it's business in the end. Look, I don't have time for this, let's talk again when you're not in a bad mood."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "call_ceo_rnp_main",
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
	question = "call_ceo_rnp_initial_2",
	id = "call_ceo_rnp_initial_answer",
	getText = function(self, dialogueObject)
		return _format(_T("INITIAL_CEO_CALL_INTRODUCE_PLAYER", "Hello, this is the CEO of 'COMPANY' calling."), "COMPANY", studio:getName())
	end,
	onPick = function(self, dialogueObject)
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		dialogueObject:setFact("had_been_introduced", rgc:wasPlayerIntroduced())
		rgc:markPlayerIntroduced()
	end
})
dialogueHandler.registerAnswer({
	id = "call_ceo_rnp_initial_answer_2",
	question = "call_ceo_rnp_initial_3",
	text = _T("CALL_CEO_RNP_INITIAL_ANSWER_2", "Liability? People loved the game, yet there was so little marketing noone knew it existed!")
})
dialogueHandler.registerAnswer({
	id = "call_ceo_rnp_initial_answer_3_a",
	question = "call_ceo_rnp_initial_4_a",
	text = _T("CALL_CEO_RNP_INITIAL_ANSWER_3_A", "This has nothing to do with the game. If it sold badly, then you've only yourself to blame for not marketing it well enough.")
})
dialogueHandler.registerAnswer({
	id = "call_ceo_rnp_initial_answer_3_b",
	question = "call_ceo_rnp_initial_4_b",
	text = _T("CALL_CEO_RNP_INITIAL_ANSWER_3_B", "Then why cut me loose? We both know I designed a good game, so why fire me?")
})
dialogueHandler.registerQuestion({
	id = "rival_company_threaten_rnp_1",
	text = _T("RIVAL_COMPANY_THREATEN_RNP_1", "You know, I was really hoping it wouldn't come to this..."),
	answers = {
		"rival_company_threat_rnp_response_continue_1"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "rival_company_threaten_rnp_3",
	id = "rival_company_threaten_rnp_2",
	revealPortrait = true,
	text = _T("RIVAL_COMPANY_THREATEN_RNP_2", "I know things weren't going that good between us, and in the back of my head, I suspected that it might come to this, but now you've done it. Luring employees away with higher salaries or outright slander by proxy - it's all the same to me."),
	onStart = rivalGameCompany.onRevealIntentionsInDialogue,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "rival_company_threaten_rnp_3",
	revealPortrait = true,
	text = _T("RIVAL_COMPANY_THREATEN_RNP_3", "With that said, I'm not going to just watch as you try to destroy this company, and the fact that we used to be colleagues does not matter to me. I will uphold the interests of people that have invested into this company. So I hope you have a good offensive or backup plan, because you sure as hell are going to need it."),
	answers = {
		"rival_company_threat_rnp_response_1",
		"rival_company_threat_rnp_response_2",
		"rival_company_threat_respose_hang_up"
	}
})
dialogueHandler.registerQuestion({
	id = "rival_company_threat_rnp_response_reply_1",
	revealPortrait = true,
	text = _T("RIVAL_COMPANY_THREAT_RNP_RESPONSE_REPLY_1", "Oh, sure, at least until your reputation crumbles or you fail to release a game on time and your financial situation goes down the drain. Then you'll see who they're better off working for."),
	answers = {
		"generic_hang_up"
	}
})
dialogueHandler.registerAnswer({
	id = "rival_company_threat_rnp_response_continue_1",
	question = "rival_company_threaten_rnp_2",
	text = _T("RIVAL_COMPANY_THREAT_RNP_RESPONSE_CONTINUE_1", "What do you want?")
})
dialogueHandler.registerAnswer({
	id = "rival_company_threat_rnp_response_1",
	question = "rival_company_threat_rnp_response_reply_1",
	text = _T("RIVAL_COMPANY_THREAT_RNP_RESPONSE_1", "Your employees are better off working for me.")
})

local function insultAndHangUp(self, dialogueObject)
	dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):insultAndHangUp()
end

dialogueHandler.registerAnswer({
	id = "rival_company_threat_rnp_response_2",
	text = _T("RIVAL_COMPANY_THREAT_RNP_RESPONSE_2", "Hey, don't get all worked up about this - it's just business. [HANG UP]"),
	onPick = insultAndHangUp
})
