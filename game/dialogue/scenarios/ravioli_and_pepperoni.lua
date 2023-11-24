dialogueHandler.registerQuestion({
	nextQuestion = "ravioli_and_pepperoni_1_2",
	id = "ravioli_and_pepperoni_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "ravioli_and_pepperoni_1",
	text = _T("RAVIOLI_AND_PEPPERONI_1_1", "Well hello there! I heard what happened with you over at \"Arts of Electrics\". Don't be too hard on yourself, the reason for the game's lack of sales has nothing to do with the game itself, the marketing team just did an awful job."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "ravioli_and_pepperoni_1_3",
	id = "ravioli_and_pepperoni_1_2",
	text = _T("RAVIOLI_AND_PEPPERONI_1_2", "Anyway, I know what you're capable of. Seeing you get laid off like that with noone to have your back isn't that pleasant. So I have an offer, one that's so good there is absolutely no way you can refuse it!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "ravioli_and_pepperoni_1_4",
	id = "ravioli_and_pepperoni_1_3",
	text = _T("RAVIOLI_AND_PEPPERONI_1_3", "Ready for this? I will provide you with a small place for you to work in and some funds. How does that sound, eh? Great? Knew you would like it!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "ravioli_and_pepperoni_1_5",
	id = "ravioli_and_pepperoni_1_4",
	text = _T("RAVIOLI_AND_PEPPERONI_1_4", "Now here's the deal, I'm not doing this because I expect something in return. I'm doing this because I know that, for a game designer, you're pretty good. Your track record is more than enough to convince me that whatever amount of money I put into you will pay off in time."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_1_5",
	text = _T("RAVIOLI_AND_PEPPERONI_1_5", "So, with that out of the way, you're now the head of your own studio. It might be tiny for now, but with your skills and reputation, I doubt it'll stay that way for long. And who knows, maybe you'll even end up getting some of your past coworkers back? Good luck to you on this journey."),
	answers = {
		"end_conversation_got_it"
	}
})

local gameData = game.getGameTypeData("scenario_ravioli_and_pepperoni")

dialogueHandler.registerQuestion({
	nextQuestion = "ravioli_and_pepperoni_2_2",
	id = "ravioli_and_pepperoni_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "ravioli_and_pepperoni_2",
	regularText = _T("RAVIOLI_AND_PEPPERONI_2_1", "Would you look at that, the guys actually filed for bankruptcy! You know, I'll just look the other way and pretend you had nothing to do with this. I don't know whether I should congratulate you or get a little scared because of your feats here, haha!"),
	boughtOutText = _T("RAVIOLI_AND_PEPPERONI_2_1_B", "So you decided to buy them out, eh? Whatever, either way works, as long as you got your revenge. And with you in charge, I'm sure the games the folks release under you will be even more impressive than before!"),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		if studio:hasBoughtOutCompany(gameData.targetRival) then
			return self.boughtOutText
		end
		
		return self.regularText
	end
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_2_2",
	text = _T("RAVIOLI_AND_PEPPERONI_2_2", "In any case, you've done a tremendous job. Built up a nice studio and even took revenge on the folks that almost ruined your career. Congratulations on your hard efforts!"),
	answers = {
		"generic_continue"
	}
})
