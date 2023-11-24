local COMBOBOXOPTION = {}

COMBOBOXOPTION.autoClose = true
COMBOBOXOPTION.skinPanelFillColor = color(198, 210, 211, 255)
COMBOBOXOPTION.skinPanelAlternativeFillColor = color(186, 198, 198, 255)
COMBOBOXOPTION.skinPanelHoverColor = color(125, 175, 125, 255)
COMBOBOXOPTION.skinPanelDisableColor = color(20, 20, 20, 255)
COMBOBOXOPTION.skinTextFillColor = color(220, 220, 220, 255)
COMBOBOXOPTION.skinTextHoverColor = color(240, 240, 240, 255)
COMBOBOXOPTION.skinTextDisableColor = color(60, 60, 60, 255)
COMBOBOXOPTION.highlightColor = color(155, 192, 255, 255)
COMBOBOXOPTION.closeOnClick = true
COMBOBOXOPTION.wrapWidth = 500
COMBOBOXOPTION._scaleHor = false

function COMBOBOXOPTION:init()
	self.font = fonts.pix14
end

function COMBOBOXOPTION:onClick(lx, ly, key)
	if self.onClicked then
		self:onClicked()
	end
	
	self.tree:onSelected(self.text, self)
	
	if self.closeOnClick then
		self.tree:close()
	end
end

function COMBOBOXOPTION:setIcon(icon)
	self.icon = icon
end

function COMBOBOXOPTION:setCloseOnClick(state)
	self.closeOnClick = state
end

function COMBOBOXOPTION:getTree()
	return self.tree
end

function COMBOBOXOPTION:setText(text)
	self.text = text
	
	self:scaleSizeToText()
end

function COMBOBOXOPTION:setHoverText(text)
	self.hoverText = text
end

function COMBOBOXOPTION:setWrapWidth(width)
	self.wrapWidth = width
end

function COMBOBOXOPTION:setupDescbox()
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.hoverText) do
			self.descBox:addText(data.text, data.font, data.textColor, data.lineSpace, data.wrapWidth or self.wrapWidth, data.icon, data.iconWidth, data.iconHeight)
		end
		
		self.descBox:positionToMouse(_S(10), _S(10))
	end
end

function COMBOBOXOPTION:onMouseEntered()
	self:setupDescbox()
	self.tree:setHasMouseLeft(false)
	self:queueSpriteUpdate()
end

function COMBOBOXOPTION:onMouseLeft()
	self:killDescBox()
	self.tree:setHasMouseLeft(true)
	self:queueSpriteUpdate()
end

function COMBOBOXOPTION:setFont(font)
	self.font = font
	
	self:scaleSizeToText()
end

function COMBOBOXOPTION:highlight(state)
	self.highlighted = state
end

function COMBOBOXOPTION:setDisabled(state)
	self.disabled = state
end

function COMBOBOXOPTION:getCanClick()
	return self.canClick
end

function COMBOBOXOPTION:isDisabled()
	return not self.canClick
end

function COMBOBOXOPTION:setHightlightColor(clr)
	self.highlightColor = clr
end

function COMBOBOXOPTION:scaleSizeToText()
	if not self.text or not self.font then
		return 
	end
	
	local width, height = math.round(self:getTextWidth()), math.round(self.font:getHeight())
	
	self.textX, self.textY = width, height
	
	self:setSize(math.max(self.rawW, width + _S(10)), math.max(self.rawH, height))
end

function COMBOBOXOPTION:getTextWidth()
	return self.font:getWidth(self.text)
end

function COMBOBOXOPTION:getStateColor()
	local pcol, tcol = gui.getStateColor(self)
	
	if self.highlighted then
		return self.highlightColor, tcol
	end
	
	return pcol, tcol
end

function COMBOBOXOPTION:updateSprites()
	if self:passesClickFilters() and self:getCanClick() then
		local pcol, tcol = self:getStateColor()
		
		self:setNextSpriteColor(pcol:unpack())
	else
		local r, g, b = COMBOBOXOPTION.skinPanelFillColor:lerpSelfResult(0.33)
		
		self:setNextSpriteColor(r, g, b, 255)
	end
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.2)
	
	if self.icon then
		self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, _S(2), _S(2), 0, self.rawH - 4, self.rawH - 4, -0.1)
	end
end

function COMBOBOXOPTION:getTextOffset()
	return 0, 0
end

function COMBOBOXOPTION:draw(w, h)
	local pcol, tcol = self:getStateColor()
	local x, y = self:getTextOffset()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.text, (w + x - self.textX) * 0.5, (h + y - self.textY) * 0.5, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("ComboBoxOption", COMBOBOXOPTION)
