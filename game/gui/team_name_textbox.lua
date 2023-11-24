local teamName = {}

teamName.ghostText = _T("ENTER_TEAM_NAME", "Enter team name")

function teamName:setTeam(team)
	self.team = team
end

function teamName:onWrite(text)
	self.team:setName(self:getText())
end

function teamName:onDelete()
	self.team:setName(self:getText())
end

gui.register("TeamNameTextBox", teamName, "TextBox")
