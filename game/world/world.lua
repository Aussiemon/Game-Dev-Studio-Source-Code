world = {}
world.mtindex = {
	__index = world
}

function world.new(sizeX, sizeY, tileWidth, tileHeight, manualRendererInit, mapData, savedWorldData)
	local new = {}
	
	setmetatable(new, world.mtindex)
	new:init(sizeX, sizeY, tileWidth, tileHeight, manualRendererInit, mapData, savedWorldData)
	
	return new
end

function world:init(sizeX, sizeY, tileWidth, tileHeight, manualRendererInit, mapData, savedWorldData)
	self.decorationObjects = {}
	self.decorationEntities = {}
	self.drawableEntities = {}
	self.drawableEntitiesMap = {}
	self.buildingObjects = {}
	self.buildingObjectMap = {}
	self.pedestrianBuildings = {}
	self.prevCamX, self.prevCamY = 0, 0
	self.gridWidth, self.gridHeight = sizeX, sizeY
	game.WORLD_WIDTH = sizeX
	game.WORLD_HEIGHT = sizeY
	
	local floorCount = 1
	
	if mapData then
		local map = officeBuildingInserter.registeredByID
		
		for key, prefab in ipairs(mapData.prefabs) do
			local cfg = map[prefab.id]
			
			floorCount = math.max(floorCount, cfg.floors)
		end
	elseif savedWorldData then
		local map = officeBuildingInserter.registeredByID
		
		for key, data in ipairs(savedWorldData.buildings) do
			local cfg = map[data.id]
			
			floorCount = math.max(floorCount, cfg.floors)
		end
	end
	
	self.floorCount = floorCount
	self.floorTileGrid = floorTileGrid.new(sizeX, sizeY, floorCount, nil, tileGrid.CUSTOM_STRUCTURES.FLOOR_STRUCTURE)
	self.objectGrid = floorObjectGrid.new(sizeX, sizeY, floorCount)
	
	self.floorTileGrid:setOverdraw(1, 1)
	self.objectGrid:setOverdraw(1, 1)
	self.floorTileGrid:setTileSize(tileWidth, tileHeight)
	self.objectGrid:setTileSize(tileWidth, tileHeight)
	
	if not manualRendererInit then
		self:createRenderers()
	end
	
	if MAIN_THREAD then
		self.quadTrees = {}
		
		local quadW, quadH = game.WORLD_WIDTH * tileWidth + tileWidth, game.WORLD_HEIGHT * tileHeight + tileHeight
		
		self.lightQuadTree = QuadTree:new(quadW, quadH, 0, 0, true)
		self.decorQuadTree = QuadTree:new(quadW, quadH, 0, 0, true)
		self.devFloorQuadTree = floorQuadTree.new(quadW, quadH, floorCount)
		self.pedQuadTree = QuadTree:new(quadW, quadH, 0, 0, true)
	end
end

function world:addQuadTree(qt)
	table.insert(self.quadTrees, qt)
end

function world:getGridSize()
	return self.gridWidth, self.gridHeight
end

function world:getLightQuadTree()
	return self.lightQuadTree
end

function world:getDecorQuadTree()
	return self.decorQuadTree
end

function world:getDevQuadTree()
	return self.devQuadTree
end

function world:getDevFloorQuadTree()
	return self.devFloorQuadTree
end

function world:getPedestrianQuadTree()
	return self.pedQuadTree
end

function world:getFloorCount()
	return self.floorCount
end

function world:addDecorEntity(entity, entityList)
	self.decorQuadTree:insert(entity)
	
	entity.WITHINQUADTREE = true
	self.updateQuad = true
	
	if entityList then
		table.insert(self.decorationEntities, entity)
	end
end

function world:createRenderers(floorSBID, officeSBID, wallSBID, outerWallSBID, southernWallSBID, outerSouthernWallSBID, floorPriority, wallPriority)
	self.visHandler = tileGridVisibilityHandler.new(self.floorTileGrid)
	self.tileRenderer = floorTileGridRenderer.new(self.floorTileGrid, floorSBID, officeSBID, wallSBID, outerWallSBID, southernWallSBID, outerSouthernWallSBID, floorPriority, wallPriority, outerWallPriority, southernWallPriority, outerSouthernWallPriority)
	self.objectRenderer = objectGridRenderer.new(self.objectGrid)
	
	self.tileRenderer:setObjectGridRenderer(self.objectRenderer)
	self.objectGrid:setHandler(self.visHandler)
end

function world:startRenderers()
	self.visHandler:addRenderer(self.tileRenderer)
	self.visHandler:addRenderer(self.objectRenderer)
	self.floorTileGrid:setRenderer(self.tileRenderer)
	self.floorTileGrid:setHandler(self.visHandler)
end

function world:getTileRenderer()
	return self.tileRenderer
end

function world:getBuildingBoundaries()
	return self.buildingMinX, self.buildingMinY, self.buildingMaxX, self.buildingMaxY
end

function world:loadMap(mapID, mapData, decompressedMapData, skipPrefabs)
	self.mapID = mapID
	
	if not mapData then
		mapData, decompressedMapData = maps:readMap(mapID)
	end
	
	self.buildingMinX, self.buildingMinY, self.buildingMaxX, self.buildingMaxY = mapData.buildingMinX, mapData.buildingMinY, mapData.buildingMaxX, mapData.buildingMaxY
	self.decompressedMapData = decompressedMapData
	
	self.floorTileGrid:fillWithTile(mapData.baseTileType)
	
	self.pedestrianTiles = mapData.pedestrianTiles
	
	if not self.pedestrianTiles then
		print("WARNING: pedestrian tiles not found in map data!")
	end
	
	for index, value in pairs(mapData.tiles) do
		self.floorTileGrid:setTileValue(index, 1, value)
	end
	
	if not skipPrefabs then
		self:loadPrefabs(mapData)
	end
end

function world:addDecorObject(obj)
	self.decorationObjects[#self.decorationObjects + 1] = obj
end

function world:update(dt)
	if camera.x ~= self.prevCamX or camera.y ~= self.prevCamY or self.updateQuad then
		self:updateDecorQuadtree()
	end
	
	self.prevCamX, self.prevCamY = camera.x, camera.y
end

function world:executeOnDecor(object)
	if not self.drawableEntitiesMap[object] then
		self.drawableEntities[#self.drawableEntities + 1] = object
		
		object:enterVisibilityRange()
	end
	
	self.drawableEntitiesMap[object] = 1
end

function world:updateDecorQuadtree()
	local visibleEntities = self.decorQuadTree:query(camera.x, camera.y, scrW / camera.scaleX + game.WORLD_TILE_WIDTH, scrH / camera.scaleY + game.WORLD_TILE_HEIGHT)
	
	for key, object in ipairs(visibleEntities) do
		if not self.drawableEntitiesMap[object] then
			self.drawableEntities[#self.drawableEntities + 1] = object
			
			object:enterVisibilityRange()
		end
		
		self.drawableEntitiesMap[object] = 1
		visibleEntities[key] = nil
	end
	
	if #self.drawableEntities > 0 then
		local index = 1
		
		for i = 1, #self.drawableEntities do
			local object = self.drawableEntities[index]
			local state = self.drawableEntitiesMap[object]
			
			if state == 2 then
				object:leaveVisibilityRange()
				table.remove(self.drawableEntities, index)
				
				self.drawableEntitiesMap[object] = nil
			else
				self.drawableEntitiesMap[object] = state + 1
				index = index + 1
			end
		end
	end
	
	self.updateQuad = false
end

function world:getPedestrianTiles()
	return self.pedestrianTiles
end

function world:getRandomPedestrianTile()
	return self.pedestrianTiles[math.random(1, #self.pedestrianTiles)]
end

function world:loadPrefabs(mapData)
	local id = 1
	
	for key, prefabData in pairs(mapData.prefabs) do
		local object = officeBuildingInserter:insertIntoCoordinates(prefabData.id, self, prefabData.x, prefabData.y, prefabData.rotation, prefabData.playerOwned, prefabData.rivalOwner, prefabData.reserved, prefabData.residential, nil)
		
		if not prefabData.playerOwned and not prefabData.residential then
			object:setUnpurchasedName(id)
			
			id = id + 1
		end
	end
	
	local tileW, tileH = self.floorTileGrid:getTileSize()
	
	for key, decorData in ipairs(mapData.decorationObjects) do
		local tree = objects.create(decorData.class)
		
		tree:setRotation(decorData.rotation)
		tree:setPos(decorData.x * tileW, decorData.y * tileH)
		tree:finalizeGridPlacement(decorData.x, decorData.y, 1, true)
		
		self.decorationObjects[#self.decorationObjects + 1] = tree
	end
	
	if mapData.decorationEntities then
		for key, data in ipairs(mapData.decorationEntities) do
			local object = objects.create(data.class)
			
			object:setPos(data.x, data.y)
			object:setRotation(data.rotation)
			
			self.decorationEntities[#self.decorationEntities + 1] = object
		end
	end
end

function world:addPedestrianBuilding(building)
	table.insert(self.pedestrianBuildings, building)
end

function world:getRandomPedestrianBuilding(exclusion)
	if exclusion then
		local success, key = table.removeObject(self.pedestrianBuildings, exclusion)
		local result = self.pedestrianBuildings[math.random(1, #self.pedestrianBuildings)]
		
		table.insert(self.pedestrianBuildings, key, exclusion)
		
		return result
	end
	
	return self.pedestrianBuildings[math.random(1, #self.pedestrianBuildings)]
end

function world:getPedestrianBuildings()
	return self.pedestrianBuildings
end

function world:getOfficeObject(objectID)
	return self.buildingObjectMap[objectID]
end

function world:addBuilding(object)
	table.insert(self.buildingObjects, object)
	
	self.buildingObjectMap[object:getID()] = object
	
	self.tileRenderer:onOfficeObjectCreated(object)
end

function world:getBuildings()
	return self.buildingObjects
end

function world:getBuildingByID(id)
	for key, buildingObj in ipairs(self.buildingObjects) do
		if buildingObj:getID() == id then
			return buildingObj
		end
	end
end

function world:canPlaceObject(x, y, object, officeTiles)
	local startX, startY, endX, endY = object:getPlacementCoordinates(x, y, nil)
	local placeOn = object.placeOn
	local floor = object:getFloor()
	
	for iterY = startY, endY do
		for iterX = startX, endX do
			local index = self.objectGrid:getTileIndex(iterX, iterY)
			
			if self.objectGrid:getObjectCount(iterX, iterY, floor) > 0 or self.objectGrid:outOfBounds(iterX, iterY) or officeTiles[index] or self.floorTileGrid:getTileValue(index, floor) ~= placeOn then
				return false
			end
		end
	end
	
	return startX, startY
end

function world:save()
	local saved = {
		decorations = {},
		decorEnts = {},
		buildings = {},
		mapID = self.mapID
	}
	
	for key, object in ipairs(self.decorationObjects) do
		saved.decorations[#saved.decorations + 1] = object:save()
	end
	
	for key, object in ipairs(self.decorationEntities) do
		saved.decorEnts[#saved.decorEnts + 1] = object:save()
	end
	
	for key, object in ipairs(self.buildingObjects) do
		saved.buildings[#saved.buildings + 1] = object:save()
	end
	
	return saved
end

function world:load(data)
	local handler = self.floorTileGrid:getHandler()
	
	self.floorTileGrid:setHandler(nil)
	
	local mapID = data.mapID
	
	mapID = mapID or data.map:gsub(game.MAP_DIRECTORY, ""):gsub(game.MAP_FILE_FORMAT, "")
	
	self:loadMap(mapID, nil, nil, true)
	
	for key, objectData in ipairs(data.decorations) do
		local newObj = objects.create(objectData.class)
		
		newObj:load(objectData)
		
		self.decorationObjects[#self.decorationObjects + 1] = newObj
	end
	
	if data.decorEnts then
		for key, objectData in ipairs(data.decorEnts) do
			local newObj = objects.create(objectData.class)
			
			newObj:load(objectData)
			
			self.decorationEntities[#self.decorationEntities + 1] = newObj
		end
	end
	
	for key, objectData in ipairs(data.buildings) do
		local newObj = officeBuilding.new()
		
		newObj:load(objectData)
		self:addBuilding(newObj)
	end
	
	self.floorTileGrid:setHandler(handler)
end

function world:onFinishLoad()
	self.finishingLoad = true
	
	for key, object in ipairs(self.buildingObjects) do
		object:postLoad()
	end
	
	self.finishingLoad = false
	
	for key, object in ipairs(self.buildingObjects) do
		object:finalizeLoad()
	end
end

function world:isFinishingLoad()
	return self.finishingLoad
end

function world:removeDecorWithinAABB(x, y, w, h)
	local objects = self.decorQuadTree:query(x, y, w, h)
	local index = 1
	
	if #objects > 0 then
		for i = 1, #objects do
			local object = objects[index]
			
			if not object.ROOF_OBJECT then
				local objX, objY, objW, objH = object:getBoundingBox()
				
				if math.ccaabb(x, y, objX, objY, w, h, objW, objH) then
					object:remove()
				end
				
				objects[index] = nil
			end
			
			index = index + 1
		end
	end
	
	if self.updateQuad then
		self:updateDecorQuadtree()
	end
end

function world:queueQuadtreeUpdate()
	self.updateQuad = true
end

function world:getDecompressedMapData()
	return self.decompressedMapData
end

function world:getMapFile()
	return self.mapFile
end

function world:getMapID()
	return self.mapID
end

function world:onFloorViewChanged()
	local floor = camera:getViewFloor()
	
	self.objectRenderer:onFloorViewChanged()
	self.tileRenderer:onFloorViewChanged()
	studio:onFloorViewChanged()
	lightingManager:sendInLoad(pathfinderThread.MESSAGE_TYPE.FLOOR, floor)
	lightingManager:forceUpdate()
	
	self.devQuadTree = self.devFloorQuadTree:getQuadTree(floor)
end

function world:postInit()
	self.tileRenderer:setupOfficeData()
	self.objectRenderer:setupOfficeData()
	
	for key, buildingObject in ipairs(self.buildingObjects) do
		buildingObject:postInit()
	end
end

function world:removeDecorationObject(object)
	for key, otherObject in ipairs(self.decorationObjects) do
		if otherObject == object then
			table.remove(self.decorationObjects, key)
		end
	end
end

function world:removeDecorationEntity(object)
	for key, otherObject in ipairs(self.decorationEntities) do
		if otherObject == object then
			table.remove(self.decorationEntities, key)
		end
	end
	
	self:removeDecorationFromQuadtree(object)
end

function world:removeDecorationFromQuadtree(object)
	if object.WITHINQUADTREE then
		self.decorQuadTree:remove(object)
		
		object.WITHINQUADTREE = false
		self.updateQuad = true
	end
end

function world:clampWidth(w)
	return math.max(1, math.min(w, self.gridWidth))
end

function world:clampHeight(h)
	return math.max(1, math.min(h, self.gridHeight))
end

function world:remove()
	self.floorTileGrid:remove()
	studio:remove()
	
	for key, object in ipairs(self.buildingObjects) do
		object:remove()
	end
	
	while #self.decorationObjects > 0 do
		self.decorationObjects[#self.decorationObjects]:remove()
	end
	
	while #self.decorationEntities > 0 do
		self.decorationEntities[#self.decorationEntities]:remove()
	end
	
	for key, obj in ipairs(self.decorQuadTree:getAllItems({})) do
		obj:remove()
	end
	
	self.objectGrid:remove()
	
	self.decorationObjects = nil
	self.decorationEntities = nil
	self.drawableEntities = nil
	self.drawableEntitiesMap = nil
	self.buildingObjects = nil
	self.buildingObjectMap = nil
	self.pedestrianBuildings = nil
	self.prevCamX, self.prevCamY = nil
	self.gridWidth, self.gridHeight = nil
	self.floorTileGrid = nil
	self.objectGrid = nil
	self.lightQuadTree = nil
	self.decorQuadTree = nil
	self.visHandler = nil
	self.tileRenderer = nil
	self.objectRenderer = nil
	self.decompressedMapData = nil
end

function world:getObjectRenderer()
	return self.objectRenderer
end

function world:getFloorTileGrid()
	return self.floorTileGrid
end

function world:getObjectGrid()
	return self.objectGrid
end

function world:draw()
	self.floorTileGrid:draw()
	self.objectGrid:draw()
	
	if #self.drawableEntities > 0 then
		for key, object in ipairs(self.drawableEntities) do
			object:draw()
		end
	end
end

function world:postDraw()
	self.objectGrid:postDraw()
end

function world:isTileFree(x, y, floorID)
	local objects = self.objectGrid:getObjects(x, y, floorID)
	
	if objects then
		for key, object in ipairs(objects) do
			if object:getEnclosesTile() or object:getPreventsMovement() or object:getRequiresWallInFront() then
				return false
			end
		end
	end
	
	return true
end

function world.expansionModeObjectDrawCallback()
	if not studio.expansion:canPerformModeAction(studio.expansion.CONSTRUCTION_MODE.OBJECTS) then
		love.graphics.setColor(255, 255, 255, 125)
	end
end

function world.expansionModeObjectPostDrawCallback()
	love.graphics.setColor(255, 255, 255, 255)
end

function world:enterExpansionMode()
	self.floorTileGrid:enterExpansionMode()
	
	for key, controlledSB in ipairs(game.objectSpriteBatches) do
		controlledSB:setDrawCallback(world.expansionModeObjectDrawCallback)
		controlledSB:setPostDrawCallback(world.expansionModeObjectPostDrawCallback)
	end
	
	for key, object in ipairs(self.buildingObjects) do
		object:enterExpansionMode()
	end
	
	for object, state in pairs(self.objectRenderer:getVisibleObjects()) do
		if object.OFFICE_OBJECT then
			object:onEnterExpansionMode()
		end
	end
end

function world:leaveExpansionMode()
	self.floorTileGrid:leaveExpansionMode()
	
	for key, controlledSB in ipairs(game.objectSpriteBatches) do
		controlledSB:setDrawCallback(nil)
		controlledSB:setPostDrawCallback(nil)
	end
	
	for key, object in ipairs(self.buildingObjects) do
		object:leaveExpansionMode()
	end
	
	for object, state in pairs(self.objectRenderer:getVisibleObjects()) do
		if object.OFFICE_OBJECT then
			object:onLeaveExpansionMode()
		end
	end
	
	game.clearMouseOverOffice()
end

function world:enterAssignmentMode()
	for key, ownedStudio in ipairs(studio:getOwnedBuildings()) do
		ownedStudio:enterAssignmentMode()
	end
end

function world:leaveAssignmentMode()
	for key, ownedStudio in ipairs(studio:getOwnedBuildings()) do
		ownedStudio:leaveAssignmentMode()
	end
	
	game.clearMouseOverOffice()
end

require("game/world/floors")
require("game/world/walls")
