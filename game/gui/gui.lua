gui.genericOutlineColor = color(0, 0, 0, 100)
gui.genericFillColor = color(0, 0, 0, 100)
gui.genericGradientColor = color(0, 0, 0, 200)
gui.genericMainGradientColor = color(83, 152, 209, 255)

function gui:preventsMouseOver()
	return false
end

gui.elementCloseKeys = {}

local oldRemoveAllUIElements = gui.removeAllUIElements

function gui.removeAllUIElements()
	oldRemoveAllUIElements()
	table.clear(gui.elementCloseKeys)
end

function gui:setCloseKey(key)
	local prevKey = self.closeKey
	
	if prevKey then
		gui.elementCloseKeys[prevKey] = nil
	end
	
	self.closeKey = key
	
	if key then
		gui.elementCloseKeys[key] = self
	end
end

function gui:canCloseViaKey()
	return true
end

function gui:closeViaKey()
	self:kill()
end

gui._oldHandleKeyPress = gui.handleKeyPress

function gui.handleKeyPress(key, isrepeat)
	local stop = gui._oldHandleKeyPress(key, isrepeat)
	
	if not stop and not gui.elementSelected then
		gui.attemptCloseElement(key)
	end
	
	return stop
end

gui._oldHandleTextEntry = gui.handleTextEntry

function gui.handleTextEntry(key, isrepeat)
	local stop = gui._oldHandleTextEntry(key, isrepeat)
	
	if not stop and not gui.elementSelected then
		gui.attemptCloseElement(key)
	end
	
	return stop
end

function gui.attemptCloseElement(key)
	local elem = gui.elementCloseKeys[key]
	
	if elem and elem:canCloseViaKey() then
		gui.elementCloseKeys[key] = nil
		
		elem:closeViaKey()
	end
end

local genericElement = {}

genericElement.skinPanelFillColor = game.UI_COLORS.NEW_HUD_FILL_3
genericElement.skinPanelHoverColor = game.UI_COLORS.NEW_HUD_HOVER
genericElement.skinPanelDisableColor = color(48, 59, 76, 255)

function genericElement:onMouseEntered()
	self:queueSpriteUpdate()
end

function genericElement:onMouseLeft()
	self:queueSpriteUpdate()
end

function genericElement:updateSprites()
	local color
	
	if not self.canClick then
		color = self.skinPanelDisableColor
	else
		color = self:getStateColor()
	end
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.09)
	
	self:setNextSpriteColor(self.genericFillColor:unpack())
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(3), _S(3), self.rawW - 6, self.rawH - 6, 2, -0.08)
end

gui.register("GenericElement", genericElement)

local slider = gui.getClassTable("Slider")

slider.barXOffset = 3
slider.barYOffset = 3
slider.textVerticalOffset = 1
slider.skinPanelFillColor = genericElement.skinPanelFillColor
slider.skinPanelHoverColor = genericElement.skinPanelHoverColor
slider.skinPanelDisableColor = genericElement.skinPanelDisableColor
slider.skinTextFillColor = color(245, 245, 245, 255)
slider.progressBarUnderColor = color(47, 57, 73, 255)
slider.progressBarUnderHoverColor = color(66, 80, 102, 255)
slider.progressBarColor = color(132, 160, 206, 255)
slider.progressBarHoverColor = color(157, 189, 242, 255)

function slider:onMouseEntered()
	self:queueSpriteUpdate()
end

function slider:onMouseLeft()
	self:queueSpriteUpdate()
end

function slider:setFont(font)
	slider.baseClass.setFont(self, font)
	
	self.unscaledFontHeight = _US(self.fontHeight)
end

function slider:getBarColor()
	return self:isMouseOver() and self.progressBarHoverColor or self.progressBarColor
end

function slider:setSliderGap(maxBars, gap)
	self.sliderPieceSprites = {}
	self.maxSliderPieces = maxBars
	self.sliderGap = gap
end

function slider:setIcon(icon, width, height)
	self.icon = icon
	self.iconWidth = width
	self.iconHeight = height
	
	self:queueSpriteUpdate()
end

function slider:getBarHeight()
	return self.rawH - self.textVerticalOffset - self.unscaledFontHeight - self.barYOffset * 2
end

function slider:getBarWidth()
	return self.rawW - self.barXOffset * 2 - 4
end

function slider:getBarY()
	return _S(self.barYOffset) + self.fontHeight
end

function slider:getBarX()
	return _S(self.barXOffset) + _S(2)
end

function slider:updateSprites()
	local pCol, tCol = self:getStateColor()
	local poutline = self:getPanelOutlineColor()
	
	self:setNextSpriteColor(poutline:unpack())
	
	self.outlineSprite = self:allocateSprite(self.outlineSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.5)
	
	if self.icon then
		self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, _S(3), _S(3), 0, self.iconWidth, self.iconHeight, 0, 0, -0.5)
	end
	
	local scaledOffsetX, scaledOffsetY = _S(self.barXOffset), _S(self.barYOffset)
	local scaledTextVertOffset = _S(self.textVerticalOffset)
	local barHeight = self:getBarHeight()
	
	self:setNextSpriteColor(self.progressBarUnderColor:unpack())
	
	self.progressBarUnderSprite = self:allocateSprite(self.progressBarUnderSprite, "vertical_gradient_75", scaledOffsetX, scaledOffsetY + self.fontHeight, 0, self.rawW - self.barXOffset * 2, barHeight, 0, 0, -0.45)
	
	local underColor
	local overColor = self:getBarColor()
	
	if self:isMouseOver() then
		underColor = self.progressBarUnderHoverColor
	else
		underColor = self.progressBarUnderColor
	end
	
	local underW = self.rawW - self.barXOffset * 2
	
	self:setNextSpriteColor(underColor:unpack())
	
	self.progressBarUnderSprite = self:allocateSprite(self.progressBarUnderSprite, "vertical_gradient_75", scaledOffsetX, scaledOffsetY + self.fontHeight, 0, underW, barHeight, 0, 0, -0.45)
	
	local displayPercentage = math.min(math.max((self.value - self.minValue) / self:getProgressToMax(), 0), 1)
	
	if self.sliderPieceSprites then
		local elementWidth = (underW - self.maxSliderPieces * self.sliderGap - self.barXOffset) / self.maxSliderPieces
		local scaledGap = _S(self.sliderGap)
		local scaledElementWidth = _S(elementWidth)
		local scaledGap = _S(self.sliderGap)
		local maxVisible = self:getActiveSliderPieces(displayPercentage)
		local gap = math.floor(scaledElementWidth + scaledGap)
		local maxWithGap = self.w - gap * self.maxSliderPieces
		local offset = math.floor(maxWithGap * 0.25)
		local elementX = scaledOffsetX + _S(self.barXOffset)
		local r, g, b, a = overColor.r, overColor.g, overColor.b, overColor.a
		local y = scaledOffsetY + self.fontHeight + _S(2)
		
		for i = 1, self.maxSliderPieces do
			if i <= maxVisible then
				local pieceClr = self:getPieceColor(i)
				
				if pieceClr then
					self:setNextSpriteColor(pieceClr.r, pieceClr.g, pieceClr.b, pieceClr.a)
				else
					self:setNextSpriteColor(r, g, b, a)
				end
				
				self.sliderPieceSprites[i] = self:allocateSprite(self.sliderPieceSprites[i], "vertical_gradient_75", elementX, y, 0, elementWidth, barHeight - 4, 0, 0, -0.45)
				elementX = elementX + gap
			else
				self.sliderPieceSprites[i] = self:allocateSprite(self.sliderPieceSprites[i], "vertical_gradient_75", 0, 0, 0, 0, 0, 0, 0, -0.45)
			end
		end
	else
		self:setNextSpriteColor(overColor:unpack())
		
		self.progressBarSprite = self:allocateSprite(self.progressBarSprite, "vertical_gradient_75", scaledOffsetX + _S(2), scaledOffsetY + self.fontHeight + _S(2), 0, (self.rawW - self.barXOffset * 2 - 4) * displayPercentage, barHeight - 4, 0, 0, -0.45)
	end
end

function slider:getActiveSliderPieces(displayPercentage)
	return math.floor(displayPercentage * self.maxSliderPieces) + 1
end

function slider:getPieceColor()
end

function slider:getSliderMousePercentage(mouseX)
	return (mouseX - _S(self.sliderOffX) * 2) / (self.w - _S(self.sliderOffX) * 4)
end

function slider:getTextColor()
	return select(2, self:getStateColor())
end

function slider:draw(w, h)
	local tCol = self:getTextColor()
	
	love.graphics.setFont(self.fontObject)
	
	local x = _S(3)
	
	if self.icon then
		x = x + _S(self.iconWidth + 3)
	end
	
	love.graphics.printST(self.text, x, _S(self.textVerticalOffset), tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
end

local oldSetValue = slider.setValue

function slider:setValue(value)
	local oldValue = self.value
	
	oldSetValue(self, value)
	
	if self.value ~= oldValue then
		self:queueSpriteUpdate()
	end
end

local textbox = gui.getElementType("TextBox")

function textbox:draw()
	self:drawText()
end

function textbox:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.92)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_FILL_3:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.91)
	
	self:setNextSpriteColor(self.genericFillColor:unpack())
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(2), _S(2), self.rawW - 4, self.rawH - 4, 2, -0.9)
end

local panel = gui.getElementType("Panel")

panel.drawColor = color(178.20000000000002, 189, 189.9, 255)
panel.alpha = 255

local genDbox = gui.getElementType("GenericDescbox")

genDbox.addSpacingH = 6
genDbox.halfSpacingH = 3
genDbox.startingHeight = 3
genDbox.regularColor = game.UI_COLORS.NEW_HUD_FILL_3
genDbox.mouseOverColor = game.UI_COLORS.NEW_HUD_HOVER

local oldInit = genDbox.init

function genDbox:init(...)
	oldInit(self, ...)
	self:addSpaceToNextText(2)
end

function genDbox:drawBackground()
	local globalAlpha = self.alpha
	local r, g, b, a = game.UI_COLORS.NEW_HUD_OUTER:unpack()
	
	a = a * globalAlpha
	
	self:setNextSpriteColor(r, g, b, a)
	
	self.bgSpriteUnder = self:allocateHollowRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.92)
	
	local r, g, b, a
	
	a = 235
	
	if self:isMouseOver() then
		r, g, b = self.mouseOverColor:unpack()
	else
		r, g, b = self.regularColor:unpack()
	end
	
	a = a * globalAlpha
	
	self:setNextSpriteColor(r, g, b, a)
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - _S(2), self.rawH - _S(2), 0, 0, -0.91)
	
	local r, g, b, a = self.genericFillColor:unpack()
	
	self:setNextSpriteColor(r, g, b, a * globalAlpha)
	
	self.thirdBgSprite = self:allocateRoundedRectangle(self.thirdBgSprite, _S(2), _S(2), self.rawW - _S(4), self.rawH - _S(4), 2, -0.9)
end

local frame = gui.getElementType("Frame")

frame.canBlockCamera = true
frame.shouldBlockLightingManager = true
frame.showSound = "popup_in"

local function setWasPushed(self, was)
	self.wasPushed = was
end

local function onKill(self)
	if self.wasPushed then
		frameController:pop()
	end
	
	self:postKill()
end

function frame:setCanBlockCamera(can)
	self.canBlockCamera = can
end

function frame:getCanBlockCamera()
	return self.canBlockCamera
end

function frame:postKill()
end

frame.setWasPushed = setWasPushed
frame.onKill = onKill
frame.skinPanelOutlineColor = color(0, 0, 0, 100)
frame.topRectColor = game.UI_COLORS.NEW_HUD_FILL_3
frame.skinPanelFillColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
frame.skinPanelHoverColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
frame.skinTextFillColor = game.UI_COLORS.WHITE
frame.skinTextHoverColor = game.UI_COLORS.WHITE
frame.buttonPad = 4
frame.buttonSize = 24
frame.animated = true

local oldHideCloseButton = frame.hideCloseButton

function frame:adjustCloseButtonPosition()
	self.closeButton:setPos(self.w - self.closeButton.w - _S(3), _S(2))
end

function frame:hideCloseButton()
	oldHideCloseButton(self)
	
	self.closeViaEscape = false
end

function frame:preventsMouseOver()
	return true
end

function frame:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.outlineSprites = self:allocateRoundedRectangle(self.outlineSprites, -_S(1), -_S(1), self.rawW + 3, self.rawH + 3, 2, -0.6)
	
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol.r, pcol.g, pcol.b, pcol.a)
	
	self.bottomSprite = self:allocateSprite(self.bottomSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local topSize = self._scaleVert and _US(self.fontHeight + self.offsetY) or self.fontHeight + self.offsetY
	local topColor = frame.topRectColor
	
	self:setNextSpriteColor(topColor.r, topColor.g, topColor.b, topColor.a)
	
	self.topSprite = self:allocateSprite(self.topSprite, "generic_1px", 0, 0, 0, self.rawW, topSize, 0, 0, -0.45)
end

frame.oldSetPos = frame.setPos
frame.oldInit = frame.init

function frame:init(...)
	self:oldInit(...)
	
	if game.instantPopups then
		self.animated = false
	end
end

function frame:setPos(x, y)
	if not game.instantPopups and not self.animating and self.animated then
		self.targetX = x
		self.targetY = y
		self.startY = scrH
		self.animProgress = 0
		
		self:oldSetPos(x, y)
	else
		self:oldSetPos(x, y)
	end
end

function frame:setAnimated(anim)
	self.animated = anim
end

function frame:setShowSound(sound)
	self.showSound = sound
end

function frame:getShowSound()
	return self.showSound
end

function frame:queueShowSound()
	self.showSoundQueued = true
end

function frame:dequeueShowSound()
	self.showSoundQueued = false
end

function frame:think()
	if self.showSoundQueued then
		sound:play(self.showSound)
		
		self.showSoundQueued = nil
	end
	
	if self.animated then
		self.animating = true
		
		local ft = math.min(0.016666666666666666, frameTime)
		local oldProgress = self.animProgress
		
		self.animProgress = math.approach(oldProgress, 1, math.max(ft, (1 - oldProgress) * ft * 23) * self.moveSpeed)
		
		local newY = math.lerp(self.startY, self.targetY, self.animProgress)
		
		if oldProgress ~= self.animProgress then
			self:setPos(self.targetX, newY)
			self:queueSpriteUpdate()
		else
			self.animated = false
		end
		
		self.animating = false
	end
end

function frame:canCloseViaEscape()
	return not self.animated and frame.baseClass.canCloseViaEscape(self)
end

function frame:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.title, self.offsetX, self.offsetY - 2, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, tcol.a)
end

local frameCloseButton = gui.getClassTable("FrameCloseButton")

frameCloseButton.skinPanelFillColor = color(240, 240, 240, 255)
frameCloseButton.skinPanelHoverColor = color(255, 255, 255, 255)

function frameCloseButton:onMouseEntered()
	self:queueSpriteUpdate()
end

function frameCloseButton:onMouseLeft()
	self:queueSpriteUpdate()
end

function frameCloseButton:updateSprites()
	self:setNextSpriteColor(50, 50, 50, 255)
	
	self.backgroundCircle = self:allocateSprite(self.backgroundCircle, "generic_circle", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.closeCircle = self:allocateSprite(self.closeCircle, "close_button", _S(2), _S(2), 0, self.rawW - 4, self.rawH - 4, 0, 0, -0.1)
end

function frameCloseButton:draw(w, h)
end

local popup = gui.getElementType("Popup")

function popup:updateSprites()
	local old = self._scaleVert
	
	self._scaleVert = true
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	local unscaledH = _US(self.rawH)
	
	self.outlineSprites = self:allocateRoundedRectangle(self.outlineSprites, -_S(1), -_S(1), self.rawW + 2, unscaledH + 3, 2, -0.6)
	
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol.r, pcol.g, pcol.b, pcol.a)
	
	self.bottomSprite = self:allocateSprite(self.bottomSprite, "generic_1px", 0, 0, 0, self.rawW, unscaledH, 0, 0, -0.5)
	
	local topSize = self._scaleVert and _US(self.fontHeight + self.offsetY) or self.fontHeight + self.offsetY
	local topColor = frame.topRectColor
	
	self:setNextSpriteColor(topColor.r, topColor.g, topColor.b, topColor.a)
	
	self.topSprite = self:allocateSprite(self.topSprite, "generic_1px", 0, 0, 0, self.rawW, topSize, 0, 0, -0.45)
	self._scaleVert = old
end

local invisFrame = gui.getElementType("InvisibleFrame")

invisFrame.invisible = false

function invisFrame:canCloseViaEscape()
	return gui.canCloseViaEscape(self)
end

function invisFrame:think()
end

function invisFrame:updateSprites()
end

gui.closeViaEscape = true

function gui:setCanCloseViaEscape(can)
	self.closeViaEscape = can
end

function gui:canCloseViaEscape()
	return self.closeViaEscape and not self.usingClickIDs and not self.blacklistingClickIDs
end

local scroller = gui.getElementType("ScrollbarPanel")

scroller.skinPanelFillColor = color(0, 0, 0, 100)
scroller.skinPanelOutlineColor = scroller.skinPanelFillColor
scroller.skinPanelHoverColor = scroller.skinPanelFillColor

local combobox = gui.getElementType("ComboBox")

combobox.autoCloseTime = 0.5

local oldComboBoxInit = combobox.init

function combobox:draw()
end

function combobox:addNoOptionsButton()
	local prev = self.optionButtonType
	
	self.optionButtonType = combobox.optionButtonType
	
	self:addOption(0, 0, 0, 24, _T("NO_OPTIONS", "No options"), fonts.get("pix20"), nil)
	
	self.optionButtonType = prev
end

function combobox:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, -_S(1), -_S(1), self.rawW + 4, self.rawH + 4, 4, -0.1)
end

function combobox:onKill()
	if not self.skippedSet then
		interactionController:resetInteractionObject()
	end
end

function combobox:init(skipComboboxSet, ...)
	oldComboBoxInit(self, skipComboboxSet, ...)
	
	if not skipComboboxSet then
		interactionController:setComboBox(self)
	end
	
	self.skippedSet = skipComboboxSet
end

function combobox:setObject(object)
	self.object = object
end

function combobox:getObject()
	return self.object
end

combobox.oldThink = combobox.think

function combobox:think()
	combobox.oldThink(self)
	
	if self.object and self.object.WORLD_OBJECT then
		local x, y = self.object:getPos()
		
		self:setPos((x - camera.x) * camera.scaleX, (y - camera.y) * camera.scaleY)
	end
end

local button = gui.getElementType("Button")

button.oldButtonInit = button.init
button.oldMouseEntered = button.onMouseEntered
button.oldMouseLeft = button.onMouseLeft
button.skinPanelFillColor = game.UI_COLORS.NEW_HUD_FILL_3
button.skinPanelHoverColor = game.UI_COLORS.NEW_HUD_HOVER
button.skinPanelSelectColor = color(163, 176, 198, 255)
button.skinPanelDisableColor = color(69, 84, 112, 255)
button.skinPanelOutlineColor = color(0, 0, 0, 100)
button.skinTextFillColor = game.UI_COLORS.WHITE
button.skinTextHoverColor = game.UI_COLORS.WHITE
button.skinTextSelectColor = game.UI_COLORS.WHITE

button:setFont("pix24")

function button:onMouseEntered()
	self:oldMouseEntered()
	self:queueSpriteUpdate()
end

function button:onMouseLeft()
	self:oldMouseLeft()
	self:queueSpriteUpdate()
end

function button:updateSprites(w, h)
	local pcol
	
	if not self.canClick then
		pcol = self.skinPanelDisableColor
	else
		pcol = self:getStateColor()
	end
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.5)
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.49)
end

function button:draw(w, h)
	local pcol, tcol
	
	if not self.canClick then
		tcol = self.skinPanelDisableColor, self.skinTextDisableColor
	else
		pcol, tcol = self:getStateColor()
	end
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, self.textX, math.floor((h - self.textHeight) / 2), tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

function button:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function button:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

local propSheetButton = gui.getElementType("PropertySheetTabButton")

propSheetButton.skinPanelFillColor = color(59, 79, 109, 255)
propSheetButton.skinPanelHoverColor = color(96, 128, 175, 255)
propSheetButton.skinPanelSelectColor = color(112, 148, 204, 255)
propSheetButton.skinPanelDisableColor = color(20, 20, 20, 255)
propSheetButton.skinPanelOutlineColor = color(0, 0, 0, 100)

function propSheetButton:playClickSound(onClickState)
	sound:play("switch_tab", nil, nil, nil)
end

function propSheetButton:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, (w - self.textWidth) * 0.5, (h - self.textHeight) / 2, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

function propSheetButton:onMouseEntered()
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.hoverText) do
			self.descBox:addText(data.text, data.font, data.color, data.lineSpacing, data.maxWidth or 600)
		end
	end
	
	if not self.canClick then
		local wasPresent = self.descBox ~= nil
		
		self.descBox = self.descBox or gui.create("GenericDescbox")
		
		if wasPresent then
			self.descBox:addSpaceToNextText(5)
		end
		
		self.descBox:addText(_T("TAB_CURRENTLY_UNAVAILABLE", "This tab is currently unavailable."), "pix24", game.UI_COLORS.IMPORTANT_1, 0, 600)
	end
	
	if self.descBox then
		self:positionDescBox()
	end
end

function propSheetButton:setIcon(icon)
	self.icon = icon
end

function propSheetButton:setIconSize(w, h)
	self.iconW = w
	self.iconH = h
end

function propSheetButton:updateSprites()
	local panelColor = self:getStateColor()
	
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	if self.icon then
		local smallest = math.min(self.rawW, self.rawH)
		
		self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, _S(2), _S(2), 0, self.iconW or smallest - _S(4), self.iconH or smallest - _S(4), 0, 0, -0.45)
	end
	
	if self:passesClickFilters() and self.canClick then
		self:setNextSpriteColor(panelColor:unpack())
	else
		local r, g, b = propSheetButton.skinPanelFillColor:lerpSelfResult(0.33)
		
		self:setNextSpriteColor(r, g, b, 255)
	end
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "vertical_gradient_75", math.max(1, _S(1)), math.max(1, _S(1)), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.5)
end

function propSheetButton:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

propSheetButton.onMouseEnteredOld = propSheetButton.onMouseEntered

function propSheetButton:onMouseEntered()
	propSheetButton.onMouseEnteredOld(self)
	self:queueSpriteUpdate()
end

local comboBoxOption = gui.getElementType("ComboBoxOption")

comboBoxOption.skinPanelFillColor = color(86, 104, 135, 240)
comboBoxOption.skinPanelAlternativeFillColor = color(65, 79, 102, 240)
comboBoxOption.skinPanelHoverColor = color(130, 158, 204, 240)
comboBoxOption.skinPanelDisableColor = color(40, 49, 63, 255)
comboBoxOption.skinTextDisableColor = color(60, 60, 60, 255)

function comboBoxOption:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function comboBoxOption:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

local checkbox = gui.getElementType("Checkbox")

function checkbox:updateSprites()
	if self:isOn() then
		self.checkboxSprite = self:allocateSprite(self.checkboxSprite, "checkbox_on", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	else
		self.checkboxSprite = self:allocateSprite(self.checkboxSprite, "checkbox_off", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	end
end

function checkbox:draw(w, h)
end

gui.GRADIENT_TYPES = {
	HORIZONTAL = 1,
	VERTICAL = 2
}

function gui:allocateLinearGradient(gradientIndex, x, y, w, h, startColor, endColor, gradientType, depthOffset)
	self.totalGradientSprites = self.totalGradientSprites or 0
	self.gradientSprites = self.gradientSprites or {}
	gradientType = gradientType or gui.GRADIENT_TYPES.VERTICAL
	
	if gradientType == gui.GRADIENT_TYPES.VERTICAL then
		self:_allocateVerticalGradient(gradientIndex, x, y, w, h, startColor, endColor, depthOffset)
	elseif gradientType == gui.GRADIENT_TYPES.HORIZONTAL then
		self:_allocateHorizontalGradient(gradientIndex, x, y, w, h, startColor, endColor, depthOffset)
	end
	
	return #self.gradientSprites
end

local generic_1px = "generic_1px"

function gui:_allocateVerticalGradient(destinationIndex, x, y, w, h, startColor, endColor, depthOffset)
	self.gradientSprites[destinationIndex] = self.gradientSprites[destinationIndex] or {}
	
	local listOfSlots = self.gradientSprites[destinationIndex]
	
	for i = 1, h do
		local position = i - 1
		
		self:setNextSpriteColor(startColor:lerpColorResult(i / h, endColor))
		
		listOfSlots[i] = self:allocateSprite(listOfSlots[i], generic_1px, x, y + position, 0, w, 1, 0, 0, depthOffset)
	end
end

function gui:_allocateHorizontalGradient(destinationIndex, x, y, w, h, startColor, endColor)
end

function gui.createGenericFrame(frameClass)
	frameClass = frameClass or "Frame"
	
	local frame = gui.create(frameClass)
	
	frame:setFont("pix24")
	
	return frame
end

function gui:allocateRoundedRectangle(spriteList, x, y, w, h, cornerSize, depthOffset)
	spriteList = spriteList or {}
	
	if w == 0 and h == 0 then
		return spriteList
	end
	
	local r, g, b, a = gui.nextSpriteColor:unpack()
	local positionalCornerSize = self._scaleHor and math.floor(self:applyScaler(cornerSize)) or cornerSize
	local scaledW, scaledH = w, h
	
	if self._scaleHor then
		scaledW = math.floor(self:applyScaler(w))
	end
	
	if self._scaleVert then
		scaledH = math.floor(self:applyScaler(h))
	end
	
	spriteList[1] = self:allocateSprite(spriteList[1], "rounded_corner", x, y, 0, cornerSize, cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[2] = self:allocateSprite(spriteList[2], "rounded_corner", x + scaledW, y, 0, -cornerSize, cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[3] = self:allocateSprite(spriteList[3], "rounded_corner", x, y + scaledH, 0, cornerSize, -cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[4] = self:allocateSprite(spriteList[4], "rounded_corner", x + scaledW, y + scaledH, 0, -cornerSize, -cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[5] = self:allocateSprite(spriteList[5], "generic_1px", x, y + positionalCornerSize, 0, w, h - cornerSize * 2, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[6] = self:allocateSprite(spriteList[6], "generic_1px", x + positionalCornerSize, y, 0, w - cornerSize * 2, cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[7] = self:allocateSprite(spriteList[7], "generic_1px", x + positionalCornerSize, y + scaledH - positionalCornerSize, 0, w - cornerSize * 2, cornerSize, nil, nil, depthOffset)
	
	return spriteList
end

function gui:allocateHollowRoundedRectangle(spriteList, x, y, w, h, cornerSize, depthOffset)
	spriteList = spriteList or {}
	
	if w == 0 and h == 0 then
		return spriteList
	end
	
	local r, g, b, a = gui.nextSpriteColor:unpack()
	local positionalCornerSize = self._scaleHor and math.floor(self:applyScaler(cornerSize)) or cornerSize
	local scaledW, scaledH = w, h
	
	if self._scaleHor then
		scaledW = math.floor(self:applyScaler(w))
	end
	
	if self._scaleVert then
		scaledH = math.floor(self:applyScaler(h))
	end
	
	spriteList[1] = self:allocateSprite(spriteList[1], "rounded_corner", x, y, 0, cornerSize, cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[2] = self:allocateSprite(spriteList[2], "rounded_corner", x + scaledW, y, 0, -cornerSize, cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[3] = self:allocateSprite(spriteList[3], "rounded_corner", x, y + scaledH, 0, cornerSize, -cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[4] = self:allocateSprite(spriteList[4], "rounded_corner", x + scaledW, y + scaledH, 0, -cornerSize, -cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[5] = self:allocateSprite(spriteList[5], "generic_1px", x, y + positionalCornerSize, 0, cornerSize, h - cornerSize * 2, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[6] = self:allocateSprite(spriteList[6], "generic_1px", x + scaledW - positionalCornerSize, y + positionalCornerSize, 0, cornerSize, h - cornerSize * 2, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[7] = self:allocateSprite(spriteList[7], "generic_1px", x + positionalCornerSize, y, 0, w - cornerSize * 2, cornerSize, nil, nil, depthOffset)
	
	self:setNextSpriteColor(r, g, b, a)
	
	spriteList[8] = self:allocateSprite(spriteList[8], "generic_1px", x + positionalCornerSize, y + scaledH - positionalCornerSize, 0, w - cornerSize * 2, cornerSize, nil, nil, depthOffset)
	
	return spriteList
end

function gui:allocateProgressBar(spriteList, x, y, w, h, progress, barColor, depthOffset)
	local progressBarW, progressBarH = quadLoader:getQuadSize("progress_bar_border")
	local scaledProgressBarW, scaledProgressBarH = progressBarW, progressBarH
	
	if self._scaleHor then
		scaledProgressBarW = self:applyScaler(progressBarW)
	end
	
	if self._scaleVert then
		scaledProgressBarH = self:applyScaler(progressBarH)
	end
	
	local scaledW, scaledH = w, h
	
	if self._scaleHor then
		scaledW = self:applyScaler(w)
	end
	
	if self._scaleVert then
		scaledH = self:applyScaler(h)
	end
	
	spriteList = spriteList or {}
	spriteList[1] = self:allocateSprite(spriteList[1], "progress_bar_border", x, y, 0, progressBarW, h, 0, 0, depthOffset)
	spriteList[2] = self:allocateSprite(spriteList[2], "progress_bar_middle", x + scaledProgressBarW, y, 0, w + 0.1 - progressBarW * 2, h, 0, 0, depthOffset)
	
	self:setNextSpriteColor(barColor:unpack())
	
	spriteList[3] = self:allocateSprite(spriteList[3], "generic_1px", x + scaledProgressBarW + _S(2), y + _S(2), 0, (w + 0.1 - progressBarW * 2 - 4) * progress, h - 4, 0, 0, depthOffset)
	spriteList[4] = self:allocateSprite(spriteList[4], "progress_bar_border", x + scaledW, y, 0, -progressBarW, h, 0, 0, depthOffset)
	
	return spriteList
end

local scrollBarButton = gui.getElementType("ScrollbarPanelUp")

scrollBarButton.skinPanelFillColor = game.UI_COLORS.NEW_HUD_FILL_3
scrollBarButton.skinPanelHoverColor = game.UI_COLORS.NEW_HUD_HOVER

function scrollBarButton:updateSprites()
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, 0, 0, self.rawW, self.rawH, 2, -0.5)
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "generic_1px", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.49)
end

function scrollBarButton:draw(w, h)
end

local scrollBarGrip = gui.getElementType("ScrollbarPanelGrip")

function scrollBarGrip:draw(w, h)
end

require("game/gui/descbox_popup")
require("game/gui/bar_display_frame")
require("game/gui/bar_display")
require("game/gui/project_info_bar_display_frame")
require("game/gui/list")
require("game/gui/titled_list")
require("game/gui/frame_controller")
require("game/gui/screen_darkener")
require("game/gui/tutorial_screen_darkener")
require("game/gui/cost_display")
require("game/gui/skill_display")
require("game/gui/attribute_display")
require("game/gui/employee_info")
require("game/gui/task_type_selection")
require("game/gui/game_task_type_selection")
require("game/gui/begin_project_button")
require("game/gui/project_name_textbox")
require("game/gui/team_name_textbox")
require("game/gui/projects_menu/select_engine_to_update_button")
require("game/gui/projects_menu/select_engine_to_revamp_button")
require("game/gui/projects_menu/theme_list_combobox_button")
require("game/gui/projects_menu/genre_list_combobox_button")
require("game/gui/projects_menu/engine_list_combobox_button")
require("game/gui/projects_menu/genre_selection_element")
require("game/gui/projects_menu/theme_selection_element")
require("game/gui/projects_menu/genre_theme_match_descbox")
require("game/gui/projects_menu/theme_genre_match_descbox")
require("game/gui/projects_menu/subgenre_match_descbox")
require("game/gui/projects_menu/design_new_genre_button")
require("game/gui/projects_menu/design_new_theme_button")
require("game/gui/team_list_combobox_button")
require("game/gui/combobox_option_buffer")
require("game/gui/team_button")
require("game/gui/team_move_selection")
require("game/gui/employee_team_assignment_button")
require("game/gui/employee_move_button")
require("game/gui/new_team_button")
require("game/gui/create_team_button")
require("game/gui/job_seeker_display")
require("game/gui/floor_tile_purchase_option")
require("game/gui/wall_purchase_option")
require("game/gui/projects_menu/engine_team_combobox")
require("game/gui/projects_menu/engine_list_combobox")
require("game/gui/engine_update_tasklist")
require("game/gui/engine_revamp_tasklist")
require("game/gui/object_purchase_option")
require("game/gui/activity_selection_button")
require("game/gui/activity_participant_display")
require("game/gui/activity_schedule_button")
require("game/gui/enjoyment_rating_display")
require("game/gui/platform_list_combobox_button")
require("game/gui/scale_list_combobox_button")
require("game/gui/basic_developer_info")
require("game/gui/task_developer_info")
require("game/gui/price_list_combobox_button")
require("game/gui/manager_assignment_button")
require("game/gui/finish_assigning_manager_button")
require("game/gui/generic_point_display")
require("game/gui/advertisement_selection_button")
require("game/gui/bribe_reviewer_selection_button")
require("game/gui/interview_reviewer_selection_button")
require("game/gui/bribe_confirm_button")
require("game/gui/bribe_size_slider")
require("game/gui/game_selection_button")
require("game/gui/confirm_invite_button")
require("game/gui/confirm_mass_advert_button")
require("game/gui/mass_advert_info_descbox")
require("game/gui/mass_advert_selection")
require("game/gui/task_completion_display")
require("game/gui/prequel_selection_button")
require("game/gui/engine_licensing_selection")
require("game/gui/open_prequel_selection_button")
require("game/gui/feature_expenses_display")
require("game/gui/game_project_info_selection")
require("game/gui/task_research_selection")
require("game/gui/research_employee_selection")
require("game/gui/begin_research_button")
require("game/gui/platform_info_display")
require("game/gui/total_project_progress_bar")
require("game/gui/research_scrollbar_panel")
require("game/gui/skill_change_display")
require("game/gui/attribute_upgrade_button")
require("game/gui/general_game_info_display")
require("game/gui/project_completion_bar")
require("game/gui/game_platform_sales_display")
require("game/gui/game_review_display")
require("game/gui/review_frame")
require("game/gui/shilling_selection_button")
require("game/gui/confirm_shilling_button")
require("game/gui/shilling_type_combobox_button")
require("game/gui/shilling_duration_combobox_button")
require("game/gui/task_category_priority_adjustment")
require("game/gui/task_category")
require("game/gui/game_scale_adjustment")
require("game/gui/project_team_selection")
require("game/gui/generic_framecontroller_pop_button")
require("game/gui/project_team_selection_confirmation")
require("game/gui/game_patch_team_selection_confirmation")
require("game/gui/game_testing_team_selection_confirm")
require("game/gui/audience_list_combobox_button")
require("game/gui/audience_combobox_button")
require("game/gui/begin_game_development_button")
require("game/gui/game_type_list_combobox_button")
require("game/gui/hint_bubble")
require("game/gui/game_update_tasklist")
require("game/gui/yearly_goal_progress_display")
require("game/gui/skill_level_display")
require("game/gui/attribute_level_display")
require("game/gui/attribute_point_display")
require("game/gui/knowledge_level_display")
require("game/gui/hint_popup")
require("game/gui/gradient_icon_panel")
require("game/gui/level_gradient_icon_panel")
require("game/gui/attribute_gradient_icon_panel")
require("game/gui/task_gradient_icon_panel")
require("game/gui/employee_role_count")
require("game/gui/contract_work_display")
require("game/gui/contract_info")
require("game/gui/yearly_goal_track_checkbox")
require("game/gui/gradient_panel")
require("game/gui/role_scrollbar_panel")
require("game/gui/role_filterer")
require("game/gui/circle_role_filter")
require("game/gui/generic_bordered_text_display")
require("game/gui/role_filterer_list")
require("game/gui/invisible_role_filter")
require("game/gui/screen_fader")
require("game/gui/gradient_icon_text_display")
require("game/gui/timeline_frame")
require("game/gui/projects_menu/project_info_display")
require("game/gui/projects_menu/engine_info_display")
require("game/gui/projects_menu/new_engine_tasklist")
require("game/gui/game_completion_progress_bar")
require("game/gui/work_amount_display")
require("game/gui/game_work_amount_display")
require("game/gui/review_description")
require("game/gui/sale_display_frame")
require("game/gui/progress_bar_with_text")
require("game/gui/management_load_display")
require("game/gui/qa_issue_display")
require("game/gui/team_info_descbox")
require("game/gui/contract_work_popup")
require("game/gui/shilling_cost_display")
require("game/gui/shilling_display_frame")
require("game/gui/icon_button")
require("game/gui/object_interaction_descbox")
require("game/gui/team_scrollbar_panel")
require("game/gui/dismantle_team_button")
require("game/gui/team_reassignment_selection")
require("game/gui/platform_info_descbox")
require("game/gui/project_evaluation_popup")
require("game/gui/trait_gradient_icon_panel")
require("game/gui/confirm_office_name_button")
require("game/gui/employee_role_interaction_button")
require("game/gui/designer_scrollbarpanel")
require("game/gui/publisher_selection_button")
require("game/gui/projects_menu/engine_stats_display")
require("game/gui/projects_menu/engine_stat_display")
require("game/gui/projects_menu/engine_list_combobox_option")
require("game/gui/projects_menu/projects_menu_tab_button")
require("game/gui/projects_menu/projects_menu_frame_controller")
require("game/gui/projects_menu/projects_menu_frame")
require("game/gui/projects_menu/game_engine_selection_element")
require("game/gui/studio_employment_info_descbox")
require("game/gui/fan_offer_frame")
require("game/gui/specialization_popup")
require("game/gui/lets_player_selection")
require("game/gui/confirm_lets_play_button")
require("game/gui/lets_play_cost_display")
require("game/gui/lets_play_display_frame")
require("game/gui/changed_skills_display")
require("game/gui/project_renaming_textbox")
require("game/gui/project_renaming_confirm_button")
require("game/gui/project_scrollbarpanel")
require("game/gui/playthrough_stats_popup")
require("game/gui/remove_selected_prequel_button")
require("game/gui/upcoming_contract_display")
require("game/gui/mass_advert_budget_slider")
require("game/gui/mass_advert_round_slider")
require("game/gui/status_icon_descbox")
require("game/gui/target_team_job_seeker")
require("game/gui/role_gradient_icon_panel")
require("game/gui/inapps_display_frame")
require("game/gui/generic_hint")
require("game/gui/team_unassignment_button")
require("game/gui/confirm_team_name_button")
require("game/gui/exit_assignment_mode_button")
require("game/gui/interest_selection_button")
require("game/gui/interest_deselect_button")
require("game/gui/research_all_tech_button")
require("game/gui/mmo_subs_display_frame")
require("game/gui/release_button")
require("game/gui/mmo_subscription_fee_slider")
require("game/gui/expand_mmo_options_button")
require("game/gui/mmo_subs_bar_display")
require("game/gui/generic_backdrop")
require("game/gui/projects_menu/platform_creation_menu_button")
require("game/gui/projects_menu/inherit_game_setup_button")

if steam then
	require("game/gui/workshop/workshop_mod_display")
	require("game/gui/workshop/workshop_new_mod_button")
	require("game/gui/workshop/workshop_folder_selection")
	require("game/gui/workshop/workshop_preview_selection")
	require("game/gui/workshop/workshop_scrollbar")
	require("game/gui/workshop/workshop_page_control")
	require("game/gui/workshop/workshop_page_control_button")
	require("game/gui/workshop/workshop_legal_agreement_element")
	require("game/gui/workshop/workshop_mod_name_textbox")
	require("game/gui/workshop/workshop_mod_upload_progress")
	require("game/gui/workshop/workshop_published_mod_display")
	require("game/gui/workshop/workshop_tag_checkbox")
	require("game/gui/workshop/workshop_next_page_switch_button")
	require("game/gui/workshop/workshop_mod_help")
end

require("game/gui/server_renting/server_renting_scrollbar")
require("game/gui/server_renting/server_upgrade_element")
require("game/gui/server_renting/upgrade_server_button")
require("game/gui/server_renting/server_capacity_bar")
require("game/gui/server_renting/change_server_rent_button")
require("game/gui/server_renting/rent_cost_display")
require("game/gui/server_renting/rented_server_count_display")
require("game/gui/server_renting/active_mmo_element")
require("game/gui/server_renting/mmo_info_descbox")
require("game/gui/server_renting/customer_support_bar")
require("game/gui/server_renting/change_customer_support_button")
require("game/gui/server_renting/server_renting_info_descbox")
require("game/gui/engine_licensing/engine_selling_selection")
require("game/gui/engine_licensing/engine_license_preparation_panel")
require("game/gui/engine_licensing/engine_license_cost_textbox")
require("game/gui/engine_licensing/start_selling_engine_button")
require("game/gui/engine_licensing/engine_sell_scrollbar")
require("game/gui/engine_licensing/engine_stats_descbox")
require("game/gui/arrow_pointer")
require("game/gui/office_expansion/property_frame")
require("game/gui/office_expansion/expansion_mode_property_sheet")
require("game/gui/office_expansion/expansion_mode_descbox")
require("game/gui/office_expansion/office_cost_display")
require("game/gui/office_expansion/office_naming_text_box")
require("game/gui/office_expansion/finish_naming_office_button")
require("game/gui/office_expansion/exit_expansion_mode")
require("game/gui/office_expansion/space_expansion_confirmation")
require("game/gui/office_expansion/change_construction_mode_button")
require("game/gui/office_expansion/demolition_mode_button")
require("game/gui/office_expansion/office_floor_purchase_display")
require("game/gui/office_expansion/office_info_descbox")
require("game/gui/monthly_cost_popup/descbox_gradient_icon_text_display")
require("game/gui/monthly_cost_popup/interest_boost_display")
require("game/gui/monthly_cost_popup/drive_affector_boost_display")
require("game/gui/monthly_cost_popup/book_experience_boost_display")
require("game/gui/monthly_cost_popup/office_info_button")
require("game/gui/monthly_cost_popup/finances_popup")
require("game/gui/monthly_cost_popup/finances_popup_button")
require("game/gui/monthly_cost_popup/monthly_expenses_display")
require("game/gui/monthly_cost_popup/monthly_cost_display")
require("game/gui/monthly_cost_popup/change_loan_button")
require("game/gui/monthly_cost_popup/loan_display")
require("game/gui/preference_checkbox")
require("game/gui/preference_display")
require("game/gui/hud/employee_assignment_frame")
require("game/gui/hud/expenses_button")
require("game/gui/hud/event_box")
require("game/gui/hud/event_box_element")
require("game/gui/hud/event_box_review_element")
require("game/gui/hud/assignment_box")
require("game/gui/hud/active_project_box")
require("game/gui/hud/active_project_scrollbar")
require("game/gui/hud/active_project_element")
require("game/gui/hud/active_engine_project_element")
require("game/gui/hud/active_game_project_element")
require("game/gui/hud/active_patch_project_element")
require("game/gui/hud/event_box_trend_element")
require("game/gui/hud/speed_adjustment_button")
require("game/gui/hud/main_hud")
require("game/gui/hud/auto_assign_button")
require("game/gui/hud/unassign_employees_button")
require("game/gui/hud/office_unassignment_button")
require("game/gui/hud/employee_assignment_mode_button")
require("game/gui/hud/employee_assignment_selection")
require("game/gui/hud/team_assignment_box")
require("game/gui/hud/team_members_assignment_selection")
require("game/gui/hud/employee_assignment_descbox")
require("game/gui/hud/office_team_assignment")
require("game/gui/hud/loading_progressbar")
require("game/gui/hud/project_element_info_display")
require("game/gui/hud/active_task_element")
require("game/gui/hud/magnification_button")
require("game/gui/hud/object_info_descbox")
require("game/gui/hud/active_price_research_element")
require("game/gui/hud/active_platform_development_task")
require("game/gui/character_designer/character_appearance_display")
require("game/gui/character_designer/trait_selection_gradient_icon_panel")
require("game/gui/character_designer/interest_selection_gradient_icon_panel")
require("game/gui/character_designer/attribute_assignment_category")
require("game/gui/character_designer/change_attribute_button")
require("game/gui/character_designer/attribute_assignment_gradient_icon_panel")
require("game/gui/character_designer/trait_selection_combo_box_option")
require("game/gui/character_designer/confirm_new_player_character_button")
require("game/gui/character_designer/appearance_adjustment")
require("game/gui/character_designer/appearance_adjustment_button")
require("game/gui/character_designer/sex_button")
require("game/gui/character_designer/confirm_begin_game_button")
require("game/gui/character_designer/cancel_game_button")
require("game/gui/quality_point_frame")
require("game/gui/quality_point_display")
require("game/gui/issue_display")
require("game/gui/issue_display_frame")
require("game/gui/qa_progress_frame")
require("game/gui/platform_combobox_option")
require("game/gui/gametype_selection")
require("game/gui/gametype_display_frame")
require("game/gui/new_game_confirmation_button")
require("game/gui/platform_creation/platform_part_selection")
require("game/gui/platform_creation/selected_platform_part")
require("game/gui/platform_creation/platform_creation_cost_display")
require("game/gui/platform_creation/platform_dev_time_slider")
require("game/gui/platform_creation/minimum_dev_time_pin")
require("game/gui/platform_creation/platform_setup_info")
require("game/gui/platform_creation/begin_platform_dev_button")
require("game/gui/platform_creation/platform_specialist_selection")
require("game/gui/platform_creation/select_platform_specialist_button")
require("game/gui/platform_creation/platform_cost_textbox")
require("game/gui/platform_creation/platform_license_cost_textbox")
require("game/gui/platform_creation/look_for_devs_option")
require("game/gui/platform_creation/platform_sales_display_frame")
require("game/gui/platform_creation/expand_platform_options_button")
require("game/gui/platform_creation/platform_sales_bar_display")
require("game/gui/platform_creation/dev_attractiveness_icon_panel")
require("game/gui/platform_creation/platform_net_change_icon_panel")
require("game/gui/platform_creation/platform_advert_duration_slider")
require("game/gui/platform_creation/begin_platform_advert_button")
require("game/gui/platform_creation/platform_advert_descbox")
require("game/gui/platform_creation/platform_name_textbox")
require("game/gui/platform_creation/platform_case_display")
require("game/gui/platform_creation/platform_support_display")
require("game/gui/platform_creation/change_platform_support_button")
require("game/gui/platform_creation/platform_production_display")
require("game/gui/platform_creation/change_platform_production_button")
require("game/gui/platform_creation/platform_fund_change_display_frame")
require("game/gui/platform_creation/platform_fund_change_bar_display")
require("game/gui/platform_creation/platform_game_ratings_frame")
require("game/gui/platform_creation/platform_game_ratings_bar_display")
require("game/gui/projects_menu/past_platforms_category")
require("game/gui/hud/platform_dev_games_info_display")
require("game/gui/main_menu/start_new_game_button")
require("game/gui/main_menu/load_game_button")
require("game/gui/main_menu/save_game_selection_button")
require("game/gui/main_menu/save_game_button")
require("game/gui/main_menu/save_and_quit_button")
require("game/gui/main_menu/quit_to_main_menu_button")
require("game/gui/main_menu/quit_game_button")
require("game/gui/main_menu/map_editor_button")
require("game/gui/main_menu/prefab_editor_button")
require("game/gui/main_menu/start_map_editor_button")
require("game/gui/main_menu/create_new_map_button")
require("game/gui/main_menu/open_map_selection_button")
require("game/gui/main_menu/key_binding_option")
require("game/gui/main_menu/key_binding_input_waiter")
require("game/gui/main_menu/volume_adjustment_slider")
require("game/gui/main_menu/effect_volume_adjustment_slider")
require("game/gui/main_menu/speech_volume_adjustment_slider")
require("game/gui/main_menu/music_volume_adjustment_slider")
require("game/gui/main_menu/voice_volume_adjustment_slider")
require("game/gui/main_menu/ambient_volume_adjustment_slider")
require("game/gui/main_menu/playthrough_stats_button")
require("game/gui/main_menu/save_file_name_textbox")
require("game/gui/main_menu/game_save_confirm_button")
require("game/gui/main_menu/game_save_cancel_button")
require("game/gui/main_menu/snapshot_button")
require("game/gui/main_menu/save_game_delete_button")
require("game/gui/main_menu/savegame_scrollbar")
require("game/gui/main_menu/randomize_playthrough_checkbox")
require("game/gui/main_menu/randomize_playthrough_display")
require("game/gui/main_menu/randomize_genre_matching_display")
require("game/gui/main_menu/randomize_genre_quality_display")
require("game/gui/main_menu/randomize_platform_stats_display")
require("game/gui/main_menu/randomize_starting_themes_genres_display")
require("game/gui/main_menu/difficulty_selection_button")
require("game/gui/main_menu/difficulty_selection_option")
require("game/gui/main_menu/credits_popup_button")
require("game/gui/main_menu/map_selection_button")
require("game/gui/main_menu/starting_year_select_button")
require("game/gui/main_menu/shadows_button")
require("game/gui/main_menu/language_selection_button")
require("game/gui/main_menu/generate_rivals_button")
require("game/gui/main_menu/console_checkbox")
require("game/gui/main_menu/show_local_mods_button")
require("game/gui/main_menu/local_installed_mod")
require("game/gui/main_menu/starting_funds_button")
require("game/gui/main_menu/start_with_employees_checkbox")
require("game/gui/main_menu/employee_retirement_checkbox")
require("game/gui/main_menu/timescale_adjustment_slider")
require("game/gui/main_menu/display_selection_button")
require("game/gui/main_menu/main_menu_object")
require("game/gui/main_menu/main_menu_decor")
require("game/gui/main_menu/main_menu_exit_game")
require("game/gui/main_menu/main_menu_load_game")
require("game/gui/main_menu/main_menu_options")
require("game/gui/main_menu/main_menu_new_game")
require("game/gui/main_menu/main_menu_credits")
require("game/gui/main_menu/main_menu_light")
require("game/gui/main_menu/main_menu_ceiling_fan")
require("game/gui/main_menu/main_menu_coffee")
require("game/gui/main_menu/main_menu_modding")
require("game/gui/main_menu/instant_popups_button")
require("game/gui/main_menu/open_workshop_button")
require("game/gui/main_menu/options_menu_button")
require("game/gui/main_menu/resolution_button")
require("game/gui/main_menu/vsync_button")
require("game/gui/main_menu/screen_mode_button")
require("game/gui/main_menu/shadow_shader_button")
require("game/gui/main_menu/lightmap_quality_button")
require("game/gui/main_menu/weather_intensity_button")
require("game/gui/main_menu/pedestrian_count_button")
require("game/gui/main_menu/autosave_button")
require("game/gui/dialogue/dialogue_box")
require("game/gui/dialogue/dialogue_answer")
require("game/gui/dialogue/dialogue_screen_darkener")
require("game/gui/book_management/bookshelf_info_element")
require("game/gui/book_management/bookshelf_fill_button")
require("game/gui/book_management/bookshelf_clear_button")
require("game/gui/book_management/book_display_element")
require("game/gui/book_management/book_purchase_element")
require("game/gui/book_management/book_buy_button")
require("game/gui/book_management/book_buy_and_place_button")
require("game/gui/book_management/book_purchase_scrollbarpanel")
require("game/gui/book_management/book_management_frame")
require("game/gui/book_management/allocated_book_list")
require("game/gui/book_management/allocated_book")
require("game/gui/book_management/book_inventory_element")
require("game/gui/book_management/book_inventory_scrollbarpanel")
require("game/gui/book_management/book_allocate_button")
require("game/gui/book_management/book_boost_titled_list")
require("game/gui/book_management/book_boost_display")
require("game/gui/game_convention/game_convention_selection_button")
require("game/gui/game_convention/expo_participant_selection")
require("game/gui/game_convention/expo_participants_category")
require("game/gui/game_convention/expo_games_category")
require("game/gui/game_convention/expo_cost_display")
require("game/gui/game_convention/book_expo_button")
require("game/gui/game_convention/expo_efficiency_display")
require("game/gui/game_convention/game_to_present_selection")
require("game/gui/game_convention/expo_booth_selection")
require("game/gui/game_convention/expo_setup_frame")
require("game/gui/game_convention/cancel_booking_close_button")
require("game/gui/game_convention/game_convention_result_frame")
require("game/gui/game_convention/game_convention_result_popup")
require("game/gui/game_convention/select_best_employees_button")
require("game/gui/objectives/objective_display")
require("game/gui/rival_game_companies/steal_employee_display")
require("game/gui/rival_game_companies/rival_info_display")
require("game/gui/rival_game_companies/rival_company_info")
require("game/gui/rival_game_companies/rival_frame")
require("game/gui/rival_game_companies/slander_selection_frame")
require("game/gui/rival_game_companies/slander_info_display")
require("game/gui/rival_game_companies/slander_selection")
require("game/gui/rival_game_companies/rival_scrollbarpanel")
require("game/gui/prefab_editor/load_prefab_button")
require("game/gui/prefab_editor/prefab_construction_mode_button")
require("game/gui/map_editor/load_map_button")
require("game/gui/map_editor/tree_placement_range_textbox")
require("game/gui/map_editor/confirm_tree_placement_button")
require("game/gui/map_editor/confirm_map_naming_button")
require("game/gui/map_editor/confirm_rival_owner_button")
require("game/gui/map_editor/map_naming_textbox")
require("game/gui/map_editor/prefab_rival_textbox")
require("game/gui/map_editor/map_edit_mode_button")
require("game/gui/employee_circulation/employee_search_setup")
require("game/gui/employee_circulation/job_listing_candidate")
require("game/gui/employee_circulation/level_search_adjustment_slider")
require("game/gui/employee_circulation/expenditures_adjustment_slider")
require("game/gui/employee_circulation/search_desired_interest")
require("game/gui/employee_circulation/add_job_listing_button")
require("game/gui/employee_circulation/role_search_selection_button")
require("game/gui/employee_circulation/job_listing_display")
require("game/gui/employee_circulation/job_listing_scrollbar")
require("game/gui/employee_circulation/final_candidates_frame")
require("game/gui/employee_circulation/close_candidate_frame_button")
require("game/gui/employee_circulation/accept_all_candidates_button")
require("game/gui/employee_circulation/refuse_all_candidates_button")
require("game/gui/employee_circulation/job_candidate_team_selection")
require("game/gui/employee_circulation/candidate_target_team_selection")
require("game/gui/game_awards/game_award_entry")
require("game/gui/game_awards/game_award_speech_entry")
require("game/gui/game_awards/set_default_speech_button")
require("game/gui/game_awards/finish_speech_prep_button")
require("game/gui/game_awards/use_last_speech_button")
require("game/gui/game_awards/game_award_nominee_selection")
require("game/gui/game_awards/upcoming_game_awards_display")
require("game/gui/game_awards/game_award_registration_info")
require("game/gui/game_awards/register_game_awards_button")
require("game/gui/game_awards/game_awards_frame")
require("game/gui/game_awards/game_awards_background_element")
require("game/gui/game_awards/game_awards_background_fadein")
require("game/gui/game_awards/game_awards_viewer")
require("game/gui/game_awards/game_awards_winner_speaker")
require("game/gui/game_awards/game_awards_competitor")
require("game/gui/game_awards/game_awards_competitors_button")
require("game/gui/game_awards/game_awards_skip_stage_button")
require("game/gui/thank_you/thank_you_peep_animation")
require("game/gui/new_hud/hud_top")
require("game/gui/new_hud/hud_bottom")
require("game/gui/new_hud/hud_generic_notification")
require("game/gui/new_hud/hud_expansion")
require("game/gui/game_editions/add_new_game_edition_button")
require("game/gui/game_editions/game_edition_display")
require("game/gui/game_editions/game_edition_info_descbox")
require("game/gui/game_editions/game_edition_name_textbox")
require("game/gui/game_editions/game_edition_scroller")
require("game/gui/game_editions/remove_game_edition_button")
require("game/gui/game_editions/game_edition_part_selection")
require("game/gui/game_editions/edition_setup_scroller")
require("game/gui/game_editions/remove_all_editions_button")
require("game/gui/game_editions/game_edition_price_textbox")
require("game/gui/game_editions/edition_cost_display")
