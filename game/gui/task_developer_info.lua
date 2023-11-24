local taskDevInfo = {}

taskDevInfo.formatTable = {}

function taskDevInfo:init()
end

function taskDevInfo:setEmployee(emp)
	self.employee = emp
	
	self:updateText()
end

function taskDevInfo:updateText()
	local name, surname = self.employee:getFullName()
	local baseText = _T("EMPLOYEE_TASK_AND_PROJECT_LAYOUT", "Project: PROJECT\nTask: TASK")
	local na = _T("NA", "N/A")
	local team = self.employee:getTeam()
	local curProject
	
	if team then
		curProject = team:getProject()
	end
	
	local curTask = self.employee:getTask()
	
	taskDevInfo.formatTable.PROJECT = curProject and curProject:getName() or na
	taskDevInfo.formatTable.TASK = curTask and curTask:getName() or na
	self.baseText = string.formatbykeys(baseText, taskDevInfo.formatTable)
	
	self:scaleToText()
end

gui.register("TaskDeveloperInfo", taskDevInfo, "BasicDeveloperInfo")
