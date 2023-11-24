local function onClicked(self)
	self.baseButton:setShillingDuration(self.shillingDurationType)
end

local shillingDuration = {}

function shillingDuration:init()
	self.shillingData = advertisement:getData("shilling")
end

function shillingDuration:setConfirmationButton(button)
	self.confirmButton = button
	
	self:setShillingDuration(1)
end

function shillingDuration:getConfirmationButton()
	return self.confirmButton
end

function shillingDuration:setShillingDuration(type)
	self.shillingDuration = type
	
	self.confirmButton:setShillingDuration(type)
	self:updateText()
end

function shillingDuration:onShow()
	self:updateText()
end

function shillingDuration:getDurationText(days)
	return timeline:getTimePeriodText(days)
end

function shillingDuration:updateText()
	if self.shillingDuration then
		self:setText(self:getDurationText(self.shillingData.durationOptions[self.shillingDuration]))
	else
		self:setText(_T("SELECT_DURATION", "Select duration"))
	end
end

function shillingDuration:onClick()
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x, y + self.h)
	comboBox:setDepth(100)
	
	for key, duration in ipairs(self.shillingData.durationOptions) do
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, self:getDurationText(duration), fonts.get("pix20"), onClicked)
		
		optionObject.shillingDurationType = key
		optionObject.baseButton = self
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

gui.register("ShillingDurationComboBoxButton", shillingDuration, "Button")
