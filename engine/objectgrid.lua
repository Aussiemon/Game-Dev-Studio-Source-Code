objectGrid = {}
objectGrid.mtindex = {
	__index = objectGrid
}
objectGrid.tileWidth = 0
objectGrid.tileHeight = 0

setmetatable(objectGrid, tileGrid.mtindex)

function objectGrid.new(sizeX, sizeY)
	local new = {}
	
	setmetatable(new, objectGrid.mtindex)
	new:init(sizeX, sizeY)
	
	return new
end

function objectGrid:setConservativeInit(state)
	self.conservativeInit = state
end

function objectGrid:initGrid(sizeX, sizeY)
	self.tiles = {}
	self.gridWidth = sizeX
	self.gridHeight = sizeY
	
	for y = 1, sizeY do
		for x = 1, sizeX do
			local index = self:getTileIndex(x, y)
			
			self.tiles[index] = {}
		end
	end
end

function objectGrid:remove()
	table.clearArray(self.tiles)
	
	self.tiles = nil
	
	self.handler:remove()
end

function objectGrid:addObjectWorldSpace(x, y, object)
	x, y = self:worldToGrid(x, y)
	
	return self:addObject(x, y, object)
end

function objectGrid:addObject(x, y, object)
	if self:outOfBounds(x, y) then
		error("Attempt to add object to out-of-range objectGrid coordinates at XY: " .. x .. "/" .. y)
	else
		local index = self:getTileIndex(x, y)
		local objects = self.tiles[index]
		
		if not objects then
			objects = {}
			self.tiles[index] = objects
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

function objectGrid:removeObjectWorldSpace(x, y, object)
	x, y = self:worldToGrid(x, y)
	
	return self:removeObject(x, y, object)
end

function objectGrid:removeObject(x, y, object)
	if not self:outOfBounds(x, y) then
		local index = self:getTileIndex(x, y)
		local objects = self.tiles[index]
		
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

function objectGrid:hasObjectWorldSpace(x, y, object)
	x, y = self:worldToGrid(x, y)
	
	return self:hasObject(x, y, object)
end

function objectGrid:hasObject(x, y, object)
	local index = self:getTileIndex(x, y)
	local objects = self.tiles[index]
	
	if objects then
		for key, otherObject in ipairs(objects) do
			if otherObject == object then
				return true, key
			end
		end
	end
	
	return false
end

function objectGrid:getObjects(x, y)
	if not self:outOfBounds(x, y) then
		return self.tiles[self:getTileIndex(x, y)]
	end
	
	return nil
end

function objectGrid:getObjectCount(x, y)
	local tiles = self.tiles[self:getTileIndex(x, y)]
	
	return tiles and #tiles or 0
end

function objectGrid:getObjectsFromIndex(index)
	return self.tiles[index]
end

function objectGrid:getFirstObject(x, y)
	if not self:outOfBounds(x, y) then
		local objects = self.tiles[self:getTileIndex(x, y)]
		
		if objects then
			return objects[1]
		end
	end
	
	return nil
end

function objectGrid:postDraw()
	self.handler:postDraw()
end
