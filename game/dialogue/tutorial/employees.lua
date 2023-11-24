dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_employees_1_2",
	id = "tutorial_employees_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_employees_1",
	text = _T("TUTORIAL_EMPLOYEES_1_1", "Right, with a decent-looking office, it's time you looked into hiring employees."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_employees_1_3",
	id = "tutorial_employees_1_2",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_employees_1",
	text = _T("TUTORIAL_EMPLOYEES_1_2", "You'll need to hire people from a variety of professions, as game developers are not miracle workers, and each has their own speciality they're best at."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_employees_1_3",
	text = _T("TUTORIAL_EMPLOYEES_1_3", "Go ahead and hire one of each."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_employees_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_employees_2",
	text = _T("TUTORIAL_EMPLOYEES_2_1", "Just because you've sent a job offer to a developer does not mean they will accept it. Your reputation and financial situation play a role in the possiblity of someone accepting your job offer."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_employees_3_2",
	id = "tutorial_employees_3_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_employees_3",
	text = _T("TUTORIAL_EMPLOYEES_3_1", "Great, more people means work on projects will be finished faster, as your developers will split up the tasks between each other."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_employees_3_3",
	id = "tutorial_employees_3_2",
	text = _T("TUTORIAL_EMPLOYEES_3_2", "Always keep your finances in mind when hiring new people. Employees need to be paid, and they will start leaving to work elsewhere in case you can't afford their salaries."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_employees_3_4",
	id = "tutorial_employees_3_3",
	text = _T("TUTORIAL_EMPLOYEES_3_3", "With that said your employees are regular people just like yourself! They often have their own Interests which provide them with Knowledge related to it. This Knowledge can then be used to make better games."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_employees_3_5",
	id = "tutorial_employees_3_4",
	text = _T("TUTORIAL_EMPLOYEES_3_4", "Aside from that every employee has Attributes and Skills. Every role, apart from you, has its main Skill. This main Skill increases much faster than all the others, since this is something they specialize in."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_employees_3_5",
	text = _T("TUTORIAL_EMPLOYEES_3_5", "Click on any employee in the game world and open their 'Employee info' menu to see more!"),
	answers = {
		"end_conversation_got_it"
	}
})
