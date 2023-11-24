local createTeam = {}

function createTeam:init()
end

function createTeam:setTeam(team)
	self.team = team
end

function createTeam:onClick()
	if self.team:canFinishCreating() then
		self.team:assignDesiredMembers()
		studio:addTeam(self.team, true)
		self:getParent():kill()
	end
end

function createTeam:isDisabled()
	return not self.team:canFinishCreating()
end

function createTeam:handleEvent(event, newMember, teamObject)
	if event == team.EVENTS.MEMBER_ADDED and teamObject == self.team or event == team.EVENTS.NAME_CHANGED and newMember == self.team then
		self:queueSpriteUpdate()
	end
end

function createTeam:draw(w, h)
	love.graphics.setFont(self.fontObject)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.printST(self.text, w * 0.5 - self.textWidth * 0.5, h * 0.5 - self.textHeight * 0.5, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("CreateTeamButton", createTeam, "Button")
