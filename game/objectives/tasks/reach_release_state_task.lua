local reachReleaseStateTask = {}

reachReleaseStateTask.id = "reach_release_state"

function reachReleaseStateTask:initConfig(cfg)
	reachReleaseStateTask.baseClass.initConfig(self, cfg)
	
	self.completed = false
end

function reachReleaseStateTask:handleEvent(event, gameProj)
	if event == gameProject.EVENTS.REACHED_RELEASE_STATE and gameProj:getOwner() == studio then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(reachReleaseStateTask, "wait_for_event")
