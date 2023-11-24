local teamScrollbar = {}

teamScrollbar.CATCHABLE_EVENTS = {
	studio.EVENTS.TEAM_CREATED,
	studio.EVENTS.TEAM_DISMANTLED
}

function teamScrollbar:setCategoryTitle(cat)
	self.category = cat
	
	self:updateCategoryText()
end

function teamScrollbar:updateCategoryText()
	self.category:setText(_format(_T("CURRENT_TEAMS_COUNT", "Current teams (CURRENT/MAX)"), "CURRENT", #studio:getTeams(), "MAX", game.MAX_TEAMS))
end

function teamScrollbar:createTeamButton(teamObj)
	local TeamButton = gui.create("TeamButton")
	
	TeamButton:setFont(fonts.get("pix24"))
	TeamButton:setSize(408, 25)
	TeamButton:setBasePanel(frame)
	TeamButton:addComboBoxOption("manage", "practice", "assigntooffice", "dismantle", "rename", "move_to_another_team")
	TeamButton:setTeam(teamObj)
	TeamButton:updateDescbox()
	
	return TeamButton
end

function teamScrollbar:fillWithElements()
	for key, curTeam in ipairs(studio:getTeams()) do
		self.category:addItem(self:createTeamButton(curTeam))
	end
end

function teamScrollbar:handleEvent(event, teamObj)
	if event == studio.EVENTS.TEAM_CREATED then
		self.category:addItem(self:createTeamButton(teamObj))
		self:updateCategoryText()
	elseif event == studio.EVENTS.TEAM_DISMANTLED then
		for key, item in ipairs(self.items) do
			if item.class == "TeamButton" and item:getTeam() == teamObj then
				self.category:removeItem(item)
				item:kill()
				self:updateCategoryText()
				
				break
			end
		end
	end
end

gui.register("TeamScrollbarPanel", teamScrollbar, "ScrollbarPanel")
