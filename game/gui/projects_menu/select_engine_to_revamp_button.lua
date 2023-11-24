local revampEngineSelection = {}

function revampEngineSelection:setEngine(engine)
	self.engine = engine
	
	self:setText(engine:getName())
end

function revampEngineSelection:onClick()
	if self.checkTeamSelect and self.checkTeamSelect.team then
		self.engine:setDesiredTeam(self.checkTeamSelect.team)
		self:getBasePanel():kill()
	end
end

gui.register("SelectEngineToRevampButton", revampEngineSelection, "SelectEngineToUpdateButton")
