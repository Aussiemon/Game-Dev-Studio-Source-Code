local whiteboard = {}

whiteboard.tileWidth = 2
whiteboard.tileHeight = 1
whiteboard.class = "whiteboard"
whiteboard.category = "office"
whiteboard.objectType = "office"
whiteboard.roomType = {
	[studio.ROOM_TYPES.CONFERENCE] = true,
	[studio.ROOM_TYPES.OFFICE] = true
}
whiteboard.roomTypeExclusions = {}
whiteboard.display = _T("OBJECT_WHITEBOARD", "Whiteboard")
whiteboard.description = _T("OBJECT_WHITEBOARD_DESCRIPTION", "Write down plans, visualize how code should work, explain things to others on this.")
whiteboard.quad = quadLoader:load("whiteboard")
whiteboard.scaleX = 1
whiteboard.scaleY = 1
whiteboard.cost = 100
whiteboard.requiresObject = false
whiteboard.requiresEntrance = true
whiteboard.inheritsRotation = false
whiteboard.preventsMovement = true
whiteboard.affectors = {}
whiteboard.realMonthlyCosts = {}
whiteboard.monthlyCosts = monthlyCost.new()
whiteboard.xDirectionalOffset = 8
whiteboard.yDirectionalOffset = -8
whiteboard.objectAtlas = "object_atlas_1"
whiteboard.objectAtlasBetweenWalls = "object_atlas_1_between_walls"
whiteboard.icon = "icon_whiteboard"
whiteboard.devSpeedMultiplier = 0.1
whiteboard.devSpeedMultiplierID = "whiteboard"

objects.registerNew(whiteboard, "coffee_machine")
