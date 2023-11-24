local snapshotButton = {}

function snapshotButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
end

function snapshotButton:enableCallback()
	saveSnapshot:enable()
	self.button:updateText()
	game.saveUserPreferences()
end

function snapshotButton:disableCallback()
	saveSnapshot:disable()
	self.button:updateText()
	game.saveUserPreferences()
end

snapshotButton.disabledHoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("SNAPSHOT_DESCRIPTION_DISABLED", "No savefile snapshots will be created upon the start of a new in-game year.")
	}
}
snapshotButton.enabledHoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("SNAPSHOT_DESCRIPTION_ENABLED", "A separate savefile will be created at the start of every new in-game year.")
	}
}

function snapshotButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	
	local option = cbox:addOption(0, 0, self.rawW, 18, _T("DISABLED", "Disabled"), fonts.get("pix20"), snapshotButton.disableCallback)
	
	option:setHoverText(snapshotButton.disabledHoverText)
	
	option.button = self
	
	local option = cbox:addOption(0, 0, self.rawW, 18, _T("ENABLED", "Enabled"), fonts.get("pix20"), snapshotButton.enableCallback)
	
	option:setHoverText(snapshotButton.enabledHoverText)
	
	option.button = self
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function snapshotButton:getSavePeriodText(timePeriod)
	return timePeriod == 1 and _T("AUTOSAVE_EVERY_MINUTE", "1 minute") or _format(_T("AUTOSAVE_EVERY_TIME", "TIME minutes"), "TIME", timePeriod)
end

function snapshotButton:updateText()
	if saveSnapshot.disabled then
		self:setText(_T("DISABLED", "Disabled"))
		
		return 
	end
	
	self:setText(_T("ENABLED", "Enabled"))
end

gui.register("SnapshotButton", snapshotButton, "Button")
