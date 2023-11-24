dialogueHandler.registerQuestion({
	id = "talk_to_employee",
	text = _T("TALK_TO_EMPLOYEE_DIALOGUE", "What's up, boss?"),
	getAnswers = function(self, dialogueObject)
		local answers = {}
		
		dialogueObject:getEmployee():fillConversationOptions(self, answers)
		table.insert(answers, "finish_employee_conversation")
		
		return answers
	end
})
dialogueHandler.registerAnswer({
	id = "finish_employee_conversation",
	endDialogue = true,
	text = {
		_T("FINISH_EMPLOYEE_CONVERSATION_1", "That's all."),
		_T("FINISH_EMPLOYEE_CONVERSATION_2", "We'll talk later."),
		_T("FINISH_EMPLOYEE_CONVERSATION_3", "I should get back to work.")
	}
})
