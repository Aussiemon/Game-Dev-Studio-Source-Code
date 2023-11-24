local payDenbts = {}

payDenbts.id = "scenario_pay_denbts"
payDenbts.trackCompletion = true
payDenbts.name = _T("SCENARIO_2_NAME", "Pay Debts")
payDenbts.display = _T("SCENARIO_2", "Scenario - Pay Debts")
payDenbts.description = _T("SCENARIO_2_DESCRIPTION", "As the CEO replacement of a company that's knee-deep in debt, your objective is to pay off a debt of $DEBT within 20 years.\n\nThere will be 3 other rivals.")
payDenbts.objectiveList = {
	"pay_denbts"
}
payDenbts.startMoney = 800000
payDenbts.moneyToPayOff = 50000000
payDenbts.startTime = {
	year = 1995,
	month = 5
}
payDenbts.yearLimit = timeline.DAYS_IN_YEAR * 20
payDenbts.startingGeneratedEngines = 6
payDenbts.orderWeight = 20
payDenbts.startingSkillLevel = 30
payDenbts.achievementOnFinish = achievements.ENUM.PAY_DEBTS
payDenbts.startingGenres = {
	"fighting",
	"horror",
	"strategy"
}
payDenbts.startingThemes = {
	"bizarre",
	"urban"
}
payDenbts.headerText = _T("PAY_DENBTS_RECOMMENDATION", "Recommended after 'Back in the Game'!")
payDenbts.startingEngineName = _T("PAY_DENBTS_STARTING_ENGINE_NAME", "ABC Engine 1.0")

local hireTime = {
	year = {
		1991,
		1993
	},
	month = {
		1,
		12
	}
}

payDenbts.startingEmployees = {
	{
		role = "software_engineer",
		repeatFor = 2,
		level = {
			3,
			5
		},
		hireTime = hireTime
	},
	{
		role = "software_engineer",
		level = 6,
		hireTime = hireTime
	},
	{
		role = "designer",
		level = 4,
		hireTime = hireTime
	},
	{
		role = "manager",
		level = 4,
		hireTime = hireTime
	},
	{
		role = "sound_engineer",
		level = 5,
		hireTime = hireTime
	},
	{
		role = "artist",
		level = 4,
		hireTime = hireTime
	}
}
payDenbts.map = "pay_denbts"
payDenbts.unlockTechAtStartTime = true
payDenbts.rivals = {
	"pay_denbts_1",
	"pay_denbts_2",
	"pay_denbts_3"
}
payDenbts.rivalBuildings = {
	pay_denbts_3 = "pay_denbts_office_4",
	pay_denbts_2 = "pay_denbts_office_3",
	pay_denbts_1 = {
		"pay_denbts_office_2",
		"pay_denbts_office_5"
	}
}
payDenbts.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}

function payDenbts:formatDescription()
	return string.easyformatbykeys(self.description, "DEBT", string.comma(self.moneyToPayOff))
end

game.registerGameType(payDenbts, "scenario_back_in_the_game")
