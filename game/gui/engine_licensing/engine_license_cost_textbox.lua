local licenseCostTextbox = {}

licenseCostTextbox.numbersOnly = true
licenseCostTextbox.negativeNumbers = false
licenseCostTextbox.maxValue = 60000

function licenseCostTextbox:getDisplayText()
	return _format(_T("PLAYER_ENGINE_PRICEPOINT", "$COST (TAX% tax)"), "COST", string.comma(self.curText), "TAX", math.round(engineLicensing.ENGINE_LICENSING_TAX * 100, 1))
end

local genericElement = gui.getClassTable("GenericElement")

licenseCostTextbox.skinTextFillColor = color(150, 150, 150, 255)
licenseCostTextbox.skinTextSelectColor = color(255, 255, 255, 255)
licenseCostTextbox.skinPanelFillColor = color(99, 119, 65, 255)
licenseCostTextbox.skinPanelHoverColor = color(164, 198, 109, 255)
licenseCostTextbox.skinPanelDisableColor = color(74, 89, 49, 255)
licenseCostTextbox.skinPanelSelectColor = licenseCostTextbox.skinPanelHoverColor
licenseCostTextbox.updateSprites = genericElement.updateSprites

function licenseCostTextbox:isOn()
	return self:isSelected()
end

function licenseCostTextbox:onDeselect()
	self:queueSpriteUpdate()
end

function licenseCostTextbox:updateSprites()
	genericElement.updateSprites(self)
	
	self.cashWadSprite = self:allocateSprite(self.cashWadSprite, "wad_of_cash", self.w - _S(self.rawH + 2), _S(1), 0, self.rawH - 2, self.rawH - 2, 0, 0, -0.05)
end

function licenseCostTextbox:adjustPointerPosition(pointerX, baseOff)
	return self.font:getWidth(_format("$COST", "COST", string.comma(self.curText))) + baseOff
end

function licenseCostTextbox:onWrite()
	self.startSellingButton:updateState()
end

function licenseCostTextbox:onDelete()
	self.startSellingButton:updateState()
end

function licenseCostTextbox:setStartSellingButton(button)
	self.startSellingButton = button
end

function licenseCostTextbox:onMouseEntered()
	self:queueSpriteUpdate()
end

function licenseCostTextbox:onMouseLeft()
	self:queueSpriteUpdate()
end

function licenseCostTextbox:draw()
	self:drawText()
end

gui.register("EngineLicenseCostTextbox", licenseCostTextbox, "TextBox")
