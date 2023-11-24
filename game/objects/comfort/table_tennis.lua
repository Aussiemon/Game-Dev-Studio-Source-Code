local tableTennis = {}

tableTennis.tileWidth = 3
tableTennis.tileHeight = 2
tableTennis.class = "table_tennis"
tableTennis.category = "leisure"
tableTennis.objectType = "decor"
tableTennis.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true
}
tableTennis.display = _T("OBJECT_TABLE_TENNIS", "Table tennis")
tableTennis.description = _T("OBJECT_TABLE_TENNIS_DESCRIPTION", "Might not require an entire courtyard, but fun nonetheless.")
tableTennis.quad = quadLoader:load("table_tennis")
tableTennis.scaleX = 1
tableTennis.scaleY = 1
tableTennis.cost = 400
tableTennis.minimumIllumination = 0
tableTennis.sizeCategory = "unhousable"
tableTennis.requiresEntrance = false
tableTennis.preventsMovement = true
tableTennis.preventsReach = true
tableTennis.affectors = {
	{
		"comfort",
		9
	}
}
tableTennis.addRotation = 0
tableTennis.centerOffsetX = 0
tableTennis.centerOffsetY = -5
tableTennis.icon = "icon_table_tennis"
tableTennis.matchingRequirements = {}

objects.registerNew(tableTennis, "room_checking_object_base")
