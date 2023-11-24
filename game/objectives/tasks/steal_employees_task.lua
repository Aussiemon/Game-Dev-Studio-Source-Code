local stealEmployeesTask = {}

stealEmployeesTask.id = "steal_employees"

function stealEmployeesTask:initConfig(cfg)
	stealEmployeesTask.baseClass.initConfig(self, cfg)
	
	self.amount = cfg.amount or 1
	self.stolenEmployees = 0
end

function stealEmployeesTask:isFinished()
	return self.stolenEmployees >= self.amount
end

function stealEmployeesTask:getProgressValues()
	return self.stolenEmployees, self.amount
end

function stealEmployeesTask:handleEvent(event)
	if event == rivalGameCompany.EVENTS.PLAYER_SUCCEED_STEAL then
		self.stolenEmployees = self.stolenEmployees + 1
	end
end

function stealEmployeesTask:save()
	local saved = stealEmployeesTask.baseClass.save(self)
	
	saved.stolenEmployees = self.stolenEmployees
	
	return saved
end

function stealEmployeesTask:load(data)
	stealEmployeesTask.baseClass.load(self, data)
	
	self.stolenEmployees = data.stolenEmployees
end

objectiveHandler:registerNewTask(stealEmployeesTask, "base_task")
