unlocks = {}
unlocks.available = {}

function unlocks:remove()
	table.clear(self.available)
end

function unlocks:makeAvailable(id)
	self.available[id] = true
end

function unlocks:makeUnavailable(id)
	self.available[id] = false
end

function unlocks:isAvailable(id)
	return self.available[id]
end

function unlocks:save()
	return {
		available = self.available
	}
end

function unlocks:load(data)
	self.available = data.available
end
