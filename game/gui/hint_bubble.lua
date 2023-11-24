local hintBubble = {}

hintBubble.SEGMENT_COUNT = 25
hintBubble.HINT_DISPLAY_TIME = 10
hintBubble.skinPanelFillColor = color(86, 104, 135, 255)
hintBubble.skinPanelHoverColor = color(179, 194, 219, 255)
hintBubble.skinPanelSelectColor = color(125, 175, 125, 255)
hintBubble.skinPanelDisableColor = color(20, 20, 20, 255)
hintBubble.skinTextFillColor = color(179, 194, 219, 255)
hintBubble.skinTextHoverColor = color(255, 255, 255, 255)
hintBubble.skinTextSelectColor = color(255, 255, 255, 255)
hintBubble.skinTextDisableColor = color(60, 60, 60, 255)

function hintBubble:init()
	self.font = fonts.get("bh36")
	self.fontHeight = self.font:getHeight()
	self.text = "?"
	self.textWidth = self.font:getWidth(self.text)
end

function hintBubble:setSize(w, h)
	hintBubble.baseClass.setSize(self, w, h)
	
	self.bubbleRadius = math.round(_S(math.max(w, h) * 0.5))
	self.textX = -self.textWidth * 0.5 + self.bubbleRadius
	self.textY = -self.fontHeight * 0.5 + self.bubbleRadius
end

function hintBubble:isDisabled()
	return false
end

function hintBubble:isMouseOver()
	local x, y = self:getPos(true)
	
	return hintBubble.baseClass.isMouseOver(self) and math.distXY(x + self.bubbleRadius, love.mouse.getX(), y + self.bubbleRadius, love.mouse.getY()) <= self.bubbleRadius
end

function hintBubble:kill()
	hintBubble.baseClass.kill(self)
	self:killDescBox()
end

function hintBubble:think()
	local mouseOver = self:isMouseOver()
	
	if self.descBox and game.time > self.descBoxLifetime and not mouseOver then
		self:killDescBox()
	end
	
	if mouseOver then
		if not self.wasMouseOver then
			self:queueSpriteUpdate()
		end
		
		self.wasMouseOver = mouseOver
	else
		if self.wasMouseOver then
			self:queueSpriteUpdate()
		end
		
		self.wasMouseOver = false
	end
end

function hintBubble:onHide()
	self:killDescBox()
end

function hintBubble:onMouseEntered()
	self:queueSpriteUpdate()
end

function hintBubble:onMouseLeft()
	self:queueSpriteUpdate()
end

function hintBubble:updateSprites()
	local alphaOne, alphaTwo
	
	if self:isMouseOver() then
		alphaOne = 200
		alphaTwo = 255
	else
		alphaOne = 100
		alphaTwo = 200
	end
	
	self:setNextSpriteColor(0, 0, 0, alphaOne)
	
	self.underSprite = self:allocateSprite(self.underSprite, "generic_circle", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.2)
	
	local panelColor, textColor = self:getStateColor()
	
	self:setNextSpriteColor(panelColor.r, panelColor.g, panelColor.b, alphaTwo)
	
	self.overSprite = self:allocateSprite(self.overSprite, "generic_circle", _S(2), _S(2), 0, self.rawW - 4, self.rawH - 4, 0, 0, -0.15)
end

function hintBubble:onClick(x, y, key)
	if self:isMouseOver() then
		if self.descBox then
			self:killDescBox()
			
			return 
		end
		
		local hint = hintSystem:attemptShowHint()
		
		if hint then
			self.descBox = gui.create("GenericDescbox")
			
			self.descBox:addText(hint, "pix20", nil, 0, 600)
			self.descBox:centerToElement(self)
			self.descBox:bringUp()
			
			self.descBoxLifetime = game.time + hintBubble.HINT_DISPLAY_TIME
		end
	end
end

function hintBubble:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	local alpha = self:isMouseOver() and 255 or 200
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.text, self.textX, self.textY, textColor.r, textColor.g, textColor.b, alpha, 0, 0, 0, alpha)
end

gui.register("HintBubble", hintBubble)
