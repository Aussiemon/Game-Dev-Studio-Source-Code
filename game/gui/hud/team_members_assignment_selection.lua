local teamAssignmentSelection = {}

teamAssignmentSelection.handleEvent = false

function teamAssignmentSelection:setTeam(team)
	self.team = team
	self.text = team:getName()
	self.memberText = team:getMemberCountText(#team:getMembers())
	
	self.textObject:addShadowed(self.text, game.UI_COLORS.WHITE, 0, 0)
	self.textObject:addShadowed(self.memberText, game.UI_COLORS.LIGHT_BLUE, _S(28), self.nameTextFontHeight + _S(4))
	
	self.textX, self.textY = math.floor(_S(5)), math.floor(_S(2))
end

function teamAssignmentSelection:initTextObjects()
	self.miscTextY = _S(2) + self.nameTextFontHeight
	self.textObject = self:createTextObject(self.nameTextFont)
end

function teamAssignmentSelection:getTeam()
	return self.team
end

function teamAssignmentSelection:isOn()
	return employeeAssignment:getAssignmentTarget() == self.team
end

function teamAssignmentSelection:onClick(x, y, key)
	employeeAssignment:setAssignmentTarget(self.team)
end

function teamAssignmentSelection:updateSprites()
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
	
	local x, y = _S(5), self.nameTextFontHeight + _S(4)
	
	self.membersBackdrop = self:allocateSprite(self.membersBackdrop, "profession_backdrop", x, y, 0, 26, 26, 0, 0, -0.5)
	self.membersIcon = self:allocateSprite(self.membersIcon, "employees", x + _S(1), y + _S(1), 0, 24, nil, 0, 0, -0.35)
end

function teamAssignmentSelection:draw(w, h)
	love.graphics.draw(self.textObject, self.textX, self.textY)
end

gui.register("TeamMembersAssignmentSelection", teamAssignmentSelection, "EmployeeAssignmentSelection")
