complexProject = {}
complexProject.mtindex = {
	__index = complexProject
}
complexProject.PROJECT_TYPE = "complex_project"
complexProject.EVENTS = {
	RecalculatedDesiredFeaturesCost = events:new(),
	ON_CONFLICTING_FEATURES_DISABLED = events:new(),
	ADDED_DESIRED_FEATURE = events:new()
}

setmetatable(complexProject, project.mtindex)

function complexProject.new(owner)
	local new = {}
	
	setmetatable(new, complexProject.mtindex)
	new:init(owner)
	
	return new
end

function complexProject:init(owner)
	project.init(self, owner)
	
	self.desiredFeatures = {}
	self.features = {}
end

function complexProject:setDesiredFeature(taskType, state, skipDisable)
	if not state then
		self.desiredFeatures[taskType] = nil
	else
		self.desiredFeatures[taskType] = state
	end
	
	if not skipDisable then
		self:disableConflictingFeatures(taskType)
	end
	
	self:calculateDesiredFeaturesCost()
	
	if state then
		taskTypes.registeredByID[taskType]:onSelected(self)
	else
		taskTypes.registeredByID[taskType]:onDeselected(self)
	end
	
	self:postSetDesiredFeature(taskType, state)
	
	if not self._minimalEffort then
		events:fire(complexProject.EVENTS.ADDED_DESIRED_FEATURE, self, state, taskType)
	end
end

function complexProject:postSetDesiredFeature(taskType, state)
end

complexProject.workAmountByWorkfield = {}

function complexProject:getThoroughWorkInfo(featureList)
	featureList = featureList or self.desiredFeatures
	
	local listOfTasks = taskTypes.registeredByID
	local total = 0
	local workByWorkField = complexProject.workAmountByWorkfield
	
	table.clear(workByWorkField)
	
	local taskClass = self:getTaskClass()
	
	for featureID, state in pairs(featureList) do
		local featureData = listOfTasks[featureID]
		local workAmount = taskClass:calculateRequiredWork(featureData, self)
		
		total = total + workAmount
		workByWorkField[featureData.workField] = (workByWorkField[featureData.workField] or 0) + workAmount
	end
	
	return total, workByWorkField
end

function complexProject:getStageWorkAmount(stageID)
	local total = 0
	local workByWorkField = complexProject.workAmountByWorkfield
	
	table.clear(workByWorkField)
	
	local tasks = self.stages[stageID]:getTasks()
	local finishedTasks = 0
	
	for key, taskObject in ipairs(tasks) do
		local workAmount = taskObject:getRemainingWork(self)
		
		total = total + workAmount
		
		if not taskObject:isDone() then
			finishedTasks = finishedTasks + 1
		end
		
		local workField = taskObject:getWorkField()
		
		workByWorkField[workField] = (workByWorkField[workField] or 0) + workAmount
	end
	
	return total, workByWorkField, #tasks, finishedTasks
end

function complexProject:getRemainingWorkAmount()
	local listOfTasks = taskTypes.registeredByID
	local total = 0
	local workByWorkField = complexProject.workAmountByWorkfield
	
	table.clear(workByWorkField)
	
	for workID, amount in pairs(self.requiredWork) do
		local workAmount = amount - self.finishedWork[workID]
		
		workByWorkField[workID] = workAmount
		total = total + workAmount
	end
	
	return total, workByWorkField
end

function complexProject:getDesiredWorkAmount()
	local total = 0
	local listOfTasks = taskTypes.registeredByID
	local taskClass = self:getTaskClass()
	
	for featureID, state in pairs(self.desiredFeatures) do
		total = total + taskClass:calculateRequiredWork(listOfTasks[featureID], self)
	end
	
	return total
end

function complexProject:hasDesiredFeature(taskType)
	return self.desiredFeatures[taskType]
end

function complexProject:clearDesiredFeatures()
	for featureID, state in pairs(self.desiredFeatures) do
		taskTypes.registeredByID[featureID]:setDesiredFeature(self, false)
	end
end

function complexProject:getFullWorkCost()
	return self:getDesiredFeaturesCost()
end

function complexProject:getDesiredFeaturesCost()
	if not self.desiredFeaturesCost then
		self:calculateDesiredFeaturesCost()
	end
	
	return self.desiredFeaturesCost
end

function complexProject:getDesiredFeatures()
	return self.desiredFeatures
end

function complexProject:calculateDesiredFeaturesCost()
	if self._minimalEffort then
		return nil
	end
	
	local total = 0
	
	for featureType, state in pairs(self.desiredFeatures) do
		if state then
			local featureData = taskTypes.registeredByID[featureType]
			
			total = total + featureData:getCost(nil, self)
		end
	end
	
	self.desiredFeaturesCost = total
	
	events:fire(complexProject.EVENTS.RecalculatedDesiredFeaturesCost, self)
	
	return total
end

function complexProject:beginWork(stage, devType)
	project.beginWork(self, stage, devType)
end

function complexProject:hasAtLeastOneDesiredFeature()
	for featureID, state in pairs(self.desiredFeatures) do
		if state then
			return true
		end
	end
	
	return false
end

function complexProject:canBeginWorkOn()
	if not self:hasAtLeastOneDesiredFeature() or not self:hasName() or not self:isAssignedToTeam() then
		return false
	end
	
	if not self:hasEnoughFunds() then
		return false
	end
	
	return true
end

function complexProject:hasEnoughFunds()
	if self.desiredFeaturesCost and self.desiredFeaturesCost > 0 and self.owner:getFunds() < self.desiredFeaturesCost then
		return false
	end
	
	return true
end

function complexProject:setScale(scale)
	project.setScale(self, scale)
	self:calculateDesiredFeaturesCost()
end

complexProject.FEATURE_UNAVAILABILITY = {
	FEATURE_INCOMPATIBILITY = 8,
	SKILL_LEVEL_TOO_LOW = 2,
	NO_TEAM_SELECTED = 16,
	MISSING_OTHER_FEATURE = 4,
	FEATURE_PRESENT = 1
}

local missingRequirements = {}
local presentIncompatibilities = {}

function complexProject:hasUnavailabilityState(number, state)
	return bit.band(number, state) == state
end

complexProject.missingFeatureNames = {}
complexProject.conflictingFeatureNames = {}
complexProject.finalIncompatibilityText = {}

function complexProject:formulateUnavailabilityText(featureID, unavailabilityStates, lowestSkillLevel, missingRequirements, presentIncompatibilities)
	local finalText = ""
	local featureData = taskTypes:getData(featureID)
	
	table.clear(complexProject.finalIncompatibilityText)
	
	if self:hasUnavailabilityState(unavailabilityStates, complexProject.FEATURE_UNAVAILABILITY.SKILL_LEVEL_TOO_LOW) then
		table.insert(complexProject.finalIncompatibilityText, {
			text = _format(_T("TASK_SKILL_LEVEL_TOO_LOW", "TASK requires a minimum SKILL level of LEVEL.\nThe highest SKILL level in the current team is LOWEST."), "TASK", featureData.display, "SKILL", skills:getData(featureData.workField).display, "LEVEL", featureData.minimumLevel, "LOWEST", lowestSkillLevel),
			textColor = game.UI_COLORS.RED
		})
	end
	
	if self:hasUnavailabilityState(unavailabilityStates, complexProject.FEATURE_UNAVAILABILITY.MISSING_OTHER_FEATURE) then
		if #missingRequirements == 1 then
			table.insert(complexProject.finalIncompatibilityText, {
				text = _format(_T("TASK_MISSING_OTHER_FEATURE", "TASK requires FEATURE to be implemented or selected for implementation."), "TASK", featureData.display, "FEATURE", taskTypes:getData(missingRequirements[1]).display),
				textColor = game.UI_COLORS.IMPORTANT_1
			})
		else
			for key, missingFeatureID in ipairs(missingRequirements) do
				table.insert(complexProject.missingFeatureNames, taskTypes:getData(missingFeatureID).display)
			end
			
			local separator = featureData.anyRequirement and _T("OR_LOWERCASE", " or ") or ", "
			
			table.insert(complexProject.finalIncompatibilityText, {
				text = _format(_T("TASK_MISSING_OTHER_FEATURES", "TASK requires the following to be implemented or selected for implementation: MISSING."), "TASK", featureData.display, "MISSING", table.concat(complexProject.missingFeatureNames, separator)),
				textColor = game.UI_COLORS.IMPORTANT_1
			})
		end
	end
	
	if self:hasUnavailabilityState(unavailabilityStates, complexProject.FEATURE_UNAVAILABILITY.FEATURE_INCOMPATIBILITY) then
		if #presentIncompatibilities == 1 then
			table.insert(complexProject.finalIncompatibilityText, {
				text = _format(_T("TASK_PRESENT_INCOMPATIBILITY", "TASK is incompatible with CONFLICT."), "TASK", featureData.display, "CONFLICT", taskTypes:getData(presentIncompatibilities[1]).display),
				textColor = game.UI_COLORS.IMPORTANT_2
			})
		else
			for key, presentConflict in ipairs(presentIncompatibilities) do
				table.insert(complexProject.conflictingFeatureNames, taskTypes:getData(presentConflict).display)
			end
			
			table.insert(complexProject.finalIncompatibilityText, {
				text = _format(_T("TASK_CONFLICTING_FEATURES", "TASK conflicts with the following features: CONFLICT."), "TASK", featureData.display, "CONFLICT", table.concat(complexProject.conflictingFeatureNames, ", ")),
				textColor = game.UI_COLORS.IMPORTANT_2
			})
		end
	end
	
	if self:hasUnavailabilityState(unavailabilityStates, complexProject.FEATURE_UNAVAILABILITY.NO_TEAM_SELECTED) then
		table.insert(complexProject.finalIncompatibilityText, {
			text = _T("TASK_NO_TEAM_SELECTED", "You have to select a team before picking features first."),
			textColor = game.UI_COLORS.RED
		})
	end
	
	table.clear(complexProject.missingFeatureNames)
	table.clear(complexProject.conflictingFeatureNames)
	
	return complexProject.finalIncompatibilityText
end

function complexProject:checkFeatureRequirement(featureData, missingRequirements)
	if featureData.anyRequirement then
		local change = 0
		local atLeastOnePresent = false
		
		for requirement, state in pairs(featureData.requirements) do
			if self.desiredFeatures[requirement] or self.features[requirement] then
				atLeastOnePresent = true
				
				break
			end
		end
		
		if not atLeastOnePresent then
			change = complexProject.FEATURE_UNAVAILABILITY.MISSING_OTHER_FEATURE
			
			for requirement, state in pairs(featureData.requirements) do
				missingRequirements[#missingRequirements + 1] = requirement
			end
		end
		
		return change
	else
		local change = 0
		
		for requirement, state in pairs(featureData.requirements) do
			if not self.desiredFeatures[requirement] and not self.features[requirement] then
				missingRequirements[#missingRequirements + 1] = requirement
			end
		end
		
		if #missingRequirements > 0 then
			change = change + complexProject.FEATURE_UNAVAILABILITY.MISSING_OTHER_FEATURE
		end
		
		return change
	end
end

function complexProject:canHaveFeature(featureID, skipRequirements, skipIncompatibilities, skipTeamCheck)
	table.clearArray(missingRequirements)
	table.clearArray(presentIncompatibilities)
	
	local lowestSkillLevel
	local unavailabilityState = 0
	
	if self.features[featureID] then
		unavailabilityState = unavailabilityState + complexProject.FEATURE_UNAVAILABILITY.FEATURE_PRESENT
	end
	
	local featureData = taskTypes:getData(featureID)
	
	if not skipTeamCheck then
		if self.desiredTeam then
			local teamObj = self.desiredTeam
			local minLevel = taskTypes:getSkillRequirement(featureID)
			
			if minLevel and minLevel > teamObj:getHighestSkillLevel(featureData.workField) then
				unavailabilityState = unavailabilityState + complexProject.FEATURE_UNAVAILABILITY.SKILL_LEVEL_TOO_LOW
				lowestSkillLevel = teamObj:getHighestSkillLevel(featureData.workField)
			end
		else
			unavailabilityState = unavailabilityState + complexProject.FEATURE_UNAVAILABILITY.NO_TEAM_SELECTED
		end
	end
	
	if not skipRequirements and featureData.requirements then
		unavailabilityState = unavailabilityState + self:checkFeatureRequirement(featureData, missingRequirements)
	end
	
	if not skipIncompatibilities and featureData.incompatibilities then
		for incompat, state in pairs(featureData.incompatibilities) do
			if self.desiredFeatures[incompat] or self.features[incompat] then
				presentIncompatibilities[#presentIncompatibilities + 1] = incompat
			end
			
			if #presentIncompatibilities > 0 then
				unavailabilityState = unavailabilityState + complexProject.FEATURE_UNAVAILABILITY.FEATURE_INCOMPATIBILITY
			end
		end
	end
	
	return unavailabilityState == 0, unavailabilityState, lowestSkillLevel, missingRequirements, presentIncompatibilities
end

function complexProject:disableConflictingFeatures(desiredFeature)
	local desiredData = taskTypes:getData(desiredFeature)
	
	for featureID, active in pairs(self.desiredFeatures) do
		if active then
			local featureData = taskTypes:getData(featureID)
			
			if featureData ~= desiredData then
				if featureData.optionCategory and featureData.optionCategory == desiredData.optionCategory then
					taskTypes.registeredByID[featureID]:setDesiredFeature(self, false, true)
				end
				
				if not self:canHaveFeature(featureID) then
					taskTypes.registeredByID[featureID]:setDesiredFeature(self, false, true)
				end
			end
		end
	end
	
	events:fire(complexProject.EVENTS.ON_CONFLICTING_FEATURES_DISABLED, self, desiredFeature)
end

function complexProject:save()
	local saved = project.save(self)
	
	saved.desiredFeatures = self.desiredFeatures
	saved.features = self.features
	
	return saved
end

function complexProject:load(data)
	project.load(self, data)
	
	self.desiredFeatures = data.desiredFeatures
	self.features = data.features
end
