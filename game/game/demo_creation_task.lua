local demoCreateTask = {}

demoCreateTask.id = "demo_creation_task"
demoCreateTask.timeToProgress = 1
demoCreateTask.workField = "software"
demoCreateTask.fillerColor = color(135, 193, 221, 255)
demoCreateTask.DEFAULT_REQUIRED_WORK_AMOUNT = 150
demoCreateTask.EXTRA_WORK_PER_SCALE = 50
demoCreateTask.DEFAULT_TIME_TO_PROGRESS = 0.75

local designTask = task:getData("design_task")

demoCreateTask.EVENTS = {
	BEGIN = events:new(),
	FINISH = events:new(),
	REMOVE_DISPLAY = events:new()
}

function demoCreateTask:init()
	demoCreateTask.baseClass.init(self)
	
	self.finishedWork = 0
	self.progressTime = 0
	
	self:addTrainedSkill("development", demoCreateTask.DEV_EXP_MIN, demoCreateTask.DEV_EXP_MAX, demoCreateTask.DEV_EXP_TIME_MIN, demoCreateTask.DEV_EXP_TIME_MAX)
end

function demoCreateTask:getProjectBoxText()
	return _format(_T("TASK_DEMO_VERSION_GAME", "Demo version - 'PROJECT'"), "PROJECT", self.project:getName())
end

function demoCreateTask:getTaskTypeText()
	return _T("TASK_DEMO_VERSION", "Demo version")
end

function demoCreateTask:getName()
	return _T("TASK_DEMO_VERSION_LOWERCASE", "demo version")
end

function demoCreateTask:getText()
	return _T("TASK_DEMO_VERSION", "Demo version")
end

function demoCreateTask:canStopToResearch()
	return false
end

function demoCreateTask:canReassign(desiredEmployee, curTask)
	return false
end

function demoCreateTask:canUnassignOnAway()
	return false
end

function demoCreateTask:setProject(obj)
	self.project = obj
	
	obj:setCreatingDemo(true)
end

function demoCreateTask:onBeginWork()
	events:fire(demoCreateTask.EVENTS.BEGIN, self)
end

function demoCreateTask:getWorkField()
	return self.workField
end

function demoCreateTask:cancel()
	demoCreateTask.baseClass.cancel(self)
	self:setAssignee(nil)
	self.project:cancelDemoCreation()
end

function demoCreateTask:areAllIssuesFixed()
	return true
end

function demoCreateTask:getCompletionDisplay()
	return self:getCompletion()
end

function demoCreateTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function demoCreateTask:isDone()
	return self:isWorkOnDone()
end

function demoCreateTask:setAssignee(assignee)
	self.assignee = assignee
	
	if self.trainedSkills then
		for key, practice in ipairs(self.trainedSkills) do
			practice:setAssignee(assignee)
		end
	end
	
	self:onSetAssignee()
end

function demoCreateTask:onSetAssignee()
	demoCreateTask.baseClass.onSetAssignee(self)
	
	if self.assignee then
		if not self.displayCreated then
			self.displayCreated = true
			
			game.projectBox:addElement(self, nil, nil, "ActiveTaskElement")
		end
	else
		self:removeProjectBoxElement()
	end
end

function demoCreateTask:removeProjectBoxElement()
	events:fire(designTask.EVENTS.REMOVE_DISPLAY, self)
end

function demoCreateTask:onFinish()
	demoCreateTask.baseClass.onFinish(self)
	self.project:scheduleDemoEvaluation()
	events:fire(demoCreateTask.EVENTS.FINISH, self)
	
	self.lastAssignee = nil
	
	self:setAssignee(nil)
end

function demoCreateTask:adjustProgressAmount(assignee, progress)
	local speedBoost = assignee:getSpeedBoost()
	local driveModifier = assignee:getDriveModifier()
	local developmentBoost = assignee:getSkillDevBoost("development")
	local fieldBoost = assignee:getSkillDevBoost(self.workField)
	local traitBoost = assignee:getTraitDevelopSpeedModifiers()
	
	progress = progress * speedBoost * developmentBoost * fieldBoost * driveModifier * traitBoost * assignee:getDevelopSpeedMultiplier() * assignee:getOfficeDevSpeedMultiplier() * DEV_SPEED_MULTIPLIER
	
	return progress
end

function demoCreateTask:progress(delta, progress, assignee)
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

function demoCreateTask:canAssign(assignee)
	return true
end

function demoCreateTask:save()
	local saved = demoCreateTask.baseClass.save(self)
	
	saved.timeToProgress = self.timeToProgress
	saved.boostAttribute = self.boostAttribute
	saved.progressTime = self.progressTime
	saved.projectID = self.project:getUniqueID()
	
	return saved
end

function demoCreateTask:load(data)
	demoCreateTask.baseClass.load(self, data)
	
	self.timeToProgress = data.timeToProgress
	self.boostAttribute = data.boostAttribute
	self.progressTime = data.progressTime
	
	self:setProject(studio:getGameByUniqueID(data.projectID))
end

task:registerNew(demoCreateTask, "progress_bar_task")
