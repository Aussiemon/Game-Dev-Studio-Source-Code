objectiveHandler = {}
objectiveHandler.maxObjectives = 0
objectiveHandler.registeredObjectives = {}
objectiveHandler.registeredObjectivesByID = {}
objectiveHandler.registeredTasks = {}
objectiveHandler.registeredTasksByID = {}
objectiveHandler.registeredFailStates = {}
objectiveHandler.registeredFailStatesByID = {}
objectiveHandler.EVENTS = {
	CLAIMED_OBJECTIVE = events:new(),
	FINISH_OBJECTIVE = events:new(),
	FILLED_OBJECTIVES = events:new(),
	UPDATE_PROGRESS_DISPLAY = events:new(),
	TASK_FINISHED = events:new()
}

function objectiveHandler:registerNewTask(data, baseClassID)
	data.mtindex = {
		__index = data
	}
	self.registeredTasks[#self.registeredTasks + 1] = data
	self.registeredTasksByID[data.id] = data
	
	if baseClassID then
		local baseClass = self.registeredTasksByID[baseClassID]
		
		setmetatable(data, baseClass.mtindex)
		
		data.baseClass = baseClass
	end
end

function objectiveHandler:getTaskData(id)
	return self.registeredTasksByID[id]
end

function objectiveHandler:registerNewFailState(data, baseClassID)
	data.mtindex = {
		__index = data
	}
	self.registeredFailStates[#self.registeredFailStates + 1] = data
	self.registeredFailStatesByID[data.id] = data
	
	if baseClassID then
		local baseClass = self.registeredFailStatesByID[baseClassID]
		
		setmetatable(data, baseClass.mtindex)
		
		data.baseClass = baseClass
	end
end

function objectiveHandler:registerNewObjective(data, inherit)
	data.icon = data.icon or "quest_getting_started"
	self.registeredObjectives[#self.registeredObjectives + 1] = data
	self.registeredObjectivesByID[data.id] = data
	
	if inherit then
		setmetatable(data, self.registeredObjectivesByID[inherit].mtindex)
	end
	
	data.mtindex = {
		__index = data
	}
	
	return data
end

function objectiveHandler:init()
	self.objectives = self.objectives or {}
	self.completedObjectives = self.completedObjectives or {}
	self.objectiveList = {}
	
	events:addReceiver(self)
end

function objectiveHandler:remove()
	for key, objectiveObj in ipairs(self.objectives) do
		objectiveObj:remove()
		
		self.objectives[key] = nil
	end
	
	table.clear(self.objectiveList)
	table.clear(self.completedObjectives)
	events:removeReceiver(self)
end

function objectiveHandler:addObjectivesToList(objectiveData)
	if type(objectiveData) == "string" then
		table.insert(self.objectiveList, objectiveData)
	elseif type(objectiveData) == "table" then
		for key, objectiveID in ipairs(objectiveData) do
			table.insert(self.objectiveList, objectiveID)
		end
	end
end

function objectiveHandler:setMaxObjectives(maxObjectives)
	self.maxObjectives = maxObjectives
end

function objectiveHandler:isObjectiveComplete(objID)
	return self.completedObjectives[objID]
end

function objectiveHandler:getObjectiveData(id)
	return objectiveHandler.registeredObjectivesByID[id]
end

function objectiveHandler:createObjective(objectiveCfg)
	local objectiveObj = objective.new()
	
	objectiveObj:loadConfig(objectiveCfg)
	objectiveObj:setStartTime(timeline.curTime)
	
	return objectiveObj
end

function objectiveHandler:createObjectiveTask(taskData, objectiveObject)
	local new = {}
	
	if taskData.overrides then
		setmetatable(new, objectiveHandler.registeredTasksByID.story_wrapper.mtindex)
	else
		setmetatable(new, objectiveHandler.registeredTasksByID[taskData.id].mtindex)
	end
	
	new:init(objectiveObject)
	new:initConfig(taskData)
	
	return new
end

function objectiveHandler:createFailState(failStateData, objectiveObject)
	local new = {}
	
	setmetatable(new, objectiveHandler.registeredFailStatesByID[failStateData.id].mtindex)
	new:init(objectiveObject, failStateData)
	
	return new
end

function objectiveHandler:removeObjective(objectiveObj)
	table.removeObject(self.objectives, objectiveObj)
end

function objectiveHandler:onObjectiveClaimed(objectiveObj)
	self.completedObjectives[objectiveObj:getID()] = true
	
	self:removeObjective(objectiveObj)
	events:fire(objectiveHandler.EVENTS.CLAIMED_OBJECTIVE, objectiveObj)
end

function objectiveHandler:handleEvent(event, ...)
	local autoClaimed = false
	local curIndex = 1
	
	for i = 1, #self.objectives do
		local objectiveObj = self.objectives[curIndex]
		
		if not objectiveObj:isFinished() then
			objectiveObj:handleEvent(event, ...)
			
			if objectiveObj:isFinished() then
				if not objectiveObj:attemptAutoClaim() then
					curIndex = curIndex + 1
				else
					autoClaimed = true
				end
			else
				curIndex = curIndex + 1
			end
		else
			curIndex = curIndex + 1
		end
	end
	
	if autoClaimed then
		self:fillObjectives()
	end
end

local validObjectives = {}

function objectiveHandler:onGameLogicStarted()
	for key, obj in ipairs(self.objectives) do
		obj:onGameLogicStarted()
	end
end

function objectiveHandler:fillObjectives(loaded)
	local maxObjectives = math.max(0, self.maxObjectives - #self.objectives)
	
	if not loaded then
		self.viewedTasks = false
	end
	
	if maxObjectives > 0 then
		for key, objectiveID in ipairs(self.objectiveList) do
			local objectiveData = objectiveHandler.registeredObjectivesByID[objectiveID]
			
			if not self.completedObjectives[objectiveData.id] and objective:checkRequirements(objectiveData.requirements) then
				validObjectives[#validObjectives + 1] = objectiveData
			end
		end
		
		for i = 1, math.min(#validObjectives, maxObjectives) do
			local randomKey = math.random(1, #validObjectives)
			local objectiveData = validObjectives[randomKey]
			
			table.remove(validObjectives, randomKey)
			
			local objectiveObj = self:createObjective(objectiveData)
			
			table.insert(self.objectives, objectiveObj)
			objectiveObj:start()
		end
		
		table.clearArray(validObjectives)
	end
	
	events:fire(objectiveHandler.EVENTS.FILLED_OBJECTIVES)
end

function objectiveHandler:getObjectives()
	return self.objectives
end

function objectiveHandler:claimObjectiveReward(objectiveObject)
	objectiveObject:giveReward()
	events:fire(objectiveHandler.EVENTS.CLAIMED_OBJECTIVE, objectiveObject)
	table.removeObject(self.objectives, objectiveObject)
end

function objectiveHandler:setViewedTasks(state)
	self.viewedTasks = state
end

function objectiveHandler:getViewedTasks()
	return self.viewedTasks
end

function objectiveHandler:save()
	local saved = {
		objectives = {},
		completedObjectives = self.completedObjectives,
		viewedTasks = self.viewedTasks
	}
	
	for key, objectiveObj in ipairs(self.objectives) do
		table.insert(saved.objectives, objectiveObj:save())
	end
	
	return saved
end

function objectiveHandler:load(data)
	self.viewedTasks = data.viewedTasks
	
	for key, objectiveData in ipairs(data.objectives) do
		local objectiveObj = objective.new()
		
		objectiveObj:load(objectiveData)
		table.insert(self.objectives, objectiveObj)
	end
	
	self.completedObjectives = data.completedObjectives
end

require("game/objectives/objective")
require("game/objectives/tasks/objective_task")
require("game/objectives/fail_states/fail_state")
