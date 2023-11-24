room = {}
room.mtindex = {
	__index = room
}
room.objectsWithin = nil
room.tiles = nil
room.employees = nil
room.assignedEmployees = nil
room.tileCount = nil
room.entryPoints = nil

function room.new()
	local new = {}
	
	setmetatable(new, room.mtindex)
	new:init()
	
	return new
end

function room:init()
	self.tileCount = 0
	self.objectsWithin = {}
	self.objectsWithinByType = {}
	self.objectsWithinForLight = {}
	self.employees = {}
	self.assignedEmployees = {}
	self.entryPoints = {}
	self.wallTypeCount = {}
	self.sameRoomObjects = {}
	self.validRoomTypes = {}
	self.entryPointCount = 0
	self.drawColor = color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 100)
end

function room:addEmployee(employee)
	if not self:getEmployee(employee) then
		table.insert(self.employees, employee)
		
		if #self.employees == 1 then
			for key, object in ipairs(self.objectsWithin) do
				object:onEmployeeEntered(employee)
			end
		end
	end
end

function room:setOffice(officeObject)
	self.office = officeObject
end

function room:setFloor(floorID)
	self.floorID = floorID
end

function room:getFloor()
	return self.floorID
end

function room:getOffice()
	return self.office
end

function room:removeEmployee(employee)
	local otherEmployee, key = self:getEmployee(employee)
	
	if key then
		if #self.employees == 1 then
			for key, object in ipairs(self.objectsWithin) do
				object:onEmployeeLeft(employee)
			end
		end
		
		table.remove(self.employees, key)
	end
end

function room:getEmployee(employee)
	for key, otherEmployee in ipairs(self.employees) do
		if otherEmployee == employee then
			return otherEmployee, key
		end
	end
end

function room:getEmployees()
	return self.employees
end

function room:countWallTypes()
	for key, value in ipairs(walls.wallTypesNumeric) do
		self.wallTypeCount[value] = 0
	end
	
	local floorID = self.floorID
	local grid = game.worldObject:getFloorTileGrid()
	local start, finish = floorTileGrid.WALL_ID_ITERATION_RANGE[1], floorTileGrid.WALL_ID_ITERATION_RANGE[2]
	
	for index, state in pairs(self.tiles) do
		local wallIDs = grid:getWallIDs(index, floorID)
		
		for i = start, finish do
			local wallType = walls:getWallType(wallIDs[i])
			
			self.wallTypeCount[wallType] = self.wallTypeCount[wallType] + 1
		end
	end
end

function room:getWallTypeCount(type)
	return self.wallTypeCount[type] or 0
end

function room:resetValidRoomObjects()
	for key, object in ipairs(self.objectsWithin) do
		object:setIsPartOfValidRoom(false)
		object:setContributesToRoom(false)
	end
	
	table.clear(self.sameRoomObjects)
end

function room:clearRegistry()
	for roomType, amount in pairs(self.validRoomTypes) do
		studio:changeValidRoomTypeCount(roomType, -amount)
		
		self.validRoomTypes[roomType] = nil
	end
end

function room:register()
	self:resetValidRoomObjects()
	
	for key, object in ipairs(self.objectsWithin) do
		object:attemptRegister()
	end
	
	for roomType, amount in pairs(self.validRoomTypes) do
		studio:changeValidRoomTypeCount(roomType, amount)
	end
end

function room:addValidRoomType(object)
	local roomType = object:getRoomType()
	
	if roomType and not self.sameRoomObjects[object] then
		self.validRoomTypes[roomType] = (self.validRoomTypes[roomType] or 0) + 1
		
		object:setContributesToRoom(true)
	end
	
	self:markSameRoomObject(object)
	object:setIsPartOfValidRoom(true)
end

function room:wasAlreadyInRoom(object)
	return self.sameRoomObjects[object]
end

function room:markSameRoomObject(object)
	self.sameRoomObjects[object] = true
end

function room:getWallTypes()
	return self.wallTypeCount
end

function room:removeTile(index)
	self.tiles[index] = nil
	self.tileCount = self.tileCount - 1
	
	local objects = game.worldObject:getObjectGrid():getObjectsFromIndex(index)
	
	if objects then
		for key, object in ipairs(objects) do
			self:removeObject(object)
		end
	end
end

function room:setStaircaseUp(staircase)
	self.staircaseUp = staircase
end

function room:getStaircaseUp()
	return self.staircaseUp
end

function room:setStaircaseDown(staircase)
	self.staircaseDown = staircase
end

function room:getStaircaseDown()
	return self.staircaseDown
end

function room:addEntryPoint(object)
	self.entryPoints[#self.entryPoints + 1] = object
	self.entryPointCount = self.entryPointCount + 1
end

function room:getEntryPoints()
	return self.entryPoints
end

function room:getEntryPointCount()
	return self.entryPointCount
end

function room:resetEntryPoints()
	table.clearArray(self.entryPoints)
	
	self.entryPointCount = 0
end

function room:resetTiles()
	if self.tiles then
		local roomMap = studio:getRoomMap()
		local floorTiles = roomMap[self.floor]
		
		for tile, state in pairs(self.tiles) do
			floorTiles[tile] = nil
		end
	end
end

function room:reset()
	table.clearArray(self.assignedEmployees)
	table.clearArray(self.entryPoints)
	
	self.entryPointCount = 0
	
	table.clearArray(self.objectsWithinForLight)
	
	self.staircaseUp = nil
	self.staircaseDown = nil
	
	local employeeCount = #self.employees
	
	for key, employee in ipairs(self.employees) do
		employee:removeFromRoom(true)
		
		self.employees[key] = nil
	end
	
	for key, object in ipairs(self.objectsWithin) do
		object:onEmployeeLeft(employee)
		
		self.objectsWithin[key] = nil
	end
	
	for key, list in pairs(self.objectsWithinByType) do
		table.clearArray(list)
	end
	
	self:clearRegistry()
	
	self.tiles = nil
	self.tileCount = 0
end

function room:remove()
	table.clearArray(self.objectsWithin)
	table.clear(self.objectsWithinByType)
	table.clearArray(self.objectsWithinForLight)
	table.clearArray(self.employees)
	table.clearArray(self.assignedEmployees)
	table.clearArray(self.entryPoints)
	table.clear(self.wallTypeCount)
	table.clear(self.sameRoomObjects)
	table.clear(self.validRoomTypes)
	
	self.tiles = nil
	self.objectsWithin = nil
	self.objectsWithinByType = nil
	self.objectsWithinForLight = nil
	self.employees = nil
	self.assignedEmployees = nil
	self.entryPoints = nil
	self.wallTypeCount = nil
	self.sameRoomObjects = nil
	self.validRoomTypes = nil
end

function room:printObjectContents()
	for key, object in ipairs(self.objectsWithin) do
		print(key, object)
	end
end

function room:setTiles(tiles)
	self.tiles = tiles
	self.tileCount = table.count(tiles)
end

function room:getTileCount()
	return self.tileCount
end

function room:getTiles()
	return self.tiles
end

function room:hasTile(index)
	return self.tiles[index]
end

function room:getObjects()
	return self.objectsWithin
end

function room:addAssignedEmployee(employee)
	if self:getAssignedEmployee(employee) then
		return 
	end
	
	table.insert(self.assignedEmployees, employee)
end

function room:removeAssignedEmployee(employee)
	local ourselves, key = self:getAssignedEmployee(employee)
	
	if key then
		table.remove(self.assignedEmployees, key)
	end
end

function room:getAssignedEmployee(employee)
	for key, otherEmployee in ipairs(self.assignedEmployees) do
		if otherEmployee == employee then
			return otherEmployee, key
		end
	end
	
	return nil, nil
end

function room:getAssignedEmployees()
	return self.assignedEmployees
end

function room:calculateOverallEmployeeEfficiency()
	for key, employee in ipairs(self.assignedEmployees) do
		employee:calculateOverallEfficiency()
	end
end

function room:addObject(object)
	local otherObject = self:getObject(object)
	
	if otherObject then
		return 
	end
	
	object:setRoom(self)
	table.insert(self.objectsWithin, object)
	
	if object.minimumIllumination > 0 then
		table.insert(self.objectsWithinForLight, object)
	end
	
	local objType = object:getObjectType()
	
	self.objectsWithinByType[objType] = self.objectsWithinByType[objType] or {}
	
	table.insert(self.objectsWithinByType[objType], object)
end

function room:getObject(object)
	for key, otherObject in ipairs(self.objectsWithin) do
		if otherObject == object then
			return otherObject, key
		end
	end
	
	return nil, nil
end

function room:removeObject(object)
	local otherObject, key = self:getObject(object)
	
	if otherObject then
		object:setRoom(nil)
		table.remove(self.objectsWithin, key)
		
		if object.minimumIllumination > 0 then
			table.removeObject(self.objectsWithinForLight, object)
		end
		
		local objectList = self.objectsWithinByType[object:getObjectType()]
		
		for key, otherObject in ipairs(objectList) do
			if object == otherObject then
				table.remove(objectList, key)
				
				break
			end
		end
	end
end

function room:getObjectsForLight()
	return self.objectsWithinForLight
end

function room:getObjectsOfType(objType)
	return self.objectsWithinByType[objType]
end

function room:draw()
	local grid = game.worldObject:getFloorTileGrid()
	local w, h = grid:getTileSize()
	
	love.graphics.setColor(self.drawColor:unpack())
	
	for index, state in pairs(self.tiles) do
		local x, y = grid:convertIndexToCoordinates(index)
		
		love.graphics.rectangle("fill", x * w - w, y * h - h, w, h)
	end
end
