local hireEmployeesTask = {}

hireEmployeesTask.id = "hire_employees_task"

function hireEmployeesTask:handleEvent(event, employee)
	if event == studio.EVENTS.EMPLOYEE_HIRED and employee:getEmployer():isPlayer() then
		local role = employee:getRole()
		
		self:increaseRoleCounter(role)
		
		if self:checkCompletion() then
			self.completed = true
		end
	end
end

objectiveHandler:registerNewTask(hireEmployeesTask, "send_job_offer_task")
