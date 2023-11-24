local costDisplay = {}

costDisplay.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.PART_SET,
	playerPlatform.EVENTS.DEV_TIME_SET,
	playerPlatform.EVENTS.SPECIALIST_SET
}

function costDisplay:updateDevCost()
	local fee = platformParts:calculateDevCost()
	local time = platformParts:getPlatformObject():getDevTime()
	
	self.monthlyFee = fee
	
	self:setCost(fee * time)
end

function costDisplay:setupDescBox()
	local funds = studio:getFunds()
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:positionToMouse(_S(10), _S(10))
	self.descBox:addText(_format(_T("CURRENT_FUNDS", "Funds: FUNDS"), "FUNDS", string.roundtobigcashnumber(funds)), "bh20", nil, 4, wrapWidth, "wad_of_cash_plus", 24, 24)
	self.descBox:addText(_format(_T("PLATFORM_TOTAL_COST", "Total cost: COST"), "COST", string.roundtobigcashnumber(self.cost)), "bh20", nil, 0, wrapWidth, "wad_of_cash_minus", 24, 24)
	self.descBox:addText(_format(_T("CURRENT_MONTHLY_COST", "Monthly cost: COST"), "COST", string.roundtobigcashnumber(self.monthlyFee)), "bh20", nil, 0, wrapWidth)
	
	if not self:hasEnoughFunds() then
		self.descBox:addSpaceToNextText(10)
		self.descBox:addText(_T("NOT_ENOUGH_MONEY_LETS_PLAYERS", "You do not have enough money."), "bh20", game.UI_COLORS.RED, 4, wrapWidth, "wad_of_cash_minus", 22, 22)
		self.descBox:addText(_format(_T("NOT_ENOUGH_MONEY_LETS_PLAYERS_2", "You need MONEY more."), "MONEY", string.roundtobigcashnumber(self:getRealCost() - funds)), "pix18", nil, 0, wrapWidth)
	end
end

function costDisplay:handleEvent(event)
	self:updateDevCost()
end

gui.register("PlatformCreationCostDisplay", costDisplay, "CostDisplay")
