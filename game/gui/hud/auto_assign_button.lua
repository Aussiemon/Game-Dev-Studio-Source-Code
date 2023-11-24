local autoAssignButton = {}

autoAssignButton.icon = "new_auto_assign"
autoAssignButton.hoverIcon = "new_auto_assign_hover"
autoAssignButton.hoverText = {
	{
		font = "bh24",
		icon = "question_mark",
		iconHeight = 24,
		lineSpace = 3,
		iconWidth = 24,
		text = _T("AUTO_ASSIGN", "Auto-assign")
	},
	{
		font = "pix20",
		text = _T("AUTO_ASSIGN_DESCRIPTION", "Click to auto-assign all employees without a workplace to all available workplaces")
	}
}

function autoAssignButton:handleEvent(event, employeeList, assignedAmount)
	if event == employeeAssignment.EVENTS.AUTO_ASSIGNED then
	end
end

function autoAssignButton:onClick()
	employeeAssignment:assignEmployeesToFreeWorkplaces(studio:getOwnedObjects())
end

function autoAssignButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h * 0.5 - self.descBox.h * 0.5)
end

function autoAssignButton:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function autoAssignButton:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

gui.register("AutoAssignButton", autoAssignButton, "IconButton")

autoAssignButton.regularIconColor = autoAssignButton.mouseOverIconColor
