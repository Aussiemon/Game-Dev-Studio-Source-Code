local platformCostTextbox = {}

platformCostTextbox.numbersOnly = true
platformCostTextbox.negativeNumbers = false

local genericElement = gui.getClassTable("GenericElement")

platformCostTextbox.skinTextFillColor = color(150, 150, 150, 255)
platformCostTextbox.skinTextSelectColor = color(255, 255, 255, 255)
platformCostTextbox.skinPanelFillColor = color(99, 119, 65, 255)
platformCostTextbox.skinPanelHoverColor = color(164, 198, 109, 255)
platformCostTextbox.skinPanelDisableColor = color(74, 89, 49, 255)
platformCostTextbox.skinPanelSelectColor = platformCostTextbox.skinPanelHoverColor
platformCostTextbox.updateSprites = genericElement.updateSprites

function platformCostTextbox:getDisplayText()
	return _format(_T("PLATFORM_PRICE", "$COST (TAX% tax)"), "COST", string.comma(self.curText), "TAX", math.round((1 - playerPlatform.SELL_TAX) * 100, 1))
end

function platformCostTextbox:onMouseEntered()
	platformCostTextbox.baseClass.onMouseEntered(self)
	
	local x, y = self:getPos(true)
	
	self.infoBox = gui.create("GenericDescbox")
	
	self.infoBox:tieVisibilityTo(self)
	self:setupInfoBox()
	self:queueSpriteUpdate()
end

function platformCostTextbox:setupInfoBox()
	local wrapW = 400
	
	self.infoBox:addText(_T("PLATFORM_COST_DESC", "Set the price a single unit will sell for. As a general rule, the price should exceed the manufacturing cost by just enough to cover it and the taxes."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "question_mark", 22, 22)
	self.infoBox:centerToElement(self)
end

function platformCostTextbox:onMouseLeft()
	if self.infoBox then
		self.infoBox:kill()
		
		self.infoBox = nil
	end
	
	self:queueSpriteUpdate()
end

function platformCostTextbox:isOn()
	return self:isSelected()
end

function platformCostTextbox:onDeselect()
	self:queueSpriteUpdate()
end

function platformCostTextbox:setPlatform(plat)
	self.platform = plat
end

function platformCostTextbox:updateSprites()
	genericElement.updateSprites(self)
	
	self.cashWadSprite = self:allocateSprite(self.cashWadSprite, "wad_of_cash", self.w - _S(self.rawH + 2), _S(1), 0, self.rawH - 2, self.rawH - 2, 0, 0, -0.05)
end

function platformCostTextbox:adjustPointerPosition(pointerX, baseOff)
	return self.font:getWidth(_format("$COST", "COST", string.comma(self.curText))) + baseOff
end

function platformCostTextbox:onWrite()
	self.platform:setCost(tonumber(self.curText))
end

function platformCostTextbox:onDelete()
	self.platform:setCost(tonumber(self.curText))
end

function platformCostTextbox:draw()
	self:drawText()
end

gui.register("PlatformCostTextbox", platformCostTextbox, "TextBox")
