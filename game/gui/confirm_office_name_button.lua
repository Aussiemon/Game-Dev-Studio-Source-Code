local ConfirmOfficeNameButton = {}

function ConfirmOfficeNameButton:isDisabled()
	return string.withoutspaces(self.textBox:getText()) == ""
end

function ConfirmOfficeNameButton:setTextBox(textbox)
	self.textBox = textbox
end

function ConfirmOfficeNameButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and not self:isDisabled() then
		studio:createNameConfirmationPopup(self.textBox:getText())
	end
end

gui.register("ConfirmOfficeNameButton", ConfirmOfficeNameButton, "Button")
