pathComputeQueue = {}

function pathComputeQueue:init()
	self.queue = {}
	self.queueMap = {}
	self.activeSearches = {}
	self.activeSearchMap = {}
	self.cancelList = {}
	self.grid = game.worldObject:getFloorTileGrid()
	self.activePathfinderCount = 0
end

function pathComputeQueue:remove()
	for key, data in ipairs(self.queue) do
		self.queueMap[data[1]] = nil
		self.queue[key] = nil
	end
	
	for key, search in ipairs(self.activeSearches) do
		search[2]:cancelPath()
		
		self.activeSearches[key] = nil
		self.activeSearchMap[search[1]] = nil
	end
	
	self.grid = nil
	self.activePathfinderCount = 0
end

function pathComputeQueue:addToQueue(object, targetObj, endX, endY)
	if not self.queueMap[object] then
		if self.activePathfinderCount < game.MAX_PATHFINDER_THREADS then
			self:_setupPathfinder(object, endX, endY)
		else
			table.insert(self.queue, {
				object,
				targetObj,
				endX,
				endY
			})
			
			self.queueMap[object] = true
		end
	end
end

function pathComputeQueue:cancelPathfind(object)
	if self.queueMap[object] then
		self.queueMap[object] = nil
		
		table.insert(self.cancelList, object)
		
		for key, data in ipairs(self.queue) do
			if data[1] == object then
				table.remove(self.queue, key)
				
				break
			end
		end
	end
	
	if self.activeSearchMap[object] then
		for key, iterObj in ipairs(self.activeSearches) do
			if iterObj[1] == object then
				table.remove(self.activeSearches, key)
				
				self.activeSearchMap[iterObj[1]] = nil
				
				break
			end
		end
	end
end

function pathComputeQueue:removeFromQueue(obj)
	local removed = false
	
	for key, data in ipairs(self.queue) do
		if data[1] == obj then
			table.remove(self.queue, key)
			
			self.queueMap[obj] = nil
			removed = true
			
			break
		end
		
		self:cancelPathfind(obj)
	end
	
	return removed
end

function pathComputeQueue:advanceQueue()
	local queue = self.queue
	local qSize = #queue
	
	if #self.queue == 0 then
		return 
	end
	
	local data = table.remove(self.queue, 1)
	local object, endX, endY = data[1], data[3], data[4]
	
	self.queueMap[object] = nil
	
	return self:_setupPathfinder(object, endX, endY)
end

function pathComputeQueue:_setupPathfinder(object, endX, endY)
	local floor = object:getFloor()
	local startX, startY = object:getTileCoordinates()
	local availableThread = game.searchThreadedPath(startX, startY, endX, endY, floor, {
		self.grid:getTileIndex(startX, startY)
	})
	
	if availableThread then
		table.insert(self.activeSearches, {
			object,
			availableThread
		})
		
		self.activeSearchMap[object] = true
		self.activePathfinderCount = self.activePathfinderCount + 1
		
		return true
	end
	
	return false
end

function pathComputeQueue:update()
	local searches = self.activeSearches
	local searchC = #searches
	
	if searchC > 0 then
		local idx = 1
		local searchMap = self.activeSearchMap
		
		for i = 1, searchC do
			local data = searches[idx]
			local target, thread = data[1], data[2]
			local path, state, floor = thread:checkForPath()
			
			if state then
				table.remove(searches, idx)
				
				searchMap[target] = nil
				
				pathCaching:addPath(path, floor)
				target:onPathFound(path)
				
				self.activePathfinderCount = self.activePathfinderCount - 1
				
				self:advanceQueue()
			elseif state == false then
				table.remove(searches, idx)
				
				searchMap[target] = nil
				
				target:onPathfindFailed()
				
				self.activePathfinderCount = self.activePathfinderCount - 1
			else
				idx = idx + 1
			end
		end
	end
	
	local cancelList = self.cancelList
	
	if #cancelList > 0 then
		local idx = 1
		
		for i = 1, #cancelList do
			local obj = cancelList[idx]
			
			if obj:cancelPath() then
				table.remove(cancelList, idx)
				
				self.activePathfinderCount = self.activePathfinderCount - 1
			else
				idx = idx + 1
			end
		end
	end
end
