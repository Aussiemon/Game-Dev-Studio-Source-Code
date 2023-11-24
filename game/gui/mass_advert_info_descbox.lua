local massAdvertBox = {}

function massAdvertBox:setConfirmButton(butt)
	self.button = butt
end

function massAdvertBox:updateDisplay()
	self:removeAllText()
	
	local massAdvert = advertisement:getData("mass_advertisement")
	local adTypes = self.button:getActiveAdvertTypes()
	local daysBetween = massAdvert:getAdvertDelay(adTypes)
	local rounds = self.button:getRounds()
	local wrapW = 300
	local scaledHeight = _S(24)
	
	self:addSpaceToNextText(6)
	self:addTextLine(-1, game.UI_COLORS.LIGHT_GREEN, scaledHeight, "weak_gradient_horizontal")
	self:addText(_format(_T("MASS_ADVERT_COST", "Cost: COST"), "COST", string.roundtobigcashnumber(self.button:getTotalCost())), "bh22", game.UI_COLORS.LIGHT_GREEN, 4, wrapW, "wad_of_cash_minus", 22, 22)
	self:addTextLine(-1, game.UI_COLORS.IMPORTANT_3, scaledHeight, "weak_gradient_horizontal")
	
	local popText
	
	if self.button:getRevealedAdvertTypes() == 0 then
		popText = _T("UNKNOWN_QUESTION_MARKS", "???")
	else
		popText = string.roundtobignumber(self.button:getRevealedBasePopularity())
	end
	
	self:addText(_format(_T("MASS_ADVERT_BASE_POPULARITY", "Potential Pop. gain: POPULARITY pts."), "POPULARITY", popText), "bh18", game.UI_COLORS.IMPORTANT_3, 2, wrapW, "star_yellow", 22, 22)
	self:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, scaledHeight, "weak_gradient_horizontal")
	self:addText(_format(_T("MASS_ADVERT_DURATION", "Duration: DURATION"), "DURATION", massAdvert:getDurationText(adTypes, rounds)), "bh20", game.UI_COLORS.LIGHT_BLUE, 4, wrapW, "clock_full", 22, 22)
	self:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, scaledHeight, "weak_gradient_horizontal")
	self:addText(_format(_T("MASS_ADVERT_TYPES", "Advert types: TYPES"), "TYPES", adTypes), "bh18", game.UI_COLORS.LIGHT_BLUE, 4, wrapW, "advertisement", 22, 22)
	self:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, scaledHeight, "weak_gradient_horizontal")
	self:addText(_format(_T("MASS_ADVERT_FREQUENCY", "Advert frequency: FREQUENCY"), "FREQUENCY", timeline:getTimePeriodText(daysBetween)), "bh18", game.UI_COLORS.LIGHT_BLUE, 4, wrapW, "speed_3", 22)
end

gui.register("MassAdvertInfoDescbox", massAdvertBox, "GenericDescbox")
