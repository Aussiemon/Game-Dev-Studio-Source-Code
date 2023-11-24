local firmwareUpdateTask = {}

firmwareUpdateTask.id = "firmware_update_task"
firmwareUpdateTask.timeToProgress = 1
firmwareUpdateTask.workField = "software"
firmwareUpdateTask.fillerColor = color(135, 193, 221, 255)
firmwareUpdateTask.DEFAULT_REQUIRED_WORK_AMOUNT = 300
firmwareUpdateTask.DEFAULT_TIME_TO_PROGRESS = 0.75

local designTask = task:getData("design_task")

firmwareUpdateTask.EVENTS = {
	BEGIN = events:new(),
	FINISH = events:new(),
	REMOVE_DISPLAY = events:new()
}

function firmwareUpdateTask:init()
	firmwareUpdateTask.baseClass.init(self)
	
	self.finishedWork = 0
	self.progressTime = 0
	
	self:addTrainedSkill("development", firmwareUpdateTask.DEV_EXP_MIN, firmwareUpdateTask.DEV_EXP_MAX, firmwareUpdateTask.DEV_EXP_TIME_MIN, firmwareUpdateTask.DEV_EXP_TIME_MAX)
end

function firmwareUpdateTask:getProjectBoxText()
	return _format(_T("FIRMWARE_UPDATE_FULL", "Firmware update - 'PLATFORM'"), "PLATFORM", self.platform:getName())
end

function firmwareUpdateTask:canStopToResearch()
	return false
end

function firmwareUpdateTask:setPlatform(obj)
	self.platform = obj
end

function firmwareUpdateTask:onBeginWork()
	events:fire(firmwareUpdateTask.EVENTS.BEGIN, self)
end

function firmwareUpdateTask:getWorkField()
	return self.workField
end

function firmwareUpdateTask:canReassign(desiredEmployee, curTask)
	return false
end

function firmwareUpdateTask:canUnassignOnAway()
	return false
end

function firmwareUpdateTask:cancel()
	firmwareUpdateTask.baseClass.cancel(self)
	self:setAssignee(nil)
end

function firmwareUpdateTask:getTaskTypeText()
	return _T("FIRMWARE_UPDATE", "Firmware update")
end

function firmwareUpdateTask:areAllIssuesFixed()
	return true
end

function firmwareUpdateTask:getCompletionDisplay()
	return self:getCompletion()
end

function firmwareUpdateTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function firmwareUpdateTask:isDone()
	return self:isWorkOnDone()
end

function firmwareUpdateTask:getName()
	return _T("FIRMWARE_UPDATE_LOWERCASE", "firmware update")
end

function firmwareUpdateTask:getText()
	return _T("FIRMWARE_UPDATE", "Firmware update")
end

function firmwareUpdateTask:setAssignee(assignee)
	self.assignee = assignee
	
	if self.trainedSkills then
		for key, practice in ipairs(self.trainedSkills) do
			practice:setAssignee(assignee)
		end
	end
	
	self:onSetAssignee()
end

function firmwareUpdateTask:onSetAssignee()
	firmwareUpdateTask.baseClass.onSetAssignee(self)
	
	if self.assignee then
		if not self.displayCreated then
			self.displayCreated = true
			
			game.projectBox:addElement(self, nil, nil, "ActiveTaskElement")
		end
	else
		self:removeProjectBoxElement()
	end
end

function firmwareUpdateTask:removeProjectBoxElement()
	events:fire(designTask.EVENTS.REMOVE_DISPLAY, self)
end

function firmwareUpdateTask:onFinish()
	firmwareUpdateTask.baseClass.onFinish(self)
	self.platform:releaseFirmwareUpdate()
	events:fire(firmwareUpdateTask.EVENTS.FINISH, self)
	
	self.lastAssignee = nil
	
	self:setAssignee(nil)
end

function firmwareUpdateTask:adjustProgressAmount(assignee, progress)
	local speedBoost = assignee:getSpeedBoost()
	local driveModifier = assignee:getDriveModifier()
	local developmentBoost = assignee:getSkillDevBoost("development")
	local fieldBoost = assignee:getSkillDevBoost(self.workField)
	local traitBoost = assignee:getTraitDevelopSpeedModifiers()
	
	progress = progress * speedBoost * developmentBoost * fieldBoost * driveModifier * traitBoost * assignee:getDevelopSpeedMultiplier() * assignee:getOfficeDevSpeedMultiplier() * DEV_SPEED_MULTIPLIER
	
	return progress
end

function firmwareUpdateTask:progress(delta, progress, assignee)
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

function firmwareUpdateTask:canAssign(assignee)
	return true
end

function firmwareUpdateTask:save()
	local saved = firmwareUpdateTask.baseClass.save(self)
	
	saved.timeToProgress = self.timeToProgress
	saved.boostAttribute = self.boostAttribute
	saved.progressTime = self.progressTime
	saved.platformID = self.platform:getID()
	
	return saved
end

function firmwareUpdateTask:load(data)
	firmwareUpdateTask.baseClass.load(self, data)
	
	self.timeToProgress = data.timeToProgress
	self.boostAttribute = data.boostAttribute
	self.progressTime = data.progressTime
	self.platform = studio:getPlatformByID(data.platformID)
end

task:registerNew(firmwareUpdateTask, "progress_bar_task")
