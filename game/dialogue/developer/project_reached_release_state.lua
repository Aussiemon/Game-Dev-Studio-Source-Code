dialogueHandler.registerQuestion({
	id = "project_reached_release_state",
	text = _T("PROJECT_REACHED_RELEASE_STATE", "Hey boss, our 'PROJECT' game project is now ready to be released. We're currently polishing it, but this is optional, and we could release it as it is if we want to."),
	getText = function(self, dialogueObject)
		return string.easyformatbykeys(self.text, "PROJECT", dialogueObject:getFact("projectInQuestion"):getName())
	end,
	answers = {
		"project_reached_release_state_ok"
	}
})
dialogueHandler.registerAnswer({
	id = "project_reached_release_state_ok",
	endDialogue = true,
	text = _T("PROJECT_REACHED_RELEASE_STATE_OK", "Alright, thank you for the info.")
})
