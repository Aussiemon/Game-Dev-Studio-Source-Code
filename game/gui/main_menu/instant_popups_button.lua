local instantPopups = {}

function instantPopups:init()
	self:updateText()
end

function instantPopups:updateText()
	if game.instantPopups then
		self:setText(_T("ENABLED", "Enabled"))
	else
		self:setText(_T("DISABLED", "Disabled"))
	end
end

function instantPopups:enableInstantPopups()
	game.instantPopups = true
	
	self.button:updateText()
	game.saveUserPreferences()
end

function instantPopups:disableInstantPopups()
	game.instantPopups = false
	
	self.button:updateText()
	game.saveUserPreferences()
end

function instantPopups:fillInteractionComboBox(combobox)
	combobox:setWidth(self.w)
	
	local option = combobox:addOption(0, 0, self.rawW, 24, _T("ENABLED", "Enabled"), fonts.get("pix20"), instantPopups.enableInstantPopups)
	
	option.button = self
	
	local option = combobox:addOption(0, 0, self.rawW, 24, _T("DISABLED", "Disabled"), fonts.get("pix20"), instantPopups.disableInstantPopups)
	
	option.button = self
	
	local x, y = self:getPos(true)
	
	combobox:setPos(x, y + self.h)
end

function instantPopups:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	interactionController:setInteractionObject(self)
end

gui.register("InstantPopupsButton", instantPopups, "Button")
