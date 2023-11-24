local stove = {}

stove.tileWidth = 1
stove.tileHeight = 1
stove.class = "stove"
stove.category = {
	"food"
}
stove.objectType = "food"
stove.roomType = studio.ROOM_TYPES.KITCHEN
stove.display = _T("STOVE", "Stove")
stove.description = _T("STOVE_DESCRIPTION", "When a microwave oven ain't cutting it or you want to heat a pizza - a stove is the way to go.")
stove.quad = quadLoader:load("stove")
stove.scaleX = 1
stove.scaleY = 1
stove.cost = 100
stove.sizeCategory = "unhousable"
stove.requiresEntrance = true
stove.preventsMovement = true
stove.affectors = {
	{
		"food",
		10
	}
}
stove.objectAtlas = "object_atlas_1"
stove.icon = "icon_stove"
stove.roomRequirements = {
	kitchen_sink = 1
}
stove.realMonthlyCosts = {
	{
		cost = 10,
		divideByObjectCount = true,
		multiplyByEmployeeCount = true,
		type = "electricity"
	}
}
stove.monthlyCosts = monthlyCost.new()
stove.roomTypeExclusions = {
	[studio.ROOM_TYPES.OFFICE] = true,
	[studio.ROOM_TYPES.TOILET] = true
}
stove.matchingRequirements = {}

objects.registerNew(stove, "room_checking_object_base")
