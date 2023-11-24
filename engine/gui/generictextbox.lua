local genericDescbox = {}

genericDescbox.font = fonts.pix14
genericDescbox.text = "sample text"
genericDescbox.addSpacingW = 10
genericDescbox.addSpacingH = 4
genericDescbox.halfSpacingW = genericDescbox.addSpacingW * 0.5
genericDescbox.halfSpacingH = genericDescbox.addSpacingH * 0.5
genericDescbox.startingHeight = genericDescbox.halfSpacingH
genericDescbox.allText = nil
genericDescbox.white = color(255, 255, 255, 255)
genericDescbox.verticalSpacing = 0
genericDescbox.alignedToRight = false
genericDescbox.alignedToBottom = false
genericDescbox.autoAlign = false
genericDescbox.canHover = false
genericDescbox.showRectSprites = true
genericDescbox.shouldLimitToScreenspace = true
genericDescbox.fadeInSpeed = 7
genericDescbox.scaleIcons = true
genericDescbox._scaleHor = false
genericDescbox._scaleVert = false
genericDescbox._scaleIcons = true
genericDescbox._inheritScalingState = false
genericDescbox.backgroundColor = color(0, 0, 0, 230)
genericDescbox.defaultShadowColor = color(0, 0, 0, 255)

function genericDescbox:init()
	self.allText = {}
	self.allocatedTextSpritebatches = {}
	self.textLines = {}
	self.textLineSprites = {}
	self.textByFont = {}
	self.drawText = {}
	self.drawTextMap = {}
	self.alpha = 0
	self.totalWidth = 0
	self.totalHeight = self.startingHeight
	
	self:bringUp()
end

function genericDescbox:setFadeInSpeed(speed)
	self.fadeInSpeed = speed
	
	if self.fadeInSpeed > 0 then
		self.alpha = 0
	else
		self.alpha = 1
	end
end

function genericDescbox:setAppearDelay(delay)
	self.appearDelay = delay
end

function genericDescbox:setFont(font)
	self.font = font
end

function genericDescbox:setData(data)
	self.statusData = data
end

function genericDescbox:setShowRectSprites(show)
	self.showRectSprites = show
end

function genericDescbox:setAlignToRight(alignment)
	self.alignedToRight = alignment
end

function genericDescbox:setAlignToBottom(alignment)
	self.alignedToBottom = alignment
end

function genericDescbox:setBackgroundColor(clr)
	self.backgroundColor = clr
end

function genericDescbox:setAutoAlign(alignment)
	self.autoAlign = alignment
end

function genericDescbox:onKill()
end

function genericDescbox:removeAllText()
	table.clearArray(self.allText)
	table.clearArray(self.textLines)
	
	for key, data in ipairs(self.textLineSprites) do
		data.sb:deallocateSlot(data.id[1], 0, 0, 0, 0, 0)
		
		self.textLineSprites[key] = nil
	end
	
	for spriteBatch, list in pairs(self.allocatedTextSpritebatches) do
		for key, slotData in ipairs(list) do
			spriteBatch:deallocateSlot(slotData[1])
		end
		
		self.allocatedTextSpritebatches[spriteBatch] = nil
	end
	
	self:clearTextObjects()
	
	self.totalHeight = self.startingHeight
	self.totalWidth = 0
end

function genericDescbox:clearTextObjects()
	for key, obj in ipairs(self.drawText) do
		obj:clear()
		
		self.drawText[key] = nil
		self.drawTextMap[obj] = nil
	end
end

function genericDescbox:setupText()
	self:clearTextObjects()
	
	for key, data in ipairs(self.allText) do
		self:addDrawText(data)
	end
end

genericDescbox.clearAllText = genericDescbox.removeAllText

function genericDescbox:setText(text, font, position, lineSpace, textColor)
	position = position or 1
	lineSpace = _S(lineSpace or 0)
	font = font or self.font
	
	local currentEntry = self.allText[position]
	
	self:updateTextTable(text, font, 1, lineSpace, textColor)
	self:setHeight(self.totalHeight + _S(self.addSpacingH))
end

function genericDescbox:limitToScreenspace()
	if not self.shouldLimitToScreenspace then
		return 
	end
	
	if self.y + self.h > scrH then
		self:alignToBottom(0)
	elseif self.y < 0 then
		self.y = 0
	end
	
	if self.x + self.w > scrW then
		self:alignToRight(0)
	elseif self.x < 0 then
		self.x = 0
	end
end

function genericDescbox:getTextObject(font)
	local obj = self.textByFont[font]
	
	if obj then
		return obj
	end
	
	obj = self:createTextObject(font, nil)
	self.textByFont[font] = obj
	
	return obj
end

function genericDescbox:addText(text, font, textColor, lineSpace, maxWidth, icon, iconWidth, iconHeight, shadowColor, position)
	if type(text) == "number" then
		text = tostring(text)
	end
	
	if icon and #self.allText == 0 then
		self.totalHeight = self.totalHeight + _S(2)
	end
	
	local scaleIcons = self._scaleIcons
	
	if iconWidth and not iconHeight then
		local quadData = quadLoader:getQuadStructure(icon)
		local relation = iconWidth / quadData.w
		
		iconHeight = quadData.h * relation
	end
	
	if iconWidth and scaleIcons then
		iconWidth = _S(iconWidth)
	end
	
	if iconHeight and scaleIcons then
		iconHeight = _S(iconHeight)
	end
	
	maxWidth = maxWidth and math.min(love.graphics.getWidth(), _S(maxWidth)) or love.graphics.getWidth()
	lineSpace = lineSpace and _S(lineSpace) or 0
	
	if type(icon) == "table" then
		iconWidth = iconWidth or 0
		iconHeight = iconHeight or 0
		
		for key, iconData in ipairs(icon) do
			if scaleIcons then
				iconData.width = _S(iconData.width)
			end
			
			if iconData.height then
				if scaleIcons then
					iconData.height = _S(iconData.height)
				end
			else
				local structure = quadLoader:getQuadStructure(iconData.icon)
				
				iconData.height = structure.h * structure.quad:getScaleToSize(iconData.width)
			end
			
			iconData.x = iconData.x and (scaleIcons and _S(iconData.x) or 0) or 0
			iconData.y = iconData.y and (scaleIcons and _S(iconData.y) or 0) or 0
			iconWidth = math.max(iconWidth, iconData.width + iconData.x)
			iconHeight = math.max(iconHeight, iconData.height + iconData.y)
		end
	end
	
	local scaledSpacing = _S(self.halfSpacingW)
	local wrapWidth = maxWidth - scaledSpacing * 2
	
	if iconWidth then
		wrapWidth = wrapWidth - scaledSpacing - iconWidth
	end
	
	local fontObject = fonts.get(font)
	
	if iconHeight then
		local dist = iconHeight - fontObject:getHeight() * string.countlines(text) - self.totalHeight
		
		if dist > 0 then
			self.totalHeight = self.totalHeight + dist
		end
	end
	
	text = string.wrap(text, fontObject, wrapWidth)
	
	if position then
		self.allText[position] = self:createTextTable(text, fontObject, lineSpace, textColor, icon, iconWidth, iconHeight, shadowColor)
		
		self:setupText()
	else
		table.inserti(self.allText, self:createTextTable(text, fontObject, lineSpace, textColor, icon, iconWidth, iconHeight, shadowColor))
	end
	
	self:setHeight(self.totalHeight + _S(self.halfSpacingH))
	self:limitToScreenspace()
	
	return self.allText[#self.allText], #self.allText
end

function genericDescbox:setPos(...)
	genericDescbox.baseClass.setPos(self, ...)
	self:limitToScreenspace()
end

function genericDescbox:updateMaxWidth(desiredWidth)
	self.totalWidth = math.max(self.totalWidth, desiredWidth)
	
	self:setWidth(self.totalWidth + _S(self.halfSpacingW))
end

function genericDescbox:queueResize()
	self.resizeQueued = true
end

function genericDescbox:resize()
	local highestW, totalH = 0, self.addSpacingH
	
	for key, data in ipairs(self.allText) do
		highestW = math.max(highestW, data.font:getWidth(data.text))
		totalH = totalH + data.font:getTextHeight(data.text) + data.lineSpace
	end
	
	self.totalWidth = highestW + _S(self.addSpacingW)
	self.totalHeight = totalH
	
	self:setSize(self.totalWidth, totalH)
	
	self.resizeQueued = false
end

function genericDescbox:centerToElement(element)
	genericDescbox.baseClass.centerToElement(self, element)
	
	self.centerElement = element
end

function genericDescbox:removeText(textObj)
	local entries = self.allText
	local state, index = table.removeObject(entries, textObj)
	local lineHeight = textObj.lineHeight
	local ourIdx = textObj.textLineIdx
	
	self.totalHeight = self.totalHeight - lineHeight
	
	if #entries > 0 then
		local tLines = self.textLines
		
		for i = index, #entries do
			local entry = entries[i]
			
			entry.y = entry.y - lineHeight
			
			local thisLine = entry.textLineIdx
			
			if thisLine then
				local textLine = tLines[thisLine]
				
				textLine.y = textLine.y - lineHeight
				
				if ourIdx and ourIdx < thisLine then
					entry.textLineIdx = thisLine - 1
				end
			end
		end
		
		if ourIdx then
			self.textLineSprites[ourIdx].sb:deallocateSlot(self.textLineSprites[ourIdx].id)
			table.remove(self.textLineSprites, ourIdx)
			table.remove(tLines, ourIdx)
		end
	end
	
	self:setHeight(self.totalHeight + _S(self.halfSpacingH))
	self:limitToScreenspace()
	self:setupText()
end

function genericDescbox:updateTextTable(text, font, position, textColor, lineSpace, maxWidth, icon, iconWidth, iconHeight)
	if not self.allText[position] then
		self:addText(text, font, textColor, lineSpace, maxWidth, icon, iconWidth, iconHeight, nil, position)
		self:queueSpriteUpdate()
	else
		local scaleIcons = self._scaleIcons
		
		if scaleIcons then
			iconWidth = iconWidth and _S(iconWidth)
			iconHeight = iconHeight and _S(iconHeight)
		end
		
		local target = self.allText[position]
		
		target.text = text or target.text
		target.icon = icon or target.icon
		target.iconWidth = iconWidth or target.iconWidth
		target.iconHeight = iconHeight or target.iconHeight
		target.textWidth = target.font:getWidth(text)
		
		self:updateMaxWidth((maxWidth or target.textWidth) + target.x)
		self:queueSpriteUpdate()
		
		local lineIdx = target.textLineIdx
		local textLineWidth = self.textLineWidth
		
		if textLineWidth then
			local textY = target.y
			local lineHeight = target.font:getHeight()
			
			if self.textLineHeight then
				local realHeight = self.textLineHeight
				
				if realHeight < 0 then
					realHeight = lineHeight * string.countlines(target.text) - realHeight
				end
				
				textY = textY - math.floor((realHeight - fontHeight) * 0.5)
				lineHeight = realHeight
			else
				lineHeight = lineHeight * string.countlines(target.text)
			end
			
			if textLineWidth == -1 then
				textLineWidth = target.textWidth + _S(self.halfSpacingW + 3)
				
				if target.iconWidth then
					textLineWidth = textLineWidth + iconWidth
				end
			end
			
			if lineIdx then
				local lineData = self.textLines[lineIdx]
				
				lineData.y = textY
				lineData.width = textLineWidth
				lineData.height = lineHeight
				lineData.color = self.textLineColor
				lineData.texture = self.textLineTexture
			else
				table.insert(self.textLines, {
					x = _S(self.halfSpacingW),
					y = textY,
					width = self.textLineWidth,
					height = lineHeight,
					color = self.textLineColor,
					texture = self.textLineTexture
				})
				
				target.textLineIdx = #self.textLines
			end
			
			self.textLineColor = nil
			self.textLineWidth = nil
			self.textLineHeight = nil
			self.textLineTexture = nil
		end
		
		target.color = textColor or target.color
	end
	
	self:setupText()
end

function genericDescbox:positionToMouse(xOff, yOff)
	genericDescbox.baseClass.positionToMouse(self, xOff, yOff)
	
	self.positioningToMouse = true
	self.mouseOffX = xOff or 0
	self.mouseOffY = yOff or 0
end

function genericDescbox:positionToElement(element, xOff, yOff)
	self.positionElement = element
	self.posOffX = xOff
	self.posOffY = yOff
end

function genericDescbox:_positionToElement()
	local x, y = self.positionElement:getPos(true)
	
	self:setPos(x + self.posOffX, y + self.posOffY)
end

function genericDescbox:doTimedAppear()
	if self.appearDelay then
		self.appearDelay = self.appearDelay - frameTime
		
		if self.appearDelay <= 0 then
			self:setPos(love.mouse.getX() + _S(5), love.mouse.getY() + _S(5))
			
			self.appearDelay = nil
			
			gui.queueElementSorting()
			self:queueSpriteUpdate()
		end
	else
		self:adjustAlpha()
	end
end

function genericDescbox:think()
	self:doTimedAppear()
	
	if self.centerElement then
		self:centerToElement(self.centerElement)
	elseif self.positionElement then
		self:_positionToElement()
	elseif self.positioningToMouse then
		self:setPos(love.mouse.getX() + self.mouseOffX, love.mouse.getY() + self.mouseOffY)
	end
end

function genericDescbox:adjustAlpha()
	if self.alpha ~= 1 then
		self.alpha = math.approach(self.alpha, 1, self.fadeInSpeed * frameTime)
		
		self:queueSpriteUpdate()
	end
end

function genericDescbox:addTextLine(width, lineColor, height, texture)
	self.textLineWidth = width
	self.textLineColor = lineColor
	self.textLineHeight = height
	self.textLineTexture = texture or "generic_1px"
end

function genericDescbox:createTextTable(text, font, lineSpace, textColor, icon, iconWidth, iconHeight, shadowColor)
	if type(font) == "string" then
		font = fonts.get(font)
	end
	
	local desiredColor
	
	lineSpace = lineSpace or 0
	desiredColor = textColor or genericDescbox.white
	
	local fontHeight = font:getHeight()
	local lineCount = string.countlines(text)
	local textHeight = fontHeight * string.countlines(text)
	local scaledSpacing = _S(self.halfSpacingW)
	local x = scaledSpacing
	
	if iconWidth then
		x = x + scaledSpacing + iconWidth
	end
	
	local extraHeight = 0
	
	if iconHeight and fontHeight < iconHeight then
		extraHeight = math.dist(fontHeight, iconHeight)
	end
	
	local textWidth = font:getWidth(text)
	local widestIcon, highestIcon = 0, 0
	
	if icon then
		if type(icon) == "table" then
			for key, data in ipairs(icon) do
				widestIcon = math.max(widestIcon, data.width)
				highestIcon = math.max(highestIcon, data.height)
			end
		else
			widestIcon = iconWidth
			highestIcon = iconHeight
		end
	end
	
	local textLineIdx
	local textLineWidth = self.textLineWidth
	
	if self.textLineWidth then
		local textY = self.totalHeight
		local lineHeight = fontHeight
		
		if self.textLineHeight then
			local realHeight = self.textLineHeight
			
			if realHeight < 0 then
				realHeight = lineHeight * string.countlines(text) - realHeight
			end
			
			textY = textY - math.floor((realHeight - fontHeight) * 0.5)
			lineHeight = realHeight
		else
			lineHeight = lineHeight * string.countlines(text)
		end
		
		local textW
		
		if textLineWidth == -1 then
			textW = textWidth + scaledSpacing + _S(3)
			
			if iconWidth then
				textW = textW + iconWidth
			end
		else
			textW = textLineWidth
		end
		
		table.insert(self.textLines, {
			x = scaledSpacing,
			y = textY,
			width = textW,
			height = lineHeight,
			color = self.textLineColor,
			texture = self.textLineTexture
		})
		
		self.textLineColor = nil
		self.textLineWidth = nil
		self.textLineHeight = nil
		self.textLineTexture = nil
		textLineIdx = #self.textLines
	end
	
	local lineHeight = lineSpace + _S(self.verticalSpacing) + textHeight + extraHeight
	local struct = {
		iconX = 0,
		iconY = 0,
		text = text,
		font = font,
		color = desiredColor,
		shadowColor = shadowColor or self.defaultShadowColor,
		lineSpace = lineSpace,
		lineHeight = lineHeight,
		x = x,
		y = self.totalHeight,
		icon = icon,
		iconWidth = iconWidth,
		iconHeight = iconHeight,
		textHeight = textHeight,
		textWidth = textWidth,
		widestIcon = widestIcon,
		highestIcon = highestIcon,
		textLineIdx = textLineIdx
	}
	
	self:addDrawText(struct)
	self:updateMaxWidth(textWidth + struct.x)
	
	self.totalHeight = self.totalHeight + lineHeight
	
	self:queueSpriteUpdate()
	
	return struct
end

function genericDescbox:addDrawText(struct)
	local obj = self:getTextObject(struct.font)
	
	obj:setNextTextColor(struct.shadowColor:unpack())
	
	local x = struct.x
	
	if self.alignedToRight then
		x = -(struct.textWidth + x)
	end
	
	obj:addShadowed(struct.text, struct.color, x, struct.y)
	
	if not self.drawTextMap[obj] then
		table.insert(self.drawText, obj)
		
		self.drawTextMap[obj] = true
	end
end

function genericDescbox:getTextEntries()
	return self.allText
end

function genericDescbox:addSpaceToNextText(amount)
	amount = _S(amount)
	self.totalHeight = self.totalHeight + amount
	self.h = self.totalHeight
end

function genericDescbox:getTotalHeight()
	return self.totalHeight
end

function genericDescbox:drawBackground()
	local backgroundColor = self.backgroundColor
	
	self:setNextSpriteColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a * self.alpha)
	
	self.rectSprites = self:allocateRoundedRectangle(self.rectSprites, 0, 0, self.w, self.h, 6, -0.9)
end

function genericDescbox:updateSprites()
	if self.appearDelay then
		return 
	end
	
	if self.showRectSprites then
		self:drawBackground()
	end
	
	local scaledSpacing = _S(self.halfSpacingW)
	local scaledHalfSpacing = _S(self.halfSpacingH) * 0.5
	
	if self.alignedToRight then
		drawX = self.w
	else
		drawX = 0
	end
	
	for key, lineData in ipairs(self.textLines) do
		local r, g, b, a = lineData.color:unpack()
		
		self:setNextSpriteColor(r, g, b, a * self.alpha)
		
		local spriteID
		
		if not self.textLineSprites[key] then
			self.textLineSprites[key] = {}
		else
			spriteID = self.textLineSprites[key].id
		end
		
		local slot, sb = self:allocateSprite(spriteID, lineData.texture, lineData.x, lineData.y, 0, lineData.width, lineData.height, 0, 0, -0.85)
		local struct = self.textLineSprites[key]
		
		struct.id = slot
		struct.sb = sb
	end
	
	for key, data in ipairs(self.allText) do
		if data.icon then
			if type(data.icon) == "table" then
				for key, iconData in ipairs(data.icon) do
					local curDrawX = drawX
					local offsetX = iconData.x or 0
					local offsetX, offsetY = offsetX, iconData.y or 0
					
					if self.alignedToRight then
						curDrawX = curDrawX + offsetX - scaledSpacing - data.widestIcon
					else
						curDrawX = scaledSpacing + offsetX
					end
					
					if iconData.color then
						local r, g, b, a = iconData.color:unpack()
						
						self:setNextSpriteColor(r, g, b, a * self.alpha)
					else
						self:setNextSpriteColor(255, 255, 255, 255 * self.alpha)
					end
					
					local depthOff = key * 0.1 - 0.1
					local spriteID, spritebatch = self:allocateSprite(iconData.spriteID, iconData.icon, curDrawX, data.y + data.textHeight * 0.5 - iconData.height * 0.5 + offsetY, iconData.rotation, iconData.width, iconData.height, iconData.xOffset, iconData.yOffset, -0.8 + depthOff)
					
					self.allocatedTextSpritebatches[spritebatch] = self.allocatedTextSpritebatches[spritebatch] or {}
					
					table.insert(self.allocatedTextSpritebatches[spritebatch], spriteID)
					
					iconData.spriteID = spriteID
				end
			else
				local curDrawX = drawX
				
				if self.alignedToRight then
					curDrawX = curDrawX - scaledSpacing - data.widestIcon
				else
					curDrawX = scaledSpacing
				end
				
				self:setNextSpriteColor(255, 255, 255, 255 * self.alpha)
				
				local spriteID, spritebatch = self:allocateSprite(data.spriteID, data.icon, curDrawX + data.iconX, data.y + data.textHeight * 0.5 - data.iconHeight * 0.5 + data.iconY, data.iconRotation, data.iconWidth, data.iconHeight, data.iconXOffset, data.iconYOffset, -0.8)
				
				self.allocatedTextSpritebatches[spritebatch] = self.allocatedTextSpritebatches[spritebatch] or {}
				
				table.insert(self.allocatedTextSpritebatches[spritebatch], spriteID)
				
				data.spriteID = spriteID
			end
		end
	end
end

function genericDescbox:draw(w, h)
	if self.appearDelay then
		return 
	end
	
	if self.statusData and self.statusData.stringFormUI then
		self:setText(self.statusData:stringFormUI())
	end
	
	if self.resizeQueued then
		self:resize()
	end
	
	w, h = self.w, self.h
	
	local drawX, drawY = 0, 0
	
	if self.autoAlign then
		local x, y = self:getPos(true)
		
		if x + w > scrW then
			drawX = -w
		end
		
		if y + h > scrH then
			drawY = -h
		end
	else
		if self.alignedToRight then
			drawX = w
		end
		
		if self.alignedToBottom then
			drawY = -h
		end
	end
	
	local backgroundColor = self.backgroundColor
	
	love.graphics.setColor(255, 255, 255, 255 * self.alpha)
	
	local curHeight = 0
	
	for key, textObj in ipairs(self.drawText) do
		love.graphics.draw(textObj, drawX, drawY)
	end
end

gui.register("GenericDescbox", genericDescbox)
