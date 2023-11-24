local expoParticipantSelection = {}

expoParticipantSelection.selectedPanelColor = game.UI_COLORS.IMPORTANT_3:duplicate()

expoParticipantSelection.selectedPanelColor:lerp(0.05, 0, 0, 0, 255)

expoParticipantSelection.selectedPanelColor.a = 200
expoParticipantSelection.selectedHoverPanelColor = game.UI_COLORS.IMPORTANT_3:duplicate()

expoParticipantSelection.selectedHoverPanelColor:lerp(0.2, 0, 0, 0, 255)

expoParticipantSelection.selectedHoverPanelColor.a = 200
expoParticipantSelection.canPropagateKeyPress = true
expoParticipantSelection.basePanelColor = color(86, 104, 135, 255)
expoParticipantSelection.hoverPanelColor = color(179, 194, 219, 255)
expoParticipantSelection.basePanelColorUnavailable = color(127, 134, 135, 255)
expoParticipantSelection.hoverPanelColorUnavailable = color(106, 120, 140, 255)
expoParticipantSelection.CATCHABLE_EVENTS = nil

function expoParticipantSelection:init()
end

function expoParticipantSelection:setEmployee(seeker)
	self.employee = seeker
	self.awayUntil = self.employee:getAwayUntil()
	
	self:createInfoLists()
end

function expoParticipantSelection:handleEvent(event)
	self:queueSpriteUpdate()
end

function expoParticipantSelection:getEmployee()
	return self.employee
end

function expoParticipantSelection:setConventionData(data)
	self.conventionData = data
end

function expoParticipantSelection:onKill()
	self:killDescBox()
end

function expoParticipantSelection:onMouseEntered()
	self:queueSpriteUpdate()
	
	local expoIsBooked = not self.conventionData:canEmployeeBeBooked(self.employee)
	
	if self.awayUntil or expoIsBooked then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("EMPLOYEE_UNAVAILABLE_FOR_BOOKING", "This employee is not available for expo participation."), "pix22", nil, 3, 600)
		
		local expoID = self.employee:getBookedExpo()
		
		if expoIsBooked and expoID then
			local expoData = gameConventions:getData(expoID)
			
			if gameConventions:isConventionInProgress(expoID) then
				self.descBox:addText(string.easyformatbykeys(_T("EMPLOYEE_PARTICIPATING_IN_EXPO", "NAME is participating in 'EXPO'."), "NAME", self.employee:getFullName(true), "EXPO", expoData.display), "pix20", game.UI_COLORS.IMPORTANT_1, 0, 600)
			else
				self.descBox:addText(string.easyformatbykeys(_T("EMPLOYEE_WILL_BE_PARTICIPATING_IN_EXPO", "NAME is already booked for participating in 'EXPO'."), "NAME", self.employee:getFullName(true), "EXPO", expoData.display), "pix20", game.UI_COLORS.IMPORTANT_1, 0, 600)
			end
		else
			self.descBox:addText(string.easyformatbykeys(_T("EMPLOYEE_UNAVAILABLE_FOR_TIME", "NAME is unavailable for TIME."), "NAME", self.employee:getFullName(true), "TIME", timeline:getTimePeriodText(timeline.curTime - self.awayUntil)), "pix20", game.UI_COLORS.IMPORTANT_1, 0, 600)
		end
		
		self.descBox:centerToElement(self)
	end
end

function expoParticipantSelection:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function expoParticipantSelection:getBasePanelColor()
	if self.conventionData:hasDesiredEmployee(self.employee) then
		if self:isMouseOver() then
			return expoParticipantSelection.selectedHoverPanelColor
		end
		
		return expoParticipantSelection.selectedPanelColor
	end
	
	local isAway = self.awayUntil or not self.conventionData:canEmployeeBeBooked(self.employee)
	
	if self:isMouseOver() then
		return isAway and expoParticipantSelection.hoverPanelColorUnavailable or expoParticipantSelection.hoverPanelColor
	end
	
	return isAway and expoParticipantSelection.basePanelColorUnavailable or expoParticipantSelection.basePanelColor
end

function expoParticipantSelection:onClick(x, y, key)
	if self.awayUntil or not self.conventionData:canEmployeeBeBooked(self.employee) then
		return 
	end
	
	if self.conventionData:hasDesiredEmployee(self.employee) then
		self.conventionData:removeDesiredEmployee(self.employee)
	elseif self.conventionData:getDesiredBooth() then
		self.conventionData:addDesiredEmployee(self.employee)
	else
		local popup = game.createPopup(500, _T("NO_BOOTH_SELECTED_TITLE", "No Booth Selected"), _T("NO_BOOTH_SELECTED_EMPLOYEES_DESCRIPTION", "You must first select the booth size before you can select employees for participation."), "pix24", "pix20")
		
		popup:center()
		frameController:push(popup)
	end
	
	self:queueSpriteUpdate()
	self:killDescBox()
end

function expoParticipantSelection:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("pix24")
	nameDisplay:setText(self.employee:getFullName(true))
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(expoParticipantSelection.gradientColor)
	
	local efficiencyDisplay = self.employee:createExpoEfficiencyDisplayElement(self.leftList, "pix22", true)
	
	efficiencyDisplay:setBaseSize(baseElementSize, 0)
	efficiencyDisplay:setIconSize(25, 25)
	efficiencyDisplay:setBackdropSize(27)
	efficiencyDisplay:setIconOffset(1, 1)
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
	
	local ageDisplay = self.employee:createAgeDisplayElement(self.rightList, "pix20", true)
	
	ageDisplay:setBaseSize(baseElementSize, 0)
	ageDisplay:setIconSize(24, nil, 26)
	ageDisplay:setIconOffset(2, 1)
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

gui.register("ExpoParticipantSelection", expoParticipantSelection, "EmployeeTeamAssignmentButton")
