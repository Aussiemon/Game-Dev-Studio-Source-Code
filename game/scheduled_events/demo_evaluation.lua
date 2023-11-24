local demoEval = {}

demoEval.id = "demo_evaluation"
demoEval.inactive = true

function demoEval:handleEvent(event, obj)
	if obj == self.project then
		scheduledEvents:removeBufferedEvent(self)
	end
end

function demoEval:validateEvent()
	return true
end

function demoEval:activate()
	demoEval.baseClass.activate(self)
	self.project:evaluateDemo(self.rating or review:getCurrentGameVerdict(self.project))
end

function demoEval:canActivateLoad()
	return false
end

function demoEval:canActivate()
	return timeline.curTime >= self.activationDate
end

function demoEval:setProject(proj)
	self.project = proj
end

function demoEval:setRating(rating)
	self.rating = rating
end

function demoEval:setActivationDate(date)
	self.activationDate = date
end

function demoEval:save()
	local saved = demoEval.baseClass.save(self)
	
	saved.projID = self.project:getUniqueID()
	saved.activationDate = self.activationDate
	saved.rating = self.rating
	
	return saved
end

function demoEval:load(data)
	self.project = studio:getGameByUniqueID(data.projID)
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
	self.rating = data.rating
end

scheduledEvents:registerNew(demoEval)
