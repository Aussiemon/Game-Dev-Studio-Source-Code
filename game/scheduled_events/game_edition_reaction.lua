local gameEditReact = {}

gameEditReact.id = "game_edition_reaction"
gameEditReact.inactive = true

function gameEditReact:handleEvent(event, obj)
	if obj == self.project then
		scheduledEvents:removeBufferedEvent(self)
	end
end

function gameEditReact:validateEvent()
	return true
end

function gameEditReact:activate()
	gameEditReact.baseClass.activate(self)
	self.project:evaluateEditions()
end

function gameEditReact:canActivateLoad()
	return false
end

function gameEditReact:canActivate()
	return timeline.curTime >= self.activationDate
end

function gameEditReact:setProject(proj)
	self.project = proj
end

function gameEditReact:setActivationDate(date)
	self.activationDate = date
end

function gameEditReact:save()
	local saved = gameEditReact.baseClass.save(self)
	
	saved.projID = self.project:getUniqueID()
	saved.activationDate = self.activationDate
	
	return saved
end

function gameEditReact:load(data)
	self.project = studio:getGameByUniqueID(data.projID)
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(gameEditReact)
