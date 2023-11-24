local staticObjectBase = {}

staticObjectBase.tileWidth = 0
staticObjectBase.tileHeight = 0
staticObjectBase.class = "static_object_base"
staticObjectBase.rotation = 1
staticObjectBase.cost = 0
staticObjectBase.scaleX = 1
staticObjectBase.scaleY = 1
staticObjectBase.addRotation = 0
staticObjectBase.STATIC_OBJECT = true
staticObjectBase.BASE = true
staticObjectBase.display = "'display' not set"
staticObjectBase.description = "'description' not set"
staticObjectBase.requiresEntrance = true
staticObjectBase.requiresObject = false
staticObjectBase.requiresSameObject = false
staticObjectBase.ignoreObjectOfType = {}
staticObjectBase.objectAtlas = "object_atlas_1"
staticObjectBase.objectAtlasBetweenWalls = "object_atlas_1_between_walls"
staticObjectBase.quad = nil
staticObjectBase.monthlyCosts = monthlyCost.new()
staticObjectBase.description = ""
staticObjectBase.affectors = {}
staticObjectBase.canHouse = {}
staticObjectBase.sizeCategory = "unhousable"
staticObjectBase.roomType = nil
staticObjectBase.minimumIllumination = 0.4
staticObjectBase.maximumEntryPoints = 0
staticObjectBase.animateOnFacing = true
staticObjectBase.xOffset = 0
staticObjectBase.yOffset = 0
staticObjectBase.xDirectionalOffset = 0
staticObjectBase.yDirectionalOffset = 0
staticObjectBase.gridUpdateState = true
staticObjectBase.enclosesTile = nil
staticObjectBase.preventsMovement = nil
staticObjectBase.preventsReach = nil
staticObjectBase.preventsLight = false
staticObjectBase.font = "pix_world22"
staticObjectBase.maxSellPrice = 1
staticObjectBase.minSellPrice = 0.2
staticObjectBase.timeUntilLowestSellPrice = timeline.DAYS_IN_MONTH * 6
staticObjectBase.onFaceAnimPlaybackSpeed = 1
staticObjectBase.onFaceAnimType = tdas.ANIMATION_TYPES.PLAYONCE
staticObjectBase.interestPoints = {}
staticObjectBase.partOfValidRoom = true
staticObjectBase.lightCaster = nil
staticObjectBase.placementHeight = 1
staticObjectBase.OFFICE_OBJECT = true
staticObjectBase.INCOMPATIBILITY_TYPES = {}

function staticObjectBase:addIncompatibilityType(typeName)
	staticObjectBase.INCOMPATIBILITY_TYPES[typeName] = table.count(staticObjectBase.INCOMPATIBILITY_TYPES) + 1
end

staticObjectBase:addIncompatibilityType("NO_LIGHT")
staticObjectBase:addIncompatibilityType("MULTIPLE_ENTRY_POINTS")
staticObjectBase:addIncompatibilityType("BAD_ENTRANCE")
staticObjectBase:addIncompatibilityType("BLOCKED_BY_OBJECT")

function staticObjectBase:init()
	staticObjectBase.baseClass.init(self)
	
	self.monthlyCosts = monthlyCost.new()
	self.incompatibilityFactors = {}
	self.entranceValid = true
	self.validObject = true
	self.reachable = true
end

function staticObjectBase:onEnterExpansionMode()
	self:verifyInvalidityDisplay()
end

function staticObjectBase:verifyInvalidityDisplay()
	if self.visibleInvalid then
		self:createInvalidityDisplay()
	end
end

function staticObjectBase:onLeaveExpansionMode()
	self:removeInvalidityDisplay()
end

function staticObjectBase:createInvalidityDisplay()
	if not self.invalidDisplay then
		self.invalidDisplay = objects.create("invalidity_display")
		
		self.invalidDisplay:setObject(self)
		self.invalidDisplay:show()
	end
end

function staticObjectBase:removeInvalidityDisplay()
	if self.invalidDisplay then
		self.invalidDisplay:remove()
		
		self.invalidDisplay = nil
	end
end

function staticObjectBase:enterVisibilityRange()
	staticObjectBase.baseClass.enterVisibilityRange(self)
	
	if studio.expansion:isActive() then
		studio.expansion:addOfficeObject(self)
		
		if self.invalidDisplay then
			if self.visibleInvalid then
				self.invalidDisplay:show()
			end
		else
			self:verifyInvalidityDisplay()
		end
	else
		self:removeInvalidityDisplay()
	end
	
	self:pickSpritebatch()
end

function staticObjectBase:canRotate()
	return true
end

function staticObjectBase:leaveVisibilityRange()
	staticObjectBase.baseClass.leaveVisibilityRange(self)
	
	if self.invalidDisplay then
		self.invalidDisplay:hide()
	end
	
	if studio.expansion:isActive() then
		studio.expansion:removeOfficeObject(self)
	end
end

function staticObjectBase:getObjectMiddle()
	local w, h = self:getPlacementIterationRange()
	
	return self.x - game.WORLD_TILE_WIDTH + w * game.WORLD_TILE_WIDTH * 0.5, self.y - game.WORLD_TILE_HEIGHT + h * game.WORLD_TILE_HEIGHT * 0.5
end

function staticObjectBase:setupPurchaseDescbox(descBox, wrapWidth)
	local description = self:getDescription()
	
	if description then
		descBox:addText(description, "pix18", nil, 0, wrapWidth)
	end
	
	self:addDescriptionToDescbox(descBox, wrapWidth)
end

function staticObjectBase:getPropAngles()
	return math.rad(walls.RAW_ANGLES[self.rotation])
end

function staticObjectBase:switchSpriteBatches()
	self.spriteBatch = studio.expansion:getSpriteSheetByID(self.textureID)
end

function staticObjectBase:getRequiresWallInFront()
	return self.requiresWallInFront
end

function staticObjectBase:returnSpritebatches()
	self:setupSpritebatches()
end

function staticObjectBase:setObjectGrid(objectGrid)
	self.objectGrid = objectGrid
end

function staticObjectBase:getObjectGrid()
	return self.objectGrid
end

function staticObjectBase:onRegister()
	if rawget(self, "preventsReach") == nil then
		self.preventsReach = self.preventsMovement
	end
	
	staticObjectBase.width = staticObjectBase.tileWidth * game.WORLD_TILE_WIDTH
	staticObjectBase.height = staticObjectBase.tileHeight * game.WORLD_TILE_HEIGHT
	
	self:setupTextureIDs()
end

function staticObjectBase:onPickOtherObject()
end

function staticObjectBase:setupTextureIDs()
	self.textureID = cache.getImageID(spriteBatchController:getContainer(self.objectAtlas):getTexture())
end

function staticObjectBase:getTileSize()
	return self.tileWidth, self.tileHeight
end

function staticObjectBase:getTileWidth()
	return self.tileWidth
end

function staticObjectBase:getTileHeight()
	return self.tileHeight
end

function staticObjectBase:getObjectType()
	return self.objectType
end

function staticObjectBase:getRoomType()
	return self.roomType
end

function staticObjectBase:setRotation(rotation)
	self.rotation = rotation
	
	self:updatePropAngles()
end

function staticObjectBase:getRotation()
	return self.rotation
end

function staticObjectBase:canPlaceOnTop(object)
	return false
end

function staticObjectBase:getName()
	return self.display
end

function staticObjectBase:setupMouseOverDescbox(descbox, wrapWidth)
	descbox:addText(self:getDisplayText(), "bh_world22", nil, 0, wrapWidth)
	self:processRoomValidityData(descbox, "bh_world18", 2, wrapWidth, "exclamation_point_red", 22, 22)
	
	if not self.reachable then
		descbox:addText(_T("OBJECT_UNREACHABLE", "This object can not be reached by anyone"), "bh_world20", nil, 0, wrapWidth, "exclamation_point_red", 22, 22)
	end
end

function staticObjectBase:getSizeCategory()
	return self.sizeCategory
end

function staticObjectBase:getDescription()
	return self.description
end

function staticObjectBase:addDescriptionToDescbox(descBox, wrapWidth)
	if self.interestPoints then
		local interestCount = table.count(self.interestPoints)
		local interestText
		
		if interestCount > 0 then
			if interestCount == 1 then
				interestText = _format(_T("OBJECT_SINGLE_INTEREST_CONTRIBUTION", "This object contributes to the INTEREST interest."), "INTEREST", interests:getData(select(1, next(self.interestPoints))).display)
			else
				local interestText = ""
				local cur = 1
				
				for interestID, pointAmount in pairs(self.interestPoints) do
					local interestData = interests:getData(interestID)
					
					if interestCount <= cur then
						interestText = interestText .. _T("CONNECTOR_AND", " and ") .. interestData.display
					elseif cur + 1 == interestCount then
						interestText = interestText .. interestData.display
					else
						interestText = interestText .. interestData.display .. ", "
					end
					
					cur = cur + 1
				end
				
				interestText = _format(_T("OBJECT_DESCRIPTION_WITH_PLURAL_CONTRIBUTION", "This object contributes to INTERESTS interests."), "INTERESTS", interestText)
			end
			
			descBox:addSpaceToNextText(10)
			descBox:addText(interestText, "bh18", nil, 0, wrapWidth, "exclamation_point", 22, 22)
		end
	end
	
	if self.affectors then
		descBox:addSpaceToNextText(5)
		
		for key, data in pairs(self.affectors) do
			local affectorData = studio.driveAffectors.registeredByID[data[1]]
			
			descBox:addText(_format(affectorData.affectorText, "CHANGE", data[2]), "bh18", nil, 0, wrapWidth, "increase", 22, 22)
		end
	end
end

function staticObjectBase:getLightCasterClass()
	return self.lightCaster
end

function staticObjectBase:getInteractAnimation(employee)
	return employee:getInteractAnimation()
end

function staticObjectBase:getPurchaseSound()
	return "place_object"
end

function staticObjectBase:isWithinGridVisibilityRange(gridStartX, gridStartY, gridEndX, gridEndY)
	return math.ccaabb(gridStartX, gridStartY, self.gridStartX, self.gridStartY, gridEndX - gridStartX, gridEndY - gridStartY, self.gridEndX - self.gridStartX, self.gridEndY - self.gridStartY)
end

function staticObjectBase:onBeingFaced(employee)
	if self.animateOnFacing then
		employee:getAvatar():addAnimToQueue(self:getInteractAnimation(employee), self.onFaceAnimPlaybackSpeed, self.onFaceAnimType)
	end
end

function staticObjectBase:getFacingAngles()
	return walls.RAW_ANGLES[self.rotation] + 90
end

function staticObjectBase:setInteractionTarget(obj)
	if obj then
		obj:setTargetObject(self)
	end
	
	self.interactionTarget = obj
end

function staticObjectBase:getInteractionTarget()
	return self.interactionTarget
end

function staticObjectBase:setFact(factID, state)
	self.facts = self.facts or {}
	
	if state == nil then
		self.facts[factID] = true
	else
		self.facts[factID] = state
	end
end

function staticObjectBase:getFact(factID)
	return self.facts and self.facts[factID]
end

function staticObjectBase:addProp(name, ...)
	staticObjectBase.baseClass.addProp(self, name, ...)
	
	if self.floor ~= camera:getViewFloor() then
		self:hideProp(name)
	end
end

function staticObjectBase:setFloor(floor)
	self.floor = floor
end

function staticObjectBase:getFloor()
	return self.floor
end

function staticObjectBase:getPreviousFloor()
	return self.prevFloor
end

function staticObjectBase:isFloorValid(floor)
	return self.floor == floor
end

function staticObjectBase:sendGridUpdateToThreads()
	game.sendGridUpdateToThreads(game.worldObject:getFloorTileGrid(), pathfinderThread.MESSAGE_TYPE.GRID_UPDATE, self.gridStartX, self.gridStartY, self.gridEndX, self.gridEndY, self.floor, true)
end

function staticObjectBase:cycleRotation(reverse)
	if reverse then
		if self.rotation == 1 then
			self:setRotation(8)
			
			return 
		end
		
		self:setRotation(self.rotation / 2)
		
		return 
	end
	
	if self.rotation == 8 then
		self:setRotation(1)
		
		return 
	end
	
	self:setRotation(self.rotation * 2)
end

function staticObjectBase:getEntryRotation()
	local destination = self.rotation
	local entry = walls.INVERSE_RELATION[destination]
	
	return entry, destination
end

function staticObjectBase:getEntranceSizeRequirement()
	if not self.requiresEntrance then
		return 0, 0
	end
	
	local rotation = self.rotation
	
	if rotation == walls.UP or rotation == walls.DOWN then
		return self.tileWidth, 1
	elseif rotation == walls.RIGHT or rotation == walls.LEFT then
		return 1, self.tileWidth
	end
end

function staticObjectBase:getEntranceTileCount()
	local x, y = self:getEntranceSizeRequirement()
	
	return x * y
end

function staticObjectBase:getEntranceTiles()
	local x, y = self:getEntranceSizeRequirement()
	
	return x * y
end

function staticObjectBase:clearIncompatibilityFactors()
	table.clearArray(self.incompatibilityFactors)
end

function staticObjectBase:isValidRoom()
	table.clearArray(self.incompatibilityFactors)
	
	self.brightEnough = self:checkBrightness()
	
	self:isEntranceValid()
	
	return self.brightEnough and not self:checkEntryPoints() and self.entranceValid
end

local concatTable = {}

function staticObjectBase:isEntranceValid()
	if not self.requiresEntrance then
		return true
	end
	
	local tileX, tileY = self:getTileCoordinates()
	local startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY = self:getPlacementCoordinates(tileX, tileY, true)
	local grid = game.worldObject:getFloorTileGrid()
	local inverseRotation = walls.INVERSE_RELATION[self.rotation]
	
	for y = entranceStartY, entranceEndY do
		for x = entranceStartX, entranceEndX do
			local index = grid:getTileIndex(x, y)
			
			if not walls:canPassThrough(grid:getWallID(index, self.floor, self.rotation)) then
				table.insert(self.incompatibilityFactors, {
					type = staticObjectBase.INCOMPATIBILITY_TYPES.BAD_ENTRANCE
				})
				
				self.entranceValid = false
				
				return false
			end
			
			local objects = self.objectGrid:getObjectsFromIndex(index, self.floor)
			
			if objects then
				for key, object in ipairs(objects) do
					if object:getPreventsMovement() and not self.ignoreObjectOfType[object.class] then
						table.insert(self.incompatibilityFactors, {
							type = staticObjectBase.INCOMPATIBILITY_TYPES.BLOCKED_BY_OBJECT,
							otherObject = object
						})
						
						self.entranceValid = false
						
						return false
					end
				end
			end
		end
	end
	
	self.entranceValid = true
	
	return true
end

function staticObjectBase:getEntranceValid()
	return self.entranceValid
end

function staticObjectBase:canPerformValidityString()
	if #self.incompatibilityFactors == 0 and self.reachable then
		return nil
	end
	
	return true
end

function staticObjectBase:processRoomValidityData(descBox, font, lineSpace, wrapWidth, icon, iconW, iconH)
	for key, data in ipairs(self.incompatibilityFactors) do
		descBox:addText(self:handleIncompatibilityData(data), font, nil, lineSpace, wrapWidth, icon, iconW, iconH)
	end
end

function staticObjectBase:handleIncompatibilityData(data)
	if data.type == staticObjectBase.INCOMPATIBILITY_TYPES.NO_LIGHT then
		return string.easyformatbykeys(_T("OBJECT_NOT_ILLUMINATED", "OBJECT requires a light level of MINIMUM lumen, current is CURRENT"), "OBJECT", self:getName(), "MINIMUM", brightnessMap.brightnessToLumen(self.minimumIllumination), "CURRENT", brightnessMap.brightnessToLumen(data.current))
	elseif data.type == staticObjectBase.INCOMPATIBILITY_TYPES.MULTIPLE_ENTRY_POINTS then
		if self.maximumEntryPoints == 1 then
			return string.easyformatbykeys(_T("MULTIPLE_ENTRY_POINTS_NOT_ALLOWED_SINGULAR", "OBJECT can not be in a room with more than MAXIMUM entry point"), "OBJECT", self:getName(), "MAXIMUM", self.maximumEntryPoints)
		else
			return string.easyformatbykeys(_T("MULTIPLE_ENTRY_POINTS_NOT_ALLOWED_PLURAL", "OBJECT can not be in a room with more than MAXIMUM entry points"), "OBJECT", self:getName(), "MAXIMUM", self.maximumEntryPoints)
		end
	elseif data.type == staticObjectBase.INCOMPATIBILITY_TYPES.BAD_ENTRANCE then
		return string.easyformatbykeys(_T("OBJECT_NEEDS_CLEAR_ENTRANCE", "OBJECT needs to have a clear entrance"), "OBJECT", self:getName())
	elseif data.type == staticObjectBase.INCOMPATIBILITY_TYPES.BLOCKED_BY_OBJECT then
		return string.easyformatbykeys(_T("OBJECT_ENTRANCE_BLOCKED_BY_OTHER_OBJECT", "No clear entrance (blocked by OBJECT)"), "OBJECT", data.otherObject:getName())
	end
	
	return nil
end

function staticObjectBase:shouldIgnoreRoomChecking(checkedBy)
	return false
end

function staticObjectBase:canBeUsed()
	return self.validObject
end

function staticObjectBase:setIsValid(valid)
	self.validObject = valid
end

function staticObjectBase:attemptRegister()
	local room = self:getRoom()
	
	if room and not room:wasAlreadyInRoom(self) then
		self:setContributesToRoom(false)
		
		local res = self:isValidRoom()
		
		if res and self.reachable then
			room:addValidRoomType(self)
			
			self.validObject = true
		else
			self.validObject = false
		end
	end
	
	if self.validObject then
		self:markAsValid()
	else
		self:markAsInvalid()
	end
end

function staticObjectBase:markAsInvalid()
	if not self._markedInvalid then
		self.office:changeInvalidObjectCount(1)
		
		self._markedInvalid = true
	end
end

function staticObjectBase:markAsValid()
	if self._markedInvalid then
		self.office:changeInvalidObjectCount(-1)
		
		self._markedInvalid = false
	end
end

function staticObjectBase:postRegisteredRooms()
end

function staticObjectBase:hasNextFloor()
	return self.office:getFloorCount() >= self.floor + 1
end

function staticObjectBase:evaluateValidityState()
	if not self.validObject or not self.entranceValid or not self.reachable then
		self.visibleInvalid = true
	else
		self.visibleInvalid = false
	end
end

function staticObjectBase:checkBrightness()
	local brightnessMap = studio:getBrightnessMap()
	local startX, startY, endX, endY = self:getUsedTiles()
	local grid = game.worldObject:getFloorTileGrid()
	local brightEnough = true
	local leastBright = 1
	
	for y = startY, endY do
		for x = startX, endX do
			local illumination = brightnessMap:getTileBrightness(grid:getTileIndex(x, y), self.floor)
			
			if illumination < self.minimumIllumination then
				leastBright = math.min(leastBright, illumination)
				brightEnough = false
			end
		end
	end
	
	if not brightEnough then
		table.insert(self.incompatibilityFactors, {
			type = staticObjectBase.INCOMPATIBILITY_TYPES.NO_LIGHT,
			current = leastBright
		})
	end
	
	return brightEnough
end

function staticObjectBase:validateReach(gridX, gridY)
	return true
end

function staticObjectBase:checkEntryPoints()
	if self.maximumEntryPoints > 0 then
		local alienRooms = 0
		local room = self:getRoom()
		local roomEntryPoints = room:getEntryPoints()
		local objGrid = game.worldObject:getFloorTileGrid()
		local wallDir = walls.DIRECTION
		
		for key, object in ipairs(roomEntryPoints) do
			local index = object:getTileIndex()
			local otherRoom = studio:getRoomOfIndex(index, self.floor)
			
			if otherRoom then
				if room ~= otherRoom then
					alienRooms = alienRooms + 1
				else
					local direction = wallDir[object:getRotation()]
					local nextIndex = objGrid:offsetIndex(object:getTileIndex(), direction[1], direction[2])
					
					if studio:getRoomOfIndex(nextIndex, self.floor) ~= room then
						alienRooms = alienRooms + 1
					end
				end
			end
		end
		
		if alienRooms > self.maximumEntryPoints then
			table.insert(self.incompatibilityFactors, {
				type = staticObjectBase.INCOMPATIBILITY_TYPES.MULTIPLE_ENTRY_POINTS
			})
		end
		
		return alienRooms > self.maximumEntryPoints
	end
	
	return false
end

function staticObjectBase:getEntranceTileDisplayOffset()
	local rotation = self.rotation
	
	if rotation == walls.UP then
		return 0, self.tileHeight
	elseif rotation == walls.RIGHT then
		return -1, 0
	elseif rotation == walls.DOWN then
		return 0, -1
	elseif rotation == walls.LEFT then
		return self.tileHeight, 0
	end
	
	return nil, nil
end

function staticObjectBase:getPlacementOffset()
	local rotation = self.rotation
	
	if rotation == walls.UP then
		return -(math.ceil(self.tileWidth / 2) - 1), 0
	elseif rotation == walls.RIGHT then
		return -math.min(self.tileWidth - 1, self.tileHeight - 1), -(math.ceil(math.max(self.tileWidth, self.tileHeight) / 2) - 1)
	elseif rotation == walls.DOWN then
		return -(math.ceil(self.tileWidth / 2) - 1), -(self.tileHeight - 1)
	elseif rotation == walls.LEFT then
		return 0, -(math.ceil(math.max(self.tileWidth, self.tileHeight) / 2) - 1)
	end
	
	return nil, nil
end

function staticObjectBase:getEdgeTileCoordinates()
	local x, y = self:getTileCoordinates()
	
	if rotation == walls.LEFT or rotation == walls.RIGHT then
		return x + self.tileHeight - 1, y + self.tileWidth - 1
	end
	
	return x + self.tileWidth, y + self.tileHeight
end

function staticObjectBase:getBottomTileCoordinates()
	local x, y = self:getTileCoordinates()
	
	if rotation == walls.LEFT or rotation == walls.RIGHT then
		return x, y + self.tileWidth - 1
	end
	
	return x, y + self.tileHeight
end

function staticObjectBase:getFrontTileCoordinates()
	local x, y = self:getTileCoordinates()
	local offset = walls.DIRECTION[self.rotation]
	
	x, y = x + offset[1], y + offset[2]
	
	if rotation == walls.LEFT or rotation == walls.RIGHT then
		return x + self.tileHeight - 1, y + self.tileWidth - 1
	end
	
	return x + self.tileWidth - 1, y + self.tileHeight - 1
end

function staticObjectBase:getCost()
	return self.cost
end

function staticObjectBase:getInterests()
	return self.interestPoints
end

function staticObjectBase:boostsInterest(interest)
	return self.interestPoints[interest] ~= nil
end

function staticObjectBase:getInterestBoost(interest)
	return self.interestPoints[interest]
end

function staticObjectBase:getPlacementIterationRange()
	local rotation = self.rotation
	
	if rotation == walls.UP or rotation == walls.DOWN then
		return self.tileWidth - 1, self.tileHeight - 1
	elseif rotation == walls.LEFT or rotation == walls.RIGHT then
		return self.tileHeight - 1, self.tileWidth - 1
	end
end

staticObjectBase.getLightCastRange = staticObjectBase.getPlacementIterationRange
staticObjectBase.getLightCastCoordinates = entity.getTileCoordinates

function staticObjectBase:getUsedTileAmount()
	return self.tileWidth * self.tileHeight
end

function staticObjectBase:getUsedTiles()
	local x, y = self:getTileCoordinates()
	local w, h = self:getPlacementIterationRange()
	
	return x, y, x + w, y + h
end

function staticObjectBase:getMouseBoundingBox()
	if walls.VERTICAL_SIDES[self.rotation] then
		return self.x, self.y, self.height, self.width
	end
	
	return self.x, self.y, self.width, self.height
end

function staticObjectBase:getEntranceCoordinates(startX, startY)
	if not startX then
		startX, startY = self:getTileCoordinates()
	end
	
	local entranceOffX, entranceOffY = self:getEntranceTileDisplayOffset()
	local entranceWidth, entranceHeight = self:getEntranceSizeRequirement()
	local entranceStartX = startX + entranceOffX
	local entranceStartY = startY + entranceOffY
	local entranceEndX = entranceStartX + entranceWidth - 1
	local entranceEndY = entranceStartY + entranceHeight - 1
	
	return entranceStartX, entranceStartY, entranceEndX, entranceEndY
end

function staticObjectBase:getEntranceInteractionCoordinates(startX, startY)
	local entranceStartX, entranceStartY, entranceEndX, entranceEndY = self:getEntranceCoordinates(startX, startY)
	
	return math.random(entranceStartX, entranceEndX), math.random(entranceStartY, entranceEndY)
end

function staticObjectBase:getPlacementCoordinatesNoEntrance(baseX, baseY, noOffset)
	local grid = game.worldObject:getFloorTileGrid()
	
	if not baseX or not baseY then
		baseX, baseY = grid:getMouseTileCoordinates()
	else
		local direction = walls.DIRECTION[self.rotation]
		local w, h = self:getPlacementIterationRange()
		
		if not noOffset then
			baseX = baseX + w * math.max(direction[1], 0)
			baseY = baseY + h * math.max(direction[2], 0)
		end
	end
	
	local sizeX, sizeY = self:getPlacementIterationRange()
	local startX = baseX
	local startY = baseY
	local offsetX, offsetY = self:getPlacementOffset()
	
	if not noOffset then
		startX = startX + offsetX
		startY = startY + offsetY
	end
	
	local endX = startX + sizeX
	local endY = startY + sizeY
	
	return startX, startY, endX, endY
end

function staticObjectBase:getPlacementCoordinates(baseX, baseY, noOffset)
	local startX, startY, endX, endY = self:getPlacementCoordinatesNoEntrance(baseX, baseY, noOffset)
	local entranceStartX, entranceStartY, entranceEndX, entranceEndY = self:getEntranceCoordinates(startX, startY)
	
	return startX, startY, endX, endY, entranceStartX, entranceStartY, entranceEndX, entranceEndY
end

function staticObjectBase:checkForObstruction(startX, startY, endX, endY)
	if not self.preventsMovement then
		return false
	end
	
	local left = walls.DIRECTION[walls.LEFT_SIDE[self.rotation]]
	local objectGrid = game.worldObject:getObjectGrid()
	
	for y = startY, endY do
		for x = startX, endX do
			if self:_checkForObstruction(x, y, objectGrid) then
				return true
			end
		end
	end
	
	return false
end

function staticObjectBase:getPlacementHeight()
	return self.placementHeight
end

function staticObjectBase:_checkForObstruction(x, y, objectGrid)
	local objects = objectGrid:getObjects(x, y)
	
	if objects then
		for key, object in ipairs(objects) do
			if object.requiresEntrance then
				local entranceStartX, entranceStartY, entranceEndX, entranceEndY = object:getEntranceCoordinates(object:getTileCoordinates())
				
				if entranceStartX <= x and x <= entranceEndX and entranceStartY <= y and y <= entranceEndX then
					return true
				end
			end
		end
	end
	
	return false
end

function staticObjectBase:canAddToTile(x, y, isEntrance, floor)
	local world = game.worldObject
	local grid = world:getFloorTileGrid()
	local objectGrid = world:getObjectGrid()
	local index = grid:getTileIndex(x, y)
	
	floor = floor or self.floor
	
	if grid:outOfBounds(x, y) or grid:isEmpty(index, floor) or not studio:hasBoughtTile(index) then
		return false
	end
	
	local objects = objectGrid:getObjects(x, y, floor)
	local initialObject
	local ownHeight = self:getPlacementHeight()
	
	if objects and #objects > 0 then
		local found = false
		
		for key, object in ipairs(objects) do
			if object:getPlacementHeight() == ownHeight then
				if isEntrance and not object:getPreventsMovement() then
					return true
				end
				
				initialObject = initialObject or object
				
				if self.requiresSameObject and object ~= initialObject then
					return false
				end
				
				if not object:canPlaceOnTop(self) then
					return false
				elseif type(self.requiresObject) == "string" and self.requiresObject ~= object:getClass() then
					return false
				end
				
				found = true
			end
		end
		
		if self.requiresObject and not found then
			return false
		end
	elseif self.requiresObject == true then
		return false
	end
	
	return true
end

function staticObjectBase:addEventReceiver()
	if self.CATCHABLE_EVENTS then
		events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
	end
end

function staticObjectBase:removeEventReceiver()
	if self.CATCHABLE_EVENTS then
		events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
	end
end

function staticObjectBase:onPurchased()
	self:addEventReceiver()
	studio:addOwnedObject(self)
	
	self.purchaseTime = timeline.curTime
end

function staticObjectBase:playPurchaseSound(placedX, placedY)
	if self.onPurchasedSound then
		sound.addTimed(self.onPurchasedSound, 0.3, placedX, placedY)
	end
end

function staticObjectBase:getEnclosesTile()
	return self.enclosesTile
end

function staticObjectBase:getFloorCheckRange(floor)
	return floor, floor
end

function staticObjectBase:setInvalidFloorPlacement(floor)
	self.invalidFloorPlacement = floor
end

function staticObjectBase:canPlace(startX, startY, endX, endY)
	return true
end

function staticObjectBase:canInteractWithExpansion()
	return self.purchaseTime ~= nil
end

function staticObjectBase:setReachable(state)
	self.reachable = state
	
	if not state then
		self:markAsInvalid()
	end
end

function staticObjectBase:isReachable()
	return self.reachable
end

function staticObjectBase:isValidForInteraction()
	return self.reachable and self.entranceValid
end

staticObjectBase.canReach = staticObjectBase.isReachable
staticObjectBase.getCanReach = staticObjectBase.isReachable

function staticObjectBase:getPreventsMovement()
	return self.preventsMovement
end

function staticObjectBase:getPreventsReach()
	return self.preventsReach
end

function staticObjectBase:setRestsOn(object)
	self.restsOn = object
	
	if self.inheritsRotation then
		self:setRotation(object:getRotation())
	end
end

function staticObjectBase:getRestsOn()
	return self.restsOn
end

function staticObjectBase:getBorderTileOffset()
	local rotation = self.rotation
	
	if rotation == walls.UP then
		return 0, -1
	elseif rotation == walls.RIGHT then
		return self.tileHeight, 0
	elseif rotation == walls.DOWN then
		return 0, self.tileHeight
	elseif rotation == walls.LEFT then
		return -1, 0
	end
	
	return nil, nil
end

function staticObjectBase:getBorderTileIterationRange()
	local rotation = self.rotation
	
	if rotation == walls.UP or rotation == walls.DOWN then
		return self.tileWidth, 1
	elseif rotation == walls.RIGHT or rotation == walls.LEFT then
		return 1, self.tileWidth
	end
	
	return nil, nil
end

function staticObjectBase:getPositionIterationRange()
	local tileX, tileY = self:getTileCoordinates()
	local w, h = self:getPlacementIterationRange()
	
	return tileX, tileY, tileX + w, tileY + h
end

function staticObjectBase:getBorderTiles(startX, startY)
	if not startX then
		startX, startY = self.objectGrid:getMouseTileCoordinates()
	end
	
	local offX, offY = self:getBorderTileOffset()
	local xRange, yRange = self:getBorderTileIterationRange()
	local startX = startX + offX
	local startY = startY + offY
	
	return startX, startX + xRange - 1, startY, startY + yRange - 1
end

function staticObjectBase:canInheritAboveObjectRotation(object)
	if self.inheritFrontObjectRotation then
		return self.inheritFrontObjectRotation[object:getObjectType()]
	end
	
	return false
end

function staticObjectBase:onCanPlace(parentObject)
	if not parentObject then
		return 
	end
	
	self:setRotation(parentObject:getRotation())
end

function staticObjectBase:onMouseOver()
	self.mouseOver = true
	
	objectSelector:onMouseOverObject(self)
	outlineShader:setDrawObject(self)
end

function staticObjectBase:onMouseLeft()
	self.mouseOver = false
	self.mouseOverString = nil
	
	outlineShader:setDrawObject(nil)
end

function staticObjectBase:setGridUpdateState(state)
	self.gridUpdateState = state
end

function staticObjectBase:removeFromGrid(skipUpdate)
	if not self.gridStartX then
		return 
	end
	
	local tileX, tileY = self:getTileCoordinates()
	local w, h = self:getPlacementIterationRange()
	
	self:_removeFromGrid(tileX, tileY, w, h)
	
	if self.office then
		self.office:removeObject(self)
	end
	
	self:removeFromRoom()
	
	if self.gridUpdateState then
		self:sendGridUpdateToThreads()
	end
end

function staticObjectBase:_removeFromGrid(tileX, tileY, w, h)
	local grid = self.objectGrid
	
	for y = tileY, tileY + h do
		for x = tileX, tileX + w do
			grid:removeObject(x, y, self)
		end
	end
end

function staticObjectBase:removeFromRoom()
	local office, floor, index = self:getRemovalData()
	
	self:_removeFromRoom(floor, index)
end

function staticObjectBase:_removeFromRoom(floor, index)
	local roomMap = studio:getRoomMap()[floor]
	
	if roomMap then
		local room = roomMap[index]
		
		if room then
			room:removeObject(self)
		end
	end
end

function staticObjectBase:getRemovalData()
	if self.movedObjectOffice then
		return self.movedObjectOffice, self.movedObjectFloor, self.objectGrid:getTileIndex(self.movedObjectX, self.movedObjectY)
	end
	
	return self.office, self.floor, self.objectGrid:worldToIndex(self:getPos())
end

function staticObjectBase:getMovedObjectOffice()
	return self.movedObjectOffice
end

function staticObjectBase:removeFromFloors()
	local officeObject, floor, index = self:getRemovalData()
	local floorObjList = officeObject:getObjectsByFloorObject()
	
	table.removeObject(floorObjList[floor], self)
	
	return floor
end

function staticObjectBase:remove()
	if self._removed then
		return 
	end
	
	if self.visible and studio.expansion:isActive() then
		studio.expansion:removeOfficeObject(self)
	end
	
	self:removeEventReceiver(self)
	staticObjectBase.baseClass.remove(self)
	interactionController:verifyComboBoxValidity()
	self:removeInvalidityDisplay()
	self:removeFromGrid()
	self:disableLightCasting(true)
	self:onRemoved()
	
	self._removed = true
	self.objectGrid = nil
end

function staticObjectBase:onRoomsUpdated()
	self:attemptRegister()
end

function staticObjectBase:postRoomsUpdated()
	self:evaluateValidityState()
	
	if self.mouseOver then
		local descbox = objectSelector:getMouseOverDescbox()
		
		if descbox and descbox:getObject() == self then
			descbox:updateDescbox(true)
		end
	end
	
	if self.visible then
		if not self.visibleInvalid then
			self:removeInvalidityDisplay()
		else
			self:createInvalidityDisplay()
		end
	end
end

function staticObjectBase:handleEvent(event)
end

function staticObjectBase:handleClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:setInteractionObject(self)
		
		return true
	end
end

function staticObjectBase:handleMouseWheel(direction)
	return objectSelector:cycleInteractionObject(direction)
end

function staticObjectBase:getSellDisplay()
	return self.display
end

function staticObjectBase:getSellAmount()
	return math.round(self:getCost() * self:getSellAmountTimeAffector())
end

function staticObjectBase:getSellAmountTimeAffector()
	return math.lerp(self.maxSellPrice, self.minSellPrice, math.min((timeline.curTime - self.purchaseTime) / self.timeUntilLowestSellPrice, 1))
end

function staticObjectBase:sell()
	local sellAmount = self:getSellAmount()
	
	studio:addFunds(sellAmount, nil, "office_expansion")
	sound:play("sell_object", nil, self:getPos())
	
	if self.restsOn then
		self.restsOn:onObjectRemoved(self)
	end
	
	self:createCashDisplay(sellAmount)
	self:remove()
	events:fire(studio.expansion.EVENTS.REMOVED_OBJECT, self)
end

function staticObjectBase:createCashDisplay(sellAmount)
	local cashDisplay = gui.create("HUDFloatingCashDisplay")
	
	cashDisplay:setBasePos(self:getPos())
	cashDisplay:setFont("bh20")
	
	local clr
	
	if sellAmount > 0 then
		clr = game.UI_COLORS.GREEN
	else
		clr = game.UI_COLORS.RED
	end
	
	cashDisplay:setText(string.roundtobigcashnumber(sellAmount), clr)
	cashDisplay:addDepth(100)
end

function staticObjectBase:canSell()
	return true
end

function staticObjectBase:canMove()
	return true
end

local function sellObjectConfirmCallback(self)
	local office = self.object:getOffice()
	
	self.object:sell()
	studio:reevaluateOffice(nil, office, self.object:getFloor())
end

local function sellObjectComboBoxOption(self)
	local objectName = self.object:getSellDisplay()
	local popup = game.createPopup(500, _T("CONFIRM_OBJECT_SELL_TITLE", "Confirm Sell"), _format(_T("CONFIRM_OBJECT_SELL_DESC", "Are you sure you want to sell this OBJECT?"), "OBJECT", objectName), "pix24", "pix20", true, nil)
	local button = popup:addButton("pix20", _format(_T("SELL_OBJECT_FOR_MONEY", "Sell OBJECT for $MONEY"), "OBJECT", objectName, "MONEY", string.comma(self.object:getSellAmount())), sellObjectConfirmCallback)
	
	button.object = self.object
	
	popup:addButton("pix20", _T("CANCEL", "Cancel"))
	popup:center()
	frameController:push(popup)
end

local function moveObjectComboBoxOption(self)
	studio.expansion:createMenu()
	studio.expansion:setDemolitionMode(studio.expansion.CONSTRUCTION_MODE.OBJECTS)
	studio.expansion:setDemolishing(true)
	studio.expansion:startMovingObject(self.object)
end

function staticObjectBase:fillInteractionComboBox(comboBox)
	if self:canSell() then
		local option = comboBox:addOption(0, 0, 0, 24, _format(_T("SELL_OBJECT_FOR_AMOUNT", "Sell OBJECT for $AMOUNT"), "OBJECT", self:getSellDisplay(), "AMOUNT", self:getSellAmount()), fonts.get("pix20"), sellObjectComboBoxOption)
		
		option.object = self
	end
	
	if self:canMove() then
		local option = comboBox:addOption(0, 0, 0, 24, _format(_T("MOVE_OBJECT", "Move OBJECT"), "OBJECT", self:getSellDisplay()), fonts.get("pix20"), moveObjectComboBoxOption)
		
		option.object = self
	end
end

function staticObjectBase:onRemoved()
	if self.office then
		studio:removeOwnedObject(self)
	end
end

function staticObjectBase:getDriveAffector()
	return self.affectors
end

function staticObjectBase:setIsPartOfValidRoom(state)
	self.partOfValidRoom = state
end

function staticObjectBase:isPartOfValidRoom()
	return self.partOfValidRoom
end

function staticObjectBase:setContributesToRoom(state)
	if not state and self.contributesToRoom then
		self:onContributesToRoom()
	elseif state and not self.contributesToRoom then
		self:onNotContributesToRoom()
	end
	
	self.contributesToRoom = state
end

function staticObjectBase:onContributesToRoom()
end

function staticObjectBase:onNotContributesToRoom()
end

function staticObjectBase:getContributesToRoom()
	return self.contributesToRoom
end

function staticObjectBase:getIcon()
	return self.icon
end

function staticObjectBase:setupSpritebatches()
	self:pickSpritebatch()
	
	self.atlasTexture = self.spriteBatch:getTexture()
	
	self:_setupSpritebatches()
end

function staticObjectBase:updateSpritebatches()
	if self.rotation == walls.DOWN then
		self:pickSpritebatch()
	end
end

function staticObjectBase:pickSpritebatch()
	if self.rotation == walls.DOWN then
		local y = self.gridEndY
		local grid = game.worldObject:getFloorTileGrid()
		
		if self.gridStartX then
			for x = self.gridStartX, self.gridEndX do
				if grid:hasWall(grid:getTileIndex(x, y), self.floor, walls.DOWN) then
					self:_pickSpritebatches(true)
					
					return 
				end
			end
		else
			self:_pickSpritebatches(false)
		end
	end
	
	self:_pickSpritebatches(false)
end

function staticObjectBase:_pickSpritebatches(lowerWallPresent)
	local prevBatch = self.spriteBatch
	local newBatch = lowerWallPresent and spriteBatchController:getContainer(self.objectAtlasBetweenWalls) or spriteBatchController:getContainer(self.objectAtlas)
	
	if newBatch ~= prevBatch then
		self:clearSprite()
		
		if prevBatch then
			for key, sb in ipairs(self.spriteBatches) do
				sb:decreaseVisibility()
				
				self.spriteBatches[key] = nil
			end
		end
		
		self.spriteBatch = newBatch
		
		self:updateSprite()
		
		if prevBatch then
			self:referenceSpritebatches()
			self:increaseVisibility()
		end
	else
		self.spriteBatch = newBatch
	end
end

function staticObjectBase:storeMoveData()
	self.movedObjectRotation = self.rotation
	self.movedObjectX, self.movedObjectY = self:getTileCoordinates()
	self.movedObjectFloor = self.floor
	self.movedObjectOffice = self.office
end

function staticObjectBase:clearMoveData()
	self.movedObjectRotation = nil
	self.movedObjectX, self.movedObjectY = nil
	self.movedObjectFloor = nil
	self.movedObjectOffice = nil
end

function staticObjectBase:beginMoving()
	self.moving = true
	
	self:storeMoveData()
	self:clearSprite()
	self:switchSpriteBatches()
	self:hideProps()
	self:onBeginMoving()
	self:removeFromGrid()
	objectSelector:reset(true)
end

function staticObjectBase:finishMoving()
	self.moving = false
	
	self:returnSpritebatches()
	self:showProps()
	self:onFinishMoving()
end

function staticObjectBase:cancelMoving()
	self.moving = false
	
	self:clearSprite()
	
	local gridW, gridH = self.objectGrid:getTileSize()
	local x, y = self.movedObjectX, self.movedObjectY
	
	self:showProps()
	self:setRotation(self.movedObjectRotation)
	self:setPos(x * gridW, y * gridH)
	self:finalizeGridPlacement(x, y, self.movedObjectFloor, true)
	self:returnSpritebatches()
	self:sendGridUpdateToThreads()
end

function staticObjectBase:onBeginMoving()
end

function staticObjectBase:onFinishMoving()
end

function staticObjectBase:onMoving(newX, newY)
	self:setPos(newX, newY)
	self:updateSprite()
end

function staticObjectBase:onMovingPurchaseMode(newX, newY)
	self:setPos(newX, newY)
	self:updateSprite()
end

function staticObjectBase:selectForPurchase()
end

function staticObjectBase:getDrawAngles(rotation)
	return walls.RAW_ANGLES[rotation]
end

function staticObjectBase:getDisplayText()
	return self.display
end

function staticObjectBase:rawDraw(x, y)
	local x, y, xOff, yOff, rotation = self:getDrawPosition(x, y)
	local scaleX, scaleY = self:getScale()
	
	love.graphics.draw(self.atlasTexture, self:getTextureQuad(), x, y, rotation, scaleX, scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
end

function staticObjectBase:drawOutline()
	local quad = self:getTextureQuad()
	local x, y, xOff, yOff, rotation = self:getDrawPosition(self.x, self.y)
	local scaleX, scaleY = self:getScale()
	
	outlineShader:setupThickness(quad)
	love.graphics.draw(self.atlasTexture, self:getTextureQuad(), math.round(x), math.round(y), rotation, scaleX, scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
end

function staticObjectBase:onReach(employee, currentCell, previousCell)
end

function staticObjectBase:onLeaveReach(employee)
end

function staticObjectBase:postDrawExpansion(startX, startY)
end

function staticObjectBase:updateSprite()
	if self.visible then
		local quad = self:getTextureQuad()
		local x, y, xOff, yOff, rotation = self:getDrawPosition()
		
		self.spriteID = self.spriteID or self.spriteBatch:allocateSlot()
		
		local scaleX, scaleY = self:getScale()
		
		self.spriteBatch:setColor(self:getDrawColor())
		self.spriteBatch:updateSprite(self.spriteID, quad, math.round(x), math.round(y), rotation, scaleX, scaleY, math.round(xOff * 0.5), math.round(yOff * 0.5))
	end
end

function staticObjectBase:getDrawColor()
	if (self.visibleInvalid or not self.reachable) and studio.expansion:isActive() then
		return studio.expansion.RED_FLICKER_COLOR:unpack()
	end
	
	return 255, 255, 255, 255
end

function staticObjectBase:draw()
end

function staticObjectBase:drawMouseOverText(text)
	if not text then
		return 
	end
	
	local textWidth = self.displayFont:getWidth(text) + 10
	local xPos, yPos = objectSelector:adjustMouseOverPosition(self.x, self.y)
	
	love.graphics.setColor(0, 0, 0, 150)
	love.graphics.rectangle("fill", xPos, yPos, textWidth, self.displayHeight * string.countlines(text))
	love.graphics.setFont(self.displayFont)
	love.graphics.printST(text, xPos + 5, yPos, 255, 255, 255, 255, 0, 0, 0, 255)
end

function staticObjectBase:setupMouseOverText()
	if studio.expansion:isActive() then
		if studio.expansion:isDemolishing() then
			self.mouseOverString = nil
		else
			self.mouseOverString = self:getRoomValidityString()
		end
	else
		self.mouseOverString = self:getDisplayText()
	end
end

function staticObjectBase:drawMouseOver()
end

function staticObjectBase:postDraw()
end

function staticObjectBase:getMonthlyCosts()
	return self.monthlyCosts
end

function staticObjectBase:onRebuildingRooms()
end

function staticObjectBase:onRebuiltRooms()
end

function staticObjectBase:canPlaceOnTopOf(otherObject)
	return false
end

function staticObjectBase:onOfficeChanged(oldOffice)
	oldOffice:removeObject(self)
end

function staticObjectBase:setOffice(office)
	local oldOffice = self.office
	
	if oldOffice and office ~= oldOffice then
		self:onOfficeChanged(office)
	end
	
	if office then
		self.office = office
		
		office:addObject(self, oldOffice)
	end
end

function staticObjectBase:canShowPlacementSmoke()
	return true
end

function staticObjectBase:removeOffice()
	self.office = nil
end

function staticObjectBase:getOffice()
	return self.office
end

local placedOnTop, placedOnTopMap = {}, {}

function staticObjectBase:finalizeGridPlacement(baseX, baseY, floor, noOffset)
	local startX, startY, endX, endY = self:getPlacementCoordinates(baseX, baseY, noOffset)
	local objectGrid = game.worldObject:getObjectGrid()
	local building = studio:getOfficeBuildingMap():getTileBuilding(objectGrid:getTileIndex(startX, startY))
	
	if floor then
		self:setFloor(floor)
	end
	
	if building then
		self:setOffice(building)
	end
	
	self.gridStartX = startX
	self.gridEndX = endX
	self.gridStartY = startY
	self.gridEndY = endY
	
	self:insertToObjectGrid()
end

function staticObjectBase:insertToObjectGrid()
	self:_insertToObjectGrid(self.gridStartX, self.gridStartY, self.gridEndX, self.gridEndY, self.floor)
end

function staticObjectBase:_insertToObjectGrid(startX, startY, endX, endY, floor)
	local objectGrid = game.worldObject:getObjectGrid()
	local ownHeight = self:getPlacementHeight()
	
	for y = startY, endY do
		for x = startX, endX do
			local objects = objectGrid:getObjects(x, y, floor)
			
			if objects then
				for key, otherObject in ipairs(objects) do
					if otherObject ~= self and otherObject:getPlacementHeight() == ownHeight and otherObject:canPlaceOnTopOf(self) and not placedOnTopMap[otherObject] then
						placedOnTop[#placedOnTop + 1] = otherObject
						placedOnTopMap[otherObject] = true
					end
				end
			end
			
			objectGrid:addObject(x, y, self, floor)
		end
	end
	
	for key, otherObject in ipairs(placedOnTop) do
		otherObject:onObjectPlacedOnTop(self)
		
		placedOnTop[key] = nil
		placedOnTopMap[otherObject] = nil
	end
end

function staticObjectBase:getGridCoords()
	return self.gridStartX, self.gridStartY, self.gridEndX, self.gridEndY
end

function staticObjectBase:save()
	local x, y = self:getTileCoordinates()
	local saved = {}
	
	saved.x = x
	saved.y = y
	saved.class = self.class
	saved.rotation = self.rotation
	saved.purchaseTime = self.purchaseTime
	saved.facts = self.facts
	saved.floor = self.floor
	
	return saved
end

function staticObjectBase:addToPurchaseMenu(scroller, w, h, categoryId, categoryKey)
	local icon = gui.create("ObjectPurchaseButton")
	
	icon:setSize(w, h)
	icon:setPurchaseData(categoryId, categoryKey)
	scroller:addItem(icon)
	
	return icon
end

function staticObjectBase:load(data)
	local objectGrid = game.worldObject:getObjectGrid()
	local w, h = objectGrid:getTileSize()
	
	self.facts = data.facts
	
	self:setFloor(data.floor or 1)
	self:setRotation(data.rotation)
	self:setPos(data.x * w, data.y * h)
	self:finalizeGridPlacement(data.x, data.y, data.floor or 1, true)
	
	self.purchaseTime = data.purchaseTime
end

function staticObjectBase:postLoad(data)
end

objects.registerNew(staticObjectBase, "generic_object")
