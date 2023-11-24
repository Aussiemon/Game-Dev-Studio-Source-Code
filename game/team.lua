team = {}
team.mtindex = {
	__index = team
}
team.TEAMWORK_SKILL_MIN_LEVEL = 30
team.TEAMWORK_MAXIMUM_PENALTY = 0.8
team.TEAMWORK_MAXIMUM_BOOST = 1.2
team.TEAMWORK_CHARISMA_BOOST = 0.25
team.INTER_OFFICE_BASE_PENALTY = 0.05
team.INTER_OFFICE_PENALTY_PER_OFFICE = 0.02
team.INTER_OFFICE_PENALTY_MAX = 0.6
team.INTER_OFFICE_PENALTY_PER_EMPLOYEE = 0.007
team.STUDIO_KNOWLEDGE_CONTRIBUTION = 0.25
team.MEMBER_KNOWLEDGE_CONTRIBUTION = 0.75
team.BOOST_INC_OFFSET = 7
team.BOOST_INC_EXP = 0.6
team.BOOST_INC_MULT = 0.8
team.HARDWARE_PING_COOLDOWN = 2
team.EVENTS = {
	MANAGER_ASSIGNED = events:new(),
	MANAGER_UNASSIGNED = events:new(),
	MEMBER_ADDED = events:new(),
	MEMBER_REMOVED = events:new(),
	CHANGED = events:new(),
	NAME_CHANGED = events:new(),
	UNASSIGNED_TEAM_FROM_WORKPLACES = events:new()
}

function team.new()
	local new = {}
	
	setmetatable(new, team.mtindex)
	new:init()
	
	return new
end

function team:init()
	self.members = {}
	self.membersByObjects = {}
	self.memberRoleCount = {}
	self.totalStats = {}
	self.totalKnowledge = {}
	self.memberKnowledge = {}
	
	for key, data in ipairs(knowledge.registered) do
		self.memberKnowledge[data.id] = 0
	end
	
	self.totalAttributes = {}
	self.highestStats = {}
	self.lowestStats = {}
	self.employeeDevSpeedBoosts = {}
	self.activeDevSpeedBoosts = {}
	self.realDevSpeedBoosts = {}
	self.recentlyFinishedEmployees = {}
	self.membersBySpec = {}
	
	for key, specData in ipairs(attributes.profiler.specializations) do
		self.membersBySpec[specData.id] = {}
	end
	
	self.busyEmployees = {}
	self.dismantleable = true
	self.paychecks = 0
	self.hardwareNotifyCooldown = 0
	self.employeeNotifyCooldown = 0
	self.interOfficeMultiplier = 1
	self.totalHighestStats = 0
	
	for key, data in ipairs(skills.registered) do
		self.totalStats[data.id] = 0
		self.highestStats[data.id] = 0
		self.lowestStats[data.id] = 0
		self.employeeDevSpeedBoosts[data.id] = 0
		self.activeDevSpeedBoosts[data.id] = 0
	end
	
	self:updateManagementBoost()
	self:initEventReceiver()
end

team.memberFormatFuncs = {}
team.memberFormatFuncs.ru = {
	plural = function(amount)
		return translation.conjugateRussianText(amount, "%s членов", "%s члена", "%s член")
	end
}

function team:getMemberCountText(amt)
	local methods = team.memberFormatFuncs[translation.currentLanguage]
	
	if amt == 0 then
		return _T("NO_TEAM_MEMBERS", "No members")
	elseif amt == 1 then
		return _T("ONE_TEAM_MEMBER", "1 member")
	elseif methods and methods.plural then
		return methods.plural(amt)
	else
		return _format(_T("MULTIPLE_TEAM_MEMBER", "MEMBERS members"), "MEMBERS", amt)
	end
end

function team:initEventReceiver()
	events:addDirectReceiver(self, team.CATCHABLE_EVENTS)
	events:addFunctionReceiver(self, self.handleObjectUpgrade, objects.getClassData("progressing_object_base").EVENTS.UPGRADED_OBJECT)
	events:addFunctionReceiver(self, self.handleObjectUpgrades, objects.getClassData("progressing_object_base").EVENTS.UPGRADED_ALL)
	events:addFunctionReceiver(self, self.handleNewTimeline, timeline.EVENTS.NEW_TIMELINE)
end

function team:removeEventReceiver()
	events:removeDirectReceiver(self, team.CATCHABLE_EVENTS)
	events:removeFunctionReceiver(self, objects.getClassData("progressing_object_base").EVENTS.UPGRADED_ALL)
	events:removeFunctionReceiver(self, objects.getClassData("progressing_object_base").EVENTS.UPGRADED_OBJECT)
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_TIMELINE)
end

function team:setName(name)
	self.name = name
	
	events:fire(team.EVENTS.NAME_CHANGED, self)
end

function team:getTotalHighestSkillLevel()
	return self.totalHighestStats
end

function team:setUniqueID(id)
	if self.uniqueID then
		error("attempt to set team unique ID while there is one set already!")
	end
	
	self.uniqueID = id
end

function team:getUniqueID()
	return self.uniqueID
end

function team:assignUniqueID()
	if self.uniqueID then
		error("attempt to assign team unique ID while there is one assigned already!")
		
		return 
	end
	
	self.uniqueID = game.assignUniqueTeamID()
end

function team:setManager(manager)
	if self.manager and self.manager ~= manager then
		self.manager:removeManagedTeam(self)
		events:fire(team.EVENTS.MANAGER_UNASSIGNED, self)
	end
	
	self.manager = manager
	
	if manager then
		manager:addManagedTeam(self)
		events:fire(team.EVENTS.MANAGER_ASSIGNED, self)
	end
	
	self:updateManagementBoost()
end

function team:createNamingPopup()
	local frame = gui.create("Frame")
	
	frame:setAnimated(false)
	frame:setSize(380, 105)
	frame:setFont("pix24")
	frame:setTitle(_T("ENTER_TEAM_NAME_TITLE", "Enter Team Name"))
	frame:hideCloseButton()
	
	local textbox = gui.create("TextBox", frame)
	
	textbox:setPos(_S(5), _S(35))
	textbox:setFont("pix24")
	textbox:setGhostText(_T("ENTER_TEAM_NAME", "Enter team name"))
	textbox:setText(self.name)
	textbox:setShouldCenter(true)
	textbox:setLimitTextToWidth(true)
	textbox:setSize(370, 30)
	
	local confirm = gui.create("ConfirmTeamNameButton", frame)
	
	confirm:setPos(_S(5), textbox.y + textbox.h + _S(5))
	confirm:setText(_T("CONFIRM_TEAM_NAME", "Confirm team name"))
	confirm:setFont("pix26")
	confirm:setSize(370, 30)
	confirm:setTextBox(textbox)
	confirm:setTeam(self)
	frame:center()
	frameController:push(frame)
end

team.MOVE_MEMBER_DESCBOX_ID = "move_member_descbox_id"

function team:createMemberMoveTeamSelectionPopup()
	local frame = gui.create("Frame")
	
	frame:setAnimated(false)
	frame:setSize(400, 500)
	frame:setFont("pix24")
	frame:setTitle(_T("SELECT_TARGET_TEAM", "Select Target Team"))
	
	local scroll = gui.create("ScrollbarPanel", frame)
	
	scroll:setPos(_S(5), _S(35))
	scroll:setSize(390, 460)
	scroll:setPadding(3, 3)
	scroll:setSpacing(3)
	scroll:setAdjustElementPosition(true)
	scroll:addDepth(100)
	
	local curTeams = gui.create("Category")
	
	curTeams:setFont(fonts.get("pix24"))
	curTeams:setText(_T("ALL_TEAMS", "All teams"))
	curTeams:setWidth(360)
	curTeams:assumeScrollbar(scroll)
	scroll:addItem(curTeams)
	
	local descboxID = team.MOVE_MEMBER_DESCBOX_ID
	
	for key, teamObj in ipairs(studio:getTeams()) do
		if teamObj ~= self then
			local element = gui.create("TeamMoveSelection")
			
			element:setTargetTeam(self)
			element:setSize(360, 65)
			element:setBasePanel(frame)
			element:setTeamInfoDescboxID(descboxID)
			element:setTeam(teamObj)
			element:setThoroughDescription(true)
			element:updateDescbox()
			curTeams:addItem(element)
		end
	end
	
	frame:center()
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(descboxID)
	teamDescbox:tieVisibilityTo(frame)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	frameController:push(frame)
end

function team:createMemberMovePopup(teamObj)
	local frame = gui.create("Frame")
	
	frame:setAnimated(false)
	frame:setSize(450, 600)
	frame:setFont("pix24")
	frame:setTitle(_T("TEAM_MANAGEMENT_TITLE", "Team Management"))
	frame:center()
	
	local infoDescbox = gui.create("EmployeeStatsOverview")
	
	infoDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	infoDescbox:tieVisibilityTo(frame)
	infoDescbox:hide()
	
	local panelScroll = gui.create("RoleScrollbarPanel", frame)
	
	panelScroll:setPos(_S(5), _S(35))
	panelScroll:setSize(440, 560)
	panelScroll:setAdjustElementPosition(true)
	panelScroll:setPadding(3, 3)
	panelScroll:addDepth(100)
	
	local list = game.createRoleFilter(panelScroll, true)
	
	list:setPos(frame.x - list.w - _S(10), frame.y)
	panelScroll:setRoleFilterList(list)
	
	local ourMembers = gui.create("Category")
	
	ourMembers:setSize(440, 20)
	ourMembers:setFont(fonts.get("pix24"))
	ourMembers:setText(_format(_T("TEAM_MEMBERS_FORMAT_LAYOUT", "Team 'TEAM' members"), "TEAM", self.name))
	
	ourMembers.teamObj = self
	
	ourMembers:assumeScrollbar(panelScroll)
	panelScroll:addItem(ourMembers)
	
	local fontObj = fonts.get("pix20")
	
	for key, member in ipairs(self.members) do
		local moveButton = gui.create("EmployeeMoveButton")
		
		moveButton:setTeams(self, teamObj)
		moveButton:setFont(fontObj)
		moveButton:setSize(410, 40)
		moveButton:setShortDescription(true)
		moveButton:setEmployee(member)
		moveButton:setInfoDescbox(infoDescbox)
		ourMembers:addItem(moveButton)
		panelScroll:addEmployeeItem(moveButton, true)
	end
	
	local theirMembers = gui.create("Category")
	
	theirMembers:setSize(440, 20)
	theirMembers:setFont(fonts.get("pix24"))
	theirMembers:setText(_format(_T("TEAM_MEMBERS_FORMAT_LAYOUT", "Team 'TEAM' members"), "TEAM", teamObj:getName()))
	
	theirMembers.teamObj = teamObj
	
	theirMembers:assumeScrollbar(panelScroll)
	panelScroll:addItem(theirMembers)
	
	for key, member in ipairs(teamObj:getMembers()) do
		local moveButton = gui.create("EmployeeMoveButton")
		
		moveButton:setTeams(self, teamObj)
		moveButton:setFont(fontObj)
		moveButton:setSize(410, 40)
		moveButton:setShortDescription(true)
		moveButton:setEmployee(member)
		moveButton:setInfoDescbox(infoDescbox)
		theirMembers:addItem(moveButton)
		panelScroll:addEmployeeItem(moveButton, true)
	end
	
	frameController:push(frame)
end

function team:getManager()
	return self.manager
end

function team:remove()
	self:removeEventReceiver()
	table.clear(self.busyEmployees)
end

function team:getOverallEfficiency()
	return self.managementBoost * self.interOfficeMultiplier
end

function team:getManagementBoost()
	return self.managementBoost
end

function team:calculateManagementBoost()
	if not self.manager or not self.manager:isAvailable() then
		return 1
	end
	
	return self.manager:getManagementBoost()
end

function team:updateManagementBoost()
	self.managementBoost = self:calculateManagementBoost()
end

function team:onEmployeeAway(employee)
	self:updateManagementBoost()
	self:updateTaskProgressAmount()
end

function team:onEmployeeReturned(employee)
	self:updateManagementBoost()
	self:updateTaskProgressAmount()
	self:assignFreeEmployees()
end

function team:getAvailableManager()
	if self.manager and self.manager:isAvailable() then
		return self.manager
	end
	
	return nil
end

function team:getName()
	return self.name
end

function team:setCanDismantle(state)
	self.dismantleable = state
end

function team:getTeamworkDevSpeedAffector()
	return self.teamworkDevSpeedAffector
end

function team:getBaseCharismaTeamworkAffector(charismaLevel)
	return team.TEAMWORK_CHARISMA_BOOST * (charismaLevel / attributes:getData("charisma").maxLevel)
end

function team:getCharismaTeamworkAffector(charismaLevel)
	return 1 + self:getBaseCharismaTeamworkAffector(charismaLevel)
end

function team:calculateTeamworkDevSpeedAffector()
	local members = self.members
	local memberCount = #self.members
	
	if memberCount <= 1 then
		return 1
	elseif self.totalStats.teamwork == 0 then
		return team.TEAMWORK_MAXIMUM_PENALTY * self:getCharismaTeamworkAffector(self.totalAttributes.charisma / #self.members)
	end
	
	local totalTeamwork = self.totalStats.teamwork / memberCount
	local finalBoost = 1
	
	if totalTeamwork < team.TEAMWORK_SKILL_MIN_LEVEL then
		finalBoost = math.lerp(team.TEAMWORK_MAXIMUM_PENALTY, 1, totalTeamwork / team.TEAMWORK_SKILL_MIN_LEVEL)
	else
		finalBoost = math.lerp(1, team.TEAMWORK_MAXIMUM_BOOST, (totalTeamwork - team.TEAMWORK_SKILL_MIN_LEVEL) / (skills.DEFAULT_MAX - team.TEAMWORK_SKILL_MIN_LEVEL))
	end
	
	return finalBoost * self:getCharismaTeamworkAffector(self.totalAttributes.charisma / #self.members)
end

function team:getEfficiencyScore()
	local score = 0
	
	for statID, level in pairs(self.totalStats) do
		score = score + level
	end
	
	return score * self:getOverallEfficiency()
end

function team:buildSkillDevSpeedAffectors()
	for key, employee in ipairs(self.members) do
		local task = employee:getTask()
		
		if employee:isAvailable() and (task and task:canCrossContribute() or not task) then
			self:addBothSkillDevSpeedAffectors(employee)
		else
			self:addSkillDevSpeedAffectors(employee, self.employeeDevSpeedBoosts)
		end
	end
end

function team:onEmployeeTaskChanged(employee, newTask)
	if newTask then
		if employee:isAvailable() and newTask:canCrossContribute() then
			if self.busyEmployees[employee] then
				self.busyEmployees[employee] = nil
				
				self:addSkillDevSpeedAffectors(employee, self.activeDevSpeedBoosts)
			end
		elseif not self.busyEmployees[employee] then
			self.busyEmployees[employee] = true
			
			self:removeSkillDevSpeedAffectors(employee, self.activeDevSpeedBoosts)
		end
	elseif employee:isAvailable() then
		if self.busyEmployees[employee] then
			self.busyEmployees[employee] = nil
			
			self:addSkillDevSpeedAffectors(employee, self.activeDevSpeedBoosts)
		end
	elseif not self.busyEmployees[employee] then
		self.busyEmployees[employee] = true
		
		self:removeSkillDevSpeedAffectors(employee, self.activeDevSpeedBoosts)
	end
end

function team:removeSkillDevSpeedAffectors(employee, boostList)
	local realDevBoosts = self.realDevSpeedBoosts
	
	for skillID, boost in pairs(employee:getDevSpeedBoosts()) do
		local newVal = boostList[skillID] - (boost - 1)
		
		boostList[skillID] = newVal
		realDevBoosts[skillID] = self:getRealDevSpeedBoost(newVal)
	end
end

function team:addSkillDevSpeedAffectors(employee, boostList)
	local realDevBoosts = self.realDevSpeedBoosts
	
	for skillID, boost in pairs(employee:getDevSpeedBoosts()) do
		local newVal = boostList[skillID] + (boost - 1)
		
		boostList[skillID] = newVal
		realDevBoosts[skillID] = self:getRealDevSpeedBoost(newVal)
	end
end

function team:getRealDevSpeedBoost(value)
	local offset = team.BOOST_INC_OFFSET
	
	if value <= offset then
		return value
	end
	
	local offVal = math.max(0, value - offset)
	
	return math.min(value, offset) + offVal^team.BOOST_INC_EXP * team.BOOST_INC_MULT
end

function team:removeBothSkillDevSpeedAffectors(employee)
	local boosts = employee:getDevSpeedBoosts()
	
	for key, skillData in ipairs(skills.registered) do
		local skillID = skillData.id
		local boost = boosts[skillID]
		
		self.employeeDevSpeedBoosts[skillID] = self.employeeDevSpeedBoosts[skillID] - (boost - 1)
		
		if not self.busyEmployees[employee] then
			local newVal = self.activeDevSpeedBoosts[skillID] - (boost - 1)
			
			self.activeDevSpeedBoosts[skillID] = newVal
			self.realDevSpeedBoosts[skillID] = self:getRealDevSpeedBoost(newVal)
		end
	end
end

function team:addBothSkillDevSpeedAffectors(employee)
	local boosts = employee:getDevSpeedBoosts()
	
	for key, skillData in ipairs(skills.registered) do
		local skillID = skillData.id
		local boost = boosts[skillID]
		
		self.employeeDevSpeedBoosts[skillID] = self.employeeDevSpeedBoosts[skillID] + (boost - 1)
		
		if not self.busyEmployees[employee] then
			local newVal = self.activeDevSpeedBoosts[skillID] + (boost - 1)
			
			self.activeDevSpeedBoosts[skillID] = newVal
			self.realDevSpeedBoosts[skillID] = self:getRealDevSpeedBoost(newVal)
		end
	end
end

function team:removeSkillDevSpeedAffector(employee, skillID)
	local boost = employee:getSkillDevBoost(skillID) - 1
	
	if not self.busyEmployees[employee] then
		local newVal = self.activeDevSpeedBoosts[skillID] - boost
		
		self.activeDevSpeedBoosts[skillID] = newVal
		self.realDevSpeedBoosts[skillID] = self:getRealDevSpeedBoost(newVal)
	end
	
	self.employeeDevSpeedBoosts[skillID] = self.employeeDevSpeedBoosts[skillID] - boost
end

function team:addSkillDevSpeedAffector(employee, skillID)
	local boost = employee:getSkillDevBoost(skillID) - 1
	
	if not self.busyEmployees[employee] then
		local newVal = self.activeDevSpeedBoosts[skillID] + boost
		
		self.activeDevSpeedBoosts[skillID] = newVal
		self.realDevSpeedBoosts[skillID] = self:getRealDevSpeedBoost(newVal)
	end
	
	self.employeeDevSpeedBoosts[skillID] = self.employeeDevSpeedBoosts[skillID] + boost
end

function team:getTotalSkillDevSpeedAffectors()
	return self.employeeDevSpeedBoosts
end

function team:getSkillDevSpeedAffector(skill)
	return self.realDevSpeedBoosts[skill]
end

function team:onEmployeeSkillIncreased(employee, skillID, increase)
	if employee == self.manager then
		self:updateManagementBoost()
	end
	
	self:updateCollectiveStats()
end

function team:onEmployeeAttributeIncreased(employee, attributeID)
	if employee == self.manager then
		self:updateManagementBoost()
	end
	
	self:updateCollectiveStats()
end

function team:handleObjectUpgrade(data)
	if data.WORKPLACE then
		local assignee = data:getAssignedEmployee()
		
		if assignee and assignee:getTeam() == self and self.missingHardware then
			self:assignFreeEmployees()
		end
	end
end

function team:handleObjectUpgrades(data)
	if self.missingHardware then
		self:assignFreeEmployees()
	end
end

function team:handleNewTimeline(event)
	if self.queuedKnowledgeUpdate then
		self:recalculateKnowledgeLevel()
		
		self.queuedKnowledgeUpdate = false
	end
end

function team:handleEvent(event, data)
	if event == timeline.EVENTS.NEW_DAY then
		if self.project then
			local projectUID = self.project:getFamiliarityUniqueID()
			
			for key, member in ipairs(self.members) do
				member:regainFamiliarity(projectUID)
			end
		end
	elseif event == project.EVENTS.PROJECT_COMPLETE and data:getTeam() == self then
		data:succeed()
		self:setProject(nil)
	end
end

function team:assignPracticeToIdlingEmployees()
	for key, member in ipairs(self.members) do
		if not member:getTask() and member:isAvailable() then
			local skillToPractice = member:getPracticeableSkill()
			
			if skillToPractice then
				member:practiceSkill(skillToPractice)
			end
		end
	end
end

function team:unassignFromWorkplaces()
	for key, member in ipairs(self.members) do
		if member:getWorkplace() then
			member:setWorkplace(nil)
		end
	end
	
	events:fire(team.EVENTS.UNASSIGNED_TEAM_FROM_WORKPLACES, self)
end

function team:clearProject()
	self:unassignFromProjectTasks(self.project)
	
	if self.project then
		self.project:setTeam(nil)
		
		self.project = nil
		
		table.clearArray(self.recentlyFinishedEmployees)
	end
end

function team:unassignFromProjectTasks(projectObj)
	if projectObj then
		for key, member in ipairs(self.members) do
			local task = member:getTask()
			
			if task and task:getProject() == projectObj and task:canUnassignOnProjectFinish() then
				member:setTask(nil)
			end
		end
	end
end

function team:setProject(proj, stage, devType, skipAssignment)
	local oldProject = self.project
	
	if oldProject then
		self.owner:addProject(oldProject)
	end
	
	if proj then
		local prevTeam = proj:getTeam()
		
		if prevTeam then
			prevTeam:clearProject()
		end
	end
	
	self:clearProject()
	
	self.project = proj
	
	if proj then
		self:unassignDifferentProjectTasks(proj)
		
		stage = stage or proj:getStage()
		
		self.owner:removeProject(self.project)
		proj:assignUniqueID()
		proj:beginWork(stage, devType)
		proj:setTeam(self)
		
		for key, member in ipairs(self.members) do
			member:onProjectChanged(proj, oldProject)
		end
		
		if not skipAssignment then
			self:assignFreeEmployees()
		end
	else
		for key, member in ipairs(self.members) do
			member:onProjectRemoved(oldProject)
		end
	end
end

function team:unassignDifferentProjectTasks(newProject)
	for key, member in ipairs(self.members) do
		local task = member:getTask()
		
		if task then
			local project = task:getProject()
			
			if project and newProject ~= project then
				member:setTask(nil)
			end
		end
	end
end

function team:onFinishedTask(employeeObj)
	self.recentlyFinishedTask = true
	self.recentlyFinishedEmployees[#self.recentlyFinishedEmployees + 1] = employeeObj
end

function team:onPaycheck(amount)
	self.paychecks = self.paychecks + amount
end

function team:postPaycheck()
	if self.project then
		self.project:changeMoneySpent(self.paychecks)
		
		self.paychecks = 0
	end
end

function team:getProject()
	return self.project
end

function team:getAverageSkill(skillID)
	local employeeCount = 0
	local totalSkill = 0
	
	for key, employee in ipairs(self.members) do
		employeeCount = employeeCount + 1
		totalSkill = totalSkill + employee:getSkillLevel(skillID)
	end
	
	return totalSkill / employeeCount, totalSkill, employeeCount
end

function team:getMostExperiencedInSkill(skillID, filter)
	return studio:getMostExperiencedInSkill(self.members, skillID, filter)
end

function team:unassignEmployees(projectOnly)
	local projectObj = self.project
	
	if projectOnly and projectObj then
		for key, employee in ipairs(self.members) do
			local task = employee:getTask()
			
			if task and task:getTargetProject() == projectObj then
				employee:setTask(nil)
			end
		end
	else
		for key, employee in ipairs(self.members) do
			local task = employee:getTask()
			
			if task and task:canReassign(employee) then
				employee:setTask(nil)
			end
		end
	end
end

function team:getMostFitForTask(newTask)
	local workField = newTask:getWorkField()
	local assignee = newTask:getAssignee()
	local highest = -math.huge
	local mostFitting, failReason, tableKey
	local canWorkEverything = self.canWorkOnEverything
	
	for key, dev in ipairs(self.members) do
		if dev:canAssignToTask() and (canWorkEverything or not canWorkEverything and (dev:getMainSkill() == workField or not dev:getMainSkill())) then
			local task = dev:getTask()
			
			if (not task or task:canReassign(dev)) and (not assignee or newTask:canReassign(dev)) then
				local canAssign, taskFailReason = newTask:canAssign(dev)
				
				if canAssign then
					local skill = dev:getSkillLevel(workField)
					
					if highest < skill then
						highest = skill
						mostFitting = dev
						tableKey = key
						failReason = nil
					end
				else
					failReason = taskFailReason
				end
			elseif task then
				local canAssign, taskFailReason = newTask:canAssign(dev)
				
				failReason = failReason or taskFailReason
			end
		end
	end
	
	return mostFitting, highest, failReason, tableKey
end

eventBoxText:registerNew({
	id = "missing_hardware_for_task",
	getText = function(self, data)
		return _format(_T("CANT_DO_TASK_LACKS_HARDWARE", "No employee has hardware capable to work on 'TASK_NAME' within the 'PROJECT_NAME' project."), "TASK_NAME", taskTypes.registeredByID[data.task].display, "PROJECT_NAME", data.project)
	end,
	fillInteractionComboBox = function(self, comboBox, uiElement)
		local workplace = "workplace"
		
		for key, office in ipairs(studio:getOwnedBuildings()) do
			local objectList = office:getObjectsByClass(workplace)
			
			if objectList and #objectList > 0 and self:attemptAddOption(comboBox, objectList) then
				break
			end
		end
	end,
	attemptAddOption = function(self, comboBox, objectList)
		for key, object in ipairs(objectList) do
			object:addUpgradeAllObjectsOption(comboBox)
			
			return true
		end
		
		return false
	end
})
eventBoxText:registerNew({
	id = "inexperienced_for_task",
	getText = function(self, data)
		return _format(_T("CANT_DO_TASK_LACKS_SKILL", "There are no employees capable of working on 'TASK_NAME' within the 'PROJECT_NAME' project."), "TASK_NAME", taskTypes.registeredByID[data.task].display, "PROJECT_NAME", data.project)
	end
}, "missing_hardware_for_task")

function team:assignFreeEmployees()
	if self.project and not self.switchingEmployees then
		self.missingHardware = false
		
		local addedToEventBox = false
		local isPlayer = self.owner:isPlayer()
		local time = timeline.curTime
		
		for key, task in ipairs(self.project:getCurrentTasks()) do
			if not task:isDone() or not task:areAllIssuesFixed() then
				local dev, highestScore, failReason, tableKey = self:getMostFitForTask(task)
				
				if dev then
					local prevAssign = task:getAssignee()
					
					if prevAssign then
						prevAssign:setTask(nil)
					end
					
					dev:setTask(task)
				elseif isPlayer and failReason and game.eventBox and failReason == task.FAIL_REASONS.LACKS_COMPUTER_HARDWARE then
					if not addedToEventBox and time >= self.hardwareNotifyCooldown then
						local element = game.addToEventBox("missing_hardware_for_task", {
							task = task:getTaskType(),
							project = self.project:getName()
						}, 4, nil, "exclamation_point_red")
						
						element:setFlash(true, true)
						
						addedToEventBox = true
						self.hardwareNotifyCooldown = time + team.HARDWARE_PING_COOLDOWN
					end
					
					self.missingHardware = true
				end
			end
			
			if isPlayer and not addedToEventBox and time >= self.employeeNotifyCooldown then
				local data = task:getTaskTypeData()
				
				if data.minimumLevel and self.highestStats[task.workField] < data.minimumLevel then
					local element = game.addToEventBox("inexperienced_for_task", {
						task = task:getTaskType(),
						project = self.project:getName()
					}, 4, nil, "exclamation_point_red")
					
					element:setFlash(true, true)
					
					addedToEventBox = true
					self.employeeNotifyCooldown = time + team.HARDWARE_PING_COOLDOWN
				end
			end
		end
		
		if not self.project:onEmployeesReassigned(self.recentlyFinishedEmployees) then
			table.clearArray(self.recentlyFinishedEmployees)
		end
	end
end

function team:reassignEmployees(forceReassign)
	if not self.project or self.project:isDone() and not forceReassign then
		return 
	end
	
	self:assignFreeEmployees()
end

function team:scrapProject()
	if self.project then
		self:unassignEmployees(true)
		self.project:setTeam(nil)
		
		self.project = nil
	end
end

function team:canStartNewProject()
	if not self.project then
		return true
	end
	
	return self.project:isProjectCompleted()
end

function team:canFinishCreating()
	if not self.name or #string.withoutspaces(self.name) == 0 then
		return false
	end
	
	if not self.desiredMembers then
		return false
	end
	
	for member, state in pairs(self.desiredMembers) do
		if state then
			return true
		end
	end
	
	return false
end

function team:setDesiredMember(member, state)
	self.desiredMembers = self.desiredMembers or {}
	self.desiredMembers[member] = state
end

function team:canAddMember(member)
	return not self:hasMember(member)
end

function team:clearDesiredMembers()
	table.clear(self.desiredMembers)
end

function team:assignDesiredMembers()
	for member, state in pairs(self.desiredMembers) do
		if state then
			if member:getTeam() then
				self.owner:removeEmployeeFromTeam(member)
			end
			
			self:addMember(member, true)
		end
	end
	
	self:onTeamMemberAdded()
end

function team:addMember(member, skipStatUpdate)
	if self.membersByObjects[member] then
		return 
	end
	
	table.insert(self.members, member)
	
	self.membersByObjects[member] = true
	
	self:changeKnowledgeLevel(member, 1)
	
	local roleID = member:getRole()
	
	self.memberRoleCount[roleID] = (self.memberRoleCount[roleID] or 0) + 1
	
	local specID = member:getSpecialization()
	
	if specID then
		table.insert(self.membersBySpec[specID], member)
	end
	
	member:setTeam(self, skipStatUpdate)
	
	if not skipStatUpdate then
		self:addBothSkillDevSpeedAffectors(member)
		self:onTeamMemberAdded()
	end
	
	events:fire(team.EVENTS.MEMBER_ADDED, member, self)
end

function team:getSpecializationCount(id)
	return #self.membersBySpec[id]
end

function team:getMembersBySpecialization(id)
	return self.membersBySpec[id]
end

function team:onEmployeeSpecialized(member)
	local specID = member:getSpecialization()
	
	table.insert(self.membersBySpec[specID], member)
end

function team:onTeamMemberAdded()
	self:updateCollectiveStats(true)
	self:updateManagementBoost()
	self:recalculateInterOfficePenalty()
	self:evaluateJOAT()
	
	if self._allowCalcKnowledge then
		self:recalculateKnowledgeLevel()
	end
	
	if self.project then
		self:reassignEmployees()
	end
	
	self:updateTaskProgressAmount()
	events:fire(team.EVENTS.CHANGED, self)
end

function team:evaluateJOAT()
	local canWorkOnEverything = true
	
	for roleID, amount in pairs(self.memberRoleCount) do
		if not attributes.profiler.rolesByID[roleID].mainSkill then
			canWorkOnEverything = false
			
			break
		end
	end
	
	self.canWorkOnEverything = canWorkOnEverything
end

function team:hasMember(member)
	return self.membersByObjects[member]
end

function team:removeMember(member, skipUpdate)
	self.membersByObjects[member] = nil
	
	member:setTeam(nil)
	
	local roleID = member:getRole()
	
	self.memberRoleCount[roleID] = self.memberRoleCount[roleID] - 1
	
	local specID = member:getSpecialization()
	
	if specID then
		table.removeObject(self.membersBySpec[specID], member)
	end
	
	for key, otherMember in ipairs(self.members) do
		if otherMember == member then
			table.remove(self.members, key)
			self:updateCollectiveStats(true)
			self:reassignEmployees()
			self:changeKnowledgeLevel(member, -1)
			self:recalculateKnowledgeLevel()
			
			break
		end
	end
	
	if not skipUpdate then
		self:removeBothSkillDevSpeedAffectors(member)
		
		self.busyEmployees[member] = nil
		
		self:updateManagementBoost()
		self:recalculateInterOfficePenalty()
		self:evaluateJOAT()
		self:updateTaskProgressAmount()
	end
	
	events:fire(team.EVENTS.MEMBER_REMOVED, member)
	events:fire(team.EVENTS.CHANGED, self)
end

function team:isValid()
	return #self.members > 0
end

function team:canDismantle()
	if not self.dismantleable then
		return false
	end
	
	return true
end

function team:dismantle()
	self.dismantled = true
	
	for key, member in ipairs(self.members) do
		member:setTeam(nil)
		
		if self.manager and self.manager == member then
			member:removeManagedTeam(self)
		end
		
		if member:getTask() then
			member:setTask(nil)
		end
	end
	
	if self.project then
		self.project:setTeam(nil)
	end
	
	self:removeEventReceiver()
end

function team:getMembers()
	return self.members
end

function team:getMemberCount()
	return #self.members
end

function team:resetCollectiveStats()
	self.totalHighestStats = 0
	
	for key, data in ipairs(skills.registered) do
		self.totalStats[data.id] = 0
		self.highestStats[data.id] = 0
		self.lowestStats[data.id] = 0
	end
end

function team:getTotalSkills()
	return self.totalStats
end

function team:getTotalSkill(skillID)
	return self.totalStats[skillID]
end

function team:getTotalAttributes()
	return self.totalAttributes
end

function team:getTotalAttribute(attributeID)
	return self.totalAttributes[attributeID]
end

function team:getLowestSkills()
	return self.lowestStats
end

function team:updateCollectiveStats(skipTaskProgressUpdate)
	local regSkills = skills.registered
	local regAttrs = attributes.registered
	
	for key, attributeData in ipairs(regAttrs) do
		self.totalAttributes[attributeData.id] = 0
	end
	
	self.totalHighestStats = 0
	
	for key, data in ipairs(regSkills) do
		local skillID = data.id
		
		self.totalStats[skillID] = 0
		self.highestStats[skillID] = 0
		self.lowestStats[skillID] = math.huge
	end
	
	for key, member in ipairs(self.members) do
		for key, data in ipairs(regSkills) do
			local skillID = data.id
			local skillLevel = member:getSkillLevel(skillID)
			
			self.totalStats[skillID] = self.totalStats[skillID] + skillLevel
			self.highestStats[skillID] = math.max(self.highestStats[skillID], skillLevel)
			self.lowestStats[skillID] = math.min(self.lowestStats[skillID], skillLevel)
		end
		
		local attributeList = member:getAttributes()
		
		for key, attributeData in ipairs(regAttrs) do
			local attributeID = attributeData.id
			
			self.totalAttributes[attributeID] = (self.totalAttributes[attributeID] or 0) + attributeList[attributeID]
		end
	end
	
	for key, data in ipairs(regSkills) do
		local id = data.id
		
		self.totalHighestStats = self.totalHighestStats + self.highestStats[id]
		
		if self.lowestStats[id] == math.huge then
			self.lowestStats[id] = 0
		end
	end
	
	self.teamworkDevSpeedAffector = self:calculateTeamworkDevSpeedAffector()
	
	if not skipTaskProgressUpdate then
		self:updateTaskProgressAmount()
	end
end

function team:updateTaskProgressAmount()
	for key, member in ipairs(self.members) do
		member:updateTaskProgressAmount()
	end
end

function team:changeKnowledgeLevel(employee, direction)
	for knowledgeID, amount in pairs(employee:getAllKnowledge()) do
		self.memberKnowledge[knowledgeID] = math.max(0, (self.memberKnowledge[knowledgeID] or 0) + amount * direction)
	end
end

function team:onKnowledgeChanged(id, amount)
	self.memberKnowledge[id] = self.memberKnowledge[id] + amount
	self.queuedKnowledgeUpdate = true
end

function team:recalculateKnowledgeLevel()
	local memberCount = #self.members
	
	if memberCount == 0 then
		for key, knowledgeData in ipairs(knowledge.registered) do
			self.totalKnowledge[knowledgeData.id] = 0
		end
		
		return 
	end
	
	local studioKnowledge = self.owner:getCollectiveKnowledge()
	local teamKnowledge = self.memberKnowledge
	local studioMult = team.STUDIO_KNOWLEDGE_CONTRIBUTION
	local memberMult = team.MEMBER_KNOWLEDGE_CONTRIBUTION
	local employeeCount = #studio:getEmployees()
	
	for key, knowledgeData in ipairs(knowledge.registered) do
		local id = knowledgeData.id
		
		self.totalKnowledge[id] = teamKnowledge[id] * memberMult / memberCount + studioKnowledge[id] * studioMult / employeeCount
	end
end

function team:getCollectiveKnowledge()
	return self.totalKnowledge
end

function team:getKnowledge(id)
	return self.totalKnowledge[id]
end

function team:getCollectiveStats()
	return self.totalStats
end

function team:getCollectiveStat(skillID)
	return self.totalStats[skillID]
end

function team:getHighestSkillLevels()
	return self.highestStats
end

function team:getHighestSkillLevel(skillID)
	return self.highestStats[skillID]
end

function team:addMemberContribution(member)
	for key, data in ipairs(skills.registered) do
		self.totalStats[data.id] = self.totalStats[data.id] + member:getSkillLevel(data.id)
	end
end

function team:removeMemberContribution(member)
	for key, data in ipairs(skills.registered) do
		self.totalStats[data.id] = self.totalStats[data.id] - member:getSkillLevel(data.id)
	end
end

function team:setRecentlyFinishedTask(state)
	self.recentlyFinishedTask = state
end

function team:progress(delta, progress)
	if self.recentlyFinishedTask then
		self:reassignEmployees()
		
		self.recentlyFinishedTask = false
	end
	
	if self.project then
		self.project:progress(delta, progress)
	end
end

local seenOffices = {}
local managers = {}

function team:recalculateInterOfficePenalty()
	local officeCount = 0
	
	for key, member in ipairs(self.members) do
		local office = member:getOffice()
		
		if office then
			if not seenOffices[office] then
				officeCount = officeCount + 1
			end
			
			seenOffices[office] = true
		end
		
		if member:getRole() == "manager" then
			managers[#managers + 1] = member
		end
	end
	
	self.interOfficeMultiplier = 1
	
	if officeCount <= 1 then
		table.clear(seenOffices)
		table.clearArray(managers)
		
		return 
	end
	
	local employeePenaltyReduction = 0
	local penaltyDivider = 0
	
	for key, manager in ipairs(managers) do
		employeePenaltyReduction = employeePenaltyReduction + manager:getRoleData():getInterOfficePenaltyDecrease(manager)
		penaltyDivider = penaltyDivider + manager:getInterOfficePenaltyDivider()
	end
	
	local penalty = 0
	
	if officeCount > 1 then
		penalty = (penalty + team.INTER_OFFICE_BASE_PENALTY + (officeCount - 2) * team.INTER_OFFICE_PENALTY_PER_OFFICE) / (1 + penaltyDivider)
		
		local employeePenalty = #self.members
		
		if employeePenaltyReduction > 0 then
			employeePenalty = employeePenalty - 1
			employeePenalty = math.max(0, employeePenalty - employeePenaltyReduction)
		end
		
		employeePenalty = employeePenalty * team.INTER_OFFICE_PENALTY_PER_EMPLOYEE
		self.interOfficeMultiplier = math.min(1, math.max(1 - penalty - employeePenalty, team.INTER_OFFICE_PENALTY_MAX))
	end
	
	table.clear(seenOffices)
	table.clearArray(managers)
end

function team:switchMembersToTeam(otherTeam)
	self.switchingEmployees = true
	
	local newProject = otherTeam:getProject()
	local curProject = self.project
	
	while self.members[1] do
		local member = self.members[1]
		
		if member:getTask() then
			member:setTask(nil)
		end
		
		self:removeMember(member, true)
		otherTeam:addMember(member, true)
		member:onProjectChanged(newProject, curProject)
	end
	
	self:onTeamMemberAdded()
	otherTeam:onTeamMemberAdded()
	
	self.switchingEmployees = false
	
	if not newProject and self.project then
		otherTeam:setProject(self.project)
	end
end

function team:getInterOfficeMultiplier()
	return self.interOfficeMultiplier
end

function team:onEmployeeOfficeChanged()
	if studio._loading then
		return 
	end
	
	self:recalculateInterOfficePenalty()
end

function team:draw()
	if self.project then
		self.project:draw()
	end
end

function team:destroy()
	events:removeReceiver(self)
end

function team:setOwner(owner)
	self.owner = owner
end

function team:getOwner()
	return self.owner
end

function team:save()
	return {
		dismantleable = self.dismantleable,
		name = self.name,
		project = self.project and self.project:getUniqueID() or nil,
		uniqueID = self.uniqueID,
		manager = self.manager and self.manager:getUniqueID()
	}
end

function team:isLoading()
	return self._loading
end

function team:load(data)
	self._loading = true
	self.dismantleable = data.dismantleable
	self.name = data.name
	self.uniqueID = data.uniqueID
	self.savedData = data
end

function team:postLoad()
	if self.savedData and self.savedData.manager then
		local employee = self.owner:getEmployeeByUniqueID(self.savedData.manager)
		
		self:setManager(employee)
	end
	
	self._allowCalcKnowledge = true
	
	self:buildSkillDevSpeedAffectors()
	self:onTeamMemberAdded()
	
	if self.savedData and self.savedData.project then
		local projectObj = self.owner:getProjectByUniqueID(self.savedData.project)
		
		projectObj = projectObj or studio:getPatchByUniqueID(self.savedData.project)
		
		local stage = projectObj:getStage()
		
		self:setProject(projectObj, stage)
	end
	
	self.savedData = nil
	self._loading = false
end
