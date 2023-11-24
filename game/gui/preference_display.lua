local preferenceDisplay = {}

preferenceDisplay.skinPanelHoverColor = game.UI_COLORS.LIGHT_BLUE:duplicate()
preferenceDisplay.skinPanelHoverColor.a = 30
preferenceDisplay.skinPanelSelectedColor = game.UI_COLORS.LIGHT_BLUE:duplicate()
preferenceDisplay.skinPanelSelectedColor.a = 50
preferenceDisplay.skinPanelNonHoverColor = color(0, 0, 0, 100)
preferenceDisplay.hoverTextColor = color(219, 228, 255, 255)

function preferenceDisplay:init()
	self.checkbox = gui.create("PreferenceCheckbox", self)
	
	self.checkbox:setSize(preferences.checkboxSize, preferences.checkboxSize)
	
	self.label = gui.create("Label", self)
	
	self.label:setFont("pix22")
	self.label:setCanHover(false)
end

function preferenceDisplay:setPreferenceData(data)
	self.preferenceData = data
	
	self.label:setText(data.display)
	self.checkbox:setPreferenceData(data)
	self:updateFont()
end

function preferenceDisplay:updateFont()
	if preferences:get(self.preferenceData.id) then
		self.label:setFont("bh22")
	else
		self.label:setFont("pix22")
	end
end

function preferenceDisplay:handleEvent(event, state, id)
	if event == preferences.EVENTS.PREFERENCE_STATE_CHANGED and id == self.preferenceData.id then
		self:queueSpriteUpdate()
		self:updateFont()
	end
end

function preferenceDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:setWidth(600)
	self.descBox:addText(self.preferenceData.description, "pix20", nil, 0, 600)
	self.descBox:centerToElement(self)
	self.label:setTextColor(self.hoverTextColor)
end

function preferenceDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
	self.label:resetTextColor()
end

function preferenceDisplay:updateSprites()
	local clr
	
	if self:isMouseOver() then
		clr = self.skinPanelHoverColor
	elseif self.preferenceData:isOnCheck(self) then
		clr = self.skinPanelSelectedColor
	else
		clr = self.skinPanelNonHoverColor
	end
	
	self:setNextSpriteColor(clr:unpack())
	
	self.roundedRectangles = self:allocateRoundedRectangle(self.roundedRectangles, 0, 0, self.rawW, self.rawH, 4, -0.1)
	
	self:setNextSpriteColor(clr:unpack())
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "horizontal_gradient_75", 1, 1, 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function preferenceDisplay:onSizeChanged()
	self.checkbox:setPos(self.w - self.checkbox.w - _S(2), _S(2))
	self.label:setPos(_S(2), _S(4))
end

gui.register("PreferenceDisplay", preferenceDisplay)
