local attributeGradient = {}

attributeGradient.availableAttributePointsTextColor = color(228, 255, 201, 255)
attributeGradient.unavailableAttributePointsTextColor = color(255, 255, 255, 255)

function attributeGradient:init(employee)
	self.employee = employee
end

function attributeGradient:handleEvent(event, employee)
	if event == developer.EVENTS.ATTRIBUTE_INCREASED then
		self:updateText()
	end
end

function attributeGradient:updateText()
	local points = self.employee:getAttributePoints()
	
	if points > 0 then
		self:setTextColor(self.availableAttributePointsTextColor)
	else
		self:setTextColor(self.unavailableAttributePointsTextColor)
	end
	
	local apText
	
	if points == 1 then
		apText = _T("SINGLE_ATTRIBUTE_POINT", "1 Attribute point")
	elseif points > 1 then
		apText = _format(_T("ATTRIBUTE_POINT_COUNT", "POINTS attribute points"), "POINTS", points)
	else
		apText = _T("NO_ATTRIBUTE_POINTS", "No attribute points")
	end
	
	self.text = apText
	
	self:updateTextDimensions()
end

gui.register("AttributeGradientIconPanel", attributeGradient, "GradientIconPanel")
