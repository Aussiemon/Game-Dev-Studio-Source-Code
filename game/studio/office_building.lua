officeBuilding = {}
officeBuilding.mtindex = {
	__index = officeBuilding
}
officeBuilding.tiles = nil
officeBuilding.employees = nil
officeBuilding.objects = nil
officeBuilding.rooms = nil
officeBuilding.driveAffectors = nil
officeBuilding.totalDriveAffector = nil
officeBuilding.expansionDirections = nil
officeBuilding.name = "INVALID"
officeBuilding.CONVERSATION_NEWLY_PURCHASED = "newly_purchased_office"
officeBuilding.FIRST_TIME_FLOOR_HINT = "first_time_floor_hint"
officeBuilding.ROOF_PRIORITY = 60
officeBuilding.MAX_OFFICE_NAME_LENGTH = 28
officeBuilding.TILE_SEARCH_AREA = 3
officeBuilding.EVENTS = {
	PURCHASED = events:new(),
	RECALCULATED_INTEREST_BOOSTS = events:new(),
	UNASSIGNED_OFFICE = events:new(),
	FINISHED_NAMING = events:new(),
	BECOME_VISIBLE = events:new(),
	BECOME_INVISIBLE = events:new(),
	PURCHASED_FLOOR = events:new(),
	MOUSE_OVER = events:new(),
	MOUSE_LEFT = events:new(),
	FLOOR_PURCHASED = events:new()
}

function officeBuilding.new()
	local new = {}
	
	setmetatable(new, officeBuilding.mtindex)
	new:init()
	
	return new
end

function officeBuilding:roofPreDrawCallback()
	local lightColor = timeOfDay:getLightColor()
	
	if self.office.canDrawRoof then
		self.office.roofAlpha = math.approach(self.office.roofAlpha, 0.2, frameTime * 3)
	else
		self.office.roofAlpha = math.approach(self.office.roofAlpha, 1, frameTime * 3)
	end
	
	love.graphics.setColor(lightColor.r, lightColor.g, lightColor.b, 255 * self.office.roofAlpha)
	
	return false
end

function officeBuilding.roofPostDrawCallback()
	love.graphics.setColor(255, 255, 255, 255)
end

function officeBuilding:init()
	self.employees = {}
	self.objects = {}
	self.objectsByFloor = {}
	self.rooms = {}
	self.driveAffectors = {}
	self.driveAffectorValues = {}
	self.interestBoost = {}
	self.monthlyCosts = {}
	self.monthlyCostsByFloor = {}
	self.totalMonthlyCost = 0
	self.totalDriveAffector = 0
	self.totalMonthlyCost = 0
	self.roofTileSprites = {}
	self.roofTileIndexes = {}
	self.visibleTiles = {}
	self.validWorkplaces = {}
	self.objectsByClass = {}
	self.devSpeedMultipliers = {}
	self.decorObjects = {}
	self.staircasesUp = {}
	self.staircasesDown = {}
	self.validTransitionUp = {}
	self.validTransitionDown = {}
	self.floorReevalQueue = {}
	self.tiles = {}
	self.tileMap = {}
	self.visibleTileCount = 0
	self.invalidObjCount = 0
	self.grid = game.worldObject:getFloorTileGrid()
	self.tileW, self.tileH = self.grid:getTileSize()
	self.devSpeedMultiplier = 1
	self.floorCount = 3
	self.purchasedFloors = 1
end

function officeBuilding:addToFloorReevalQueue(floorID)
	if table.find(self.floorReevalQueue, floorID) then
		return 
	end
	
	self.floorReevalQueue[#self.floorReevalQueue + 1] = floorID
end

function officeBuilding:getFloorReevalQueue()
	return self.floorReevalQueue
end

function officeBuilding:attemptUseEvalQueue()
	local reevalQueue = self.floorReevalQueue
	
	if #reevalQueue > 0 then
		local lowestFloor = math.huge
		
		for key, floorID in ipairs(reevalQueue) do
			lowestFloor = math.min(lowestFloor, floorID)
			reevalQueue[key] = nil
		end
		
		lowestFloor = lowestFloor + 1
		
		for i = lowestFloor, self.purchasedFloors do
			studio.expansion:evaluateReach(self, i)
			studio:updateRooms(nil, self, i)
		end
	end
end

function officeBuilding:purchaseFloor()
	studio:deductFunds(self:getFloorPurchaseCost(self.purchasedFloors + 1))
	self:addPurchasedFloor()
	
	if camera:getViewFloor() == self.purchasedFloors then
		self:stopDrawingRoof()
	end
	
	if studio.expansion:isActive() and not studio:getFact(officeBuilding.FIRST_TIME_FLOOR_HINT) then
		studio.expansion:createFloorControlHint()
		studio:setFact(officeBuilding.FIRST_TIME_FLOOR_HINT, true)
	end
	
	sound:play("purchase_building_floor")
	events:fire(officeBuilding.EVENTS.FLOOR_PURCHASED, self)
end

function officeBuilding:getFloorPurchaseCost(floorID)
	return self.floorCost
end

function officeBuilding:updateDisplayableFloor()
	self.displayableFloor = math.min(self.purchasedFloors, camera:getViewFloor())
end

function officeBuilding:getDisplayableFloor()
	return self.displayableFloor
end

function officeBuilding:addPurchasedFloor()
	self.purchasedFloors = self.purchasedFloors + 1
	
	local pFloors = self.purchasedFloors
	
	self.objectsByFloor[pFloors] = {}
	self.rooms[pFloors] = {}
	self.monthlyCostsByFloor[pFloors] = {}
	
	self:fillFloorTiles(pFloors, true)
	self:fillBorderWalls(nil, pFloors)
	game.sendGridIndexUpdateToThreads(game.worldObject:getFloorTileGrid(), pathfinderThread.MESSAGE_TYPE.GRID_UPDATE, self.tiles, pFloors)
	studio:onFloorPurchased(pFloors)
	events:fire(self.EVENTS.PURCHASED_FLOOR, self)
end

function officeBuilding:setupFloorData()
	for i = 1, self.purchasedFloors do
		self.objectsByFloor[i] = {}
		self.rooms[i] = {}
		self.monthlyCostsByFloor[i] = {}
	end
end

function officeBuilding:getPurchasedFloors()
	return self.purchasedFloors
end

function officeBuilding:setFloorCount(cnt)
	self.floorCount = cnt
end

function officeBuilding:getFloorCount()
	return self.floorCount
end

function officeBuilding:canPurchaseFloor()
	return self.floorCount > self.purchasedFloors
end

function officeBuilding:addDecorObject(obj)
	self.decorObjects[#self.decorObjects + 1] = obj
end

function officeBuilding:setPedestrianBuilding(pedestrian)
	self.pedestrianBuilding = pedestrian
	
	if pedestrian then
		game.worldObject:addPedestrianBuilding(self)
	end
end

function officeBuilding:isPedestrianBuilding()
	return self.pedestrianBuilding
end

function officeBuilding:setFrustrationChange(change)
	self.frustrationChange = change
end

function officeBuilding:getFrustrationChange()
	return self.frustrationChange
end

function officeBuilding:setRivalOwner(rivalID)
	self.rivalOwner = rivalID
	self.reserved = nil
end

function officeBuilding:getRivalOwner()
	return self.rivalOwner
end

function officeBuilding:addWorkplace(object)
	table.insert(self.validWorkplaces, object)
end

function officeBuilding:getWorkplaces()
	return self.validWorkplaces
end

function officeBuilding:removeWorkplace(object)
	table.removeObject(self.validWorkplaces, object)
end

function officeBuilding:setNoRoofValues(state)
	self.noRoofValues = state
end

function officeBuilding:getRoofTileIndexes()
	return self.roofTileIndexes
end

officeBuilding.ROOF_EVAL_TILES = {
	floors:getData(31),
	floors:getData(32),
	floors:getData(33),
	floors:getData(34),
	floors:getData(27),
	floors:getData(28),
	floors:getData(29),
	floors:getData(30),
	floors:getData(23),
	floors:getData(24),
	floors:getData(25),
	floors:getData(26)
}
officeBuilding.ROOF_TILE_ID = 22

function officeBuilding:fillRoofTileIndexes()
	local roofBase = officeBuilding.ROOF_TILE_ID
	local tileMap = self.tileMap
	local eval = officeBuilding.ROOF_EVAL_TILES
	local grid = game.worldObject:getFloorTileGrid()
	
	for key, index in ipairs(self.tiles) do
		local finalID = roofBase
		
		for cfgKey, cfg in ipairs(eval) do
			if cfg:roofValidCheck(grid, index, tileMap) then
				finalID = cfg.id
				
				break
			end
		end
		
		self.roofTileIndexes[index] = finalID
	end
end

function officeBuilding:setID(id)
	self.id = id
	self.data = officeBuildingInserter.registeredByID[self.id]
	self.floorCost = self.data.floorCost
	self.roofTile = self.data.roofTile
	self.floorCount = self.data.floors
	self.spriteBatchID = tostring(self) .. "_roof_spritebatch"
	self.spriteBatch = spriteBatchController:newSpriteBatch(self.spriteBatchID, floors.texture, 1024, "dynamic", officeBuilding.ROOF_PRIORITY, false, true, true, true)
	self.roofAlpha = 1
	self.spriteBatch.office = self
	
	self.spriteBatch:setDrawCallback(officeBuilding.roofPreDrawCallback)
	self.spriteBatch:setPostDrawCallback(officeBuilding.roofPostDrawCallback)
	self:setupFloorData()
end

function officeBuilding:addDevSpeedMultiplier(id, change)
	if not self.devSpeedMultipliers[id] then
		self.devSpeedMultipliers[id] = change
		self.devSpeedMultiplier = self.devSpeedMultiplier + change
	end
end

function officeBuilding:recalculateDevSpeedMultiplier()
	self.devSpeedMultiplier = 1
	
	for id, change in pairs(self.devSpeedMultipliers) do
		self.devSpeedMultiplier = self.devSpeedMultiplier + change
	end
end

function officeBuilding:removeDevSpeedMultiplier(id)
	local change = self.devSpeedMultipliers[id]
	
	if change then
		self.devSpeedMultipliers[id] = nil
		self.devSpeedMultiplier = self.devSpeedMultiplier - change
	end
end

function officeBuilding:getDevSpeedMultiplier()
	return self.devSpeedMultiplier
end

function officeBuilding:getID()
	return self.id
end

function officeBuilding:addRoom(roomObject)
	roomObject:setOffice(self)
	table.insert(self.rooms[roomObject:getFloor()], roomObject)
end

function officeBuilding:onRoomsUpdated(floor)
	for key, object in ipairs(self.objects) do
		object:onRoomsUpdated()
	end
	
	for key, object in ipairs(self.objects) do
		object:postRoomsUpdated()
	end
	
	local up = self.staircasesUp[floor]
	
	if up then
		up:applyRoomValues()
	end
	
	local down = self.staircasesDown[floor]
	
	if down then
		down:applyRoomValues()
	end
	
	self:evaluateFloorTransitions()
	studio.driveAffectors:calculateDriveAffection(self)
end

function officeBuilding:evaluateFloorTransitions()
	local stairUp, stairDown = self.staircasesUp, self.staircasesDown
	local validUp, validDown = self.validTransitionUp, self.validTransitionDown
	local validUpTransition = true
	
	for i = 1, self.purchasedFloors do
		local up, down = stairUp[i], stairDown[i]
		
		if down then
			if down:isValidForInteraction() then
				validDown[i] = true
			else
				validDown[i] = false
			end
		else
			validDown[i] = false
		end
		
		if validUpTransition then
			if up then
				if not up:isValidForInteraction() then
					validUpTransition = false
				end
			else
				validUpTransition = false
			end
		end
		
		validUp[i] = validUpTransition
	end
end

function officeBuilding:isFloorAccessible(floor)
	if floor == 1 then
		return true
	end
	
	return self.validTransitionDown[floor]
end

function officeBuilding:getRooms()
	return self.rooms
end

function officeBuilding:getRoomsByFloor(floor)
	return self.rooms[floor]
end

function officeBuilding:removeRoom(roomObject, skipTileRemove)
	for key, otherRoomObject in ipairs(self.rooms) do
		if roomObject == otherRoomObject then
			if not skipTileRemove then
				for index, state in pairs(roomObject:getTiles()) do
					self.roomMap[index] = nil
				end
			end
			
			table.remove(self.rooms, key)
			
			break
		end
	end
end

function officeBuilding:getSizeInTiles()
	return #self.tiles
end

function officeBuilding:enterExpansionMode()
	self.expansionMode = true
	
	if not self.playerOwned then
		if not studio.expansion:getBuildingPurchasesAllowed() and not self.saleDisplay then
			self.saleDisplay = gui.create("OfficeCostDisplay")
			
			self.saleDisplay:setHeight(60)
			self.saleDisplay:setOffice(self)
			self.saleDisplay:setDepth(100)
			
			if not self.visible then
				self.saleDisplay:hide()
			end
			
			studio.expansion:addPurchasableBuilding(self)
		end
	elseif self.visible then
		self:attemptCreateFloorPurchaseDisplay()
	end
end

function officeBuilding:setOfficeFloorPurchaseDisplay(obj)
	self.officeFloorPurchaseDisplay = obj
end

function officeBuilding:attemptCreateFloorPurchaseDisplay()
	if self.playerOwned and self.purchasedFloors < self.floorCount and (not self.officeFloorPurchaseDisplay or not self.officeFloorPurchaseDisplay:isValid()) then
		local elem = gui.create("OfficeFloorPurchaseDisplay")
		
		elem:setHeight(60)
		elem:setOffice(self)
		elem:setDepth(90)
		
		self.officeFloorPurchaseDisplay = elem
	end
end

function officeBuilding:leaveExpansionMode()
	self:killSaleDisplay()
	self:updateRoofDrawState()
	
	self.mouseOver = false
	self.expansionMode = false
end

function officeBuilding:enterAssignmentMode()
	self.assignmentDisplay = gui.create("OfficeTeamAssignment")
	
	self.assignmentDisplay:setOffice(self)
end

function officeBuilding:leaveAssignmentMode()
	self:killAssignmentDisplay()
end

function officeBuilding:allocateVisibleRoofSprites()
	for tile, state in pairs(self.visibleTiles) do
		self:showTileSprite(tile)
	end
end

function officeBuilding:beginDrawingRoof()
	if self.roofDisabled then
		return 
	end
	
	if self.saleDisplay then
		self.saleDisplay:show()
	end
	
	self.drawingRoof = true
	
	priorityRenderer:add(self.spriteBatch, officeBuilding.ROOF_PRIORITY)
	
	if self.visible then
		self:allocateVisibleRoofSprites()
	end
end

function officeBuilding:disableRoof()
	self.roofDisabled = true
	
	priorityRenderer:remove(self.spriteBatch)
end

function officeBuilding:hidePurchaseElement()
	if self.saleDisplay then
		self.saleDisplay:hide()
	end
end

function officeBuilding:showPurchaseElement()
	if self.saleDisplay then
		self.saleDisplay:show()
	end
end

function officeBuilding:stopDrawingRoof()
	self.drawingRoof = false
	
	if self.spriteBatch then
		priorityRenderer:remove(self.spriteBatch)
	end
	
	if self.saleDisplay then
		self.saleDisplay:hide()
	end
	
	for index, spriteID in pairs(self.roofTileSprites) do
		self.spriteBatch:deallocateSlot(spriteID)
		
		self.roofTileSprites[index] = nil
	end
end

function officeBuilding:showTileSprite(index)
	local roofValue = self.roofTileIndexes[index]
	
	if roofValue then
		local slot = self.spriteBatch:allocateSlot()
		
		self.roofTileSprites[index] = slot
		
		local roofTileData = floors.registeredByID[roofValue]
		local gridX, gridY = self.grid:convertIndexToCoordinates(index)
		
		gridX, gridY = gridX * self.tileW, gridY * self.tileH
		
		local renderX, renderY, rotation, halfWidth, halfHeight, quad = roofTileData:getRenderData(gridX, gridY)
		
		self.spriteBatch:updateSprite(slot, quad, renderX, renderY - 12, rotation, roofTileData.scaleX, roofTileData.scaleY, halfWidth, halfHeight)
	end
end

function officeBuilding:hideTileSprite(index)
	local sprite = self.roofTileSprites[index]
	
	if sprite then
		self.spriteBatch:deallocateSlot(sprite)
		
		self.roofTileSprites[index] = nil
	end
end

function officeBuilding:getFloorsText()
	return _format(_T("BUILDING_FLOOR_TOTAL_COUNT", "Floors: FLOORS/TOTAL"), "FLOORS", self.purchasedFloors, "TOTAL", self.floorCount)
end

function officeBuilding:onTileBecomeVisible(index)
	if not self.visibleTiles[index] then
		self.visibleTiles[index] = true
		self.visibleTileCount = self.visibleTileCount + 1
		
		if not self.visible then
			if not self.playerOwned or camera:getViewFloor() > self.purchasedFloors then
				self:beginDrawingRoof()
			end
			
			if self.expansionMode then
				self:attemptCreateFloorPurchaseDisplay()
			end
		end
		
		local wasVis = self.visible
		
		if not wasVis then
			self.visible = true
			
			self:updateDisplayableFloor()
			studio:getOfficeBuildingMap():addVisibleBuilding(self)
			events:fire(officeBuilding.EVENTS.BECOME_VISIBLE, self)
		end
		
		if self.drawingRoof then
			self:showTileSprite(index)
		end
	end
end

function officeBuilding:onTileBecomeInvisible(index)
	self.visibleTileCount = self.visibleTileCount - 1
	self.visibleTiles[index] = false
	
	if self.drawingRoof then
		self:hideTileSprite(index)
	end
	
	if self.visibleTileCount == 0 then
		self.visible = false
		
		studio:getOfficeBuildingMap():removeVisibleBuilding(self)
		events:fire(officeBuilding.EVENTS.BECOME_INVISIBLE, self)
		self:stopDrawingRoof()
	end
end

function officeBuilding:killSaleDisplay()
	if self.saleDisplay then
		self.saleDisplay:kill()
		
		self.saleDisplay = nil
	end
end

function officeBuilding:killAssignmentDisplay()
	if self.assignmentDisplay then
		self.assignmentDisplay:kill()
		
		self.assignmentDisplay = nil
	end
end

function officeBuilding:updateRoofDrawState()
	self.canDrawRoof = self.mouseOver and not self.rivalOwner and not self.reserved and not self.pedestrianBuilding and self.purchasedFloors >= camera:getViewFloor()
end

function officeBuilding:onMouseEntered()
	self.mouseOver = true
	
	self:updateRoofDrawState()
	
	if self.saleDisplay then
		self.saleDisplay:officeMouseOver()
	end
	
	if self.playerOwned and employeeAssignment:isActive() then
		self.assignmentDisplay:officeMouseOver()
	end
	
	events:fire(officeBuilding.EVENTS.MOUSE_OVER, self)
end

function officeBuilding:onMouseLeft()
	self.mouseOver = false
	
	self:updateRoofDrawState()
	
	if self.saleDisplay then
		self.saleDisplay:officeMouseLeft()
	end
	
	if self.playerOwned and employeeAssignment:isActive() then
		self.assignmentDisplay:officeMouseLeft()
	end
	
	events:fire(officeBuilding.EVENTS.MOUSE_LEFT, self)
end

function officeBuilding:unassignEveryone()
	local employeeList = self.employees
	
	self.preventMonthlyRecalculation = true
	
	while employeeList[1] do
		employeeAssignment:unassignEmployee(employeeList[1])
	end
	
	self.preventMonthlyRecalculation = false
	
	for i = 1, self.purchasedFloors do
		self:updateMonthlyCosts(i)
	end
	
	events:fire(officeBuilding.EVENTS.UNASSIGNED_OFFICE, self)
end

local presentInterestObjects = {}

function officeBuilding:calculateInterestBoost()
	if studio._loading then
		return 
	end
	
	table.clear(self.interestBoost)
	
	for key, object in ipairs(self.objects) do
		local objectClass = object:getClass()
		
		for interest, amount in pairs(object:getInterests()) do
			local data = interests:getData(interest)
			
			if data.noObjectRepetition then
				if not presentInterestObjects[objectClass] then
					self:increaseInterestBoost(interest, amount)
				end
			else
				self:increaseInterestBoost(interest, amount)
			end
		end
		
		presentInterestObjects[objectClass] = true
	end
	
	table.clear(presentInterestObjects)
	events:fire(officeBuilding.EVENTS.RECALCULATED_INTEREST_BOOSTS, self)
end

function officeBuilding:increaseInterestBoost(interest, amount)
	local current = self.interestBoost[interest]
	
	self.interestBoost[interest] = current and current + amount or amount
end

function officeBuilding:getInterestBoosts()
	return self.interestBoost
end

function officeBuilding:getInterestBoost(interestID)
	return self.interestBoost[interestID] or 0
end

function officeBuilding:changeInvalidObjectCount(change)
	self.invalidObjCount = self.invalidObjCount + change
end

function officeBuilding:reRegisterRooms(floor)
	for key, roomObject in ipairs(self.rooms[floor]) do
		roomObject:register()
	end
end

function officeBuilding:getLargestFrustrator()
	local id, largest = nil, math.huge
	
	for key, data in ipairs(studio.driveAffectors.registered) do
		local aff = self.driveAffectors[data.id]
		
		if aff and data.mandatory and aff < 0 and aff < largest then
			id = data.id
			aff = largest
		end
	end
	
	return id
end

function officeBuilding:setDriveAffector(id, amount)
	self.driveAffectors[id] = amount
end

function officeBuilding:getDriveAffector(id)
	return self.driveAffectors[id]
end

function officeBuilding:getDriveAffectors()
	return self.driveAffectors, self.driveAffectorValues
end

function officeBuilding:setTotalDriveAffector(total)
	self.totalDriveAffector = total
end

function officeBuilding:getTotalDriveAffector()
	return self.totalDriveAffector
end

function officeBuilding:updateMonthlyCosts(floorID)
	if studio._loading or not studio._allowCostRecalc or self.preventMonthlyRecalculation or game._removing then
		return 
	end
	
	local floorCosts = self.monthlyCostsByFloor[floorID]
	local monthlyCosts = self.monthlyCosts
	
	for costType, cost in pairs(floorCosts) do
		monthlyCosts[costType] = monthlyCosts[costType] - cost
		floorCosts[costType] = 0
		self.totalMonthlyCost = self.totalMonthlyCost - cost
	end
	
	local grid = game.worldObject:getFloorTileGrid()
	local employeeCount = #self.employees
	local tileCost, objCost, communal = 0, 0, 0
	
	for key, index in ipairs(self.tiles) do
		local tileID = grid:getTileID(index, floorID)
		local tileData = floors.registeredByID[tileID]
		
		if tileData then
			for costType, cost in pairs(tileData.monthlyCost:getCostTypes()) do
				local curCost = monthlyCosts[costType]
				local curFloorCost = floorCosts[costType]
				
				floorCosts[costType] = curFloorCost and curFloorCost + cost or cost
				tileCost = tileCost + cost
			end
		end
	end
	
	for key, object in ipairs(self.objectsByFloor[floorID]) do
		for costType, cost in pairs(object:getMonthlyCosts():getCostTypes()) do
			local curCost = monthlyCosts[costType]
			local curFloorCost = floorCosts[costType]
			
			floorCosts[costType] = curFloorCost and curFloorCost + cost or cost
			objCost = objCost + cost
		end
	end
	
	if employeeCount > 0 then
		local change = monthlyCost.COST_PER_EMPLOYEE_FOR_COMMUNAL * employeeCount
		
		floorCosts.communal = floorCosts.communal + change
	else
		floorCosts.communal = 0
	end
	
	communal = floorCosts.communal
	
	for costType, cost in pairs(floorCosts) do
		cost = math.round(cost)
		floorCosts[costType] = cost
		monthlyCosts[costType] = (monthlyCosts[costType] or 0) + cost
		self.totalMonthlyCost = self.totalMonthlyCost + cost
	end
	
	return self.monthlyCosts
end

function officeBuilding:getMonthlyCosts()
	return self.monthlyCosts
end

function officeBuilding:getMonthlyCost(id)
	return self.monthlyCosts[id]
end

function officeBuilding:getHighestMonthlyCost()
	local id, amount = nil, 0
	
	for costID, costAmount in pairs(self.monthlyCosts) do
		if amount < costAmount then
			amount = costAmount
			id = costID
		end
	end
	
	return id, amount
end

function officeBuilding:getMonthlyCostAmount()
	return self.totalMonthlyCost
end

function officeBuilding:getMonthlyEmployeeSalaries()
	local total = 0
	
	for key, employee in ipairs(self.employees) do
		total = total + employee:getSalary()
	end
	
	return total
end

function officeBuilding:getOverallExpenses()
	return self:getMonthlyCostAmount() + self:getMonthlyEmployeeSalaries()
end

function officeBuilding:getCost()
	return self.data.cost
end

function officeBuilding:isPlayerOwned()
	return self.playerOwned
end

function officeBuilding:setCanExpand(canExpand)
	self.canExpand = canExpand
	
	if canExpand and not self.expansionDirections then
		self.expansionDirections = {}
		
		for directionID, times in pairs(self.canExpand) do
			self.expansionDirections[directionID] = 0
		end
	end
end

function officeBuilding:getCanExpand(direction)
	return self.canExpand
end

function officeBuilding:canExpandInDirection(direction)
	local available = self.canExpand[direction]
	
	if available then
		return available > self.expansionDirections[direction]
	end
	
	return false
end

function officeBuilding:purchase()
	studio:deductFunds(self:getCost(), nil, "office_expansion")
	camera:setViewFloor(1)
	self:onPurchased()
	conversations:addTopicToTalkAbout(officeBuilding.CONVERSATION_NEWLY_PURCHASED, self.id)
	self:fillRoofTileIndexes()
	self:attemptCreateFloorPurchaseDisplay()
	self:createOfficeNamingPopup()
	sound:play("office_purchased")
end

function officeBuilding:setReserved(state)
	self.reserved = state
end

function officeBuilding:getReserved()
	return self.reserved
end

function officeBuilding:onPurchased()
	self.playerOwned = true
	
	self:updateRoofDrawState()
	studio:addOwnedBuilding(self)
	
	self.buildingNumber = #studio:getOwnedBuildings()
	
	self:setDefaultName()
	
	for key, object in ipairs(self.objects) do
		object:onPurchased()
	end
	
	self:setRivalOwner(nil)
	self:stopDrawingRoof()
	self:killSaleDisplay()
	studio:onFloorPurchased(self.purchasedFloors)
	
	if self.canExpand and studio.expansion:isActive() then
		studio.expansion:updatePurchasableRows()
	end
	
	local key = 1
	
	for i = 1, self.purchasedFloors do
		studio:reevaluateOffice(nil, self, i)
	end
	
	events:fire(officeBuilding.EVENTS.PURCHASED, self)
end

function officeBuilding:upgradeWorkplaces()
	local workplaceClass = objects.getClassData("workplace")
	local newestLevel = workplaceClass:getLatestProgression()
	
	for key, object in ipairs(self.objects) do
		if object:getObjectType() == "workplace" then
			object:setProgression(newestLevel)
		end
	end
end

function officeBuilding:remove()
	self._removing = true
	
	self:killSaleDisplay()
	self:stopDrawingRoof()
	spriteBatchController:removeSpriteBatch(self.spriteBatch.batchID)
	
	self.spriteBatch = nil
	
	local objs = self.objects
	
	while objs[1] do
		objs[#objs]:remove()
		table.remove(objs, #objs)
	end
	
	table.clearArray(self.employees)
	table.clearArray(self.rooms)
	table.clear(self.driveAffectors)
	table.clear(self.driveAffectorValues)
	table.clear(self.interestBoost)
	table.clear(self.monthlyCosts)
	table.clear(self.roofTileSprites)
	table.clear(self.roofTileIndexes)
	table.clear(self.visibleTiles)
	table.clearArray(self.validWorkplaces)
	table.clear(self.objectsByClass)
	table.clearArray(self.tiles)
	table.clearArray(self.decorObjects)
	table.clear(self.tileMap)
	
	self.tiles = nil
	self.tileMap = nil
	self.employees = nil
	self.rooms = nil
	self.driveAffectors = nil
	self.driveAffectorValues = nil
	self.interestBoost = nil
	self.monthlyCosts = nil
	self.roofTileSprites = nil
	self.roofTileIndexes = nil
	self.visibleTiles = nil
	self.validWorkplaces = nil
	self.objectsByClass = nil
	self.grid = nil
	self._removing = false
end

function officeBuilding:removeFromEditor(worldObject, floorGrid, wallGrid, clearToTileValue)
	local map = studio:getOfficeBuildingMap()
	
	for key, index in ipairs(self.tiles) do
		for key, rotation in ipairs(walls.ORDER) do
			wallGrid:removeWall(index, 1, rotation)
		end
		
		floorGrid:setTileValue(index, 1, 0)
		map:setTileBuilding(index, nil)
		floorGrid:setTileValue(index, 1, clearToTileValue)
	end
	
	local objs = self.objects
	
	for i = 1, #objs do
		local object = objs[#objs]
		
		object:remove()
	end
	
	local decor = self.decorObjects
	
	for i = 1, #decor do
		decor[#decor]:remove()
		table.remove(decor, #decor)
	end
end

function officeBuilding:logExpansion(direction)
	self.expansionDirections[direction] = self.expansionDirections[direction] + 1
end

function officeBuilding:addEmployee(employee)
	table.insert(self.employees, employee)
	
	for i = 1, self.purchasedFloors do
		self:updateMonthlyCosts(i)
	end
	
	employee:setOfficeDevSpeedMultiplier(self.devSpeedMultiplier)
end

function officeBuilding:getRandomTileIndex()
	return self.tiles[math.random(1, #self.tiles)]
end

function officeBuilding:getTiles()
	return self.tiles
end

function officeBuilding:removeEmployee(employee)
	table.removeObject(self.employees, employee)
	
	for i = 1, self.purchasedFloors do
		self:updateMonthlyCosts(i)
	end
end

function officeBuilding:getEmployees()
	return self.employees
end

function officeBuilding:addObject(object, oldOffice)
	if object._lastFloor and oldOffice == self then
		table.removeObject(self.objectsByFloor[object._lastFloor], object)
	end
	
	local x, y = object:getTileCoordinates()
	
	table.insert(self.objects, object)
	
	local class = object:getClass()
	
	if not self.objectsByClass[class] then
		self.objectsByClass[class] = {}
	end
	
	local floor = object:getFloor()
	
	object._lastFloor = floor
	
	table.insert(self.objectsByFloor[floor], object)
	table.insert(self.objectsByClass[class], object)
end

function officeBuilding:getObjectsByFloor(floor)
	return self.objectsByFloor[floor]
end

function officeBuilding:getObjectsByFloorObject()
	return self.objectsByFloor
end

function officeBuilding:removeObject(object)
	if self._removing then
		return 
	end
	
	if table.removeObject(self.objects, object) then
		local class = object:getClass()
		local objects = self.objectsByClass[class]
		
		table.removeObject(objects, object)
		
		local removedFloor = object:removeFromFloors()
		
		object:markAsValid()
		self:updateMonthlyCosts(removedFloor)
	end
end

function officeBuilding:getObjectCountByClass(class)
	return self.objectsByClass[class] and #self.objectsByClass[class] or 0
end

function officeBuilding:getObjectsByClass(class)
	return self.objectsByClass[class]
end

function officeBuilding:removeObjectFromRoom(object)
	object:removeFromRoom(self)
end

function officeBuilding:getObjects()
	return self.objects
end

function officeBuilding:setStaircaseUp(floor, object)
	local prevStair = self.staircasesUp[floor]
	
	self.staircasesUp[floor] = object
end

function officeBuilding:setStaircaseDown(floor, object)
	self.staircasesDown[floor] = object
end

function officeBuilding:getStaircaseUp(floor)
	return self.staircasesUp[floor]
end

function officeBuilding:getStaircaseDown(floor)
	return self.staircasesDown[floor]
end

function officeBuilding:fillFloorReachText(descbox, wrapW)
	local realFloor = math.min(self.purchasedFloors, camera:getViewFloor())
	
	if realFloor > 1 and not self.staircasesDown[realFloor] then
		descbox:addSpaceToNextText(6)
		descbox:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		descbox:addText(_T("OFFICE_NO_STAIRCASE_DOWN", "No staircase leading down!"), "bh20", game.UI_COLORS.RED, 0, wrapW, "exclamation_point_red", 22, 22)
	end
	
	if realFloor < self.purchasedFloors and not self.staircasesUp[realFloor] then
		descbox:addSpaceToNextText(6)
		descbox:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		descbox:addText(_T("OFFICE_NO_STAIRCASE_UP", "No staircase leading up!"), "bh20", game.UI_COLORS.RED, 0, wrapW, "exclamation_point_red", 22, 22)
	end
	
	if self.invalidObjCount > 0 then
		descbox:addSpaceToNextText(6)
		descbox:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		descbox:addText(_format(_T("OFFICE_UNUSABLE_OBJECTS_COUNTER", "Unusable objects: AMOUNT"), "AMOUNT", self.invalidObjCount), "bh20", game.UI_COLORS.RED, 0, wrapW, "exclamation_point_red", 22, 22)
	end
end

function officeBuilding:setupMainDoor()
	self.mainDoor = nil
	
	for key, object in ipairs(self.objects) do
		if object:getFact(game.MAIN_DOOR_FACT) then
			self.mainDoor = object
			
			return true
		end
	end
	
	return false
end

function officeBuilding:getSpawnTile()
	if not self.employeeSpawnTiles then
		self:findEmployeeSpawnTiles()
	end
	
	if #self.currentSpawnTiles == 0 then
		self:resetSpawnTiles()
	end
	
	local randomIndex = math.random(1, #self.currentSpawnTiles)
	local tile = self.currentSpawnTiles[randomIndex]
	
	table.remove(self.currentSpawnTiles, randomIndex)
	
	return tile
end

function officeBuilding:findEmployeeSpawnTiles()
	local tileX, tileY = self.mainDoor:getTileCoordinates()
	local grid = game.worldObject:getFloorTileGrid()
	
	self.employeeSpawnTiles = {}
	self.currentSpawnTiles = {}
	
	for y = tileY - officeBuilding.TILE_SEARCH_AREA, tileY + officeBuilding.TILE_SEARCH_AREA do
		for x = tileX - officeBuilding.TILE_SEARCH_AREA, tileX + officeBuilding.TILE_SEARCH_AREA do
			local index = grid:getTileIndex(x, y)
			local value = grid:getTileValue(index, 1)
			
			if floors.registeredByID[value].employeeSpawnable then
				self.employeeSpawnTiles[#self.employeeSpawnTiles + 1] = index
				self.currentSpawnTiles[#self.currentSpawnTiles + 1] = index
			end
		end
	end
end

function officeBuilding:resetSpawnTiles()
	for key, index in ipairs(self.employeeSpawnTiles) do
		self.currentSpawnTiles[key] = index
	end
end

function officeBuilding:setMainDoor(mainDoor)
	self.mainDoor = mainDoor
end

function officeBuilding:getMainDoor()
	return self.mainDoor
end

function officeBuilding:getMidCoordinates()
	return self.midX, self.midY
end

function officeBuilding:getFloorUpgradeCoords()
	return self.midX, self.bottomY
end

function officeBuilding:setTileIndexes(indexes, skipOfficeMap)
	self.tileMap = indexes
	
	local map = studio:getOfficeBuildingMap()
	
	grid = game.worldObject:getFloorTileGrid()
	
	local tileW, tileH = grid:getTileSize()
	local tileCount = 0
	
	self.midX, self.midY = 0, 0
	self.minX, self.minY, self.maxX, self.maxY = math.huge, math.huge, -math.huge, -math.huge
	self.bottomY = -math.huge
	
	for index, data in pairs(indexes) do
		if not skipOfficeMap then
			map:setTileBuilding(index, self)
		end
		
		local tileX, tileY = grid:convertIndexToCoordinates(index)
		
		self.midX, self.midY = self.midX + tileX, self.midY + tileY
		self.bottomY = math.max(self.bottomY, tileY)
		tileCount = tileCount + 1
		
		table.insert(self.tiles, index)
		
		self.minX, self.minY, self.maxX, self.maxY = math.min(self.minX, tileX), math.min(self.minY, tileY), math.max(self.maxX, tileX), math.max(self.maxY, tileY)
	end
	
	self.tileCount = tileCount
	self.midX, self.midY = self.midX / tileCount * tileW - tileW * 0.5, self.midY / tileCount * tileH - tileH * 0.5
	self.minX, self.minY, self.maxX, self.maxY = self.minX * tileW - tileW, self.minY * tileH - tileH, self.maxX * tileW - tileW, self.maxY * tileH - tileH
	self.bottomY = self.bottomY * tileH
end

function officeBuilding:addTileIndex(index)
	if not self.tileMap[index] then
		table.insert(self.tiles, index)
		
		self.tileMap[index] = true
		self.tileCount = self.tileCount + 1
		grid = game.worldObject:getFloorTileGrid()
		
		local tileW, tileH = grid:getTileSize()
		local tileX, tileY = grid:convertIndexToCoordinates(index)
		
		tileX, tileY = tileX * tileW, tileY * tileH
		self.minX, self.minY, self.maxX, self.maxY = math.min(self.minX, tileX), math.min(self.minY, tileY), math.max(self.maxX, tileX - tileW), math.max(self.maxY, tileY)
		self.midX = (self.minX + self.maxX) * 0.5
		self.midY = (self.minY + self.maxY) * 0.5 + tileH * 0.5
		self.bottomY = math.max(self.bottomY, self.maxY)
	end
	
	studio:getOfficeBuildingMap():setTileBuilding(index, self)
end

function officeBuilding:getTileCount()
	return self.tileCount
end

function officeBuilding:getTileIndexes()
	return self.tileMap, self.tiles
end

function officeBuilding:convertTiles()
	local converted = {}
	
	for key, index in ipairs(self.tiles) do
		converted[#converted + 1] = index
	end
	
	return converted
end

function officeBuilding:confirmPurchaseCallback()
	self.office:purchase()
end

function officeBuilding:setDefaultName()
	self.isDefaultName = true
	self.name = _format(_T("DEFAULT_OFFICE_NAME", "Office NUMBER"), "NUMBER", #studio:getOwnedBuildings())
end

function officeBuilding:setUnpurchasedName(buildingId)
	self.isDefaultName = true
	self.name = _format(_T("DEFAULT_BUILDING_NAME", "Building NUMBER"), "NUMBER", buildingId)
end

function officeBuilding:finishNaming()
	events:fire(officeBuilding.EVENTS.FINISHED_NAMING, self)
end

function officeBuilding:postInit()
	if self.rivalOwner then
		local company = rivalGameCompanies:getCompanyByID(self.rivalOwner)
		
		if company then
			rivalGameCompanies:getCompanyByID(self.rivalOwner):addOwnedBuilding(self)
		else
			print("company '" .. self.rivalOwner .. "' object not found for office '" .. self.id .. "'")
		end
	end
end

function officeBuilding:createOfficeNamingPopup()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setTitle(_T("ENTER_OFFICE_NAME_TITLE", "Enter Office Name"))
	frame:setSize(250, 100)
	frame:hideCloseButton()
	
	local nameTextbox = gui.create("OfficeNamingTextBox", frame)
	
	nameTextbox:setPos(_S(5), _S(35))
	nameTextbox:setSize(frame.rawW - 10, 30)
	nameTextbox:setFont(fonts.get("pix24"))
	nameTextbox:setLimitTextToWidth(true)
	nameTextbox:setShouldCenter(true)
	nameTextbox:setText(self.name or "")
	nameTextbox:setOffice(self)
	
	local confirmButton = gui.create("FinishNamingOfficeButton", frame)
	
	confirmButton:setSize(150, 25)
	confirmButton:setFont("pix20")
	confirmButton:setText(_T("CONFIRM", "Confirm"))
	confirmButton:setY(nameTextbox.y + nameTextbox.h + _S(5))
	confirmButton:setOffice(self)
	confirmButton:centerX()
	frame:center()
	frameController:push(frame)
end

function officeBuilding:setName(name)
	if string.withoutspaces(name) == "" then
		self:setDefaultName()
		
		return 
	end
	
	self.name = name
	self.isDefaultName = false
end

function officeBuilding:getName()
	if self.isDefaultName then
		return self.name
	end
	
	return self.name
end

function officeBuilding:createPurchaseConfirmationPopup()
	if self.reserved then
		local popup = game.createPopup(500, _T("BUILDING_NOT_PURCHASABLE_TITLE", "Building Not Purchasable"), _T("BUILDING_NOT_PURCHASABLE_DESC", "This office building is currently not available for sale."), "pix24", "pix20")
		
		frameController:push(popup)
		
		return 
	end
	
	if self.pedestrianBuilding then
		local popup = game.createPopup(500, _T("BUILDING_NOT_PURCHASABLE_TITLE", "Building Not Purchasable"), _T("BUILDING_RESIDENTIAL_DESC", "This is a residential building and is therefore not available for sale."), "pix24", "pix20")
		
		frameController:push(popup)
		
		return 
	end
	
	if self.rivalOwner then
		local popup = game.createPopup(500, _T("BUILDING_OWNED_BY_RIVAL_TITLE", "Building Owned By Rival"), _T("BUILDING_OWNED_BY_RIVAL_DESC", "This office building is owned by a rival and can not be purchased until the rival goes out of business."), "pix24", "pix20")
		
		frameController:push(popup)
		
		return 
	end
	
	local myCost = self:getCost()
	
	if studio:hasFunds(myCost) then
		local cost = string.comma(myCost)
		local popup = game.createPopup(400, _T("CONFIRM_BUILDING_PURCHASE_TITLE", "Confirm Building Purchase"), _format(_T("CONFIRM_BUILDING_PURCHASE_DESCRIPTION", "Are you sure you want to purchase this building for $COST?\nBuilding size in tiles: TILES"), "COST", cost, "TILES", self.tileCount), "pix24", "pix20", true)
		
		popup:addButton("pix20", _format(_T("YES_PAY_COST", "Yes (pay $COST)"), "COST", cost), officeBuilding.confirmPurchaseCallback).office = self
		
		popup:addButton("pix20", _T("NO", "No"))
		popup:center()
		frameController:push(popup)
	else
		frameController:push(game.createPopup(400, _T("NOT_ENOUGH_FUNDS_TITLE", "Not Enough Funds"), _T("NOT_ENOUGH_FUNDS_FOR_BUILDING_PURCHASE", "You do not have enough funds to purchase this building."), "pix24", "pix20"))
	end
end

officeBuilding.DEFAULT_FLOOR_PURCHASE = 2

function officeBuilding:fillFloorTiles(floor, makeParticles)
	local grid = game.worldObject:getFloorTileGrid()
	local id = officeBuilding.DEFAULT_FLOOR_PURCHASE
	
	if makeParticles then
		local expansion = studio.expansion
		local depth = expansion.SMOKE_DEPTH
		
		for key, index in ipairs(self.tiles) do
			local worldX, worldY = grid:indexToWorld(index)
			
			for i = 1, 2 do
				expansion:createSmokeParticle(worldX + math.random(-20, 20), worldY + math.random(-20, 20), depth)
			end
			
			grid:setTileValue(index, floor, id)
		end
	else
		for key, index in ipairs(self.tiles) do
			grid:setTileValue(index, floor, id)
		end
	end
end

function officeBuilding:fillBorderWalls(grid, specificFloor)
	grid = grid or game.worldObject:getFloorTileGrid()
	
	if specificFloor then
		self:_fillBorderWalls(grid, specificFloor)
	else
		for i = 1, self.purchasedFloors do
			self:_fillBorderWalls(grid, i)
		end
	end
end

officeBuilding.threadUpdateList = {}

function officeBuilding:_fillBorderWalls(grid, floor)
	local order, dir = walls.ORDER, walls.DIRECTION
	local tileMap = self.tileMap
	local objGrid = game.worldObject:getObjectGrid()
	local defaultWall = studio.DEFAULT_BORDER_WALL_ID
	local updList = self.threadUpdateList
	
	for key, tileIndex in ipairs(self.tiles) do
		local x, y = grid:convertIndexToCoordinates(tileIndex)
		
		for key, rotationID in ipairs(order) do
			local offset = dir[rotationID]
			local curX, curY = x + offset[1], y + offset[2]
			
			if not tileMap[grid:offsetIndex(tileIndex, offset[1], offset[2])] then
				local canContinue = true
				local objects = objGrid:getObjects(curX, curY, floor)
				
				if objects then
					for key, object in pairs(objects) do
						if object:getFact(game.IGNORE_WALLS_FACT) then
							canContinue = false
						end
					end
				end
				
				if canContinue and grid:getWallID(tileIndex, floor, rotationID) == 0 then
					grid:insertWall(tileIndex, floor, defaultWall, rotationID)
				end
			end
		end
	end
end

function officeBuilding:viewOfficeInfoCallback()
	monthlyCost.createOfficeMenu(self.office)
end

function officeBuilding:renameOfficeCallback()
	self.office:createOfficeNamingPopup()
end

function officeBuilding:goToCallback()
	frameController:pop()
	
	local midX, midY = self.office:getMidCoordinates()
	
	camera:setPosition(midX, midY, nil, true)
	
	if not self.office:isPlayerOwned() and not studio.expansion:isActive() then
		studio.expansion:createMenu()
	end
end

function officeBuilding:fillInteractionComboBox(combobox)
	if self.playerOwned then
		combobox:addOption(0, 0, 0, 24, _T("VIEW_OFFICE_INFO", "View office info"), fonts.get("pix20"), officeBuilding.viewOfficeInfoCallback).office = self
		combobox:addOption(0, 0, 0, 24, _T("RENAME_OFFICE", "Rename office"), fonts.get("pix20"), officeBuilding.renameOfficeCallback).office = self
	end
	
	combobox:addOption(0, 0, 0, 24, _T("GO_TO_OFFICE", "Go to"), fonts.get("pix20"), officeBuilding.goToCallback).office = self
end

function officeBuilding:save()
	local saved = {
		name = self.name,
		objects = {},
		playerOwned = self.playerOwned,
		expansionDirections = self.expansionDirections,
		id = self.id,
		buildingNumber = self.buildingNumber,
		isDefaultName = self.isDefaultName,
		roofTileIndexes = self.roofTileIndexes,
		rivalOwner = self.rivalOwner,
		reserved = self.reserved,
		pedestrianBuilding = self.pedestrianBuilding,
		purchasedFloors = self.purchasedFloors
	}
	
	for key, object in ipairs(self.objects) do
		saved.objects[#saved.objects + 1] = object:save()
	end
	
	local floorTileGrid = game.worldObject:getFloorTileGrid()
	
	saved.tileContents = {}
	
	for i = 1, self.purchasedFloors do
		saved.tileContents[i] = floorTileGrid:save(self.tiles, i)
	end
	
	return saved
end

function officeBuilding:load(data)
	self.name = data.name
	
	local tileIndexes = {}
	
	if not data.purchasedFloors then
		for key, data in ipairs(data.tileContents) do
			tileIndexes[data.index] = true
		end
	else
		for key, data in ipairs(data.tileContents[1]) do
			tileIndexes[data.index] = true
		end
	end
	
	self:setTileIndexes(tileIndexes)
	
	self.playerOwned = data.playerOwned
	self.expansionDirections = data.expansionDirections
	self.buildingNumber = data.buildingNumber or 1
	self.isDefaultName = data.isDefaultName
	self.roofTileIndexes = data.roofTileIndexes or self.roofTileIndexes
	self.rivalOwner = data.rivalOwner
	self.reserved = data.reserved
	
	self:setPedestrianBuilding(data.pedestrianBuilding)
	self:setID(data.id)
	
	self.canExpand = officeBuildingInserter.registeredByID[data.id].expandable
	self.purchasedFloors = data.purchasedFloors or self.purchasedFloors
	self.floorCount = math.max(self.floorCount, self.purchasedFloors)
	
	self:setupFloorData()
	
	if self.playerOwned then
		studio:addOwnedBuilding(self)
		self:stopDrawingRoof()
		self:fillRoofTileIndexes()
	end
	
	self.postLoadObjects = {}
	self.objectData = data.objects
	
	for key, objectData in ipairs(data.objects) do
		local newObj = objects.create(objectData.class)
		
		newObj:load(objectData)
		
		if self.playerOwned then
			newObj:onPurchased()
		end
		
		self.postLoadObjects[key] = newObj
	end
	
	local floorTileGrid = game.worldObject:getFloorTileGrid()
	
	if not data.purchasedFloors then
		floorTileGrid:load(data.tileContents, 1)
	else
		for i = 1, data.purchasedFloors do
			floorTileGrid:load(data.tileContents[i], i)
		end
	end
	
	self:setupMainDoor()
end

function officeBuilding:postLoad()
	for key, object in ipairs(self.postLoadObjects) do
		local objectData = self.objectData[key]
		
		object:postLoad(objectData)
	end
	
	self.objectData = nil
	self.postLoadObjects = nil
	
	self:calculateInterestBoost()
end

function officeBuilding:finalizeLoad()
	studio.driveAffectors:calculateDriveAffection(self)
end
