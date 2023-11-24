local roleInteractButton = {}

function roleInteractButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
	self:killDescBox()
end

function roleInteractButton:fillInteractionComboBox(combobox)
	self.employee:addCancelTaskOption(combobox)
	attributes.profiler:fillInteractionComboBox(self.employee, combobox)
end

gui.register("EmployeeRoleInteractionButton", roleInteractButton, "EmployeeTeamAssignmentButton")
