local rivalInfo = {}

rivalInfo.basePanelColor = color(86, 104, 135, 255)
rivalInfo.hoverPanelColor = color(179, 194, 219, 255)
rivalInfo.skinPanelHoverColor = color(179, 194, 219, 255)
rivalInfo.skinTextFillColor = color(200, 200, 200, 255)
rivalInfo.skinTextHoverColor = color(240, 240, 240, 255)
rivalInfo.skinTextDisableColor = color(200, 200, 200, 255)
rivalInfo.canPropagateKeyPress = true

function rivalInfo:setCompany(company)
	self.company = company
	
	self:createInfoLists()
end

function rivalInfo:getCompany()
	return self.company
end

function rivalInfo:fillInteractionComboBox(comboBox)
	self.company:fillInteractionComboBox(comboBox)
end

function rivalInfo:onMouseEntered()
	rivalInfo.baseClass.onMouseLeft(self)
	gui:getElementByID(rivalGameCompanies.EXTRA_RIVAL_INFO_PANEL_ID):showDisplay(self.company)
end

function rivalInfo:onMouseLeft()
	rivalInfo.baseClass.onMouseLeft(self)
	gui:getElementByID(rivalGameCompanies.EXTRA_RIVAL_INFO_PANEL_ID):hideDisplay()
end

function rivalInfo:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
	self:killDescBox()
end

function rivalInfo:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW - self.panelHorizontalSpacing * 4
	local height = 25
	local iconW, iconH = 20, 20
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont("pix24")
	nameDisplay:setText(self.company:getName())
	nameDisplay:setHeight(height)
	nameDisplay:setGradientColor(rivalInfo.gradientColor)
	
	local employeeCountDisplay = self.company:createEmployeeCountDisplay(self.leftList, "pix24", true)
	
	employeeCountDisplay:setBaseSize(baseElementSize, 0)
	employeeCountDisplay:setIconSize(20, 22.400000000000002, 27.200000000000003)
	employeeCountDisplay:setIconOffset(4, 3)
	
	local friendOrFoe = gui.create("GradientIconPanel", self.leftList)
	
	friendOrFoe:setFont("pix22")
	friendOrFoe:setIcon("star")
	
	local text, textColor
	
	if self.company:isHostile() then
		text = _T("RIVAL_RELATIONSHIP_HOSTILE", "Foe")
		textColor = game.UI_COLORS.LIGHT_RED
	else
		text = _T("RIVAL_RELATIONSHIP_NEUTRAL", "Neutral")
		textColor = game.UI_COLORS.GREEN
	end
	
	friendOrFoe:setText(text)
	friendOrFoe:setTextColor(textColor)
	friendOrFoe:setBackdropVisible(false)
	friendOrFoe:setBaseSize(baseElementSize, 0)
	friendOrFoe:setIconSize(iconW, iconH, 0)
	friendOrFoe:setHeight(height)
	friendOrFoe:setIconOffset(1, 1)
	self.leftList:updateLayout()
	self:setHeight(self.leftList:getRawHeight())
	self.leftList:alignToBottom(0)
end

gui.register("RivalInfoDisplay", rivalInfo, "EmployeeTeamAssignmentButton")
