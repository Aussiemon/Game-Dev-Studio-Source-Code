local attributePointDisplay = {}

attributePointDisplay.CATCHABLE_EVENTS = {
	developer.EVENTS.ATTRIBUTE_INCREASED
}
attributePointDisplay.font = "pix22"
attributePointDisplay.skinTextSelectColor = color(245, 245, 245, 255)

function attributePointDisplay:handleEvent(event)
	if event == developer.EVENTS.ATTRIBUTE_INCREASED then
		self:updateDisplay()
	end
end

function attributePointDisplay:_updateFont()
	if self.employee and self.employee:getAttributePoints() > 0 then
		self.font = "bh20"
	else
		self.font = "pix20"
	end
	
	self:updateFont()
end

function attributePointDisplay:isOn()
	return self.active
end

function attributePointDisplay:recreateDescbox()
	local wrapWidth = 350
	
	if self.descBox then
		self.descBox:removeAllText()
	else
		self.descBox = gui.create("GenericDescbox")
	end
	
	self.descBox:addText(_T("ATTRIBUTE_POINTS_DESCRIPTION_1", "Used for increasing employee Attributes levels."), "pix18", nil, 5, wrapWidth)
	self.descBox:addText(_format(_T("ATTRIBUTE_POINTS_DESCRIPTION_2", "Earned once per level, for a total of LEVELS levels, so spend them wisely!"), "LEVELS", developer.MAX_LEVEL), "pix16", nil, 5, wrapWidth)
	self.descBox:addText(_T("ATTRIBUTE_POINTS_DESCRIPTION_3", "Specializing attributes is a better idea than generalizing them."), "pix16", nil, 0, wrapWidth)
	self.descBox:centerToElement(self)
end

function attributePointDisplay:setEmployee(employee)
	attributePointDisplay.baseClass.setEmployee(self, employee)
	self:updateDisplay()
end

function attributePointDisplay:updateDisplay()
	self.pointCount = self.employee:getAttributePoints()
	self.active = self.pointCount > 0
	
	self:_updateFont()
	self:updateAttributeLevelText()
end

function attributePointDisplay:updateAttributeLevelText()
	local points = self.pointCount
	
	if points == 0 then
		apText = _T("ZERO_ATTRIBUTE_POINTS", "0 Points")
	elseif points == 1 then
		apText = _T("ONE_ATTRIBUTE_POINTS_MINIMAL", "1 Point")
	else
		apText = _format(_T("ATTRIBUTE_POINT_COUNT_MULTIPLE", "POINTS Points"), "POINTS", points)
	end
	
	self.attributeLevelText = apText
end

function attributePointDisplay:updateBackgroundSprite()
	if self.pointCount > 0 then
		self:setNextSpriteColor(self.baseColorAttentionFinish:unpack())
	else
		local underColor = self:isMouseOver() and self.baseColor or self.baseColorInactive
		
		self:setNextSpriteColor(underColor:unpack())
	end
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function attributePointDisplay:getIcon()
	return "attribute_points"
end

function attributePointDisplay:onClick()
end

gui.register("AttributePointDisplay", attributePointDisplay, "AttributeLevelDisplay")
