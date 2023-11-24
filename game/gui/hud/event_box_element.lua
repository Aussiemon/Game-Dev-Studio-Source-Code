local element = {}

element.textColor = color(255, 255, 255, 255)
element.textShadowColor = color(0, 0, 0, 255)

function element:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or element.textColor
	self.textShadowColor = textShadowColor or element.textShadowColor
	self.alpha = 1
end

function element:setEventBox(eb)
	self.eventBox = eb
end

function element:setFont(font)
	self.font = font
	self.fontObject = fonts.get(font)
	self.fontHeight = self.fontObject:getHeight()
	
	if self.textObject and self.textObject:getFont() ~= self.fontObject then
		self.textObject:setFont(self.fontObject)
	end
end

function element:setFlash(flash, endFlashOnMouse)
	self.flash = flash
	self.endFlashOnMouse = endFlashOnMouse
	
	if flash then
		self.flashTime = 0
		self.panelColorFlash = self.panelColor:duplicate()
		
		self.panelColorFlash:setColor(self.panelColorFlash:lerpSelfResult(0.35))
		
		self.panelColorFlash.a = 255
		self.flashR, self.flashG, self.flashB, self.flashA = self.panelColorFlash:unpack()
	end
end

function element:onMouseEntered()
	element.baseClass.onMouseEntered(self)
	
	if self.endFlashOnMouse then
		self.flash = false
	end
end

function element:setupTextObject()
end

function element:setText(text)
	if not self.textObject then
		self.textObject = self:createTextObject(self.fontObject, nil)
	else
		self.textObject:clear()
	end
	
	self.text = text
	
	self:scaleToText()
end

function element:getIconOffset()
	return self.fontHeight
end

function element:updateTextContainer()
	self.textObject:clear()
	
	local x, y = _S(5), _S(1)
	local iconOffset = 0
	
	if self.icon then
		iconOffset = self:getIconOffset()
	end
	
	if self.wrappedTextPost then
		self.textObject:addShadowed(self.wrappedText, nil, x + iconOffset, y)
		self.textObject:addShadowed(self.wrappedTextPost, nil, x, y + self.fontHeight)
	else
		self.textObject:addShadowed(self.wrappedText, nil, x + iconOffset, y)
	end
end

function element:getText()
	return self.text
end

function element:getFont()
	return self.font, self.fontObject
end

function element:setImportance(level)
	local eventBoxData = gui.getClassTable("EventBox")
	
	self.importance = level
	self.panelColor = eventBoxData.IMPORTANCE_COLORS[self.importance].panel
end

function element:getImportance()
	return self.importance
end

function element:fillInteractionComboBox(comboBox)
	self.textClassData:fillInteractionComboBox(comboBox, self)
end

function element:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x - _S(20), y - _S(10))
	
	comboBox.baseButton = self
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	interactionController:setInteractionObject(self, nil, nil, true)
end

function element:setSize(...)
	element.baseClass.setSize(self, ...)
	self:scaleToText()
end

function element:updateSprites()
	local r, g, b, a
	
	if self.flash then
		self.flashTime = self.flashTime + frameTime
		
		if self.flashTime >= 1 then
			self.flashTime = self.flashTime - 1
		end
		
		local flash = math.flash(self.flashTime, 1)
		
		r, g, b, a = self.panelColor:lerpResult(flash, self.flashR, self.flashG, self.flashB, self.flashA)
	else
		r, g, b, a = self.panelColor:unpack()
	end
	
	self:setNextSpriteColor(r, g, b, a * self.alpha)
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	if self.icon then
		local unscaledFontHeight = _US(self.fontHeight) - 2
		
		self:setNextSpriteColor(255, 255, 255, a * self.alpha)
		
		self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, _S(2), _S(2), 0, unscaledFontHeight, unscaledFontHeight, 0, 0, -0.5)
	end
end

function element:setTextID(id)
	self.textID = id
	self.textClassData = eventBoxText.registeredByID[self.textID]
end

function element:setData(data)
	self.textData = data
	
	self:setText(self.textClassData:getText(self.textData))
end

function element:getData()
	return self.textData
end

function element:saveData()
	local saved = {
		id = self.id,
		text = self.text,
		importance = self.importance,
		class = self.class,
		textID = self.textID,
		flash = self.flash,
		endFlashOnMouse = self.endFlashOnMouse,
		icon = self.icon
	}
	
	if self.textID then
		saved.textData = self.textClassData:save(self.textData)
	end
	
	return saved
end

function element:setIcon(icon)
	self.icon = icon
	
	if self.wrappedText then
		self:scaleToText(true)
	end
end

function element:loadData(data)
	self:setFont("bh19")
	
	if data.textID then
		self:setTextID(data.textID)
		self.textClassData:load(self, data.textData)
	end
	
	if data.importance then
		self:setImportance(data.importance)
	end
	
	self:setFlash(data.flash, data.endFlashOnMouse)
	self:setIcon(data.icon)
	
	if data.id then
		self:setID(data.id)
	end
end

function element:scaleToText(force)
	if self.previousWidth == self.w and not force then
		return 
	end
	
	local iconOffset
	
	if self.icon then
		iconOffset = self:getIconOffset()
	end
	
	self.wrappedText, self.wrappedTextPost = nil
	
	local text, lineCount, height, firstText = string.wrap(self.text, self.fontObject, self.w - _S(20), nil, iconOffset)
	
	if firstText and type(firstText) == "string" then
		self.wrappedText = firstText
		self.wrappedTextPost = text
	else
		self.wrappedText = text
	end
	
	self:setHeight(_US(height) + 2)
	
	self.previousWidth = self.w
	
	self:updateTextContainer()
end

function element:think()
	local oldAlpha = self.alpha
	
	if oldAlpha ~= self.eventBox.alpha then
		self:setAlpha(self.eventBox.alpha)
	end
	
	if self.flash then
		self:queueSpriteUpdate()
	end
end

function element:setAlpha(alpha)
	self.alpha = alpha
	
	self:queueSpriteUpdate()
end

function element:draw(w, h)
	local textColor, shadowColor = self.textColor, self.textShadowColor
	
	love.graphics.setColor(255, 255, 255, 255 * self.alpha)
	self.textObject:draw(0, 0)
end

gui.register("EventBoxElement", element)
