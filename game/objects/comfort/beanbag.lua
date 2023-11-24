local beanbag = {}

beanbag.tileWidth = 1
beanbag.tileHeight = 1
beanbag.class = "beanbag"
beanbag.category = "leisure"
beanbag.objectType = "decor"
beanbag.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true
}
beanbag.display = _T("OBJECT_BEANBAG", "Beanbag")
beanbag.description = _T("OBJECT_BEANBAG_DESCRIPTION", "When the office chair becomes too much and you need to take a break... by sitting down on a different sort of chair.")
beanbag.quad = quadLoader:load("beanbag")
beanbag.scaleX = 1
beanbag.scaleY = 1
beanbag.cost = 200
beanbag.minimumIllumination = 0
beanbag.sizeCategory = "unhousable"
beanbag.requiresEntrance = false
beanbag.preventsMovement = true
beanbag.preventsReach = true
beanbag.affectors = {
	{
		"comfort",
		2
	}
}
beanbag.addRotation = 0
beanbag.centerOffsetX = 0
beanbag.centerOffsetY = -5
beanbag.icon = "icon_beanbag"
beanbag.matchingRequirements = {}

function beanbag:onBeingFaced(employee)
	local ang = self:getFacingAngles()
	local x, y = math.normalfromdeg(ang - 90)
	
	employee:setIsOnWorkplace(false)
	employee:getAvatar():setDrawOffset(math.abs(x) * self.X_OFFSET_TO_CHAIR + y * -self.FORWARD_OFFSET_TO_CHAIR, math.abs(y) * self.Y_OFFSET_TO_CHAIR + x * self.FORWARD_OFFSET_TO_CHAIR)
	self.baseClass.onBeingFaced(self, employee)
	employee:setAngleRotation(ang)
end

function beanbag:canRotate()
	return false
end

function beanbag:selectForPurchase()
	self.rotation = walls.UP
	
	studio.expansion:setRotation(self.rotation)
end

objects.registerNew(beanbag, "room_checking_object_base")
