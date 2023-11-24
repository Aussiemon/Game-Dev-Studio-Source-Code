local toilet = {}

toilet.tileWidth = 1
toilet.tileHeight = 1
toilet.class = "toilet"
toilet.category = "sanitary"
toilet.objectType = "toilet"
toilet.roomType = studio.ROOM_TYPES.TOILET
toilet.display = _T("TOILET", "Toilet")
toilet.description = _T("TOILET_DESCRIPTION", "Mandatory part of a restroom.")
toilet.quad = quadLoader:load("toilet_open")
toilet.scaleX = 1
toilet.scaleY = 1
toilet.maximumEntryPoints = 1
toilet.minimumIllumination = 0.7
toilet.cost = 20
toilet.sizeCategory = "toilet"
toilet.requiresEntrance = true
toilet.requiresWallInFront = true
toilet.preventsMovement = true
toilet.noWindows = true
toilet.affectors = {
	{
		"sanitary",
		14
	}
}
toilet.xOffset = 0
toilet.yOffset = 0
toilet.yDirectionalOffset = -2
toilet.icon = "icon_toilet"
toilet.realMonthlyCosts = {
	{
		cost = 5,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "water"
	}
}
toilet.monthlyCosts = monthlyCost.new()
toilet.OFFSET_TO_SHITTER = 40
toilet.roomRequirements = {
	sink = 1,
	toilet_paper = 1
}
toilet.roomTypeExclusions = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.KITCHEN] = true
}
toilet.matchingRequirements = {}

function toilet:getInteractAnimation(employee)
	return employee:getToiletAnimation()
end

function toilet:onBeingFaced(employee)
	local ang = self:getFacingAngles() + 90
	local x, y = math.normalfromdeg(ang)
	
	employee:getAvatar():setDrawOffset(y * toilet.OFFSET_TO_SHITTER, -x * toilet.OFFSET_TO_SHITTER)
	self.baseClass.onBeingFaced(self, employee)
	employee:setAngleRotation(ang - 90)
	employee:changeFullness(-100)
	
	local gridX, gridY = self:getTileCoordinates()
	local objectGrid = game.worldObject:getObjectGrid()
	
	for y = gridY - 1, gridY + 1 do
		for x = gridX - 1, gridX + 1 do
			local objects = objectGrid:getObjects(x, y, self.floor)
			
			if objects then
				for key, object in ipairs(objects) do
					if object.room == self.room and object.objectType == "door" then
						object:removeOpener(employee)
					end
				end
			end
		end
	end
end

function toilet:setInteractionTarget(obj)
	if not obj and self.interactionTarget then
		self.interactionTarget:getAvatar():setDrawOffset(0, 0)
	end
	
	self.baseClass.setInteractionTarget(self, obj)
end

function toilet:getFacingAngles()
	return walls.RAW_ANGLES[self.rotation] - 90
end

objects.registerNew(toilet, "room_checking_object_base")
