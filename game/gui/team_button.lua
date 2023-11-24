local function assignTeamToOffice(self)
	employeeAssignment:enter(self.team, employeeAssignment.ASSIGNMENT_MODES.TEAMS)
end

local function dismantleTeam(self)
	game.openDismantlingMenu(self.team)
end

local function manageTeam(self)
	game.openTeamManagementMenu(self.tree.teamButton:getTeam())
end

local function practiceSkills(self)
	local button = self.tree.teamButton
	local team = button:getTeam()
	
	team:assignPracticeToIdlingEmployees()
	
	for key, member in ipairs(team:getMembers()) do
		if not member:getTask() then
			member:practiceMainSkill()
		end
	end
end

local function renameTeam(self)
	local button = self.tree.teamButton
	local team = button:getTeam()
	
	team:createNamingPopup()
end

local function moveMembers(self)
	local button = self.tree.teamButton
	local team = button:getTeam()
	
	team:createMemberMoveTeamSelectionPopup()
end

local function assignManager(self)
	local team = self.tree.teamButton:getTeam()
	
	team:setManager(self.manager)
	self.tree.teamButton:highlight(true)
end

local function unassignManager(self)
	local team = self.tree.teamButton:getTeam()
	
	team:setManager(nil)
	self.tree.teamButton:highlight(false)
end

local teamButton = {}

teamButton.highlightedColor = color(211, 234, 178, 255)
teamButton.unhighlightedColor = color(80, 80, 80, 255)
teamButton.descboxID = game.TEAM_INFO_DESCBOX
teamButton.CATCHABLE_EVENTS = {
	team.EVENTS.NAME_CHANGED,
	team.EVENTS.CHANGED,
	team.EVENTS.CHANGED
}

function teamButton:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(50)
	self.descriptionBox:setPos(0, _S(3))
	self.descriptionBox:setFadeInSpeed(0)
	self:highlight(false)
end

function teamButton:handleEvent(event, data)
	if data == self.team then
		if event == team.EVENTS.CHANGED then
			self.requiresUpdate = true
		elseif event == team.EVENTS.NAME_CHANGED or event == team.EVENTS.CHANGED then
			self:updateDescbox()
		end
	end
end

function teamButton:onShow()
	if self.requiresUpdate then
		self:updateDescbox()
	end
end

function teamButton:updateDescbox()
	if not self.team then
		return 
	end
	
	self.descriptionBox:removeAllText()
	
	local wrapW = self.rawW - 20
	local lineWidth = self.w - _S(10)
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.team:getName(), "pix24", nil, 5, wrapW)
	
	local memberText = self.team:getMemberCountText(#self.team:getMembers())
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, _S(26), "weak_gradient_horizontal")
	self.descriptionBox:addText(memberText, "pix24", nil, 3, wrapW, "employees", 24, 24)
	
	if self.thoroughDescription then
		local lineHeight = _S(24)
		local projObj = self.team:getProject()
		
		self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, lineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("CURRENT_PROJECT", "Project: PROJECT"), "PROJECT", projObj and projObj:getName() or _T("NA", "N/A")), "bh22", nil, 3, wrapW, "project_stuff", 24, 24)
		
		local manager = self.team:getManager()
		
		self.descriptionBox:addTextLine(lineWidth, manager and game.UI_COLORS.YELLOW or game.UI_COLORS.ORANGE, lineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("CURRENT_MANAGER", "Manager: MANAGER"), "MANAGER", manager and manager:getFullName(true) or _T("NONE", "None")), "bh22", nil, 0, wrapW, "employee", 24, 24)
	end
	
	self:setHeight(_US(self.descriptionBox:getHeight()) + 2)
end

function teamButton:highlight(state)
	self.highlighted = state
	self.panelColor = state and teamButton.highlightedColor or teamButton.unhighlightedColor
	
	self:updateDescbox()
end

function teamButton:setTeam(teamObj)
	self.team = teamObj
	
	if self:hasComboBoxOption("assignmanager") then
		self:highlight(self.team:getManager() == self.manager)
	end
end

function teamButton:getTeam()
	return self.team
end

function teamButton:onMouseEntered()
	teamButton.baseClass.onMouseEntered(self)
	
	local element = gui:getElementByID(self.descboxID)
	
	element:showDisplay(self.team)
end

function teamButton:setTeamInfoDescboxID(id)
	self.descboxID = id
end

function teamButton:onMouseLeft()
	teamButton.baseClass.onMouseLeft(self)
	gui:getElementByID(self.descboxID):hideDisplay()
end

function teamButton:setThoroughDescription(state)
	self.thoroughDescription = state
end

function teamButton:fillInteractionComboBox(comboBox)
	comboBox:setAutoCloseTime(0.5)
	
	if self:hasComboBoxOption("manage") then
		comboBox:addOption(0, 0, 150, 18, _T("MANAGE_TEAM", "Manage team"), fonts.get("pix20"), manageTeam)
	end
	
	if self:hasComboBoxOption("practice") then
		comboBox:addOption(0, 0, 0, 0, _T("TEAM_PRACTICE_SKILLS", "Practice skills"), fonts.get("pix20"), practiceSkills)
	end
	
	if self:hasComboBoxOption("rename") then
		comboBox:addOption(0, 0, 0, 0, _T("RENAME_TEAM", "Rename team"), fonts.get("pix20"), renameTeam)
	end
	
	if self:hasComboBoxOption("move_to_another_team") and #self.team:getMembers() > 0 and #studio:getTeams() > 1 then
		comboBox:addOption(0, 0, 0, 0, _T("MOVE_TO_ANOTHER_TEAM", "Move to another team..."), fonts.get("pix20"), moveMembers)
	end
	
	if self:hasComboBoxOption("assignmanager") then
		local option
		
		if self.team:getManager() == self.manager then
			option = comboBox:addOption(0, 0, 150, 18, _T("UNASSIGN_MANAGER", "Unassign manager"), fonts.get("pix20"), unassignManager)
		else
			option = comboBox:addOption(0, 0, 150, 18, _T("ASSIGN_MANAGER_TO_TEAM", "Assign manager to team"), fonts.get("pix20"), assignManager)
		end
		
		option.manager = self.manager
	end
	
	if self:hasComboBoxOption("assigntooffice") then
		comboBox:addOption(0, 0, 150, 18, _T("ASSIGN_TEAM_TO_OFFICE", "Assign team to office"), fonts.get("pix20"), assignTeamToOffice).team = self.team
	end
	
	if self:hasComboBoxOption("dismantle") and self.team:canDismantle() then
		comboBox:addOption(0, 0, 150, 18, _T("DISMANTLE_TEAM", "Dismantle team"), fonts.get("pix20"), dismantleTeam).team = self.team
	end
	
	comboBox.teamButton = self
end

function teamButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - _S(20), y - _S(10), true)
end

function teamButton:draw(w, h)
end

gui.register("TeamButton", teamButton, "ComboBoxOptionBuffer")
