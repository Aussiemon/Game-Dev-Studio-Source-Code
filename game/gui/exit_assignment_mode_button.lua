local exitAssignment = {}

exitAssignment.icon = "new_exit_mode"
exitAssignment.hoverIcon = "new_exit_mode_hover"
exitAssignment.hoverText = {
	{
		font = "bh24",
		text = _T("EXIT_EMPLOYEE_ASSIGNMENT", "Exit employee assignment")
	}
}

function exitAssignment:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		employeeAssignment:leave()
	end
end

function exitAssignment:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h * 0.5 - self.descBox.h * 0.5)
end

gui.register("ExitAssignmentModeButton", exitAssignment, "IconButton")

exitAssignment.regularIconColor = exitAssignment.mouseOverIconColor
