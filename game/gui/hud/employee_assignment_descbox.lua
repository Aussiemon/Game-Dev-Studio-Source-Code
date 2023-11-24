local expansionModeDescbox = {}

expansionModeDescbox.CATCHABLE_EVENTS = {
	employeeAssignment.EVENTS.ASSIGNED,
	employeeAssignment.EVENTS.ASSIGNMENT_MODE_CHANGED,
	employeeAssignment.EVENTS.DESELECTED,
	employeeAssignment.EVENTS.DESELECTED_TEAM,
	employeeAssignment.EVENTS.SELECTED,
	employeeAssignment.EVENTS.SELECTED_TEAM
}

function expansionModeDescbox:init()
end

function expansionModeDescbox:handleEvent(event, newState)
	self:updateText()
end

function expansionModeDescbox:setFrame(frame)
	self.baseFrame = frame
	
	self:updateText()
end

function expansionModeDescbox:setYEdgePosition(edge)
	self.yEdge = edge
end

function expansionModeDescbox:updateElementPosition()
	local scaledOffset = _S(10)
	
	self:setPos(self.baseFrame.x + self.baseFrame.w + _S(10), self.baseFrame.y + self.baseFrame.h - _S(10) - self.h)
end

function expansionModeDescbox:updateText()
	self:removeAllText()
	
	local modeText, modeIcon = self:getModeText()
	
	self:addText(modeText, "pix22", nil, 0, 500, modeIcon, 24, nil)
	self:addText(self:getKeyBindText(), "pix18", nil, 0, 500)
	self:updateElementPosition()
end

function expansionModeDescbox:getModeText()
	local assignmentMode = employeeAssignment:getAssignmentMode()
	
	if assignmentMode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES then
		return _T("EMPLOYEE_ASSIGNMENT", "Employee assignment"), "hud_employee"
	elseif assignmentMode == employeeAssignment.ASSIGNMENT_MODES.TEAMS then
		return _T("TEAM_ASSIGNMENT", "Team assignment"), "employees"
	end
end

function expansionModeDescbox:getKeyBindText()
	local assignmentMode = employeeAssignment:getAssignmentMode()
	local assignmentTarget = employeeAssignment:getAssignmentTarget()
	
	if assignmentMode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES then
		if assignmentTarget then
			return _T("ASSIGNING_EMPLOYEE_CONTROLS_WITH_EMPLOYEE", "Left mouse - assign to workplace\nRight mouse - deselect employee")
		end
		
		return _T("ASSIGNING_EMPLOYEE_CONTROLS", "Left mouse - select employee\nRight mouse - unassign employee on mouse")
	elseif assignmentMode == employeeAssignment.ASSIGNMENT_MODES.TEAMS then
		if assignmentTarget then
			return _T("ASSIGNING_TEAM_CONTROLS_ACTIVE", "Left mouse - assign to office on mouse\nRight mouse - deselect office")
		end
		
		return _T("ASSIGNING_TEAM_CONTROLS", "Left mouse - select team of employee")
	end
end

gui.register("EmployeeAssignmentDescbox", expansionModeDescbox, "GenericDescbox")
