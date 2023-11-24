local designTask = {}

designTask.id = "design_task"
designTask.timeToProgress = 1
designTask.workField = "design"
designTask.fillerColor = color(135, 193, 221, 255)
designTask.DEFAULT_REQUIRED_WORK_AMOUNT = 100
designTask.DEFAULT_TIME_TO_PROGRESS = 0.75
designTask.EVENTS = {
	BEGIN = events:new(),
	FINISH = events:new(),
	REMOVE_DISPLAY = events:new(),
	UPDATE_DISPLAY = events:new()
}
designTask.TYPES = {
	GENRE = 2,
	THEME = 1
}

function designTask:init()
	designTask.baseClass.init(self)
	
	self.finishedWork = 0
	self.progressTime = 0
	
	self:addTrainedSkill("development", designTask.DEV_EXP_MIN, designTask.DEV_EXP_MAX, designTask.DEV_EXP_TIME_MIN, designTask.DEV_EXP_TIME_MAX)
end

function designTask:setDesignType(type)
	self.designType = type
end

function designTask:getDesignType()
	return self.designType
end

function designTask:getProjectBoxText()
	if self.designType == designTask.TYPES.THEME then
		return _T("RESEARCH_OF_NEW_THEME", "Design of new theme")
	else
		return _T("RESEARCH_OF_NEW_GENRE", "Design of new genre")
	end
end

function designTask:canStopToResearch()
	return false
end

function designTask:setResearchID(researchID)
	self.researchID = researchID
end

function designTask:getResearchID()
	return self.researchID
end

function designTask:onBeginWork()
	events:fire(designTask.EVENTS.BEGIN, self)
end

function designTask:getWorkField()
	return self.workField
end

function designTask:canReassign(desiredEmployee, curTask)
	return false
end

function designTask:canUnassignOnAway()
	return false
end

function designTask:cancel()
	designTask.baseClass.cancel(self)
	self:setAssignee(nil)
end

function designTask:getTaskTypeText()
	return _T("DESIGN", "Design")
end

function designTask:areAllIssuesFixed()
	return true
end

function designTask:getCompletionDisplay()
	return self:getCompletion()
end

function designTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function designTask:isDone()
	return self:isWorkOnDone()
end

function designTask:getName()
	if self.designType == designTask.TYPES.THEME then
		return _T("NEW_THEME", "new theme")
	end
	
	return _T("NEW_GENRE", "new genre")
end

function designTask:getText()
	if self.designType == designTask.TYPES.THEME then
		return _T("NEW_THEME_CAPITALIZED", "New theme")
	end
	
	return _T("NEW_GENRE_CAPITALIZED", "New genre")
end

function designTask:setAssignee(assignee)
	self.assignee = assignee
	
	if self.trainedSkills then
		for key, practice in ipairs(self.trainedSkills) do
			practice:setAssignee(assignee)
		end
	end
	
	self:onSetAssignee()
end

function designTask:onSetAssignee()
	designTask.baseClass.onSetAssignee(self)
	
	if self.assignee then
		if not self.display then
			self.display = game.projectBox:addElement(self, nil, nil, "ActiveTaskElement")
		end
	else
		self:removeProjectBoxElement()
	end
end

function designTask:removeProjectBoxElement()
	events:fire(designTask.EVENTS.REMOVE_DISPLAY, self)
end

eventBoxText:registerNew({
	id = "finished_design_task",
	getText = function(self, data)
		local name = data.name
		
		if data.designType == designTask.TYPES.THEME then
			return _format(_T("THEME_DESIGN_FINISHED", "NAME has finished designing a new theme. Resulting theme: THEME"), "NAME", names:getFullName(name[1], name[2], name[3], name[4]), "THEME", themes.registeredByID[data.researchID].display)
		else
			return _format(_T("GENRE_DESIGN_FINISHED", "NAME has finished designing a new genre. Resulting genre: GENRE"), "NAME", names:getFullName(name[1], name[2], name[3], name[4]), "GENRE", genres.registeredByID[data.researchID].display)
		end
		
		return "incorrect setup of finished_design_task event box element"
	end
})

function designTask:onFinish()
	designTask.baseClass.onFinish(self)
	
	if self.designType == designTask.TYPES.THEME then
		studio:addResearchedTheme(self.researchID)
	else
		studio:addResearchedGenre(self.researchID)
	end
	
	local roleData = attributes.profiler.rolesByID[self.assignee:getRole()]
	
	roleData:applyDesignCooldown(self.assignee)
	game.addToEventBox("finished_design_task", {
		name = {
			self.assignee:getNameConfig()
		},
		designType = self.designType,
		researchID = self.researchID
	}, 1, nil, "exclamation_point")
	events:fire(designTask.EVENTS.FINISH, self)
	
	self.lastAssignee = nil
	
	self:setAssignee(nil)
end

function designTask:adjustProgressAmount(assignee, progress)
	local speedBoost = assignee:getSpeedBoost()
	local driveModifier = assignee:getDriveModifier()
	local developmentBoost = assignee:getSkillDevBoost("development")
	local fieldBoost = assignee:getSkillDevBoost(self.workField)
	local traitBoost = assignee:getTraitDevelopSpeedModifiers()
	
	progress = progress * speedBoost * developmentBoost * fieldBoost * driveModifier * traitBoost * assignee:getDevelopSpeedMultiplier() * assignee:getOfficeDevSpeedMultiplier() * DEV_SPEED_MULTIPLIER
	
	return progress
end

function designTask:progress(delta, progress, assignee)
	if self.trainedSkills then
		for key, practice in ipairs(self.trainedSkills) do
			practice:progress(delta, progress, assignee)
		end
	end
	
	progress = self:adjustProgressAmount(assignee, progress)
	
	local residue = self.progressTime - progress
	
	if self.progressTime <= 0 then
		while residue <= 0 do
			if not self:isWorkOnDone() then
				self.finishedWork = self.finishedWork + 1
				residue = residue + self.timeToProgress
				self.progressTime = residue
			else
				return 
			end
		end
	else
		self.progressTime = residue
	end
end

function designTask:canAssign(assignee)
	return true
end

function designTask:save()
	local saved = designTask.baseClass.save(self)
	
	saved.timeToProgress = self.timeToProgress
	saved.boostAttribute = self.boostAttribute
	saved.progressTime = self.progressTime
	saved.designType = self.designType
	saved.researchID = self.researchID
	
	return saved
end

function designTask:load(data)
	designTask.baseClass.load(self, data)
	
	self.timeToProgress = data.timeToProgress
	self.boostAttribute = data.boostAttribute
	self.progressTime = data.progressTime
	self.designType = data.designType
	self.researchID = data.researchID
end

task:registerNew(designTask, "progress_bar_task")
