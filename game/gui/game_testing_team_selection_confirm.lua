local teamSelect = {}

function teamSelect:onClick(x, y, key)
	if not self.team then
		return 
	end
	
	local teamObj = self.project:getTeam()
	
	if teamObj ~= self.team then
		self.project:testProject(self.team)
		frameController:pop()
	end
end

gui.register("GameTestingTeamSelectionConfirm", teamSelect, "GamePatchTeamSelectionConfirmation")
