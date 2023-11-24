local yearlyGoalCheckbox = {}

yearlyGoalCheckbox.horizontalAlignment = gui.SIDES.LEFT
yearlyGoalCheckbox.backColor1 = color(138.6, 147, 147.7, 255)
yearlyGoalCheckbox.backColor2 = color(178.20000000000002, 189, 189.9, 255)
yearlyGoalCheckbox.backColor2Selected = color(90, 174, 118, 255)
yearlyGoalCheckbox.backColor2Hover = color(101, 148, 188, 255)
yearlyGoalCheckbox.crossColor = color(255, 255, 255, 255)

function yearlyGoalCheckbox:isOn()
	return yearlyGoalController:isTrackingGoals()
end

function yearlyGoalCheckbox:onClick(x, y, key)
	yearlyGoalController:setTrackGoals(not yearlyGoalController:isTrackingGoals())
	self:queueSpriteUpdate()
end

function yearlyGoalCheckbox:onMouseEntered()
	self:queueSpriteUpdate()
end

function yearlyGoalCheckbox:onMouseLeft()
	self:queueSpriteUpdate()
end

gui.register("YearlyGoalTrackCheckbox", yearlyGoalCheckbox, "Checkbox")
