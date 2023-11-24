mapEditor = {}
mapEditor.EDIT_MODE = {
	FLOORS = 1,
	OBJECTS = 5,
	PREFABS = 2,
	DECOR = 4,
	MOVE = 3
}
mapEditor.EDIT_MODE_ORDER = {
	mapEditor.EDIT_MODE.FLOORS,
	mapEditor.EDIT_MODE.PREFABS,
	mapEditor.EDIT_MODE.MOVE,
	mapEditor.EDIT_MODE.DECOR,
	mapEditor.EDIT_MODE.OBJECTS
}
mapEditor.EDIT_MODE_TEXT = {
	[mapEditor.EDIT_MODE.FLOORS] = _T("MAP_EDITOR_MODE_FLOORS", "Floors"),
	[mapEditor.EDIT_MODE.PREFABS] = _T("MAP_EDITOR_MODE_PREFABS", "Prefabs"),
	[mapEditor.EDIT_MODE.MOVE] = _T("MAP_EDITOR_MODE_MOVING", "Moving floor tiles"),
	[mapEditor.EDIT_MODE.DECOR] = _T("MAP_EDITOR_MODE_DECOR", "Decor objects"),
	[mapEditor.EDIT_MODE.OBJECTS] = _T("MAP_EDITOR_MODE_OBJECTS", "Tilegrid objects")
}
mapEditor.MODE_ICONS = {
	[mapEditor.EDIT_MODE.FLOORS] = "tab_floors",
	[mapEditor.EDIT_MODE.PREFABS] = "tab_walls",
	[mapEditor.EDIT_MODE.MOVE] = "tab_floors",
	[mapEditor.EDIT_MODE.DECOR] = "tab_general",
	[mapEditor.EDIT_MODE.OBJECTS] = "tab_office"
}
mapEditor.CATCHABLE_EVENTS = {
	game.EVENTS.PRE_GAME_UNLOAD,
	game.EVENTS.RESOLUTION_CHANGED
}
mapEditor.EVENTS = {
	EDIT_MODE_CHANGED = events:new()
}

function mapEditor:loadMap(filePath, fileName)
	self:leave()
	
	local mapData = game.readMap(filePath)
	
	self:enter(mapData.width, mapData.height, mapData.baseTileType, mapData)
	
	self.mapName = string.gsub(fileName, game.MAP_FILE_FORMAT, "")
end

function mapEditor:enter(width, height, baseTileType, mapData)
	game.setEditorState(true)
	game.setCanInitHUD(false)
	
	self.state = require("game/editors/map_editor_state")
	
	gameStateService:addState(self.state)
	
	self.renderer = require("game/editors/map_editor_renderer")
	
	layerRenderer:addLayer(self.renderer)
	
	self.inputHandler = require("game/editors/map_editor_input_handler")
	
	inputService:addHandler(self.inputHandler)
	inputService:removeHandler(game.mainInputHandler)
	gui.removeAllUIElements()
	mainMenu:hide()
	love.filesystem.createDirectory(game.MAP_DIRECTORY)
	
	self.worldObject = world.new(width, height, game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT)
	game.worldObject = self.worldObject
	self.prefabWorldObject = world.new(width, height, game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT, true)
	
	self.prefabWorldObject:createRenderers("prefab_floor", "prefab_office", "prefab_wall", "prefab_wall_1", "prefab_wall_2", "prefab_wall_3", 3, 6, 52, 48, 53)
	camera:setViewFloor(1)
	
	self.active = true
	game.initialGameStarted = false
	
	timeline:updateTime()
	
	self.tilesToSave = {}
	self.buildingPrefabs = {}
	self.grid = self.worldObject.floorTileGrid
	self.objectGrid = self.worldObject.objectGrid
	self.prefabGrid = self.grid
	self.gridW, self.gridH = width, height
	self.tileW, self.tileH = self.grid:getTileSize()
	self.prefabRotation = walls.UP
	self.decorationObjects = {}
	self.decorObjectIndex = 1
	self.placementEntityRotation = 1
	
	self:cyclePlacementObject(1)
	
	self.decorationEntities = {}
	self.decorEntityIndex = 1
	
	self:cyclePlacementEntity(1)
	
	self.movedTiles = {}
	
	self:initHUD()
	
	self.tilePlacementW = 1
	self.tilePlacementH = 1
	self.tileIndexesToAdjust = {}
	self.baseTileType = baseTileType
	self.floorID = 0
	
	self:cycleFloorID(1)
	
	self.prefabID = 0
	
	self:cyclePrefabID(1)
	self:setEditMode(mapEditor.EDIT_MODE.FLOORS)
	
	self.pedestrianTiles = {}
	self.pedestrianTilesMap = {}
	self.textFont = fonts.get("pix20")
	
	self:fillWithTile(baseTileType)
	game.setCameraPanState(true)
	camera:setBounds(-game.BASE_CAMERA_BOUNDARY, width * game.WORLD_TILE_WIDTH - scrW + game.BASE_CAMERA_BOUNDARY, -game.BASE_CAMERA_BOUNDARY, height * game.WORLD_TILE_HEIGHT - scrH + game.BASE_CAMERA_BOUNDARY)
	
	if mapData then
		for index, value in pairs(mapData.tiles) do
			self:setFloorTile(index, value)
		end
		
		if mapData.prefabs then
			for key, prefab in ipairs(mapData.prefabs) do
				self:insertPrefab(prefab.id, prefab.x, prefab.y, prefab.rotation, prefab.playerOwned, prefab.rivalOwner, prefab.reserved, prefab.residential)
			end
		end
		
		if mapData.decorationObjects then
			for key, objectData in ipairs(mapData.decorationObjects) do
				self:addDecorObject(objectData)
			end
		end
		
		if mapData.decorationEntities then
			for key, data in ipairs(mapData.decorationEntities) do
				self:addDecorEntity(data)
			end
		end
	end
	
	self.worldObject:startRenderers()
	self.prefabWorldObject:startRenderers()
	events:addDirectReceiver(self, mapEditor.CATCHABLE_EVENTS)
	musicPlayback:setPlaylist(musicPlayback.PLAYLIST_IDS.GAMEPLAY_ALL)
end

function mapEditor:isActive()
	return self.active
end

function mapEditor:initHUD()
	self.descBox = gui.create("GenericDescbox")
	self.descBox.backgroundColor = color(0, 0, 0, 50)
	
	self:createButtons()
	self:createZoomButtons()
	self:updateTextbox()
end

function mapEditor:createZoomButtons()
	self.zoomButtons = {}
	
	local lastButton = self.tabButtons[#self.tabButtons]
	local zoomInButton = gui.create("MagnificationButton")
	
	zoomInButton:setSize(32, 32)
	zoomInButton:setDirection(1)
	zoomInButton:setPos(lastButton.x + lastButton.w + _S(5), lastButton.y)
	table.insert(self.zoomButtons, zoomInButton)
	
	local zoomOutButton = gui.create("MagnificationButton")
	
	zoomOutButton:setSize(32, 32)
	zoomOutButton:setDirection(-1)
	zoomOutButton:setPos(zoomInButton.x + zoomInButton.w + _S(5), zoomInButton.y)
	table.insert(self.zoomButtons, zoomOutButton)
end

function mapEditor:createButtons()
	self.tabButtons = {}
	
	for key, modeID in ipairs(mapEditor.EDIT_MODE_ORDER) do
		local button = gui.create("MapEditModeButton")
		
		button:setEditMode(modeID)
		button:setIcon(mapEditor.MODE_ICONS[modeID])
		button:setHoverText({
			{
				font = "bh20",
				text = mapEditor.EDIT_MODE_TEXT[modeID]
			}
		})
		button:setSize(48, 48)
		table.insert(self.tabButtons, button)
	end
	
	self:positionButtons()
end

function mapEditor:positionButtons()
	local scaledOffset = _S(5)
	local buttonCount = #self.tabButtons
	local totalW = scaledOffset * buttonCount + self.tabButtons[1]:getWidth() * buttonCount
	local baseX = scrW * 0.5 - totalW * 0.5
	local baseY = _S(20)
	
	for key, button in ipairs(self.tabButtons) do
		button:setPos(baseX, baseY)
		
		baseX = baseX + button.w + scaledOffset
	end
end

function mapEditor:handleEvent(event)
	if event == game.EVENTS.RESOLUTION_CHANGED then
		self:destroyHUD()
		self:initHUD()
	else
		self:leave()
	end
end

function mapEditor:addPedestrianTile(index, value)
	if not self.pedestrianTilesMap[index] then
		self.pedestrianTiles[#self.pedestrianTiles + 1] = index
		self.pedestrianTilesMap[index] = value
	end
end

function mapEditor:removePedestrianTile(index)
	table.removeObject(self.pedestrianTiles, index)
	
	self.pedestrianTilesMap[index] = nil
end

function mapEditor:setMapName(name)
	self.mapName = name
end

function mapEditor:destroyHUD()
	if self.descBox:isValid() then
		self.descBox:kill()
		
		self.descBox = nil
	end
	
	for key, button in ipairs(self.tabButtons) do
		button:kill()
		
		self.tabButtons[key] = nil
	end
	
	for key, button in ipairs(self.zoomButtons) do
		button:kill()
		
		self.zoomButtons[key] = nil
	end
end

function mapEditor:leave()
	if not self.active then
		return 
	end
	
	game.setEditorState(false)
	game.setCanInitHUD(true)
	
	self.announcement = nil
	
	inputService:addHandler(game.mainInputHandler)
	self:disable()
end

function mapEditor:disable()
	while #self.buildingPrefabs > 0 do
		self:removeLastPrefab()
	end
	
	self.grid = nil
	self.active = false
	
	self:destroyHUD()
	game.setCameraPanState(false)
	self.prefabWorldObject:remove()
	
	for key, obj in ipairs(self.decorationEntities) do
		obj:remove()
		
		self.decorationEntities[key] = nil
	end
	
	self.worldObject = nil
	game.worldObject = nil
	self.prefabWorldObject = nil
	self.prefabGrid = nil
	
	table.clear(self.tilesToSave)
	self:clearMovedTiles()
	gameStateService:removeState(self.state)
	layerRenderer:removeLayer(self.renderer)
	inputService:removeHandler(self.inputHandler)
	events:removeDirectReceiver(self, mapEditor.CATCHABLE_EVENTS)
end

function mapEditor:createStartFrame()
	local frame = gui.create("Frame")
	
	frame:setSize(250, 105)
	frame:setFont("pix24")
	frame:setText(_T("MAP_EDITOR", "Map editor"))
	
	local openMapLoad = gui.create("OpenMapSelectionButton", frame)
	
	openMapLoad:setSize(240, 30)
	openMapLoad:setPos(_S(5), _S(35))
	
	local newMap = gui.create("CreateNewMapButton", frame)
	
	newMap:setSize(240, 30)
	newMap:setPos(openMapLoad.x, openMapLoad.y + openMapLoad.h + _S(5))
	frame:center()
	frameController:push(frame)
end

function mapEditor:createMapSizeSelectionFrame()
	local frame = gui.create("Frame")
	
	frame:setSize(250, 140)
	frame:setFont("pix24")
	frame:setText(_T("ENTER_MAP_SIZE", "Enter map size (in tiles)"))
	
	local textBox = gui.create("TextBox", frame)
	
	textBox:setNumbersOnly(true)
	textBox:setFont(fonts.get("pix24"))
	textBox:setGhostText(_T("WIDTH", "Width"))
	textBox:setMaxText(3)
	textBox:setSize(240, 30)
	textBox:setPos(_S(5), _S(35))
	
	local heightBox = gui.create("TextBox", frame)
	
	heightBox:setNumbersOnly(true)
	heightBox:setFont(fonts.get("pix24"))
	heightBox:setGhostText(_T("HEIGHT", "Height"))
	heightBox:setMaxText(3)
	heightBox:setSize(240, 30)
	heightBox:setPos(textBox.x, textBox.y + textBox.h + _S(5))
	
	local startMapEditorButton = gui.create("StartMapEditorButton", frame)
	
	startMapEditorButton:setSize(240, 30)
	startMapEditorButton:setPos(heightBox.x, heightBox.y + heightBox.h + _S(5))
	startMapEditorButton:setWidthBox(textBox)
	startMapEditorButton:setHeightBox(heightBox)
	frame:center()
	frameController:push(frame)
end

function mapEditor:openLoadingDialog()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont("pix24")
	frame:setText(_T("SELECT_MAP_TO_LOAD", "Select map to load"))
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(390, 560)
	scrollbar:setAdjustElementPosition(true)
	
	for key, mapFile in ipairs(love.filesystem.getDirectoryItems(game.MAP_DIRECTORY)) do
		local loadMapButton = gui.create("LoadMapButton")
		
		loadMapButton:setHeight(28)
		loadMapButton:setFont("pix22")
		loadMapButton:setText(mapFile)
		loadMapButton:setFile(game.MAP_DIRECTORY .. mapFile, mapFile)
		scrollbar:addItem(loadMapButton)
	end
	
	frame:center()
	frameController:push(frame)
end

function mapEditor:setEditMode(mode)
	local oldMode = self.editMode
	
	self.editMode = mode
	
	self:updateTextbox()
	
	if mode ~= oldMode then
		if oldMode == mapEditor.EDIT_MODE.DECOR and self.placementPreview then
			self.placementPreview:remove()
			
			self.placementPreview = nil
		end
		
		if mode == mapEditor.EDIT_MODE.DECOR then
			self:verifyEntityPlacementPreview()
		elseif mode == mapEditor.EDIT_MODE.OBJECTS then
			self:verifyObjectPlacementPreview()
		end
	end
	
	self:positionButtons()
	events:fire(mapEditor.EVENTS.EDIT_MODE_CHANGED)
end

function mapEditor:getEditMode()
	return self.editMode
end

function mapEditor:canInsertPrefab(baseX, baseY, prefabID)
	local indexMap = studio:getOfficeBuildingMap():getTileIndexes()
	local buildingCfg = officeBuildingInserter.registered[prefabID]
	local oldRot = buildingCfg.rotation
	
	buildingCfg.rotation = self.prefabRotation
	
	local grid = self.grid
	
	for key, tileData in ipairs(buildingCfg.tiles) do
		local gridX, gridY = officeBuildingInserter:adjustPosition(baseX, baseY, tileData.x, tileData.y, buildingCfg)
		
		if indexMap[grid:getTileIndex(gridX, gridY)] then
			return false
		end
	end
	
	buildingCfg.rotation = oldRot
	
	return true
end

function mapEditor:insertPrefab(prefabID, x, y, rotation, playerOwned, rivalOwner, reserved, residential)
	if not officeBuildingInserter.registeredByID[prefabID] then
		print("WARNING: loading map with missing building prefab '" .. prefabID .. "'")
		
		return 
	end
	
	local object = officeBuildingInserter:insertIntoCoordinates(prefabID, self.worldObject, x, y, rotation, nil, nil, nil, nil, self.prefabGrid)
	
	object:disableRoof()
	
	playerOwned = playerOwned or false
	
	table.insert(self.buildingPrefabs, {
		id = prefabID,
		x = x,
		y = y,
		rotation = rotation,
		object = object,
		playerOwned = playerOwned,
		rivalOwner = rivalOwner,
		reserved = reserved,
		residential = residential
	})
end

function mapEditor:removeLastPrefab()
	local last = #self.buildingPrefabs
	
	if last > 0 then
		self:removePrefab(last)
	end
end

function mapEditor:removePrefab(key)
	self.buildingPrefabs[key].object:removeFromEditor(self.worldObject, self.prefabGrid, self.prefabGrid, self.baseTileType)
	table.remove(self.buildingPrefabs, key)
end

function mapEditor:getPrefabData(officeObject)
	for key, data in ipairs(self.buildingPrefabs) do
		if data.object == officeObject then
			return data, key
		end
	end
end

function mapEditor:getPrefabOnMouse()
	local prefab = studio:getOfficeBuildingMap():getTileBuilding(self.grid:getTileIndexOnMouse())
	
	if prefab then
		return self:getPrefabData(prefab)
	end
	
	return nil
end

function mapEditor:fillWithTile(tileID)
	self.grid:fillWithTile(tileID)
end

function mapEditor:getSaveDestination()
	return game.MAP_DIRECTORY .. self.mapName .. game.MAP_FILE_FORMAT
end

function mapEditor:attemptSave()
	if self.mapName then
		self:save()
	else
		self:createMapNamingDialog()
	end
end

function mapEditor:cyclePrefabRotation()
	self.prefabRotation = walls.RIGHT_SIDE[self.prefabRotation]
end

function mapEditor:setPrefabRivalOwner(prefabData, ownerID)
	if string.withoutspaces(ownerID) == "" then
		ownerID = nil
	end
	
	prefabData.rivalOwner = ownerID
	prefabData.playerOwned = nil
	prefabData.reserved = nil
end

function mapEditor:createPrefabRivalOwnerPopup(prefabData)
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText(_T("ENTER_RIVAL_ID", "Enter rival ID"))
	frame:setSize(250, 105)
	
	local idBox = gui.create("PrefabRivalTextBox", frame)
	
	idBox:setPos(_S(5), _S(35))
	idBox:setSize(240, 30)
	idBox:setLimitTextToWidth(true)
	idBox:setFont(fonts.get("pix24"))
	
	local confirmButton = gui.create("ConfirmRivalOwnerButton", frame)
	
	confirmButton:setPos(idBox.x, idBox.y + idBox.h + _S(5))
	confirmButton:setSize(240, 30)
	confirmButton:setPrefabData(prefabData)
	confirmButton:setNameBox(idBox)
	frame:center()
	frameController:push(frame)
end

local bitser = require("engine/bitser")

function mapEditor:save()
	local saved = {
		tiles = self.tilesToSave,
		width = self.gridW,
		height = self.gridH,
		baseTileType = self.baseTileType,
		pedestrianTiles = self.pedestrianTiles,
		prefabs = {},
		decorationObjects = {},
		decorationEntities = {}
	}
	local buildingMinX, buildingMinY, buildingMaxX, buildingMaxY = math.huge, math.huge, -math.huge, -math.huge
	
	for key, data in ipairs(self.buildingPrefabs) do
		local prefabData = officeBuildingInserter.registeredByID[data.id]
		
		buildingMinX = math.min(buildingMinX, data.x)
		buildingMinY = math.min(buildingMinY, data.y)
		buildingMaxX = math.max(buildingMaxX, data.x + prefabData.width)
		buildingMaxY = math.max(buildingMaxY, data.y + prefabData.height)
		
		table.insert(saved.prefabs, {
			id = data.id,
			x = data.x,
			y = data.y,
			rotation = data.rotation,
			playerOwned = data.playerOwned,
			rivalOwner = data.rivalOwner,
			reserved = data.reserved,
			residential = data.residential
		})
	end
	
	saved.buildingMinX, saved.buildingMinY, saved.buildingMaxX, saved.buildingMaxY = buildingMinX, buildingMinY, buildingMaxX, buildingMaxY
	
	local gridObj = self.grid
	
	for key, object in ipairs(self.decorationObjects) do
		local x, y = object:getTileCoordinates()
		
		table.insert(saved.decorationObjects, {
			class = object.class,
			x = x,
			y = y,
			rotation = object:getRotation()
		})
		
		if object:getPreventsMovement() then
			local xS, yS, xE, yE = object:getUsedTiles()
			
			for y = yS, yE do
				for x = xS, xE do
					self:removePedestrianTile(grid:getTileIndex(x, y))
				end
			end
		end
	end
	
	for key, object in ipairs(self.decorationEntities) do
		local x, y = object:getPos()
		
		table.insert(saved.decorationEntities, {
			class = object.class,
			x = x,
			y = y,
			rotation = object:getRotation()
		})
	end
	
	local serialized = love.math.compress(bitser.dumps(saved), game.MAP_COMPRESSION_ALGORITHM, game.MAP_COMPRESSION_LEVEL)
	local saveDest = self:getSaveDestination()
	local saveDirectory = love.filesystem.getSaveDirectory()
	
	love.filesystem.write(saveDest, serialized)
	
	local popup = game.createPopup(400, _T("MAP_SAVED", "Map saved"), _format(_T("MAP_SAVED_DESC", "Map saved to file 'FILENAME'"), "FILENAME", saveDirectory .. saveDest), "pix24", "pix20", nil)
	
	frameController:push(popup)
end

function mapEditor:toggleReservation(prefabData)
	prefabData.reserved = not prefabData.reserved
	prefabData.playerOwned = nil
	prefabData.rivalOwner = nil
	
	local text = prefabData.reserved and _T("PREFAB_RESERVED", "Prefab is now reserved") or _T("PREFAB_NOT_RESERVED", "Prefab no longer reserved")
	local popup = game.createPopup(400, _T("PREFAB_RESERVATION_STATE_CHANGED", "Reservation state changed"), text, "pix24", "pix20", nil)
	
	frameController:push(popup)
end

function mapEditor:toggleResidential(prefabData)
	prefabData.residential = not prefabData.residential
	prefabData.playerOwned = nil
	prefabData.rivalOwner = nil
	
	local text = prefabData.residential and _T("PREFAB_RESIDENTIAL", "Prefab is now residential (not purchasable)") or _T("PREFAB_NOT_RESIDENTIAL", "Prefab no longer residential")
	local popup = game.createPopup(400, _T("PREFAB_RESIDENTIAL_STATE_CHANGED", "Residential state changed"), text, "pix24", "pix20", nil)
	
	frameController:push(popup)
end

function mapEditor:getTilePlacementRange(x, y)
	local w, h = math.floor(self.tilePlacementW * 0.5), math.floor(self.tilePlacementH * 0.5)
	
	return math.min(math.max(1, x - w), self.gridW), math.min(math.max(1, y - h), self.gridH), math.min(math.max(1, x + self.tilePlacementW - w - 1), self.gridW), math.min(math.max(1, y + self.tilePlacementH - h - 1), self.gridH)
end

function mapEditor:update(dt)
	if self.placingFloor then
		local startX, startY, endX, endY = self:getTilePlacementRange(self.grid:getMouseTileCoordinates())
		
		for y = startY, endY do
			for x = startX, endX do
				self:setFloorTile(self.grid:getTileIndex(x, y), floors.registered[self.floorID].id, false, true)
			end
		end
		
		self:adjustPlacedTileIDs()
		
		self.placingFloor = true
		self.removingFloor = false
	elseif self.removingFloor then
		local startX, startY, endX, endY = self:getTilePlacementRange(self.grid:getMouseTileCoordinates())
		
		for y = startY, endY do
			for x = startX, endX do
				self:setFloorTile(self.grid:getTileIndex(x, y), self.baseTileType, false, true)
			end
		end
		
		self:adjustPlacedTileIDs()
		
		self.placingFloor = false
		self.removingFloor = true
	end
	
	self.prefabWorldObject:update(dt)
	
	if self.floorDragStartX then
		self:updateDragTile()
	end
end

function mapEditor:setFloorID(id)
	self.floorID = id
	
	if floors.registered[self.floorID].skipEditor then
		self:cycleFloorID(-1)
	else
		self:cycleFloorID(0)
	end
end

function mapEditor:cycleFloorID(direction)
	repeat
		self.floorID = self.floorID + direction
		
		if self.floorID <= 0 then
			self.floorID = #floors.registered
		elseif self.floorID > #floors.registered then
			self.floorID = 1
		end
	until not floors.registered[self.floorID].skipEditor
	
	if self.editMode == mapEditor.EDIT_MODE.FLOORS then
		self:updateTextbox()
	end
end

function mapEditor:cyclePrefabID(direction)
	self.prefabID = self.prefabID + direction
	
	if self.prefabID <= 0 then
		self.prefabID = #officeBuildingInserter.registered
	elseif self.prefabID > #officeBuildingInserter.registered then
		self.prefabID = 1
	end
	
	if self.editMode == mapEditor.EDIT_MODE.PREFABS then
		self:updateTextbox()
	end
end

function mapEditor:recordIndexes(index)
	local grid = self.grid
	local indexX, indexY = grid:convertIndexToCoordinates(index)
	
	for y = -1, 1 do
		for x = -1, 1 do
			if not grid:outOfBounds(indexX + x, indexY + y) then
				local offsetIndex = grid:offsetIndex(index, x, y)
				
				if not table.find(self.tileIndexesToAdjust, offsetIndex) then
					self.tileIndexesToAdjust[#self.tileIndexesToAdjust + 1] = offsetIndex
				end
			end
		end
	end
end

function mapEditor:setFloorTile(index, value, adjustValue, record)
	if studio:getOfficeBuildingMap():getTileBuilding(index) then
		return 
	end
	
	if record then
		self:recordIndexes(index)
	end
	
	if adjustValue then
		value = floors.registeredByID[value]:mapAdjustPlacedTile(index, value, self.grid, 1)
	end
	
	if self.grid:getTileValue(index, 1) == value then
		return 
	end
	
	if floors.pedestrianTiles[value] and not floors.pedestrianTiles[self.grid:getTileValue(index, 1)] then
		self:addPedestrianTile(index, value)
	elseif not floors.pedestrianTiles[value] and floors.pedestrianTiles[self.grid:getTileValue(index, 1)] then
		self:removePedestrianTile(index)
	end
	
	if value ~= self.baseTileType then
		self.tilesToSave[index] = value
	else
		self.tilesToSave[index] = nil
	end
	
	self.grid:setTileValue(index, 1, value)
end

function mapEditor:adjustPlacedTileIDs()
	for key, index in ipairs(self.tileIndexesToAdjust) do
		self:setFloorTile(index, self.grid:getTileValue(index, 1), true, false)
		
		self.tileIndexesToAdjust[key] = nil
	end
end

function mapEditor:addDecorObject(objectData)
	local object = objects.create(objectData.class)
	
	object:setRotation(objectData.rotation)
	object:setObjectGrid(self.objectGrid)
	object:setPos(objectData.x * self.tileW, objectData.y * self.tileH)
	object:finalizeGridPlacement(objectData.x, objectData.y, 1, true)
	
	self.decorationObjects[#self.decorationObjects + 1] = object
	
	self.worldObject:addDecorObject(object)
end

function mapEditor:placeDecorObject(class, startX, startY, rotation)
	local object = objects.create(class)
	
	object:setObjectGrid(self.objectGrid)
	object:setRotation(rotation)
	object:setPos(startX * self.tileW, startY * self.tileH)
	object:finalizeGridPlacement(startX, startY, 1, true)
	
	self.decorationObjects[#self.decorationObjects + 1] = object
end

function mapEditor:addDecorEntity(objectData)
	self:_addDecorEntity(objectData.class, objectData.x, objectData.y, objectData.rotation)
end

function mapEditor:_addDecorEntity(class, x, y, rotation)
	local object = objects.create(class)
	
	object:setPos(x, y)
	object:setRotation(rotation)
	
	self.decorationEntities[#self.decorationEntities + 1] = object
end

function mapEditor:verifyObjectPlacementPreview()
	if not self.placementObjectPreview then
		self.placementObjectPreview = objects.create(objects.registered[self.decorObjectIndex].class)
		
		self.placementObjectPreview:setObjectGrid(self.objectGrid)
		self.placementObjectPreview:setRotation(self.placementEntityRotation)
		self.placementObjectPreview:enterVisibilityRange()
	end
end

function mapEditor:removeObjectPlacementPreview()
	if self.placementObjectPreview then
		self.placementObjectPreview:remove()
		
		self.placementObjectPreview = nil
	end
end

function mapEditor:verifyEntityPlacementPreview()
	if not self.placementPreview then
		self.placementPreview = objects.create(objects.registered[self.decorEntityIndex].class)
		
		self.placementPreview:setRotation(self.placementEntityRotation)
		self.placementPreview:enterVisibilityRange()
	end
end

function mapEditor:removeEntityPlacementPreview()
	if self.placementPreview then
		game.worldObject:removeDecorationEntity(self.placementPreview)
		self.placementPreview:remove()
		
		self.placementPreview = nil
	end
end

function mapEditor:cyclePlacementObject(direction)
	local objectCount = #objects.registered
	
	self:removeObjectPlacementPreview()
	
	while true do
		self.decorObjectIndex = self.decorObjectIndex + direction
		
		local object = objects.registered[self.decorObjectIndex]
		
		if object and object.STATIC_OBJECT and not rawget(object, "BASE") then
			break
		elseif objectCount <= self.decorObjectIndex then
			self.decorObjectIndex = 1
		elseif self.decorObjectIndex <= 0 then
			self.decorObjectIndex = #objects.registered
		end
	end
	
	self:verifyObjectPlacementPreview()
	
	if self.editMode == mapEditor.EDIT_MODE.OBJECTS then
		self:updateTextbox()
	end
end

function mapEditor:cyclePlacementEntity(direction)
	local objectCount = #objects.registered
	
	self:removeEntityPlacementPreview()
	
	while true do
		self.decorEntityIndex = self.decorEntityIndex + direction
		
		local object = objects.registered[self.decorEntityIndex]
		
		if object and not object.SKIP_MAP_EDITOR and object.DECOR and not rawget(object, "ROOT_DECOR") then
			break
		elseif objectCount <= self.decorEntityIndex then
			self.decorEntityIndex = 1
		elseif self.decorEntityIndex <= 0 then
			self.decorEntityIndex = #objects.registered
		end
	end
	
	self:verifyEntityPlacementPreview()
	
	if self.editMode == mapEditor.EDIT_MODE.DECOR then
		self:updateTextbox()
	end
end

function mapEditor:cyclePlacementEntityRotation()
	self.placementEntityRotation = walls.RIGHT_SIDE[self.placementEntityRotation]
	
	self.placementPreview:setRotation(self.placementEntityRotation)
end

function mapEditor:cyclePlacementObjectRotation()
	self.placementEntityRotation = walls.RIGHT_SIDE[self.placementEntityRotation]
	
	self.placementObjectPreview:setRotation(self.placementEntityRotation)
end

function mapEditor:removeTrees()
	for key, object in ipairs(self.decorationObjects) do
		if object.TREE then
			object:remove()
			
			self.decorationObjects[key] = nil
		end
	end
end

function mapEditor:placeTrees(seed, amount)
	self:removeTrees()
	
	if amount == 0 then
		return 
	end
	
	math.randomseed(seed)
	
	local treeIndexes = {}
	local grid = self.grid
	local tileW, tileH = grid:getTileSize()
	local gridW, gridH = grid:getSize()
	local treeClass = objects.getClassData("tree_decoration")
	local placeOn = treeClass.placeOn
	
	for y = 1, gridH - 1 do
		for x = 1, gridW - 1 do
			local index = grid:getTileIndex(x, y)
			
			if grid:getTileValue(index, 1) == placeOn then
				treeIndexes[#treeIndexes + 1] = index
			end
		end
	end
	
	local treeW, treeH = treeClass:getTileSize()
	local buildingTiles = studio:getOfficeBuildingMap():getTileIndexes()
	local treesToMake = amount
	
	while treesToMake > 0 and #treeIndexes > 0 do
		local randomIndex = math.random(1, #treeIndexes)
		local gridIndex = treeIndexes[randomIndex]
		
		table.remove(treeIndexes, randomIndex)
		
		local x, y = grid:convertIndexToCoordinates(gridIndex)
		
		if not buildingTiles[gridIndex] then
			local gridX, gridY = self:canPlaceObject(x, y, treeClass, buildingTiles)
			
			if gridX and not buildingTiles[grid:getTileIndex(gridX, gridY)] and not grid:outOfBounds(x, y) then
				local tree = objects.create("tree_decoration")
				
				tree:setPos(gridX * tileW, gridY * tileH)
				tree:finalizeGridPlacement(gridX, gridY, 1, true)
				
				self.decorationObjects[#self.decorationObjects + 1] = tree
				treesToMake = treesToMake - 1
			end
		end
	end
	
	local popup = gui.create("Popup")
	
	popup:setWidth(400)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLACED_TREES_TITLE", "Placed trees"))
	popup:setText(_format(_T("PLACED_TREES_DESC", "Placed X trees. Leftover (not enough space for): Y trees"), "X", math.abs(treesToMake - amount), "Y", treesToMake))
	popup:addOKButton()
	popup:center()
	frameController:push(popup)
end

function mapEditor:canPlaceObject(x, y, object, officeTiles)
	local startX, startY, endX, endY = object:getPlacementCoordinates(x, y, nil)
	local placeOn = object.placeOn
	
	for iterY = startY, endY do
		for iterX = startX, endX do
			local index = self.objectGrid:getTileIndex(iterX, iterY)
			
			if self.objectGrid:getObjectCount(iterX, iterY, 1) > 0 or self.objectGrid:outOfBounds(iterX, iterY) or officeTiles[index] or self.grid:getTileValue(index, 1) ~= placeOn then
				return false
			end
		end
	end
	
	return startX, startY
end

function mapEditor:createTreePlacementDialog()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText(_T("ENTER_TREE_AMOUNT", "Enter tree amount"))
	frame:setSize(250, 105)
	
	local rangeBox = gui.create("TreePlacementRangeTextBox", frame)
	
	rangeBox:setPos(_S(5), _S(35))
	rangeBox:setSize(240, 30)
	rangeBox:setFont(fonts.get("pix24"))
	
	local confirmButton = gui.create("ConfirmTreePlacementButton", frame)
	
	confirmButton:setPos(rangeBox.x, rangeBox.y + rangeBox.h + _S(5))
	confirmButton:setSize(240, 30)
	confirmButton:setRangeTextbox(rangeBox)
	frame:center()
	frameController:push(frame)
end

function mapEditor:createMapNamingDialog()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText(_T("ENTER_MAP_NAME", "Enter map name"))
	frame:setSize(250, 105)
	
	local nameBox = gui.create("MapNamingTextBox", frame)
	
	nameBox:setPos(_S(5), _S(35))
	nameBox:setSize(240, 30)
	nameBox:setFont(fonts.get("pix24"))
	
	local confirmButton = gui.create("ConfirmMapNamingButton", frame)
	
	confirmButton:setPos(nameBox.x, nameBox.y + nameBox.h + _S(5))
	confirmButton:setSize(240, 30)
	confirmButton:setNameBox(nameBox)
	frame:center()
	frameController:push(frame)
end

function mapEditor:announce(text)
	if not self.announcement or not self.announcement:isValid() then
		self.announcement = gui.create("TimedTextDisplay")
	else
		self.announcement:removeAllText()
	end
	
	self.announcement:addSpaceToNextText(3)
	self.announcement:addText(text, "bh20", nil, 0, 500, "exclamation_point", 22, 22)
	self.announcement:centerX()
	self.announcement:setY(scrH * 0.25)
end

function mapEditor:handleMouseClick(key, x, y)
	if not self.active then
		return 
	end
	
	if self.editMode == mapEditor.EDIT_MODE.FLOORS then
		if key == gui.mouseKeys.LEFT then
			local mouseIndex = self.grid:getTileIndexOnMouse()
			
			self:setFloorTile(mouseIndex, floors.registered[self.floorID].id, false, true)
			
			self.placingFloor = true
			self.removingFloor = false
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			local mouseIndex = self.grid:getTileIndexOnMouse()
			
			self:setFloorTile(mouseIndex, self.baseTileType, false, true)
			
			self.placingFloor = false
			self.removingFloor = true
			
			return true
		elseif key == gui.mouseKeys.AUX1 then
			self.tilePlacementW, self.tilePlacementH = self.tilePlacementH, self.tilePlacementW
			
			return true
		end
	elseif self.editMode == mapEditor.EDIT_MODE.PREFABS then
		if key == gui.mouseKeys.LEFT then
			local gridX, gridY = self.grid:getMouseTileCoordinates()
			
			if self:canInsertPrefab(gridX, gridY, self.prefabID) then
				self:insertPrefab(officeBuildingInserter.registered[self.prefabID].id, gridX, gridY, self.prefabRotation)
			else
				self:announce(_T("MAP_EDITOR_CANT_PLACE_PREFAB", "Can not insert prefab: tiles overlapping with another building"))
			end
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			self:cyclePrefabRotation()
			
			return true
		elseif key == gui.mouseKeys.AUX1 then
			local prefab = studio:getOfficeBuildingMap():getTileBuilding(self.grid:getTileIndexOnMouse())
			
			for key, prefabData in ipairs(self.buildingPrefabs) do
				if prefabData.object == prefab then
					self:removePrefab(key)
					
					break
				end
			end
			
			return true
		end
	elseif self.editMode == mapEditor.EDIT_MODE.MOVE then
		if key == gui.mouseKeys.LEFT then
			if #self.movedTiles == 0 then
				self:attemptDragTile()
			else
				self:moveTiles()
			end
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			if #self.movedTiles > 0 then
				self:clearMovedTiles()
			end
			
			return true
		end
	elseif self.editMode == mapEditor.EDIT_MODE.DECOR then
		if key == gui.mouseKeys.LEFT then
			local mouseX, mouseY = camera:mousePosition()
			
			self:_addDecorEntity(objects.registered[self.decorEntityIndex].class, mouseX + game.WORLD_TILE_WIDTH * 0.5, mouseY + game.WORLD_TILE_HEIGHT * 0.5, self.placementEntityRotation)
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			self:cyclePlacementEntityRotation()
			
			return true
		elseif key == gui.mouseKeys.AUX1 then
			local quadtree = self.worldObject:getDecorQuadTree()
			local mouseX, mouseY = camera:mousePosition()
			local objects = quadtree:query(mouseX + game.WORLD_TILE_WIDTH, mouseY + game.WORLD_TILE_HEIGHT, 1, 1)
			
			if #objects > 0 then
				for key, object in ipairs(objects) do
					if object ~= self.placementPreview then
						quadtree:remove(object)
						object:remove()
						table.removeObject(self.decorationEntities, object)
					end
					
					objects[key] = nil
				end
				
				quadtree:update()
			end
		end
	elseif self.editMode == mapEditor.EDIT_MODE.OBJECTS then
		if key == gui.mouseKeys.LEFT then
			local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = self.placementObjectPreview:getPlacementCoordinates()
			
			self:placeDecorObject(objects.registered[self.decorObjectIndex].class, startX, startY, self.placementObjectPreview:getRotation())
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			self:cyclePlacementObjectRotation()
			
			return true
		elseif key == gui.mouseKeys.AUX1 then
			local objects = self.objectGrid:getObjects(self.objectGrid:getMouseTileCoordinates(), 1)
			
			if objects then
				for key, object in ipairs(objects) do
					object:remove()
					table.removeObject(self.decorationObjects, object)
				end
				
				return true
			end
		end
	end
end

function mapEditor:handleMouseRelease(key, x, y)
	if not self.active then
		return 
	end
	
	if not gui.handleMouseRelease(x, y, key) then
		if self.editMode == mapEditor.EDIT_MODE.FLOORS then
			if key == gui.mouseKeys.LEFT then
				self.placingFloor = false
				
				return true
			elseif key == gui.mouseKeys.RIGHT then
				self.removingFloor = false
				
				return true
			end
		elseif self.editMode == mapEditor.EDIT_MODE.MOVE and key == gui.mouseKeys.LEFT and self.holdingDown then
			self:memorizeMove()
			
			self.holdingDown = false
		end
	end
end

function mapEditor:canSetEditMode(mode)
	if self.editMode == mapEditor.EDIT_MODE.FLOORS then
		if self.placingFloor or self.removingFloor then
			return false
		end
	elseif self.editMode == mapEditor.EDIT_MODE.MOVE and (self.holdingDown or #self.movedTiles > 0) then
		return false
	end
	
	return true
end

function mapEditor:handleKeyPress(key)
	if not self.active then
		return 
	end
	
	local numberKey = tonumber(key)
	
	if numberKey then
		local mode = mapEditor.EDIT_MODE_ORDER[numberKey]
		
		if mode and self:canSetEditMode(mode) then
			self:setEditMode(mode)
		end
		
		return true
	end
	
	if key == "f1" then
		self:createTreePlacementDialog()
		
		return true
	elseif key == "f3" then
		self:attemptSave()
		
		return true
	elseif key == "f4" then
		self:openLoadingDialog()
		
		return true
	elseif key == "f5" then
		self:fillWithTile(self.baseTileType)
		
		return true
	end
	
	if self.editMode == mapEditor.EDIT_MODE.FLOORS then
		if key == "g" then
			local mouseIndex = self.grid:getTileIndexOnMouse()
			
			self:setFloorID(floors.registeredByID[self.grid:getTileValue(mouseIndex, 1)].index)
			
			return true
		elseif key == "kp+" then
			if keyBinding:isShiftDown() then
				self.tilePlacementH = math.max(1, self.tilePlacementH + 1)
			else
				self.tilePlacementW = math.max(1, self.tilePlacementW + 1)
			end
		elseif key == "kp-" then
			if keyBinding:isShiftDown() then
				self.tilePlacementH = math.max(1, self.tilePlacementH - 1)
			else
				self.tilePlacementW = math.max(1, self.tilePlacementW - 1)
			end
		end
	elseif self.editMode == mapEditor.EDIT_MODE.PREFABS then
		if key == "z" then
			self:removeLastPrefab()
			
			return true
		elseif key == "p" then
			local prefab = self:getPrefabOnMouse()
			
			if prefab then
				prefab.playerOwned = not prefab.playerOwned
				prefab.rivalOwner = nil
				prefab.reserved = nil
				
				local text = prefab.playerOwned and _T("PREFAB_PLAYEROWNED", "Prefab is now player-owned") or _T("PREFAB_NOT_PLAYEROWNED", "Prefab no longer player-owned")
				local popup = game.createPopup(400, _T("PREFAB_PLAYER_OWNERSHIP_CHANGED", "Player ownership changed"), text, "pix24", "pix20", nil)
				
				frameController:push(popup)
			end
			
			return true
		elseif key == "r" then
			local prefab = self:getPrefabOnMouse()
			
			if prefab then
				self:createPrefabRivalOwnerPopup(prefab)
			end
		elseif key == "l" then
			local prefab = self:getPrefabOnMouse()
			
			if prefab then
				self:toggleReservation(prefab)
			end
		elseif key == "u" then
			local prefab = self:getPrefabOnMouse()
			
			if prefab then
				self:toggleResidential(prefab)
			end
		end
	elseif self.editMode == mapEditor.EDIT_MODE.PREFABS then
	end
end

function mapEditor:handleMouseWheel(direction)
	if not self.active then
		return 
	end
	
	if self.editMode == mapEditor.EDIT_MODE.FLOORS then
		self:cycleFloorID(direction)
		
		return true
	elseif self.editMode == mapEditor.EDIT_MODE.PREFABS then
		self:cyclePrefabID(direction)
		
		return true
	elseif self.editMode == mapEditor.EDIT_MODE.DECOR then
		self:cyclePlacementEntity(direction)
		
		return true
	elseif self.editMode == mapEditor.EDIT_MODE.OBJECTS then
		self:cyclePlacementObject(direction)
		
		return true
	end
end

function mapEditor:memorizeMove()
	self.moveWidth = math.dist(self.floorDragStartX, self.floorDragFinishX)
	self.moveHeight = math.dist(self.floorDragStartY, self.floorDragFinishY)
	
	for y = self.floorDragStartY, self.floorDragFinishY do
		local localY = y - self.floorDragStartY
		
		for x = self.floorDragStartX, self.floorDragFinishX do
			local localX = x - self.floorDragStartX
			
			table.insert(self.movedTiles, {
				x = localX,
				y = localY,
				value = self.grid:getTileValue(self.grid:getTileIndex(x, y), 1)
			})
		end
	end
	
	self:clearFloorDragArea()
	self:updateTextbox()
end

function mapEditor:moveTiles()
	for key, tileData in ipairs(self.movedTiles) do
		self:setFloorTile(self.grid:getTileIndex(self.lastMoveX + tileData.x, self.lastMoveY + tileData.y), self.baseTileType)
	end
	
	local tileX, tileY = self.grid:getMouseTileCoordinates()
	
	for key, tileData in ipairs(self.movedTiles) do
		self:setFloorTile(self.grid:getTileIndex(tileX + tileData.x, tileY + tileData.y), tileData.value, true)
	end
	
	self.lastMoveX, self.lastMoveY = tileX, tileY
	
	self:setDragRenderBounds(self.lastMoveX, self.lastMoveY, self.lastMoveX + self.moveWidth, self.lastMoveY + self.moveHeight)
end

function mapEditor:attemptDragTile()
	local x, y = self.grid:getMouseTileCoordinates()
	
	self:setFloorDragBounds(x, y)
	self:setDragRenderBounds(self.floorDragStartX, self.floorDragStartY, self.floorDragFinishX, self.floorDragFinishY)
	
	self.holdingDown = true
	
	return true
end

function mapEditor:updateDragTile()
	self:setFloorDragBounds(self.grid:getMouseTileCoordinates())
	self:setDragRenderBounds(self.floorDragStartX, self.floorDragStartY, self.floorDragFinishX, self.floorDragFinishY)
end

function mapEditor:setFloorDragBounds(x, y)
	if not self.floorDragStartX then
		self.floorDragStartX = x
		self.floorDragStartY = y
		self.floorDragFinishX = x
		self.floorDragFinishY = y
		self.floorDragOriginX = x
		self.floorDragOriginY = y
	else
		if x < self.floorDragStartX then
			self.floorDragStartX = x
			self.floorDragFinishX = math.max(self.floorDragStartX, self.floorDragOriginX)
		else
			self.floorDragStartX = math.min(x, self.floorDragOriginX)
			self.floorDragFinishX = math.max(x, self.floorDragOriginX)
		end
		
		if y < self.floorDragStartY then
			self.floorDragStartY = y
			self.floorDragFinishY = math.max(self.floorDragStartY, self.floorDragOriginY)
		else
			self.floorDragStartY = math.min(y, self.floorDragOriginY)
			self.floorDragFinishY = math.max(y, self.floorDragOriginY)
		end
	end
	
	self.lastMoveX, self.lastMoveY = self.floorDragStartX, self.floorDragStartY
end

function mapEditor:clearDragRenderBounds()
	self.dragRenderStartX = nil
	self.dragRenderStartY = nil
	self.dragRenderWidth = nil
	self.dragRenderHeight = nil
end

function mapEditor:clearFloorDragArea()
	self.floorDragStartX = nil
	self.floorDragStartY = nil
	self.floorDragFinishX = nil
	self.floorDragFinishY = nil
end

function mapEditor:clearMovedTiles()
	table.clear(self.movedTiles)
	self:clearDragRenderBounds()
	self:clearFloorDragArea()
	
	self.moveWidth = nil
	self.moveHeight = nil
	
	self:updateTextbox()
end

function mapEditor:setDragRenderBounds(startX, startY, endX, endY)
	local x, y, w, h = math.min(startX, endX), math.min(startY, endY), math.max(startX, endX), math.max(startY, endY)
	local width, height = math.dist(x, w), math.dist(y, h)
	
	self.dragRenderStartX = (x - 1) * game.WORLD_TILE_WIDTH
	self.dragRenderStartY = (y - 1) * game.WORLD_TILE_HEIGHT
	self.dragRenderWidth = (width + 1) * game.WORLD_TILE_WIDTH
	self.dragRenderHeight = (height + 1) * game.WORLD_TILE_HEIGHT
end

function mapEditor:updateTextbox()
	if not self.editMode then
		return 
	end
	
	if self.descBox:isValid() then
		self.descBox:removeAllText()
		self.descBox:overwriteDepth(100)
		self.descBox:addText(mapEditor.EDIT_MODE_TEXT[self.editMode], "bh24", nil, 10, 600)
		
		if self.editMode == mapEditor.EDIT_MODE.FLOORS then
			local floorData = floors.registered[self.floorID]
			local quadName = type(floorData.quadName) == "table" and floorData.quadName[1] or floorData.quadName
			local textData = self.descBox:addText(floorData.display, "bh22", nil, 0, 600, quadName, 36, 36)
			
			textData.iconRotation = floorData.rotation and floorData.rotation[1]
			textData.iconX = _S(18)
			textData.iconY = _S(18)
			textData.iconXOffset = 12
			textData.iconYOffset = 12
			
			self.descBox:addText(_format(_T("MAP_EDITOR_FLOORS_MODE_CONTROLS", "Hold & drag LEFT MOUSE - place floor\nHold & drag RIGHT MOUSE - replace with DEFAULT\nG - grab tile type on mouse\nMouse wheel - cycle through floor types\n Plus/minus - increase/decrease horizontal placement range\nPlus/minus + shift - increase/decrease vertical placement range\nMIDDLE MOUSE - flip placement range"), "DEFAULT", floors.registeredByID[self.baseTileType].display), "bh20", nil, 0, 600)
		elseif self.editMode == mapEditor.EDIT_MODE.PREFABS then
			local prefabData = officeBuildingInserter.registered[self.prefabID]
			
			self.descBox:addText(_format(_T("PREFAB", "Prefab 'NAME'"), "NAME", prefabData.id), "bh22", nil, 0, 600)
			self.descBox:addText(_T("MAP_EDITOR_PREFAB_MODE_CONTROLS", "LEFT MOUSE - place prefab\nRIGHT MOUSE - rotate prefab placement\nMIDDLE MOUSE ON PREFAB - remove it\nZ - remove last prefab\nP - toggle player-owned on mouse prefab\nR - enter rival ID as owner\nL - make reserved (requires scripting to un-reserve)\nU - make residential (not purchasable)"), "bh20", nil, 0, 600)
		elseif self.editMode == mapEditor.EDIT_MODE.MOVE then
			if #self.movedTiles == 0 then
				self.descBox:addText(_T("MAP_EDITOR_MOVE_TILES_FINISH", "Drag & hold LEFT MOUSE - select area to move"), "bh20", nil, 0, 600)
			else
				self.descBox:addText(_T("MAP_EDITOR_MOVE_TILES_START", "LEFT MOUSE on map - move tiles here\nRIGHT MOUSE - deselect/finish moving"), "bh20", nil, 0, 600)
			end
		elseif self.editMode == mapEditor.EDIT_MODE.DECOR then
			self.descBox:addText(_format(_T("MAP_EDITOR_DECOR", "Decor 'NAME'"), "NAME", objects.registered[self.decorEntityIndex].class), "bh22", nil, 0, 600)
			self.descBox:addText(_T("MAP_EDITOR_DECOR_MODE_CONTROLS", "LEFT MOUSE - place object\nRIGHT MOUSE - rotate object\nMouse wheel - cycle through objects\nMIDDLE MOUSE - remove object on mouse"), "bh20", nil, 0, 600)
		elseif self.editMode == mapEditor.EDIT_MODE.OBJECTS then
			self.descBox:addText(_format(_T("MAP_EDITOR_DECOR", "Decor 'NAME'"), "NAME", objects.registered[self.decorObjectIndex].class), "bh22", nil, 0, 600)
			self.descBox:addText(_T("MAP_EDITOR_OBJECTS_MODE_CONTROLS", "LEFT MOUSE - place object\nRIGHT MOUSE - rotate object\nMouse wheel - cycle through objects\nMIDDLE MOUSE - remove objects on mouse"), "bh20", nil, 0, 600)
		end
		
		self.descBox:addText(_T("MAP_EDITOR_EXTRA_CONTROLS", "F1 - place trees\nF3 - save map\nF4 - load existing map\nF5 - reset map"), "pix20", nil, 0, 600)
		self.descBox:setX(_S(10))
		self.descBox:alignToBottom(_S(10))
	end
end

function mapEditor:draw()
	self.worldObject:draw()
	
	if self.editMode == mapEditor.EDIT_MODE.DECOR then
		if self.placementPreview then
			local x, y = camera:mousePosition()
			
			self.placementPreview:setPos(x + game.WORLD_TILE_WIDTH * 0.5, y + game.WORLD_TILE_HEIGHT * 0.5, true)
			self.placementPreview:updateSprite()
		end
	elseif self.editMode == mapEditor.EDIT_MODE.OBJECTS and self.placementObjectPreview then
		local object = self.placementObjectPreview
		local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getPlacementCoordinates()
		local x, y = self.grid:gridToWorld(startX, startY)
		
		object:onMovingPurchaseMode(x, y)
	end
end

function mapEditor:postDraw()
	local gridX, gridY = self.grid:getMouseTileCoordinates()
	
	camera:set()
	
	if self.editMode == mapEditor.EDIT_MODE.PREFABS then
		local prefabData = officeBuildingInserter.registered[self.prefabID]
		
		love.graphics.setColor(150, 255, 150, 75)
		
		local w, h = prefabData.width, prefabData.height
		
		if self.prefabRotation == walls.RIGHT or self.prefabRotation == walls.LEFT then
			w, h = h, w
		end
		
		love.graphics.rectangle("fill", (gridX - 1) * self.tileW, (gridY - 1) * self.tileH, (w + 1) * self.tileW, (h + 1) * self.tileH)
	elseif self.editMode == mapEditor.EDIT_MODE.FLOORS then
		local startX, startY, endX, endY = self:getTilePlacementRange(self.grid:getMouseTileCoordinates())
		local distX, distY = math.dist(startX, endX), math.dist(startY, endY)
		
		love.graphics.setColor(150, 255, 150, 75)
		love.graphics.rectangle("fill", (startX - 1) * self.tileW, (startY - 1) * self.tileH, (1 + distX) * self.tileW, (1 + distY) * self.tileH)
	end
	
	local x, y = gridX * game.WORLD_TILE_WIDTH, gridY * game.WORLD_TILE_HEIGHT
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(self.textFont)
	love.graphics.printST(gridX .. "/" .. gridY, x, y, 255, 255, 255, 255, 0, 0, 0, 255)
	
	if self.editMode == mapEditor.EDIT_MODE.PREFABS then
		local height = self.textFont:getHeight()
		local prefab = self:getPrefabOnMouse()
		
		if prefab then
			love.graphics.printST(_format("building id: BUILDING\nplayer owned: PLAYEROWNED\nrival owner: RIVAL\nreserved: RESERVED\nresidential: RESIDENTIAL", "BUILDING", prefab.object:getID(), "PLAYEROWNED", tostring(prefab.playerOwned), "RIVAL", tostring(prefab.rivalOwner), "RESERVED", tostring(prefab.reserved), "RESIDENTIAL", tostring(prefab.residential)), x, y + height, 255, 255, 255, 255, 0, 0, 0, 255)
		end
	end
	
	if self.dragRenderStartX then
		love.graphics.setColor(150, 255, 150, 150)
		love.graphics.rectangle("fill", self.dragRenderStartX, self.dragRenderStartY, self.dragRenderWidth, self.dragRenderHeight)
	end
	
	camera:unset()
end
