local releasePlatform = {}

releasePlatform.id = "release_platform_event"
releasePlatform.inactive = true
releasePlatform.platformID = nil

function releasePlatform:validateEvent()
	return scheduledEvents.activatedEvents[self.id]
end

function releasePlatform:activate()
	releasePlatform.baseClass.activate(self)
	
	local data = platforms.registeredByID[self.platformID]
	
	if not platformShare:isPlatformOnShareList(self.platformID) and platforms:canBeReleased(data) then
		platformShare:addPlatformToShareList(platformShare:initPlatform(data))
	end
end

scheduledEvents:registerNew(releasePlatform)
