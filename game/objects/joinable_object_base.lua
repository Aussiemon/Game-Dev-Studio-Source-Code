local joinableObjectBase = {}

joinableObjectBase.tileWidth = 1
joinableObjectBase.tileHeight = 1
joinableObjectBase.quad = nil
joinableObjectBase.quadSurround = nil
joinableObjectBase.quadLeft = nil
joinableObjectBase.quadRight = nil
joinableObjectBase.matchType = "joinable"
joinableObjectBase.class = "joinable_object_base"
joinableObjectBase.leftOffset = 0
joinableObjectBase.rightOffset = 0
joinableObjectBase.MATCHED_SIDES = {
	RIGHT = 2,
	BOTH = 4,
	LEFT = 1,
	NONE = 0
}
joinableObjectBase.BASE = true

function joinableObjectBase:getTextureQuad()
	self:updateValidQuad()
	
	return self.validQuad
end

function joinableObjectBase:updateValidQuad()
	self.validQuad, self.validSides = self:getValidQuad()
end

function joinableObjectBase:getDrawPosition(x, y, quad, rotation, xDirOff, yDirOff)
	local x, y, w, h, rad = joinableObjectBase.baseClass.getDrawPosition(self, x, y, quad, rotation, xDirOff, yDirOff)
	
	if self.validSides == joinableObjectBase.MATCHED_SIDES.LEFT then
		local dir = walls.DIRECTION[walls.LEFT_SIDE[self.rotation]]
		
		x = x + dir[1] * self.leftOffset
		y = y + dir[2] * self.leftOffset
	elseif self.validSides == joinableObjectBase.MATCHED_SIDES.RIGHT then
		local dir = walls.DIRECTION[walls.RIGHT_SIDE[self.rotation]]
		
		x = x + dir[1] * self.rightOffset
		y = y + dir[2] * self.rightOffset
	end
	
	return x, y, w, h, rad
end

function joinableObjectBase:getValidQuad()
	if not self.gridStartX then
		return self.quad, joinableObjectBase.MATCHED_SIDES.NONE
	end
	
	local leftRot, rightRot = walls.LEFT_SIDE[self.rotation], walls.RIGHT_SIDE[self.rotation]
	local leftOff, rightOff = walls.DIRECTION[leftRot], walls.DIRECTION[rightRot]
	local grid = game.worldObject:getFloorTileGrid()
	local curIndex = self.objectGrid:getTileIndex(self.gridStartX, self.gridStartY)
	local left = not grid:hasWall(curIndex, self.floor, leftRot) and self:hasMatchInDirection(self.objectGrid:getTileIndex(self.gridStartX + leftOff[1], self.gridStartY + leftOff[2]), leftRot)
	local right = not grid:hasWall(curIndex, self.floor, rightRot) and self:hasMatchInDirection(self.objectGrid:getTileIndex(self.gridStartX + rightOff[1], self.gridStartY + rightOff[2]), rightRot)
	
	if left and right then
		return self.quadSurround, joinableObjectBase.MATCHED_SIDES.BOTH
	elseif left then
		return self.quadLeft, joinableObjectBase.MATCHED_SIDES.LEFT
	elseif right then
		return self.quadRight, joinableObjectBase.MATCHED_SIDES.RIGHT
	end
	
	return self.quad, joinableObjectBase.MATCHED_SIDES.NONE
end

function joinableObjectBase:hasMatchInDirection(index, directionRotation)
	local objects = self.objectGrid:getObjectsFromIndex(index, self.floor)
	local rotation, match = self.rotation, self.matchType
	
	if objects then
		for key, object in ipairs(objects) do
			if object.matchType and object.matchType == match and object:getRotation() == rotation then
				return true
			end
		end
	end
	
	return false
end

objects.registerNew(joinableObjectBase, "housable_object_base")
