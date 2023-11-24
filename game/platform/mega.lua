local megaGenreMatching = {
	fighting = 1,
	racing = 1,
	action = 1,
	sandbox = 1.15,
	strategy = 0.6,
	simulation = 0.7,
	horror = 1,
	adventure = 1.15,
	rpg = 1.15
}

platforms:registerNew({
	manufacturer = "mega",
	defaultAttractiveness = 200,
	licenseCost = 40000,
	maxProjectScale = 6,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.25,
	quad = "platform_origin",
	id = "mega_platform_1",
	startingSharePercentage = 0.15,
	display = _T("PLATFORM_MEGA_ORIGIN", "Mega 'Origin'"),
	releaseDate = {
		year = 1988,
		month = 10
	},
	expiryDate = {
		year = 1997,
		month = 5
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_MEGA_ORIGIN_RELEASE", "Mega has released their new 'Origin' game console."),
	engineFeatureRequirements = {
		"mega_platform_1_support"
	},
	genreMatching = megaGenreMatching
})
platforms:registerNew({
	manufacturer = "mega",
	defaultAttractiveness = 210,
	licenseCost = 50000,
	maxProjectScale = 8,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.25,
	quad = "platform_jupiter",
	id = "mega_platform_2",
	startingSharePercentage = 0.15,
	display = _T("PLATFORM_MEGA_JUPITER", "Mega 'Jupiter'"),
	releaseDate = {
		year = 1994,
		month = 11
	},
	expiryDate = {
		year = 1999,
		month = 2
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_MEGA_JUPITER_RELEASE", "Mega has released their new 'Jupiter' game console."),
	engineFeatureRequirements = {
		"mega_platform_2_support"
	},
	genreMatching = megaGenreMatching
})
platforms:registerNew({
	manufacturer = "mega",
	defaultAttractiveness = 210,
	licenseCost = 45000,
	maxProjectScale = 10,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.25,
	quad = "platform_expand",
	id = "mega_platform_3",
	startingSharePercentage = 0.125,
	display = _T("PLATFORM_MEGA_EXPAND", "Mega 'Expand'"),
	releaseDate = {
		year = 1998,
		month = 2
	},
	expiryDate = {
		year = 2006,
		month = 5
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_MEGA_EXPAND_RELEASE", "Mega has released their new 'Expand' game console."),
	engineFeatureRequirements = {
		"mega_platform_3_support"
	},
	genreMatching = megaGenreMatching
})
platforms:registerNew({
	manufacturer = "mega",
	defaultAttractiveness = 200,
	licenseCost = 40000,
	maxProjectScale = 13,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.25,
	quad = "platform_horizon",
	id = "mega_platform_4",
	startingSharePercentage = 0.1,
	display = _T("PLATFORM_MEGA_HORIZON", "Mega 'Horizon'"),
	releaseDate = {
		year = 2005,
		month = 2
	},
	expiryDate = {
		year = 2012,
		month = 6
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_MEGA_HORIZON_RELEASE", "Mega has released their new 'Horizon' game console."),
	engineFeatureRequirements = {
		"mega_platform_4_support"
	},
	genreMatching = megaGenreMatching
})
platforms:registerNew({
	manufacturer = "mega",
	defaultAttractiveness = 150,
	licenseCost = 50000,
	maxProjectScale = 17,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.25,
	quad = "platform_beyond",
	id = "mega_platform_5",
	startingSharePercentage = 0.1,
	display = _T("PLATFORM_MEGA_BEYOND", "Mega 'Beyond'"),
	releaseDate = {
		year = 2011,
		month = 2
	},
	expiryDate = {
		year = 2019,
		month = 4
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_MEGA_BEYOND_RELEASE", "Mega has released their new 'Beyond' game console."),
	engineFeatureRequirements = {
		"mega_platform_5_support"
	},
	genreMatching = megaGenreMatching
})
platforms:registerNew({
	manufacturer = "mega",
	defaultAttractiveness = 100,
	maxProjectScale = 20,
	licenseCost = 50000,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.25,
	quad = "platform_forever",
	id = "mega_platform_6",
	startingSharePercentage = 0.1,
	display = _T("PLATFORM_MEGA_FOREVER", "Mega Forever"),
	releaseDate = {
		year = 2018,
		month = 2
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_MEGA_FOREVER_RELEASE", "Mega has released their new 'Forever' game console."),
	engineFeatureRequirements = {
		"mega_platform_6_support"
	},
	genreMatching = megaGenreMatching
})
taskTypes:registerNew({
	workAmount = 200,
	platformID = "mega_platform_1",
	id = "mega_platform_1_support",
	minimumLevel = 25,
	display = _T("MEGA_PLATFORM_1_SUPPORT", "'Mega Origin' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 250,
	platformID = "mega_platform_2",
	id = "mega_platform_2_support",
	minimumLevel = 25,
	display = _T("MEGA_PLATFORM_2_SUPPORT", "'Mega Jupiter' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 300,
	platformID = "mega_platform_3",
	id = "mega_platform_3_support",
	minimumLevel = 30,
	display = _T("MEGA_PLATFORM_3_SUPPORT", "'Mega Expand' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 350,
	platformID = "mega_platform_4",
	id = "mega_platform_4_support",
	minimumLevel = 35,
	display = _T("MEGA_PLATFORM_4_SUPPORT", "'Mega Horizon' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 300,
	platformID = "mega_platform_5",
	id = "mega_platform_5_support",
	minimumLevel = 40,
	display = _T("MEGA_PLATFORM_5_SUPPORT", "'Mega Beyond' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 275,
	platformID = "mega_platform_6",
	id = "mega_platform_6_support",
	minimumLevel = 45,
	display = _T("MEGA_PLATFORM_6_SUPPORT", "'Mega Forever' support")
}, nil, "polystation_1_support")
