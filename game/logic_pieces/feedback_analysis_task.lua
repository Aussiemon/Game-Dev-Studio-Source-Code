local feedbackTask = {}

feedbackTask.id = "feedback_analysis_task"
feedbackTask.timeToProgress = 1
feedbackTask.workField = "management"
feedbackTask.fillerColor = color(135, 193, 221, 255)
feedbackTask.DEFAULT_REQUIRED_WORK_AMOUNT = 75
feedbackTask.DEFAULT_TIME_TO_PROGRESS = 0.75
feedbackTask.EVENTS = {
	BEGIN = events:new(),
	FINISH = events:new()
}

local logicData = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)

feedbackTask.CATCHABLE_EVENTS = {
	logicData.EVENTS.OVER
}

local designTask = task:getData("design_task")

function feedbackTask:init()
	feedbackTask.baseClass.init(self)
	
	self.finishedWork = 0
	self.progressTime = 0
	
	self:addTrainedSkill("development", feedbackTask.DEV_EXP_MIN, feedbackTask.DEV_EXP_MAX, feedbackTask.DEV_EXP_TIME_MIN, feedbackTask.DEV_EXP_TIME_MAX)
end

function feedbackTask:getProjectBoxText()
	return _format(_T("FEEDBACK_ANALYSIS_FOR_GAME", "Feedback analysis - 'GAME'"), "GAME", self.project:getName())
end

function feedbackTask:setProject(project)
	self.project = project
end

function feedbackTask:canUnassignOnProjectFinish()
	return false
end

function feedbackTask:onProjectScrapped(scrappedProj)
	if scrappedProj == self.project then
		self.assignee:cancelTask()
	end
end

function feedbackTask:getProject()
	return self.project
end

function feedbackTask:canReassign(desiredEmployee, curTask)
	return false
end

function feedbackTask:canUnassignOnAway()
	return false
end

function feedbackTask:onBeginWork()
	events:fire(feedbackTask.EVENTS.BEGIN, self)
end

function feedbackTask:getWorkField()
	return self.workField
end

function feedbackTask:cancel()
	feedbackTask.baseClass.cancel(self)
	self:setAssignee(nil)
end

function feedbackTask:remove()
	feedbackTask.baseClass.remove(self)
	self:setAssignee(nil)
end

function feedbackTask:areAllIssuesFixed()
	return true
end

function feedbackTask:getCompletionDisplay()
	return self:getCompletion()
end

function feedbackTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function feedbackTask:isDone()
	return self:isWorkOnDone()
end

function feedbackTask:getTaskTypeText()
	return _T("FEEDBACK_ANALYSIS_TASKTYPE", "Feedback analysis")
end

function feedbackTask:getName()
	return _T("FEEDBACK_ANALYSIS_NAME", "feedback analysis")
end

function feedbackTask:getText()
	return _format(_T("FEEDBACK_ANALYSIS_FOR_GAME_PROJECT", "Feedback analysis for 'GAME'"), "GAME", self.project:getName())
end

function feedbackTask:handleEvent(event, gameObj)
	if event == logicData.EVENTS.OVER and gameObj == self.project then
		self.assignee:cancelTask()
	end
end

function feedbackTask:setAssignee(assignee)
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

function feedbackTask:initEventHandler()
	events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function feedbackTask:removeEventHandler()
	events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function feedbackTask:onSetAssignee()
	feedbackTask.baseClass.onSetAssignee(self)
	
	if self.projectID then
		self.project = self.assignee:getEmployer():getProjectByUniqueID(self.projectID)
		self.projectID = nil
	end
	
	if self.assignee then
		if not self.display then
			self.display = game.projectBox:addElement(self, nil, nil, "ActiveTaskElement")
		end
	else
		self:removeProjectBoxElement()
	end
end

function feedbackTask:removeProjectBoxElement()
	events:fire(designTask.EVENTS.REMOVE_DISPLAY, self)
end

function feedbackTask:onFinish()
	feedbackTask.baseClass.onFinish(self)
	
	local dialogue = dialogueHandler:addDialogue("manager_finished_feedback_analysis", nil, self.assignee)
	
	dialogue:setFact("game", self.project)
	
	local piece = self.project:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
	
	if piece:isFeedbackCooldownOver() then
		local tasks = piece:getEvaluatableTasks()
		local genre = self.project:getGenre()
		local curIndex = 1
		local indexCount = #tasks
		
		if indexCount > 0 then
			for i = 1, indexCount do
				local id = tasks[curIndex]
				
				if gameProject.isMMOMatchKnown(id, genre) then
					table.remove(tasks, curIndex)
				else
					curIndex = curIndex + 1
				end
			end
			
			if #tasks > 0 then
				local id = table.remove(tasks, math.random(1, #tasks))
				
				dialogue:setFact("task", id)
				piece:onFinishFeedback(true, genre, id)
			end
		end
	end
	
	events:fire(feedbackTask.EVENTS.FINISH, self)
	
	self.lastAssignee = nil
	
	self:setAssignee(nil)
end

function feedbackTask:adjustProgressAmount(assignee, progress)
	local speedBoost = assignee:getSpeedBoost()
	local driveModifier = assignee:getDriveModifier()
	local developmentBoost = assignee:getSkillDevBoost("development")
	local fieldBoost = assignee:getSkillDevBoost(self.workField)
	local traitBoost = assignee:getTraitDevelopSpeedModifiers()
	
	progress = progress * speedBoost * developmentBoost * fieldBoost * driveModifier * traitBoost * assignee:getDevelopSpeedMultiplier() * assignee:getOfficeDevSpeedMultiplier() * DEV_SPEED_MULTIPLIER
	
	return progress
end

function feedbackTask:progress(delta, progress, assignee)
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

function feedbackTask:canAssign(assignee)
	return true
end

function feedbackTask:save()
	local saved = feedbackTask.baseClass.save(self)
	
	saved.timeToProgress = self.timeToProgress
	saved.progressTime = self.progressTime
	saved.projectID = self.project:getUniqueID()
	
	return saved
end

function feedbackTask:load(data)
	feedbackTask.baseClass.load(self, data)
	
	self.timeToProgress = data.timeToProgress
	self.progressTime = data.progressTime
	self.projectID = data.projectID
end

task:registerNew(feedbackTask, "progress_bar_task")
