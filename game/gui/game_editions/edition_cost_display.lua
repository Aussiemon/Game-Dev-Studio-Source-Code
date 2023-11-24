local editCostDisp = {}

editCostDisp.CATCHABLE_EVENTS = {
	gameEditions.EVENTS.PART_ADDED,
	gameEditions.EVENTS.PART_REMOVED,
	gameProject.EVENTS.EDITION_ADDED,
	gameProject.EVENTS.EDITION_REMOVED
}

function editCostDisp:setupDescBox()
	local funds = studio:getFunds()
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:positionToMouse(_S(10), _S(10))
	
	local baseUnits = string.comma(gameEditions.ADVANCE_PAYMENT)
	local clr = game.UI_COLORS.IMPORTANT_3
	
	self.descBox:addTextLine(-1, clr, nil, "weak_gradient_horizontal")
	self.descBox:addText(_format(_T("GAME_EDITION_UPFRONT_PAYMENT", "The up-front payment for manufacturing UNITS units of each edition in advance. These will be sold first before manufacturing any extra units."), "UNITS", baseUnits), "bh18", clr, 4, wrapWidth, "exclamation_point_yellow", 24, 24)
	self.descBox:addText(_format(_T("CURRENT_FUNDS", "Funds: FUNDS"), "FUNDS", string.roundtobigcashnumber(funds)), "bh20", nil, 4, wrapWidth, "wad_of_cash_plus", 24, 24)
	self.descBox:addText(_format(_T("CURRENT_COST", "Current cost: COST"), "COST", string.roundtobigcashnumber(self.cost)), "bh20", nil, 0, wrapWidth, "wad_of_cash_minus", 24, 24)
	
	if not self:hasEnoughFunds() then
		self.descBox:addSpaceToNextText(10)
		self.descBox:addText(_T("NOT_ENOUGH_MONEY_LETS_PLAYERS", "You do not have enough money."), "bh20", game.UI_COLORS.RED, 4, wrapWidth, "wad_of_cash_minus", 22, 22)
		self.descBox:addText(_format(_T("NOT_ENOUGH_MONEY_LETS_PLAYERS_2", "You need MONEY more."), "MONEY", string.roundtobigcashnumber(self:getRealCost() - funds)), "pix18", nil, 0, wrapWidth)
	end
end

function editCostDisp:handleEvent(event, object)
	if event == gameProject.EVENTS.EDITION_ADDED then
		self:setCost(object:getEditionPayment())
	else
		self:setCost(object:getProject():getEditionPayment())
	end
end

gui.register("EditionCostDisplay", editCostDisp, "CostDisplay")
