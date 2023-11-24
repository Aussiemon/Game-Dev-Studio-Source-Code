local jobs = {}

jobs.skinPanelFillColor = color(184, 195, 196, 255)
jobs.skinPanelHoverColor = color(175, 160, 75, 255)
jobs.skinPanelSelectColor = color(125, 175, 125, 255)
jobs.skinTextFillColor = color(200, 200, 200, 255)
jobs.skinTextHoverColor = color(240, 240, 240, 255)
jobs.skinTextDisableColor = color(200, 200, 200, 255)
jobs.canPropagateKeyPress = true
jobs.CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.SELECTED_TARGET_TEAM
}

function jobs:init()
end

function jobs:setEmployee(seeker)
	self.employee = seeker
	
	self:createInfoLists()
end

function jobs:getEmployee()
	return self.employee
end

function jobs:onKill()
	self:killDescBox()
end

function jobs.moreInfoCallback(comboBoxOption)
	comboBoxOption.employee:createEmployeeMenu()
end

function jobs.sendJobOfferCallback(comboBoxOption)
	if employeeCirculation:verifyJobOfferValidity() then
		if #studio:getTeams() > 1 then
			employeeCirculation:createTeamAssignmentPopup(comboBoxOption.employee, comboBoxOption.element)
			
			return 
		end
		
		employeeCirculation:offerJob(comboBoxOption.employee)
		comboBoxOption.element:moveToSentCategory()
	end
end

function jobs.cancelJobOfferCallback(comboBoxOption)
	comboBoxOption.element:moveToUnsentCategory()
	employeeCirculation:revokeJobOffer(comboBoxOption.employee)
end

function jobs:moveToSentCategory()
	employeeCirculation.sentCategory:addItem(self)
end

function jobs:moveToUnsentCategory()
	employeeCirculation.unsentCategory:addItem(self, true)
end

function jobs:handleEvent(event, object)
	if object == self.employee then
		self:moveToSentCategory()
	end
end

function jobs:fillInteractionComboBox(comboBox)
	comboBox:setAutoCloseTime(0.5)
	
	comboBox:addOption(0, 0, 200, 18, _T("MORE_INFO", "More info"), fonts.get("pix20"), jobs.moreInfoCallback).employee = self.employee
	
	if not self.employee:hasOfferedWork() then
		local option = comboBox:addOption(0, 0, 200, 18, _T("SEND_JOB_OFFER", "Send job offer"), fonts.get("pix20"), jobs.sendJobOfferCallback)
		
		option.employee = self.employee
		option.element = self
	else
		local option = comboBox:addOption(0, 0, 200, 18, _T("REVOKE_JOB_OFFER", "Revoke job offer"), fonts.get("pix20"), jobs.cancelJobOfferCallback)
		
		option.employee = self.employee
		option.element = self
	end
end

function jobs:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
	self:killDescBox()
end

function jobs:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("bh22")
	nameDisplay:setText(self.employee:getFullName(true))
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(jobs.gradientColor)
	
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

gui.register("JobSeekerDisplay", jobs, "EmployeeTeamAssignmentButton")
