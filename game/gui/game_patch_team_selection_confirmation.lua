local teamSelect = {}

function teamSelect:isDisabled()
	return not self.team or self.team == self.project:getTeam()
end

function teamSelect:onClick(x, y, key)
	if not self.team then
		return 
	end
	
	local teamObj = self.project:getTeam()
	
	if teamObj ~= self.team then
		self.project:beginCreatingPatch(self.team)
		frameController:pop()
	end
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

gui.register("GamePatchTeamSelectionConfirmation", teamSelect, "Button")
