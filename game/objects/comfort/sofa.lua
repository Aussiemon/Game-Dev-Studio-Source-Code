local sofa = {}

sofa.tileWidth = 3
sofa.tileHeight = 1
sofa.class = "sofa"
sofa.category = "leisure"
sofa.objectType = "decor"
sofa.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true
}
sofa.display = _T("OBJECT_SOFA", "Sofa")
sofa.description = _T("OBJECT_SOFA_DESCRIPTION", "A place to lie down on during work, or to chill with your coworkers.")
sofa.quad = quadLoader:load("sofa")
sofa.scaleX = 1
sofa.scaleY = 1
sofa.cost = 500
sofa.minimumIllumination = 0
sofa.sizeCategory = "unhousable"
sofa.requiresEntrance = true
sofa.preventsMovement = true
sofa.preventsReach = true
sofa.affectors = {
	{
		"comfort",
		6
	}
}
sofa.addRotation = 0
sofa.centerOffsetX = 0
sofa.centerOffsetY = -5
sofa.icon = "icon_sofa"
sofa.matchingRequirements = {}
sofa.SOFA = true

function sofa:onBeingFaced(employee)
	local ang = self:getFacingAngles()
	local x, y = math.normalfromdeg(ang - 90)
	
	employee:setIsOnWorkplace(false)
	employee:getAvatar():setDrawOffset(math.abs(x) * self.X_OFFSET_TO_CHAIR + y * -self.FORWARD_OFFSET_TO_CHAIR, math.abs(y) * self.Y_OFFSET_TO_CHAIR + x * self.FORWARD_OFFSET_TO_CHAIR)
	self.baseClass.onBeingFaced(self, employee)
	employee:setAngleRotation(ang)
end

objects.registerNew(sofa, "room_checking_object_base")
