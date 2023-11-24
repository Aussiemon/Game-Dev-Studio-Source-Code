local preferenceCheckbox = {}

preferenceCheckbox.horizontalAlignment = gui.SIDES.LEFT
preferenceCheckbox.backColor1 = color(138.6, 147, 147.7, 255)
preferenceCheckbox.backColor2 = color(178.20000000000002, 189, 189.9, 255)
preferenceCheckbox.backColor2Selected = color(90, 174, 118, 255)
preferenceCheckbox.backColor2Hover = color(101, 148, 188, 255)
preferenceCheckbox.crossColor = color(255, 255, 255, 255)

function preferenceCheckbox:setPreferenceData(data)
	self.preferenceData = data
end

function preferenceCheckbox:isOn()
	return self.preferenceData:isOnCheck(self)
end

function preferenceCheckbox:onClick(x, y, key)
	preferences:set(self.preferenceData.id, not preferences:get(self.preferenceData.id))
	self:queueSpriteUpdate()
end

function preferenceCheckbox:onMouseEntered()
	self:queueSpriteUpdate()
end

function preferenceCheckbox:onMouseLeft()
	self:queueSpriteUpdate()
end

gui.register("PreferenceCheckbox", preferenceCheckbox, "Checkbox")
