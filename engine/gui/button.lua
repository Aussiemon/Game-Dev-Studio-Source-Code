local BUTTON = {}

BUTTON.skinPanelFillColor = color(80, 80, 80, 255)
BUTTON.skinPanelHoverColor = color(120, 120, 120, 255)
BUTTON.skinTextFillColor = color(220, 220, 220, 255)
BUTTON.skinTextHoverColor = color(240, 240, 240, 255)
BUTTON.skinTextDisableColor = color(60, 60, 60, 255)
BUTTON.font = "pix24"
BUTTON.text = "display text"
BUTTON.textX = 0
BUTTON.LEFT = 1
BUTTON.MIDDLE = 2
BUTTON.RIGHT = 3
BUTTON.alignment = BUTTON.MIDDLE

function BUTTON:init()
	self:setFont(self.font)
	self:setText(self.text)
end

function BUTTON:setAlignment(align)
	self.alignment = align
	
	self:updateTextPosition()
end

function BUTTON:setFont(font)
	if type(font) == "string" then
		font = fonts.get(font)
	end
	
	self.fontObject = font
	self.textWidth = self.fontObject:getWidth(self.text)
	self.textHeight = self.fontObject:getHeight()
	
	self:updateDisplayText()
end

function BUTTON:setSize(x, y)
	BUTTON.baseClass.setSize(self, x, y)
	self:updateDisplayText()
end

function BUTTON:setHoverText(hoverText)
	self.hoverText = hoverText
end

function BUTTON:onMouseEntered()
	self:createHoverText()
end

function BUTTON:createHoverText()
	if self.hoverText and not self.descBox then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.hoverText) do
			self.descBox:addText(data.text, data.font, data.textColor, data.lineSpace, data.wrapWidth or 600, data.icon, data.iconWidth, data.iconHeight)
		end
		
		self:positionHoverText()
	end
end

function BUTTON:positionHoverText()
	self.descBox:centerToElement(self)
end

function BUTTON:onMouseLeft()
	self:killDescBox()
end

function BUTTON:getMaxTextWidth()
	return self.w - _S(6)
end

function BUTTON:updateDisplayText(text)
	text = text or self.originalText
	
	if not text then
		return 
	end
	
	if self.w > 0 then
		text = string.cutToWidth(self.originalText, self.fontObject, self:getMaxTextWidth())
	end
	
	self.text = text
	self.textHeight = self.fontObject:getHeight()
	self.displayTextHeight = (self.h - self.textHeight) * 0.5
	self.textWidth = self.fontObject:getWidth(self.text)
	
	self:updateTextPosition()
end

function BUTTON:setText(text)
	self.originalText = text
	
	self:updateDisplayText()
end

function BUTTON:getTextSize()
	return self.fontObject:getWidth(self.text)
end

function BUTTON:updateTextPosition()
	local xPos = _S(3)
	
	if self.alignment == BUTTON.MIDDLE then
		xPos = (self.w - self.textWidth) * 0.5
	elseif self.alignment == BUTTON.RIGHT then
		xPos = self.w - self.textWidth - _S(6)
	end
	
	self.textX = xPos
end

function BUTTON:onSizeChanged()
	self:updateTextPosition()
end

function BUTTON:draw(w, h)
	local poutline = self:getPanelOutlineColor()
	
	love.graphics.setColor(poutline.r, poutline.g, poutline.b, poutline.a)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("rough")
	love.graphics.rectangle("line", 0, 0, w, h)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	love.graphics.rectangle("fill", 1, 1, w - 2, h - 2)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self.textX, self.displayTextHeight, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

function BUTTON:postClick(localX, localY, key)
end

function BUTTON:onClick(localX, localY, key)
	self:postClick()
end

gui.register("Button", BUTTON)
