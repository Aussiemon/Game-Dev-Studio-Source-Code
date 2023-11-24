local lightSource = {}

lightSource.class = "light_source_base"
lightSource.objectType = "light_source"
lightSource.display = "Light source"
lightSource.requiresEntrance = false
lightSource.requiresWallInFront = false
lightSource.preventsMovement = false
lightSource.illuminationRadius = 5
lightSource.objectAtlas = "object_atlas_3"
lightSource.enableLightCastingSound = "toggle_light"
lightSource.disableLightCastingSound = nil
lightSource.minimumIllumination = 0
lightSource.BASE = true
lightSource.lightCaster = "lamp_caster"
lightSource.lightColor = color(251, 255, 237, 255)
lightSource.placementHeight = 100
lightSource.EVENTS = {
	TOGGLED = events:new()
}
lightSource.displayedIlluminatedTiles = {}

function lightSource:init()
	lightSource.baseClass.init(self)
	self:disableLightCasting()
	
	self.debugColor = color(255, 255, 255, 150)
	
	self.debugColor:random()
	
	self.illuminatedTiles = {}
	self.illuminatedTilesMap = {}
end

function lightSource:shouldIgnoreRoomChecking(checkedBy)
	return true
end

function lightSource:setReachable(state)
	self.reachable = true
end

function lightSource:onEmployeeEntered()
	self:enableLightCasting()
end

function lightSource:onEmployeeLeft()
	self:disableLightCasting()
end

function lightSource:postRegisteredRooms()
	self:updateLightState()
end

function lightSource:getIlluminatedTiles()
	return self.illuminatedTiles
end

function lightSource:getIlluminatedTileMap()
	return self.illuminatedTilesMap
end

function lightSource:castLight(imageData, pixelX, pixelY)
	local clr = self.lightColor
	local r, g, b = imageData:getPixel(pixelX, pixelY)
	
	imageData:setPixel(pixelX, pixelY, math.max(r, clr.r), math.max(g, clr.g), math.max(b, clr.b), 255)
end

local currentIteratedObject, curIterFloor

function lightSource.losIteratorCallback(index, tileX, tileY)
	currentIteratedObject:addIlluminatedTile(index, tileX, tileY)
	
	local objects = currentIteratedObject.objectGrid:getObjectsFromIndex(index, curIterFloor)
	
	if objects then
		for key, object in ipairs(objects) do
			if object.preventsLight then
				return false
			end
		end
	end
end

function lightSource.losWallCheckCallback(grid, index, wallSide)
	return walls:stopsLight(grid:getWallID(index, curIterFloor, wallSide))
end

function lightSource:updateLightState()
	if self.room and #self.room:getEmployees() > 0 then
		self:enableLightCasting()
	else
		self:disableLightCasting()
	end
end

function lightSource:enableLightCasting()
	if not self.castingLight and self.enableLightCastingSound and not studio.expansion:isActive() then
		if not game.worldObject:isFinishingLoad() then
			self:playSound(self.enableLightCastingSound, true)
		end
		
		events:fire(lightSource.EVENTS.TOGGLED, self)
	end
	
	lightSource.baseClass.enableLightCasting(self)
end

function lightSource:disableLightCasting()
	if self.castingLight and self.disableLightCastingSound and not studio.expansion:isActive() then
		if not game.worldObject:isFinishingLoad() then
			self:playSound(self.disableLightCastingSound, true)
		end
		
		events:fire(lightSource.EVENTS.TOGGLED, self)
	end
	
	lightSource.baseClass.disableLightCasting(self)
end

function lightSource:calculateTileBrightness(tileX, tileY)
	local x, y = math.dist(tileX, self.lightTileX), math.dist(tileY, self.lightTileY)
	local mag = math.magnitude(x, y)
	
	return 1 - 1 * mag / self.illuminationRadius
end

function lightSource:addIlluminatedTile(index, tileX, tileY)
	if not self.illuminatedTilesMap[index] then
		local brightness = self:calculateTileBrightness(tileX, tileY)
		
		self.illuminatedTilesMap[index] = brightness
		self.illuminatedTiles[#self.illuminatedTiles + 1] = index
		
		self.brightnessMap:setTileBrightness(index, brightness, self)
	end
end

function lightSource:illuminateNearbyTiles()
	self:resetTileIllumination()
	
	local halfRadius = self.illuminationRadius
	local losCheckDistance = self.illuminationRadius + 1
	local iterW, iterH = halfRadius, halfRadius
	local tileX, tileY = self:getTileCoordinates()
	local grid = game.worldObject:getFloorTileGrid()
	
	self.lightTileX = tileX
	self.lightTileY = tileY
	self.brightnessMap = studio:getBrightnessMap()
	currentIteratedObject = self
	curIterFloor = self:getFloor()
	
	local startX, startY, finishX, finishY = tileX - iterW, tileY - iterH, tileX + iterW, tileY + iterH
	local floor = self.floor
	
	for key, object in ipairs(self.room:getObjectsForLight()) do
		if object.minimumIllumination > 0 then
			local tStartX, tStartY, tFinishX, tFinishY = object:getUsedTiles()
			local canContinue = not (finishX < tStartX) and not (finishY < tStartY) and not (tFinishX < startX) and not (tFinishY < startY)
			
			if canContinue then
				for y = tStartY, tFinishY do
					for x = tStartX, tFinishX do
						if not self.brightnessMap:isIlluminatingTile(grid:getTileIndex(x, y), self) then
							util.los(tileX, tileY, x, y, floor, losCheckDistance, true, lightSource.losIteratorCallback, lightSource.losWallCheckCallback)
						end
					end
				end
			end
		end
	end
	
	currentIteratedObject = nil
	curIterFloor = nil
	self.brightnessMap = nil
end

local illuminatedTileList = {}
local illuminatedTileMap = {}

function lightSource.losIteratorCallbackDisplay(index, tileX, tileY)
	if not illuminatedTileMap[index] then
		local bright = currentIteratedObject:calculateTileBrightness(tileX, tileY)
		
		illuminatedTileList[#illuminatedTileList + 1] = index
		illuminatedTileMap[index] = bright
	end
	
	local objects = currentIteratedObject.objectGrid:getObjectsFromIndex(index, curIterFloor)
	
	if objects then
		for key, object in ipairs(objects) do
			if object.preventsLight then
				return false
			end
		end
	end
end

function lightSource:findIlluminatedTiles(targetList, tileX, tileY)
	local halfRadius = self.illuminationRadius
	local losCheckDistance = self.illuminationRadius + 1
	local iterW, iterH = halfRadius, halfRadius
	
	currentIteratedObject = self
	curIterFloor = self:getFloor()
	self.lightTileX = tileX
	self.lightTileY = tileY
	
	local curY = tileY - iterH
	local floor = self.floor
	
	for x = tileX - iterW, tileX + iterW do
		util.los(tileX, tileY, x, curY, floor, losCheckDistance, true, lightSource.losIteratorCallbackDisplay, lightSource.losWallCheckCallback)
	end
	
	local curY = tileY + iterH
	
	for x = tileX - iterW, tileX + iterW do
		util.los(tileX, tileY, x, curY, floor, losCheckDistance, true, lightSource.losIteratorCallbackDisplay, lightSource.losWallCheckCallback)
	end
	
	local curX = tileX - iterW
	
	for y = tileY - iterH, tileY + iterH do
		util.los(tileX, tileY, curX, y, floor, losCheckDistance, true, lightSource.losIteratorCallbackDisplay, lightSource.losWallCheckCallback)
	end
	
	local curX = tileX + iterW
	
	for y = tileY - iterH, tileY + iterH do
		util.los(tileX, tileY, curX, y, floor, losCheckDistance, true, lightSource.losIteratorCallbackDisplay, lightSource.losWallCheckCallback)
	end
	
	currentIteratedObject = nil
	curIterFloor = nil
	
	return illuminatedTileList, illuminatedTileMap
end

function lightSource:setFloor(floor)
	local prevFloor = self.floor
	
	if prevFloor and floor ~= prevFloor then
		studio:getBrightnessMap():removeLightSource(self, prevFloor)
	end
	
	lightSource.baseClass.setFloor(self, floor)
end

function lightSource:resetTileIllumination()
	local brightnessMap = studio:getBrightnessMap()
	local prev = self.prevFloor or self.floor
	
	for key, index in ipairs(self.illuminatedTiles) do
		brightnessMap:resetTileBrightness(index, self, prev)
		
		self.illuminatedTiles[key] = nil
		self.illuminatedTilesMap[index] = nil
	end
end

function lightSource:remove()
	studio:getBrightnessMap():removeLightSource(self, self.floor)
	lightSource.baseClass.remove(self)
end

function lightSource:load(data)
	lightSource.baseClass.load(self, data)
end

function lightSource:onRebuildingRooms()
	self:resetTileIllumination()
end

function lightSource:postDrawExpansion(startX, startY, endX, endY)
	local halfW, halfH = self:getHalfSize()
	local worldX, worldY = game.worldObject:getFloorTileGrid():gridToWorld(startX, startY)
	
	self:drawIlluminationDisplay(worldX + halfW, worldY + halfH, self:findIlluminatedTiles(targetList, startX, startY))
	
	for key, index in ipairs(illuminatedTileList) do
		illuminatedTileList[key] = nil
		illuminatedTileMap[index] = nil
	end
end

function lightSource:onRebuiltRooms()
	self:illuminateNearbyTiles()
	self:updateLightState()
end

function lightSource:getTileBrightness(index)
	return self.illuminatedTilesMap[index]
end

function lightSource:onMouseOver()
	lightSource.baseClass.onMouseOver(self)
	
	if studio.expansion:isActive() then
		table.clearArray(lightSource.displayedIlluminatedTiles)
		
		local tileList, tileMap = self:findIlluminatedTiles(targetList, self:getTileCoordinates())
		
		for key, index in ipairs(tileList) do
			lightSource.displayedIlluminatedTiles[key] = index
			tileList[key] = nil
			tileMap[index] = nil
		end
	end
end

function lightSource:postDraw()
	lightSource.baseClass.postDraw(self)
	
	if self.mouseOver and studio.expansion:isActive() then
		self:drawIlluminationDisplay(nil, nil, lightSource.displayedIlluminatedTiles)
	end
end

local currentDrawObject

local function stencilTest()
	local grid = game.worldObject:getFloorTileGrid()
	local w, h = grid:getTileSize()
	local r, g, b, a = currentDrawObject.debugColor:unpack()
	
	love.graphics.setColor(255, 255, 255, 255)
	
	for key, index in ipairs(currentDrawObject.currentRenderTileList) do
		local x, y = grid:indexToWorld(index)
		
		love.graphics.rectangle("fill", x - w, y - h, w, h)
	end
end

function lightSource:drawIlluminationDisplay(x, y, tileList)
	if not x or not y then
		x, y = self:getCenter()
	end
	
	local w, h = game.WORLD_TILE_WIDTH * self.illuminationRadius, game.WORLD_TILE_HEIGHT * self.illuminationRadius
	local underColor = game.UI_COLORS.IMPORTANT_1
	
	love.graphics.setColor(underColor.r, underColor.g, underColor.b, 50)
	love.graphics.circle("fill", x - game.WORLD_TILE_WIDTH, y - game.WORLD_TILE_HEIGHT, w, 64)
	
	currentDrawObject = self
	self.currentRenderTileList = tileList or self.illuminatedTiles
	
	love.graphics.stencil(stencilTest, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	love.graphics.setColor(174, 229, 167, 100)
	love.graphics.circle("fill", x - game.WORLD_TILE_WIDTH, y - game.WORLD_TILE_HEIGHT, w, 64)
	love.graphics.setStencilTest()
end

objects.registerNew(lightSource, "complex_monthly_cost_object_base")
