local teamReassignment = {}

teamReassignment.descboxID = game.DISMANTLING_TEAM_DESCBOX_ID
teamReassignment.EVENTS = {
	REASSIGN_TARGET_SET = events:new()
}
teamReassignment.CATCHABLE_EVENTS = {
	teamReassignment.EVENTS.REASSIGN_TARGET_SET
}

function teamReassignment:setConfirmButton(button)
	self.confirmButton = button
end

function teamReassignment:isOn()
	return self.beingReassigned
end

function teamReassignment:handleEvent(event)
	if self.confirmButton:getReassignTeam() ~= self.team then
		self.beingReassigned = false
	end
	
	self:queueSpriteUpdate()
end

function teamReassignment:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if self.confirmButton:getReassignTeam() == self.team then
			self.confirmButton:setReassignTeam(nil)
			
			self.beingReassigned = false
		else
			self.confirmButton:setReassignTeam(self.team)
			
			self.beingReassigned = true
		end
		
		events:fire(teamReassignment.EVENTS.REASSIGN_TARGET_SET)
		self:queueSpriteUpdate()
	end
end

gui.register("TeamReassignmentSelection", teamReassignment, "TeamButton")
