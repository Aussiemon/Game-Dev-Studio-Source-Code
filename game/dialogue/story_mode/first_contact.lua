dialogueHandler.registerQuestion({
	nextQuestion = "first_contact_1_2",
	id = "first_contact_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "first_contact_1",
	text = _T("FIRST_CONTACT_1_1", "I keep hearing stories of a game studio that's getting quite popular. I'm talking about you!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "first_contact_1_3",
	id = "first_contact_1_2",
	text = _T("FIRST_CONTACT_1_2", "Having a favorable reputation is good, because people will be more likely to accept your job offers and more people will buy your games."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "first_contact_1_4",
	id = "first_contact_1_3",
	text = _T("FIRST_CONTACT_1_3", "But it's not all roses. There are other game companies, just like your own, constantly looking for talented people. Some crave success so much that they don't mind making a few enemies in the game industry, and might even consider trying to lure your employees away."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "first_contact_1_4",
	text = _T("FIRST_CONTACT_1_4", "So, when someone's going to try and steal your employees - you let me know. We'll make them regret it."),
	answers = {
		"end_conversation_got_it"
	}
})
