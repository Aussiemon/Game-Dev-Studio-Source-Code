local conferenceBase = {}

conferenceBase.class = "conference_object_base"
conferenceBase.preventsMovement = true
conferenceBase.requiresEntrance = false
conferenceBase.surroundingWidth = 1
conferenceBase.surroundingHeight = 1
conferenceBase.surroundingChairs = 1
conferenceBase.BASE = true
conferenceBase.FLIP_ITERATION_RANGE = {
	[walls.LEFT] = true,
	[walls.RIGHT] = true
}

function conferenceBase:init()
	conferenceBase.baseClass.init(self)
	
	self.chairs = {}
	self.tiles = {}
end

function conferenceBase:isValidRoom()
	local result = conferenceBase.baseClass.isValidRoom(self)
	
	self.enoughRoomSpace = self:checkRoomSpace()
	self.enoughChairs = self:checkNearbyChairs()
	
	if not self.enoughRoomSpace then
		table.insert(self.incompatibilityFactors, {
			type = conferenceBase.INCOMPATIBILITY_TYPES.NOT_ENOUGH_ROOM
		})
	end
	
	return result and self.enoughRoomSpace and self.enoughChairs
end

function conferenceBase:beginMotivationalSpeechCallback()
	motivationalSpeeches:start(self.developer)
end

function conferenceBase:fillInteractionComboBox(combobox)
	if motivationalSpeeches:canStart(self, nil) then
		combobox:addOption(0, 0, 0, 24, _T("START_MOTIVATIONAL_SPEECH", "Start motivational speech"), fonts.get("pix20"), conferenceBase.beginMotivationalSpeechCallback).developer = self
	end
end

function conferenceBase:handleIncompatibilityData(data)
	if data.type == conferenceBase.INCOMPATIBILITY_TYPES.NOT_ENOUGH_ROOM then
		return _T("NOT_ENOUGH_ROOM_FOR_CONFERENCE_TABLE", "There isn't enough room around the conference table")
	elseif data.type == conferenceBase.INCOMPATIBILITY_TYPES.NOT_ENOUGH_CHAIRS then
		local missing = data.current
		
		if missing == 1 then
			return _T("MISSING_CHAIR_FOR_CONFERENCE_TABLE", "The table needs to have 1 more chair surrounding it.")
		end
		
		return string.easyformatbykeys(_T("NOT_ENOUGH_CHAIRS_FOR_CONFERENCE_TABLE", "The table needs to have AMOUNT more chairs surrounding it."), "AMOUNT", missing)
	end
	
	return conferenceBase.baseClass.handleIncompatibilityData(self, data)
end

function conferenceBase:checkRoomSpace()
	local iterW, iterH = self.surroundingWidth, self.surroundingHeight
	local rotation = self:getRotation()
	local objectGrid = game.worldObject:getObjectGrid()
	
	if conferenceBase.FLIP_ITERATION_RANGE[rotation] then
		iterW, iterH = iterH, iterW
	end
	
	local tileW, tileH = self:getPlacementIterationRange()
	local tileX, tileY = self:getTileCoordinates()
	local grid = game.worldObject:getFloorTileGrid()
	
	for y = tileY - iterH, tileY + tileH + iterH do
		for x = tileX - iterW, tileX + tileW + iterW do
			local index = grid:getTileIndex(x, y)
			
			if not studio:hasBoughtTile(index) then
				return false
			end
			
			for key, wallID in pairs(walls.ORDER) do
				if grid:hasWall(index, self.floor, wallID) then
					return false
				end
			end
			
			if objectGrid:getObjectCount(x, y, self.floor) == 0 then
				self.tiles[#self.tiles + 1] = index
			end
		end
	end
	
	return true
end

local foundObjects = {}

function conferenceBase:checkNearbyChairs()
	local tileW, tileH = self:getPlacementIterationRange()
	local tileX, tileY = self:getTileCoordinates()
	local objectGrid = game.worldObject:getObjectGrid()
	
	for y = tileY - 1, tileY + tileH + 1 do
		for x = tileX - 1, tileX + tileW + 1 do
			local objects = objectGrid:getObjects(x, y, self.floor)
			
			if objects then
				for key, object in ipairs(objects) do
					if object:getObjectType() == "chair" then
						foundObjects[object] = true
					end
				end
			end
		end
	end
	
	table.clear(self.chairs)
	
	local validChairs = 0
	
	for chair, state in pairs(foundObjects) do
		local x, y, w, h = chair:getUsedTiles()
		local direction = walls.DIRECTION[chair:getRotation()]
		local valid = true
		
		for Y = y, h do
			for X = x, w do
				if not objectGrid:hasObject(X + direction[1], Y + direction[2], self, self.floor) then
					valid = false
				end
			end
		end
		
		if valid then
			self.chairs[#self.chairs + 1] = chair
			validChairs = validChairs + 1
		end
	end
	
	if validChairs < self.surroundingChairs then
		table.insert(self.incompatibilityFactors, {
			type = conferenceBase.INCOMPATIBILITY_TYPES.NOT_ENOUGH_CHAIRS,
			current = self.surroundingChairs - validChairs
		})
	end
	
	table.clear(foundObjects)
	
	return validChairs >= self.surroundingChairs
end

function conferenceBase:getSurroundingChairs()
	return self.chairs
end

function conferenceBase:getSurroundingTiles()
	return self.tiles
end

local reachedTileList = {}

function conferenceBase.losIteratorCallbackDisplay(index, tileX, tileY)
	reachedTileList[index] = true
end

function conferenceBase:findUnobstructedTiles(tileX, tileY)
	local iterW, iterH = self.surroundingWidth, self.surroundingHeight
	local rotation = self:getRotation()
	
	if conferenceBase.FLIP_ITERATION_RANGE[rotation] then
		iterW, iterH = iterH, iterW
	end
	
	local tileW, tileH = self:getPlacementIterationRange()
	local grid = game.worldObject:getFloorTileGrid()
	
	for y = tileY - iterH, tileY + tileH + iterH do
		for x = tileX - iterW, tileX + tileW + iterW do
			local valid = true
			local index = grid:getTileIndex(x, y)
			
			if not studio:hasBoughtTile(index) then
				valid = false
			else
				for key, wallID in pairs(walls.ORDER) do
					if grid:hasWall(index, self.floor, wallID) then
						valid = false
						
						break
					end
				end
			end
			
			reachedTileList[index] = valid
		end
	end
end

function conferenceBase:postDrawExpansion(startX, startY, endX, endY)
	local halfW, halfH = self:getHalfSize()
	local worldX, worldY = game.worldObject:getFloorTileGrid():gridToWorld(startX, startY)
	
	self:findUnobstructedTiles(startX, startY)
	self:drawRoomSpace(worldX + halfW, worldY + halfH)
	table.clear(reachedTileList)
	conferenceBase.baseClass.postDrawExpansion(self, startX, startY, endX, endY)
end

function conferenceBase:postDraw()
	conferenceBase.baseClass.postDraw(self)
	
	if self.mouseOver and studio.expansion:isActive() then
		self:drawRoomSpace()
	end
end

function conferenceBase:drawRoomSpace(x, y)
	if not x or not y then
		x, y = self:getCenter()
	end
	
	local underColor = game.UI_COLORS.IMPORTANT_1
	local grid = game.worldObject:getFloorTileGrid()
	local w, h = grid:getTileSize()
	
	love.graphics.setColor(174, 229, 167, 150)
	
	for index, state in pairs(reachedTileList) do
		if state then
			love.graphics.setColor(174, 229, 167, 150)
		else
			love.graphics.setColor(255, 0, 0, 150)
		end
		
		local x, y = grid:indexToWorld(index)
		
		love.graphics.rectangle("fill", x - w, y - h, w, h)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
end

objects.registerNew(conferenceBase, "static_object_base")
conferenceBase:addIncompatibilityType("NOT_ENOUGH_ROOM")
conferenceBase:addIncompatibilityType("NOT_ENOUGH_CHAIRS")
