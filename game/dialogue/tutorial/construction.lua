dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_construction_1_2",
	id = "tutorial_construction_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_construction_1",
	text = _T("TUTORIAL_CONSTRUCTION_1_1", "Welcome! This tutorial will teach you the basics of construction and filling out of empty office space you might have."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_construction_1_2",
	text = _T("TUTORIAL_CONSTRUCTION_1_2", "An office with no workplaces is just empty, useless space. Let's start changing that."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_construction_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_construction_2",
	text = _T("TUTORIAL_CONSTRUCTION_2_1", "First, let's place a couple of workplaces, since we don't want world-class developers sitting on the floor with notepads in their hands, doodling something."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_construction_3_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_construction_3",
	text = _T("TUTORIAL_CONSTRUCTION_3_1", "You might think just workplaces are enough, but that's not the case. Game developers are regular people with needs like every other person. So let's take care of that now."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_construction_4_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_construction_4",
	text = _T("TUTORIAL_CONSTRUCTION_4_1", "Great, there's only one thing your office is missing now - a water dispenser."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_construction_5_2",
	id = "tutorial_construction_5_1",
	image = "the_investor_1",
	uniqueDialogueID = "tutorial_construction_5",
	text = _T("TUTORIAL_CONSTRUCTION_5_1", "Great, your office is now set-up with all the prerequisites."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_construction_5_3",
	id = "tutorial_construction_5_2",
	text = _T("TUTORIAL_CONSTRUCTION_5_2", "Offices can also be outfitted with kitchens and various objects related to comfort, so that your employees run out of Drive slower and stay in office for longer."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_construction_5_3",
	text = _T("TUTORIAL_CONSTRUCTION_5_3", "Some offices can be expanded, and in some cases you'll need to expand an existing building for a couple more workplaces. This is cheaper than buying a new building, and will give you the much-needed office space."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_construction_6_1",
	image = "the_investor_1",
	text = _T("TUTORIAL_CONSTRUCTION_6_1", "Expansion is one thing, but an entire new office is a completely different thing. A new building will cost a lot more than just expanding your existing one, but you'll get a ton of extra space that way."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "tutorial_construction_7_2",
	id = "tutorial_construction_7_1",
	image = "the_investor_1",
	text = _T("TUTORIAL_CONSTRUCTION_7_1", "That's all I've wanted to show to you. With these basics in mind, the rest is up to you. You'll need to position things in your offices in the most efficient way possible, to allow for as many workplaces as possible."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "tutorial_construction_7_2",
	text = _T("TUTORIAL_CONSTRUCTION_7_2", "By the way, aside from expanding every office can have multiple floors. Purchasing a new floor gives you as much extra space as an entirely new office, while costing much less to purchase. Buy some extra floors if you wish to!"),
	answers = {
		"end_conversation_got_it"
	}
})
