local thankYou = {}

function thankYou:getXSpread()
	return 0.9, 0.95
end

function thankYou:getYSpread()
	return 0.25, 0.9
end

function thankYou:getTargetX()
	return 0.1, 0.8
end

function thankYou:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 150)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.9)
	
	self:updatePeepSprites()
end

gui.register("ThankYouPeepAnimation", thankYou, "GameConventionResultFrame")
