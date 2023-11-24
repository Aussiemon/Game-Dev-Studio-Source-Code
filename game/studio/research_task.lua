local researchTask = {}

researchTask.id = "research_task"
researchTask.timeToProgress = 1
researchTask.researchableTasks = {}
researchTask.EVENTS = {
	BEGIN = events:new()
}

local designTask = task:getData("design_task")

function researchTask:init()
	researchTask.baseClass.init(self)
	
	self.finishedWork = 0
	self.progressTime = 0
	
	self:addTrainedSkill("development", researchTask.DEV_EXP_MIN, researchTask.DEV_EXP_MAX, researchTask.DEV_EXP_TIME_MIN, researchTask.DEV_EXP_TIME_MAX)
end

function researchTask:setupResearchableTasks()
	table.clearArray(self.researchableTasks)
	
	self.featuresInResearch = studio:getResearchTaskList()
	
	self:_addResearchCategory(gameProject.DEVELOPMENT_CATEGORIES)
	self:_addResearchCategory(engine.DEVELOPMENT_CATEGORIES)
end

function researchTask:getResearchableTasks()
	return self.researchableTasks
end

function researchTask:attemptBeginAutoResearch(employeeObj, taskObj)
	if #self.researchableTasks > 0 then
		for key, taskData in ipairs(self.researchableTasks) do
			if taskData:canResearch(employeeObj) == true then
				if not taskObj then
					taskObj = game.createResearchTask(taskData.id)
					
					employeeObj:setTask(taskObj)
					taskObj:setAutoResearch(true)
				else
					game.updateResearchTask(taskObj, taskData)
					events:fire(designTask.EVENTS.UPDATE_DISPLAY, self)
				end
				
				table.remove(self.researchableTasks, key)
				
				return true
			end
		end
		
		return false
	end
	
	return nil
end

function researchTask:countResearchableTasks(employeeObj)
	local total = 0
	
	for key, taskData in ipairs(self.researchableTasks) do
		if taskData:canResearch(employeeObj) == true then
			total = total + 1
		end
	end
	
	return total
end

function researchTask:grabResearchableTask()
	return table.remove(self.researchableTasks, #self.researchableTasks)
end

function researchTask:_addResearchCategory(categoryList)
	for key, category in ipairs(categoryList) do
		local categoryTasks = taskTypes:getResearchableCategoryFeatures(category)
		
		for i = #categoryTasks, 1, -1 do
			local taskData = categoryTasks[i]
			
			if not self.featuresInResearch[taskData.id] then
				self.researchableTasks[#self.researchableTasks + 1] = taskData
			end
			
			table.remove(categoryTasks, i)
		end
	end
end

function researchTask:setAutoResearch(state)
	self.autoResearch = state
end

function researchTask:onBeginWork()
	events:fire(researchTask.EVENTS.BEGIN, self)
end

function researchTask:setTaskType(taskType)
	researchTask.baseClass.setTaskType(self, taskType)
	self:setText(self.taskTypeData.display)
end

function researchTask:cancel()
	researchTask.baseClass.cancel(self)
	self:setAssignee(nil)
	
	if self.autoResearch then
		self.featuresInResearch[self.taskTypeData.id] = nil
		
		table.insert(self.researchableTasks, self.taskTypeData)
	end
end

function researchTask:canUnassignOnAway()
	return false
end

function researchTask:canStopToResearch()
	return false
end

function researchTask:getProjectBoxText()
	return self:getText()
end

function researchTask:onSetAssignee()
	researchTask.baseClass.onSetAssignee(self)
	
	if self.assignee then
		if not self.display then
			self.display = game.projectBox:addElement(self, nil, nil, "ActiveTaskElement")
		end
		
		studio:setResearchTask(self.taskTypeData.id, self)
	else
		self:removeProjectBoxElement()
		studio:setResearchTask(self.taskTypeData.id, nil)
	end
end

function researchTask:removeProjectBoxElement()
	events:fire(designTask.EVENTS.REMOVE_DISPLAY, self)
end

function researchTask:canReassign()
	return false
end

function researchTask:getTaskTypeText()
	return _T("RESEARCH", "Research")
end

function researchTask:areAllIssuesFixed()
	return true
end

function researchTask:getCompletionDisplay()
	return self:getCompletion()
end

function researchTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function researchTask:isDone()
	return self:isWorkOnDone()
end

function researchTask:setAssignee(assignee)
	self.assignee = assignee
	
	for key, practice in ipairs(self.trainedSkills) do
		practice:setAssignee(assignee)
	end
	
	self:onSetAssignee()
end

function researchTask:getUnassignOnFinish()
	return self._finished
end

function researchTask:onFinish()
	studio:addFeature(self.taskType)
	
	if self.autoResearch then
		if not self:attemptBeginAutoResearch(self.assignee, self) then
			self:_onFinish()
		end
	else
		self:_onFinish()
	end
	
	researchTask.baseClass.onFinish(self)
end

function researchTask:_onFinish()
	self._finished = true
	self.lastAssignee = nil
	self.assignee = nil
end

function researchTask:adjustProgressAmount(assignee, progress)
	local speedBoost = assignee:getSpeedBoost()
	local driveModifier = assignee:getDriveModifier()
	local developmentBoost = assignee:getSkillDevBoost("development")
	local fieldBoost = assignee:getSkillDevBoost(self.workField)
	local traitBoost = assignee:getTraitDevelopSpeedModifiers()
	
	progress = progress * speedBoost * developmentBoost * fieldBoost * driveModifier * traitBoost * assignee:getDevelopSpeedMultiplier() * assignee:getOfficeDevSpeedMultiplier() * DEV_SPEED_MULTIPLIER
	
	return progress
end

function researchTask:progress(delta, progress, assignee, wasCalculated)
	if not wasCalculated then
		if self.trainedSkills then
			for key, practice in ipairs(self.trainedSkills) do
				practice:progress(delta, progress, assignee)
			end
		end
		
		local empSkills = assignee:getSkills()
		
		progress = self:adjustProgressAmount(assignee, progress)
	end
	
	local residue = self.progressTime - progress
	
	self.progressTime = residue
	
	if residue <= 0 and not self:isWorkOnDone() then
		self.finishedWork = self.finishedWork + 1
		self.progressTime = self.timeToProgress
		
		self:progress(delta, -residue, assignee, true)
	end
end

function researchTask:canAssign(assignee)
	return true
end

function researchTask:setBoostAttribute(attribute)
	self.boostAttribute = attribute
end

function researchTask:save()
	local saved = researchTask.baseClass.save(self)
	
	saved.timeToProgress = self.timeToProgress
	saved.boostAttribute = self.boostAttribute
	saved.progressTime = self.progressTime
	
	return saved
end

function researchTask:load(data)
	researchTask.baseClass.load(self, data)
	
	self.timeToProgress = data.timeToProgress
	self.boostAttribute = data.boostAttribute
	self.progressTime = data.progressTime
end

task:registerNew(researchTask, "progress_bar_task")
