local screenModeButton = {}

function screenModeButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
end

function screenModeButton:fullscreenCallback()
	if resolutionHandler:setScreenMode(resolutionHandler.SCREEN_MODES_COMBOS.FULLSCREEN) then
		resolutionHandler:applyScreenMode()
		mainMenu:createOptionsMenu()
	end
end

function screenModeButton:windowedCallback()
	if resolutionHandler:setScreenMode(resolutionHandler.SCREEN_MODES_COMBOS.WINDOWED) then
		resolutionHandler:applyScreenMode()
		mainMenu:createOptionsMenu()
	end
end

function screenModeButton:windowedBorderlessCallback()
	if resolutionHandler:setScreenMode(resolutionHandler.SCREEN_MODES_COMBOS.WINDOWED_BORDERLESS) then
		resolutionHandler:applyScreenMode()
		mainMenu:createOptionsMenu()
	end
end

function screenModeButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	cbox:addOption(0, 0, self.rawW, 18, self:getModeText(resolutionHandler.SCREEN_MODES_COMBOS.FULLSCREEN), fonts.get("pix20"), screenModeButton.fullscreenCallback)
	cbox:addOption(0, 0, self.rawW, 18, self:getModeText(resolutionHandler.SCREEN_MODES_COMBOS.WINDOWED), fonts.get("pix20"), screenModeButton.windowedCallback)
	cbox:addOption(0, 0, self.rawW, 18, self:getModeText(resolutionHandler.SCREEN_MODES_COMBOS.WINDOWED_BORDERLESS), fonts.get("pix20"), screenModeButton.windowedBorderlessCallback)
	interactionController:setInteractionObject(self, nil, nil, true)
end

function screenModeButton:getModeText(modeId)
	if resolutionHandler:hasMode(modeId, resolutionHandler.SCREEN_MODES_COMBOS.WINDOWED_BORDERLESS) then
		return _T("BORDERLESS", "Borderless")
	elseif resolutionHandler:hasMode(modeId, resolutionHandler.SCREEN_MODES_COMBOS.WINDOWED) then
		return _T("WINDOWED", "Windowed")
	elseif resolutionHandler:hasMode(modeId, resolutionHandler.SCREEN_MODES_COMBOS.FULLSCREEN) then
		return _T("FULLSCREEN", "Fullscreen")
	end
end

function screenModeButton:updateText()
	self:setText(self:getModeText(resolutionHandler:getScreenModeNumber()))
end

gui.register("ScreenModeButton", screenModeButton, "Button")
