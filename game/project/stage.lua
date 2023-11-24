devStage = {}
devStage.mtindex = {
	__index = devStage
}

function devStage.new()
	local new = {}
	
	setmetatable(new, devStage.mtindex)
	new:init()
	
	return new
end

function devStage:init()
	self.tasks = {}
	self.requiredWork = 0
	self.finishedWork = 0
	self.discoveredIssues = 0
	self.fixedIssues = 0
	self.taskCount = 0
end

function devStage:resetWorkData()
	self.requiredWork = 0
	self.finishedWork = 0
end

function devStage:resetIssueData()
	self.fixedIssues = 0
	self.discoveredIssues = 0
end

function devStage:addRequiredWork(work)
	self.requiredWork = self.requiredWork + work
end

function devStage:addFinishedWork(work)
	self.finishedWork = self.finishedWork + work
end

function devStage:onDiscoverIssue()
	self.discoveredIssues = self.discoveredIssues + 1
end

function devStage:onFixIssue()
	self.fixedIssues = self.fixedIssues + 1
end

function devStage:areIssuesFixed()
	return self.fixedIssues >= self.discoveredIssues
end

function devStage:isDone()
	return self.finishedWork >= self.requiredWork and self.fixedIssues >= self.discoveredIssues
end

function devStage:isWorkFinished()
	return self.finishedWork >= self.requiredWork
end

function devStage:getWorkAmounts()
	return self.finishedWork, self.requiredWork
end

function devStage:getCompletion()
	return self.finishedWork / self.requiredWork
end

function devStage:addTask(task)
	table.insert(self.tasks, task)
	
	self.requiredWork = self.requiredWork + task:getRequiredWork()
	self.taskCount = self.taskCount + 1
end

function devStage:clearTasks()
	table.clearArray(self.tasks)
	
	self.taskCount = 0
end

function devStage:getTasks()
	return self.tasks
end

function devStage:onProjectFinished()
	for key, taskObject in ipairs(self.tasks) do
		taskObject:onProjectFinished()
	end
end

function devStage:hasAtLeastOneDiscoveredIssue()
	for key, taskObject in ipairs(self.tasks) do
		if not taskObject:areAllIssuesFixed() then
			return true
		end
	end
	
	return false
end

function devStage:save()
	local saved = {
		tasks = {},
		finishedWork = self.finishedWork,
		fixedIssues = self.fixedIssues,
		discoveredIssues = self.discoveredIssues
	}
	
	for key, taskObj in ipairs(self.tasks) do
		table.insert(saved.tasks, taskObj:save())
	end
	
	return saved
end

function devStage:load(data, projectObject)
	self.finishedWork = data.finishedWork
	self.fixedIssues = data.fixedIssues
	self.discoveredIssues = data.discoveredIssues
	
	for key, taskData in ipairs(data.tasks) do
		local taskTypeData = taskTypes.registeredByID[taskData.taskType]
		
		if taskTypeData then
			local newTask = task.new(taskData.id)
			
			newTask:setProject(projectObject)
			newTask:load(taskData)
			self:addTask(newTask)
		end
	end
end
