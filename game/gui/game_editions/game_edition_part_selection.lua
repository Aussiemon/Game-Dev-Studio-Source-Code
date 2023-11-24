local editPart = {}

editPart.topPartHeight = 26

function editPart:getIconSize()
	return self.rawH - 4
end

function editPart:setData(data)
	self.data = data
	self.textFont = fonts.get("bh20")
	self.iconQuad = quadLoader:load(self.data.icon)
	self.textX = math.round(_S(self.rawH + 3))
	self.textY = math.round(_S(self.topPartHeight * 0.5) - self.textFont:getHeight() * 0.5)
	self.valueText = _format(_T("GAME_EDITION_PART_VALUE", "Value: VALUE pts."), "VALUE", self.data:getValue())
	self.costText = "$" .. self.data:getProduceCost()
	self.text = self:createTextObject(self.textFont, nil)
	
	self:setupText()
end

function editPart:setupText()
	if self.text then
		self.text:clear()
		
		local r, g, b, a = game.UI_COLORS.NEW_HUD_OUTER:unpack()
		
		self.text:addShadowed(self.data.display, game.UI_COLORS.WHITE, 0, 0, 1)
		
		local icSize = _S(self:getIconSize())
		local costText = self.costText
		local x = self.w - (self.textX + _S(6 + self.topPartHeight)) - self.textFont:getWidth(costText)
		
		self.text:addShadowed(costText, game.UI_COLORS.WHITE, x, _S(2), 1)
		self.text:addShadowed(self.valueText, game.UI_COLORS.NEW_HUD_OUTER, _S(self.topPartHeight), _S(self.topPartHeight), 1)
	end
end

function editPart:onSizeChanged()
	self:setupText()
end

function editPart:setEdition(edit)
	self.edition = edit
end

function editPart:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if not self.edition:hasPart(self.data.id) then
			self.edition:addPart(self.data)
		else
			self.edition:removePart(self.data)
		end
		
		self:queueSpriteUpdate()
	end
end

function editPart:onMouseEntered()
	self:queueSpriteUpdate()
	
	local dbox = gui:getElementByID(gameEditions.PART_INFO_DESCBOX_ID)
	
	dbox:enableRendering()
	self.data:fillDescbox(dbox, self.edition:getProject())
end

function editPart:onMouseLeft()
	self:queueSpriteUpdate()
	
	local dbox = gui:getElementByID(gameEditions.PART_INFO_DESCBOX_ID)
	
	dbox:removeAllText()
	dbox:disableRendering()
end

function editPart:getUnderColor()
	if self:isOn() then
		if self:isMouseOver() then
			return game.UI_COLORS.NEW_HUD_HOVER
		else
			return game.UI_COLORS.GREEN
		end
	elseif self:isMouseOver() then
		return game.UI_COLORS.NEW_HUD_HOVER
	else
		return game.UI_COLORS.NEW_HUD_FILL_3
	end
end

function editPart:isOn()
	return self.edition:hasPart(self.data.id)
end

function editPart:updateSprites()
	local topHeight = self.topPartHeight
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.1)
	
	self:setNextSpriteColor(self:getUnderColor():unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.09)
	
	local iconSize = self:getIconSize()
	
	self:setNextSpriteColor(self.genericFillColor:unpack())
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(5 + iconSize), _S(3), self.rawW - 8 - iconSize, self.rawH - 6, 2, -0.08)
	
	local w, h = self.iconQuad:getQuadDimensions(iconSize)
	
	self.iconSprite = self:allocateSprite(self.iconSprite, self.data.icon, _S(2 + iconSize * 0.5 - w * 0.5), _S(2 + iconSize * 0.5 - h * 0.5), 0, w, h, 0, 0, -0.06)
	
	local sprite
	
	sprite = self:isOn() and "checkbox_on" or "checkbox_off"
	
	local scaledIconSize = _S(iconSize)
	
	self.checkboxSprite = self:allocateSprite(self.checkboxSprite, sprite, self.w - _S(topHeight + 3), _S(4), 0, topHeight - 2, topHeight - 2, 0, 0, -0.07)
	self.valueSprite = self:allocateSprite(self.valueSprite, "content", self.textX, _S(topHeight), 0, topHeight - 2, topHeight - 2, 0, 0, -0.07)
end

function editPart:draw()
	love.graphics.draw(self.text, self.textX, self.textY)
end

gui.register("GameEditionPartSelection", editPart)
