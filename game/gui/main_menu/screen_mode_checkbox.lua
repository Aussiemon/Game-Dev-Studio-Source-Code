local screenModeCheckbox = {}

function resButton:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
end

function resButton:optionSelectCallback()
	resolutionHandler:setDesiredResolution(self.resolutionData.width, self.resolutionData.height)
end

function resButton:onClick(x, y, key)
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	
	for key, resData in ipairs(resolutionHandler:getResolutionList()) do
		local optionObject = cbox:addOption(0, 0, self.w, 18, resData.text, fonts.get("pix20"), resButton.optionSelectCallback)
		
		optionObject.baseButton = self
		optionObject.resolutionData = resData
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function resButton:updateText()
	self:setText(resolutionHandler:getResolutionText(scrW, scrH))
end

gui.register("ResolutionButton", resButton, "Checkbox")
