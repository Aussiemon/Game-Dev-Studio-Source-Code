local specializationCheckbox = {}

specializationCheckbox.horizontalAlignment = gui.SIDES.LEFT
specializationCheckbox.backColor1 = color(138.6, 147, 147.7, 255)
specializationCheckbox.backColor2 = color(178.20000000000002, 189, 189.9, 255)
specializationCheckbox.backColor2Selected = color(90, 174, 118, 255)
specializationCheckbox.backColor2Hover = color(101, 148, 188, 255)
specializationCheckbox.crossColor = color(255, 255, 255, 255)
specializationCheckbox.CATCHABLE_EVENTS = {
	developer.EVENTS.DESIRED_SPECIALIZATION_SET
}

function specializationCheckbox:isOn()
	return self.selected
end

function specializationCheckbox:handleEvent()
	self.selected = self.parent:getEmployee():getDesiredSpec() == self.parent:getSpecializationData().id
	
	self:queueSpriteUpdate()
end

function specializationCheckbox:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.parent:getEmployee():setDesiredSpec(self.parent:getSpecializationData().id)
	end
end

function specializationCheckbox:onMouseEntered()
	self:queueSpriteUpdate()
end

function specializationCheckbox:onMouseLeft()
	self:queueSpriteUpdate()
end

gui.register("SpecializationCheckbox", specializationCheckbox, "Checkbox")
