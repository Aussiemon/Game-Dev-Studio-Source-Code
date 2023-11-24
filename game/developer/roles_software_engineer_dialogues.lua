dialogueHandler.registerQuestion({
	nextQuestion = "mmo_capacity_warning_2",
	id = "mmo_capacity_warning_1",
	text = _T("MMO_CAPACITY_WARNING_1", "Boss, are you sure you want to release 'GAME' with our servers CAPACITY% in use? If a lot of people buy the game and start playing, our servers could become overloaded, and if that happens, people would experience all sorts of issues, ranging from long log-in times, to laggy game servers. Long story short, it'd make for an uncomfortable gameplay experience, and people would be left pretty irritated."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		local gameObj = dialogueObject:getFact("game")
		
		return _format(self.text, "GAME", gameObj:getName(), "CAPACITY", math.round(gameObj:getOwner():getServerUsePercentage() * 100))
	end
})
dialogueHandler.registerQuestion({
	id = "mmo_capacity_warning_2",
	text = _T("MMO_CAPACITY_WARNING_2", "If you ask me, it'd be a good idea to expand on the capacity of our servers before we release the game. So either purchasing new server racks, or renting them out would be a good thing to do."),
	answers = {
		"mmo_capacity_warning_finish"
	}
})
dialogueHandler.registerAnswer({
	id = "mmo_capacity_warning_finish",
	text = _T("MMO_CAPACITY_WARNING_FINISH", "Alright, thanks for the heads-up.")
})
dialogueHandler.registerQuestion({
	nextQuestion = "mmo_ddos_2",
	id = "mmo_ddos_1",
	text = _T("MMO_DDOS_DIALOGUE_1", "Boss, our game servers for 'GAME' are under a DDoS attack, short for distributed denial of service. What this means is our servers are being flooded with traffic and it's adding extra load to our servers."),
	answers = {
		"mmo_ddos_answer_1"
	},
	getText = function(self, dialogueObject)
		local gameObj = dialogueObject:getFact("game")
		
		return _format(self.text, "GAME", gameObj:getName())
	end
})
dialogueHandler.registerQuestion({
	id = "mmo_ddos_2",
	text = _T("MMO_DDOS_DIALOGUE_2", "No, these attacks come from multiple sources, so it's impossible to filter them all out. We'll just have to grit our teeth and wait for the attack to be over."),
	answers = {
		"mmo_capacity_warning_finish"
	}
})
dialogueHandler.registerAnswer({
	id = "mmo_ddos_answer_1",
	text = _T("MMO_DDOS_ANSWER_1", "Can we stop this?")
})
dialogueHandler.registerQuestion({
	nextQuestion = "mmo_servers_overloaded_2",
	id = "mmo_servers_overloaded_1",
	text = _T("MMO_SERVERS_OVERLOADED_1", "Boss, our game servers are overloaded. This causes all sorts of issues, ranging from long log-in times, to laggy gameplay. All in all, our players aren't going to be happy about this."),
	answers = {
		"mmo_servers_overloaded_answer_1"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "mmo_servers_overloaded_3",
	id = "mmo_servers_overloaded_2",
	text = _T("MMO_SERVERS_OVERLOADED_2", "Expand our servers. We can purchase server racks and place them into our property, but that will take up space that could have been used for other things. Alternatively, we could rent them out. They would use up no office space, but the rent itself would cost money."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "mmo_servers_overloaded_3",
	text = _T("MMO_SERVERS_OVERLOADED_3", "Keep in mind that, the more complex our MMO game projects are, the more servers we'll need to keep it running smoothly, and the higher the server load is, the higher our expenses are."),
	answers = {
		"mmo_capacity_warning_finish"
	}
})
dialogueHandler.registerAnswer({
	id = "mmo_servers_overloaded_answer_1",
	text = _T("MMO_SERVERS_OVERLOADED_ANSWER_1", "What can we do to fix this?")
})
dialogueHandler.registerQuestion({
	nextQuestion = "mmo_database_corruption_2",
	id = "mmo_database_corruption_1",
	text = _T("MMO_DATABASE_CORRUPTION_1", "Uh, boss, you won't believe what just happened."),
	answers = {
		"mmo_database_corrupt_answer_1"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "mmo_database_corruption_3",
	id = "mmo_database_corruption_2",
	text = _T("MMO_DATABASE_CORRUPTION_2", "The database for our 'GAME' MMO got corrupted, and about AMOUNT players lost all their progress. I don't think I have to tell you what that means for us."),
	answers = {
		"mmo_database_corrupt_answer_2"
	},
	getText = function(self, dialogueObject)
		local gameObj = dialogueObject:getFact("game")
		local logic = gameObj.mmoLogic
		
		return _format(self.text, "GAME", gameObj:getName(), "AMOUNT", string.comma(math.ceil(math.min(logic:getSubscribers(), dialogueObject:getFact("subs")) / 10000) * 10000 * 2))
	end
})
dialogueHandler.registerQuestion({
	nextQuestion = "mmo_database_corruption_4",
	id = "mmo_database_corruption_3",
	text = _T("MMO_DATABASE_CORRUPTION_3", "Well, the affected people and their friends are obviously going to be angry, which means the overall satisfaction with the game is going to take a hit, and those affected are likely to unsubscribe from the game. Additionally, you can bet that our customer support services are going to be under much heavier load for the time being, so you'll have to make sure they're not overloaded."),
	answers = {
		"mmo_database_corrupt_answer_3"
	}
})
dialogueHandler.registerQuestion({
	id = "mmo_database_corruption_4",
	text = _T("MMO_DATABASE_CORRUPTION_4", "Not entirely, especially if it happens due to hardware failure. However, the more complex our game servers are, the higher the chance is of such things occuring. In other words, if we want to minimize the risk of this occuring, we should keep the server complexity low. On the flip side of the coin, the more complex our MMOs are, the more people are willing to pay for the monthly subscription fee, so we'll have to find the right balance."),
	answers = {
		"mmo_database_corrupt_answer_4"
	}
})
dialogueHandler.registerAnswer({
	id = "mmo_database_corrupt_answer_1",
	text = _T("MMO_DATABASE_CORRUPT_ANSWER_1", "What's up?")
})
dialogueHandler.registerAnswer({
	id = "mmo_database_corrupt_answer_2",
	text = _T("MMO_DATABASE_CORRUPT_ANSWER_2", "So, what happens now?")
})
dialogueHandler.registerAnswer({
	id = "mmo_database_corrupt_answer_3",
	text = _T("MMO_DATABASE_CORRUPT_ANSWER_3", "Can we stop this from happening again?")
})
dialogueHandler.registerAnswer({
	id = "mmo_database_corrupt_answer_4",
	text = _T("MMO_DATABASE_CORRUPT_ANSWER_4", "Alright, let's just hope it doesn't happen again.")
})
