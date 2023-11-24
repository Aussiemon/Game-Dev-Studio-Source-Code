letsPlayers:registerNew({
	viewerIncreaseMult = 0.8,
	maxViewerbaseMult = 1,
	minimumViewerBaseForPaidVideos = 750000,
	maxVideos = 3,
	icon = "lp_zapdeadcake",
	extraPriceSection = 20000,
	extraPerSection = 500,
	startingViewers = 360,
	freeExtraVideosRating = 8,
	baseVideoPrice = 1000,
	id = "lets_player_1",
	freeExtraVideos = 6,
	display = _T("LETS_PLAYER_1", "ZapDeadCake"),
	description = _T("LETS_PLAYER_1_DESC", "Screams a lot into his microphone, but less than 'charliesewernose'."),
	availability = {
		year = 2010,
		month = 4
	},
	preferredGenres = {
		action = true,
		rpg = true
	},
	setupDescbox = function(self, letsPlayer, descBox, wrapWidth)
		if timeline.curTime >= timeline:getDateTime(2017, 4) then
			descBox:addText(_T("LETS_PLAYER_1_DESC_2", "Rumors say he is also the Grand Wizard of the KKK."), "pix16", nil, 0, wrapWidth)
		end
	end
})
letsPlayers:registerNew({
	startingViewers = 20,
	extraPerSection = 250,
	freeExtraVideosRating = 8,
	maxViewerbaseMult = 0.15,
	viewerIncreaseMult = 0.15,
	minimumViewerBaseForPaidVideos = 100000,
	baseVideoPrice = 500,
	maxVideos = 2,
	id = "lets_player_2",
	icon = "lp_absolute_cracker",
	extraPriceSection = 15000,
	freeExtraVideos = 1,
	display = _T("LETS_PLAYER_2", "AbsoluteCracker"),
	description = _T("LETS_PLAYER_2_DESC", "Takes a very honest stance on video games."),
	availability = {
		year = 2006,
		month = 7
	},
	preferredGenres = {
		action = true,
		rpg = true
	}
})
letsPlayers:registerNew({
	startingViewers = 45,
	extraPerSection = 500,
	freeExtraVideosRating = 8,
	maxViewerbaseMult = 0.2,
	viewerIncreaseMult = 0.2,
	minimumViewerBaseForPaidVideos = 200000,
	baseVideoPrice = 500,
	maxVideos = 5,
	id = "lets_player_3",
	icon = "lp_flustered_pedro_show",
	extraPriceSection = 10000,
	freeExtraVideos = 4,
	display = _T("LETS_PLAYER_3", "FlusteredPedroShow"),
	description = _T("LETS_PLAYER_3_DESC", "Makes lengthy game review videos and is known for his sense of humor."),
	availability = {
		year = 2008,
		month = 10
	},
	preferredGenres = {
		action = true,
		rpg = true
	}
})
letsPlayers:registerNew({
	startingViewers = 100,
	extraPerSection = 500,
	freeExtraVideosRating = 8,
	maxViewerbaseMult = 0.7,
	viewerIncreaseMult = 0.3,
	minimumViewerBaseForPaidVideos = 50000,
	baseVideoPrice = 500,
	maxVideos = 5,
	id = "lets_player_4",
	icon = "lp_charliesewernose",
	extraPriceSection = 10000,
	freeExtraVideos = 4,
	display = _T("LETS_PLAYER_4", "charliesewernose"),
	description = _T("LETS_PLAYER_4_DESC", "Screams a lot into his microphone."),
	availability = {
		year = 2007,
		month = 2
	},
	preferredGenres = {
		action = true,
		rpg = true
	}
})
