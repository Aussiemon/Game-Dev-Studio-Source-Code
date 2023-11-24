local popup = {}

popup.textPad = 10
popup.baseHeight = 5
popup.buttonWidth = 100
popup.buttonHeight = 20
popup.buttonPad = 5
popup.text = "text"
popup.bgAlpha = 255
popup.buttonSpacing = 5
popup.setFontLayoutPerform = false
popup.scrollbarPadding = 10
popup._scaleVert = false
popup._propagateScalingState = false
popup.HORIZONTAL_BUTTONS = 1
popup.VERTICAL_BUTTONS = 2
popup.buttonOrientation = popup.HORIZONTAL_BUTTONS
popup.textColor = color(255, 255, 255, 255)
popup.textShadowColor = color(0, 0, 0, 255)

function popup:init()
	self.lastInteraction = gui.interactionFilter
	self.widestButtonText = 0
	self.prevButtonHeight = 0
	self.extraHeight = 0
end

function popup:setExtraHeight(extra)
	self.extraHeight = extra
end

function popup:onKill()
	popup.baseClass.onKill(self)
	gui.setInteractionFilter(self.lastInteraction)
	
	if self.onKillCallback then
		self:onKillCallback()
	end
end

function popup:setOnKillCallback(callback)
	self.onKillCallback = callback
end

function popup:setButtonAlignment(alignType)
	self.buttonAlignment = alignType
end

function popup:setButtonSpacing(spacing)
	self.buttonSpacing = spacing
end

function popup:setButtonWidth(width)
	self.buttonWidth = width
	self.widestButtonText = math.max(self.widestButtonText, width)
end

function popup:setButtonOrientation(orientation)
	self.buttonOrientation = orientation
end

function popup:createOKButton(font, callback)
	font = font or "pix20"
	
	return self:addButton(font, _T("OK", "OK"), callback)
end

popup.addOKButton = popup.createOKButton

function popup:getButtons()
	return self.buttons
end

function popup:addButton(font, text, callback)
	self.buttons = self.buttons or {}
	text = text or "text"
	
	local button = gui.create("CloseButton", self)
	
	button:setFont(font)
	button:setText(text)
	button:setSize(self.widestButtonText, self.buttonHeight)
	
	if callback then
		button.postClick = callback
	end
	
	table.insert(self.buttons, button)
	self:performLayout()
	
	return button
end

function popup:scaleButtons(button)
	local largest = math.max(button:getTextSize() + _S(10), self.widestButtonText, _S(self.buttonWidth))
	
	if largest > self.widestButtonText then
		for key, button in ipairs(self.buttons) do
			button:setWidth(largest)
		end
		
		self.widestButtonText = largest
	end
end

function popup:getExtraHeight()
	return self.extraHeight
end

function popup:performLayout()
	local queueButtonReupdate = false
	
	popup.baseClass.performLayout(self)
	self:updateTextDimensions()
	self:scaleHeightToText()
	self:updateScrollerPosition()
	self:updateButtonPositions()
end

function popup:updateButtonPositions(skipResize)
	if not self.buttons then
		return 
	end
	
	local totalHeight = self:getExtraHeight()
	
	for key, button in ipairs(self.buttons) do
		button:setY(self.h + totalHeight)
		button:setWidth(self.rawW - _S(10))
		button:centerX()
		
		totalHeight = totalHeight + button.h + _S(self.buttonSpacing)
	end
	
	if not skipResize then
		self:setHeight(self.rawH + totalHeight)
	end
	
	return totalHeight
end

function popup:createScroller(width, height)
	width = width or self.rawW - 10
	self.scrollbar = gui.create("ScrollbarPanel", self)
	
	self.scrollbar:setSize(width, height)
	self.scrollbar:setAdjustElementPosition(true)
	self.scrollbar:addDepth(100)
	self:performLayout()
	
	return self.scrollbar
end

function popup:updateScrollerPosition()
	if self.scrollbar then
		self.scrollbar:setPos(_S(5), self.textHeight + _S(30 + self.scrollbarPadding * 0.5))
	end
end

function popup:setTextPad(pad)
	self.textPad = pad
end

function popup:addCheckBox(checkCallback, isOnCallback, isDisabledCallback, labelText)
end

function popup:setText(text)
	self.text = text
	
	self:updateTextDimensions()
	self:scaleHeightToText()
end

function popup:updateTextDimensions()
	local wrappedText, lineCount, height = string.wrap(self.text, self.textFont, self.w - _S(self.textPad * 2))
	
	self.wrappedText = wrappedText
	self.lineCount = lineCount
	self.textHeight = height
end

function popup:setTextFont(font)
	if type(font) == "string" then
		font = fonts.get(font)
	end
	
	self.textFont = font
	self.textFontHeight = font:getHeight()
end

function popup:scaleHeightToText()
	local height = self:getTextBottom() + _S(self.baseHeight)
	
	if self.scrollbar then
		height = height + self.scrollbar:getHeight() + _S(self.scrollbarPadding)
	end
	
	self:setHeight(height)
end

function popup:getTextBottom()
	return _S(8) + self.fontHeight + self.textHeight
end

function popup:draw(w, h)
	popup.baseClass.draw(self, w, h)
	
	if self.wrappedText then
		local clr, shadow = self.textColor, self.textShadowColor
		
		love.graphics.setFont(self.textFont)
		love.graphics.printST(self.wrappedText, self.textPad, _S(8) + self.fontHeight, clr.r, clr.g, clr.b, clr.a, shadow.r, shadow.g, shadow.b, shadow.a)
	end
end

gui.register("Popup", popup, "Frame")
