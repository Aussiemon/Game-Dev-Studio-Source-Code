local unassignEmployeesButton = {}

unassignEmployeesButton.icon = "new_mass_unassignment"
unassignEmployeesButton.hoverIcon = "new_mass_unassignment_hover"
unassignEmployeesButton.hoverText = {
	{
		font = "bh24",
		icon = "question_mark",
		iconHeight = 24,
		lineSpace = 3,
		iconWidth = 24,
		text = _T("MASS_UNASSIGNMENT", "Mass unassignment")
	},
	{
		font = "pix20",
		text = _T("MASS_UNASSIGNMENT_DESCRIPTION", "Click to view options")
	}
}

function unassignEmployeesButton:unassignEveryoneCallback()
	employeeAssignment:unassignEveryone()
end

function unassignEmployeesButton:unassignTeamCallback()
	employeeAssignment:createTeamUnassignmentPopup()
end

function unassignEmployeesButton:unassignOfficeCallback()
	employeeAssignment:createOfficeUnassignmentPopup()
end

function unassignEmployeesButton:handleEvent(event, employeeList, assignedAmount)
	if event == employeeAssignment.EVENTS.AUTO_ASSIGNED then
	end
end

function unassignEmployeesButton:fillInteractionComboBox(comboBox)
	comboBox:addOption(0, 0, 0, 24, _T("UNASSIGN_EVERYONE", "Unassign everyone"), fonts.get("pix20"), unassignEmployeesButton.unassignEveryoneCallback)
	comboBox:addOption(0, 0, 0, 24, _T("UNASSIGN_TEAM", "Unassign team..."), fonts.get("pix20"), unassignEmployeesButton.unassignTeamCallback)
	comboBox:addOption(0, 0, 0, 24, _T("UNASSIGN_OFFICE", "Unassign office..."), fonts.get("pix20"), unassignEmployeesButton.unassignOfficeCallback)
end

function unassignEmployeesButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - _S(20), y - _S(10), true)
end

function unassignEmployeesButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h * 0.5 - self.descBox.h * 0.5)
end

function unassignEmployeesButton:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function unassignEmployeesButton:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

gui.register("UnassignEmployeesButton", unassignEmployeesButton, "IconButton")

unassignEmployeesButton.regularIconColor = unassignEmployeesButton.mouseOverIconColor
