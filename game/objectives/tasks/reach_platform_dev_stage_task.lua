local reachPlatformDevStage = {}

reachPlatformDevStage.id = "reach_platform_dev_stage"

function reachPlatformDevStage:initConfig(cfg)
	reachPlatformDevStage.baseClass.initConfig(self, cfg)
	
	self.completed = false
	self.stage = cfg.stage
end

function reachPlatformDevStage:isFinished()
	return self.completed
end

function reachPlatformDevStage:getProgressValues()
	return self.completed and 1 or 0, 1
end

function reachPlatformDevStage:handleEvent(event, platObj)
	if event == playerPlatform.EVENTS.DEV_STAGE_SET and platObj:getDevStage() >= self.stage then
		self.completed = true
	end
end

function reachPlatformDevStage:save()
	local saved = reachPlatformDevStage.baseClass.save(self)
	
	saved.completed = self.completed
	
	return saved
end

function reachPlatformDevStage:load(data)
	reachPlatformDevStage.baseClass.load(self, data)
	
	self.completed = data.completed
end

objectiveHandler:registerNewTask(reachPlatformDevStage, "base_task")
