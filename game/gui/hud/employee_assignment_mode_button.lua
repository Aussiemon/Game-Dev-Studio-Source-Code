local assignmentModeButton = {}

assignmentModeButton.icon = "generic_backdrop_40"

function assignmentModeButton:onClick()
	employeeAssignment:setAssignmentMode(self.mode)
end

function assignmentModeButton:handleEvent(event, newMode)
	if event == employeeAssignment.EVENTS.ASSIGNMENT_MODE_CHANGED then
		self.active = newMode == self.mode
		
		self:queueSpriteUpdate()
	end
end

function assignmentModeButton:getIcon()
	if self:isOn() then
		return self.hoverIcon
	end
	
	return assignmentModeButton.baseClass.getIcon(self)
end

function assignmentModeButton:setAssignmentMode(mode)
	self.mode = mode
	self.active = employeeAssignment:getAssignmentMode() == self.mode
end

function assignmentModeButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h * 0.5 - self.descBox.h * 0.5)
end

function assignmentModeButton:setOverIcon(icon)
	self.overIcon = icon
end

function assignmentModeButton:isOn()
	return self.active
end

gui.register("EmployeeAssignmentModeButton", assignmentModeButton, "IconButton")

assignmentModeButton.regularIconColor = assignmentModeButton.mouseOverIconColor
