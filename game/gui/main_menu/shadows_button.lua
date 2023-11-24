local shadowsButton = {}

function shadowsButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
	self:setHoverText(buildingShadows.DESCRIPTION)
end

function shadowsButton:enableCallback()
	buildingShadows:enable()
	self.button:updateText()
	game.saveUserPreferences()
end

function shadowsButton:disableCallback()
	buildingShadows:disable()
	self.button:updateText()
	game.saveUserPreferences()
end

shadowsButton.disabledHoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("SHADOWS_DESCRIPTION_DISABLED", "No shadows will be cast.")
	}
}
shadowsButton.enabledHoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("SHADOWS_DESCRIPTION_ENABLED", "Buildings and various objects will cast shadows.")
	}
}

function shadowsButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	self:killDescBox()
	
	local option = cbox:addOption(0, 0, self.rawW, 18, _T("DISABLED", "Disabled"), fonts.get("pix20"), shadowsButton.disableCallback)
	
	option:setHoverText(shadowsButton.disabledHoverText)
	
	option.button = self
	
	local option = cbox:addOption(0, 0, self.rawW, 18, _T("ENABLED", "Enabled"), fonts.get("pix20"), shadowsButton.enableCallback)
	
	option:setHoverText(shadowsButton.enabledHoverText)
	
	option.button = self
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function shadowsButton:updateText()
	if not buildingShadows.enabled then
		self:setText(_T("DISABLED", "Disabled"))
		
		return 
	end
	
	self:setText(_T("ENABLED", "Enabled"))
end

gui.register("ShadowsButton", shadowsButton, "Button")
