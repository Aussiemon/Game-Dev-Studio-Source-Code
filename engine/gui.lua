gui = {}
hui = gui
gui.clickIDs = {}
gui.blacklistedClickIDs = {}
gui.elementsByID = {}
gui.elements = {}
gui.globalParents = {}
gui.allCreatedElements = {}
gui.renderOrder = {}
gui.spriteBatchesByTexture = {}
gui.spriteBatches = {}
gui.individualSpriteBatches = nil
gui.objectCount = 0
gui.elementHold = false
gui.needsDepthSorting = false
gui.elementHovered = nil
gui.allocatedSprites = nil
gui.depth = 1
gui.baseDepth = 1
gui.individualDepth = 0
gui.spriteAlphaOverride = 1
gui.GUI = true
gui.lastTranslateX = 0
gui.lastTranslateY = 0
gui.scissor = false
gui.CONSEQUENT_DEPTH_PER_CHILDREN = 5
gui.mouseX = -math.huge
gui.mouseY = -math.huge
gui.TOP_PRIORITY = 100000
gui.skinPanelFillColor = color(200, 200, 200, 255)
gui.skinPanelOutlineColor = color(50, 50, 50, 255)
gui.skinPanelHoverColor = color(200, 200, 200, 255)
gui.skinPanelSelectColor = color(150, 215, 135, 255)
gui.skinPanelDisableColor = color(100, 100, 100, 255)
gui.skinTextFillColor = color(20, 20, 20, 255)
gui.skinTextHoverColor = color(20, 20, 20, 255)
gui.skinTextSelectColor = color(10, 10, 10, 255)
gui.skinTextDisableColor = color(0, 0, 0, 255)
gui._scaleHor = true
gui._scaleVert = true
gui._inheritScalingState = true
gui._propagateScalingState = true
gui.canPropagateKeyPress = false
gui.textObjects = nil
gui.scaler = scaling.DEFAULT_SCALER
gui.curScaleX = 1
gui.curScaleY = 1
gui.SIDES = {
	RIGHT = 2,
	TOP = 4,
	LEFT = 1,
	BOTTOM = 8
}
gui.mouseKeys = {
	RIGHT = 2,
	AUX3 = 5,
	AUX2 = 4,
	AUX1 = 3,
	LEFT = 1,
	NONE = 0
}
gui.writeKeys = {
	p = true,
	["ш"] = true,
	["а"] = true,
	g = true,
	["!"] = true,
	f = true,
	o = true,
	["="] = true,
	[")"] = true,
	["@"] = true,
	["#"] = true,
	["ä"] = true,
	["Ш"] = true,
	["З"] = true,
	m = true,
	["в"] = true,
	["^"] = true,
	l = true,
	["е"] = true,
	["Е"] = true,
	["я"] = true,
	j = true,
	["/"] = true,
	k = true,
	["э"] = true,
	["Ч"] = true,
	["Ц"] = true,
	["ю"] = true,
	["ь"] = true,
	["Д"] = true,
	["-"] = true,
	i = true,
	["Б"] = true,
	["ы"] = true,
	h = true,
	["м"] = true,
	["р"] = true,
	["*"] = true,
	["У"] = true,
	["+"] = true,
	["ъ"] = true,
	["Ф"] = true,
	["А"] = true,
	["Щ"] = true,
	["С"] = true,
	["Х"] = true,
	["&"] = true,
	["щ"] = true,
	e = true,
	["Ъ"] = true,
	["("] = true,
	d = true,
	["ü"] = true,
	["Г"] = true,
	["Р"] = true,
	b = true,
	["'"] = true,
	c = true,
	["В"] = true,
	["п"] = true,
	["о"] = true,
	u = true,
	["ч"] = true,
	["Ы"] = true,
	["%"] = true,
	a = true,
	["н"] = true,
	["$"] = true,
	["О"] = true,
	["ц"] = true,
	["ё"] = true,
	["\""] = true,
	["л"] = true,
	["к"] = true,
	_ = true,
	["у"] = true,
	["ф"] = true,
	["Ж"] = true,
	["Э"] = true,
	["й"] = true,
	["Я"] = true,
	z = true,
	["т"] = true,
	["ö"] = true,
	[" "] = true,
	["\\"] = true,
	["д"] = true,
	["х"] = true,
	["и"] = true,
	["с"] = true,
	v = true,
	y = true,
	["М"] = true,
	["И"] = true,
	x = true,
	["Т"] = true,
	["Ё"] = true,
	[":"] = true,
	["Ю"] = true,
	["П"] = true,
	w = true,
	["з"] = true,
	["ж"] = true,
	["Н"] = true,
	n = true,
	t = true,
	["Л"] = true,
	["К"] = true,
	["г"] = true,
	r = true,
	s = true,
	["Й"] = true,
	["б"] = true,
	["."] = true,
	q = true,
	["Ь"] = true
}

for i = 0, 9 do
	gui.writeKeys[tostring(i)] = true
end

function gui.performDrawing()
	gui._performDrawing()
	love.graphics.setColor(255, 255, 255, 255)
end

function gui._performDrawing()
	local currentElement = 1
	
	for key = 1, #gui.renderOrder do
		local element = gui.renderOrder[currentElement]
		
		if element then
			if not element.SPRITEBATCH and element.isVisible then
				element:think()
				
				if element.requiresSpriteUpdate and not element._killPanel then
					element:_updateSprites()
				end
			end
			
			if not element._killPanel then
				currentElement = currentElement + 1
			end
		end
	end
	
	if gui.needsDepthSorting then
		gui.sortAllElements()
		gui._performDrawing()
		
		return 
	end
	
	gui.drawPanels()
	
	gui.lastTranslateX = 0
	gui.lastTranslateY = 0
end

function gui.attemptFindHoverTarget(element)
	if not element.ignoreMouse and not element.ignoreClicks and element:canInteractWith() then
		local result = gui.isMouseOverElement(element)
		
		if result and result and result.isVisible and result.canHover and not result._killPanel then
			return result
		end
	end
	
	return self
end

function gui.isMouseOverElement(element)
	local x, y = element:getPos(true)
	local w, h = element:getSize()
	
	return gui:_mouseOver(element, x, y, w, h)
end

function gui.leaveCurrentHover()
	if gui.elementHovered then
		gui.elementHovered:onMouseLeft()
		
		gui.elementHovered = nil
	end
end

function gui.drawPanels()
	if gui.needsDepthSorting then
		gui.sortAllElements()
	end
	
	local wW, wH = love.graphics.getWidth(), love.graphics.getHeight()
	
	gui.mouseX, gui.mouseY = love.mouse.getX(), love.mouse.getY()
	
	local prevElement = gui.elementHovered
	
	gui.elementHovered = nil
	
	local result
	
	for i = #gui.globalParents, 1, -1 do
		result = gui.attemptFindHoverTarget(gui.globalParents[i])
		
		if result then
			gui.elementHovered = result
			
			break
		end
	end
	
	if prevElement and prevElement ~= gui.elementHovered and not prevElement._killPanel then
		prevElement:onMouseLeft()
	end
	
	if result and prevElement ~= result and not gui.elementHovered._killPanel then
		gui.elementHovered:onMouseEntered()
	end
	
	local currentElement = 1
	local lastScissorObject, lastParentObject
	
	for key = 1, #gui.renderOrder do
		local element = gui.renderOrder[currentElement]
		
		if element then
			if not element.parent then
				if lastParentObject and lastParentObject ~= element then
					lastParentObject:postDrawRoot()
				end
				
				lastParentObject = element
				
				lastParentObject:preDrawRoot()
				
				if lastParentObject.requiresSpriteUpdate and not lastParentObject._killPanel then
					lastParentObject:_updateSprites()
				end
			end
			
			if not element.SPRITEBATCH then
				if element.scissor and not lastScissorObject then
					local ourX, ourY = element:getPos(true)
					
					element:enableScissor(ourX, ourY, element.w, element.h)
					
					lastScissorObject = element
				elseif lastScissorObject and lastScissorObject ~= element.scissorParent then
					lastScissorObject:restoreScissor()
					love.graphics.setScissor()
					
					if element.scissor then
						local ourX, ourY = element:getPos(true)
						
						element:enableScissor(ourX, ourY, element.w, element.h)
						
						lastScissorObject = element
					else
						lastScissorObject = nil
					end
				end
				
				if element.requiresSpriteUpdate and not element._killPanel then
					element:_updateSprites()
				end
				
				element:_draw()
			else
				local parent = element.parent
				
				if parent and not parent.scissor and not parent.scissorParent then
					love.graphics.setScissor()
				end
				
				love.graphics.setColor(255, 255, 255, 255)
				gui.setOffset(0, 0)
				element:_draw()
			end
			
			if not element._killPanel then
				currentElement = currentElement + 1
			end
		end
	end
	
	if lastParentObject then
		lastParentObject:postDrawRoot()
	end
	
	love.graphics.origin()
	love.graphics.setScissor()
end

function gui.removeAllUIElements()
	while gui.allCreatedElements[1] do
		gui.allCreatedElements[#gui.allCreatedElements]:kill()
	end
	
	for textureName, list in pairs(gui.spriteBatches) do
		for depth, batch in pairs(list) do
			batch.parent = nil
			
			spriteBatchController:removeSpriteBatch(batch:getID())
			
			list[depth] = nil
		end
		
		gui.spriteBatches[textureName] = nil
	end
	
	table.clear(gui.spriteBatchesByTexture)
end

function gui.setInteractionFilter(object)
	gui.interactionFilter = object
end

function gui:resetDepth()
	self.baseDepth = 0
	self.individualDepth = 0
end

function gui:bringUp(offset)
	offset = offset or 0
	
	self:addDepth(gui.TOP_PRIORITY + offset)
end

function gui:getMidPoint()
	local x, y = self:getPos(true)
	
	return x + self.w * 0.5, y + self.h * 0.5
end

function gui:getDistanceToMouse()
	local x, y = self:getMidPoint()
	
	return math.dist(gui.mouseX, x) + math.dist(gui.mouseY, y)
end

function gui:canHold(key)
	return key == gui.mouseKeys.LEFT or key == gui.mouseKeys.RIGHT
end

function gui.handleClick(x, y, key, xVel, yVel)
	if gui._LOCKED then
		return 
	end
	
	yVel = yVel or 0
	gui.elementHold = false
	
	local clicked = false
	local clickedElement = false
	local mouseKeys = gui.mouseKeys
	local left, right = mouseKeys.LEFT, mouseKeys.RIGHT
	local mouseClick = key == left or key == right
	
	if (mouseClick or yVel ~= 0) and gui.elementHovered and gui.elementHovered.canClick then
		if gui.elementHovered.canClick and mouseClick then
			clickedElement = true
			
			if gui.elementSelected and gui.elementSelected ~= gui.elementHovered then
				gui.elementSelected:deselect()
			end
			
			gui.clickElement = gui.elementHovered
			
			gui.clickElement:onClickDown(x, y, key)
			
			clicked = true
		elseif yVel ~= 0 then
			clickedElement = true
			
			gui.elementHovered:onScroll(xVel, -yVel)
		end
		
		if gui.elementHovered:canHold(key) then
			clickedElement = true
			gui.elementHold = gui.elementHovered
		end
	end
	
	if not clicked then
		gui.elementSelected = nil
	end
	
	return clickedElement
end

function gui.handleMouseRelease(x, y, key)
	if gui.clickElement then
		if gui.isMouseOverElement(gui.clickElement) then
			gui.clickElement:_onClick(x, y, key)
		end
		
		gui.clickElement = nil
	end
	
	if gui.elementHold then
		gui.elementHold:onRelease(x, y, key)
		
		gui.elementHold = false
		
		return true
	end
	
	return false
end

function gui:setID(id)
	self.id = id
	gui.elementsByID[id] = self
end

function gui:getID()
	return self.id
end

function gui:getElementByID(id)
	return gui.elementsByID[id]
end

function gui:setClickIDs(listOfIDs)
	table.clear(self.clickIDs)
	
	self.usingClickIDs = true
	
	for key, elementID in ipairs(listOfIDs) do
		self.clickIDs[elementID] = true
	end
	
	for key, parent in ipairs(gui.globalParents) do
		parent:queueSpriteUpdate()
	end
end

function gui:addClickID(clickID)
	self.clickIDs[clickID] = true
	self.usingClickIDs = true
end

function gui:clearClickIDs()
	table.clear(self.clickIDs)
	
	self.usingClickIDs = false
	
	for key, parent in ipairs(gui.globalParents) do
		parent:queueSpriteUpdate()
	end
end

function gui:disableClickIDs()
	if self.clickIDsDisabled or not self.usingClickIDs then
		return 
	end
	
	self.clickIDsDisabled = true
	self.usingClickIDs = false
end

function gui:enableClickIDs()
	if not self.clickIDsDisabled or self.usingClickIDs then
		return 
	end
	
	self.clickIDsDisabled = false
	self.usingClickIDs = true
end

function gui:setBlacklistedClickIDs(listOfIDs)
	table.clear(self.blacklistedClickIDs)
	
	self.blacklistingClickIDs = true
	
	for key, elementID in ipairs(listOfIDs) do
		self.blacklistedClickIDs[elementID] = true
	end
end

function gui:clearBlacklistedClickIDs()
	table.clear(self.blacklistedClickIDs)
	
	self.blacklistingClickIDs = false
end

function gui:isLimitingClicks()
	return self.usingClickIDs or self.blacklistingClickIDs
end

function gui:passesClickFilters()
	if gui.usingClickIDs then
		if not self.clickIDs[self.id] and not self.clickIDs[self] then
			return false
		end
		
		if self.blacklistedClickIDs[self.id] or self.blacklistedClickIDs[self] then
			return false
		end
		
		if not self.id and not self.clickIDs[self] then
			return false
		end
	end
	
	return true
end

function gui:setCanPropagateKeyPress(can)
	self.canPropagateKeyPress = can
end

function gui:createTextObject(font, initialText)
	self.textObjects = self.textObjects or {}
	
	local obj = love.graphics.newText(font, initialText)
	
	table.insert(self.textObjects, obj)
	
	return obj
end

function gui:getFontObject(font)
	for key, obj in ipairs(self.textObjects) do
		if obj:getFont() == font then
			return obj
		end
	end
	
	return nil
end

function gui:getTextObjects()
	return self.textObjects
end

function gui:getTextObject(index)
	return self.textObjects[index]
end

function gui:copyPanelSkinColorsOfElement(elementClass)
	local classTable = gui.getClassTable(elementClass)
	
	self.skinPanelFillColor = classTable.skinPanelFillColor
	self.skinPanelHoverColor = classTable.skinPanelHoverColor
	self.skinPanelSelectColor = classTable.skinPanelSelectColor
	self.skinPanelDisableColor = classTable.skinPanelDisableColor
	self.skinPanelOutlineColor = classTable.skinPanelOutlineColor
end

function gui:setTextObject(index, textObject)
	if self.textObjects then
		self.textObjects[index] = textObject
	end
end

function gui:canDraw()
	return self.isVisible and not self.hidden
end

function gui:canEnable(childElement)
	return true
end

function gui:canPropagateKeyPressTo(element)
	return element.isVisible
end

function gui:processTextEntry(text)
	if self.canWriteTo and self:isSelected() and self:writeTo(text) then
		return true
	end
	
	if self.canPropagateKeyPress then
		return self:propagateTextEntry(text)
	end
end

function gui:propagateTextEntry(text)
	local state = false
	
	for index, element in ipairs(self.children) do
		if element:isMouseWithin() and self:canPropagateKeyPressTo(element) then
			local elementState = element:processTextEntry(text)
			
			state = not state and elementState or state
		end
	end
	
	return state
end

function gui:processKeyPress(key)
	if self:onKeyPress(key) then
		return true
	end
	
	if self.canPropagateKeyPress then
		return self:propagateKeyPress(key)
	end
end

function gui:propagateKeyPress(key)
	local state = false
	
	for index, element in ipairs(self.children) do
		if element:isMouseWithin() and self:canPropagateKeyPressTo(element) then
			local elementState = element:processKeyPress(key)
			
			state = not state and elementState or state
		end
	end
	
	return state
end

function gui:onKeyPress(key)
end

function gui:processKeyRelease(key)
	return true
end

function gui.preResolutionChanged()
	for key, element in ipairs(gui.allCreatedElements) do
		gui._preResolutionChanged(element)
	end
end

function gui._preResolutionChanged(element)
	element:preResolutionChange()
end

function gui:initVisual()
end

function gui:preResolutionChange()
end

function gui:postResolutionChange()
end

function gui.postResolutionChanged()
	for key, element in ipairs(gui.allCreatedElements) do
		gui._postResolutionChanged(element)
	end
end

function gui._postResolutionChanged(element)
	element:postResolutionChange()
	element:initVisual()
end

function gui.handleTextEntry(text)
	local target = gui.elementSelected or gui.elementHovered
	local stop = false
	local key = love.lastKeyPressed
	
	if target and target ~= gui.elementHovered then
		stop = target:processKeyPress(key) or target:processTextEntry(text)
	end
	
	if not stop then
		for i = #gui.globalParents, 1, -1 do
			local element = gui.globalParents[i]
			
			if not element.ignoreMouse and not element.ignoreClicks and element:canInteractWith() and element.isVisible and element.canHover and not element._killPanel and element:isMouseWithin() then
				gui.keyPressElement = element
				
				return element:processKeyPress(key) or element:processTextEntry(text)
			end
		end
	end
	
	return stop
end

function gui.handleKeyPress(key, isrepeat)
	if gui._LOCKED then
		return 
	end
	
	local target = gui.elementSelected or gui.elementHovered
	local stop = false
	
	if target then
		stop = target:processKeyPress(key)
	end
	
	if not stop then
		for i = #gui.globalParents, 1, -1 do
			local element = gui.globalParents[i]
			
			if not element.ignoreMouse and not element.ignoreClicks and element:canInteractWith() and element.isVisible and element.canHover and not element._killPanel and element:isMouseWithin() then
				gui.keyPressElement = element
				
				return element:processKeyPress(key)
			end
		end
	end
	
	return stop
end

function gui.handleKeyRelease(key)
	local state = false
	
	if gui.keyPressElement and gui.keyPressElement:isValid() then
		state = gui.keyPressElement:processKeyRelease(key)
		gui.keyPressElement = nil
	end
	
	return state
end

function gui:isMouseWithin()
	local x, y = self:getPos(true)
	
	return x < self.mouseX and self.mouseX <= x + self.w and y < self.mouseY and self.mouseY <= y + self.h
end

function gui:_mouseOver(panel, x3, y3, w3, h3)
	if not panel.isVisible then
		return false
	end
	
	if panel.children then
		for i = #panel.children, 1, -1 do
			local v = panel.children[i]
			
			if v.isVisible and v.canHover then
				local x2, y2 = v:getPos(true)
				
				if x3 <= self.mouseX and self.mouseX < x3 + w3 and y3 <= self.mouseY and self.mouseY < y3 + h3 and x2 <= self.mouseX and self.mouseX < x2 + v.w and y2 <= self.mouseY and self.mouseY < y2 + v.h then
					local w4, h4 = v:getSize()
					local result = gui:_mouseOver(v, x2, y2, w4, h4)
					
					if result and result:passesClickFilters() then
						return result
					end
				end
			end
		end
	end
	
	if x3 <= self.mouseX and self.mouseX <= x3 + w3 and y3 <= self.mouseY and self.mouseY <= y3 + h3 and panel:passesClickFilters() then
		return panel
	end
	
	return false
end

function gui:canInteractWith()
	if gui.interactionFilter then
		return gui.interactionFilter == self
	end
	
	return true
end

function gui:update()
	if self.children then
		for key, child in ipairs(self.children) do
			child:update()
			child:updateElement()
		end
	end
end

function gui:updateElement()
end

function gui:getLastTranslation()
	return self.lastTranslateX, self.lastTranslateY
end

function gui:setBasePanel(pan)
	self._basePanel = pan
end

function gui:getBasePanel()
	return self._basePanel
end

function gui:onMouseEntered()
end

function gui:onMouseLeft()
end

function gui:tieVisibilityTo(otherElement)
	self.tiedVisibilityTo = otherElement
	
	otherElement:tieVisibilityOf(self)
end

function gui:removeVisibilityTie(otherElement)
	self.tiedVisibilityTo = nil
	
	local ties = otherElement:getVisibilityTies()
	
	if ties then
		table.removeObject(ties, self)
	end
end

function gui:tieVisibilityOf(otherElement)
	self.tiedVisibility = self.tiedVisibility or {}
	
	table.insert(self.tiedVisibility, otherElement)
	
	if not self.isVisible then
		otherElement:hide()
	end
end

function gui:getVisibilityTies()
	return self.tiedVisibility
end

function gui:isSameClass(targetClass)
	return self.class == targetClass
end

function gui.setOffset(x, y)
	love.graphics.translate(-gui.lastTranslateX, -gui.lastTranslateY)
	
	gui.lastTranslateX = x
	gui.lastTranslateY = y
	
	love.graphics.translate(x, y)
end

local guiIndex = {
	__index = gui
}

function gui.register(name, panel, fallback)
	if gui.elements[name] then
		error("attempt to register new UI class with an already-registered class of the same name (" .. name .. ")")
	end
	
	if fallback then
		setmetatable(panel, gui.elements[fallback].mtindex)
		
		panel.baseClass = gui.elements[fallback]
	else
		setmetatable(panel, guiIndex)
		
		panel.baseClass = gui
	end
	
	panel.class = name
	panel.mtindex = {
		__index = panel
	}
	panel.objClass = name
	gui.elements[name] = panel
end

local function depthSortFunc(a, b)
	return a.depth < b.depth
end

function gui.create(name, parent, ...)
	local elem = {}
	
	gui.objectCount = gui.objectCount + 1
	
	local basePanel = gui.elements[name]
	
	elem.reference = name .. " [" .. gui.objectCount .. "]"
	
	setmetatable(elem, basePanel.mtindex)
	elem:_init(...)
	
	if elem.init then
		elem:init(...)
		elem:postInit()
	end
	
	elem:initVisual()
	elem:initEventHandler()
	
	if not parent then
		table.insert(gui.globalParents, elem)
		elem:setDepth(1)
	else
		elem:setParent(parent)
	end
	
	table.insert(gui.allCreatedElements, elem)
	gui.queueElementSorting()
	elem:queueSpriteUpdate()
	
	return elem
end

function gui.getElementType(name)
	return gui.elements[name]
end

gui.getClassTable = gui.getElementType
gui._seenSpriteBatches = {}
gui._curUnderneathDepthSpriteBatches = {}
gui._curDepthSpriteBatches = {}

function gui.lock()
	gui._LOCKED = true
end

function gui.unlock()
	gui._LOCKED = false
end

function gui.sortAllElements()
	table.clearArray(gui.renderOrder)
	gui._sortAllElements(gui.globalParents)
	
	local curIndex = 1
	local curDepthIndex, curDepthLevel
	
	for i = 1, #gui.renderOrder do
		local element = gui.renderOrder[curIndex]
		local elementDepth = element:getDepth()
		local sprites = element:getAllocatedSprites()
		
		if curDepthLevel and curDepthLevel ~= elementDepth then
			curIndex = curIndex + gui.attemptInsertSpriteBatches(curIndex, curDepthIndex)
		end
		
		if sprites then
			curDepthLevel = elementDepth
			curDepthIndex = curDepthIndex or curIndex
			
			for spriteBatch, slotList in pairs(sprites) do
				spriteBatch.UI_RENDER = true
				
				if elementDepth > spriteBatch:getDepth() then
					gui._curUnderneathDepthSpriteBatches[spriteBatch] = true
				else
					gui._curDepthSpriteBatches[spriteBatch] = true
				end
			end
		end
		
		curIndex = curIndex + 1
	end
	
	if curDepthLevel then
		gui.attemptInsertSpriteBatches(curIndex, curDepthIndex)
	end
	
	table.sort(gui.renderOrder, depthSortFunc)
	table.clear(gui._seenSpriteBatches)
	table.clear(gui._curDepthSpriteBatches)
	table.clear(gui._curUnderneathDepthSpriteBatches)
	
	gui.needsDepthSorting = false
end

function gui.attemptInsertSpriteBatches(depthStartPosition, baseInsertPosition)
	local insertions = 0
	
	for spriteBatch, state in pairs(gui._curDepthSpriteBatches) do
		if not gui._seenSpriteBatches[spriteBatch] then
			table.insert(gui.renderOrder, depthStartPosition, spriteBatch)
			
			gui._seenSpriteBatches[spriteBatch] = true
			depthStartPosition = depthStartPosition + 1
			insertions = insertions + 1
		end
		
		gui._curDepthSpriteBatches[spriteBatch] = nil
	end
	
	for spriteBatch, state in pairs(gui._curUnderneathDepthSpriteBatches) do
		if not gui._seenSpriteBatches[spriteBatch] then
			table.insert(gui.renderOrder, baseInsertPosition, spriteBatch)
			
			gui._seenSpriteBatches[spriteBatch] = true
			baseInsertPosition = baseInsertPosition + 1
			insertions = insertions + 1
		end
		
		gui._curUnderneathDepthSpriteBatches[spriteBatch] = nil
	end
	
	table.clear(gui._curDepthSpriteBatches)
	table.clear(gui._curUnderneathDepthSpriteBatches)
	
	return insertions
end

function gui._sortAllElements(list)
	table.sort(list, depthSortFunc)
	
	for key, element in ipairs(list) do
		if element:canDraw() and not element._killPanel then
			if element.requiresSpriteUpdate then
				element:_updateSprites()
			end
			
			gui.renderOrder[#gui.renderOrder + 1] = element
			
			if not element.children then
				error("attempt to sort non-existent children of GUI element! class " .. element.class)
			end
			
			gui._sortAllElements(element.children)
		end
	end
end

function gui.sortElementsInList(list)
	table.sort(list, depthSortFunc)
end

function gui.queueElementSorting()
	gui.needsDepthSorting = true
end

gui.isVisible = true
gui.canClick = true
gui.canHover = true

function gui:_init(...)
	self.x = 0
	self.y = 0
	self.localX = 0
	self.localY = 0
	self.w = 0
	self.h = 0
	self.rawW = 0
	self.rawH = 0
	self.sXM = 0
	self.sYM = 0
	self.hovered = false
	self.children = {}
	self.childrenByKeys = {}
	self.sbCounter = 0
	self.allocatedSprites = {}
	self.spriteDataByUID = {}
	
	if self.baseClass and self.baseClass.init ~= self.init then
		self.baseClass.init(self, ...)
	end
end

function gui:initEventHandler()
	if self.handleEvent then
		if self.CATCHABLE_EVENTS then
			events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
		else
			events:addReceiver(self)
		end
	end
end

function gui:removeEventHandler()
	if self.handleEvent then
		if self.CATCHABLE_EVENTS then
			events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
		else
			events:removeReceiver(self)
		end
	end
end

function gui:drawSpriteQuad(quad, x, y, rotation, width, height)
	local quadStruct = quadLoader:getQuadStructure(quad)
	
	quad = quadStruct.quad
	texture = texture or quadStruct.texture
	
	local scaleX, scaleY = quadStruct.quad:getSpriteScale(width, height)
	
	love.graphics.draw(quadStruct.texture, quad, x, y, rotation, scaleX, scaleY)
end

function gui:drawScissoredSprite(texture, quad, x, y, rotation, width, height, scissorWidth, scissorHeight)
	local scaleX, scaleY
	
	if texture and type(texture) == "string" then
		texture = cache.getImage(texture)
	end
	
	if quad then
		local quadStruct = quadLoader:getQuadStructure(quad)
		
		quad = quadStruct.quad
		texture = texture or quadStruct.texture
		scaleX, scaleY = quadStruct.quad:getSpriteScale(width, height)
	else
		scaleX, scaleY = texture:getSpriteScale(width, height)
	end
	
	local ourX, ourY = self:getPos(true)
	
	ourX, ourY = ourX + x, ourY + y
	
	love.graphics.setScissor(ourX, ourY, scissorWidth, scissorHeight)
	
	if quad then
		love.graphics.draw(texture, quad, x, y, rotation, scaleX, scaleY)
	else
		love.graphics.draw(texture, x, y, rotation, scaleX, scaleY)
	end
	
	self:restoreScissor()
end

function gui:postInit()
end

function gui:setScissor(scissor)
	self.scissor = scissor
	
	self:updateScissorParent()
end

function gui:setScissorParent(parent)
	self.sciParent = parent
end

function gui:getScissorParent()
	return self.sciParent
end

gui.lastScissor = {
	0,
	0,
	0,
	0
}

function gui:limitToScreenspace(padding)
	padding = padding or 0
	
	local x, y = self:getPos()
	local w, h = self.w, self.h
	local newX, newY
	
	if x + w > scrW - padding then
		newX = scrW - w - padding
	elseif x < padding then
		newX = padding
	end
	
	if y + h > scrH - padding then
		newY = scrH - h - padding
	elseif y < padding then
		newY = padding
	end
	
	self:setPos(newX, newY)
end

function gui:setScale(x, y)
	self.curScaleX = x
	self.curScaleY = y
	
	love.graphics.scale(x, y)
end

function gui:enableScissor(x, y, w, h)
	self.currentScissor = self.currentScissor or {
		math.huge,
		math.huge,
		math.huge,
		math.huge
	}
	
	local x2, y2, w2, h2 = love.graphics.getScissor()
	
	if self.parent and x2 then
		local oldX, oldY = x, y
		
		x = math.max(x, x2)
		y = math.max(y, y2)
		
		local deltaX, deltaY = oldX - x, oldY - y
		
		w = math.max(math.min(w - (x + w - (x2 + w2)), w + deltaX), 0)
		h = math.max(math.min(h - (y + h - (y2 + h2)), h + deltaY), 0)
	end
	
	w = math.max(0, w)
	h = math.max(0, h)
	self.currentScissor[1] = x
	self.currentScissor[2] = y
	self.currentScissor[3] = w
	self.currentScissor[4] = h
	
	love.graphics.setScissor(x, y, w, h)
end

function gui:restoreScissor()
	if self.currentScissor then
		love.graphics.setScissor(unpack(self.currentScissor))
	elseif self.parent then
		self.parent:restoreScissor()
	end
end

function gui:preDrawRoot()
end

function gui:postDrawRoot()
end

local setScissor, setFont, getFont = love.graphics.setScissor, love.graphics.setFont, love.graphics.getFont

function gui:_draw()
	local ourX, ourY = self:getPos(true)
	
	gui.setOffset(ourX, ourY)
	
	if self.requiresSpriteUpdate and not self._killPanel then
		self:_updateSprites()
	end
	
	local oldf = getFont()
	
	if self.preDraw then
		self:preDraw(self.w, self.h)
	end
	
	if not self._drawOverride then
		self:draw(self.w, self.h)
	end
	
	setFont(oldf)
	
	local currentElement = 1
end

function gui:disableRendering()
	self:hide()
	
	self.disabledRendering = true
end

function gui:canShow()
	return true
end

function gui:enableRendering()
	self.disabledRendering = false
	
	self:show()
end

function gui:isRenderingDisabled()
	return self.disabledRendering
end

function gui:canHide()
	return true
end

function gui:getVisibilityTie()
	return self.tiedVisibilityTo
end

function gui:show()
	if self.isVisible or self.disabledRendering or not self:canShow() then
		return 
	end
	
	if self.tiedVisibilityTo and self ~= self.tiedVisibilityTo:getVisibilityTie() and not self.tiedVisibilityTo:getVisible() then
		return 
	end
	
	if not self.parent then
		table.insert(gui.globalParents, self)
	end
	
	if self.children then
		for key, child in ipairs(self.children) do
			if child.wasVisible and self:canEnable(child) then
				child.wasVisible = false
				
				child:show()
			end
		end
	end
	
	self.hidden = false
	
	self:setVisible(true)
	self:onShow()
	self:postShow()
	self:queueSpriteUpdate()
	gui.queueElementSorting()
end

function gui:hide()
	if not self:canHide() then
		return 
	end
	
	for key, obj in ipairs(gui.globalParents) do
		if obj == self then
			table.remove(gui.globalParents, key)
			
			break
		end
	end
	
	if self.children then
		for key, child in ipairs(self.children) do
			if child.isVisible then
				child.wasVisible = child.isVisible
				
				child:hide()
			end
		end
	end
	
	if self:isSelected() then
		self:deselect()
	end
	
	self.hidden = true
	
	self:setVisible(false)
	self:onHide()
	self:postHide()
	self:hideSprites()
	gui.queueElementSorting()
end

function gui:onShow()
end

function gui:postShow()
end

function gui:onHide()
end

function gui:postHide()
end

function gui:overwriteDepth(depth)
	local oldDepth = self.individualDepth
	
	self.individualDepth = depth
	
	self:postChangeDepth(oldDepth)
end

function gui:setDepth(depth)
	local oldDepth = self.depth
	
	self.baseDepth = depth
	
	self:postChangeDepth(oldDepth)
end

function gui:addDepth(depth)
	local oldDepth = self.depth
	
	self.individualDepth = depth
	
	self:postChangeDepth(oldDepth)
end

function gui:postChangeDepth(oldDepth)
	self:updateDepth()
	
	if oldDepth ~= self.depth then
		gui.queueElementSorting()
		self:queueSpriteUpdate()
	end
	
	local theirDepth = self.depth + gui.CONSEQUENT_DEPTH_PER_CHILDREN
	
	for key, child in ipairs(self.children) do
		child:setDepth(theirDepth)
	end
end

function gui:updateDepth()
	self.depth = self.baseDepth + self.individualDepth
end

function gui:getDepth()
	return self.depth
end

function gui:setOwner(owner)
	self.owner = owner
end

function gui:getOwner()
	return self.owner
end

function gui:killDescBox()
	if self.descBox then
		self.descBox:kill()
		
		self.descBox = nil
	end
end

function gui:centerToElement(element, horizontalCenter, verticalCenter)
	if horizontalCenter == nil then
		horizontalCenter = true
	end
	
	local x, y = element:getPos(true)
	local w, h = element:getSize()
	local windowW, windowH = scrW, scrH
	local targetX, targetY
	
	if horizontalCenter then
		targetX = x + w * 0.5 - self.w * 0.5
		
		if windowW < targetX + self.w then
			targetX = windowW - self.w - 5
		elseif targetX < 0 then
			targetX = 5
		end
	end
	
	if verticalCenter then
		targetY = y + h * 0.5 - self.h * 0.5
	else
		targetY = y + h + 5
		
		if windowH < targetY + self.h then
			targetY = y - 5 - self.h
		elseif targetY < 0 then
			targetY = 5
		end
	end
	
	self:setPos(targetX, targetY)
end

function gui:getBottom()
	return self.y + self.h
end

function gui:getRight()
	return self.x + self.w
end

function gui:getLeft()
	return self.x
end

function gui:getTop()
	return self.y
end

function gui:getSide(sides)
	local x, y = self:getPos(true)
	
	if bit.band(sides, gui.SIDES.RIGHT) == gui.SIDES.RIGHT then
		x = x + self.w
	end
	
	if bit.band(sides, gui.SIDES.BOTTOM) == gui.SIDES.BOTTOM then
		y = y + self.h
	end
	
	return x, y
end

function gui:setPos(x, y)
	x = x and math.round(x)
	y = y and math.round(y)
	
	local p = self:getParent()
	
	if p then
		local x2, y2 = p:getPos()
		
		if x then
			self.x = x2 + x
			self.localX = x
		end
		
		if y then
			self.y = y2 + y
			self.localY = y
		end
	else
		if x then
			self.x = x
		end
		
		if y then
			self.y = y
		end
	end
	
	self:queueSpriteUpdate()
end

function gui:setX(x)
	local p = self:getParent()
	
	if p then
		local x2, y2 = p:getPos()
		
		self.x = x2 + x
		self.localX = x
	else
		self.x = x
	end
	
	self:queueSpriteUpdate()
end

function gui:updateSprites()
end

function gui:getSpriteBatch(texture, depthOffset)
	depthOffset = depthOffset or 0
	
	local depth = self:getDepth() + depthOffset
	local spriteMap = self.spriteBatches[texture]
	
	if not spriteMap then
		spriteMap = {}
		
		local textureName = cache.getTexturePathByID(texture)
		local cnt = (gui.spriteBatchesByTexture[textureName] or 0) + 1
		
		gui.spriteBatchesByTexture[textureName] = cnt
		spriteBatch = spriteBatchController:newSpriteBatch(textureName .. cnt, textureName, 4, "static", depth, false, true, false, true)
		self.sbCounter = self.sbCounter + 1
		spriteBatch._UID = self.sbCounter
		spriteMap[depth] = spriteBatch
		spriteBatch.parent = self
		self.spriteBatches[texture] = spriteMap
	else
		spriteBatch = spriteMap[depth]
		
		if not spriteBatch then
			local textureName = cache.getTexturePathByID(texture)
			local cnt = (gui.spriteBatchesByTexture[textureName] or 0) + 1
			
			gui.spriteBatchesByTexture[textureName] = cnt
			spriteBatch = spriteBatchController:newSpriteBatch(textureName .. cnt, textureName, 4, "static", depth, false, true, false, true)
			self.sbCounter = self.sbCounter + 1
			spriteBatch._UID = self.sbCounter
			spriteMap[depth] = spriteBatch
			spriteBatch.parent = self
		end
	end
	
	return spriteBatch
end

gui.nextSpriteColor = color(255, 255, 255, 255)

function gui:setNextSpriteColor(r, g, b, a)
	gui.nextSpriteColor:setColor(r, g, b, a)
end

function gui:dummyAllocateSprite()
end

function gui:setSpriteAlphaOverride(alpha)
	self.spriteAlphaOverride = alpha
end

function gui:applyScaler(size)
	return scaling[self.scaler](size)
end

function gui:allocateSprite(slotData, quad, x, y, rotation, sizeX, sizeY, centerOffsetX, centerOffsetY, depthOffset)
	local baseX, baseY = self:getPos(true)
	local allocatedSprites = self.allocatedSprites
	local struct = quadLoader:getQuadStructure(quad)
	local scaleX, scaleY = 1, 1
	local w, h = struct.w, struct.h
	
	if sizeX then
		scaleX = sizeX / w
	end
	
	if sizeY then
		scaleY = sizeY / h
	else
		local relation = sizeX / struct.w
		
		sizeY = h * relation
		scaleY = sizeY / h
	end
	
	if self._scaleHor then
		scaleX = scaling[self.scaler](scaleX)
	end
	
	if self._scaleVert then
		scaleY = scaling[self.scaler](scaleY)
	end
	
	local spriteBatch = self:getSpriteBatch(struct.textureID, depthOffset)
	local clr = gui.nextSpriteColor
	local r, g, b, a = clr.r, clr.g, clr.b, clr.a
	
	a = a * self.spriteAlphaOverride
	
	spriteBatch:setColor(r, g, b, a)
	
	local oldUsers = spriteBatch.USERS or 0
	local spriteMap = allocatedSprites[spriteBatch]
	
	if not spriteMap then
		spriteMap = {}
		allocatedSprites[spriteBatch] = spriteMap
		spriteBatch.USERS = (spriteBatch.USERS or 0) + 1
	end
	
	local uid = spriteBatch._UID
	local desiredSlot
	
	if not slotData then
		desiredSlot = spriteBatch:setSprite(nil, struct.quad, math.floor(x + baseX), math.floor(y + baseY), rotation, scaleX, scaleY, centerOffsetX, centerOffsetY)
		slotData = {
			desiredSlot,
			uid
		}
	else
		local id = slotData[2]
		local slot = slotData[1]
		
		if uid ~= id then
			local sData = self.spriteDataByUID[id]
			local prevTex = quadLoader:getQuadTextureID(sData:getQuad())
			
			if prevTex ~= struct.textureID then
				local sb = self:getSpriteBatch(prevTex, depthOffset):deallocateSlot(sData:getSlot())
				
				spriteMap[slot] = nil
				slot = nil
			end
		end
		
		desiredSlot = spriteBatch:setSprite(slot, struct.quad, math.floor(x + baseX), math.floor(y + baseY), rotation, scaleX, scaleY, centerOffsetX, centerOffsetY)
		slotData[1] = desiredSlot
		slotData[2] = uid
	end
	
	local clrMap = self.initialSpriteColors
	
	if not clrMap then
		clrMap = {}
		self.initialSpriteColors = clrMap
	end
	
	local clrSpriteMap = clrMap[spriteBatch]
	
	if not clrSpriteMap then
		clrSpriteMap = {}
		clrMap[spriteBatch] = clrSpriteMap
	end
	
	local iniClr = clrSpriteMap[desiredSlot]
	
	if not iniClr then
		clrSpriteMap[desiredSlot] = color(r, g, b, a)
	end
	
	local container = spriteMap[desiredSlot]
	
	if not container then
		container = spriteDataContainer.new(desiredSlot, quad, x, y, rotation, sizeX, sizeY, centerOffsetX, centerOffsetY, depthOffset)
		spriteMap[desiredSlot] = container
		self.spriteDataByUID[uid] = container
		
		container:setColor(clrSpriteMap[desiredSlot])
	else
		container:apply(desiredSlot, quad, x, y, rotation, sizeX, sizeY, centerOffsetX, centerOffsetY, depthOffset)
	end
	
	gui.nextSpriteColor:setColor(255, 255, 255, 255)
	
	if oldUsers == 0 then
		gui.queueElementSorting()
	end
	
	return slotData, spriteBatch, container
end

function gui:pureAllocateSprite(quad, depthOffset)
	local struct = quadLoader:getQuadStructure(quad)
	local spriteBatch = self:getSpriteBatch(struct.textureID, depthOffset)
	
	return {
		spriteBatch:allocateSlot(),
		spriteBatch._UID
	}
end

function gui:hideSprites()
	if self._killPanel then
		return 
	end
	
	if self.allocatedSprites then
		for spriteBatch, slotList in pairs(self.allocatedSprites) do
			for slot, spriteData in pairs(slotList) do
				spriteBatch:hideSprite(slot)
			end
		end
	end
	
	for key, child in ipairs(self.children) do
		child:hideSprites()
	end
end

function gui:getAllocatedSprites()
	return self.allocatedSprites
end

function gui:getInitialSpriteColors()
	return self.initialSpriteColors
end

function gui:createSpriteBatch(name, texture)
	self.individualSpriteBatches = self.individualSpriteBatches or {}
	
	local spriteBatch = spriteBatchController:newSpriteBatch(name, texture, 4, "static", 1, false, true, false, true)
	
	self.individualSpriteBatches[name] = spriteBatch
	
	return spriteBatch
end

function gui:getIndividualSpriteBatch(name)
	return self.individualSpriteBatches[name]
end

function gui:allocateIndividualSprite(batchName, desiredSlot, quad, x, y, rotation, scaleX, scaleY, centerOffsetX, centerOffsetY)
	return self.individualSpriteBatches[batchName]:setSprite(desiredSlot, quad, x + baseX, y + baseY, rotation, scaleX, scaleY, centerOffsetX, centerOffsetY)
end

function gui:drawSpriteBatch(name)
	love.graphics.draw(self.individualSpriteBatches[name], 0, 0)
end

function gui:setY(y)
	local p = self:getParent()
	
	if p then
		local x2, y2 = p:getPos()
		
		self.y = y2 + y
		self.localY = y
	else
		self.y = y
	end
	
	self:queueSpriteUpdate()
end

function gui:getAbsPos()
	return self.x, self.y
end

function gui:getTextSize(font, text)
	return font:getWidth(text)
end

function gui:getTextHeight(font, text)
	return font:getHeight(text)
end

function gui:getLargestTextSize(font, text, text2)
	local s = self:getTextSize(font, text)
	local s2 = self:getTextSize(font, text2)
	
	return s2 < s and s or s2
end

function gui:compareTextSize(font, text, size)
	local s = self:getTextSize(font, text)
	
	return size < s and s or size
end

function gui:getPos(rel)
	local p = self:getParent()
	
	if p then
		if rel then
			return self:getRelativePosition()
		end
		
		return self.localX, self.localY
	else
		return self.x, self.y
	end
end

function gui:getRelativePosition()
	if not self.parent then
		return self.x, self.y
	end
	
	local x, y = self.parent:getPos(true)
	
	return self.localX + x, self.localY + y
end

function gui:setCanInheritScalingState(state)
	self._inheritScalingState = state
end

function gui:setScalingState(hor, vert)
	if not self._inheritScalingState then
		return 
	end
	
	if hor ~= nil then
		self._scaleHor = hor
	end
	
	if vert ~= nil then
		self._scaleVert = vert
	end
end

function gui:getScalingState()
	return self._scaleHor, self._scaleVert
end

function gui:applyHorizontalScaling()
	if not self._scaleHor then
		return false
	end
	
	self.w = scaling[self.scaler](self.w)
	
	return true
end

function gui:applyVerticalScaling()
	if not self._scaleVert then
		return false
	end
	
	self.h = scaling[self.scaler](self.h)
	
	return true
end

function gui:setSize(w, h, skipScale)
	self.rawW = w or self.rawW
	self.rawH = h or self.rawH
	self.w = w or self.w or 50
	self.h = h or self.h or 50
	
	if not skipScale then
		self:applyHorizontalScaling()
		self:applyVerticalScaling()
	end
	
	self.w = math.round(self.w)
	self.rawW = math.round(self.rawW)
	self.h = math.round(self.h)
	self.rawH = math.round(self.rawH)
	
	self:performLayout()
	self:onSizeChanged()
	self:queueSpriteUpdate()
	
	if self.parent then
		self.parent:onChildSizeChanged(self)
	end
end

function gui:fitWithin(element, xPad, yPad)
	local w, h = element:getSize()
	local newX, newY = xPad, yPad
	local newW, newH
	
	if xPad then
		newW = w - xPad * 2
	end
	
	if yPad then
		newH = h - yPad * 2
	end
	
	self:setPos(newX, newY)
	self:setSize(newW, newH)
end

function gui:_updateSprites()
	self.requiresSpriteUpdate = false
	
	self:updateSprites()
	
	for key, child in ipairs(self.children) do
		if child:canDraw() then
			child:_updateSprites()
		end
	end
end

function gui:getRawWidth()
	return self.rawW
end

function gui:getRawHeight()
	return self.rawH
end

function gui:getRawSize()
	return self.rawW, self.rawH
end

function gui:queueSpriteUpdate()
	self.requiresSpriteUpdate = true
end

function gui:propagateSpriteUpdateQueueing()
	self:queueSpriteUpdate()
	
	for key, child in ipairs(self.children) do
		child:propagateSpriteUpdateQueueing()
	end
end

function gui:setWide(w, skipScale)
	self.rawW = w or self.rawW
	self.w = w or self.w
	
	if not skipScale then
		self:applyHorizontalScaling()
	end
	
	self.w = math.round(self.w)
	self.rawW = math.round(self.rawW)
	
	self:onSizeChanged()
	self:queueSpriteUpdate()
	
	if self.parent then
		self.parent:onChildSizeChanged(self)
	end
end

function gui:setTall(h, skipScale)
	self.rawH = h or self.rawH
	self.h = h or self.h
	
	if not skipScale then
		self:applyVerticalScaling()
	end
	
	self.h = math.round(self.h)
	self.rawH = math.round(self.rawH)
	
	self:onSizeChanged()
	self:queueSpriteUpdate()
	
	if self.parent then
		self.parent:onChildSizeChanged(self)
	end
end

function gui:onSizeChanged()
end

gui.setWidth = gui.setWide
gui.setHeight = gui.setTall

function gui:getSize()
	return self.w, self.h
end

function gui:getWide()
	return self.w
end

function gui:getTall()
	return self.h
end

function gui:getWidth()
	return self.w
end

function gui:getHeight()
	return self.h
end

function gui:setFont(font)
	self.font = font
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
end

function gui:getFont()
	return self.fontObject
end

function gui:getRelativePos(x, y)
	local ourX, ourY = self:getPos(true)
	
	return x - ourX, y - ourY
end

function gui:setScaler(scaler)
	self.scaler = scaler
end

function gui:getScaler()
	return self.scaler
end

function gui:updateScissorParent()
	self.scissorParent = nil
	
	if not self.scissor then
		if self.parent.scissorParent then
			self.scissorParent = self.parent.scissorParent
		elseif self.parent.scissor then
			self.scissorParent = self.parent
		end
	end
	
	for key, child in ipairs(self.children) do
		child:updateScissorParent(self)
	end
end

function gui:setParent(newparent)
	local oldparent = self.parent
	
	if oldparent == newparent then
		return 
	end
	
	if not oldparent then
		for k, v in ipairs(gui.globalParents) do
			if v == self then
				table.remove(gui.globalParents, k)
				
				break
			end
		end
	end
	
	if not newparent then
		oldparent:removeChild(self)
		table.insert(gui.globalParents, self)
	else
		newparent:addChild(self)
	end
	
	if oldparent then
		for k, v in ipairs(oldparent.children) do
			if v == self then
				table.remove(oldparent.children, k)
				
				break
			end
		end
	end
	
	self.parent = newparent
	
	self:setDepth(newparent:getDepth() + 5)
	self:updateScissorParent()
	gui.queueElementSorting()
	self:queueSpriteUpdate()
end

function gui:getParent()
	return self.parent
end

function gui:getChildren()
	return self.children
end

function gui:performLayout(w, h)
end

function gui:setVisible(vis)
	local wasVis = self.isVisible
	
	self.isVisible = vis
	
	if self.tiedVisibility then
		if not vis and wasVis then
			for key, element in ipairs(self.tiedVisibility) do
				element:hide()
			end
		elseif vis and not wasVis then
			for key, element in ipairs(self.tiedVisibility) do
				element:show()
			end
		end
	end
	
	gui.queueElementSorting()
	self:queueSpriteUpdate()
end

function gui:setCanClick(can)
	self.canClick = can
end

function gui:getCanClick()
	return self.canClick
end

function gui:setCanHover(can)
	self.canHover = can
end

function gui:getCanHover()
	return self.canHover
end

function gui:getVisible()
	return self.isVisible
end

function gui:isValid()
	return not self._killPanel
end

function gui:writeTo(key)
end

function gui:removeChild(element)
	if self._killPanel then
		return 
	end
	
	for key, otherElement in ipairs(self.children) do
		if otherElement == element then
			table.remove(self.children, key)
		end
	end
	
	self.childrenByKeys[element] = nil
end

function gui:addChild(element)
	if self.childrenByKeys[element] then
		return 
	end
	
	element.scaler = self:getScaler()
	
	if self._propagateScalingState then
		element:setScalingState(self:getScalingState())
	end
	
	table.insert(self.children, element)
	
	self.childrenByKeys[element] = true
end

function gui:onChildSizeChanged()
end

function gui:kill()
	if self._killPanel then
		return 
	end
	
	self.allocateSprite = self.dummyAllocateSprite
	self._killPanel = true
	
	for k, v in ipairs(gui.renderOrder) do
		if v == self then
			table.remove(gui.renderOrder, k)
			
			break
		end
	end
	
	if self.id then
		gui.elementsByID[self.id] = nil
	end
	
	self:killDescBox()
	
	if self:isSelected() then
		self:deselect()
	end
	
	if self.parent then
		self.parent:removeChild(self)
	end
	
	for k, v in ipairs(self.children) do
		v:kill()
		
		self.children[k] = nil
	end
	
	if self.tiedVisibility then
		for key, element in ipairs(self.tiedVisibility) do
			element:kill()
		end
	end
	
	for k, v in ipairs(gui.globalParents) do
		if v == self then
			table.remove(gui.globalParents, k)
			
			break
		end
	end
	
	for k, v in ipairs(gui.allCreatedElements) do
		if v == self then
			table.remove(gui.allCreatedElements, k)
			
			break
		end
	end
	
	self:hide()
	self:removeEventHandler()
	
	if self.onKill then
		self:onKill()
	end
	
	self:playKillSound()
	
	if self.textObjects then
		for key, obj in ipairs(self.textObjects) do
			obj:clear()
			
			self.textObjects[key] = nil
		end
	end
	
	self:clearSpritebatches()
	
	if self.individualSpriteBatches then
		for name, spriteBatch in pairs(self.individualSpriteBatches) do
			spriteBatch.parent = nil
			
			spriteBatchController:removeSpriteBatch(spriteBatch)
			
			self.individualSpriteBatches[name] = nil
		end
	end
	
	gui.queueElementSorting()
	
	self.isVisible = false
end

function gui:clearSpritebatches()
	if self.allocatedSprites then
		for spriteBatch, slotList in pairs(self.allocatedSprites) do
			self.initialSpriteColors[spriteBatch] = nil
			self.allocatedSprites[spriteBatch] = nil
			spriteBatch.USERS = spriteBatch.USERS - 1
			
			for slot, state in pairs(slotList) do
				spriteBatch:deallocateSlot(slot)
			end
		end
	end
end

function gui.removeSpriteBatch(spriteBatch)
	for key, element in ipairs(gui.renderOrder) do
		if element == spriteBatch then
			table.remove(gui.renderOrder, key)
			
			break
		end
	end
end

gui.remove = gui.kill

function gui:_onClick(x, y, key)
	if self:canSelect() then
		self:select()
	end
	
	self:playClickSound(self:onClick(x, y, key))
end

function gui:canSelect()
	return false
end

function gui:playKillSound()
end

function gui:playClickSound(onClickState)
end

function gui:onDeselect()
end

function gui:deselect()
	if gui.elementSelected then
		gui.elementSelected:onDeselect()
	end
	
	if gui.keyPressElement == self then
		gui.keyPressElement = nil
	end
	
	gui.elementSelected = nil
end

function gui:isHeldDown()
	return gui.elementHold == self
end

function gui:select()
	gui.elementSelected = self
	
	self:onSelected()
end

function gui:onSelected()
end

function gui:isSelected()
	return gui.elementSelected == self
end

function gui:isDisabled()
	return false
end

function gui:isOn()
	return false
end

function gui:onClick(x, y, key)
end

function gui:onClickDown(x, y, key)
end

function gui:onScroll(x, y, key)
	if self:getParent() then
		self:getParent():onScroll(x, y, key)
	end
end

function gui:onRelease(x, y, key)
end

function gui:getClass()
	return self.class
end

function gui:center()
	if self.parent then
		self:setPos((self.parent.w - self.w) * 0.5, (self.parent.h - self.h) * 0.5)
	else
		local x, y = love.graphics.getDimensions()
		
		self:setPos((x - self.w) * 0.5, (y - self.h) * 0.5)
	end
end

function gui:alignToRight(offset)
	if self.parent then
		local w, h = self.parent:getPos()
		
		self:setX(w - offset - self.w)
	else
		self:setX(scrW - offset - self.w)
	end
end

function gui:alignToBottom(offset)
	if self.parent then
		local w, h = self.parent:getSize()
		
		self:setY(h - offset - self.h)
	else
		self:setY(scrH - offset - self.h)
	end
end

function gui:centerX()
	if self.parent then
		self:setPos((self.parent.w - self.w) * 0.5)
	else
		local x, y = love.graphics.getDimensions()
		
		self:setPos((x - self.w) * 0.5)
	end
end

function gui:centerY()
	if self.parent then
		self:setPos(nil, (self.parent.h - self.h) * 0.5)
	else
		local x, y = love.graphics.getDimensions()
		
		self:setPos(nil, (y - self.h) * 0.5)
	end
end

function gui:localToPanel(x, y)
	x = math.clamp(x - self.x, 0, self.w)
	y = math.clamp(y - self.y, 0, self.h)
	
	return x, y
end

function gui:isMouseOver()
	if self == gui.elementHovered then
		return true
	else
		return false
	end
end

function gui:isMouseOverChildren()
	for key, child in ipairs(self.children) do
		if child == gui.elementHovered then
			return true
		end
	end
	
	return false
end

function gui:think()
end

function gui:draw()
end

function gui:init()
end

function gui:onLeftClick()
end

function gui:onRightClick()
end

function gui:setPanelFillColor(r, g, b, a)
	self.skinPanelFillColorN = self.skinPanelFillColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinPanelFillColorN.r = r.r
		self.skinPanelFillColorN.g = r.g
		self.skinPanelFillColorN.b = r.b
		self.skinPanelFillColorN.a = r.a
	else
		self.skinPanelFillColorN.r = r
		self.skinPanelFillColorN.g = g
		self.skinPanelFillColorN.b = b
		self.skinPanelFillColorN.a = a
	end
end

function gui:getPanelFillColor()
	return self.skinPanelFillColorN or self.skinPanelFillColor
end

function gui:setPanelOutlineColor(r, g, b, a)
	self.skinPanelOutlineColorN = self.skinPanelOutlineColorN or color(0, 0, 0, 0)
	
	if type(r) ~= "number" then
		self.skinPanelOutlineColorN = r
	else
		self.skinPanelOutlineColorN.r = r
		self.skinPanelOutlineColorN.g = g
		self.skinPanelOutlineColorN.b = b
		self.skinPanelOutlineColorN.a = a
	end
end

function gui:getPanelOutlineColor()
	return self.skinPanelOutlineColorN or self.skinPanelOutlineColor
end

function gui:setPanelHoverColor(r, g, b, a)
	self.skinPanelHoverColorN = self.skinPanelHoverColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinPanelHoverColorN.r = r.r
		self.skinPanelHoverColorN.g = r.g
		self.skinPanelHoverColorN.b = r.b
		self.skinPanelHoverColorN.a = r.a
	else
		self.skinPanelHoverColorN.r = r
		self.skinPanelHoverColorN.g = g
		self.skinPanelHoverColorN.b = b
		self.skinPanelHoverColorN.a = a
	end
end

function gui:getPanelHoverColor()
	return self.skinPanelHoverColorN or self.skinPanelHoverColor
end

function gui:setPanelSelectColor(r, g, b, a)
	self.skinPanelSelectColorN = self.skinPanelSelectColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinPanelSelectColorN.r = r.r
		self.skinPanelSelectColorN.g = r.g
		self.skinPanelSelectColorN.b = r.b
		self.skinPanelSelectColorN.a = r.a
	else
		self.skinPanelSelectColorN.r = r
		self.skinPanelSelectColorN.g = g
		self.skinPanelSelectColorN.b = b
		self.skinPanelSelectColorN.a = a
	end
end

function gui:getPanelSelectColor()
	return self.skinPanelSelectColorN or self.skinPanelSelectColor
end

function gui:setPanelDisableColor(r, g, b, a)
	self.skinPanelDisableColorN = self.skinPanelDisableColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinPanelDisableColorN.r = r.r
		self.skinPanelDisableColorN.g = r.g
		self.skinPanelDisableColorN.b = r.b
		self.skinPanelDisableColorN.a = r.a
	else
		self.skinPanelDisableColorN.r = r
		self.skinPanelDisableColorN.g = g
		self.skinPanelDisableColorN.b = b
		self.skinPanelDisableColorN.a = a
	end
end

function gui:getPanelDisableColor()
	return self.skinPanelDisableColorN or self.skinPanelDisableColor
end

function gui:setTextFillColor(r, g, b, a)
	self.skinTextFillColorN = self.skinTextFillColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinTextFillColorN.r = r.r
		self.skinTextFillColorN.g = r.g
		self.skinTextFillColorN.b = r.b
		self.skinTextFillColorN.a = r.a
	else
		self.skinTextFillColorN.r = r
		self.skinTextFillColorN.g = g
		self.skinTextFillColorN.b = b
		self.skinTextFillColorN.a = a
	end
end

function gui:getTextFillColor()
	return self.skinTextFillColorN or self.skinTextFillColor
end

function gui:setTextHoverColor(r, g, b, a)
	self.skinTextHoverColorN = self.skinTextHoverColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinTextHoverColorN.r = r.r
		self.skinTextHoverColorN.g = r.g
		self.skinTextHoverColorN.b = r.b
		self.skinTextHoverColorN.a = r.a
	else
		self.skinTextHoverColorN.r = r
		self.skinTextHoverColorN.g = g
		self.skinTextHoverColorN.b = b
		self.skinTextHoverColorN.a = a
	end
end

function gui:getTextHoverColor()
	return self.skinTextHoverColorN or self.skinTextHoverColor
end

function gui:setTextSelectColor(r, g, b, a)
	self.skinTextSelectColorN = self.skinTextSelectColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinTextSelectColorN.r = r.r
		self.skinTextSelectColorN.g = r.g
		self.skinTextSelectColorN.b = r.b
		self.skinTextSelectColorN.a = r.a
	else
		self.skinTextSelectColorN.r = r
		self.skinTextSelectColorN.g = g
		self.skinTextSelectColorN.b = b
		self.skinTextSelectColorN.a = a
	end
end

function gui:getTextSelectColor()
	return self.skinTextSelectColorN or self.skinTextSelectColor
end

function gui:setTextDisableColor(r, g, b, a)
	self.skinTextDisableColorN = self.skinTextDisableColorN or color(255, 255, 255, 255)
	
	if type(r) ~= "number" then
		self.skinTextDisableColorN.r = r.r
		self.skinTextDisableColorN.g = r.g
		self.skinTextDisableColorN.b = r.b
		self.skinTextDisableColorN.a = r.a
	else
		self.skinTextDisableColorN.r = r
		self.skinTextDisableColorN.g = g
		self.skinTextDisableColorN.b = b
		self.skinTextDisableColorN.a = a
	end
end

function gui:positionToMouse(xOff, yOff)
	xOff = xOff or 0
	yOff = yOff or 0
	
	self:setPos(love.mouse.getX() + xOff, love.mouse.getY() + yOff)
end

function gui:getTextDisableColor()
	return self.skinTextDisableColorN or self.skinTextDisableColor
end

function gui:getStateColor()
	if self:isDisabled() then
		return self:getPanelDisableColor(), self:getTextDisableColor()
	elseif self:isOn() then
		return self:getPanelSelectColor(), self:getTextSelectColor()
	elseif self:isMouseOver() then
		return self:getPanelHoverColor(), self:getTextHoverColor()
	else
		return self:getPanelFillColor(), self:getTextFillColor()
	end
end

require("engine/gui/panel")
require("engine/gui/frame")
require("engine/gui/combobox")
require("engine/gui/combobox_option")
require("engine/gui/graphics_settings_base")
require("engine/gui/scrollbar")
require("engine/gui/scrollbar_up")
require("engine/gui/scrollbar_down")
require("engine/gui/scrollbar_grip")
require("engine/gui/scrollbar_canvas")
require("engine/gui/button")
require("engine/gui/dummypanel")
require("engine/gui/generictextbox")
require("engine/gui/generictextdisplay")
require("engine/gui/label")
require("engine/gui/propertysheet")
require("engine/gui/propertysheet_tab_button")
require("engine/gui/slider")
require("engine/gui/textbox")
require("engine/gui/close_button")
require("engine/gui/generic_popup")
require("engine/gui/checkbox")
require("engine/gui/category_title")
require("engine/gui/timed_text_display")
require("engine/gui/page_controller")
require("engine/gui/generic_image")
