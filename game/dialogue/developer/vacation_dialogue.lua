dialogueHandler.registerQuestion({
	id = "developer_vacation_offer",
	text = _T("DEVELOPER_VACATION_OFFER", "Yeah, and I still do. Any chance I could get that vacation? I'd like to have a 2 week vacation, and I'll go on vacation in 2 weeks."),
	answers = {
		"developer_vacation_offer_confirm",
		"developer_vacation_offer_nevermind"
	}
})
dialogueHandler.registerAnswer({
	id = "developer_vacation_offer",
	question = "developer_vacation_offer",
	text = _T("DEVELOPER_VACATION_OFFER_QUESTION", "I remember you wanted to go on vacation?")
})
dialogueHandler.registerAnswer({
	question = "talk_to_employee",
	id = "developer_vacation_offer_confirm",
	text = _T("DEVELOPER_VACATION_OFFER_CONFIRM", "In 2 weeks, sure. [APPROVE VACATION]"),
	returnText = _T("DEVELOPER_VACATION_OFFER_CONFIRM_RETURN", "Awesome, thanks boss!"),
	onPick = function(self, dialogueObject)
		dialogueObject:getEmployee():approveVacation()
	end
})
dialogueHandler.registerAnswer({
	id = "developer_vacation_offer_nevermind",
	question = "talk_to_employee",
	text = _T("DEVELOPER_VACATION_OFFER_NEVERMIND", "Nevermind."),
	returnText = _T("DEVELOPER_VACATION_OFFER_NEVERMIND_RETURN", "Was there something else you wanted?")
})
