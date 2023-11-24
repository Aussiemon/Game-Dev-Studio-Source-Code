local slanderSelection = {}

slanderSelection.basePanelColor = color(86, 104, 135, 255)
slanderSelection.hoverPanelColor = color(179, 194, 219, 255)
slanderSelection.skinPanelSelectColor = color(125, 175, 125, 255)
slanderSelection.skinTextFillColor = color(200, 200, 200, 255)
slanderSelection.skinTextHoverColor = color(240, 240, 240, 255)
slanderSelection.skinTextDisableColor = color(200, 200, 200, 255)
slanderSelection.canPropagateKeyPress = true

function slanderSelection:setSlanderData(data)
	self.slanderData = data
end

function slanderSelection:setCompany(company)
	self.company = company
	
	self:createInfoLists()
end

function slanderSelection:startSlander()
	frameController:pop()
	self.company:schedulePlayerSlander(self.slanderData.id)
end

function slanderSelection:fillInteractionComboBox(comboBox)
	local button = comboBox:addOption(0, 0, 200, 18, _T("SLANDER_SELECT", "Select & start"), fonts.get("pix20"), slanderSelection.startSlander)
	
	button.company = self.company
	button.slanderData = self.slanderData
end

function slanderSelection:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
	self:killDescBox()
end

function slanderSelection:onMouseEntered()
	self:queueSpriteUpdate()
	gui:getElementByID(rivalGameCompanies.SLANDER_INFO_PANEL_ID):showDisplay(self.slanderData, studio)
end

function slanderSelection:onMouseLeft()
	self:queueSpriteUpdate()
	gui:getElementByID(rivalGameCompanies.SLANDER_INFO_PANEL_ID):hideDisplay()
end

function slanderSelection:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW - self.panelHorizontalSpacing * 2
	local height = 25
	local iconW, iconH = 20, 20
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("pix24")
	nameDisplay:setText(self.slanderData:getName())
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(slanderSelection.gradientColor)
	
	local costDisplay = gui.create("GradientIconPanel", self.leftList)
	
	costDisplay:setIcon("wad_of_cash")
	costDisplay:setFont("pix22")
	
	if self.slanderData:getCost() > 0 then
		costDisplay:setText(string.easyformatbykeys(_T("SLANDER_COST", "$COST"), "COST", string.comma(self.slanderData:getCost())))
	else
		costDisplay:setText(string.easyformatbykeys(_T("SLANDER_COST_FREE", "No cost")))
	end
	
	costDisplay:setBaseSize(baseElementSize, 0)
	costDisplay:setIconSize(iconW, iconH, iconW + 4)
	costDisplay:setHeight(height)
	costDisplay:setIconOffset(1, 1)
	
	local costDisplay = gui.create("GradientIconPanel", self.leftList)
	
	costDisplay:setIcon("percentage")
	costDisplay:setFont("pix22")
	costDisplay:setBackdropVisible(false)
	costDisplay:setText(string.easyformatbykeys(_T("SLANDER_SUCCESS_CHANCE", "CHANCE% chance of success"), "CHANCE", self.slanderData:getSlanderSuccessChance(studio)))
	costDisplay:setBaseSize(baseElementSize, 0)
	costDisplay:setIconSize(iconW, iconH, 0)
	costDisplay:setHeight(height)
	costDisplay:setIconOffset(1, 1)
	self.leftList:updateLayout()
	self:setHeight(self.leftList:getRawHeight())
	self.leftList:alignToBottom(0)
end

gui.register("SlanderSelection", slanderSelection, "EmployeeTeamAssignmentButton")
