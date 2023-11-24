local door = {}

door.class = "door_object_base"
door.objectType = "door"
door.wallID = 1000
door.lightPassWallID = 1004
door.animateOnFacing = false
door.BASE = true
door.DOOR = true

function door:canPlace(startX, startY, endX, endY)
	local rotation = self.rotation
	local tileGrid = game.worldObject:getFloorTileGrid()
	local index = tileGrid:getTileIndex(startX, startY)
	local leftDirection = walls.DIRECTION[walls.LEFT_SIDE[rotation]]
	local leftIndex = tileGrid:getTileIndex(startX + leftDirection[1], startY + leftDirection[2])
	local floor = self.floor
	local leftWall = tileGrid:hasWall(leftIndex, floor, rotation)
	
	if not leftWall and not tileGrid:hasWall(index, floor, walls.LEFT_SIDE[rotation]) then
		return false
	end
	
	local rightDirection = walls.DIRECTION[walls.RIGHT_SIDE[rotation]]
	local rightIndex = tileGrid:getTileIndex(startX + rightDirection[1], startY + rightDirection[2])
	local rightWall = tileGrid:hasWall(rightIndex, floor, rotation)
	
	if not rightWall and not tileGrid:hasWall(index, floor, walls.RIGHT_SIDE[rotation]) then
		return false
	end
	
	local direction = walls.DIRECTION[rotation]
	local finalX, finalY = startX + direction[1], startY + direction[2]
	
	if not studio:hasBoughtTile(tileGrid:getTileIndex(finalX, finalY)) or not self:isTileFree(finalX, finalY, floor) then
		return false
	end
	
	return true
end

function door:isTileFree(x, y, floorID)
	local objects = self.objectGrid:getObjects(x, y, floorID)
	local ourRot = self.rotation
	
	if objects then
		for key, object in ipairs(objects) do
			if object:getEnclosesTile() or object:getPreventsMovement() then
				return false
			elseif object:getRequiresWallInFront() then
				local rot = object:getRotation()
				
				if rot == walls.INVERSE_RELATION[ourRot] then
					return false
				end
			end
		end
	end
	
	return true
end

function door:shouldIgnoreRoomChecking(checkedBy)
	return true
end

function door:canInteractWithExpansion()
	return self:getFact(game.MAIN_DOOR_FACT) == nil
end

function door:canSell()
	return self:getFact(game.MAIN_DOOR_FACT) == nil
end

function door:canMove()
	return self:getFact(game.MAIN_DOOR_FACT) == nil
end

function door:getFacingAngles()
	return walls.RAW_ANGLES[self.rotation] - 90
end

function door:onBeginMoving()
	local tileGrid = game.worldObject:getFloorTileGrid()
	
	tileGrid:removeWall(tileGrid:getTileIndex(self:getTileCoordinates()), self.floor, self.rotation)
end

function door:onRemoved()
	self:removeWall()
	door.baseClass.onRemoved(self)
end

function door:finalizeGridPlacement(baseX, baseY, noOffset)
	door.baseClass.finalizeGridPlacement(self, baseX, baseY, noOffset)
	self:insertWall()
end

function door:replaceWall()
	local tileGrid = game.worldObject:getFloorTileGrid()
	
	tileGrid:replaceWall(tileGrid:getTileIndex(self:getTileCoordinates()), self.floor, self.lightPassWallID, self.rotation)
end

function door:insertWall()
	local tileGrid = game.worldObject:getFloorTileGrid()
	
	tileGrid:replaceWall(tileGrid:getTileIndex(self:getTileCoordinates()), self.floor, self.wallID, self.rotation)
end

function door:removeWall()
	if not self.purchaseTime then
		return 
	end
	
	local tileGrid = game.worldObject:getFloorTileGrid()
	local idx
	
	if self.moving then
		idx = tileGrid:getTileIndex(self.movedObjectX, self.movedObjectY)
	else
		idx = tileGrid:getTileIndex(self:getTileCoordinates())
	end
	
	tileGrid:removeWall(idx, self.floor, self.rotation)
end

function door:_updateThreads()
	local x, y, w, h = self:getUsedTiles()
	
	game.sendGridUpdateToThreads(game.worldObject:getFloorTileGrid(), pathfinderThread.MESSAGE_TYPE.GRID_UPDATE, x, y, w, h, self.floor, true)
end

objects.registerNew(door, "static_object_base")
