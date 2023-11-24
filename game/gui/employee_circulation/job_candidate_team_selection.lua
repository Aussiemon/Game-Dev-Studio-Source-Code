local button = {}

button.CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.CANDIDATE_TARGET_TEAM_CHANGED
}

function button:onClick(x, y, key)
	employeeCirculation:createTargetTeamSelectionMenu()
end

function button:handleEvent(event)
	self:updateText()
end

function button:updateText()
	self:setText(_format(_T("TARGET_TEAM", "Team: TEAM"), "TEAM", employeeCirculation:getTargetTeam():getName()))
end

gui.register("JobCandidateTeamSelection", button, "Button")
