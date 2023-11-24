local raviPeppi = {}

raviPeppi.id = "scenario_ravioli_and_pepperoni"
raviPeppi.trackCompletion = true
raviPeppi.name = _T("SCENARIO_3_NAME", "Ravioli & Pepperoni")
raviPeppi.display = _T("SCENARIO_3", "Scenario - Ravioli & Pepperoni")
raviPeppi.description = _T("SCENARIO_3_DESCRIPTION", "Having been a subsidiary of \"Arts of Electrics\" for years, your studio has been disbanded, and you have been fired after the latest game you were in charge of failed to meet the financial expectations of the publisher. You've decided to start your own company, starting out in a small office with $MONEY in bank.\n\nYour objective is to take revenge on the game developer giant that is \"Art of Electrics\" and make sure they go under.")
raviPeppi.objectiveList = {
	"ravioli_and_pepperoni",
	"ravioli_and_pepperoni_finish"
}
raviPeppi.startMoney = 350000
raviPeppi.moneyToPayOff = 50000000
raviPeppi.startTime = {
	year = 1995,
	month = 5
}
raviPeppi.startingGeneratedEngines = 6
raviPeppi.orderWeight = 25
raviPeppi.startingReputation = 2500
raviPeppi.startingSkillLevel = 40
raviPeppi.achievementOnFinish = achievements.ENUM.RAVIOLI_AND_PEPPERONI
raviPeppi.startingGenres = {
	"fighting",
	"horror",
	"strategy"
}
raviPeppi.startingThemes = {
	"bizarre",
	"urban"
}
raviPeppi.headerText = _T("RAVIOLI_AND_PEPPERONI_RECOMMENDATION", "Recommended after 'Pay Debts'!")
raviPeppi.startingEngineName = false
raviPeppi.startingEmployees = {}
raviPeppi.map = "ravioli_and_pepperoni"
raviPeppi.unlockTechAtStartTime = true
raviPeppi.targetRival = "ravioli_and_pepperoni_1"
raviPeppi.rivals = {
	raviPeppi.targetRival
}
raviPeppi.rivalBuildings = {
	ravioli_and_pepperoni_1 = {
		"ravioli_and_pepperoni_1",
		"ravioli_and_pepperoni_2"
	}
}
raviPeppi.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}

function raviPeppi:formatDescription()
	return string.easyformatbykeys(self.description, "MONEY", string.comma(self.startMoney))
end

game.registerGameType(raviPeppi, "scenario_back_in_the_game")
