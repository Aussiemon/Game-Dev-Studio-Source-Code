yearlyGoalController = {}
yearlyGoalController.registered = {}
yearlyGoalController.registeredByID = {}
yearlyGoalController.validGoals = {}
yearlyGoalController.goalElementQueue = {}
yearlyGoalController.EVENTS = {
	DISPLAY_REMOVED = events:new()
}
yearlyGoalController.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_YEAR,
	yearlyGoalController.EVENTS.DISPLAY_REMOVED,
	game.EVENTS.RESOLUTION_CHANGED
}

function yearlyGoalController:registerNew(data, inherit)
	table.insert(self.registered, data)
	
	self.registeredByID[data.id] = data
	data.mtindex = data.mtindex or {
		__index = data
	}
	
	if inherit then
		data.baseClass = self.registeredByID[inherit]
		
		setmetatable(data, self.registeredByID[inherit].mtindex)
	else
		data.baseClass = self.registeredByID.goal_base
	end
end

function yearlyGoalController:init()
	self.goalWasAvailableForThisYear = false
	
	events:addDirectReceiver(self, yearlyGoalController.CATCHABLE_EVENTS)
end

function yearlyGoalController:remove()
	events:removeDirectReceiver(self, yearlyGoalController.CATCHABLE_EVENTS)
	
	if self.goal then
		self:removeGoal()
	end
end

function yearlyGoalController:setTrackGoals(state)
	self.trackGoals = state
	
	if state then
		if self.goal then
			self.goal:createDisplay()
		end
	elseif self.goal then
		local element = self.goal:getDisplay()
		
		if element then
			element:kill()
		end
	end
end

function yearlyGoalController:isTrackingGoals()
	return self.trackGoals
end

function yearlyGoalController:createGoal(id)
	local data = yearlyGoalController.registeredByID[id]
	local goalObj = {}
	
	setmetatable(goalObj, data.mtindex)
	goalObj:init()
	goalObj:initEventHandler()
	
	return goalObj
end

function yearlyGoalController:setGoal(object)
	self.goal = object
	
	self.goal:prepare()
	self.goal:onStart()
	
	self.previousGoal = object:getID()
end

function yearlyGoalController:getCurrentGoalID()
	return self.goal and self.goal:getID() or nil
end

function yearlyGoalController:getGoal()
	return self.goal
end

function yearlyGoalController:queueGoalElement(element)
	if self.currentGoalElement and self.currentGoalElement:isValid() or game.hudHidden then
		table.insert(self.goalElementQueue, element)
		element:hide()
	else
		element:show()
	end
end

function yearlyGoalController:showNextQueuedGoalElement()
	if #self.goalElementQueue > 0 then
		self.goalElementQueue[1]:show()
		table.remove(self.goalElementQueue, 1)
	end
end

function yearlyGoalController:setCurrentGoalElement(elem)
	self.currentGoalElement = elem
end

function yearlyGoalController:startNewGoal()
	if self.goalWasAvailableForThisYear then
		return false
	end
	
	if self.goal then
		self:removeGoal()
	end
	
	for key, goalType in ipairs(yearlyGoalController.registered) do
		if goalType:canPick() and goalType.id ~= self.previousGoal then
			table.insert(self.validGoals, goalType.id)
		end
	end
	
	if #self.validGoals > 0 then
		local randomGoal = self.validGoals[math.random(1, #self.validGoals)]
		local object = self:createGoal(randomGoal)
		
		self:setGoal(object)
		table.clear(self.validGoals)
		
		return true
	end
	
	return false
end

function yearlyGoalController:handleEvent(event, ...)
	if event == timeline.EVENTS.NEW_YEAR then
		self:startNewGoal()
	elseif event == yearlyGoalController.EVENTS.DISPLAY_REMOVED and not game.hudHidden then
		self:showNextQueuedGoalElement()
	elseif event == game.EVENTS.RESOLUTION_CHANGED and self.goal then
		self.goal:createDisplay()
	end
end

function yearlyGoalController:failGoal(goalObject)
	goalObject:onFail()
	goalObject:removeEventHandler()
	
	if goalObject == self.goal then
		self.goal = nil
	end
end

function yearlyGoalController:finishGoal(goalObject)
	goalObject:onFinish()
	goalObject:giveReward()
	goalObject:removeEventHandler()
	
	if goalObject == self.goal then
		self.goal = nil
	end
end

function yearlyGoalController:removeGoal()
	if self.goal then
		self.goal:removeEventHandler()
		self.goal:remove()
		
		self.goal = nil
	end
end

function yearlyGoalController:save()
	local saved = {}
	
	saved.goal = self.goal and self.goal:save()
	saved.previousGoalID = self.previousGoalID
	saved.goalWasAvailableForThisYear = self.goalWasAvailableForThisYear
	saved.trackGoals = self.trackGoals
	
	return saved
end

function yearlyGoalController:load(data)
	if not data or not data.goal then
		self:startNewGoal()
		
		return 
	end
	
	self:setTrackGoals(data.trackGoals)
	
	if data.goal then
		local goalObject = self:createGoal(data.goal.id)
		
		goalObject:load(data.goal)
		
		self.goal = goalObject
	end
	
	self.previousGoalID = data.previousGoalID
	self.goalWasAvailableForThisYear = data.goalWasAvailableForThisYear
end

require("game/yearly_goal/yearly_goal")
require("game/yearly_goal/have_n_employees")
require("game/yearly_goal/create_game_with_rating")
require("game/yearly_goal/implement_n_features_in_engine")
