dialogueHandler.registerQuestion({
	id = "the_journey_dialogue_1",
	image = "the_investor_1",
	uniqueDialogueID = "the_journey_dialogue_1",
	text = _T("THE_JOURNEY_DIALOGUE_1", "Alright, now listen, I'm trusting you to finish this game within 3 years. I'll be doing a little behind-the-scenes to make this game a bit more popular in order to make some more sales. So don't slack around and don't waste all the money I've given you!"),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "the_journey_dialogue_qa_2",
	id = "the_journey_dialogue_qa",
	image = "the_investor_1",
	uniqueDialogueID = "the_journey_dialogue_qa",
	text = _T("THE_JOURNEY_DIALOGUE_QA", "Alright, your game's almost ready. Now it's polishing time. Which reminds me, you should hire a Quality Assurance firm, short for QA, to test your game. They'll find a lot of bugs you overlooked while working on it."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "the_journey_dialogue_qa_2",
	image = "the_investor_1",
	text = _T("THE_JOURNEY_DIALOGUE_QA_2", "Alternatively, you can always test your game projects on your own, but it'll take a lot more time to find all the problems with it, unless you have a lot of employees. So, my advice to you - begin QA, let them find bugs and then fix them."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "the_journey_dialogue_2",
	image = "the_investor_1",
	uniqueDialogueID = "the_journey_dialogue_2",
	text = _T("THE_JOURNEY_DIALOGUE_2", "You've got a game now, great! Just release it as it is now. I've done some marketing for it, but not much, so don't expect many sales, but don't expect it to be nothing either!"),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "the_journey_dialogue_3",
	image = "the_investor_1",
	uniqueDialogueID = "the_journey_dialogue_3",
	text = _T("THE_JOURNEY_DIALOGUE_3", "Sweet, now just sit back, relax and let the money and reviews pour in!"),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "the_journey_dialogue_4",
	image = "the_investor_1",
	uniqueDialogueID = "the_journey_dialogue_4",
	text = _T("THE_JOURNEY_DIALOGUE_4", "Hey, check this out, someone just reviewed your game! You should take a look at it, they'll definitely let you know what was good or bad about it."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "the_journey_dialogue_5_1",
	image = "the_investor_1",
	uniqueDialogueID = "the_journey_dialogue_5",
	getText = function(self, dialogueObject)
		local game = studio:getReleasedGames()[1]
		local rating = game:getReviewRating()
		
		if rating < 5 then
			return _T("THE_JOURNEY_DIALOGUE_5_LOW_RATING", "Oof, well that could have gone better, but don't be hard on yourself - this is your first game, after all.")
		elseif rating < 7 then
			return _T("THE_JOURNEY_DIALOGUE_5_MEDIUM_RATING", "Not bad, you did better than I expected, to be honest with you.")
		end
		
		return _T("THE_JOURNEY_DIALOGUE_5_HIGH_RATING", "Would you look at that, people love your game! Quite frankly this is the one outcome I did not expect at all!")
	end,
	answers = {
		"the_journey_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "the_journey_dialogue_5_2",
	text = _T("THE_JOURNEY_DIALOGUE_5_2", "Regardless, reading reviews is important. They will provide you with insight on what works and what doesn't with all kinds of genres and themes. So don't be lazy and read them when you have the time!"),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerAnswer({
	id = "the_journey_continue",
	question = "the_journey_dialogue_5_2",
	text = _T("GENERIC_DIALOGUE_CONTINUE", "[...]")
})
dialogueHandler.registerQuestion({
	id = "the_journey_timelimit",
	image = "the_investor_1",
	text = _T("THE_JOURNEY_TIMELIMIT", "Time's up. It's been 36 months and I don't see a game being released anywhere. Sorry pal, but it's over."),
	answers = {
		"generic_continue"
	},
	onFinish = function()
		game.gameOver(_T("THE_JOURNEY_GAMEOVER", "The investor has put someone else in your place, because you took too much time in creating your first game."))
	end
})
