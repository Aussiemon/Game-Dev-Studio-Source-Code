local confirmTeamName = {}

function confirmTeamName:isDisabled()
	return string.withoutspaces(self.textBox:getText()) == ""
end

function confirmTeamName:setTextBox(textbox)
	self.textBox = textbox
end

function confirmTeamName:setTeam(team)
	self.team = team
end

function confirmTeamName:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and not self:isDisabled() then
		self.team:setName(self.textBox:getText())
		self.parent:kill()
	end
end

gui.register("ConfirmTeamNameButton", confirmTeamName, "Button")
