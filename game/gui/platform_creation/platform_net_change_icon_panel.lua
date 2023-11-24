local netChange = {}

netChange.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.COST_SET
}

function netChange:handleEvent(event, obj)
	if obj == self.platform then
		self:updateText()
	end
end

function netChange:setPlatform(plat)
	self.platform = plat
end

function netChange:updateText()
	local net = self.platform:getRealCost() - self.platform:getManufacturingCost()
	
	if net < 0 then
		self:setIcon("wad_of_cash_minus")
		self:setTextColor(game.UI_COLORS.RED)
		self:setGradientColor(game.UI_COLORS.RED)
	elseif net > 0 then
		self:setIcon("wad_of_cash_plus")
		self:setTextColor(game.UI_COLORS.LIGHT_GREEN)
		self:setGradientColor(game.UI_COLORS.LIGHT_GREEN)
	else
		self:setTextColor(game.UI_COLORS.GREY)
		self:setIcon("wad_of_cash")
		self:setGradientColor(nil)
	end
	
	self:setText(_format(_T("PLATFORM_NET_CHANGE", "Net change: CHANGE"), "CHANGE", string.roundtobigcashnumber(net)))
end

gui.register("PlatformNetChangeIconPanel", netChange, "GradientIconPanel")
