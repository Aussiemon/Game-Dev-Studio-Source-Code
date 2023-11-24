local platformProduction = {}

platformProduction.spacing = 2
platformProduction.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.CHANGED_PRODUCTION
}

function platformProduction:handleEvent(event)
	self:setText(self.platform:getProduction())
	self:updateText()
end

function platformProduction:onWrite()
	self.platform:changeProduction(tonumber(self.curText) - self.platform:getProduction())
	self:setText(self.platform:getProduction())
	self:updateText()
end

function platformProduction:onDelete()
	self.platform:changeProduction(tonumber(self.curText) - self.platform:getProduction())
	self:updateText()
end

function platformProduction:setupDescBox()
	local funds = studio:getFunds()
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self:fillDescbox()
	self.descBox:centerToElement(self)
end

function platformProduction:fillDescbox()
	if self.descBox then
		self.descBox:removeAllText()
		self.descBox:addSpaceToNextText(4)
		self.descBox:addText(_format(_T("PLATFORM_PRODUCTION_VALUE", "Max. production: PRODUCTION units/week"), "PRODUCTION", string.roundtobignumber(self.platform:getProductionValue())), "bh20", nil, 5, wrapWidth, "platform_production_capacity", 21, 14)
		self.descBox:addText(_format(_T("PLATFORM_PRODUCTION_COSTS", "Production cost: COST/month"), "COST", string.roundtobigcashnumber(self.platform:getProductionCost())), "bh20", nil, 5, wrapWidth, "wad_of_cash_minus", 24, 24)
		self.descBox:addText(_format(_T("PLATFORM_WEEK_SALES", "Units sold this week: SALES"), "SALES", string.comma(self.platform:getWeekSales())), "pix18", nil, 0, wrapWidth, "platform_units_sold_16", 22, 22)
		self.descBox:addText(_format(_T("PLATFORM_MONTH_SALES", "Units sold this month: SALES"), "SALES", string.comma(self.platform:getMonthSales())), "pix18", nil, 0, wrapWidth, "platform_units_sold", 22, 22)
		
		if self.platform:isReleased() and not self.platform:isDiscontinued() then
			local sales = self.platform:calculateSales()
			local val
			
			if sales < 1000 then
				val = math.ceil(sales / 100) * 100
			elseif sales > 1000 then
				val = math.ceil(sales / 1000) * 1000
			elseif sales > 10000 then
				val = math.ceil(sales / 10000) * 10000
			end
			
			self.descBox:addText(_format(_T("PLATFORM_PROJECTED_SALES_NEXT_WEEK", "Projected sales for next week: ~SALES"), "SALES", string.comma(val)), "pix18", nil, 0, wrapWidth)
		end
	end
end

gui.register("PlatformProductionDisplay", platformProduction, "PlatformSupportDisplay")
