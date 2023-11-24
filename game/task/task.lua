task = {}
task.registered = {}
task.registeredByID = {}
task.registeredByCategory = {}

local baseTask = {}

baseTask.mtindex = {
	__index = baseTask
}
baseTask.id = "base_task"
baseTask.timeToProgress = 1
baseTask.taskType = nil

function baseTask:setAssignee(target)
	self.assignee = target
	
	self:onSetAssignee()
end

function baseTask:onSetAssignee()
end

function baseTask:init()
end

function baseTask:updateSpecializationBoost()
end

function baseTask:canStopToResearch()
	return true
end

function baseTask:canUnassignOnAway()
	return true
end

function baseTask:queueProgressUpdate()
end

function baseTask:updateProgressAmount()
end

function baseTask:canUnassignOnProjectFinish()
	return true
end

function baseTask:onProjectScrapped()
end

function baseTask:canCrossContribute()
	return true
end

function baseTask:getProjectBoxText()
	return "project box text not set"
end

function baseTask:enterVisibilityRange()
end

function baseTask:leaveVisibilityRange()
end

function baseTask:getProject()
	return nil
end

function baseTask:getTargetProject()
	return nil
end

function baseTask:addTrainedSkill(skillID, expMin, expMax, practiceMin, practiceMax)
	self.trainedSkills = self.trainedSkills or {}
	expMin = expMin or 15
	expMax = expMax or 20
	practiceMin = practiceMin or 1.5
	practiceMax = practiceMax or 2
	self.trainedSkills = self.trainedSkills or {}
	
	local practice = task.new("practice_skill")
	
	practice:setBarVisible(false)
	practice:setPracticeSkill(skillID)
	practice:setSessions(-1)
	practice:setExperienceIncrease(expMin, expMax)
	practice:setPracticeInterval(practiceMin, practiceMax)
	table.insert(self.trainedSkills, practice)
end

function baseTask:getTrainedSkills()
	return self.trainedSkills
end

function baseTask:hasTrainedSkill(skillID)
	if self.trainedSkills then
		for key, taskObj in ipairs(self.trainedSkills) do
			if taskObj:getPracticeSkill() == skillID then
				return true
			end
		end
		
		return false
	end
	
	return nil
end

function baseTask:getUnassignOnFinish()
	return true
end

function baseTask:clearPracticeTasks()
	for key, taskObj in ipairs(self.trainedSkills) do
		taskObj:setAssignee(nil)
	end
end

function baseTask:canReassign(desiredEmployee, curTask)
	return true
end

function baseTask:getID()
	return self.id
end

function baseTask:canCancel()
	return true
end

function baseTask:isCancelled()
	return self.cancelled
end

function baseTask:onProjectFinished()
end

function baseTask:canSave()
	return true
end

function baseTask:cancel()
	self.cancelled = true
end

function baseTask:onBeginWork()
end

function baseTask:draw()
end

function baseTask:getAssignee(assignee)
	return self.assignee
end

function baseTask:calculateRequiredWork(taskTypeData, projectObject)
	return taskTypeData.workAmount
end

function baseTask:setupRequiredWork()
	self:setRequiredWork(self:calculateRequiredWork(self.taskTypeData, self.project))
end

function baseTask:setRequiredWork(amount)
	self.requiredWork = math.ceil(amount)
end

function baseTask:setFinishedWork(work)
	self.finishedWork = work
end

function baseTask:getCompletionDisplay()
	return self:getCompletion()
end

function baseTask:getCompletion()
	return self.finishedWork / self.requiredWork
end

function baseTask:getRequiredWork()
	return self.requiredWork
end

function baseTask:getFinishedWork()
	return self.finishedWork
end

function baseTask:getRemainingWork()
	return self.requiredWork - self.finishedWork
end

function baseTask:setCanHaveIssues(state)
end

function baseTask:getTaskTypeData()
	return self.taskTypeData
end

function baseTask:getCategory()
	return self.taskTypeData.category
end

function baseTask:setTaskType(taskType)
	self.taskType = taskType
	
	if self.taskType then
		self.taskTypeData = taskTypes:getData(taskType)
		
		if not self.requiredWork then
			self:setRequiredWork(self.taskTypeData.workAmount)
		end
		
		self:setWorkField(self.taskTypeData.workField)
		
		if not self.taskTypeData.noIssues then
			self:setCanHaveIssues(true)
		end
	end
end

function baseTask:getTaskType()
	return self.taskType
end

function baseTask:getTaskTypeText()
	return "base"
end

function baseTask:remove()
end

function baseTask:onCreate()
end

function baseTask:getName()
	return taskTypes:getData(self.taskType).display
end

function baseTask:initWorkAmount(scale)
end

function baseTask:progress(delta, progress)
end

function baseTask:validateIssueState()
end

function baseTask:onFinish()
	if self.taskTypeData then
		self.taskTypeData:onFinish(self)
	end
end

function baseTask:setWorkField(field)
	self.workField = field
end

function baseTask:getWorkField()
	return self.workField
end

function baseTask:isDone()
	return false
end

function baseTask:isWorkOnDone()
	return false
end

function baseTask:getUndiscoveredUnfixedIssueCount(type)
	return 0
end

function baseTask:getUnfixedIssueCount(type)
	return 0
end

function baseTask:canAssign(assignee)
	return true
end

function baseTask:setTimeToProgress(time)
	self.timeToProgress = time
end

function baseTask:save()
	local trainedSkills
	
	if self.trainedSkills then
		trainedSkills = {}
		
		for key, taskObj in ipairs(self.trainedSkills) do
			table.insert(trainedSkills, taskObj:save())
		end
	end
	
	return {
		id = self.id,
		finishedWork = self.finishedWork,
		requiredWork = self.requiredWork,
		taskType = self.taskType,
		trainedSkills = trainedSkills,
		timeToProgress = self.timeToProgress,
		workField = self.workField
	}
end

function baseTask:load(data, assignee)
	self.id = data.id
	self.finishedWork = data.finishedWork
	self.timeToProgress = data.timeToProgress
	self.workField = data.workField
	self.requiredWork = data.requiredWork
	
	if data.trainedSkills then
		self.trainedSkills = self.trainedSkills or {}
		
		for key, taskData in ipairs(data.trainedSkills) do
			local task = task.new(taskData.id)
			
			task:setBarVisible(false)
			task:load(taskData)
			table.insert(self.trainedSkills, task)
		end
	end
	
	self:setTaskType(data.taskType)
end

function task.new(taskID, ...)
	local taskBase = task.registeredByID[taskID]
	local newTask = {}
	
	setmetatable(newTask, taskBase.mtindex)
	newTask:init(...)
	
	return newTask
end

function task:registerNew(data, inherit)
	table.insert(task.registered, data)
	
	task.registeredByID[data.id] = data
	
	if data.category then
		task.registeredByCategory[data.category] = task.registeredByCategory[data.category] or {}
		
		table.insert(task.registeredByCategory[data.category], data)
	end
	
	if inherit then
		local inherit = task.registeredByID[inherit]
		
		setmetatable(data, inherit.mtindex)
		
		data.baseClass = inherit
	else
		setmetatable(data, baseTask.mtindex)
		
		data.baseClass = baseTask
	end
	
	data.mtindex = {
		__index = data
	}
end

function task:getData(taskID)
	return task.registeredByID[taskID]
end

require("game/task/task_types")
require("game/task/progress_bar_task")
require("game/task/practice_skill")
require("game/task/design_task")
