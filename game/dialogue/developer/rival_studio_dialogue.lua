dialogueHandler.registerQuestion({
	id = "developer_rival_studio_steal_attempt",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_1", "Hey boss, I'm leaving the studio."),
	answers = {
		"developer_rival_studio_steal_attempt_proceed",
		"developer_rival_studio_steal_attempt_farewell"
	},
	onStartSpooling = function(self, dialogueObject)
		dialogueHandler:createSkillChangeDisplay(dialogueObject, true)
	end
})
dialogueHandler.registerQuestion({
	id = "developer_rival_studio_steal_attempt_proceed",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_PROCEED_QUESTION", "I've got a job offer from \"RIVAL\", which is a game development studio, and they're offering me a higher salary. (Current salary: $CURRENT, Rival salary: $NEW)"),
	answers = {
		"developer_rival_studio_steal_attempt_match",
		"developer_rival_studio_steal_attempt_farewell_2"
	},
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		return string.easyformatbykeys(self.text, "NEW", string.comma(employee:finalizeSalary(employee:getUnfinalizedSalary() + employee:getAttemptedStealBonus())), "CURRENT", string.comma(employee:getSalary()), "RIVAL", employee:getAttemptedStealStudio():getName())
	end,
	onStart = function(self, dialogueObject)
		dialogueObject:getEmployee():getAttemptedStealStudio():markAsHostile()
	end
})
dialogueHandler.registerQuestion({
	id = "developer_rival_studio_steal_attempt_suspense",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_SUSPENSE_QUESTION", "Give me a second to think this over..."),
	answers = {
		"developer_rival_studio_steal_attempt_suspense_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_rival_studio_post_match_offer",
	textAccepted = _T("DEVELOPER_RIVAL_STUDIO_POST_MATCH_OFFER_ACCEPTED", "Alright, I'm staying."),
	textDeclined = _T("DEVELOPER_RIVAL_STUDIO_POST_MATCH_OFFER_DECLINED", "Sorry boss, it's not just about the money, I've wanted to try something new for a long time now, so I'm staying by my decision."),
	answersAccepted = {
		"developer_rival_studio_steal_accepted_match"
	},
	answersDeclined = {
		"developer_rival_studio_steal_offer_bonus",
		"developer_rival_studio_steal_attempt_farewell_3"
	},
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getFact("agreed_to_match") then
			dialogueObject:getEmployee():setFact(rivalGameCompany.STEAL_DIALOGUE_FACT, false)
			
			return self.answersAccepted
		end
		
		dialogueObject:getEmployee():setFact(rivalGameCompany.STEAL_DIALOGUE_FACT, false)
		
		return self.answersDeclined
	end,
	getText = function(self, dialogueObject)
		if dialogueObject:getFact("agreed_to_match") then
			return self.textAccepted
		end
		
		return self.textDeclined
	end
})
dialogueHandler.registerQuestion({
	id = "developer_rival_studio_steal_attempt_final",
	textAccepted = _T("DEVELOPER_RIVAL_STUDIO_POST_BONUS_OFFER_ACCEPTED", "Alright, I'm staying."),
	textDeclined = _T("DEVELOPER_RIVAL_STUDIO_POST_BONUS_OFFER_DECLINED", "I'm sure. Like I said it's not just about the money."),
	answersAccepted = {
		"developer_rival_studio_steal_accepted_match"
	},
	answersDeclined = {
		"developer_rival_studio_steal_attempt_farewell_3"
	},
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getFact("agreed_to_match") then
			dialogueObject:getEmployee():setFact(rivalGameCompany.STEAL_DIALOGUE_FACT, false)
			
			return self.answersAccepted
		end
		
		dialogueObject:getEmployee():setFact(rivalGameCompany.STEAL_DIALOGUE_FACT, false)
		
		return self.answersDeclined
	end,
	getText = function(self, dialogueObject)
		if dialogueObject:getFact("agreed_to_match") then
			return self.textAccepted
		end
		
		return self.textDeclined
	end
})
dialogueHandler.registerAnswer({
	id = "developer_rival_studio_steal_attempt_proceed",
	question = "developer_rival_studio_steal_attempt_proceed",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_PROCEED", "Is something wrong?")
})
dialogueHandler.registerAnswer({
	question = "developer_rival_studio_steal_attempt_suspense",
	id = "developer_rival_studio_steal_attempt_match",
	requiresConfirmation = true,
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_MATCH", "I can match their offer. [RAISE SALARY BY $INCREASE]"),
	getText = function(self, dialogueObject)
		return _format(self.text, "INCREASE", string.comma(dialogueObject:getEmployee():getStealBonusDelta(0)))
	end,
	onPick = function(self, dialogueObject)
		local agreed = dialogueObject:getEmployee():getMatchAcceptChance(0) > math.random(1, 100)
		
		dialogueObject:setFact("agreed_to_match", agreed)
		
		if agreed then
			dialogueObject:getEmployee():failSteal(0)
		end
	end
})
dialogueHandler.registerAnswer({
	question = "developer_rival_studio_steal_attempt_final",
	id = "developer_rival_studio_steal_offer_bonus",
	requiresConfirmation = true,
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_OFFER_BONUS_ANSWER", "Are you sure? I can add more. [ADD $INCREASE]"),
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		local extra = employee:getStealBonusDelta(employee:getAttemptedStealBonus()) - employee:getStealBonusDelta(0)
		
		return _format(self.text, "INCREASE", string.comma(extra))
	end,
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		local extra = employee:getStealBonusDelta(employee:getAttemptedStealBonus()) - employee:getStealBonusDelta(0)
		local agreed = employee:getMatchAcceptChance(extra) > math.random(1, 100)
		
		dialogueObject:setFact("agreed_to_match", agreed)
		
		if agreed then
			dialogueObject:getEmployee():failSteal(extra)
		end
	end
})
dialogueHandler.registerAnswer({
	id = "developer_rival_studio_steal_attempt_suspense_continue",
	question = "developer_rival_studio_post_match_offer",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_SUSPENSE_ANSWER", "[...]")
})
dialogueHandler.registerAnswer({
	id = "developer_rival_studio_steal_accepted_match",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ACCEPTED_MATCH_ANSWER", "Great, I'm glad we can continue doing business together.")
})

local function genericLeaveOnPick(self, dialogueObject)
	local employee = dialogueObject:getEmployee()
	
	studio:fireEmployee(employee, studio.EMPLOYEE_LEAVE_REASONS.RIVAL_GAME_STUDIO)
	employee:succeedSteal()
end

dialogueHandler.registerAnswer({
	requiresConfirmation = true,
	id = "developer_rival_studio_steal_attempt_farewell",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_FAREWELL", "Well that's a shame, I'm sorry you have to go."),
	onPick = genericLeaveOnPick
})
dialogueHandler.registerAnswer({
	id = "developer_rival_studio_steal_attempt_farewell_2",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_FAREWELL_2", "I'm sad that this has happened, but I'm happy we had your talent with us for as long as we have."),
	onPick = genericLeaveOnPick
})
dialogueHandler.registerAnswer({
	id = "developer_rival_studio_steal_attempt_farewell_3",
	text = _T("DEVELOPER_RIVAL_STUDIO_STEAL_ATTEMPT_FAREWELL_3", "Alright, it's a shame you're not staying, but I wish you luck in your future endeavors."),
	onPick = genericLeaveOnPick
})
