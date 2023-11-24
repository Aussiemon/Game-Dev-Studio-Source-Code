local platDesc = {}

platDesc.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.ADVERT_DURATION_ADJUSTED
}

function platDesc:handleEvent(event, obj, duration)
	if obj == self.platform then
		self:updateCostText(false, duration)
	end
end

function platDesc:setWrapWidth(wrap)
	self.wrapW = wrap
end

function platDesc:setPlatform(plat)
	self.platform = plat
end

function platDesc:insertBaseText()
	self:addText(_T("PLATFORM_ADJUST_ADVERT_DURATION_DESC", "Adjust the duration of the advertisement campaign.\nThe platform will accumulate interest during the campaign's duration."), "pix20", nil, 10, self.wrapW)
	self:updateCostText(true, playerPlatform.ADVERT_DEFAULT_DURATION)
end

function platDesc:getCostText(duration)
	local dur, funds = self.platform:getAdvertDurationCost(duration), studio:getFunds()
	
	return _format(_T("PLATFORM_ADVERT_COST", "Cost: COST (bank: BANK)"), "COST", string.roundtobigcashnumber(dur), "BANK", string.roundtobigcashnumber(funds)), dur, funds
end

function platDesc:updateCostText(add, weeks)
	local text, duration, funds = self:getCostText(weeks)
	local textColor
	
	if funds < duration then
		textColor = game.UI_COLORS.RED
	else
		textColor = game.UI_COLORS.GREEN
	end
	
	self:addTextLine(_S(self.wrapW), textColor, nil, "weak_gradient_horizontal")
	
	if add then
		self:addText(text, "bh20", textColor, 0, self.wrapW, "wad_of_cash", 23, 21)
	else
		self:updateTextTable(text, "bh20", 2, textColor, 0, nil)
	end
end

gui.register("PlatformAdvertDescbox", platDesc, "GenericDescbox")
