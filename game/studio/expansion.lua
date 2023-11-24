studio.expansion = {}

local studioExpansion = studio.expansion

studioExpansion.objectSpriteBatches = {}
studioExpansion.objectSpriteBatchesOver = {}
studioExpansion.spriteBatchIDList = {}
studioExpansion.spriteBatchID = floorTileGridRenderer.spriteBatchID
studioExpansion.objectBatchID = "expansion_spritebatch"
studioExpansion.overObjectBatchID = "expansion_spritebatch_2"
studioExpansion.purchasableTileQuad = quadLoader:load("cell_indicator")
studioExpansion.entranceDirection = quadLoader:load("cell_entrance_indicator")
studioExpansion.validEntryTileColor = color(114, 167, 224, 255)
studioExpansion.invalidEntryTileColor = color(255, 150, 150, 255)
studioExpansion.expanding = false
studioExpansion.MAX_CAMERA_PAN_FOR_PLACEMENT = 4
studioExpansion.CONSTRUCTION_MODE = {
	WALLS = 2,
	FLOORS = 1,
	OBJECTS = 3
}
studioExpansion.DEMOLITION_MODE_KEYS = {
	["1"] = studioExpansion.CONSTRUCTION_MODE.WALLS,
	["2"] = studioExpansion.CONSTRUCTION_MODE.OBJECTS
}
studioExpansion.SELL_MOVING_OBJECT_KEY = "backspace"
studioExpansion.CANCEL_MOVING_OBJECT_KEY = "escape"
studioExpansion.EXIT_EXPANSION_BUTTON_ID = "exit_expansion_button"
studioExpansion.MIN_ICON_ALPHA = 200
studioExpansion.ICON_ALPHA_APPROACH_RATE = 255 - studioExpansion.MIN_ICON_ALPHA
studioExpansion.EXPANSION_BORDER = 2
studioExpansion.WALL_SIDE_INDICATION = quadLoader:load("wall_selection_side")
studioExpansion.DEMOLITION_TEXT_FONT = "bh18"
studioExpansion.FLOOR_PLACEMENT_TEXT_FONT = "bh18"
studioExpansion.SMOKE_DEPTH = 20
studioExpansion.SMOKE_PARTICLE_COUNT = 4
studioExpansion.WALL_SMOKE_PARTICLE_COUNT = 3
studioExpansion.MOVE_COUNTDOWN = 0.5
studioExpansion.EVENTS = {
	BOUGHT_FLOOR = events:new(),
	BOUGHT_WALL = events:new(),
	REMOVED_WALL = events:new(),
	EXPANDED_OFFICE = events:new(),
	PLACED_OBJECT = events:new(),
	POST_PLACED_OBJECT = events:new(),
	REMOVED_OBJECT = events:new(),
	POST_REMOVED_OBJECT = events:new(),
	ENTER_EXPANSION_MODE = events:new(),
	LEAVE_EXPANSION_MODE = events:new(),
	CONSTRUCTION_MODE_CHANGED = events:new(),
	BEGAN_MOVING_OBJECT = events:new(),
	FINISHED_MOVING_OBJECT = events:new(),
	SOLD_MOVED_OBJECT = events:new(),
	PURCHASE_ID_CHANGED = events:new(),
	DEMOLITION_MODE_CHANGED = events:new(),
	CLICKED_OBJECT_OPTION = events:new()
}
studioExpansion.DEMOLISH_KEYS = {
	lctrl = true,
	rctrl = true
}
studioExpansion.spriteBatchID = "studio_expansion_tilegrid_spritebatch"
studioExpansion.CONSTRUCTION_ORDER = {
	studioExpansion.CONSTRUCTION_MODE.FLOORS,
	studioExpansion.CONSTRUCTION_MODE.WALLS,
	studioExpansion.CONSTRUCTION_MODE.OBJECTS
}
studioExpansion.SINGLE_FLOOR_PLACEMENT_KEYS = {
	lshift = true,
	rshift = true
}
studioExpansion.lastPurchaseIDs = {}
studioExpansion.enclosedTiles = {}
studioExpansion.openTiles = {}
studioExpansion.constructionMode = studioExpansion.CONSTRUCTION_MODE.FLOORS
studioExpansion.CONSTRUCTION_DEPTH = 200
studioExpansion.OBJECT_DEPTH = 210
studioExpansion.OBJECT_DEPTH_TWO = 211
studioExpansion.OBJECT_TEXTURE = "textures/spritesheets/object_spritesheet.png"
studioExpansion.RED_FLICKER_SPEED = 0.75
studioExpansion.RED_FLICKER_COLOR = color(255, 100, 100, 255)
studioExpansion.spriteUpdateState = {}

function studioExpansion.spriteUpdateState:update(dt)
	studioExpansion:updateExpansionSprites(dt)
end

studioExpansion.moveObjectState = {}

function studioExpansion.moveObjectState:update(dt)
	studioExpansion:updateMoveState(dt)
end

function studioExpansion:init()
	self:initGrids()
	self:initFonts()
	
	self.spriteBatchIDList = {}
	self.displayElements = {}
	self.tileSpriteBatch = self.tileSpriteBatch and spriteBatchController:resetContainer(self.tileSpriteBatch) or spriteBatchController:newSpriteBatch(studioExpansion.spriteBatchID, floors.texture, 8, "dynamic", studioExpansion.CONSTRUCTION_DEPTH, false, true)
	
	self.tileSpriteBatch:setAlwaysActive(true)
	
	self.objectSpriteBatch = self.objectSpriteBatch and spriteBatchController:resetContainer(self.objectSpriteBatch) or spriteBatchController:newSpriteBatch(studioExpansion.objectBatchID, studioExpansion.OBJECT_TEXTURE, 8, "dynamic", studioExpansion.OBJECT_DEPTH, false, true)
	
	self.objectSpriteBatch:setAlwaysActive(true)
	
	self.overObjectSpriteBatch = self.overObjectSpriteBatch and spriteBatchController:resetContainer(self.overObjectSpriteBatch) or spriteBatchController:newSpriteBatch(studioExpansion.overObjectBatchID, studioExpansion.OBJECT_TEXTURE, 8, "dynamic", studioExpansion.OBJECT_DEPTH_TWO, false, true)
	
	self.overObjectSpriteBatch:setAlwaysActive(true)
	
	self.validRows = self.validRows and table.clear(self.validRows) or {}
	self.allocatedSprites = self.allocatedSprites and table.clear(self.allocatedSprites) or {}
	self.allocatedTileSprites = self.allocatedTileSprites and table.clear(self.allocatedTileSprites) or {}
	self.mergedRowCoords = self.mergedRowCoords and table.clear(self.mergedRowCoords) or {}
	self.mergedRowCoordsByID = table.reuse(self.mergedRowCoordsByID)
	self.buildingsByRows = table.reuse(self.buildingsByRows)
	self.invalidTiles = self.invalidTiles and table.clear(self.invalidTiles) or {}
	self.createdObjects = self.createdObjects and table.clear(self.createdObjects) or {}
	self.officeObjects = self.officeObjects and table.clearArray(self.officeObjects) or {}
	self.officeObjectMap = self.officeObjectMap and table.clear(self.officeObjectMap) or {}
	self.usedTileSprites = 0
	self.iconSine = 0
	self.iconAlpha = 255
	self.redFlicker = 0
	self.invalidSine = 0
	self.invalidMove = 0
	self.invalidMoveProgress = 0
	self.areEmployeesUnblocked = true
	self.expansionDisabled = false
end

function studioExpansion:disableExpansion()
	self.expansionDisabled = true
end

function studioExpansion:enableExpansion()
	self.expansionDisabled = false
	
	if self.expanding then
		self.expansionFlash = math.pi * 2
		
		gameStateService:addState(self.spriteUpdateState)
		self:updatePurchasableRows()
	end
end

function studioExpansion:getExpansionDisabled()
	return self.expansionDisabled
end

function studioExpansion:disableBuildingPurchases()
	self.buildingPurchaseDisabled = true
end

function studioExpansion:enableBuildingPurchases()
	self.buildingPurchaseDisabled = false
	
	if self.expanding then
		for key, object in ipairs(game.worldObject:getBuildings()) do
			object:enterExpansionMode()
		end
	end
end

function studioExpansion:getBuildingPurchasesAllowed()
	return self.buildingPurchaseDisabled
end

function studioExpansion:addObjectSpritesheet(batchID, texturePath)
	local id = cache.getImageID(cache.getImage(texturePath))
	local spriteBatch = spriteBatchController:newSpriteBatch(batchID, texturePath, 8, "dynamic", studioExpansion.OBJECT_DEPTH, false, true)
	
	spriteBatch:setAlwaysActive(true)
	
	self.objectSpriteBatches[id] = spriteBatch
	
	local spriteBatch = spriteBatchController:newSpriteBatch(batchID .. "_2", texturePath, 8, "dynamic", studioExpansion.OBJECT_DEPTH_TWO, false, true)
	
	self.objectSpriteBatchesOver[id] = spriteBatch
	
	spriteBatch:setAlwaysActive(true)
	
	self.spriteBatchIDList[#self.spriteBatchIDList + 1] = id
end

studioExpansion:addObjectSpritesheet(studioExpansion.objectBatchID, studioExpansion.OBJECT_TEXTURE)

function studioExpansion:getSpriteSheetByID(id)
	return self.objectSpriteBatches[id], self.objectSpriteBatchesOver[id]
end

function studioExpansion:remove()
	local spriteBatches = self.objectSpriteBatches
	local spriteBatchesOver = self.objectSpriteBatchesOver
	
	for key, id in ipairs(self.spriteBatchIDList) do
		spriteBatches[id]:resetContainer()
		spriteBatchesOver[id]:resetContainer()
	end
end

function studioExpansion:initGrids()
	self.grid = game.worldObject:getFloorTileGrid()
	self.tileW, self.tileH = self.grid:getTileSize()
	self.objectGrid = game.worldObject:getObjectGrid()
end

function studioExpansion:initFonts()
	if not self.font then
		self.font = fonts.get("pix20")
		self.fontHeight = studioExpansion.font:getHeight()
	end
end

function studioExpansion:reset()
	self:init()
end

function studioExpansion:update(dt)
	self.redFlicker = math.flash(curTime, studioExpansion.RED_FLICKER_SPEED)
	
	local scale = 155 * self.redFlicker
	
	studioExpansion.RED_FLICKER_COLOR.g = 100 + scale
	studioExpansion.RED_FLICKER_COLOR.b = 100 + scale
	self.invalidSine = self.invalidSine + frameTime * 3
	
	if self.invalidSine > math.tau then
		self.invalidSine = self.invalidSine - math.tau
	end
	
	self.invalidMove = math.sin(self.invalidSine)
	self.invalidMoveProgress = self.invalidSine / math.tau
	
	for key, obj in ipairs(self.officeObjects) do
		obj:updateSprite()
	end
	
	if self.constructionMode == studioExpansion.CONSTRUCTION_MODE.WALLS then
		if not self.autoSideOverride then
			self:autoAdjustWallSide()
		elseif self.grid:getTileIndexOnMouse() ~= self.lastGridIndex then
			self.autoSideOverride = false
			
			self:autoAdjustWallSide()
		end
	end
end

function studioExpansion:autoAdjustWallSide()
	if not self.holdingDown then
		local sides = walls.ORDER
		local mouseX, mouseY = camera.mouseX, camera.mouseY
		local grid = self.grid
		local mouseGridX, mouseGridY = grid:getMouseTileCoordinates()
		local gridW, gridH = grid:getTileSize()
		local scaleX, scaleY = camera.scaleX, camera.scaleY
		local nGridX, nGridY = (mouseGridX * gridW - camera.x) * scaleX, (mouseGridY * gridH - camera.y) * scaleY
		local halfW, halfH = gridW * 0.5 * scaleX, gridH * 0.5 * scaleY
		local gridXOff, gridYOff = nGridX - halfW, nGridY - halfH
		local dirs = walls.DIRECTION
		local side, closest = nil, math.huge
		
		for key, rot in ipairs(sides) do
			local dir = dirs[rot]
			local dirX, dirY = dir[1], dir[2]
			
			if dirX == 0 then
				local dist = math.dist(gridYOff + halfH * dirY, mouseY)
				
				if dist < closest then
					side = rot
					closest = dist
				end
			else
				local dist = math.dist(gridXOff + halfW * dirX, mouseX)
				
				if dist < closest then
					side = rot
					closest = dist
				end
			end
		end
		
		self.rotationID = side
	end
end

function studioExpansion:startMovingObject(object)
	local floor = object:getFloor()
	
	camera:setViewFloor(floor)
	
	self.movedObject = object
	
	self.movedObject:beginMoving()
	
	self.movedObjectRotation = object:getRotation()
	self.movedObjectX, self.movedObjectY = object:getTileCoordinates()
	self.movedObjectFloor = floor
	
	self.frame:hide()
	self:hideBuildingPurchases()
	self:clearSprites()
	self:allocateSpritesForObject(self.movedObject)
	sound:play("pickup_object")
	events:fire(studioExpansion.EVENTS.BEGAN_MOVING_OBJECT, object)
	
	return true
end

function studioExpansion:cancelMovingObject()
	local objectGrid = game.worldObject:getObjectGrid()
	local width, height = objectGrid:getTileSize()
	local movedObject = self.movedObject
	
	movedObject:cancelMoving()
	self.frame:show()
	self.movedObject:clearMoveData()
	
	self.movedObject = nil
	self.movedObjectRotation = nil
	self.movedObjectX, self.movedObjectY = nil
	self.movedObjectFloor = nil
	
	self:showBuildingPurchases()
	self:updateRowSprites()
	self:deallocateSprites(self.allocatedTileSprites)
	self:verifyPlaceObjectSprites()
	events:fire(studioExpansion.EVENTS.FINISHED_MOVING_OBJECT, movedObject)
end

function studioExpansion:finishMovingObject()
	self.movedObject:finishMoving()
	
	local movedObject = self.movedObject
	local officeObj = self.movedObject:getMovedObjectOffice()
	
	self.movedObject:clearMoveData()
	
	self.movedObject = nil
	self.movedObjectRotation = nil
	self.movedObjectX, self.movedObjectY = nil
	
	if self.movedObjectFloor ~= movedObject:getFloor() then
		self.evalFloorStart = self.movedObjectFloor
	end
	
	self.movedObjectFloor = nil
	
	self.frame:show()
	self:showBuildingPurchases()
	self:updateRowSprites()
	self:deallocateSprites(self.allocatedTileSprites)
	self:verifyPlaceObjectSprites()
	events:fire(studioExpansion.EVENTS.FINISHED_MOVING_OBJECT, movedObject)
	
	return true
end

function studioExpansion:sellMovedObject()
	local object = self.movedObject
	
	self:sellObject(object)
	
	self.movedObject = nil
	
	self:showBuildingPurchases()
	self:updateRowSprites()
	self:deallocateSprites(self.allocatedTileSprites)
	self.frame:show()
	self:verifyPlaceObjectSprites()
	events:fire(studioExpansion.EVENTS.SOLD_MOVED_OBJECT, object)
end

function studioExpansion:verifyPlaceObjectSprites()
	if not self.demolishing and self.constructionMode == studioExpansion.CONSTRUCTION_MODE.OBJECTS and self.currentPurchaseObject then
		self:allocateSpritesForObject(self.currentPurchaseObject)
	end
end

function studioExpansion:getMovedObject()
	return self.movedObject
end

function studioExpansion:addOfficeObject(obj)
	if self.officeObjectMap[obj] then
		return 
	end
	
	self.officeObjects[#self.officeObjects + 1] = obj
	self.officeObjectMap[obj] = true
end

function studioExpansion:removeOfficeObject(obj)
	table.removeObject(self.officeObjects, obj)
	
	self.officeObjectMap[obj] = nil
end

studioExpansion.CANT_LEAVE_COLOR = color(255, 200, 200, 255)

function studioExpansion:createFloorControlHint()
	self:killDisplayElements()
	
	local hintDisplay = gui.create("TimedTextDisplay")
	
	hintDisplay:addSpaceToNextText(4)
	hintDisplay:addText(string.easyformatbykeys(_T("SWITCH_FLOORS_KEYS", "Switch between floors by pressing FLOOR_UP and FLOOR_DOWN."), "FLOOR_UP", keyBinding:getNiceCommandDisplay(keyBinding.COMMANDS.FLOOR_UP), "FLOOR_DOWN", keyBinding:getNiceCommandDisplay(keyBinding.COMMANDS.FLOOR_DOWN)), "bh22", game.UI_COLORS.LIGHT_BLUE, 0, 600, "question_mark", 24, 24)
	hintDisplay:setDieTime(8)
	hintDisplay:centerX()
	hintDisplay:setY(scrH * 0.5 - hintDisplay.h - _S(100))
	table.insert(self.displayElements, hintDisplay)
end

function studioExpansion:createBlockedEmployeesDisplay()
	self:killDisplayElements()
	
	local delta = self.workplaceEmployees - self.reachableEmployees
	local blockedEmployeesDisplay = gui.create("TimedTextDisplay")
	
	for key, employee in ipairs(studio:getEmployees()) do
		if not employee:getCanReachExit() then
			camera:setPosition(employee.x - scrW * 0.5, employee.y - scrH * 0.5)
			camera:setViewFloor(employee:getFloor())
			camera:blockInputFor(1)
		end
	end
	
	if delta > 1 then
		blockedEmployeesDisplay:addText(string.easyformatbykeys(_T("EMPLOYEES_BLOCKED_FROM_ENTRANCE", "COUNT of your employees can't reach the office exit."), "COUNT", delta), "pix22", studioExpansion.CANT_LEAVE_COLOR, 0, 600, "exclamation_point_red", 24, 24)
	else
		blockedEmployeesDisplay:addText(_T("EMPLOYEE_BLOCKED_FROM_ENTRANCE", "1 employee can't reach the office exit."), "pix22", studioExpansion.CANT_LEAVE_COLOR, 0, 600, "exclamation_point_red", 24, 24)
	end
	
	blockedEmployeesDisplay:setDieTime(6)
	blockedEmployeesDisplay:centerX()
	blockedEmployeesDisplay:setY(scrH * 0.5 - blockedEmployeesDisplay.h - _S(100))
	table.insert(self.displayElements, blockedEmployeesDisplay)
end

local missingRooms = {}
local concatTable = {}

function studioExpansion:createMandatoryRoomTypesDisplay()
	self:killDisplayElements()
	
	for roomType, amount in pairs(self.mandatoryRoomTypes) do
		if amount > studio:getValidRoomTypeCount(roomType) then
			missingRooms[roomType] = amount
		end
	end
	
	if #missingRooms > 0 then
		local roomTypesDisplay = gui.create("TimedTextDisplay")
		local concatTarget = _T("ROOM_TYPE_AMOUNT", "AMOUNT ROOMTYPE")
		
		for roomType, amount in pairs(missingRooms) do
			concatTable[#concatTable + 1] = string.easyformatbykeys(concatTarget, "AMOUNT", amount, "ROOMTYPE", studio:getRoomTypeName(roomType))
		end
		
		local substitute = table.concat(concatTable, ", ")
		
		roomTypesDisplay:addText(string.easyformatbykeys(_T("MISSING_ROOM_TYPES", "You must have at least MISSING before you can exit expansion mode."), "MISSING", substitute), "pix22", game.UI_COLORS.IMPORTANT_2, 0, 600, "exclamation_point", 24, 24)
		roomTypesDisplay:setDieTime(6)
		roomTypesDisplay:centerX()
		roomTypesDisplay:setY(scrH * 0.5 - roomTypesDisplay.h - _S(100))
		table.insert(self.displayElements, roomTypesDisplay)
		table.clear(missingRooms)
		table.clearArray(concatTable)
		
		return true
	end
	
	return false
end

function studioExpansion:createFinishMovingDisplay()
	self:killDisplayElements()
	
	if self.finishMovingDisplay and self.finishMovingDisplay:isValid() then
		self.finishMovingDisplay:kill()
	end
	
	self.finishMovingDisplay = gui.create("TimedTextDisplay")
	
	self.finishMovingDisplay:addText(_T("OBJECT_MOVE_NOT_FINISHED_1", "You have not finished moving an object."), "pix22", game.UI_COLORS.IMPORTANT_2, 0, 600)
	self.finishMovingDisplay:addText(_T("OBJECT_MOVE_NOT_FINISHED_2", "Please finish placing the object before attempting to exit office expansion mode."), "pix22", game.UI_COLORS.IMPORTANT_1, 0, 600)
	self.finishMovingDisplay:setDieTime(6)
	self.finishMovingDisplay:centerX()
	self.finishMovingDisplay:setY(scrH * 0.5 - self.finishMovingDisplay.h - _S(100))
end

function studioExpansion:initConstructionValues()
	self.expanding = true
	self.demolishing = false
	self.demolishHold = false
	self.autoSideOverride = false
	self.lastGridIndex = nil
	self.curHoverObject = nil
	
	if not self.expansionDisabled then
		self:updatePurchasableRows()
	end
	
	self:resetPurchaseIDs()
	self:setConstructionMode(studioExpansion.CONSTRUCTION_MODE.FLOORS)
	self:setDemolitionMode(studioExpansion.CONSTRUCTION_MODE.WALLS)
	self:setPurchaseID(1)
	self:setRotation(1)
	
	self.objectIndex = 1
end

function studioExpansion:enter()
	self.interactableObjectList = {}
	self.purchasableBuildings = {}
	
	autosave:addBlocker(self)
	lightingManager:setOfficeBrightnessLevel(lightingManager.OFFICE_BRIGHTNESS_LEVEL_EXPANSION_MODE)
	lightingManager:forceUpdate()
	objectSelector:reset(true)
	priorityRenderer:add(self.tileSpriteBatch, studioExpansion.CONSTRUCTION_DEPTH)
	
	local spriteBatches = self.objectSpriteBatches
	local spriteBatchesOver = self.objectSpriteBatchesOver
	local depthOne, depthTwo = studioExpansion.OBJECT_DEPTH, studioExpansion.OBJECT_DEPTH_TWO
	
	for key, id in ipairs(self.spriteBatchIDList) do
		priorityRenderer:add(spriteBatches[id], depthOne)
		priorityRenderer:add(spriteBatchesOver[id], depthOne)
	end
	
	for key, obj in ipairs(game.worldObject:getObjectRenderer():getVisibleObjectList()) do
		if obj.OFFICE_OBJECT and obj.visible then
			table.insert(self.officeObjects, obj)
			
			self.officeObjectMap[obj] = true
		end
	end
	
	self.modeDisplay = gui.create("ExpansionModeDescbox")
	
	self.modeDisplay:setYEdgePosition(self.mainFrame:getHeight() + _S(10))
	game.worldObject:enterExpansionMode()
	gameStateService:addState(self)
	
	local elem = gui.create("OfficeInfoDescbox")
	
	elem:setPos(_S(10), _S(60, "new_hud"))
	elem:addDepth(1000)
	events:fire(studioExpansion.EVENTS.ENTER_EXPANSION_MODE)
end

function studioExpansion:hideBuildingPurchases()
	for key, obj in ipairs(self.purchasableBuildings) do
		obj:hidePurchaseElement()
	end
end

function studioExpansion:showBuildingPurchases()
	for key, obj in ipairs(self.purchasableBuildings) do
		obj:showPurchaseElement()
	end
end

function studioExpansion:addPurchasableBuilding(obj)
	table.insert(self.purchasableBuildings, obj)
end

function studioExpansion:isActive()
	return self.expanding
end

function studioExpansion:setMandatoryRoomTypes(roomTypes)
	self.mandatoryRoomTypes = roomTypes
end

function studioExpansion:canLeave()
	if gui:isLimitingClicks() then
		return false
	end
	
	if self.mandatoryRoomTypes and self:createMandatoryRoomTypesDisplay() then
		return false
	end
	
	if self.movedObject then
		self:createFinishMovingDisplay()
		
		return false
	end
	
	return true
end

function studioExpansion:attemptLeave()
	if not self.expanding then
		return 
	end
	
	if self.mainFrame and not self.mainFrame:canDraw() then
		return false
	end
	
	if self:canLeave() then
		self:leave()
		
		return true
	end
	
	return false
end

function studioExpansion:leave()
	if not self.expanding then
		return 
	end
	
	self.expanding = false
	self.demolishing = false
	self.curHoverObject = nil
	self.mainFrame = nil
	self.objectListTab = nil
	self.placingObject = false
	self.movedObject = nil
	self.currentPurchaseObject = nil
	self.noCashDisplay = nil
	
	if self.moveObjectTimed then
		self:stopMoveCountdown()
	end
	
	objectSelector:reset()
	gameStateService:removeState(self.spriteUpdateState)
	table.clearArray(self.purchasableBuildings)
	
	if self.modeDisplay then
		self.modeDisplay:kill()
		
		self.modeDisplay = nil
	end
	
	objectSelector:removeBlocker(self)
	
	self.dragCost = nil
	self.holdingDown = false
	
	self:clearSprites()
	self:clearTileSprites()
	lightingManager:setOfficeBrightnessLevel(lightingManager.OFFICE_BRIGHTNESS_LEVEL)
	lightingManager:forceUpdate()
	game.worldObject:leaveExpansionMode()
	self:clearFloorDragArea()
	self:clearDragRenderBounds()
	table.clear(self.validRows)
	table.clear(self.mergedRowCoords)
	table.clear(self.mergedRowCoordsByID)
	table.clear(self.invalidTiles)
	table.clear(self.buildingsByRows)
	
	for objectID, object in pairs(self.createdObjects) do
		object.visible = false
		
		object:remove()
		
		self.createdObjects[objectID] = nil
	end
	
	for key, obj in ipairs(self.officeObjects) do
		obj:updateSprite()
		
		self.officeObjects[key] = nil
		self.officeObjectMap[obj] = nil
	end
	
	self:killDisplayElements()
	
	if self.finishMovingDisplay and self.finishMovingDisplay:isValid() then
		self.finishMovingDisplay:kill()
	end
	
	if self.currentMouseRow then
		self.currentMouseRow = nil
		
		self.rowExpansionElement:kill()
		
		self.rowExpansionElement = nil
	end
	
	if self.modeDisplay and self.modeDisplay:isValid() then
		self.modeDisplay:kill()
		
		self.modeDisplay = nil
	end
	
	self.finishMovingDisplay = nil
	self.mandatoryRoomTypes = nil
	
	priorityRenderer:remove(self.tileSpriteBatch)
	
	local spriteBatches = self.objectSpriteBatches
	local spriteBatchesOver = self.objectSpriteBatchesOver
	local depthOne, depthTwo = studioExpansion.OBJECT_DEPTH, studioExpansion.OBJECT_DEPTH_TWO
	
	for key, id in ipairs(self.spriteBatchIDList) do
		priorityRenderer:remove(spriteBatches[id])
		priorityRenderer:remove(spriteBatchesOver[id])
	end
	
	gameStateService:removeState(self)
	events:fire(studioExpansion.EVENTS.LEAVE_EXPANSION_MODE)
	frameController:pop()
	autosave:removeBlocker(self)
end

function studioExpansion:killDisplayElements()
	for key, element in ipairs(self.displayElements) do
		element:kill()
		
		self.displayElements[key] = nil
	end
end

function studioExpansion:clearDragRenderBounds()
	self.dragRenderStartX = nil
	self.dragRenderStartY = nil
	self.dragRenderWidth = nil
	self.dragRenderHeight = nil
end

function studioExpansion:clearFloorDragArea()
	self.floorDragID = nil
	self.floorDragStartX = nil
	self.floorDragStartY = nil
	self.floorDragFinishX = nil
	self.floorDragFinishY = nil
end

function studioExpansion:getTileSpriteBatch()
	return self.tileSpriteBatch
end

function studioExpansion:clearTileSprites()
	for key, spriteID in ipairs(self.allocatedTileSprites) do
		self.tileSpriteBatch:deallocateSlot(spriteID)
		
		self.allocatedTileSprites[key] = nil
	end
end

function studioExpansion:resetPurchaseIDs()
	self.purchaseID = 1
	
	for key, modeID in pairs(studioExpansion.CONSTRUCTION_MODE) do
		self.lastPurchaseIDs[modeID] = 1
	end
end

function studioExpansion:allocateSprites(amount, into)
	local currentSprites = #into
	local allocateAmount = amount - currentSprites
	
	if allocateAmount > 0 then
		for i = 1, allocateAmount do
			into[#into + 1] = self.tileSpriteBatch:allocateSlot()
		end
	end
	
	return into
end

function studioExpansion:allocateSpritesRaw(amount, into)
	for i = 1, amount do
		into[#into + 1] = self.tileSpriteBatch:allocateSlot()
	end
	
	return into
end

function studioExpansion:deallocateSprites(contents, amount, startPoint)
	if amount then
		local container = self.tileSpriteBatch
		
		for i = 1, amount do
			container:deallocateSlot(table.remove(contents, #contents))
		end
	else
		local container = self.tileSpriteBatch
		
		for key, spriteID in ipairs(contents) do
			container:deallocateSlot(spriteID)
			
			contents[key] = nil
		end
	end
end

function studioExpansion:deallocateUnneededSprites(contents, desiredAmount)
	local currentSprites = #contents
	
	if currentSprites == 0 then
		return 
	end
	
	local unneededSprites = currentSprites - desiredAmount
	
	if unneededSprites > 0 then
		for i = 1, unneededSprites do
			self.tileSpriteBatch:deallocateSlot(spriteID)
			
			contents[unneededSprites] = nil
		end
	end
end

function studioExpansion:updatePurchasableRows()
	self:clearSprites()
	table.clear(self.mergedRowCoords)
	table.clear(self.mergedRowCoordsByID)
	table.clear(self.validRows)
	table.clear(self.buildingsByRows)
	
	for key, officeObject in ipairs(studio:getOwnedBuildings()) do
		print("can expand?", officeObject:getCanExpand())
		
		if officeObject:getCanExpand() then
			self:getPurchasableRows(officeObject)
		end
	end
	
	self:updateRowSprites()
end

function studioExpansion:updateRowSprites()
	local container = self.tileSpriteBatch
	local grid = game.worldObject:getFloorTileGrid()
	local tileW, tileH = grid:getTileSize()
	local tileQuad = studioExpansion.purchasableTileQuad
	
	for key, data in ipairs(self.validRows) do
		local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
		local row = data.tiles
		
		if self:canAffordRow(row) then
			container:setColor(193, 255, 209, 255)
		else
			container:setColor(224, 96, 92, 255)
		end
		
		for key, index in ipairs(row) do
			local x, y = grid:convertIndexToCoordinates(index)
			local spriteID = self.tileSpriteBatch:allocateSlot()
			
			self.allocatedSprites[#self.allocatedSprites + 1] = spriteID
			minX = math.min(minX, x)
			minY = math.min(minY, y)
			maxX = math.max(maxX, x)
			maxY = math.max(maxY, y)
			
			container:updateSprite(spriteID, tileQuad, x * tileW - tileW, y * tileH - tileH, 0, 2, 2)
		end
		
		local struct = {
			minX = minX,
			minY = minY,
			maxX = maxX,
			maxY = maxY,
			rowID = key,
			office = self.buildingsByRows[key]
		}
		
		table.insert(self.mergedRowCoords, struct)
		
		self.mergedRowCoordsByID[key] = struct
	end
	
	container:setColor(255, 255, 255, 255)
end

function studioExpansion:startMoveCountdown(object)
	self:attemptMakeObjectInvisible()
	self:deallocateSprites(self.allocatedTileSprites)
	
	self.moveTime = self.MOVE_COUNTDOWN
	self.moveObjectTimed = object
	
	gameStateService:addState(self.moveObjectState)
end

function studioExpansion:stopMoveCountdown()
	gameStateService:removeState(self.moveObjectState)
	
	self.moveTime = nil
	self.moveObjectTimed = nil
end

function studioExpansion:updateMoveState(dt)
	self.moveTime = self.moveTime - dt
	
	if self.moveTime <= 0 then
		self:attemptMakeObjectInvisible()
		
		self.placingObject = false
		
		self:startMovingObject(self.moveObjectTimed)
		self:stopMoveCountdown()
	end
end

function studioExpansion:updateExpansionSprites(dt)
	if not self.movedObject then
		local spriteIdx = 1
		local allocatedSprites = self.allocatedSprites
		local tileW, tileH = grid:getTileSize()
		local tileQuad = studioExpansion.purchasableTileQuad
		local container = self.tileSpriteBatch
		
		for key, data in ipairs(self.validRows) do
			local row = data.tiles
			
			if self:canAffordRow(row) then
				container:setColor(193, 255, 209, 155 + 100 * math.max(0, math.cos(self.expansionFlash)))
			else
				container:setColor(224, 96, 92, 155 + 100 * math.max(0, math.cos(self.expansionFlash)))
			end
			
			for key, index in ipairs(row) do
				local x, y = grid:convertIndexToCoordinates(index)
				local spriteID = allocatedSprites[spriteIdx]
				
				container:updateSprite(spriteID, tileQuad, x * tileW - tileW, y * tileH - tileH, 0, 2, 2)
				
				spriteIdx = spriteIdx + 1
			end
		end
		
		self.expansionFlash = self.expansionFlash - dt * 3
		
		if self.expansionFlash <= 0 then
			self.expansionFlash = math.pi * 2
		end
	end
end

function studioExpansion:clearSprites()
	for key, spriteID in ipairs(self.allocatedSprites) do
		self.tileSpriteBatch:deallocateSlot(spriteID)
		
		self.allocatedSprites[key] = nil
	end
end

function studioExpansion:getTopmostTile(officeObject)
	local tileMap, tileList = officeObject:getTileIndexes()
	local state, randomTile = table.random(tileMap)
	local grid = game.worldObject:getFloorTileGrid()
	local x, y = grid:convertIndexToCoordinates(randomTile)
	
	return self:findLastTile(x, y, 0, -1, camera:getViewFloor())
end

function studioExpansion:getPurchasableRows(officeObject)
	local topX, topY = self:getTopmostTile(officeObject)
	local floor = 1
	
	if officeObject:canExpandInDirection(walls.LEFT) then
		self:attemptAddRow(self:getTileRowInDirection(topX, topY, -1, 0, 1, 0, 0, 1, floor), officeObject, walls.LEFT)
	end
	
	if officeObject:canExpandInDirection(walls.RIGHT) then
		self:attemptAddRow(self:getTileRowInDirection(topX, topY, 1, 0, -1, 0, 0, 1, floor), officeObject, walls.RIGHT)
	end
	
	local leftX, leftY = self:findLastTile(topX, topY, -1, 0, floor)
	
	if officeObject:canExpandInDirection(walls.UP) then
		self:attemptAddRow(self:getTileRowInDirection(leftX, leftY, 0, -1, 0, 1, 1, 0, floor), officeObject, walls.UP)
	end
	
	if officeObject:canExpandInDirection(walls.DOWN) then
		self:attemptAddRow(self:getTileRowInDirection(leftX, leftY, 0, 1, 0, -1, 1, 0, floor), officeObject, walls.DOWN)
	end
	
	return self.validRows
end

function studioExpansion:findLastTile(x, y, dirX, dirY, floor)
	local grid = game.worldObject:getFloorTileGrid()
	local officeObject = officeObject or studio:getOfficeAtIndex(grid:getTileIndex(x, y))
	local purchasedTiles = officeObject:getTileIndexes()
	
	while true do
		local tileIndex = grid:getTileIndex(x + dirX, y + dirY)
		
		if grid:outOfBounds(x + dirX, y + dirY) or grid:getTileID(tileIndex, floor) == 0 or not purchasedTiles[tileIndex] then
			return x, y
		end
		
		x = x + dirX
		y = y + dirY
	end
end

function studioExpansion:attemptAddRow(data, officeObject, direction)
	if data then
		table.insert(self.validRows, {
			tiles = data,
			direction = direction
		})
		
		self.buildingsByRows[#self.validRows] = officeObject
	end
end

function studioExpansion:setConstructionMode(mode)
	if self.moveObjectTimed then
		self.placingObject = false
		
		self:stopMoveCountdown()
	end
	
	self:clearTileSprites()
	
	self.curHoverObject = nil
	
	if mode ~= self.constructionMode then
		self:storePurchaseID()
	end
	
	self.constructionMode = mode
	
	self:setPurchaseID(self:getPurchaseID())
	
	if studioExpansion.CONSTRUCTION_MODE.FLOORS ~= mode then
		self:setDemolitionMode(mode)
	end
	
	events:fire(studioExpansion.EVENTS.CONSTRUCTION_MODE_CHANGED, self.demolishing)
end

function studioExpansion:preventsObjectSelector()
	return self.expanding and self.demolishing and self.demolitionMode == studioExpansion.CONSTRUCTION_MODE.WALLS
end

function studioExpansion:setDemolitionMode(mode)
	local oldMode = self.demolitionMode
	
	self.demolitionMode = mode
	self.curHoverObject = nil
	
	self:attemptMakeObjectInvisible()
	
	if self.demolitionMode == studioExpansion.CONSTRUCTION_MODE.WALLS then
		objectSelector:reset(true)
		objectSelector:addBlocker(self)
	elseif self.demolitionMode == studioExpansion.CONSTRUCTION_MODE.OBJECTS then
		local grid = game.worldObject:getObjectGrid()
		
		objectSelector:updateInteractionListOnMouse(grid)
		objectSelector:reset(true)
		objectSelector:removeBlocker(self)
	end
	
	if self.objectListTab then
		self.objectListTab:switchTo()
	end
	
	if oldMode ~= mode then
		events:fire(studioExpansion.EVENTS.DEMOLITION_MODE_CHANGED, mode)
	end
end

function studioExpansion:getDemolitionMode()
	return self.demolitionMode
end

function studioExpansion:getConstructionMode()
	return self.constructionMode
end

function studioExpansion:setProgressionLevel(level)
	self.progressionLevel = level
end

function studioExpansion:onFloorViewChanged()
	local obj = self.movedObject or self.currentPurchaseObject
	
	if obj then
		obj:setFloor(camera:getViewFloor())
	end
end

function studioExpansion:setPurchaseID(id)
	if self.demolishing then
		self:setDemolishing(false)
	end
	
	self.progressionLevel = nil
	
	if self.constructionMode == studioExpansion.CONSTRUCTION_MODE.OBJECTS then
		id = math.min(id, #self.objectList)
		
		if self.currentPurchaseObject then
			self:makeObjectInvisible()
		end
		
		local newObject = self.objectList[id].class
		local object
		
		if not self.createdObjects[newObject] then
			object = objects.create(newObject)
			
			object:switchSpriteBatches()
			object:setFloor(camera:getViewFloor())
			object:setObjectGrid(game.worldObject:getObjectGrid())
			
			self.createdObjects[newObject] = object
		else
			object = self.createdObjects[newObject]
			
			object:setFloor(camera:getViewFloor())
		end
		
		object:selectForPurchase()
		object:setRotation(self.rotationID)
		
		self.currentPurchaseObject = object
		
		self:allocateSpritesForObject(object)
		
		self.usedTileSprites = 0
	elseif self.constructionMode == studioExpansion.CONSTRUCTION_MODE.WALLS then
		self:updateWallDrawData(id)
	elseif self.constructionMode == studioExpansion.CONSTRUCTION_MODE.FLOORS then
		self:updateFloorDrawData(id)
	end
	
	local oldID = self.purchaseID
	
	self.purchaseID = id
	
	self:storePurchaseID()
	events:fire(studioExpansion.EVENTS.PURCHASE_ID_CHANGED, id, oldID)
end

function studioExpansion:attemptMakeObjectInvisible()
	if self.currentPurchaseObject and self.constructionMode == studioExpansion.CONSTRUCTION_MODE.OBJECTS then
		self:makeObjectInvisible()
	end
end

function studioExpansion:makeObjectInvisible()
	local obj = self.currentPurchaseObject
	
	obj.visible = false
	
	obj:clearSprite()
	obj:onPickOtherObject()
end

function studioExpansion:updateFloorDrawData(id)
	self.floorQuad, self.floorTexture = floors:getData(id):getQuad()
	self.floorTexture = cache.getImageByID(self.floorTexture)
end

function studioExpansion:updateWallDrawData(id)
	local data = walls:getData(id)
	
	self.wallQuad, self.wallTexture = data.quad, data.quadTexID
	self.wallTexture = cache.getImageByID(self.wallTexture)
end

function studioExpansion:allocateSpritesForObject(object)
	self:deallocateSprites(self.allocatedTileSprites)
	self:allocateSprites(object:getUsedTileAmount() + object:getEntranceTiles(), self.allocatedTileSprites)
end

function studioExpansion:setObjectList(list, cameFrom)
	self.objectList = list
	self.objectListTab = cameFrom
end

function studioExpansion:getPurchaseObject()
	return self.movedObject or self.createdObjects[self.objectList[self:getPurchaseID()].class]
end

function studioExpansion:getPurchaseID(mode)
	mode = mode or self.constructionMode
	
	return self.lastPurchaseIDs[mode]
end

function studioExpansion:storePurchaseID()
	self.lastPurchaseIDs[self.constructionMode] = self.purchaseID
end

function studioExpansion:setRotation(rotateID)
	self.rotationID = rotateID
end

function studioExpansion:getRotation()
	return self.rotationID
end

function studioExpansion:canPlaceWall(x, y, rotation)
	local floor = camera:getViewFloor()
	local index = self.grid:getTileIndex(x, y)
	local purchaseID = self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.WALLS)
	local objectGrid = game.worldObject:getObjectGrid()
	
	rotation = rotation or self.rotationID
	
	local direction = walls.DIRECTION[rotation]
	local forwardObjects = objectGrid:getObjects(x + direction[1], y + direction[2], floor)
	local curObjects = objectGrid:getObjects(x, y, floor)
	
	if curObjects then
		for key, object in ipairs(curObjects) do
			if not self:checkObjectDirectionBlock(object, rotation) then
				return false
			end
		end
	end
	
	if forwardObjects then
		for key, object in ipairs(forwardObjects) do
			if not self:checkObjectDirectionBlock(object, walls.INVERSE_RELATION[rotation]) then
				return false
			end
		end
	end
	
	if forwardObjects and forwardObjects[1] and curObjects and curObjects[1] and curObjects[1] == forwardObjects[1] then
		return false
	end
	
	if studio:hasBoughtTile(index) and studio:canAffordWall(purchaseID) and self.grid:canAddWall(index, floor, rotation, purchaseID) and walls:canPlace(purchaseID, x, y, floor, rotation) then
		return true
	end
	
	return false
end

function studioExpansion:canPlaceTile(x, y, floor)
	local index = self.grid:getTileIndex(x, y)
	local purchaseID = self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.FLOORS)
	
	if studio:hasBoughtTile(index) and self.grid:getTileID(index, floor) ~= purchaseID then
		return true
	end
end

function studioExpansion:getMouseRow()
	for key, data in ipairs(self.mergedRowCoords) do
		if self:isMouseOverRow(data) then
			return data
		end
	end
	
	return nil
end

function studioExpansion:isMouseOverRow(data)
	local grid = game.worldObject:getFloorTileGrid()
	local mouseGridX, mouseGridY = grid:getMouseTileCoordinates()
	
	if mouseGridX < data.minX or mouseGridX > data.maxX or mouseGridY < data.minY or mouseGridY > data.maxY then
		return false
	end
	
	return true
end

function studioExpansion:getRowCost(row)
	return #row * (studio:getNewTileCost() + studio:getTileCost(nil, self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.FLOORS)))
end

function studioExpansion:canAffordRow(row)
	return studio:getFunds() >= self:getRowCost(row)
end

function studioExpansion:getRowTiles(mergedCoords)
	return self.validRows[mergedCoords.rowID].tiles
end

function studioExpansion:cycleWallRotation(reverse)
	self.autoSideOverride = true
	self.lastGridIndex = self.grid:getTileIndexOnMouse()
	
	if reverse then
		if self.rotationID <= 1 then
			self.rotationID = 8
			
			return 
		end
		
		self.rotationID = self.rotationID / 2
		
		return 
	end
	
	if self.rotationID == 8 then
		self.rotationID = 1
		
		return 
	end
	
	self.rotationID = self.rotationID * 2
end

function studioExpansion:clearObjectSprites()
	if not self.objectList then
		return 
	end
	
	local object = self.createdObjects[self.objectList[self:getPurchaseID()].class]
	
	if object then
		object:clearSprite()
		
		object.visible = false
	end
end

function studioExpansion:setDemolishing(demolishing)
	if self.moveObjectTimed then
		self.placingObject = false
		
		self:stopMoveCountdown()
	end
	
	self.demolishing = demolishing
	self.iconAlpha = 255
	
	self:setDemolitionMode(self.demolitionMode)
	
	if self.demolishing then
		self:clearTileSprites()
		objectSelector:reset(true)
		
		if self.constructionMode == studioExpansion.CONSTRUCTION_MODE.OBJECTS then
			self:clearObjectSprites()
		end
	else
		self:setConstructionMode(self.constructionMode)
	end
	
	events:fire(studioExpansion.EVENTS.DEMOLITION_MODE_CHANGED, self.demolishing)
end

function studioExpansion:handleKeyPress(key, isrepeat)
	if not self.expanding or gui:isLimitingClicks() then
		return false
	end
	
	if self.floorDragStartX then
		if key == "escape" then
			self:clearFloorDragArea()
			self:clearDragRenderBounds()
			
			self.holdingDown = false
			
			return true
		end
		
		return false
	end
	
	if studioExpansion.DEMOLISH_KEYS[key] then
		if not self.movedObject then
			self:setDemolishing(not self.demolishing)
		end
		
		return true
	else
		local switchToConstructionMode = studioExpansion.DEMOLITION_MODE_KEYS[key]
		
		if switchToConstructionMode then
			if not self.movedObject and not self.holdingDown then
				self:setDemolitionMode(switchToConstructionMode)
			end
			
			return true
		end
		
		if self.movedObject then
			if key == studioExpansion.SELL_MOVING_OBJECT_KEY then
				self:sellMovedObject()
				
				return true
			elseif key == studioExpansion.CANCEL_MOVING_OBJECT_KEY then
				self:cancelMovingObject()
				
				return true
			end
		end
	end
	
	if key == "escape" then
		self:attemptLeave()
		
		return true
	end
	
	return false
end

function studioExpansion:attemptPurchaseRow(row)
	local rowData = self.validRows[row.rowID]
	local tiles = rowData.tiles
	
	if self:canAffordRow(tiles) then
		game.worldObject:removeDecorWithinAABB(row.minX * self.tileW, row.minY * self.tileH, (row.maxX - row.minX + 1) * self.tileW, (row.maxY - row.minY + 1) * self.tileH)
		self:buyRow(rowData, row.rowID)
		
		return true
	end
	
	return false
end

function studioExpansion:handleClick(x, y, key, xVel, yVel)
	if gui:isLimitingClicks() then
		return 
	end
	
	if self.expanding then
		local row
		
		if not self.movedObject then
			row = self:getMouseRow()
		end
		
		if row then
			if key == gui.mouseKeys.LEFT and self.rowExpansionElement then
				self.rowExpansionElement:increasePurchaseState()
			end
		elseif not self.demolishing and self:canPerformModeAction(studioExpansion.CONSTRUCTION_MODE.FLOORS) and key == gui.mouseKeys.LEFT then
			local singleTile = false
			
			for keyID, state in pairs(studioExpansion.SINGLE_FLOOR_PLACEMENT_KEYS) do
				if love.keyboard.isDown(keyID) then
					singleTile = true
				end
			end
			
			if singleTile then
				local x, y = self.grid:getMouseTileCoordinates()
				
				return self:attemptSetTile(x, y, camera:getViewFloor(), self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.FLOORS), false)
			else
				return self:attemptDragTile()
			end
		elseif self:canPerformModeAction(studioExpansion.CONSTRUCTION_MODE.WALLS) then
			if key == gui.mouseKeys.RIGHT then
				self.demolishHold = true
				self.demolitionMode = studioExpansion.CONSTRUCTION_MODE.WALLS
				
				self:attemptInteractWall(camera:getViewFloor())
				
				return true
			elseif yVel < 0 then
				self:cycleWallRotation()
				
				return true
			elseif yVel > 0 then
				self:cycleWallRotation(true)
				
				return true
			elseif key == gui.mouseKeys.LEFT then
				self.demolishHold = false
				
				self:attemptInteractWall(camera:getViewFloor())
				
				return true
			end
		elseif self:canPerformModeAction(studioExpansion.CONSTRUCTION_MODE.OBJECTS) then
			local movObj = self.movedObject
			
			if not movObj then
				local demolishObject = self:getDemolishObject()
				
				if demolishObject and key == gui.mouseKeys.LEFT then
					self:startMoveCountdown(demolishObject)
					
					self.placingObject = true
					
					return true
				end
			end
			
			if self.demolishing then
				if movObj and yVel ~= 0 then
					return self:changeObjectRotation(key, yVel, movObj)
				end
				
				if yVel < 0 then
					if not movObj then
						return objectSelector:cycleInteractionObject(-1)
					end
				elseif yVel > 0 then
					if not movObj then
						return objectSelector:cycleInteractionObject(1)
					end
				else
					self.placingObject = true
				end
			else
				if yVel < 0 then
					if objectSelector:cycleInteractionObject(-1) then
						return true
					end
				elseif yVel > 0 then
					if objectSelector:cycleInteractionObject(1) then
						return true
					end
				else
					self.placingObject = true
				end
				
				if yVel ~= 0 then
					return self:changeObjectRotation(key, yVel, movObj or self:getPurchaseObject())
				end
			end
		end
	end
end

function studioExpansion:handleClickRelease(x, y, key)
	if self.expanding then
		local modes = studioExpansion.CONSTRUCTION_MODE
		
		if self:canPerformModeAction(modes.FLOORS) then
			if self.floorDragStartX then
				if key == gui.mouseKeys.LEFT then
					self:attemptSetTile()
				elseif key == gui.mouseKeys.RIGHT then
					self:clearFloorDragArea()
					self:clearDragRenderBounds()
				end
			end
		elseif self:canPerformModeAction(modes.WALLS) and self.holdingDown and key == gui.mouseKeys.RIGHT then
			self.demolishHold = false
		elseif self:canPerformModeAction(modes.OBJECTS) then
			if self.moveObjectTimed then
				self:stopMoveCountdown()
				self:verifyPlaceObjectSprites()
			end
			
			if self.placingObject then
				self.placingObject = false
				
				if camera:getTraveledMagnitude() < studioExpansion.MAX_CAMERA_PAN_FOR_PLACEMENT then
					if self.demolishing then
						if self.movedObject then
							if key == gui.mouseKeys.LEFT then
								return self:attemptBuyObject(self.movedObject)
							end
							
							return self:changeObjectRotation(key, nil, self.movedObject)
						else
							local object = self:getDemolishObject()
							
							if object then
								if key == gui.mouseKeys.RIGHT and object:canSell() then
									return self:sellObject(object)
								elseif key == gui.mouseKeys.LEFT and object:canMove() then
									return self:startMovingObject(object)
								end
							end
						end
					else
						local object = self:getPurchaseObject()
						
						if key == gui.mouseKeys.LEFT then
							return self:attemptBuyObject(object)
						end
						
						return self:changeObjectRotation(key, nil, object)
					end
				end
			end
		end
		
		self.holdingDown = false
	end
end

function studioExpansion:changeObjectRotation(key, yVel, object)
	if not object:canRotate() then
		return false
	end
	
	if key == gui.mouseKeys.RIGHT then
		object:cycleRotation(false)
		self:setRotation(object:getRotation())
		
		return true
	elseif yVel then
		if yVel < 0 then
			object:cycleRotation()
			
			return true
		elseif yVel > 0 then
			object:cycleRotation(true)
			self:setRotation(object:getRotation())
			
			return true
		end
	end
	
	return false
end

function studioExpansion:updateRoomTiles(x, y, floorID, new, referenceRoomTiles, iterationFunction, blockedByObjectCallback)
	table.clear(self.enclosedTiles)
	self:findEnclosedTiles(x, y, floorID, iterationFunction, blockedByObjectCallback)
	
	if new then
		if referenceRoomTiles then
			for tile, state in pairs(referenceRoomTiles) do
				if self.enclosedTiles[tile] then
					return self.enclosedTiles
				end
			end
		end
		
		local newList = {}
		
		for tile, state in pairs(self.enclosedTiles) do
			newList[tile] = true
		end
		
		return newList
	end
	
	return self.enclosedTiles
end

local function dummyIterationFunction()
end

local function dummyBlockedByObject(rotationOfObject, blockerObject)
end

local blockedDirections = {}

function studioExpansion:findEnclosedTiles(x, y, floorID, iterationFunction, blockedByObject)
	local grid = self.grid
	local objectGrid = game.worldObject:getObjectGrid()
	
	iterationFunction = iterationFunction or dummyIterationFunction
	blockedByObject = blockedByObject or dummyBlockedByObject
	
	table.clear(self.openTiles)
	
	self.openTiles[#self.openTiles + 1] = grid:getTileIndex(x, y)
	
	while #self.openTiles > 0 do
		local key = #self.openTiles
		local index = self.openTiles[key]
		
		self.openTiles[key] = nil
		
		if studio:hasBoughtTile(index) and not self.enclosedTiles[index] then
			local x, y = objectGrid:convertIndexToCoordinates(index)
			
			self.enclosedTiles[index] = true
			
			iterationFunction(index, blockedDirections)
			
			local objects = objectGrid:getObjects(x, y, floorID)
			
			if objects then
				for key, object in ipairs(objects) do
					if object:getEnclosesTile() then
						local objectRotation = object:getRotation()
						
						blockedByObject(objectRotation, object)
						
						break
					end
				end
			end
			
			for rotation, data in pairs(walls.DIRECTION) do
				local behind = walls.INVERSE_RELATION[rotation]
				local direction = walls.DIRECTION[rotation]
				local nextTile = grid:getTileIndex(x + direction[1], y + direction[2])
				local wallID = grid:getWallID(index, floorID, rotation)
				
				if not self.enclosedTiles[nextTile] and walls:canPassThrough(wallID) then
					local objects = objectGrid:getObjectsFromIndex(nextTile, floorID)
					
					if objects then
						for key, object in ipairs(objects) do
							if object:getEnclosesTile() then
								local objectRotation = object:getRotation()
								
								if objectRotation == walls.INVERSE_RELATION[rotation] then
									blockedByObject(objectRotation, object)
								end
							end
						end
					end
					
					if not walls:enclosesTile(wallID) then
						self.openTiles[#self.openTiles + 1] = nextTile
					end
				end
			end
			
			table.clear(blockedDirections)
		end
	end
end

function studioExpansion:getEnclosedTiles()
	return self.enclosedTiles
end

function studioExpansion:attemptSetTile(x, y, floor, purchaseID, muteSound)
	if not x then
		x, y = self.grid:getMouseTileCoordinates()
	end
	
	purchaseID = purchaseID or self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.FLOORS)
	
	if self.floorDragStartX then
		if not self:canAffordDrag() then
			self:clearFloorDragArea()
			self:clearDragRenderBounds()
		else
			local x1, y1, x2, y2 = self.floorDragStartX, self.floorDragStartY, self.floorDragFinishX, self.floorDragFinishY
			local dragID = self.floorDragID
			
			self:clearFloorDragArea()
			self:clearDragRenderBounds()
			
			local success = false
			local floor = camera:getViewFloor()
			
			for y = y1, y2 do
				for x = x1, x2 do
					local successful = self:attemptSetTile(x, y, floor, purchaseID, true)
					
					if successful then
						success = true
					end
				end
			end
			
			if success then
				local midX, midY = math.lerp(x1, x2, 0.5), math.lerp(y1, y2, 0.5)
				local worldX, worldY = game.worldObject:getFloorTileGrid():gridToWorld(midX, midY)
				
				sound:play("place_floor", nil, worldX, worldY)
			end
		end
	elseif self:canPlaceTile(x, y, camera:getViewFloor()) and studio:canAffordTile(purchaseID) then
		studio:buyTile(x, y, floor, false, purchaseID)
		
		self.holdingDown = true
		
		if not muteSound then
			local worldX, worldY = game.worldObject:getFloorTileGrid():gridToWorld(x, y)
			
			sound:play("place_floor", nil, worldX, worldY)
		end
		
		events:fire(studioExpansion.EVENTS.BOUGHT_TILE)
		
		return true
	end
end

function studioExpansion:canAffordDrag()
	return studio:hasFunds(self.dragCost)
end

function studioExpansion:setDragCost(cost)
	self.dragCost = cost
	self.dragCostText = string.easyformatbykeys(_T("DRAG_PLACEMENT_COST", "$COST"), "COST", cost)
	self.dragCostTextWidth = self.font:getWidth(self.dragCostText)
end

function studioExpansion:attemptDragTile()
	local x, y = self.grid:getMouseTileCoordinates()
	
	if not self:canPlaceTile(x, y, camera:getViewFloor()) then
		return false
	end
	
	self:setFloorDragBounds(x, y)
	
	self.floorDragID = self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.FLOORS)
	
	self:setDragRenderBounds(self.floorDragStartX, self.floorDragStartY, self.floorDragFinishX, self.floorDragFinishY)
	self:setDragCost(self:getTileDragCost())
	
	self.holdingDown = true
	
	return true
end

function studioExpansion:getTileDragCost()
	local totalCost = 0
	local tileCost = studio:getTileCost(nil, self.floorDragID)
	local floor = camera:getViewFloor()
	
	for y = self.floorDragStartY, self.floorDragFinishY do
		for x = self.floorDragStartX, self.floorDragFinishX do
			if self:canPlaceTile(x, y, floor) then
				totalCost = totalCost + tileCost
			end
		end
	end
	
	return totalCost
end

function studioExpansion:updateDragTile()
	self:setFloorDragBounds(self.grid:getMouseTileCoordinates())
	self:setDragRenderBounds(self.floorDragStartX, self.floorDragStartY, self.floorDragFinishX, self.floorDragFinishY)
	self:setDragCost(self:getTileDragCost())
end

function studioExpansion:setFloorDragBounds(x, y)
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
end

function studioExpansion:setDragRenderBounds(startX, startY, endX, endY)
	local x, y, w, h = math.min(startX, endX), math.min(startY, endY), math.max(startX, endX), math.max(startY, endY)
	local width, height = math.dist(x, w), math.dist(y, h)
	
	self.dragRenderStartX = (x - 1) * game.WORLD_TILE_WIDTH
	self.dragRenderStartY = (y - 1) * game.WORLD_TILE_HEIGHT
	self.dragRenderWidth = (width + 1) * game.WORLD_TILE_WIDTH
	self.dragRenderHeight = (height + 1) * game.WORLD_TILE_HEIGHT
end

function studioExpansion:isDemolishing()
	return self.demolishing
end

function studioExpansion:getDemolishObject()
	return objectSelector:getCurrentInteractableObject()
end

function studioExpansion:cycleInteractionObject(direction)
	if #self.interactableObjectList == 0 then
		return 
	end
	
	self.objectIndex = self.objectIndex + direction
	
	if self.objectIndex <= 0 then
		self.objectIndex = #self.interactableObjectList
	elseif self.objectIndex > #self.interactableObjectList then
		self.objectIndex = 1
	end
	
	events:fire(studioExpansion.EVENTS.OBJECT_SELECTION_CYCLED, direction)
end

function studioExpansion:getObjectsAttachedToWall(index, floor, rotation, destinationList)
	local direction = walls.DIRECTION[rotation]
	
	self:_getObjectsAttachedToWall(self.objectGrid:offsetIndex(index, direction[1], direction[2]), floor, walls.INVERSE_RELATION[rotation], destinationList)
	self:_getObjectsAttachedToWall(index, floor, rotation, destinationList)
	
	return destinationList
end

function studioExpansion:_getObjectsAttachedToWall(index, floor, rotation, destinationList)
	local objects = self.objectGrid:getObjectsFromIndex(index, floor)
	
	if objects then
		for key, object in ipairs(objects) do
			if object.requiresWallInFront and object:getRotation() == rotation then
				destinationList[#destinationList + 1] = object
			end
		end
	end
end

local objectsToSell = {}

function studioExpansion:updateSurroundingObjectSpritebatches(x, y, floor, rotation)
	self:_updateSurroundingObjectSpritebatches(x, y, floor)
	
	local direction = walls.DIRECTION[rotation]
	
	self:_updateSurroundingObjectSpritebatches(x + direction[1], y + direction[2], floor)
end

function studioExpansion:_updateSurroundingObjectSpritebatches(x, y, floor)
	local objects = self.objectGrid:getObjects(x, y, floor)
	
	if objects then
		for key, object in ipairs(objects) do
			object:updateSpritebatches()
		end
	end
end

function studioExpansion:createSmokeParticle(x, y, depth)
	local system = particleSystem.instantiate("interaction_smoke", depth)
	
	system:setPosition(x, y)
	system:emitSprites(1, true)
	system.particleSystem:setDirection(math.rad(math.random(0, 360)))
end

function studioExpansion:attemptInteractWall(floor, repeatPurchase)
	local x, y = self.grid:getMouseTileCoordinates()
	local rotationID = self.rotationID
	
	if repeatPurchase then
		local direction = walls.DIRECTION[self.rotationID]
		
		x, y = x + direction[1], y + direction[2]
		rotationID = walls.INVERSE_RELATION[rotationID]
	end
	
	if self.demolishing or self.demolishHold then
		local index = self.grid:getTileIndex(x, y)
		
		if studio:canDemolishWall(index, floor, rotationID) then
			studio:demolishWall(index, floor, rotationID)
			
			local grid = self.grid
			local offset = walls.DIRECTION[rotationID]
			local xOff = 20 * offset[1]
			local yOff = 20 * offset[2]
			local smokeDepth = studioExpansion.SMOKE_DEPTH
			
			for i = 1, studioExpansion.WALL_SMOKE_PARTICLE_COUNT do
				local worldX, worldY = grid:gridToWorld(x, y)
				
				self:createSmokeParticle(worldX + math.random(-10, 10) + xOff, worldY + math.random(-10, 10) + yOff, smokeDepth)
			end
			
			local worldX, worldY = game.worldObject:getFloorTileGrid():gridToWorld(x, y)
			
			sound:play("break_wall", nil, worldX, worldY)
			self:updateSurroundingObjectSpritebatches(x, y, floor, rotationID)
			
			self.holdingDown = true
			
			local objects = self:getObjectsAttachedToWall(index, floor, rotationID, objectsToSell)
			
			if #objects > 0 then
				for key, object in ipairs(objects) do
					object:sell()
				end
			end
			
			table.clearArray(objectsToSell)
			studio:reevaluateOffice(nil, studio:getOfficeAtIndex(index), floor)
			studio:getBrightnessMap():updateLightSourcesOnIndex(index, floor)
			events:fire(studioExpansion.EVENTS.REMOVED_WALL, index, rotationID)
			
			return true
		end
	else
		local purchaseID = self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.WALLS)
		
		if repeatPurchase or self:canPlaceWall(x, y, rotationID) and studio:canAffordWall(purchaseID) then
			local grid = game.worldObject:getFloorTileGrid()
			local index = self.grid:getTileIndex(x, y)
			local previousBothSides, shouldPlaceBothSides
			local offset = walls.DIRECTION[rotationID]
			
			if not repeatPurchase then
				previousBothSides = walls.registeredByID[grid:getWallID(index, floor, rotationID)].bothSides
				shouldPlaceBothSides = previousBothSides or walls.registeredByID[purchaseID].bothSides
				
				local xOff = 20 * offset[1]
				local yOff = 20 * offset[2]
				
				for i = 1, studioExpansion.WALL_SMOKE_PARTICLE_COUNT do
					local worldX, worldY = grid:gridToWorld(x, y)
					local system = particleSystem.instantiate("interaction_smoke", studioExpansion.SMOKE_DEPTH)
					
					system:setPosition(worldX + math.random(-10, 10) + xOff, worldY + math.random(-10, 10) + yOff)
					system:emitSprites(1, true)
					system.particleSystem:setDirection(math.rad(math.random(0, 360)))
				end
			end
			
			studio:buyWall(index, floor, rotationID, purchaseID, repeatPurchase, not (not shouldPlaceBothSides and grid:getWallID(grid:offsetIndex(index, offset[1], offset[2]), floor, walls.INVERSE_RELATION[rotationID]) ~= 0) and 1 or 0.5)
			
			self.holdingDown = true
			
			local worldX, worldY = grid:gridToWorld(x, y)
			
			if not repeatPurchase then
				sound:play("place_wall", nil, worldX, worldY)
				self:updateSurroundingObjectSpritebatches(x, y, floor, rotationID)
			end
			
			local office = studio:getOfficeAtIndex(index)
			
			if office then
				studio:reevaluateOffice(nil, office, floor)
			end
			
			if studio:hasBoughtTile(index) then
				studio:getBrightnessMap():updateLightSourcesOnIndex(index)
			end
			
			events:fire(studioExpansion.EVENTS.BOUGHT_WALL, index, rotationID)
			
			if not repeatPurchase then
				if shouldPlaceBothSides then
					self:attemptInteractWall(floor, true)
				end
				
				game.sendGridUpdateToThreads(grid, pathfinderThread.MESSAGE_TYPE.GRID_UPDATE, x, y, x, y, floor, nil)
			end
			
			return true
		end
	end
end

function studioExpansion:attemptBuyObject(object)
	if self:canPlaceObject(object, true) then
		local oldOffice = self.movedObject and self.movedObject:getOffice()
		local newObject = self:placeObject(object, self.movedObject ~= nil)
		
		if newObject then
			local floor, prevFloor = newObject:getFloor()
			local purchased = false
			
			if not self.movedObject then
				purchased = true
				
				newObject:onPurchased()
			else
				prevFloor = self.movedObjectFloor
				
				self:finishMovingObject()
			end
			
			local x, y, w, h = newObject:getUsedTiles()
			local midX, midY = math.lerp(x, w, 0.5), math.lerp(y, h, 0.5)
			local grid = game.worldObject:getFloorTileGrid()
			local worldX, worldY = grid:gridToWorld(midX, midY)
			
			if newObject:canShowPlacementSmoke() then
				local tileW, tileH = newObject:getTileSize()
				
				if tileW == 1 and tileH == 1 then
					local system = particleSystem.instantiate("object_placement_dust", studioExpansion.SMOKE_DEPTH)
					
					system:setPosition(worldX - game.WORLD_TILE_WIDTH * 0.9, worldY - game.WORLD_TILE_HEIGHT * 0.9)
					system:emitSprites(1, true)
				else
					for i = 1, studioExpansion.SMOKE_PARTICLE_COUNT * tileW * tileH do
						local worldX, worldY = grid:gridToWorld(math.random(x, w), math.random(y, h))
						local system = particleSystem.instantiate("interaction_smoke", studioExpansion.SMOKE_DEPTH)
						
						system:setPosition(worldX + math.random(-30, 30), worldY + math.random(-30, 30))
						system:emitSprites(1, true)
						system.particleSystem:setDirection(math.rad(math.random(0, 360)))
					end
				end
			end
			
			sound:play("place_object", nil, worldX, worldY)
			newObject:playPurchaseSound(worldX, worldY)
			
			local rotation = object:getRotation()
			local newOffice = newObject:getOffice()
			
			if oldOffice and oldOffice ~= newOffice then
				if self.evalFloorStart then
					local start = math.min(self.evalFloorStart, prevFloor)
					
					self.evalFloorStart = nil
					
					oldOffice:addToFloorReevalQueue(start - 1)
					oldOffice:attemptUseEvalQueue()
				else
					studio:reevaluateOffice(nil, oldOffice, prevFloor)
				end
			end
			
			if self.evalFloorStart then
				local start = math.min(self.evalFloorStart, floor)
				
				self.evalFloorStart = nil
				
				newOffice:addToFloorReevalQueue(start - 1)
				newOffice:attemptUseEvalQueue()
			else
				studio:reevaluateOffice(nil, newOffice, floor)
			end
			
			events:fire(studioExpansion.EVENTS.PLACED_OBJECT, newObject, purchased)
			events:fire(studioExpansion.EVENTS.POST_PLACED_OBJECT, newObject)
			
			local wasUpdate = false
			
			if oldOffice then
				if oldOffice ~= newOffice then
					oldOffice:updateMonthlyCosts(prevFloor)
					
					wasUpdate = true
				end
				
				newOffice:updateMonthlyCosts(floor)
			else
				newOffice:updateMonthlyCosts(floor)
			end
			
			if wasUpdate then
				studio:updateMonthlyCosts(floor)
			end
			
			return true
		end
	end
	
	return false
end

function studioExpansion:handleMouseDrag(dx, dy)
	if self.holdingDown then
		if not self.demolishing and self.constructionMode == studioExpansion.CONSTRUCTION_MODE.FLOORS then
			if self.floorDragStartX then
				self:updateDragTile()
			else
				local x, y = self.grid:getMouseTileCoordinates()
				
				return self:attemptSetTile(x, y, camera:getViewFloor(), self:getPurchaseID(studioExpansion.CONSTRUCTION_MODE.FLOORS), false)
			end
		elseif self.constructionMode == studioExpansion.CONSTRUCTION_MODE.WALLS or self.demolitionMode == studioExpansion.CONSTRUCTION_MODE.WALLS and self.demolishHold then
			return self:attemptInteractWall(camera:getViewFloor())
		end
	end
end

function studioExpansion:getExpandingRow(row, direction)
	local boughtTiles = studio:getBoughtTiles()
	local grid = game.worldObject:getFloorTileGrid()
	local expandingRow = {}
	local offset = walls.DIRECTION[walls.INVERSE_RELATION[direction]]
	local offX, offY = offset[1], offset[2]
	
	for key, index in ipairs(row) do
		expandingRow[#expandingRow + 1] = grid:offsetIndex(index, offX, offY)
	end
	
	return expandingRow
end

studioExpansion.foundValidRooms = {}
studioExpansion.foundUniqueWalls = {}

function studioExpansion:buyRow(rowData, rowID)
	local row = rowData.tiles
	local direction = rowData.direction
	local indexesToClear = self:getExpandingRow(row, direction)
	local grid = game.worldObject:getFloorTileGrid()
	local expandDir = walls.DIRECTION[direction]
	local expandX, expandY = expandDir[1], expandDir[2]
	local officeObject = self.buildingsByRows[rowID]
	
	officeObject:logExpansion(direction)
	
	local uniqWalls = self.foundUniqueWalls
	local floorCount = officeObject:getPurchasedFloors()
	
	for i = 1, floorCount do
		for key, index in ipairs(row) do
			local offsetIndex = grid:offsetIndex(index, -expandX, -expandY)
			
			if studio:hasBoughtTile(offsetIndex) then
				local id = grid:getWallID(offsetIndex, i, direction)
				
				if id ~= 0 and id ~= studio.DEFAULT_BORDER_WALL_ID then
					table.insert(uniqWalls, {
						index = index,
						id = id
					})
				end
			end
		end
		
		studio:clearBorderTileWalls(indexesToClear, direction, i)
		
		local objectGrid = game.worldObject:getObjectGrid()
		
		for key, index in ipairs(row) do
			local x, y = grid:convertIndexToCoordinates(index)
			
			for i = 1, studioExpansion.WALL_SMOKE_PARTICLE_COUNT do
				local worldX, worldY = grid:gridToWorld(x, y)
				local system = particleSystem.instantiate("interaction_smoke", studioExpansion.SMOKE_DEPTH)
				
				system:setPosition(worldX + math.random(-10, 10), worldY + math.random(-10, 10))
				system:emitSprites(1, true)
				system.particleSystem:setDirection(math.rad(math.random(0, 360)))
			end
			
			local objects = objectGrid:getObjectsFromIndex(index, i)
			
			if objects then
				for key, object in ipairs(objects) do
					object:setGridUpdateState(false)
					object:remove()
				end
			end
			
			officeObject:addTileIndex(index)
			studio:buyTile(x, y, i, false, 2, true)
		end
		
		officeObject:updateMonthlyCosts(i)
		officeObject:fillBorderWalls(nil, i)
		officeObject:fillRoofTileIndexes()
		
		if #uniqWalls > 0 then
			for key, data in ipairs(uniqWalls) do
				grid:replaceWall(data.index, i, data.id, direction)
				
				uniqWalls[key] = nil
			end
		end
	end
	
	lightingManager:sendInLoad(lightingManager.MESSAGE_TYPE.OFFICE_TILE_UPDATE, row)
	studio:updateMonthlyCosts()
	gameStateService:removeState(self.spriteUpdateState)
	self:updatePurchasableRows()
	
	for key, index in ipairs(row) do
		local x, y = grid:convertIndexToCoordinates(index)
		
		for i = 1, floorCount do
			game.sendGridUpdateToThreads(game.worldObject:getFloorTileGrid(), pathfinderThread.MESSAGE_TYPE.GRID_UPDATE, x, y, x, y, i, true)
		end
	end
	
	for i = 1, floorCount do
		studio:updateRooms(nil, officeObject, i)
	end
	
	events:fire(studioExpansion.EVENTS.EXPANDED_OFFICE, officeObject)
end

studioExpansion.evaluationOpen = {}
studioExpansion.evaluationClosed = {}
studioExpansion.evaluatedObjects = {}
studioExpansion.evaluatedObjectsMap = {}

function studioExpansion:evaluateReach(officeObject, floor)
	table.clear(self.evaluationClosed)
	
	self.ownedTiles = officeObject:getTileIndexes()
	
	local entryObject, entryX, entrY
	
	if floor == 1 then
		entryObject = officeObject:getMainDoor()
		entryX, entryY = entryObject:getTileCoordinates()
	else
		entryObject = officeObject:getStaircaseDown(floor)
		
		if entryObject then
			if not entryObject:isValidForInteraction() then
				for key, obj in ipairs(officeObject:getObjectsByFloor(floor)) do
					obj:setReachable(false)
				end
				
				return 
			end
			
			if entryObject:getFloor() == floor then
				entryX, entryY = entryObject:getEntranceCoordinates()
			else
				entryX, entryY = entryObject:getTransitionCoordinates()
			end
		end
	end
	
	local objList = officeObject:getObjectsByFloor(floor)
	
	if not entryObject then
		for key, object in ipairs(objList) do
			object:setReachable(false)
		end
		
		return 
	end
	
	self.evaluationOpen[#self.evaluationOpen + 1] = self.grid:getTileIndex(entryX, entryY)
	
	for key, object in ipairs(objList) do
		if object:getFloor() == floor then
			object:setReachable(false)
		end
	end
	
	if floor == 1 then
		entryObject:setReachable(true)
	end
	
	while #self.evaluationOpen > 0 do
		local pos = #self.evaluationOpen
		local topTile = self.evaluationOpen[pos]
		
		self.evaluationOpen[pos] = nil
		
		for key, tileID in ipairs(walls.ORDER) do
			self:attemptFloodTile(topTile, tileID, floor)
		end
		
		self.evaluationClosed[topTile] = true
	end
	
	for key, object in ipairs(self.evaluatedObjects) do
		object:setReachable(true)
		
		self.evaluatedObjects[key] = nil
		self.evaluatedObjectsMap[object] = nil
	end
	
	self:cleanupEvaluation()
end

function studioExpansion:checkOfficeValidity(officeObject)
	for key, employee in ipairs(officeObject:getEmployees()) do
		local workplace = employee:getWorkplace()
		
		if workplace and workplace:isReachable() then
			local room = employee:getCurrentWalkRoom()
			
			if room then
				if workplace:getFloor() == 1 then
					if room and room:getEntryPointCount() == 0 then
						employee:returnToWorkplace()
					end
				else
					local stairDown = room:getStaircaseDown()
					
					if stairDown and stairDown:getRoom() == room then
						if not stairDown:isValidForInteraction() then
							employee:returnToWorkplace()
						end
					elseif room and room:getEntryPointCount() == 0 then
						employee:returnToWorkplace()
					end
				end
			end
		end
	end
end

function studioExpansion:isTileReachable(index)
	return self.evaluationClosed[index]
end

function studioExpansion:getTileReachMap()
	return self.evaluationClosed
end

function studioExpansion:cleanupEvaluation()
	table.clearArray(self.evaluationOpen)
	table.clearArray(self.evaluatedObjects)
	table.clear(self.evaluatedObjectsMap)
end

function studioExpansion:attemptFloodTile(index, rotation, floorID)
	local x, y = self.grid:convertIndexToCoordinates(index)
	local offset = walls.DIRECTION[rotation]
	local offX, offY = x + offset[1], y + offset[2]
	local offsetIndex = self.grid:getTileIndex(offX, offY)
	
	if self.ownedTiles[offsetIndex] and not self.evaluationClosed[offsetIndex] and walls:canPassThrough(self.grid:getWallID(index, floorID, rotation)) then
		local objects = self.objectGrid:getObjects(offX, offY, floorID)
		local canContinue = true
		
		if objects then
			for key, object in ipairs(objects) do
				if object:getPreventsReach() then
					canContinue = false
				end
				
				if not self.evaluatedObjectsMap[object] and object:validateReach(offX, offY) then
					self.evaluatedObjects[#self.evaluatedObjects + 1] = object
					self.evaluatedObjectsMap[object] = true
				end
			end
		end
		
		if canContinue then
			self.evaluationOpen[#self.evaluationOpen + 1] = offsetIndex
		end
		
		return canContinue
	end
end

function studioExpansion:getTileRowInDirection(x, y, dirX, dirY, searchX, searchY, offsetX, offsetY, floor)
	local lastX, lastY = self:findLastTile(x, y, dirX, dirY, floor)
	
	lastX, lastY = self:findLastTile(lastX, lastY, -offsetX, -offsetY, floor)
	lastX, lastY = lastX + dirX, lastY + dirY
	
	if lastX < studioExpansion.EXPANSION_BORDER or lastX > game.WORLD_WIDTH - studioExpansion.EXPANSION_BORDER or lastY > game.WORLD_HEIGHT - studioExpansion.EXPANSION_BORDER then
		return nil
	end
	
	local row = {}
	local grid = game.worldObject:getFloorTileGrid()
	local purchasedTiles = studio:getBoughtTiles()
	
	while true do
		local index = grid:getTileIndex(lastX + searchX, lastY + searchY)
		
		if not grid:outOfBounds(lastX, lastY) and not grid:outOfBounds(lastX + searchX, lastY + searchY) and not grid:isTileEmpty(index, floor) and purchasedTiles[index] then
			row[#row + 1] = grid:getTileIndex(lastX, lastY)
		else
			break
		end
		
		lastX = lastX + offsetX
		lastY = lastY + offsetY
	end
	
	return row
end

function studioExpansion:isInObjectBounds(curX, curY, xMin, xMax, yMin, yMax)
	if curX < xMin or xMax < curX or curY < yMin or yMax < curY then
		return false
	end
	
	return true
end

function studioExpansion:isTileValidForObject(curX, curY, xMin, xMax, yMin, yMax, floor)
	local grid = self.grid
	local wallContents = grid:getWallContents(grid:getTileIndex(curX, curY), floor)
	
	for key, rotation in ipairs(walls.ROTATION_NUMBERS) do
		local offset = walls.DIRECTION[rotation]
		local x, y = curX + offset[1], curY + offset[2]
		
		if self:isInObjectBounds(x, y, xMin, xMax, yMin, yMax) and bit.band(wallContents, rotation) == rotation then
			return false
		end
	end
	
	return true
end

function studioExpansion:canAffordObject(object)
	return studio:getFunds() >= object:getCost()
end

function studioExpansion:verifyWall(x, y, floor, rotation)
	local index = self.grid:getTileIndex(x, y)
	local wallID = self.grid:getWallID(index, floor, rotation)
	local wallData = walls.registeredByID[wallID]
	
	if not wallData or wallData.canPassThrough then
		self.invalidTiles[index] = true
		
		return false
	end
	
	return true
end

function studioExpansion:checkObjectDirectionBlock(object, direction)
	return not object.requiresNoWallInDirection or direction ~= object:getRotation()
end

function studioExpansion:canPlaceObject(object)
	table.clear(self.invalidTiles)
	
	local rotation = object:getRotation()
	local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getPlacementCoordinates()
	local floor = camera:getViewFloor()
	
	if self.movedObject and self.movedObjectRotation == rotation and self.movedObjectFloor == floor and startX == self.movedObjectX and startY == self.movedObjectY then
		return true
	end
	
	local grid = self.grid
	local objectGrid = game.worldObject:getObjectGrid()
	local canPlace = true
	local diffFloorInvalid = false
	local placeOnTopObject
	local ownHeight = object:getPlacementHeight()
	local invalidTiles = self.invalidTiles
	local startFloor, finFloor = object:getFloorCheckRange(floor)
	local buildingTiles = studio:getOfficeBuildingMap():getTileIndexes()
	
	for y = startY, endY do
		for x = startX, endX do
			for i = startFloor, finFloor do
				local objects = objectGrid:getObjects(x, y, i)
				
				if objects then
					for key, otherObject in ipairs(objects) do
						if otherObject:getPlacementHeight() == ownHeight then
							if not otherObject:canPlaceOnTop(object) or not self:checkObjectDirectionBlock(otherObject, rotation) then
								local index = grid:getTileIndex(x, y)
								
								invalidTiles[index] = true
								canPlace = false
								
								if i ~= floor and buildingTiles[index] and buildingTiles[index]:isPlayerOwned() then
									diffFloorInvalid = i
								end
								
								break
							else
								object:onCanPlace(otherObject)
							end
						end
					end
				end
			end
		end
	end
	
	if not object:canPlace(startX, startY, endX, endY, invalidTiles) then
		for y = startY, endY do
			for x = startX, endX do
				local index = self.grid:getTileIndex(x, y)
				
				invalidTiles[index] = true
				canPlace = false
			end
		end
	end
	
	if object.inheritFrontObjectRotation then
		local startX, finishX, startY, finishY = object:getBorderTiles()
		
		for y = startY, finishY do
			for x = startX, finishX do
				local objects = objectGrid:getObjects(x, y, floor)
				
				if objects then
					for key, otherObject in ipairs(objects) do
						if otherObject:getPlacementHeight() == ownHeight and object:canInheritAboveObjectRotation(otherObject) then
							object:setRotation(otherObject:getRotation())
							
							break
						end
					end
				end
			end
		end
	end
	
	local rotation = object:getRotation()
	local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getPlacementCoordinates()
	
	for y = startY, endY do
		for x = startX, endX do
			for i = startFloor, finFloor do
				if object.requiresWallBehind then
					local behind = walls.INVERSE_RELATION[rotation]
					
					if not self:verifyWall(x, y, i, behind) then
						canPlace = false
						
						if i ~= floor and buildingTiles[index] and buildingTiles[index]:isPlayerOwned() then
							diffFloorInvalid = i
						end
					end
				end
				
				if object.requiresWallInFront and not self:verifyWall(x, y, i, rotation) then
					canPlace = false
					
					if i ~= floor and buildingTiles[index] and buildingTiles[index]:isPlayerOwned() then
						diffFloorInvalid = i
					end
				end
				
				if not object:canAddToTile(x, y, nil, i) then
					local index = grid:getTileIndex(x, y)
					
					invalidTiles[index] = true
					canPlace = false
					
					if i ~= floor and buildingTiles[index] and buildingTiles[index]:isPlayerOwned() then
						diffFloorInvalid = i
					end
				end
				
				if not self:isTileValidForObject(x, y, startX, endX, startY, endY, i) then
					local index = grid:getTileIndex(x, y)
					
					invalidTiles[index] = true
					canPlace = false
					
					if i ~= floor and buildingTiles[index] and buildingTiles[index]:isPlayerOwned() then
						diffFloorInvalid = i
					end
				end
			end
		end
	end
	
	if not object.entranceDisplayOnly then
		for y = entranceStartY, entranceEndY do
			for x = entranceStartX, entranceEndX do
				for i = startFloor, finFloor do
					local index = grid:getTileIndex(x, y)
					
					if self.grid:hasWall(index, i, rotation) or not object:canAddToTile(x, y, true, i) then
						invalidTiles[index] = true
						canPlace = false
						
						if i ~= floor and buildingTiles[index] and buildingTiles[index]:isPlayerOwned() then
							diffFloorInvalid = i
						end
					end
					
					local objects = objectGrid:getObjects(x, y, i)
					
					if objects and #objects > 0 then
						local tileInvalid = false
						
						for key, otherObject in ipairs(objects) do
							if otherObject:getPlacementHeight() == ownHeight and otherObject:getPreventsMovement() then
								tileInvalid = true
								
								break
							end
						end
						
						if tileInvalid then
							invalidTiles[index] = true
							canPlace = false
							
							if i ~= floor and buildingTiles[index] and buildingTiles[index]:isPlayerOwned() then
								diffFloorInvalid = i
							end
						end
					end
				end
			end
		end
	end
	
	object:setInvalidFloorPlacement(diffFloorInvalid)
	
	return canPlace, invalidTiles, placeOnTopObject
end

function studioExpansion:sellObject(x, y)
	local grid = game.worldObject:getObjectGrid()
	
	if not y then
		local officeObject = x:getOffice()
		
		x:sell()
		studio:reevaluateOffice(nil, officeObject, x:getFloor())
		events:fire(studioExpansion.EVENTS.POST_REMOVED_OBJECT, x)
		
		return true
	end
	
	local object = game.worldObject:getObjectGrid():getFirstObject(x, y)
	
	if object then
		local officeObject = object:getOffice()
		
		object:sell()
		studio:reevaluateOffice(nil, officeObject, object:getFloor())
		events:fire(studioExpansion.EVENTS.POST_REMOVED_OBJECT, object)
		
		return true
	end
	
	return false
end

function studioExpansion:placeObject(object, isFree)
	local startX, startY, endX, endY = object:getPlacementCoordinates()
	
	if not isFree and not self:canAffordObject(object) then
		if not self.noCashDisplay or not self.noCashDisplay:isValid() or self.noCashDisplay.object ~= object then
			if self.noCashDisplay and self.noCashDisplay:isValid() then
				self.noCashDisplay:kill()
			end
			
			local noCashDisplay = gui.create("TimedTextDisplay")
			
			noCashDisplay:addText(_format(_T("NO_CASH_FOR_OBJECT", "You can't afford to purchase this OBJECT."), "OBJECT", object:getName()), "bh20", game.UI_COLORS.RED, 0, 600, "wad_of_cash_minus", 24, 24)
			noCashDisplay:setDieTime(2.3)
			noCashDisplay:centerX()
			noCashDisplay:setY(scrH * 0.5 - noCashDisplay.h - _S(100))
			
			self.noCashDisplay = noCashDisplay
			self.noCashDisplay.object = object
			
			table.insert(self.displayElements, noCashDisplay)
		end
		
		return false
	end
	
	local objectGrid = game.worldObject:getObjectGrid()
	local width, height = objectGrid:getTileSize()
	local newObj = self.movedObject or objects.create(object:getClass())
	
	if not self.movedObject then
		if self.progressionLevel then
			newObj:setProgression(self.progressionLevel)
		end
		
		local cost = object:getCost(self.progressionLevel)
		
		object:createCashDisplay(-cost)
		studio:deductFunds(cost, nil, "office_expansion")
	end
	
	newObj:setRotation(object:getRotation())
	newObj:setPos(startX * width, startY * height)
	newObj:finalizeGridPlacement(nil, nil, camera:getViewFloor())
	newObj:sendGridUpdateToThreads()
	
	return newObj
end

function studioExpansion:isEntranceValid(rotation, x, y)
	if self.grid:hasWall(self.grid:getTileIndex(x, y), rotation) then
		return false
	end
end

function studioExpansion:canPerformModeAction(mode)
	return not self.demolishing and self.constructionMode == mode or self.demolishing and self.demolitionMode == mode
end

function studioExpansion:preDraw()
	if self.expanding then
		camera:unset()
		love.graphics.setColor(0, 0, 0, 50)
		love.graphics.rectangle("fill", 0, 0, scrW, scrH)
		love.graphics.setColor(255, 255, 255, 255)
		camera:set()
		
		if self:canPerformModeAction(studioExpansion.CONSTRUCTION_MODE.OBJECTS) and not self.moveTime then
			if self.demolishing then
				if self.movedObject then
					self:drawObjectSprite(self.movedObject, true)
				else
					local mouseX, mouseY = self.grid:getMouseTileCoordinates()
					local grid = game.worldObject:getObjectGrid()
					local objects = grid:getObjects(mouseX, mouseY, camera:getViewFloor())
					local demolishObject = self:getDemolishObject()
					
					if demolishObject then
						if self.curHoverObject ~= demolishObject and demolishObject:canSell() then
							self.curHoverObject = demolishObject
						end
					else
						self.curHoverObject = nil
					end
				end
			else
				self:drawObjectSprite(self:getPurchaseObject())
			end
			
			local container = self.tileSpriteBatch
			
			if not self.demolishing or self.movedObject then
				local object = self:getPurchaseObject()
				local canPlace, invalidTiles, objectToPlaceOn = self:canPlaceObject(object)
				local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getPlacementCoordinates()
				local grid = self.grid
				local tileWidth, tileHeight = self.grid:getTileSize()
				
				self.usedTileSprites = 0
				
				for y = startY, endY do
					for x = startX, endX do
						local r, g, b, a = 150, 255, 150, 255
						local index = grid:getTileIndex(x, y)
						
						if not canPlace then
							if self.invalidTiles[index] then
								r, g, b, a = 255, 150, 150, 255
							else
								r, g, b, a = 255, 225, 117, 255
							end
						end
						
						self.usedTileSprites = self.usedTileSprites + 1
						
						local spriteID = self.allocatedTileSprites[self.usedTileSprites]
						
						container:setColor(r, g, b, a)
						container:updateSprite(spriteID, studioExpansion.purchasableTileQuad, x * tileWidth - tileWidth, y * tileHeight - tileHeight, 0, 2, 2)
					end
				end
				
				local validR, validG, validB, validA = studioExpansion.validEntryTileColor:unpack()
				local invalidR, invalidG, invalidB, invalidA = studioExpansion.invalidEntryTileColor:unpack()
				local r, g, b, a
				local rotation = walls.ANGLES[object:getRotation()]
				
				object:preDrawExpansion(startX, startY, endX, endY)
				
				for y = entranceStartY, entranceEndY do
					for x = entranceStartX, entranceEndX do
						if self.invalidTiles[grid:getTileIndex(x, y)] then
							r, g, b, a = invalidR, invalidG, invalidB, invalidA
						else
							r, g, b, a = validR, validG, validB, validA
						end
						
						self.usedTileSprites = self.usedTileSprites + 1
						
						local spriteID = self.allocatedTileSprites[self.usedTileSprites]
						
						container:setColor(r, g, b, a)
						container:updateSprite(spriteID, studioExpansion.entranceDirection, x * tileWidth - tileWidth + 24, y * tileHeight - tileHeight + 24, rotation, 2, 2, 12, 12)
					end
				end
			end
		end
	end
end

function studioExpansion:drawObjectSprite(object, moving)
	local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getPlacementCoordinates()
	local x, y = self.grid:gridToWorld(startX, startY)
	
	object.visible = true
	
	if moving then
		object:onMoving(x, y)
	else
		object:onMovingPurchaseMode(x, y)
	end
end

function studioExpansion:getRowMid(data)
	local tileW, tileH = self.grid:getTileSize()
	
	return (data.minX + data.maxX) * 0.5 * tileW, (data.minY + data.maxY) * 0.5 * tileH
end

function studioExpansion:getIconMouseCoordinates()
	local mouseX, mouseY = camera:mousePosition()
	
	mouseX = (mouseX - camera.x) * camera.scaleX
	mouseY = (mouseY - camera.y) * camera.scaleY
	self.iconSine = self.iconSine + frameTime * 3
	self.iconAlpha = math.max(studioExpansion.MIN_ICON_ALPHA, self.iconAlpha - frameTime * studioExpansion.ICON_ALPHA_APPROACH_RATE)
	
	if self.iconSine > math.pi then
		self.iconSine = self.iconSine - math.pi
	end
	
	return mouseX, mouseY + math.sin(self.iconSine) * _S(8)
end

function studioExpansion:draw()
	if self.expanding then
		local floor = camera:getViewFloor()
		local mouseX, mouseY = self.grid:getMouseTileCoordinates()
		local tileW, tileH = self.grid:getTileSize()
		local grid = self.grid
		local mouseIndex = grid:getTileIndex(mouseX, mouseY)
		
		game.performMouseOverOffice(grid)
		
		local wasMouseOver = false
		local modes = studioExpansion.CONSTRUCTION_MODE
		
		if not self.movedObject then
			for key, data in ipairs(self.mergedRowCoords) do
				if self:isMouseOverRow(data) then
					if data ~= self.currentMouseRow then
						if self.rowExpansionElement then
							self.rowExpansionElement:kill()
						end
						
						self.currentMouseRow = data
						self.rowExpansionElement = gui.create("SpaceExpandConfirmation")
						
						self.rowExpansionElement:setHeight(60)
						self.rowExpansionElement:setRow(data)
					end
					
					wasMouseOver = true
					
					local width, height = math.dist(data.minX, data.maxX) + 1, math.dist(data.minY, data.maxY) + 1
					
					love.graphics.setColor(200, 255, 200, 150)
					love.graphics.rectangle("fill", data.minX * tileW - tileW, data.minY * tileH - tileH, width * tileW, height * tileH)
					
					break
				end
			end
		end
		
		if not wasMouseOver and self.currentMouseRow then
			self.currentMouseRow = nil
			
			self.rowExpansionElement:kill()
			
			self.rowExpansionElement = nil
		end
		
		if self.currentMouseRow then
			camera:unset()
			
			local mouseX, mouseY = self:getIconMouseCoordinates()
			
			self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("TAP_TO_EXPAND", "Tap to expand"), -1, 255, 255, 255, 255, 2, 2, studioExpansion.FLOOR_PLACEMENT_TEXT_FONT)
			camera:set()
		else
			if not self.demolishing and self.constructionMode == modes.FLOORS then
				local data = floors.registeredByID[self:getPurchaseID(modes.FLOORS)]
				
				if studio:hasBoughtTile(mouseIndex) then
					local renderX = mouseX * tileW - tileW
					local renderY = mouseY * tileH - tileH
					local canPlace = self:canPlaceTile(mouseX, mouseY, camera:getViewFloor())
					
					if canPlace then
						love.graphics.setColor(150, 255, 150, 150)
					else
						love.graphics.setColor(255, 150, 150, 150)
					end
					
					love.graphics.draw(self.floorTexture, self.floorQuad, renderX, renderY, 0, data.scaleX, data.scaleY)
				end
				
				if self.dragRenderStartX then
					if self:canAffordDrag() then
						love.graphics.setColor(150, 255, 150, 150)
					else
						love.graphics.setColor(255, 200, 200, 200)
					end
					
					love.graphics.rectangle("fill", self.dragRenderStartX, self.dragRenderStartY, self.dragRenderWidth, self.dragRenderHeight)
					
					local centerX, centerY = camera:convertToScreen(self.dragRenderStartX + self.dragRenderWidth * 0.5, self.dragRenderStartY + self.dragRenderHeight * 0.5)
					
					camera:unset()
					
					local rectX, rectY = centerX - self.dragCostTextWidth * 0.5 - 2, centerY - self.fontHeight * 0.5
					
					love.graphics.setColor(0, 0, 0, 200)
					love.graphics.rectangle("fill", rectX, rectY, self.dragCostTextWidth + 4, self.fontHeight)
					love.graphics.setColor(255, 255, 255, 255)
					love.graphics.setFont(self.font)
					
					local rectX, rectY = centerX - self.dragCostTextWidth * 0.5, centerY - self.fontHeight * 0.5
					
					love.graphics.print(self.dragCostText, rectX, rectY)
					camera:set()
				end
			elseif self:canPerformModeAction(modes.WALLS) then
				if studio:hasBoughtTile(mouseIndex) then
					local canPlace = false
					local demolishing = self.demolishing
					
					if demolishing then
						canPlace = studio:canDemolishWall(mouseIndex, floor, self.rotationID)
					else
						canPlace = self:canPlaceWall(mouseX, mouseY)
					end
					
					if canPlace then
						love.graphics.setColor(200, 255, 200, 50)
					else
						love.graphics.setColor(255, 150, 150, 50)
					end
					
					love.graphics.rectangle("fill", mouseX * tileW - tileW, mouseY * tileH - tileH, tileW, tileH)
					
					local rotationData = walls.ROTATIONS[self.rotationID]
					
					if canPlace then
						if demolishing then
							love.graphics.setColor(150, 255, 150, 125)
						else
							love.graphics.setColor(150, 255, 150, 200)
						end
					elseif demolishing then
						love.graphics.setColor(255, 150, 150, 150)
					else
						love.graphics.setColor(255, 150, 150, 200)
					end
					
					local renderX = mouseX * tileW + rotationData.x - tileW
					local renderY = mouseY * tileH + rotationData.y - tileH
					local originX, originY = 0, 0
					local quad, texture
					
					if demolishing then
						texture = floors.atlasTexture
						quad = studioExpansion.WALL_SIDE_INDICATION
						originX = 4
						originY = 6
					else
						love.graphics.draw(floors.atlasTexture, studioExpansion.WALL_SIDE_INDICATION, renderX, renderY, rotationData.rot, 1, 1, 4, 6)
						
						texture = self.wallTexture
						quad = self.wallQuad
					end
					
					love.graphics.draw(texture, quad, renderX, renderY, rotationData.rot, 1, 1, originX, originY)
					
					if canPlace and demolishing then
						local displayText = _T("DEMOLISH", "Demolish")
						local textWidth = studioExpansion.font:getWidth(displayText)
						
						love.graphics.setColor(0, 0, 0, 255)
						love.graphics.rectangle("fill", renderX - 3, renderY + tileH, textWidth + 5, studioExpansion.fontHeight)
						love.graphics.setColor(255, 255, 255, 255)
						love.graphics.setFont(studioExpansion.font)
						love.graphics.print(displayText, renderX, renderY + tileH)
					end
				end
			elseif self:canPerformModeAction(modes.OBJECTS) and not self.moveTime then
				local object
				
				if self.demolishing then
					object = self.movedObject
				else
					object = self:getPurchaseObject()
				end
				
				if object then
					local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getPlacementCoordinates()
					
					object:postDrawExpansion(startX, startY, endX, endY)
				end
			end
			
			if not self.movedObject then
				if not self.curHoverObject then
					local mouseX, mouseY = self:getIconMouseCoordinates()
					
					camera:unset()
					
					if self.demolishing then
						mouseY = mouseY + _S(24)
						
						self:drawDemolitionQuad(modes.WALLS, "new_tab_walls_active", "new_tab_walls_inactive", mouseX, mouseY, -1.25, _T("DEMOLITION_KEY_WALLS", "[1]"), true)
						self:drawDemolitionQuad(modes.OBJECTS, "new_tab_general_active", "new_tab_general_inactive", mouseX, mouseY, 0.25, _T("DEMOLITION_KEY_OBJECTS", "[2]"), false)
					else
						local objectMode = self:canPerformModeAction(modes.OBJECTS)
						
						if objectMode then
							mouseY = mouseY + _S(12)
							
							if objectMode and not self:getPurchaseObject():canRotate() then
								self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("PLACE", "Place"), -1, 255, 255, 255, 255, 2, 2)
							else
								self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("PLACE", "Place"), -2.5, 255, 255, 255, 255, 2, 2)
								self:drawQuad(quadLoader:getQuadStructure("mouse_right"), mouseX, mouseY, _T("ROTATE", "Rotate"), 0.5, 255, 255, 255, 255, 2, 2)
							end
						elseif self:canPerformModeAction(modes.WALLS) then
							mouseY = mouseY + _S(12)
							
							if objectMode and not self:getPurchaseObject():canRotate() then
								self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("PLACE", "Place"), -1, 255, 255, 255, 255, 2, 2)
							else
								self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("PLACE", "Place"), -2.5, 255, 255, 255, 255, 2, 2)
								self:drawQuad(quadLoader:getQuadStructure("mouse_right"), mouseX, mouseY, _T("DEMOLISH", "Demolish"), 0.5, 255, 255, 255, 255, 2, 2)
							end
						else
							love.graphics.setColor(255, 255, 255, self.iconAlpha)
							
							if self.dragRenderStartX then
								self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("RELEASE_TO_PLACE", "Place"), -2.5, 255, 255, 255, 255, 2, 2, studioExpansion.FLOOR_PLACEMENT_TEXT_FONT)
								self:drawQuad(quadLoader:getQuadStructure("mouse_right"), mouseX, mouseY, _T("FLOOR_RIGHT_MOUSE_CANCEL", "Cancel"), 0.5, 255, 255, 255, 255, 2, 2, studioExpansion.FLOOR_PLACEMENT_TEXT_FONT)
							else
								self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("TAP_OR_DRAG", "Tap or drag"), -1, 255, 255, 255, 255, 2, 2, studioExpansion.FLOOR_PLACEMENT_TEXT_FONT)
							end
						end
					end
					
					camera:set()
				else
					local mouseX, mouseY = self:getIconMouseCoordinates()
					
					camera:unset()
					self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("MOVE", "Move"), -2.5, 255, 255, 255, 255, 2, 2)
					self:drawQuad(quadLoader:getQuadStructure("mouse_right"), mouseX, mouseY, _T("SELL", "Sell"), 0.5, 255, 255, 255, 255, 2, 2)
					camera:set()
				end
			else
				local mouseX, mouseY = self:getIconMouseCoordinates()
				
				camera:unset()
				self:drawQuad(quadLoader:getQuadStructure("mouse_left"), mouseX, mouseY, _T("PLACE", "Place"), -2.5, 255, 255, 255, 255, 2, 2)
				self:drawQuad(quadLoader:getQuadStructure("mouse_right"), mouseX, mouseY, _T("ROTATE", "Rotate"), 0.5, 255, 255, 255, 255, 2, 2)
				camera:set()
			end
		end
		
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function studioExpansion:drawDemolitionQuad(desiredMode, quadActive, quadInactive, x, y, xOffsetMult, textToDraw)
	local isActive = self.demolitionMode == desiredMode
	local quadName = isActive and quadActive or quadInactive
	local quadData = quadLoader:getQuadStructure(quadName)
	local r, g, b, a = 255, 255, 255, 255
	
	if not isActive then
		a = self.iconAlpha
	end
	
	self:drawQuad(quadData, x, y, textToDraw, xOffsetMult, r, g, b, a, 1, 1)
end

function studioExpansion:drawQuad(quadData, x, y, textToDraw, xOffsetMult, r, g, b, a, scaleX, scaleY, font)
	love.graphics.setColor(r, g, b, a)
	
	local w, h = quadData.w, quadData.h
	
	x, y = math.floor(x + w * xOffsetMult), math.floor(y + h)
	
	love.graphics.draw(quadData.texture, quadData.quad, x, y, 0, scaleX, scaleY)
	
	local textX, textY = x, y + h * scaleY + _S(5)
	local fontObject = fonts.get(font or studioExpansion.DEMOLITION_TEXT_FONT)
	
	textX = textX - fontObject:getWidth(textToDraw) * 0.5 + w * 0.5 * scaleX
	
	love.graphics.setFont(fontObject)
	love.graphics.printST(textToDraw, textX, textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

function studioExpansion.switchToFloorCallback()
	studioExpansion:clearObjectSprites()
	studio.expansion:setObjectList(nil, nil)
	studio.expansion:setConstructionMode(studio.expansion.CONSTRUCTION_MODE.FLOORS)
end

function studioExpansion.switchToWallsCallback()
	studioExpansion:clearObjectSprites()
	studio.expansion:setObjectList(nil, nil)
	studio.expansion:setConstructionMode(studio.expansion.CONSTRUCTION_MODE.WALLS)
end

function studioExpansion.switchToObjectsCallback(panel)
	studioExpansion:clearObjectSprites()
	studio.expansion:setObjectList(panel.categoryObjects, panel)
	studio.expansion:setConstructionMode(studio.expansion.CONSTRUCTION_MODE.OBJECTS)
end

studioExpansion.OBJECT_TAB_BASE_ID = "expansion_tab_"

function studioExpansion:getObjectTabID(objectCategory)
	return self.OBJECT_TAB_BASE_ID .. objectCategory
end

function studioExpansion:createMenu()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self:initConstructionValues()
	
	local elementSize = 64
	local totalSize = 84 + elementSize
	local frame = gui.create("PropertyFrame")
	
	frame:setSize(scrW, totalSize)
	frame:alignToBottom(0)
	frame:setScaler("ui_hor")
	frame:setCanBlockCamera(false)
	frame:addDepth(1000)
	frame:setCloseKey(keyBinding:getCommandKey(keyBinding.COMMANDS.PROPERTY))
	
	self.mainFrame = frame
	
	local propertysheet = gui.create("ExpansionModePropertySheet", frame)
	
	propertysheet:setScaler("ui_hor")
	propertysheet:setScalingState(false, true)
	propertysheet:setPos(0, _S(9))
	propertysheet:setTabOffset(7, -2)
	propertysheet:setSize(scrW, 200)
	
	propertysheet.font = fonts.get("pix24")
	
	local propSheetSocketContainer = gui.create("HUDExpansionContainer", frame)
	
	propSheetSocketContainer:setScaler("new_hud")
	propSheetSocketContainer:setPropertySheet(propertysheet)
	propSheetSocketContainer:setHeight(propSheetSocketContainer.borderH)
	propertysheet:setSocketContainer(propSheetSocketContainer)
	
	local scrollHeight = 98
	local floorScroll = gui.create("ScrollbarPanel")
	
	floorScroll:setScaler("ui_hor")
	floorScroll:setScalingState(false, true)
	floorScroll:setSize(scrW, scrollHeight)
	floorScroll:setAdjustElementPosition(true)
	floorScroll:setOrientation(floorScroll.HORIZONTAL)
	
	for key, data in ipairs(floors.purchasable) do
		local icon = gui.create("FloorTilePurchaseOption")
		
		icon:setSize(96, 120)
		icon:setPurchaseData(data.id)
		floorScroll:addItem(icon)
	end
	
	local tabButton = propertysheet:addItem(floorScroll, _T("TAB_FLOORS", "Floors"), elementSize, elementSize, studioExpansion.switchToFloorCallback, nil, nil)
	
	tabButton:addHoverText(_T("EXPANSION_FLOORS", "Floors"), "pix20", 0, nil, 200)
	tabButton:setIcons("new_tab_floors", "new_tab_floors_hover")
	
	local wallScroll = gui.create("ScrollbarPanel")
	
	wallScroll:setScaler("ui_hor")
	wallScroll:setScalingState(false, true)
	wallScroll:setSize(scrW, scrollHeight)
	wallScroll:setAdjustElementPosition(true)
	wallScroll:setOrientation(floorScroll.HORIZONTAL)
	
	for key, data in ipairs(walls.purchasable) do
		local icon = gui.create("WallPurchaseOption")
		
		icon:setSize(96, 120)
		icon:setPurchaseData(data.id)
		wallScroll:addItem(icon)
	end
	
	local tabButton = propertysheet:addItem(wallScroll, _T("TAB_WALLS", "Walls"), elementSize, elementSize, studioExpansion.switchToWallsCallback, nil, nil)
	
	tabButton:addHoverText(_T("EXPANSION_WALLS", "Walls"), "pix20", 0, nil, 200)
	tabButton:setIcons("new_tab_walls", "new_tab_walls_hover")
	
	for keyID, data in ipairs(objectCategories.allCategories) do
		if #data.objects > 0 then
			local objectScroll = gui.create("ScrollbarPanel")
			
			objectScroll:setScaler("ui_hor")
			objectScroll:setScalingState(false, true)
			objectScroll:setSize(scrW, scrollHeight)
			objectScroll:setAdjustElementPosition(true)
			objectScroll:setOrientation(objectScroll.HORIZONTAL)
			
			local id = data.id
			
			for key, objectData in ipairs(data.objects) do
				local element = objectData:addToPurchaseMenu(objectScroll, 96, 120, id, key)
				
				if element then
					element:setID(objectData.class .. "_icon")
				end
			end
			
			local tabButton = propertysheet:addItem(objectScroll, data.display, elementSize, elementSize, studioExpansion.switchToObjectsCallback, id)
			
			tabButton:setID(self:getObjectTabID(id))
			tabButton:addHoverText(data.display, "pix20", 0, nil, 200)
			
			tabButton.categoryObjects = data.objects
		end
	end
	
	propSheetSocketContainer:setPos(0, propertysheet.localY + _S(8))
	propSheetSocketContainer:adjustLayout()
	
	self.frame = frame
	
	self:enter()
	frameController:push(frame)
end
