dialogueHandler.registerQuestion({
	id = "activity_organization_1",
	text = _T("ACTIVITY_ORGANIZATION_1", "Hey boss, have you got a minute?"),
	answers = {
		"activity_organization_continue",
		"activity_organization_end_early"
	}
})
dialogueHandler.registerQuestion({
	id = "activity_organization_2",
	text = _T("ACTIVITY_ORGANIZATION_2", "I've asked folks around the office and we thought it would be cool if we went to ACTIVITY_ACTION. What do you think?"),
	getText = function(self, dialogueObject)
		local activityData = dialogueObject:getFact(activities.AUTO_ORGANIZE_DIALOGUE_FACT)
		
		return _format(self.text, "ACTIVITY_ACTION", activityData.activityDisplay)
	end,
	answersRegular = {
		"activity_organization_approve",
		"activity_organization_decline"
	},
	answersNoCash = {
		"activity_organization_decline_no_cash"
	},
	getAnswers = function(self, dialogueObject)
		local activityData = dialogueObject:getFact(activities.AUTO_ORGANIZE_DIALOGUE_FACT)
		
		if studio:getFunds() >= activityData:getPrice(dialogueObject:getFact(activities.AUTO_ORGANIZE_EMPLOYEE_COUNT_FACT)) then
			return self.answersRegular
		end
		
		return self.answersNoCash
	end
})
dialogueHandler.registerQuestion({
	id = "activity_organization_3_1",
	text = {
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_1", "Alright, awesome!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_2", "Alright, thanks!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_3", "Great, thanks!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_4", "Cool, thanks!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_5", "Thanks, boss!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_6", "Awesome, thank you very much!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_7", "Thanks a lot!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_8", "Fantastic, thank you!"),
		_T("ACTIVITY_ORGANIZATION_3_APPROVE_9", "Thanks!")
	},
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerQuestion({
	id = "activity_organization_3_2",
	text = _T("ACTIVITY_ORGANIZATION_3_REFUSE", "Alright, no problem, boss."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerAnswer({
	id = "activity_organization_continue",
	question = "activity_organization_2",
	text = _T("ACTIVITY_ORGANIZATION_CONTINUE", "What's up?")
})
dialogueHandler.registerAnswer({
	id = "activity_organization_approve",
	question = "activity_organization_3_1",
	text = _T("ACTIVITY_ORGANIZATION_APPROVE", "Sure, I'll make it on the house. [PAY $AMOUNT]"),
	getText = function(self, dialogueObject)
		return _format(self.text, "AMOUNT", dialogueObject:getFact(activities.AUTO_ORGANIZE_DIALOGUE_FACT):getPrice(dialogueObject:getFact(activities.AUTO_ORGANIZE_EMPLOYEE_COUNT_FACT)))
	end,
	onPick = function(self, dialogueObject)
		local activityData = dialogueObject:getFact(activities.AUTO_ORGANIZE_DIALOGUE_FACT)
		
		studio:scheduleActivity(activityData.id, nil)
	end
})
dialogueHandler.registerAnswer({
	id = "activity_organization_decline",
	question = "activity_organization_3_2",
	text = _T("ACTIVITY_ORGANIZATION_DECLINE", "Thanks for the offer, but I'll pass.")
})
dialogueHandler.registerAnswer({
	id = "activity_organization_decline_no_cash",
	question = "activity_organization_3_2",
	text = _T("ACTIVITY_ORGANIZATION_DECLINE_NO_CASH", "Thanks for the offer, but I'll pass. [CAN'T AFFORD]")
})
dialogueHandler.registerAnswer({
	id = "activity_organization_end_early",
	endDialogue = true,
	text = _T("ACTIVITY_ORGANIZATION_END_EARLY", "Sorry, I'm busy right now.")
})
