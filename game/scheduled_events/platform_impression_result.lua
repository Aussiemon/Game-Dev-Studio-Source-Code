local platformReaction = {}

platformReaction.id = "platform_impression_result"
platformReaction.inactive = true
platformReaction.platform = nil

function platformReaction:init()
end

function platformReaction:validateEvent()
	return true
end

function platformReaction:initEventHandler()
	events:addFunctionReceiver(self, self.handlePlatformScrap, playerPlatform.EVENTS.CANCELLED_DEVELOPMENT)
end

function platformReaction:handlePlatformScrap(platObj)
	if platObj == self.platform then
		scheduledEvents:removeBufferedEvent(self)
	end
end

function platformReaction:activate()
	platformReaction.baseClass.activate(self)
	self.platform:createImpressionPopup()
end

function platformReaction:canActivateLoad()
	return false
end

function platformReaction:canActivate()
	return timeline.curTime >= self.activationDate
end

function platformReaction:setActivationDate(date)
	self.activationDate = date
end

function platformReaction:setPlatform(obj)
	self.platform = obj
end

function platformReaction:save()
	local saved = platformReaction.baseClass.save(self)
	
	saved.platform = self.platform:getID()
	saved.activationDate = self.activationDate
	
	return saved
end

function platformReaction:load(data)
	self.platform = studio:getPlatformByID(data.platform)
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(platformReaction)
