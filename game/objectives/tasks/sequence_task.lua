local sequenceTask = {}

sequenceTask.id = "sequence"
sequenceTask.EVENTS = {
	TASK_ADVANCED = events:new()
}

function sequenceTask:initConfig(cfg)
	sequenceTask.baseClass.initConfig(self, cfg)
	
	self.tasks = {}
	self.currentTask = 1
	
	for key, taskData in ipairs(cfg.tasks) do
		local taskObject = objectiveHandler:createObjectiveTask(taskData, self.objective)
		
		table.insert(self.tasks, taskObject)
	end
end

function sequenceTask:onStart()
	local taskObject = self.tasks[self.currentTask]
	
	taskObject:setHasStarted(true)
	taskObject:onStart()
end

function sequenceTask:onFinish()
	for key, taskObject in ipairs(self.tasks) do
		sequenceTaskObject:onFinish()
	end
end

function sequenceTask:onGameLogicStarted()
	local taskObject = self.tasks[self.currentTask]
	
	if taskObject then
		taskObject:onGameLogicStarted()
	end
end

function sequenceTask:remove()
	for key, taskObject in ipairs(self.tasks) do
		taskObject:remove()
	end
end

function sequenceTask:getTasks()
	return self.tasks
end

function sequenceTask:getProgressData(targetList)
	for key, task in ipairs(self.tasks) do
		task:getProgressData(targetList)
	end
end

function sequenceTask:getProgressValues()
	return self.currentTask, #self.tasks
end

function sequenceTask:isFinished()
	return self.currentTask >= #self.tasks and self.tasks[self.currentTask]:isFinished()
end

function sequenceTask:handleEvent(...)
	if self.finishing then
		return 
	end
	
	local currentTask = self.tasks[self.currentTask]
	
	if not currentTask then
		return 
	end
	
	currentTask:handleEvent(...)
	
	if currentTask:isFinished() then
		self.finishing = true
		
		self:advanceTask(currentTask)
	end
	
	self.finishing = false
end

function sequenceTask:advanceTask(prevTask)
	local nextTask = self.tasks[self.currentTask + 1]
	
	if nextTask then
		self.currentTask = self.currentTask + 1
		
		prevTask:onFinish()
		nextTask:setHasStarted(true)
		nextTask:onStart()
		
		if nextTask:isFinished() then
			self:advanceTask(nextTask)
		end
		
		events:fire(sequenceTask.EVENTS.TASK_ADVANCED)
	else
		prevTask:onFinish()
	end
end

function sequenceTask:findLatestTask()
	for key, taskObject in ipairs(self.tasks) do
		if taskObject:isFinished() then
			if self.tasks[key + 1] then
				self.currentTask = key + 1
			else
				self.currentTask = key
			end
		end
	end
end

function sequenceTask:save()
	local saved = sequenceTask.baseClass.save(self)
	
	saved.tasks = {}
	
	for key, taskObject in ipairs(self.tasks) do
		table.insert(saved.tasks, taskObject:save())
	end
	
	return saved
end

function sequenceTask:load(data)
	sequenceTask.baseClass.load(self, data)
	
	for key, taskData in ipairs(data.tasks) do
		self.tasks[key]:load(taskData)
	end
	
	self:findLatestTask()
end

objectiveHandler:registerNewTask(sequenceTask, "base_task")
