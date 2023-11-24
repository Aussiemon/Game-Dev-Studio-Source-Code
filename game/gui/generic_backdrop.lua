local genericBackdrop = {}

genericBackdrop.color = color(0, 0, 0, 100)
genericBackdrop.canPropagateKeyPress = true

function genericBackdrop:updateSprites()
	local clr = self.color
	
	self:setNextSpriteColor(clr.r, clr.g, clr.b, clr.a)
	
	self.backdrop = self:allocateSprite(self.backdrop, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
end

gui.register("GenericBackdrop", genericBackdrop)
