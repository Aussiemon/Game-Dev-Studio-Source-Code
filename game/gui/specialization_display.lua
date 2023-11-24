local specializationDisplay = {}

specializationDisplay.skinPanelNonHoverColor = color(0, 0, 0, 100)
specializationDisplay.skinPanelHoverColor = game.UI_COLORS.LIGHT_BLUE:duplicate()
specializationDisplay.skinPanelHoverColor.a = 30
specializationDisplay.skinPanelSelectedColor = game.UI_COLORS.LIGHT_BLUE:duplicate()
specializationDisplay.skinPanelSelectedColor.a = 50
specializationDisplay.skinPanelHoverColor.a = 150
specializationDisplay.hoverTextColor = color(219, 228, 255, 255)
specializationDisplay.CATCHABLE_EVENTS = {
	developer.EVENTS.DESIRED_SPECIALIZATION_SET
}

function specializationDisplay:init()
	self.checkbox = gui.create("SpecializationCheckbox", self)
	self.label = gui.create("Label", self)
	
	self.label:setFont("pix24")
	self.label:setCanHover(false)
end

function specializationDisplay:setEmployee(employee)
	self.employee = employee
end

function specializationDisplay:getEmployee()
	return self.employee
end

function specializationDisplay:setSpecializationData(data)
	self.specData = data
	
	self.label:setText(data.display)
end

function specializationDisplay:getSpecializationData()
	return self.specData
end

function specializationDisplay:handleEvent(event, state, id)
	self:queueSpriteUpdate()
end

function specializationDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	self.label:setTextColor(self.hoverTextColor)
end

function specializationDisplay:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.employee:setDesiredSpec(self.specData.id)
	end
end

function specializationDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self.label:resetTextColor()
end

function specializationDisplay:updateSprites()
	local clr
	
	if self:isMouseOver() then
		clr = self.skinPanelHoverColor
	elseif self.specData.id == self.employee:getDesiredSpec() then
		clr = self.skinPanelSelectedColor
	else
		clr = self.skinPanelNonHoverColor
	end
	
	self:setNextSpriteColor(clr:unpack())
	
	self.roundedRectangles = self:allocateRoundedRectangle(self.roundedRectangles, 0, 0, self.rawW, self.rawH, 4, -0.1)
	
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "weak_gradient_horizontal", 0, _S(2), 0, self.rawW - 6, self.rawH - 4, 0, 0, -0.1)
end

function specializationDisplay:onSizeChanged()
	self.checkbox:setSize(self.rawH - 4, self.rawH - 4)
	self.checkbox:setPos(self.w - self.checkbox.w - _S(2), _S(2))
	self.label:setPos(_S(2), 0)
	self.label:centerY()
end

gui.register("SpecializationDisplay", specializationDisplay)
