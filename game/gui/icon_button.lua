local iconButton = {}

iconButton.mouseOverIconColor = color(255, 255, 255, 255)
iconButton.regularIconColor = color(100, 100, 100, 255)
iconButton.backgroundColor = color(0, 0, 0, 100)
iconButton.hoverText = nil
iconButton.icon = nil
iconButton.backgroundOffset = 0

function iconButton:setIcon(icon)
	self.icon = icon
end

function iconButton:getIcon()
	if self.hoverIcon and self:isMouseOver() then
		return self.hoverIcon
	end
	
	return self.icon
end

function iconButton:getSpriteColor()
	return self:isMouseOver() and self.mouseOverIconColor or self.regularIconColor
end

function iconButton:getBackgroundColor()
	return self.backgroundColor
end

function iconButton:setIconSize(w, h)
	self.iconW, self.iconH = w, h
end

function iconButton:setHoverIcon(icon)
	self.hoverIcon = icon
end

function iconButton:updateSprites()
	local iconW, iconH
	
	if self.iconW then
		iconW, iconH = self.iconW, self.iconH
	else
		iconW, iconH = self.rawW, self.rawH
	end
	
	local backOff = self.backgroundOffset
	
	if backOff > 0 then
		iconW, iconH = iconW - backOff, iconH - backOff
		
		self:setNextSpriteColor(self:getBackgroundColor():unpack())
		
		self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.45)
	end
	
	local halfOff = _S(backOff * 0.5)
	
	self:setNextSpriteColor(self:getSpriteColor():unpack())
	
	self.spriteSlot = self:allocateSprite(self.spriteSlot, self:getIcon(), halfOff, halfOff, 0, iconW, iconH, 0, 0, -0.4)
end

function iconButton:setBackgroundOffset(off)
	self.backgroundOffset = off
end

function iconButton:setHoverText(text)
	self.hoverText = text
end

function iconButton:onMouseEntered()
	self:queueSpriteUpdate()
	self:createDescbox()
end

function iconButton:createDescbox()
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		self:setupDescbox()
	end
end

function iconButton:updateDescbox()
	self.descBox:removeAllText()
	self:setupDescbox()
end

function iconButton:setupDescbox()
	for key, data in ipairs(self.hoverText) do
		if data.preLineSpace then
			self.descBox:addSpaceToNextText(data.preLineSpace)
		end
		
		self.descBox:addText(data.text, data.font, data.color, data.lineSpace, data.wrapWidth or 400, data.icon, data.iconWidth, data.iconHeight)
	end
	
	self:positionDescbox()
end

function iconButton:positionDescbox()
	self.descBox:centerToElement(self)
end

function iconButton:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function iconButton:draw(w, h)
end

function iconButton:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function iconButton:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

gui.register("IconButton", iconButton)
