local TAB = {}

TAB.skinPanelFillColor = color(50, 50, 50, 255)
TAB.skinPanelHoverColor = color(175, 160, 75, 255)
TAB.skinPanelSelectColor = color(125, 175, 125, 255)
TAB.skinPanelDisableColor = color(20, 20, 20, 255)
TAB.skinTextFillColor = color(220, 220, 220, 255)
TAB.skinTextHoverColor = color(240, 240, 240, 255)
TAB.skinTextSelectColor = color(255, 255, 255, 255)
TAB.skinTextDisableColor = color(60, 60, 60, 255)
TAB.white = color(255, 255, 255, 255)
TAB.gradientFinishColor = color(255, 255, 255, 255)

function TAB:init()
	self.text = ""
	self.font = fonts.pix28
	self.textWidth = 0
	self.textHeight = 0
	self.active = false
end

function TAB:isActive()
	return self.active
end

function TAB:isOn()
	return self.active
end

function TAB:onKill()
	self:killDescBox()
end

function TAB:setItemPosition(pos)
	self.itemPosition = pos
end

function TAB:addHoverText(text, font, lineSpacing, color, maxWidth, icon, iconW, iconH)
	if not self.hoverText then
		self.hoverText = {}
	end
	
	lineSpacing = lineSpacing or 0
	color = color or self.white
	
	table.insert(self.hoverText, {
		font = font,
		text = text,
		lineSpacing = lineSpacing,
		color = color,
		maxWidth = maxWidth,
		icon = icon,
		iconW = iconW,
		iconH = iconH
	})
end

function TAB:onMouseEntered()
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.hoverText) do
			self.descBox:addText(data.text, data.font, data.color, data.lineSpacing, data.maxWidth or 600, data.icon, data.iconW, data.iconH)
		end
		
		self:positionDescBox()
	end
end

function TAB:setCenterDescBox(should)
	self.centerDescBox = should
end

function TAB:positionDescBox()
	if self.centerDescBox then
		self.descBox:centerToElement(self)
		
		return 
	end
	
	local sheetItems = self.parent:getItems()
	local isLeftSide = self.itemPosition <= #sheetItems * 0.5
	local middle = math.isMiddleOf(self.itemPosition, #sheetItems)
	local x, y = self:getPos(true)
	local w, h = self.w, self.h
	local boxX, boxY = nil, y + h + 5
	local boxW, boxH = self.descBox:getSize()
	
	if middle then
		boxX = x + w * 0.5 - boxW * 0.5
	elseif isLeftSide then
		boxX = x
	else
		boxX = x + w - boxW
	end
	
	self.descBox:setPos(boxX, boxY)
end

function TAB:onKill()
	self:killDescBox()
end

function TAB:onHide()
	self:killDescBox()
end

function TAB:draw(w, h)
	local parent = self:getParent()
	
	if not parent then
		return 
	end
	
	local ocol = parent:getPanelOutlineColor()
	
	love.graphics.setColor(ocol.r, ocol.g, ocol.b, ocol.a)
	love.graphics.rectangle("fill", 0, 0, w, h)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	love.graphics.rectangle("fill", 2, 2, w - 4, h - 4)
	
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, (w - self.textWidth) * 0.5, (h - self.textHeight) / 2, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

function TAB:setCallback(callback)
	self.callback = callback
end

function TAB:getCallback()
	return self.callback
end

function TAB:open()
end

function TAB:setCanvas(canvas)
	self.canvas = canvas
end

function TAB:getCanvas()
	return self.canvas
end

function TAB:setOnSwitchEvent(event)
	self.onSwitchEvent = event
end

function TAB:getItemList()
	return self:getParent().items
end

function TAB:switchTo()
	if self.active then
		return 
	end
	
	for k, v in pairs(self:getItemList()) do
		if v[1] == self then
			v[1].active = true
			v[2].activeTabCanvas = true
			
			v[2]:show()
			
			if v[2].onActive then
				v[2]:onActive()
			end
		else
			local wasActive = v[1].active
			
			v[1].active = false
			v[2].activeTabCanvas = false
			
			v[2]:hide()
			
			if wasActive then
				v[1]:queueSpriteUpdate()
			end
		end
	end
	
	self:queueSpriteUpdate()
	
	if self.callback then
		self:callback()
	end
	
	if self.onSwitchEvent then
		events:fire(self.onSwitchEvent, self)
	end
end

function TAB:onClick()
	self:switchTo()
end

gui.register("PropertySheetTabButton", TAB, "Button")
