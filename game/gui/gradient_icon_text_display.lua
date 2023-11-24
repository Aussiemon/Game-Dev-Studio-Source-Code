local gradientIconText = {}

gradientIconText.iconOffsetX = 0
gradientIconText.iconOffsetY = 0
gradientIconText.DEFAULT_TEXT_COLOR = color(255, 255, 255, 255)
gradientIconText.DEFAULT_TEXT_SPACING = 8
gradientIconText.MAIN_PART_PAD = 3
gradientIconText.INNER_PART_PAD = 1
gradientIconText.BACKPANEL_COLOR = game.UI_COLORS.STAT_POPUP_PANEL_COLOR:duplicate()
gradientIconText.BACKPANEL_COLOR.a = 100
gradientIconText.GRADIENT_COLOR = color(0, 0, 0, 200)
gradientIconText.gradientSpriteName = "strong_fading_gradient_horizontal"

function gradientIconText:init()
	self.totalTextX = 0
	self.textEntries = {}
end

function gradientIconText:setIcon(icon, xOff, yOff)
	self.icon = icon
	self.iconOffsetX = xOff or self.iconOffsetX
	self.iconOffsetY = yOff or self.iconOffsetY
	
	local smallest = math.min(self.rawW, self.rawH)
end

function gradientIconText:setFont(font)
	self.font = font
	self.fontObject = fonts.get(self.font)
end

function gradientIconText:addText(text, textColor, xOffset, y, font)
	xOffset = xOffset or _S(self.DEFAULT_TEXT_SPACING)
	font = font and fonts.get(font) or self.fontObject
	y = y or self.h * 0.5 - font:getHeight() * 0.5
	
	table.insert(self.textEntries, {
		text = text,
		font = font,
		color = textColor or self.DEFAULT_TEXT_COLOR,
		x = self.totalTextX + xOffset,
		y = y
	})
	
	self.totalTextX = self.totalTextX + xOffset + font:getWidth(text)
end

function gradientIconText:getGradientColor()
	return self.GRADIENT_COLOR
end

function gradientIconText:onMouseEntered()
	self:queueSpriteUpdate()
end

function gradientIconText:onMouseLeft()
	self:queueSpriteUpdate()
end

function gradientIconText:updateSprites()
	self:setNextSpriteColor(gradientIconText.BACKPANEL_COLOR:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local scaledPad = _S(self.MAIN_PART_PAD)
	local doublePad = self.MAIN_PART_PAD * 2
	local scaledInnerPad = _S(self.INNER_PART_PAD)
	local smallest = math.min(self.rawW, self.rawH)
	local rectSize = smallest - self.MAIN_PART_PAD * 3 - self.INNER_PART_PAD * 2
	
	self:setNextSpriteColor(self:getGradientColor():unpack())
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, self.gradientSpriteName, scaledPad, scaledPad, 0, self.rawW - doublePad, self.rawH - doublePad, 0, 0, -0.1)
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.backdropSprite = self:allocateSprite(self.backdropSprite, "profession_backdrop", _S(doublePad), _S(doublePad), 0, rectSize, rectSize, 0, 0, -0.1)
	
	local iconWidth = rectSize - self.iconOffsetX * 2
	local iconHeight = rectSize - self.iconOffsetY * 2
	
	self.textBaseX = self:applyScaler(smallest)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, _S(doublePad + self.iconOffsetX), _S(doublePad + self.iconOffsetY), 0, iconWidth, iconHeight, 0, 0, -0.1)
end

function gradientIconText:draw(w, h)
	for key, textData in ipairs(self.textEntries) do
		local textColor = textData.color
		
		love.graphics.setFont(textData.font)
		love.graphics.printST(textData.text, self.textBaseX + textData.x, textData.y, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	end
end

gui.register("GradientIconTextDisplay", gradientIconText)
