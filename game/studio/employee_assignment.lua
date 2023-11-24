employeeAssignment = {}
employeeAssignment.active = false
employeeAssignment.botherDelay = 7
employeeAssignment.flickerBaseAlpha = 150
employeeAssignment.flickerAlpha = 75
employeeAssignment.GREET_DELAY = 5
employeeAssignment.EVENTS = {
	ASSIGNED = events:new(),
	ASSIGNED_TEAM = events:new(),
	SELECTED = events:new(),
	SELECTED_TEAM = events:new(),
	DESELECTED = events:new(),
	DESELECTED_TEAM = events:new(),
	UNASSIGNED = events:new(),
	AUTO_ASSIGNED = events:new(),
	UNASSIGNED_EVERYONE = events:new(),
	ASSIGNMENT_MODE_CHANGED = events:new()
}
employeeAssignment.VALID_WORKPLACE_TYPE = "workplace"
employeeAssignment.ASSIGNMENT_MODES = {
	TEAMS = 2,
	EMPLOYEES = 1
}
employeeAssignment.EMPLOYEE_ASSIGNMENT_TEXT = {
	{
		font = "bh24",
		icon = "question_mark",
		iconHeight = 24,
		lineSpace = 3,
		iconWidth = 24,
		text = _T("EMPLOYEE_ASSIGNMENT", "Employee assignment")
	},
	{
		font = "pix20",
		text = _T("EMPLOYEE_ASSIGNMENT_DESCRIPTION", "Assign individual employees to workplaces")
	}
}
employeeAssignment.TEAM_ASSIGNMENT_TEXT = {
	{
		font = "bh24",
		icon = "question_mark",
		iconHeight = 24,
		lineSpace = 3,
		iconWidth = 24,
		text = _T("TEAM_ASSIGNMENT", "Team assignment")
	},
	{
		font = "pix20",
		text = _T("TEAM_ASSIGNMENT_DESCRIPTION", "Assign an entire team to an office")
	}
}

function employeeAssignment:init()
	self.nextGreet = 0
	self.active = false
	self.allocatedSprites = {}
	self.spritesByBuilding = {}
	self.highlightedBuildings = {}
	self.employeesWithoutWorkplace = {}
	self.validWorkplaces = {}
	self.workplaceObjects = {}
	self.assignableWorkplaceObjects = {}
	self.botherTime = 0
end

function employeeAssignment:remove()
	table.clearArray(self.employeesWithoutWorkplace)
	table.clearArray(self.validWorkplaces)
	table.clearArray(self.workplaceObjects)
	table.clearArray(self.assignableWorkplaceObjects)
end

function employeeAssignment:initEventHandler()
	events:addDirectReceiver(self, employeeAssignment.CATCHABLE_EVENTS)
end

function employeeAssignment:removeEventHandler()
	events:removeDirectReceiver(self, employeeAssignment.CATCHABLE_EVENTS)
end

function employeeAssignment:enter(assignmentTarget, desiredMode)
	self.active = true
	
	local invisibleFrame = gui.create("EmployeeAssignmentFrame")
	
	invisibleFrame:setSize(300, _US(scrH) - _US(game.topHUD.h))
	invisibleFrame:setPos(0, game.topHUD.h)
	
	local scaledYOff = _S(5)
	
	self.exitButton = gui.create("ExitAssignmentModeButton")
	
	self.exitButton:setSize(40, 40)
	self.exitButton:setPos(invisibleFrame.x + invisibleFrame.w + _S(8), invisibleFrame.y + scaledYOff)
	self.exitButton:tieVisibilityTo(invisibleFrame)
	
	self.teamAssignmentButton = gui.create("EmployeeAssignmentModeButton")
	
	self.teamAssignmentButton:setSize(40, 40)
	self.teamAssignmentButton:setAssignmentMode(employeeAssignment.ASSIGNMENT_MODES.TEAMS)
	self.teamAssignmentButton:setIcon("new_team_assignment")
	self.teamAssignmentButton:setHoverIcon("new_team_assignment_hover")
	self.teamAssignmentButton:setPos(self.exitButton.x, self.exitButton.y + scaledYOff + self.exitButton.h)
	self.teamAssignmentButton:setHoverText(employeeAssignment.TEAM_ASSIGNMENT_TEXT)
	self.teamAssignmentButton:tieVisibilityTo(invisibleFrame)
	
	self.employeeAssignmentButton = gui.create("EmployeeAssignmentModeButton")
	
	self.employeeAssignmentButton:setSize(40, 40)
	self.employeeAssignmentButton:setAssignmentMode(employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES)
	self.employeeAssignmentButton:setIcon("new_employee_assignment")
	self.employeeAssignmentButton:setHoverIcon("new_employee_assignment_hover")
	self.employeeAssignmentButton:setPos(self.teamAssignmentButton.x, self.teamAssignmentButton.y + scaledYOff + self.teamAssignmentButton.h)
	self.employeeAssignmentButton:setHoverText(employeeAssignment.EMPLOYEE_ASSIGNMENT_TEXT)
	self.employeeAssignmentButton:tieVisibilityTo(invisibleFrame)
	
	self.assignmentBox = gui.create("AssignmentBox", invisibleFrame)
	
	self.assignmentBox:setSize(invisibleFrame.rawW, invisibleFrame.rawH)
	self.assignmentBox:fillWithElements()
	self.assignmentBox:addDepth(100)
	
	local roleScroller = self.assignmentBox:getScrollbarPanel()
	local list = game.createInvisibleRoleFilter(roleScroller, true, "new_hud")
	
	roleScroller:setRoleFilterList(list)
	self.assignmentBox:hide()
	
	self.teamAssignmentBox = gui.create("TeamAssignmentBox", invisibleFrame)
	
	self.teamAssignmentBox:setSize(invisibleFrame.rawW, invisibleFrame.rawH)
	self.teamAssignmentBox:fillWithElements()
	self.teamAssignmentBox:addDepth(100)
	self.teamAssignmentBox:hide()
	
	self.autoAssign = gui.create("AutoAssignButton")
	
	self.autoAssign:setSize(40, 40)
	self.autoAssign:setPos(self.employeeAssignmentButton.x, self.employeeAssignmentButton.y + scaledYOff + self.employeeAssignmentButton.h)
	self.autoAssign:tieVisibilityTo(self.assignmentBox)
	
	self.unassignmentButton = gui.create("UnassignEmployeesButton")
	
	self.unassignmentButton:setSize(40, 40)
	self.unassignmentButton:setPos(self.autoAssign.x, self.autoAssign.y + scaledYOff + self.autoAssign.h)
	self.unassignmentButton:tieVisibilityTo(self.assignmentBox)
	list:setPos(self.unassignmentButton.x, self.unassignmentButton.y + scaledYOff + self.unassignmentButton.h)
	objectSelector:reset()
	
	self.tileSpriteBatch = studio.expansion:getTileSpriteBatch()
	
	self.tileSpriteBatch:setVisible(true)
	game.hideHUD()
	
	self.gridFlicker = 0
	
	game.worldObject:enterAssignmentMode()
	autosave:addBlocker(self)
	self:setAssignmentMode(desiredMode or employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES)
	self:findWorkplaceObjects()
	priorityRenderer:add(self.tileSpriteBatch, studio.expansion.CONSTRUCTION_DEPTH)
	gameStateService:addState(self)
	
	if assignmentTarget then
		self:setAssignmentTarget(assignmentTarget)
	end
	
	self.descbox = gui.create("EmployeeAssignmentDescbox")
	
	self.descbox:setFrame(invisibleFrame)
	self.descbox:setYEdgePosition(_S(50))
	self.descbox:addDepth(10000)
	self.descbox:tieVisibilityTo(invisibleFrame)
	timeline:pause()
	frameController:push(invisibleFrame)
end

function employeeAssignment:leave()
	if not self.active then
		return false
	end
	
	self.active = false
	
	self:setAssignmentTarget(nil)
	self.assignmentBox:kill()
	
	self.assignmentBox = nil
	
	self.autoAssign:kill()
	
	self.autoAssign = nil
	
	self.descbox:kill()
	
	self.descbox = nil
	
	if self.assignmentResultsText and self.assignmentResultsText:isValid() then
		self.assignmentResultsText:kill()
		
		self.assignmentResultsText = nil
	end
	
	self.employeeAssignmentButton:kill()
	
	self.employeeAssignmentButton = nil
	
	self.teamAssignmentButton:kill()
	
	self.teamAssignmentButton = nil
	
	self.unassignmentButton:kill()
	
	self.unassignmentButton = nil
	
	self.exitButton:kill()
	
	self.exitButton = nil
	
	self.tileSpriteBatch:setVisible(false)
	studio.expansion:deallocateSprites(self.allocatedSprites)
	self:unhighlightBuildings()
	priorityRenderer:remove(self.tileSpriteBatch)
	gameStateService:removeState(self)
	table.clearArray(self.workplaceObjects)
	game.showHUD()
	
	self.gridFlicker = 0
	
	game.worldObject:leaveAssignmentMode()
	autosave:removeBlocker(self)
	frameController:pop()
	timeline:resume()
	
	return true
end

function employeeAssignment:update(dt)
	self.gridFlicker = self.gridFlicker + frameTime * 3
	
	if self.gridFlicker > math.tau then
		self.gridFlicker = self.gridFlicker - math.tau
	end
	
	self.gridFlickerSine = math.sin(self.gridFlicker)
end

function employeeAssignment:findWorkplaceObjects()
	for object, state in pairs(game.worldObject:getObjectRenderer():getVisibleObjects()) do
		if object.WORKPLACE and object:getOffice():isPlayerOwned() then
			self.workplaceObjects[#self.workplaceObjects + 1] = object
		end
	end
end

function employeeAssignment:filterAssignableWorkplaceObjects()
	for key, object in ipairs(self.workplaceObjects) do
		studio.expansion:allocateSpritesRaw(object:getUsedTileAmount(), self.allocatedSprites)
	end
end

function employeeAssignment:addWorkplaceObject(object)
	if not table.find(self.workplaceObjects, object) then
		table.insert(self.workplaceObjects, object)
		studio.expansion:allocateSpritesRaw(object:getUsedTileAmount(), self.allocatedSprites)
	end
end

function employeeAssignment:removeWorkplaceObject(object)
	if table.removeObject(self.workplaceObjects, object) then
		studio.expansion:deallocateSprites(self.allocatedSprites, object:getUsedTileAmount())
	end
end

function employeeAssignment:isActive()
	return self.active
end

function employeeAssignment:setAssignmentMode(mode)
	local prevMode = self.assignmentMode
	
	self.assignmentMode = mode
	
	self:setAssignmentTarget(nil)
	self:deallocateSprites()
	
	if mode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES then
		self.assignmentBox:show()
		self.teamAssignmentBox:hide()
		self:unhighlightBuildings()
	elseif mode == employeeAssignment.ASSIGNMENT_MODES.TEAMS then
		self.assignmentBox:hide()
		self.teamAssignmentBox:show()
	end
	
	if self.assignmentMode ~= prevMode then
		events:fire(employeeAssignment.EVENTS.ASSIGNMENT_MODE_CHANGED, self.assignmentMode)
	end
end

function employeeAssignment:getAssignmentMode()
	return self.assignmentMode
end

function employeeAssignment:unassignEmployee(target)
	local prevOffice = target:getOffice()
	
	target:setWorkplace(nil)
	events:fire(employeeAssignment.EVENTS.UNASSIGNED, target, prevOffice)
end

function employeeAssignment:unassignFromWorkplace(workplace, skipEvent)
	local employee = workplace:getAssignedEmployee()
	local prevOffice = employee:getOffice()
	
	workplace:unassignEmployee()
	workplace:verifyEmployeeTask(employee)
	
	if not skipEvent then
		events:fire(employeeAssignment.EVENTS.UNASSIGNED, employee, prevOffice)
	end
	
	self.workPlace = nil
end

function employeeAssignment:attemptAutoAssign(target)
	if employeeAssignment:assignEmployeeToFreeWorkplace(target, not game.startingNewGame) and not game.startingNewGame then
		target:placeOutsideOffice()
		target:goToWorkplace()
		
		local passedTime = timeline:getPassedTime()
		
		if passedTime >= self.nextGreet and #target:getOffice():getEmployees() > 1 then
			target:setShouldGreet(true)
			
			self.nextGreet = passedTime + employeeAssignment.GREET_DELAY
		end
	end
end

function employeeAssignment:getEmployeesWithoutWorkplace()
	local employees = studio:getEmployees()
	local employeeCount = #employees
	
	for key, employee in ipairs(employees) do
		if not employee:getWorkplace() then
			self.employeesWithoutWorkplace[#self.employeesWithoutWorkplace + 1] = employee
		end
	end
	
	return self.employeesWithoutWorkplace
end

function employeeAssignment:getWorkplaceCount(objectList)
	local total = 0
	
	for key, object in ipairs(objectList) do
		if self:isWorkplace(object) then
			total = total + 1
		end
	end
	
	return total
end

function employeeAssignment:getValidWorkplaceCount(objectList)
	local total = 0
	
	for key, object in ipairs(objectList) do
		if self:isValidWorkplace(object) then
			total = total + 1
		end
	end
	
	return total
end

function employeeAssignment:getStudioWorkplaceCount()
	local total = 0
	
	for key, officeObject in ipairs(studio:getOwnedBuildings()) do
		for key, object in ipairs(officeObject:getWorkplaces()) do
			if self:isValidWorkplace(object) then
				total = total + 1
			end
		end
	end
	
	return total
end

function employeeAssignment:getValidWorkplaces(objectList)
	table.clearArray(self.validWorkplaces)
	
	for key, object in ipairs(objectList) do
		if self:isValidWorkplace(object) then
			self.validWorkplaces[#self.validWorkplaces + 1] = object
		end
	end
	
	return self.validWorkplaces
end

function employeeAssignment:getValidStudioWorkplaces()
	table.clearArray(self.validWorkplaces)
	
	for key, officeObject in ipairs(studio:getOwnedBuildings()) do
		for key, object in ipairs(officeObject:getWorkplaces()) do
			if self:isValidWorkplace(object) then
				self.validWorkplaces[#self.validWorkplaces + 1] = object
			end
		end
	end
	
	return self.validWorkplaces
end

function employeeAssignment:isWorkplace(object)
	return object:getObjectType() == employeeAssignment.VALID_WORKPLACE_TYPE and object:isValidForWork()
end

function employeeAssignment:isValidWorkplace(object)
	return object:getObjectType() == employeeAssignment.VALID_WORKPLACE_TYPE and not object:getAssignedEmployee() and object:isValidForWork()
end

function employeeAssignment:assignEmployeesToFreeWorkplaces(objectList, employeeList)
	if studio._loading or studio._preventAssignment then
		return 
	end
	
	local employees = employeeList or self:getEmployeesWithoutWorkplace()
	local workplaces = self:getValidWorkplaces(objectList)
	local autoAssigned = 0
	
	self.blockAssignmentFiring = true
	
	for key, employee in ipairs(employees) do
		local validPlace = workplaces[#workplaces]
		
		if validPlace then
			self:assignEmployee(validPlace, employee)
			
			autoAssigned = autoAssigned + 1
			workplaces[#workplaces] = nil
		elseif employee:getTask() then
			employee:setTask(nil)
		end
	end
	
	self.blockAssignmentFiring = false
	
	events:fire(employeeAssignment.EVENTS.AUTO_ASSIGNED, employees, autoAssigned)
	table.clearArray(employees)
	
	return autoAssigned
end

function employeeAssignment:assignEmployeeToFreeWorkplace(employee, skipFacing)
	local workplaces = self:getValidStudioWorkplaces()
	local validPlace = workplaces[#workplaces]
	
	if validPlace then
		self:assignEmployee(validPlace, employee, skipFacing)
		
		return true
	end
	
	return false
end

eventBoxText:registerNew({
	id = "employee_without_workplace",
	getText = function(self, data)
		local text
		
		if data.playerCharacter then
			text = _T("PLAYER_CHARACTER", "Player character")
		else
			text = names:getFullName(data.name[1], data.name[2], data.name[3], data.name[4])
		end
		
		return _format(_T("EMPLOYEE_WITHOUT_WORKPLACE", "NAME has not been assigned to a workplace."), "NAME", text)
	end
})
eventBoxText:registerNew({
	id = "employees_without_workplaces",
	getText = function(self, data)
		if data.idleEmployees == data.totalEmployees then
			return _T("EVERYONE_WITHOUT_WORKPLACE", "All your employees are without a workplace.")
		else
			return _format(_T("SOME_WITHOUT_WORKPLACE", "EMPLOYEES of your employees are without a workplace."), "EMPLOYEES", data.idleEmployees)
		end
	end
})

function employeeAssignment:handleEvent(event, obj)
	if event == timeline.EVENTS.NEW_DAY then
		if timeline.curTime > self.botherTime then
			local employeeCount = #studio:getEmployees()
			
			self:getEmployeesWithoutWorkplace()
			
			local idleEmployeeCount = #self.employeesWithoutWorkplace
			
			if idleEmployeeCount > 0 then
				if idleEmployeeCount == 1 then
					local employee = self.employeesWithoutWorkplace[1]
					
					game.addToEventBox("employee_without_workplace", {
						name = {
							employee:getNameConfig()
						},
						playerCharacter = employee:isPlayerCharacter()
					}, 2)
				else
					game.addToEventBox("employees_without_workplaces", {
						idleEmployees = idleEmployeeCount,
						totalEmployees = employeeCount
					}, 4)
				end
				
				self.botherTime = timeline.curTime + employeeAssignment.botherDelay
			end
			
			table.clearArray(self.employeesWithoutWorkplace)
		end
	elseif event == officeBuilding.EVENTS.BECOME_VISIBLE then
		if self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.TEAMS and self:canHighlightBuilding(obj) then
			self:highlightBuilding(obj)
		end
	elseif event == officeBuilding.EVENTS.BECOME_INVISIBLE and self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.TEAMS and self:canHighlightBuilding(obj) then
		self:unhighlightBuilding(obj)
	end
end

function employeeAssignment:highlightBuildings()
	for key, obj in ipairs(studio:getOfficeBuildingMap():getVisibleBuildings()) do
		if self:canHighlightBuilding(obj) then
			self:highlightBuilding(obj)
		end
	end
end

function employeeAssignment:canHighlightBuilding(obj)
	if not obj:isPlayerOwned() then
		return false
	end
	
	return true
end

function employeeAssignment:highlightBuilding(obj)
	local spriteList = self.spritesByBuilding[obj]
	
	if not spriteList then
		spriteList = {}
		self.spritesByBuilding[obj] = spriteList
	end
	
	studio.expansion:allocateSpritesRaw(obj:getTileCount(), spriteList)
	table.insert(self.highlightedBuildings, obj)
	self:_highlightBuilding(obj)
end

function employeeAssignment:_highlightBuilding(obj)
	local container = self.tileSpriteBatch
	local expansion = studio.expansion
	local tileList = obj:getTiles()
	local spriteList = self.spritesByBuilding[obj]
	local grid = game.worldObject:getFloorTileGrid()
	local w, h = grid:getTileSize()
	local tileQuad = studio.expansion.purchasableTileQuad
	local index = 1
	local states = developer.ASSIGNMENT_STATE
	
	for key, index in ipairs(tileList) do
		local x, y = grid:convertIndexToCoordinates(index)
		local alpha = 200
		
		container:setColor(150, 255, 150, alpha)
		
		local spriteID = spriteList[key]
		
		container:updateSprite(spriteID, tileQuad, x * w - w, y * h - h, 0, 2, 2)
	end
end

function employeeAssignment:unhighlightBuildings()
	for key, building in ipairs(self.highlightedBuildings) do
		self:unhighlightBuilding(building, true)
	end
end

function employeeAssignment:unhighlightBuilding(obj, skipRemoval)
	local spriteList = self.spritesByBuilding[obj]
	
	if spriteList then
		studio.expansion:deallocateSprites(spriteList)
		
		if not skipRemoval then
			table.removeObject(self.highlightedBuildings, obj)
		end
	end
end

function employeeAssignment:createTeamUnassignmentPopup()
	local frame = gui.createGenericFrame()
	
	frame:setTitle(_T("SELECT_TEAM_TO_UNASSIGN_TITLE", "Select Team to Unassign"))
	frame:setSize(400, 600)
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(390, 560)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	
	for key, curTeam in ipairs(studio:getTeams()) do
		local TeamButton = gui.create("TeamUnassignmentButton")
		
		TeamButton:setFont(fonts.get("pix24"))
		TeamButton:setSize(360, 65)
		TeamButton:setBasePanel(frame)
		TeamButton:setTeam(curTeam)
		TeamButton:setThoroughDescription(true)
		TeamButton:updateDescbox()
		
		TeamButton.descboxID = game.TEAM_MANAGEMENT_DESCBOX_ID
		
		scrollbar:addItem(TeamButton)
	end
	
	frame:center()
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(game.TEAM_MANAGEMENT_DESCBOX_ID)
	teamDescbox:tieVisibilityTo(frame)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	frameController:push(frame)
end

function employeeAssignment:createOfficeUnassignmentPopup()
	local frame = gui.createGenericFrame()
	
	frame:setTitle(_T("SELECT_OFFICE_TO_UNASSIGN_TITLE", "Select Office to Unassign"))
	frame:setSize(400, 600)
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(390, 560)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	
	for key, officeObject in ipairs(studio:getOwnedBuildings()) do
		local officeSelection = gui.create("OfficeUnassignmentButton")
		
		officeSelection:setOffice(officeObject)
		scrollbar:addItem(officeSelection)
	end
	
	frame:center()
	frameController:push(frame)
end

function employeeAssignment:setAssignmentTarget(target)
	self.assignmentTarget = target
	
	if not target then
		if self.assignmentText then
			self.assignmentText:kill()
			
			self.assignmentText = nil
		end
		
		if self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES then
			events:fire(employeeAssignment.EVENTS.DESELECTED)
		elseif self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.TEAMS then
			events:fire(employeeAssignment.EVENTS.DESELECTED_TEAM)
			self:unhighlightBuildings()
		end
	elseif self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES then
		self:filterAssignableWorkplaceObjects()
		self:setAssignmentText(string.easyformatbykeys(_T("ASSIGNING_TARGET", "Assigning NAME"), "NAME", target:getFullName(true)))
		events:fire(employeeAssignment.EVENTS.SELECTED)
	elseif self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.TEAMS then
		self:setAssignmentText(string.easyformatbykeys(_T("ASSIGNING_TEAM", "Assigning 'TEAM'"), "TEAM", target:getName()))
		events:fire(employeeAssignment.EVENTS.SELECTED_TEAM)
		self:highlightBuildings()
	end
end

function employeeAssignment:setAssignmentText(text)
	self:verifyAssignmentText()
	self.assignmentText:setText(text)
	self.assignmentText:centerX()
	self.assignmentText:setY(scrH * 0.5 + _S(100))
	self.assignmentText:setDisplayTime(nil)
	self.assignmentText:setAlpha(255)
end

function employeeAssignment:getAssignmentTarget()
	return self.assignmentTarget
end

function employeeAssignment:verifyAssignmentText()
	if not self.assignmentText then
		self.assignmentText = gui.create("GenericBorderedTextDisplay")
		
		self.assignmentText:setFont(fonts.get("pix28"))
		self.assignmentText:addDepth(10000)
	end
end

function employeeAssignment:handleKeyPress(key, isrepeat)
	if not self.active then
		return false
	end
end

function employeeAssignment:assignEmployee(workplace, target, skipFacing)
	if target:getWorkplace() then
		target:getWorkplace():unassignEmployee()
	end
	
	workplace:assignEmployee(target, skipFacing)
	
	if self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES then
		self.workPlace = nil
		
		self:setAssignmentTarget(nil)
		
		if not self.blockAssignmentFiring then
			events:fire(employeeAssignment.EVENTS.ASSIGNED, target)
		end
		
		self:deallocateSprites()
	end
end

local teamEmployeesToAssign = {
	noWorkplace = {},
	workplace = {}
}

function employeeAssignment:assignTeamToOffice(teamObject, buildingObject)
	local workplaces = buildingObject:getWorkplaces()
	local workplaceCount = self:getValidWorkplaceCount(workplaces)
	local employeesWithNoWorkplace = 0
	
	for key, employee in ipairs(teamObject:getMembers()) do
		if employeesWithNoWorkplace < workplaceCount then
			if employee:getWorkplace() then
				self:unassignEmployee(employee)
				table.insert(teamEmployeesToAssign.workplace, employee)
				
				employeesWithNoWorkplace = employeesWithNoWorkplace + 1
			else
				table.insert(teamEmployeesToAssign.noWorkplace, employee)
				
				employeesWithNoWorkplace = employeesWithNoWorkplace + 1
			end
		else
			break
		end
	end
	
	local assignedEmployees = 0
	
	if #teamEmployeesToAssign.noWorkplace > 0 then
		assignedEmployees = assignedEmployees + self:assignEmployeesToFreeWorkplaces(workplaces, teamEmployeesToAssign.noWorkplace)
		
		self:setAssignmentTarget(nil)
	end
	
	if #teamEmployeesToAssign.workplace > 0 then
		assignedEmployees = assignedEmployees + self:assignEmployeesToFreeWorkplaces(workplaces, teamEmployeesToAssign.workplace)
	end
	
	if #teamEmployeesToAssign.noWorkplace > 0 or #teamEmployeesToAssign.workplace > 0 then
		self:setAssignmentTarget(nil)
		events:fire(employeeAssignment.EVENTS.ASSIGNED_TEAM, teamObject, buildingObject)
	end
	
	if self.assignmentResultsText and self.assignmentResultsText:isValid() then
		self.assignmentResultsText:removeAllText()
		self.assignmentResultsText:resetAlpha()
	else
		self.assignmentResultsText = gui.create("TimedTextDisplay")
	end
	
	local assignmentText = self.assignmentResultsText
	local text
	
	if assignedEmployees == 0 then
		text = _T("ASSIGNED_NO_MEMBERS_TO_WORKPLACES", "Assigned 0 team members to workplaces")
	elseif assignedEmployees == 1 then
		text = _T("ASSIGNED_ONE_MEMBER_TO_WORKPLACE", "Assigned 1 team member to a workplace")
	else
		text = _format(_T("ASSIGNED_TEAM_MEMBERS_COUNT", "Assigned AMOUNT team members to workplaces"), "AMOUNT", assignedEmployees)
	end
	
	assignmentText:addText(text, "bh20", game.UI_COLORS.LIGHT_BLUE, 0, 400, "exclamation_point", 24, 24)
	assignmentText:setDieTime(2.3)
	assignmentText:centerX()
	assignmentText:setY(scrH * 0.5 - assignmentText.h - _S(100))
	table.clearArray(teamEmployeesToAssign.noWorkplace)
	table.clearArray(teamEmployeesToAssign.workplace)
end

function employeeAssignment:handleClick(x, y, key, xVel, yVel)
	if not self.active then
		return false
	end
	
	if yVel ~= 0 then
		return false
	end
	
	local objectGrid = game.worldObject:getObjectGrid()
	local gridX, gridY = objectGrid:getMouseTileCoordinates()
	
	if self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES then
		if self.assignmentTarget then
			if key == gui.mouseKeys.LEFT then
				local workPlace, availability = self.assignmentTarget:getFreeWorkplace(gridX, gridY, camera:getViewFloor())
				
				if workPlace and availability == developer.ASSIGNMENT_STATE.CAN then
					self:assignEmployee(workPlace, self.assignmentTarget)
				end
			elseif key == gui.mouseKeys.RIGHT then
				self:setAssignmentTarget(nil)
				self:deallocateSprites()
			end
		elseif key == gui.mouseKeys.RIGHT then
			local object = game.getObjectAtMousePos()
			
			if object then
				if object.class ~= "developer" and object:getObjectType() == "desk" then
					local employee = object:getAssignedEmployee()
					
					if employee then
						self:unassignFromWorkplace(object)
					end
				elseif object.class == "developer" then
					local workplace = object:getWorkplace()
					
					if workplace then
						self:unassignFromWorkplace(workplace)
					else
						self:setAssignmentTarget(object)
					end
				end
			end
		elseif key == gui.mouseKeys.LEFT then
			local object = game.getObjectAtMousePos()
			
			if object and object.class == "developer" then
				self:setAssignmentTarget(object)
			end
		end
	elseif self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.TEAMS then
		if self.assignmentTarget then
			if key == gui.mouseKeys.LEFT then
				local office = studio:getOfficeAtIndex(objectGrid:getTileIndex(gridX, gridY))
				
				if office and office:isPlayerOwned() then
					self:assignTeamToOffice(self.assignmentTarget, office)
				end
			elseif key == gui.mouseKeys.RIGHT and self.assignmentTarget then
				self:setAssignmentTarget(nil)
				self:deallocateSprites()
			end
		elseif key == gui.mouseKeys.LEFT then
			local object = game.getObjectAtMousePos()
			
			if object and object.class == "developer" then
				local team = object:getTeam()
				
				if team then
					self:setAssignmentTarget(team)
				end
			end
		end
	end
	
	return true
end

function employeeAssignment:unassignEveryone()
	for key, employee in ipairs(studio:getEmployees()) do
		local workplace = employee:getWorkplace()
		
		if workplace then
			self:unassignFromWorkplace(workplace, true)
		end
	end
	
	events:fire(employeeAssignment.EVENTS.UNASSIGNED_EVERYONE)
end

function employeeAssignment:deallocateSprites()
	if #self.allocatedSprites > 0 then
		studio.expansion:deallocateSprites(self.allocatedSprites)
	end
end

function employeeAssignment:draw()
	if self.active then
		game.performMouseOverOffice(game.worldObject:getFloorTileGrid())
		
		if self.assignmentTarget and self.assignmentMode == employeeAssignment.ASSIGNMENT_MODES.EMPLOYEES and #self.workplaceObjects > 0 then
			local container = self.tileSpriteBatch
			local spriteBatch = container.spriteBatch
			local expansion = studio.expansion
			local objectGrid = game.worldObject:getObjectGrid()
			local w, h = objectGrid:getTileSize()
			local tileQuad = studio.expansion.purchasableTileQuad
			local flickerAlpha = 150 + employeeAssignment.flickerAlpha * self.gridFlickerSine
			local index = 1
			local states = developer.ASSIGNMENT_STATE
			
			for key, object in ipairs(self.workplaceObjects) do
				local xStart, yStart, xFinish, yFinish = object:getPositionIterationRange()
				local availability = self.assignmentTarget:getAssignmentState(object)
				local alpha = object:isMouseOver() and 255 or flickerAlpha
				
				if availability == states.CAN then
					container:setColor(150, 255, 150, alpha)
				elseif availability == states.CANT then
					container:setColor(255, 150, 150, alpha)
				elseif availability == states.SAME_DESK then
					container:setColor(255, 225, 117, alpha)
				end
				
				for y = yStart, yFinish do
					for x = xStart, xFinish do
						local spriteID = self.allocatedSprites[index]
						
						container:updateSprite(spriteID, tileQuad, x * w - w, y * h - h, 0, 2, 2)
						
						index = index + 1
					end
				end
			end
		end
	end
end

employeeAssignment:init()
