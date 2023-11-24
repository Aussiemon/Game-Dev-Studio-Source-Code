local function onClicked(self)
	self.baseButton:setShillingType(self.shillingType)
end

local shillingType = {}

function shillingType:init()
	self.shillingData = advertisement:getData("shilling")
end

function shillingType:setConfirmationButton(button)
	self.confirmButton = button
	
	self:setShillingType(1)
end

function shillingType:getConfirmationButton()
	return self.confirmButton
end

function shillingType:setShillingType(type)
	self.shillingType = type
	
	self.confirmButton:setShillingType(type)
	self:updateText()
end

function shillingType:onShow()
	self:updateText()
end

function shillingType:updateText()
	if self.shillingType then
		self:setText(self.shillingData.types[self.shillingType].text)
	else
		self:setText(_T("SELECT_TYPE", "Select type"))
	end
end

function shillingType:onClick()
	if interactionController:attemptHide(self) then
		return 
	end
	
	local x, y = self:getPos(true)
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x, y + self.h)
	comboBox:setDepth(100)
	
	for key, data in ipairs(self.shillingData.types) do
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, data.text, fonts.get("pix20"), onClicked)
		
		optionObject.shillingType = key
		optionObject.baseButton = self
	end
	
	interactionController:setInteractionObject(self, nil, nil, true)
end

gui.register("ShillingTypeComboBoxButton", shillingType, "Button")
