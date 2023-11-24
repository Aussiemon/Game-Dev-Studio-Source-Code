local tableFootball = {}

tableFootball.tileWidth = 2
tableFootball.tileHeight = 2
tableFootball.class = "table_football"
tableFootball.category = "leisure"
tableFootball.objectType = "decor"
tableFootball.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true
}
tableFootball.display = _T("OBJECT_TABLE_FOOTBALL", "Table football")
tableFootball.description = _T("OBJECT_TABLE_FOOTBALL_DESCRIPTION", "Compete with your coworkers in this football mock-up.")
tableFootball.quad = quadLoader:load("table_football")
tableFootball.scaleX = 1
tableFootball.scaleY = 1
tableFootball.cost = 300
tableFootball.minimumIllumination = 0
tableFootball.sizeCategory = "unhousable"
tableFootball.requiresEntrance = false
tableFootball.preventsMovement = true
tableFootball.preventsReach = true
tableFootball.affectors = {
	{
		"comfort",
		5
	}
}
tableFootball.addRotation = 0
tableFootball.centerOffsetX = 0
tableFootball.centerOffsetY = -5
tableFootball.icon = "icon_table_football"
tableFootball.matchingRequirements = {}

objects.registerNew(tableFootball, "room_checking_object_base")
