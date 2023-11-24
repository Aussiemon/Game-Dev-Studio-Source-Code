local loadingProgressbar = {}

loadingProgressbar.canHover = false

function loadingProgressbar:init()
	self.flash = 0
end

function loadingProgressbar:initVisual()
	self.font = fonts.get("bh24")
	self.fontHeight = self.font:getHeight()
	self.tipFont = fonts.get("bh18")
	self.tipFontHeight = self.tipFont:getHeight()
end

function loadingProgressbar:setupTip()
	self.tip = game.pickRandomGameOverTip()
	
	local bottomText, lines, height, topText = string.wrap(self.tip, self.tipFont, self.w, nil, _S(28))
	
	if topText then
		self.tipOne = topText
		self.tipTwo = bottomText
	else
		self.tipOne = bottomText
	end
	
	self.topTipX = _S(28)
	self.tipY = self.h + _S(5)
	
	if self.tipTwo then
		self.tipYBottom = self.tipY + _S(24)
	end
end

function loadingProgressbar:updateDisplay()
	self.text = loadingScreen:getText()
	
	local width = self.font:getWidth(self.text)
	
	self.textX = self.w * 0.5 - width * 0.5
	self.textY = -(self.fontHeight + _S(5))
	
	self:queueSpriteUpdate()
end

function loadingProgressbar:updateSprites()
	self:setNextSpriteColor(60, 60, 60, 255)
	
	self.backSprite = self:allocateSprite(self.backSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	self:setNextSpriteColor(game.UI_COLORS.LIGHT_BLUE:unpack())
	
	self.progressSprite = self:allocateSprite(self.progressSprite, "vertical_gradient_75", 0, 0, 0, self.rawW * loadingScreen:getProgress(), self.rawH, 0, 0, -0.5)
	self.questionMark = self:allocateSprite(self.questionMark, "question_mark", 0, self.tipY, 0, 24, 24, 0, 0, -0.5)
end

function loadingProgressbar:draw(w, h)
	local alpha = 255
	
	if loadingScreen:isFinished() then
		self.flash = self.flash + frameTime * 2
		
		if self.flash >= math.pi then
			self.flash = self.flash - math.pi
		end
		
		alpha = 255 * math.sin(self.flash)
	end
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.text, self.textX, self.textY, 255, 255, 255, alpha, 0, 0, 0, alpha)
	love.graphics.setFont(self.tipFont)
	love.graphics.printST(self.tipOne, self.topTipX, self.tipY, 255, 255, 255, 255, 0, 0, 0, 255)
	
	if self.tipTwo then
		love.graphics.printST(self.tipTwo, 0, self.tipYBottom, 255, 255, 255, 255, 0, 0, 0, 255)
	end
end

gui.register("LoadingProgressBar", loadingProgressbar)
