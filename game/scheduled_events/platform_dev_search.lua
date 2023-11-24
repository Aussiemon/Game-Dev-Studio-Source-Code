local devSearch = {}

devSearch.id = "platform_dev_search"
devSearch.inactive = true
devSearch.platform = nil

function devSearch:init()
end

function devSearch:validateEvent()
	return true
end

function devSearch:initEventHandler()
	events:addFunctionReceiver(self, self.handlePlatformScrap, playerPlatform.EVENTS.CANCELLED_DEVELOPMENT)
end

function devSearch:handlePlatformScrap(platObj)
	if platObj == self.platform then
		scheduledEvents:removeBufferedEvent(self)
	end
end

function devSearch:activate()
	devSearch.baseClass.activate(self)
	self.platform:onFinishDevSearch()
end

function devSearch:canActivateLoad()
	return false
end

function devSearch:canActivate()
	return timeline.curTime >= self.activationDate
end

function devSearch:setActivationDate(date)
	self.activationDate = date
end

function devSearch:setPlatform(name)
	self.platform = name
end

function devSearch:save()
	local saved = devSearch.baseClass.save(self)
	
	saved.platform = self.platform:getID()
	saved.activationDate = self.activationDate
	
	return saved
end

function devSearch:load(data)
	self.platform = studio:getPlatformByID(data.platform)
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(devSearch)
