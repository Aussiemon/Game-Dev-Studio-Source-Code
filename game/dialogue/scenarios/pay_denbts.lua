dialogueHandler.registerQuestion({
	nextQuestion = "pay_denbts_1_2",
	id = "pay_denbts_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("PAY_DENBTS_1_1", "Welcome, welcome! I've heard many good things about you! Now, let me give you a quick explanation on what needs to be done here..."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "pay_denbts_1_3",
	id = "pay_denbts_1_2",
	text = _T("PAY_DENBTS_1_2", "The previous person in charge of this company had developed a really ambituous game. The only problem is - it blew up and sold badly. So, the people investing money into the company, including myself, were not happy with that and we decided to replace the CEO with someone else who knows their trade."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "pay_denbts_1_4",
	id = "pay_denbts_1_3",
	text = _T("PAY_DENBTS_1_3", "In fact, the game blew up so bad, the previous CEO had to sell off the larger office building to one of the rivals that were progressing quickly in this industry, and lay off a large amount of staff just not to go under."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "pay_denbts_1_5",
	id = "pay_denbts_1_4",
	text = _T("PAY_DENBTS_1_4", "So, with that out of the way, your task is really simple: you'll need to pay off debt, and then some, within 20 years. The total sum of money amounts to $DEBT. Though with your skills I doubt that will be an issue."),
	getText = function(self, dialogueObject)
		local data = game.getGameTypeData("scenario_pay_denbts")
		
		return _format(self.text, "DEBT", string.comma(data.moneyToPayOff))
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "pay_denbts_1_5",
	text = _T("PAY_DENBTS_1_5", "You manage to pull that off and the studio is yours, because, in my books, paying off debt of that size is a pretty good indicator that you know what you're doing."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "pay_denbts_timelimit",
	image = "the_investor_1",
	text = _T("PAY_DENBTS_TIMELIMIT", "Well buddy, the debt still has not been paid off, and time's up. I'm afraid business is business and I can't change the contract. So as sad as it is for you, I'll have to replace you with someone more fit for the task."),
	answers = {
		"generic_continue"
	},
	onFinish = function()
		local data = game.getGameTypeData("scenario_pay_denbts")
		
		game.gameOver(_format(_T("PAY_DENBTS_TIMELIMIT_GAMEOVER", "The investor has replaced you with someone else, because you didn't manage to pay off the debt of $DEBT within TIME"), "DEBT", string.comma(data.moneyToPayOff), "TIME", timeline:getTimePeriodText(data.yearLimit)))
	end
})
dialogueHandler.registerQuestion({
	id = "pay_denbts_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "pay_denbts_2",
	text = _T("PAY_DENBTS_2_1", "Aaaaand... time! The debt's paid off and you didn't cross the 20 year time limit. Well done, well done! As far as I'm concerned you can do whatever you wish with the staff and the assets you have, I'm sure the folks that've invested money into this company won't mind. Congratulations on your hard efforts!"),
	answers = {
		"generic_continue"
	}
})
