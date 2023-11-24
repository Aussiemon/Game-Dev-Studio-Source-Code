local button = {}

button.CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.CANDIDATE_TARGET_TEAM_CHANGED
}

function button:handleEvent(event)
	self:highlight(self.team == employeeCirculation:getTargetTeam())
	self:queueSpriteUpdate()
end

function button:setTeam(teamObj)
	self.team = teamObj
	
	self:highlight(self.team == employeeCirculation:getTargetTeam())
end

function button:isOn()
	return self.highlighted
end

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		employeeCirculation:setTargetTeam(self.team)
	end
end

gui.register("CandidateTargetTeamSelection", button, "TeamButton")
