dialogueHandler.registerQuestion({
	id = "employee_leaves_work_late_salaries",
	text = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES", "Hey boss, I'm leaving the studio."),
	answers = {
		"employee_leaves_work_late_salaries_answer_1",
		"employee_leaves_work_late_salaries_answer_2"
	},
	onStartSpooling = function(self, dialogueObject)
		dialogueHandler:createSkillChangeDisplay(dialogueObject, true)
	end
})
dialogueHandler.registerQuestion({
	id = "employee_leaves_work_late_salaries_finish",
	text = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES_FINISH", "Well, the salaries are late and I've got bills to pay, so as unfortunate as it is I'm not going to stick around and hope things take a turn for the better."),
	answers = {
		"employee_leaves_work_late_salaries_convince_to_stay",
		"employee_leaves_work_late_salaries_answer_2"
	}
})
dialogueHandler.registerQuestion({
	id = "employee_leaves_work_late_salaries_convince",
	textConvinced = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES_CONVINCED", "Alright, you've convinced me. I'll stick around for a bit more, but if this keeps up, then I'm sorry, but I'll look for work elsewhere."),
	text = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES_NOT_CONVINCED", "Sorry, but I can't take the chance."),
	getText = function(self, dialogueObject)
		if dialogueObject:getFact("convinced_to_stay_salaries") then
			return self.textConvinced
		end
		
		return self.text
	end,
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getFact("convinced_to_stay_salaries") then
			return self.answersConvinced
		end
		
		return self.answers
	end,
	answers = {
		"employee_leaves_work_late_salaries_answer_2"
	},
	answersConvinced = {
		"employee_leaves_work_late_salaries_convinced"
	}
})
dialogueHandler.registerAnswer({
	id = "employee_leaves_work_late_salaries_answer_1",
	question = "employee_leaves_work_late_salaries_finish",
	text = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES_ANSWER_1", "What's wrong?")
})
dialogueHandler.registerAnswer({
	endDialogue = true,
	id = "employee_leaves_work_late_salaries_answer_2",
	text = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES_ANSWER_2", "That's a shame, but I wish the best of luck to you."),
	onPick = function(self, dialogueObject)
		studio:fireEmployee(dialogueObject:getEmployee(), studio.EMPLOYEE_LEAVE_REASONS.LEFT)
	end
})
dialogueHandler.registerAnswer({
	stayChancePerCharisma = 4,
	question = "employee_leaves_work_late_salaries_convince",
	maxChance = 65,
	id = "employee_leaves_work_late_salaries_convince_to_stay",
	stayBaseChance = 15,
	text = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES_CONVINCE_TO_STAY", "Stick with me for just a while longer. [CONVINCE TO STAY]"),
	stayChancePerKnowledge = 20 / knowledge.MAXIMUM_KNOWLEDGE,
	onPick = function(self, dialogueObject)
		local playerChar = studio:getPlayerCharacter()
		local chance = 0
		
		if playerChar:hasTrait("silver_tongue") then
			chance = chance + self.stayBaseChance
		end
		
		chance = math.min(self.maxChance, chance + playerChar:getAttribute("charisma") * self.stayChancePerCharisma + playerChar:getKnowledge("public_speaking") * self.stayChancePerKnowledge)
		
		dialogueObject:setFact("convinced_to_stay_salaries", chance >= math.random(1, 100))
	end
})
dialogueHandler.registerAnswer({
	id = "employee_leaves_work_late_salaries_convinced",
	endDialogue = true,
	text = _T("EMPLOYEE_LEAVES_WORK_LATE_SALARIES_CONVINCED_THANKS", "Thanks.")
})
