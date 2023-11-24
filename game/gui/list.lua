local list = {}

list.LAYOUT_TYPES = {
	VERTICAL = 1,
	HORIZONTAL = 2
}
list.horizontalAlign = gui.SIDES.RIGHT
list.verticalAlign = gui.SIDES.BOTTOM
list.layoutType = list.LAYOUT_TYPES.VERTICAL
list.elementSpacingHor = 3
list.elementSpacingVert = 3
list.panelColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
list.shouldDraw = true
list._scaleHor = false
list._scaleVert = false

function list:init()
end

function list:think()
	if self.queuedLayoutUpdate then
		self:updateLayout()
	end
end

function list:setPanelColor(clr)
	self.panelColor = clr
end

function list:setElementSpacing(horSpacing, vertSpacing)
	self.elementSpacingHor = horSpacing or self.elementSpacingHor
	self.elementSpacingVert = vertSpacing or self.elementSpacingVert
end

function list:queueLayoutUpdate()
	self.queuedLayoutUpdate = true
end

function list:addChild(...)
	list.baseClass.addChild(self, ...)
	self:queueLayoutUpdate()
end

function list:onSizeChanged()
	self:queueLayoutUpdate()
end

function list:setLayoutType(layoutType)
	self.layoutType = layoutType
end

function list:setAlignment(horizontal, vertical)
	self.horizontalAlign = horizontal or self.horizontalAlign
	self.verticalAlign = vertical or self.verticalAlign
end

function list:updateLayout(baseW)
	if self.layoutType == list.LAYOUT_TYPES.VERTICAL then
		local horizontalSpacing = math.round(_S(self.elementSpacingHor))
		local vertSpacing = math.round(_S(self.elementSpacingVert))
		local newWidth, newHeight = baseW or self.w, vertSpacing
		
		for key, element in ipairs(self.children) do
			if not baseW then
				newWidth = math.max(newWidth, element.w + self.elementSpacingHor * 2)
			end
			
			element:setPos(horizontalSpacing, newHeight)
			
			newHeight = newHeight + element.h + vertSpacing
		end
		
		for key, element in ipairs(self.children) do
			element:setWidth(newWidth - self.elementSpacingHor * 2)
		end
		
		local newX, newY = self.baseX, self.baseY
		
		if self.horizontalAlign == gui.SIDES.LEFT then
			newX = newX - newWidth
		end
		
		if self.verticalAlign == gui.SIDES.TOP then
			newY = newY - newHeight
		end
		
		self:setPos(newX, newY)
		self:setSize(newWidth, _US(newHeight))
		
		self.queuedLayoutUpdate = false
	elseif self.layoutType == list.LAYOUT_TYPES.HORIZONTAL then
		local horizontalSpacing = _S(self.elementSpacingHor)
		local vertSpacing = _S(self.elementSpacingVert)
		local newWidth, newHeight = self.w, vertSpacing
		local totalWidth = horizontalSpacing
		local highest = 0
		
		for key, element in ipairs(self.children) do
			newWidth = math.max(newWidth, element.w + horizontalSpacing * 2)
			highest = math.max(highest, element.h)
			
			element:setPos(totalWidth, newHeight)
			
			totalWidth = totalWidth + element.w + horizontalSpacing
		end
		
		local newX, newY = self.baseX, self.baseY
		
		if self.horizontalAlign == gui.SIDES.LEFT then
			newX = newX - newWidth
		end
		
		if self.verticalAlign == gui.SIDES.TOP then
			newY = newY - highest
		end
		
		self:setPos(newX, newY)
		self:setFinalSize(totalWidth, highest)
		
		self.queuedLayoutUpdate = false
	end
	
	self:queueSpriteUpdate()
end

function list:setFinalSize(totalWidth, totalHeight)
	self:setSize(totalWidth, _US(totalHeight) + _S(self.elementSpacingVert) * 2)
end

function list:setSpacing(horizontal, vertical)
	self.horizontalSpacing = horizontal
	self.verticalSpacing = vertical
end

function list:setBasePoint(x, y)
	if x and y then
		self.baseX, self.baseY = x, y
		
		self:setPos(x, y)
	else
		self.baseX, self.baseY = self:getPos()
	end
	
	self:queueLayoutUpdate()
end

function list:updateSprites()
	if not self.shouldDraw then
		return 
	end
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.outlineSprites = self:allocateRoundedRectangle(self.outlineSprites, -_S(1), -_S(1), self.rawW + 3, self.rawH + 3, 2, -0.6)
	
	self:setNextSpriteColor(self.panelColor:unpack())
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
end

gui.register("List", list)
