dialogueHandler.registerQuestion({
	id = "getting_started_dialogue_1",
	image = "the_investor_1",
	uniqueDialogueID = "getting_started_dialogue",
	text = _T("GETTING_STARTED_DIALOGUE_1", "Alright buddy, welcome to your new home, consider this investment as the key to your future success."),
	answers = {
		"getting_started_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "getting_started_dialogue_2",
	text = _T("GETTING_STARTED_DIALOGUE_2", "Now, you owe me, since I've invested some of my hard-earned money into you, and will have to be following my orders for a while.\nThis tiny space you've got will be enough for you and maybe one or two more folks, so what you should do right now is change the empty space you've got into something useful."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerAnswer({
	id = "getting_started_continue",
	question = "getting_started_dialogue_2",
	text = _T("GENERIC_DIALOGUE_CONTINUE", "[...]")
})
