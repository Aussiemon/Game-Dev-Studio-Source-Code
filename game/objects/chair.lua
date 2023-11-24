local chair = {}

chair.tileWidth = 2
chair.tileHeight = 1
chair.class = "chair"
chair.objectType = "chair"
chair.category = "office"
chair.display = _T("CHAIR", "Chair")
chair.description = _T("CHAIR_DESCRIPTION", "Place next to a conference table.")
chair.quad = quadLoader:load("conference_chair")
chair.scaleX = 1
chair.scaleY = 1
chair.cost = 100
chair.preventsMovement = true
chair.preventsReach = false
chair.addRotation = 180
chair.centerOffsetX = 0
chair.centerOffsetY = -5
chair.minimumIllumination = 0
chair.animateOnFacing = false
chair.icon = "icon_conference_chair"
chair.X_OFFSET_TO_CHAIR = 24
chair.Y_OFFSET_TO_CHAIR = 24
chair.FORWARD_OFFSET_TO_CHAIR = -18

function chair:onBeingFaced(employee)
	local ang = self:getFacingAngles()
	local x, y = math.normalfromdeg(ang - 90)
	
	employee:setIsOnWorkplace(false)
	employee:getAvatar():setDrawOffset(math.abs(x) * self.X_OFFSET_TO_CHAIR + y * -self.FORWARD_OFFSET_TO_CHAIR, math.abs(y) * self.Y_OFFSET_TO_CHAIR + x * self.FORWARD_OFFSET_TO_CHAIR)
	self.baseClass.onBeingFaced(self, employee)
	employee:setAngleRotation(ang)
end

objects.registerNew(chair, "static_object_base")
