local goal = {}

goal.id = "implement_n_features_in_engine"
goal.FEATURES_TO_IMPLEMENT_RANGE = {
	1,
	2
}
goal.TASK_IDS = {
	engine_task = true
}
goal.NEW_FEATURE_TEXT_COLOR = color(200, 255, 200, 255)
goal.FEATURE_MONTH_PERIOD = {
	2,
	4
}
goal.FOUND_FEATURES = {}
goal.CATCHABLE_EVENTS = {
	engine.EVENTS.FEATURE_ADDED
}

function goal:init()
	self.foundFeatures = {}
end

function goal:prepare()
	table.copyover(goal.FOUND_FEATURES, self.foundFeatures)
	table.clear(goal.FOUND_FEATURES)
	
	local allTasks = #self.foundFeatures
	
	self.startTime = timeline:getDateTime(timeline:getYear(), timeline:getMonth())
	self.finishTime = timeline:getDateTime(timeline:getYear(), timeline.MONTHS_IN_YEAR)
	self.featuresToImplement = math.max(1, allTasks - math.random(goal.FEATURES_TO_IMPLEMENT_RANGE[1], goal.FEATURES_TO_IMPLEMENT_RANGE[2]))
	self.implementedFeaturesCounter = 0
	self.implementedFeatures = {}
end

function goal:canPick()
	taskTypes:getReleasedFeaturesBetween(timeline:getDateTime(timeline:getYear(), timeline:getMonth()), timeline:getDateTime(timeline:getYear(), math.min(12, timeline:getMonth() + math.random(goal.FEATURE_MONTH_PERIOD[1], goal.FEATURE_MONTH_PERIOD[2]))), self.TASK_IDS, goal.FOUND_FEATURES)
	
	return #goal.FOUND_FEATURES > 0
end

function goal:getText()
	return string.easyformatbykeys(_T("IMPLEMENT_N_FEATURES_INTO_ENGINE_DESCRIPTION", "Implement COUNT new tech into any engine."), "COUNT", self.featuresToImplement)
end

function goal:isFeatureNew(dateData)
	local date = timeline:getDateTime(dateData.year, dateData.month)
	
	return date > self.startTime
end

function goal:handleEvent(event, data, feature)
	if not data:isLicenseable() then
		local owner = data:getOwner()
		
		if owner and owner:isPlayer() then
			local taskTypeData = taskTypes:getData(feature)
			
			if taskTypeData.taskID == "engine_task" and taskTypeData.releaseDate and self:isFeatureNew(taskTypeData.releaseDate) and not self.implementedFeatures[feature] then
				self.implementedFeatures[feature] = true
				self.implementedFeaturesCounter = self.implementedFeaturesCounter + 1
			end
			
			self:checkForFinish()
			self:updateDisplay(self.display)
		end
	end
end

function goal:checkForFinish()
	if self.implementedFeaturesCounter >= self.featuresToImplement then
		yearlyGoalController:finishGoal(self)
	end
end

function goal:_updateDisplay(element)
	local text = self:getText()
	
	text = text .. string.easyformatbykeys(_T("IMPLEMENT_N_FEATURES_INTO_ENGINE_PROGRESS_TEXT", "\n - IMPLEMENTED/REQUIRED tech implemented"), "IMPLEMENTED", self.implementedFeaturesCounter, "REQUIRED", self.featuresToImplement)
	
	element:setText(text)
end

function goal:onHoverTaskInfoDescBox(taskData)
	if taskData.releaseDate and goal.TASK_IDS[taskData.taskID] and self:isFeatureNew(taskData.releaseDate) then
		return _T("FEATURE_IS_NEW", "This tech is new."), "pix24", goal.NEW_FEATURE_TEXT_COLOR
	end
	
	return nil, nil, nil
end

function goal:save()
	local saved = goal.baseClass.save(self)
	
	saved.startTime = self.startTime
	saved.finishTime = self.finishTime
	saved.featuresToImplement = self.featuresToImplement
	saved.implementedFeatures = self.implementedFeatures
	
	return saved
end

function goal:load(data)
	self.startTime = data.startTime
	self.finishTime = data.finishTime
	self.featuresToImplement = data.featuresToImplement
	self.implementedFeatures = data.implementedFeatures
	self.implementedFeaturesCounter = table.count(self.implementedFeatures)
	
	goal.baseClass.load(self, data)
	self:updateDisplay(self.display)
end

yearlyGoalController:registerNew(goal, "goal_base")
