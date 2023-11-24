local projectsTabButton = {}

projectsTabButton.iconScale = 0.8
projectsTabButton.skinPanelFillColor = color(200, 200, 200, 255)
projectsTabButton.skinPanelHoverColor = color(255, 255, 255, 255)
projectsTabButton.skinPanelDisableColor = color(100, 100, 100, 255)

function projectsTabButton:setIconScale(scale)
	self.iconScale = scale
end

function projectsTabButton:onMouseEntered()
	projectsTabButton.baseClass.onMouseEntered(self)
	self:showNearbyText()
end

function projectsTabButton:onMouseLeft()
	projectsTabButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function projectsTabButton:setOnSwitchEvent(event)
	self.onSwitchEvent = event
end

function projectsTabButton:playClickSound()
	sound:play("switch_tab", nil, nil, nil)
end

function projectsTabButton:showNearbyText()
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(self.text, "bh20", nil, 0, 300)
	self.descBox:overwriteDepth(10000)
	
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x - _S(5) - self.descBox.w, y + self.h * 0.5 - self.descBox.h * 0.5)
end

function projectsTabButton:isDisabled()
	return self.frame and not self.frame:getVisible()
end

function projectsTabButton:setFrameController(controller)
	self.frameController = controller
end

function projectsTabButton:setNearbyText(text)
	self.text = text
end

function projectsTabButton:setFrame(frame)
	self.frame = frame
end

function projectsTabButton:getFrame()
	return self.frame
end

function projectsTabButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:switchTo()
	end
end

function projectsTabButton:switchTo()
	self.frameController:switchFrame(self)
	
	if self.onSwitchEvent then
		events:fire(self.onSwitchEvent, self)
	end
end

function projectsTabButton:hideFrame()
	self:queueSpriteUpdate()
	self.frame:hide()
	
	self.active = false
end

function projectsTabButton:showFrame()
	self:queueSpriteUpdate()
	self.frame:show()
	
	self.active = true
end

function projectsTabButton:isActive()
	return self.active
end

function projectsTabButton:onKill()
	self.frame:kill()
end

function projectsTabButton:updateSprites()
	local clr
	
	if self:isMouseOver() and self:isDisabled() then
		clr = self.skinPanelFillColor
	else
		clr = self:getStateColor()
	end
	
	self:setNextSpriteColor(clr:unpack())
	
	self.outlineSprite = self:allocateSprite(self.outlineSprite, "generic_backdrop_64", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local iconX, iconY = self.w * 0.5, self.h * 0.5
	local quad = quadLoader:load(self.icon)
	local quadW, quadH = quad:getSize()
	local scale = quad:getScaleToSize(self.w * self.iconScale)
	local iconW, iconH = quadW * scale, quadH * scale
	
	iconX = iconX - iconW * 0.5
	iconY = iconY - iconH * 0.5
	
	self:setNextSpriteColor(clr:unpack())
	
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, iconX, iconY, 0, _US(iconW), _US(iconH), 0, 0, -0.5)
end

gui.register("ProjectsMenuTabButton", projectsTabButton, "IconButton")
