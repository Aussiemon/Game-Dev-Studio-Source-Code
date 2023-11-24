pathfinderThread = {}
pathfinderThread.MESSAGE_TYPE = {
	ABORT = 4,
	FIND_PATH = 3,
	CLEAR_GRID = 9,
	STOP = 7,
	GRID_UPDATE = 2,
	FLOOR = 8,
	PATH_FOUND = 5,
	GRID = 1,
	PATH_FIND_FAILED = 6
}
pathfinderThread.mtindex = {
	__index = pathfinderThread
}
pathfinderThread.THREAD_IN_CHANNEL = "PATHFINDER_IN_"
pathfinderThread.THREAD_OUT_CHANNEL = "PATHFINDER_OUT_"
pathfinderThread.SEND_DATA = {}

local ffi = require("ffi")

pathfinderThread.gridTileType = ffi.typeof("floor_structure *")
pathfinderThread.THREAD_INIT_STRING = "\tjit.opt.start('maxmcode=2048', 'maxtrace=2000')\n\n\t-- load base stuff\n\trequire(\"engine/extratable\")\n\t\n\t-- load grid\n\trequire(\"engine/pathfinding\")\n\trequire(\"engine/quad_loader\")\n\trequire(\"engine/translation\")\n\trequire(\"engine/tilegrid\")\n\trequire(\"engine/objectgrid\")\n\t--require(\"engine/bitser\")\n\trequire(\"game/tilegrid/tilegrid\")\n\t\n\trequire(\"game/world/floors\")\n\trequire(\"game/world/walls\")\n\t\n\trequire(\"game/pathfinder_thread\")\n\t--require(\"game/error_reporter\")\n\t\n\tlocal inChannel = love.thread.getChannel(\"IN_CHANNEL_NAME\") -- channel which receives info about what's going on in the main thread\n\tlocal outChannel = love.thread.getChannel(\"OUT_CHANNEL_NAME\") -- channel which sends out paths\n\t\n\tlocal threadContainer = pathfinderThread.new()\n\tthreadContainer:setChannels(inChannel, outChannel)\n\tthreadContainer.tileWidth = \"TILE_WIDTH\"\n\tthreadContainer.tileHeight = \"TILE_HEIGHT\"\n\t\n\tlocal GC = 0\n\t\n\twhile not threadContainer.STOPPED do\n\t\tthreadContainer:update()\n\t\t\n\t\t--GC = GC + 1\n\t\t\n\t\t--if GC >= 50 then\n\t\t--\tprint(\"stepmantas\")\n\t\t\tcollectgarbage(\"step\", 100)\n\t\t--\tGC = 0\n\t\t--end\n\tend\n"

function pathfinderThread.new()
	local new = {}
	
	setmetatable(new, pathfinderThread.mtindex)
	new:init()
	
	return new
end

function pathfinderThread:init()
	self.pathsCreated = 0
	self.floor = 1
end

function pathfinderThread:remove()
	pf.removePathfinder(self.pathfinder)
	
	self.pathfinder = nil
	
	self:sendInWait(pathfinderThread.MESSAGE_TYPE.STOP, nil)
	self.outChannel:clear()
end

local bitser = require("engine/bitser")

function pathfinderThread:cancelPath()
	if self.cancelledPath then
		local data = self.outChannel:pop()
		
		if data then
			self.busy = false
			self.cancelledPath = false
			
			return true
		end
	end
	
	local data = self.outChannel:pop()
	
	if data then
		self.busy = false
		self.pathsCreated = self.pathsCreated + 1
		self.cancelledPath = false
		
		return true
	end
	
	self.cancelledPath = true
	
	return false
end

function pathfinderThread:startPathfinding(floor, threadData)
	self.pathFloor = floor
	
	self:sendIn(pathfinderThread.MESSAGE_TYPE.FIND_PATH, threadData)
end

function pathfinderThread:checkForPath()
	local data = self.outChannel:pop()
	
	if data then
		if data.type == pathfinderThread.MESSAGE_TYPE.PATH_FOUND then
			self.busy = false
			self.pathsCreated = self.pathsCreated + 1
			
			local deserialised = bitser.loads(data.payload)
			
			return deserialised, true, self.pathFloor
		elseif data.type == pathfinderThread.MESSAGE_TYPE.PATH_FIND_FAILED then
			self.busy = false
			
			return nil, false, nil
		end
	end
	
	return nil, nil, self.pathFloor
end

function pathfinderThread:createPathfinder(gridW, gridH)
	pf:setToIndexConversionFunc(function(x, y)
		return self.grid:getTileIndex(x, y)
	end)
	pf:setIndexToCoordinatesFunc(function(index)
		return self.grid:convertIndexToCoordinates(index)
	end)
	
	self.pathfinder = pf.new(false, 100000)
	
	self.pathfinder:setSeparatePathObjects(true)
	self.pathfinder:setGridBoundaries(gridW, gridH)
	self.pathfinder:setFilterFunc(function(selfPathfinder, neighborX, neighborY, startX, startY)
		local grid = self.grid
		local initialIndex = grid:getTileIndex(startX, startY)
		local directionX, directionY = startX - neighborX, startY - neighborY
		local initialWallSides = walls:getSideFromDirection(-directionX, -directionY)
		local floor = self.floor
		
		for key, wallSide in ipairs(initialWallSides) do
			if not walls:canPassThrough(grid:getWallID(initialIndex, floor, wallSide)) then
				return nil
			end
		end
		
		local wallSides = walls:getSideFromDirection(directionX, directionY)
		local targetIndex = grid:getTileIndex(neighborX, neighborY)
		
		for key, wallSide in ipairs(wallSides) do
			if not walls:canPassThrough(grid:getWallID(targetIndex, floor, wallSide)) then
				return nil
			end
		end
		
		if targetIndex == self.endIndex then
			return true
		end
		
		if self._obstructionTiles[targetIndex] then
			return false
		end
		
		return true
	end)
	self.pathfinder:setScoreAdjust(function(x, y, score)
		return score + floors.registeredByID[self.grid:getTileValue(self.grid:getTileIndex(x, y), self.floor)].pathScore
	end)
	self.pathfinder:setEligibleBlockCheck(function(x, y, index)
		return floors.pedestrianTiles[self.grid:getTileValue(index, self.floor)]
	end)
end

function pathfinderThread:setChannels(inChannel, outChannel)
	self.inChannel = inChannel
	self.outChannel = outChannel
end

function pathfinderThread:sendIn(type, payload)
	if type == pathfinderThread.MESSAGE_TYPE.FIND_PATH then
		self.busy = true
	end
	
	pathfinderThread.SEND_DATA.type = type
	pathfinderThread.SEND_DATA.payload = payload
	
	self.inChannel:push(pathfinderThread.SEND_DATA)
end

function pathfinderThread:sendInWait(type, payload)
	if type == pathfinderThread.MESSAGE_TYPE.FIND_PATH then
		self.busy = true
	end
	
	pathfinderThread.SEND_DATA.type = type
	pathfinderThread.SEND_DATA.payload = payload
	
	self.inChannel:supply(pathfinderThread.SEND_DATA)
end

function pathfinderThread:sendOut(type, payload)
	pathfinderThread.SEND_DATA.type = type
	pathfinderThread.SEND_DATA.payload = payload
	
	self.outChannel:push(pathfinderThread.SEND_DATA)
end

function pathfinderThread:setup(threadIndex)
	local inChannel, outChannel = pathfinderThread.THREAD_IN_CHANNEL .. threadIndex, pathfinderThread.THREAD_OUT_CHANNEL .. threadIndex
	
	self.inChannel = love.thread.getChannel(inChannel)
	self.outChannel = love.thread.getChannel(outChannel)
	
	local initString = string.easyformatbykeys(pathfinderThread.THREAD_INIT_STRING, "IN_CHANNEL_NAME", inChannel, "OUT_CHANNEL_NAME", outChannel, "TILE_WIDTH", game.WORLD_TILE_WIDTH, "TILE_HEIGHT", game.WORDL_TILE_HEIGHT)
	
	self.thread = love.thread.newThread(initString)
	
	self.thread:start()
end

function pathfinderThread:setReceiver(receiver)
	self.receiver = receiver
end

function pathfinderThread:setIsBusy(state)
	self.busy = state
end

function pathfinderThread:isBusy()
	if self.pathfinder then
		return self.pathfinder:isBusy()
	end
	
	return self.busy
end

function pathfinderThread:setSearchPath(data)
	local deserialised = bitser.loads(data)
	
	self.startX = deserialised.startX
	self.startY = deserialised.startY
	self.endX = deserialised.endX
	self.endY = deserialised.endY
	self.floor = deserialised.floor
	self.endIndex = self.grid:getTileIndex(self.endX, self.endY)
	self._obstructionTiles = self.obstructionTiles[self.floor]
	self.ignoreTiles = deserialised.ignoreTiles or {}
	self.searchInProgress = true
	
	self.pathfinder:getPath(self.startX, self.startY, self.endX, self.endY)
end

function pathfinderThread:abortSearch()
	self.pathfinder:abort()
	self:clearSearchVariables()
end

function pathfinderThread:clearSearchVariables()
	self.pathfinder:clearResult()
	
	self.startX = nil
	self.startY = nil
	self.endX = nil
	self.endY = nil
	self.searchInProgress = false
end

function pathfinderThread:initGrid(data)
	self.grid = obstructionGrid.new(data.gridWidth, data.gridHeight, data.floors, nil, tileGrid.CUSTOM_STRUCTURES.FLOOR_STRUCTURE, data.pointers)
	self.gridW, self.gridH = data.gridWidth, data.gridHeight
	
	if not self.pathfinder then
		self:createPathfinder(data.gridWidth, data.gridHeight)
	else
		self.pathfinder:setGridBoundaries(data.gridWidth, data.gridHeight)
	end
	
	local mapData = bitser.loads(data.mapData)
	
	self.obstructionTiles = {}
	
	for i = 1, data.floors do
		local deserialised = bitser.loads(data.tiles[i])
		
		self.obstructionTiles[i] = deserialised.objectObstruction
		
		if i == 1 then
			self:applyOwnedTiles(deserialised.tiles)
		end
	end
end

function pathfinderThread:applyOwnedTiles(tileList)
	self.ownedTiles = self.ownedTiles or {}
	
	for key, tileData in ipairs(tileList) do
		self.ownedTiles[tileData.index] = true
	end
end

function pathfinderThread:updateGrid(data)
	local tileData = bitser.loads(data)
	
	if tileData.tiles then
		self:applyOwnedTiles(tileData.tiles)
	end
	
	local target = self.obstructionTiles[tileData.floor]
	
	for tileIndex, obstructed in pairs(tileData.objectObstruction) do
		if obstructed then
			target[tileIndex] = true
		else
			target[tileIndex] = nil
		end
	end
end

function pathfinderThread:addToChannelQueue(type, data)
	table.insert(self.channelQueue, {
		type = type,
		data = data
	})
end

function pathfinderThread:update()
	if self.searchInProgress then
		if self.pathfinder:hasSucceeded() then
			local result = self.pathfinder:getResult()
			
			self:clearSearchVariables()
			self:sendOut(pathfinderThread.MESSAGE_TYPE.PATH_FOUND, bitser.dumps(result))
		elseif self.pathfinder:hasFailed() then
			self:clearSearchVariables()
			self:sendOut(pathfinderThread.MESSAGE_TYPE.PATH_FIND_FAILED, nil)
		end
	else
		local data = self.inChannel:demand()
		
		if data then
			if data.type == pathfinderThread.MESSAGE_TYPE.GRID then
				self:initGrid(data.payload)
				collectgarbage("collect")
				collectgarbage("collect")
			elseif data.type == pathfinderThread.MESSAGE_TYPE.FIND_PATH then
				self:setSearchPath(data.payload)
			elseif data.type == pathfinderThread.MESSAGE_TYPE.GRID_UPDATE then
				self:updateGrid(data.payload)
			elseif data.type == pathfinderThread.MESSAGE_TYPE.ABORT then
				self:abortSearch()
			elseif data.type == pathfinderThread.MESSAGE_TYPE.STOP then
				self.STOPPED = true
			elseif data.type == pathfinderThread.MESSAGE_TYPE.CLEAR_GRID and self.grid then
				self.grid:remove()
				
				self.grid = nil
			end
		end
	end
end
