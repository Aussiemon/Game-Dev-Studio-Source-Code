local finishAssigning = {}

function finishAssigning:init()
end

function finishAssigning:setInterview(inter)
	self.interview = inter
end

function finishAssigning:onClick()
	if self:isDisabled() then
		return 
	end
	
	self.interview:startManagerInterview()
end

function finishAssigning:onKill()
	if not self.interview:isManagerInterview() then
		self.interview:setManager(nil)
	end
end

function finishAssigning:isDisabled()
	if not self.interview:getAssignedManager() then
		return true
	end
	
	return false
end

gui.register("FinishAssigningManagerButton", finishAssigning, "Button")
