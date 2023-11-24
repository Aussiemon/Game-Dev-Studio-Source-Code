objective = {}
objective.mtindex = {
	__index = objective
}

function objective.new()
	local new = {}
	
	setmetatable(new, objective.mtindex)
	new:init()
	
	return new
end

function objective:init()
	self.task = nil
	self.progressData = {}
end

function objective:getID()
	return self.id
end

function objective:loadConfig(config, savedTaskData)
	self.id = config.id
	self.config = config
	self.reward = self.config.reward
	
	if self.config.failState then
		self.failState = objectiveHandler:createFailState(self.config.failState, self)
	end
	
	self:initTask(savedTaskData)
end

function objective:getFailState()
	return self.failState
end

function objective:start()
	self.task:setHasStarted(true)
	self.task:onStart()
end

function objective:finish()
	self.finishTime = timeline.curTime
	
	if self.config.onFinish then
		self.config:onFinish(self)
	end
end

function objective:getFinishTime()
	return self.finishTime
end

function objective:getName()
	return self.config.name
end

function objective:getDescription()
	if self.config.getDescription then
		return self.config:getDescription(self)
	end
	
	return self.config.description
end

function objective:onGameLogicStarted()
	self.task:onGameLogicStarted()
end

function objective:getProgressData()
	table.clear(self.progressData)
	
	if self.config.getProgressData then
		self.config:getProgressData(self.progressData)
	end
	
	self.task:getProgressData(self.progressData)
	
	if self.failState and not self.failState:isDisabled() then
		self.failState:getProgressData(self.progressData)
	end
	
	return self.progressData
end

function objective:getIcon()
	return self.config.icon
end

function objective:setStartTime(time)
	self.startTime = time
end

function objective:getStartTime()
	return self.startTime
end

function objective:initTask(savedTaskData)
	self.task = objectiveHandler:createObjectiveTask(self.config.task, self)
	
	if savedTaskData then
		self.task:load(savedTaskData)
	end
end

function objective:remove()
	self.task:remove()
end

function objective:handleEvent(...)
	self.task:handleEvent(...)
	
	if self.failState and not self.failState:isDisabled() then
		self.failState:handleEvent(...)
	end
end

function objective:fail()
	self:onFail()
	objectiveHandler:removeObjective(self)
end

function objective:onFail()
end

function objective:getTask()
	return self.task
end

function objective:isFinished()
	return self.task:isFinished()
end

function objective:checkRequirements(requirements)
	if requirements and requirements.completedObjectives then
		for key, objectiveID in ipairs(requirements.completedObjectives) do
			if not objectiveHandler:isObjectiveComplete(objectiveID) then
				return false
			end
		end
	end
	
	return true
end

function objective:giveReward()
	if self.reward and self.reward.funds then
		studio:addFunds(self.reward.funds, nil, "misc")
	end
	
	self.rewardGiven = true
	
	objectiveHandler:onObjectiveClaimed(self)
end

function objective:attemptAutoClaim()
	if self.reward then
		if self.config.autoClaim then
			self:giveReward()
			self:finish()
			
			return true
		end
		
		return false
	end
	
	self:giveReward()
	self:finish()
	
	return true
end

function objective:save()
	local saved = {
		id = self.id,
		rewardGiven = self.rewardGiven,
		startTime = self.startTime,
		finishTime = self.finishTime,
		task = self.task:save()
	}
	
	if self.failState then
		saved.failState = self.failState:save()
	end
	
	return saved
end

function objective:load(data)
	self.rewardGiven = data.rewardGiven
	
	self:loadConfig(objectiveHandler:getObjectiveData(data.id), data.task)
	
	if data.failState and self.failState then
		self.failState:load(data.failState)
	end
	
	self.startTime = data.startTime
	self.finishTime = data.finishTime
end
