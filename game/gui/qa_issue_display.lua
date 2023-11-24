local qaIssueDisplay = {}

qaIssueDisplay.skinPanelFillColor = color(86, 104, 135, 200)
qaIssueDisplay.CATCHABLE_EVENTS = {
	gameProject.EVENTS.QA_OVER,
	project.EVENTS.SCRAPPED_PROJECT,
	gameProject.EVENTS.QA_PROGRESSED
}

function qaIssueDisplay:init()
	self.leftInfo = gui.create("GenericDescbox", self)
	
	self.leftInfo:setShowRectSprites(false)
	self.leftInfo:setY(5)
	self.leftInfo:overwriteDepth(10)
	
	self.rightInfo = gui.create("GenericDescbox", self)
	
	self.rightInfo:setShowRectSprites(false)
	
	self.rightInfo.alignedToRight = true
	
	self.rightInfo:overwriteDepth(10)
end

function qaIssueDisplay:createBarDisplay()
end

function qaIssueDisplay:postResolutionChange()
	self:setSize(self.rawW, self.rawH)
	self:fullSetup()
end

function qaIssueDisplay:setData(proj)
	self.project = proj
	
	self:fullSetup()
end

function qaIssueDisplay:handleEvent(event, gameProj)
	if gameProj == self.project then
		if event == gameProject.EVENTS.QA_PROGRESSED then
			self:updateDisplay()
		else
			self:kill()
		end
	end
end

function qaIssueDisplay:fullSetup()
	self.leftInfo:removeAllText()
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_format(_T("QA_FOR_PROJECT", "QA - 'PROJECT'"), "PROJECT", self.project:getName()), "bh18", nil, 2, self.rawW)
	self.rightInfo:setY(self.leftInfo.h - _S(2))
	
	for key, issueData in ipairs(issues.registered) do
		if key % 2 == 0 then
			self.leftInfo:addTextLine(scaledWrapWidth, game.UI_COLORS.LINE_COLOR_ONE)
		else
			self.leftInfo:addTextLine(scaledWrapWidth, game.UI_COLORS.LINE_COLOR_TWO)
		end
		
		self.leftInfo:addText(issueData.display, "bh16", nil, 0, self.rawW, {
			{
				width = 12,
				height = 12,
				y = 0,
				x = 1,
				icon = issueData.icon
			}
		})
	end
	
	self:setHeight(_US(self.leftInfo:getHeight()) + 5)
	self:updateDisplay()
end

function qaIssueDisplay:updateDisplay()
	self.rightInfo:removeAllText()
	
	local qaIssues, thisRound = self.project:getFoundQAIssues()
	
	for key, issueData in ipairs(issues.registered) do
		if thisRound[issueData.id] and thisRound[issueData.id] > 0 then
			self.rightInfo:addText(_format(_T("QA_ISSUES_FOUND_ROUND", "TOTAL (+ROUND)"), "TOTAL", tostring(qaIssues[issueData.id] or 0), "ROUND", thisRound[issueData.id]), "bh16", nil, 0, self.rawW)
		else
			self.rightInfo:addText(tostring(qaIssues[issueData.id] or 0), "bh16", nil, 0, self.rawW)
		end
	end
	
	self.rightInfo:setX(self.w - self.rightInfo.w - _S(4))
end

function qaIssueDisplay:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(self.skinPanelFillColor:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

gui.register("QAIssueDisplay", qaIssueDisplay, "ProjectInfoBarDisplayFrame")
