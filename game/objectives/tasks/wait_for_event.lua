local waitForEventTask = {}

waitForEventTask.id = "wait_for_event"

function waitForEventTask:initConfig(cfg)
	waitForEventTask.baseClass.initConfig(self, cfg)
	
	self.completed = false
	self.eventToCatch = cfg.event
end

function waitForEventTask:isFinished()
	return self.completed
end

function waitForEventTask:getProgressValues()
	return self.completed and 1 or 0, 1
end

function waitForEventTask:handleEvent(event)
	if event == self.eventToCatch then
		self.completed = true
	end
end

function waitForEventTask:save()
	local saved = waitForEventTask.baseClass.save(self)
	
	saved.completed = self.completed
	
	return saved
end

function waitForEventTask:load(data)
	waitForEventTask.baseClass.load(self, data)
	
	self.completed = data.completed
end

objectiveHandler:registerNewTask(waitForEventTask, "base_task")
