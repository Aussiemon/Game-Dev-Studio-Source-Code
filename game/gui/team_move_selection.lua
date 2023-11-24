local teamMoveSel = {}

function teamMoveSel:moveEmployeesOption()
	frameController:pop()
	self.targetTeam:createMemberMovePopup(self.team)
end

function teamMoveSel:fillInteractionComboBox(combobox)
	local option = combobox:addOption(0, 0, 0, 24, _T("CONTINUE", "Continue"), fonts.get("pix20"), teamMoveSel.moveEmployeesOption)
	
	option.targetTeam = self.targetTeam
	option.team = self.team
end

function teamMoveSel:setTargetTeam(teamObj)
	self.targetTeam = teamObj
end

function teamMoveSel:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:setInteractionObject(self, x - 20, y - 10, true)
		self:killDescBox()
	end
end

gui.register("TeamMoveSelection", teamMoveSel, "TeamButton")
