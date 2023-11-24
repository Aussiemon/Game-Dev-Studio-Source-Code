dialogueHandler.registerQuestion({
	id = "vroom_vroom_dialogue_1",
	image = "the_investor_1",
	uniqueDialogueID = "vroom_vroom_dialogue_1",
	text = _T("VROOM_VROOM_DIALOGUE_1_1", "I'm sure you're eager to jump straight into developing a game, but hold your horses. You'll need to make a game engine first. It doesn't need to be amazing or follow professional industry standards, just something to make a game with."),
	answers = {
		"vroom_vroom_continue_1"
	}
})
dialogueHandler.registerQuestion({
	id = "vroom_vroom_dialogue_1_1",
	image = "the_investor_1",
	text = _T("VROOM_VROOM_DIALOGUE_1_2", "But don't think I won't be looking over your progress. I expect you to finish this thing in 6 months."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "vroom_vroom_timelimit",
	image = "the_investor_1",
	text = _T("VROOM_VROOM_TIMELIMIT", "Tick-tock, time's up! Sorry friend, but it seems I was wrong about you. I'm ending our business relationship today."),
	answers = {
		"generic_continue"
	},
	onFinish = function()
		game.gameOver(_T("VROOM_VROOM_GAMEOVER", "The investor has put someone else in your place, because you took too much time in creating a game engine."))
	end
})
dialogueHandler.registerAnswer({
	id = "vroom_vroom_continue_1",
	question = "vroom_vroom_dialogue_1_1",
	text = _T("GENERIC_DIALOGUE_CONTINUE", "[...]")
})
dialogueHandler.registerQuestion({
	id = "vroom_vroom_dialogue_2",
	image = "the_investor_1",
	uniqueDialogueID = "vroom_vroom_dialogue_2",
	text = _T("VROOM_VROOM_DIALOGUE_2", "Done already? Not bad, but let's see how good your hand is at making a game! Just so we're clear, you'll have to finish developing this game in 3 years. So don't make it a huge one, otherwise you'll never finish it in time."),
	answers = {
		"end_conversation_got_it"
	}
})
