local hudFundsDisplay = {}

hudFundsDisplay.scaler = "ui"
hudFundsDisplay.icon = "hud_new_expenses"
hudFundsDisplay.iconHover = "hud_new_expenses_hover"
hudFundsDisplay.CATCHABLE_EVENTS = {
	studio.EVENTS.FUNDS_CHANGED,
	studio.EVENTS.FUNDS_SET
}

function hudFundsDisplay:init()
	self.fundChange = 0
	
	self:createDescbox()
end

function hudFundsDisplay:setPos(x, y)
	hudFundsDisplay.baseClass.setPos(self, x, y)
end

function hudFundsDisplay:createDescbox()
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:tieVisibilityTo(self)
	self:showFunds()
end

function hudFundsDisplay:handleEvent(event)
	if not self:isMouseOver() then
		self:showFunds()
	end
end

function hudFundsDisplay:queueTextDisplay(change)
	if change == 0 then
		return 
	end
	
	self.fundChange = self.fundChange + change
	
	if self.fundChange ~= 0 then
		self.requiresCreation = true
	else
		self.requiresCreation = false
	end
end

function hudFundsDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	self:showInfo()
end

function hudFundsDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:showFunds()
end

function hudFundsDisplay:think()
	hudFundsDisplay.baseClass.think(self)
	
	if self.requiresCreation and self:canDraw() then
		self:createTextDisplay()
	end
end

function hudFundsDisplay:setPos(x, y)
	hudFundsDisplay.baseClass.setPos(self, x, y)
	
	if self.floatingFundDisplay then
		self:positionDescbox()
	end
end

function hudFundsDisplay:createTextDisplay()
	if not self.floatingFundDisplay or not self.floatingFundDisplay:isValid() then
		self.floatingFundDisplay = gui.create("TimedTextDisplay")
		
		self.floatingFundDisplay:addText(self:getFundChangeText(self.fundChange), self.font, self.fundChange < 0 and game.UI_COLORS.RED or game.UI_COLORS.GREEN, 0, 500)
		self.floatingFundDisplay:setDieTime(2)
		self.floatingFundDisplay:setMoveRate(3)
		self.floatingFundDisplay:setFadeInTime(0.5)
		self.floatingFundDisplay:setFadeOutTime(0.5)
		self.floatingFundDisplay:overwriteDepth(5000)
		self:updateFundDisplayPosition()
		
		self.requiresCreation = false
		self.fundChange = 0
	end
end

function hudFundsDisplay:updateFundDisplayPosition()
	if self.floatingFundDisplay and self.floatingFundDisplay:isValid() then
		local progX, progY = self.floatingFundDisplay:getProgress()
		local x, y = self:getFundDisplayPosition()
		
		if progY == 0 then
			self.floatingFundDisplay:setStartPos(x, y + _S(24))
		end
		
		self.floatingFundDisplay:setPos(x, y + _S(24) * (1 - progY))
		self.floatingFundDisplay:setFinishPos(x, y)
	end
end

function hudFundsDisplay:getFundChangeText(change)
	if change > 0 then
		return string.easyformatbykeys(_T("POSITIVE_FUND_CHANGE", "+CHANGE"), "CHANGE", string.roundtobigcashnumber(change))
	elseif change == 0 then
		return _T("NO_FUND_CHANGE", "$0")
	else
		return string.easyformatbykeys(_T("NEGATIVE_FUND_CHANGE", "-CHANGE"), "CHANGE", string.roundtobigcashnumber(math.abs(change)))
	end
end

function hudFundsDisplay:showFunds()
	self.descBox:removeAllText()
	self.descBox:addText(string.easyformatbykeys(_T("FUND_DISPLAY", "FUNDS\nMonth: CHANGE"), "FUNDS", studio:getFundsText(), "CHANGE", self:getFundChangeText(studio:getFundChange())), "bh22", nil, 0, 300)
	self:positionDescbox()
end

function hudFundsDisplay:showInfo()
	self.descBox:removeAllText()
	self.descBox:addText(_T("CURRENT_FINANCIAL_SITUATION", "Current financial situation"), "bh22", nil, 0, 300)
	self:positionDescbox()
end

function hudFundsDisplay:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h * 0.5 - self.descBox.h * 0.5)
end

gui.register("HUDFundsDisplay", hudFundsDisplay, "HUDBottomButton")

local hudExpansionContainer = {}

hudExpansionContainer._inheritScalingState = false

function hudExpansionContainer:setPropertySheet(propSheet)
	self.propSheet = propSheet
end

function hudExpansionContainer:getPropertySheet()
	return self.propSheet
end

function hudExpansionContainer:updateSprites()
	hudExpansionContainer.baseClass.updateSprites(self)
	
	self.borderSprite = self:allocateSprite(self.borderSprite, "new_hud_generic_border", self.totalSpriteW, _S(self.borderH - 4, self.scaler), 0, _US(scrW, self.scaler) - self.totalSpriteW, 4, 0, 0, -0.3)
end

gui.register("HUDExpansionContainer", hudExpansionContainer, "SocketButtonContainer")

local hudExpansionTabButton = {}

hudExpansionTabButton.scaler = "new_hud"

function hudExpansionTabButton:setIcons(icon, hover)
	self.icon = icon
	self.iconHover = hover
end

function hudExpansionTabButton:setTab(tab)
	self.tab = tab
end

function hudExpansionTabButton:setSocketContainer(ctnr)
	self.socketContainer = ctnr
end

function hudExpansionTabButton:getItemList()
	return self.socketContainer:getPropertySheet().items
end

function hudExpansionTabButton:setCategoryID(id)
	self.categoryID = id
	
	if id then
		self.categoryData = objectCategories:getCategory(self.categoryID)
		
		self:setIcons(self.categoryData.icon, self.categoryData.iconActive)
	end
end

function hudExpansionTabButton:updateSprites()
	local icon
	
	if self:isMouseOver() or self:isOn() then
		icon = self.iconHover
	else
		icon = self.icon
	end
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.iconSprite = self:allocateSprite(self.iconSprite, icon, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.3)
end

gui.register("HUDExpansionTabButton", hudExpansionTabButton, "PropertySheetTabButton")
