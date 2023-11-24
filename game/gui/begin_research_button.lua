local beginResearch = {}

function beginResearch:init()
end

function beginResearch:setTask(taskObj)
	self.taskObject = taskObj
end

function beginResearch:onClick()
	if self:isDisabled() then
		return 
	end
	
	self.taskObject:getAssignee():setTask(self.taskObject)
	frameController:pop()
	events:fire(studio.EVENTS.BEGUN_FEATURE_RESEARCH)
end

function beginResearch:isDisabled()
	return not self.taskObject:getAssignee()
end

gui.register("BeginResearchButton", beginResearch, "Button")
