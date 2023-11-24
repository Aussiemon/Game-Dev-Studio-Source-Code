dialogueHandler.registerQuestion({
	nextQuestion = "back_in_the_game_1_2",
	id = "back_in_the_game_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "back_in_the_game_1",
	text = _T("BACK_IN_THE_GAME_1_1", "Hello and welcome to your new office! Woah, deja-vu, you look familiar. Anyway, let me give you a quick rundown on the situation here..."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "back_in_the_game_1_3",
	id = "back_in_the_game_1_2",
	text = _T("BACK_IN_THE_GAME_1_2", "This company isn't what it used to be. A couple of years back the people here made great games, but the CEO made some really bad decisions, and so the company is about to go bankrupt. Since I've invested my money into this studio I would hate to see it go under."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "back_in_the_game_1_4",
	id = "back_in_the_game_1_3",
	text = _T("BACK_IN_THE_GAME_1_3", "So, this is where you come in. I've heard good things about you, which is why I've decided to replace the previous CEO with you."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "back_in_the_game_1_5",
	id = "back_in_the_game_1_4",
	text = _T("BACK_IN_THE_GAME_1_4", "Your task is pretty simple & straightforward. You'll need to restore this company back to it's former glory, meaning you'll need to get the employee count back up to sixty and return the reputation it once had."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "back_in_the_game_1_5",
	text = _T("BACK_IN_THE_GAME_1_5", "And one more thing - I know video games are your passion, so if this goes well enough, I'll grant you full freedom to do whatever it is you wish to do, in case you manage to save this company from certain death."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "back_in_the_game_timelimit",
	image = "the_investor_1",
	textBoth = _T("BACK_IN_THE_GAME_TIMELIMIT_BOTH", "Ding ding ding! Time's up. YEARS years have passed, but I don't see neither the employee count nor do I hear exceptional things about the studio. Sorry pal, but business is business."),
	textReputation = _T("BACK_IN_THE_GAME_TIMELIMIT_REP", "Ding ding ding! Time's up. YEARS years have passed, but I don't hear exceptional things about the studio. Sorry pal, but business is business."),
	textEmployees = _T("BACK_IN_THE_GAME_TIMELIMIT_EMPLOYEES", "Ding ding ding! Time's up. YEARS years have passed, but you're short on the employee count."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		local rep, employeeCount = studio:getReputation(), #studio:getEmployees()
		local text
		
		if rep < game.curGametype.targetReputation and employeeCount < game.curGametype.employeeCount then
			text = self.textBoth
		elseif rep < game.curGametype.targetReputation then
			text = self.textReputation
		elseif employeeCount < game.curGametype.employeeCount then
			text = self.textEmployees
		end
		
		return _format(text, "YEARS", game.getGameTypeData("scenario_back_in_the_game").yearLimit)
	end,
	onFinish = function()
		local data = game.getGameTypeData("scenario_back_in_the_game")
		
		game.gameOver(_format(_T("BACK_IN_THE_GAME_GAMEOVER", "The investor has replaced you with someone else, because you didn't manage to complete all objectives in time. (reach REPK in reputation & have EMPLOYEES employees)"), "REP", string.roundtobignumber(data.targetReputation), "EMPLOYEES", data.employeeCount))
	end
})
dialogueHandler.registerQuestion({
	id = "back_in_the_game_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "back_in_the_game_2",
	text = _T("BACK_IN_THE_GAME_2_1", "You know, when I first assigned you as the CEO, I thought that despite your efforts this company could not be saved, but it seems I was wrong! You've outdone the expectations of investors and I! Like I said, you now have full freedom to do whatever it is you wish to do with this company. Congratulations!"),
	answers = {
		"generic_continue"
	}
})
