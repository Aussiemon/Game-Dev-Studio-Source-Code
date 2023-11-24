dialogueHandler.registerQuestion({
	id = "developer_outdated_tech_start",
	text = _T("DEVELOPER_OUTDATED_TECH_START", "Hey boss, there's a lot of new cool tech coming out, but we have computers in our office that are outdated. It's impossible to work on such tech on computers that don't have the hardware for it."),
	answers = {
		"developer_outdated_tech_ok"
	}
})
dialogueHandler.registerAnswer({
	id = "developer_outdated_tech_ok",
	endDialogue = true,
	text = _T("DEVELOPER_OUTDATED_TECH_OK", "OK, I'll see what I can do.")
})
