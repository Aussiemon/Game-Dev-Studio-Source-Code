local slanderInfoDisplay = {}

slanderInfoDisplay.extraInfoColor = color(140, 180, 206, 255)
slanderInfoDisplay.saleInfoColor = color(184, 206, 171, 255)
slanderInfoDisplay.categoryColor = color(201, 206, 171, 255)
slanderInfoDisplay.HIGH_SUSPICION_CUTOFF = 50

function slanderInfoDisplay:showDisplay(slanderData, slanderer)
	self:addText(_T("SLANDER_INFO", "Basic info"), "pix24", self.categoryColor, 5, 300)
	self:addText(slanderData:getDescription(), "pix18", nil, 5, 300)
	
	if slanderData:getCost() == 0 then
		self:addText(_T("SLANDER_INFO_COST_FREE", "You do it for free"), "pix20", nil, 4, 300, "wad_of_cash", 20, 20)
	else
		self:addText(_format(_T("SLANDER_INFO_COST", "Cost: $COST"), "COST", string.comma(slanderData:getCost())), "pix20", nil, 4, 300, "wad_of_cash", 20, 20)
	end
	
	local repDrop = slanderData:getReputationPercentageDrop()
	
	self:addText(_format(_T("SLANDER_INFO_REPUTATION_LOSS", "Rival reputation loss: up to PERCENTAGE%"), "PERCENTAGE", math.round(repDrop * 100)), "pix20", game.UI_COLORS.LIGHT_BLUE, 4, 300, "star", 20, 20)
	self:addText(_format(_T("SLANDER_INFO_CURRENT_SUSPICION", "Current suspicion: SUSPICION%"), "SUSPICION", math.round(slanderer:getSlanderSuspicion())), "pix20", nil, 4, 300, "question_mark", 20, 20)
	self:addText(_format(_T("SLANDER_INFO_SUSPICION_INCREASE", "Suspicion increase: SUSPICION%"), "SUSPICION", slanderData:getSuspicionIncrease()), "pix20", game.UI_COLORS.LIGHT_RED, 4, 300, "question_mark_red", 20, 20)
	
	if slanderer:getSlanderSuspicion() > slanderInfoDisplay.HIGH_SUSPICION_CUTOFF then
		self:addText(_T("SLANDER_INFO_HIGH_SUSPICION_1", "Your suspicion is high."), "pix20", game.UI_COLORS.RED, 4, 300, "attention", 20, 20)
		self:addText(_T("SLANDER_INFO_HIGH_SUSPICION_2", "Rivals will be able to figure out it's you doing the slander, and people are much less likely to believe the slanderous articles."), "pix20", game.UI_COLORS.RED, 4, 300)
	end
	
	self:addSpaceToNextText(8)
	self:addText(_T("SLANDER_CHANCES_AND_RISKS", "Chances & risks"), "pix24", self.categoryColor, 5, 300)
	self:addText(_format(_T("SUCCESS CHANCE", "CHANCE% success chance"), "CHANCE", slanderData:getSlanderSuccessChance(slanderer)), "pix20", game.UI_COLORS.LIGHT_BLUE, 4, 300, "percentage", 20, 20)
	self:addText(_format(_T("SLANDER_CHANCE_OF_RIVAL_DISCOVERY", "CHANCE% rival discovery chance"), "CHANCE", slanderData:getTargetAffectChance(slanderer)), "pix20", game.UI_COLORS.LIGHT_RED, 4, 300, "percentage_red", 20, 20)
	self:show()
end

function slanderInfoDisplay:hideDisplay()
	self:removeAllText()
	self:hide()
end

gui.register("SlanderInfoDisplay", slanderInfoDisplay, "GenericDescbox")
