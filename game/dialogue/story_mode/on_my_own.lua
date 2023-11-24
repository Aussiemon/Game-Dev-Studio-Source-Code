dialogueHandler.registerQuestion({
	nextQuestion = "on_my_own_dialogue_1_2",
	id = "on_my_own_dialogue_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "on_my_own_dialogue_1",
	text = _T("ON_MY_OWN_DIALOGUE_1_1", "Right, so this is where I take off for a bit. Now listen, I know your first step is to reach for the stars, but you'll have to slow down a bit. You're still new, you need cash, more employees and, most importantly, know how to manage your time and resources."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "on_my_own_dialogue_1_3",
	id = "on_my_own_dialogue_1_2",
	text = _T("ON_MY_OWN_DIALOGUE_1_2", "So let's start your journey with a small simple task. I'm giving you 4 years to make a total of $800,000. If you make that much money by then, or sooner, I'll be happy to invest more money into you. If not, then our business relationship will be over, and I'll find someone else to take care of the studio."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "on_my_own_dialogue_1_3",
	text = _T("ON_MY_OWN_DIALOGUE_1_3", "Now, are we on the same page? I'm glad we are! Are you excited for the future? I'm glad you are! Best of luck to you on your first endeavor, business partner!"),
	answers = {
		"end_conversation_got_it"
	},
	answersNoEmployees = {
		"generic_continue"
	},
	getAnswers = function(self, dialogueObject)
		if #studio:getEmployees() == 1 then
			return self.answersNoEmployees
		end
		
		return self.answers
	end,
	getNextQuestion = function(self, dialogueObject)
		if #studio:getEmployees() == 1 then
			return "on_my_own_dialogue_1_4"
		end
		
		return nil
	end
})
dialogueHandler.registerQuestion({
	id = "on_my_own_dialogue_1_4",
	text = _T("ON_MY_OWN_DIALOGUE_1_4", "Oh, and by the way, I've noticed that you haven't hired anyone, I suggest you do hire at least one more software engineer. But don't go around hiring experts that ask for huge salaries at this point - you'll run out of money before you finish another game!"),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "on_my_own_dialogue_2_2_a",
	id = "on_my_own_dialogue_2_1_a",
	image = "the_investor_1",
	uniqueDialogueID = "on_my_own_dialogue_2_1",
	text = _T("ON_MY_OWN_DIALOGUE_2_1_A", "Now listen, I've just transferred $500,000 to your bank account. That is a large sum of money. I am hoping you'll use that to advertise your game, so that it gets more sales upon release, but if you wish to do something else with it, go right ahead. I am telling you, however, that using that money to advertise your game would be the best choice right now!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "on_my_own_dialogue_2_2_a",
	text = _T("ON_MY_OWN_DIALOGUE_2_2_A", "And I can't stress this enough: a good game on it's own will not sell well unless it has interest and hype surrounding it. You can make a damn good game, but if no-one knows about it, it'll only sell so much, and word of mouth won't be that much help either, unless it's a fluke. And flukes rarely happen."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "on_my_own_dialogue_2_1_b",
	image = "the_investor_1",
	uniqueDialogueID = "on_my_own_dialogue_2_1",
	text = _T("ON_MY_OWN_DIALOGUE_2_1_B", "I was going to tell you to advertise your game once it's in a near-completed state and give you the funds to do that, but I see you've already done that with your own cash reserves. No matter, I'm transferring the $500,000 I was going to for covering the costs of advertisement regardless."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "on_my_own_off_market_dialogue_2",
	id = "on_my_own_off_market_dialogue_1",
	image = "the_investor_1",
	uniqueDialogueID = "on_my_own_off_market_dialogue_1",
	text = _T("ON_MY_OWN_OFF_MARKET_DIALOGUE_1", "Word around town is your first game's gone off-market."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "on_my_own_off_market_dialogue_3",
	id = "on_my_own_off_market_dialogue_2",
	image = "the_investor_1",
	text = _T("ON_MY_OWN_OFF_MARKET_DIALOGUE_2", "This will happen to every game you and your rivals make. How long a game stays on-market depends on how well it's selling. So, if you make a good game it'll stay on-market for longer purely because it'll be selling like hot cakes."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "on_my_own_off_market_dialogue_3",
	image = "the_investor_1",
	text = _T("ON_MY_OWN_OFF_MARKET_DIALOGUE_3", "In other words don't expect to make any money on a hack-job of a game. You put effort into a game - you get money; you don't put effort into it - well, now you have a hole in your wallet. Simple as that."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "on_my_own_timelimit",
	image = "the_investor_1",
	text = _T("ON_MY_OWN_TIMELIMIT", "Well, time's up and I see you haven't made that $800,000 yet. As unfortunate as it is I'm afraid today's the last day we do business. Better luck next time."),
	answers = {
		"generic_continue"
	},
	onFinish = function()
		game.gameOver(_T("ON_MY_OWN_GAMEOVER", "The investor has replaced you with someone else, because you didn't manage to make a revenue of $800,000 in 4 years time."))
	end
})
