local rack = {}

rack.tileWidth = 2
rack.tileHeight = 2
rack.class = "squat_rack"
rack.category = "leisure"
rack.objectType = "leisure"
rack.display = _T("SQUAT_RACK", "Squat rack")
rack.description = _T("SQUAT_RACK_DESCRIPTION", "Hope you're not doing barbell curls in the squat rack.")
rack.quad = quadLoader:load("squat_rack")
rack.scaleX = 1
rack.scaleY = 1
rack.xOffset = 0
rack.yOffset = 0
rack.cost = 300
rack.interestPoints = {
	lifting = 30
}
rack.icon = "icon_squat_rack"
rack.affectors = {
	{
		"comfort",
		1
	}
}
rack.baseOffsetX = 24
rack.baseOffsetY = 24
rack.roomTypeExclusions = {
	[studio.ROOM_TYPES.TOILET] = true
}

objects.registerNew(rack, "room_checking_object_base")
