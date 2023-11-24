local newPlatformTask = {}

newPlatformTask.id = "new_platform_task"
newPlatformTask.CHANGE_PER_DAY = 1
newPlatformTask.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY
}
newPlatformTask.EVENTS = {
	FINISHED = events:new()
}

function newPlatformTask:init()
	newPlatformTask.baseClass.init(self)
	
	self.completionValue = 0
	self.eventValue = 0
	self.moneyTime = 0
	self.stage = 1
end

function newPlatformTask:setFirstStageWorkAmount(amt)
	self.firstStageWork = amt
end

function newPlatformTask:getFirstStageWorkAmount()
	return self.firstStageWork
end

function newPlatformTask:setCompletionValue(val)
	self.completionValue = val
end

function newPlatformTask:getCompletionValue()
	return self.completionValue
end

function newPlatformTask:start()
	self:initEventHandler()
	self:createUIElement()
end

function newPlatformTask:createUIElement()
	if not self.displayCreated then
		self.displayCreated = true
		
		local element = game.projectBox:addElement(self, nil, nil, "ActivePlatformDevelopmentElement")
		
		element:setID(self.platform:getID())
	end
end

function newPlatformTask:getProjectBoxText()
	return _T("TASK_NEW_PLATFORM_DEVELOPMENT", "New platform development")
end

function newPlatformTask:getName()
	return _T("TASK_NEW_PLATFORM", "new platform")
end

function newPlatformTask:getText()
	return _T("TASK_NEW_PLATFORM_CAPITALIZED", "New platform")
end

function newPlatformTask:initEventHandler()
	events:addDirectReceiver(self, newPlatformTask.CATCHABLE_EVENTS)
	events:addFunctionReceiver(self, self.handleCancel, playerPlatform.EVENTS.CANCELLED_DEVELOPMENT)
	events:addFunctionReceiver(self, self.handleRelease, playerPlatform.EVENTS.PLATFORM_RELEASED)
end

function newPlatformTask:removeEventHandler()
	events:removeDirectReceiver(self, newPlatformTask.CATCHABLE_EVENTS)
	events:removeFunctionReceiver(self, playerPlatform.EVENTS.CANCELLED_DEVELOPMENT)
	events:removeFunctionReceiver(self, playerPlatform.EVENTS.PLATFORM_RELEASED)
end

function newPlatformTask:setPlatform(obj)
	self.platform = obj
	
	self.platform:setDevTask(self)
	studio:addDevPlayerPlatform(self.platform)
end

function newPlatformTask:getPlatform()
	return self.platform
end

function newPlatformTask:handleCancel(obj)
	if obj == self.platform then
		self:cancel()
	end
end

function newPlatformTask:handleRelease(obj)
	if obj == self.platform then
		self:finalizeRelease()
	end
end

function newPlatformTask:cancel()
	newPlatformTask.baseClass.cancel(self)
	self:removeEventHandler()
	studio:removeTask(self)
	studio:removeDevPlayerPlatform(self.platform)
	self.platform:destroy()
end

function newPlatformTask:handleEvent(event)
	self:progress(newPlatformTask.CHANGE_PER_DAY)
end

function newPlatformTask:progress(change)
	if self.finished then
		return 
	end
	
	self.finishedWork = self.finishedWork + change
	self.completionValue = self.completionValue + change
	
	local newVal = self.eventValue + 1
	
	self.eventValue = newVal
	
	local days = timeline.DAYS_IN_MONTH
	
	self.moneyTime = self.moneyTime + 1
	
	if days <= self.moneyTime then
		self.moneyTime = self.moneyTime - days
		
		local cost = self.platform:getDevCost()
		
		studio:deductFunds(cost)
		self.platform:changeDevCosts(cost)
		self.platform:changeMoneySpent(cost)
		self.platform:updateFundChange(-cost)
	end
	
	if self.finishedWork >= self.firstStageWork and self.platform:getDevStage() ~= playerPlatform.DEV_STAGE then
		self.platform:setDevStage(playerPlatform.DEV_STAGE)
	end
	
	if self.finishedWork >= self.requiredWork then
		self:onFinish()
	elseif days <= newVal then
		self.eventValue = newVal - days
	end
end

function newPlatformTask:isDone()
	return self.finished
end

function newPlatformTask:onFinish()
	self.finished = true
	
	self.platform:setCompletionValue(self.platform:getMinimumWork())
	self.platform:onFinish()
end

function newPlatformTask:confirmRelease()
	self.platform:release()
end

function newPlatformTask:finalizeRelease()
	studio:removeTask(self)
	self:removeEventHandler()
	events:fire(newPlatformTask.EVENTS.FINISHED, self)
end

function newPlatformTask:save()
	local saved = newPlatformTask.baseClass.save(self)
	
	saved.completionValue = self.completionValue
	saved.platform = self.platform:save()
	saved.eventValue = self.eventValue
	saved.moneyTime = self.moneyTime
	saved.firstStageWork = self.firstStageWork
	saved.finished = self.finished
	
	return saved
end

function newPlatformTask:load(data)
	newPlatformTask.baseClass.load(self, data)
	
	self.completionValue = data.completionValue
	self.eventValue = data.eventValue
	self.moneyTime = data.moneyTime
	self.firstStageWork = data.firstStageWork
	self.finished = data.finished
	self.platform = playerPlatform.new()
	
	self.platform:setDevTask(self)
	self.platform:load(data.platform)
	self:start()
	studio:addDevPlayerPlatform(self.platform)
end

task:registerNew(newPlatformTask)
