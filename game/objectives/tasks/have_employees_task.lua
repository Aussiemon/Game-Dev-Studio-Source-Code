local haveEmployeesTask = {}

haveEmployeesTask.id = "have_employees"

function haveEmployeesTask:initConfig(cfg)
	haveEmployeesTask.baseClass.initConfig(self, cfg)
	
	self.employeeCount = cfg.employeeCount
	
	self:checkCompletion()
end

function haveEmployeesTask:getProgressValues()
	return #studio:getEmployees(), self.employeeCount
end

function haveEmployeesTask:checkCompletion()
	if #studio:getEmployees() >= self.employeeCount then
		self.completed = true
	end
end

function haveEmployeesTask:handleEvent(event, company)
	if event == studio.EVENTS.EMPLOYEE_COUNT_CHANGED and company == studio and self:checkCompletion() then
		self.completed = true
	end
end

function haveEmployeesTask:load(data)
	haveEmployeesTask.baseClass.load(self, data)
	
	if not self.completed then
		self:checkCompletion()
	end
end

objectiveHandler:registerNewTask(haveEmployeesTask, "base_task")
