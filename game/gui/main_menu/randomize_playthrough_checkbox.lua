local randomizeCheckbox = {}

randomizeCheckbox.horizontalAlignment = gui.SIDES.LEFT
randomizeCheckbox.backColor1 = color(138.6, 147, 147.7, 255)
randomizeCheckbox.backColor2 = color(178.20000000000002, 189, 189.9, 255)
randomizeCheckbox.backColor2Selected = color(90, 174, 118, 255)
randomizeCheckbox.backColor2Hover = color(101, 148, 188, 255)
randomizeCheckbox.crossColor = color(255, 255, 255, 255)
randomizeCheckbox.CATCHABLE_EVENTS = {
	game.EVENTS.RANDOMIZE_PLAYTHROUGH_STATE_CHANGED
}

function randomizeCheckbox:isOn()
	return game.hasRandomizationState(self.state)
end

function randomizeCheckbox:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		game.togglePlaythroughRandomization()
	end
end

function randomizeCheckbox:handleEvent(event, state)
	if state == self.state then
		self:queueSpriteUpdate()
	end
end

function randomizeCheckbox:setState(state)
	self.state = state
end

function randomizeCheckbox:onMouseEntered()
	self:queueSpriteUpdate()
end

function randomizeCheckbox:onMouseLeft()
	self:queueSpriteUpdate()
end

gui.register("RandomizePlaythroughCheckbox", randomizeCheckbox, "Checkbox")
