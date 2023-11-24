rivalGameCompanies.registerNew({
	maximumEmployees = 51,
	startingReputation = 180000,
	angerLossPerDay = 0.5,
	threatToPlayerOnReputation = 120000,
	legalActionDialogue = "rival_company_legal_action_1",
	startingFunds = 100000000,
	playerLegalActionDialogue = "player_legal_action_1",
	angerForLegalAction = 50,
	ceoLevel = 4,
	preBankruptBuyoutCostMultiplier = 50,
	legalActionReconsiderReputationDifference = 5000,
	intimidationOffset = -100,
	retaliationFactor = 0,
	maximumEmployeeSkillRange = 15,
	intimidationLossPerDay = 0.25,
	threatenDialogue = "rival_company_threaten_1",
	id = "back_in_the_game_1",
	ceoSkillLevels = 60,
	name = _T("RIVAL_COMPANY_BACK_IN_THE_GAME_1", "Fishy Bytes"),
	startingEmployees = {
		{
			repeatFor = 12,
			role = "software_engineer",
			level = {
				4,
				6
			}
		},
		{
			repeatFor = 3,
			role = "artist",
			level = {
				4,
				6
			}
		},
		{
			role = "manager",
			level = 5
		},
		{
			role = "sound_engineer",
			level = 7
		},
		{
			repeatFor = 2,
			role = "designer",
			level = {
				5,
				6
			}
		},
		{
			role = "writer",
			level = 6
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
	maximumPrice = gameProject.PRICE_POINTS[10],
	maximumPlatformExpirationAge = timeline.DAYS_IN_MONTH * 2,
	employeeCirculation = {
		leaveTime = {
			timeline.DAYS_IN_MONTH * 6,
			timeline.DAYS_IN_YEAR * 5
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
rivalGameCompanies.registerNew({
	maximumEmployees = 23,
	startingReputation = 80000,
	angerLossPerDay = 0.5,
	threatToPlayerOnReputation = 60000,
	legalActionDialogue = "rival_company_legal_action_1",
	startingFunds = 30000000,
	playerLegalActionDialogue = "player_legal_action_1",
	angerForLegalAction = 50,
	ceoLevel = 4,
	preBankruptBuyoutCostMultiplier = 30,
	legalActionReconsiderReputationDifference = 4000,
	intimidationOffset = -80,
	retaliationFactor = 0,
	maximumEmployeeSkillRange = 15,
	intimidationLossPerDay = 0.25,
	threatenDialogue = "rival_company_threaten_1",
	id = "back_in_the_game_2",
	ceoSkillLevels = 60,
	name = _T("RIVAL_COMPANY_BACK_IN_THE_GAME_2", "Lever Corporation"),
	startingEmployees = {
		{
			repeatFor = 6,
			role = "software_engineer",
			level = {
				3,
				4
			}
		},
		{
			repeatFor = 2,
			role = "artist",
			level = {
				4,
				5
			}
		},
		{
			role = "manager",
			level = 2
		},
		{
			role = "sound_engineer",
			level = 5
		},
		{
			role = "designer",
			level = {
				4,
				5
			}
		},
		{
			role = "writer",
			level = 4
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
	maximumPrice = gameProject.PRICE_POINTS[10],
	maximumPlatformExpirationAge = timeline.DAYS_IN_MONTH * 2,
	employeeCirculation = {
		leaveTime = {
			timeline.DAYS_IN_MONTH * 6,
			timeline.DAYS_IN_YEAR * 5
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
rivalGameCompanies.registerNew({
	maximumEmployees = 16,
	startingReputation = 20000,
	angerLossPerDay = 0.5,
	angerForLegalAction = 50,
	legalActionDialogue = "rival_company_legal_action_1",
	startingFunds = 2000000,
	playerLegalActionDialogue = "player_legal_action_1",
	ceoLevel = 4,
	preBankruptBuyoutCostMultiplier = 7,
	legalActionReconsiderReputationDifference = 100,
	intimidationOffset = -50,
	retaliationFactor = 0,
	maximumEmployeeSkillRange = 15,
	intimidationLossPerDay = 0.25,
	threatenDialogue = "rival_company_2_threaten_1",
	id = "back_in_the_game_3",
	ceoSkillLevels = 60,
	name = _T("RIVAL_COMPANY_BACK_IN_THE_GAME_3", "5B Games"),
	startingEmployees = {
		{
			repeatFor = 5,
			role = "software_engineer",
			level = {
				3,
				4
			}
		},
		{
			repeatFor = 2,
			role = "artist",
			level = {
				4,
				5
			}
		},
		{
			role = "manager",
			level = 2
		},
		{
			role = "sound_engineer",
			level = 5
		},
		{
			role = "designer",
			level = {
				4,
				5
			}
		},
		{
			role = "writer",
			level = 4
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
	maximumPrice = gameProject.PRICE_POINTS[10],
	maximumPlatformExpirationAge = timeline.DAYS_IN_MONTH * 2,
	employeeCirculation = {
		leaveTime = {
			timeline.DAYS_IN_MONTH * 6,
			timeline.DAYS_IN_YEAR * 5
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
