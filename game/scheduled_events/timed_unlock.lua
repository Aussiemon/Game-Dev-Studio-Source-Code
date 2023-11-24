local base = {}

base.id = "timed_unlock"
base.inactive = true
base.unlockID = nil

function base:activate()
	base.baseClass.activate(self)
	unlocks:makeAvailable(self.unlockID)
end

function base:validateEvent()
	return unlocks:isAvailable(self.unlockID)
end

scheduledEvents:registerNew(base)
