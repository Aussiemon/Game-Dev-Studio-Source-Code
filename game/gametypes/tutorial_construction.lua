local tutConstr = {}

tutConstr.id = "tutorial_construction"
tutConstr.trackCompletion = true
tutConstr.display = _T("TUTORIAL_CONSTRUCTION", "Tutorial - Construction")
tutConstr.description = _T("TUTORIAL_CONSTRUCTION_DESCRIPTION", "The go-to gametype for new players; get acquainted with the office construction mode of the game.")
tutConstr.orderWeight = 0
tutConstr.objectiveList = {
	"tutorial_construction_1",
	"tutorial_construction_employees",
	"tutorial_construction_projects"
}
tutConstr.startTime = timeline.DAYS_IN_MONTH * 4
tutConstr.restrictActions = {
	"scrap_game",
	"advertise_game",
	"game_conventions",
	"look_for_publisher",
	"contract_work",
	"trends"
}
tutConstr.THE_INVESTOR_STRING_NAME = _T("INVESTOR_NAME", "The Investor")
tutConstr.map = "tutorial"
tutConstr.rivals = {}
tutConstr.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}
tutConstr.allowPlatformAdvertisement = false
tutConstr.allowTrends = false
tutConstr.achievementOnFinish = achievements.ENUM.TUTORIAL
tutConstr.tutorial = true
tutConstr.checkTutorial = false
tutConstr.startMoney = 2000000
tutConstr.campaignFinishedText = _T("TUTORIAL_CONSTRUCTION_FINISHED_TEXT", "Congratulations, you've finished the Construction Tutorial!")
tutConstr.startingGeneratedEngines = 6
tutConstr.campaignFinishedText = _T("TUTORIAl_FINISHED", "Congratulations you've finished the Tutorial! With an understanding of the basics in mind, your next suggested step is to try the Introduction scenario!")
tutConstr.startingHUDVisibility = 1
tutConstr.headerText = _T("TUTORIAL_RECOMMENDED", "Recommended for new players!")
tutConstr.headerIcon = "question_mark"

local hudBottom = gui.getClassTable("HUDBottom")

tutConstr.hudRestrictions = {
	{
		[hudBottom.PROJECTS_BUTTON_ID] = true,
		[hudBottom.EMPLOYEES_BUTTON_ID] = true,
		[hudBottom.OFFICE_PREFERENCES_BUTTON_ID] = true
	},
	{
		[hudBottom.PROJECTS_BUTTON_ID] = true,
		[hudBottom.OFFICE_PREFERENCES_BUTTON_ID] = true
	},
	{}
}

function tutConstr:getHUDRestrictions()
	return self.hudRestrictions[self.hudVisibility]
end

function tutConstr:postStartCallback()
	engineLicensing:generateEngines(self.startingGeneratedEngines)
end

function tutConstr:setHUDVisibility(index)
	self.hudVisibility = index
	
	local hud = game.getHUD()
	
	if hud then
		hud:finalize()
	end
end

function tutConstr:setPlaylist(initialSet)
	if initialSet then
		musicPlayback:getPlaylist(musicPlayback.PLAYLIST_IDS.GAMEPLAY_PARTIAL):setFirstTrack(musicPlayback.GAMEPLAY_TRACKS_FOLDER .. "dream_project.ogg")
	end
	
	tutConstr.baseClass.setPlaylist(self)
end

function tutConstr:preventAchievements()
	return true
end

function tutConstr:startCallback()
	tutConstr.baseClass.startCallback(self)
	self:setHUDVisibility(self.startingHUDVisibility)
	objectiveHandler:setMaxObjectives(1)
	objectiveHandler:addObjectivesToList(self.objectiveList)
	interactionRestrictor:restrictActions(self.restrictActions)
	game.logStartedCampaign(self.id)
end

function tutConstr:save(saveDest)
	saveDest.hudVisibility = self.hudVisibility
end

function tutConstr:load(data)
	objectiveHandler:setMaxObjectives(1)
	objectiveHandler:addObjectivesToList(self.objectiveList)
	self:setHUDVisibility(data.hudVisibility)
end

function tutConstr:handleEvent(event, objectiveObject)
	if objectiveObject:getID() == self.objectiveList[#self.objectiveList] then
		game.createStatsPopup(self.campaignFinishedText)
		game.logFinishedCampaign(self.id)
	end
end

game.registerGameType(tutConstr, "standard")
