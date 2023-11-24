gameConventions:registerNew({
	id = "e3",
	icon = "convention_vgpe",
	staffCost = 300,
	yearlyVisitors = 60000,
	entryFee = 5000,
	conventionMonth = 6,
	duration = 3,
	display = _T("CONVENTION_VGPE", "VGPE"),
	availability = {
		year = 1995,
		month = 2
	},
	unlockTitle = _T("CONVENTION_E3_POPUP_TITLE", "'VGPE' now available"),
	unlockText = _T("CONVENTION_E3_POPUP_TEXT", "Things are looking up for the video game industry. A new gaming convention called 'VGPE' is now available.\n\nBooking available each year until May."),
	visitorsMinMaxRange = {
		0.9,
		1.1
	},
	booths = {
		{
			cost = 5000,
			maxPeopleHoused = 2000,
			requiredParticipants = 5,
			icon = "booth_small",
			maxPresentedGames = 2,
			display = _T("E3_SMALL_BOOTH", "Small booth"),
			type = gameConventions.BOOTH_TYPES.SMALL
		},
		{
			cost = 50000,
			maxPeopleHoused = 4500,
			requiredParticipants = 10,
			icon = "booth_medium",
			maxPresentedGames = 4,
			display = _T("E3_MEDIUM_BOOTH", "Medium booth"),
			type = gameConventions.BOOTH_TYPES.MEDIUM
		},
		{
			cost = 250000,
			maxPeopleHoused = 15000,
			requiredParticipants = 15,
			icon = "booth_large",
			maxPresentedGames = 6,
			display = _T("E3_LARGE_BOOTH", "Large booth"),
			type = gameConventions.BOOTH_TYPES.LARGE
		}
	}
})
gameConventions:registerNew({
	duration = 3,
	icon = "convention_gdc",
	staffCost = 360,
	entryFee = 5000,
	conventionMonth = 4,
	id = "gdc",
	yearlyVisitors = 70000,
	display = _T("CONVENTION_GDC", "Game Developer Congregation"),
	availability = {
		year = 1988,
		month = 2
	},
	visitorsMinMaxRange = {
		0.65,
		1.4
	},
	booths = {
		{
			cost = 10000,
			maxPeopleHoused = 2500,
			requiredParticipants = 4,
			icon = "booth_small",
			maxPresentedGames = 2,
			display = _T("E3_SMALL_BOOTH", "Small booth"),
			type = gameConventions.BOOTH_TYPES.SMALL
		},
		{
			cost = 75000,
			maxPeopleHoused = 5000,
			requiredParticipants = 8,
			icon = "booth_medium",
			maxPresentedGames = 4,
			display = _T("E3_MEDIUM_BOOTH", "Medium booth"),
			type = gameConventions.BOOTH_TYPES.MEDIUM
		},
		{
			cost = 300000,
			maxPeopleHoused = 20000,
			requiredParticipants = 13,
			icon = "booth_large",
			maxPresentedGames = 6,
			display = _T("E3_LARGE_BOOTH", "Large booth"),
			type = gameConventions.BOOTH_TYPES.LARGE
		}
	}
})
gameConventions:registerNew({
	duration = 3,
	id = "gamescom",
	staffCost = 324,
	yearlyVisitors = 50000,
	entryFee = 6000,
	conventionMonth = 8,
	icon = "convention_socgames",
	display = _T("CONVENTION_GAMESCOM", "SocGames"),
	unlockTitle = _T("CONVENTION_GAMESCOM_POPUP_TITLE", "'SocGames' now available"),
	unlockText = _T("CONVENTION_GAMESCOM_POPUP_TEXT", "A large new game expo called 'SocGames' is now available.\n\nBooking available each year until August."),
	availability = {
		year = 2009,
		month = 6
	},
	visitorsMinMaxRange = {
		0.4,
		2.5
	},
	booths = {
		{
			cost = 20000,
			maxPeopleHoused = 7000,
			requiredParticipants = 6,
			icon = "booth_small",
			maxPresentedGames = 2,
			display = _T("E3_SMALL_BOOTH", "Small booth"),
			type = gameConventions.BOOTH_TYPES.SMALL
		},
		{
			cost = 85000,
			maxPeopleHoused = 20000,
			requiredParticipants = 11,
			icon = "booth_medium",
			maxPresentedGames = 4,
			display = _T("E3_MEDIUM_BOOTH", "Medium booth"),
			type = gameConventions.BOOTH_TYPES.MEDIUM
		},
		{
			cost = 330000,
			maxPeopleHoused = 50000,
			requiredParticipants = 16,
			icon = "booth_large",
			maxPresentedGames = 6,
			display = _T("E3_LARGE_BOOTH", "Large booth"),
			type = gameConventions.BOOTH_TYPES.LARGE
		}
	}
})
gameConventions:registerNew({
	duration = 3,
	id = "gameon",
	staffCost = 216,
	yearlyVisitors = 12000,
	entryFee = 500,
	conventionMonth = 9,
	icon = "convention_gygo",
	display = _T("CONVENTION_GAMEON", "GYGO"),
	unlockTitle = _T("CONVENTION_GAMEON_POPUP_TITLE", "'GYGO' now available"),
	unlockText = _T("CONVENTION_GAMEON_POPUP_TEXT", "A new small-scale game expo called 'GYGO' is now available.\n\nBooking available each year until July."),
	availability = {
		year = 1993,
		month = 7
	},
	visitorsMinMaxRange = {
		0.98,
		1.4
	},
	booths = {
		{
			cost = 1000,
			maxPeopleHoused = 1200,
			requiredParticipants = 5,
			icon = "booth_small",
			maxPresentedGames = 2,
			display = _T("E3_SMALL_BOOTH", "Small booth"),
			type = gameConventions.BOOTH_TYPES.SMALL
		},
		{
			cost = 5000,
			maxPeopleHoused = 2500,
			requiredParticipants = 8,
			icon = "booth_medium",
			maxPresentedGames = 4,
			display = _T("E3_MEDIUM_BOOTH", "Medium booth"),
			type = gameConventions.BOOTH_TYPES.MEDIUM
		},
		{
			cost = 15000,
			maxPeopleHoused = 5000,
			requiredParticipants = 12,
			icon = "booth_large",
			maxPresentedGames = 6,
			display = _T("E3_LARGE_BOOTH", "Large booth"),
			type = gameConventions.BOOTH_TYPES.LARGE
		}
	}
})
