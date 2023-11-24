dialogueHandler.registerQuestion({
	id = "fire_employee_confirm",
	text = _T("FIRE_EMPLOYEE_CONFIRMATION_TEXT", "[Are you sure you want to fire this employee?]"),
	answers = {
		"fire_employee_confirm",
		"fire_employee_cancel"
	},
	onStart = function(self, dialogueObject, answerID)
		dialogueHandler:createSkillChangeDisplay(dialogueObject)
	end
})
dialogueHandler.registerAnswer({
	id = "fire_employee",
	question = "fire_employee_confirm",
	text = {
		_T("FIRE_EMPLOYEE_DIALOGUE_1", "[FIRE EMPLOYEE]")
	}
})
dialogueHandler.registerAnswer({
	id = "fire_employee_confirm",
	text = {
		_T("FIRE_EMPLOYEE_DIALOGUE_1", "[FIRE EMPLOYEE]")
	},
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		employee:getEmployer():fireEmployee(employee)
		dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
	end
})
dialogueHandler.registerAnswer({
	question = "talk_to_employee",
	id = "fire_employee_cancel",
	text = {
		_T("FIRE_EMPLOYEE_DIALOGUE_GO_BACK", "[GO BACK]")
	},
	returnText = _T("RETURN_TEXT_NONE", "..."),
	onPick = function(self, dialogueObject)
		dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
	end
})
