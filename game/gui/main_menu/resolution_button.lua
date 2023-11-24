local resButton = {}

function resButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
end

function resButton:optionSelectCallback()
	if resolutionHandler:setDesiredResolution(self.resolutionData.width, self.resolutionData.height) then
		resolutionHandler:applyScreenMode()
		frameController:pop()
		mainMenu:createOptionsMenu()
	end
end

function resButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	
	for key, resData in ipairs(resolutionHandler:getResolutionList()) do
		local optionObject = cbox:addOption(0, 0, self.rawW, 18, resData.text, fonts.get("pix20"), resButton.optionSelectCallback)
		
		optionObject.baseButton = self
		optionObject.resolutionData = resData
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function resButton:updateText()
	self:setText(resolutionHandler:getResolutionText(scrW, scrH))
end

gui.register("ResolutionButton", resButton, "Button")
