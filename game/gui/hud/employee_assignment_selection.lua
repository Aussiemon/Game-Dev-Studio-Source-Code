local assignmentSelection = {}

assignmentSelection.skinPanelFillColor = color(0, 0, 0, 100)
assignmentSelection.skinPanelSelectColor = color(110, 158, 204, 255)
assignmentSelection.skinTextFillColor = color(245, 245, 245, 255)
assignmentSelection.skinTextHoverColor = color(255, 255, 255, 255)
assignmentSelection.skinTextSelectColor = color(255, 255, 255, 255)

function assignmentSelection:init()
	self.alpha = 1
	self.nameTextFont = fonts.get("bh22")
	self.nameTextFontHeight = self.nameTextFont:getHeight()
	self.miscTextFont = fonts.get("bh18")
	self.miscTextFontHeight = self.miscTextFont:getHeight()
	
	self:initTextObjects()
end

function assignmentSelection:initTextObjects()
	self.textX, self.textY = math.floor(_S(5)), math.floor(_S(2))
	self.miscTextY = _S(2) + self.nameTextFontHeight + self.textY
	self.roleTextObj = self:createTextObject(self.miscTextFont)
end

function assignmentSelection:handleEvent(event, obj)
	if (event == employeeAssignment.EVENTS.ASSIGNED or event == employeeAssignment.EVENTS.UNASSIGNED) and obj == self.employee then
		self:updateAssignmentState()
	end
end

function assignmentSelection:updateAssignmentState()
	if self.employee:getWorkplace() then
		self.text = self.employee:getFullName(true)
	else
		self.text = _format(_T("EMPLOYEE_UNASSIGNED_NA", "NAME - N/A"), "NAME", self.employee:getFullName(true))
	end
end

function assignmentSelection:setEmployee(employee)
	self.employee = employee
	
	self:updateAssignmentState()
	self:setupSkillProfessionText()
end

function assignmentSelection:setupSkillProfessionText()
	local mainSkill = self.employee:getMainSkill() or self.employee:getHighestSkill()
	
	self.roleData = self.employee:getRoleData()
	self.skillData = skills:getData(mainSkill)
	self.roleText = self.roleData.display
	self.skillText = _format(_T("MAIN_SKILL_DISPLAY_LAYOUT", "NAME Lv. LEVEL"), "NAME", self.skillData.display, "LEVEL", self.employee:getSkillLevel(mainSkill))
	
	local scaledOffset = math.floor(_S(28))
	local textColor = game.UI_COLORS.WHITE
	
	self.roleTextObj:addShadowed(self.roleText, game.UI_COLORS.LIGHT_BLUE, scaledOffset, _S(2))
	self.roleTextObj:addShadowed(self.skillText, game.UI_COLORS.LIGHT_BLUE, scaledOffset, self.miscTextFontHeight + _S(14))
end

function assignmentSelection:getEmployee()
	return self.employee
end

function assignmentSelection:onClick(x, y, key)
	if not self.employee:getWorkplace() then
		employeeAssignment:setAssignmentTarget(self.employee)
	end
end

function assignmentSelection:isOn()
	return employeeAssignment:getAssignmentTarget() == self.employee
end

function assignmentSelection:setAlpha(alpha)
	self.alpha = alpha
end

function assignmentSelection:updateSprites()
	local isOn = self:isOn()
	local globalAlpha = isOn and 1 or self.alpha
	local r, g, b, a = game.UI_COLORS.NEW_HUD_OUTER:unpack()
	
	self:setNextSpriteColor(r, g, b, a * globalAlpha)
	
	self.bgSpriteUnder = self:allocateHollowRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.92)
	
	local alpha = 100
	
	if self:isMouseOver() then
		local r, g, b, a = game.UI_COLORS.NEW_HUD_HOVER:unpack()
		
		self:setNextSpriteColor(r, g, b, a * globalAlpha)
	elseif isOn then
		local r, g, b, a = game.UI_COLORS.NEW_HUD_HOVER_DESATURATED:unpack()
		
		self:setNextSpriteColor(r, g, b, a * globalAlpha)
	else
		local r, g, b = game.UI_COLORS.NEW_HUD_FILL_3:unpack()
		
		alpha = 50
		
		self:setNextSpriteColor(r, g, b, 200 * globalAlpha)
	end
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.91)
	
	local r, g, b = self.genericFillColor:unpack()
	
	self:setNextSpriteColor(r, g, b, alpha * globalAlpha)
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(2), _S(2), self.rawW - 4, self.rawH - 4, 2, -0.9)
	
	local x = _S(5)
	local y = self.nameTextFontHeight + self.textY
	local scaledX = _S(1)
	
	self.roleBackdrop = self:allocateSprite(self.roleBackdrop, "profession_backdrop", x, y, 0, 26, 26, 0, 0, -0.5)
	self.roleSprite = self:allocateSprite(self.roleSprite, self.roleData.roleIcon, x + scaledX, y + scaledX, 0, 24, 24, 0, 0, -0.45)
	
	local y = self.nameTextFontHeight + _S(28) + self.textY
	
	self.skillBackdrop = self:allocateSprite(self.skillBackdrop, "profession_backdrop", x, y, 0, 26, 26, 0, 0, -0.4)
	self.skillIcon = self:allocateSprite(self.skillIcon, self.skillData.icon, x + scaledX, y + scaledX, 0, 24, 24, 0, 0, -0.35)
end

function assignmentSelection:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	local textOff = math.floor(_S(5))
	local alpha = self:isOn() and 1 or self.alpha
	
	love.graphics.setFont(self.nameTextFont)
	love.graphics.printST(self.text, self.textX, self.textY, textColor.r, textColor.g, textColor.b, textColor.a * alpha, 0, 0, 0, 255 * alpha)
	love.graphics.draw(self.roleTextObj, textOff, self.miscTextY)
end

gui.register("EmployeeAssignmentSelection", assignmentSelection)
