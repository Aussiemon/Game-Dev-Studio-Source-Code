obstructionGrid = {}
obstructionGrid.mtindex = {
	__index = obstructionGrid
}

setmetatable(obstructionGrid, floorTileGrid.mtindex)

function obstructionGrid.new(...)
	local new = {}
	
	setmetatable(new, obstructionGrid.mtindex)
	new:init(...)
	
	return new
end

local bitser = require("engine/bitser")

function obstructionGrid:save(gridObj, tiles, floorID, skipMiscData)
	local final = {}
	local result = floorTileGrid.save(gridObj, tiles, floorID)
	
	final.tiles = result
	final.objectObstruction = {}
	
	local grid = game.worldObject:getObjectGrid()
	
	self:prepareObjectList(final.objectObstruction, grid, studio:getOwnedObjects(), floorID)
	
	return bitser.dumps(final)
end

function obstructionGrid:prepareObjects(objectList)
	local final = {}
	
	final.objectObstruction = {}
	
	self:prepareObjectList(final.objectObstruction, game.worldObject:getObjectGrid(), objectList)
	
	return bitser.dumps(final)
end

function obstructionGrid:prepareObjectList(destination, grid, list, floor)
	for key, object in ipairs(list) do
		if object:isFloorValid(floor) and object:getPreventsMovement() then
			local x, y, w, h = object:getUsedTiles()
			
			for Y = y, h do
				for X = x, w do
					destination[grid:getTileIndex(X, Y)] = true
				end
			end
		end
	end
end

local updateTable = {
	tiles = {},
	objectObstruction = {}
}

function obstructionGrid:prepareSendData(startX, startY, endX, endY, floor, skipExpansion)
	if not game.canSendGridUpdateToThreads then
		return false
	end
	
	local ownedTiles = studio:getBoughtTiles()
	
	if not skipExpansion then
		startX = startX - 1
		endX = endX + 1
		startY = startY - 1
		endY = endY + 1
	end
	
	local grid = game.worldObject:getObjectGrid()
	
	for x = startX, endX do
		for y = startY, endY do
			local index = self:getTileIndex(x, y)
			
			if ownedTiles[index] then
				updateTable.tiles[#updateTable.tiles + 1] = self:saveTile(index, floor)
				
				local objects = grid:getObjects(x, y, floor)
				
				if objects then
					local obstruction = false
					
					for key, object in ipairs(objects) do
						if object:getPreventsMovement() then
							obstruction = true
							
							break
						end
					end
					
					updateTable.objectObstruction[index] = obstruction
				end
			end
		end
	end
	
	updateTable.floor = floor
	
	local result = bitser.dumps(updateTable)
	
	table.clearArray(updateTable.tiles)
	table.clear(updateTable.objectObstruction)
	
	return result
end

function obstructionGrid:prepareSendIndexes(indexList, floor)
	if not game.canSendGridUpdateToThreads then
		return false
	end
	
	local ownedTiles = studio:getBoughtTiles()
	local grid = game.worldObject:getObjectGrid()
	
	for key, index in ipairs(indexList) do
		if ownedTiles[index] then
			updateTable.tiles[#updateTable.tiles + 1] = self:saveTile(index, floor)
			
			local objects = grid:getObjectsFromIndex(index, floor)
			
			if objects then
				local obstruction = false
				
				for key, object in ipairs(objects) do
					if object:getPreventsMovement() then
						obstruction = true
						
						break
					end
				end
				
				updateTable.objectObstruction[index] = obstruction
			end
		end
	end
	
	updateTable.floor = floor
	
	local result = bitser.dumps(updateTable)
	
	table.clearArray(updateTable.tiles)
	table.clear(updateTable.objectObstruction)
	
	return result
end

function obstructionGrid:sendTileUpdate(startX, startY, endX, endY, floor, skipExpansion)
	if not game.canSendGridUpdateToThreads then
		return false
	end
	
	local ownedTiles = studio:getBoughtTiles()
	
	if not skipExpansion then
		startX = startX - 1
		endX = endX + 1
		startY = startY - 1
		endY = endY + 1
	end
	
	local grid = game.worldObject:getObjectGrid()
	
	for x = startX, endX do
		for y = startY, endY do
			local index = self:getTileIndex(x, y)
			
			if ownedTiles[index] then
				updateTable.tiles[#updateTable.tiles + 1] = self:saveTile(index, floor)
				
				local objects = grid:getObjects(x, y, floor)
				
				if objects then
					local obstruction = false
					
					for key, object in ipairs(objects) do
						if object:getPreventsMovement() then
							obstruction = true
							
							break
						end
					end
					
					updateTable.objectObstruction[index] = obstruction
				end
			end
		end
	end
	
	local result = bitser.dumps(updateTable)
	
	table.clearArray(updateTable.tiles)
	table.clear(updateTable.objectObstruction)
	game.sendGridUpdateToThreads(pathfinderThread.MESSAGE_TYPE.GRID_UPDATE, result)
end

function obstructionGrid:updateAdjacentWallSprites(index)
end
