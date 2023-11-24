local languageSelection = {}

function languageSelection:init()
	self:updateText()
end

function languageSelection:updateText()
	local text = _T(translation.languageTranslationKey[translation.desiredLanguage])
	
	self:setText(text)
end

function languageSelection:selectLanguageCallback()
	local currentLanguage = translation.currentLanguage
	
	translation.setDesiredLanguage(self.languageID)
	
	if translation.currentLanguage ~= self.languageID then
		local popup = game.createPopup(500, _T("GAME_RESTART_REQUIRED", "Game Restart Required"), _T("RESTART_GAME_TO_CHANGE_LANGUAGE", "Please restart the game for the selected language to take effect."), "pix24", "pix20", nil)
		
		frameController:push(popup)
	end
	
	self.button:updateText()
end

function languageSelection:fillInteractionComboBox(combobox)
	combobox:setWidth(self.w)
	
	for key, languageID in ipairs(translation.languageList) do
		local option = combobox:addOption(0, 0, self.rawW, 24, _T(translation.languageTranslationKey[languageID]), fonts.get("pix20"), languageSelection.selectLanguageCallback)
		
		option.languageID = languageID
		option.button = self
	end
	
	local x, y = self:getPos(true)
	
	combobox:setPos(x, y + self.h)
end

function languageSelection:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	interactionController:setInteractionObject(self)
end

gui.register("LanguageSelectionButton", languageSelection, "Button")
