platforms:registerNew({
	manufacturer = "cexpi",
	defaultAttractiveness = 150,
	licenseCost = 60000,
	maxProjectScale = 9,
	developmentTimeAffector = 0.6,
	cutPerSale = 0.2,
	quad = "platform_polystation_1",
	id = "polystation_1",
	startingSharePercentage = 0.15,
	display = _T("POLYSTATION", "Polystation"),
	releaseDate = {
		year = 1995,
		month = 9
	},
	expiryDate = {
		year = 2005,
		month = 4
	},
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseText = _T("POLYSTATION_RELEASE", "C-EXPI has released their new 'Polystation' game console."),
	engineFeatureRequirements = {
		"polystation_1_support"
	},
	genreMatching = {
		fighting = 1.15,
		racing = 1,
		action = 1.1,
		sandbox = 1,
		strategy = 0.75,
		simulation = 0.6,
		horror = 1.15,
		adventure = 1,
		rpg = 1
	}
})
platforms:registerNew({
	manufacturer = "cexpi",
	quad = "platform_polystation_2",
	maxProjectScale = 12,
	licenseCost = 40000,
	startingSharePercentage = 0.125,
	defaultAttractiveness = 140,
	cutPerSale = 0.2,
	id = "polystation_2",
	developmentTimeAffector = 0.8,
	display = _T("POLYSTATION_2", "Polystation 2"),
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseDate = {
		year = 2000,
		month = 3
	},
	expiryDate = {
		year = 2013,
		month = 1
	},
	releaseText = _T("POLYSTATION_2_RELEASE", "C-EXPI has released their new 'Polystation 2' game console."),
	engineFeatureRequirements = {
		"polystation_2_support",
		"gamepad"
	},
	genreMatching = {
		fighting = 1.15,
		racing = 1,
		action = 1,
		sandbox = 1,
		strategy = 0.7,
		simulation = 0.6,
		horror = 1.15,
		adventure = 1,
		rpg = 1
	}
})
platforms:registerNew({
	manufacturer = "cexpi",
	defaultAttractiveness = 140,
	licenseCost = 10000,
	maxProjectScale = 15,
	developmentTimeAffector = 1.2,
	cutPerSale = 0.225,
	quad = "platform_polystation_3",
	id = "polystation_3",
	startingSharePercentage = 0.1,
	display = _T("POLYSTATION_3", "Polystation 3"),
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseDate = {
		year = 2006,
		month = 10
	},
	expiryDate = {
		year = 2015,
		month = 10
	},
	releaseText = _T("POLYSTATION_3_RELEASE", "C-EXPI has released their new 'Polystation 3' game console."),
	engineFeatureRequirements = {
		"polystation_3_support",
		"gamepad"
	},
	genreMatching = {
		fighting = 1.15,
		racing = 1,
		action = 1,
		sandbox = 1,
		strategy = 0.75,
		simulation = 0.6,
		horror = 1.15,
		adventure = 1,
		rpg = 1
	}
})
platforms:registerNew({
	manufacturer = "cexpi",
	defaultAttractiveness = 150,
	maxProjectScale = 20,
	licenseCost = 10000,
	developmentTimeAffector = 0.9,
	cutPerSale = 0.3,
	quad = "platform_polystation_4",
	id = "polystation_4",
	startingSharePercentage = 0.1,
	display = _T("POLYSTATION_4", "Polystation 4"),
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseDate = {
		year = 2013,
		month = 10
	},
	releaseText = _T("POLYSTATION_4_RELEASE", "C-EXPI has released their new 'Polystation 4' game console."),
	engineFeatureRequirements = {
		"polystation_4_support",
		"gamepad"
	},
	genreMatching = {
		fighting = 1.15,
		racing = 1,
		action = 1,
		sandbox = 1,
		strategy = 0.75,
		simulation = 0.6,
		horror = 1.15,
		adventure = 1,
		rpg = 1
	}
})
platforms:registerNew({
	manufacturer = "cexpi",
	defaultAttractiveness = 80,
	licenseCost = 40000,
	maxProjectScale = 9,
	startingSharePercentage = 0.125,
	cutPerSale = 0.25,
	quad = "platform_pocket",
	id = "polystation_handheld_1",
	developmentTimeAffector = 0.85,
	display = _T("POLYSTATION_HANDHELD_1", "Polystation Pocket"),
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseDate = {
		year = 2004,
		month = 12
	},
	expiryDate = {
		year = 2014,
		month = 1
	},
	releaseText = _T("POLYSTATION_POCKET_RELEASE", "C-EXPI has released their new 'Polystation Pocket' game console."),
	engineFeatureRequirements = {
		"polystation_handheld_1_support"
	},
	genreMatching = {
		fighting = 1.35,
		racing = 1.15,
		action = 1.15,
		sandbox = 1,
		strategy = 0.75,
		simulation = 0.6,
		horror = 1,
		adventure = 1.15,
		rpg = 1
	}
})
platforms:registerNew({
	manufacturer = "cexpi",
	defaultAttractiveness = 80,
	licenseCost = 40000,
	maxProjectScale = 12,
	startingSharePercentage = 0.1,
	cutPerSale = 0.2,
	quad = "platform_pocket_2",
	id = "polystation_handheld_2",
	developmentTimeAffector = 0.95,
	display = _T("POLYSTATION_HANDHELD_2", "Polystation Pocket 2"),
	postExpireOnMarketTime = timeline.DAYS_IN_YEAR,
	releaseDate = {
		year = 2011,
		month = 12
	},
	expiryDate = {
		year = 2021,
		month = 1
	},
	releaseText = _T("POLYSTATION_POCKET_2_RELEASE", "C-EXPI has released their new 'Polystation Pocket 2' game console."),
	engineFeatureRequirements = {
		"polystation_handheld_2_support"
	},
	genreMatching = {
		fighting = 1.15,
		racing = 1.1,
		action = 1.1,
		sandbox = 1,
		strategy = 0.75,
		simulation = 0.6,
		horror = 1,
		adventure = 1.1,
		rpg = 1
	}
})
taskTypes:registerNew({
	noIssues = true,
	workField = "software",
	platformID = "polystation_1",
	workAmount = 200,
	category = "platform_support",
	id = "polystation_1_support",
	taskID = "engine_task",
	neverOutdated = true,
	minimumLevel = 25,
	display = _T("POLYSTATION_1_SUPPORT", "'Polystation 1' support"),
	canHaveTask = function(self, projectObject)
		if not platformShare:isPlatformOnShareList(self.platformID) then
			return false
		end
		
		if projectObject and projectObject:getOwner() then
			return studio:hasPlatformLicense(self.platformID)
		end
		
		return true
	end,
	setupDescbox = function(self, descbox, wrapwidth)
		descbox:addSpaceToNextText(4)
		descbox:addText(_format(_T("ADDS_SUPPORT_FOR_PLATFORM", "Adds development support for the 'PLATFORM' platform."), "PLATFORM", platforms:getData(self.platformID).display), "bh20", nil, 0, wrapwidth)
	end
})
taskTypes:registerNew({
	workAmount = 250,
	platformID = "polystation_2",
	id = "polystation_2_support",
	minimumLevel = 30,
	display = _T("POLYSTATION_2_SUPPORT", "'Polystation 2' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 300,
	platformID = "polystation_3",
	id = "polystation_3_support",
	minimumLevel = 35,
	display = _T("POLYSTATION_3_SUPPORT", "'Polystation 3' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 350,
	platformID = "polystation_4",
	id = "polystation_4_support",
	minimumLevel = 40,
	display = _T("POLYSTATION_4_SUPPORT", "'Polystation 4' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 275,
	platformID = "polystation_handheld_1",
	id = "polystation_handheld_1_support",
	minimumLevel = 30,
	display = _T("POLYSTATION_POCKET_SUPPORT", "'Polystation Pocket' support")
}, nil, "polystation_1_support")
taskTypes:registerNew({
	workAmount = 325,
	platformID = "polystation_handheld_2",
	id = "polystation_handheld_2_support",
	minimumLevel = 35,
	display = _T("POLYSTATION_POCKET_2_SUPPORT", "'Polystation Pocket 2' support")
}, nil, "polystation_1_support")
