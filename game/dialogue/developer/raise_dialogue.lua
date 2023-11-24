dialogueHandler.registerQuestion({
	id = "developer_raise_question_1",
	text = _T("DEVELOPER_RAISE_QUESTION_1", "Hey boss, have you got a minute to spare? I'd like to talk about my salary."),
	answers = {
		"developer_raise_answer_proceed",
		"developer_raise_deny_raise_1"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_raise_question_2",
	text = _T("DEVELOPER_RAISE_QUESTION_2", "I've worked hard the past several months, have greatly improved my skills, and would like to ask for a raise in pay to $DESIRED_SALARY up from my $CURRENT_SALARY."),
	answers = {
		"developer_raise_approve_raise",
		"developer_raise_deny_raise_2"
	},
	answersNoPreference = {
		"developer_raise_approve_raise",
		"developer_raise_approve_raise_always",
		"developer_raise_deny_raise_2"
	},
	getAnswers = function(self, dialogueObject)
		if preferences:get(developer.ALWAYS_APPROVE_RAISES_PREFERENCE) then
			return self.answers
		end
		
		return self.answersNoPreference
	end,
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		return string.easyformatbykeys(self.text, "DESIRED_SALARY", string.comma(employee:getNewSalary()), "CURRENT_SALARY", string.comma(employee:getSalary()))
	end,
	onStart = function(self, dialogueObject, answerID)
		dialogueHandler:createSkillChangeDisplay(dialogueObject)
	end
})
dialogueHandler.registerQuestion({
	id = "developer_raise_end_question",
	text = _T("DEVELOPER_RAISE_DENIED_1", "Alright, I'll talk to you later."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_raise_denied",
	text = _T("DEVELOPER_RAISE_DENIED_2", "Alright, boss."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_raise_approved",
	text = _T("DEVELOPER_RAISE_APPROVED_1", "Thanks, and thank you for your time, boss."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerAnswer({
	id = "developer_raise_answer_proceed",
	question = "developer_raise_question_2",
	text = _T("DEVELOPER_RAISE_ANSWER_1", "Sure, let's talk.")
})
dialogueHandler.registerAnswer({
	question = "developer_raise_end_question",
	id = "developer_raise_deny_raise_1",
	text = _T("DEVELOPER_RAISE_ANSWER_2", "Sorry, I'm busy now, let's do this later. [DENY RAISE]"),
	onPick = function(self, dialogueObject)
		dialogueObject:getEmployee():denyRaise()
	end
})
dialogueHandler.registerAnswer({
	question = "developer_raise_approved",
	id = "developer_raise_approve_raise",
	requiresConfirmation = true,
	text = _T("DEVELOPER_APPROVE_RAISE", "No problem. [APPROVE RAISE]"),
	onPick = function(self, dialogueObject)
		dialogueObject:getEmployee():approveRaise()
		dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
	end
})
dialogueHandler.registerAnswer({
	question = "developer_raise_approved",
	id = "developer_raise_approve_raise_always",
	requiresConfirmation = true,
	text = _T("DEVELOPER_APPROVE_RAISE_ALWAYS", "No problem. [APPROVE RAISES ALWAYS]"),
	onPick = function(self, dialogueObject)
		dialogueObject:getEmployee():approveRaise()
		dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
		preferences:set(developer.ALWAYS_APPROVE_RAISES_PREFERENCE, true)
	end
})
dialogueHandler.registerAnswer({
	question = "developer_raise_denied",
	id = "developer_raise_deny_raise_2",
	requiresConfirmation = true,
	text = _T("DEVELOPER_DENY_RAISE", "Sorry, not now. [DENY RAISE]"),
	onPick = function(self, dialogueObject)
		dialogueObject:getEmployee():denyRaise()
		dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
	end
})
dialogueHandler.registerQuestion({
	id = "developer_raise_offer",
	text = _T("DEVELOPER_RAISE_OFFER_QUESTION", "I'm listening."),
	answers = {
		"developer_raise_offer_proceed",
		"developer_raise_offer_nevermind"
	},
	onStart = function(self, dialogueObject, answerID)
		dialogueHandler:createSkillChangeDisplay(dialogueObject)
	end
})
dialogueHandler.registerAnswer({
	id = "developer_raise_offer",
	question = "developer_raise_offer",
	text = _T("DEVELOPER_RAISE_OFFER_ANSWER", "Let's talk about your salary.")
})
dialogueHandler.registerAnswer({
	question = "talk_to_employee",
	id = "developer_raise_offer_proceed",
	text = _T("DEVELOPER_RAISE_OFFER_PROCEED", "I'm raising your salary to $NEW_SALARY up from your current $OLD_SALARY."),
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		return string.easyformatbykeys(self.text, "NEW_SALARY", string.comma(employee:getNewSalary()), "OLD_SALARY", string.comma(employee:getSalary()))
	end,
	onPick = function(self, dialogueObject)
		dialogueObject:getEmployee():approveRaise()
		dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
	end,
	returnText = _T("DEVELOPER_RAISE_OFFER_FINISH", "Awesome, thank you boss!")
})
dialogueHandler.registerAnswer({
	question = "talk_to_employee",
	id = "developer_raise_offer_nevermind",
	text = _T("DEVELOPER_RAISE_OFFER_NEVERMIND_ANSWER", "Nevermind."),
	returnText = _T("DEVELOPER_RAISE_OFFER_NEVERMIND_RETURN", "Alright, anything else?"),
	onPick = function(self, dialogueObject)
		dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
	end
})
