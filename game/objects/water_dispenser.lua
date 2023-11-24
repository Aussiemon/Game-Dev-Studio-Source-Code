local dispenser = {}

dispenser.tileWidth = 1
dispenser.tileHeight = 1
dispenser.class = "water_dispenser"
dispenser.category = "food"
dispenser.objectType = "food"
dispenser.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.KITCHEN] = true
}
dispenser.display = _T("WATER_DISPENSER", "Water dispenser")
dispenser.description = _T("WATER_DISPENSER_DESCRIPTION", "A must-have in any office.\nYour office will need more water dispensers the more employees you have.")
dispenser.quad = quadLoader:load("water_dispenser")
dispenser.scaleX = 1.5
dispenser.scaleY = 1.5
dispenser.preventsMovement = true
dispenser.cost = 100
dispenser.minimumIllumination = 0.2
dispenser.icon = "icon_water_dispenser"
dispenser.realMonthlyCosts = {
	{
		cost = 10,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "water"
	},
	{
		cost = 6,
		disableWithNoEmployees = true,
		type = "electricity"
	}
}
dispenser.monthlyCosts = monthlyCost.new()
dispenser.affectors = {
	{
		"water",
		9
	}
}

function dispenser:onBeingFaced(employee)
	dispenser.baseClass.onBeingFaced(self, employee)
	
	local avatar = employee:getAvatar()
	
	avatar:addAnimToQueue(employee:getAnimationList().drink, 0.75)
	employee:changeHydration(50)
end

objects.registerNew(dispenser, "complex_monthly_cost_object_base")
