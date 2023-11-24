local cd = {}

cd.id = "scenario_console_domination_Dev"
cd.trackCompletion = true
cd.name = _T("SCENARIO_4_NAMEDEV", "Console Domination DEV")
cd.display = _format(_T("SCENARIO_4", "Scenario - NAME"), "NAME", cd.name)
cd.description = _T("SCENARIO_4_DESCRIPTION", "Having been chosen as the CEO of a new company that is taking interest in console hardware manufacturing, your task is to make $MONEY within TIME.\n\nThis scenario acts as an introduction to console creation (with a challenge), and is recommended to play through if you're unsure of how it works.")
cd.labCoatPortrait = "labcoat_guy"
cd.objectiveList = {
	"console_domination_1",
	"console_domination_2"
}
cd.startMoney = 10000000
cd.orderWeight = 40
cd.startTime = {
	year = 1989,
	month = 3
}
cd.playerCharacterLearnSpeedMultiplier = 3
cd.startingSkillLevel = 30
cd.startingGenres = {
	"action",
	"simulation",
	"strategy"
}
cd.startingThemes = {
	"scifi",
	"military"
}
cd.playlistID = musicPlayback.PLAYLIST_IDS.GAMEPLAY_ALL
cd.map = "console_domination"
cd.unlockTechAtStartTime = true
cd.rivals = {
	"back_in_the_game_1",
	"back_in_the_game_2",
	"back_in_the_game_3"
}
cd.rivalBuildings = {}

local hireTime = {
	year = {
		1988,
		1988
	},
	month = {
		1,
		12
	}
}

cd.startingEmployees = {
	{
		role = "software_engineer",
		repeatFor = 2,
		level = {
			3,
			5
		},
		hireTime = hireTime
	},
	{
		role = "software_engineer",
		level = 6,
		hireTime = hireTime
	},
	{
		role = "designer",
		level = 4,
		hireTime = hireTime
	},
	{
		role = "manager",
		level = 4,
		hireTime = hireTime
	},
	{
		role = "sound_engineer",
		level = 5,
		hireTime = hireTime
	},
	{
		role = "artist",
		level = 4,
		hireTime = hireTime
	}
}
cd.startingUserCount = 600000
cd.startingReputation = 5000
cd.campaignFinishedText = _T("BACK_IN_THE_GAME_FINISHED_TEXT", "Congratulations, you've finished the 'SCENARIO' scenario! From this point onwards it's pure freeplay, so play for as long as you'd like or start another scenario to try your hand at another challenge!")
cd.startingGeneratedEngines = 6
cd.startingEngineName = false
cd.fundsToFinish = 200000000
cd.timeLimit = timeline.DAYS_IN_YEAR * 30
cd.headerText = _T("RECOMMENDED_AFTER_PAY_DENBTS", "Recommended after 'Pay Debts'!")
cd.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}
cd.restrictActions = {
	"cancel_platform",
	"look_for_developers",
	"discontinue_platform"
}

function cd:setPlaylist(initialSet)
	if initialSet then
		musicPlayback:getPlaylist(musicPlayback.PLAYLIST_IDS.GAMEPLAY_ALL):setFirstTrack(musicPlayback.GAMEPLAY_TRACKS_FOLDER .. "content_content.ogg")
	end
	
	cd.baseClass.setPlaylist(self)
end

function cd:startCallback()
	cd.baseClass.startCallback(self)
	interactionRestrictor:restrictActions(self.restrictActions)
end

function cd:formatDescription()
	return string.easyformatbykeys(self.description, "MONEY", string.comma(self.fundsToFinish), "TIME", timeline:getTimePeriodText(self.timeLimit))
end

game.registerGameType(cd, "scenario_back_in_the_game")
game.registerDialogueName("labcoat", _T("LABCOAT_GUY_NAME", "Hardware Lab Lead"))
