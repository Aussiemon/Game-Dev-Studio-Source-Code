local attributeLevelDisplay = {}

attributeLevelDisplay.skinTextFillColor = color(240, 240, 240, 255)
attributeLevelDisplay.skinTextHoverColor = color(255, 255, 255, 255)
attributeLevelDisplay.baseColorInactive = game.UI_COLORS.NEW_HUD_FILL_3
attributeLevelDisplay.baseColor = game.UI_COLORS.NEW_HUD_HOVER
attributeLevelDisplay.baseColorAttentionStart = game.UI_COLORS.GREEN
attributeLevelDisplay.baseColorAttentionFinish = game.UI_COLORS.LIGHT_GREEN
attributeLevelDisplay.textCostColor = color(238, 247, 190, 255)
attributeLevelDisplay.textBuyColor = color(247, 226, 190, 255)
attributeLevelDisplay.underIconColor = color(0, 0, 0, 100)
attributeLevelDisplay.progressBarColor = color(190, 226, 145, 255)
attributeLevelDisplay.progressBarHeight = 8
attributeLevelDisplay.font = "bh26"
attributeLevelDisplay.flashSpeed = 0.3

function attributeLevelDisplay:init()
	self.acknowledged = false
	
	self:updateFont()
end

function attributeLevelDisplay:handleEvent(event, employee, attributeID)
	if event == developer.EVENTS.ATTRIBUTE_INCREASED and attributeID == self.attributeData.id then
		self:updateAttributeLevelText()
	end
end

function attributeLevelDisplay:updateFont()
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
end

function attributeLevelDisplay:setScalingState(hor, vert)
	attributeLevelDisplay.baseClass.setScalingState(self, true, true)
end

function attributeLevelDisplay:setEmployee(employee)
	self.employee = employee
end

function attributeLevelDisplay:setAttributeData(data)
	self.attributeData = data
	
	self:updateAttributeLevelText()
end

function attributeLevelDisplay:updateAttributeLevelText()
	self.attributeLevel = self.employee:getAttribute(self.attributeData.id)
	self.attributeLevelText = string.easyformatbykeys(_T("ATTRIBUTE_DISPLAY_SHORT", "Lv. LEVEL"), "LEVEL", self.attributeLevel)
end

function attributeLevelDisplay:setFlashOffset(offset)
	self.flashOffset = offset
end

function attributeLevelDisplay:recreateDescbox()
	local wrapWidth = 400
	
	if self.descBox then
		self.descBox:removeAllText()
	else
		self.descBox = gui.create("GenericDescbox")
	end
	
	self.descBox:addText(string.easyformatbykeys(_T("ATTRIBUTE_TITLE_LEVEL_LAYOUT", "ATTRIBUTENAME - Level LEVEL/MAX"), "ATTRIBUTENAME", self.attributeData.display, "LEVEL", self.employee:getAttribute(self.attributeData.id), "MAX", attributes.DEFAULT_MAX), "pix18", nil, 10, wrapWidth)
	self.descBox:addText(self.attributeData.description, "pix16", nil, 0, wrapWidth)
	self.attributeData:formatDescriptionText(self.descBox, self.employee, wrapWidth)
	
	local canImprove = self.employee:canImproveAttribute(self.attributeData.id)
	
	if canImprove then
		self.descBox:addSpaceToNextText(_S(10))
		
		local cost = attributes:getRequiredAttributePoints(self.employee, self.attributeData.id)
		local attributePointText = cost == 1 and _T("ATTRIBUTE_POINT", "attribute point") or _T("ATTRIBUTE_POINTS", "attribute_points")
		
		self.descBox:addText(string.easyformatbykeys(_T("CLICK_TO_INCREASE_ATTRIBUTE", "Click to increase this attribute to level LEVEL."), "LEVEL", self.attributeLevel + 1), "pix16", self.textBuyColor, 0, wrapWidth)
		self.descBox:addText(string.easyformatbykeys(_T("ATTRIBUTE_POINT_COST", "Costs COST ATTRIBUTE_POINT_TEXT"), "COST", cost, "ATTRIBUTE_POINT_TEXT", attributePointText), "pix16", self.textCostColor, 0, wrapWidth)
	end
	
	self.descBox:centerToElement(self)
end

function attributeLevelDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	self:recreateDescbox()
	
	self.acknowledged = true
end

function attributeLevelDisplay:think(dt)
	self:updateBackgroundSprite()
end

function attributeLevelDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function attributeLevelDisplay:onClick()
	if self.employee:canImproveAttribute(self.attributeData.id) then
		self.employee:increaseAttribute(self.attributeData.id, false)
		
		self.attributeLevel = self.employee:getAttribute(self.attributeData.id)
		
		self:recreateDescbox()
	end
end

function attributeLevelDisplay:getIconSize()
	return self.rawH - 4
end

function attributeLevelDisplay:updateBackgroundSprite()
	if self.employee:canImproveAttribute(self.attributeData.id) and not self.acknowledged then
		self:setNextSpriteColor(self.baseColorAttentionStart:lerpColorResult(math.flash(curTime + self.flashOffset, self.flashSpeed), self.baseColorAttentionFinish))
	else
		local underColor = self:isMouseOver() and attributeLevelDisplay.baseColor or attributeLevelDisplay.baseColorInactive
		
		self:setNextSpriteColor(underColor:unpack())
	end
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function attributeLevelDisplay:getIcon()
	return self.attributeData.icon
end

function attributeLevelDisplay:updateSprites()
	self:updateBackgroundSprite()
	
	local iconSize = self:getIconSize()
	local scaledTwo = _S(2)
	
	self:setNextSpriteColor(attributeLevelDisplay.underIconColor:unpack())
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	self.iconSprite = self:allocateSprite(self.iconSprite, self:getIcon(), scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
end

function attributeLevelDisplay:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.attributeLevelText, _S(self:getIconSize() + 8), self.h * 0.5 - self.fontHeight * 0.5, tcol.r, tcol.g, tcol.b, tcol.a)
end

gui.register("AttributeLevelDisplay", attributeLevelDisplay)
