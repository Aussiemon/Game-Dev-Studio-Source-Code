local socketBC = {}

socketBC.scaler = "new_hud"
socketBC.socket = {
	70,
	50
}
socketBC.startSocketPad = 18
socketBC.socketPad = 26
socketBC.borderH = 50
socketBC.endBorderW = 4
socketBC.buttonH = 64
socketBC.buttonYOff = socketBC.buttonH * 0.5 - 5

function socketBC:init()
	self.buttons = {}
	self.sockets = {}
	self.socketPads = {}
end

function socketBC:adjustLayout()
	self:adjustButtonPositions()
	self:adjustSize()
end

function socketBC:adjustButtonPositions()
	local activeButtons = 0
	local buttonY = math.floor(_S(self.buttonYOff, self.scaler))
	
	for key, button in ipairs(self.buttons) do
		if not button:isRenderingDisabled() then
			button:setPos(self:getButtonX(activeButtons), self:getButtonY())
			
			activeButtons = activeButtons + 1
		end
	end
	
	self.activeButtons = activeButtons
end

function socketBC:addButton(button, tableIdx, id)
	tableIdx = tableIdx or #self.buttons
	
	button:setSize(64, 64)
	button:setPos(self:getButtonX(tableIdx), self:getButtonY())
	button:addDepth(100)
	button:tieVisibilityTo(self)
	
	if id then
		button:setID(id)
	end
	
	table.insert(self.buttons, button)
	self:queueSpriteUpdate()
end

function socketBC:getButtonX(tableIdx)
	local x = math.floor(_S(self.startSocketPad, self.scaler))
	local socket = self.socket
	local socketW, socketH = socket[1], socket[2]
	local socketPad = self.socketPad
	local scaledPad = math.floor(_S(self.socketPad, self.scaler))
	local scaledSocketW = math.floor(_S(socketW, self.scaler))
	
	return self.x + math.floor(_S(self.startSocketPad, self.scaler)) + tableIdx * (scaledPad + scaledSocketW)
end

function socketBC:getButtonY()
	local x, y = self:getPos(true)
	
	return y - math.floor(_S(self.buttonYOff, self.scaler))
end

function socketBC:adjustSize()
	self:setSize(self.activeButtons * (self.socketPad + self.socket[1]) + self.startSocketPad, self.borderH)
end

function socketBC:updateSprites()
	local borderH = self.borderH
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.startPad = self:allocateSprite(self.startPad, "hud_new_bottom_bar", 0, 0, 0, self.startSocketPad, borderH, 0, 0, -0.3)
	
	local x = math.floor(_S(self.startSocketPad, self.scaler))
	local socket = self.socket
	local socketW, socketH = socket[1], socket[2]
	local socketPad = self.socketPad
	local scaledPad = math.floor(_S(self.socketPad, self.scaler))
	local scaledSocketW = math.floor(_S(socketW, self.scaler))
	local active = self.activeButtons
	
	for i = 1, active do
		self.sockets[i] = self:allocateSprite(self.sockets[i], "hud_new_bottom_bar_button_socket", x, 0, 0, socketW, socketH, 0, 0, -0.3)
		x = x + scaledSocketW
		self.socketPads[i] = self:allocateSprite(self.socketPads[i], "hud_new_bottom_bar", x, 0, 0, socketPad, borderH, 0, 0, -0.3)
		x = x + scaledPad
	end
	
	local btns = #self.buttons
	
	if btns - active > 0 then
		for i = btns, active + 1, -1 do
			self.sockets[i] = self:allocateSprite(self.sockets[i], "hud_new_bottom_bar_button_socket", 0, 0, 0, 0, 0, 0, 0, -0.3)
			self.socketPads[i] = self:allocateSprite(self.socketPads[i], "hud_new_bottom_bar", 0, 0, 0, 0, 0, 0, 0, -0.3)
		end
	end
	
	self.endBorder = self:allocateSprite(self.endBorder, "hud_new_bottom_bar_edge", x, 0, 0, self.endBorderW, borderH, 0, 0, -0.3)
	self.totalSpriteW = x + _S(self.endBorderW, self.scaler)
end

gui.register("SocketButtonContainer", socketBC)

local hudBottom = {}

hudBottom.scaler = "new_hud"
hudBottom.PROJECTS_BUTTON_ID = "projects_menu_button"
hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID = "property_and_rivals_button"
hudBottom.PROPERTY_BUTTON_ID = "property_menu_button"
hudBottom.RIVALS_BUTTON_ID = "rivals_menu_button"
hudBottom.FUNDS_BUTTON_ID = "funds_button"
hudBottom.EMPLOYEES_BUTTON_ID = "employes_button"
hudBottom.OFFICE_PREFERENCES_BUTTON_ID = "preferences_button"
hudBottom.GAME_CONVENTIONS_ID = "hud_game_conventions"
hudBottom.JOB_SEEKERS_MENU_ID = "job_seekers_button"
hudBottom.EVENTS = {
	SHOWING_PROPERTY_BUTTONS = events:new(),
	NEARBY_BUTTON_CLICKED = events:new(),
	SHOWING_EMPLOYEE_BUTTONS = events:new()
}

function hudBottom:setActiveReveal(element)
	local prev = self.activeReveal
	
	if prev and prev ~= element then
		prev:hideButtons()
	end
	
	self.activeReveal = element
end

function hudBottom:buttonEnabled(button)
	self:adjustLayout()
end

function hudBottom:buttonDisabled(button)
	self:adjustLayout()
end

function hudBottom:removeActiveReveal(element)
	if element == self.activeReveal then
		self.activeReveal = nil
		
		element:hideButtons()
	end
end

function hudBottom:finalize()
	if not self:canDisplayElement(hudBottom.FUNDS_BUTTON_ID) then
		self.financesButton:disable()
	else
		self.financesButton:enable()
	end
	
	if not self:canDisplayElement(hudBottom.PROJECTS_BUTTON_ID) then
		self.projectsButton:disable()
	else
		self.projectsButton:enable()
	end
	
	if not self:canDisplayElement(hudBottom.EMPLOYEES_BUTTON_ID) then
		self.employeesActivities:disable()
	else
		self.employeesActivities:enable()
	end
	
	if not self:canDisplayElement(hudBottom.OFFICE_PREFERENCES_BUTTON_ID) then
		self.preferencesButton:disable()
	else
		self.preferencesButton:enable()
	end
end

function hudBottom:canDisplayElement(id)
	local data = game.curGametype:getHUDRestrictions()
	
	if data and data[id] then
		return false
	end
	
	return true
end

function hudBottom:createElements()
	self.timelineButton = gui.create("HUDTimelineButton")
	
	self:addButton(self.timelineButton, nil)
	
	self.financesButton = gui.create("HUDFinancesButton")
	
	self:addButton(self.financesButton, nil, hudBottom.FUNDS_BUTTON_ID)
	
	self.propertyButton = gui.create("HUDPropertyButton")
	
	self:addButton(self.propertyButton, nil, hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID)
	
	self.projectsButton = gui.create("HUDProjectsMenu")
	
	self:addButton(self.projectsButton, nil, hudBottom.PROJECTS_BUTTON_ID)
	
	self.gameConventions = gui.create("HUDGameConventions")
	
	self:addButton(self.gameConventions, nil, hudBottom.GAME_CONVENTIONS_ID)
	
	self.employeesActivities = gui.create("HUDEmployeesActivities")
	
	self:addButton(self.employeesActivities, nil, hudBottom.EMPLOYEES_BUTTON_ID)
	
	self.officePreferences = gui.create("HUDOfficePreferences")
	
	self:addButton(self.officePreferences, nil, hudBottom.OFFICE_PREFERENCES_BUTTON_ID)
	
	self.objectives = gui.create("HUDObjectives")
	
	self:addButton(self.objectives)
	self:adjustLayout()
end

function hudBottom:position()
	self:setPos(0, scrH - _S(self.borderH, self.scaler))
end

gui.register("HUDBottom", hudBottom, "SocketButtonContainer")

local hudBottomButton = {}

hudBottomButton.icon = ""
hudBottomButton.iconHover = ""
hudBottomButton.iconW, hudBottomButton.iconH = 64, 64
hudBottomButton.mouseOverIconColor = color(255, 255, 255, 255)
hudBottomButton.regularIconColor = hudBottomButton.mouseOverIconColor
hudBottomButton.scaler = "new_hud"
hudBottomButton.revealSpeed = 7
hudBottomButton.hideSpeed = 4
hudBottomButton.alpha = 1
hudBottomButton.revealPad = 8
hudBottomButton.revealHold = 5

function hudBottomButton:init()
	self.buttons = {}
	self.revealAlpha = 0
	
	self:setSize(self.iconW, self.iconH)
	self:setAlpha(hudBottomButton.alpha)
end

function hudBottomButton:getSocketContainer()
	return self.socketContainer
end

function hudBottomButton:getNearbyButtons()
	return self.buttons
end

function hudBottomButton:expandOptions()
	self:revealButtons()
end

function hudBottomButton:kill()
	hudBottomButton.baseClass.kill(self)
	self:killRevealedButtons()
end

function hudBottomButton:hide()
	hudBottomButton.baseClass.hide(self)
	self:killRevealedButtons()
end

function hudBottomButton:toggleReveal()
	if self.buttonFadeIn then
		self:hideButtons()
	else
		self:revealButtons()
	end
end

function hudBottomButton:disable()
	self:disableRendering()
	game.bottomHUD:buttonDisabled(self)
end

function hudBottomButton:enable()
	self:enableRendering()
	game.bottomHUD:buttonEnabled(self)
end

function hudBottomButton:lockRevealTime()
	self.revealTimeLocked = true
end

function hudBottomButton:unlockRevealTime()
	self.revealTimeLocked = false
	self.revealTime = self.revealHold
end

function hudBottomButton:revealButtons()
	self.buttonFadeIn = true
	
	self:killDescBox()
	game.bottomHUD:setActiveReveal(self)
	
	if #self.buttons == 0 then
		self:createButtons()
	end
	
	self.revealTime = self.revealHold
	
	self:onReveal()
end

function hudBottomButton:onReveal()
end

function hudBottomButton:onHide()
end

function hudBottomButton:hideButtons()
	game.bottomHUD:removeActiveReveal(self)
	self:resetRevealState()
	self:queueSpriteUpdate()
	self:onHide()
end

function hudBottomButton:resetRevealState()
	self.buttonFadeIn = false
	self.revealTimeLocked = false
	self.revealTime = 0
end

function hudBottomButton:think()
	if self.buttonFadeIn then
		if self.revealAlpha < 1 then
			self.revealAlpha = math.approach(self.revealAlpha, 1, frameTime * self.revealSpeed)
			
			self:updateButtonAlpha()
		elseif self.revealTime > 0 then
			if not self.revealTimeLocked then
				self.revealTime = self.revealTime - frameTime
			end
		else
			self:hideButtons()
		end
	elseif #self.buttons > 0 and not gui:isLimitingClicks() then
		if self.revealAlpha > 0 then
			self.revealAlpha = math.approach(self.revealAlpha, 0, frameTime * self.hideSpeed)
			
			self:updateButtonAlpha()
		else
			self:killRevealedButtons()
		end
	end
end

function hudBottomButton:addButton(butt, id)
	local otherButton = self.buttons[#self.buttons]
	local y
	
	if otherButton then
		y = otherButton.y - butt.h - _S(self.revealPad, self.scaler)
	else
		y = self.y - butt.h - _S(self.revealPad, self.scaler)
	end
	
	butt:setBaseButton(self)
	butt:setPos(self.x + self.w * 0.5 - butt.w * 0.5, y)
	
	if id then
		butt:setID(id)
	end
	
	table.insert(self.buttons, butt)
end

function hudBottomButton:createButtons()
end

function hudBottomButton:killRevealedButtons()
	self:resetRevealState()
	
	self.revealAlpha = 0
	
	for key, butt in ipairs(self.buttons) do
		butt:kill()
		
		self.buttons[key] = nil
	end
	
	if self:isMouseOver() and self:isRenderingDisabled() then
		self:createDescbox()
	end
	
	self:queueSpriteUpdate()
end

function hudBottomButton:updateButtonAlpha()
	local alpha = self.revealAlpha
	
	for key, butt in ipairs(self.buttons) do
		butt:setAlpha(alpha)
	end
end

function hudBottomButton:setAlpha(alpha)
	self.alpha = alpha
	self.displayAlpha = alpha * 255
	
	self:queueSpriteUpdate()
end

function hudBottomButton:onMouseEntered()
	if not self.buttonFadeIn then
		self:createDescbox()
	end
	
	self:queueSpriteUpdate()
	self:lockRevealTime()
end

function hudBottomButton:createDescbox()
	if self.descBox then
		return 
	end
	
	local descBoxText = self:getDescboxText()
	
	if descBoxText then
		self:setupDescbox(descBoxText)
	end
end

function hudBottomButton:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
	self:unlockRevealTime()
end

function hudBottomButton:getDescboxText()
	return nil
end

function hudBottomButton:setupDescbox(text)
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(text, "bh18", nil, 0, 200)
	self:positionDescbox()
end

function hudBottomButton:positionDescbox()
	local midX = self.x + self.w * 0.5 - self.descBox.w * 0.5
	local x
	
	if midX < 0 then
		x = self.x
	else
		x = midX
	end
	
	self.descBox:setPos(x, self.y - self.descBox.h - _S(5, self.scaler))
end

function hudBottomButton:updateSprites()
	local icon
	
	if self:isMouseOver() or #self.buttons > 0 then
		icon = self.iconHover
	else
		icon = self.icon
	end
	
	self:setNextSpriteColor(255, 255, 255, self.displayAlpha)
	
	self.iconSprite = self:allocateSprite(self.iconSprite, icon, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.3)
end

function hudBottomButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:killDescBox()
		self:onClicked()
		
		return true
	end
end

function hudBottomButton:onClicked()
end

gui.register("HUDBottomButton", hudBottomButton, "IconButton")

local hudRevealedButton = {}

hudRevealedButton.alpha = 0
hudRevealedButton.iconW, hudRevealedButton.iconH = 44, 44

function hudRevealedButton:setBaseButton(button)
	self.baseButton = button
end

function hudRevealedButton:onMouseEntered()
	hudRevealedButton.baseClass.onMouseEntered(self)
	self.baseButton:lockRevealTime()
end

function hudRevealedButton:onMouseLeft()
	hudRevealedButton.baseClass.onMouseLeft(self)
	self.baseButton:unlockRevealTime()
end

function hudRevealedButton:positionDescbox()
	self.descBox:setPos(self.x + self.w + _S(5, self.scaler), self.y + self.h * 0.5 - self.descBox.h * 0.5)
end

gui.register("HUDRevealedButton", hudRevealedButton, "HUDBottomButton")

local hudTimelineButton = {}

hudTimelineButton.icon = "hud_new_timeline"
hudTimelineButton.iconHover = "hud_new_timeline_hover"

function hudTimelineButton:onClicked()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = game.createTimelineMenu()
end

function hudTimelineButton:getDescboxText()
	return _T("GOALS_AND_DEADLINES", "Goals & deadlines")
end

gui.register("HUDTimelineButton", hudTimelineButton, "HUDBottomButton")

local hudFinancesButton = {}

hudFinancesButton.icon = "hud_new_expenses"
hudFinancesButton.iconHover = "hud_new_expenses_hover"

function hudFinancesButton:getDescboxText()
	if self.canClick then
		return _T("VIEW_OFFICES_AND_EXPENSES", "View offices & expenses")
	end
	
	return _T("CURRENT_FINANCIAL_SITUATION", "Current financial situation")
end

function hudFinancesButton:onClicked()
	if self.canClick then
		monthlyCost.createMenu()
	end
end

gui.register("HUDFinancesButton", hudFinancesButton, "HUDBottomButton")

local hudPropertyButton = {}

hudPropertyButton.icon = "hud_new_property"
hudPropertyButton.iconHover = "hud_new_property_hover"

function hudPropertyButton:getDescboxText()
	if rivalGameCompanies:isLocked() then
		return _T("PROPERTY", "Property")
	end
	
	return _T("PROPERTY_AND_RIVALS", "Property & rivals")
end

function hudPropertyButton:onClicked()
	self:toggleReveal()
	events:fire(hudBottom.EVENTS.SHOWING_PROPERTY_BUTTONS)
end

function hudPropertyButton:createButtons()
	local expansion = gui.create("HUDExpansionButton")
	
	self:addButton(expansion, hudBottom.PROPERTY_BUTTON_ID)
	
	local empAssign = gui.create("HUDEmployeeAssignment")
	
	self:addButton(empAssign)
	
	local viewRivals = gui.create("HUDViewRivals")
	
	self:addButton(viewRivals, hudBottom.RIVALS_BUTTON_ID)
end

gui.register("HUDPropertyButton", hudPropertyButton, "HUDBottomButton")

local hudExpansionButton = {}

hudExpansionButton.icon = "hud_new_expansion"
hudExpansionButton.iconHover = "hud_new_expansion_hover"

function hudExpansionButton:getDescboxText()
	return _T("EXPAND_OFFICE", "Expand office")
end

function hudExpansionButton:onClicked()
	studio.expansion:createMenu()
	events:fire(hudBottom.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

gui.register("HUDExpansionButton", hudExpansionButton, "HUDRevealedButton")

local hudEmployeeAssignment = {}

hudEmployeeAssignment.icon = "hud_new_assign_employees"
hudEmployeeAssignment.iconHover = "hud_new_assign_employees_hover"

function hudEmployeeAssignment:getDescboxText()
	return _T("EMPLOYEE_ASSIGNMENT_BUTTON", "Assign employees")
end

function hudEmployeeAssignment:onClicked()
	employeeAssignment:enter()
	events:fire(hudBottom.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

gui.register("HUDEmployeeAssignment", hudEmployeeAssignment, "HUDRevealedButton")

local hudViewRivals = {}

hudViewRivals.icon = "hud_new_rivals"
hudViewRivals.iconHover = "hud_new_rivals_hover"

function hudViewRivals:getDescboxText()
	return _T("VIEW_RIVAL_GAME_COMPANIES", "View rivals")
end

function hudViewRivals:onClicked()
	rivalGameCompanies:createMenu()
	events:fire(hudBottom.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

gui.register("HUDViewRivals", hudViewRivals, "HUDRevealedButton")

local hudProjectsMenu = {}

hudProjectsMenu.icon = "hud_new_projects"
hudProjectsMenu.iconHover = "hud_new_projects_hover"

function hudProjectsMenu:getDescboxText()
	return _T("PROJECTS", "Projects")
end

function hudProjectsMenu:onClicked()
	projectsMenu:open()
end

gui.register("HUDProjectsMenu", hudProjectsMenu, "HUDBottomButton")

local hudEmployeesActivities = {}

hudEmployeesActivities.icon = "hud_new_employees_and_activities"
hudEmployeesActivities.iconHover = "hud_new_employees_and_activities_hover"

function hudEmployeesActivities:getDescboxText()
	return _format(_T("EMPLOYEES_WITH_COUNTER", "Employees (EMPLOYEES)"), "EMPLOYEES", #studio:getEmployees())
end

function hudEmployeesActivities:createButtons()
	local hire = gui.create("HUDHireEmployees")
	
	self:addButton(hire, hudBottom.JOB_SEEKERS_MENU_ID)
	
	local employeeManagement = gui.create("HUDEmployeeManagement")
	
	self:addButton(employeeManagement)
end

function hudEmployeesActivities:onClicked()
	self:toggleReveal()
	events:fire(hudBottom.EVENTS.SHOWING_EMPLOYEE_BUTTONS, self)
end

gui.register("HUDEmployeesActivities", hudEmployeesActivities, "HUDBottomButton")

local hudHireEmployees = {}

hudHireEmployees.icon = "hud_new_hire_employees"
hudHireEmployees.iconHover = "hud_new_hire_employees_hover"

function hudHireEmployees:getDescboxText()
	return _format(_T("HIRE_EMPLOYEES_COUNTER", "Hire employees (EMPLOYEES)"), "EMPLOYEES", #employeeCirculation:getJobSeekers())
end

function hudHireEmployees:onClicked()
	employeeCirculation:toggleMenu()
	events:fire(hudBottom.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

gui.register("HUDHireEmployees", hudHireEmployees, "HUDRevealedButton")

local hudEmployeeManagement = {}

hudEmployeeManagement.icon = "hud_new_manage_employees"
hudEmployeeManagement.iconHover = "hud_new_manage_employees_hover"

function hudEmployeeManagement:getDescboxText()
	return _format(_T("EMPLOYEE_MANAGEMENT_AND_ACTIVITIES", "Employee management & activities"))
end

function hudEmployeeManagement:onClicked()
	game.createTeamManagementMenu()
	events:fire(hudBottom.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

gui.register("HUDEmployeeManagement", hudEmployeeManagement, "HUDRevealedButton")

local hudOfficePreferences = {}

hudOfficePreferences.icon = "hud_new_office_preferences"
hudOfficePreferences.iconHover = "hud_new_office_preferences_hover"

function hudOfficePreferences:getDescboxText()
	return _T("OFFICE_PREFERENCES", "Office preferences")
end

function hudOfficePreferences:onClicked()
	preferences:createPopup()
end

gui.register("HUDOfficePreferences", hudOfficePreferences, "HUDBottomButton")

local hudObjectives = {}

hudObjectives.icon = "hud_new_objectives"
hudObjectives.iconHover = "hud_new_objectives_hover"

local sequenceObjective = objectiveHandler:getTaskData("sequence")

hudObjectives.CATCHABLE_EVENTS = {
	objectiveHandler.EVENTS.FILLED_OBJECTIVES,
	sequenceObjective.EVENTS.TASK_ADVANCED,
	game.EVENTS.ENTER_GAMEPLAY,
	game.EVENTS.GAME_LOGIC_STARTED
}

function hudObjectives:init()
	self:createNotification()
end

function hudObjectives:setPos(x, y)
	hudObjectives.baseClass.setPos(self, x, y)
	
	if self.notification then
		local x, y = self:getPos(true)
		
		self.notification:setPos(x, y)
	end
end

function hudObjectives:handleEvent(event)
	self:adjustNotification()
end

function hudObjectives:adjustNotification()
	local objs = objectiveHandler:getObjectives()
	
	if not objs then
		return 
	end
	
	if #objs == 0 then
		self:disable()
	else
		self:enable()
		
		if gui:isLimitingClicks() or objectiveHandler:getViewedTasks() then
			self:hideNotification()
		else
			self:showNotification()
		end
	end
end

function hudObjectives:createNotification()
	self.notification = gui.create("HUDGenericNotification")
	
	self.notification:setSize(44, 44)
	self.notification:tieVisibilityTo(self)
	self.notification:addDepth(200)
	self:adjustNotification()
end

function hudObjectives:showNotification()
	self.notification:enableRendering()
end

function hudObjectives:hideNotification()
	self.notification:disableRendering()
end

function hudObjectives:getDescboxText()
	return _T("OBJECTIVES", "Objectives")
end

function hudObjectives:onClicked()
	game.createObjectivesMenu()
	self:hideNotification()
end

gui.register("HUDObjectives", hudObjectives, "HUDBottomButton")

local hudGameConventions = {}

hudGameConventions.icon = "hud_new_game_conventions"
hudGameConventions.iconHover = "hud_new_game_conventions_hover"

function hudGameConventions:getDescboxText()
	return _T("HUD_GAME_CONVENTIONS", "Game conventions")
end

function hudGameConventions:onClicked()
	gameProject:createConventionSelectionMenu(true)
end

gui.register("HUDGameConventions", hudGameConventions, "HUDBottomButton")
