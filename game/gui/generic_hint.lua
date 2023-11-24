local genericHintText = {}

genericHintText.GRADIENT_COLOR = color(52, 91, 142, 200)
genericHintText.flyInDistance = 0
genericHintText._scaleVert = false
genericHintText._scaleHor = false

function genericHintText:init()
end

function genericHintText:setText(text)
	self.text = text
	
	local textWidth = self.fontObject:getWidth(self.text)
	
	self:setSize(textWidth + 5, self.fontHeight + 5)
	
	self.textX = math.floor(self.w * 0.5 - textWidth * 0.5)
	self.textY = math.floor(self.h * 0.5 - self.fontHeight * 0.5)
end

function genericHintText:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 75)
	
	self.underNameSprite = self:allocateSprite(self.underNameSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.05)
	
	self:setNextSpriteColor(genericHintText.GRADIENT_COLOR:unpack())
	
	self.underNameGradient = self:allocateSprite(self.underNameGradient, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.05)
end

function genericHintText:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self.textX, self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("GenericHintText", genericHintText)
