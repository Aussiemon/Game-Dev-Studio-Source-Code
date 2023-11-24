local getFundsTask = {}

getFundsTask.id = "get_funds"

function getFundsTask:initConfig(cfg)
	getFundsTask.baseClass.initConfig(self, cfg)
	
	self.requiredFunds = cfg.amount
	self.accumulatedFunds = 0
end

function getFundsTask:isFinished()
	return self.accumulatedFunds >= self.requiredFunds
end

function getFundsTask:getProgressValues()
	return self.accumulatedFunds, self.requiredFunds
end

function getFundsTask:handleEvent(event, change, newAmount, quiet)
	if event == studio.EVENTS.FUNDS_CHANGED and change > 0 and not quiet then
		self.accumulatedFunds = self.accumulatedFunds + change
	end
end

function getFundsTask:save()
	local saved = getFundsTask.baseClass.save(self)
	
	saved.accumulatedFunds = self.accumulatedFunds
	
	return saved
end

function getFundsTask:load(data)
	getFundsTask.baseClass.load(self, data)
	
	self.accumulatedFunds = data.accumulatedFunds
end

objectiveHandler:registerNewTask(getFundsTask, "base_task")
