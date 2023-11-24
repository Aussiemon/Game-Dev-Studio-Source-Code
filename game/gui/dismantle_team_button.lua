local dismantleTeamButton = {}

function dismantleTeamButton:setTeam(teamObj)
	self.dismantleTeam = teamObj
end

function dismantleTeamButton:setReassignTeam(teamObj)
	self.reassignMembersTo = teamObj
	
	self:updateText()
end

function dismantleTeamButton:updateText()
	if self.reassignMembersTo then
		self:setText(_T("REASSIGN_AND_DISMANTLE_TEAM", "Reassign members & dismantle team"))
	else
		self:setText(_T("DISMANTLE_TEAM", "Dismantle team"))
	end
end

function dismantleTeamButton:getReassignTeam()
	return self.reassignMembersTo
end

function dismantleTeamButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if self.reassignMembersTo then
			self.dismantleTeam:switchMembersToTeam(self.reassignMembersTo)
		end
		
		studio:dismantleTeam(self.dismantleTeam)
		frameController:pop()
	end
end

gui.register("DismantleTeamButton", dismantleTeamButton, "Button")
