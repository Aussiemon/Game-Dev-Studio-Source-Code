local acUnit = {}

acUnit.tileWidth = 2
acUnit.tileHeight = 1
acUnit.class = "ac_unit"
acUnit.category = "office"
acUnit.objectType = "decor"
acUnit.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true
}
acUnit.display = _T("OBJECT_AC_UNIT", "Air conditioner")
acUnit.description = _T("OBJECT_AC_UNIT_DESCRIPTION", "Adjust the room temperature with the click of a button. What kind of a wonder machine is this?")
acUnit.quad = quadLoader:load("air_conditioner")
acUnit.scaleX = 1
acUnit.scaleY = 1
acUnit.cost = 4000
acUnit.minimumIllumination = 0
acUnit.sizeCategory = "unhousable"
acUnit.requiresEntrance = false
acUnit.preventsMovement = false
acUnit.preventsReach = false
acUnit.requiresWallInFront = true
acUnit.affectors = {
	{
		"comfort",
		3
	}
}
acUnit.addRotation = 0
acUnit.centerOffsetX = 0
acUnit.centerOffsetY = 0
acUnit.xDirectionalOffset = 16
acUnit.yDirectionalOffset = -20
acUnit.icon = "icon_ac_unit"
acUnit.matchingRequirements = {}
acUnit.monthlyCosts = monthlyCost.new()
acUnit.objectAtlas = "object_atlas_3"
acUnit.objectAtlasBetweenWalls = "object_atlas_3_between_walls"
acUnit.realMonthlyCosts = {
	{
		cost = 300,
		disableWithNoEmployees = true,
		type = "electricity"
	}
}
acUnit.placementHeight = 200

function acUnit:setReachable(state)
	self.reachable = true
end

function acUnit:getDirectionalOffset()
	if self.rotation == walls.DOWN then
		return self.xDirectionalOffset, self.yDirectionalOffset + 4
	end
	
	return self.xDirectionalOffset, self.yDirectionalOffset
end

objects.registerNew(acUnit, "room_checking_object_base")
