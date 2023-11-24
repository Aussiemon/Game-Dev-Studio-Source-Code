local haveWorkplacesTask = {}

haveWorkplacesTask.id = "have_workplaces"
haveWorkplacesTask.updateOnEvent = nil

function haveWorkplacesTask:initConfig(cfg)
	haveWorkplacesTask.baseClass.initConfig(self, cfg)
	
	self.requiredAmount = cfg.amount
	self.totalWorkplaces = 0
end

function haveWorkplacesTask:getProgressValues()
	return self.totalWorkplaces, self.requiredAmount
end

function haveWorkplacesTask:onStart()
	haveWorkplacesTask.baseClass.onStart(self)
	self:checkCompletion()
end

function haveWorkplacesTask:checkCompletion()
	self:updateWorkplaceCount()
	
	if self.totalWorkplaces >= self.requiredAmount then
		self.completed = true
	end
end

function haveWorkplacesTask:updateWorkplaceCount()
	local old = self.totalWorkplaces
	
	self.totalWorkplaces = 0
	
	for key, officeObj in ipairs(studio:getOwnedBuildings()) do
		self.totalWorkplaces = self.totalWorkplaces + #officeObj:getWorkplaces()
	end
	
	if old ~= self.totalWorkplaces then
		events:fire(objectiveHandler.EVENTS.UPDATE_PROGRESS_DISPLAY, self)
	end
end

function haveWorkplacesTask:handleEvent(event, newObject)
	if self.updateOnEvent[event] then
		self:checkCompletion()
	end
end

objectiveHandler:registerNewTask(haveWorkplacesTask, "base_task")
