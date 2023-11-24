dialogueHandler.registerQuestion({
	id = "employee_leaves_to_work_on_own_projects",
	text = _T("EMPLOYEE_LEAVES_TO_WORK_ON_OWN_PROJECTS", "Hey boss, I'm leaving the studio."),
	answers = {
		"employee_leaves_to_work_on_own_projects_answer_1",
		"employee_leaves_to_work_on_own_projects_answer_2"
	},
	onStartSpooling = function(self, dialogueObject)
		dialogueHandler:createSkillChangeDisplay(dialogueObject, true)
	end
})
dialogueHandler.registerQuestion({
	id = "employee_leaves_to_work_on_own_projects_finish",
	text = _T("EMPLOYEE_LEAVES_TO_WORK_ON_OWN_PROJECTS_FINISH", "Everything's fine, I just want to finish a project I've been working on in my free time, and then go further from there."),
	answers = {
		"employee_leaves_to_work_on_own_projects_convince_to_stay",
		"employee_leaves_to_work_on_own_projects_answer_2"
	}
})
dialogueHandler.registerQuestion({
	id = "employee_leaves_to_work_on_own_projects_convince",
	textConvinced = _T("EMPLOYEE_LEAVES_TO_WORK_ON_OWN_PROJECTS_CONVINCED", "Alright, you've convinced me. I'll stay."),
	text = _T("EMPLOYEE_LEAVES_TO_WORK_ON_OWN_PROJECTS_NOT_CONVINCED", "Sorry, but I really do want to finish the project I've been working on in my free time for quite a while."),
	getText = function(self, dialogueObject)
		if dialogueObject:getFact("convinced_to_stay") then
			return self.textConvinced
		end
		
		return self.text
	end,
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getFact("convinced_to_stay") then
			return self.answersConvinced
		end
		
		return self.answers
	end,
	answers = {
		"employee_leaves_to_work_on_own_projects_answer_2"
	},
	answersConvinced = {
		"employee_leaves_to_work_on_own_projects_convinced"
	}
})
dialogueHandler.registerAnswer({
	id = "employee_leaves_to_work_on_own_projects_answer_1",
	question = "employee_leaves_to_work_on_own_projects_finish",
	text = _T("employee_leaves_to_work_on_own_projects_answer_1", "Is something wrong?")
})
dialogueHandler.registerAnswer({
	endDialogue = true,
	id = "employee_leaves_to_work_on_own_projects_answer_2",
	text = _T("EMPLOYEE_LEAVES_TO_WORK_ON_OWN_PROJECTS_ANSWER_2", "That's a shame, but I wish the best of luck to you."),
	onPick = function(self, dialogueObject)
		studio:fireEmployee(dialogueObject:getEmployee(), studio.EMPLOYEE_LEAVE_REASONS.LEFT)
	end
})
dialogueHandler.registerAnswer({
	stayChancePerCharisma = 2,
	question = "employee_leaves_to_work_on_own_projects_convince",
	maxChance = 40,
	id = "employee_leaves_to_work_on_own_projects_convince_to_stay",
	stayBaseChance = 10,
	text = _T("EMPLOYEE_LEAVES_TO_WORK_ON_OWN_PROJECTS_CONVINCE_TO_STAY", "Are you sure you want to leave? [CONVINCE TO STAY]"),
	stayChancePerKnowledge = 10 / knowledge.MAXIMUM_KNOWLEDGE,
	onPick = function(self, dialogueObject)
		local playerChar = studio:getPlayerCharacter()
		local chance = 0
		
		if playerChar:hasTrait("silver_tongue") then
			chance = chance + self.stayBaseChance
		end
		
		chance = math.min(self.maxChance, chance + playerChar:getAttribute("charisma") * self.stayChancePerCharisma + playerChar:getKnowledge("public_speaking") * self.stayChancePerKnowledge)
		
		dialogueObject:setFact("convinced_to_stay", chance >= math.random(1, 100))
	end
})
dialogueHandler.registerAnswer({
	id = "employee_leaves_to_work_on_own_projects_convinced",
	endDialogue = true,
	text = _T("EMPLOYEE_LEAVES_TO_WORK_ON_OWN_PROJECTS_ANSWER_CONVINCED", "Great, I'm glad you're staying.")
})
