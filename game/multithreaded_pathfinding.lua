require("game/pathfinder_thread")

local ffi = require("ffi")

game.MAX_PATHFINDER_THREADS = math.min(love.system.getProcessorCount(), 16)

function game.initPathfinderThreads()
	if game.pathfinderThreads then
		return 
	end
	
	game.pathfinderThreads = {}
	
	for i = 1, game.MAX_PATHFINDER_THREADS do
		local thread = pathfinderThread.new()
		
		thread:setup(i)
		table.insert(game.pathfinderThreads, thread)
	end
end

function game.destroyPathfinderThreads()
	if game.pathfinderThreads then
		for key, threadObj in ipairs(game.pathfinderThreads) do
			threadObj:remove()
			
			game.pathfinderThreads[key] = nil
		end
		
		game.pathfinderThreads = nil
	end
end

local bitser = require("engine/bitser")

function game.sendWholeGridToPathfinderThreads()
	local grid = game.worldObject:getFloorTileGrid()
	local tileList = {}
	
	for key, buildingObject in ipairs(game.worldObject:getBuildings()) do
		for index, state in pairs(buildingObject:getTileIndexes()) do
			tileList[#tileList + 1] = index
		end
	end
	
	local fCount = game.worldObject:getFloorCount()
	local tiles = {}
	local savedResults = {
		floors = fCount,
		tiles = tiles,
		gridWidth = grid.gridWidth,
		gridHeight = grid.gridHeight,
		mapData = bitser.dumps(game.worldObject:getDecompressedMapData()),
		pointers = {}
	}
	
	for i = 1, fCount do
		tiles[#tiles + 1] = obstructionGrid:save(grid, tileList, i)
		savedResults.pointers[i] = tonumber(ffi.cast(ffi.typeof("uintptr_t"), grid.tiles[i]))
	end
	
	savedResults.mapData = game.worldObject:getDecompressedMapData()
	
	for key, threadObj in ipairs(game.pathfinderThreads) do
		threadObj:sendInWait(pathfinderThread.MESSAGE_TYPE.GRID, savedResults)
	end
	
	savedResults.mapData = nil
	
	lightingManager:sendInLoadWait(pathfinderThread.MESSAGE_TYPE.GRID, savedResults)
	lightingManager:sendInWait(pathfinderThread.MESSAGE_TYPE.GRID, savedResults)
end

function game.getFreePathfinder()
	for key, threadObj in ipairs(game.pathfinderThreads) do
		if not threadObj:isBusy() then
			return threadObj, key
		end
	end
end

local bitser = require("engine/bitser")

game.pathDumpTable = {}

function game.searchThreadedPath(startX, startY, endX, endY, floor, ignoreTiles)
	local threadObj, key = game.getFreePathfinder()
	
	if threadObj then
		local tbl = game.pathDumpTable
		
		tbl.startX = startX
		tbl.startY = startY
		tbl.endX = endX
		tbl.endY = endY
		tbl.ignoreTiles = ignoreTiles
		tbl.floor = floor
		
		threadObj:startPathfinding(floor, bitser.dumps(tbl))
		
		return threadObj
	end
	
	return nil
end

function game.sendToPathfinderThreads(messageType, payload)
	for key, threadObj in ipairs(game.pathfinderThreads) do
		threadObj:sendIn(messageType, payload)
	end
end

function game.sendGridUpdateToLightingComputeThread(gridObject, messageType, startX, startY, endX, endY, floor, skipExpansion)
	local savedPayload = obstructionGrid.prepareSendData(gridObject, startX, startY, endX, endY, floor, skipExpansion)
	
	lightingManager:sendInLoad(messageType, savedPayload)
	lightingManager:sendIn(messageType, savedPayload)
end

function game.sendGridUpdateToThreads(gridObject, messageType, startX, startY, endX, endY, floor, skipExpansion)
	if not game.canSendGridUpdateToThreads then
		return 
	end
	
	local savedPayload = obstructionGrid.prepareSendData(gridObject, startX, startY, endX, endY, floor, skipExpansion)
	
	game._sendGridUpdateToThreads(messageType, savedPayload)
end

function game.sendGridIndexUpdateToThreads(gridObject, messageType, indexList, floor)
	if not game.canSendGridUpdateToThreads then
		return 
	end
	
	local result = obstructionGrid.prepareSendIndexes(gridObject, indexList, floor)
	
	game._sendGridUpdateToThreads(messageType, result)
end

function game._sendGridUpdateToThreads(messageType, savedPayload)
	for key, threadObj in ipairs(game.pathfinderThreads) do
		threadObj:sendIn(messageType, savedPayload)
	end
end
