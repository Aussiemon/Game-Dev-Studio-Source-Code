local editDisp = {}

editDisp.CATCHABLE_EVENTS = {
	gameProject.EVENTS.EDITION_REMOVED,
	gameEditions.EVENTS.PART_ADDED,
	gameEditions.EVENTS.PART_REMOVED,
	gameEditions.EVENTS.SETUP_ELEMENT_SELECTED,
	gameEditions.EVENTS.NAME_SET,
	gameEditions.EVENTS.PRICE_CHANGED
}
editDisp.UPDATE_TEXT_EVENTS = {
	[gameEditions.EVENTS.PART_ADDED] = true,
	[gameEditions.EVENTS.PART_REMOVED] = true,
	[gameEditions.EVENTS.PRICE_CHANGED] = true
}

function editDisp:init()
	self.infoBox = gui.create("GenericDescbox", self)
	
	self.infoBox:setShowRectSprites(false)
	self.infoBox:setBackgroundColor(self.bgColor)
	self.infoBox:setFadeInSpeed(0)
	self.infoBox:setPos(_S(3), _S(3))
	self.infoBox:overwriteDepth(10)
end

function editDisp:isOn()
	return self.edition == self.scroller:getSetupScroller():getEdition()
end

function editDisp:handleEvent(event, edition)
	if event == gameProject.EVENTS.EDITION_REMOVED then
		if edition == self.edition then
			self.scrollPanel:removeEditionElement(self)
		end
	elseif self.UPDATE_TEXT_EVENTS[event] then
		local newIcon = self.edition:getIcon()
		local wrapW = self:getWrapSize()
		
		if self.icon ~= newIcon then
			self.icon = newIcon
			
			self:updateName(wrapW)
		end
		
		self:updateInfo(wrapW)
	elseif event == gameEditions.EVENTS.NAME_SET then
		local wrapW = self:getWrapSize()
		
		self:updateName(wrapW)
		self:updateInfo(wrapW)
	elseif event == gameEditions.EVENTS.SETUP_ELEMENT_SELECTED and self.edition ~= self then
		self:queueSpriteUpdate()
	end
end

function editDisp:initButtons()
	if self.edition:getDeletable() then
		self.removeButton = gui.create("RemoveGameEditionButton", self)
		
		self.removeButton:setSize(24, 24)
		self.removeButton:setEdition(self.edition)
	end
end

function editDisp:getWrapSize()
	return self.rawW - 10
end

function editDisp:setScroller(scroll)
	self.scroller = scroll
end

function editDisp:setEdition(edit)
	edit:updateIcon()
	
	self.edition = edit
	self.icon = edit:getIcon()
	self.project = edit:getProject()
	
	self:initButtons()
	
	local wrapW = self:getWrapSize()
	
	self:updateName(wrapW)
	self:updateInfo(wrapW)
end

function editDisp:updateName(wrapW)
	self.infoBox:removeAllText()
	self.infoBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	self.infoBox:addText(self.edition:getName(), "bh24", nil, 0, wrapW, self.icon, 32)
end

function editDisp:updateInfo(wrapW)
	local price, produceCost = self.edition:getPrice(), self.edition:getProduceCost()
	local netSprite, textColor
	local net = price - produceCost
	
	if net < 0 then
		netSprite = "decrease_red"
		textColor = game.UI_COLORS.RED
		
		self.infoBox:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
	elseif net > 0 then
		netSprite = "increase"
		textColor = game.UI_COLORS.LIGHT_BLUE
		
		self.infoBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	else
		netSprite = "tilde_yellow"
		textColor = game.UI_COLORS.IMPORTANT_3
		
		self.infoBox:addTextLine(-1, game.UI_COLORS.IMPORTANT_3, nil, "weak_gradient_horizontal")
	end
	
	self.infoBox:updateTextTable(_format(_T("GAME_EDITION_NET_CHANGE_PER_COPY", "Net change per copy: CHANGE"), "CHANGE", string.roundtobigcashnumber(net, 2)), "bh20", 2, textColor, 4, wrapW, netSprite, 22, 22)
	self.infoBox:addTextLine(-1, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	self.infoBox:updateTextTable(_format(_T("GAME_EDITION_PRICE", "Price: $PRICE"), "PRICE", math.round(price, 2)), "bh18", 3, nil, 0, wrapW, "wad_of_cash_plus", 22, 22)
	self.infoBox:addTextLine(-1, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	self.infoBox:updateTextTable(_format(_T("GAME_EDITION_MANUFACTURING_COST", "Manufacturing cost: $COST"), "COST", math.round(produceCost, 2)), "bh18", 4, nil, 0, wrapW, "wad_of_cash_minus", 22, 22)
	self.infoBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	self.infoBox:updateTextTable(_format(_T("GAME_EDITION_VALUE_POINTS", "Value: VALUE pts."), "VALUE", math.round(self.edition:getValue(), 1)), "bh18", 5, nil, 4, wrapW, "content", 22, 22)
	
	local rawH = self.rawH
	local newH = math.round(_US(self.infoBox.rawH) + 6)
	
	if rawH ~= newH then
		self:setHeight(newH)
	end
end

function editDisp:getUnderColor()
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

function editDisp:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:selectForAdjustment()
	end
end

function editDisp:selectForAdjustment()
	self.scroller:getSetupScroller():setEdition(self.edition)
	self:queueSpriteUpdate()
end

function editDisp:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.1)
	
	self:setNextSpriteColor(self:getUnderColor():unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.09)
	
	self:setNextSpriteColor(self.genericFillColor:unpack())
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(3), _S(3), self.rawW - 6, self.rawH - 6, 2, -0.08)
end

function editDisp:onSizeChanged()
	if self.removeButton then
		self.removeButton:setPos(self.w - self.removeButton.w - _S(6), self.h - self.removeButton.h - _S(6))
	end
end

gui.register("GameEditionDisplay", editDisp, "GenericElement")
