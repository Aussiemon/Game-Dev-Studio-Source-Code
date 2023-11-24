local door = {}

door.tileWidth = 1
door.tileHeight = 1
door.class = "door"
door.category = "general"
door.objectType = "door"
door.display = _T("DOOR", "Door")
door.description = _T("DOOR_DESCRIPTION", "Doors enclose and separate rooms.")
door.quad = quadLoader:load("door_1")
door.scaleX = 1
door.scaleY = 1
door.cost = 20
door.xOffset = 0
door.yOffset = 0
door.xDirectionalOffset = 0
door.yDirectionalOffset = 0
door.centerOffsetX = -1
door.centerOffsetY = 24
door.requiresEntrance = false
door.enclosesTile = true
door.requiresNoWallInDirection = true
door.minimumIllumination = 0
door.openSpeed = 2
door.closeSpeed = 1.5
door.maxOpenRange = 72
door.HOLD_OPEN_FOR = 0.4
door.icon = "icon_door"
door.addRotation = 0
door.progressTime = 0.15
door.quadList = {
	"door_1",
	"door_2",
	"door_3",
	"door_4",
	"door_5"
}
door.quadListVertical = {
	"door_5_2",
	"door_3_2",
	"door_4",
	"door_5",
	"door_5"
}
door.quadObjects = {}
door.quadObjectsVertical = {}

for key, quadID in ipairs(door.quadList) do
	door.quadObjects[#door.quadObjects + 1] = quadLoader:load(quadID)
end

for key, quadID in ipairs(door.quadListVertical) do
	door.quadObjectsVertical[#door.quadObjectsVertical + 1] = quadLoader:load(quadID)
end

door.quadListLength = #door.quadObjects
door.quadListVerticalLength = #door.quadObjectsVertical
door.ROTATION_TO_LINE_DIRECTION = {
	[walls.UP] = {
		0,
		0,
		1,
		0
	},
	[walls.RIGHT] = {
		1,
		0,
		1,
		1
	},
	[walls.DOWN] = {
		0,
		1,
		1,
		1
	},
	[walls.LEFT] = {
		0,
		0,
		0,
		1
	}
}
door.INVERSE_QUAD_ROTATION = {
	[walls.LEFT] = true,
	[walls.RIGHT] = true
}

function door:init()
	door.baseClass.init(self)
	
	self.currentDoorRotation = 0
	self.rotationApproachSpeed = 0
	self.targetRotation = 0
	self.extraDoorMoveSpeed = 0
	self.doorMaintainTime = 0
	self.doorOpeners = {}
	self.animTime = 0
	
	self:setupQuadList()
	
	self.curQuadIndex = 1
	self.curQuad = self.quadList[1]
end

function door:setRotation(rot)
	door.baseClass.setRotation(self, rot)
	self:setupQuadList()
	
	self.curQuad = self.quadList[self.curQuadIndex]
end

function door:setupQuadList()
	if walls.VERTICAL_SIDES[self.rotation] then
		self.quadList = self.quadObjectsVertical
	else
		self.quadList = self.quadObjects
	end
end

function door:updateQuad()
	self.curQuad = self.quadList[self.curQuadIndex]
end

function door:getTextureQuad()
	return self.quadList[self.curQuadIndex]
end

function door:onRemoved()
	door.baseClass.onRemoved(self)
	game.removeDynamicObject(self)
end

function door:getDrawAngles(rotation)
	if rotation == walls.LEFT then
		return walls.RAW_ANGLES[rotation]
	elseif rotation == walls.RIGHT then
		return walls.RAW_ANGLES[rotation]
	end
	
	return walls.RAW_ANGLES[rotation]
end

function door:getScale()
	if self.rotation == walls.DOWN then
		return self.scaleX, -self.scaleY
	end
	
	return self.scaleX, self.scaleY
end

function door:getDirectionalOffset()
	if self.rotation == walls.UP then
		return 0, -16
	elseif self.rotation == walls.RIGHT then
		return 4, 0
	elseif self.rotation == walls.DOWN then
		return 0, -32
	end
	
	return 0, 0
end

function door:open(reacher)
	if table.find(self.doorOpeners, reacher) then
		return 
	end
	
	table.insert(self.doorOpeners, reacher)
	
	if #self.doorOpeners == 1 then
		self:startMovement()
	end
	
	self.targetRotation = math.pi / 2
	self.closed = false
	self.rotationApproachSpeed = door.openSpeed
	self.doorMaintainTime = self.HOLD_OPEN_FOR
end

function door:startMovement()
	self:playSound("door_open", true)
	game.addDynamicObject(self)
	self:replaceWall()
	self:_updateThreads()
end

function door:finishMovement()
	game.removeDynamicObject(self)
	
	self.animTime = 0
	
	self:playSound("door_close", true)
	self:insertWall()
	self:_updateThreads()
end

function door:removeOpener(employee)
	table.removeObject(self.doorOpeners, employee)
	
	if #self.doorOpeners == 0 then
		self:close()
	end
end

function door:close()
	self.targetRotation = 0
	self.closed = true
	self.rotationApproachSpeed = door.closeSpeed
end

function door:onReach(reacher, currentCell, previousCell, nextCell)
	if nextCell and self:attemptOpen(currentCell, nextCell, reacher) then
		return 
	end
	
	self:attemptOpen(reacher:getTileIndex(), currentCell, reacher)
end

function door:attemptOpen(start, finish, reacher)
	local grid = game.worldObject:getFloorTileGrid()
	local tileW, tileH = grid:getTileSize()
	local curX, curY = grid:convertIndexToCoordinates(start)
	local nextX, nextY = grid:convertIndexToCoordinates(finish)
	local dirX, dirY = nextX - curX, nextY - curY
	local sizeInfo = door.ROTATION_TO_LINE_DIRECTION[self.rotation]
	local midX, midY = grid:getIndexMidpoint(start)
	local ourDir = walls.DIRECTION[self.rotation]
	local ourX, ourY = self:getTileCoordinates()
	
	ourX, ourY = ourX * tileW, ourY * tileH
	
	if math.lineSegmentIntersects(ourX + self.width * sizeInfo[1], ourY + self.height * sizeInfo[2], ourX + self.width * sizeInfo[3], ourY + self.height * sizeInfo[4], midX, midY, midX + dirX * tileW, midY + dirY * tileH) then
		self:open(reacher)
		
		return true
	end
	
	return false
end

function door:onLeaveReach()
end

door.SAME_OFF_ROTATION = {
	[walls.RIGHT] = true,
	[walls.LEFT] = true,
	[walls.DOWN] = true
}

function door:getDrawPosition(x, y)
	local x, y, xOff, yOff, rotation = door.baseClass.getDrawPosition(self, x, y)
	local quad = self:getTextureQuad()
	
	if quad == self.quadList[self.quadListLength] then
		xOff = self.SAME_OFF_ROTATION[self.rotation] and 4 or 6 * math.cos(rotation)
		
		if walls.HORIZONTAL_SIDES[self.rotation] then
			yOff = yOff - 8
		end
	else
		xOff = 0
	end
	
	return x, y, xOff, yOff, rotation
end

function door:updateSprite()
	if self.visible then
		local objectGrid = game.worldObject:getObjectGrid()
		local x, y, xOff, yOff, rotation = self:getDrawPosition()
		
		if not self.spriteID then
			self.spriteID = self.spriteBatch:allocateSlot()
		end
		
		local quad = self:getTextureQuad()
		local scaleX, scaleY = self:getScale()
		
		self.spriteBatch:setColor(self:getDrawColor())
		self.spriteBatch:updateSprite(self.spriteID, quad, x - math.cos(rotation) * 24, y - math.sin(rotation) * 24, rotation + self.currentDoorRotation, scaleX, scaleY, xOff, yOff * 0.5)
	end
end

function door:drawOutline()
	local quad = self:getTextureQuad()
	local x, y, xOff, yOff, rotation = self:getDrawPosition(self.x, self.y)
	local scaleX, scaleY = self:getScale()
	
	outlineShader:setupThickness(quad)
	love.graphics.draw(self.atlasTexture, self:getTextureQuad(), x - math.cos(rotation) * 24, y - math.sin(rotation) * 24, rotation + self.currentDoorRotation, scaleX, scaleY, xOff, yOff * 0.5)
end

function door:update(dt, progress)
	local count = #self.doorOpeners
	local shouldClose = self.doorMaintainTime <= 0
	local closestDist = math.huge
	local maxRange = self.maxOpenRange
	
	if count > 0 then
		local midX, midY = self:getCenter()
		
		midX, midY = midX - 48, midY - 48
		
		local curIteration = 1
		
		for key = 1, count do
			local doorOpener = self.doorOpeners[curIteration]
			
			if doorOpener:isValid() then
				local curX, curY = doorOpener:getAvatar():getCenterDrawPosition()
				local newDist = math.sqrt(math.pow(math.abs(curX - midX), 2) + math.pow(math.abs(curY - midY), 2))
				
				if newDist < closestDist then
					closestDist = newDist
				end
				
				if shouldClose and maxRange < newDist then
					table.remove(self.doorOpeners, curIteration)
				else
					curIteration = curIteration + 1
				end
			else
				table.remove(self.doorOpeners, curIteration)
			end
		end
	end
	
	if maxRange < closestDist and shouldClose then
		self:close()
	else
		progress = progress + progress * math.min(1, closestDist / maxRange) * 1.5
	end
	
	self.doorMaintainTime = self.doorMaintainTime - progress
	
	if self.closed then
		self.animTime = self.animTime + progress
		
		if self.animTime >= self.progressTime then
			self.animTime = self.animTime - self.progressTime
			self.curQuadIndex = math.max(1, self.curQuadIndex - 1)
			
			if self.curQuadIndex == 1 then
				self:finishMovement()
			end
			
			local newQuad = self.quadList[self.curQuadIndex]
			
			if newQuad ~= self.curQuad then
				self.curQuad = newQuad
				
				self:updateSprite()
			end
		end
	elseif self.curQuadIndex < self.quadListLength then
		self.animTime = self.animTime + progress
		
		if self.animTime >= self.progressTime then
			self.animTime = self.animTime - self.progressTime
			self.curQuadIndex = self.curQuadIndex + 1
			
			local newQuad = self.quadList[self.curQuadIndex]
			
			if newQuad ~= self.curQuad then
				self.curQuad = newQuad
				
				self:updateSprite()
			end
		end
	end
end

function door:draw()
end

objects.registerNew(door, "door_object_base")
