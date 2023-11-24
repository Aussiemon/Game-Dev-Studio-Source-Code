local activeProject = {}

activeProject.textColor = color(255, 255, 255, 255)
activeProject.panelColor = color(0, 0, 0, 150)
activeProject.textShadowColor = color(0, 0, 0, 255)
activeProject.finishedColor = color(200, 255, 200, 150)
activeProject.finishedBarColor = color(127, 195, 255, 255)
activeProject.barSpacing = 4
activeProject.REMOVE_SELF_EVENTS = {
	[project.EVENTS.SCRAPPED_PROJECT] = true
}

function activeProject:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or activeProject.textColor
	self.textShadowColor = textShadowColor or activeProject.textShadowColor
	self.alpha = 1
	self.underBarSprites = {}
	self.underBarSpriteOuter = {}
	self.barSprites = {}
	
	events:addReceiver(self)
end

function activeProject:onKill()
	self.baseClass.onKill(self)
	events:removeReceiver(self)
end

function activeProject:fillInteractionComboBox(comboBox)
	self.project:fillInteractionComboBox(comboBox)
end

function activeProject:onTargetObjectSet()
	if not self.issueDisplayElements then
		self.issueDisplayElements = {}
		
		for key, issueData in ipairs(issues.registered) do
			local element = gui.create("ProjectElementInfoDisplay", self)
			
			element:setIcon(issueData.icon)
			element:setSize(45, 18)
			element:setFont("bh16")
			element:setText(self.project:getDiscoveredUnfixedIssueCount(issueData.id))
			element:setCanHover(false)
			table.insert(self.issueDisplayElements, element)
		end
	end
	
	self:updateAlphaLevels()
	activeProject.baseClass.onTargetObjectSet(self)
end

function activeProject:adjustDisplayPositions()
	local textH = self.textHeight
	local y = textH + _S(5)
	local scaledFive = _S(5)
	local x = scaledFive
	
	for key, element in ipairs(self.issueDisplayElements) do
		element:setPos(x, y)
		
		x = x + scaledFive + element.w
	end
	
	self.workPointsDisplay:setPos(x, y)
	
	x = x + scaledFive + self.workPointsDisplay.w
	
	self.workCompletionDisplay:setPos(x, y)
	
	self.barY = self.workPointsDisplay.localY + self.workPointsDisplay.h + _S(6)
end

function activeProject:updateIssueDisplay(issueType)
	local element = self.issueDisplayElements[issues.registeredByID[issueType].index]
	
	element:setText(self.project:getDiscoveredUnfixedIssueCount(issueType))
end

function activeProject:adjustHeight(textHeight)
	return _US(textHeight) + 44
end

function activeProject:getText()
	local text = self.project:getName()
	local contractor = self.project:getContractor() or self.project:getPublisher()
	
	if contractor then
		local data = self.project:getContractData()
		local deadline = data:getDeadline()
		local milestoneDate, milestonePercentage, wasFinalReached = data:getMilestoneData()
		
		if not wasFinalReached then
			text = text .. "\n" .. string.easyformatbykeys(_T("CONTRACT_PROJECT_DEADLINE", "Deadline: YEAR/MONTH\nMilestone: COMPLETION% by MILESTONEY/MILESTONEM"), "YEAR", timeline:getYear(deadline), "MONTH", timeline:getMonth(deadline), "COMPLETION", math.round(milestonePercentage * 100), "MILESTONEY", timeline:getYear(milestoneDate), "MILESTONEM", timeline:getMonth(milestoneDate))
		else
			text = text .. "\n" .. string.easyformatbykeys(_T("CONTRACT_PROJECT_DEADLINE_FINISHED_MILESTONE", "Deadline: YEAR/MONTH\nFinal milestone reached!"), "YEAR", timeline:getYear(deadline), "MONTH", timeline:getMonth(deadline))
		end
	end
	
	return text
end

function activeProject:onMouseEntered()
	activeProject.baseClass.onMouseEntered(self)
	self:setupDescbox()
end

function activeProject:setupDescbox()
	if self.descBox then
		self.descBox:removeAllText()
	end
	
	local stageID, stageObject = self.project:getStage()
	local stages = self.project:getCurrentStages()
	local validStage
	
	for key, stageObject in ipairs(stages) do
		if not stageObject:isWorkFinished() and stageID == key then
			validStage = key
		end
	end
	
	local variousFixes = not validStage and stageID and self.project:getTeam()
	
	if validStage or variousFixes then
		self.descBox = self.descBox or gui.create("GenericDescbox")
		
		local wrapW = 300
		
		if not variousFixes then
			self.descBox:addText(_format(_T("PROJECT_CURRENT_STAGE", "Current stage: STAGE"), "STAGE", gameProject.STAGE_TEXT[validStage]), "bh20", nil, 0, wrapW, "question_mark", 22, 22)
			
			if validStage < #stages then
				self.descBox:addText(_format(_T("PROJECT_NEXT_STAGE", "Next stage: STAGE"), "STAGE", gameProject.STAGE_TEXT[validStage + 1]), "bh20", nil, 0, wrapW)
			end
		else
			self.descBox:addText(_T("PROJECT_STAGE_VARIOUS_FIXES", "Current stage: Various fixes"), "bh20", nil, 0, wrapW, "question_mark", 22, 22)
		end
		
		self.descBox:addSpaceToNextText(10)
		self.project:setupInfoDescbox(self.descBox, wrapW)
		self.descBox:positionToElement(self, -self.descBox.w - _S(10), -self.descBox:getHeight() + self.h)
	end
end

function activeProject:onMouseLeft()
	activeProject.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function activeProject:updateUnderProgressBar()
end

activeProject.barXOffset = 6
activeProject.barSizeReduce = 2

function activeProject:updateVisualProgressBar()
	local scaledBarSpace = _S(self.barSpacing)
	local overallWork = self.project:getTotalRequiredWork()
	local baseX = _S(self.barXOffset)
	local stages = self.project:getCurrentStages()
	local stageCount = #stages
	local barY = self.barY
	local barH = self.barHeight
	local rawW = self.rawW
	local underBarSprites, underBarSpriteOuter, barSprites = self.underBarSprites, self.underBarSpriteOuter, self.barSprites
	local sizeReduction = self.barSpacing * stageCount + self.barXOffset + self.barSizeReduce
	local baseBarW = rawW - sizeReduction - 1
	local stageClrs = gameProject.STAGE_COLORS
	local r, g, b, a = game.UI_COLORS.NEW_HUD_OUTER:unpack()
	
	for key, stageObj in ipairs(stages) do
		local finished, required = stageObj:getWorkAmounts()
		local barWidth = math.round(baseBarW * (required / overallWork))
		
		self:setNextSpriteColor(r, g, b, a)
		
		underBarSpriteOuter[key] = self:allocateHollowRoundedRectangle(underBarSpriteOuter[key], baseX - _S(1), barY - _S(1), barWidth + 2, barH + 2, 2, -0.31)
		
		self:setNextSpriteColor(45, 45, 45, 255)
		
		underBarSprites[key] = self:allocateSprite(underBarSprites[key], "generic_1px", baseX, barY, 0, barWidth, barH, 0, 0, -0.3)
		
		if finished > 0 then
			local barCompletion = finished / required
			local colors = stageClrs[key]
			
			self:setNextSpriteColor(colors.r, colors.g, colors.b, colors.a)
			
			barSprites[key] = self:allocateSprite(barSprites[key], "vertical_gradient_75", baseX, barY, 0, barWidth * barCompletion, barH, 0, 0, -0.25)
		end
		
		baseX = baseX + _S(barWidth) + scaledBarSpace
	end
end

function activeProject:updateAlphaLevels()
	if self.project:canReleaseGame() then
		self:setOverrideAlphaLevels(true)
	else
		self:setOverrideAlphaLevels(false)
	end
end

eventBoxText:registerNew({
	id = "game_released",
	getText = function(self, data)
		return _format(_T("GAME_PROJECT_RELEASED", "'GAME' has been released!"), "GAME", data:getName())
	end,
	saveData = function(self, data)
		return data:getUniqueID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getGameByUniqueID(data)
	end
})

function activeProject:handleEvent(event, data, issueType)
	activeProject.baseClass.handleEvent(self, event, data)
	
	if event == gameProject.EVENTS.REACHED_RELEASE_STATE and data == self.project then
		self:updateAlphaLevels()
	elseif event == studio.EVENTS.RELEASED_GAME and data == self.project then
		self.panelColor = activeProject.finishedColor
		
		game.addToEventBox("game_released", self.project, 1)
		self.elementBox:getScroller():removeItem(self)
		self:kill()
	elseif event == contractor.EVENTS.NEW_MILESTONE then
		self:scaleToText()
	elseif event == gameProject.EVENTS.WORK_PERIOD_EXTENDED then
		self:updateProgressBar(true)
	elseif (event == gameProject.EVENTS.ISSUE_DISCOVERED or event == gameProject.EVENTS.ISSUE_FIXED) and self.project == data then
		self:updateIssueDisplay(issueType)
	elseif event == project.EVENTS.NEW_STAGE and self.project == data and self.descBox then
		self:setupDescbox()
	end
end

gui.register("ActiveGameProjectElement", activeProject, "ActiveProjectElement")
