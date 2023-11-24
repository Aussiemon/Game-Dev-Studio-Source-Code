dialogueHandler.registerQuestion({
	id = "theme_cooldown_start",
	text = _T("THEME_DESIGN_COOLDOWN", "Hey boss, I'm kind of burned out when it comes to game theme design. Let's try that in a few months."),
	answers = {
		"theme_cooldown_inquire",
		"theme_cooldown_insist",
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "theme_cooldown_explanation",
	text = _T("THEME_COOLDOWN_EXPLANATION", "Don't get me wrong, I'm not tired or anything like that, I simply need to do more research, read more design documents, play more games in my free time before I try to come up with anything, you know? It's like writer's block, except I'd do a really poor job if I'd try to come up with a new game theme without a fresh mind."),
	answers = {
		"theme_cooldown_what_can_i_do",
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "theme_cooldown_suggestion",
	text = _T("THEME_COOLDOWN_SUGGESTION", "Nothing that would make me come up with more stuff right away, no. If you're in a hurry you can hire another Designer, that way one of us would be in charge of coming up with game themes and the other would design new game genres."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "theme_cooldown_insist",
	text = _T("THEME_COOLDOWN_INSIST_QUESTION", "Alright, I'll do my best, but it'll take me a lot more time than if my head was fresh."),
	answers = {
		"end_conversation_ok"
	}
})
dialogueHandler.registerAnswer({
	question = "theme_cooldown_insist",
	id = "theme_cooldown_insist",
	text = _T("THEME_COOLDOWN_INSIST_ANSWER", "You'll have to try. [BEGIN SLOW RESEARCH]"),
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		local roleData = attributes.profiler:getRoleData(employee:getRole())
		
		roleData:beginThemeDesign(employee)
	end
})
dialogueHandler.registerAnswer({
	id = "theme_cooldown_inquire",
	question = "theme_cooldown_explanation",
	text = _T("THEME_COOLDOWN_INQUIRE", "How come you can't design another theme right now?")
})
dialogueHandler.registerAnswer({
	id = "theme_cooldown_what_can_i_do",
	question = "theme_cooldown_suggestion",
	text = _T("THEME_COOLDOWN_WHAT_CAN_I_DO", "Is there anything I can do about these 'design blocks'?")
})
dialogueHandler.registerQuestion({
	id = "genre_cooldown_start",
	text = _T("GENRE_DESIGN_COOLDOWN", "I don't think I'd be able to come up with a new genre this soon, give me a few months to refresh my mind."),
	answers = {
		"genre_cooldown_inquire",
		"genre_cooldown_insist",
		"end_conversation_ok"
	}
})
dialogueHandler.registerQuestion({
	id = "genre_cooldown_explanation",
	text = _T("GENRE_COOLDOWN_EXPLANATION", "I'm simply burned out for now. I mean, I'd love to come up with more stuff right away, but as it is, at the moment, I am simply out of ideas. Give me some time, I'll read up on game design, play a few games and will have a fresh mind for this stuff."),
	answers = {
		"genre_cooldown_what_can_i_do",
		"end_conversation_ok"
	}
})
dialogueHandler.registerQuestion({
	id = "genre_cooldown_suggestion",
	text = _T("GENRE_COOLDOWN_SUGGESTION", "Coming up with an entire game genre with gameplay mechanics that work well is no easy task, so, no. However, you can always hire more Designers and let them come up with new game themes and genres while I'm cooling off."),
	answers = {
		"end_conversation_ok"
	}
})
dialogueHandler.registerQuestion({
	id = "genre_cooldown_insist",
	text = _T("GENRE_COOLDOWN_INSIST_QUESTION", "Alright, I'll do my best, but it'll take me a lot more time than if my head was fresh."),
	answers = {
		"end_conversation_ok"
	}
})
dialogueHandler.registerQuestion({
	id = "cant_design_themes_genres_no_workplace",
	text = _T("CANT_DESIGN_THEMES_GENRES_NO_WORKPLACE", "Sorry boss, but I can't design any new genres or themes without a workplace."),
	answers = {
		"end_conversation_ok"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "designer_subgenre_2",
	id = "designer_subgenre_1",
	text = _T("DESIGNER_SUBGENRE_1", "Hey boss, we've been designing new genres lately, and I thought to myself: why not mix two genres together in one game?"),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "designer_subgenre_3",
	id = "designer_subgenre_2",
	text = _T("DESIGNER_SUBGENRE_2", "Having a subgenre that fits well with the game's main genre would for sure make it more appealing to people, and would generally make for a more fun game. It would no doubt add some extra work, but if we pick two genres that complement each other, we'd see more sales."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "designer_subgenre_3",
	text = _T("DESIGNER_SUBGENRE_3", "Give it some thought, with the amount of genres we've got under our belt I'm sure we could come up with something that a large audience would love."),
	answers = {
		"designer_subgenre_1"
	}
})
dialogueHandler.registerAnswer({
	question = "genre_cooldown_insist",
	id = "genre_cooldown_insist",
	text = _T("GENRE_COOLDOWN_INSIST_ANSWER", "You'll have to try. [BEGIN SLOW RESEARCH]"),
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		local roleData = attributes.profiler:getRoleData(employee:getRole())
		
		roleData:beginGenreDesign(employee)
	end
})
dialogueHandler.registerAnswer({
	id = "genre_cooldown_inquire",
	question = "genre_cooldown_explanation",
	text = _T("GENRE_COOLDOWN_INQUIRE", "How come you can't come up with another game genre right now?")
})
dialogueHandler.registerAnswer({
	id = "genre_cooldown_what_can_i_do",
	question = "genre_cooldown_suggestion",
	text = _T("GENRE_COOLDOWN_WHAT_CAN_I_DO", "Is there anything I can do to help you get around this?")
})
dialogueHandler.registerAnswer({
	id = "designer_subgenre_1",
	text = _T("DESIGNER_SUBGENRE_ANSWER_1", "Great work.")
})
