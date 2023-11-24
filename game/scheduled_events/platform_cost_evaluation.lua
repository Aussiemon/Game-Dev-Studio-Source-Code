local platCostEval = {}

platCostEval.id = "platform_cost_evaluation"
platCostEval.inactive = true

function platCostEval:validateEvent()
	return true
end

function platCostEval:activate()
	platCostEval.baseClass.activate(self)
	
	if self.platform:isDiscontinued() then
		return 
	end
	
	self.platform:evaluateCost()
end

function platCostEval:canActivateLoad()
	return false
end

function platCostEval:canActivate()
	return timeline.curTime >= self.activationDate
end

function platCostEval:setPlatform(plat)
	self.platform = plat
end

function platCostEval:setActivationDate(date)
	self.activationDate = date
end

function platCostEval:save()
	local saved = platCostEval.baseClass.save(self)
	
	saved.platID = self.platform:getID()
	saved.activationDate = self.activationDate
	
	return saved
end

function platCostEval:load(data)
	self.platform = studio:getPlatformByID(data.platID)
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(platCostEval)
