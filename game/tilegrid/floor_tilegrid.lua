floorTileGrid = {}
floorTileGrid.mtindex = {
	__index = floorTileGrid
}
floorTileGrid.WALL_ID_ITERATION_RANGE = {
	0,
	3
}

setmetatable(floorTileGrid, tileGrid.mtindex)

local ffi = require("ffi")

floorTileGrid.uintptr_t = ffi.typeof("uintptr_t")

function floorTileGrid.new(xSize, ySize, floors, dataTypeEnum, dataType, pointers)
	local new = {}
	
	setmetatable(new, floorTileGrid.mtindex)
	new:init(xSize, ySize, floors, dataTypeEnum, dataType, pointers)
	
	return new
end

function floorTileGrid:init(xSize, ySize, floors, dataTypeEnum, dataType, pointers)
	self.floorCount = floors
	self.tilePointers = pointers
	
	tileGrid.init(self, xSize, ySize, dataTypeEnum, dataType)
end

function floorTileGrid:setTileValue(index, floorID, value)
	self.tiles[floorID][index].id = value
	
	self:onTileValueChanged(index, floorID)
end

function floorTileGrid:isTileEmpty(index, floorID)
	return self.tiles[floorID][index].id == 0
end

function floorTileGrid:getTileID(index, floorID)
	return tonumber(self.tiles[floorID][index].id)
end

function floorTileGrid:getTileFromIndex(index, floorID)
	return self.tiles[floorID][index]
end

floorTileGrid.getTileValue = floorTileGrid.getTileID

function floorTileGrid:_initGrid(sizeX, sizeY, dataType, dataStructType)
	self.tiles = {}
	
	for i = 1, self.floorCount do
		if self.tilePointers then
			local ptr = ffi.cast(self.uintptr_t, self.tilePointers[i])
			
			self.tiles[i] = ffi.cast(dataType.ctype, ffi.cast(dataType.ctype, self.tilePointers[i]))
		else
			local cStruct = ffi.new(dataStructType, (sizeX + 2) * (sizeY + 2))
			
			self.tiles[i] = cStruct
			
			if dataType and dataType.vars then
				for varType, value in pairs(dataType.vars) do
					for y = 0, sizeY do
						for x = 0, sizeX do
							if type(value) == "table" then
								local index = self:getTileIndex(x, y)
								local data = cStruct[index]
								
								for i = 0, value.length do
									data[varType][i] = value.value
								end
							else
								local index = self:getTileIndex(x, y)
								local data = cStruct[index]
								
								data[varType] = value
							end
						end
					end
				end
			else
				for y = 0, sizeY do
					for x = 0, sizeX do
						local index = self:getTileIndex(x, y)
						
						cStruct[index] = 0
					end
				end
			end
		end
	end
end

function floorTileGrid:setWallID(index, floorID, wallID, rotation)
	self.tiles[floorID][index].wallIDs[walls.ROTATION_TO_ID[rotation]] = wallID
end

function floorTileGrid:insertWall(index, floorID, wallID, rotation)
	self:setWallID(index, floorID, wallID, rotation)
	self:addWall(index, floorID, rotation)
	self:postSetWallID(index, floorID, wallID, rotation)
end

function floorTileGrid:getWallID(index, floorID, rotation)
	return tonumber(self.tiles[floorID][index].wallIDs[walls.ROTATION_TO_ID[rotation]])
end

function floorTileGrid:getWallIDs(index, floorID)
	return self.tiles[floorID][index].wallIDs
end

function floorTileGrid:isEmpty(index, floorID)
	return self.tiles[floorID][index].id == 0
end

function floorTileGrid:canAddWall(index, floorID, rotation, newWallID)
	local x, y = self:convertIndexToCoordinates(index)
	
	newWallID = newWallID or 0
	
	if self:outOfBounds(x, y) or self:isEmpty(index, floorID) then
		return false
	end
	
	if self:hasWall(index, floorID, rotation) and self.tiles[floorID][index].wallIDs[walls.ROTATION_TO_ID[rotation]] == newWallID then
		return false
	end
	
	return true
end

function floorTileGrid:enterExpansionMode()
	self.renderer:enterExpansionMode()
end

function floorTileGrid:leaveExpansionMode()
	self.renderer:leaveExpansionMode()
end

function floorTileGrid:hasAnyWall(index, floorID)
	return self.tiles[floorID][index].adjacentWalls ~= 0
end

function floorTileGrid:hasWall(index, floorID, wall)
	if self:outOfBounds(self:convertIndexToCoordinates(index)) then
		return false
	end
	
	return bit.band(tonumber(self.tiles[floorID][index].adjacentWalls), wall) == wall
end

function floorTileGrid:hasWallBit(index, floorID, wall)
	if self:outOfBounds(self:convertIndexToCoordinates(index)) then
		return 0
	end
	
	return bit.band(tonumber(self.tiles[floorID][index].adjacentWalls), wall)
end

function floorTileGrid:addWall(index, floorID, wall)
	if not self:hasWall(index, floorID, wall) then
		self.tiles[floorID][index].adjacentWalls = self.tiles[floorID][index].adjacentWalls + wall
		
		self:updateAdjacentWalls(index, floorID)
		
		return true
	end
	
	return false
end

function floorTileGrid:postSetWallID(index, floorID, wallID, rotation)
	if not self.removed then
		self:updateAdjacentWallSprites(index, floorID)
	end
end

function floorTileGrid:setRenderer(renderer)
	self.renderer = renderer
end

function floorTileGrid:getRenderer()
	return self.renderer
end

function floorTileGrid:updateAdjacentWallSprites(index, floorID)
	if self.renderer then
		local x, y = self:convertIndexToCoordinates(index)
		local renderer = self.renderer
		
		for Y = y - 1, y + 1 do
			for X = x - 1, x + 1 do
				if self:canSeeTile(X, Y) then
					renderer:applyWallSprite(X, Y, self:getTileIndex(X, Y))
				end
			end
		end
	end
end

function floorTileGrid:clearWall(index, floorID)
	local tile = self.tiles[floorID][index]
	
	tile.adjacentWalls = 0
	
	for i = 0, 3 do
		tile.wallIDs[i] = 0
	end
	
	self:updateAdjacentWalls(index, floorID)
end

function floorTileGrid:replaceWall(index, floorID, newWallID, rotation)
	self:removeWall(index, floorID, rotation)
	
	if newWallID ~= 0 then
		self:insertWall(index, floorID, newWallID, rotation)
	end
end

function floorTileGrid:removeWall(index, floorID, wallRotation)
	if self.removed then
		return 
	end
	
	if self:hasWall(index, floorID, wallRotation) then
		self:setWallID(index, floorID, 0, wallRotation)
		
		local offset = walls.DIRECTION[wallRotation]
		
		self:setWallID(self:offsetIndex(index, offset[1], offset[2]), floorID, 0, walls.INVERSE_RELATION[wallRotation])
		
		self.tiles[floorID][index].adjacentWalls = self.tiles[floorID][index].adjacentWalls - wallRotation
		
		self:updateAdjacentWalls(index, floorID)
		self:updateAdjacentWallSprites(index, floorID)
	end
end

function floorTileGrid:resetWalls(index, floorID)
	self.tiles[floorID][index].adjacentWalls = 0
end

function floorTileGrid:setWallContents(index, floorID, contents)
	local x, y = self:convertIndexToCoordinates(index)
	
	for key, rotation in ipairs(walls.ORDER) do
		if bit.band(contents, rotation) == rotation and not self:hasWall(index, floorID, rotation) then
			local offset = walls.DIRECTION[rotation]
			local inverse = walls.INVERSE_RELATION[rotation]
			local curX, curY = x + offset[1], y + offset[2]
			local wallID = self:getWallID(self:getTileIndex(curX, curY), floorID, inverse)
			
			self.tiles[floorID][index].wallIDs[walls.ROTATION_TO_ID[rotation]] = wallID
		end
	end
	
	self.tiles[floorID][index].adjacentWalls = contents
end

function floorTileGrid:getWallContents(index, floorID)
	return tonumber(self.tiles[floorID][index].adjacentWalls)
end

function floorTileGrid:getWallLightPenetration(index, floorID, wallRotation)
	if self:outOfBounds(self:convertIndexToCoordinates(index)) then
		return false
	end
	
	return walls.registeredByID[self.tiles[floorID][index].wallIDs[walls.ROTATION_TO_ID[wallRotation]]].lightPenetration
end

function floorTileGrid:updateAdjacentWalls(index, floorID)
	local curX, curY = self:convertIndexToCoordinates(index)
	
	for y = curY - 1, curY + 1 do
		for x = curX - 1, curX + 1 do
			if y ~= curY or x ~= curX then
				local index = self:getTileIndex(x, y)
				local walls = self:getSurroundingWalls(index, floorID)
				
				self:setWallContents(index, floorID, walls)
			end
		end
	end
end

function floorTileGrid:getSurroundingWalls(index, floorID)
	local invRel = walls.INVERSE_RELATION
	
	return invRel[self:hasWallBit(self:offsetIndex(index, -1, 0), floorID, walls.RIGHT)] + invRel[self:hasWallBit(self:offsetIndex(index, 1, 0), floorID, walls.LEFT)] + invRel[self:hasWallBit(self:offsetIndex(index, 0, -1), floorID, walls.DOWN)] + invRel[self:hasWallBit(self:offsetIndex(index, 0, 1), floorID, walls.UP)]
end

function floorTileGrid:attemptAddCorner(destination, contents, direction, corner, x, y)
	if not self:outOfBounds(x, y) and bit.band(contents, direction) == direction then
		local offset = walls.CORNER_DIRECTION[corner]
		local index = self:getTileIndex(x + offset[1], y + offset[2])
		
		if studio:hasBoughtTile(index) then
			destination[#destination + 1] = corner
		end
	end
end

local corners = {}

function floorTileGrid:getWallCorners(wallContents, x, y, floorID)
	table.clearArray(corners)
	
	if bit.band(wallContents, walls.UP) == walls.UP then
		self:attemptAddCorner(corners, wallContents, walls.LEFT, walls.CORNER_TOP_LEFT, x, y)
		self:attemptAddCorner(corners, wallContents, walls.RIGHT, walls.CORNER_TOP_RIGHT, x, y)
	end
	
	if bit.band(wallContents, walls.DOWN) == walls.DOWN then
		self:attemptAddCorner(corners, wallContents, walls.LEFT, walls.CORNER_BOTTOM_LEFT, x, y)
		self:attemptAddCorner(corners, wallContents, walls.RIGHT, walls.CORNER_BOTTOM_RIGHT, x, y)
	end
	
	return corners
end

function floorTileGrid:fillWithTile(tileID)
	for y = 1, self.gridHeight do
		for x = 1, self.gridWidth do
			self:setTileValue(self:getTileIndex(x, y), 1, tileID)
		end
	end
end

function floorTileGrid:save(indexList, floorID)
	local final = {}
	
	for key, index in pairs(indexList) do
		final[#final + 1] = self:saveTile(index, floorID)
	end
	
	return final
end

function floorTileGrid:saveTile(index, floorID)
	local tile = self.tiles[floorID][index]
	local cur = {}
	
	cur.index = index
	cur.wallIDs = {}
	cur.id = tonumber(tile.id)
	
	for i = 0, 3 do
		cur.wallIDs[i] = tonumber(tile.wallIDs[i])
	end
	
	return cur
end

function floorTileGrid:load(data, floorID, resetAndApply)
	local idToRotation = walls.ID_TO_ROTATION
	
	if resetAndApply then
		for key, tileData in ipairs(data) do
			self:setTileValue(tileData.index, floorID, tileData.id)
			
			for i = 0, 3 do
				local sideID = tileData.wallIDs[i]
				
				self:replaceWall(tileData.index, floorID, sideID, idToRotation[i])
			end
		end
	else
		for key, tileData in ipairs(data) do
			self:setTileValue(tileData.index, floorID, tileData.id)
			
			for i = 0, 3 do
				local sideID = tileData.wallIDs[i]
				
				if sideID ~= 0 then
					self:insertWall(tileData.index, floorID, sideID, idToRotation[i])
				end
			end
		end
	end
end

require("game/tilegrid/obstruction_grid")
