platforms:registerNew({
	manufacturer = "pineapple",
	defaultAttractiveness = 100,
	quad = "platform_pphone",
	licenseCost = 1000,
	maxProjectScale = 4,
	developmentTimeAffector = 0.7,
	cutPerSale = 0.3,
	frustrationMultiplier = 0.4,
	id = "pineapple_phone_1",
	startingSharePercentage = 0.025,
	display = _T("PINEAPPLE_PHONE_1", "pPhone"),
	releaseDate = {
		year = 2007,
		month = 6
	},
	releaseText = _T("PINEAPPLE_POS_RELEASE_TEXT", "Pineapple has released their new mobile device 'pPhone' featuring a touch-screen running on their new 'pOS' operating system. With the specifications not even close to that of a gaming console, this phone will most likely only adopt the casual game market."),
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	engineFeatureRequirements = {
		"pineapple_phone_1_support"
	},
	genreMatching = {
		fighting = 1,
		racing = 1,
		action = 1,
		sandbox = 1,
		strategy = 1,
		simulation = 0.5,
		horror = 1,
		adventure = 1,
		rpg = 1
	}
})
taskTypes:registerNew({
	workAmount = 100,
	platformID = "pineapple_phone_1",
	id = "pineapple_phone_1_support",
	minimumLevel = 25,
	display = _T("PINEAPPLE_PHONE_1_SUPPORT", "'pPhone' support")
}, nil, "polystation_1_support")
