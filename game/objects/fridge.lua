local fridge = {}

fridge.tileWidth = 1
fridge.tileHeight = 1
fridge.class = "fridge"
fridge.category = {
	"food"
}
fridge.objectType = "food"
fridge.roomType = studio.ROOM_TYPES.KITCHEN
fridge.display = _T("FRIDGE", "Fridge")
fridge.description = _T("FRIDGE_DESCRIPTION", "Thank God there's a fridge! Just make sure to keep it clean.")
fridge.quad = quadLoader:load("fridge")
fridge.scaleX = 1
fridge.scaleY = 1
fridge.cost = 100
fridge.sizeCategory = "unhousable"
fridge.requiresEntrance = true
fridge.preventsMovement = true
fridge.affectors = {
	{
		"food",
		30
	}
}
fridge.objectAtlas = "object_atlas_1"
fridge.icon = "icon_fridge"
fridge.roomRequirements = {
	kitchen_sink = 1
}
fridge.realMonthlyCosts = {
	{
		cost = 40,
		divideByObjectCount = true,
		disableWithNoEmployees = true,
		type = "electricity"
	}
}
fridge.monthlyCosts = monthlyCost.new()
fridge.roomTypeExclusions = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.TOILET] = true
}
fridge.matchingRequirements = {}

objects.registerNew(fridge, "room_checking_object_base")
