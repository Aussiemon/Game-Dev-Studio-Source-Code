dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_1_1",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_1_1", "Hey boss, long time no see."),
	answers = {
		"ravioli_and_pepperoni_coworker_answer_1_1"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_1_2",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_1_2", "Not too bad, though I do miss working with the other guys. 'Paxis' being disbanded so quickly wasn't an easy pill to swallow, you know? I miss the old days when we'd make great games with little-to-no corporate interest involved. I got sick of all games being made purely for profit, so I've decided to join your studio now that you have some things going."),
	answers = {
		"ravioli_and_pepperoni_coworker_more_info",
		"ravioli_and_pepperoni_coworker_accept",
		"ravioli_and_pepperoni_coworker_refuse"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_1_3",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_1_3", "Really? Well that's a shame. I was hoping I'd get to work with you again. If you change your mind, I'll be on the lookout for your job offer for some time."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerAnswer({
	id = "ravioli_and_pepperoni_coworker_answer_1_1",
	question = "ravioli_and_pepperoni_coworker_1_2",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_ANSWER_1_1", "NAME! How have you been?"),
	getText = function(self, dialogueObject)
		return _format(self.text, "NAME", dialogueObject:getEmployee():getName())
	end
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_2_1",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_2_1", "Hey there, heard you started your own company."),
	answers = {
		"ravioli_and_pepperoni_coworker_answer_2_1"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_2_2",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_2_2", "Honestly? I miss the days when all we did was make good games. The guys in suits over at 'Arts of Electrics' are running innovation and interesting things into the ground. Not much soul in games that are made to score a big buck, you know? As far as I'm concerned I'm better off working with you guys instead of working on games I have no interest in."),
	answers = {
		"ravioli_and_pepperoni_coworker_more_info",
		"ravioli_and_pepperoni_coworker_accept",
		"ravioli_and_pepperoni_coworker_refuse"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_2_3",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_2_3", "A shame. I'm sick of working on the stuff they make, so if you change your mind - let me know, I'll be on the lookout for your job offer."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerAnswer({
	id = "ravioli_and_pepperoni_coworker_answer_2_1",
	question = "ravioli_and_pepperoni_coworker_2_2",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_ANSWER_2_1", "Nice of you to visit, how are things?")
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_3_1",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_3_1", "Knock knock! Who's there? Long time no see!"),
	answers = {
		"ravioli_and_pepperoni_coworker_answer_3_1"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_3_2",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_3_2", "Pretty good, though work got super stale, especially since some of the newest projects the suits over at 'Arts of Electrics' started recently are without any kind of soul. You know, you've been doing quite good on your own so far, under your leadership I'm sure we could put out some quality stuff again. What do you say, is there a spot in your studio for the likes of I?"),
	answers = {
		"ravioli_and_pepperoni_coworker_more_info",
		"ravioli_and_pepperoni_coworker_accept",
		"ravioli_and_pepperoni_coworker_refuse"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_3_3",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_3_3", "Aaah well, maybe next time. And I mean that, literally. If you change your mind - hit me up, I'll be on the lookout for your job offer."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerAnswer({
	id = "ravioli_and_pepperoni_coworker_answer_3_1",
	question = "ravioli_and_pepperoni_coworker_3_2",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_ANSWER_3_1", "Hey! Glad you came by, how've you been?")
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_4_1",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_4_1", "Hey boss, I see you're all set up in here."),
	answers = {
		"ravioli_and_pepperoni_coworker_answer_4_1"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_4_2",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_4_2", "Eh, I miss the what our team used to be. Nowadays it's all corporate guys trying to make the biggest profit possible. Don't get me wrong, I still enjoy making sound effects, but the stuff they go into is lacking so much soul. That's also why I'm here, I was thinking hey, maybe I could join your team? That'd beat working at 'Arts of Electrics' for sure."),
	answers = {
		"ravioli_and_pepperoni_coworker_more_info",
		"ravioli_and_pepperoni_coworker_accept",
		"ravioli_and_pepperoni_coworker_refuse"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_4_3",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_4_3", "Alright. I've left their studio and am on the lookout for a job elsewhere, so if you change your mind - I'll be waiting for your job offer."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerAnswer({
	id = "ravioli_and_pepperoni_coworker_answer_4_1",
	question = "ravioli_and_pepperoni_coworker_4_2",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_ANSWER_4_1", "Look who it is, come in! How are things?")
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_5_1",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_5_1", "Hey there! Nice studio you've got, old friend."),
	answers = {
		"ravioli_and_pepperoni_coworker_answer_5_1"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_5_2",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_5_2", "Real nice. Though I'm exhausted of working over at 'Arts of Electrics' for so much time, so I'm on the lookout for a new job. Which is also why I came here, haha! I miss the days when we made games that we genuinely enjoyed playing, so seeing as that's what you're doing with your own teams, any chance I could get a spot here?"),
	answers = {
		"ravioli_and_pepperoni_coworker_more_info",
		"ravioli_and_pepperoni_coworker_accept",
		"ravioli_and_pepperoni_coworker_refuse"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_5_3",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_5_3", "Aw, what a shame. If you change your mind - be sure to let me know, I'll come join you guys real quick."),
	answers = {
		"end_conversation"
	}
})
dialogueHandler.registerQuestion({
	id = "ravioli_and_pepperoni_coworker_decision",
	uniqueDialogueID = "pay_denbts_1",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_DECISION", "[...]"),
	answers = {
		"ravioli_and_pepperoni_coworker_more_info",
		"ravioli_and_pepperoni_coworker_accept",
		"ravioli_and_pepperoni_coworker_refuse"
	}
})
dialogueHandler.registerAnswer({
	id = "ravioli_and_pepperoni_coworker_answer_5_1",
	question = "ravioli_and_pepperoni_coworker_5_2",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_ANSWER_5_1", "Hey, come on in! How've you been?")
})
dialogueHandler.registerAnswer({
	id = "ravioli_and_pepperoni_coworker_accept",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_ACCEPT", "Welcome back to the team! [HIRE]"),
	onPick = function(self, dialogueObject)
		studio:hireEmployee(dialogueObject:getEmployee())
	end
})
dialogueHandler.registerAnswer({
	timeToDisappear = 60,
	id = "ravioli_and_pepperoni_coworker_refuse",
	text = _T("RAVIOLI_AND_PEPPERONI_COWORKER_REFUSE_1", "Sorry, this isn't a good time. [REFUSE]"),
	onPick = function(self, dialogueObject)
		employeeCirculation:addJobSeeker(dialogueObject:getEmployee(), self.timeToDisappear)
	end,
	getNextQuestion = function(self, dialogueObject)
		return dialogueObject:getFact("question_id")
	end
})
dialogueHandler.registerAnswer({
	question = "ravioli_and_pepperoni_coworker_decision",
	id = "ravioli_and_pepperoni_coworker_more_info",
	text = _T("FAN_WANTS_TO_WORK_MORE_INFO", "[OPEN EMPLOYEE INFO MENU]"),
	returnText = _T("RAVIOLI_AND_PEPPERONI_COWORKER_MORE_INFO_RETURN", "[...]"),
	onPick = function(self, dialogueObject)
		dialogueHandler:hide()
		
		local employee = dialogueObject:getEmployee()
		
		employee:createEmployeeMenu("FanOfferFrame")
	end
})
