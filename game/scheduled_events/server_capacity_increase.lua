local serverCapacity = {}

serverCapacity.id = "server_capacity_increase"
serverCapacity.inactive = true

function serverCapacity:activate()
	serverCapacity.baseClass.activate(self)
	serverRenting:setCapacity(self.capacity)
end

scheduledEvents:registerNew(serverCapacity)
