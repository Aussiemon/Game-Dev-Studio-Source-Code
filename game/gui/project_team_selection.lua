local teamSelect = {}

teamSelect.skinTextFillColor = color(220, 220, 220, 255)
teamSelect.skinTextHoverColor = color(240, 240, 240, 255)
teamSelect.skinTextSelectColor = color(255, 255, 255, 255)
teamSelect.skinTextDisableColor = color(150, 150, 150, 255)
teamSelect.descboxID = project.teamInfoDescboxID
teamSelect.EVENT_UPDATE_TEXT = "update_team_selection_text"

function teamSelect:init()
	if not self.descriptionBox then
		self.descriptionBox = gui.create("GenericDescbox", self)
		
		self.descriptionBox:setShowRectSprites(false)
		self.descriptionBox:overwriteDepth(50)
		self.descriptionBox:setFadeInSpeed(0)
	end
	
	self.nameFont = fonts.get("pix24")
	self.nameFontHeight = self.nameFont:getHeight()
	self.font = fonts.get("pix20")
	self.fontHeight = self.font:getHeight()
	
	events:addReceiver(self)
end

function teamSelect:onKill()
	events:removeReceiver(self)
end

function teamSelect:handleEvent(event, data, newTeam)
	if event == teamSelect.EVENT_UPDATE_TEXT then
		self:updateDescbox()
	end
end

function teamSelect:setConfirmationButton(button)
	self.confirmButton = button
end

function teamSelect:setTeam(team)
	self.team = team
	self.initialTeam = self.project:getTeam() == team
	self.initialProject = self.team:getProject()
	
	self:updateDescbox()
end

function teamSelect:updateSprites()
	teamSelect.baseClass.updateSprites(self)
	
	self.checkboxSprite = self:allocateSprite(self.checkboxSprite, self:isOn() and "checkbox_on" or "checkbox_off", self.w - _S(28), _S(5), 0, 22, 22, 0, 0, -0.4)
end

function teamSelect:updateDescbox()
	teamSelect.baseClass.updateDescbox(self)
	
	if not self.team then
		return 
	end
	
	local projectText, projectIcon
	local wrapW = self.rawW - 20
	
	if self.initialTeam and self.initialProject then
		local project = self.initialProject
		
		if self:isOn() then
			projectText = string.easyformatbykeys(_T("WORKING_ON", "Working on 'NAME'"), "NAME", project:getName())
			projectIcon = "project_stuff"
		else
			projectText = string.easyformatbykeys(_T("WORKED_ON", "Worked on 'NAME'"), "NAME", project:getName())
			projectIcon = "question_mark"
		end
	elseif self:isOn() then
		projectText = string.easyformatbykeys(_T("PENDING_ASSIGNMENT", "Pending assignment to 'NAME'"), "NAME", self.project:getName())
		projectIcon = "project_stuff"
	elseif self.initialProject then
		projectText = string.easyformatbykeys(_T("WORKING_ON", "Working on 'NAME'"), "NAME", self.initialProject:getName())
		projectIcon = "project_stuff"
	else
		projectText = _T("NOT_WORKING", "Not working on anything")
		projectIcon = "question_mark"
	end
	
	local lineWidth = self.w - _S(10)
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, _S(-2), "weak_gradient_horizontal")
	self.descriptionBox:addSpaceToNextText(8)
	self.descriptionBox:addText(projectText, "bh20", nil, 2, wrapW, projectIcon, 24, 24)
	
	local efficiency, versusTeam, currentEfficiency = studio:getTeamEfficiency(self.team)
	local efficiencyText, efficiencyColor
	local roundedEffOurs, roundedEffTheir = math.round(efficiency * 100, 1), math.round(currentEfficiency * 100, 1)
	
	if versusTeam ~= self.team then
		efficiencyText = string.easyformatbykeys(_T("EFFICIENCY_VS_TEAM", "Efficiency vs team 'TEAM' - EFFICIENCY%"), "TEAM", versusTeam:getName(), "EFFICIENCY", roundedEffOurs)
		
		if roundedEffOurs < roundedEffTheir then
			efficiencyColor = game.UI_COLORS.ORANGE
		else
			efficiencyColor = game.UI_COLORS.YELLOW
		end
	else
		efficiencyText = string.easyformatbykeys(_T("TEAM_EFFICIENCY", "Efficiency - EFFICIENCY%"), "EFFICIENCY", roundedEffOurs)
		
		if roundedEffTheir < roundedEffOurs then
			efficiencyColor = game.UI_COLORS.ORANGE
		else
			efficiencyColor = game.UI_COLORS.YELLOW
		end
	end
	
	self.descriptionBox:addTextLine(lineWidth, efficiencyColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(efficiencyText, "bh20", nil, 0, wrapW, "efficiency", 24, 24)
	self:setHeight(_US(self.descriptionBox.h) + 3)
end

function teamSelect:setProject(proj)
	self.project = proj
end

function teamSelect:isOn()
	return self.team == self.confirmButton:getTeam()
end

function teamSelect:onClick(x, y, key)
	self.confirmButton:setTeam(self.team)
	events:fire(teamSelect.EVENT_UPDATE_TEXT)
end

gui.register("ProjectTeamSelection", teamSelect, "TeamButton")
