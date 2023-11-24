local tabButton = gui.getClassTable("ExpansionModePropertySheetTabButton")
local conMode = {}

conMode.mouseOverIconColor = tabButton.iconActiveColor
conMode.regularIconColor = tabButton.iconInactiveColor
conMode.inactiveColor = tabButton.backgroundActiveColor
conMode.activeColor = tabButton.backgroundInActiveColor

function conMode:setConstructionMode(mode)
	self.constructionMode = mode
	self.keyText = _format("[KEY]", "KEY", mode)
	self.textWidth = self.fontObject:getWidth(self.keyText)
end

function conMode:onSizeChanged()
	self.textX, self.textY = self.w - self.textWidth - _S(3), self.h - self.fontHeight - _S(3)
end

function conMode:handleEvent(event)
	self:queueSpriteUpdate()
end

function conMode:initVisual()
	self.fontObject = fonts.get("bh20")
	self.fontHeight = self.fontObject:getHeight()
end

function conMode:onClick(x, y, key)
	officePrefabEditor:setConstructionMode(self.constructionMode)
end

function conMode:getColors()
	if self:isMouseOver() then
		return conMode.activeColor, conMode.mouseOverIconColor
	elseif officePrefabEditor:getConstructionMode() == self.constructionMode then
		return conMode.activeColor, conMode.mouseOverIconColor
	else
		return conMode.inactiveColor, conMode.regularIconColor
	end
end

function conMode:updateSprites()
	local backColor, frontColor = self:getColors()
	
	self:setNextSpriteColor(backColor:unpack())
	
	self.underSprite = self:allocateSprite(self.underSprite, "generic_backdrop_40", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	self:setNextSpriteColor(frontColor:unpack())
	
	self.spriteSlot = self:allocateSprite(self.spriteSlot, self:getIcon(), _S(2), _S(2), 0, self.rawW - 8, self.rawH - 8, 0, 0, -0.4)
end

function conMode:draw(w, h)
	conMode.baseClass.draw(self, w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.keyText, self.textX, self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("PrefabConstructionModeButton", conMode, "IconButton")
