local devCommentary = {}

devCommentary.id = "scenario_developer_commentary"
devCommentary.trackCompletion = true
devCommentary.name = _T("SCENARIO_DEV_COMMENTARY_NAME", "Developer Commentary")
devCommentary.display = _T("SCENARIO_DEV_COMMENTARY", "Developer Commentary")
devCommentary.description = _T("SCENARIO_DEV_COMMENTARY_DESC", "Welcome to the Game Dev Studio Developer Commentary! In this scenario I will tell you how and why the game was made, what iterations certain features went through. If you're a game developer or are a fan of the game and want to find out more about how it was made - look no further.\n\nBits of commentary will get unlocked as you play through the campaign and interact with the various systems.\nCommentary that you have yet to see can be checked in the Objectives window at any time.")
devCommentary.objectiveList = {
	"scenario_developer_commentary",
	"scenario_developer_commentary_outro"
}
devCommentary.startMoney = 5000000
devCommentary.orderWeight = 100
devCommentary.startTime = {
	year = 2001,
	month = 5
}
devCommentary.playerCharacterLearnSpeedMultiplier = 3
devCommentary.startingSkillLevel = 30
devCommentary.startingGenres = {
	"rpg",
	"simulation",
	"strategy"
}
devCommentary.startingThemes = {
	"scifi",
	"military"
}
devCommentary.playlistID = musicPlayback.PLAYLIST_IDS.GAMEPLAY_FULL
devCommentary.achievementOnFinish = false
devCommentary.map = "back_in_the_game"
devCommentary.unlockTechAtStartTime = true
devCommentary.rivals = {
	"back_in_the_game_1",
	"back_in_the_game_2",
	"back_in_the_game_3"
}
devCommentary.rivalBuildings = {
	back_in_the_game_2 = "back_in_the_game_office_2",
	back_in_the_game_3 = "back_in_the_game_office_4",
	back_in_the_game_1 = {
		"back_in_the_game_office_3",
		"office_medium_7"
	}
}

local hireTime = {
	year = {
		1988,
		1992
	},
	month = {
		1,
		12
	}
}

devCommentary.startingEmployees = {
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
devCommentary.targetReputation = 60000
devCommentary.startingUserCount = 2000000
devCommentary.startingReputation = 5000
devCommentary.campaignFinishedText = _T("DEV_COMMENTARY_FINISHED_TEXT", "Congratulations, you've finished the Developer Commentary! I hope it was interesting and fun to find out how the game was made, as it was certainly fun for me to make it.")
devCommentary.startingGeneratedEngines = 6
devCommentary.startingEngineFeatureCountMultiplier = 0.9
devCommentary.startingEngineName = _T("devCommentary_STARTING_ENGINE", "inTech 1.0")
devCommentary.headerText = _T("RECOMMENDED_AFTER_STORY_MODE", "Recommended after Story Mode!")
devCommentary.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}

function devCommentary:begin()
	self:setupStartingTime()
	characterDesigner:begin(nil, self.startingSkillLevel)
end

function devCommentary:formatDescription()
	return self.description
end

function devCommentary:startCallback()
	self:unlockStartingTech()
	platformShare:setTotalUsers(self.startingUserCount)
	
	local employee = characterDesigner:getEmployee()
	
	employee:setOverallSkillProgressionMultiplier(self.playerCharacterLearnSpeedMultiplier)
	characterDesigner:finish()
	
	self.playerCharacter = employee
	
	self:giveStartingThemesGenres()
	self:setupStartingRivals()
	studio:setFunds(self.startMoney)
	self:setupObjectives()
	studio:setReputation(self.startingReputation)
	self:giveStartingEmployees()
	
	if self.startingEngineName then
		local engineObj = engineLicensing:generateEngine(nil, self.startingEngineFeatureCountMultiplier, true)
		
		engineObj:setName(self.startingEngineName)
		engineObj:setOwner(studio)
		engineObj:calculateLicensingAttractiveness()
		engineObj:calculateMinimumRevampRequirement()
		studio:addEngine(engineObj)
	end
	
	game.logStartedCampaign(self.id)
	
	if DEV_COMMENTARY then
		self:loadDevCommentary()
	end
end

function devCommentary:postStartCallback()
	engineLicensing:generateEngines(self.startingGeneratedEngines)
end

function devCommentary:load()
	self:setupObjectives()
	
	for key, employee in ipairs(studio:getEmployees()) do
		if employee:isPlayerCharacter() then
			self.playerCharacter = employee
			
			break
		end
	end
end

function devCommentary:setupObjectives()
	objectiveHandler:setMaxObjectives(1)
	objectiveHandler:addObjectivesToList(self.objectiveList)
end

function devCommentary:handleEvent(event, objectiveObject)
	if objectiveObject:getID() == self.objectiveList[#self.objectiveList] then
		game.createStatsPopup(_format(self.campaignFinishedText, "SCENARIO", self.name))
		game.logFinishedCampaign(self.id)
	end
end

game.registerGameType(devCommentary)

devCommentary.ROMAN_GLEBENKOV_NAME = _T("ROMAN_GLEBENKOV", "Roman Glebenkov")

game.registerDialogueName("roman_glebenkov", devCommentary.ROMAN_GLEBENKOV_NAME)
