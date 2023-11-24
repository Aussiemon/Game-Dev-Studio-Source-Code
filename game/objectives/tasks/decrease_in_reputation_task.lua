local reachReputationTask = {}

reachReputationTask.id = "decrease_in_reputation"

function reachReputationTask:initConfig(cfg)
	reachReputationTask.baseClass.initConfig(self, cfg)
end

function reachReputationTask:handleEvent(event, change, company)
	if event == studio.EVENTS.REPUTATION_CHANGED and company:isPlayer() and change < 0 then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(reachReputationTask, "base_task")
