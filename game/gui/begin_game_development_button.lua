local beginProject = {}

function beginProject:onClick()
	if self.project and self.project:canBeginWorkOn() then
		local desiredTeam = self.project:getDesiredTeam()
		
		frameController:pop()
		desiredTeam:setProject(self.project, 1, nil)
		self.project:setDesiredTeam(nil)
		
		self.project = nil
	end
end

gui.register("BeginGameDevelopmentButton", beginProject, "BeginProjectButton")
