local loanDisplay = {}

loanDisplay.CATCHABLE_EVENTS = {
	studio.EVENTS.CHANGED_LOAN
}
loanDisplay.icon = "wad_of_cash_plus"

function loanDisplay:setupDescBox()
	local funds = studio:getFunds()
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_format(_T("CURRENT_FUNDS", "Funds: FUNDS"), "FUNDS", string.roundtobigcashnumber(funds)), "bh20", nil, 4, wrapWidth, "wad_of_cash", 24, 24)
	
	local loan = studio:getLoan()
	
	self.descBox:addText(_format(_T("CURRENT_LOAN", "Current loan: LOAN"), "LOAN", string.roundtobigcashnumber(loan)), "bh20", nil, 4, wrapWidth, "wad_of_cash_plus", 24, 24)
	self.descBox:addText(_format(_T("CURRENT_LOAN_INTEREST", "Interest rate: LOAN/month"), "LOAN", string.roundtobigcashnumber(monthlyCost.getInterestForLoan(loan))), "bh20", nil, 0, wrapWidth, "wad_of_cash_minus", 24, 24)
	self.descBox:positionToMouse(_S(10), -(self.descBox.h + _S(10)))
end

function loanDisplay:handleEvent()
	self:updateText()
end

function loanDisplay:updateText()
	self.costText = string.easyformatbykeys(_T("LOAN_WITH_MAX", "Loan: LOAN/MAX"), "LOAN", string.roundtobigcashnumber(studio:getLoan()), "MAX", string.roundtobigcashnumber(monthlyCost.getMaxLoan()))
end

function loanDisplay:getTextColor()
	if studio:getLoan() > 0 then
		return game.UI_COLORS.IMPORTANT_3
	end
	
	return game.UI_COLORS.WHITE
end

gui.register("LoanDisplay", loanDisplay, "CostDisplay")
