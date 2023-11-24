local vsyncButton = {}

vsyncButton.CATCHABLE_EVENTS = {
	game.EVENTS.RESOLUTION_CHANGED
}

function vsyncButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
end

function vsyncButton:handleEvent(event)
	self:updateText()
end

function vsyncButton:enableCallback()
	if resolutionHandler:setVsync(true) then
		resolutionHandler:applyScreenMode()
		mainMenu:createOptionsMenu()
	end
end

function vsyncButton:disableCallback()
	if resolutionHandler:setVsync(false) then
		resolutionHandler:applyScreenMode()
		mainMenu:createOptionsMenu()
	end
end

function vsyncButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	cbox:addOption(0, 0, self.rawW, 18, _T("ENABLED", "Enabled"), fonts.get("pix20"), vsyncButton.enableCallback)
	cbox:addOption(0, 0, self.rawW, 18, _T("DISABLED", "Disabled"), fonts.get("pix20"), vsyncButton.disableCallback)
	interactionController:setInteractionObject(self, nil, nil, true)
end

function vsyncButton:updateText()
	if resolutionHandler:getVsync() then
		return self:setText(_T("ENABLED", "Enabled"))
	end
	
	return self:setText(_T("DISABLED", "Disabled"))
end

gui.register("VsyncButton", vsyncButton, "Button")
