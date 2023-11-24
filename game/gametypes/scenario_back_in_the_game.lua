local bitg = {}

bitg.id = "scenario_back_in_the_game"
bitg.trackCompletion = true
bitg.name = _T("SCENARIO_1_NAME", "Back in the Game")
bitg.display = _format(_T("SCENARIO_1", "Scenario - NAME"), "NAME", bitg.name)
bitg.description = _T("SCENARIO_1_DESCRIPTION", "You've been chosen as a CEO replacement for a company that has lost its' former reputation. You must hire a total of EMPLOYEES or more employees and acquire a total of REP reputation points within YEARS years.\n\nThere will be RIVALS other rivals.")
bitg.objectiveList = {
	"back_in_the_game",
	"back_in_the_game_finish"
}
bitg.startMoney = 750000
bitg.orderWeight = 10
bitg.startTime = {
	year = 1993,
	month = 5
}
bitg.playerCharacterLearnSpeedMultiplier = 3
bitg.startingSkillLevel = 30
bitg.startingGenres = {
	"rpg",
	"simulation",
	"strategy"
}
bitg.startingThemes = {
	"scifi",
	"military"
}
bitg.playlistID = musicPlayback.PLAYLIST_IDS.GAMEPLAY_FULL
bitg.achievementOnFinish = achievements.ENUM.BACK_IN_THE_GAME
bitg.map = "back_in_the_game"
bitg.unlockTechAtStartTime = true
bitg.rivals = {
	"back_in_the_game_1",
	"back_in_the_game_2",
	"back_in_the_game_3"
}
bitg.rivalBuildings = {
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

bitg.startingEmployees = {
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
bitg.targetReputation = 60000
bitg.employeeCount = 60
bitg.yearLimit = timeline.DAYS_IN_YEAR * 20
bitg.startingUserCount = 2000000
bitg.startingReputation = 5000
bitg.campaignFinishedText = _T("BACK_IN_THE_GAME_FINISHED_TEXT", "Congratulations, you've finished the 'SCENARIO' scenario! From this point onwards it's pure freeplay, so play for as long as you'd like or start another scenario to try your hand at another challenge!")
bitg.startingGeneratedEngines = 6
bitg.startingEngineFeatureCountMultiplier = 0.9
bitg.startingEngineName = _T("BITG_STARTING_ENGINE", "inTech 1.0")
bitg.headerText = _T("RECOMMENDED_AFTER_STORY_MODE", "Recommended after Story Mode!")
bitg.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}

function bitg:begin()
	self:setupStartingTime()
	characterDesigner:begin(nil, self.startingSkillLevel)
end

function bitg:formatDescription()
	return string.easyformatbykeys(self.description, "EMPLOYEES", self.employeeCount, "REP", string.comma(self.targetReputation), "YEARS", self.yearLimit / timeline.DAYS_IN_YEAR, "RIVALS", #self.rivals)
end

function bitg:startCallback()
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
end

function bitg:postStartCallback()
	engineLicensing:generateEngines(self.startingGeneratedEngines)
end

function bitg:load()
	self:setupObjectives()
	
	for key, employee in ipairs(studio:getEmployees()) do
		if employee:isPlayerCharacter() then
			self.playerCharacter = employee
			
			break
		end
	end
end

function bitg:setupObjectives()
	objectiveHandler:setMaxObjectives(1)
	objectiveHandler:addObjectivesToList(self.objectiveList)
end

function bitg:handleEvent(event, objectiveObject)
	if objectiveObject:getID() == self.objectiveList[#self.objectiveList] then
		game.createStatsPopup(_format(self.campaignFinishedText, "SCENARIO", self.name))
		game.logFinishedCampaign(self.id)
	end
end

game.registerGameType(bitg)
