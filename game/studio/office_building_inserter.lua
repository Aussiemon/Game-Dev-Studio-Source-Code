officeBuildingInserter = {}
officeBuildingInserter.registered = {}
officeBuildingInserter.registeredByID = {}
officeBuildingInserter.DEFAULT_FLOOR_COUNT = 3
officeBuildingInserter.DEFAULT_FLOOR_COST = 20000

function officeBuildingInserter:registerNew(data)
	table.insert(self.registered, data)
	
	self.registeredByID[data.id] = data
	data.width = 0
	data.height = 0
	data.roofTile = data.roofTile or floors:getData("roof_base")
	data.rotation = data.rotation or walls.UP
	data.floors = data.floors or officeBuildingInserter.DEFAULT_FLOOR_COUNT
	
	if not data.floorCost then
		data.floorCost = officeBuildingInserter.DEFAULT_FLOOR_COST
	end
	
	for key, tileData in ipairs(data.tiles) do
		data.width = math.max(data.width, tileData.x)
		data.height = math.max(data.height, tileData.y)
	end
end

officeBuildingInserter.OFFSET_BY_ROTATION = {
	[walls.UP] = 0,
	[walls.RIGHT] = 1,
	[walls.DOWN] = 2,
	[walls.LEFT] = 3
}

function officeBuildingInserter:rotateFloor(id, offset)
	local data = floors.registeredByID[id]
	local rotLink = data.rotationLink
	local rotLinkCount = #rotLink
	
	if rotLinkCount > 1 then
		local index = data.rotationLinkIndex
		
		while offset > 0 do
			index = index + 1
			
			if rotLinkCount < index then
				index = 1
			end
			
			offset = offset - 1
		end
		
		return floors.registeredByID[data.rotationLink[index]].id
	end
	
	return id
end

function officeBuildingInserter:adjustRotation(rotation, offset)
	if offset > 0 then
		local value = walls.ROTATION_TO_ORDER[rotation] + offset
		
		if value > walls.COUNT then
			return walls.ORDER[value % walls.COUNT]
		else
			return walls.ORDER[value]
		end
	end
	
	return rotation
end

function officeBuildingInserter:adjustPosition(baseX, baseY, offsetX, offsetY, prefabCfg)
	if prefabCfg.rotation == walls.DOWN then
		return baseX + (prefabCfg.width - offsetX), baseY + (prefabCfg.height - offsetY)
	elseif prefabCfg.rotation == walls.RIGHT then
		return baseX + (prefabCfg.height - offsetY), baseY + offsetX
	elseif prefabCfg.rotation == walls.LEFT then
		return baseX + offsetY, baseY + (prefabCfg.width - offsetX)
	end
	
	return baseX + offsetX, baseY + offsetY
end

function officeBuildingInserter:insertIntoCoordinates(buildingCfg, worldObject, gridX, gridY, rotation, playerOwned, rivalOwner, reserved, residential, grid)
	if type(buildingCfg) == "string" then
		buildingCfg = officeBuildingInserter.registeredByID[buildingCfg]
	end
	
	local officeBuildingObject = officeBuilding.new()
	
	officeBuildingObject:setID(buildingCfg.id)
	
	local indexes = {}
	local map = studio:getOfficeBuildingMap()
	
	grid = grid or worldObject:getFloorTileGrid()
	
	local roofTileIndexes = officeBuildingObject:getRoofTileIndexes()
	
	buildingCfg.rotation = rotation or walls.UP
	
	local offset = officeBuildingInserter.OFFSET_BY_ROTATION[buildingCfg.rotation]
	
	for key, tileData in ipairs(buildingCfg.tiles) do
		local curX, curY = self:adjustPosition(gridX, gridY, tileData.x, tileData.y, buildingCfg)
		local curIndex = grid:getTileIndex(curX, curY)
		
		indexes[curIndex] = true
		
		map:setTileBuilding(curIndex, officeBuildingObject)
		
		if tileData.id and tileData.id ~= 0 then
			grid:setTileValue(curIndex, 1, tileData.id)
		end
		
		if tileData.roof then
			roofTileIndexes[curIndex] = self:rotateFloor(tileData.roof, offset)
		end
		
		if tileData.walls then
			for key, wallID in ipairs(tileData.walls) do
				if wallID ~= 0 then
					local rotation = self:adjustRotation(walls.ORDER[key], offset)
					
					grid:insertWall(curIndex, 1, wallID, rotation)
				end
			end
			
			tileData.wallIndex = curIndex
		end
	end
	
	officeBuildingObject:setTileIndexes(indexes, true)
	officeBuildingObject:fillBorderWalls(grid)
	
	for key, tileData in ipairs(buildingCfg.tiles) do
		if tileData.walls then
			for key, wallID in ipairs(tileData.walls) do
				if wallID ~= 0 then
					local rotation = self:adjustRotation(walls.ORDER[key], offset)
					
					grid:insertWall(tileData.wallIndex, 1, wallID, rotation)
				end
			end
			
			tileData.wallIndex = nil
		end
	end
	
	self.gridWidth, self.gridHeight = worldObject:getObjectGrid():getTileSize()
	
	if buildingCfg.objects then
		for key, objectData in ipairs(buildingCfg.objects) do
			self:createObject(objectData, gridX, gridY, buildingCfg)
		end
	end
	
	local object = self:createObject(buildingCfg.mainDoor, gridX, gridY, buildingCfg)
	
	object:setFact(game.MAIN_DOOR_FACT, true)
	object:setFact(game.IGNORE_WALLS_FACT, true)
	
	if buildingCfg.roofObjects then
		local baseX, baseY = gridX * game.WORLD_TILE_WIDTH, gridY * game.WORLD_TILE_HEIGHT
		
		for key, objectData in ipairs(buildingCfg.roofObjects) do
			local obj = self:createRoofDecorObject(objectData, buildingCfg, baseX, baseY)
			
			officeBuildingObject:addDecorObject(obj)
		end
	end
	
	officeBuildingObject:setMainDoor(object)
	officeBuildingObject:setCanExpand(buildingCfg.expandable)
	
	if playerOwned then
		officeBuildingObject:onPurchased()
	elseif rivalOwner then
		officeBuildingObject:setRivalOwner(rivalOwner)
	elseif reserved then
		officeBuildingObject:setReserved(true)
	elseif residential then
		officeBuildingObject:setPedestrianBuilding(true)
	end
	
	worldObject:addBuilding(officeBuildingObject)
	
	buildingCfg.rotation = nil
	
	return officeBuildingObject
end

function officeBuildingInserter:createObject(objectData, gridX, gridY, buildingCfg)
	local newObj = objects.create(objectData.class)
	local rotation = self:adjustRotation(objectData.rotation, officeBuildingInserter.OFFSET_BY_ROTATION[buildingCfg.rotation])
	
	newObj:setRotation(rotation)
	
	local x, y = self:adjustPosition(gridX, gridY, objectData.x, objectData.y, buildingCfg)
	local startX, startY, endX, endY = newObj:getPlacementCoordinates(x, y, true)
	
	if buildingCfg.rotation == walls.DOWN then
		startX = startX - (newObj.tileWidth - 1)
		startY = startY - (newObj.tileHeight - 1)
	elseif buildingCfg.rotation == walls.RIGHT then
		startX = startX - (newObj.tileWidth - 1)
	elseif buildingCfg.rotation == walls.LEFT then
		startY = startY - (newObj.tileHeight - 1)
	end
	
	newObj:setPos(startX * self.gridWidth, startY * self.gridHeight)
	newObj:finalizeGridPlacement(startX, startY, 1)
	
	return newObj
end

function officeBuildingInserter:createRoofDecorObject(objectData, buildingCfg, baseX, baseY)
	local newObj = objects.create(objectData.class)
	local rotation = self:adjustRotation(objectData.rotation, officeBuildingInserter.OFFSET_BY_ROTATION[buildingCfg.rotation])
	
	newObj:setRotation(rotation)
	
	local x, y = objectData.x, objectData.y
	
	if buildingCfg.rotation == walls.DOWN then
		x, y = buildingCfg.width * game.WORLD_TILE_WIDTH - objectData.x, buildingCfg.height * game.WORLD_TILE_HEIGHT - objectData.y
	elseif buildingCfg.rotation == walls.RIGHT then
		x, y = buildingCfg.height * game.WORLD_TILE_HEIGHT - objectData.y, objectData.x
	elseif buildingCfg.rotation == walls.LEFT then
		x, y = objectData.y, buildingCfg.width * game.WORLD_TILE_WIDTH - objectData.x
	end
	
	newObj:setPos(baseX + x, baseY + y)
	game.worldObject:addDecorEntity(newObj, true)
	
	return newObj
end

require("game/buildings/offices")
require("game/buildings/residence_buildings")
require("game/buildings/back_in_the_game")
require("game/buildings/pay_denbts")
require("game/buildings/ravioli_and_pepperoni")
require("game/buildings/console_domination")
require("game/buildings/tutorial")
