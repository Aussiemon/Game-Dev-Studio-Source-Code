local circleRoleFilter = {}

circleRoleFilter.enabledColor = color(210, 210, 210, 255)
circleRoleFilter.disabledColor = color(30, 30, 30, 255)
circleRoleFilter.hoverColor = color(255, 255, 255, 255)

function circleRoleFilter:setRole(role)
	circleRoleFilter.baseClass.setRole(self, role)
	
	local roleData = attributes.profiler.rolesByID[self.role]
	
	self.icon = roleData.flatIcon
	self.iconHover = self.icon .. "_hover"
	self.iconInactive = self.icon .. "_inactive"
end

function circleRoleFilter:updateSprites()
	self:setNextSpriteColor(255, 255, 255, 255)
	
	local icon
	
	if self:isMouseOver() then
		icon = self.iconHover
	elseif self.roleState then
		icon = self.icon
	else
		icon = self.iconInactive
	end
	
	self.iconSprite = self:allocateSprite(self.iconSprite, icon, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.15)
end

gui.register("CircleRoleFilter", circleRoleFilter, "RoleFilterer")
