local moveButton = {}

function moveButton.updateElementPosition(element, newTeam)
	local baseButton = element.baseButton
	
	for key, otherPanel in ipairs(baseButton.scrollPanel:getItems()) do
		if otherPanel.teamObj and otherPanel.teamObj == newTeam then
			otherPanel:addItem(baseButton, true)
			
			break
		end
	end
end

function moveButton:moveEmployeeOption()
	self.employee:getTeam():removeMember(self.employee)
	self.team:addMember(self.employee)
	moveButton.updateElementPosition(self, self.team)
end

function moveButton:setInfoDescbox(box)
	self.infoDescbox = box
end

function moveButton:setTeams(teamOne, teamTwo)
	self.startTeam = teamOne
	self.targetTeam = teamTwo
end

function moveButton:onMouseEntered(x, y)
	moveButton.baseClass.onMouseEntered(self, x, y)
	self.infoDescbox:setEmployee(self.employee)
end

function moveButton:onMouseLeft(x, y)
	moveButton.baseClass.onMouseLeft(self, x, y)
	self.infoDescbox:removeEmployee()
end

function moveButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:setInteractionObject(self, x - 20, y - 10, true)
		self:killDescBox()
	end
end

function moveButton:fillInteractionComboBox(cbox)
	local targetTeam = self.employee:getTeam() == self.startTeam and self.targetTeam or self.startTeam
	local opt = cbox:addOption(0, 0, 0, 24, _format(_T("MOVE_EMPLOYEE_TO_TEAM", "Move to TEAM"), "TEAM", targetTeam:getName()), fonts.get("pix20"), self.moveEmployeeOption)
	
	opt.employee = self.employee
	opt.baseButton = self
	opt.team = targetTeam
end

gui.register("EmployeeMoveButton", moveButton, "EmployeeTeamAssignmentButton")
