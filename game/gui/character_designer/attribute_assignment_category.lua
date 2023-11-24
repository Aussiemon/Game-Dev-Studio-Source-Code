local attributeCategory = {}

function attributeCategory:handleEvent(event)
	if event == developer.EVENTS.ATTRIBUTE_CHANGED then
		self:updateText()
	end
end

function attributeCategory:updateText()
	self.attributePointText = string.easyformatbykeys(_T("FREE_ATTRIBUTE_POINTS", "POINTS Pts"), "POINTS", characterDesigner:getAvailableAttributePoints())
	self.attributePointTextWidth = self.font:getWidth(self.attributePointText)
end

function attributeCategory:draw(w, h)
	attributeCategory.baseClass.draw(self, w, h)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.attributePointText, w - _S(5) - self.attributePointTextWidth, self.drawHeight, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("AttributeAssignmentCategory", attributeCategory, "Category")
