local researchEmployeeSelection = {}

researchEmployeeSelection.skinPanelFillColor = color(80, 80, 80, 255)
researchEmployeeSelection.skinPanelSelectColor = color(200, 220, 140, 255)
researchEmployeeSelection.skinPanelDisableColor = color(60, 60, 60, 255)
researchEmployeeSelection.skinTextFillColor = color(220, 220, 220, 255)
researchEmployeeSelection.skinTextHoverColor = color(245, 245, 245, 255)
researchEmployeeSelection.skinTextSelectColor = color(245, 245, 245, 255)
researchEmployeeSelection.skinTextDisableColor = color(150, 150, 150, 255)
researchEmployeeSelection.gradientColor = color(83, 152, 209, 255)
researchEmployeeSelection.selectedPanelColor = color(128, 170, 204, 255)
researchEmployeeSelection.disabledPanelColor = color(123, 132, 145, 255)
researchEmployeeSelection.EVENTS = {
	ASSIGNEE_CHANGED = events:new()
}

function researchEmployeeSelection:init()
end

function researchEmployeeSelection:setResearchTask(taskObj)
	self.researchTask = taskObj
end

function researchEmployeeSelection:setEmployee(employee)
	self.employee = employee
	
	local taskData = self.researchTask:getTaskTypeData()
	local state = taskData:canResearch(employee)
	
	if state ~= true then
		self.employeeNotSkilledEnough = state
	end
	
	self:createInfoLists()
end

function researchEmployeeSelection:getEmployee()
	return self.employee
end

function researchEmployeeSelection:isOn()
	return self.researchTask:getAssignee() == self.employee
end

function researchEmployeeSelection:isDisabled()
	return not self.employee:isAvailable() or self.employee:getTask() or self.employeeNotSkilledEnough
end

function researchEmployeeSelection:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	self.researchTask:setAssignee(self.employee, true)
	self:queueSpriteUpdate()
	events:fire(researchEmployeeSelection.EVENTS.ASSIGNEE_CHANGED)
end

function researchEmployeeSelection:kill()
	researchEmployeeSelection.baseClass.kill(self)
	self:killDescBox()
end

function researchEmployeeSelection:handleEvent(event)
	if event == researchEmployeeSelection.EVENTS.ASSIGNEE_CHANGED then
		self:queueSpriteUpdate()
	end
end

function researchEmployeeSelection:onMouseEntered()
	local isBusy = self.employee:getTask() ~= nil
	
	if self.employeeNotSkilledEnough or isBusy then
		self.descBox = gui.create("GenericDescbox")
		
		local nextSpace = 0
		
		if isBusy then
			self.descBox:addText(_T("EMPLOYEE_BUSY", "This employee is busy with another task."), "pix20", nil, 0, 600)
			
			nextSpace = 10
		end
		
		if self.employeeNotSkilledEnough then
			self.descBox:addSpaceToNextText(nextSpace)
			self.descBox:addText(self.employeeNotSkilledEnough, "pix20", nil, 0, 600)
		end
		
		self.descBox:centerToElement(self)
	end
	
	self:queueSpriteUpdate()
end

function researchEmployeeSelection:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function researchEmployeeSelection:updateSprites()
	if self:isMouseOver() then
		self:setNextSpriteColor(researchEmployeeSelection.hoverPanelColor:unpack())
	elseif self:isOn() then
		self:setNextSpriteColor(researchEmployeeSelection.selectedPanelColor:unpack())
	elseif self:isDisabled() then
		self:setNextSpriteColor(researchEmployeeSelection.disabledPanelColor:unpack())
	else
		self:setNextSpriteColor(researchEmployeeSelection.basePanelColor:unpack())
	end
	
	self.leftPanel = self:allocateSprite(self.leftPanel, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function researchEmployeeSelection:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("pix24")
	nameDisplay:setText(self.employee:getFullName(true))
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(researchEmployeeSelection.gradientColor)
	
	local workfield = self.researchTask:getTaskTypeData():getResearchWorkField()
	local skillData = skills.registeredByID[workfield]
	local skillDisplay = gui.create("GradientIconPanel", self.leftList)
	
	skillDisplay:setIcon(skillData.icon)
	skillDisplay:setFont("pix20")
	skillDisplay:setText(string.easyformatbykeys(_T("REQUIRES_SKILL_LEVEL", "Requires skill Lv. LEVEL"), "LEVEL", self.researchTask:getTaskTypeData():getMinimumLevel()))
	skillDisplay:setBaseSize(baseElementSize, 0)
	skillDisplay:setIconSize(24, 24, 26)
	skillDisplay:setIconOffset(1, 1)
	self.leftList:updateLayout()
	
	self.rightList = gui.create("List", self)
	
	self.rightList:setPos(self.leftList.x + self.leftList.w)
	self.rightList:setPanelColor(developer.employeeMenuListColor)
	self.rightList:setCanHover(false)
	
	self.rightList.shouldDraw = false
	
	local roleDisplay = self.employee:createRoleDisplayElement(self.rightList, "pix22", true)
	
	roleDisplay:setBaseSize(baseElementSize, 0)
	roleDisplay:setIconSize(25, 25)
	roleDisplay:setBackdropSize(27)
	roleDisplay:setIconOffset(1, 1)
	
	local skillDisplay = self.employee:createMainSkillDisplayElement(self.rightList, "pix20", true, workfield)
	
	skillDisplay:setBaseSize(baseElementSize, 0)
	skillDisplay:setIconSize(24, 24, 26)
	skillDisplay:setIconOffset(1, 1)
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

gui.register("ResearchEmployeeSelection", researchEmployeeSelection, "EmployeeTeamAssignmentButton")
