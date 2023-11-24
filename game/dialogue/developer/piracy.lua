dialogueHandler.registerQuestion({
	nextQuestion = "piracy_explanation_2",
	id = "piracy_explanation_1",
	text = _T("PIRACY_DIALOGUE_EXPLANATION_1", "Boss, you might have noticed the piracy for 'GAME' is quite high at RATE%."),
	answers = {
		"piracy_explanation_continue"
	},
	getText = function(self, dialogueObject)
		local gameObj = dialogueObject:getFact("game")
		
		return _format(self.text, "GAME", gameObj:getName(), "RATE", gameObj:getNicePiracyPercentage(), 1)
	end
})
dialogueHandler.registerQuestion({
	id = "piracy_explanation_2",
	textNoDRM = _T("PIRACY_DIALOGUE_EXPLANATION_2_NO_DRM", "The first thing to do is to simply make better games. The Opinion level of the studio also affects how heavily our games are pirated. Lastly, adding DRM can delay piracy, but people might not be happy about its presence."),
	textDRM = _T("PIRACY_DIALOGUE_EXPLANATION_2_DRM", "The first thing to do is to simply make better games. The Opinion level of the studio also affects how heavily our games are pirated. Lastly, we already have DRM in 'GAME' so it did help in mitigating some piracy, but not all of it. Don't forget that people might not be happy about its presence."),
	answers = {
		"end_conversation_got_it"
	},
	getText = function(self, dialogueObject)
		local gameObj = dialogueObject:getFact("game")
		
		if gameObj:getDRMValue() > 0 then
			return _format(self.textDRM, "GAME", gameObj:getName())
		end
		
		return self.textNoDRM
	end
})
dialogueHandler.registerAnswer({
	id = "piracy_explanation_continue",
	text = _T("PIRACY_EXPLANATION_ANSWER_CONTINUE", "What can we do about this?")
})
