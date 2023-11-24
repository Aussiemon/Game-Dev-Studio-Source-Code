floorObjectGrid = {}
floorObjectGrid.mtindex = {
	__index = floorObjectGrid
}
floorObjectGrid.tileWidth = 0
floorObjectGrid.tileHeight = 0

setmetatable(floorObjectGrid, objectGrid.mtindex)

function floorObjectGrid.new(sizeX, sizeY, floorCount)
	local new = {}
	
	setmetatable(new, floorObjectGrid.mtindex)
	new:init(sizeX, sizeY, floorCount)
	
	return new
end

function floorObjectGrid:initGrid(sizeX, sizeY, floorCount)
	floorCount = floorCount or 1
	self.floors = {}
	self.floorCount = floorCount
	self.gridWidth = sizeX
	self.gridHeight = sizeY
	
	for i = 1, floorCount do
		local floorObj = {}
		
		self.floors[i] = floorObj
		
		for y = 1, sizeY do
			for x = 1, sizeX do
				floorObj[self:getTileIndex(x, y)] = {}
			end
		end
	end
end

function floorObjectGrid:remove()
	table.clearArray(self.floors)
	
	self.floors = nil
	
	self.handler:remove()
end

function floorObjectGrid:addObjectWorldSpace(x, y, object, floorID)
	x, y = self:worldToGrid(x, y)
	
	return self:addObject(x, y, object, floorID)
end

function floorObjectGrid:addObject(x, y, object, floorID)
	if self:outOfBounds(x, y) then
		error("Attempt to add object to out-of-range objectGrid coordinates at XY: " .. x .. "/" .. y)
	else
		object:setObjectGrid(self)
		
		local index = self:getTileIndex(x, y)
		local floor = self.floors[floorID]
		local objects = floor[index]
		
		if not objects then
			objects = {}
			floor[index] = objects
		else
			for key, otherObject in ipairs(objects) do
				if otherObject == object then
					return false
				end
			end
		end
		
		self.handler:onObjectAdded(object)
		table.insert(objects, object)
		
		return true
	end
end

function floorObjectGrid:removeObjectWorldSpace(x, y, object, floorID)
	x, y = self:worldToGrid(x, y)
	
	return self:removeObject(x, y, object, floorID)
end

function floorObjectGrid:removeObject(x, y, object, floorID)
	if not self:outOfBounds(x, y) then
		floorID = floorID or object:getFloor()
		
		local index = self:getTileIndex(x, y)
		local floor = self.floors[floorID]
		local objects = floor[index]
		
		if not objects then
			return nil
		else
			for key, iterObject in ipairs(objects) do
				if iterObject == object then
					table.remove(objects, key)
					self.handler:onObjectRemoved(object)
					
					return true
				end
			end
		end
	end
	
	return false
end

function floorObjectGrid:hasObjectWorldSpace(x, y, object)
	x, y = self:worldToGrid(x, y)
	
	return self:hasObject(x, y, object)
end

function floorObjectGrid:hasObject(x, y, object, floorID)
	floorID = floorID or object:getFloor()
	
	local index = self:getTileIndex(x, y)
	local floor = self.floors[floorID]
	local objects = floor[index]
	
	if objects then
		for key, otherObject in ipairs(objects) do
			if otherObject == object then
				return true, key
			end
		end
	end
	
	return false
end

function floorObjectGrid:getObjects(x, y, floorID)
	if not self:outOfBounds(x, y) then
		return self.floors[floorID][self:getTileIndex(x, y)]
	end
	
	return nil
end

function floorObjectGrid:getObjectCount(x, y, floorID)
	local tiles = self.floors[floorID][self:getTileIndex(x, y)]
	
	return tiles and #tiles or 0
end

function floorObjectGrid:getObjectsFromIndex(index, floorID)
	return self.floors[floorID][index]
end

function floorObjectGrid:getFirstObject(x, y, floorID)
	if not self:outOfBounds(x, y) then
		local objects = self.floors[floorID][self:getTileIndex(x, y)]
		
		if objects then
			return objects[1]
		end
	end
	
	return nil
end

function floorObjectGrid:postDraw()
	self.handler:postDraw()
end
