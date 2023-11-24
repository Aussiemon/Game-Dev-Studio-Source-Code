require("game/gui/team_list_combobox_button")

local teamList = {}

teamList.CATCHABLE_EVENTS = {
	project.EVENTS.DESIRED_TEAM_UNSET,
	project.EVENTS.DESIRED_TEAM_SET
}

function teamList:init()
	self:setFont(fonts.get("pix14"))
	self:updateText()
end

function teamList:setDefaultText()
end

function teamList:handleEvent(event, gameObj, teamObj)
	if event == project.EVENTS.DESIRED_TEAM_UNSET then
		if teamObj == self.team then
			self:setTeam(nil)
		end
	elseif event == project.EVENTS.DESIRED_TEAM_SET and gameObj == self.featureList:getProject() then
		self:setTeam(teamObj)
	end
end

function teamList:setTeam(teamObj)
	self.team = teamObj
	
	self:updateText()
end

function teamList:setProject(project)
end

function teamList:getProject()
end

function teamList:setFeatureList(feat)
	self.featureList = feat
end

function teamList:onSelected(option)
	self.team = option.team
	
	if self.featureList then
		self.featureList:setDesiredTeam(option.team)
		self.featureList:updateList()
	end
end

function teamList:updateText()
	if self.team then
		self:setText(self.team:getName())
	else
		self:setText(_T("BUTTON_SELECT_TEAM", "Select Team"))
	end
end

gui.register("EngineTeamComboBox", teamList, "TeamListComboBoxButton")
