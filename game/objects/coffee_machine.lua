local coffeeMachine = {}

coffeeMachine.tileWidth = 1
coffeeMachine.tileHeight = 1
coffeeMachine.class = "coffee_machine"
coffeeMachine.category = "food"
coffeeMachine.objectType = "food"
coffeeMachine.roomType = studio.ROOM_TYPES.KITCHEN
coffeeMachine.display = _T("COFFEE_MACHINE", "Coffee machine")
coffeeMachine.description = _T("COFFEE_MACHINE_DESCRIPTION", "Nothing beats a cup of coffee in the morning.")
coffeeMachine.quad = quadLoader:load("coffee_machine")
coffeeMachine.scaleX = 1
coffeeMachine.scaleY = 1
coffeeMachine.cost = 400
coffeeMachine.sizeCategory = "small_desk_object"
coffeeMachine.requiresObject = true
coffeeMachine.requiresEntrance = false
coffeeMachine.inheritsRotation = true
coffeeMachine.preventsMovement = true
coffeeMachine.affectors = {
	{
		"food",
		5
	}
}
coffeeMachine.xDirectionalOffset = 8
coffeeMachine.yDirectionalOffset = -8
coffeeMachine.objectAtlas = "object_atlas_2"
coffeeMachine.objectAtlasBetweenWalls = "object_atlas_2_between_walls"
coffeeMachine.icon = "icon_coffee_machine"
coffeeMachine.devSpeedMultiplier = 0.05
coffeeMachine.devSpeedMultiplierID = "coffee"
coffeeMachine.realMonthlyCosts = {
	{
		cost = 5,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "water"
	},
	{
		cost = 2.5,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "food"
	},
	{
		cost = 2,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "electricity"
	}
}
coffeeMachine.monthlyCosts = monthlyCost.new()
coffeeMachine.roomTypeExclusions = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.TOILET] = true
}
coffeeMachine.matchingRequirements = {}
coffeeMachine.coffeeDrinkAmount = {
	2,
	3
}

function coffeeMachine:hasOtherValidContributors()
	if self.office then
		local objects = self.office:getObjectsByClass(self.class)
		local ownClass = self.class
		
		for key, object in ipairs(objects) do
			if object ~= self and object:isPartOfValidRoom() then
				return true
			end
		end
	end
	
	return false
end

function coffeeMachine:addDescriptionToDescbox(descBox, wrapWidth)
	descBox:addSpaceToNextText(5)
	descBox:addText(_format(_T("COFFEE_MACHINE_INCREASED_DEV_SPEED", "Increases development speed by INCREASE%"), "INCREASE", self.devSpeedMultiplier * 100), "bh18", nil, 0, wrapWidth, "increase", 22, 22)
	coffeeMachine.baseClass.addDescriptionToDescbox(self, descBox, wrapWidth)
end

function coffeeMachine:attemptApplyDevSpeedMultiplier(newState)
	if not self.office then
		return 
	end
	
	if newState and self.partOfValidRoom then
		self.office:addDevSpeedMultiplier(self.devSpeedMultiplierID, self.devSpeedMultiplier)
		
		self.addedBonus = true
	else
		self.addedBonus = false
		
		if self:hasOtherValidContributors() then
			return 
		end
		
		self.office:removeDevSpeedMultiplier(self.devSpeedMultiplierID)
	end
end

function coffeeMachine:remove()
	coffeeMachine.baseClass.remove(self)
	
	if self.addedBonus then
		self:attemptApplyDevSpeedMultiplier(false)
	end
end

function coffeeMachine:postRegisteredRooms()
	self:attemptApplyDevSpeedMultiplier(self.partOfValidRoom)
end

function coffeeMachine:onBeingFaced(employee)
	coffeeMachine.baseClass.onBeingFaced(self, employee)
	
	local avatar = employee:getAvatar()
	
	employee:setFact("coffee", math.random(coffeeMachine.coffeeDrinkAmount[1], coffeeMachine.coffeeDrinkAmount[2]))
	employee:setCarryObject("coffee_mug")
end

objects.registerNew(coffeeMachine, "room_checking_object_base")
