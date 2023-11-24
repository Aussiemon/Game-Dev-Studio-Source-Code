local function onClicked(self)
	self.baseButton:setTeam(self.team)
	self.baseButton:onSelected(self)
	self.tree:onSelected(self)
	self.tree:close()
end

local teamList = {}

teamList.popupTitle = _T("NO_TEAMS_AVAILABLE_TITLE", "No Teams Available")
teamList.popupText = _T("NO_TEAMS_AVAILABLE_DESC", "You currently have no teams created.\nPlease create at least one team before proceeding.")
teamList.CATCHABLE_EVENTS = {
	project.EVENTS.DESIRED_TEAM_SET,
	project.EVENTS.DESIRED_TEAM_UNSET
}

function teamList:init()
	self.busyTeams = {}
end

function teamList:handleEvent(event)
	self:updateText()
end

function teamList:onSelected(obj)
end

function teamList:setTeam(teamObj)
	self.team = teamObj
	
	self.project:setDesiredTeam(teamObj)
end

function teamList:setProject(project)
	self.project = project
	
	self:updateText()
end

function teamList:getProject()
	return self.project
end

function teamList:onShow()
	self:updateText()
end

function teamList:updateText()
	if self.project:isAssignedToTeam() then
		local teamObj = self.project:getTeam() or self.project:getDesiredTeam()
		
		self:setText(teamObj:getName())
	else
		self:setText(_T("SELECT_TEAM", "Select team"))
	end
end

function teamList:getListTable()
	return studio:getTeams()
end

teamList.busyTeamColor = color(130, 130, 130, 255)

function teamList:fillInteractionComboBox(comboBox)
	local x, y = self:getPos(true)
	
	comboBox:setOptionButtonType("TeamComboboxButton")
	comboBox:setPos(x, y + self.h)
	
	for key, teamObj in ipairs(self.teamList) do
		if teamObj:getProject() then
			self.busyTeams[#self.busyTeams + 1] = teamObj
		else
			local optionObject = comboBox:addOption(0, 0, self.rawW, 18, teamObj:getName(), fonts.get("pix20"), onClicked)
			
			optionObject:setTeam(teamObj)
			
			optionObject.baseButton = self
		end
	end
	
	local busyColor = teamList.busyTeamColor
	
	for key, teamObj in ipairs(self.busyTeams) do
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, teamObj:getName(), fonts.get("pix20"), onClicked)
		
		optionObject:setTeam(teamObj)
		optionObject:setTextFillColor(busyColor)
		
		optionObject.baseButton = self
		self.busyTeams[key] = nil
	end
	
	self.teamList = nil
end

function teamList:onClick()
	if interactionController:attemptHide(self) then
		return 
	end
	
	local teams = self:getListTable()
	
	if #teams > 0 then
		self.teamList = teams
		
		interactionController:startInteraction(self)
	else
		local popup = gui.create("Popup")
		
		popup:setWidth(450)
		popup:centerX()
		popup:setTextFont(fonts.get("pix24"))
		popup:setFont(fonts.get("pix20"))
		popup:setTitle(self.popupTitle)
		popup:setText(self.popupText)
		popup:setDepth(105)
		popup:addButton(fonts.get("pix24"), "OK")
		popup:performLayout()
		popup:centerY()
		frameController:push(popup)
	end
end

gui.register("TeamListComboBoxButton", teamList, "Button")
require("game/gui/team_combobox_option")
