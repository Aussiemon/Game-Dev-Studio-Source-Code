local teamSelect = {}

teamSelect.skinPanelDisableColor = color(40, 40, 40, 255)
teamSelect.skinTextFillColor = color(220, 220, 220, 255)
teamSelect.skinTextHoverColor = color(240, 240, 240, 255)
teamSelect.skinTextSelectColor = color(255, 255, 255, 255)
teamSelect.skinTextDisableColor = color(150, 150, 150, 255)

function teamSelect:onClick(x, y, key)
	if self.project:getTeam() ~= self.team then
		self.team:setProject(self.project)
	end
	
	frameController:pop()
end

function teamSelect:setProject(proj)
	self.project = proj
	self.team = proj:getTeam()
end

function teamSelect:setTeam(team)
	self.team = team
end

function teamSelect:getTeam()
	return self.team
end

gui.register("ProjectTeamSelectionConfirmation", teamSelect, "Button")
