local dispSel = {}

function dispSel:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
end

function dispSel:optionSelectCallback()
	if resolutionHandler:setDisplay(self.displayNumber) then
		resolutionHandler:applyScreenMode()
		frameController:pop()
		mainMenu:createOptionsMenu()
	end
end

function dispSel:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	
	for i = 1, love.window.getDisplayCount() do
		local optionObject = cbox:addOption(0, 0, self.rawW, 18, resolutionHandler:getDisplayText(i), fonts.get("pix20"), dispSel.optionSelectCallback)
		
		optionObject.baseButton = self
		optionObject.displayNumber = i
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function dispSel:updateText()
	self:setText(resolutionHandler:getDisplayText(resolutionHandler:getDisplay()))
end

gui.register("DisplaySelectionButton", dispSel, "Button")
