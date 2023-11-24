local randomizePlaythroughDisplay = {}

randomizePlaythroughDisplay.skinPanelHoverColor = game.UI_COLORS.LIGHT_BLUE:duplicate()
randomizePlaythroughDisplay.skinPanelHoverColor.a = 50
randomizePlaythroughDisplay.skinPanelSelectedColor = game.UI_COLORS.LIGHT_BLUE:duplicate()
randomizePlaythroughDisplay.skinPanelSelectedColor.a = 100
randomizePlaythroughDisplay.skinPanelNonHoverColor = color(86, 104, 135, 75)
randomizePlaythroughDisplay.hoverTextColor = color(219, 228, 255, 255)
randomizePlaythroughDisplay.CATCHABLE_EVENTS = {
	game.EVENTS.RANDOMIZE_PLAYTHROUGH_STATE_CHANGED
}

function randomizePlaythroughDisplay:init()
	self.checkbox = gui.create("RandomizePlaythroughCheckbox", self)
	
	self.checkbox:setCanHover(false)
	self.checkbox:setState(self.state)
end

function randomizePlaythroughDisplay:getCheckbox()
	return self.checkbox
end

function randomizePlaythroughDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	
	local wrapWidth = 400
	
	self.descBox = gui.create("GenericDescbox")
	
	self:setupDescbox()
end

function randomizePlaythroughDisplay:setupDescbox()
end

function randomizePlaythroughDisplay:setState(state)
	self.state = state
	
	self.checkbox:setState(self.state)
end

function randomizePlaythroughDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function randomizePlaythroughDisplay:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if game.toggleRandomizationState(self.state) then
			sound:play("feature_selected", nil, nil, nil)
		else
			sound:play("feature_deselected", nil, nil, nil)
		end
	end
end

function randomizePlaythroughDisplay:handleEvent(event, state, id)
	if state == self.state then
		self:queueSpriteUpdate()
	end
end

function randomizePlaythroughDisplay:updateSprites()
	local clr
	
	if self:isMouseOver() then
		clr = self.skinPanelHoverColor
	elseif game.hasRandomizationState(self.state) then
		clr = self.skinPanelSelectedColor
	else
		clr = self.skinPanelNonHoverColor
	end
	
	self:setNextSpriteColor(clr:unpack())
	
	self.roundedRectangles = self:allocateRoundedRectangle(self.roundedRectangles, 0, 0, self.rawW, self.rawH, 4, -0.1)
	
	self:setNextSpriteColor(clr:unpack())
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "horizontal_gradient_75", 1, 1, 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function randomizePlaythroughDisplay:onSizeChanged()
	self.checkbox:setSize(self.rawH - 4, self.rawH - 4)
	self.checkbox:setPos(_S(2), _S(2))
end

gui.register("RandomizePlaythroughDisplay", randomizePlaythroughDisplay)
