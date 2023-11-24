local officeCostDisplay = {}

officeCostDisplay.iconOffset = 2
officeCostDisplay.baseOffset = 2
officeCostDisplay.iconSize = 32
officeCostDisplay.skinPanelFillColor = color(0, 0, 0, 200)
officeCostDisplay.skinPanelHoverColor = game.UI_COLORS.GREEN:duplicate()
officeCostDisplay.skinPanelHoverColor.a = 200
officeCostDisplay.skinTextFillColor = color(255, 255, 255, 255)
officeCostDisplay.skinTextHoverColor = color(255, 255, 255, 255)
officeCostDisplay.textShadowFillColor = color(0, 0, 0, 255)
officeCostDisplay.textShadowHoverColor = color(0, 0, 0, 255)
officeCostDisplay.OFFICE_DISPLAY = true
officeCostDisplay._scaleHor = false
officeCostDisplay._scaleVert = false

function officeCostDisplay:initVisual()
	self.baseFont = fonts.get("bh_world22")
	self.costFont = fonts.get("pix_world22")
end

function officeCostDisplay:think()
	if not self.mouseOnOffice or not self.canHover then
		self:updateCameraPosition()
	else
		if frameController:preventsMouseOver() then
			return 
		end
		
		local mouseX, mouseY = love.mouse.getPosition()
		
		self:setPos(mouseX - self.w + _S(10), mouseY - self.h + _S(10))
	end
end

function officeCostDisplay:updateCameraPosition(force)
	local x, y = camera:getLocalMousePosition(self.midX, self.midY)
	
	if x ~= self.prevCamX or y ~= self.prevCamY or force then
		self:setPos(x - self.w * 0.5, y - self.h * 0.5)
		self:queueSpriteUpdate()
		
		self.prevCamX = x
		self.prevCamY = y
	end
end

function officeCostDisplay:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and not frameController:preventsMouseOver() then
		self.office:createPurchaseConfirmationPopup()
	end
end

function officeCostDisplay:officeMouseOver()
	self.mouseOnOffice = true
end

function officeCostDisplay:officeMouseLeft()
	self.mouseOnOffice = false
	
	self:updateCameraPosition(true)
end

function officeCostDisplay:onMouseEntered()
	self:queueSpriteUpdate()
end

function officeCostDisplay:onMouseLeft()
	self:queueSpriteUpdate()
end

function officeCostDisplay:setOffice(office)
	self.office = office
	self.rivalID = office:getRivalOwner()
	
	if self.office:getReserved() then
		self.baseText = _T("OFFICE_RESERVED", "Office reserved")
		self.costText = _T("NOT_FOR_SALE", "Not for sale")
		
		self:setCanClick(false)
		self:setCanHover(false)
	elseif self.rivalID then
		self.baseText = _format(_T("RIVAL_OWNED_OFFICE", "'RIVAL' office"), "RIVAL", rivalGameCompanies.registeredByID[self.rivalID].name)
		self.costText = _T("NOT_FOR_SALE", "Not for sale")
	elseif self.office:isPedestrianBuilding() then
		self.baseText = _T("RESIDENTIAL_BUILDING", "Residential building")
		self.costText = _T("NOT_FOR_SALE", "Not for sale")
		
		self:setCanClick(false)
		self:setCanHover(false)
	else
		self.baseText = _T("OFFICE_FOR_SALE", "For sale!")
		self.costText = _format(_T("GENERIC_COST", "$COST"), "COST", string.comma(self.office:getCost()))
	end
	
	self:setupDisplay()
end

function officeCostDisplay:setupDisplay()
	self.costTextX = self.iconSize + self.iconOffset * 2
	self.costTextY = self.baseFont:getHeight() + self.baseOffset
	
	local baseTextWidth = self.baseFont:getWidth(self.baseText)
	
	self:setWidth(math.max(baseTextWidth, self.costTextX + self.costFont:getWidth(self.costText)) + 5)
	
	self.baseTextX = (self.w - baseTextWidth) * 0.5
	self.midX, self.midY = self.office:getMidCoordinates()
end

function officeCostDisplay:getIcon()
	if self.office:getReserved() or self.office:isPedestrianBuilding() then
		return "unavailable"
	end
	
	return self.rivalID and "rivals" or "wad_of_cash"
end

function officeCostDisplay:updateSprites()
	local pCol = self:getStateColor()
	
	self:setNextSpriteColor(pCol:unpack())
	
	self.rectSprites = self:allocateRoundedRectangle(self.rectSprites, 0, 0, self.rawW, self.rawH, 3, -0.5)
	self.cashSprite = self:allocateSprite(self.cashSprite, self:getIcon(), self.iconOffset, self.baseFont:getHeight() + self.baseOffset, 0, self.iconSize, self.iconSize, 0, 0, -0.4)
end

function officeCostDisplay:draw(w, h)
	local textColor, shadowColor
	
	if self:isMouseOver() then
		textColor = self.skinTextHoverColor
		shadowColor = self.textShadowHoverColor
	else
		textColor = self.skinTextFillColor
		shadowColor = self.textShadowFillColor
	end
	
	love.graphics.setFont(self.baseFont)
	love.graphics.printST(self.baseText, self.baseTextX, self.baseOffset, textColor.r, textColor.g, textColor.b, textColor.a, shadowColor.r, shadowColor.g, shadowColor.b, shadowColor.a)
	love.graphics.setFont(self.costFont)
	love.graphics.printST(self.costText, self.costTextX, self.costTextY, textColor.r, textColor.g, textColor.b, textColor.a, shadowColor.r, shadowColor.g, shadowColor.b, shadowColor.a)
end

gui.register("OfficeCostDisplay", officeCostDisplay)
