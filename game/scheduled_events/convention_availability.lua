local conventionAvailability = {}

conventionAvailability.id = "convention_availability"
conventionAvailability.conventionID = nil
conventionAvailability.inactive = true

function conventionAvailability:validateEvent()
	return scheduledEvents.activatedEvents[self.id]
end

function conventionAvailability:activate()
	gameConventions:addAvailableConvention(self.conventionID)
	conventionAvailability.baseClass.activate(self)
end

scheduledEvents:registerNew(conventionAvailability, "generic_timed_popup")
