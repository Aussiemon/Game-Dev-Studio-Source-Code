local storyMode = {}

storyMode.id = "story_mode"
storyMode.trackCompletion = true
storyMode.display = _T("STORY_MODE", "Introduction")
storyMode.description = _T("STORY_MODE_DESCRIPTION", "The go-to gametype for new players after completing the tutorial.\n\nStart out with $MONEY in a tiny office with your own player character that learns everything LEARN_SPEED times as fast, and slowly make your way to the top.\n\nYou will need to follow the Investor's instructions with some of the tasks being on a time limit.")
storyMode.objectiveList = {
	"getting_started",
	"vroom_vroom",
	"the_journey",
	"on_my_own",
	"climbing_the_ladder",
	"a_formidable_reputation",
	"first_contact_1",
	"an_eye_for_an_eye"
}
storyMode.startTime = timeline.DAYS_IN_MONTH * 4 + 0.001
storyMode.orderWeight = 1
storyMode.restrictActions = {
	"contract_work",
	"engine_licensing",
	"interviews",
	"game_convention",
	"generic_project_interaction",
	"generic_game_interaction",
	"rival_game_companies",
	"story_mode_1",
	"player_steal_employees",
	"player_slander",
	"buyout_rivals"
}
storyMode.THE_INVESTOR_STRING_NAME = _T("INVESTOR_NAME", "The Investor")
storyMode.map = "story_mode"
storyMode.rivals = {
	"rival_company_1"
}
storyMode.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}
storyMode.checkTutorial = false
storyMode.startMoney = 100000
storyMode.campaignFinishedText = _T("STORY_MODE_FINISHED_TEXT", "Congratulations, you've finished the Story Mode! You can keep playing onwards, or start one of the Scenarios to try your hand in a different starting setting and be faced with completely different challenges!")
storyMode.headerText = _T("STORY_MODE_RECOMMENDED", "Recommended for new players!")
storyMode.headerIcon = "question_mark"
game.TUTORIAL_CAMPAIGN_ID = "story_mode"

function storyMode:setPlaylist(initialSet)
	if initialSet then
		musicPlayback:getPlaylist(musicPlayback.PLAYLIST_IDS.GAMEPLAY_PARTIAL):setFirstTrack(musicPlayback.GAMEPLAY_TRACKS_FOLDER .. "dream_project.ogg")
	end
	
	storyMode.baseClass.setPlaylist(self)
end

function storyMode:startCallback()
	storyMode.baseClass.startCallback(self)
	objectiveHandler:setMaxObjectives(1)
	objectiveHandler:addObjectivesToList(self.objectiveList)
	interactionRestrictor:restrictActions(self.restrictActions)
	game.logStartedCampaign(self.id)
end

function storyMode:formatDescription()
	return string.easyformatbykeys(self.description, "YEARS", self.playerCharacterFinishAge - self.playerCharacterStartAge, "MONEY", string.comma(self.startMoney), "LEARN_SPEED", self.playerCharacterLearnSpeedMultiplier)
end

function storyMode:load()
	objectiveHandler:setMaxObjectives(1)
	objectiveHandler:addObjectivesToList(self.objectiveList)
end

function storyMode:handleEvent(event, objectiveObject)
	if objectiveObject:getID() == self.objectiveList[#self.objectiveList] then
		game.createStatsPopup(self.campaignFinishedText)
		game.logFinishedCampaign(self.id)
	end
end

game.registerGameType(storyMode, "standard")

game.registeredDialogueNames = {}

function game.registerDialogueName(id, name)
	game.registeredDialogueNames[id] = name
end

function game.getDialogueName(id)
	return game.registeredDialogueNames[id]
end

function game.getInvestorName()
	return storyMode.THE_INVESTOR_STRING_NAME
end

game.registerDialogueName("investor", storyMode.THE_INVESTOR_STRING_NAME)
