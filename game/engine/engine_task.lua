local engineTask = {}

engineTask.id = "engine_task"

function engineTask:onFinish()
	if not self.wasFinished and not self.project:hasFeature(self.taskType) then
		self.project:addFeature(self.taskType)
		
		if self.taskTypeData.statAffector then
			self.project:adjustStat(self.taskTypeData.statAffector.statID, self.taskTypeData.statAffector.amount)
		end
	end
	
	engineTask.baseClass.onFinish(self)
end

function engineTask:getCost()
	return self.cost
end

function engineTask:setProject(proj)
	engineTask.baseClass.setProject(self, proj)
	
	self.integrity = self.project:getStat("integrity", nil)
end

function engineTask:updateProgressAmount()
	engineTask.baseClass.updateProgressAmount(self)
	
	self.progressValue = self.progressValue * self.integrity
end

task:registerNew(engineTask, "project_task")
require("game/engine/engine_revamp_task")

engine.TASK_CLASS = engineTask
