floorTileGridRenderer = {}
floorTileGridRenderer.mtindex = {
	__index = floorTileGridRenderer
}
floorTileGridRenderer.tileSpriteQuad = quadLoader:load("floor_tile", floors.atlasTexture, 0, 0, 48, 48)
floorTileGridRenderer.spriteBatchID = "floor_atlas_spritebatch"
floorTileGridRenderer.officeSpriteBatchID = "office_floor_atlas_spritebatch"
floorTileGridRenderer.wallSpriteBatchID = "wall_atlas_spritebatch"
floorTileGridRenderer.southWallSpriteBatchID = "south_wall_atlas_spritebatch"
floorTileGridRenderer.outerWallSpriteBatchID = "outer_wall_atlas_spritebatch"
floorTileGridRenderer.outerSouthernWallSpriteBatchID = "outer_southern_wall_atlas_spritebatch"
floorTileGridRenderer.wallDecalsSpriteBatchID = "wall_decals_spritebatch"
floorTileGridRenderer.depth = 1
floorTileGridRenderer.RENDER_ORDER = {
	WALL_OUTER_SOUTH = 52,
	FLOOR = 1,
	WALL_OUTER = 51,
	WALLS_DECALS = 53,
	OFFICE_FLOOR = 2,
	WALL_SOUTH = 19.5,
	WALL = 19
}
floorTileGridRenderer.CORNER_SPRITE_SLOTS = {
	[walls.UP] = {
		5,
		6
	},
	[walls.RIGHT] = {
		7,
		8
	},
	[walls.DOWN] = {
		9,
		10
	},
	[walls.LEFT] = {
		11,
		12
	}
}

function floorTileGridRenderer.new(tileGridObj, floorSBID, officeSBID, wallSBID, outerWallSBID, southernWallSBID, outerSouthernWallSBID, floorPriority, wallPriority, outerWallPriority, southernWallPriority, outerSouthernWallPriority)
	local new = {}
	
	setmetatable(new, floorTileGridRenderer.mtindex)
	new:init(tileGridObj, floorSBID, officeSBID, wallSBID, outerWallSBID, southernWallSBID, outerSouthernWallSBID, floorPriority, wallPriority, outerWallPriority, southernWallPriority, outerSouthernWallPriority)
	
	return new
end

function floorTileGridRenderer:setHandler(handler)
	self.visibilityHandler = handler
end

floorTileGridRenderer.colorLossPerWetness = 80

function floorTileGridRenderer:drawFloorCallback()
	local colorLoss = floorTileGridRenderer.colorLossPerWetness * weather:getWetness()
	
	love.graphics.setColor(255 - colorLoss, 255 - colorLoss, 255 - colorLoss, 255)
end

function floorTileGridRenderer:postDrawFloorCallback()
	love.graphics.setColor(255, 255, 255, 255)
end

function floorTileGridRenderer:init(tileGridObj, floorSBID, officeSBID, wallSBID, outerWallSBID, southernWallSBID, outerSouthernWallSBID, floorPriority, wallPriority, outerWallPriority, southernWallPriority, outerSouthernWallPriority)
	self.tileGrid = tileGridObj
	self.ownedTiles = {}
	self.wallSpriteBatchCollections = {}
	self.visibleOfficeTiles = {}
	floorPriority = floorPriority or floorTileGridRenderer.RENDER_ORDER.FLOOR
	floorSBID = floorSBID or floorTileGridRenderer.spriteBatchID
	self.mainCollection = gridSpriteBatchCollection.new()
	
	floors:initializeCollection(self.mainCollection, floorSBID, 3072, floorPriority)
	self.mainCollection:setupDrawing(floorTileGridRenderer.drawFloorCallback, floorTileGridRenderer.postDrawFloorCallback, false)
	
	self.officeCollection = gridSpriteBatchCollection.new()
	officeSBID = officeSBID or floorTileGridRenderer.officeSpriteBatchID
	
	floors:initializeCollection(self.officeCollection, officeSBID, 3072, floorPriority + 0.5)
	self.officeCollection:setupDrawing(nil, nil, false)
	
	wallPriority = wallPriority or floorTileGridRenderer.RENDER_ORDER.WALL
	southernWallPriority = southernWallPriority or floorTileGridRenderer.RENDER_ORDER.WALL_SOUTH
	outerSouthernWallPriority = outerSouthernWallPriority or floorTileGridRenderer.RENDER_ORDER.WALL_OUTER_SOUTH
	outerWallPriority = outerWallPriority or floorTileGridRenderer.RENDER_ORDER.WALL_OUTER
	wallSBID = wallSBID or floorTileGridRenderer.wallSpriteBatchID
	southernWallSBID = southernWallSBID or floorTileGridRenderer.southWallSpriteBatchID
	outerSouthernWallSBID = outerSouthernWallSBID or floorTileGridRenderer.outerSouthernWallSpriteBatchID
	outerWallSBID = outerWallSBID or floorTileGridRenderer.outerWallSpriteBatchID
	self.wallCollection = gridWallSpriteBatchCollection.new()
	
	walls:initializeCollection(self.wallCollection, wallSBID, 4096, wallPriority)
	self.wallCollection:setupDrawing(nil, nil, false)
	table.insert(self.wallSpriteBatchCollections, self.wallCollection)
	
	self.southWallCollection = gridWallSpriteBatchCollection.new()
	
	walls:initializeCollection(self.southWallCollection, southernWallSBID, 4096, southernWallPriority)
	self.southWallCollection:setupDrawing(nil, nil, false)
	table.insert(self.wallSpriteBatchCollections, self.southWallCollection)
	
	self.outerSouthWallCollection = gridWallSpriteBatchCollection.new()
	
	walls:initializeCollection(self.outerSouthWallCollection, outerSouthernWallSBID, 4096, outerSouthernWallPriority)
	self.outerSouthWallCollection:setupDrawing(nil, nil, false)
	self.outerSouthWallCollection:setupDrawing(floorTileGridRenderer.regularSouthWallDrawCallback, floorTileGridRenderer.regularSouthWallPostDrawCallback, false)
	table.insert(self.wallSpriteBatchCollections, self.outerSouthWallCollection)
	
	self.outerWallCollection = gridWallSpriteBatchCollection.new()
	
	walls:initializeCollection(self.outerWallCollection, outerWallSBID, 4096, outerWallPriority)
	self.outerWallCollection:setupDrawing(nil, nil, false)
	table.insert(self.wallSpriteBatchCollections, self.outerWallCollection)
	
	self.wallDecalCollection = gridWallSpriteBatchCollection.new()
	
	walls:initializeCollection(self.wallDecalCollection, floorTileGridRenderer.wallDecalsSpriteBatchID, 1024, outerWallPriority + 5)
	self.wallDecalCollection:setupDrawing(floorTileGridRenderer.regularSouthWallDrawCallback, floorTileGridRenderer.regularSouthWallPostDrawCallback, false)
	
	self.allocatedSprites = {}
	self.officeSprites = {}
	self.wallSpriteLists = {}
	self.wallSpriteKeys = {}
	self.officeTileMap = studio:getOfficeBuildingMap():getTileIndexes()
end

function floorTileGridRenderer:_applyFloorTiles(destination, object)
	local renderer = game.worldObject:getTileRenderer()
	local startX, startY, endX, endY = object:getGridCoords()
	local grid = self.tileGrid
	
	for y = startY, endY do
		for x = startX, endX do
			destination[grid:getTileIndex(x, y)] = object
		end
	end
end

function floorTileGridRenderer:_removeFloorTiles(destination, object)
	local renderer = game.worldObject:getTileRenderer()
	local startX, startY, endX, endY = object:getGridCoords()
	local grid = self.tileGrid
	
	for y = startY, endY do
		for x = startX, endX do
			destination[grid:getTileIndex(x, y)] = nil
		end
	end
end

function floorTileGridRenderer:setObjectGridRenderer(render)
	self.objectGridRenderer = render
end

function floorTileGridRenderer:onFloorViewChanged()
	local floor = camera:getViewFloor()
	
	self.viewFloor = floor
	self.floorBelow = floor - 1
	
	local grid = self.tileGrid
	local objRender = self.objectGridRenderer
	local floorUpdate = walls.FLOOR_WALL_UPDATE
	local officeMap = self.officeTileMap
	
	for key, obj in ipairs(studio:getOfficeBuildingMap():getVisibleBuildings()) do
		obj:updateDisplayableFloor()
		obj:updateRoofDrawState()
		
		if obj:isPlayerOwned() then
			local pFloors = obj:getPurchasedFloors()
			
			if pFloors < floor then
				obj:beginDrawingRoof()
			elseif floor <= pFloors then
				obj:stopDrawingRoof()
			end
		end
	end
	
	for key, index in ipairs(self.visibleOfficeTiles) do
		local x, y = grid:convertIndexToCoordinates(index)
		
		self:updateVisuals(x, y, index)
		objRender:onTileBecomeVisible(x, y, index)
		
		for key, data in ipairs(floorUpdate) do
			local offX, offY = data[1], data[2]
			local offIndex = grid:offsetIndex(index, offX, offY)
			
			if not officeMap[offIndex] then
				self:applyWallSprite(x + offX, y + offY, offIndex)
			end
		end
	end
end

function floorTileGridRenderer:setupOfficeData()
	self.officeTileMap = studio:getOfficeBuildingMap():getTileIndexes()
	self.ownedTiles = studio:getBoughtTiles()
end

function floorTileGridRenderer:onOfficeObjectCreated(officeObject)
end

function floorTileGridRenderer.expansionModeWallDrawCallback()
	if not studio.expansion:canPerformModeAction(studio.expansion.CONSTRUCTION_MODE.WALLS) then
		love.graphics.setColor(255, 255, 255, 125)
	end
end

function floorTileGridRenderer.expansionModeWallPostDrawCallback()
	love.graphics.setColor(255, 255, 255, 255)
end

function floorTileGridRenderer.regularSouthWallDrawCallback()
	local lightColor = timeOfDay:getLightColor()
	
	love.graphics.setColor(lightColor.r, lightColor.g, lightColor.b, 255)
end

function floorTileGridRenderer.regularSouthWallPostDrawCallback()
	love.graphics.setColor(255, 255, 255, 255)
end

function floorTileGridRenderer:enterExpansionMode()
	local expCallback = floorTileGridRenderer.expansionModeWallDrawCallback
	local expPostDraw = floorTileGridRenderer.expansionModeWallPostDrawCallback
	
	self.wallCollection:setupDrawing(expCallback, expPostDraw, false)
	self.southWallCollection:setupDrawing(expCallback, expPostDraw, false)
	self.outerSouthWallCollection:setupDrawing(expCallback, expPostDraw, false)
	self.outerWallCollection:setupDrawing(expCallback, expPostDraw, false)
end

function floorTileGridRenderer:leaveExpansionMode()
	local expCallback = floorTileGridRenderer.regularSouthWallDrawCallback
	local expPostDraw = floorTileGridRenderer.regularSouthWallPostDrawCallback
	
	self.wallCollection:setupDrawing(nil, nil, false)
	self.southWallCollection:setupDrawing(nil, nil, false)
	self.outerSouthWallCollection:setupDrawing(floorTileGridRenderer.regularSouthWallDrawCallback, floorTileGridRenderer.regularSouthWallDrawCallback, false)
	self.outerWallCollection:setupDrawing(nil, nil, false)
end

function floorTileGridRenderer:resetOuterWallDrawCallbacks()
	self.outerWallSpriteBatch:setDrawCallback(floorTileGridRenderer.regularSouthWallDrawCallback)
	self.outerWallSpriteBatch:setPostDrawCallback(floorTileGridRenderer.regularSouthWallPostDrawCallback)
	self.outerSouthernWallSpriteBatch:setDrawCallback(floorTileGridRenderer.regularSouthWallDrawCallback)
	self.outerSouthernWallSpriteBatch:setPostDrawCallback(floorTileGridRenderer.regularSouthWallPostDrawCallback)
end

function floorTileGridRenderer:getSpritebatches()
	return self.spriteBatch, self.wallSpriteBatch, self.officeSpriteBatch, self.southWallSpriteBatch, self.outerWallSpriteBatch, self.outerSouthernWallSpriteBatch, self.wallDecalsSpriteBatch
end

function floorTileGridRenderer:remove()
	self.mainCollection:remove()
	self.officeCollection:remove()
	self.wallCollection:remove()
	self.southWallCollection:remove()
	self.outerSouthWallCollection:remove()
	self.outerWallCollection:remove()
	self.wallDecalCollection:remove()
	table.clear(self.officeTileMap)
end

function floorTileGridRenderer:cacheSpriteList(spriteList)
	self.wallSpriteLists[#self.wallSpriteLists + 1] = spriteList
end

function floorTileGridRenderer:getWallSpriteList(index)
	if self.wallSpriteKeys[index] then
		return self.wallSpriteKeys[index]
	end
	
	local list = self:retrieveFreeWallSpriteList()
	
	self.wallSpriteKeys[index] = list
	
	return list
end

function floorTileGridRenderer:getSpriteContainers()
	return self.mainCollection, self.wallCollection, self.officeCollection, self.southWallCollection, self.outerWallCollection, self.outerSouthWallCollection, self.wallDecalCollection
end

function floorTileGridRenderer:retrieveFreeWallSpriteList()
	local list = self.wallSpriteLists[#self.wallSpriteLists]
	
	if list then
		table.remove(self.wallSpriteLists, #self.wallSpriteLists)
		
		return list
	end
	
	return {
		normal = {},
		southern = {},
		outer = {},
		outerSouthern = {},
		decals = {}
	}
end

function floorTileGridRenderer:getWallSpriteBatchCollections()
	return self.wallSpriteBatchCollections
end

function floorTileGridRenderer:getFloorSpriteBatchCollections()
	return self.spriteBatchCollections
end

floorTileGridRenderer.growingGrass = quadLoader:load("growing_grass")
floorTileGridRenderer.growingGrassID = quadLoader:getQuadTextureID("growing_grass")

function floorTileGridRenderer:applyWallSprite(x, y, index)
	local grid = self.tileGrid
	local indexFloor = self:_getFloor(index)
	local floor = indexFloor
	local officeTileMap = self.officeTileMap
	local outOfOffice = not officeTileMap[index]
	local tileList = grid.tiles
	local gridTiles = tileList[floor]
	local startWallContents = tonumber(gridTiles[index].adjacentWalls)
	local wallContents = startWallContents
	
	self:clearWallSprites(index)
	
	local w, h = grid:getTileSize()
	local baseX, baseY = x * w - w, y * h - h
	local rotations = walls.ROTATIONS
	local directions = walls.DIRECTION
	local rotationToID = walls.ROTATION_TO_ID
	local inverseRelation = walls.INVERSE_RELATION
	local wallsByID = walls.registeredByID
	local cornerRotations = walls.CORNER_ROTATIONS
	local diagonalEdgeOffsets = walls.DIAGONAL_EDGE_OFFSETS
	local up, down = walls.UP, walls.DOWN
	local cornerSpriteSlots = floorTileGridRenderer.CORNER_SPRITE_SLOTS
	local growingGrass = floorTileGridRenderer.growingGrass
	local growingGrassID = floorTileGridRenderer.growingGrassID
	
	if wallContents ~= 0 then
		for key, rotation in ipairs(walls.ORDER) do
			if outOfOffice then
				local dir = directions[rotation]
				local offIndex = grid:offsetIndex(index, dir[1], dir[2])
				local offOffice = officeTileMap[offIndex]
				
				if offOffice then
					floor = offOffice:getDisplayableFloor()
					
					if not floor then
						offOffice:updateDisplayableFloor()
						
						floor = offOffice:getDisplayableFloor()
					end
				else
					floor = indexFloor
				end
				
				gridTiles = tileList[floor]
				wallContents = tonumber(gridTiles[index].adjacentWalls)
			end
			
			if bit.band(wallContents, rotation) == rotation then
				local wallID = tonumber(gridTiles[index].wallIDs[rotationToID[rotation]])
				local wallData = walls:getData(wallID)
				
				if wallData and wallData.visible then
					local outerWall, southern, removeSprite = false, false, false
					local yOff = 0
					local offsetData = rotations[rotation]
					local renderX, renderY = math.round(baseX + offsetData.x), baseY + offsetData.y
					local radRotation = offsetData.rot
					local spritebatch, quad, spriteID, spriteList, textureID
					local dir = directions[rotation]
					
					if rotation == up then
						if gridTiles[grid:offsetIndex(index, dir[1], dir[2])].wallIDs[rotationToID[inverseRelation[rotation]]] == wallID then
							quad = wallData.southernQuad
							textureID = wallData.southernQuadTexID
						else
							quad = wallData.horizontalVaryingSide
							textureID = wallData.horVarTexID
							yOff = 4
						end
						
						if not officeTileMap[index] then
							spritebatch = self.outerSouthWallCollection
							outerWall = true
						else
							spritebatch = self.southWallCollection
						end
						
						southern = true
					elseif rotation == down then
						if gridTiles[grid:offsetIndex(index, dir[1], dir[2])].wallIDs[rotationToID[inverseRelation[rotation]]] == wallID then
							removeSprite = true
						else
							if not officeTileMap[index] then
								local dir = directions[rotation]
								
								spritebatch = self.outerSouthWallCollection
							else
								spritebatch = self.southWallCollection
							end
							
							quad = wallData.horizontalTopSide
							textureID = wallData.horTopTexID
						end
					elseif rotation ~= up and not officeTileMap[index] then
						quad = wallData.quad
						textureID = wallData.quadTexID
						spritebatch = self.outerWallCollection
						outerWall = true
					elseif rotation ~= down then
						quad = wallData.quad
						textureID = wallData.quadTexID
						spritebatch = self.wallCollection
					else
						quad = wallData.southernQuad
						textureID = wallData.southernQuadTexID
						spritebatch = self.southWallCollection
						southern = true
					end
					
					if not removeSprite and quad then
						spritebatch:newSprite(textureID, index, renderX, renderY + yOff, radRotation, quad, offsetData.scaleX, offsetData.scaleY, 0, 0)
					end
					
					if rotation == up and not officeTileMap[index] and not wallData.noGrass then
						self.wallDecalCollection:newSprite(growingGrassID, index, baseX + 2, baseY, radRotation, growingGrass, 1, 1, 0, 0)
					end
					
					if not wallData.noCorners then
						local validEdge, currentWallID, previousWallID = self:isEdgeValid(index, rotation)
						
						if validEdge then
							local currentWallData = wallsByID[currentWallID]
							local previousWallData = wallsByID[previousWallID]
							local edgeOffsetData = cornerRotations[rotation]
							local positionOffset = diagonalEdgeOffsets[rotation]
							local renderX, renderY = math.round(baseX + edgeOffsetData.x) + positionOffset[1] * currentWallData.cornerW * 0.5, baseY + edgeOffsetData.y + positionOffset[2] * currentWallData.cornerH * 0.5
							local spriteBatch, spriteList
							
							if outerWall then
								if southern then
									spriteBatch = self.outerSouthWallCollection
								else
									spriteBatch = self.outerWallCollection
								end
							elseif southern then
								spriteBatch = self.southWallCollection
							else
								spriteBatch = self.wallCollection
							end
							
							local spriteSlots = cornerSpriteSlots[rotation]
							
							spriteBatch:newSprite(currentWallData.southernWallCornerQuadTexID, index, renderX, renderY, 0, currentWallData.southernWallCornerQuad, 1, 1, currentWallData.cornerW * 0.5, currentWallData.cornerH * 0.5)
							
							if previousWallData.visible then
								spriteBatch:newSprite(previousWallData.southernWallCornerQuadTexID, index, renderX, renderY, 0, previousWallData.southernWallCornerQuad, 1, 1, currentWallData.cornerW * 0.5, currentWallData.cornerH * 0.5)
							end
						end
					end
				end
			end
		end
	end
end

function floorTileGridRenderer:isEdgeValid(index, rotation)
	local inverseRelation = walls.INVERSE_RELATION
	local directions = walls.DIRECTION
	local inverseStart = inverseRelation[rotation]
	local startOffset = directions[rotation]
	local prevWall = walls.LEFT_SIDE[rotation]
	local inverseEnd = inverseRelation[prevWall]
	local endOffset = directions[prevWall]
	local grid = self.tileGrid
	local offIndex1, offIndex2 = grid:offsetIndex(index, startOffset[1], startOffset[2]), grid:offsetIndex(index, endOffset[1], endOffset[2])
	local floor1, floor2 = self:_getFloor(offIndex1), self:_getFloor(offIndex2)
	local curWallID = grid:getWallID(offIndex1, floor1, inverseStart)
	local prevWallID = grid:getWallID(offIndex2, floor2, inverseEnd)
	
	if not walls.registeredByID[prevWallID].visible then
		return false
	end
	
	local diagOffset = walls.DIAGONAL_EDGE_OFFSETS[rotation]
	local tShape = false
	local offsetIndex = grid:offsetIndex(index, diagOffset[1], diagOffset[2])
	local offsetFloor = self:_getFloor(offsetIndex)
	
	for key, tShapeRotation in ipairs(walls.T_SHAPE_ROTATION[rotation]) do
		if grid:getWallID(offsetIndex, offsetFloor, tShapeRotation) ~= 0 then
			tShape = true
			
			break
		end
	end
	
	return curWallID ~= 0 and prevWallID ~= 0 and not tShape, curWallID, prevWallID
end

function floorTileGridRenderer:onObjectAdded(object)
end

function floorTileGridRenderer:onObjectRemoved(object)
end

function floorTileGridRenderer:_getFloor(index)
	if self.ownedTiles[index] then
		local office = self.officeTileMap[index]
		
		if office then
			return office:getDisplayableFloor()
		end
		
		return self.viewFloor
	end
	
	return 1
end

function floorTileGridRenderer:onTileBecomeVisible(x, y, index)
	self:applyVisuals(x, y, index)
end

function floorTileGridRenderer:_walkFloorOnSide(index, side)
	local dir = walls.DIRECTION[side]
	
	return self._floorDownTiles[self.tileGrid:offsetIndex(index, dir[1], dir[2])]
end

function floorTileGridRenderer:applyVisuals(x, y, index)
	local collection, floorData
	local w, h = self.tileGrid:getTileSize()
	local office = self.officeTileMap[index]
	
	if office then
		office:onTileBecomeVisible(index)
		
		self.visibleOfficeTiles[#self.visibleOfficeTiles + 1] = index
		floorData = floors.registeredByID[self.tileGrid:getTileValue(index, office:getDisplayableFloor())]
		collection = self.officeCollection
	else
		floorData = floors:getData(self.tileGrid:getTileFromIndex(index, self:_getFloor(index)).id)
		collection = self.mainCollection
	end
	
	if floorData then
		local renderX, renderY, rotation, halfW, halfH, quad, textureID = floorData:getRenderData(x * w, y * h)
		
		collection:applySprite(textureID, collection:getTextureID(index), index, renderX, renderY, rotation, quad, floorData.scaleX, floorData.scaleY, halfW, halfH)
		self:applyWallSprite(x, y, index)
	end
end

function floorTileGridRenderer:updateVisuals(x, y, index)
	local collection, floorData
	local w, h = self.tileGrid:getTileSize()
	local office = self.officeTileMap[index]
	
	if office then
		office:onTileBecomeVisible(index)
		
		floorData = floors.registeredByID[self.tileGrid:getTileValue(index, office:getDisplayableFloor())]
		collection = self.officeCollection
	else
		floorData = floors:getData(self.tileGrid:getTileFromIndex(index, self:_getFloor(index)).id)
		collection = self.mainCollection
	end
	
	if floorData then
		local renderX, renderY, rotation, halfW, halfH, quad, textureID = floorData:getRenderData(x * w, y * h)
		
		collection:applySprite(textureID, collection:getTextureID(index), index, renderX, renderY, rotation, quad, floorData.scaleX, floorData.scaleY, halfW, halfH)
		self:applyWallSprite(x, y, index)
	end
end

function floorTileGridRenderer:clearWallSprites(index)
	self.wallCollection:clearSprite(index)
	self.southWallCollection:clearSprite(index)
	self.outerSouthWallCollection:clearSprite(index)
	self.outerWallCollection:clearSprite(index)
	self.wallDecalCollection:clearSprite(index)
end

function floorTileGridRenderer:onTileBecomeInvisible(index)
	local office = self.officeTileMap[index]
	
	if office then
		table.removeObject(self.visibleOfficeTiles, index)
		self.officeCollection:clearSprite(index)
		office:onTileBecomeInvisible(index)
	else
		self.mainCollection:clearSprite(index)
	end
	
	self:clearWallSprites(index)
end

function floorTileGridRenderer:applySprite(x, y, spriteID, floorData, spriteBatch)
	local renderX, renderY, rotation, halfWidth, halfHeight, quad = floorData:getRenderData(x, y)
	
	spriteBatch:updateSprite(spriteID, quad, renderX, renderY, rotation, floorData.scaleX, floorData.scaleY, halfWidth, halfHeight)
end

function floorTileGridRenderer:onTileValueChanged(index)
	local x, y = self.tileGrid:convertIndexToCoordinates(index)
	local tileGrid = self.tileGrid
	
	if not tileGrid:canSeeTile(x, y) then
		return 
	end
	
	local office = self.officeTileMap[index]
	local spriteID, spriteBatch, collection, floor
	
	if office then
		collection = self.officeCollection
		floor = office:getDisplayableFloor()
	else
		collection = self.mainCollection
		floor = self:_getFloor(index)
	end
	
	local oldTextureID = collection:getTextureID(index)
	
	if oldTextureID then
		local floorData = floors:getData(self.tileGrid:getTileValue(index, floor))
		
		if floorData then
			local renderX, renderY, rotation, halfWidth, halfHeight, quad, textureID = floorData:getRenderData(x * tileGrid:getTileWidth(), y * tileGrid:getTileHeight())
			
			collection:applySprite(textureID, oldTextureID, index, renderX, renderY, rotation, quad, floorData.scaleX, floorData.scaleY, halfWidth, halfHeight)
		else
			collection:clearSprite(index)
		end
	else
		self:onTileBecomeVisible(x, y, index)
	end
end

function floorTileGridRenderer:draw()
end

function floorTileGridRenderer:postDraw()
end

require("game/tilegrid/grid_spritebatch_collection")
require("game/tilegrid/grid_wall_spritebatch_collection")
