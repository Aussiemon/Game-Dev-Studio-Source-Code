local revampTask = {}

revampTask.id = "engine_revamp_task"

function revampTask:canAssign(dev)
	return dev:getSkill(self.workField).level >= self.project:getMinimumRevampRequirement()
end

function revampTask:calculateRequiredWork(taskTypeData, projectObject)
	return math.ceil(taskTypeData.workAmount * engine.REVAMP_WORK_SCALE)
end

function revampTask:load(data)
	revampTask.baseClass.load(self, data)
end

task:registerNew(revampTask, "engine_task")

engine.REVAMP_TASK_CLASS = revampTask
