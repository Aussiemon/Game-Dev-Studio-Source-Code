local titledList = {}

titledList.mainTextBackgroundColor = game.UI_COLORS.NEW_HUD_FILL_3
titledList.horizontalAlign = gui.SIDES.RIGHT
titledList.verticalAlign = gui.SIDES.BOTTOM
titledList.fontSpacing = 3
titledList.elementSpacingHor = 3
titledList.elementSpacingVert = 3
titledList.titleSpacingHor = 10
titledList.displayText = "undefined"
titledList.font = "pix24"
titledList.panelColor = color(0, 0, 0, 150)
titledList._scaleHor = false
titledList._scaleVert = false

function titledList:init()
	self:updateFontObject()
	
	self.titleSpacingHorScaled = _S(self.titleSpacingHor)
	self.baseWidth = 0
end

function titledList:setFontSpacing(spacing)
	self.fontSpacing = spacing
end

function titledList:setFont(font)
	self.font = font
	
	self:updateFontObject()
	self:queueLayoutUpdate()
end

function titledList:updateFontObject()
	self.fontObject = fonts.get(self.font)
	self.titleTextWidth = self.fontObject:getWidth(self.displayText)
	self.fontHeight = self.fontObject:getHeight()
end

function titledList:setBaseWidth(baseWidth)
	self.baseWidth = _S(baseWidth)
end

function titledList:setTitle(title)
	self.displayText = title
	
	self:updateFontObject()
	self:queueLayoutUpdate()
end

function titledList:updateLayout(baseWidth)
	local horizontalSpacing = _S(self.elementSpacingHor)
	local newWidth, newHeight = math.max(self.fontObject:getWidth(self.displayText) + self.titleSpacingHorScaled * 2, (baseWidth or self.baseWidth or self.w) + horizontalSpacing * 2), 0
	
	newHeight = newHeight + self.fontHeight + _S(self.fontSpacing) * 2
	
	local vertSpacing = _S(self.elementSpacingVert)
	
	for key, element in ipairs(self.children) do
		newWidth = math.max(newWidth, element.w + horizontalSpacing * 2)
		
		element:setPos(horizontalSpacing, newHeight)
		
		newHeight = newHeight + element.h + vertSpacing
	end
	
	for key, element in ipairs(self.children) do
		local width = newWidth
		
		if element._scaleHor then
			width = _US(width) - self.elementSpacingHor * 2
		else
			width = width - _S(self.elementSpacingHor * 2)
		end
		
		element:setWidth(width)
	end
	
	local newX, newY = self.baseX, self.baseY
	
	if self.horizontalAlign == gui.SIDES.LEFT then
		newX = newX - newWidth
	end
	
	if self.verticalAlign == gui.SIDES.TOP then
		newY = newY - newHeight
	end
	
	self:setPos(newX, newY)
	self:setSize(newWidth, newHeight)
	self:queueSpriteUpdate()
	
	self.queuedLayoutUpdate = false
end

function titledList:updateSprites()
	if not self.shouldDraw then
		return 
	end
	
	titledList.baseClass.updateSprites(self)
	
	local scaledFontSpacing, scaledHorizontalSpacing = _S(self.fontSpacing), _S(self.elementSpacingHor)
	
	self:setNextSpriteColor(self.mainTextBackgroundColor:unpack())
	
	self.frontSprite = self:allocateSprite(self.frontSprite, "generic_1px", math.ceil(scaledFontSpacing), scaledHorizontalSpacing, 0, self.w - scaledFontSpacing * 2, self.fontHeight, 0, 0, -0.45)
end

function titledList:draw(w, h)
	titledList.baseClass.draw(self, w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.displayText, w * 0.5 - self.titleTextWidth * 0.5, _S(3), 255, 255, 255, 255)
end

gui.register("TitledList", titledList, "List")
