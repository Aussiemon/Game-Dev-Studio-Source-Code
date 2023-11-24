local sale = {}

sale.skinPanelFillColor = color(86, 104, 135, 200)
sale.skinPanelHoverColor = color(163, 176, 198, 200)
sale.barDisplayClass = "SaleDisplay"
sale.EVENTS = {
	PRE_SETUP = events:new(),
	POST_SETUP = events:new()
}

function sale:setData(proj)
	self.project = proj
	self.trendContribution = trends:getContribution(self.project)
	self.canPirate = proj:canPirate()
	
	self:fullSetup()
end

function sale:postResolutionChange()
	self:setWidth(self.rawW)
	self:fullSetup()
end

function sale:handleEvent(event, object)
	if event == gameProject.EVENTS.TREND_CONTRIBUTION_UPDATED then
		if object == self.project then
			local newContrib = self.project:getTrendContribution()
			
			if newContrib ~= self.trendContribution then
				self.requireSetup = true
			end
		end
	elseif object == self.project then
		if event == gameProject.EVENTS.GAME_OFF_MARKET or event == project.EVENTS.SCRAPPED_PROJECT then
			self:kill()
		else
			self:updateDisplay()
		end
	end
end

function sale:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, x, y)
	end
end

function sale:fillInteractionComboBox(combobox)
	self.project:fillInteractionComboBox(combobox)
	
	local x, y = self:getPos(true)
	
	combobox:setPos(x - combobox.w - _S(5), y)
	combobox:setAutoCloseTime(0.5)
end

function sale:think()
	if self.requireSetup then
		self.trendContribution = self.project:getTrendContribution()
		
		self:fullSetup()
		
		self.requireSetup = false
	end
end

function sale:fullSetup()
	self.leftInfo:removeAllText()
	self.rightInfo:removeAllText()
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_format(_T("GAME_NAME_IN_QUOTES", "'NAME'"), "NAME", self.project:getName()), "bh18", nil, 0, self.rawW)
	
	if not self.rightSet then
		self.rightInfo:setY(self.leftInfo.h - _S(2))
		
		self.rightSet = true
	end
	
	events:fire(sale.EVENTS.PRE_SETUP, self)
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(self.project:getContractor() and _T("MONEY_MADE", "Money made") or _T("MONEY_EARNED", "Money earned"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "wad_of_cash",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("PROFIT", "Profit"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "wad_of_cash_plus",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("LAST_SALES", "Last sales"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "wad_of_cash_plus",
			x = 1
		}
	})
	
	if self.canPirate then
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("GAME_PIRACY", "Piracy"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "piracy",
				x = 1
			}
		})
	end
	
	if self.project:getContractor() or self.project:getPublisher() then
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("CONTRACTOR_PAYOUT", "Royalties"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "percentage",
				x = 1
			}
		})
	end
	
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("TOTAL_SALES", "Total sales"), "bh16", nil, 0, self.rawW)
	
	if self.trendContribution > 1 then
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		
		local textEntry, textIndex = self.leftInfo:addText(_T("GAME_SALE_TREND_BOOST", "Trend boost"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "star",
				x = 1
			}
		})
		
		self.trendIndex = textIndex
	end
	
	events:fire(sale.EVENTS.POST_SETUP, self)
	self.barDisplay:setProject(self.project)
	self.barDisplay:setSize(self.rawW - 11, 40)
	self.barDisplay:setPos(_S(5), self.leftInfo.localY + self.leftInfo.h + _S(3))
	self:setHeight(_US(self.barDisplay.localY + self.barDisplay.h) + 5)
	self:updateDisplay()
end

function sale:_updateDisplay()
	local wrapWidth = self.w
	
	self.rightInfo:addText(string.roundtobigcashnumber(self.project:getMoneyMade()), "bh16", game.UI_COLORS.GREEN, 0, wrapWidth)
	
	local contractor = self.project:getContractor() or self.project:getPublisher()
	local profit
	
	if contractor then
		profit = self.project:getShareMoney() - self.project:getMoneySpent()
	else
		profit = self.project:getMoneyMade() - self.project:getMoneySpent()
	end
	
	local profitColor
	
	if profit > 0 then
		profitColor = game.UI_COLORS.GREEN
	elseif profit < 0 then
		profitColor = game.UI_COLORS.RED
	end
	
	self.rightInfo:addText(string.roundtobigcashnumber(profit), "bh16", profitColor, 0, wrapWidth)
	
	local sales, moneyMade = self.project:getLastSales()
	
	profitColor = nil
	
	if moneyMade > 0 then
		profitColor = game.UI_COLORS.GREEN
	end
	
	local roundedMoneyMade = string.roundtobigcashnumber(moneyMade)
	
	self.rightInfo:addText(_format(_T("SALES_MONEY_MADE", "SALES (MONEY)"), "SALES", string.roundtobignumber(sales), "MONEY", roundedMoneyMade), "bh16", profitColor, 0, wrapWidth)
	
	if self.canPirate then
		self.rightInfo:addText(_format(_T("PIRACY_RATES", "PIRACY (PERCENTAGE%)"), "PIRACY", string.roundtobignumber(self.project:getPiratedCopies()), "PERCENTAGE", math.round(self.project:getPiracyPercentage() * 100, 1)), "bh16", game.UI_COLORS.LIGHT_RED, 0, wrapWidth)
	end
	
	if contractor then
		local shareMoney, lastShareMoney = self.project:getShareMoney()
		local data = self.project:getContractData()
		local sharePercentage = data:getFinalShares()
		
		if sharePercentage ~= 0 then
			sharePercentage = math.round(sharePercentage * 100, 1)
		else
			sharePercentage = _T("UNKNOWN_QUESTION_MARKS", "???")
		end
		
		local royaltiesColor
		
		if shareMoney > 0 then
			royaltiesColor = game.UI_COLORS.GREEN
		end
		
		self.rightInfo:addText(_format(_T("SALES_MONEY_MADE_PERCENTAGE", "MONEY (PERCENTAGE%)"), "MONEY", string.roundtobigcashnumber(shareMoney), "PERCENTAGE", sharePercentage), "bh16", royaltiesColor, 0, wrapWidth)
	end
	
	local maxPlayers = self.project:getMaxPlatformUsers()
	local sales = self.project:getSales()
	
	self.rightInfo:addText(_format("SALES (PERCENTAGE%)", "SALES", string.roundtobignumber(sales), "PERCENTAGE", math.round(math.min(1, sales / maxPlayers) * 100, 1)), "bh16", nil, 0, wrapWidth)
	
	if self.trendContribution > 1 then
		self.rightInfo:addText(_format("PERC%", "PERC", math.round(self.trendContribution * 100 - 100, 1)), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, self.rawW)
	end
end

gui.register("SaleDisplayFrame", sale, "ProjectInfoBarDisplayFrame")
require("game/gui/sale_display")
