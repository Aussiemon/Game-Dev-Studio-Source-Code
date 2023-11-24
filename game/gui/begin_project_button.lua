local beginProject = {}

beginProject.skinPanelFillColor = game.UI_COLORS.LIGHT_GREEN
beginProject.CATCHABLE_EVENTS = {
	complexProject.EVENTS.ADDED_DESIRED_FEATURE,
	gameProject.EVENTS.CHANGED_GENRE,
	gameProject.EVENTS.CHANGED_THEME,
	gameProject.EVENTS.AUDIENCE_CHANGED,
	gameProject.EVENTS.CHANGED_PRICE,
	gameProject.EVENTS.ENGINE_CHANGED,
	gameProject.EVENTS.PLATFORM_STATE_CHANGED,
	gameProject.EVENTS.INHERITED_PROJECT_SETUP,
	project.EVENTS.DESIRED_TEAM_SET,
	project.EVENTS.DESIRED_TEAM_UNSET,
	project.EVENTS.NAME_SET
}

function beginProject:init()
end

function beginProject:handleEvent(event, projectObject, state)
	if projectObject == self.project then
		self.canBeginWorkOn = self.project:canBeginWorkOn()
		
		self:queueSpriteUpdate()
	end
end

function beginProject:setProject(proj)
	self.project = proj
end

function beginProject:getProject()
	return self.project
end

function beginProject:setDevelopmentType(devType)
	self.developmentType = devType
end

function beginProject:onClick()
	if self.developmentType == engine.DEVELOPMENT_TYPE.REVAMP then
		if self.project and self.project:isAssignedToTeam() then
			self.project:getDesiredTeam():setProject(self.project, 1, self.developmentType)
			self.project:setDesiredTeam(nil)
			
			self.project = nil
			
			frameController:pop()
		end
	elseif self.project and self.canBeginWorkOn then
		self.project:getDesiredTeam():setProject(self.project, 1, self.developmentType)
		self.project:setDesiredTeam(nil)
		
		self.project = nil
		
		frameController:pop()
	end
end

function beginProject:kill()
	beginProject.baseClass.kill(self)
	
	if self.project then
		self.project:setDesiredTeam(nil)
	end
end

function beginProject:onMouseEntered()
	beginProject.baseClass.onMouseEntered(self)
	
	if not self.descBox then
		local invalidString = self:getGameValidity()
		
		if invalidString then
			self.descBox = gui.create("GenericDescbox")
			
			self.descBox:addText(_T("CANT_BEGIN_WORK_ON_PROJECT", "Can not begin work on project:"), "pix22", nil, 10, 600)
			self.descBox:addText(invalidString, "pix20", nil, 0, 600)
			self.descBox:centerToElement(self)
		end
	end
end

function beginProject:onMouseLeft()
	self:killDescBox()
	beginProject.baseClass.onMouseEntered(self)
end

function beginProject:getGameValidity()
	if self.developmentType == engine.DEVELOPMENT_TYPE.REVAMP then
		return nil
	end
	
	if not self.project then
		return nil
	end
	
	local list = self.project:getMissingSelectionTextTable()
	
	if #list > 0 then
		local concatString = table.concat(list, "\n")
		
		table.clear(list)
		
		return concatString
	end
	
	return nil
end

function beginProject:isDisabled()
	if self.developmentType == engine.DEVELOPMENT_TYPE.REVAMP then
		if not self.project or not self.project:hasName() or not self.project:isAssignedToTeam() then
			return true
		end
	elseif not self.project or not self.canBeginWorkOn then
		return true
	end
	
	return false
end

gui.register("BeginProjectButton", beginProject, "Button")
