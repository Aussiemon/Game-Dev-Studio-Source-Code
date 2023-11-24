local vendingMachine = {}

vendingMachine.tileWidth = 2
vendingMachine.tileHeight = 1
vendingMachine.class = "snack_vending_machine"
vendingMachine.category = "food"
vendingMachine.objectType = "food"
vendingMachine.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.KITCHEN] = true
}
vendingMachine.display = _T("SNACK_VENDING_MACHINE", "Snack vending machine")
vendingMachine.description = _T("SNACK_VENDING_MACHINE_DESCRIPTION", "Forgot your lunch at home and coworkers won't share? Have no fear, snacks are here!")
vendingMachine.quad = quadLoader:load("vending_machine")
vendingMachine.scaleX = 1.5
vendingMachine.scaleY = 1.5
vendingMachine.cost = 400
vendingMachine.minimumIllumination = 0
vendingMachine.sizeCategory = "unhousable"
vendingMachine.requiresEntrance = true
vendingMachine.inheritsRotation = true
vendingMachine.preventsMovement = true
vendingMachine.affectors = {
	{
		"food",
		10
	},
	{
		"comfort",
		1
	}
}
vendingMachine.xDirectionalOffset = -8
vendingMachine.yDirectionalOffset = 8
vendingMachine.lightColor = color(178, 154, 121, 255)
vendingMachine.icon = "icon_vending_machine"
vendingMachine.lightCaster = "vending_machine_caster"
vendingMachine.realMonthlyCosts = {
	{
		cost = 5,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "food"
	},
	{
		cost = 2.5,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "electricity"
	}
}
vendingMachine.monthlyCosts = monthlyCost.new()
vendingMachine.matchingRequirements = {}

function vendingMachine:getEntranceInteractionCoordinates(startX, startY)
	local entranceStartX, entranceStartY, entranceEndX, entranceEndY = self:getEntranceCoordinates(startX, startY)
	
	return entranceStartX, entranceStartY
end

function vendingMachine:onBeingFaced(employee)
	vendingMachine.baseClass.onBeingFaced(self, employee)
	
	local avatar = employee:getAvatar()
	
	avatar:addAnimToQueue(employee:getAnimationList().eat, 0.75)
	employee:changeSatiety(25)
end

function vendingMachine:finalizeGridPlacement(...)
	vendingMachine.baseClass.finalizeGridPlacement(self, ...)
	self:enableLightCasting()
end

function vendingMachine:castLight(imageData, pixelX, pixelY)
	local clr = self.lightColor
	local r, g, b = imageData:getPixel(pixelX, pixelY)
	
	imageData:setPixel(pixelX, pixelY, math.max(r, clr.r), math.max(g, clr.g), math.max(b, clr.b), 255)
end

objects.registerNew(vendingMachine, "room_checking_object_base")
