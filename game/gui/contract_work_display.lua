local contractDisplay = {}

contractDisplay.baseColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR:duplicate()
contractDisplay.baseColor.a = 100
contractDisplay.gradientColor = color(0, 0, 0, 255)
contractDisplay.gameTitleShadowColor = color(0, 20, 33, 255)
contractDisplay.gameTitleColor = color(107, 170, 206, 255)
contractDisplay.completionTextColor = color(162, 204, 242, 255)
contractDisplay.panelColor = color(0, 0, 0, 100)
contractDisplay.barColor = color(154, 179, 206, 255)
contractDisplay.gradientHoverColor = color(255, 202, 96, 255)
contractDisplay.basePad = 3
contractDisplay.partPad = 4
contractDisplay.logoSize = 45
contractDisplay.progressBarHeight = 10
contractDisplay.completionDisplayWidth = 45
contractDisplay.completionDisplayHeight = contractDisplay.completionDisplayWidth / 2.08
contractDisplay.logoBackgroundColor = color(12, 51, 76, 100)

function contractDisplay:init()
	self.textFont = fonts.get("pix22")
	self.projectTextFont = fonts.get("bh22")
	self.progressBarW, self.progressBarH = quadLoader:getQuadSize("progress_bar_border")
	self.showMilestones = true
end

function contractDisplay:setShowMilestones(showMilestones)
	self.showMilestones = showMilestones
end

function contractDisplay:setProject(proj)
	self.project = proj
	
	local contractDataObject = self.project:getContractData()
	
	self.contractor = self.project:getContractor() or self.project:getPublisher()
	
	local dataObject = contractDataObject or self.contractor
	local deadline = dataObject:getDeadline()
	
	deadline = deadline or timeline.curTime
	
	if not self.showMilestones then
		self.contractorText = string.easyformatbykeys(_T("CONTRACT_WORK_CONTRACTOR_INFO_COMPLETED", "CONTRACTOR\nDeadline: YEAR/MONTH"), "CONTRACTOR", self.contractor:getName(), "YEAR", timeline:getYear(deadline), "MONTH", timeline:getMonth(deadline))
	else
		local milestoneDate, milestonePercentage = contractDataObject:getMilestoneData()
		
		self.contractorText = string.easyformatbykeys(_T("CONTRACT_WORK_CONTRACTOR_INFO", "CONTRACTOR\nDeadline: YEAR/MONTH\nMilestone: COMPLETION% by MILESTONEY/MILESTONEM"), "CONTRACTOR", self.contractor:getName(), "YEAR", timeline:getYear(deadline), "MONTH", timeline:getMonth(deadline), "COMPLETION", math.round(milestonePercentage * 100), "MILESTONEY", timeline:getYear(milestoneDate), "MILESTONEM", timeline:getMonth(milestoneDate))
	end
	
	self.projectNameText = string.easyformatbykeys(_T("CONTRACT_WORK_PROJECT_NAME", "\"PROJECT\""), "PROJECT", string.cutToWidth(self.project:getName(), self.projectTextFont, self.w - _S(70)))
	self.contractorTextHeight = self.textFont:getTextHeight(self.contractorText) + _S(2)
	self.projectNameTextHeight = self.projectTextFont:getTextHeight(self.projectNameText)
	self.completionText = string.easyformatbykeys(_T("PERCENTAGE", "PERCENTAGE%"), "PERCENTAGE", math.round(self.project:getOverallCompletion() * 100))
	self.completionTextWidth = self.textFont:getWidth(self.completionText)
end

function contractDisplay:onSizeChanged()
	if not self.completionTextWidth then
		return 
	end
	
	local scaledBasePad = _S(self.basePad)
	
	self.completionTextX = self.w - scaledBasePad - _S(self.completionDisplayWidth) * 0.5 - self.completionTextWidth * 0.5
	self.completionTextY = self.h - scaledBasePad * 2 - _S(self.progressBarHeight) - self.textFont:getHeight()
end

function contractDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	gui:getElementByID(game.EXTRA_CONTRACT_INFO_PANEL_ID):showDisplay(self.project)
end

function contractDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	gui:getElementByID(game.EXTRA_CONTRACT_INFO_PANEL_ID):hideDisplay()
end

function contractDisplay:fillInteractionComboBox(box)
	box:addOption(0, 0, 0, 24, _T("PROJECT_INFO", "Project info"), fonts.get("pix20"), gameProject.projectInfoCallback).project = self.project
end

function contractDisplay:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x - 20, y)
	
	comboBox.baseButton = self
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	interactionController:setInteractionObject(self, nil, nil, true)
end

function contractDisplay:updateSprites()
	local w, h = self.rawW, self.rawH
	
	self:setNextSpriteColor(self.baseColor:unpack())
	
	self.basePanelSprite = self:allocateSprite(self.basePanelSprite, "generic_1px", 0, 0, 0, w, h, 0, 0, -0.1)
	
	local scaledBasePad = _S(self.basePad)
	local scaledPartPad = _S(self.partPad)
	local scaledLogoSize = _S(self.logoSize)
	
	if self:isMouseOver() then
		self:setNextSpriteColor(self.gradientHoverColor:unpack())
	else
		self:setNextSpriteColor(self.gradientColor:unpack())
	end
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "weak_gradient_horizontal", scaledBasePad, scaledBasePad, 0, w - self.basePad * 3 - self.logoSize, h - self.basePad * 3 - self.progressBarH, 0, 0, -0.1)
	self.progressBarSprites = self:allocateProgressBar(self.progressBarSprites, scaledBasePad, self.h - scaledBasePad - _S(self.progressBarH), self.rawW - self.basePad * 2, self.progressBarH, self.project:getOverallCompletion(), self.barColor, -0.1)
	
	self:setNextSpriteColor(self.panelColor:unpack())
	
	self.completionPanel = self:allocateSprite(self.completionPanel, "generic_1px", self.w - scaledBasePad - _S(self.completionDisplayWidth), self.h - scaledBasePad * 2 - _S(self.completionDisplayHeight) - _S(self.progressBarHeight), 0, self.completionDisplayWidth, self.completionDisplayHeight, 0, 0, -0.1)
	
	local scaledLogoSize = _S(self.logoSize)
	
	self:setNextSpriteColor(contractDisplay.panelColor:unpack())
	
	self.logoBackground = self:allocateRoundedRectangle(self.logoBackground, self.w - scaledLogoSize - scaledBasePad, scaledBasePad, self.logoSize, self.logoSize, 4, -0.1)
	
	local logo = self.contractor:getLogo()
	local quadStruct = quadLoader:getQuadStructure(logo)
	local scale = quadStruct:getScaleToSize(self.logoSize)
	local height = quadStruct.h * scale
	
	self.logoSprite = self:allocateSprite(self.logoSprite, logo, self.w - scaledLogoSize - scaledBasePad, _S(self.logoSize * 0.5 + self.basePad - height * 0.5), 0, quadStruct.w * scale, height, 0, 0, -0.1)
end

function contractDisplay:draw(w, h)
	local scaledBasePad = _S(self.basePad)
	local textColor, shadowColor = self.gameTitleColor, self.gameTitleShadowColor
	
	love.graphics.setFont(self.textFont)
	love.graphics.printST(self.contractorText, scaledBasePad * 2, scaledBasePad, 255, 255, 255, 255, 0, 0, 0, 255)
	
	local completionTextColor = self.completionTextColor
	
	love.graphics.printST(self.completionText, self.completionTextX, self.completionTextY, completionTextColor.r, completionTextColor.g, completionTextColor.b, completionTextColor.a, shadowColor.r, shadowColor.g, shadowColor.b, shadowColor.a)
	love.graphics.setFont(self.projectTextFont)
	love.graphics.printST(self.projectNameText, scaledBasePad * 2, self.contractorTextHeight, textColor.r, textColor.g, textColor.b, textColor.a, shadowColor.r, shadowColor.g, shadowColor.b, shadowColor.a)
end

gui.register("ContractWorkDisplay", contractDisplay)
