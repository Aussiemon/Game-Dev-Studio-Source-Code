local costDisplay = {}

costDisplay.skinPanelFillColor = color(86, 104, 135, 255)
costDisplay.skinPanelHoverColor = color(179, 194, 219, 255)
costDisplay.skinPanelSelectColor = color(151, 198, 168, 255)
costDisplay.skinPanelDisableColor = color(69, 84, 112, 255)
costDisplay.skinPanelOutlineColor = color(0, 0, 0, 100)
costDisplay.baseBackgroundColor = color(0, 0, 0, 100)
costDisplay.baseBackgroundColorHover = color(0, 0, 0, 20)
costDisplay.overPaymentColor = color(199, 234, 204, 255)
costDisplay.extraTextXOffset = 5
costDisplay.cashWadSpacing = 2
costDisplay.displayOwnFunds = true
costDisplay.icon = "wad_of_cash"

function costDisplay:init()
end

function costDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	self:setupDescBox()
end

function costDisplay:hasEnoughFunds()
	if self.cost <= 0 then
		return true
	end
	
	return studio:getFunds() >= self.cost
end

function costDisplay:setupDescBox()
	local funds = studio:getFunds()
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:positionToMouse(_S(10), _S(10))
	self.descBox:addText(_format(_T("CURRENT_FUNDS", "Funds: FUNDS"), "FUNDS", string.roundtobigcashnumber(funds)), "bh20", nil, 4, wrapWidth, "wad_of_cash_plus", 24, 24)
	self.descBox:addText(_format(_T("CURRENT_COST", "Current cost: COST"), "COST", string.roundtobigcashnumber(self.cost)), "bh20", nil, 0, wrapWidth, "wad_of_cash_minus", 24, 24)
	
	if not self:hasEnoughFunds() then
		self.descBox:addSpaceToNextText(10)
		self.descBox:addText(_T("NOT_ENOUGH_MONEY_LETS_PLAYERS", "You do not have enough money."), "bh20", game.UI_COLORS.RED, 4, wrapWidth, "wad_of_cash_minus", 22, 22)
		self.descBox:addText(_format(_T("NOT_ENOUGH_MONEY_LETS_PLAYERS_2", "You need MONEY more."), "MONEY", string.roundtobigcashnumber(self:getRealCost() - funds)), "pix18", nil, 0, wrapWidth)
	end
end

function costDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function costDisplay:setDisplayOwnFunds(state)
	self.displayOwnFunds = state
end

function costDisplay:setPreviousPayment(prev)
	self.previousPayment = prev
end

function costDisplay:updateSprites()
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
	
	local scaledSpacing = _S(self.cashWadSpacing)
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", scaledSpacing, scaledSpacing, 0, self.rawW - self.cashWadSpacing * 2, self.rawH - self.cashWadSpacing * 2, 0, 0, -0.49)
	
	local cashWadSize = math.min(self.rawW, self.rawH) - self.cashWadSpacing * 2
	
	self.cashWadSprite = self:allocateSprite(self.cashWadSprite, self.icon, scaledSpacing, scaledSpacing, 0, cashWadSize, cashWadSize, 0, 0, -0.45)
	self.textXOffset = _S(cashWadSize) + _S(self.extraTextXOffset)
end

function costDisplay:setFont(font)
	self.font = font
	self.fontObject = fonts.get(font)
	self.fontHeight = self.fontObject:getHeight()
end

function costDisplay:setCost(cost)
	self.cost = cost
	
	self:updateText()
end

function costDisplay:getRealCost()
	if self.previousPayment then
		return self.cost - self.previousPayment
	end
	
	return self.cost
end

function costDisplay:updateText()
	local cost = self:getRealCost()
	local costText
	
	if cost < 0 then
		costText = string.easyformatbykeys(_T("COST_DISPLAY_OVERPAYMENT", "+ COST"), "COST", string.roundtobigcashnumber(math.abs(cost)))
	else
		costText = string.roundtobigcashnumber(cost)
	end
	
	if self.displayOwnFunds then
		self.costText = string.easyformatbykeys(_T("GENERIC_COST_WITH_OWN_FUNDS", "COST (FUNDS)"), "COST", costText, "FUNDS", studio:getFundsText())
	else
		self.costText = string.roundtobigcashnumber(cost)
	end
end

function costDisplay:getTextColor()
	local tCol
	local cost = self:getRealCost()
	
	if cost < 0 then
		return self.overPaymentColor
	elseif not self:hasEnoughFunds() then
		return game.UI_COLORS.RED
	else
		return select(2, self:getStateColor())
	end
end

function costDisplay:draw(w, h)
	local tCol = self:getTextColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.costText, self.textXOffset, h * 0.5 - self.fontHeight * 0.5, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
end

gui.register("CostDisplay", costDisplay)
