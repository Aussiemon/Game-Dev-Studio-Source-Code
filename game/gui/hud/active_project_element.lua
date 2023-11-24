local activeProject = {}

activeProject.textColor = color(255, 255, 255, 255)
activeProject.panelColor = color(0, 0, 0, 150)
activeProject.textShadowColor = color(0, 0, 0, 255)
activeProject.barColor = color(164, 204, 138, 255)
activeProject.barHeight = 6
activeProject.skinPanelFillColor = game.UI_COLORS.NEW_HUD_FILL_3
activeProject.skinPanelHoverColor = game.UI_COLORS.NEW_HUD_HOVER
activeProject.skinPanelDisableColor = color(48, 59, 76, 255)
activeProject.REMOVE_SELF_EVENTS = {
	[project.EVENTS.SCRAPPED_PROJECT] = true
}

function activeProject:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or activeProject.textColor
	self.textShadowColor = textShadowColor or activeProject.textShadowColor
	self.alpha = 1
	self.lastUpdate = 0
	self.progress = 0
end

function activeProject:setTargetObject(object)
	self.project = object
	
	self:onTargetObjectSet()
end

function activeProject:onTargetObjectSet()
	self:createWorkPointsDisplay()
	self:setText(self:getTargetObject():getName())
end

function activeProject:getTargetObject()
	return self.project
end

function activeProject:getProject()
	return self.project
end

function activeProject:setElementBox(box)
	self.elementBox = box
end

function activeProject:setText(text)
	self.text = text
	
	self:scaleToText()
end

function activeProject:getText()
	return self.text
end

function activeProject:scaleToText()
	local text = self:getText()
	
	if not self.fontObject or not text then
		return 
	end
	
	self:updateText(text)
end

function activeProject:updateText(newText)
	local text, lineCount, height = string.wrap(newText, self.fontObject, self.w - _S(20))
	
	self.wrappedText = text
	self.textHeight = height
	
	self:updateHeight()
end

activeProject.WORK_POINTS_SIZE = {
	50,
	18
}
activeProject.WORK_COMPLETION_SIZE = {
	54,
	18
}

function activeProject:createWorkPointsDisplay()
	if not self.workPointsDisplay then
		self.workPointsDisplay = gui.create("ProjectElementInfoDisplay", self)
		
		self.workPointsDisplay:setIcon("wrench")
		self.workPointsDisplay:setFont("bh14")
		self.workPointsDisplay:setCanHover(false)
		
		self.workCompletionDisplay = gui.create("ProjectElementInfoDisplay", self)
		
		self.workCompletionDisplay:setIcon("demolition_blue")
		self.workCompletionDisplay:setFont("bh16")
		self.workCompletionDisplay:setCanHover(false)
		self:adjustWorkElementSizes()
		self:updateWorkPoints()
		self:updateWorkCompletion()
	end
end

function activeProject:adjustWorkElementSizes()
	local size = activeProject.WORK_POINTS_SIZE
	
	self.workPointsDisplay:setSize(size[1], size[2])
	
	size = activeProject.WORK_COMPLETION_SIZE
	
	self.workCompletionDisplay:setSize(size[1], size[2])
end

function activeProject:adjustDisplayPositions()
	if self.workPointsDisplay then
		local y = self.textHeight + _S(6)
		local scaledFive = _S(5)
		local x = scaledFive
		
		self.workPointsDisplay:setPos(x, y)
		
		x = x + scaledFive + self.workPointsDisplay.w
		
		self.workCompletionDisplay:setPos(x, y)
		
		self.barY = self.workPointsDisplay.localY + self.workPointsDisplay.h + _S(6)
	end
end

function activeProject:updateHeight()
	self:setHeight(self:adjustHeight(self.textHeight))
	self:adjustDisplayPositions()
end

function activeProject:adjustHeight(textHeight)
	if self.workPointsDisplay then
		return _US(textHeight) + 45
	end
	
	return _US(textHeight) + 20
end

function activeProject:setAlpha(alpha)
	self.alpha = alpha
end

function activeProject:getAlpha()
	return self.overrideAlphaLevels and 1 or self.alpha
end

function activeProject:saveData()
	local saved = activeProject.baseClass.saveData(self)
	
	saved.targetObject = self:getTargetObject()
	saved.panelColor = self.panelColor
	saved.textColor = self.textColor
	saved.textShadowColor = self.textShadowColor
	
	return saved
end

function activeProject:loadData(data)
	self:setTargetObject(data.targetObject)
	activeProject.baseClass.loadData(self, data)
end

function activeProject:setOverrideAlphaLevels(override)
	self.overrideAlphaLevels = override
end

function activeProject:onKill()
	self.scrollPanel:removeItem(self)
	interactionController:verifyComboBoxValidity()
	events:removeReceiver(self)
end

function activeProject:onHide()
	interactionController:verifyComboBoxValidity()
end

function activeProject:attemptRemoval(event)
	self:kill()
end

eventBoxText:registerNew({
	id = "work_on_project_finished",
	getText = function(self, data)
		return _format(_T("PROJECT_COMPLETE", "Work on 'PROJECT' is finished."), "PROJECT", data)
	end
})

function activeProject:handleEvent(event, data)
	if event == studio.EVENTS.NEW_ENGINE and data == self.project then
		self.panelColor = activeProject.finishedColor
		
		game.addToEventBox("work_on_project_finished", self.project:getName(), 1)
		self.elementBox:getScroller():removeItem(self)
		self:kill()
	elseif self.REMOVE_SELF_EVENTS[event] and data == self.project then
		self.elementBox:getScroller():removeItem(self)
		self:kill()
	elseif event == contractor.EVENTS.LOADED and data:hasProject(self.project) then
		self:setText(self:getText())
	elseif event == project.EVENTS.NAME_SET then
		self:updateText(self:getText())
	end
end

function activeProject:updateWorkCompletion()
	self.workCompletionDisplay:setText(_format("COMPLETION%", "COMPLETION", math.round(self:getCompletion() * 100, 1)))
end

function activeProject:updateWorkPoints()
	local remainder = self.project:getWorkRemainder()
	
	if remainder < 10000 then
		self.workPointsDisplay:setText(string.comma(remainder))
	else
		self.workPointsDisplay:setText(string.roundtobignumbernodecimals(remainder))
	end
end

function activeProject:updateProgressBar(force)
	local oldProgress = self.progress
	local progress = self:getCompletion()
	
	self.progress = progress
	
	if progress ~= oldProgress or force then
		self:updateVisualProgressBar()
		
		if self.workPointsDisplay then
			self:updateWorkPoints()
			self:updateWorkCompletion()
		end
		
		return true
	end
	
	return false
end

function activeProject:getCompletion()
	return self.project:getOverallCompletion()
end

function activeProject:updateUnderProgressBar()
	local baseX = _S(self.barXOffset)
	local barWidth = self.rawW - self.barXOffset * 2
	local barY = self.barY
	local barH = self.barHeight
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.underBarSpriteOuter = self:allocateHollowRoundedRectangle(self.underBarSpriteOuter, baseX - _S(1), barY - _S(1), barWidth + 2, barH + 2, 2, -0.5)
	
	self:setNextSpriteColor(45, 45, 45, 255)
	
	self.underBarSprite = self:allocateSprite(self.underBarSprite, "generic_1px", baseX, barY, 0, barWidth, barH, 0, 0, -0.3)
end

function activeProject:updateVisualProgressBar()
	local baseX = _S(self.barXOffset)
	local barWidth = self.rawW - self.barXOffset * 2
	local barY = self.barY
	local barH = self.barHeight
	
	self:setNextSpriteColor(self.barColor:unpack())
	
	self.progressSprite = self:allocateSprite(self.progressSprite, "generic_1px", baseX, barY, 0, barWidth * self.progress, barH, 0, 0, -0.3)
end

function activeProject:onMouseEntered()
	activeProject.baseClass.onMouseEntered(self)
	self:queueSpriteUpdate()
end

function activeProject:onMouseLeft()
	activeProject.baseClass.onMouseLeft(self)
	self:queueSpriteUpdate()
end

activeProject.barXOffset = 6
activeProject.barSizeReduce = 2

function activeProject:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.6)
	
	self:setNextSpriteColor(self:getStateColor():unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.59)
	
	self:setNextSpriteColor(self.genericFillColor:unpack())
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(3), _S(3), self.rawW - 6, self.rawH - 6, 2, -0.58)
	
	self:updateUnderProgressBar()
	self:updateVisualProgressBar()
end

function activeProject:draw(w, h)
	self:updateProgressBar()
	
	local textColor, shadowColor = self.textColor, self.textShadowColor
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.wrappedText, _S(5), _S(2), textColor.r, textColor.g, textColor.b, textColor.a, shadowColor.r, shadowColor.g, shadowColor.b, shadowColor.a)
end

gui.register("ActiveProjectElement", activeProject, "EventBoxElement")
