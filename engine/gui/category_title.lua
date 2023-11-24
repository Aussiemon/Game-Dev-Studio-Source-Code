local category = {}

category.skinPanelFillColor = color(125, 175, 250, 255)
category.skinPanelHoverColor = color(150, 200, 255, 255)
category.skinTextFillColor = color(220, 220, 220, 255)
category.skinTextHoverColor = color(240, 240, 240, 255)
category.hoverFont = "pix24"
category.CATEGORY_TITLE = true

function category:scrollbarOnAddItemFunc(item, inFrontOfSelf, insertPosition)
	if not self.folded then
		if not inFrontOfSelf then
			self.scrollbar:addItem(item)
		else
			self.scrollbar:addInFrontOf(item, self, nil, insertPosition)
		end
	else
		self.scrollbar:disableItem(item, false)
	end
end

function category:scrollbarFoldFunc()
	if self.items then
		for key, item in ipairs(self.items) do
			self.scrollbar:disableItem(item, false)
			self.scrollbar:removeItem(item, false)
			
			if item.CATEGORY_TITLE then
				item:fold()
			end
		end
	end
end

function category:scrollbarUnfoldFunc()
	if self.items then
		local ownPos = self.scrollbar:getItem(self)
		
		for i = #self.items, 1, -1 do
			local item = self.items[i]
			
			self.scrollbar:addInFrontOf(item, nil, ownPos + 1)
			self.scrollbar:enableItem(item)
			
			if item.CATEGORY_TITLE then
				item:unfold()
			end
		end
	end
end

function category:init()
	self.folded = false
end

function category:isFolded()
	return self.folded
end

function category:hide(fold)
	category.baseClass.hide(self)
	
	self.wasFolded = self.folded
	
	if fold then
		self:fold()
	end
end

function category:updateDrawHeight()
	if self.font and self.displayText then
		if self.changeSizeOnTextUpdate then
			self:setSize(_US(self.font:getWidth(self.displayText)) + _S(10), math.max(_US(string.countlines(self.displayText) * self.fontHeight), _US(self.rawH)))
		end
		
		self.drawHeight = math.round((self.h - self.font:getHeight()) * 0.5)
	end
end

function category:show(unfold)
	category.baseClass.show(self)
	
	if unfold and not self.wasFolded then
		self:unfold()
	end
end

function category:onClick(x, y, key)
	if not self.folded then
		self:fold()
	else
		self:unfold()
	end
	
	self:queueSpriteUpdate()
end

function category:fold()
	if self.foldFunc then
		self:foldFunc()
	end
	
	self.folded = true
	
	self:updateFoldText()
end

function category:unfold()
	if self.unfoldFunc then
		self:unfoldFunc()
	end
	
	self.folded = false
	
	self:updateFoldText()
end

function category:setHoverText(hoverText)
	self.hoverText = hoverText
end

function category:updateFoldText()
	if self.folded then
		self.foldText = "+"
	else
		self.foldText = "-"
	end
	
	self.foldTextWidth = self.font:getWidth(self.foldText)
end

function category:setIcon(icon)
	self.icon = icon
end

function category:onSizeChanged()
	self:updateTextX()
end

function category:updateTextX()
	self.textX = _S(5)
	
	if self.icon then
		self.textX = self.textX + self.h
	end
end

function category:onMouseEntered()
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.hoverText) do
			self.descBox:addText(data.text, data.font, data.textColor, data.lineSpace, data.wrapWidth or 600, data.icon, data.iconWidth, data.iconHeight)
		end
		
		self.descBox:positionToMouse(_S(10), _S(10))
	end
	
	self:queueSpriteUpdate()
end

function category:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function category:getItems()
	return self.items
end

function category:getScrollbar()
	return self.scrollbar
end

function category:addItem(item, inFrontOfSelf, afterAllElements)
	if item.curCategoryTitle then
		item.curCategoryTitle:removeItem(item)
	end
	
	item.curCategoryTitle = self
	
	if not self.items then
		self.items = {}
	end
	
	table.insert(self.items, item)
	
	if self.onAddItemFunc then
		self:onAddItemFunc(item, inFrontOfSelf, afterAllElements and #self.items - 1 or 0)
	end
	
	if self.folded and item.CATEGORY_TITLE then
		item:fold()
	end
end

function category:removeItem(item)
	if self.items then
		for key, otherItem in ipairs(self.items) do
			if otherItem == item then
				self.scrollbar:removeItem(item)
				table.remove(self.items, key)
				
				return true
			end
		end
	end
	
	return false
end

function category:addInFrontOf(insertItem, inFrontOfItem, position)
	if not inFrontOfItem then
		position = self.scrollbar:getItem(self) + 1
	end
	
	if not self.items then
		self.items = {}
	end
	
	table.insert(self.items, insertItem)
	self.scrollbar:addInFrontOf(insertItem, inFrontOfItem, position)
end

function category:setOnFoldFunction(foldFunc)
	self.foldFunc = foldFunc
end

function category:setOnUnfoldFunction(unfoldFunc)
	self.unfoldFunc = unfoldFunc
end

function category:assumeScrollbar(scrollbar)
	self.scrollbar = scrollbar
	self.foldFunc = category.scrollbarFoldFunc
	self.unfoldFunc = category.scrollbarUnfoldFunc
	self.onAddItemFunc = category.scrollbarOnAddItemFunc
	
	self:updateFoldText()
end

function category:isOn()
	return false
end

category.assumeScroller = category.assumeScrollbar
category.assumeScrollBar = category.assumeScrollbar

function category:updateSprites()
	local pcol, tcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.backgroundPanel = self:allocateSprite(self.backgroundPanel, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	if self.icon then
		self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, _S(2), _S(2), 0, self.rawH - 4, self.rawH - 4, 0, 0, -0.45)
	end
end

function category:getItemCount()
	if not self.items then
		return 0
	end
	
	return #self.items
end

function category:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, self.textX, self.drawHeight, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
	
	if self:getItemCount() > 0 then
		love.graphics.setFont(self.font)
		love.graphics.printST(self.foldText, w - 15 - self.foldTextWidth * 0.5, self.drawHeight, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
	end
end

gui.register("Category", category, "Label")
