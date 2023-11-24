local generateRivals = {}

generateRivals.disabledHoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("GENERATE_RIVALS_DESCRIPTION_DISABLED", "No new rivals will be generated after at least one rival goes bankrupt.")
	}
}
generateRivals.enabledHoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("GENERATE_RIVALS_DESCRIPTION_ENABLED", "When at least one rival goes bankrupt, the game will generate new rivals after some time.")
	}
}

function generateRivals:init()
	self:updateText()
end

function generateRivals:updateText()
	if rivalGameCompanies:getCanGenerateRivals() then
		self:setText(_T("ENABLED", "Enabled"))
		self:setHoverText(self.enabledHoverText)
	else
		self:setText(_T("DISABLED", "Disabled"))
		self:setHoverText(self.disabledHoverText)
	end
end

function generateRivals:adjustStateCallback()
	rivalGameCompanies:setCanGenerateRivals(self.state)
	self.button:updateText()
end

function generateRivals:fillInteractionComboBox(combobox)
	combobox:setWidth(self.w)
	
	local option = combobox:addOption(0, 0, self.rawW, 24, _T("ENABLED", "Enabled"), fonts.get("pix20"), generateRivals.adjustStateCallback)
	
	option:setHoverText(generateRivals.enabledHoverText)
	
	option.state = true
	option.button = self
	
	local option = combobox:addOption(0, 0, self.rawW, 24, _T("DISABLED", "Disabled"), fonts.get("pix20"), generateRivals.adjustStateCallback)
	
	option:setHoverText(generateRivals.disabledHoverText)
	
	option.state = false
	option.button = self
	
	local x, y = self:getPos(true)
	
	combobox:setPos(x, y + self.h)
end

function generateRivals:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	interactionController:setInteractionObject(self)
end

gui.register("GenerateRivalsButton", generateRivals, "Button")
