contractWork.registerContractor({
	minimumReputation = 50000,
	preferGenreRating = 7,
	overallDevelopmentTimeMultiplier = 1,
	skillValueForScale = 100,
	minShareRating = 7,
	minimumEmployees = 35,
	coverFunding = 1.5,
	avoidGenreRating = 5,
	returnFundingAmount = 0.75,
	logo = "publisher_uhq",
	id = "publisher1",
	maxShareRating = 8.5,
	display = _T("PUBLISHER_1_NAME", "UHQ"),
	minimumGameCost = gameProject.PRICE_POINTS[3],
	monthlyFunding = {
		perPerson = 1000,
		perRating = 1000,
		yearMultiplier = 0.1,
		scaleMultiplier = 8000
	},
	instantCash = {
		ratingPoint = 30000,
		yearMultiplier = 0.1,
		scaleMultiplier = 0.3
	},
	advertisement = {
		gainPerScalePoint = 300,
		baseWeeklyGain = 750,
		gainPerMinimumRating = 20
	},
	publishing = {
		minimumReputation = 60000,
		advertisementCostMin = 250,
		maximumReputation = 100000,
		minShare = 0.07,
		minimumGameScale = 6,
		maxShare = 0.15,
		minReputationAdvert = 0.5,
		minAdvertisement = 0.2,
		popularityGainMax = 500,
		maxAdvertAtGameScale = 16,
		popularityGainMin = 25,
		advertisementCostMax = 5000,
		noGoRating = 6,
		maxEvaluationRange = timeline.DAYS_IN_YEAR * 5
	},
	extraScale = {
		max = 5,
		min = 3
	},
	shareBoundaries = {
		max = 0.1,
		min = 0.05
	},
	targetRating = {
		max = 9,
		min = 7
	}
})
contractWork.registerContractor({
	minimumReputation = 20000,
	maximumReputation = 60000,
	overallDevelopmentTimeMultiplier = 0.8,
	preferGenreRating = 6,
	skillValueForScale = 100,
	minShareRating = 6,
	avoidGenreRating = 5,
	coverFunding = 2,
	returnFundingAmount = 0.5,
	logo = "publisher_shabbysoft",
	minimumEmployees = 15,
	id = "publisher2",
	scalePerEmployee = 0.3,
	maxShareRating = 9,
	display = _T("PUBLISHER_2_NAME", "Shabbysoft"),
	minimumGameCost = gameProject.PRICE_POINTS[2],
	monthlyFunding = {
		perPerson = 1500,
		perRating = 2000,
		yearMultiplier = 0.1,
		scaleMultiplier = 4000
	},
	instantCash = {
		ratingPoint = 25000,
		yearMultiplier = 0.05,
		scaleMultiplier = 0.25
	},
	advertisement = {
		gainPerScalePoint = 250,
		baseWeeklyGain = 500,
		gainPerMinimumRating = 15
	},
	publishing = {
		minimumReputation = 6500,
		advertisementCostMin = 150,
		maximumReputation = 30000,
		minShare = 0.1,
		minimumGameScale = 4,
		maxShare = 0.2,
		minReputationAdvert = 0.5,
		minAdvertisement = 0.25,
		popularityGainMax = 250,
		maxAdvertAtGameScale = 14,
		popularityGainMin = 15,
		advertisementCostMax = 2500,
		noGoRating = 7,
		maxEvaluationRange = timeline.DAYS_IN_YEAR * 5
	},
	extraScale = {
		max = 3,
		min = 2
	},
	shareBoundaries = {
		max = 0.13,
		min = 0.04
	},
	targetRating = {
		max = 9,
		min = 6
	}
})
contractWork.registerContractor({
	minimumReputation = 1500,
	maximumReputation = 40000,
	overallDevelopmentTimeMultiplier = 1.1,
	preferGenreRating = 6,
	skillValueForScale = 120,
	minShareRating = 6,
	avoidGenreRating = 5,
	coverFunding = 1.25,
	returnFundingAmount = 0.75,
	logo = "publisher_game_advance",
	minimumEmployees = 5,
	id = "publisher3",
	scalePerEmployee = 0.33,
	maxShareRating = 9,
	display = _T("PUBLISHER_3_NAME", "Game Advance"),
	minimumGameCost = gameProject.PRICE_POINTS[1],
	monthlyFunding = {
		perPerson = 500,
		perRating = 700,
		yearMultiplier = 0.025,
		scaleMultiplier = 2000
	},
	instantCash = {
		ratingPoint = 8000,
		yearMultiplier = 0,
		scaleMultiplier = 0.1
	},
	advertisement = {
		gainPerScalePoint = 100,
		baseWeeklyGain = 200,
		gainPerMinimumRating = 10
	},
	publishing = {
		minimumReputation = 2000,
		advertisementCostMin = 50,
		maximumReputation = 15000,
		minShare = 0.2,
		minimumGameScale = 2,
		maxShare = 0.3,
		minReputationAdvert = 0.5,
		minAdvertisement = 0.3,
		popularityGainMax = 100,
		maxAdvertAtGameScale = 10,
		popularityGainMin = 5,
		advertisementCostMax = 1000,
		noGoRating = 6.5,
		maxEvaluationRange = timeline.DAYS_IN_YEAR * 5
	},
	extraScale = {
		max = 1.5,
		min = 0
	},
	shareBoundaries = {
		max = 0.17,
		min = 0.1
	},
	targetRating = {
		max = 9,
		min = 6
	}
})
