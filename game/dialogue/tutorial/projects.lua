dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_1_2",
	id = "tutorial_projects_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_projects_1",
	text = _T("TUTORIAL_PROJECTS_1_1", "And now we finally get to the meat and bone of this industry - game development!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_projects_1_2",
	text = _T("TUTORIAL_PROJECTS_1_2", "First you'll need to acquire a game engine, which means either making one or purchasing one."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_2_2",
	id = "tutorial_projects_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_projects_2",
	text = _T("TUTORIAL_PROJECTS_2_1", "With an engine in stock, you can get to work on a game."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_2_3",
	id = "tutorial_projects_2_2",
	text = _T("TUTORIAL_PROJECTS_2_2", "There are many variables that affect the success of your game, but selecting every single feature under the sun is not one of them."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_projects_2_3",
	text = _T("TUTORIAL_PROJECTS_2_3", "Selecting a lot features for your games is necessary only for a game that is sold for a high price."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_3_2",
	id = "tutorial_projects_3_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_projects_3",
	text = _T("TUTORIAL_PROJECTS_3_1", "The game development process is split up into three stages: concept & design, development, and polishing."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_3_3",
	id = "tutorial_projects_3_2",
	text = _T("TUTORIAL_PROJECTS_3_2", "The first two stages are mandatory, and polishing can be skipped entirely if you wish."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_projects_3_3",
	text = _T("TUTORIAL_PROJECTS_3_3", "In most cases, however, skipping the polishing stage is like signing a death warrant for the success of your game. Rough gameplay and countless bugs will do your sales no good."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_4_2",
	id = "tutorial_projects_4_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_projects_4",
	text = _T("TUTORIAL_PROJECTS_4_1", "Now that the game has entered the polishing stage, you might want to look into Quality Assurance (QA) for your game, or test it yourself."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_4_3",
	id = "tutorial_projects_4_2",
	text = _T("TUTORIAL_PROJECTS_4_2", "Quality Assurance will playtest the game and find issues while you're still working on it."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_projects_4_3",
	text = _T("TUTORIAL_PROJECTS_4_3", "Testing the game on your own will require employees to do redirect their efforts to that instead of working on the game, which means time lost on things that could have been spent working on the game itself."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_projects_5_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_projects_5",
	text = _T("TUTORIAL_PROJECTS_5_1", "The game's finished. At this point you can either release it as it is, or extend the work period and let your employees further polish and improve it."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_6_2",
	id = "tutorial_projects_6_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_projects_6",
	text = _T("TUTORIAL_PROJECTS_6_1", "The game's released and your job here is done."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_projects_6_2",
	text = _T("TUTORIAL_PROJECTS_6_2", "How do you know whether the game is bad or not? The reviews, of course! They'll pile up over time, and give you an insight on the good and the bad, so be sure to read them."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_7_2",
	id = "tutorial_projects_7_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_projects_7",
	text = _T("TUTORIAL_PROJECTS_7_1", "That's just a tiny glimpse into what your game did right and wrong. Reading more reviews will give you the bigger picture, and armed with that knowledge you will be able to make better games."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_projects_7_3",
	id = "tutorial_projects_7_2",
	text = _T("TUTORIAL_PROJECTS_7_2", "A good genre-theme match will boost the sales of your game and make it more appealing to reviewers, but it alone is not enough to make a good game. The most important part to making a good game is having experienced developers."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_projects_7_3",
	text = _T("TUTORIAL_PROJECTS_7_3", "Well, that's all I wanted to explain to you. With this knowledge in mind, it's time for you to try your hand at an actual challenge."),
	answers = {
		"end_conversation_got_it"
	}
})
