local optionalTask = {}

optionalTask.id = "optional_task"

function optionalTask:initConfig(cfg)
	optionalTask.baseClass.initConfig(self, cfg)
	
	self.checkMethod = cfg.checkMethod
end

function optionalTask:onStart()
	if self.config:startCheck(self) then
		self.completed = true
		
		print("ye it's REDEY")
	end
end

function optionalTask:checkCompletion(event, ...)
	if self.checkMethod(self.config, self, event, ...) then
		self.completed = true
	end
end

function optionalTask:handleEvent(event, ...)
	self:checkCompletion(event, ...)
end

objectiveHandler:registerNewTask(optionalTask, "base_task")
