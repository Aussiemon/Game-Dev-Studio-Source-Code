rivalGameCompanies.registerNew({
	maximumEmployees = 31,
	startingReputation = 100000,
	angerLossPerDay = 0.5,
	threatToPlayerOnReputation = 1500,
	angerForLegalAction = 50,
	startingFunds = 100000000,
	playerLegalActionDialogue = "player_legal_action_1",
	legalActionDialogue = "rival_company_legal_action_1",
	legalActionReconsiderReputationDifference = 100,
	maleCEO = true,
	preBankruptBuyoutCostMultiplier = 10,
	infiniteFunds = true,
	intimidationOffset = -100,
	retaliationFactor = 0,
	maximumEmployeeSkillRange = 15,
	ceoLevel = 4,
	intimidationLossPerDay = 0.25,
	threatenDialogue = "rival_company_threaten_1",
	id = "rival_company_1",
	ceoSkillLevels = 60,
	name = _T("RIVAL_COMPANY_1_NAME", "Bombastic Games"),
	startingEmployees = {
		{
			repeatFor = 12,
			role = "software_engineer",
			level = {
				3,
				4
			}
		},
		{
			repeatFor = 3,
			role = "artist",
			level = {
				4,
				5
			}
		},
		{
			role = "manager",
			level = 6
		},
		{
			repeatFor = 2,
			role = "sound_engineer",
			level = {
				5,
				6
			}
		},
		{
			repeatFor = 2,
			role = "designer",
			level = {
				5,
				7
			}
		},
		{
			repeatFor = 2,
			role = "writer",
			level = {
				4,
				6
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
	maximumEmployees = 68,
	startingReputation = 300000,
	angerLossPerDay = 0.5,
	threatToPlayerOnReputation = 200000,
	legalActionDialogue = "rival_company_legal_action_1",
	startingFunds = 200000000,
	playerLegalActionDialogue = "player_legal_action_1",
	angerForLegalAction = 50,
	ceoLevel = 4,
	preBankruptBuyoutCostMultiplier = 20,
	legalActionReconsiderReputationDifference = 100,
	intimidationOffset = -100,
	retaliationFactor = 0,
	maximumEmployeeSkillRange = 15,
	intimidationLossPerDay = 0.25,
	threatenDialogue = "rival_company_2_threaten_1",
	id = "rival_company_2",
	ceoSkillLevels = 60,
	name = _T("RIVAL_COMPANY_2_NAME", "idea! Entertainment"),
	startingEmployees = {
		{
			repeatFor = 25,
			role = "software_engineer",
			level = {
				4,
				8
			}
		},
		{
			repeatFor = 5,
			role = "artist",
			level = {
				4,
				5
			}
		},
		{
			repeatFor = 2,
			role = "manager",
			level = 6
		},
		{
			repeatFor = 2,
			role = "sound_engineer",
			level = {
				5,
				7
			}
		},
		{
			repeatFor = 4,
			role = "designer",
			level = {
				4,
				7
			}
		},
		{
			repeatFor = 2,
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
	maximumEmployees = 22,
	startingReputation = 100000,
	angerLossPerDay = 0.5,
	threatToPlayerOnReputation = 100000,
	legalActionDialogue = "rival_company_legal_action_1",
	startingFunds = 50000000,
	playerLegalActionDialogue = "player_legal_action_1",
	angerForLegalAction = 50,
	ceoLevel = 4,
	preBankruptBuyoutCostMultiplier = 15,
	legalActionReconsiderReputationDifference = 100,
	intimidationOffset = -100,
	retaliationFactor = 0,
	maximumEmployeeSkillRange = 15,
	intimidationLossPerDay = 0.25,
	threatenDialogue = "rival_company_threaten_1",
	id = "rival_company_3",
	ceoSkillLevels = 60,
	name = _T("RIVAL_COMPANY_3_NAME", "Sips' Games"),
	startingEmployees = {
		{
			repeatFor = 10,
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
			level = 5
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
