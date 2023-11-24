local activeProject = {}

activeProject.textColor = color(255, 255, 255, 255)
activeProject.panelColor = color(0, 0, 0, 150)
activeProject.textShadowColor = color(0, 0, 0, 255)

function activeProject:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or activeProject.textColor
	self.textShadowColor = textShadowColor or activeProject.textShadowColor
	self.alpha = 1
	
	events:addReceiver(self)
end

function activeProject:fillInteractionComboBox(comboBox)
	self.project:fillInteractionComboBox(comboBox)
end

eventBoxText:registerNew({
	id = "engine_updated",
	getText = function(self, data)
		return _format(_T("ENGINE_UPDATE_FINISHED", "Update of 'ENGINE_NAME' engine with new features is finished."), "ENGINE_NAME", data)
	end
})
eventBoxText:registerNew({
	id = "engine_revamped",
	getText = function(self, data)
		return _format(_T("ENGINE_REVAMP_FINISHED", "Revamp of 'ENGINE_NAME' engine is finished."), "ENGINE_NAME", data)
	end
}, "engine_updated")
eventBoxText:registerNew({
	id = "engine_finished",
	getText = function(self, data)
		return _format(_T("ENGINE_PROJECT_COMPLETE", "Work on 'ENGINE' is done, it can now be used for game development."), "ENGINE", data)
	end
}, "engine_updated")

function activeProject:handleEvent(event, data)
	activeProject.baseClass.handleEvent(self, event, data)
	
	if data == self.project and (event == engine.EVENTS.REVAMP_FINISHED or event == engine.EVENTS.UPDATE_FINISHED) then
		local text
		
		if event == engine.EVENTS.UPDATE_FINISHED then
			game.addToEventBox("engine_updated", self.project:getName(), 1)
		else
			game.addToEventBox("engine_revamped", self.project:getName(), 1)
		end
		
		self.elementBox:getScroller():removeItem(self)
		self:kill()
	elseif event == project.EVENTS.SCRAPPED_PROJECT and data == self.project then
		self.elementBox:getScroller():removeItem(self)
		self:kill()
	elseif event == engine.EVENTS.FINISHED_ENGINE and data == self.project then
		game.addToEventBox("engine_finished", self.project:getName(), 1)
		self.elementBox:getScroller():removeItem(self)
		self:kill()
	elseif event == engine.EVENTS.UPDATE_CANCELLED and data == self.project then
		self.elementBox:getScroller():removeItem(self)
		self:kill()
	end
end

function activeProject:onMouseEntered()
	activeProject.baseClass.onMouseEntered(self)
	self:setupDescbox()
end

function activeProject:setupDescbox()
	if self.descBox then
		self.descBox:removeAllText()
	end
	
	self.descBox = self.descBox or gui.create("GenericDescbox")
	
	local wrapW = 300
	
	self.project:setupInfoDescbox(self.descBox, wrapW)
	self.descBox:positionToElement(self, self.w + _S(20), -self.descBox:getHeight() + self.h)
end

function activeProject:onMouseLeft()
	activeProject.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("ActiveEngineProjectElement", activeProject, "ActiveProjectElement")
