local platformLicenseCostTextbox = {}

function platformLicenseCostTextbox:getDisplayText()
	return _format(_T("PLATFORM_PRICE", "$COST (TAX% tax)"), "COST", string.comma(self.curText), "TAX", math.round((1 - playerPlatform.SELL_TAX) * 100, 1))
end

function platformLicenseCostTextbox:setupInfoBox()
	local wrapW = 400
	
	self.infoBox:addText(_T("PLATFORM_LICENSE_COST_DESC_1", "Increasing the license cost will reduce the amount of developers willing to work for you, but will increase the quality of the games made for the console."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "question_mark", 22, 22)
	self.infoBox:centerToElement(self)
end

function platformLicenseCostTextbox:setPlatform(plat)
	self.platform = plat
end

function platformLicenseCostTextbox:onWrite()
	self.platform:setDevLicenseCost(tonumber(self.curText))
end

function platformLicenseCostTextbox:onDelete()
	self.platform:setDevLicenseCost(tonumber(self.curText))
end

function platformLicenseCostTextbox:draw()
	self:drawText()
end

gui.register("PlatformLicenseCostTextbox", platformLicenseCostTextbox, "PlatformCostTextbox")
