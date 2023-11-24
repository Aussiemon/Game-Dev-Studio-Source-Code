dialogueHandler.registerQuestion({
	id = "rival_company_2_threaten_1",
	text = _T("RIVAL_COMPANY_2_THREATEN_1", "Hello, is this the CEO of 'PLAYER'?"),
	answers = {
		"rival_company_2_threat_response_continue_1",
		"rival_company_threat_respose_hang_up"
	},
	getText = function(self, dialogueObject)
		return _format(self.text, "PLAYER", studio:getName())
	end
})
dialogueHandler.registerQuestion({
	id = "rival_company_2_threaten_2",
	revealPortrait = true,
	textStoleEmployees = _T("RIVAL_COMPANY_2_THREATEN_2_EMPLOYEES", "I'm calling because you've recently convinced one of my employees to switch over to your studio. I understand that this is just business to you, but I don't want there to be any kind of conflicts between us. I'm willing to let this slide if you agree to not do this again. What do you say?"),
	textMentionSlander = _T("RIVAL_COMPANY_2_THREATEN_2_SLANDER", "I'm calling because you've recently ran a slanderous campaign against my studio. That was risky and stupid on your part. If making enemies was your plan - then you've succeeded at that."),
	getText = function(self, dialogueObject)
		local company = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		if company:getPlayerStolenEmployees() > 0 or company:getPlayerFailedStolenEmployees() > 0 then
			return self.textStoleEmployees
		end
		
		return self.textMentionSlander
	end,
	getAnswers = function(self, dialogueObject)
		local company = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		if company:getPlayerStolenEmployees() > 0 or company:getPlayerFailedStolenEmployees() > 0 then
			return self.answersRegular
		end
		
		return self.answersNoOptions
	end,
	answersRegular = {
		"rival_company_2_threat_agree",
		"rival_company_2_threat_disagree",
		"rival_company_2_threat_respose_hang_up"
	},
	answersNoOptions = {
		"generic_hang_up"
	}
})
dialogueHandler.registerQuestion({
	id = "rival_company_2_threaten_3_agreed",
	revealPortrait = true,
	onStart = function(self, dialogueObject)
		local company = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		company:setAnger(0)
		company:setIntimidation(0)
	end,
	text = _T("RIVAL_COMPANY_2_THREATEN_3_AGREED", "Great, I'm glad we managed to sort this out."),
	answers = {
		"generic_hang_up"
	}
})
dialogueHandler.registerQuestion({
	id = "rival_company_2_threaten_3_disagreed",
	revealPortrait = true,
	onStart = rivalGameCompany.onRevealIntentionsInDialogue,
	text = _T("RIVAL_COMPANY_2_THREATEN_3_DISAGREED", "Well, now you can't say I didn't come to you offering peace."),
	answers = {
		"generic_hang_up"
	}
})
dialogueHandler.registerAnswer({
	question = "rival_company_2_threaten_2",
	id = "rival_company_2_threat_response_continue_1",
	text = _T("RIVAL_COMPANY_2_THREAT_RESPONSE_CONTINUE_1", "Yes, can I help you with something?"),
	textUnknown = _T("RIVAL_COMPANY_2_THREAT_RESPONSE_CONTINUE_1_UNKNOWN", "Yes, that's me."),
	getText = function(self, dialogueObject)
		local company = dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT)
		
		if company:wasPlayerIntroduced() then
			return self.text
		end
		
		return self.textUnknown
	end
})
dialogueHandler.registerAnswer({
	id = "rival_company_2_threat_agree",
	question = "rival_company_2_threaten_3_agreed",
	text = _T("RIVAL_COMPANY_2_THREAT_AGREE", "Alright.")
})

local function insultAndHangUp(self, dialogueObject)
	dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):insultAndHangUp()
end

dialogueHandler.registerAnswer({
	id = "rival_company_2_threat_disagree",
	question = "rival_company_2_threaten_3_disagreed",
	text = _T("RIVAL_COMPANY_2_THREAT_DISAGREE", "No.")
})
dialogueHandler.registerAnswer({
	id = "rival_company_2_threat_respose_hang_up",
	text = _T("RIVAL_COMPANY_THREAT_RESPOSE_HANG_UP", "[HANG UP]"),
	onPick = function(self, dialogueObject)
		dialogueObject:getFact(rivalGameCompany.COMPANY_REFERENCE_DIALOGUE_FACT):hangUp()
		rivalGameCompany.onRevealIntentionsInDialogue(self, dialogueObject)
	end
})
