dialogueHandler.registerQuestion({
	id = "rival_company_threaten_1",
	text = _T("RIVAL_COMPANY_THREATEN_1", "Hello friendo."),
	regularAnswers = {
		"rival_company_threat_response_continue_1",
		"rival_company_threat_respose_hang_up"
	},
	ftueAnswers = {
		"rival_company_threat_response_continue_1"
	},
	getAnswers = function(self, dialogueObject)
		return interactionRestrictor:canPerformAction(rivalGameCompanies.FULL_RIVAL_DIALOGUES) and self.regularAnswers or self.ftueAnswers
	end
})
dialogueHandler.registerQuestion({
	id = "rival_company_threaten_2",
	revealPortrait = true,
	text = _T("RIVAL_COMPANY_THREATEN_2", "I'm the CEO of COMPANY, and I wouldn't be making this call if you had kept your fingers to yourself. But you just had to try and mess with me and my staff, didn't you?"),
	onStart = rivalGameCompany.onRevealIntentionsInDialogue,
	getText = function(self, dialogueObject)
		return _format(self.text, "COMPANY", dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):getName())
	end,
	regularAnswers = {
		"rival_company_threat_response_continue_2_1",
		"rival_company_threat_response_continue_2_2",
		"rival_company_threat_respose_hang_up"
	},
	ftueAnswers = {
		"rival_company_threat_response_continue_2_1"
	},
	getAnswers = function(self, dialogueObject)
		return interactionRestrictor:canPerformAction(rivalGameCompanies.FULL_RIVAL_DIALOGUES) and self.regularAnswers or self.ftueAnswers
	end
})
dialogueHandler.registerQuestion({
	id = "rival_company_threaten_3",
	text = _T("RIVAL_COMPANY_THREATEN_3", "What do I want? Oh, nothing, but you better know that you've made yourself an enemy in this industry. I'll make you get a taste of your own medicine."),
	answers = {
		"rival_company_threat_response_continue_3_1",
		"rival_company_threat_response_continue_3_2",
		"rival_company_threat_respose_hang_up"
	}
})
dialogueHandler.registerQuestion({
	id = "rival_company_threaten_4",
	textStoleSpecificEmployee = _T("RIVAL_COMPANY_THREATEN_4_A", "Do something? Are you joking? You have the audacity to suggest something like that after persuading EMPLOYEE to switch to your studio? You either have a very bad sense of humor or have no respect for other people like yourself."),
	textStoleEmployees = _T("RIVAL_COMPANY_THREATEN_4_B", "Do something? Are you joking? You have the audacity to suggest something like that after stealing my employees? You either have a very bad sense of humor or have no respect for other people like yourself."),
	textStoleEmployee = _T("RIVAL_COMPANY_THREATEN_4_C", "Do something? Are you joking? You have the audacity to suggest something like that after stealing one of my employees? You either have a very bad sense of humor or have no respect for other people like yourself."),
	textTriedStealingEmployees = _T("RIVAL_COMPANY_THREATEN_4_D", "Ha-ha, very funny. First you try to persuade my employees into switching over to your studio and now you want to make up for it? You're out of your mind."),
	textMentionSlander = _T("RIVAL_COMPANY_THREATEN_4_SLANDER", "Not only that, but you had the nerve to start slanderous campaigns against me. No way in hell am I going to do anything for you."),
	textMentionSlanderOnly = _T("RIVAL_COMPANY_THREATEN_5_SLANDER", "Are you nuts or just have no self-awareness? You ran slanderous campaigns against my company and now wish to make up for it?! You know, if we were one on one right now, I'd give you a really tasty knuckle sandwich for having the nerve to even suggest something like that."),
	getText = function(self, dialogueObject)
		local company = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		local employee = company:getMostRecentStolenEmployee()
		local knowsOfSlander = company:hasFoundOutPlayerSlander()
		local finalText
		local complainAboutEmployees = false
		local triedStealingEmployees = company:getPlayerStolenEmployees() > 0 or company:getPlayerFailedStolenEmployees() > 0
		
		if employee then
			finalText = _format(self.textStoleSpecificEmployee, "EMPLOYEE", employee:getFullName(true))
			complainAboutEmployees = true
		else
			local stolenEmployees = company:getPlayerStolenEmployees()
			
			if stolenEmployees == 1 then
				finalText = self.textStoleEmployee
				complainAboutEmployees = true
			elseif stolenEmployees > 1 then
				finalText = self.textStoleEmployees
				complainAboutEmployees = true
			end
		end
		
		if triedStealingEmployees then
			finalText = finalText or self.textTriedStealingEmployees
			
			if knowsOfSlander then
				finalText = finalText .. " " .. self.textMentionSlander
			end
		else
			finalText = self.textMentionSlanderOnly
		end
		
		return finalText
	end,
	answers = {
		"generic_hang_up"
	}
})
dialogueHandler.registerAnswer({
	question = "rival_company_threaten_2",
	id = "rival_company_threat_response_continue_1",
	text = _T("RIVAL_COMPANY_THREAT_RESPONSE_CONTINUE_1", "Hello, is there something you need?"),
	textUnknown = _T("RIVAL_COMPANY_THREAT_RESPONSE_CONTINUE_1_UNKNOWN", "Who's this?"),
	getText = function(self, dialogueObject)
		local company = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		if company:wasPlayerIntroduced() then
			return self.text
		end
		
		return self.textUnknown
	end
})
dialogueHandler.registerAnswer({
	id = "rival_company_threat_response_continue_2_1",
	question = "rival_company_threaten_3",
	text = _T("RIVAL_COMPANY_THREAT_RESPONSE_CONTINUE_2_1", "Get to the point, what do you want?")
})

local function insultAndHangUp(self, dialogueObject)
	dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):insultAndHangUp()
end

dialogueHandler.registerAnswer({
	id = "rival_company_threat_response_continue_2_2",
	text = _T("RIVAL_COMPANY_THREAT_RESPONSE_CONTINUE_2_2", "I don't have time for this. [HANG UP]"),
	onPick = insultAndHangUp
})
dialogueHandler.registerAnswer({
	id = "rival_company_threat_response_continue_3_1",
	question = "rival_company_threaten_4",
	text = _T("RIVAL_COMPANY_THREAT_RESPONSE_CONTINUE_3_1", "Surely there must be something we can do about this.")
})
dialogueHandler.registerAnswer({
	id = "rival_company_threat_respose_hang_up",
	text = _T("RIVAL_COMPANY_THREAT_RESPOSE_HANG_UP", "[HANG UP]"),
	onPick = function(self, dialogueObject)
		dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):hangUp()
	end
})
dialogueHandler.registerAnswer({
	id = "rival_company_threat_response_continue_3_2",
	text = _T("RIVAL_COMPANY_THREAT_RESPONSE_CONTINUE_3_2", "What are you going to do, hire me? [HANG UP]"),
	onPick = insultAndHangUp
})
dialogueHandler.registerQuestion({
	nextQuestion = "rival_company_legal_action_2",
	id = "rival_company_legal_action_1",
	text = _T("RIVAL_COMPANY_LEGAL_ACTION_1", "You know, I was really hoping it wouldn't have to come to this, but you leave me no choice."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "rival_company_legal_action_2",
	text = _T("RIVAL_COMPANY_LEGAL_ACTION_2", "I'm not going to mince words. You got me really mad, you know? I hope you have a good lawyer, I'll see you in court over all this defamation business in a week."),
	answers = {
		"generic_continue"
	},
	answersPlayerRetaliate = {
		"rival_company_legal_action_retaliate",
		"generic_hang_up"
	},
	getAnswers = function(self, dialogueObject)
		if studio:knowsOfRivalSlander(dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):getID()) then
			return self.answersPlayerRetaliate
		end
		
		return self.answers
	end
})
dialogueHandler.registerQuestion({
	id = "rival_company_legal_action_3",
	textReconsdering = _T("RIVAL_COMPANY_LEGAL_ACTION_3_A", "You have a point there. Tell you what, we're both hurting from this whole ordeal in terms of finance and reputation, how about we both forget about all this and don't go to court? No more slander, no more trying to steal each others employees. What do you say?"),
	textTaunt = _T("RIVAL_COMPANY_LEGAL_ACTION_3_B", "Well good luck with that, I believe I have a much better case than you do, so I won't change my mind on this."),
	answersReconsidering = {
		"rival_company_legal_action_reconsider_agree",
		"rival_company_legal_action_reconsider_disagree"
	},
	answersTaunt = {
		"generic_hang_up"
	},
	getText = function(self, dialogueObject)
		local state = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):getReconsiderLegalActionState()
		
		if state == rivalGameCompany.RECONSIDERATION_STATE.RECONSIDER then
			return self.textReconsdering
		end
		
		return self.textTaunt
	end,
	getAnswers = function(self, dialogueObject)
		local state = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):getReconsiderLegalActionState()
		
		if state == rivalGameCompany.RECONSIDERATION_STATE.RECONSIDER then
			return self.answersReconsidering
		end
		
		return self.answersTaunt
	end
})
dialogueHandler.registerQuestion({
	id = "rival_company_legal_action_4_a",
	text = _T("RIVAL_COMPANY_LEGAL_ACTION_4_A", "Great. I'm hoping this is the last time we have any kind of bad blood between us."),
	answers = {
		"generic_hang_up"
	},
	onStart = function(self, dialogueObject)
		local rival = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		rival:resetRivalry()
	end
})
dialogueHandler.registerQuestion({
	id = "rival_company_legal_action_4_b",
	text = _T("RIVAL_COMPANY_LEGAL_ACTION_4_B", "As you wish."),
	answers = {
		"generic_hang_up"
	}
})
dialogueHandler.registerAnswer({
	id = "rival_company_legal_action_retaliate",
	question = "rival_company_legal_action_3",
	text = _T("RIVAL_COMPANY_LEGAL_ACTION_RETALIATE", "Two can play that game, I'll bring over my evidence of your defamation attempts.")
})
dialogueHandler.registerAnswer({
	id = "rival_company_legal_action_reconsider_agree",
	question = "rival_company_legal_action_4_a",
	text = _T("RIVAL_COMPANY_LEGAL_ACTION_RECONSIDER_AGREE", "It's a deal.")
})
dialogueHandler.registerAnswer({
	id = "rival_company_legal_action_reconsider_disagree",
	question = "rival_company_legal_action_4_b",
	text = _T("RIVAL_COMPANY_LEGAL_ACTION_RECONSIDER_DISAGREE", "No deal.")
})
dialogueHandler.registerQuestion({
	id = "player_legal_action_1",
	text = _T("PLAYER_LEGAL_ACTION_1", "Yes, hello?"),
	answers = {
		"player_legal_action_1_generic"
	}
})
dialogueHandler.registerQuestion({
	id = "player_legal_action_2",
	textReconsdering = _T("PLAYER_LEGAL_ACTION_2_A", "Now wait a second, are you sure you want to go through all the paperwork for that? I have a suggestion - let's forget about this whole ordeal and start anew, yeah? No more defamation, no more attempts to lure each others' employees away, just pretend none of this ever happened."),
	textTaunt = _T("PLAYER_LEGAL_ACTION_2_B", "Really? Considering how much you've hurt my reputation I was thinking of doing the same, and now that you're announcing these news I think I'll go ahead and reciprocate. See you in court."),
	answersReconsidering = {
		"rival_company_legal_action_reconsider_agree",
		"rival_company_legal_action_reconsider_disagree"
	},
	answersFtue = {
		"rival_company_legal_action_reconsider_disagree"
	},
	answersTaunt = {
		"generic_hang_up"
	},
	getText = function(self, dialogueObject)
		local state = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):getReconsiderLegalActionState()
		
		if state == rivalGameCompany.RECONSIDERATION_STATE.RECONSIDER then
			return self.textReconsdering
		end
		
		return self.textTaunt
	end,
	getAnswers = function(self, dialogueObject)
		local state = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):getReconsiderLegalActionState()
		
		if state == rivalGameCompany.RECONSIDERATION_STATE.RECONSIDER then
			if interactionRestrictor:canPerformAction("reconsider_court_case") then
				return self.answersReconsidering
			else
				return self.answersFtue
			end
		end
		
		return self.answersTaunt
	end
})
dialogueHandler.registerAnswer({
	question = "player_legal_action_2",
	id = "player_legal_action_1_generic",
	text = _T("PLAYER_LEGAL_ACTION_1_GENERIC", "I'm suing you due to defamation. Get your lawyer ready."),
	onPick = function(self, dialogueObject)
		local rgc = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		rgc:scheduleLegalPlayerAction(true)
	end
})
