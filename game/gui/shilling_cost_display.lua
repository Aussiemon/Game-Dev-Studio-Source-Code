local shillingCostDisplay = {}

shillingCostDisplay.shillData = advertisement:getData("shilling")

function shillingCostDisplay:setupDescBox()
	local total, siteCost, durationCost, heavinessCostMult = self.confirmationButton:getCosts()
	
	self.descBox = gui.create("GenericDescbox")
	
	if total > 0 then
		self.descBox:addText(_format(_T("CURRENT_FUNDS", "Funds: FUNDS"), "FUNDS", string.roundtobigcashnumber(studio:getFunds())), "bh20", nil, 4, wrapWidth, "wad_of_cash_plus", 24, 24)
		self.descBox:addText(string.easyformatbykeys(_T("TOTAL_SHILLING_COST", "Total cost: $COST"), "COST", string.comma(total)), "bh20", game.UI_COLORS.GREEN, 0, 600, "wad_of_cash", 24, 24)
		self.descBox:addText(string.easyformatbykeys(_T("SITE_COST_AFFECTOR", "Site costs: $COST"), "COST", string.comma(siteCost * heavinessCostMult)), "pix18", nil, 0, 600)
		self.descBox:addText(string.easyformatbykeys(_T("SHILLING_DURATION_COSTS", "Duration costs: $COST"), "COST", string.comma(durationCost * heavinessCostMult)), "pix18", nil, 0, 600)
		self.descBox:addText(string.easyformatbykeys(_T("SHILLING_INTENSITY_COST_AFFECTOR", "Intensity affector: xCOST"), "COST", math.round(heavinessCostMult, 2)), "pix18", nil, 0, 600)
	else
		self.descBox:addText(_T("PLEASE_SETUP_SHILLING", "Please setup the shilling campaign."), "pix18", nil, 0, 600)
	end
	
	self.descBox:centerToElement(self)
end

function shillingCostDisplay:onMouseLeft()
	shillingCostDisplay.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function shillingCostDisplay:setConfirmButton(button)
	self.confirmationButton = button
end

gui.register("ShillingCostDisplay", shillingCostDisplay, "CostDisplay")
