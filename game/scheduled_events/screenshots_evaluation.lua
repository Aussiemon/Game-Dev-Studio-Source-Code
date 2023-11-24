local screenshotsEval = {}

screenshotsEval.id = "screenshots_evaluation"
screenshotsEval.inactive = true

function screenshotsEval:handleEvent(event, obj)
	if obj == self.project then
		scheduledEvents:removeBufferedEvent(self)
	end
end

function screenshotsEval:validateEvent()
	return true
end

function screenshotsEval:activate()
	screenshotsEval.baseClass.activate(self)
	advertisement:getData("screenshots"):resetFacts(self.project)
	advertisement:getData("screenshots"):evaluate(self.project, self)
end

function screenshotsEval:canActivateLoad()
	return false
end

function screenshotsEval:canActivate()
	return timeline.curTime >= self.activationDate
end

function screenshotsEval:setProject(proj)
	self.project = proj
end

function screenshotsEval:setRating(rating)
	self.rating = rating
end

function screenshotsEval:getRating()
	return self.rating
end

function screenshotsEval:setActivationDate(date)
	self.activationDate = date
end

function screenshotsEval:save()
	local saved = screenshotsEval.baseClass.save(self)
	
	saved.projID = self.project:getUniqueID()
	saved.activationDate = self.activationDate
	saved.rating = self.rating
	
	return saved
end

function screenshotsEval:load(data)
	self.project = studio:getGameByUniqueID(data.projID)
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
	self.rating = data.rating
end

scheduledEvents:registerNew(screenshotsEval)
