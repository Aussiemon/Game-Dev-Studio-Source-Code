local microwaveOven = {}

microwaveOven.tileWidth = 1
microwaveOven.tileHeight = 1
microwaveOven.class = "microwave"
microwaveOven.category = {
	"food"
}
microwaveOven.objectType = "food"
microwaveOven.roomType = studio.ROOM_TYPES.KITCHEN
microwaveOven.display = _T("MICROWAVE", "Microwave oven")
microwaveOven.description = _T("MICROVE_DESCRIPTION", "Quick and easy food heating!")
microwaveOven.quad = quadLoader:load("microwave_oven")
microwaveOven.scaleX = 1
microwaveOven.scaleY = 1
microwaveOven.cost = 100
microwaveOven.sizeCategory = "small_desk_object"
microwaveOven.requiresObject = true
microwaveOven.requiresEntrance = false
microwaveOven.inheritsRotation = true
microwaveOven.preventsMovement = true
microwaveOven.affectors = {
	{
		"food",
		5
	}
}
microwaveOven.xDirectionalOffset = 8
microwaveOven.yDirectionalOffset = -8
microwaveOven.objectAtlas = "object_atlas_2"
microwaveOven.objectAtlasBetweenWalls = "object_atlas_2_between_walls"
microwaveOven.icon = "icon_microwave"
microwaveOven.realMonthlyCosts = {
	{
		cost = 2,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "food"
	},
	{
		cost = 4,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "electricity"
	}
}
microwaveOven.monthlyCosts = monthlyCost.new()
microwaveOven.roomTypeExclusions = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.TOILET] = true
}
microwaveOven.matchingRequirements = {}

objects.registerNew(microwaveOven, "room_checking_object_base")
