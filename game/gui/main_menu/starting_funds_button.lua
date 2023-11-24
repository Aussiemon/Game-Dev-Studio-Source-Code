local startFunds = {}

function startFunds:onSelectOptionCallback()
	self.tree.baseButton:selectStartingFunds(self.configKey)
end

function startFunds:setGametypeData(data)
	self.gametypeData = data
end

function startFunds:setMultiplierList(list)
	self.multiplierList = list
end

function startFunds:selectStartingFunds(index)
	self.gametypeData:setStartingFunds(index)
	self:updateText()
end

function startFunds:handleEvent(event)
	if self.gametypeData:getSelectedMap() then
		self:updateText()
	end
end

function startFunds:fillInteractionComboBox(comboBox)
	comboBox.baseButton = self
	
	for key, multiplier in ipairs(self.multiplierList) do
		local option = comboBox:addOption(0, 0, self.rawW, 18, _format("AMOUNT%", "AMOUNT", math.round(multiplier * 100, 1)), fonts.get("pix20"), startFunds.onSelectOptionCallback)
		
		option.configKey = key
	end
	
	local x, y = self:getPos(true)
	
	comboBox:setPos(x, y + self.h)
end

function startFunds:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, 0, 0)
	end
end

function startFunds:updateText()
	local multIndex = self.gametypeData:getStartingFunds()
	
	if multIndex then
		local mult = self.gametypeData:getFundMultipliers()[multIndex]
		
		if not self.gametypeData:getSelectedMap() then
			self:setText(_format(_T("STARTING_FUNDS_AMOUNT_SHORT", "Starting funds: PERCENTAGE%"), "PERCENTAGE", math.round(mult * 100, 1)))
		else
			self:setText(_format(_T("STARTING_FUNDS_AMOUNT", "Starting funds: PERCENTAGE% (AMOUNT)"), "PERCENTAGE", math.round(mult * 100, 1), "AMOUNT", string.roundtobigcashnumber(self.gametypeData:getStartingMoney())))
		end
	else
		self:setText(_T("SELECT_STARTING_FUNDS", "Select starting funds"))
	end
end

gui.register("StartingFundsButton", startFunds, "Button")
