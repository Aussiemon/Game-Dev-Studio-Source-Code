local massAdvertSelection = {}

massAdvertSelection.skinPanelFillColor = color(86, 104, 135, 255)
massAdvertSelection.skinPanelHoverColor = color(179, 194, 219, 255)
massAdvertSelection.skinPanelSelectColor = color(125, 175, 125, 255)
massAdvertSelection.skinPanelDisableColor = color(40, 40, 40, 255)
massAdvertSelection.skinTextFillColor = color(220, 220, 220, 255)
massAdvertSelection.skinTextHoverColor = color(240, 240, 240, 255)
massAdvertSelection.skinTextSelectColor = color(255, 255, 255, 255)
massAdvertSelection.skinTextDisableColor = color(150, 150, 150, 255)
massAdvertSelection.massCampaignDataFact = nil
massAdvertSelection.CATCHABLE_EVENTS = {
	advertisement:getData("mass_advertisement").EVENTS.BUDGET_CHANGED
}

function massAdvertSelection:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:setFadeInSpeed(0)
	self.descriptionBox:overwriteDepth(5)
	self.descriptionBox:setPos(_S(2), _S(2))
	
	massAdvertSelection.font = fonts.get("bh24")
	massAdvertSelection.secondaryFont = fonts.get("pix20")
	
	self:setFont(fonts.get("bh24"))
	
	massAdvertSelection.massAdvertData = advertisement:getData("mass_advertisement")
	massAdvertSelection.massCampaignDataFact = massAdvertSelection.massAdvertData.dataFact
	self.budgetPercentage = 1
end

function massAdvertSelection:setOption(data)
	self.option = data
	self.icon = massAdvertSelection.massAdvertData.additionalAdvertOptionsByID[self.option.id].uiIcon
	
	self:updateDescbox()
end

function massAdvertSelection:updateDescbox()
	local wrapWidth = self.rawW - 100
	local lineWidth = self:applyScaler(wrapWidth)
	local lineHeight = self:applyScaler(26)
	
	self.descriptionBox:removeAllText()
	self.descriptionBox:addTextLine(lineWidth, gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.option.display, "bh24", nil, 8, wrapWidth)
	
	local icon
	local revealedAdverts = studio:getFact(massAdvertSelection.massAdvertData.revealedAdvertisementsFact)
	
	if revealedAdverts and revealedAdverts[self.option.id] then
		local advert = massAdvertSelection.massAdvertData
		
		efficiencyText = _format(_T("ADVERT_EFFICIENCY", "EFFICIENCY Popularity Points"), "EFFICIENCY", string.comma(advert:getPopularityGain(advert.additionalAdvertOptionsByID[self.option.id], self.budgetPercentage, 1)))
		icon = "efficiency_star"
	else
		efficiencyText = _T("UNKNOWN", "Unknown efficiency")
		icon = "question_mark"
	end
	
	self.descriptionBox:addTextLine(lineWidth, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(efficiencyText, "bh20", game.UI_COLORS.NEW_HUD_OUTER, 4, wrapWidth, icon, 24, 24)
	
	self.costText = _format(_T("ADVERT_COST", "$COST"), "COST", string.comma(math.floor(self.option.cost * self.budgetPercentage)))
	
	self.descriptionBox:addTextLine(lineWidth, game.UI_COLORS.LIGHT_GREEN, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.costText, "bh20", game.UI_COLORS.LIGHT_GREEN, 0, wrapWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			width = 18,
			height = 18,
			y = 1,
			icon = "wad_of_cash",
			x = 3
		}
	})
end

function massAdvertSelection:handleEvent(event, budgetPercentage)
	self.budgetPercentage = budgetPercentage
	
	self:updateDescbox()
end

function massAdvertSelection:setConfirmationButton(button)
	self.confirmButton = button
end

function massAdvertSelection:onKill()
	self:killDescBox()
end

function massAdvertSelection:isOn()
	return self.confirmButton:isAdvertTypeOn(self.option.id)
end

function massAdvertSelection:onClick(x, y, key)
	self.confirmButton:toggleAdvertTypeState(self.option.id)
	self:queueSpriteUpdate()
end

function massAdvertSelection:updateSprites()
	local smallest = math.min(self.rawW, self.rawH)
	
	smallest = smallest - 10
	
	local baseIconX = self.w - _S(smallest + 5)
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.55)
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.frontSprite = self:allocateSprite(self.frontSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local quadName = self.icon
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(smallest - 4)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local baseX, baseY = baseIconX - _S(2), _S(5)
	local bgIconSize = smallest + 2
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, baseX, baseY, bgIconSize, bgIconSize, 4, -0.5)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_FILL:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", baseX + _S(2), baseY + _S(2), 0, bgIconSize - 4, bgIconSize - 4, 0, 0, -0.5)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, baseX + _S(bgIconSize * 0.5 - w * 0.5), baseY + _S(bgIconSize * 0.5 - h * 0.5), 0, w, h, 0, 0, 0.5)
end

function massAdvertSelection:onMouseEntered()
	massAdvertSelection.baseClass.onMouseEntered(self)
	
	if not self.descBox then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(self.option.description, "pix20", nil, 0, 500)
		self.descBox:centerToElement(self)
	end
	
	self:queueSpriteUpdate()
end

function massAdvertSelection:onMouseLeft()
	massAdvertSelection.baseClass.onMouseLeft(self)
	self:killDescBox()
	self:queueSpriteUpdate()
end

function massAdvertSelection:draw(w, h)
end

gui.register("MassAdvertSelection", massAdvertSelection, "Button")
