local stealEmployee = {}

stealEmployee.skinPanelFillColor = color(184, 195, 196, 255)
stealEmployee.skinPanelHoverColor = color(175, 160, 75, 255)
stealEmployee.skinPanelSelectColor = color(125, 175, 125, 255)
stealEmployee.skinTextFillColor = color(200, 200, 200, 255)
stealEmployee.skinTextHoverColor = color(240, 240, 240, 255)
stealEmployee.skinTextDisableColor = color(200, 200, 200, 255)
stealEmployee.canPropagateKeyPress = true

function stealEmployee:attemptStealCallback()
	local employee = self.element:getEmployee()
	
	employee:getEmployer():markPlayerStealEmployee(employee)
	gui:getElementByID(rivalGameCompany.UNAVAILABLE_CATEGORY_UI_ID):addItem(self.element, true)
	
	local popup = game.createPopup(600, _T("STEAL_ATTEMPT_PERFORMED_TITLE", "Job Offer Sent"), _format(_T("STEAL_ATTEMPT_PERFORMED_DETAILED", "Job offer sent to NAME. You will receive a reply in a few days."), "NAME", employee:getFullName(true)), "pix24", "pix20", nil)
	
	frameController:push(popup)
end

function stealEmployee:fillInteractionComboBox(comboBox)
	comboBox:addOption(0, 0, 200, 18, _T("MORE_INFO", "More info"), fonts.get("pix20"), stealEmployee.moreInfoCallback).employee = self.employee
	
	local employer = self.employee:getEmployer()
	
	if employer:canPlayerStealEmployee(self.employee) and not employer:hasMarkedEmployee(self.employee) then
		comboBox:addOption(0, 0, 200, 18, _T("ATTEMPT_STEAL_EMPLOYEE", "Attempt steal employee"), fonts.get("pix20"), stealEmployee.attemptStealCallback).element = self
	end
end

function stealEmployee:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
	self:killDescBox()
end

function stealEmployee:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("bh22")
	nameDisplay:setText(self.employee:getFullName(true))
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(stealEmployee.gradientColor)
	
	local levelDisplay = self.employee:createLevelDisplayElement(self.leftList, "pix24", true)
	
	levelDisplay:setBaseSize(baseElementSize, 0)
	levelDisplay:setIconSize(20, 22.400000000000002, 27.200000000000003)
	levelDisplay:setIconOffset(4, 3)
	levelDisplay:setDisplayExpBar(false)
	
	local salaryDisplay = self.employee:createSalaryDisplayElement(self.leftList, "pix24", true, true)
	
	salaryDisplay:setBaseSize(baseElementSize, 0)
	salaryDisplay:setIconSize(24, 24, 27.200000000000003)
	salaryDisplay:setIconOffset(1, 1)
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
	
	local ageDisplay = self.employee:createAgeDisplayElement(self.rightList, "pix20", true)
	
	ageDisplay:setBaseSize(baseElementSize, 0)
	ageDisplay:setIconSize(24, 24, 26)
	ageDisplay:setIconOffset(2, 1)
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

gui.register("StealEmployeeDisplay", stealEmployee, "JobSeekerDisplay")
