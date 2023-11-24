dialogueHandler.registerQuestion({
	nextQuestion = "a_formidable_reputation_1_2",
	id = "a_formidable_reputation_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "a_formidable_reputation_1",
	text = _T("A_FORMIDABLE_REPUTATION_1_1", "Seems like you recently released a game that isn't that good."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "a_formidable_reputation_1_3",
	id = "a_formidable_reputation_1_2",
	text = _T("A_FORMIDABLE_REPUTATION_1_2", "I'm a bit too late in mentioning this, but: your reputation won't get better when you release bad games. Quite the contrary, it'll suffer from that."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "a_formidable_reputation_1_3",
	text = _T("A_FORMIDABLE_REPUTATION_1_3", "So if you're going to start work on some project, make sure you can finish it in under four years. New tech becomes available over time and game standards rise due to that, and if your game is running on old, tech then it'll get slammed for it, unless it's exceptionally good in what it does."),
	answers = {
		"end_conversation_got_it"
	}
})
