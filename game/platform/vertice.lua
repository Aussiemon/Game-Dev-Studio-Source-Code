local verticeGenreMatching = {
	fighting = 1.15,
	racing = 1,
	action = 1,
	sandbox = 1,
	strategy = 0.7,
	simulation = 0.6,
	horror = 1,
	adventure = 1.1,
	rpg = 1.1
}

platforms:registerNew({
	manufacturer = "hardmacro",
	quad = "platform_vertice",
	defaultAttractiveness = 150,
	licenseCost = 70000,
	developmentTimeAffector = 0.4,
	cutPerSale = 0.3,
	maxProjectScale = 14,
	id = "vertice",
	startingSharePercentage = 0.125,
	display = _T("VERTICE", "Vertice"),
	releaseDate = {
		year = 2001,
		month = 10
	},
	expiryDate = {
		year = 2006,
		month = 6
	},
	engineFeatureRequirements = {
		"vertice_support"
	},
	releaseText = _T("VERTICE_RELEASE", "HardMacro has released their new 'Vertice' game console."),
	expiryText = _T("VERTICE_EXPIRATION", "HardMacro has officially discontinued their 'Vertice' game console."),
	genreMatching = verticeGenreMatching
})
platforms:registerNew({
	manufacturer = "hardmacro",
	quad = "platform_vertice_x",
	defaultAttractiveness = 125,
	licenseCost = 50000,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.35,
	maxProjectScale = 16,
	id = "vertice_x",
	startingSharePercentage = 0.1,
	display = _T("VERTICE_X", "Vertice X"),
	releaseDate = {
		year = 2005,
		month = 10
	},
	expiryDate = {
		year = 2017,
		month = 10
	},
	engineFeatureRequirements = {
		"vertice_x_support",
		"gamepad"
	},
	releaseText = _T("VERTICE_X_RELEASE", "HardMacro has released their new 'Vertice X' game console."),
	expiryText = _T("VERTICE_X_EXPIRATION", "HardMacro has officially discontinued their 'Vertice X' game console."),
	genreMatching = verticeGenreMatching
})
platforms:registerNew({
	manufacturer = "hardmacro",
	defaultAttractiveness = 100,
	developmentTimeAffector = 0.75,
	licenseCost = 30000,
	cutPerSale = 0.4,
	maxProjectScale = 20,
	quad = "platform_vertice_x2",
	id = "vertice_x2",
	startingSharePercentage = 0.1,
	display = _T("VERTICE_X2", "Vertice X2"),
	releaseDate = {
		year = 2013,
		month = 10
	},
	engineFeatureRequirements = {
		"vertice_x2_support",
		"gamepad"
	},
	releaseText = _T("VERTICE_X2_RELEASE", "HardMacro has released their new 'Vertice X2' game console."),
	expiryText = _T("VERTICE_X2_EXPIRATION", "HardMacro has officially discontinued their 'Vertice X2' game console."),
	genreMatching = verticeGenreMatching
})
taskTypes:registerNew({
	workAmount = 250,
	platformID = "vertice",
	id = "vertice_support",
	minimumLevel = 30,
	display = _T("VERTICE_SUPPORT", "'Vertice' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 300,
	platformID = "vertice_x",
	id = "vertice_x_support",
	minimumLevel = 35,
	display = _T("VERTICE_X_SUPPORT", "'Vertice X' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 350,
	platformID = "vertice_x2",
	id = "vertice_x2_support",
	minimumLevel = 40,
	display = _T("VERTICE_X2_SUPPORT", "'Vertice X2' support")
}, nil, "polystation_1_support")
