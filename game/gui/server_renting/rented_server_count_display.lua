local rentedServers = {}

rentedServers.spacing = 2
rentedServers.CATCHABLE_EVENTS = {
	serverRenting.EVENTS.CHANGED_RENTED_SERVERS
}
rentedServers.skinPanelFillColor = color(86, 104, 135, 255)
rentedServers.skinPanelHoverColor = color(179, 194, 219, 255)
rentedServers.skinPanelSelectColor = color(151, 198, 168, 255)
rentedServers.skinPanelDisableColor = color(69, 84, 112, 255)
rentedServers.skinPanelOutlineColor = color(0, 0, 0, 100)
rentedServers.baseBackgroundColor = color(0, 0, 0, 100)
rentedServers.baseBackgroundColorHover = color(0, 0, 0, 20)
rentedServers.numbersOnly = true
rentedServers.minValue = 0

function rentedServers:handleEvent(event)
	self:setText(studio:getRentedServers())
	self:updateText()
end

function rentedServers:onMouseEntered()
	self:queueSpriteUpdate()
	self:setupDescBox()
end

function rentedServers:setupDescBox()
	local funds = studio:getFunds()
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:positionToMouse(_S(10), _S(10))
	self:fillDescbox()
	self.descBox:centerToElement(self)
end

function rentedServers:fillDescbox()
	if self.descBox then
		self.descBox:removeAllText()
		self.descBox:addText(_format(_T("RENTED_SERVER_CAPACITY", "Rented server capacity: CAP"), "CAP", string.roundtobignumber(studio:getRentedServerCapacity())), "bh20", nil, 0, wrapWidth, "projects_finished", 24, 24)
	end
end

function rentedServers:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function rentedServers:updateText()
	self:updateDisplayText()
	
	self.textW = self.font:getWidth(self:getDisplayText())
	self.textX = self.w - self.textW - _S(4)
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
	
	self:fillDescbox()
end

function rentedServers:updateSprites()
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

function rentedServers:updateDisplayText()
	self.displayText = _format("xPRODUCTION", "PRODUCTION", string.roundtobignumber(tonumber(self.curText)))
end

function rentedServers:getDisplayText()
	return self.displayText
end

function rentedServers:getTextX()
	return self.textX, self.textW
end

function rentedServers:getTextY()
	return self.textY
end

function rentedServers:onWrite()
	serverRenting:changeRentedServers(tonumber(self.curText) - studio:getRentedServers())
	self:setText(studio:getRentedServers())
	self:updateText()
end

function rentedServers:onDelete()
	serverRenting:changeRentedServers(tonumber(self.curText) - studio:getRentedServers())
	self:setText(studio:getRentedServers())
	self:updateText()
end

function rentedServers:draw(w, h)
	self:drawText()
end

gui.register("RentedServerCountDisplay", rentedServers, "TextBox")
