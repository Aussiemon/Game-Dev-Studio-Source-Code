local employeeTeamAssignmentButton = {}

local function updateElementPosition(self, targetTeam)
	local button = self.tree.baseButton
	local employee = button:getEmployee()
	
	if not targetTeam then
		if employee:getTeam() then
			targetTeam = button:getTeam()
		else
			targetTeam = "none"
		end
	end
	
	for key, otherPanel in ipairs(button.scrollPanel:getItems()) do
		if otherPanel.teamObj and otherPanel.teamObj == targetTeam then
			otherPanel:addItem(button, true)
			
			break
		end
	end
end

local function unassignOption(self)
	local button = self.tree.baseButton
	
	studio:removeEmployeeFromTeam(button:getEmployee())
	updateElementPosition(self, button:getEmployee():getTeam())
	button:clearComboBoxOptions()
	button:addComboBoxOption("assign")
end

local function assignOption(self)
	local button = self.tree.baseButton
	local teamObj = button:getTeam()
	
	teamObj:addMember(button:getEmployee())
	updateElementPosition(self, teamObj)
	button:clearComboBoxOptions()
	button:addComboBoxOption("unassign")
end

local function desireEmployeeOption(self)
	local button = self.tree.baseButton
	local teamObj = button:getTeam()
	
	teamObj:setDesiredMember(button:getEmployee(), true)
	updateElementPosition(self, teamObj)
	button:clearComboBoxOptions()
	button:addComboBoxOption("undesire")
end

local function undesireEmployeeOption(self)
	local button = self.tree.baseButton
	
	button:getTeam():setDesiredMember(button:getEmployee(), false)
	updateElementPosition(self, button:getEmployee():getTeam())
	button:clearComboBoxOptions()
	button:addComboBoxOption("desire")
end

local function fireEmployeeOption(self)
	local button = self.tree.baseButton
	local employee = button:getEmployee()
	
	button.scrollPanel:removeItem(button, true)
	button:kill()
	game.createFireConfirmationPopup(employee, button)
end

local function assignToWorkplace(self)
	frameController:pop()
	
	local button = self.tree.baseButton
	local employee = button:getEmployee()
	
	employeeAssignment:enter(employee)
end

employeeTeamAssignmentButton.panelHorizontalSpacing = 3
employeeTeamAssignmentButton.basePanelColor = color(86, 104, 135, 255)
employeeTeamAssignmentButton.hoverPanelColor = color(179, 194, 219, 255)
employeeTeamAssignmentButton.employeeInteractionFill = true
employeeTeamAssignmentButton.EVENTS = {
	MOUSE_OVER = events:new(),
	MOUSE_LEFT = events:new()
}
employeeTeamAssignmentButton.CATCHABLE_EVENTS = {
	studio.EVENTS.EMPLOYEE_FIRED
}

function employeeTeamAssignmentButton:setEmployee(emp)
	self.employee = emp
	self.name = _format(_T("EMPLOYEE_NAME_WITH_LEVEL", "EMPLOYEE - Level LEVEL"), "EMPLOYEE", emp:getFullName(true), "LEVEL", emp:getLevel())
	self.salary = _format(_T("EMPLOYEE_SALARY", "Salary $SALARY"), "SALARY", self.employee:getSalary())
	self.role = attributes.profiler:getRoleName(emp:getRole())
	self.roleWidth = self.fontObject:getWidth(self.role)
	
	if not emp:getWorkplace() then
		self.assigned = _T("EMPLOYEE_NO_WORKPLACE", "No workplace")
		self.assignedWidth = self.fontObject:getWidth(self.assigned)
	end
	
	self:createInfoLists()
end

function employeeTeamAssignmentButton:setShortDescription(short)
	self.shortDescription = short
end

function employeeTeamAssignmentButton:getEmployee()
	return self.employee
end

function employeeTeamAssignmentButton:handleEvent(event, employee)
	if employee == self.employee then
		self:kill()
	end
end

employeeTeamAssignmentButton.gradientColor = gui.genericMainGradientColor

function employeeTeamAssignmentButton:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("bh22")
	nameDisplay:setText(self.employee:getFullName(true))
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(employeeTeamAssignmentButton.gradientColor)
	
	local levelDisplay = self.employee:createLevelDisplayElement(self.leftList, "pix24", true)
	
	levelDisplay:setBaseSize(baseElementSize, 0)
	levelDisplay:setIconSize(20, 22.400000000000002, 27.200000000000003)
	levelDisplay:setIconOffset(4, 3)
	levelDisplay:setDisplayExpBar(false)
	
	if not self.shortDescription then
		local salaryDisplay = self.employee:createSalaryDisplayElement(self.leftList, "pix24", true, true)
		
		salaryDisplay:setBaseSize(baseElementSize, 0)
		salaryDisplay:setIconSize(24, 24, 27.200000000000003)
		salaryDisplay:setIconOffset(1, 1)
	end
	
	self.leftList:updateLayout()
	
	self.rightList = gui.create("List", self)
	
	self.rightList:setPos(self.leftList.x + self.leftList.w)
	self.rightList:setPanelColor(developer.employeeMenuListColor)
	self.rightList:setCanHover(false)
	
	self.rightList.shouldDraw = false
	
	local roleDisplay = self.employee:createRoleDisplayElement(self.rightList, "pix20", true)
	
	roleDisplay:setBaseSize(baseElementSize, 0)
	roleDisplay:setIconSize(25, 25)
	roleDisplay:setBackdropSize(27)
	roleDisplay:setIconOffset(1, 1)
	
	local skillDisplay = self.employee:createMainSkillDisplayElement(self.rightList, "bh18", true)
	
	skillDisplay:setBaseSize(baseElementSize, 0)
	skillDisplay:setIconSize(24, 24, 26)
	skillDisplay:setIconOffset(1, 1)
	
	if not self.shortDescription then
		local apDisplay = self.employee:createAttributeDisplayElement(self.rightList, "pix20", true)
		
		apDisplay:setBaseSize(baseElementSize, 0)
		apDisplay:setIconSize(21, 24, 26)
	end
	
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

function employeeTeamAssignmentButton:setTeam(teamObj)
	self.team = teamObj
end

function employeeTeamAssignmentButton:getTeam()
	return self.team
end

function employeeTeamAssignmentButton:onMouseEntered()
	self:queueSpriteUpdate()
	events:fire(employeeTeamAssignmentButton.EVENTS.MOUSE_OVER, self)
end

function employeeTeamAssignmentButton:onMouseLeft()
	self:queueSpriteUpdate()
	events:fire(employeeTeamAssignmentButton.EVENTS.MOUSE_LEFT, self)
end

function employeeTeamAssignmentButton:getBasePanelColor()
	if self:isMouseOver() then
		return self.hoverPanelColor
	end
	
	return self.basePanelColor
end

function employeeTeamAssignmentButton:updateSprites()
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.basePanel = self:allocateSprite(self.basePanel, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.15)
	
	self:setNextSpriteColor(self:getBasePanelColor():unpack())
	
	self.leftPanel = self:allocateSprite(self.leftPanel, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function employeeTeamAssignmentButton:setEmployeeInteractionFill(inter)
	self.employeeInteractionFill = inter
end

function employeeTeamAssignmentButton:fillInteractionComboBox(comboBox)
	comboBox.baseButton = self
	
	comboBox:setAutoClose(true)
	comboBox:setAutoCloseTime(0.5)
	
	if self.employeeInteractionFill then
		self.employee:fillInteractionComboBox(comboBox)
	else
		comboBox.employee = self.employee
		
		self.employee:addEmployeeInfoInteraction(comboBox)
	end
	
	if self.employee:getTeam() and self:hasComboBoxOption("unassign") then
		comboBox:addOption(0, 0, 0, 24, _format(_T("UNASSIGN_EMPLOYEE", "Unassign EMPLOYEE"), "EMPLOYEE", self.employee:getFullName(true)), fonts.get("pix20"), unassignOption)
	end
	
	if self:hasComboBoxOption("assign") then
		comboBox:addOption(0, 0, 0, 24, _format(_T("ASSIGN_EMPLOYEE_TO_TEAM", "Assign EMPLOYEE to TEAM"), "EMPLOYEE", self.employee:getFullName(true), "TEAM", self.team:getName()), fonts.get("pix20"), assignOption)
	end
	
	if self:hasComboBoxOption("desire") then
		comboBox:addOption(0, 0, 0, 24, _format(_T("ASSIGN_EMPLOYEE_TO_NEW_TEAM", "Assign EMPLOYEE to new team"), "EMPLOYEE", self.employee:getFullName(true)), fonts.get("pix20"), desireEmployeeOption)
	end
	
	if self:hasComboBoxOption("undesire") then
		comboBox:addOption(0, 0, 0, 24, _format(_T("UNASSIGN_EMPLOYEE_FROM_NEW_TEAM", "Unassign EMPLOYEE from new team"), "EMPLOYEE", self.employee:getFullName(true)), fonts.get("pix20"), undesireEmployeeOption)
	end
	
	if self:hasComboBoxOption("fire") and self.employee:canFire() then
		comboBox:addOption(0, 0, 0, 24, _format(_T("FIRE_EMPLOYEE_FROM_STUDIO", "Fire EMPLOYEE"), "EMPLOYEE", self.employee:getFullName(true)), fonts.get("pix20"), fireEmployeeOption)
	end
	
	if self:hasComboBoxOption("assignworkplace") then
		comboBox:addOption(0, 0, 0, 24, _format(_T("ASSIGN_EMPLOYEE_TO_WORKPLACE", "Assign EMPLOYEE to workplace"), "EMPLOYEE", self.employee:getFullName(true)), fonts.get("pix20"), assignToWorkplace)
	end
end

function employeeTeamAssignmentButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if interactionController:attemptHide(self) then
			return 
		end
		
		if self.comboBoxOptions then
			interactionController:setInteractionObject(self, x - 20, y - 10, true)
			self:killDescBox()
		end
	end
end

function employeeTeamAssignmentButton:onKill()
	if self:isComboBoxValid() then
		self.comboBox:close()
	end
	
	self:killDescBox()
end

function employeeTeamAssignmentButton:isComboBoxValid()
	return self.comboBox and self.comboBox:isValid()
end

function employeeTeamAssignmentButton:setThoroughDescription(should)
	self.thoroughDescription = should
end

function employeeTeamAssignmentButton:draw(w, h)
end

gui.register("EmployeeTeamAssignmentButton", employeeTeamAssignmentButton, "ComboBoxOptionBuffer")
