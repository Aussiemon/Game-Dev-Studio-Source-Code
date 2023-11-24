local reachReputationTask = {}

reachReputationTask.id = "reach_reputation"

function reachReputationTask:initConfig(cfg)
	reachReputationTask.baseClass.initConfig(self, cfg)
	
	self.requiredReputation = cfg.requiredReputation
end

function reachReputationTask:getProgressValues()
	return math.floor(studio:getReputation()), self.requiredReputation
end

function reachReputationTask:handleEvent(event, change, company)
	if event == studio.EVENTS.REPUTATION_CHANGED then
		if company:isPlayer() and company:getReputation() >= self.requiredReputation then
			self.completed = true
		end
	elseif event == timeline.EVENTS.NEW_DAY and studio:getReputation() >= self.requiredReputation then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(reachReputationTask, "base_task")
