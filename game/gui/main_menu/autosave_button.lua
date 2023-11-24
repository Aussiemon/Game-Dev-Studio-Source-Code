local autosaveButton = {}

function autosaveButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
end

function autosaveButton:enableCallback()
	autosave:setSavePeriod(self.timePeriod)
	autosave:enable()
	self.button:updateText()
	game.saveUserPreferences()
end

function autosaveButton:disableCallback()
	autosave:disable()
	self.button:updateText()
	game.saveUserPreferences()
end

autosaveButton.disabledHoverText = {
	{
		font = "pix18",
		text = _T("AUTOSAVE_DESCRIPTION_DISABLED", "The game will not be auto-saved.")
	}
}

function autosaveButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	
	local option = cbox:addOption(0, 0, self.rawW, 18, _T("DISABLED", "Disabled"), fonts.get("pix20"), autosaveButton.disableCallback)
	
	option:setHoverText(autosaveButton.disabledHoverText)
	
	option.button = self
	
	for i = 1, autosave.MAX_SAVE_PERIOD do
		local option = cbox:addOption(0, 0, self.rawW, 18, self:getSavePeriodText(i), fonts.get("pix20"), autosaveButton.enableCallback)
		
		option.button = self
		option.timePeriod = i
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

autosaveButton.minuteFormatMethod = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s минут", "%s минуты", "%s минута")
	end
}

function autosaveButton:getSavePeriodText(timePeriod)
	local method = autosaveButton.minuteFormatMethod[translation.currentLanguage]
	
	if method then
		return method(timePeriod)
	end
	
	return timePeriod == 1 and _T("AUTOSAVE_EVERY_MINUTE", "1 minute") or _format(_T("AUTOSAVE_EVERY_TIME", "TIME minutes"), "TIME", timePeriod)
end

function autosaveButton:updateText()
	if autosave.enabled then
		self:setText(self:getSavePeriodText(autosave:getSavePeriod()))
		
		return 
	end
	
	self:setText(_T("DISABLED", "Disabled"))
end

gui.register("AutosaveButton", autosaveButton, "Button")
