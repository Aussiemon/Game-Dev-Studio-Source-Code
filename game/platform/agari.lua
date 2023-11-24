local agariPlatformGenreMatching = {
	fighting = 1,
	racing = 1.1,
	action = 1.15,
	sandbox = 1,
	strategy = 0.7,
	simulation = 0.8,
	horror = 1.15,
	adventure = 1,
	rpg = 1
}

platforms:registerNew({
	manufacturer = "agari",
	defaultAttractiveness = 150,
	licenseCost = 10000,
	maxProjectScale = 4,
	developmentTimeAffector = 1.3,
	cutPerSale = 0.1,
	quad = "platform_heghs",
	id = "agari_platform_1",
	startingSharePercentage = 0.15,
	display = _T("PLATFORM_AGARI_HEGHS", "HEGHS"),
	releaseDate = {
		year = 1987,
		month = 1
	},
	expiryDate = {
		year = 1992,
		month = 10
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_AGARI_HEGHS_RELEASE", "Agari has released their new 'HEGHS' game console."),
	engineFeatureRequirements = {
		"agari_platform_1_support"
	},
	genreMatching = agariPlatformGenreMatching
})
platforms:registerNew({
	manufacturer = "agari",
	defaultAttractiveness = 150,
	licenseCost = 15000,
	maxProjectScale = 7,
	developmentTimeAffector = 1.15,
	cutPerSale = 0.15,
	quad = "platform_heghs",
	id = "agari_platform_2",
	startingSharePercentage = 0.15,
	display = _T("PLATFORM_AGARI_HEGHS_2", "HEGHS 2.0"),
	releaseDate = {
		year = 1992,
		month = 5
	},
	expiryDate = {
		year = 1997,
		month = 4
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_AGARI_HEGHS_2_RELEASE", "Agari has released their new 'HEGHS 2' game console."),
	engineFeatureRequirements = {
		"agari_platform_2_support"
	},
	genreMatching = agariPlatformGenreMatching
})
platforms:registerNew({
	manufacturer = "agari",
	defaultAttractiveness = 150,
	licenseCost = 20000,
	maxProjectScale = 9,
	developmentTimeAffector = 1,
	cutPerSale = 0.2,
	quad = "platform_puma",
	id = "agari_platform_3",
	startingSharePercentage = 0.125,
	display = _T("PLATFORM_AGARI_PUMA", "Puma"),
	releaseDate = {
		year = 1996,
		month = 2
	},
	expiryDate = {
		year = 2004,
		month = 4
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_AGARI_PUMA_RELEASE", "Agari has released their new 'Puma' game console."),
	engineFeatureRequirements = {
		"agari_platform_3_support"
	},
	genreMatching = agariPlatformGenreMatching
})
platforms:registerNew({
	manufacturer = "agari",
	defaultAttractiveness = 150,
	licenseCost = 30000,
	maxProjectScale = 11,
	developmentTimeAffector = 0.8,
	cutPerSale = 0.25,
	quad = "platform_xyu",
	id = "agari_platform_4",
	startingSharePercentage = 0.125,
	display = _T("PLATFORM_AGARI_XYU", "X.Y.U."),
	releaseDate = {
		year = 2002,
		month = 4
	},
	expiryDate = {
		year = 2010,
		month = 4
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_AGARI_XYU_RELEASE", "Agari has released their new 'X.Y.U.' game console."),
	engineFeatureRequirements = {
		"agari_platform_4_support"
	},
	genreMatching = agariPlatformGenreMatching
})
platforms:registerNew({
	manufacturer = "agari",
	defaultAttractiveness = 150,
	licenseCost = 40000,
	maxProjectScale = 15,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.325,
	quad = "platform_bear",
	id = "agari_platform_5",
	startingSharePercentage = 0.1,
	display = _T("PLATFORM_AGARI_BEAR", "Bear"),
	releaseDate = {
		year = 2008,
		month = 8
	},
	expiryDate = {
		year = 2016,
		month = 4
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_AGARI_BEAR_RELEASE", "Agari has released their new 'Bear' game console."),
	engineFeatureRequirements = {
		"agari_platform_5_support"
	},
	genreMatching = agariPlatformGenreMatching
})
platforms:registerNew({
	manufacturer = "agari",
	defaultAttractiveness = 150,
	maxProjectScale = 20,
	licenseCost = 50000,
	developmentTimeAffector = 0.4,
	cutPerSale = 0.4,
	quad = "platform_ultra",
	id = "agari_platform_6",
	startingSharePercentage = 0.1,
	display = _T("PLATFORM_AGARI_ULTRA", "Ultra"),
	releaseDate = {
		year = 2015,
		month = 2
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("PLATFORM_AGARI_ULTRA_RELEASE", "Agari has released their new 'Ultra' game console."),
	engineFeatureRequirements = {
		"agari_platform_6_support"
	},
	genreMatching = agariPlatformGenreMatching
})
taskTypes:registerNew({
	workAmount = 300,
	platformID = "agari_platform_1",
	id = "agari_platform_1_support",
	minimumLevel = 20,
	display = _T("AGARI_PLATFORM_1_SUPPORT", "'HEGHS' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 350,
	platformID = "agari_platform_2",
	id = "agari_platform_2_support",
	minimumLevel = 25,
	display = _T("AGARI_PLATFORM_2_SUPPORT", "'HEGHS 2.0' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 300,
	platformID = "agari_platform_3",
	id = "agari_platform_3_support",
	minimumLevel = 30,
	display = _T("AGARI_PLATFORM_3_SUPPORT", "'Puma' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 250,
	platformID = "agari_platform_4",
	id = "agari_platform_4_support",
	minimumLevel = 35,
	display = _T("AGARI_PLATFORM_4_SUPPORT", "'X.Y.U' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 225,
	platformID = "agari_platform_5",
	id = "agari_platform_5_support",
	minimumLevel = 40,
	display = _T("AGARI_PLATFORM_5_SUPPORT", "'Bear' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 200,
	platformID = "agari_platform_6",
	id = "agari_platform_6_support",
	minimumLevel = 35,
	display = _T("AGARI_PLATFORM_6_SUPPORT", "'Ultra' support")
}, nil, "polystation_1_support")
