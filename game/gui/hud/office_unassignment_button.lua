local officeUnassignmentButton = {}

function officeUnassignmentButton:unassignCallback()
	self.officeBuilding:unassignEveryone()
	self.baseButton:updateDescbox()
end

function officeUnassignmentButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - _S(20), y - _S(10), true)
end

function officeUnassignmentButton:fillInteractionComboBox(combobox)
	local button = combobox:addOption(0, 0, 0, 24, _T("UNASSIGN_ALL_MEMBERS", "Unassign all members"), fonts.get("pix20"), officeUnassignmentButton.unassignCallback)
	
	button.officeBuilding = self.office
	button.baseButton = self
end

gui.register("OfficeUnassignmentButton", officeUnassignmentButton, "OfficeInfoButton")
