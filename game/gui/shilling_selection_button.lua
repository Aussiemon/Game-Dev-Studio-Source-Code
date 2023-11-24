local shillingSelection = {}

shillingSelection.skinPanelDisableColor = color(40, 40, 40, 255)
shillingSelection.skinTextFillColor = color(220, 220, 220, 255)
shillingSelection.skinTextHoverColor = color(240, 240, 240, 255)
shillingSelection.skinTextSelectColor = color(255, 255, 255, 255)
shillingSelection.skinTextDisableColor = color(150, 150, 150, 255)
shillingSelection.BUSTED_TEXT_COLOR = color(255, 180, 180, 255)
shillingSelection.bustedText = _T("BUSTED", "Busted!")

function shillingSelection:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(200)
end

function shillingSelection:setProject(proj)
	self.project = proj
end

function shillingSelection:setConfirmationButton(button)
	self.confirmButton = button
end

function shillingSelection:getProject()
	return self.project
end

function shillingSelection:setSite(site)
	self.siteData = site
	
	local bustedOn = studio:getFact(advertisement:getData("shilling").bustedFact)
	
	if bustedOn and not self.siteData:canSelect(self.siteData.id) then
		self.bustedTime = bustedOn[self.siteData.id]
	end
	
	self:updateDescbox()
end

function shillingSelection:updateDescbox()
	self.descriptionBox:removeAllText()
	self.descriptionBox:addSpaceToNextText(3)
	
	local textColor = self.bustedTime and game.UI_COLORS.LIGHT_GREY or game.UI_COLORS.WHITE
	
	self.descriptionBox:addTextLine(self.w, gui.genericMainGradientColor, _S(24), "weak_gradient_horizontal")
	
	local wrapWidth = self.rawW
	
	self.descriptionBox:addText(self.siteData.display, "pix24", textColor, 7, wrapWidth)
	
	local textLineHeight = _S(26)
	
	self.descriptionBox:addTextLine(self.w, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("SHILLING_BASE_COST", "Base cost $COST"), "COST", string.comma(self.siteData:getCost())), "bh20", textColor, 3, wrapWidth, "wad_of_cash", 24, 24)
	self.descriptionBox:addTextLine(self.w, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("SHILLING_MONTHLY_VISITORS", "VISITORS monthly visitors"), "VISITORS", string.roundtobignumber(math.floor(self.siteData:getMarketSharePercentage() * platformShare:getTotalUsers()))), "bh20", textColor, 0, wrapWidth, "employees", 24, 24)
	
	if self.bustedTime then
		self.descriptionBox:addSpaceToNextText(3)
		self.descriptionBox:addTextLine(self.w, game.UI_COLORS.RED, textLineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_T("SHILL_BUSTED", "Busted!"), "bh24", game.UI_COLORS.RED, 3, wrapWidth, "exclamation_point_red", 24, 24)
	end
	
	self:setHeight(_US(self.descriptionBox:getHeight()))
end

function shillingSelection:getSiteID()
	return self.siteData.id
end

function shillingSelection:isDisabled()
	return not self.siteData:canSelect(self.project)
end

function shillingSelection:isOn()
	return self.confirmButton:getSiteShillState(self.siteData.id)
end

function shillingSelection:onKill()
	self:killDescBox()
end

function shillingSelection:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	self.confirmButton:toggleSiteShillState(self.siteData.id)
	self:queueSpriteUpdate()
end

function shillingSelection:onMouseEntered()
	shillingSelection.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	if self.bustedTime then
		self.descBox:addSpaceToNextText(3)
		self.descBox:addText(string.easyformatbykeys(_T("CANT_SHILL_BUSTED", "Can not shill on this site as your agents were busted here TIME ago."), "TIME", timeline:getTimeText(self.bustedTime, timeline.curTime)), "bh20", shillingSelection.BUSTED_TEXT_COLOR, 0, 400, "exclamation_point_red", 24, 24)
		self.descBox:addSpaceToNextText(6)
	end
	
	for key, descData in ipairs(self.siteData.description) do
		self.descBox:addText(descData.text, descData.font, descData.color, descData.lineSpace, 400)
	end
	
	self.descBox:centerToElement(self)
end

function shillingSelection:updateSprites()
	shillingSelection.baseClass.updateSprites(self)
	
	if not self:isDisabled() then
		self.checkboxSprite = self:allocateSprite(self.checkboxSprite, self:isOn() and "checkbox_on" or "checkbox_off", self.w - _S(28), _S(5), 0, 22, 22, 0, 0, -0.4)
	end
end

function shillingSelection:onMouseLeft()
	shillingSelection.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function shillingSelection:draw(w, h)
end

gui.register("ShillingSelectionButton", shillingSelection, "Button")
