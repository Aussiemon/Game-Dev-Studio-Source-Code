officePrefabEditor = {}
officePrefabEditor.active = nil
officePrefabEditor.CONSTRUCTION_MODES = {
	FLOORS = 1,
	ROOFS = 4,
	OBJECTS = 3,
	ROOF_OBJECTS = 5,
	WALLS = 2
}
officePrefabEditor.FLOOR_QUAD_SIZE = 48
officePrefabEditor.WALL_WIDTH = 48
officePrefabEditor.WALL_HEIGHT = 4
officePrefabEditor.CATCHABLE_EVENTS = {
	game.EVENTS.RETURNING_TO_MAIN_MENU,
	game.EVENTS.RESOLUTION_CHANGED
}
officePrefabEditor.EVENTS = {
	CONSTRUCTION_MODE_CHANGED = events:new()
}
officePrefabEditor.MODE_ICONS = {
	[officePrefabEditor.CONSTRUCTION_MODES.FLOORS] = "tab_floors",
	[officePrefabEditor.CONSTRUCTION_MODES.WALLS] = "tab_walls",
	[officePrefabEditor.CONSTRUCTION_MODES.OBJECTS] = "tab_office",
	[officePrefabEditor.CONSTRUCTION_MODES.ROOFS] = "tab_floors",
	[officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS] = "tab_general"
}
officePrefabEditor.MODE_NAME = {
	[officePrefabEditor.CONSTRUCTION_MODES.FLOORS] = _T("OFFICE_EDITOR_FLOORS", "Floors"),
	[officePrefabEditor.CONSTRUCTION_MODES.WALLS] = _T("OFFICE_EDITOR_WALLS", "Walls"),
	[officePrefabEditor.CONSTRUCTION_MODES.OBJECTS] = _T("OFFICE_EDITOR_OBJECTS", "Objects"),
	[officePrefabEditor.CONSTRUCTION_MODES.ROOFS] = _T("OFFICE_EDITOR_ROOFS", "Roofs"),
	[officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS] = _T("OFFICE_EDITOR_ROOF_OBJECTS", "Roof objects")
}
officePrefabEditor.BASE_MODE_TEXT = "F1 - reset prefab\nF2 - save prefab to clipboard\nF3 - remove previous object\nF4 - remove main door\nF5 - remove all objects\nF6 - load prefab"
officePrefabEditor.MODE_TEXT = {
	[officePrefabEditor.CONSTRUCTION_MODES.FLOORS] = "Mouse wheel - cycle through floors\nClick, hold & drag LEFT MOUSE - place floor\nClick, hold & drag RIGHT MOUSE - remove floor",
	[officePrefabEditor.CONSTRUCTION_MODES.WALLS] = "Mouse wheel - cycle through walls\nRight mouse - rotate side\nDelete - remove wall",
	[officePrefabEditor.CONSTRUCTION_MODES.OBJECTS] = "Mouse wheel - cycle through objects\nRight mouse - rotate side\nDelete - remove objects on mouse",
	[officePrefabEditor.CONSTRUCTION_MODES.ROOFS] = "Mouse wheel - cycle through tiles\nClick, hold & drag LEFT MOUSE - place roofs\nClick, hold & drag RIGHT MOUSE - remove floor",
	[officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS] = "Mouse wheel - cycle through objects\nLEFT MOUSE - place object\nDelete - delete roof objects on mouse"
}
officePrefabEditor.CONSTRUCTION_MODE_ORDER = {
	officePrefabEditor.CONSTRUCTION_MODES.FLOORS,
	officePrefabEditor.CONSTRUCTION_MODES.WALLS,
	officePrefabEditor.CONSTRUCTION_MODES.OBJECTS,
	officePrefabEditor.CONSTRUCTION_MODES.ROOFS,
	officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS
}
officePrefabEditor.GRID_WIDTH = 100
officePrefabEditor.GRID_HEIGHT = 100
officePrefabEditor.FLOOR_TYPE = 5

function officePrefabEditor:enter()
	game.setEditorState(true)
	game.setCanInitHUD(false)
	gui.removeAllUIElements()
	mainMenu:hide()
	timeline:updateTime()
	
	self.placedFloors = {}
	self.indexes = {}
	self.roofIndexes = {}
	self.tileData = table.reuse(self.tileData)
	self.objectPreview = table.reuse(self.objectPreview)
	self.objects = table.reuse(self.objects)
	
	inputService:addHandler(self)
	inputService:removeHandler(game.mainInputHandler)
	gameStateService:addState(self)
	layerRenderer:addLayer(self)
	layerRenderer:removeLayer(game.mainMenuRenderer)
	
	self.worldObject = world.new(officePrefabEditor.GRID_WIDTH, officePrefabEditor.GRID_HEIGHT, game.WORLD_TILE_WIDTH, game.WORLD_TILE_HEIGHT, true)
	
	self.worldObject:createRenderers()
	
	game.worldObject = self.worldObject
	self.objectGrid = self.worldObject:getObjectGrid()
	self.grid = self.worldObject:getFloorTileGrid()
	self.gridW, self.gridH = self.grid:getTileSize()
	
	self.grid:fillWithTile(officePrefabEditor.FLOOR_TYPE)
	camera:setViewFloor(1)
	
	self.floorSpriteBatch = self.floorSpriteBatch or spriteBatchController:newSpriteBatch("office_editor_floor", floors.texture, 3072, "dynamic", 10, false, true, true)
	
	self.floorSpriteBatch:setShouldSortSprites(false)
	
	self.roofSpriteBatch = self.roofSpriteBatch or spriteBatchController:newSpriteBatch("office_editor_roof", floors.texture, 3072, "dynamic", 15, false, true, true)
	
	self.roofSpriteBatch:setShouldSortSprites(false)
	self.roofSpriteBatch:setDrawCallback(function()
		local alpha = self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS and 150 or 100
		
		love.graphics.setColor(255, 255, 255, alpha)
	end)
	self.roofSpriteBatch:setPostDrawCallback(function()
		love.graphics.setColor(255, 255, 255, 255)
	end)
	
	self.wallSpriteBatch = self.wallSpriteBatch or spriteBatchController:newSpriteBatch("office_editor_walls", floors.texture, 4096, "dynamic", 12, false, true, true)
	
	self.wallSpriteBatch:setShouldSortSprites(false)
	self.worldObject:startRenderers()
	camera:setBounds(-game.BASE_CAMERA_BOUNDARY, officePrefabEditor.GRID_WIDTH * game.WORLD_TILE_WIDTH - scrW + game.BASE_CAMERA_BOUNDARY, -game.BASE_CAMERA_BOUNDARY, officePrefabEditor.GRID_HEIGHT * game.WORLD_TILE_HEIGHT - scrH + game.BASE_CAMERA_BOUNDARY)
	
	self.tabButtons = {}
	self.roofObjects = {}
	self.roofObjectID = 1
	self.active = true
	self.floorID = 1
	self.wallID = 1
	self.objectID = 0
	self.roofID = 1
	self.baseX = math.huge
	self.baseY = math.huge
	self.wallRotation = walls.UP
	self.objectRotation = walls.UP
	
	self:initHUD()
	self:setConstructionMode(officePrefabEditor.CONSTRUCTION_MODES.WALLS)
	self:cycleObjectID(1)
	self:cycleRoofObjectID(1)
	game.setCameraPanState(true)
	events:addDirectReceiver(self, officePrefabEditor.CATCHABLE_EVENTS)
	musicPlayback:setPlaylist(musicPlayback.PLAYLIST_IDS.GAMEPLAY_ALL)
end

function officePrefabEditor:leave()
	game.setEditorState(false)
	game.setCanInitHUD(true)
	
	self.announcement = nil
	
	inputService:addHandler(game.mainInputHandler)
	self:disable()
end

function officePrefabEditor:disable()
	self:reset()
	
	self.grid = nil
	self.objectGrid = nil
	self.gridW, self.gridH = nil
	self.active = false
	game.worldObject = nil
	
	self:destroyHUD()
	gameStateService:removeState(self)
	layerRenderer:removeLayer(self)
	inputService:removeHandler(self)
	events:removeDirectReceiver(self, officePrefabEditor.CATCHABLE_EVENTS)
	game.setCameraPanState(false)
end

function officePrefabEditor:handleEvent(event)
	if event == game.EVENTS.RESOLUTION_CHANGED then
		self:destroyHUD()
		self:initHUD()
	else
		self:leave()
	end
end

function officePrefabEditor:cycleConstructionMode(direction)
	self.constructionMode = self.constructionMode + direction
	
	if self.constructionMode > #officePrefabEditor.CONSTRUCTION_MODE_ORDER then
		self.constructionMode = 1
	elseif self.constructionMode <= 0 then
		self.constructionMode = #officePrefabEditor.CONSTRUCTION_MODE_ORDER
	end
end

function officePrefabEditor:setConstructionMode(mode)
	if mode == self.constructionMode then
		return 
	end
	
	if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
		self.objectPreview[self.objectID]:leaveVisibilityRange()
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS then
		self.objectPreview[self.roofObjectID]:leaveVisibilityRange()
	end
	
	self.constructionMode = mode
	
	self:updateTextbox()
	
	self.textX, self.textY = self.descBox:getPos(true)
	
	if mode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
		self:verifyObjectPreview(self.objectID)
	elseif mode == officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS then
		self:verifyObjectPreview(self.roofObjectID)
	end
	
	events:fire(officePrefabEditor.EVENTS.CONSTRUCTION_MODE_CHANGED)
end

function officePrefabEditor:getConstructionMode()
	return self.constructionMode
end

function officePrefabEditor:createPrefabLoadFrame()
	local frame = gui.create("Frame")
	
	frame:setSize(450, 600)
	frame:setFont("pix24")
	frame:setText(_T("SELECT_PREFAB", "Select prefab"))
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(440, 560)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:addDepth(50)
	
	for key, prefabData in ipairs(officeBuildingInserter.registered) do
		local prefabLoad = gui.create("LoadPrefabButton")
		
		prefabLoad:setHeight(30)
		prefabLoad:setPrefabID(prefabData.id)
		scrollbar:addItem(prefabLoad)
	end
	
	frame:center()
	frameController:push(frame)
end

function officePrefabEditor:loadPrefab(id)
	self:reset()
	
	local prefabData = officeBuildingInserter.registeredByID[id]
	local x, y = camera:getCenter()
	local tileW, tileH = self.grid:getTileSize()
	local gridX, gridY = self.grid:worldToGrid(x, y)
	
	gridX, gridY = gridX - math.round(prefabData.width * 0.5), gridY - math.round(prefabData.height * 0.5)
	
	for key, tileData in ipairs(prefabData.tiles) do
		local tileX, tileY = gridX + tileData.x, gridY + tileData.y
		local index = self.grid:getTileIndex(tileX, tileY)
		
		if tileData.id and tileData.id ~= 0 then
			self:placeTile(index, tileData.id, false)
			
			if tileData.roof then
				self:placeTile(index, tileData.roof, true)
			end
			
			if tileData.walls then
				for key, wallID in ipairs(tileData.walls) do
					if wallID ~= 0 then
						self:placeWall(index, wallID, key)
					end
				end
			end
		end
	end
	
	if prefabData.mainDoor then
		local objectData = prefabData.mainDoor
		
		self:placeObject(objects.registeredByID[objectData.class], gridX + objectData.x, gridY + objectData.y, objectData.rotation)
	end
	
	if prefabData.objects then
		for key, objectData in ipairs(prefabData.objects) do
			self:placeObject(objects.registeredByID[objectData.class], gridX + objectData.x, gridY + objectData.y, objectData.rotation)
		end
	end
	
	if prefabData.roofObjects then
		local baseObjX, baseObjY = gridX * tileW, gridY * tileH
		
		for key, data in ipairs(prefabData.roofObjects) do
			self:placeRoofObject(objects.registeredByID[data.class], baseObjX + data.x, baseObjY + data.y)
		end
	end
end

function officePrefabEditor:announce(text)
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

function officePrefabEditor:updateTextbox()
	if not self.constructionMode then
		return 
	end
	
	self.descBox:removeAllText()
	self.descBox:overwriteDepth(100)
	self.descBox:addText(officePrefabEditor.MODE_NAME[self.constructionMode], "bh24", nil, 10, 600)
	
	if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.FLOORS or self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS then
		local floorID = self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS and self.roofID or self.floorID
		local floorData = floors.registered[floorID]
		local quadName = type(floorData.quadName) == "table" and floorData.quadName[1] or floorData.quadName
		local textData = self.descBox:addText(floorData.display, "bh22", nil, 0, 600, quadName, 36, 36)
		
		textData.iconRotation = floorData.rotation and floorData.rotation[1]
		textData.iconX = _S(18)
		textData.iconY = _S(18)
		textData.iconXOffset = 12
		textData.iconYOffset = 12
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
		local data = self.objectPreview[self.objectID]
		local w, h = data.quad:getSize()
		
		w = w * 0.75
		h = h * 0.75
		
		self.descBox:addText(data.display, "bh22", nil, 0, 600, quadLoader:getQuadObjectStructure(data.quad).name, w, h)
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS then
		local data = self.objectPreview[self.roofObjectID]
		local w, h = data.quad:getSize()
		
		w = w * 0.75
		h = h * 0.75
		
		self.descBox:addText(tostring(data.display), "bh22", nil, 0, 600, quadLoader:getQuadObjectStructure(data.quad).name, w, h)
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.WALLS then
		local wallData = walls.purchasable[self.wallID]
		
		self.descBox:addText(wallData.display, "bh22", nil, 0, 600, wallData.menuDisplayQuad, 36, 36)
	end
	
	self.descBox:addText(officePrefabEditor.MODE_TEXT[self.constructionMode], "bh20", nil, 0, 600)
	self.descBox:addText(officePrefabEditor.BASE_MODE_TEXT, "pix20", nil, 0, 600)
	self.descBox:setX(_S(10))
	self.descBox:alignToBottom(_S(10))
	self:positionButtons()
end

function officePrefabEditor:destroyHUD()
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

function officePrefabEditor:initHUD()
	self.descBox = gui.create("GenericDescbox")
	self.descBox.backgroundColor = color(0, 0, 0, 50)
	
	self:createButtons()
	self:createZoomButtons()
	self:updateTextbox()
end

function officePrefabEditor:createZoomButtons()
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

function officePrefabEditor:verifyObjectPreview(objectID)
	if not self.objectPreview[objectID] then
		local object = objects.create(objects.registered[objectID].class)
		
		if object.setObjectGrid then
			object:setObjectGrid(self.objectGrid)
		end
		
		object:setRotation(walls.ORDER[self.objectRotation])
		object:enterVisibilityRange()
		
		self.objectPreview[objectID] = object
	else
		self.objectPreview[objectID]:setRotation(walls.ORDER[self.objectRotation])
		self.objectPreview[objectID]:enterVisibilityRange()
	end
end

function officePrefabEditor:cycleFloorID(direction)
	self.floorID = self.floorID + direction
	
	if self.floorID <= 0 then
		self.floorID = #floors.registered
	elseif self.floorID > #floors.registered then
		self.floorID = 1
	end
	
	self:updateTextbox()
end

function officePrefabEditor:cycleRoofID(direction)
	self.roofID = self.roofID + direction
	
	if self.roofID <= 0 then
		self.roofID = #floors.registered
	elseif self.roofID > #floors.registered then
		self.roofID = 1
	end
	
	self:updateTextbox()
end

function officePrefabEditor:cycleWallID(direction)
	self.wallID = self.wallID + direction
	
	if self.wallID <= 0 then
		self.wallID = #walls.purchasable
	elseif self.wallID > #walls.purchasable then
		self.wallID = 1
	end
	
	self:updateTextbox()
end

function officePrefabEditor:areWallsPresent(tileData)
	for key, wallID in ipairs(tileData.walls) do
		if wallID ~= 0 then
			return true
		end
	end
	
	return false
end

function officePrefabEditor:cycleObjectID(direction)
	local prevID = self.objectID
	
	self.objectID = self.objectID + direction
	
	if self.objectID < 1 then
		self.objectID = #objects.registered
	elseif self.objectID > #objects.registered then
		self.objectID = 1
	end
	
	if prevID ~= self.objectID then
		local object = self.objectPreview[prevID]
		
		if object then
			object.visible = false
			
			object:leaveVisibilityRange()
		end
	end
	
	local objectData = objects.registered[self.objectID]
	
	if not objectData.category then
		self:cycleObjectID(direction)
	else
		self:verifyObjectPreview(self.objectID)
		self:updateTextbox()
	end
end

function officePrefabEditor:save()
	if not self.mainDoor then
		local popup = game.createPopup(500, _T("NO_MAIN_DOOR", "No main door"), _T("CANT_SAVE_PREFAB_NO_MAIN_DOOR", "Can't save prefab - no entrance door placed"), "pix24", "pix20", nil)
		
		frameController:push(popup)
		
		return 
	end
	
	local baseX, baseY = math.huge, math.huge
	local grid = self.grid
	
	for index, data in pairs(self.indexes) do
		local gridX, gridY = grid:convertIndexToCoordinates(index)
		
		baseX, baseY = math.min(baseX, gridX), math.min(baseY, gridY)
	end
	
	local tileString = ""
	local wallIDs = {}
	local orderLength = #walls.ORDER
	
	for index, data in pairs(self.indexes) do
		local x, y = grid:convertIndexToCoordinates(index)
		
		x, y = x - baseX, y - baseY
		
		local baseString
		local floorID = self.placedFloors[index] or 0
		local roofID = self.roofIndexes[index] and self.roofIndexes[index].tileID
		
		if floorID or roofID then
			local wallString = ""
			
			if grid:getWallContents(index, 1) ~= 0 then
				for key, rotation in ipairs(walls.ORDER) do
					local id = grid:getWallID(index, 1, rotation)
					
					if key == 1 then
						wallString = wallString .. id .. ", "
					elseif key < orderLength then
						wallString = wallString .. id .. ", "
					else
						wallString = wallString .. id
					end
				end
			end
			
			if wallString ~= "" then
				baseString = "\n\t\t{x = X, y = Y, id = ID, roof = ROOF, walls = {WALLS}}, "
				
				local id = floorID
				
				if next(self.indexes, index) then
					tileString = tileString .. _format("\n\t\t{x = X, y = Y, id = ID, roof = ROOF, walls = {WALLS}}, ", "X", x, "Y", y, "ID", id, "WALLS", wallString)
				else
					tileString = tileString .. _format("\n\t\t{x = X, y = Y, id = ID, roof = ROOF, walls = {WALLS}}", "X", x, "Y", y, "ID", id, "WALLS", wallString)
				end
			else
				local id = floorID
				
				if next(self.indexes, index) then
					tileString = tileString .. _format("\n\t\t{x = X, y = Y, id = ID, roof = ROOF}, ", "X", x, "Y", y, "ID", id)
				else
					tileString = tileString .. _format("\n\t\t{x = X, y = Y, id = ID, roof = ROOF}", "X", x, "Y", y, "ID", id)
				end
			end
			
			if roofID then
				tileString = string.gsub(tileString, "ROOF", tostring(roofID))
			else
				tileString = string.gsub(tileString, ", roof = ROOF", "")
			end
		end
	end
	
	local objectString = ""
	local baseString = "{\n\tid = \"enter_id_here\",\n\tcost = 1000,\n\ttiles = {\n\tTILES\n\t},\n"
	
	if #self.objects > 0 then
		baseString = baseString .. "\tobjects = {\n\tOBJECTS\n\t},\n"
		
		for key, object in ipairs(self.objects) do
			local tileX, tileY = object:getTileCoordinates()
			local thisString
			
			thisString = key < #self.objects and "\n\t\t{x = X, y = Y, rotation = ROTATION, class = \"CLASS\"}," or "\n\t\t{x = X, y = Y, rotation = ROTATION, class = \"CLASS\"}"
			objectString = objectString .. _format(thisString, "X", tileX - baseX, "Y", tileY - baseY, "ROTATION", object:getRotation(), "CLASS", object:getClass())
		end
	end
	
	local roofObjectsString = ""
	
	if #self.roofObjects > 0 then
		baseString = baseString .. "\troofObjects = {\n\tROOFDECOR\n\t},\n\t"
		
		local gridBaseX, gridBaseY = baseX * game.WORLD_TILE_WIDTH, baseY * game.WORLD_TILE_HEIGHT
		
		for key, object in ipairs(self.roofObjects) do
			local objX, objY = object:getPos()
			local thisString
			
			thisString = key < #self.roofObjects and "\n\t\t{x = X, y = Y, rotation = ROTATION, class = \"CLASS\"}," or "\n\t\t{x = X, y = Y, rotation = ROTATION, class = \"CLASS\"}"
			roofObjectsString = roofObjectsString .. _format(thisString, "X", math.round(objX - gridBaseX), "Y", math.round(objY - gridBaseY), "ROTATION", object:getRotation(), "CLASS", object:getClass())
		end
	end
	
	baseString = baseString .. "\tmainDoor = MAINDOOR\n"
	
	local x, y = self.mainDoor:getTileCoordinates()
	local mainDoorString = _format("{x = X, y = Y, rotation = ROTATION, class = \"CLASS\"}", "X", x - baseX, "Y", y - baseY, "ROTATION", self.mainDoor:getRotation(), "CLASS", self.mainDoor.class)
	local finalString = _format(baseString, "TILES", tileString, "OBJECTS", objectString, "MAINDOOR", mainDoorString, "ROOFDECOR", roofObjectsString)
	
	love.system.setClipboardText(finalString)
end

function officePrefabEditor:reset()
	self.roofSpriteBatch:resetContainer()
	
	local baseFloor = officePrefabEditor.FLOOR_TYPE
	
	for index, state in pairs(self.indexes) do
		if self.placedFloors[index] then
			self.grid:setTileValue(index, 1, baseFloor)
			
			self.placedFloors[index] = nil
		end
		
		for key, rotat in ipairs(walls.ORDER) do
			if self.grid:hasWall(index, 1, rotat) then
				self.grid:removeWall(index, 1, rotat)
			end
		end
		
		local rData = self.roofIndexes[index]
		
		if rData then
			self.roofIndexes[index] = nil
			
			self.roofSpriteBatch:deallocateSlot(rData.spriteID)
		end
		
		self.indexes[index] = nil
	end
	
	table.clearArray(self.roofIndexes)
	
	self.placingFloor = false
	self.baseX = math.huge
	self.baseY = math.huge
	
	for key, object in ipairs(self.objectPreview) do
		object:remove()
		
		self.objectPreview[key] = nil
	end
	
	for key, object in ipairs(self.objects) do
		object:remove()
		
		self.objects[key] = nil
	end
	
	for key, object in ipairs(self.roofObjects) do
		object:remove()
		
		self.roofObjects[key] = nil
	end
	
	if self.mainDoor then
		self.mainDoor:remove()
		
		self.mainDoor = nil
	end
end

function officePrefabEditor:removeObject(object, index)
	if object == self.mainDoor then
		self.mainDoor = nil
	elseif index then
		table.remove(self.objects, index)
	else
		table.removeObject(self.objects, object)
	end
	
	object:remove()
end

function officePrefabEditor:removeRoofObject(object, index)
	if index then
		table.remove(self.roofObjects, index)
	else
		table.removeObject(self.roofObjects, object)
	end
	
	object:remove()
end

function officePrefabEditor:isActive()
	return self.active
end

function officePrefabEditor:handleTextInput()
end

function officePrefabEditor:handleKeyPress(key)
	if self:_handleKeyPress(key) then
		inputService:setPreventPropagation(true)
		
		return true
	end
end

function officePrefabEditor:_handleKeyPress(key)
	if key == "f10" then
		game.captureScreenshot(true)
	end
	
	if love.nonTextKeys[key] and gui.handleKeyPress(key) then
		return true
	end
	
	game.handleKeyPress(key)
	game.attemptSetCameraKey(key, true)
	
	if not self.active then
		return 
	end
	
	local numberKey = tonumber(key)
	
	if numberKey then
		local mode = officePrefabEditor.CONSTRUCTION_MODE_ORDER[numberKey]
		
		if mode then
			self:setConstructionMode(mode)
		end
		
		return true
	else
		if key == "f1" then
			self:reset()
			
			return true
		elseif key == "f2" then
			self:save()
			
			return true
		elseif key == "f3" then
			local object = self.objects[#self.objects]
			
			if object then
				object:remove()
				table.remove(self.objects, #self.objects)
			end
			
			return true
		elseif key == "f4" then
			if self.mainDoor then
				table.removeObject(self.objects, self.mainDoor)
				self.mainDoor:remove()
				
				self.mainDoor = nil
				
				self:announce("Main door removed. You must place the main door in order to be able to save the prefab.")
			end
			
			return true
		elseif key == "f5" then
			for key, object in ipairs(self.objects) do
				object:remove()
				
				self.objects[key] = nil
			end
			
			return true
		elseif key == "f6" then
			self:createPrefabLoadFrame()
			
			return true
		elseif key == "delete" then
			if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
				local realIndex = 1
				
				for i = 1, #self.objects do
					local object = self.objects[realIndex]
					
					if object:isMouseOver() then
						self:removeObject(object, realIndex)
					else
						realIndex = realIndex + 1
					end
				end
			elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS then
				local realIndex = 1
				
				for i = 1, #self.roofObjects do
					local object = self.roofObjects[realIndex]
					
					if object:isMouseOver() then
						self:removeRoofObject(object, realIndex)
					else
						realIndex = realIndex + 1
					end
				end
			end
		end
		
		if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.WALLS and key == "delete" then
			local mouseX, mouseY = self.grid:getMouseTileCoordinates()
			local mouseIndex = self.grid:getTileIndexOnMouse()
			
			self:removeWall(mouseIndex, self.wallRotation)
			
			return true
		end
	end
	
	if frameController:getFrameCount() == 0 then
		return true
	end
	
	return false
end

function officePrefabEditor:placeWall(index, id, rotation)
	self.grid:insertWall(index, 1, id, walls.ORDER[rotation])
	self:evaluateTile(index, false)
end

function officePrefabEditor:removeWall(index, rotation)
	if self.indexes[index] then
		self:_removeWall(index, walls.ORDER[rotation])
	end
	
	local dir = walls.DIRECTION[walls.ORDER[rotation]]
	local forwardIndex = self.grid:offsetIndex(index, dir[1], dir[2])
	
	if self.indexes[forwardIndex] then
		self:_removeWall(forwardIndex, walls.INVERSE_RELATION[walls.ORDER[rotation]])
	end
end

function officePrefabEditor:_removeWall(index, rotation)
	self.grid:removeWall(index, 1, rotation)
	self:evaluateTile(index, false)
end

function officePrefabEditor:handleKeyRelease(key)
	gui.handleKeyRelease(key)
	game.attemptSetCameraKey(key, false)
	
	return true
end

function officePrefabEditor:handleMouseWheel(direction)
	if self.active then
		if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.FLOORS then
			self:cycleFloorID(direction)
			
			return true
		elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.WALLS then
			self:cycleWallID(direction)
			
			return true
		elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
			self:cycleObjectID(direction)
			
			return true
		elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS then
			self:cycleRoofID(direction)
			
			return true
		elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS then
			self:cycleRoofObjectID(direction)
			
			return true
		end
	end
end

function officePrefabEditor:placeObject(object, x, y, rotation)
	local newObject = objects.create(object.class)
	
	newObject:setObjectGrid(self.objectGrid)
	newObject:setRotation(rotation or object:getRotation())
	newObject:setPos(x * self.gridW, y * self.gridH)
	newObject:enterVisibilityRange()
	
	newObject.visible = true
	
	if not self.mainDoor and object.objectType == "door" then
		self.mainDoor = newObject
		
		self:announce("Main door placed. Employees will be placed close to it when hired.\nPress F4 to remove the main door.")
	else
		table.insert(self.objects, newObject)
	end
end

function officePrefabEditor:getRealFloorID()
	local isPlacingRoof = self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS
	local floorID
	
	if isPlacingRoof then
		floorID = self.roofID
	else
		floorID = self.floorID
	end
	
	return floorID, isPlacingRoof
end

function officePrefabEditor:createButtons()
	self.tabButtons = {}
	
	for key, modeID in ipairs(officePrefabEditor.CONSTRUCTION_MODE_ORDER) do
		local button = gui.create("PrefabConstructionModeButton")
		
		button:setConstructionMode(modeID)
		button:setIcon(officePrefabEditor.MODE_ICONS[modeID])
		button:setHoverText({
			{
				font = "bh20",
				text = officePrefabEditor.MODE_NAME[modeID]
			}
		})
		button:setSize(48, 48)
		table.insert(self.tabButtons, button)
	end
	
	self:positionButtons()
end

function officePrefabEditor:positionButtons()
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

function officePrefabEditor:handleMouseClick(key, x, y)
	if not self.active then
		return 
	end
	
	local mouseX, mouseY = self.grid:getMouseTileCoordinates()
	local mouseIndex = self.grid:getTileIndexOnMouse()
	
	if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.FLOORS or self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS then
		local floorID, isPlacingRoof = self:getRealFloorID()
		
		if key == gui.mouseKeys.LEFT then
			self.placingFloor = true
			self.removingFloor = false
			
			self:placeTile(mouseIndex, floors.registered[floorID].id, isPlacingRoof)
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			self.placingFloor = false
			self.removingFloor = true
			
			self:removeTile(mouseIndex, isPlacingRoof)
		end
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.WALLS then
		if key == gui.mouseKeys.LEFT then
			self:placeWall(mouseIndex, self.wallID, self.wallRotation)
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			self:cycleWallRotation(1)
			
			return true
		end
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
		if key == gui.mouseKeys.LEFT then
			local previewObject = self.objectPreview[self.objectID]
			local startX, startY, endX, endY = previewObject:getPlacementCoordinates()
			
			self:placeObject(previewObject, startX, startY)
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			self:cycleObjectRotation(1)
			
			return true
		end
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS and key == gui.mouseKeys.LEFT then
		local previewObject = self.objectPreview[self.roofObjectID]
		local x, y = camera:mousePosition()
		
		self:placeRoofObject(previewObject, x, y)
		
		return true
	end
end

function officePrefabEditor:handleMouseRelease(key)
	if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.FLOORS or self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS then
		if key == gui.mouseKeys.LEFT then
			self.placingFloor = false
			
			return true
		elseif key == gui.mouseKeys.RIGHT then
			self.removingFloor = false
			
			return true
		end
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.WALLS then
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
	end
end

function officePrefabEditor:mouseMoved(x, y, dx, dy)
	if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.FLOORS or self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOFS then
		local floorID, isPlacingRoof = self:getRealFloorID()
		
		if self.placingFloor then
			local mouseX, mouseY = self.grid:getMouseTileCoordinates()
			local mouseIndex = self.grid:getTileIndexOnMouse()
			
			self:placeTile(mouseIndex, floors.registered[floorID].id, isPlacingRoof)
			
			return true
		elseif self.removingFloor then
			local mouseIndex = self.grid:getTileIndexOnMouse()
			
			if self.placedFloors[mouseIndex] or self.roofIndexes[mouseIndex] then
				self:removeTile(mouseIndex, isPlacingRoof)
			end
		end
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.WALLS then
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
	end
end

function officePrefabEditor:placeTile(index, tileID, placingRoof)
	if not placingRoof then
		self.placedFloors[index] = tileID
		
		self:evaluateTile(index, false)
		self.grid:setTileValue(index, 1, tileID)
	else
		local data = self.roofIndexes[index]
		local oldID, spriteID
		
		if data then
			oldID = data.tileID
			data.tileID = tileID
			spriteID = data.spriteID
		else
			spriteID = self.roofSpriteBatch:allocateSlot()
			self.roofIndexes[index] = {
				tileID = tileID,
				spriteID = spriteID
			}
		end
		
		if oldID ~= tileID then
			local fData = floors.registeredByID[tileID]
			local renderX, renderY, rotation, halfWidth, halfHeight, quad = fData:getRenderData(self.grid:indexToWorld(index))
			
			self.roofSpriteBatch:updateSprite(spriteID, quad, renderX, renderY, rotation, fData.scaleX, fData.scaleY, halfWidth, halfHeight)
		end
		
		self:evaluateTile(index, true)
	end
end

function officePrefabEditor:removeTile(index, placingRoof)
	if not placingRoof then
		if self.placedFloors[index] then
			self.placedFloors[index] = nil
			
			self:evaluateTile(index, false)
			self.grid:setTileValue(index, 1, officePrefabEditor.FLOOR_TYPE)
		end
	else
		local data = self.roofIndexes[index]
		
		if data then
			self.roofIndexes[index] = nil
			
			self:evaluateTile(index, true)
			self.roofSpriteBatch:deallocateSlot(data.spriteID)
		end
	end
end

function officePrefabEditor:evaluateTile(index)
	local ids = self.grid:getWallIDs(index, 1)
	local valid = false
	
	for key, rotat in ipairs(walls.ORDER) do
		if ids[rotat] ~= 0 then
			valid = true
			
			break
		end
	end
	
	if not valid and not self.placedFloors[index] and not self.roofIndexes[index] then
		self.indexes[index] = nil
	else
		self.indexes[index] = true
	end
end

function officePrefabEditor:cycleWallRotation(direction)
	self.wallRotation = self.wallRotation + 1
	
	if self.wallRotation <= 0 then
		self.wallRotation = #walls.ORDER
	elseif self.wallRotation > #walls.ORDER then
		self.wallRotation = 1
	end
end

function officePrefabEditor:cycleObjectRotation(direction)
	self.objectRotation = self.objectRotation + 1
	
	if self.objectRotation <= 0 then
		self.objectRotation = #walls.ORDER
	elseif self.objectRotation > #walls.ORDER then
		self.objectRotation = 1
	end
	
	self.objectPreview[self.objectID]:setRotation(walls.ORDER[self.objectRotation])
end

function officePrefabEditor:cycleRoofObjectID(direction)
	local prevID = self.roofObjectID
	
	self.roofObjectID = self.roofObjectID + direction
	
	if self.roofObjectID < 1 then
		self.roofObjectID = #objects.registered
	elseif self.roofObjectID > #objects.registered then
		self.roofObjectID = 1
	end
	
	if prevID ~= self.roofObjectID then
		local object = self.objectPreview[prevID]
		
		if object then
			object.visible = false
			
			object:leaveVisibilityRange()
		end
	end
	
	local objectData = objects.registered[self.roofObjectID]
	
	if not objectData.ROOF_DECOR or rawget(objectData, "ROOT_BASE") then
		self:cycleRoofObjectID(direction)
	else
		self:verifyObjectPreview(self.roofObjectID)
		self:updateTextbox()
	end
end

function officePrefabEditor:placeRoofObject(object, x, y)
	local newObject = objects.create(object.class)
	
	newObject:setRotation(rotation or object:getRotation())
	newObject:setPos(x, y)
	newObject:enterVisibilityRange()
	
	newObject.visible = true
	
	table.insert(self.roofObjects, newObject)
end

function officePrefabEditor:update(dt)
	game.attemptMoveCamera(dt)
	camera:update(dt)
	self.worldObject:update(dt)
end

function officePrefabEditor:draw()
	love.graphics.setCanvas(game.mainFrameBufferObject)
	self.worldObject:draw()
	
	for key, object in ipairs(self.roofObjects) do
		object:updateSprite()
		object:draw()
	end
	
	camera:set()
	priorityRenderer:draw()
	
	if self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.WALLS then
		local scaledW, scaledH = _S(officePrefabEditor.WALL_WIDTH), _S(officePrefabEditor.WALL_HEIGHT)
		local wallData = walls.purchasable[self.wallID]
		
		if wallData.quadName then
			local mouseX, mouseY = self.grid:getMouseTileCoordinates()
			local tileH, tileW = self.grid:getTileSize()
			
			love.graphics.setColor(200, 255, 200, 50)
			love.graphics.rectangle("fill", mouseX * tileW - tileW, mouseY * tileH - tileH, tileW, tileH)
			
			local rotationData = walls.ROTATIONS[walls.ORDER[self.wallRotation]]
			
			love.graphics.setColor(150, 255, 150, 125)
			
			local renderX = mouseX * tileW + rotationData.x - tileW
			local renderY = mouseY * tileH + rotationData.y - tileH
			local originX, originY = 0, 0
			
			love.graphics.draw(floors.atlasTexture, wallData.quad, renderX, renderY, rotationData.rot, 1, 1, originX, originY)
		end
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.OBJECTS then
		local object = self.objectPreview[self.objectID]
		
		if object then
			local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getPlacementCoordinates()
			local x, y = self.grid:gridToWorld(startX, startY)
			
			object:setPos(x, y)
			
			object.visible = true
			
			object:updateSprite()
		end
	elseif self.constructionMode == officePrefabEditor.CONSTRUCTION_MODES.ROOF_OBJECTS then
		local object = self.objectPreview[self.roofObjectID]
		
		if object then
			local x, y = camera:mousePosition()
			
			object:setPos(x, y)
			object:updateSprite()
		end
	end
	
	camera:unset()
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	game.mainFrameBuffer:draw()
	gui.performDrawing()
end
