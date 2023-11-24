local pedestrian = {}

pedestrian.width = 48
pedestrian.height = 48
pedestrian.class = "pedestrian"
pedestrian.NEXT_CELL_DIRECTION_DISTANCE = 0.6
pedestrian.NEXT_CELL_MAX_TURN_AMOUNT = 0.8
pedestrian.WALK_SPEED = {
	60,
	80
}
pedestrian.PATH_TYPE = {
	HOME = 1,
	RANDOM = 2
}

function pedestrian:init()
	self.avatar = pedestrianAvatar.new(self)
	
	self.avatar:setOwner(self)
	self:setWalkPath(nil)
	
	self.targetAngle = 0
	self.angleRotation = 0
	self.walkProgress = 0
	self.female = math.random(1, 100) <= 50
	
	self:setTileGrid(game.worldObject:getFloorTileGrid())
	
	self.homeBuilding = game.worldObject:getRandomPedestrianBuilding()
	self.lastBuilding = self.homeBuilding
	self.walkSpeedMult = 1
	self.walkSpeed = math.random(self.WALK_SPEED[1], self.WALK_SPEED[2]) / game.WORLD_TILE_WIDTH
	self.quadTree = game.worldObject:getPedestrianQuadTree()
end

function pedestrian:getFloor()
	return 1
end

function pedestrian:setWakeTime(time)
	self.wakeTime = time
end

function pedestrian:enterVisibilityRange()
	self.avatar:enterVisibilityRange()
	
	self.visible = true
end

function pedestrian:leaveVisibilityRange()
	self.avatar:leaveVisibilityRange()
	
	self.visible = false
end

function pedestrian:setController(contr)
	self.controller = contr
end

function pedestrian:remove()
	self.avatar:remove()
	self.quadTree:remove(self)
end

function pedestrian:getAvatar()
	return self.avatar
end

function pedestrian:moveHome()
	local tile = self.homeBuilding:getRandomTileIndex()
	
	self.x, self.y = self.tileGrid:indexToWorld(tile)
	
	self:setWalkPath(nil)
	
	self.lastBuilding = self.homeBuilding
	self.pathType = pedestrian.PATH_TYPE.HOME
	
	self.quadTree:insert(self)
end

function pedestrian:goHome()
	self:setWalkPath(nil)
	self:setTargetTile(self.homeBuilding:getRandomTileIndex())
	
	self.lastBuilding = self.homeBuilding
	self.pathType = pedestrian.PATH_TYPE.HOME
end

function pedestrian:getPathType()
	return self.pathType
end

function pedestrian:setTargetTile(index)
	self.targetTile = index
	self.tileX, self.tileY = self.tileGrid:convertIndexToCoordinates(self.targetTile)
	self.gridX, self.gridY = self:getTileCoordinates()
	
	pathComputeQueue:addToQueue(self, nil, self.tileX, self.tileY)
end

function pedestrian:setWalkSpeedMultiplier(mult)
	self.walkSpeedMult = mult
end

function pedestrian:onRainStarted()
	self.walkSpeedMult = pedestrianController.RAIN_WALK_SPEED
	
	self.avatar:setAnimSpeed(3)
	
	if self.pathType ~= pedestrian.PATH_TYPE.HOME then
		self:goHome()
	end
end

function pedestrian:onRainEnded()
	self.walkSpeedMult = 1
	
	self.avatar:setAnimSpeed(1.75)
end

function pedestrian:snapToTargetTile()
	self:setTargetAngle(math.directiontodeg(self.y - self.curPathY, self.x - self.curPathX))
	
	self.angleRotation = self.targetAngle
end

function pedestrian:setTargetAngle(ang)
	self.targetAngle = math.normalizeAngle(ang)
end

function pedestrian:update(dt)
	if self.walkPath then
		local progress = dt * self.walkSpeed * self.walkSpeedMult
		
		self.walkProgress = math.approach(self.walkProgress, 1, progress)
		
		local deg = math.directiontodeg(self.y - self.curPathY, self.x - self.curPathX)
		
		if self.nextCell then
			local dist = 1 - math.max(math.dist(self.x, self.curPathX), math.dist(self.y, self.curPathY)) / game.WORLD_TILE_WIDTH
			
			if dist >= pedestrian.NEXT_CELL_DIRECTION_DISTANCE then
				deg = math.lerpAngle(deg, math.directiontodeg(self.y - self.nextPathY, self.x - self.nextPathX), (dist - pedestrian.NEXT_CELL_DIRECTION_DISTANCE) / (1 - pedestrian.NEXT_CELL_DIRECTION_DISTANCE) * pedestrian.NEXT_CELL_MAX_TURN_AMOUNT)
			end
		end
		
		if self.targetAngle ~= deg then
			self:setTargetAngle(deg)
		end
		
		self.x = math.lerp(self.startX, self.curPathX, self.walkProgress)
		self.y = math.lerp(self.startY, self.curPathY, self.walkProgress)
		
		self.quadTree:insert(self)
		self.avatar:update(dt)
		
		if self.walkProgress == 1 then
			self.walkProgress = 0
			self.curWalkIndex = self.curWalkIndex + 1
			
			self:updatePathCoordinates()
		end
	elseif not self.targetTile then
		local newTargetBuilding = game.worldObject:getRandomPedestrianBuilding(self.lastBuilding)
		
		self.lastBuilding = newTargetBuilding
		
		self:setTargetTile(newTargetBuilding:getRandomTileIndex())
	end
	
	self.angleRotation = math.approachAngle(self.angleRotation, self.targetAngle, dt * 360 * 1.5)
end

local validBuildings = {}

function pedestrian:onPathFound(foundPath)
	self:setWalkPath(foundPath)
end

function pedestrian:onPathfindFailed()
	self.targetTile = nil
end

function pedestrian:updatePathCoordinates()
	self.currentCell = self.walkPath[self.curWalkIndex]
	
	if not self.currentCell then
		self.controller:onFinishedPath(self)
		
		self.pathType = pedestrian.PATH_TYPE.RANDOM
		
		self:removeWalkPath()
		
		return 
	end
	
	local gridX, gridY = self.tileGrid:convertIndexToCoordinates(self.currentCell)
	
	self.startX, self.startY = self.x, self.y
	self.curPathX, self.curPathY = self.tileGrid:gridToWorld(gridX, gridY)
	self.nextCell = self.walkPath[self.curWalkIndex + 1]
	
	if self.nextCell then
		local gridX, gridY = self.tileGrid:convertIndexToCoordinates(self.nextCell)
		
		self.nextPathX, self.nextPathY = self.tileGrid:gridToWorld(gridX, gridY)
	else
		self.nextPathX, self.nextPathY = nil
	end
	
	if self.currentWalkObjects then
		for key, object in ipairs(self.currentWalkObjects) do
			object:onLeaveReach(self)
		end
	end
	
	local objects
	
	if self.walkPath then
		local objects = game.worldObject:getObjectGrid():getObjectsFromIndex(self.currentCell, 1)
		
		if objects then
			for key, object in ipairs(objects) do
				object:onReach(self, self.currentCell, self.currentCell, self.nextCell)
			end
		end
	end
	
	self.currentWalkObjects = objects
end

function pedestrian:getWalkAnim()
	if self.female then
		return avatar.ANIM_WALK_F
	end
	
	return avatar.ANIM_WALK
end

function pedestrian:getStandAnimation()
	if self.female then
		return avatar.ANIM_STAND_F
	end
	
	return avatar.ANIM_STAND
end

function pedestrian:setWalkPath(walkPath)
	self.curWalkIndex = 2
	self.walkPath = walkPath
	self.targetTile = nil
	
	if not self.walkPath then
		self:removeWalkPath()
	else
		self.walkSpeedMult = math.random(1, 100) <= 5 and 1.75 or 1
		
		self.avatar:setAnimation(self:getWalkAnim(), 1.5 * self.walkSpeedMult)
		self:updatePathCoordinates()
	end
end

function pedestrian:getWalkPath()
	return self.walkPath
end

function pedestrian:playFootstep()
	if not self.visible then
		return 
	end
	
	local gridX, gridY = self:getTileCoordinates()
	local grid = self.tileGrid
	local tile = grid:getTileID(grid:getTileIndex(gridX, gridY), 1)
	local surfaceType = floors:getSurfaceTypeForFloor(tile)
	local data = sound:play(surfaceType.stepSoundData, self, self:getCenterX(), self:getCenterY())
	
	data.soundObj:setPitch(math.randomf(0.7, 1.1))
end

function pedestrian:removeWalkPath()
	self.walkPath = nil
	self.currentCell = nil
	self.nextCell = nil
	self.curPathX, self.curPathY = nil
	self.nextPathX, self.nextPathY = nil
	
	self.avatar:setAnimation(self:getStandAnimation())
end

function pedestrian:getCarryObject()
	return nil
end

function pedestrian:draw()
	self.avatar:draw(self.x - 48, self.y - 48)
end

objects.registerNew(pedestrian)
require("game/objects/pedestrian_avatar")
