local managementLoadDisplay = {}

managementLoadDisplay.skinTextDisableColor = game.UI_COLORS.RED

function managementLoadDisplay:setManager(manager)
	self.manager = manager
	self.maxManagedMembers = skills:getData("management"):getManageablePeopleAmount(manager)
	
	self:updateText()
end

function managementLoadDisplay:handleEvent(event, teamObj)
	if event == team.EVENTS.MANAGER_ASSIGNED or event == team.EVENTS.MANAGER_UNASSIGNED then
		self:updateText()
		self:queueSpriteUpdate()
	end
end

function managementLoadDisplay:onMouseEntered()
	managementLoadDisplay.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("MANAGED_PEOPLE_AMOUNT_DESCRIPTION", "The amount of people that the manager has to manage, as well as the maximum amount of people he can manage properly."), "pix20", nil, 0, 500, "question_mark", 24, 24)
	
	if self.overloaded then
		self.descBox:addText(_T("MANAGED_PEOPLE_AMOUNT_OVERLOADED_DESCRIPTION", "Managing too many people - management efficiency reduced"), "bh20", game.UI_COLORS.RED, 0, 500, "exclamation_point_red", 24, 24)
	end
	
	self.descBox:centerToElement(self)
end

function managementLoadDisplay:onMouseLeft()
	managementLoadDisplay.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function managementLoadDisplay:getProgress()
	return math.min(1, self.managedMembers / self.maxManagedMembers)
end

function managementLoadDisplay:getBarColor()
	return managementLoadDisplay.baseClass.getBarColor(self)
end

function managementLoadDisplay:getTextColor()
	if self.overloaded then
		return game.UI_COLORS.RED
	end
	
	return managementLoadDisplay.baseClass.getTextColor(self)
end

function managementLoadDisplay:updateText()
	local total = 0
	
	for key, teamObj in ipairs(self.manager:getManagedTeams()) do
		total = total + #teamObj:getMembers()
	end
	
	self.managedMembers = total
	self.overloaded = total > self.maxManagedMembers
	
	if self.overloaded then
		self.text = _format(_T("MANAGED_PEOPLE_AMOUNT_OVERLOADED", "Managed people: MANAGED/MAX - OVERLOADED!"), "MANAGED", self.managedMembers, "MAX", self.maxManagedMembers)
	else
		self.text = _format(_T("MANAGED_PEOPLE_AMOUNT", "Managed people: MANAGED/MAX"), "MANAGED", self.managedMembers, "MAX", self.maxManagedMembers)
	end
	
	if self.overloaded then
		self:setIcon("exclamation_point_red", 16, 16)
	else
		self:setIcon("question_mark", 16, 16)
	end
end

gui.register("ManagementLoadDisplay", managementLoadDisplay, "ProgressBarWithText")
