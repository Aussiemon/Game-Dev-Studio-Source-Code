local schedule = {}

function schedule:init()
	self:setText(_T("SCHEDULE_ACTIVITY", "Schedule"))
end

function schedule:setActivityID(id)
	self.activityID = id
end

function schedule:setCost(cost)
	self.cost = cost
end

function schedule:isDisabled()
	return not studio:hasFunds(self.cost)
end

function schedule:onClick(x, y, key)
	if not studio:hasFunds(self.cost) then
		return 
	end
	
	studio:scheduleActivity(self.activityID)
	frameController:pop()
end

gui.register("ScheduleActivityButton", schedule, "Button")
