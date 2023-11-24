local reachReputationTask = {}

reachReputationTask.id = "wait_for_bad_game"

function reachReputationTask:initConfig(cfg)
	reachReputationTask.baseClass.initConfig(self, cfg)
end

function reachReputationTask:handleEvent(event, gameObject, company)
	if event == gameProject.EVENTS.NEW_REVIEW and gameObject:getOwner():isPlayer() and gameObject:getReviewRating() <= studio.BAD_GAME_SCORE_THRESHOLD then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(reachReputationTask, "base_task")
