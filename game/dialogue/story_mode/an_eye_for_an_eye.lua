dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_1_2",
	id = "an_eye_for_an_eye_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "an_eye_for_an_eye_1",
	text = _T("AN_EYE_FOR_AN_EYE_1_1", "Am I dreaming or did that just happen? Regardless, I'm not too surprised. I know what you're thinking, though. Probably angry, right?"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_1_3",
	id = "an_eye_for_an_eye_1_2",
	text = _T("AN_EYE_FOR_AN_EYE_1_2", "Don't be. Just keep in mind that this is business to other companies in this industry, after all it's nothing personal."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "an_eye_for_an_eye_1_3",
	text = _T("AN_EYE_FOR_AN_EYE_1_3", "But you know, just because it's business doesn't mean we can't do anything about it. How about we give them a taste of their own medicine? Take a look at the employees they've got, pick one out and send them a job offer. See what happens."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_2_2",
	id = "an_eye_for_an_eye_2_1",
	image = "the_investor_1",
	uniqueDialogueID = "an_eye_for_an_eye_2",
	text = _T("AN_EYE_FOR_AN_EYE_2_1", "Hahaha, did he just say that? What a hypocrite! First he tries stealing your employees, next thing you know - it's all your fault!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_2_3",
	id = "an_eye_for_an_eye_2_2",
	text = _T("AN_EYE_FOR_AN_EYE_2_2", "But let's focus on what matters right now - this guy essentially just declared war on you, so don't think you two will be best friends anytime soon."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_2_4",
	id = "an_eye_for_an_eye_2_3",
	text = _T("AN_EYE_FOR_AN_EYE_2_3", "With that out of the way, congratulations, you've just reduced his employee count by one! Score one for 'STUDIO'!"),
	getText = function(self, dialogueObject)
		return _format(self.text, "STUDIO", studio:getName())
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_2_5",
	id = "an_eye_for_an_eye_2_4",
	text = _T("AN_EYE_FOR_AN_EYE_2_4", "That won't be enough to get him out of the game, though. Your next step is to try and get two more of his employees."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "an_eye_for_an_eye_2_5",
	spoolCooldown = 0.7,
	text = _T("AN_EYE_FOR_AN_EYE_2_5", "But remember. This is just business. Don't let it get to you."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "story_mode_call_from_rival_1",
	uniqueDialogueID = "story_mode_call_from_rival_1",
	text = _T("STORY_MODE_CALL_FROM_RIVAL_1", "You know, you really are something. I knew I'd get some kind of reaction from you, but nothing on this level. You've stolen three of my employees. Three! I'm starting to think I might just have to take some extraordinary, super-human measures in response to this."),
	answers = {
		"generic_hang_up"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_3_2",
	id = "an_eye_for_an_eye_3_1",
	image = "the_investor_1",
	uniqueDialogueID = "an_eye_for_an_eye_3",
	text = _T("AN_EYE_FOR_AN_EYE_3_1", "Look at that! You made him angry! What were the chances? Okay, okay, he's getting all dramatic, that must mean he's getting some sinister ideas."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "an_eye_for_an_eye_3_2",
	text = _T("AN_EYE_FOR_AN_EYE_3_2", "I say you go about your business like you did before. If you want to steal more of his employees - feel free to do so. I'm interested in what he's going to come up with!"),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_4_2",
	id = "an_eye_for_an_eye_4_1",
	image = "the_investor_1",
	uniqueDialogueID = "an_eye_for_an_eye_4",
	text = _T("AN_EYE_FOR_AN_EYE_4_1", "Huh, how interesting, a slander article. Looks like someone is hard at work in an attempt to ruin your reputation."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_4_3",
	id = "an_eye_for_an_eye_4_2",
	text = _T("AN_EYE_FOR_AN_EYE_4_2", "You know, it's all too convenient. Not too long ago the CEO of 'COMPANY' got all dramatic, and now here we've got a slander article. Let me think this through..."),
	getText = function(self, dialogueObject)
		return _format(self.text, "COMPANY", rivalGameCompanies.registeredByID.rival_company_1.name)
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "an_eye_for_an_eye_4_3",
	text = _T("AN_EYE_FOR_AN_EYE_4_3", "Alright, go about your business as you did before. If it really was him, he's not going to stop because he's out for revenge, he'll start slipping up here and there, and eventually we'll have a good enough case to take to court. Once that happens, he can kiss his reputation goodbye."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_5_2",
	id = "an_eye_for_an_eye_5_1",
	image = "the_investor_1",
	uniqueDialogueID = "an_eye_for_an_eye_5",
	text = _T("AN_EYE_FOR_AN_EYE_5_1", "That snake, we finally got him! Alright, we've got a good enough case to take him to court. This is getting exciting!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "an_eye_for_an_eye_5_2",
	text = _T("AN_EYE_FOR_AN_EYE_5_2", "Give him a call and tell him to get ready for court, and don't back down to any of his sweet-talking. He's a snake first and foremost."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_6_2",
	id = "an_eye_for_an_eye_6_1",
	image = "the_investor_1",
	uniqueDialogueID = "an_eye_for_an_eye_6",
	text = _T("AN_EYE_FOR_AN_EYE_6_1", "And there you have it, one less rival to worry about. This doesn't mean that you're in the clear, it just means that guy won't be trying to mess with you again. In fact, I bet he's actually going to go bankrupt, and when that happens, the majority of his employees will be looking for work, if you know what I mean."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_6_3",
	id = "an_eye_for_an_eye_6_2",
	image = "the_investor_1",
	text = _T("AN_EYE_FOR_AN_EYE_6_2", "Well, with all of this said and done this is where we part ways. You've come a long way and have definitely shown me that you're more than capable of running a game development studio."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "an_eye_for_an_eye_6_3",
	image = "the_investor_1",
	text = _T("AN_EYE_FOR_AN_EYE_6_3", "If you wish to continue advancing your studio, feel free to. And consider it your own! But if I were you I'd look for a new adventure, you know what I mean?"),
	answers = {
		"an_eye_for_an_eye_final_answer_1"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "an_eye_for_an_eye_6_5",
	id = "an_eye_for_an_eye_6_4",
	text = _T("AN_EYE_FOR_AN_EYE_6_4", "Don't mention it, you were the right choice in the end, you know? Relatively speaking I'd say you managed to build an empire, but that's a bit far-fetched, haha!"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "an_eye_for_an_eye_6_5",
	spoolCooldown = 1,
	text = _T("AN_EYE_FOR_AN_EYE_6_5", "You and I, business partner, we had a good run. Good luck to you in your future endeavors."),
	answers = {
		"an_eye_for_an_eye_final_answer_2"
	}
})
dialogueHandler.registerAnswer({
	id = "an_eye_for_an_eye_final_answer_1",
	question = "an_eye_for_an_eye_6_4",
	text = _T("AN_EYE_FOR_AN_EYE_FINAL_ANSWER_1", "It sure was a good time. Thanks for having faith in me.")
})
dialogueHandler.registerAnswer({
	id = "an_eye_for_an_eye_final_answer_2",
	text = _T("AN_EYE_FOR_AN_EYE_FINAL_ANSWER_2", "See you, big guy.")
})
