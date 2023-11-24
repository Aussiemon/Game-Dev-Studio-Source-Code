pathCaching = {}
pathCaching.storedPaths = {}
pathCaching.storedPathsNumeric = {}
pathCaching.maxCachedPaths = 10000
pathCaching.EVENTS = {
	PATHS_INVALIDATED = events:new()
}
pathCaching.CATCHABLE_EVENTS = {
	studio.expansion.EVENTS.BOUGHT_WALL,
	studio.expansion.EVENTS.REMOVED_WALL,
	studio.expansion.EVENTS.PLACED_OBJECT,
	studio.expansion.EVENTS.REMOVED_OBJECT
}

function pathCaching:init()
	self.totalPaths = 0
	
	events:addDirectReceiver(self, pathCaching.CATCHABLE_EVENTS)
end

function pathCaching:addPath(path, floor)
	local start = path[1]
	local finish = path[#path]
	
	self.storedPaths[floor][start] = self.storedPaths[floor][start] or {}
	self.storedPaths[floor][start][finish] = path
	self.totalPaths = self.totalPaths + 1
	
	if not self:getPath(finish, start, floor) then
		self:addPath(table.reverse(path), floor)
	end
	
	self.storedPathsNumeric[#self.storedPathsNumeric + 1] = {
		floor,
		path
	}
	
	local delta = #self.storedPathsNumeric - self.maxCachedPaths
	
	if delta > 0 then
		for i = 1, delta do
			local data = self.storedPathsNumeric[1]
			local pathFloor = data[1]
			local path = data[2]
			local start, finish = path[1], path[#path]
			
			table.remove(self.storedPathsNumeric, 1)
			
			self.storedPaths[pathFloor][start][finish] = nil
		end
		
		self.totalPaths = self.totalPaths - delta
	end
end

function pathCaching:setupFloor(i)
	self.storedPaths[i] = {}
end

function pathCaching:getPath(startIndex, finishIndex, floor)
	local map = self.storedPaths[floor][startIndex]
	
	if map then
		return map[finishIndex]
	end
end

function pathCaching:handleEvent(event)
	self:invalidatePaths()
end

function pathCaching:invalidatePaths()
	for i = 1, game.worldObject:getFloorCount() do
		table.clear(self.storedPaths[i])
	end
	
	table.clearArray(self.storedPathsNumeric)
	
	self.totalPaths = 0
	
	events:fire(pathCaching.EVENTS.PATHS_INVALIDATED)
end

function pathCaching:remove()
	table.clear(self.storedPaths)
	table.clearArray(self.storedPathsNumeric)
	events:removeDirectReceiver(self, pathCaching.CATCHABLE_EVENTS)
end
