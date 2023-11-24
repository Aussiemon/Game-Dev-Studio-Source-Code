local LABEL = {}

LABEL.defaultWrapWidth = 300
LABEL.defaultTextColor = color(240, 240, 240, 255)
LABEL.changeSizeOnTextUpdate = true

function LABEL:isOn()
	return true
end

function LABEL:init()
	self.displayText = "text"
	self.font = fonts.pix14
	
	self:resetTextColor()
end

function LABEL:setFont(font)
	if type(font) == "string" then
		self.font = fonts.get(font)
	else
		self.font = font
	end
	
	self.fontHeight = self.font:getHeight()
	
	self:scaleMe()
	self:updateDrawHeight()
end

function LABEL:getFont()
	return self.font
end

function LABEL:setText(text)
	self.displayText = text
	
	self:scaleMe()
	self:updateDrawHeight()
end

function LABEL:setTextColor(color)
	self.textColor = color
end

function LABEL:resetTextColor()
	self.textColor = self.defaultTextColor
end

function LABEL:getTextDimensions()
	return self.font:getWidth(self.displayText), self.fontHeight * string.countlines(self.displayText)
end

function LABEL:updateDrawHeight()
	if self.font and self.displayText then
		if self.changeSizeOnTextUpdate then
			self:setSize(_US(self.font:getWidth(self.displayText)), _US(string.countlines(self.displayText) * self.fontHeight))
		end
		
		self.drawHeight = math.round((self.h - self.font:getHeight()) * 0.5)
	end
end

function LABEL:onSizeChanged()
end

function LABEL:getText()
	return self.displayText
end

LABEL.setColor = LABEL.setTextFillColor

function LABEL:wrapText(desiredWidth, text)
	if text then
		self.displayText = text
	end
	
	desiredWidth = desiredWidth or LABEL.defaultWrapWidth
	
	local wrappedText, lines, height = string.wrap(self.displayText, self.font, desiredWidth)
	
	self.displayText = wrappedText
	self.displayWidth = self.font:getWidth(self.displayText)
	self.displayHeight = height
	
	if self.changeSizeOnTextUpdate then
		self.w = desiredWidth
		self.h = height
	end
end

function LABEL:getTextWidth()
	return self.displayWidth
end

function LABEL:scaleMe()
	if not self.displayText or not self.changeSizeOnTextUpdate then
		return 
	end
	
	self.w = self.font:getWidth(self.displayText)
	
	self:setTall(math.max(self.font:getHeight(), self.h))
end

function LABEL:draw(w, h)
	local tcol = self.textColor
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, 0, 0, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("Label", LABEL)
