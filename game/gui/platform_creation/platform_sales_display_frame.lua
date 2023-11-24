local platformSalesDisplayFrame = {}

platformSalesDisplayFrame.barDisplayClass = "PlatformSalesBarDisplay"
platformSalesDisplayFrame.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.PROGRESSED,
	playerPlatform.EVENTS.ADVERT_STARTED,
	playerPlatform.EVENTS.DISCONTINUED,
	timeline.EVENTS.NEW_MONTH
}
platformSalesDisplayFrame.skinPanelFillFlashColor = color(124, 150, 193, 230)
platformSalesDisplayFrame.redHappinessColorCutoff = 0.5

function platformSalesDisplayFrame:handleEvent(event, obj)
	if event == playerPlatform.EVENTS.ADVERT_STARTED then
		if obj == self.platform then
			self:updateNetChange()
		end
	elseif event == timeline.EVENTS.NEW_MONTH then
		self.saleUpdate = true
	elseif event == playerPlatform.EVENTS.DISCONTINUED and obj == self.platform then
		self:kill()
	elseif obj == self.platform then
		self.saleUpdate = true
	end
end

function platformSalesDisplayFrame:onShowHUD()
	if self.expandButton then
		self.expandButton:show()
	end
end

function platformSalesDisplayFrame:onHide()
	if self.expandButton then
		self.expandButton:hide()
	end
end

function platformSalesDisplayFrame:onShow()
	if self.expandButton then
		self.expandButton:show()
	end
end

function platformSalesDisplayFrame:init(skipButton)
	if not skipButton then
		self.flashTime = 0
		self.subUpdate = 0
		self.shouldFlash = not studio:getFact(playerPlatform.FIRST_TIME_UI_FACT)
		self.expandButton = gui.create("ExpandPlatformOptionsButton")
		
		self.expandButton:setDisplay(self)
		self.expandButton:setMove(self.shouldFlash)
		self.expandButton:setSize(16, 31)
		self.expandButton:tieVisibilityTo(self)
		self.expandButton:setDepth(1000)
		
		if game.hudHidden then
			self.expandButton:hide()
		end
	end
end

function platformSalesDisplayFrame:onSizeChanged()
end

function platformSalesDisplayFrame:fillInteractionComboBox(combobox)
	combobox:setAutoCloseTime(0.5)
	self.platform:fillInteractionComboBox(combobox, self)
	
	local x, y = self:getPos(true)
	
	combobox:setPos(x - combobox.w - _S(5), y)
end

function platformSalesDisplayFrame:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:startInteraction()
	end
end

function platformSalesDisplayFrame:startInteraction()
	interactionController:startInteraction(self, x, y)
	
	if self.shouldFlash then
		studio:setFact(playerPlatform.FIRST_TIME_UI_FACT, true)
		
		if self.expandButton then
			self.expandButton:setMove(false)
		end
		
		self.shouldFlash = false
		
		self:queueSpriteUpdate()
	end
end

function platformSalesDisplayFrame:getSubChangeColor(value)
	if value > 0 then
		return game.UI_COLORS.GREEN
	elseif value < 0 then
		return game.UI_COLORS.RED
	end
	
	return game.UI_COLORS.WHITE
end

function platformSalesDisplayFrame:think()
	if self.shouldFlash then
		self:queueSpriteUpdate()
		
		self.flashTime = self.flashTime + frameTime * 2
		
		if self.flashTime >= math.pi then
			self.flashTime = self.flashTime - math.pi
		end
	end
	
	if self.saleUpdate then
		self:updateSaleDisplay()
		self:queueSpriteUpdate()
		
		self.saleUpdate = false
	end
end

function platformSalesDisplayFrame:getFillColor()
	if self.shouldFlash then
		return self.skinPanelFillFlashColor:lerpColorResult(math.sin(self.flashTime), self.skinPanelFillColor)
	end
	
	return self.skinPanelFillColor:unpack()
end

function platformSalesDisplayFrame:getNetChangeColor(val)
	if val > 0 then
		return game.UI_COLORS.GREEN
	elseif val < 0 then
		return game.UI_COLORS.RED
	end
	
	return game.UI_COLORS.WHITE
end

function platformSalesDisplayFrame:getHappinessColor(val)
	if val < playerPlatform.REPUTATION_LOSS_HAPPINESS then
		return game.UI_COLORS.RED
	elseif val > playerPlatform.REPUTATION_GAIN_HAPPINESS then
		return game.UI_COLORS.GREEN
	end
	
	return game.UI_COLORS.WHITE
end

function platformSalesDisplayFrame:_updateDisplay()
	local made, spent = self.platform:getFundData()
	local net = made - spent
	local wrapW = self.w
	local total, thisMonth = self.platform:getGameMoney()
	
	if self.lessInfo then
		self.rightInfo:addText(string.roundtobigcashnumber(net), "bh16", self:getNetChangeColor(net), 0, wrapW)
		self.rightInfo:addText(string.roundtobignumber(self.platform:getSales()), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(total), "bh16", nil, 0, wrapW)
	elseif not self.added then
		local hap = self.platform:getHappiness()
		
		self.rightInfo:addText(_format("HAP%", "HAP", math.round(hap * 100, 1)), "bh16", self:getHappinessColor(hap), 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(net), "bh16", self:getNetChangeColor(net), 0, wrapW)
		self.rightInfo:addText(string.roundtobignumber(self.platform:getSales()), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(total), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(thisMonth), "bh16", nil, 0, wrapW)
		
		self.added = true
	else
		local hap = self.platform:getHappiness()
		
		self.rightInfo:updateTextTable(_format("HAP%", "HAP", math.round(hap * 100, 1)), "bh16", 1, self:getHappinessColor(hap))
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(net), "bh16", 2, self:getNetChangeColor(net))
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.platform:getSales()), "bh16", 3, nil)
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(total), "bh16", 4, nil)
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(thisMonth), "bh16", 5, nil)
	end
end

function platformSalesDisplayFrame:updateSaleDisplay()
	local made, spent = self.platform:getFundData()
	local net = made - spent
	local total, thisMonth = self.platform:getGameMoney()
	local hap = self.platform:getHappiness()
	
	self.rightInfo:updateTextTable(_format("HAP%", "HAP", math.round(hap * 100, 1)), "bh16", 1, self:getHappinessColor(hap))
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(net), "bh16", 2, self:getNetChangeColor(net))
	self.rightInfo:updateTextTable(string.roundtobignumber(self.platform:getSales()), "bh16", 3)
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(total), "bh16", 4, nil)
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(thisMonth), "bh16", 5, nil)
	self:updateRightDescboxPosition()
	self.barDisplay:updateBars()
end

function platformSalesDisplayFrame:updateNetChange()
	local made, spent = self.platform:getFundData()
	local net = made - spent
	
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(net), "bh16", 2, self:getNetChangeColor(net))
	self:updateRightDescboxPosition()
end

function platformSalesDisplayFrame:shouldRemoveRightText()
	return false
end

function platformSalesDisplayFrame:setupTitle()
	self.leftInfo:addText(_format(_T("PLATFORM_NAME_IN_QUOTES", "Platform - 'NAME'"), "NAME", self.platform:getName()), "bh18", nil, 0, self.rawW)
	
	local sales, expenses = self.platform:getSaleData()
	
	self.barDisplay:setDisplayData(sales)
	self.barDisplay:setExpensesData(expenses)
	self.rightInfo:setY(self.leftInfo.h - _S(4))
end

function platformSalesDisplayFrame:setData(obj)
	self.platform = obj
	self.lessInfo = self.platform:isDiscontinued()
	
	self:setupTitle()
	
	local scaledWrapWidth = self.w - _S(10)
	local fin = self.lessInfo
	local rel = self.platform:isReleased()
	
	if not fin and rel then
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("PLATFORM_HAPPINESS", "Happiness"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "happiness_small",
				x = 1
			}
		})
	end
	
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("PLATFORM_NET_CHANGE_SHORT", "Net change"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "wad_of_cash",
			x = 1
		}
	})
	
	if rel then
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("PLATFORM_UNITS_SOLD_SHORT", "Units sold"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "platform_units_sold_16",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("PLATFORM_GAME_REVENUE", "Game revenue"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "platform_game_revenue_16",
				x = 1
			}
		})
		
		if not fin then
			self:cycleLineColor(self.leftInfo, scaledWrapWidth)
			self.leftInfo:addText(_T("PLATFORM_GAME_REVENUE_THIS_MONTH", "This month"), "bh16", nil, 0, self.rawW)
		end
	end
	
	self.leftInfo:setY(5)
	self.barDisplay:setSize(self.rawW - 11, 40)
	self.barDisplay:setPos(_S(5), self.leftInfo.localY + self.leftInfo.h + _S(3))
	self:setHeight(_US(self.barDisplay.localY + self.barDisplay.h) + 5)
	self:updateDisplay()
end

function platformSalesDisplayFrame:saveData(saved)
	saved.platform = self.platform
	
	return saved
end

function platformSalesDisplayFrame:loadData(data)
	self:setData(data.platform)
end

gui.register("PlatformSalesDisplayFrame", platformSalesDisplayFrame, "ProjectInfoBarDisplayFrame")
