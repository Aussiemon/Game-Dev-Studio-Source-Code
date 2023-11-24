local utf8 = require("utf8")
local PANEL = {}

PANEL.ghostText = ""
PANEL.textPad = 10
PANEL.limitTextToWidth = false
PANEL.maxSize = 16
PANEL.skinPanelFillColor = color(80, 80, 80, 255)
PANEL.skinPanelHoverColor = PANEL.skinPanelFillColor
PANEL.skinTextFillColor = color(220, 220, 220, 255)
PANEL.skinTextHoverColor = color(240, 240, 240, 255)
PANEL.negativeNumbers = true
PANEL.numbersOnly = false

function PANEL:init()
	self.canWriteTo = true
	self.curText = ""
	self.removeTextWait = 0
	self.alpha = 0
	
	self:setTextPadding(PANEL.textPad)
	self:setGhostText(self.ghostText)
end

function PANEL:setText(text)
	self.curText = text
	
	if self.autoAdjustFonts then
		self:adjustFontSize()
	end
end

function PANEL:getText()
	return self.curText
end

function PANEL:setMaxText(max)
	self.maxSize = max
end

function sortByHeight(a, b)
	return a:getHeight() < b:getHeight()
end

function PANEL:setAutoAdjustFonts(fontList)
	self.autoAdjustFonts = {}
	
	for key, fontName in ipairs(fontList) do
		self.autoAdjustFonts[#self.autoAdjustFonts + 1] = fonts.get(fontName)
	end
	
	table.sort(self.autoAdjustFonts, sortByHeight)
	self:adjustFontSize()
end

function PANEL:adjustFontSize()
	local validFont = self.autoAdjustFonts[1]
	local maxW = self.w - self.scaledPad
	local text = self.curText
	
	for i = #self.autoAdjustFonts, 1, -1 do
		local fontObject = self.autoAdjustFonts[i]
		
		if maxW >= fontObject:getWidth(text) then
			validFont = fontObject
			
			break
		end
	end
	
	if self.font ~= validFont then
		self:setFont(validFont)
	end
end

function PANEL:canSelect()
	return true
end

function PANEL:setLimitTextToWidth(state)
	self.limitTextToWidth = state
end

function PANEL:setTextPadding(pad)
	self.textPad = pad
	self.scaledPad = _S(self.textPad)
end

function PANEL:getMaxText()
	return self.maxSize
end

function PANEL:setFont(font)
	local realFont = font
	
	if type(font) == "string" then
		realFont = fonts.get(font)
	end
	
	self.font = realFont
	self.fontHeight = realFont:getHeight()
	self.widestCharacter = 0
	
	for char, state in pairs(gui.writeKeys) do
		local key = string.sub(string.upper(char), 1, utf8.offset(char, 1))
		
		self.widestCharacter = math.max(realFont:getWidth(char), self.widestCharacter)
	end
end

function PANEL:scaleToWidestCharacterInFont()
	self:setWidth(self.widestCharacter * self.maxSize + 10)
end

function PANEL:setShouldCenter(s)
	self.centerText = s
end

function PANEL:setGhostText(text)
	self.ghostText = text
end

function PANEL:onWrite()
end

function PANEL:canEnterText(desiredText)
	if self.limitTextToWidth then
		if self.font:getWidth(desiredText) > self.w - self.textPad then
			return false
		end
	else
		local maxSize = self.maxSize
		
		if self.negative then
			maxSize = maxSize + 1
		end
		
		if string.utf8.len(desiredText) > self.maxSize then
			return false
		end
	end
	
	return true
end

function PANEL:setNumbersOnly(state)
	self.numbersOnly = state
end

function PANEL:setAllowNegativeNumbers(allow)
	self.negativeNumbers = allow
end

function PANEL:setMaxValue(value)
	self.maxValue = value
end

function PANEL:setMinValue(value)
	self.minValue = value
end

local none = ""

function PANEL:_deleteSymbol(text)
	if type(text) == "number" then
		local stringed = tostring(text)
		local deleted = string.deletesymbol(stringed)
		local reversed = tonumber(deleted)
		
		if not reversed then
			return 0
		end
		
		return reversed
	end
	
	return string.deletesymbol(text)
end

function PANEL:_onDelete()
	self:onDelete()
	
	if self.autoAdjustFonts then
		self:adjustFontSize()
	end
end

function PANEL:onKeyPress(key)
	if key == "backspace" then
		self.curText = self:_deleteSymbol(self.curText)
		
		if self.numbersOnly then
			self:limitToMin()
		end
		
		self:_onDelete()
		
		self.removeTextWait = curTime + 0.5
		self.removeWait = false
		
		return true
	elseif (key == "-" or key == "kp-") and self.numbersOnly and self.negativeNumbers then
		self.negative = not self.negative
		
		if self.negative then
			self.curText = -(tonumber(self.curText) or 0)
		else
			self.curText = math.abs(tonumber(self.curText) or 0)
		end
		
		self:onWrite()
	end
end

function PANEL:writeTo(key)
	if self.numbersOnly then
		local numberKey = tonumber(key)
		
		if not numberKey then
			return 
		end
		
		if numberKey == 0 and tonumber(self.curText) == 0 then
			return 
		end
	end
	
	self.removeTextWait = 0
	key = key == "space" and " " or key
	
	local newText = self.curText .. key
	
	if self:canEnterText(newText) then
		if self.numbersOnly then
			local numberKey = tonumber(key)
			local numberText = tonumber(self.curText)
			
			if self.maxValue then
				local newNumberText = tonumber(newText)
				
				newText = math.min(newNumberText, self.maxValue)
			end
			
			if self.minValue then
				local newNumberText = tonumber(newText)
				
				newText = math.max(newNumberText, self.minValue)
			end
			
			if numberText == 0 and numberText < numberKey then
				self.curText = key
			else
				self.curText = newText
			end
			
			if self.negative then
				self.curText = -math.abs(self.curText)
			end
		else
			self.curText = newText
		end
		
		if self.autoAdjustFonts then
			self:adjustFontSize()
		end
	end
	
	if self.onWrite then
		self:onWrite()
		
		return true
	end
end

function PANEL:getText()
	return self.curText
end

function PANEL:onDelete()
end

function PANEL:limitToMin()
	if self.minValue and self.curText then
		local newNumberText = tonumber(self.curText)
		
		if newNumberText then
			self.curText = math.max(newNumberText, self.minValue)
		else
			self.curText = self.minValue
		end
	end
end

function PANEL:think()
	if curTime > self.removeTextWait and self:isSelected() then
		if love.keyboard.isDown("backspace") then
			self.curText = self:_deleteSymbol(self.curText)
			
			if self.numbersOnly then
				self:limitToMin()
			end
			
			self:_onDelete()
			
			if self.removeWait then
				self.removeTextWait = curTime + 0.5
				self.removeWait = false
			else
				self.removeTextWait = curTime + 0.05
			end
		elseif love.keyboard.isDown("return") then
			self:deselect()
		elseif curTime > self.removeTextWait then
			self.removeWait = true
		end
	end
end

PANEL.pointerColor = color(255, 255, 255, 255)
PANEL.pointerWidth = 2
PANEL.pointerAlphaSpeed = 4

function PANEL:drawTextPointer(textEndX)
	if self:isSelected() then
		self.alpha = self.alpha + frameTime * self.pointerAlphaSpeed
		
		if self.alpha > math.pi then
			self.alpha = self.alpha - math.pi
		end
		
		local r, g, b, a = self.pointerColor:unpack()
		
		love.graphics.setColor(r, g, b, a * math.sin(self.alpha))
		love.graphics.rectangle("fill", textEndX, self:getPointerY(), _S(self.pointerWidth), self.pointerHeight)
	end
end

function PANEL:onSelected()
	self.alpha = 0
end

function PANEL:getDisplayText()
	return self.curText
end

function PANEL:adjustPointerPosition(pointerX, baseOff)
	return pointerX
end

function PANEL:getPointerY()
	return _S(2)
end

function PANEL:getTextY()
	return self.h * 0.5 - self.fontHeight * 0.5
end

function PANEL:onSizeChanged()
	self:adjustPointerSize()
	
	if self.autoAdjustFonts then
		self:adjustFontSize()
	end
end

function PANEL:adjustPointerSize()
	self.pointerHeight = self.h - _S(4)
end

function PANEL:getTextX(text)
	local x = self.scaledPad * 0.5
	local width = self.font:getWidth(text)
	
	if self.centerText then
		x = self.w * 0.5 - width * 0.5
	end
	
	return x, width
end

function PANEL:drawText()
	local pcol, tcol = self:getStateColor()
	local x = _S(5)
	local text = self:getDisplayText()
	
	if self.elementSelected ~= self and self.curText == none then
		text = self.ghostText
	end
	
	local textX, textW = self:getTextX(text)
	local pointerX = textX + textW
	
	if not self.canClick then
		tcol = self.skinTextDisableColor
	end
	
	local textY = self:getTextY()
	
	self:_drawText(text, textX, textY, tcol)
	self:drawTextPointer(self:adjustPointerPosition(pointerX, x))
end

function PANEL:_drawText(text, textX, textY, textColor)
	love.graphics.setFont(self.font)
	love.graphics.printST(text, textX, textY, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

function PANEL:draw(w, h)
	local poutline = self:getPanelOutlineColor()
	
	love.graphics.setColor(poutline.r, poutline.g, poutline.b, poutline.a)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("rough")
	love.graphics.rectangle("line", 0, 0, w, h)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	love.graphics.rectangle("fill", 1, 1, w - 2, h - 2)
	self:drawText()
end

gui.register("TextBox", PANEL)
