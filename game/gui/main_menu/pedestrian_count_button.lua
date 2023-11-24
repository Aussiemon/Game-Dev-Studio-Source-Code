local pedCount = {}

pedCount.DESCRIPTION = {
	{
		font = "pix20",
		wrapWidth = 400,
		text = _T("PEDESTRIAN_COUNT_DESCRIPTION", "Adjust the amount of pedestrians walking on the streets.")
	},
	{
		font = "pix20",
		wrapWidth = 400,
		text = _T("PEDESTRIAN_COUNT_DESCRIPTION_2", "Reducing the amount will decrease the CPU load.")
	}
}

function pedCount:init()
	self:setFont(fonts.get("pix22"))
	self:updateText()
	self:setHoverText(pedCount.DESCRIPTION)
end

function pedCount:optionSelectCallback()
	pedestrianController:setPedestrianCountIndex(self.presetID)
	self.baseButton:updateText()
	game.saveUserPreferences()
end

function pedCount:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		self:createHoverText()
		
		return 
	end
	
	local x, y = self:getPos(true)
	local cbox = gui.create("ComboBox")
	
	cbox:setPos(x, y + self.h)
	cbox:setDepth(100)
	self:killDescBox()
	
	local list = pedestrianController.COUNT_INDEXES
	
	for i = 1, #list do
		local optionObject = cbox:addOption(0, 0, self.rawW, 18, _format(_T("PEDESTRIAN_AMOUNT", "AMOUNT Pedestrians"), "AMOUNT", list[i]), fonts.get("pix20"), pedCount.optionSelectCallback)
		
		optionObject.baseButton = self
		optionObject.presetID = i
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

function pedCount:updateText()
	self:setText(pedestrianController:getPedestrianCount())
end

gui.register("PedestrianCountButton", pedCount, "Button")
