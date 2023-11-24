local polishTask = {}

polishTask.id = "polish_project_task"
polishTask.timeToProgress = 1
polishTask.qualityIncreaseRequirement = 10
polishTask.randomIssues = {}
polishTask.MIN_ISSUE_DISCOVER_CHANCE = 10
polishTask.MAX_CHANCE_DISCOVERED_ISSUES_AMOUNT = 20
polishTask.EXP_INCREASE_PER_OVER_LIMIT = 0.005
polishTask.FINAL_CHANCE_DEC_MULTIPLIER = 0.5
polishTask.WORK_OVERALL_MULTIPLIER = 0.6
polishTask.qualityAddMultiplier = 1

function polishTask:init()
	polishTask.baseClass.init(self)
end

local projectTask = task:getData("project_task")

function polishTask:onFinish()
	projectTask.onFinish(self)
end

function polishTask:canHaveIssues()
	return false
end

function polishTask:getCompletionDisplay()
	return self:getCompletion()
end

function polishTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function polishTask:calculateRequiredWork(taskTypeData, projectObject)
	local total, platformPoints = polishTask.baseClass.calculateRequiredWork(self, taskTypeData, projectObject)
	
	return math.ceil(total * self.WORK_OVERALL_MULTIPLIER), math.ceil(total * self.WORK_OVERALL_MULTIPLIER)
end

function polishTask:initIssues()
end

function polishTask:setCanHaveIssues(can)
end

function polishTask:isDone()
	return self:isWorkOnDone()
end

function polishTask:save()
	local saved = polishTask.baseClass.save(self)
	
	saved.qualityAddMultiplier = self.qualityAddMultiplier
	
	return saved
end

function polishTask:load(data)
	polishTask.baseClass.load(self, data)
	
	self.qualityAddMultiplier = data.qualityAddMultiplier
end

task:registerNew(polishTask, "game_task")

gameProject.POLISH_TASK_CLASS = polishTask
