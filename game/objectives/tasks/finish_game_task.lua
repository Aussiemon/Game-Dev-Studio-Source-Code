local finishGameTask = {}

finishGameTask.id = "finish_game"

function finishGameTask:initConfig(cfg)
	finishGameTask.baseClass.initConfig(self, cfg)
	
	self.completed = false
end

function finishGameTask:handleEvent(event, gameProj)
	if event == gameProject.ON_FINISHED_FIRE_EVENT and gameProj:getOwner() == studio then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(finishGameTask, "wait_for_event")
