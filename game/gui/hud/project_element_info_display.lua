local projInfoDisp = {}

function projInfoDisp:setIcon(icon)
	self.icon = icon
end

function projInfoDisp:updateSprites()
	local r, g, b = game.UI_COLORS.LIGHT_BLUE:unpack()
	
	self:setNextSpriteColor(r, g, b, 100)
	
	self.rectSprites = self:allocateRoundedRectangle(self.rectSprites, 0, 0, self.rawW, self.rawH, 4, -0.4)
	
	local scaledTwo = _S(2)
	
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, scaledTwo, scaledTwo, 0, self.rawH - 4, self.rawH - 4, 0, 0, -0.35)
	self.textX = _S(self.rawH)
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
end

function projInfoDisp:setHoverText(text)
	self.hoverText = text
end

function projInfoDisp:onMouseEntered()
	projInfoDisp.baseClass.onMouseEntered(self)
	
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		self:setupHoverText()
		self.descBox:centerToElement(self)
	end
end

function projInfoDisp:setupHoverText()
	for key, data in ipairs(self.hoverText) do
		self.descBox:addText(data.text, data.font, data.textColor, data.lineSpace, data.wrapWidth, data.icon, data.iconWidth, data.iconHeight)
	end
end

function projInfoDisp:onMouseLeft()
	projInfoDisp.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function projInfoDisp:setText(text)
	self.text = text
end

function projInfoDisp:draw(w, h)
	local pCol, tCol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self.textX, self.textY, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
end

gui.register("ProjectElementInfoDisplay", projInfoDisp)
