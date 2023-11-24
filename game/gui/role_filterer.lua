local roleFilter = {}

roleFilter.enabledColor = game.UI_COLORS.NEW_HUD_FILL_3
roleFilter.hoverColor = game.UI_COLORS.NEW_HUD_HOVER
roleFilter.disabledColor = color(65, 79, 102, 255)
roleFilter.iconPad = 3
roleFilter.skinTextFillColor = color(245, 245, 245, 255)
roleFilter.skinTextHoverColor = color(255, 255, 255, 255)
roleFilter.underIconColor = color(52, 74, 102, 255)

function roleFilter:init()
	self.roleState = true
	
	self:setFont("pix24")
end

function roleFilter:setFont(font)
	self.font = fonts.get(font)
	self.fontHeight = self.font:getHeight()
end

function roleFilter:setRole(role)
	self.role = role
end

function roleFilter:onMouseEntered()
	local roleData = attributes.profiler.rolesByID[self.role]
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(string.easyformatbykeys(_T("DISPLAY_ROLE", "Show ROLE roles"), "ROLE", roleData.display), "pix20", nil, 4, 300)
	self.descBox:addText(_T("SHOW_THIS_ROLE_ONLY", "Show this role only"), "pix20", game.UI_COLORS.IMPORTANT_1, 0, 300, "mouse_right", 22, 22)
	roleData:addRoleEmploymentInfo(self.descBox, 300, studio:getEmployeeCountByRole(roleData.id))
	self.descBox:centerToElement(self)
	self:queueSpriteUpdate()
end

function roleFilter:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function roleFilter:changeRoleState(state)
	self.roleState = state
	
	self:queueSpriteUpdate()
end

function roleFilter:onClick(x, y, key)
	self.roleState = not self.roleState
	
	local parent = self:getParent()
	
	if key == gui.mouseKeys.RIGHT then
		if parent:shouldHideRoles(self.role) then
			parent:showEmployeesOfRole(self.role)
			sound:play("feature_selected", nil, nil, nil)
		else
			parent:hideEmployeesOfRole(self.role)
			sound:play("feature_deselected", nil, nil, nil)
		end
	elseif self.roleState then
		parent:showEmployeeRole(self.role)
		sound:play("feature_selected", nil, nil, nil)
	else
		parent:hideEmployeeRole(self.role)
		sound:play("feature_deselected", nil, nil, nil)
	end
	
	self:queueSpriteUpdate()
end

function roleFilter:getRole()
	return self.role
end

function roleFilter:isRoleDisplayed()
	return self.roleState
end

function roleFilter:updateSprites()
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.15)
	
	if self.roleState then
		if self:isMouseOver() then
			self:setNextSpriteColor(self.hoverColor:unpack())
		else
			self:setNextSpriteColor(self.enabledColor:unpack())
		end
	elseif self:isMouseOver() then
		self:setNextSpriteColor(self.hoverColor:unpack())
	else
		self:setNextSpriteColor(self.disabledColor:unpack())
	end
	
	self.backSprite = self:allocateSprite(self.backSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - _S(2), self.rawH - _S(2), 0, 0, -0.1)
	
	local roleData = attributes.profiler.rolesByID[self.role]
	local scaledPad = _S(self.iconPad)
	local sprite = self.roleState and "checkbox_on" or "checkbox_off"
	local iconSize = self.rawH - scaledPad * 2
	
	self:setNextSpriteColor(self.underIconColor:unpack())
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", scaledPad, scaledPad, 0, iconSize, iconSize, 0, 0, -0.1)
	self.roleIconSprite = self:allocateSprite(self.roleIconSprite, roleData.roleIcon, scaledPad, scaledPad, 0, iconSize, iconSize, 0, 0, -0.1)
	self.checkboxSprite = self:allocateSprite(self.checkboxSprite, sprite, self.w - scaledPad - iconSize, scaledPad, 0, iconSize, iconSize, 0, 0, -0.1)
end

function roleFilter:draw(w, h)
	local iconSize = self.h + _S(self.iconPad) * 2
	local textColor = select(2, self:getStateColor())
	
	love.graphics.setFont(self.font)
	love.graphics.printST(#self:getParent():getScroller():getEmployeesItemsOfRole(self.role), iconSize, (h - self.fontHeight) * 0.5, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

gui.register("RoleFilterer", roleFilter)
