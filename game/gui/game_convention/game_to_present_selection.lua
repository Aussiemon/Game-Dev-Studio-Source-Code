local gameToPresentSelection = {}

gameToPresentSelection.selectedPanelColor = game.UI_COLORS.IMPORTANT_3:duplicate()

gameToPresentSelection.selectedPanelColor:lerp(0.05, 0, 0, 0, 255)

gameToPresentSelection.selectedPanelColor.a = 200
gameToPresentSelection.selectedHoverPanelColor = game.UI_COLORS.IMPORTANT_3:duplicate()

gameToPresentSelection.selectedHoverPanelColor:lerp(0.2, 0, 0, 0, 255)

gameToPresentSelection.selectedHoverPanelColor.a = 200
gameToPresentSelection.canPropagateKeyPress = true
gameToPresentSelection.basePanelColor = color(86, 104, 135, 255)
gameToPresentSelection.hoverPanelColor = color(175, 160, 75, 255)
gameToPresentSelection.basePanelColorUnavailable = color(127, 134, 135, 255)
gameToPresentSelection.hoverPanelColorUnavailable = color(106, 120, 140, 255)

function gameToPresentSelection:init()
end

function gameToPresentSelection:setProject(project)
	self.gameProject = project
	
	self:createInfoLists()
end

function gameToPresentSelection:handleEvent(event)
	if event == gameConventions.EVENTS.BOOTH_CHANGED then
		self:queueSpriteUpdate()
	end
end

function gameToPresentSelection:setConventionData(data)
	self.conventionData = data
end

function gameToPresentSelection:onKill()
	self:killDescBox()
end

function gameToPresentSelection:onMouseEntered()
	self:queueSpriteUpdate()
end

function gameToPresentSelection:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function gameToPresentSelection:getBasePanelColor()
	if self.conventionData:hasDesiredGame(self.gameProject) then
		if self:isMouseOver() then
			return gameToPresentSelection.selectedHoverPanelColor
		end
		
		return gameToPresentSelection.selectedPanelColor
	end
	
	if self:isMouseOver() then
		return gameToPresentSelection.hoverPanelColor
	end
	
	return gameToPresentSelection.basePanelColor
end

function gameToPresentSelection:onClick(x, y, key)
	if self.conventionData:hasDesiredGame(self.gameProject) then
		self.conventionData:removeDesiredGame(self.gameProject)
	elseif self.conventionData:getDesiredBooth() then
		self.conventionData:addDesiredGame(self.gameProject)
	else
		local popup = game.createPopup(500, _T("NO_BOOTH_SELECTED_TITLE", "No Booth Selected"), _T("NO_BOOTH_SELECTED_GAMES_DESCRIPTION", "You must first select the booth size before you can select games for presentation."), "pix24", "pix20")
		
		popup:center()
		frameController:push(popup)
	end
	
	self:queueSpriteUpdate()
	self:killDescBox()
end

function gameToPresentSelection:adjustInfoLists()
end

function gameToPresentSelection:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local font = "bh22"
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont(font)
	nameDisplay:setText(string.cutToWidth(self.gameProject:getName(), fonts.get(font), _S(baseElementSize)))
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(gameToPresentSelection.gradientColor)
	
	local completionDisplay = self.gameProject:createCompletionDisplay(self.leftList, "pix22", true)
	
	completionDisplay:setBaseSize(baseElementSize, 0)
	completionDisplay:setIconSize(25, 25)
	completionDisplay:setBackdropSize(27)
	completionDisplay:setIconOffset(1, 1)
	self.leftList:updateLayout()
	
	self.rightList = gui.create("List", self)
	
	self.rightList:setPos(self.leftList.x + self.leftList.w)
	self.rightList:setPanelColor(developer.employeeMenuListColor)
	self.rightList:setCanHover(false)
	
	self.rightList.shouldDraw = false
	
	local issueDisplay = self.gameProject:createTotalIssueDisplay(self.rightList, "pix22", true)
	
	issueDisplay:setBaseSize(baseElementSize, 0)
	issueDisplay:setIconSize(25, 25)
	issueDisplay:setBackdropSize(27)
	issueDisplay:setIconOffset(1, 1)
	
	local qualityDisplay = self.gameProject:createQualityPointsDisplay(self.rightList, "pix20", true)
	
	qualityDisplay:setBaseSize(baseElementSize, 0)
	qualityDisplay:setIconSize(24, 24, 26)
	qualityDisplay:setIconOffset(2, 1)
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

gui.register("GameToPresentSelection", gameToPresentSelection, "EmployeeTeamAssignmentButton")
