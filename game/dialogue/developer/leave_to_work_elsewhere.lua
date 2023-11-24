dialogueHandler.registerQuestion({
	id = "employee_leaves_work_elsewhere",
	text = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE", "Hey boss, I'm leaving the studio."),
	answers = {
		"employee_leaves_work_elsewhere_answer_1",
		"employee_leaves_work_elsewhere_answer_2"
	},
	onStartSpooling = function(self, dialogueObject)
		dialogueHandler:createSkillChangeDisplay(dialogueObject, true)
	end
})
dialogueHandler.registerQuestion({
	id = "employee_leaves_work_elsewhere_finish",
	text = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE_FINISH", "Nothing, really. I just realized that game development is not meant for me, so I'm leaving to work in another programming field."),
	answers = {
		"employee_leaves_work_elsewhere_convince_to_stay",
		"employee_leaves_work_elsewhere_answer_2"
	}
})
dialogueHandler.registerQuestion({
	id = "employee_leaves_work_elsewhere_finish_convince",
	textConvinced = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE_FINISH_CONVINCED", "Alright, you've convinced me. Maybe I should give it another try before coming to such a conclusion."),
	text = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE_FINISH_NOT_CONVINCED", "Sorry, I really do think that game development is not meant for me. It was fun working here, but I want to try my programming luck elsewhere."),
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
		"employee_leaves_work_elsewhere_answer_2"
	},
	answersConvinced = {
		"employee_leaves_work_elsewhere_answer_convinced"
	}
})
dialogueHandler.registerAnswer({
	id = "employee_leaves_work_elsewhere_answer_1",
	question = "employee_leaves_work_elsewhere_finish",
	text = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE_ANSWER_1", "Is something wrong?")
})
dialogueHandler.registerAnswer({
	endDialogue = true,
	id = "employee_leaves_work_elsewhere_answer_2",
	text = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE_ANSWER_2", "That's a shame, but I wish the best of luck to you."),
	onPick = function(self, dialogueObject)
		studio:fireEmployee(dialogueObject:getEmployee(), studio.EMPLOYEE_LEAVE_REASONS.LEFT)
	end
})
dialogueHandler.registerAnswer({
	stayChancePerCharisma = 6,
	question = "employee_leaves_work_elsewhere_finish_convince",
	maxChance = 90,
	id = "employee_leaves_work_elsewhere_convince_to_stay",
	stayBaseChance = 20,
	text = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE_CONVINCE_TO_STAY", "Are you sure you want to leave? [CONVINCE TO STAY]"),
	stayChancePerKnowledge = 20 / knowledge.MAXIMUM_KNOWLEDGE,
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
	id = "employee_leaves_work_elsewhere_answer_convinced",
	endDialogue = true,
	text = _T("EMPLOYEE_LEAVES_WORK_ELSEWHERE_ANSWER_CONVINCED", "Great, I'm glad you're staying.")
})
