local bookDisplay = {}

bookDisplay.bookPad = 3
bookDisplay.internalPad = 2
bookDisplay.textPad = 3
bookDisplay.BACKPANEL_COLOR = game.UI_COLORS.STAT_POPUP_PANEL_COLOR:duplicate()
bookDisplay.BACKPANEL_COLOR.a = 100
bookDisplay.skillBoostColorText = game.UI_COLORS.LIGHT_BLUE

function bookDisplay:init()
	self.titleFontObject = fonts.get("pix18")
	self.titleFontObjectHeight = self.titleFontObject:getHeight()
	self.boostFontObject = fonts.get("bh16")
	self.boostFontObjectHeight = self.boostFontObject:getHeight()
end

function bookDisplay:setBookData(data)
	self.bookData = data
	
	self:updateText()
end

function bookDisplay:getBookData()
	return self.bookData
end

function bookDisplay:onSizeChanged()
	self:updateText()
end

function bookDisplay:updateText()
	self.titleText = self.bookData.display
	self.boostText = self.bookData:formulateBoostText()
	self.gradientHeight = _US(self.titleFontObjectHeight + self.boostFontObjectHeight) + self.textPad * 2
	self.textX = self:getBookIconEdge()
	self.titleY = _S(self.bookPad) + _S(self.textPad) * 0.5
	self.boostY = self.titleY + self.titleFontObjectHeight
end

function bookDisplay:getBookIconEdge()
	local quad = quadLoader:getQuad(self.bookData.icon)
	local w, h = quad:getSize()
	local scale = quad:getScaleToSize(self.rawH)
	
	return _S(w * scale) + _S(self.bookPad) + _S(self.internalPad) * 2
end

function bookDisplay:getGradientStartPosition()
	local quad = quadLoader:load(self.bookData.icon)
	local quadW, quadH = quad:getSize()
	local scale = quad:getScaleToSize(self.rawH)
	
	quadW, quadH = quadW * scale, quadH * scale
	
	local bookW, bookH = quadW - self.internalPad, quadH - self.internalPad
	
	return _S(bookW + self.bookPad + self.internalPad)
end

function bookDisplay:updateSprites()
	self:setNextSpriteColor(bookDisplay.BACKPANEL_COLOR:unpack())
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local scaledBookPad = _S(self.bookPad)
	local scaledInternalPad = _S(self.internalPad)
	local scaledTotalPad = scaledBookPad + scaledInternalPad
	local quad = quadLoader:load(self.bookData.icon)
	local quadW, quadH = quad:getSize()
	local scale = quad:getScaleToSize(self.rawH)
	
	quadW, quadH = quadW * scale, quadH * scale
	
	local bookW, bookH = quadW - self.internalPad, quadH - self.internalPad
	
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.backdropSpriteList = self:allocateRoundedRectangle(self.backdropSpriteList, scaledBookPad, scaledBookPad, quadW - self.bookPad * 2, quadH - self.bookPad * 2, 6, -0.1)
	self.bookSprite = self:allocateSprite(self.bookSprite, self.bookData.icon, scaledTotalPad, scaledTotalPad, 0, quadW - self.bookPad * 2 - self.internalPad * 2, quadH - self.bookPad * 2 - self.internalPad * 2, 0, 0, -0.1)
	
	local edge = self:getBookIconEdge()
	
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "weak_gradient_horizontal", _S(bookW) + scaledTotalPad, scaledBookPad, 0, self.rawW - bookW, self.gradientHeight, 0, 0, -0.1)
end

function bookDisplay:draw(w, h)
	love.graphics.setFont(self.titleFontObject)
	love.graphics.printST(self.titleText, self.textX, self.titleY, 255, 255, 255, 255, 0, 0, 0, 255)
	love.graphics.setFont(self.boostFontObject)
	
	local r, g, b, a = bookDisplay.skillBoostColorText:unpack()
	
	love.graphics.printST(self.boostText, self.textX, self.boostY, r, g, b, a, 0, 0, 0, 255)
end

gui.register("BookDisplayElement", bookDisplay)
