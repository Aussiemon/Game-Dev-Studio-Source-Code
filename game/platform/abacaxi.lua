local abacaxiGenreMatching = {
	fighting = 0.7,
	racing = 1.1,
	action = 1,
	sandbox = 1.15,
	strategy = 1.15,
	simulation = 1.15,
	horror = 1,
	adventure = 1,
	rpg = 1.05
}

platforms:registerNew({
	manufacturer = "pineapple",
	quad = "platform_se",
	defaultAttractiveness = 150,
	licenseCost = 10000,
	developmentTimeAffector = 0.5,
	cutPerSale = 0.4,
	maxProjectScale = 4,
	id = "abacaxi_1",
	startingSharePercentage = 0.15,
	display = _T("ABACAXI_1", "Abacaxi SE"),
	releaseDate = {
		year = 1987,
		month = 3
	},
	expiryDate = {
		year = 1990,
		month = 1
	},
	engineFeatureRequirements = {
		"abacaxi_1_support"
	},
	genreMatching = abacaxiGenreMatching
})
platforms:registerNew({
	manufacturer = "pineapple",
	quad = "platform_iii",
	defaultAttractiveness = 150,
	licenseCost = 10000,
	developmentTimeAffector = 0.5,
	cutPerSale = 0.4,
	maxProjectScale = 5,
	id = "abacaxi_2",
	startingSharePercentage = 0.15,
	display = _T("ABACAXI_2", "Abacaxi III"),
	releaseDate = {
		year = 1990,
		month = 5
	},
	expiryDate = {
		year = 1998,
		month = 4
	},
	engineFeatureRequirements = {
		"abacaxi_2_support"
	},
	genreMatching = abacaxiGenreMatching
})
platforms:registerNew({
	manufacturer = "pineapple",
	quad = "platform_g4",
	defaultAttractiveness = 150,
	licenseCost = 10000,
	developmentTimeAffector = 0.5,
	cutPerSale = 0.4,
	maxProjectScale = 11,
	id = "abacaxi_3",
	startingSharePercentage = 0.125,
	display = _T("ABACAXI_3", "Abacaxi G4"),
	releaseDate = {
		year = 1998,
		month = 1
	},
	expiryDate = {
		year = 2003,
		month = 3
	},
	engineFeatureRequirements = {
		"abacaxi_3_support"
	},
	genreMatching = abacaxiGenreMatching
})
platforms:registerNew({
	manufacturer = "pineapple",
	quad = "platform_g5",
	defaultAttractiveness = 150,
	licenseCost = 10000,
	developmentTimeAffector = 0.5,
	cutPerSale = 0.4,
	maxProjectScale = 14,
	id = "abacaxi_4",
	startingSharePercentage = 0.125,
	display = _T("ABACAXI_4", "Abacaxi G5"),
	releaseDate = {
		year = 2002,
		month = 1
	},
	expiryDate = {
		year = 2006,
		month = 3
	},
	engineFeatureRequirements = {
		"abacaxi_4_support"
	},
	genreMatching = abacaxiGenreMatching
})
platforms:registerNew({
	manufacturer = "pineapple",
	quad = "platform_pro",
	defaultAttractiveness = 150,
	licenseCost = 10000,
	developmentTimeAffector = 0.5,
	cutPerSale = 0.4,
	id = "abacaxi_5",
	startingSharePercentage = 0.1,
	getDisplayQuad = function(self)
		return self.quad
	end,
	display = _T("ABACAXI_5", "Abacaxi Pro"),
	releaseDate = {
		year = 2006,
		month = 1
	},
	expiryDate = {
		year = 2030,
		month = 3
	},
	engineFeatureRequirements = {
		"abacaxi_5_support"
	},
	scaleProgression = {
		{
			year = 2006,
			scale = 15
		},
		{
			year = 2007,
			scale = 16
		},
		{
			year = 2009,
			scale = 17
		},
		{
			year = 2010,
			scale = 18
		},
		{
			year = 2011,
			scale = 19
		},
		{
			year = 2012,
			scale = 20
		}
	},
	genreMatching = abacaxiGenreMatching
}, "pc")
platforms:registerNew({
	quad = "platform_master",
	manufacturer = "pineapple",
	defaultAttractiveness = 150,
	developmentTimeAffector = 0.5,
	licenseCost = 10000,
	cutPerSale = 0.4,
	maxProjectScale = 20,
	id = "abacaxi_6",
	startingSharePercentage = 0.1,
	display = _T("ABACAXI_6", "Abacaxi Master"),
	releaseDate = {
		year = 2025,
		month = 3
	},
	engineFeatureRequirements = {
		"abacaxi_6_support"
	},
	genreMatching = abacaxiGenreMatching
})
taskTypes:registerNew({
	workAmount = 150,
	platformID = "abacaxi_1",
	id = "abacaxi_1_support",
	minimumLevel = 20,
	display = _T("ABACAXI_1_SUPPORT", "'Abacaxi SE' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 175,
	platformID = "abacaxi_2",
	id = "abacaxi_2_support",
	minimumLevel = 20,
	display = _T("ABACAXI_2_SUPPORT", "'Abacaxi III' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 200,
	platformID = "abacaxi_3",
	id = "abacaxi_3_support",
	minimumLevel = 25,
	display = _T("ABACAXI_3_SUPPORT", "'Abacaxi G4' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 225,
	platformID = "abacaxi_4",
	id = "abacaxi_4_support",
	minimumLevel = 25,
	display = _T("ABACAXI_4_SUPPORT", "'Abacaxi G5' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 250,
	platformID = "abacaxi_5",
	id = "abacaxi_5_support",
	minimumLevel = 30,
	display = _T("ABACAXI_5_SUPPORT", "'Abacaxi Pro' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 300,
	platformID = "abacaxi_6",
	id = "abacaxi_6_support",
	minimumLevel = 40,
	display = _T("ABACAXI_6_SUPPORT", "'Abacaxi Master' support")
}, nil, "polystation_1_support")
