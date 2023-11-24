local bgElem = {}

bgElem.canHover = false

function bgElem:canInteractWith()
	return false
end

function bgElem:init()
	self.alpha = 1
end

function bgElem:setQuad(quad)
	self.quad = quad
end

function bgElem:setAlpha(alpha)
	self.alpha = alpha
end

function bgElem:updateSprites()
	self:setNextSpriteColor(255, 255, 255, 255 * self.alpha)
	
	self.spriteSlot = self:allocateSprite(self.spriteSlot, self.quad, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

gui.register("GameAwardsBackgroundElement", bgElem)
