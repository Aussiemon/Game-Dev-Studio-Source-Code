local attr = {}

attr.textTemplate = _T("INCREASE_ATTRIBUTE_TEXT_LAYOUT", "Increase to level NEXT_LEVEL")
attr.maxLevel = _T("MAX_ATTRIBUTE_LEVEL", "Maximum level reached")
attr.relevantAttributeText = _T("RELEVANT_ATTRIBUTE_TEXT", "This attribute is relevant to the employees role.")
attr.relevantAttributeColor = color(220, 255, 220, 255)
attr.irrelevantAttributeText = _T("IRRELEVANT_ATTRIBUTE_TEXT", "This attribute is irrelevant to the employees role.")
attr.irrelevantAttributeColor = color(180, 180, 180, 255)
attr.skinPanelFillColor = color(60, 60, 60, 255)

function attr:init()
	events:addReceiver(self)
end

function attr:kill()
	self.baseClass.kill(self)
	events:removeReceiver(self)
	self:killDescBox()
end

function attr:handleEvent(event, data)
	if event == developer.EVENTS.ATTRIBUTE_INCREASED and data == self.button:getEmployee() then
		self:validateState()
	end
end

function attr:setBaseButton(button)
	self.button = button
	
	self:validateState()
end

function attr:validateState()
	local attributeLevel = self.button:getEmployee():getAttribute(self.button:getAttribute())
	local availableUpgrades = attributeLevel < attributes.DEFAULT_MAX
	
	self.isActive = self.button:getEmployee():hasAttributePoints() and availableUpgrades
	
	if availableUpgrades then
		self:setText(string.easyformatbykeys(attr.textTemplate, "NEXT_LEVEL", attributeLevel + 1))
	else
		self:setText(attr.maxLevel)
	end
end

function attr:onMouseEntered()
	local attribute = self.button:getAttribute()
	local attributeData = attributes.registeredByID[attribute]
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(attributeData.description, "pix24", nil, nil, 500)
	
	local x, y = self:getSide(gui.SIDES.RIGHT + gui.SIDES.BOTTOM)
	
	self.descBox:setPos(x - self.descBox:getWidth(), y)
end

function attr:onMouseLeft()
	self:killDescBox()
end

function attr:isDisabled()
	return not self.isActive
end

function attr:onClick(x, y, key)
	if not self.isActive then
		return 
	end
	
	local employee = self.button:getEmployee()
	local attribute = self.button:getAttribute()
	
	employee:increaseAttribute(attribute, false)
end

gui.register("AttributeUpgradeButton", attr, "Button")
