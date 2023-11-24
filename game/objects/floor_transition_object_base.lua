local floorTransitionObject = {}

floorTransitionObject.class = "floor_transition_object_base"
floorTransitionObject.BASE = true
floorTransitionObject.objectType = "staircase"

function floorTransitionObject:onRemoved()
	floorTransitionObject.baseClass.onRemoved(self)
	self:killHintDescbox()
end

function floorTransitionObject:isTransitionUp()
	return self.floor == camera:getViewFloor()
end

function floorTransitionObject:resetFloorData()
	local office = self.office
	
	if office then
		office:setStaircaseUp(self.floor, nil)
		office:setStaircaseDown(self.floor + 1, nil)
		
		if self.room then
			self.room:setStaircaseUp(nil)
			studio:getRoomOfIndex(self.objectGrid:getTileIndex(self:getTransitionCoordinates()), self.floor + 1):setStaircaseDown(nil)
		end
	end
end

function floorTransitionObject:applyRoomValues()
	self.room:setStaircaseUp(self)
	
	local roomObj = studio:getRoomOfIndex(self.objectGrid:getTileIndex(self:getTransitionCoordinates()), self.floor + 1)
	
	if roomObj then
		roomObj:setStaircaseDown(self)
	end
end

function floorTransitionObject:postRegisteredRooms()
	self.office:addToFloorReevalQueue(self.floor)
end

function floorTransitionObject:onPickOtherObject()
	self:killHintDescbox()
end

function floorTransitionObject:killHintDescbox()
	if self.placeInfoDescbox then
		self.placeInfoDescbox:kill()
		
		self.placeInfoDescbox = nil
	end
	
	self._lastFloorDisplay = nil
	self._staircaseDisplay = nil
	self._floorInvalidDisplay = nil
end

function floorTransitionObject:canPlaceOnFloor(officeObject, floorID)
	if officeObject:getStaircaseUp(floorID) then
		return false
	end
	
	return true
end

function floorTransitionObject:canPlace(startX, startY, endX, endY)
	local officeObj = studio:getOfficeBuildingMap():getTileBuilding(self.objectGrid:getTileIndex(startX, startY))
	
	if officeObj and not self:canPlaceOnFloor(officeObj, self.floor) then
		return false
	end
	
	return true
end

function floorTransitionObject:postDrawExpansion(startX, startY, endX, endY)
	local officeObj = studio:getOfficeBuildingMap():getTileBuilding(self.objectGrid:getTileIndex(startX, startY))
	local valid = false
	
	if self.invalidFloorPlacement then
		if not self._floorInvalidDisplay then
			if self.floor > self.invalidFloorPlacement then
				self._floorInvalidDisplay = self:_displayInvalidText(_T("STAIRCASE_INVALID_FLOOR_ABOVE", "Something is preventing placement on the floor below."))
			else
				self._floorInvalidDisplay = self:_displayInvalidText(_T("STAIRCASE_INVALID_FLOOR_BELOW", "Something is preventing placement on the floor above."))
			end
		end
		
		valid = true
	elseif self._floorInvalidDisplay then
		self.placeInfoDescbox:removeText(self._floorInvalidDisplay)
		
		self._floorInvalidDisplay = nil
	end
	
	if officeObj then
		if officeObj:getPurchasedFloors() <= self.floor then
			if not self._lastFloorDisplay then
				self._lastFloorDisplay = self:_displayInvalidText(_T("STAIRCASE_LAST_FLOOR", "This is the last office floor."))
			end
			
			valid = true
		elseif self._lastFloorDisplay then
			self.placeInfoDescbox:removeText(self._lastFloorDisplay)
			
			self._lastFloorDisplay = nil
		end
		
		if not self:canPlaceOnFloor(officeObj, self.floor) then
			if not self._staircaseDisplay then
				self._staircaseDisplay = self:_displayInvalidText(_T("FLOOR_ALREADY_HAS_STAIRCASE", "This floor already has a staircase leading up."))
			end
			
			valid = true
		elseif self._staircaseDisplay then
			self.placeInfoDescbox:removeText(self._staircaseDisplay)
			
			self._staircaseDisplay = nil
		end
	end
	
	if not valid then
		self:killHintDescbox()
	elseif self.placeInfoDescbox then
		local wX, wY = self.objectGrid:gridToWorld(endX, startY)
		
		self.placeInfoDescbox:setPos(camera:convertToScreen(wX, wY))
	end
end

function floorTransitionObject:_displayInvalidText(text)
	if not self.placeInfoDescbox then
		local db = gui.create("GenericDescbox")
		
		db:setBackgroundColor(color(0, 0, 0, 200))
		
		self.placeInfoDescbox = db
	else
		self.placeInfoDescbox:removeAllText()
	end
	
	local res, idx
	
	self.placeInfoDescbox:addText(text, "bh18", nil, 0, 300, "exclamation_point_red", 22, 22)
	
	return res
end

function floorTransitionObject:getTextureQuad()
	if camera:getViewFloor() ~= self.floor then
		return self.spriteDown
	end
	
	return self.spriteUp
end

function floorTransitionObject:finalizeGridPlacement(...)
	floorTransitionObject.baseClass.finalizeGridPlacement(self, ...)
	self:killHintDescbox()
	
	local entranceX, entranceY = self:getEntranceInteractionCoordinates()
	local entranceIdx = self.objectGrid:getTileIndex(entranceX, entranceY)
	local dir = walls.DIRECTION[self.rotation]
	local entraceIdxOffset = self.objectGrid:offsetIndex(entranceIdx, dir[1], dir[2])
	local finalIdx = self.objectGrid:getTileIndex(self:getTransitionCoordinates())
	
	self.walkUpPath = {
		entraceIdxOffset,
		finalIdx
	}
	self.walkDownPath = {
		finalIdx,
		entraceIdxOffset
	}
	
	local office = self.office
	
	office:setStaircaseUp(self.floor, self)
	office:setStaircaseDown(self.floor + 1, self)
end

function floorTransitionObject:_removeFromGrid(tileX, tileY, w, h)
	local grid = self.objectGrid
	local floor = self.floor
	local building = self.office
	
	if building then
		local removeNextFloor = building:getFloorCount() >= floor + 1
		
		if removeNextFloor then
			self.office:addToFloorReevalQueue(floor)
			
			for y = tileY, tileY + h do
				for x = tileX, tileX + w do
					grid:removeObject(x, y, self)
					grid:removeObject(x, y, self, floor + 1)
				end
			end
		else
			for y = tileY, tileY + h do
				for x = tileX, tileX + w do
					grid:removeObject(x, y, self)
				end
			end
		end
	end
end

function floorTransitionObject:removeFromRoom()
	self:resetFloorData()
	
	local office, floor, index = self:getRemovalData()
	
	self:_removeFromRoom(floor, index)
	
	if self:hasNextFloor() then
		self:_removeFromRoom(floor + 1, index)
	end
end

function floorTransitionObject:removeFromFloors()
	local officeObject, floor, index = self:getRemovalData()
	local floorObjList = officeObject:getObjectsByFloorObject()
	
	table.removeObject(floorObjList[floor], self)
	
	if self:hasNextFloor() then
		table.removeObject(floorObjList[floor + 1], self)
	end
	
	return floor
end

function floorTransitionObject:getFloorCheckRange(floor)
	return floor, math.min(game.worldObject:getFloorCount(), floor + 1)
end

function floorTransitionObject:insertToObjectGrid()
	self:_insertToObjectGrid(self.gridStartX, self.gridStartY, self.gridEndX, self.gridEndY, self.floor)
	
	local building = studio:getOfficeBuildingMap():getTileBuilding(self.objectGrid:getTileIndex(self.gridStartX, self.gridStartY))
	
	if building:getFloorCount() >= self.floor + 1 then
		self:_insertToObjectGrid(self.gridStartX, self.gridStartY, self.gridEndX, self.gridEndY, self.floor + 1)
	end
end

function floorTransitionObject:sendGridUpdateToThreads()
	local x, y, w, h, floor = self.gridStartX, self.gridStartY, self.gridEndX, self.gridEndY, self.floor
	local grid, msg = game.worldObject:getFloorTileGrid(), pathfinderThread.MESSAGE_TYPE.GRID_UPDATE
	
	game.sendGridUpdateToThreads(grid, msg, x, y, w, h, floor, true)
	
	if self:hasNextFloor() then
		game.sendGridUpdateToThreads(grid, msg, x, y, w, h, floor + 1, true)
	end
end

function floorTransitionObject:getTransitionCoordinates()
	local x, y = self:getTileCoordinates()
	local rot = self.rotation
	local offset = walls.DIRECTION[rot]
	local w, h = self.tileWidth - 1, self.tileHeight - 1
	
	if rot == walls.UP then
		return x, y
	end
	
	return x + offset[1] * w, y + offset[2] * h
end

function floorTransitionObject:isFloorValid(floor)
	local ourFloor = self.floor
	
	return ourFloor == floor or ourFloor + 1 == floor
end

function floorTransitionObject:cycleRotation(reverse)
	if self.rotation == walls.UP then
		self:setRotation(walls.DOWN)
	else
		self:setRotation(walls.UP)
	end
end

function floorTransitionObject:selectForPurchase()
	studio.expansion:setRotation(walls.UP)
end

function floorTransitionObject:getPathUp()
	return self.walkUpPath
end

function floorTransitionObject:getPathDown()
	return self.walkDownPath
end

function floorTransitionObject:canPlace(startX, startY, endX, endY, invalidTiles)
	local office = studio:getOfficeBuildingMap():getTileBuilding(game.worldObject:getFloorTileGrid():getTileIndex(startX, startY))
	
	if office then
		local floors = office:getPurchasedFloors()
		
		return floors > self.floor and not office:getStaircaseUp(self.floor)
	end
	
	return false
end

objects.registerNew(floorTransitionObject, "static_object_base")
