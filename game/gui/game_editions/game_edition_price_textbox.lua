local editPrice = {}

editPrice.maxSize = 25
editPrice.skinPanelFillColor = color(99, 119, 65, 255)
editPrice.skinPanelHoverColor = color(164, 198, 109, 255)
editPrice.skinPanelDisableColor = color(74, 89, 49, 255)
editPrice.skinPanelSelectColor = editPrice.skinPanelHoverColor
editPrice.numbersOnly = true
editPrice.negativeNumbers = false
editPrice.extraTag = 0.99
editPrice.CATCHABLE_EVENTS = {
	gameEditions.EVENTS.SETUP_ELEMENT_SELECTED
}

function editPrice:handleEvent(event, obj)
	self:setEdition(obj)
end

local genericElement = gui.getClassTable("GenericElement")

editPrice.updateSprites = genericElement.updateSprites

function editPrice:updateSprites()
	genericElement.updateSprites(self)
	
	self.cashWadSprite = self:allocateSprite(self.cashWadSprite, "wad_of_cash", self.w - _S(self.rawH + 2), _S(1), 0, self.rawH - 2, self.rawH - 2, 0, 0, -0.05)
end

function editPrice:adjustPointerPosition(pointerX, baseOff)
	return self.font:getWidth(_format("$COST", "COST", string.comma(self.curText))) + baseOff
end

function editPrice:getDisplayText()
	return _format("$COST", "COST", tonumber(self.curText))
end

function editPrice:getGreyDisplayText()
	return _format("$COST", "COST", tonumber(self.curText) + self.extraTag)
end

function editPrice:setEdition(edit)
	self.edition = edit
	
	self:setMinValue(0)
	self:setText(self.edition:getPrice())
	self:deselect()
	
	if self.edition:getDeletable() then
		self:setCanClick(true)
	else
		self:setCanClick(false)
	end
end

function editPrice:onWrite()
	self.edition:setPrice(tonumber(self.curText) + self.extraTag)
end

function editPrice:onDelete()
	self.edition:setPrice(tonumber(self.curText) + self.extraTag)
end

function editPrice:onSelected()
	self:setText(math.floor(tonumber(self.curText)))
end

function editPrice:onDeselect()
	self:setText(tonumber(self.curText) + self.extraTag)
end

function editPrice:_drawText(text, textX, textY, textColor)
	if not self.edition then
		return 
	end
	
	love.graphics.setFont(self.font)
	
	if self:isSelected() then
		love.graphics.setColor(game.UI_COLORS.GREY:unpack())
		love.graphics.print(self:getGreyDisplayText(), textX, textY)
	end
	
	love.graphics.printST(text, textX, textY, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

function editPrice:draw()
	self:drawText()
end

gui.register("GameEditionPriceTextbox", editPrice, "TextBox")
