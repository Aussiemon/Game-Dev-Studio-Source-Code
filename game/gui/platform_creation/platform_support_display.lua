local platformSupport = {}

platformSupport.spacing = 2
platformSupport.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.CHANGED_SUPPORT
}
platformSupport.skinPanelFillColor = color(86, 104, 135, 255)
platformSupport.skinPanelHoverColor = color(179, 194, 219, 255)
platformSupport.skinPanelSelectColor = color(151, 198, 168, 255)
platformSupport.skinPanelDisableColor = color(69, 84, 112, 255)
platformSupport.skinPanelOutlineColor = color(0, 0, 0, 100)
platformSupport.baseBackgroundColor = color(0, 0, 0, 100)
platformSupport.baseBackgroundColorHover = color(0, 0, 0, 20)
platformSupport.numbersOnly = true
platformSupport.minValue = 0

function platformSupport:handleEvent(event)
	self:setText(self.platform:getSupport())
	self:updateText()
end

function platformSupport:onMouseEntered()
	self:queueSpriteUpdate()
	self:setupDescBox()
end

function platformSupport:setPlatform(plat)
	self.platform = plat
end

function platformSupport:setupDescBox()
	local funds = studio:getFunds()
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:positionToMouse(_S(10), _S(10))
	self:fillDescbox()
	self.descBox:centerToElement(self)
end

function platformSupport:fillDescbox()
	if self.descBox then
		self.descBox:removeAllText()
		self.descBox:addText(_format(_T("PLATFORM_SUPPORT_VALUE", "Customer support: SUPPORT"), "SUPPORT", string.roundtobignumber(self.platform:getSupportValue())), "bh20", nil, 0, wrapWidth, "employees", 24, 24)
		self.descBox:addText(_format(_T("PLATFORM_SUPPORT_COST", "Cost: COST/month"), "COST", string.roundtobigcashnumber(self.platform:getSupportCost())), "bh20", nil, 0, wrapWidth, "wad_of_cash_minus", 24, 24)
		
		if self.platform:isReleased() then
			self.descBox:addSpaceToNextText(5)
			self.descBox:addText(_format(_T("PLATFORM_SUPPORT_REPAIRS", "Repairs this week: REPAIRS"), "REPAIRS", string.comma(self.platform:getWeekRepairs())), "bh18", nil, 0, wrapWidth, "platform_units_repaired", 24, 24)
		end
	end
end

function platformSupport:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function platformSupport:updateText()
	self:updateDisplayText()
	
	self.textW = self.font:getWidth(self:getDisplayText())
	self.textX = self.w - self.textW - _S(4)
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
	
	self:fillDescbox()
end

function platformSupport:updateDisplayText()
	self.displayText = _format("xPRODUCTION", "PRODUCTION", string.roundtobignumber(tonumber(self.curText)))
end

function platformSupport:getDisplayText()
	return self.displayText
end

function platformSupport:getTextX()
	return self.textX, self.textW
end

function platformSupport:getTextY()
	return self.textY
end

function platformSupport:onWrite()
	self.platform:changeSupport(tonumber(self.curText) - self.platform:getSupport())
	self:setText(self.platform:getSupport())
	self:updateText()
end

function platformSupport:onDelete()
	self.platform:changeSupport(tonumber(self.curText) - self.platform:getSupport())
	self:updateText()
end

function platformSupport:updateSprites()
	local poutline = self:getPanelOutlineColor()
	
	self:setNextSpriteColor(poutline:unpack())
	
	self.outlineSprite = self:allocateSprite(self.outlineSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.5)
	
	if self:isMouseOver() then
		self:setNextSpriteColor(self.baseBackgroundColorHover:unpack())
	else
		self:setNextSpriteColor(self.baseBackgroundColor:unpack())
	end
	
	local scaledSpacing = _S(self.spacing)
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", scaledSpacing, scaledSpacing, 0, self.rawW - self.spacing * 2, self.rawH - self.spacing * 2, 0, 0, -0.49)
end

function platformSupport:draw(w, h)
	self:drawText()
end

gui.register("PlatformSupportDisplay", platformSupport, "TextBox")
