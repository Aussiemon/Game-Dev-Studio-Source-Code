rivalGameCompanies.registerNew({
	maximumEmployees = 87,
	startingReputation = 200000,
	angerLossPerDay = 0.33,
	threatToPlayerOnReputation = 120000,
	legalActionDialogue = "rival_company_legal_action_1",
	startingFunds = 100000000,
	playerLegalActionDialogue = "player_legal_action_1",
	initialCallDialogue = "call_ceo_rnp_initial",
	angerForLegalAction = 50,
	ceoLevel = 8,
	preBankruptBuyoutCostMultiplier = 30,
	legalActionReconsiderReputationDifference = 5000,
	intimidationOffset = -100,
	retaliationFactor = 0,
	maximumEmployeeSkillRange = 15,
	intimidationLossPerDay = 0.25,
	threatenDialogue = "rival_company_threaten_rnp_1",
	id = "ravioli_and_pepperoni_1",
	ceoSkillLevels = 60,
	name = _T("RIVAL_COMPANY_RAVIOLI_AND_PEPPERONI_1", "Arts of Electrics"),
	startingEmployees = {
		{
			repeatFor = 20,
			role = "software_engineer",
			level = {
				4,
				8
			}
		},
		{
			repeatFor = 6,
			role = "artist",
			level = {
				4,
				8
			}
		},
		{
			repeatFor = 3,
			role = "manager",
			level = {
				5,
				9
			}
		},
		{
			reeatFor = 4,
			role = "sound_engineer",
			level = {
				5,
				8
			}
		},
		{
			repeatFor = 4,
			role = "designer",
			level = {
				5,
				8
			}
		},
		{
			repeatFor = 3,
			role = "writer",
			level = {
				5,
				8
			}
		}
	},
	slander = {
		chancePerSuspicion = -1,
		chancePerIntimidation = -0.7,
		minimumAnger = 5,
		chance = 40,
		chancePerAnger = 0.5,
		cooldown = timeline.DAYS_IN_MONTH
	},
	minimumPrice = gameProject.PRICE_POINTS[1],
	maximumPrice = gameProject.PRICE_POINTS[12],
	maximumPlatformExpirationAge = timeline.DAYS_IN_MONTH * 2,
	employeeCirculation = {
		leaveTime = {
			timeline.DAYS_IN_MONTH * 6,
			timeline.DAYS_IN_YEAR * 10
		}
	},
	employeeStealing = {
		intimidationOnPlayerStealSuccess = 10,
		chance = 20,
		intimidationOnStealFail = 1,
		roundingSegment = 50,
		intimidationOnStealSuccess = -2,
		angerOnPlayerStealFail = 19,
		chancePerAnger = 0.8,
		minimumOfferedCash = 100,
		angerOnPlayerStealSuccess = 8,
		angerOnStealSuccess = -4,
		angerOnStealFail = -5,
		maximumOfferedCash = 400,
		extraCashPerCurrentSalary = 0.035,
		intimidationOnPlayerStealFail = 1,
		failStealEmployeeRelationshipChange = -5,
		chancePerIntimidation = -1,
		cooldown = timeline.DAYS_IN_MONTH * 4
	}
})
require("game/dialogue/scenarios/ravioli_and_pepperoni")
require("game/dialogue/scenarios/ravioli_and_pepperoni_coworkers")
require("game/dialogue/scenarios/ravioli_and_pepperoni_rival")
