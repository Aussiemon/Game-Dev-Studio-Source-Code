dialogueHandler.registerQuestion({
	id = "developer_inquire_about_workplace",
	text = _T("DEVELOPER_INQUIRE_ABOUT_WORKPLACE_QUESTION", "Hmm, let me think for a moment..."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_inquire_about_workplace_nothing",
	text = _T("DEVELOPER_INQUIRE_ABOUT_WORKPLACE_NOTHING", "Can't think of anything, everything is fine as far as I'm concerned."),
	answers = {
		"developer_inquire_about_workplace_finish"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_inquire_about_workplace_finish",
	text = _T("DEVELOPER_INQUIRE_ABOUT_WORKPLACE_FINISH_QUESTION", "That's all I can think about."),
	answers = {
		"developer_inquire_about_workplace_finish"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_too_many_people_in_room",
	text = _T("DEVELOPER_TOO_MANY_PEOPLE_IN_ROOM", "There are too many people in the room where I work, I can't concentrate properly and it affects my work efficiency."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_team_could_use_manager",
	getText = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		if employee:getRole() == "manager" then
			return _T("ASSIGN_ME_TO_MANAGE_TEAM", "The team I'm on does not have a manager, I'm fairly sure that if you had assigned me to manage the team, everyone there would work faster.")
		end
		
		return _T("DEVELOPER_TEAM_COULD_USE_MANAGER", "I'm fairly sure that if someone managed our team, we would work faster.")
	end,
	getAnswers = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		if employee:getRole() == "manager" then
			return self.answersManager
		end
		
		return self.answers
	end,
	answersManager = {
		"developer_continue_assign_manager",
		"developer_continue_skip_manager_assignment"
	},
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_continue_assign_manager_finished",
	text = _T("DEVELOPER_CONTINUE_ASSIGN_MANAGER_FINISHED", "Awesome, as long as I'm not overloaded with people to manage, I'll do a good job. Now, back to the topic at hand..."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_continue_assign_manager_skipped",
	text = _T("DEVELOPER_CONTINUE_ASSIGN_MANAGER_SKIPPED", "Alright. Let's get back to the initial topic..."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "developer_outdated_computer",
	getText = function(self, dialogueObject)
		if dialogueObject:getEmployee():getRole() == "software_engineer" then
			_T("DEVELOPER_OUTDATED_COMPUTER_PROGRAMMER", "My computer is a bit old, new tech might be impossible to implement into any game or engine because it will require hardware beyond what I have.")
		end
		
		return _T("DEVELOPER_OUTDATED_COMPUTER", "My computer is a bit old, I might not be able to work on specific game-related things if it's outdated.")
	end,
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "activity_organization_suggestion",
	text = _T("ACTIVITY_ORGANIZATION_SUGGESTION", "This is a bit irrelevant to your question, but I think if we could go somewhere as a team it would be refreshing and could help with motivation."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "inter_office_team_penalty_suggestion",
	text = _T("INTER_OFFICE_TEAM_PENALTY_SUGGESTION", "The team I'm part of has its members scattered across multiple buildings, this makes communication an issue. If we were all in one office, then we'd be more efficient at our jobs."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerAnswer({
	question = "developer_inquire_about_workplace",
	id = "developer_inquire_about_workplace",
	text = _T("DEVELOPER_INQUIRE_ABOUT_WORKPLACE_ANSWER", "Is there anything I can do to improve your working conditions?"),
	onPick = function(self, dialogueObject)
		local potentialImprovements = {}
		local employee = dialogueObject:getEmployee()
		local officeObject = employee:getOffice()
		
		employee:fillSuggestionList(potentialImprovements, dialogueObject)
		dialogueObject:setFact("potentialImprovements", potentialImprovements)
		dialogueObject:setFact("hadPotentialImprovements", #potentialImprovements > 0)
	end
})
dialogueHandler.registerAnswer({
	question = "talk_to_employee",
	id = "developer_inquire_about_workplace_finish",
	text = _T("DEVELOPER_INQUIRE_ABOUT_WORKPLACE_FINISH_ANSWER", "Alright, thanks for your input."),
	returnText = _T("DEVELOPER_INQUIRE_ABOUT_WORKPLACE_FINISH_RETURN", "Was there something else you needed?"),
	onPick = function(self, dialogueObject)
		dialogueObject:setFact("potentialImprovements", nil)
		dialogueObject:setFact("hadPotentialImprovements", nil)
	end
})
dialogueHandler.registerAnswer({
	question = "developer_continue_assign_manager_finished",
	id = "developer_continue_assign_manager",
	text = _T("DEVELOPER_CONTINUE_ASSIGN_MANAGER", "Alright, you'll be managing the team, then. [ASSIGN MANAGER]"),
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		employee:getTeam():setManager(employee)
	end
})
dialogueHandler.registerAnswer({
	question = "developer_continue_assign_manager_skipped",
	id = "developer_continue_skip_manager_assignment",
	text = _T("DEVELOPER_CONTINUE_SKIP_MANAGER_ASSIGNMENT", "I'll think about it."),
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		employee:getTeam():setManager(employee)
	end
})
dialogueHandler.registerAnswer({
	id = "developer_inquire_about_workplace_continue",
	text = _T("GENERIC_CONTINUE", "[CONTINUE]"),
	onPick = function(self, dialogueObject)
		local potentialImprovements = dialogueObject:getFact("potentialImprovements")
		local currentDiscussedData
		
		if #potentialImprovements > 0 then
			currentDiscussedData = potentialImprovements[#potentialImprovements]
			
			table.remove(potentialImprovements, #potentialImprovements)
		end
		
		dialogueObject:setFact("currentDiscussionData", currentDiscussedData)
	end,
	getNextQuestion = function(self, dialogueObject)
		local currentDiscussedData = dialogueObject:getFact("currentDiscussionData")
		
		if currentDiscussedData then
			if type(currentDiscussedData) == "table" then
				return currentDiscussedData.id
			elseif type(currentDiscussedData) == "string" then
				return currentDiscussedData
			end
		end
		
		if dialogueObject:getFact("hadPotentialImprovements") then
			return "developer_inquire_about_workplace_finish"
		end
		
		return "developer_inquire_about_workplace_nothing"
	end
})
dialogueHandler.registerQuestion({
	id = "developer_ask_about_role",
	getText = function(self, dialogueObject)
		return dialogueObject:getEmployee():getRoleData().inquiry
	end,
	answers = {
		"developer_ask_about_role_return"
	}
})
dialogueHandler.registerAnswer({
	id = "developer_ask_about_role",
	question = "developer_ask_about_role",
	text = _T("DEVELOPER_ASK_ABOUT_ROLE", "What do you do?")
})
dialogueHandler.registerAnswer({
	id = "developer_ask_about_role_return",
	question = "talk_to_employee",
	text = _T("DEVELOPER_ASK_ABOUT_ROLE_RETURN", "Thanks for the info."),
	returnText = _T("DEVELOPER_ASK_ABOUT_ROLE_RETURN_TEXT", "Anything else, boss?")
})
