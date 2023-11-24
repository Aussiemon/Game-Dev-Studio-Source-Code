local inappsDisplayFrame = {}
local inappsData = logicPieces:getData("microtransactions_logic_piece")

inappsDisplayFrame.CATCHABLE_EVENTS = {
	inappsData.EVENTS.PROGRESSED,
	inappsData.EVENTS.OVER
}

function inappsDisplayFrame:handleEvent(event, gameProj)
	if event == inappsData.EVENTS.PROGRESSED and gameProj == self.project then
		self:updateDisplay()
	elseif event == inappsData.EVENTS.OVER and gameProj == self.project then
		self:kill()
	end
end

function inappsDisplayFrame:_updateDisplay()
	local totalPurchases, moneyMade, lastMoneyMade = self.logicPiece:getSaleData()
	local wrapW = self.w
	
	self.rightInfo:addText(string.roundtobignumber(totalPurchases), "bh16", nil, 0, wrapW)
	self.rightInfo:addText(string.roundtobigcashnumber(moneyMade), "bh16", nil, 0, wrapW)
	self.rightInfo:addText(string.roundtobigcashnumber(lastMoneyMade), "bh16", nil, 0, wrapW)
end

function inappsDisplayFrame:setLogicPiece(logicPiece)
	self.logicPiece = logicPiece
end

function inappsDisplayFrame:setData(gameProj)
	self.project = gameProj
	
	if not self.logicPiece then
		self:setLogicPiece(self.project:getLogicPiece("microtransactions_logic_piece"))
	end
	
	self.barDisplay:setDisplayData(self.logicPiece:getPurchaseList())
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_format(_T("INAPPS_GAME_IN_QUOTES", "In-apps - 'NAME'"), "NAME", self.project:getName()), "bh18", nil, 0, self.rawW)
	self.rightInfo:setY(self.leftInfo.h - _S(2))
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("INAPPS_TOTAL_PURCHASES", "Total purchases"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "wad_of_cash",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("INAPPS_MONEY_MADE", "Total money made"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "wad_of_cash",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("INAPPS_MONEY_MADE_THIS_WEEK", "Money this week"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "wad_of_cash_plus",
			x = 1
		}
	})
	self.leftInfo:setY(5)
	self.barDisplay:setSize(self.rawW - 11, 40)
	self.barDisplay:setPos(_S(5), self.leftInfo.y + self.leftInfo.h + _S(3))
	self:setHeight(_US(self.barDisplay.y + self.barDisplay.h) + 5)
	self:updateDisplay()
end

gui.register("InappsDisplayFrame", inappsDisplayFrame, "ProjectInfoBarDisplayFrame")
