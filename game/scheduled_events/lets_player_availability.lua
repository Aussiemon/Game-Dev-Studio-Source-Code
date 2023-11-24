local letsPlayerAvailability = {}

letsPlayerAvailability.id = "lets_player_availability"
letsPlayerAvailability.letsPlayerID = nil
letsPlayerAvailability.inactive = true

function letsPlayerAvailability:activate()
	letsPlayers:initLetsPlayer(self.letsPlayerID)
	letsPlayerAvailability.baseClass.activate(self)
end

scheduledEvents:registerNew(letsPlayerAvailability, "generic_timed_popup")
