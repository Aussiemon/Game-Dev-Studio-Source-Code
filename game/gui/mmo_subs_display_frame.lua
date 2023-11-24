local mmoSubsDisplayFrame = {}

mmoSubsDisplayFrame.barDisplayClass = "MMOSubsBarDisplay"

local mmoSubsData = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)

mmoSubsDisplayFrame.CATCHABLE_EVENTS = {
	mmoSubsData.EVENTS.PROGRESSED,
	mmoSubsData.EVENTS.HAPPINESS_CHANGED,
	mmoSubsData.EVENTS.SUBSCRIBERS_CHANGED,
	mmoSubsData.EVENTS.OVER,
	gameProject.EVENTS.COPIES_SOLD,
	mmoSubsData.EVENTS.FEE_CHANGED,
	mmoSubsData.EVENTS.DDOS_STARTED,
	mmoSubsData.EVENTS.DDOS_ENDED,
	timeline.EVENTS.NEW_MONTH
}
mmoSubsDisplayFrame.SUB_UPDATE_STATE = {
	PURE = 1,
	FULL = 2
}
mmoSubsDisplayFrame.skinPanelFillFlashColor = color(124, 150, 193, 230)
mmoSubsDisplayFrame.skinPanelDDOSColor = color(229, 138, 82, 150)
mmoSubsDisplayFrame.redHappinessColorCutoff = 0.5

function mmoSubsDisplayFrame:handleEvent(event, gameProj)
	if event == mmoSubsData.EVENTS.PROGRESSED and gameProj == self.project then
		self:updateSubscriptionDisplay()
	elseif event == mmoSubsData.EVENTS.HAPPINESS_CHANGED and gameProj == self.project then
		self:updateHappinessChange()
	elseif event == mmoSubsData.EVENTS.OVER and gameProj == self.project then
		self:kill()
	elseif (event == gameProject.EVENTS.COPIES_SOLD or event == mmoSubsData.EVENTS.FEE_CHANGED) and gameProj == self.project then
		self:updateSubChange()
	elseif event == timeline.EVENTS.NEW_MONTH then
		self:updateSubChangePure()
	elseif (event == mmoSubsData.EVENTS.DDOS_STARTED or mmoSubsData.EVENTS.DDOS_ENDED) and gameProj == self.project then
		self:updateServerUse()
		self:queueSpriteUpdate()
	elseif event == mmoSubsData.EVENTS.SUBSCRIBERS_CHANGED and gameProj == self.project then
		self:updateSubChange()
	end
end

function mmoSubsDisplayFrame:onShowHUD()
	if self.expandButton then
		self.expandButton:show()
	end
end

function mmoSubsDisplayFrame:onHide()
	if self.expandButton then
		self.expandButton:hide()
	end
end

function mmoSubsDisplayFrame:onShow()
	if self.expandButton then
		self.expandButton:show()
	end
end

function mmoSubsDisplayFrame:init(skipButton)
	self.shouldFlash = not studio:getFact(mmoSubsData.FIRST_TIME_UI_FACT)
	self.flashTime = 0
	self.subUpdate = 0
	
	if not skipButton then
		self.expandButton = gui.create("ExpandMMOOptionsButton")
		
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

function mmoSubsDisplayFrame:onSizeChanged()
end

function mmoSubsDisplayFrame:fillInteractionComboBox(combobox)
	combobox:setAutoCloseTime(0.5)
	self.logicPiece:fillInteractionComboBox(combobox, self)
	
	local x, y = self:getPos(true)
	
	combobox:setPos(x - combobox.w - _S(5), y)
end

function mmoSubsDisplayFrame:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:startInteraction()
	end
end

function mmoSubsDisplayFrame:startInteraction()
	interactionController:startInteraction(self, x, y)
	
	if self.shouldFlash then
		studio:setFact(mmoSubsData.FIRST_TIME_UI_FACT, true)
		
		if self.expandButton then
			self.expandButton:setMove(false)
		end
		
		self.shouldFlash = false
		
		self:queueSpriteUpdate()
	end
end

function mmoSubsDisplayFrame:updateSubscriptionDisplay()
	local money = self.logicPiece:getMoneyMade()
	
	self.rightInfo:updateTextTable(string.roundtobignumber(self.logicPiece:getSubscribers()), "bh16", 1)
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(money), "bh16", 2, self:getSubChangeColor(money))
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.logicPiece:calculateServerCosts()), "bh16", 3)
	self:updateRightDescboxPosition()
	self.barDisplay:updateBars()
end

function mmoSubsDisplayFrame:getSubChangeColor(value)
	if value > 0 then
		return game.UI_COLORS.GREEN
	elseif value < 0 then
		return game.UI_COLORS.RED
	end
	
	return game.UI_COLORS.WHITE
end

function mmoSubsDisplayFrame:think()
	if self.shouldFlash then
		self:queueSpriteUpdate()
		
		self.flashTime = self.flashTime + frameTime * 2
		
		if self.flashTime >= math.pi then
			self.flashTime = self.flashTime - math.pi
		end
	end
	
	local states = mmoSubsDisplayFrame.SUB_UPDATE_STATE
	
	if self.subUpdate == states.FULL then
		self:_updateSubChange()
		
		self.subUpdate = 0
	elseif self.subUpdate == states.PURE then
		self:_updateSubChangePure()
		
		self.subUpdate = 0
	end
end

function mmoSubsDisplayFrame:getFillColor()
	if self.logicPiece:getDDOS() then
		return mmoSubsDisplayFrame.skinPanelDDOSColor:unpack()
	end
	
	if self.shouldFlash then
		return self.skinPanelFillFlashColor:lerpColorResult(math.sin(self.flashTime), self.skinPanelFillColor)
	end
	
	return self.skinPanelFillColor:unpack()
end

function mmoSubsDisplayFrame:getHappinessColor(hap)
	return hap <= self.redHappinessColorCutoff and game.UI_COLORS.RED or game.UI_COLORS.WHITE
end

function mmoSubsDisplayFrame:_updateDisplay()
	local subscriptions, moneyMade, subChange = self.logicPiece:getSaleData()
	local happiness = self.logicPiece:getHappiness()
	local wrapW = self.w
	
	if self.finished then
		local fees, costs = self.logicPiece:getFinanceInfo()
		
		self.rightInfo:addText(string.roundtobigcashnumber(fees), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(costs), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(moneyMade), "bh16", self:getSubChangeColor(moneyMade), 0, wrapW)
		self.rightInfo:addText("$" .. self.logicPiece:getFee(), "bh16", nil, 0, wrapW)
	elseif not self.added then
		self.rightInfo:addText(string.roundtobignumber(subscriptions), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(moneyMade), "bh16", self:getSubChangeColor(moneyMade), 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(self.logicPiece:calculateServerCosts()), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(self.logicPiece:getMonthlyFees()), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobignumber(subChange), "bh16", self:getSubChangeColor(subChange), 0, wrapW)
		self.rightInfo:addText(_format("VALUE%", "VALUE", math.round(happiness * 100)), "bh16", self:getHappinessColor(happiness), 0, wrapW)
		
		self.added = true
	else
		self.rightInfo:updateTextTable(string.roundtobignumber(subscriptions), "bh16", 1)
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(moneyMade), "bh16", 2, self:getSubChangeColor(moneyMade))
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.logicPiece:calculateServerCosts()), "bh16", 3)
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.logicPiece:getMonthlyFees()), "bh16", 4)
		self.rightInfo:updateTextTable(string.roundtobignumber(subChange), "bh16", 5, self:getSubChangeColor(subChange))
		self.rightInfo:updateTextTable(_format("VALUE%", "VALUE", math.round(happiness * 100)), "bh16", 6, self:getHappinessColor(happiness))
	end
end

function mmoSubsDisplayFrame:updateHappinessChange()
	local happiness = self.logicPiece:getHappiness()
	
	self.rightInfo:updateTextTable(_format("VALUE%", "VALUE", math.round(happiness * 100)), "bh16", 6, self:getHappinessColor(happiness))
	self:updateRightDescboxPosition()
end

function mmoSubsDisplayFrame:updateSubChange()
	self.subUpdate = math.max(self.subUpdate, mmoSubsDisplayFrame.SUB_UPDATE_STATE.FULL)
end

function mmoSubsDisplayFrame:updateSubChangePure()
	self.subUpdate = math.max(self.subUpdate, mmoSubsDisplayFrame.SUB_UPDATE_STATE.PURE)
end

function mmoSubsDisplayFrame:_updateSubChange()
	local subs = self.logicPiece:getSubscribers()
	local subChange = self.logicPiece:getSubChange()
	
	self.rightInfo:updateTextTable(string.roundtobignumber(subs), "bh16", 1)
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.logicPiece:calculateServerCosts()), "bh16", 3)
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.logicPiece:getMonthlyFees()), "bh16", 4)
	self.rightInfo:updateTextTable(string.roundtobignumber(subChange), "bh16", 5, self:getSubChangeColor(subChange))
	self:updateRightDescboxPosition()
	self.barDisplay:updateBars()
	
	self.subUpdate = 0
end

function mmoSubsDisplayFrame:updateServerUse()
	self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.logicPiece:calculateServerCosts()), "bh16", 3)
	self:updateRightDescboxPosition()
	self.barDisplay:updateBars()
end

function mmoSubsDisplayFrame:_updateSubChangePure()
	local subChange = self.logicPiece:getSubChange()
	
	self.rightInfo:updateTextTable(string.roundtobignumber(subChange), "bh16", 5, self:getSubChangeColor(subChange))
	self:updateRightDescboxPosition()
end

function mmoSubsDisplayFrame:updateHappiness()
end

function mmoSubsDisplayFrame:shouldRemoveRightText()
	return false
end

function mmoSubsDisplayFrame:setLogicPiece(logicPiece)
	self.logicPiece = logicPiece
	self.finished = self.logicPiece:isFinished()
end

function mmoSubsDisplayFrame:setData(gameProj)
	self.project = gameProj
	
	if not self.logicPiece then
		self:setLogicPiece(self.project:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID))
	end
	
	self.barDisplay:setDisplayData(self.logicPiece:getSubscriberList())
	self.barDisplay:setLogicPiece(self.logicPiece)
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_format(_T("SUBSCRIPTIONS_GAME_IN_QUOTES", "Subscriptions - 'NAME'"), "NAME", self.project:getName()), "bh18", nil, 0, self.rawW)
	self.rightInfo:setY(self.leftInfo.h - _S(4))
	
	if not self.finished then
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_CURRENT_SUBSCRIPTIONS", "Current subs."), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "mmo_subscriptions",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_MONEY_NET_CHANGE", "Net change"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "wad_of_cash",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_SERVER_COSTS", "Server costs"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "wad_of_cash_minus",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_FEES_PER_MONTH", "Fees/month"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "wad_of_cash_plus",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_SUBSCRIPTIONS_CHANGE", "Sub change"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "subscription_change",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_PLAYER_HAPPINESS", "Player happiness"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "happiness_small",
				x = 1
			}
		})
	else
		local made, costs = self.logicPiece:getFinanceInfo()
		
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_FEES", "Total fees"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "wad_of_cash_plus",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_TOTAL_SERVER_COSTS", "Total server costs"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "wad_of_cash_minus",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_MONEY_NET_CHANGE", "Net change"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "wad_of_cash",
				x = 1
			}
		})
		self:cycleLineColor(self.leftInfo, scaledWrapWidth)
		self.leftInfo:addText(_T("MMO_SUBSCRIPTION_FEE", "Subscription fee"), "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				icon = "mmo_subscriptions",
				x = 1
			}
		})
	end
	
	self.leftInfo:setY(5)
	self.barDisplay:setSize(self.rawW - 11, 40)
	self.barDisplay:setPos(_S(5), self.leftInfo.y + self.leftInfo.h + _S(3))
	self:setHeight(_US(self.barDisplay.y + self.barDisplay.h) + 5)
	self:updateDisplay()
end

gui.register("MMOSubsDisplayFrame", mmoSubsDisplayFrame, "ProjectInfoBarDisplayFrame")
