local officeTeamAssignment = {}

officeTeamAssignment.CATCHABLE_EVENTS = {
	employeeAssignment.EVENTS.DESELECTED_TEAM,
	employeeAssignment.EVENTS.SELECTED_TEAM,
	employeeAssignment.EVENTS.ASSIGNED_TEAM,
	employeeAssignment.EVENTS.UNASSIGNED_EVERYONE,
	employeeAssignment.EVENTS.AUTO_ASSIGNED,
	employeeAssignment.EVENTS.UNASSIGNED,
	officeBuilding.EVENTS.UNASSIGNED_OFFICE
}
officeTeamAssignment.shouldLimitToScreenspace = false
officeTeamAssignment.backgroundColor = color(0, 0, 0, 150)

function officeTeamAssignment:bringUp()
	self:setDepth(100)
end

function officeTeamAssignment:think()
	officeTeamAssignment.baseClass.think(self)
	self:updateCameraPosition()
end

function officeTeamAssignment:handleEvent(event, dataOne, dataTwo)
	if event == officeBuilding.EVENTS.UNASSIGNED_OFFICE and dataOne ~= self.office then
		return 
	elseif event == employeeAssignment.EVENTS.UNASSIGNED and dataTwo ~= self.office then
		return 
	end
	
	if event == employeeAssignment.EVENTS.ASSIGNED_TEAM or event == employeeAssignment.EVENTS.UNASSIGNED_EVERYONE or event == employeeAssignment.EVENTS.AUTO_ASSIGNED or event == officeBuilding.EVENTS.UNASSIGNED_OFFICE or event == employeeAssignment.EVENTS.UNASSIGNED then
		self:updateWorkplaceCount()
	end
	
	self:updateDescbox()
end

function officeTeamAssignment:updateCameraPosition(force)
	local x, y = camera:getLocalMousePosition(self.midX, self.midY)
	
	if x ~= self.prevCamX or y ~= self.prevCamY or force then
		self:setPos(x - self.w * 0.5, y - self.h * 0.5)
		self:queueSpriteUpdate()
	end
	
	self.prevCamX = x
	self.prevCamY = y
end

function officeTeamAssignment:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.office:createPurchaseConfirmationPopup()
	end
end

function officeTeamAssignment:officeMouseOver()
	self.mouseOnOffice = true
	
	self:hide()
end

function officeTeamAssignment:officeMouseLeft()
	self.mouseOnOffice = false
	
	self:show()
end

function officeTeamAssignment:updateWorkplaceCount()
	self.workplaces = employeeAssignment:getValidWorkplaceCount(self.office:getObjects())
end

function officeTeamAssignment:updateDescbox()
	self:removeAllText()
	self:addText(self.office:getName(), "bh22", nil, 0, 300)
	
	if self.workplaces == 0 then
		self:addSpaceToNextText(4)
		self:addText(_T("NO_WORKPLACES_AVAILABLE", "No workplaces available!"), "bh20", game.UI_COLORS.LIGHT_RED, 0, 300, "exclamation_point_red", 24, 24)
		
		return 
	elseif employeeAssignment:getAssignmentMode() == employeeAssignment.ASSIGNMENT_MODES.TEAMS then
		local target = employeeAssignment:getAssignmentTarget()
		
		if target then
			local members = #target:getMembers()
			local availableToAssign = math.min(self.workplaces, members)
			
			self:addSpaceToNextText(4)
			self:addText(_format(_T("ASSIGNABLE_EMPLOYEE_COUNT", "Assignable employees: EMPLOYEES"), "EMPLOYEES", availableToAssign), "bh20", nil, 4, 300, "employees", 24, 24)
			self:addText(_format(_T("TOTAL_TEAM_MEMBERS", "Total team members: MEMBERS"), "MEMBERS", members), "bh20", nil, 0, 300)
			
			return 
		end
	end
	
	self:addSpaceToNextText(4)
	self:addText(self.workplaces > 1 and _format(_T("FREE_WORKPLACE_COUNT", "WORKPLACES free workplaces"), "WORKPLACES", self.workplaces) or _T("ONE_FREE_WORKPLACE", "1 free workplace"), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, 300, "exclamation_point", 24, 24)
end

function officeTeamAssignment:setOffice(office)
	self.office = office
	self.midX, self.midY = self.office:getMidCoordinates()
	
	self:updateWorkplaceCount()
	self:updateDescbox()
end

gui.register("OfficeTeamAssignment", officeTeamAssignment, "GenericDescbox")
