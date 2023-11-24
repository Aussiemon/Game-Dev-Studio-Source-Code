local attributeAssignmentGradient = {}

attributeAssignmentGradient.availableAttributePointsTextColor = color(228, 255, 201, 255)
attributeAssignmentGradient.unavailableAttributePointsTextColor = color(255, 255, 255, 255)
attributeAssignmentGradient.backdropSize = 24
attributeAssignmentGradient.iconSize = 24
attributeAssignmentGradient.backdropVisible = false
attributeAssignmentGradient.textPad = 0
attributeAssignmentGradient.descBoxWrapWidth = 400

function attributeAssignmentGradient:init()
	self.increaseButton = gui.create("ChangeAttributeButton", self)
	
	self.increaseButton:setSize(24, 24)
	self.increaseButton:setDirection(1)
	
	self.decreaseButton = gui.create("ChangeAttributeButton", self)
	
	self.decreaseButton:setSize(24, 24)
	self.decreaseButton:setDirection(-1)
end

function attributeAssignmentGradient:handleEvent(event, employee)
	if event == developer.EVENTS.ATTRIBUTE_CHANGED then
		self:updateText()
	end
end

function attributeAssignmentGradient:onSizeChanged()
	self:positionAssignmentButtons()
end

function attributeAssignmentGradient:positionAssignmentButtons()
	if self.increaseButton then
		self.increaseButton:setPos(self.w - _S(2) - self.increaseButton.w, _S(2))
		self.decreaseButton:setPos(self.increaseButton.x - _S(4) - self.decreaseButton.w, _S(2))
	end
end

function attributeAssignmentGradient:setEmployee(employee)
	self.employee = employee
end

function attributeAssignmentGradient:getEmployee()
	return self.employee
end

function attributeAssignmentGradient:onMouseEntered()
	attributeAssignmentGradient.baseClass.onMouseEntered(self)
	self.attributeData:formatDescriptionText(self.descBox, self.employee, self.descBoxWrapWidth)
end

function attributeAssignmentGradient:updateSprites()
	attributeAssignmentGradient.baseClass.updateSprites(self)
	
	local halfGradientPad = _S(self.gradientPad) * 0.5
	local offX, offY = self:getIconOffset()
	local iconW, iconH = self:getIconSize()
	
	self.iconBGSprite = self:allocateSprite(self.iconBGSprite, "profession_backdrop", _S(offX) + halfGradientPad, _S(offY) + halfGradientPad, 0, iconW, iconH, 0, 0, -0.2)
end

function attributeAssignmentGradient:setAttributeID(attribute)
	self.attribute = attribute
	
	local attributeData = attributes:getData(self.attribute)
	
	self.attributeData = attributeData
	
	self:setIcon(attributeData.icon)
	self:setHoverText(attributeData.description)
	self:updateText()
end

function attributeAssignmentGradient:getAttributeID()
	return self.attribute
end

function attributeAssignmentGradient:updateText()
	local attributeData = attributes:getData(self.attribute)
	
	self.text = string.easyformatbykeys(_T("ATTRIBUTE_ASSIGNMENT", "ATTRIBUTE Lv. LEVEL"), "ATTRIBUTE", attributeData.display, "LEVEL", self.employee:getAttribute(self.attribute))
	
	self:updateTextDimensions()
end

gui.register("AttributeAssignmentGradientIconPanel", attributeAssignmentGradient, "GradientIconPanel")
