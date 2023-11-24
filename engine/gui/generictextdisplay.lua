local genericTextDisplay = {}

genericTextDisplay.displayTime = nil
genericTextDisplay.alpha = 0
genericTextDisplay.fadeInSpeed = 500
genericTextDisplay.fadeOutSpeed = 500
genericTextDisplay.text = "sample text"
genericTextDisplay._scaleVert = false
genericTextDisplay._scaleHor = false

function genericTextDisplay:init(text)
	self.text = text or genericTextDisplay.text
	
	self:setFont(fonts.get("pix30"))
	
	self.displayTime = curTime + 4
	self.alpha = 0
	self.fadeInSpeed = 500
	self.fadeOutSpeed = 500
	
	self:setupText()
end

function genericTextDisplay:setDisplayTime(time)
	if not time then
		self.displayTime = nil
	else
		self.displayTime = curTime + time
	end
end

function genericTextDisplay:setFont(font)
	self.font = font
	self.fontHeight = self.font:getHeight()
end

function genericTextDisplay:getFont()
	return self.font
end

function genericTextDisplay:setAlpha(alpha)
	self.alpha = alpha
end

function genericTextDisplay:setText(text)
	self.text = text
	
	self:setupText()
end

function genericTextDisplay:setInOutSpeed(fadeIn, fadeOut)
	if fadeIn then
		self.fadeInSpeed = fadeIn
	end
	
	if fadeOut then
		self.fadeOutSpeed = fadeOut
	end
end

function genericTextDisplay:setupText()
	self:_setupText()
	self:setSize(self.textWidth, self.fontHeight)
	
	self.textX = self.w * 0.5 - self.textWidth * 0.5
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
end

function genericTextDisplay:_setupText()
	self.textWidth = self.font:getWidth(self.text)
end

function genericTextDisplay:draw(w, h)
	if self.displayTime and curTime > self.displayTime then
		self.alpha = math.approach(self.alpha, 0, frameTime * self.fadeOutSpeed)
		
		if self.alpha == 0 then
			self:kill()
			
			return 
		end
	else
		self.alpha = math.approach(self.alpha, 255, frameTime * self.fadeInSpeed)
	end
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.text, self.textX, self.textY, 255, 255, 255, self.alpha, 0, 0, 0, self.alpha)
end

gui.register("GenericTextDisplay", genericTextDisplay)
