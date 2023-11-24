local genericBordered = {}

genericBordered.GRADIENT_COLOR = color(52, 91, 142, 200)

function genericBordered:setupText()
	self:_setupText()
	self:setSize(self.textWidth + _S(8), self.fontHeight + _S(4))
	
	self.textX = self.w * 0.5 - self.textWidth * 0.5
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
end

function genericBordered:updateSprites()
	local r, g, b, a = game.UI_COLORS.NEW_HUD_OUTER:unpack()
	
	self:setNextSpriteColor(r, g, b, a)
	
	self.bgSpriteUnder = self:allocateHollowRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.92)
	
	local r, g, b = game.UI_COLORS.NEW_HUD_FILL_3:unpack()
	
	self:setNextSpriteColor(r, g, b, 200)
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.91)
	
	local r, g, b = self.genericFillColor:unpack()
	
	self:setNextSpriteColor(r, g, b, 100)
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(2), _S(2), self.rawW - 4, self.rawH - 4, 2, -0.9)
end

gui.register("GenericBorderedTextDisplay", genericBordered, "GenericTextDisplay")
