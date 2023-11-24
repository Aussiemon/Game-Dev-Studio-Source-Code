require("engine/gui/button")

local PANEL = {}

PANEL.spacing = 3
PANEL.VERTICAL = 0
PANEL.HORIZONTAL = 1
PANEL.HANKIOU = 0
PANEL.KANKIOU = 1
PANEL.orientation = PANEL.VERTICAL
PANEL.paddingx = 0
PANEL.paddingy = 0
PANEL.adjustElementSize = true
PANEL.canWriteTo = true
PANEL.scissor = true
PANEL.smooth = true
PANEL.skinPanelOutlineColor = color(0, 0, 0, 100)

function PANEL:processKeyPress(key)
	if self.orientation == PANEL.VERTICAL then
		if key == "up" then
			self:scroll(-50)
			
			return true
		elseif key == "down" then
			self:scroll(50)
			
			return true
		end
	elseif self.orientation == PANEL.HORIZONTAL then
		if key == "left" then
			self:scroll(-50)
			
			return true
		elseif key == "right" then
			self:scroll(50)
			
			return true
		end
	end
	
	PANEL.baseClass.processKeyPress(self, key)
end

function PANEL:setSpacing(spacing)
	self.spacing = math.ceil(_S(spacing))
end

function PANEL:setSmooth(smooth)
	self.smooth = smooth
end

function PANEL:setAdjustElementPosition(state)
	self.adjustElementPosition = state
end

function PANEL:setAdjustElementSize(state)
	self.adjustElementSize = state
end

function PANEL:setOrientation(orientation)
	self.orientation = orientation
	self.queuedLayoutPerform = true
end

function PANEL:isVertical()
	return self.orientation == PANEL.VERTICAL
end

function PANEL:setPadding(paddingx, paddingy)
	self.paddingx = paddingx or self.paddingx
	self.paddingy = paddingy or self.paddingy
end

function PANEL:init()
	self.scissor = true
	self.i_scroll = 0
	self.curScrollPos = 0
	self.topTall = 0
	self.jump = 5
	self.alpha = 200
	self.items = {}
	self.itemsByKey = {}
	self.activeItems = {}
	self.disabledItems = {}
	
	self:setScissor(true)
	
	self.btnUp = gui.create("ScrollbarPanelUp", self)
	
	self.btnUp:setPos(0, 0)
	self.btnUp:setSize(13, 13)
	self.btnUp:setVisible(false)
	self.btnUp:addDepth(6)
	
	self.btnGrip = gui.create("ScrollbarPanelGrip", self)
	
	self.btnGrip:setPos(0, 50)
	self.btnGrip:setSize(13, 13)
	self.btnGrip:setVisible(false)
	self.btnGrip:addDepth(6)
	
	self.btnDown = gui.create("ScrollbarPanelDown", self)
	
	self.btnDown:setPos(0, 0)
	self.btnDown:setSize(13, 13)
	self.btnDown:setVisible(false)
	self.btnDown:addDepth(6)
	
	self.canvas = gui.create("ScrollbarPanelCanvas", self)
	
	self.canvas:setPos(0, 0)
	self.canvas:setSize(self.w, self.h)
	self.canvas:addDepth(5)
end

function PANEL:setScrollAmount(amt)
	self.jump = amt and amt or 5
end

function PANEL:getContentSize()
	return self.canvas:getSize()
end

function PANEL:calculateScrollAmount()
	local axis
	
	if self.orientation == PANEL.VERTICAL then
		self.jump = math.ceil(self.canvas.h * 0.05)
		axis = self.canvas.h
	else
		self.jump = math.ceil(self.canvas.w * 0.05)
		axis = self.canvas.w
	end
	
	self.jump = math.min(self.jump, math.ceil(axis * 0.25))
end

function PANEL:requiresScroller(newElement)
	local isVertical = self:isVertical()
	local totalSpace = self.paddingy + (newElement and self:_getElementAxisSize(newElement, isVertical) or 0)
	
	for key, element in ipairs(self.activeItems) do
		if self.adjustElementPosition then
			totalSpace = totalSpace + self:_getElementAxisSize(element, isVertical)
		else
			local h = element:getHeight()
			
			if totalSpace < h then
				totalSpace = h
			end
		end
	end
	
	return totalSpace > self.h
end

function PANEL:setScrollToBottomOnElementAdd(state)
	self.scrollToBottomOnElementAdd = state
end

function PANEL:isMouseOverChildren()
	if gui.isMouseOverChildren(self) then
		return true
	end
	
	for key, item in ipairs(self.activeItems) do
		if item == gui.elementHovered then
			return true
		end
	end
	
	return false
end

function PANEL:_getElementAxisSize(element, isVertical)
	local w, h = element:getSize()
	
	if isVertical then
		return h + self.spacing
	else
		return w + self.spacing
	end
end

function PANEL:getScrollerSize()
	return self.btnUp:getWide()
end

function PANEL:getElementWidth()
	local buttonVisible = self.btnUp:getVisible()
	
	if buttonVisible then
		return self.rawW - self.paddingx * 3 - self.btnUp:getRawWidth()
	end
	
	return self.rawW - self.paddingx * 2
end

function PANEL:verifySlider()
	local showscroll = self.canvas.h > self.h
	
	if showscroll then
		self.disabledItems[self.btnUp] = nil
		self.disabledItems[self.btnGrip] = nil
		self.disabledItems[self.btnDown] = nil
		
		self:showSlider()
		
		return true
	else
		self.disabledItems[self.btnUp] = true
		self.disabledItems[self.btnGrip] = true
		self.disabledItems[self.btnDown] = true
		
		self:hideSlider()
	end
	
	return false
end

function PANEL:showSlider()
	self.btnUp:show()
	self.btnGrip:show()
	self.btnDown:show()
end

function PANEL:hideSlider()
	self.btnUp:hide()
	self.btnGrip:hide()
	self.btnDown:hide()
end

function PANEL:preventLayout()
	self.queuedLayoutPerform = false
end

function PANEL:performLayout()
	local w, h = self:getSize()
	local isVertical = self:isVertical()
	local upWide = self.btnUp:getWide()
	local rawUpWidth = self.btnUp:getRawWidth()
	
	if isVertical then
		self.btnUp:setPos(w - upWide - self.paddingy, self.paddingy)
		self.btnGrip:setPos(w - upWide - self.paddingy, self.btnUp.h + self.paddingy)
		self.btnDown:setPos(w - upWide - self.paddingy, h - upWide - self.paddingy)
	else
		self.btnUp:setPos(self.paddingy, h - upWide - self.paddingy)
		self.btnGrip:setPos(upWide + self.paddingy, h - upWide - self.paddingy)
		self.btnDown:setPos(w - self.btnDown:getWide() - self.paddingy, h - upWide - self.paddingy)
	end
	
	local scaledPadX = _S(self.paddingx)
	local scaledPadY = _S(self.paddingy)
	local totalElementSize = 0
	local totalElementPad = scaledPadY
	
	for key, element in ipairs(self.activeItems) do
		local w, h = element:getSize()
		
		if self.adjustElementPosition then
			if isVertical then
				element:setPos(scaledPadX, totalElementSize + totalElementPad)
				
				totalElementSize = totalElementSize + h
				totalElementPad = totalElementPad + self.spacing
			else
				element:setPos(totalElementSize + totalElementPad, scaledPadX)
				
				totalElementSize = totalElementSize + w
				totalElementPad = totalElementPad + self.spacing
			end
		else
			totalElementSize = math.max(self.canvas.h, totalElementSize)
		end
	end
	
	local totalSpace = math.floor(totalElementSize + totalElementPad)
	local canvas = self.canvas
	
	if isVertical then
		canvas:setScalingState(false, false)
		
		self.topTall = math.max(totalSpace - self:getTall(), 0)
		
		canvas:setSize(w, totalSpace)
		canvas:setScalingState(true, true)
	else
		canvas:setScalingState(false, false)
		
		self.topWide = math.max(totalSpace - self:getWide(), 0)
		
		canvas:setSize(totalSpace, h)
		canvas:setScalingState(true, true)
	end
	
	local showscroll = h < totalSpace
	
	if not isVertical then
		showscroll = w < totalSpace
	end
	
	if showscroll then
		self.disabledItems[self.btnUp] = nil
		self.disabledItems[self.btnGrip] = nil
		self.disabledItems[self.btnDown] = nil
		
		self:showSlider()
	else
		self.disabledItems[self.btnUp] = true
		self.disabledItems[self.btnGrip] = true
		self.disabledItems[self.btnDown] = true
		
		self:hideSlider()
	end
	
	if self.adjustElementSize then
		local w, h = self:getRawSize()
		
		for key, element in ipairs(self.activeItems) do
			if isVertical then
				if showscroll then
					element:setWide(w - self.paddingx * 3 - rawUpWidth)
				else
					element:setWide(w - self.paddingx * 2)
				end
			elseif showscroll then
				element:setTall(h - self.paddingx * 3 - rawUpWidth)
			else
				element:setTall(h - self.paddingx * 2)
			end
		end
	end
	
	if isVertical then
		local maxh = h - self.btnUp.h - self.btnDown.h
		local relation = (h - self.btnUp.h - self.btnDown.h) / totalSpace
		local maxHSize = math.max(self.btnUp.rawH + self.btnDown.rawH, _US(h * relation))
		
		self.btnGrip:setSize(rawUpWidth, maxHSize)
		
		self.maxH = maxh
	else
		local maxw = w - self.btnUp.w - self.btnDown.w
		local relation = (w - self.btnUp.w - self.btnDown.w) / totalSpace
		local maxWSize = math.max(self.btnUp.rawH + self.btnDown.rawH, _US(w * relation))
		
		self.btnGrip:setSize(maxWSize, rawUpWidth)
		
		self.maxW = maxw
	end
	
	self:calculateScrollAmount()
	
	self.queuedLayoutPerform = false
	
	self:scroll(0)
end

function PANEL:onScroll(xVel, yVel)
	self.btnGrip:onScroll(xVel, yVel)
end

function PANEL:buttonSizes(px)
	self.btnUp:setSize(px, px)
	self.btnDown:setSize(px, px)
	
	self.queuedLayoutPerform = true
end

function PANEL:reAddItem(item, newPosition)
	newPosition = newPosition or #self.items
	
	self:removeItem(item, false)
	table.insert(self.items, newPosition, item)
	
	self.itemsByKey[item] = true
	self.queuedLayoutPerform = true
	self.queuedObjectCulling = true
end

function PANEL:addInFrontOf(insertItem, inFrontOfItem, position, positionOffset)
	if position then
		self:addItem(insertItem, position)
	else
		for key, item in ipairs(self.items) do
			if item == inFrontOfItem then
				self:addItem(insertItem, key + 1 + (positionOffset or 0))
				
				break
			end
		end
	end
end

function PANEL:getItems()
	return self.items
end

function PANEL:queueObjectCulling()
	self.queuedObjectCulling = true
end

function PANEL:queueLayoutPerform()
	self.queuedLayoutPerform = true
end

function PANEL:queueActiveObjectListBuild()
	self.queuedObjectListBuild = true
end

function PANEL:removeAllItems()
	local items = self.items
	
	while #items > 0 do
		items[#items]:kill()
	end
end

function PANEL:createElementCache(class)
	if not self.elementCache then
		self.elementCache = {}
	end
	
	self.elementCache[class] = {}
end

function PANEL:cacheAllElements(class)
	local cache = self.elementCache[class]
	local items = self.items
	local cnt = #items
	
	if cnt == 0 then
		return 
	end
	
	for i = 1, cnt do
		local item = items[cnt]
		
		items[cnt] = nil
		self.itemsByKey[item] = nil
		cache[#cache + 1] = item
		
		item:hide()
		
		cnt = cnt - 1
	end
end

function PANEL:getFromCache(class)
	local cache = self.elementCache[class]
	local cnt = #cache
	
	if cnt > 0 then
		local elem = table.remove(cache, cnt)
		
		return elem
	end
	
	return nil
end

function PANEL:buildActiveObjectList()
	table.clearArray(self.activeItems)
	
	for key, item in ipairs(self.items) do
		if not self.disabledItems[item] then
			self.activeItems[#self.activeItems + 1] = item
		end
	end
	
	self.queuedObjectListBuild = false
end

function PANEL:addItem(item, position)
	item.scrollPanel = self
	
	item:setParent(self.canvas)
	item:queueSpriteUpdate()
	
	position = position or #self.items + 1
	
	table.insert(self.items, position, item)
	
	self.itemsByKey[item] = true
	self.queuedLayoutPerform = true
	self.queuedObjectListBuild = true
	self.queuedObjectCulling = true
	
	if self.scrollToBottomOnElementAdd then
		self:scrollToBottom()
	end
end

function PANEL:_removeItem(item, position)
	if not self.itemsByKey[item] then
		return false
	end
	
	if position then
		table.remove(self.items, position)
		
		self.itemsByKey[item] = nil
		
		return true
	else
		for k, v in ipairs(self.items) do
			if v == item then
				table.remove(self.items, k)
				
				self.itemsByKey[item] = nil
				
				return true
			end
		end
	end
	
	return false
end

function PANEL:getItem(item)
	for key, otherItem in ipairs(self.items) do
		if item == otherItem then
			return key, otherItem
		end
	end
	
	return nil, nil
end

function PANEL:removeItem(item, performLayout, position)
	if self:_removeItem(item, position) and self.adjustElementPosition then
		self.queuedLayoutPerform = true
		self.queuedObjectListBuild = true
		self.queuedObjectCulling = true
	end
end

function PANEL:removeItems()
	local childCount = #self.canvas.children
	
	for i = 1, childCount do
		local child = self.canvas.children[childCount]
		
		child:kill()
		
		childCount = childCount - 1
	end
	
	table.clearArray(self.items)
	
	self.queuedObjectListBuild = true
	self.queuedLayoutPerform = true
	self.queuedObjectCulling = true
end

function PANEL:hideItem(item)
	if item.isVisible then
		item:hide()
	end
	
	self.queuedObjectListBuild = true
	self.queuedLayoutPerform = true
	self.queuedObjectCulling = true
end

function PANEL:showItem(item)
	if not item.isVisible and self:getItem(item) then
		item:show()
	end
	
	self.queuedObjectListBuild = true
	self.queuedLayoutPerform = true
	self.queuedObjectCulling = true
end

function PANEL:queueEverything()
	self.queuedObjectListBuild = true
	self.queuedLayoutPerform = true
	self.queuedObjectCulling = true
end

function PANEL:disableItem(item)
	self.disabledItems[item] = true
	
	self:hideItem(item)
end

function PANEL:enableItem(item)
	self.disabledItems[item] = nil
	
	self:showItem(item)
	
	return true
end

function PANEL:getDisabledItem(item)
	return self.disabledItems[item]
end

local elementPosition = {}

function PANEL:cullObjects()
	local desiredAxis, desiredSize
	local realX, realY = self:getRelativePosition()
	local start, finish
	
	if self:isVertical() then
		desiredAxis = "y"
		desiredSize = "h"
		start = realY
		finish = start + self.h
	else
		desiredAxis = "x"
		desiredSize = "w"
		start = realX
		finish = start + self.w
	end
	
	for key, element in ipairs(self.activeItems) do
		elementPosition.x, elementPosition.y = element:getRelativePosition()
		
		local pos = elementPosition[desiredAxis]
		local size = element[desiredSize]
		
		if start >= pos + size or finish <= pos then
			if element.isVisible then
				element:hide()
			end
		elseif not element.isVisible then
			element:show()
		end
	end
	
	self.queuedObjectCulling = false
end

function PANEL:mouseWheelScroll(direction)
	local amount = 0
	
	if self:isVertical() then
		amount = self.h * 0.2
	else
		amount = self.w * 0.2
	end
	
	self:scroll(math.round(amount) * direction)
end

function PANEL:dragScroll(direction)
	if self:isVertical() then
		local change = direction / (self.h - self.btnUp.h - self.btnDown.h - self.paddingy) * self.canvas.rawH
		
		self:scroll(change)
	else
		local change = direction / (self.w - self.btnUp.w - self.btnDown.w - self.paddingy) * self.canvas.rawW
		
		self:scroll(change)
	end
end

function PANEL:scroll(val)
	if self:isVertical() then
		self.i_scroll = math.max(0, math.min(self.i_scroll + val, self.canvas.rawH - self.h))
		
		self:setScroll(self.i_scroll)
	else
		self.i_scroll = math.max(0, math.min(self.i_scroll + val, self.canvas.rawW - self.w))
		
		self:setScroll(self.i_scroll)
	end
end

function PANEL:updateGripPosition()
	if self:isVertical() then
		local progress = math.abs(self.actualScroll) / (self.canvas.rawH - self.h)
		local dist = math.dist(self.btnUp:getBottom(), self.btnDown:getTop()) - self.btnGrip.h
		
		self.btnGrip:setPos(self.w - self.btnGrip:getWide() - self.paddingy, self.btnUp.h + dist * progress + self.paddingy)
	else
		local progress = math.abs(self.actualScroll) / (self.canvas.rawW - self.w)
		local dist = math.dist(self.btnUp:getRight(), self.btnDown:getLeft()) - self.btnGrip.w
		
		self.btnGrip:setPos(self.btnUp.w + dist * progress + self.paddingy, self.h - self.btnGrip.h - self.paddingy)
	end
end

function PANEL:scrollToBottom()
	self:scroll(10000000)
end

function PANEL:setScroll(val, forceSnap)
	self.actualScroll = -val
	
	if forceSnap or not self.smooth then
		self.curScrollPos = self.actualScroll
		
		if isVertical then
			self:setCanvasPosition(0, self.actualScroll)
		else
			self:setCanvasPosition(self.actualScroll, 0)
		end
		
		self.queuedObjectCulling = true
	end
	
	self:updateGripPosition()
end

function PANEL:getCanvas()
	return self.canvas
end

function PANEL:setCanvasPosition(x, y)
	local oldX, oldY = self.canvas:getPos()
	
	self.canvas:setPos(x, y)
	
	if oldX ~= x or oldY ~= y then
		self:updateChildSprites(self.canvas:getChildren())
	end
end

function PANEL:updateChildSprites(list)
	for key, child in ipairs(list) do
		if child:canDraw() then
			child:queueSpriteUpdate()
			self:updateChildSprites(child:getChildren())
		end
	end
end

function PANEL:canEnable(child)
	return not self.disabledItems[child]
end

function PANEL:think()
	if self.btnGrip.drag then
		local isVertical = self:isVertical()
		local my = isVertical and love.mouse.getY() or love.mouse.getX()
		local rel = 0
		
		rel = my - self.btnGrip.dragStart
		self.btnGrip.dragStart = my
		
		self:dragScroll(rel)
	end
	
	if self.smooth and self.actualScroll then
		local newPos = math.lerp(self.curScrollPos, self.actualScroll, frameTime * 10)
		local difference = newPos - self.curScrollPos
		
		difference = difference < 0 and math.min(difference, -1) or math.max(difference, 1)
		
		local prev = self.curScrollPos
		
		self.curScrollPos = math.approach(self.curScrollPos, self.actualScroll, difference)
		
		if prev ~= self.curScrollPos then
			self.queuedObjectCulling = true
			
			if self:isVertical() then
				self:setCanvasPosition(0, self.curScrollPos)
			else
				self:setCanvasPosition(self.curScrollPos, 0)
			end
		end
	end
	
	if self.queuedObjectListBuild then
		self:buildActiveObjectList()
	end
	
	if self.queuedLayoutPerform then
		self:performLayout()
	end
	
	if self.queuedObjectCulling then
		self:cullObjects()
	end
end

function PANEL:draw(w, h)
	local clr = self:getPanelOutlineColor()
	
	love.graphics.setColor(clr.r, clr.g, clr.b, clr.a)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

gui.register("ScrollbarPanel", PANEL)
