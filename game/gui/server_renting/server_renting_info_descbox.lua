local serverInfo = {}
local data = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)

serverInfo.CATCHABLE_EVENTS = {
	serverRenting.EVENTS.CHANGED_RENTED_SERVERS,
	serverRenting.EVENTS.CHANGED_CUSTOMER_SUPPORT,
	studio.EVENTS.FUNDS_CHANGED,
	data.EVENTS.FEE_CHANGED
}

function serverInfo:init()
	self:updateMMOFee()
	self:updateSubFees()
end

function serverInfo:handleEvent()
	if event == data.EVENTS.FEE_CHANGED then
		self:updateSubFees()
	else
		self:updateMMOFee()
	end
	
	self:setup()
end

function serverInfo:setBasePoint(x, y)
	self.baseX = x
	self.baseY = y
end

function serverInfo:updateSubFees()
	self.subFees = serverRenting:getActiveMMOSubFees()
end

function serverInfo:updateMMOFee()
	self.activeMMOFee = serverRenting:getActiveMMOFee()
	self.customerSupportCost = serverRenting:getCustomerSupportCost()
end

function serverInfo:setup()
	local funds = studio:getFunds()
	local wrapWidth = 300
	local sleeping = serverRenting:isSleeping()
	local clr, font
	
	if sleeping then
		font = "pix18"
		clr = game.UI_COLORS.DARK_GREY
	else
		font = "bh18"
	end
	
	self:removeAllText()
	self:addText(_format(_T("CURRENT_FUNDS", "Funds: FUNDS"), "FUNDS", string.roundtobigcashnumber(funds)), "bh20", nil, 4, wrapWidth, "wad_of_cash", 24, 24)
	self:addText(_format(_T("CUSTOMER_SUB_FEES", "Subscription fees: FEES"), "FEES", string.roundtobigcashnumber(self.subFees)), "bh18", nil, 4, wrapWidth, "wad_of_cash_plus", 22, 22)
	self:addText(_format(_T("CURRENT_SERVER_RENT", "Current rent: RENT"), "RENT", string.roundtobigcashnumber(serverRenting:getPlayerFee())), font, clr, 4, wrapWidth, "wad_of_cash_minus", 24, 24)
	self:addText(_format(_T("CUSTOMER_SUPPORT_COST", "Customer support cost: COST"), "COST", string.roundtobigcashnumber(self.customerSupportCost)), font, clr, 4, wrapWidth)
	self:addText(_format(_T("SERVER_RUNNING_COSTS", "Server running costs: COST"), "COST", string.roundtobigcashnumber(self.activeMMOFee)), "bh18", nil, 4, wrapWidth)
	
	local textColor, icon
	local netChange = self.subFees - self.activeMMOFee - self.customerSupportCost - serverRenting:getPlayerFee()
	
	if netChange ~= 0 then
		if netChange > 0 then
			icon = "increase"
			textColor = game.UI_COLORS.GREEN
		elseif netChange < 0 then
			icon = "decrease_red"
			textColor = game.UI_COLORS.RED
		end
		
		self:addText(_format(_T("MMO_NET_CHANGE", "Net change: CHANGE"), "CHANGE", string.roundtobigcashnumber(netChange)), "bh18", textColor, 0, wrapWidth, icon, 22, 22)
	end
	
	self:setPos(self.baseX - self.w, self.baseY)
end

gui.register("ServerRentingInfoDescbox", serverInfo, "GenericDescbox")
