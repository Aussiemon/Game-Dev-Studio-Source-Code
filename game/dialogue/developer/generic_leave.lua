dialogueHandler.registerQuestion({
	id = "generic_leave_1",
	text = _T("GENERIC_LEAVE_1", "Hey boss, I'm leaving the studio."),
	answers = {
		"generic_leave_continue",
		"generic_leave_end_early"
	},
	onStartSpooling = function(self, dialogueObject)
		dialogueHandler:createSkillChangeDisplay(dialogueObject, true)
	end
})
dialogueHandler.registerQuestion({
	id = "generic_leave_2",
	answersConvinceToStay = {
		"generic_convince_to_stay",
		"generic_leave_end_early"
	},
	answersOfferRaise = {
		"generic_leave_offer_raise",
		"generic_leave_end_early"
	},
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		local raises = employee:getDeniedRaises()
		
		if raises > 1 then
			return _T("LEAVE_SEVERAL_DENIED_RAISES", "I've asked for a raise in my pay several times recently and was denied each time, so I'm going to go work elsewhere.")
		elseif raises == 1 then
			return _T("LEAVE_ONE_DENIED_RAISE", "Well, I had asked for a raise recently and you said no, so I'm not going to wait around for a change of heart.")
		end
		
		return _T("LEAVE_GENERIC_LEAVE_REASON", "I'm just tired of working on games and I want to try some new things, you know? It's nothing personal, I just think it's time I moved on to a new place with new challenges.")
	end,
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getEmployee():getDeniedRaises() > 0 then
			return self.answersOfferRaise
		end
		
		return self.answersConvinceToStay
	end
})
dialogueHandler.registerQuestion({
	id = "generic_leave_3",
	answers = {
		"generic_leave_finish"
	},
	text = _T("GENERIC_LEAVE_3", "No, this has gone on for too long. I wouldn't be saying this if I hadn't made up my mind already.")
})
dialogueHandler.registerQuestion({
	id = "generic_leave_raise_conclusion",
	textAccepted = _T("GENERIC_LEAVE_RAISE_ACCEPTED_RAISE", "Alright, you've convinced me."),
	textRefused = _T("GENERIC_LEAVE_RAISE_REFUSED_RAISE", "Sorry, no."),
	answersAccepted = {
		"generic_success_convince"
	},
	answersRefused = {
		"generic_leave_finish"
	},
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getFact("accepted_raise") then
			dialogueObject:getEmployee():approveRaise()
			
			return self.answersAccepted
		end
		
		return self.answersRefused
	end,
	getText = function(self, dialogueObject)
		if dialogueObject:getFact("accepted_raise") then
			return self.textAccepted
		end
		
		return self.textRefused
	end
})
dialogueHandler.registerQuestion({
	id = "generic_leave_convince_to_stay_conclusion",
	textAccepted = _T("GENERIC_LEAVE_CONVINCED_TO_STAY", "Alright, you've convinced me. I'll stick around for some more time, maybe I was too quick to come to a decision like this."),
	textRefused = _T("GENERIC_LEAVE_NOT_CONVINCED_TO_STAY", "Sorry, but I won't be staying."),
	answersAccepted = {
		"generic_success_convince"
	},
	answersRefused = {
		"generic_leave_finish"
	},
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getFact("staying") then
			return self.answersAccepted
		end
		
		return self.answersRefused
	end,
	getText = function(self, dialogueObject)
		if dialogueObject:getFact("staying") then
			return self.textAccepted
		end
		
		return self.textRefused
	end
})

function genericLeaveAnswer(self, dialogueObject, previousQuestionID, answerKey)
	dialogueObject:getEmployee():leaveStudio()
	dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
end

dialogueHandler.registerAnswer({
	id = "generic_leave_continue",
	question = "generic_leave_2",
	text = _T("GENERIC_LEAVE_CONTINUE", "Is something wrong?")
})
dialogueHandler.registerAnswer({
	endDialogue = true,
	id = "generic_leave_end_early",
	text = _T("GENERIC_LEAVE_END_EARLY", "That's a shame, but alright."),
	onPick = genericLeaveAnswer
})
dialogueHandler.registerAnswer({
	endDialogue = true,
	id = "generic_leave_finish",
	text = _T("GENERIC_LEAVE_FINISH", "It's a shame you're leaving."),
	onPick = genericLeaveAnswer
})
dialogueHandler.registerAnswer({
	id = "generic_success_convince",
	endDialogue = true,
	text = _T("GENERIC_SUCCESS_CONVINCE", "I'm glad you're staying with us.")
})
dialogueHandler.registerAnswer({
	question = "generic_leave_raise_conclusion",
	id = "generic_leave_offer_raise",
	text = _T("GENERIC_LEAVE_OFFER_RAISE", "I can approve that raise right away. [APPROVE RAISE]"),
	onPick = function(self, dialogueObject)
		if math.random(1, 100) <= dialogueObject:getEmployee():getStayConsiderationChance() then
			dialogueObject:setFact("accepted_raise", true)
		end
	end
})
dialogueHandler.registerAnswer({
	stayChancePerCharisma = 6,
	question = "generic_leave_convince_to_stay_conclusion",
	maxChance = 90,
	id = "generic_convince_to_stay",
	stayBaseChance = 20,
	text = _T("GENERIC_CONVINCE_TO_STAY", "Stick with me for just a bit more. [CONVINCE TO STAY]"),
	stayChancePerKnowledge = 20 / knowledge.MAXIMUM_KNOWLEDGE,
	onPick = function(self, dialogueObject)
		local playerChar = studio:getPlayerCharacter()
		local chance = 0
		
		if playerChar:hasTrait("silver_tongue") then
			chance = chance + self.stayBaseChance
		end
		
		chance = math.min(self.maxChance, chance + playerChar:getAttribute("charisma") * self.stayChancePerCharisma + playerChar:getKnowledge("public_speaking") * self.stayChancePerKnowledge)
		
		if chance >= math.random(1, 100) then
			dialogueObject:setFact("staying", true)
		end
	end
})
