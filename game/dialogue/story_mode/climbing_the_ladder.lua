dialogueHandler.registerQuestion({
	nextQuestion = "climbing_the_ladder_1_2",
	id = "climbing_the_ladder_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "climbing_the_ladder_1",
	text = _T("CLIMBING_THE_LADDER_1_1", "Ka-ching! That's the sound of eight hundred thousand in the bank! I knew I had a good feeling about you!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "climbing_the_ladder_1_3",
	id = "climbing_the_ladder_1_2",
	textValid = _T("CLIMBING_THE_LADDER_1_2_A", "Now that you have a somewhat decent capital your next step is to hire people. I'd say go ahead and get a total of 15 people in your office."),
	textFinished = _T("CLIMBING_THE_LADDER_1_2_B", "I was going to tell you to get 15 employees in your office, but I see you already took care of hiring people, so we'll skip that."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		if #studio:getEmployees() >= 15 then
			return self.textFinished
		end
		
		return self.textValid
	end
})
dialogueHandler.registerQuestion({
	id = "climbing_the_ladder_1_3",
	textValid = _T("CLIMBING_THE_LADDER_1_3_A", "But that doesn't mean you should stop making games! I'm giving you 36 months to make another $500,000."),
	textFinished = _T("CLIMBING_THE_LADDER_1_3_B", "Aside from that you should keep on making games. Once you make another $500,000 in 36 months, or less, I'll let you know what to do next."),
	answers = {
		"end_conversation_got_it"
	},
	getText = function(self, dialogueObject)
		if #studio:getEmployees() >= 15 then
			return self.textFinished
		end
		
		return self.textValid
	end
})
dialogueHandler.registerQuestion({
	nextQuestion = "climbing_the_ladder_2_2",
	id = "climbing_the_ladder_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "climbing_the_ladder_2",
	text = _T("CLIMBING_THE_LADDER_2_1", "Look at this - you've got a good amount of people working for you, you've got money and you're making games. Sounds great, right?"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "climbing_the_ladder_2_3",
	id = "climbing_the_ladder_2_2",
	text = _T("CLIMBING_THE_LADDER_2_2", "And it is! The only real thing you're lacking right now is reputation. Having a good reputation increases your sales without having to advertise as much, because people know that your games are worth the money."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "climbing_the_ladder_2_3",
	text = _T("CLIMBING_THE_LADDER_2_3", "So, your next task is to get 20,000 reputation points. I'm not going to give you any time restraints, since you've shown that you know what you're doing. But don't take too long, or you'll get old, hahaha!"),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "climbing_the_ladder_timelimit",
	text = _T("climbing_the_ladder_timelimit", "Time's up. You got far enough, but it seems this was too much for you. As unfortunate as it is, I'm going to have to replace you with someone else."),
	answers = {
		"generic_continue"
	},
	onFinish = function(self, dialogueObject)
		game.gameOver(_T("CLIMBING_THE_LADDER_TIMELIMIT", "The investor has replaced you with someone else, because you failed to finish one of the two tasks (make $500,000 and get 15 employees in the office) in 3 years time."))
	end
})
