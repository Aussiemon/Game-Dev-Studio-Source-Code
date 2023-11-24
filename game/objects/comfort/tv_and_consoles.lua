local tvAndConsoles = {}

tvAndConsoles.tileWidth = 2
tvAndConsoles.tileHeight = 1
tvAndConsoles.class = "tv_and_consoles"
tvAndConsoles.category = "leisure"
tvAndConsoles.objectType = "decor"
tvAndConsoles.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true
}
tvAndConsoles.display = _T("OBJECT_TV_AND_CONSOLES", "TV and consoles")
tvAndConsoles.description = _T("OBJECT_TV_AND_CONSOLES_DESCRIPTION", "When you're tired of working on games, take a break by playing some games.")
tvAndConsoles.quad = quadLoader:load("tv_and_consoles_1")
tvAndConsoles.quadNew = quadLoader:load("tv_and_consoles_2")
tvAndConsoles.scaleX = 1
tvAndConsoles.scaleY = 1
tvAndConsoles.cost = 600
tvAndConsoles.minimumIllumination = 0
tvAndConsoles.sizeCategory = "unhousable"
tvAndConsoles.requiresEntrance = false
tvAndConsoles.preventsMovement = true
tvAndConsoles.preventsReach = true
tvAndConsoles.affectors = {
	{
		"comfort",
		9
	}
}
tvAndConsoles.addRotation = 0
tvAndConsoles.centerOffsetX = 0
tvAndConsoles.centerOffsetY = -5
tvAndConsoles.icon = "icon_tv_and_consoles_1"
tvAndConsoles.iconNew = "icon_tv_and_consoles_2"
tvAndConsoles.matchingRequirements = {}
tvAndConsoles.realMonthlyCosts = {
	{
		cost = 20,
		disableWithNoEmployees = true,
		type = "electricity"
	}
}
tvAndConsoles.newerSpriteYear = 2005
tvAndConsoles.checkRange = 3

function tvAndConsoles:isValidRoom()
	return tvAndConsoles.baseClass.isValidRoom(self) and self:checkForSofa()
end

function tvAndConsoles:checkForSofa()
	local rot = self.rotation
	local inverse = walls.INVERSE_RELATION[rot]
	local direction = walls.DIRECTION[inverse]
	local grid = game.worldObject:getFloorTileGrid()
	local objectGrid = game.worldObject:getObjectGrid()
	local gridX, gridY = self:getTileCoordinates()
	local sofaPresent = self:_checkForSofa(gridX, gridY, direction, objectGrid, grid)
	
	if not sofaPresent then
		table.insert(self.incompatibilityFactors, {
			type = tvAndConsoles.INCOMPATIBILITY_TYPES.NO_SOFA
		})
	end
	
	return sofaPresent
end

function tvAndConsoles:getTextureQuad()
	if timeline:getYear() >= self.newerSpriteYear then
		return self.quadNew
	end
	
	return self.quad
end

function tvAndConsoles:getIcon()
	if timeline:getYear() >= self.newerSpriteYear then
		return self.iconNew
	end
	
	return self.icon
end

function tvAndConsoles:_checkForSofa(gridX, gridY, direction, objectGrid, grid)
	local dirX, dirY = direction[1], direction[2]
	local range = self.tileWidth - 1
	
	gridX, gridY = gridX + dirX, gridY + dirY
	
	local rot = self.rotation
	
	if rot == walls.LEFT or rot == walls.RIGHT then
		for i = 0, self.checkRange do
			local curX = gridX + i * dirX
			local sofaAmt = 0
			
			for Y = 0, range do
				local curY = gridY + i * dirY + Y
				
				if grid:hasWall(grid:getTileIndex(curX, curY), self.floor, rot) then
					sofaPresent = false
					
					break
				else
					local objects = objectGrid:getObjects(curX, curY, self.floor)
					
					if objects and self:_isSofa(objects) then
						sofaAmt = sofaAmt + 1
						
						if sofaAmt >= 2 then
							return true
						end
					end
				end
			end
		end
	elseif rot == walls.UP or rot == walls.DOWN then
		for i = 0, self.checkRange do
			local curY = gridY + i * dirY
			local sofaAmt = 0
			
			for X = 0, range do
				local curX = gridX + i * dirX + X
				
				if grid:hasWall(grid:getTileIndex(curX, curY), self.floor, rot) then
					sofaPresent = false
					
					break
				else
					local objects = objectGrid:getObjects(curX, curY, self.floor)
					
					if objects and self:_isSofa(objects) then
						sofaAmt = sofaAmt + 1
						
						if sofaAmt >= 2 then
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end

function tvAndConsoles:_isSofa(objectList)
	for key, object in ipairs(objectList) do
		if object.SOFA and object:isPartOfValidRoom() and object:getRotation() == walls.INVERSE_RELATION[self.rotation] then
			return true
		end
	end
	
	return false
end

function tvAndConsoles:handleIncompatibilityData(data)
	local result = tvAndConsoles.baseClass.handleIncompatibilityData(self, data)
	
	if not result and data.type == tvAndConsoles.INCOMPATIBILITY_TYPES.NO_SOFA then
		result = _T("INCOMPATIBILITY_MUST_HAVE_SOFA_IN_FRONT", "Must have sofa in front")
	end
	
	return result
end

objects.registerNew(tvAndConsoles, "room_checking_object_base")
tvAndConsoles:addIncompatibilityType("NO_SOFA")
