dialogueHandler.registerQuestion({
	id = "employee_retire_1",
	answers = {
		"employee_retire_answer"
	},
	textOneYear = {
		_T("EMPLOYEE_RETIRE_ONE_YEAR_1", "Well boss, I haven't spent that much time here, but it's time for me to retire. It was great fun working here, the people here are great. I wish you best of luck.")
	},
	textFiveYears = {
		_T("EMPLOYEE_RETIRE_FIVE_YEARS_1", "Hey boss, it's time for me to retire. I might not be one of the oldest folks around here, but I'm glad I've spent some time here. Best of luck to you.")
	},
	textTenYears = {
		_T("EMPLOYEE_RETIRE_TEN_YEARS_1", "Boss, with the amount of time I've spent here I consider you folks my second family. As hard as it is for me to say this, it's time for me to retire. I'm glad I've spent here as much time as I have, and I wish you the best of luck.")
	},
	textTwentyYears = {
		_T("EMPLOYEE_RETIRE_TWENTY_YEARS_1", "Well my friend, I've been here for quite some time, we've been through hardships and what-not, but it's about time I retire and get some peace and quiet. Best of luck to you.")
	},
	textMoreThanTwentyYears = {
		_T("EMPLOYEE_RETIRE_MORE_THAN_TWENTY_YEARS_1", "Boss, it pains me to say this, but it's time for me to retire. I've lost track of how many years I've spent in this studio working on games, we've no doubt gone through some hardships, but it was worth it. Best of luck to you in your future endeavours.")
	},
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		local workTime = employee:getTimeWorkedInStudio()
		local yearsWorked = workTime / timeline.DAYS_IN_YEAR
		local textList
		
		if yearsWorked <= 1 then
			textList = self.textOneYear
		elseif yearsWorked <= 5 then
			textList = self.textFiveYears
		elseif yearsWorked <= 10 then
			textList = self.textTenYears
		elseif yearsWorked <= 20 then
			textList = self.textTwentyYears
		elseif yearsWorked > 20 then
			textList = self.textMoreThanTwentyYears
		end
		
		return textList[math.random(1, #textList)]
	end,
	onStartSpooling = function(self, dialogueObject)
		dialogueHandler:createSkillChangeDisplay(dialogueObject, true)
	end
})
dialogueHandler.registerAnswer({
	id = "employee_retire_answer",
	endDialogue = true,
	text = {
		_T("EMPLOYEE_RETIRE_ANSWER_1", "Thanks for being here for as long as you have."),
		_T("EMPLOYEE_RETIRE_ANSWER_2", "Pay a visit every now and then, alright?"),
		_T("EMPLOYEE_RETIRE_ANSWER_3", "It has been great to have you here.")
	}
})
