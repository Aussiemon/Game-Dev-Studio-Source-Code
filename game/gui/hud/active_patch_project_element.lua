local activePatchProject = {}

activePatchProject.textColor = color(255, 255, 255, 255)
activePatchProject.panelColor = color(0, 0, 0, 150)
activePatchProject.textShadowColor = color(0, 0, 0, 255)
activePatchProject.finishedColor = color(200, 255, 200, 150)
activePatchProject.finishedBarColor = color(127, 195, 255, 255)

function activePatchProject:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or activePatchProject.textColor
	self.textShadowColor = textShadowColor or activePatchProject.textShadowColor
	self.alpha = 1
end

function activePatchProject:fillInteractionComboBox(comboBox)
	self.project:fillInteractionComboBox(comboBox)
end

function activePatchProject:getText()
	return string.easyformatbykeys(_T("PATCH_NAME_DISPLAY_LAYOUT", "'PROJECT' - patch"), "PROJECT", self.project:getName())
end

function activePatchProject:getCompletion()
	return self.project:getPatchProgress()
end

function activePatchProject:updateColor()
	self.barColor = activePatchProject.barColor
	
	self:setOverrideAlphaLevels(false)
end

function activePatchProject:updateWorkCompletion()
	self.workCompletionDisplay:setText(_format("COMPLETION%", "COMPLETION", math.round(self:getCompletion() * 100, 1)))
end

function activePatchProject:updateWorkPoints()
end

function activePatchProject:onTargetObjectSet()
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
	
	activePatchProject.baseClass.onTargetObjectSet(self)
end

function activePatchProject:createWorkPointsDisplay()
	if not self.workCompletionDisplay then
		self.workCompletionDisplay = gui.create("ProjectElementInfoDisplay", self)
		
		self.workCompletionDisplay:setIcon("demolition_blue")
		self.workCompletionDisplay:setSize(54, 18)
		self.workCompletionDisplay:setFont("bh16")
		self.workCompletionDisplay:setCanHover(false)
		self:updateWorkCompletion()
	end
end

function activePatchProject:adjustDisplayPositions()
	local y = self.textHeight + _S(6)
	local scaledFive = _S(5)
	local x = scaledFive
	
	for key, element in ipairs(self.issueDisplayElements) do
		element:setPos(x, y)
		
		x = x + scaledFive + element.w
	end
	
	self.workCompletionDisplay:setPos(x, y)
	
	self.barY = self.workCompletionDisplay.localY + self.workCompletionDisplay.h + _S(6)
end

function activePatchProject:updateIssueDisplay(issueType)
	local element = self.issueDisplayElements[issues.registeredByID[issueType].index]
	
	element:setText(self.project:getDiscoveredUnfixedIssueCount(issueType))
end

function activePatchProject:adjustHeight(textHeight)
	if self.workCompletionDisplay then
		return _US(textHeight) + 44
	end
	
	return _US(textHeight) + 24
end

function activePatchProject:onMouseEntered()
	activePatchProject.baseClass.onMouseEntered(self)
	self:setupDescbox()
end

function activePatchProject:setupDescbox()
	if self.descBox then
		self.descBox:removeAllText()
	end
	
	self.descBox = self.descBox or gui.create("GenericDescbox")
	
	local wrapW = 300
	
	self.project:setupInfoDescbox(self.descBox, wrapW)
	self.descBox:positionToElement(self, self.w + _S(20), -self.descBox:getHeight() + self.h)
end

function activePatchProject:onMouseLeft()
	activePatchProject.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function activePatchProject:handleEvent(event, data, issueType)
	activePatchProject.baseClass.handleEvent(self, event, data)
	
	if (event == patchProject.EVENTS.FINISHED or event == patchProject.EVENTS.CANCELLED) and data == self.project then
		self:kill()
	elseif (event == gameProject.EVENTS.ISSUE_DISCOVERED or event == gameProject.EVENTS.ISSUE_FIXED) and self.project:getTargetProject() == data:getTargetProject() then
		self:updateIssueDisplay(issueType)
	end
end

gui.register("ActivePatchProjectElement", activePatchProject, "ActiveProjectElement")
