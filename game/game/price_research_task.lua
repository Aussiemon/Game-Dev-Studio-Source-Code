local priceResearchTask = {}

priceResearchTask.id = "price_research_task"
priceResearchTask.timeToProgress = 1
priceResearchTask.workField = "management"
priceResearchTask.fillerColor = color(135, 193, 221, 255)
priceResearchTask.DEFAULT_REQUIRED_WORK_AMOUNT = 75
priceResearchTask.DEFAULT_TIME_TO_PROGRESS = 0.75
priceResearchTask.EVENTS = {
	BEGIN = events:new(),
	FINISH = events:new()
}

local designTask = task:getData("design_task")

function priceResearchTask:init()
	priceResearchTask.baseClass.init(self)
	
	self.finishedWork = 0
	self.progressTime = 0
	
	self:addTrainedSkill("development", priceResearchTask.DEV_EXP_MIN, priceResearchTask.DEV_EXP_MAX, priceResearchTask.DEV_EXP_TIME_MIN, priceResearchTask.DEV_EXP_TIME_MAX)
end

function priceResearchTask:getProjectBoxText()
	return _format(_T("PRICE_RESEARCH_FOR_GAME", "Price research - 'GAME'"), "GAME", self.project:getName())
end

function priceResearchTask:setProject(project)
	self.project = project
end

function priceResearchTask:canUnassignOnProjectFinish()
	return false
end

function priceResearchTask:onProjectScrapped(scrappedProj)
	if scrappedProj == self.project then
		self.assignee:cancelTask()
	end
end

function priceResearchTask:getProject()
	return self.project
end

function priceResearchTask:canReassign(desiredEmployee, curTask)
	return false
end

function priceResearchTask:canUnassignOnAway()
	return false
end

function priceResearchTask:onBeginWork()
	events:fire(priceResearchTask.EVENTS.BEGIN, self)
end

function priceResearchTask:getWorkField()
	return self.workField
end

function priceResearchTask:cancel()
	priceResearchTask.baseClass.cancel(self)
	self:setAssignee(nil)
end

function priceResearchTask:remove()
	priceResearchTask.baseClass.remove(self)
	self:setAssignee(nil)
end

function priceResearchTask:areAllIssuesFixed()
	return true
end

function priceResearchTask:getCompletionDisplay()
	return self:getCompletion()
end

function priceResearchTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function priceResearchTask:isDone()
	return self:isWorkOnDone()
end

function priceResearchTask:getTaskTypeText()
	return _T("PRICE_RESEARCH_TASKTYPE", "Price research")
end

function priceResearchTask:getName()
	return _T("PRICE_RESEARCH_NAME", "price research")
end

function priceResearchTask:getText()
	return _format(_T("PRICE_RESEARCH_FOR_GAME_PROJECT", "Price research for 'GAME'"), "GAME", self.project:getName())
end

function priceResearchTask:handleEvent(event, gameObj)
	if event == studio.EVENTS.RELEASED_GAME and gameObj == self.project then
		self.assignee:cancelTask()
	end
end

function priceResearchTask:setAssignee(assignee)
	self.assignee = assignee
	
	if self.trainedSkills then
		for key, practice in ipairs(self.trainedSkills) do
			practice:setAssignee(assignee)
		end
	end
	
	if not assignee then
		self:removeEventHandler()
	else
		self:initEventHandler()
	end
	
	self:onSetAssignee()
end

function priceResearchTask:initEventHandler()
	events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function priceResearchTask:removeEventHandler()
	events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function priceResearchTask:onSetAssignee()
	priceResearchTask.baseClass.onSetAssignee(self)
	
	if self.projectID then
		self.project = self.assignee:getEmployer():getProjectByUniqueID(self.projectID)
		self.projectID = nil
	end
	
	if self.assignee then
		if not self.display then
			self.display = game.projectBox:addElement(self, nil, nil, "ActivePriceResearchElement")
		end
	else
		self:removeProjectBoxElement()
	end
end

function priceResearchTask:removeProjectBoxElement()
	events:fire(designTask.EVENTS.REMOVE_DISPLAY, self)
end

local projectLink

function priceResearchTask.preStartDialogueCallback(dialogueObject)
	dialogueObject:setFact("game", projectLink)
	
	projectLink = nil
end

function priceResearchTask:onFinish()
	priceResearchTask.baseClass.onFinish(self)
	
	projectLink = self.project
	
	local dialogue = dialogueHandler:addDialogue("manager_game_pricing_finished_1", nil, self.assignee, priceResearchTask.preStartDialogueCallback)
	
	events:fire(priceResearchTask.EVENTS.FINISH, self)
	
	self.lastAssignee = nil
	
	self:setAssignee(nil)
end

function priceResearchTask:adjustProgressAmount(assignee, progress)
	local speedBoost = assignee:getSpeedBoost()
	local driveModifier = assignee:getDriveModifier()
	local developmentBoost = assignee:getSkillDevBoost("development")
	local fieldBoost = assignee:getSkillDevBoost(self.workField)
	local traitBoost = assignee:getTraitDevelopSpeedModifiers()
	
	progress = progress * speedBoost * developmentBoost * fieldBoost * driveModifier * traitBoost * assignee:getDevelopSpeedMultiplier() * assignee:getOfficeDevSpeedMultiplier() * DEV_SPEED_MULTIPLIER
	
	return progress
end

function priceResearchTask:progress(delta, progress, assignee)
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

function priceResearchTask:canAssign(assignee)
	return true
end

function priceResearchTask:save()
	local saved = priceResearchTask.baseClass.save(self)
	
	saved.timeToProgress = self.timeToProgress
	saved.progressTime = self.progressTime
	saved.projectID = self.project:getUniqueID()
	
	return saved
end

function priceResearchTask:load(data)
	priceResearchTask.baseClass.load(self, data)
	
	self.timeToProgress = data.timeToProgress
	self.progressTime = data.progressTime
	self.projectID = data.projectID
end

task:registerNew(priceResearchTask, "progress_bar_task")
