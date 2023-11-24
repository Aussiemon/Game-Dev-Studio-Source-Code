officeBuildingMap = {}
officeBuildingMap.mtindex = {
	__index = officeBuildingMap
}

function officeBuildingMap.new()
	local new = {}
	
	setmetatable(new, officeBuildingMap.mtindex)
	new:init()
	
	return new
end

function officeBuildingMap:init()
	self.indexes = {}
	self.visibleBuildings = {}
end

function officeBuildingMap:setTileBuilding(index, building)
	self.indexes[index] = building
end

function officeBuildingMap:makeThreadTable()
	local new = {}
	
	for index, state in pairs(self.indexes) do
		new[index] = true
	end
	
	return new
end

function officeBuildingMap:getTileBuilding(index)
	return self.indexes[index]
end

function officeBuildingMap:getTileIndexes()
	return self.indexes
end

function officeBuildingMap:addVisibleBuilding(obj)
	if table.find(self.visibleBuildings, obj) then
		return 
	end
	
	table.insert(self.visibleBuildings, obj)
end

function officeBuildingMap:removeVisibleBuilding(obj)
	table.removeObject(self.visibleBuildings, obj)
end

function officeBuildingMap:getVisibleBuildings()
	return self.visibleBuildings
end

function officeBuildingMap:scrub()
	table.clearArray(self.visibleBuildings)
	table.clear(self.indexes)
end
