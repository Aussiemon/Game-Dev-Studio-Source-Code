local waitForTime = {}

waitForTime.id = "wait_for_time"

function waitForTime:initConfig(cfg)
	waitForTime.baseClass.initConfig(self, cfg)
	
	self.completed = false
	self.time = cfg.time
	self.waitedTime = 0
end

function waitForTime:isFinished()
	return self.completed
end

function waitForTime:getProgressValues()
	return self.completed and 1 or 0, 1
end

function waitForTime:handleEvent(event)
	if event == timeline.EVENTS.NEW_DAY then
		local time = self.waitedTime + 1
		
		self.waitedTime = time
		
		if time > self.time then
			self.completed = true
		end
	end
end

function waitForTime:save()
	local saved = waitForTime.baseClass.save(self)
	
	saved.completed = self.completed
	saved.waitedTime = self.waitedTime
	
	return saved
end

function waitForTime:load(data)
	waitForTime.baseClass.load(self, data)
	
	self.completed = data.completed
	self.waitedTime = data.waitedTime
end

objectiveHandler:registerNewTask(waitForTime, "base_task")
