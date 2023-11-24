dialogueHandler.registerQuestion({
	id = "fan_wants_to_work_start",
	text = {
		_T("FAN_WANTS_TO_WORK_START_1", "Hey boss, a fan just came by and said he wants to work for us."),
		_T("FAN_WANTS_TO_WORK_START_2", "Boss, one of our fans just came to our office and has offered his services."),
		_T("FAN_WANTS_TO_WORK_START_3", "Hey, a fan just came by and offered to work for us.")
	},
	answers = {
		"fan_wants_to_work_proceed",
		"fan_wants_to_work_end"
	}
})
dialogueHandler.registerQuestion({
	id = "fan_wants_to_work_decision",
	text = {
		_T("FAN_WANTS_TO_WORK_DECISION_1", "Their name is NAME, they are ROLE, and they're asking for $SALARY per month. You can see their work experience on this CV.")
	},
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getFact("fan")
		
		return string.easyformatbykeys(self.text[math.random(1, #self.text)], "NAME", employee:getFullName(true), "ROLE", attributes.profiler:getIndividualDisplay(employee:getRole()), "SALARY", string.comma(employee:getSalary()))
	end,
	answers = {
		"fan_wants_to_work_more_info",
		"fan_wants_to_work_accept",
		"fan_wants_to_work_decline"
	}
})
dialogueHandler.registerQuestion({
	id = "fan_wants_to_work_decline_last_chance",
	text = {
		_T("FAN_WANTS_TO_WORK_DECLINE_LAST_CHANCE", "Are you sure? This might be the only time we see or hear of him.")
	},
	answers = {
		"fan_wants_to_work_accept",
		"fan_wants_to_work_decline_final"
	}
})
dialogueHandler.registerQuestion({
	id = "fan_wants_to_work_end_last_chance",
	text = {
		_T("FAN_WANTS_TO_WORK_DECLINE_LAST_CHANCE", "Are you sure? This might be the only time we see or hear of him.")
	},
	answers = {
		"fan_wants_to_work_reconsider",
		"fan_wants_to_work_decline_final"
	}
})
dialogueHandler.registerAnswer({
	id = "fan_wants_to_work_proceed",
	question = "fan_wants_to_work_decision",
	text = _T("FAN_WANTS_TO_WORK_PROCEED", "Really? Tell me more.")
})
dialogueHandler.registerAnswer({
	id = "fan_wants_to_work_reconsider",
	question = "fan_wants_to_work_decision",
	text = _T("FAN_WANTS_TO_WORK_RECONSIDER", "Alright, tell me about this person.")
})
dialogueHandler.registerAnswer({
	id = "fan_wants_to_work_accept",
	text = _T("FAN_WANTS_TO_WORK_ACCEPT", "Alright, let's hire him. [ACCEPT]"),
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getFact("fan")
		
		studio:hireEmployee(employee)
	end
})
dialogueHandler.registerAnswer({
	question = "fan_wants_to_work_decision",
	id = "fan_wants_to_work_more_info",
	text = _T("FAN_WANTS_TO_WORK_MORE_INFO", "[OPEN EMPLOYEE INFO MENU]"),
	returnText = _T("FAN_WANTS_TO_WORK_MORE_INFO_RETURN", "So, what do you think?"),
	onPick = function(self, dialogueObject)
		dialogueHandler:hide()
		
		local employee = dialogueObject:getFact("fan")
		
		employee:createEmployeeMenu("FanOfferFrame")
	end
})
dialogueHandler.registerAnswer({
	id = "fan_wants_to_work_end",
	question = "fan_wants_to_work_end_last_chance",
	text = _T("FAN_WANTS_TO_WORK_END", "Sorry, I don't have time for this at the moment. [DECLINE]")
})
dialogueHandler.registerAnswer({
	id = "fan_wants_to_work_decline",
	question = "fan_wants_to_work_decline_last_chance",
	text = _T("FAN_WANTS_TO_WORK_DECLINE", "I don't think he'd be a valuable asset. [DECLINE]")
})
dialogueHandler.registerAnswer({
	id = "fan_wants_to_work_decline_final",
	text = _T("FAN_WANTS_TO_WORK_DECLINE_FINAL", "I'm sure. [DECLINE]")
})
