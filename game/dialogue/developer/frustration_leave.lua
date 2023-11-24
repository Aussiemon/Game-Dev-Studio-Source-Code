dialogueHandler.registerQuestion({
	id = "frustration_leave_1",
	text = _T("FRUSTRATION_LEAVE_1", "Hey boss, I'm leaving the studio."),
	answers = {
		"frustration_leave_continue",
		"frustration_leave_end_early"
	},
	onStartSpooling = function(self, dialogueObject)
		dialogueHandler:createSkillChangeDisplay(dialogueObject, true)
	end
})
dialogueHandler.registerQuestion({
	id = "frustration_leave_2",
	answers = {
		"frustration_leave_continue_2",
		"frustration_leave_end_early"
	},
	getText = function(self, dialogueObject)
		return studio.driveAffectors.registeredByID[dialogueObject:getFact("frustrator")].frustrationLeaveText
	end
})
dialogueHandler.registerQuestion({
	id = "frustration_leave_3",
	answers = {
		"frustration_leave_finish"
	},
	text = _T("FRUSTRATION_LEAVE_3", "No, this has gone on for too long. I wouldn't be saying this if I hadn't made up my mind already.")
})

function genericLeaveAnswer(self, dialogueObject, previousQuestionID, answerKey)
	dialogueObject:getEmployee():leaveStudio()
	dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
end

dialogueHandler.registerAnswer({
	id = "frustration_leave_continue",
	question = "frustration_leave_2",
	text = _T("FRUSTRATION_LEAVE_CONTINUE", "Is something wrong?")
})
dialogueHandler.registerAnswer({
	endDialogue = true,
	id = "frustration_leave_end_early",
	text = _T("FRUSTRATION_LEAVE_END_EARLY", "That's a shame, but alright."),
	onPick = genericLeaveAnswer
})
dialogueHandler.registerAnswer({
	id = "frustration_leave_continue_2",
	question = "frustration_leave_3",
	text = _T("FRUSTRATION_LEAVE_CONTINUE_2", "Is there anything I can do to make you reconsider?")
})
dialogueHandler.registerAnswer({
	endDialogue = true,
	id = "frustration_leave_finish",
	text = _T("FRUSTRATION_LEAVE_FINISH", "It's a shame you're leaving."),
	onPick = genericLeaveAnswer
})
