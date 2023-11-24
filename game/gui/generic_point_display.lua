local genericPointDisplay = {}

genericPointDisplay.skinTextHoverColor = color(240, 240, 240, 255)
genericPointDisplay.skinTextFillColor = color(255, 255, 255, 255)
genericPointDisplay.underIconColor = color(0, 0, 0, 100)
genericPointDisplay.baseColorInactive = game.UI_COLORS.NEW_HUD_FILL_3
genericPointDisplay.baseColor = game.UI_COLORS.NEW_HUD_HOVER
genericPointDisplay._scaleVert = false
genericPointDisplay._scaleHor = false
genericPointDisplay.font = "bh22"

function genericPointDisplay:initVisual()
	self:setFont(genericPointDisplay.font)
end

function genericPointDisplay:setText(text)
	self.text = text
	self.textWidth = self.fontObject:getWidth(self.text)
	
	self:adjustFontSize()
end

function genericPointDisplay:setFont(font)
	self.font = font
	self.fontObject = fonts.get(font)
	self.fontHeight = self.fontObject:getHeight()
	
	if self.text then
		self.textWidth = self.fontObject:getWidth(self.text)
	end
end

function genericPointDisplay:setAutoAdjustFonts(fontList)
	self.autoAdjustFonts = {}
	
	for key, fontName in ipairs(fontList) do
		self.autoAdjustFonts[#self.autoAdjustFonts + 1] = fonts.get(fontName)
	end
	
	table.sort(self.autoAdjustFonts, sortByHeight)
	self:adjustFontSize()
end

function genericPointDisplay:adjustFontSize()
	if not self.autoAdjustFonts or not self.text then
		return 
	end
	
	local validFont = self.autoAdjustFonts[1]
	local iconSize = self:getIconSize()
	local maxW = self.w - iconSize - _S(4)
	
	for i = #self.autoAdjustFonts, 1, -1 do
		local fontObject = self.autoAdjustFonts[i]
		
		if maxW >= fontObject:getWidth(self.text) then
			validFont = fontObject
			
			break
		end
	end
	
	if self.font ~= validFont then
		self:setFont(fonts.namesByObjects[validFont])
	end
end

function genericPointDisplay:setIcon(icon)
	self.icon = icon
end

function genericPointDisplay:getIcon()
	return self.icon
end

function genericPointDisplay:getIconSize()
	return self.rawH - _S(4)
end

function genericPointDisplay:setHoverText(text)
	self.hoverText = text
end

function genericPointDisplay:onMouseEntered()
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.hoverText) do
			self.descBox:addText(data.text, data.font, data.color, data.lineSpace, data.wrapWidth, data.icon, data.iconW, data.iconH)
		end
		
		self.descBox:positionToMouse(_S(10), _S(10))
	end
	
	self:queueSpriteUpdate()
end

function genericPointDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function genericPointDisplay:updateBackgroundSprite()
	local underColor = self:isMouseOver() and genericPointDisplay.baseColor or genericPointDisplay.baseColorInactive
	
	self:setNextSpriteColor(underColor:unpack())
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function genericPointDisplay:updateSprites()
	self:updateBackgroundSprite()
	
	local iconSize = self:getIconSize()
	local scaledTwo = _S(2)
	
	self:setNextSpriteColor(self.underIconColor:unpack())
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	self.iconSprite = self:allocateSprite(self.iconSprite, self:getIcon(), scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	self.textX = self.w * 0.5 + self:getIconSize() * 0.5 - self.textWidth * 0.5
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
end

function genericPointDisplay:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self.textX, self.textY, tcol.r, tcol.g, tcol.b, tcol.a)
end

gui.register("GenericPointDisplay", genericPointDisplay)
