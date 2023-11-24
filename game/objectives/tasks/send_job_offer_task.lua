local haveEmployeesTask = {}

haveEmployeesTask.id = "send_job_offer_task"

function haveEmployeesTask:initConfig(cfg)
	haveEmployeesTask.baseClass.initConfig(self, cfg)
	
	self.requiredRoles = cfg.requiredRoles
	self.hiredByRole = {}
	self.totalMax = 0
	
	for key, data in ipairs(self.requiredRoles) do
		self.hiredByRole[data[1]] = 0
		self.totalMax = self.totalMax + data[2]
	end
	
	self:checkCompletion()
end

function haveEmployeesTask:getProgressValues()
	return self.overallProgress, self.totalMax
end

function haveEmployeesTask:getProgressTable()
	return self.hiredByRole
end

function haveEmployeesTask:checkCompletion()
	local hireCounter = self.hiredByRole
	local valid = true
	
	self.overallProgress = 0
	
	for key, data in ipairs(self.requiredRoles) do
		local amount = hireCounter[data[1]]
		local required = data[2]
		
		self.overallProgress = self.overallProgress + math.min(amount, required)
		
		if amount < required then
			valid = false
		end
	end
	
	if valid then
		self.completed = true
	end
end

function haveEmployeesTask:handleEvent(event, employee)
	if event == employeeCirculation.EVENTS.JOB_OFFER_SENT then
		local role = employee:getRole()
		
		self:increaseRoleCounter(role)
		
		if self:checkCompletion() then
			self.completed = true
		end
	end
end

function haveEmployeesTask:increaseRoleCounter(role)
	self.hiredByRole[role] = (self.hiredByRole[role] or 0) + 1
end

function haveEmployeesTask:save()
	local saved = haveEmployeesTask.baseClass.save(self)
	
	saved.hiredByRole = self.hiredByRole
	
	return saved
end

function haveEmployeesTask:load(data)
	haveEmployeesTask.baseClass.load(self, data)
	
	self.hiredByRole = data.hiredByRole
	
	if not self.completed then
		self:checkCompletion()
	end
end

objectiveHandler:registerNewTask(haveEmployeesTask, "base_task")
