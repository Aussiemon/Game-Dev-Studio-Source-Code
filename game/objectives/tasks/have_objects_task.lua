local haveObjectsTask = {}

haveObjectsTask.id = "have_objects"
haveObjectsTask.updateOnEvent = nil

function haveObjectsTask:initConfig(cfg)
	haveObjectsTask.baseClass.initConfig(self, cfg)
	
	self.requiredAmount = cfg.amount
	self.objectClass = cfg.objectClass
	self.totalObjects = 0
end

function haveObjectsTask:onStart()
	haveObjectsTask.baseClass.onStart(self)
	self:checkCompletion()
end

function haveObjectsTask:getProgressValues()
	return self.totalObjects, self.requiredAmount
end

function haveObjectsTask:checkCompletion()
	self:updateObjectCount()
	
	if self.totalObjects >= self.requiredAmount then
		self.completed = true
	end
end

function haveObjectsTask:updateObjectCount()
	local old = self.totalObjects
	
	self.totalObjects = 0
	
	for key, officeObj in ipairs(studio:getOwnedBuildings()) do
		local objectList = officeObj:getObjectsByClass(self.objectClass)
		
		if objectList then
			for key, object in ipairs(objectList) do
				if object:canBeUsed() then
					self.totalObjects = self.totalObjects + 1
				end
			end
		end
	end
	
	if old ~= self.totalObjects then
		events:fire(objectiveHandler.EVENTS.UPDATE_PROGRESS_DISPLAY, self)
	end
end

function haveObjectsTask:handleEvent(event, newObject)
	if self.updateOnEvent[event] then
		events:fire(objectiveHandler.EVENTS.UPDATE_PROGRESS_DISPLAY, self)
		self:checkCompletion()
	end
end

objectiveHandler:registerNewTask(haveObjectsTask, "base_task")
