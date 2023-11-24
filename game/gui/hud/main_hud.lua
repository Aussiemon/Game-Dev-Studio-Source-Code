local mainHUD = {}

mainHUD.buttonSpacing = 7
mainHUD.PROJECTS_BUTTON_ID = "projects_menu_button"
mainHUD.PROPERTY_AND_RIVALS_BUTTON_ID = "property_and_rivals_button"
mainHUD.PROPERTY_BUTTON_ID = "property_menu_button"
mainHUD.RIVALS_BUTTON_ID = "rivals_menu_button"
mainHUD.FUNDS_BUTTON_ID = "funds_button"
mainHUD.EMPLOYEES_BUTTON_ID = "employes_button"
mainHUD.OFFICE_PREFERENCES_BUTTON_ID = "preferences_button"
mainHUD.JOB_SEEKERS_MENU_ID = "job_seekers_button"
mainHUD.EVENTS = {
	SHOWING_PROPERTY_BUTTONS = events:new(),
	NEARBY_BUTTON_CLICKED = events:new(),
	SHOWING_EMPLOYEE_BUTTONS = events:new()
}
mainHUD.CATCHABLE_EVENTS = {
	mainHUD.EVENTS.NEARBY_BUTTON_CLICKED
}

function mainHUD:init()
	self:resetPositionData()
	
	self.buttonElements = {}
end

function mainHUD:createElements()
	local timeDisplay = gui.create("TimeHUDElement")
	
	self:addButton(timeDisplay)
	
	self.timeDisplay = timeDisplay
	
	local fundsDisplay = gui.create("FundsHUDElement")
	
	fundsDisplay:setID(mainHUD.FUNDS_BUTTON_ID)
	
	self.fundsDisplay = fundsDisplay
	
	self:addButton(fundsDisplay)
	
	local propertyDisplay = gui.create("PropertyHUDElement")
	
	propertyDisplay:setID(mainHUD.PROPERTY_AND_RIVALS_BUTTON_ID)
	self:addButton(propertyDisplay)
	
	local projectButton = gui.create("ProjectsHUDElement")
	
	projectButton:setID(mainHUD.PROJECTS_BUTTON_ID)
	
	self.projectButton = projectButton
	
	self:addButton(projectButton)
	
	local employeesButton = gui.create("EmployeesHUDElement")
	
	employeesButton:setID(mainHUD.EMPLOYEES_BUTTON_ID)
	
	self.employeesButton = employeesButton
	
	self:addButton(employeesButton)
	
	local preferencesButton = gui.create("OfficePreferencesHUDElement")
	
	preferencesButton:setID(mainHUD.OFFICE_PREFERENCES_BUTTON_ID)
	
	self.preferencesButton = preferencesButton
	
	self:addButton(preferencesButton)
	
	local objectivesButton = gui.create("ObjectivesHUDElement")
	
	self:addButton(objectivesButton)
	
	local mainMenuButton = gui.create("MainMenuHUDElement")
	
	self:addButton(mainMenuButton)
end

function mainHUD:kill()
	self.timeDisplay.remainOnPopup = false
	
	mainHUD.baseClass.kill(self)
end

function mainHUD:makeTimeAlwaysDisplay()
	self.timeDisplay.remainOnPopup = true
end

function mainHUD:finalize()
	if not self:canDisplayElement(mainHUD.FUNDS_BUTTON_ID) then
		self.fundsDisplay:disableRendering()
	else
		self.fundsDisplay:enableRendering()
	end
	
	if not self:canDisplayElement(mainHUD.PROJECTS_BUTTON_ID) then
		self.projectButton:disableRendering()
	else
		self.projectButton:enableRendering()
	end
	
	if not self:canDisplayElement(mainHUD.EMPLOYEES_BUTTON_ID) then
		self.employeesButton:disableRendering()
	else
		self.employeesButton:enableRendering()
	end
	
	if not self:canDisplayElement(mainHUD.OFFICE_PREFERENCES_BUTTON_ID) then
		self.preferencesButton:disableRendering()
	else
		self.preferencesButton:enableRendering()
	end
	
	self:repositionAllButtons()
end

function mainHUD:canDisplayElement(id)
	local data = game.curGametype:getHUDRestrictions()
	
	if data and data[id] then
		return false
	end
	
	return true
end

function mainHUD:handleEvent(event)
	for key, button in ipairs(self.buttonElements) do
		button:clearNearbyButtons()
	end
end

function mainHUD:addButton(object, skipPositioning)
	if not skipPositioning then
		self.largestButton = math.max(self.largestButton, object.w)
		
		object:setPos(self.x + (self.largestButton * 0.5 - object.w * 0.5), self.currentButtonY)
		
		self.currentButtonY = self.currentButtonY + object:getAddHeight() + _S(self.buttonSpacing)
	end
	
	object:setHUDContainer(self)
	table.insert(self.buttonElements, object)
end

function mainHUD:resetPositionData()
	self.currentButtonY = 10
	self.largestButton = 0
end

function mainHUD:repositionAllButtons()
	self:resetPositionData()
	
	for key, element in ipairs(self.buttonElements) do
		self.largestButton = math.max(self.largestButton, element.w)
	end
	
	for key, element in ipairs(self.buttonElements) do
		if not element:isRenderingDisabled() then
			element:setPos(self.x + (self.largestButton * 0.5 - element.w * 0.5), self.currentButtonY)
			
			self.currentButtonY = self.currentButtonY + element:getAddHeight() + _S(self.buttonSpacing)
		end
	end
end

function mainHUD:hide()
	mainHUD.baseClass.hide(self)
	
	for key, element in ipairs(self.buttonElements) do
		if not element.remainOnPopup then
			element:hide()
		else
			element:setCanClick(false)
		end
	end
end

function mainHUD:show()
	mainHUD.baseClass.show(self)
	
	for key, element in ipairs(self.buttonElements) do
		if not element.remainOnPopup then
			element:show()
		else
			element:show()
			element:setCanClick(true)
		end
	end
end

gui.register("MainHUD", mainHUD)

local circleImageButton = {}

circleImageButton.circleImageSize = 64
circleImageButton.nearbyTextSpacing = 7
circleImageButton.nearbyButtonSpacing = 7
circleImageButton.alphaFadeInTime = 4
circleImageButton.alphaFadeOutTime = 3
circleImageButton.fadeInDelayPerButton = 1 / circleImageButton.alphaFadeInTime * 0.5
circleImageButton.fadeOutDelayPerButton = 1 / circleImageButton.alphaFadeOutTime * 0.5
circleImageButton.startFadeWhenDistance = 300
circleImageButton.nearbyTextSide = gui.SIDES.RIGHT
circleImageButton.offsetToBox = 85

function circleImageButton:setHUDContainer(container)
	self.hudContainer = container
end

function circleImageButton:init(nearbyTextSide)
	if nearbyTextSide then
		self.nearbyTextSide = nearbyTextSide
	end
	
	self.alpha = 1
end

function circleImageButton:getAddHeight()
	return self.h
end

function circleImageButton:setAlpha(alpha)
	self.alpha = alpha
	
	self:setSpriteAlphaOverride(alpha)
end

function circleImageButton:postInit()
	self.nearbyTextFont = "pix24"
	
	self:setSize(self.circleImageSize, self.circleImageSize)
end

function circleImageButton:setQuad(quad)
	self.quad = quad
end

function circleImageButton:onMouseEntered()
	self:setCircleSprite()
	self:setAlpha(1)
end

function circleImageButton:onMouseLeft()
	self:setCircleSprite()
	self:setAlpha(1)
	
	self.mouseLeaveTimestamp = curTime
end

function circleImageButton:setNearbyTextFont(font)
	self.nearbyTextFont = font
end

function circleImageButton:setNearbyText(text)
	self.nearbyText = text
end

function circleImageButton:setNearbyTextSide(side)
	self.nearbyTextSide = side
end

function circleImageButton:showNearbyText(text)
	text = text or self.nearbyText
	
	self:killDescBox()
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:setSize(600, 0)
	self.descBox:addText(text, self.nearbyTextFont)
	
	local xPos
	
	if self.nearbyTextSide == gui.SIDES.LEFT then
		xPos = self.x - _S(self.nearbyTextSpacing) - self.descBox:getWidth()
	else
		xPos = self.x + _S(self.nearbyTextSpacing) + self.w
	end
	
	if self.expandedButton then
		self.descBox:setPos(xPos, self.y + self.h + _S(3))
	else
		self.descBox:setPos(xPos, self.y + self.h * 0.5 - self.descBox.h * 0.5)
	end
	
	self.descBox:bringUp()
end

function circleImageButton:setNextSpriteColor(...)
	circleImageButton.baseClass.setNextSpriteColor(self, ...)
	
	self.waitForNextSlot = true
end

function circleImageButton:getCircleColor(withAlpha)
	if self:isMouseOver() then
		return 101, 136, 165, 255
	end
	
	return 0, 0, 0, 200
end

function circleImageButton:canShowNearbyText()
	return true
end

function circleImageButton:onMouseEntered()
	self:queueSpriteUpdate()
	
	if self.nearbyText and self:canShowNearbyText() then
		self:showNearbyText()
	end
end

function circleImageButton:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function circleImageButton:show()
	if self.hudContainer and not self.hudContainer:getVisible() then
		return 
	end
	
	circleImageButton.baseClass.show(self)
	
	if self.buttons then
		self:showNearbyButtons()
	end
end

function circleImageButton:hide()
	circleImageButton.baseClass.hide(self)
	
	if self.buttons then
		self:hideNearbyButtons()
	end
end

function circleImageButton:onKill()
	self:killDescBox()
	
	if self.buttons then
		for key, button in ipairs(self.buttons) do
			button:kill()
		end
	end
end

function circleImageButton:clearNearbyButtons()
	if self.buttons then
		for key, buttonObject in ipairs(self.buttons) do
			buttonObject:kill()
			
			self.buttons[key] = nil
		end
		
		self.buttonFadeIn = false
		
		self:resetTotalButtonWidth()
	end
end

function circleImageButton:hideNearbyButtons()
	if self.buttons then
		for key, buttonObject in ipairs(self.buttons) do
			buttonObject:hide()
		end
	end
end

function circleImageButton:showNearbyButtons()
	if self.buttons then
		for key, buttonObject in ipairs(self.buttons) do
			buttonObject:show()
		end
	end
end

function circleImageButton:getNearbyButtons()
	return self.buttons
end

function circleImageButton:setIsExpandedButton(expanded)
	self.expandedButton = true
end

function circleImageButton:addNearbyButton(object)
	self.totalButtonX = 0
	
	if not self.buttons then
		self:resetTotalButtonWidth()
		
		self.buttons = {}
	end
	
	table.insert(self.buttons, object)
	object:setDepth(self:getDepth())
	
	local x, y = self:getPos(true)
	local width = object.w + _S(self.nearbyButtonSpacing)
	
	object:centerToElement(self, nil, true)
	object:setPos(x + self.totalButtonWidth, nil)
	object:animateFadeIn(circleImageButton.fadeInDelayPerButton * (#self.buttons - 1))
	object:setIsExpandedButton(true)
	
	self.totalButtonWidth = self.totalButtonWidth + width
end

function circleImageButton:resetTotalButtonWidth()
	self.totalButtonWidth = self.w + _S(self.nearbyButtonSpacing)
end

function circleImageButton:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function circleImageButton:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

function circleImageButton:fadeOutNearbyButtons(alsoRemove)
	if not self.buttons then
		return 
	end
	
	local buttonCount = #self.buttons
	
	for key, buttonObject in ipairs(self.buttons) do
		buttonObject:animateFadeOut((buttonCount - key) * self.fadeOutDelayPerButton)
		
		self.buttons[key] = nil
	end
	
	self:resetTotalButtonWidth()
	sound:play("hud_buttons_hide")
end

function circleImageButton:animateFadeIn(delay)
	if self.alphaFadeInDelay then
		return 
	end
	
	self.alphaFadeInDelay = curTime + delay
	self.alphaFadeOutDelay = nil
	
	self:updateSpriteAlphas()
end

function circleImageButton:animateFadeOut(delay)
	if self.alphaFadeOutDelay then
		return 
	end
	
	self.alphaFadeOutDelay = curTime + delay
	self.alphaFadeInDelay = nil
	
	self:updateSpriteAlphas()
end

function circleImageButton:updateSpriteAlphas()
	if self.allocatedSprites then
		self:queueSpriteUpdate()
	end
end

function circleImageButton:think()
	if self.alphaFadeOutDelay and curTime > self.alphaFadeOutDelay then
		local last = self.alpha
		
		self:setAlpha(math.approach(self.alpha, 0, frameTime * self.alphaFadeOutTime))
		
		if last ~= self.alpha then
			self:updateSpriteAlphas()
		end
		
		if self.alpha == 0 then
			self:kill()
			
			return 
		end
	elseif self.alphaFadeInDelay and curTime > self.alphaFadeInDelay then
		local last = self.alpha
		
		self:setAlpha(math.approach(self.alpha, 1, frameTime * self.alphaFadeInTime))
		
		if last ~= self.alpha then
			self:updateSpriteAlphas()
		end
	end
	
	if self.buttons and #self.buttons > 0 and not gui:isLimitingClicks() and self:getDistanceToMouse() >= _S(self.startFadeWhenDistance) then
		self:fadeOutNearbyButtons()
	end
end

function circleImageButton:setupIconColor()
	if self:isMouseOver() then
		self:setNextSpriteColor(255, 255, 255, 255 * self.alpha)
	else
		self:setNextSpriteColor(100, 100, 100, 255 * self.alpha)
	end
end

function circleImageButton:setCircleSprite()
	if not self:canDraw() then
		return 
	end
	
	self:setNextSpriteColor(self:getCircleColor())
	
	self.circleSprite = self:allocateSprite(self.circleSprite, "generic_circle", 0, 0, 0, self.circleImageSize, self.circleImageSize, 0, 0, -0.1)
end

gui.register("CircleImageButton", circleImageButton)

local circleImageButtonText = {}

circleImageButtonText.textY = 0

function circleImageButtonText:setFont(font)
	self.font = font
	self.fontObject = fonts.get(font)
	self.fontHeight = self.fontObject:getHeight()
	
	self:updateText()
end

function circleImageButtonText:updateText()
	if not self.fontObject then
		return 
	end
	
	self:_updateText()
	self:updateTextDimensions()
	self:queueSpriteUpdate()
end

function circleImageButtonText:updateTextDimensions()
	local textHeight = self.fontObject:getTextHeight(self.text)
	
	self.textY = math.round(self.h * 0.5 - textHeight * 0.5)
	self.textW = self.fontObject:getWidth(self.text)
	
	if self.nearbyTextSide == gui.SIDES.LEFT then
		self.textX = -(self.fontObject:getWidth(self.text) + _S(self.nearbyTextSpacing) * 2)
	else
		self.textX = _S(self.circleImageSize) + _S(self.nearbyTextSpacing)
	end
end

function circleImageButtonText:setSize(w, h)
	circleImageButtonText.baseClass.setSize(self, w, h)
	self:updateText()
end

function circleImageButtonText:_updateText()
end

function circleImageButtonText:onMouseEntered()
	circleImageButtonText.baseClass.onMouseEntered(self)
	self:queueSpriteUpdate()
end

function circleImageButtonText:onMouseLeft()
	circleImageButtonText.baseClass.onMouseLeft(self)
	self:queueSpriteUpdate()
end

function circleImageButtonText:show()
	circleImageButtonText.baseClass.show(self)
	
	if self.requiresPanelUpdate then
		self:queueSpriteUpdate()
	end
end

function circleImageButtonText:updateBackgroundPanel()
	if not self:canDraw() then
		self.requiresPanelUpdate = true
		
		return 
	end
	
	if not self.text then
		self:updateText()
	end
	
	local textHeight = self.fontObject:getTextHeight(self.text)
	
	if not self:canDisplayText() then
		self:setNextSpriteColor(0, 0, 0, 0)
	else
		self:setNextSpriteColor(10, 10, 10, 200)
	end
	
	self.backgroundSprites = self:allocateRoundedRectangle(self.backgroundSprites, self.textX, self.textY, _US(self.textW) + 10, _US(textHeight) + 1, 4, -0.5)
	self.requiresPanelUpdate = nil
end

function circleImageButtonText:updateSprites()
	circleImageButtonText.baseClass.updateSprites(self)
	self:setCircleSprite()
	self:updateBackgroundPanel()
end

function circleImageButtonText:getBoxBottom()
	return self.textY + self.fontObject:getTextHeight(self.text)
end

function circleImageButtonText:getBoxLeft()
	return _S(85)
end

function circleImageButtonText:canDisplayText()
	if not self.text or self.text == "" then
		return false
	end
	
	if self.nearbyText and self:isMouseOver() then
		return false
	end
	
	if self.buttons and #self.buttons > 0 then
		return false
	end
	
	return true
end

function circleImageButtonText:draw(w, h)
	if self:canDisplayText() then
		love.graphics.setFont(self.fontObject)
		love.graphics.printST(self.text, self.textX + _S(5), self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
	end
end

gui.register("CircleImageButtonText", circleImageButtonText, "CircleImageButton")

local timeHUDElement = {}

timeHUDElement.circleImageSize = 78
timeHUDElement.timeAdjustmentElementWidth = 30
timeHUDElement.timeAdjustmentElementHeight = 32
timeHUDElement.interButtonSpacing = 5
timeHUDElement.interButtonSpacingY = 10
timeHUDElement.CATCHABLE_EVENTS = {
	timeline.EVENTS.SPEED_CHANGED,
	timeline.EVENTS.NEW_TIMELINE
}
timeHUDElement.SPEED_PAUSE_ID = "speed_pause"
timeHUDElement.SPEED_ONE_ID = "speed_1"
timeHUDElement.SPEED_THREE_ID = "speed_3"
timeHUDElement.SPEED_FIVE_ID = "speed_5"

function timeHUDElement:init()
	self.speedAdjustButtons = {}
	
	self:setFont("pix28")
	self:setNearbyText(_T("GOALS_AND_DEADLINES", "Goals & deadlines"))
	self:createButtons()
end

function timeHUDElement:canHide()
	return not self.remainOnPopup
end

function timeHUDElement:getAddHeight()
	return self.h + _S(self.timeAdjustmentElementHeight)
end

function timeHUDElement:handleEvent(event)
	self:updateDisplay()
end

function timeHUDElement:onClick()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = game.createTimelineMenu()
end

function timeHUDElement:updateDisplay()
	self:updateText()
end

function timeHUDElement:onKill()
	timeHUDElement.baseClass.onKill(self)
	
	for key, button in ipairs(self.speedAdjustButtons) do
		button:kill()
		
		self.speedAdjustButtons[key] = nil
	end
end

function timeHUDElement:setCanClick(state)
	timeHUDElement.baseClass.setCanClick(self, state)
	
	if not state then
		for key, button in ipairs(self.speedAdjustButtons) do
			button:hide()
		end
	else
		for key, button in ipairs(self.speedAdjustButtons) do
			button:show()
		end
	end
end

function timeHUDElement:hide()
	timeHUDElement.baseClass.hide(self)
	
	for key, button in ipairs(self.speedAdjustButtons) do
		button:hide()
	end
end

function timeHUDElement:show()
	timeHUDElement.baseClass.show(self)
	
	for key, button in ipairs(self.speedAdjustButtons) do
		button:show()
	end
end

function timeHUDElement:createButtons()
	self:addButton(0, "speed_pause", timeHUDElement.SPEED_PAUSE_ID)
	self:addButton(1, "speed_1", timeHUDElement.SPEED_ONE_ID)
	self:addButton(3, "speed_3", timeHUDElement.SPEED_THREE_ID)
	self:addButton(5, "speed_5", timeHUDElement.SPEED_FIVE_ID)
end

function timeHUDElement:updateTextDimensions()
	timeHUDElement.baseClass.updateTextDimensions(self)
	self:updateButtons()
end

function timeHUDElement:addButton(speed, icon, id)
	local button = gui.create("SpeedAdjustmentButton")
	
	button:setSpeed(speed)
	button:setID(id)
	button:setSize(timeHUDElement.timeAdjustmentElementWidth, timeHUDElement.timeAdjustmentElementHeight)
	button:setIcon(icon)
	table.insert(self.speedAdjustButtons, button)
end

function timeHUDElement:updateButtons()
	local scaledPad = _S(timeHUDElement.interButtonSpacing)
	local scaledPadVert = _S(timeHUDElement.interButtonSpacingY)
	
	self.buttonX = scaledPad + _S(timeHUDElement.circleImageSize)
	
	local relX, relY = self:getPos(true)
	
	for key, button in ipairs(self.speedAdjustButtons) do
		button:setPos(relX + self.buttonX, relY + self:getBoxBottom() + scaledPadVert)
		
		self.buttonX = self.buttonX + button.w + scaledPad
	end
end

function timeHUDElement:updateSprites()
	timeHUDElement.baseClass.updateSprites(self)
	
	self.clockSprite = self:allocateSprite(self.clockSprite, "clock_base", _S(3), _S(3), 0, 72, 72)
	
	self:updateArrows()
end

function timeHUDElement:updateArrows()
	local scaledOffset = _S(39)
	local tau = math.pi * 2
	
	self.weekArrowSprite = self:allocateSprite(self.weekArrowSprite, "clock_pointer_week", scaledOffset, scaledOffset, -timeline:getWeekProgress() * tau, 3, 21, 1, 19)
	self.monthArrowSprite = self:allocateSprite(self.monthArrowSprite, "clock_pointer_month", scaledOffset, scaledOffset, -timeline:getMonthProgress() * tau, 3, 18, 1, 16)
	self.yearArrowSprite = self:allocateSprite(self.yearArrowSprite, "clock_pointer_year", scaledOffset, scaledOffset, timeline:getYearProgress() * tau, 3, 15, 1, 12)
end

function timeHUDElement:_updateText()
	self.text = string.easyformatbykeys(_T("TIME_DISPLAY_LAYOUT", "YEAR/MONTH\nWeek WEEK, xTIMESCALE"), "YEAR", timeline:getYear(), "MONTH", timeline:getMonth(), "WEEK", timeline:getWeek(), "TIMESCALE", timeline:getSpeed())
end

function timeHUDElement:draw(w, h)
	if self.time ~= timeline.curTime then
		self:updateArrows()
	end
	
	self.time = timeline.curTime
	
	timeHUDElement.baseClass.draw(self, w, h)
end

gui.register("TimeHUDElement", timeHUDElement, "CircleImageButtonText")

local fundsHUDElement = {}

fundsHUDElement.circleImageSize = 60
fundsHUDElement.CATCHABLE_EVENTS = {
	studio.EVENTS.FUNDS_CHANGED,
	studio.EVENTS.FUNDS_SET
}

function fundsHUDElement:init(nearbyTextSide)
	self.fundChange = 0
	
	self:setFont("pix26")
	self:setNearbyText(_T("VIEW_OFFICES_AND_EXPENSES", "View offices & expenses"))
end

function fundsHUDElement:handleEvent(event, change, newMoney)
	if event == studio.EVENTS.FUNDS_CHANGED then
		self:updateText()
		self:queueTextDisplay(change)
	elseif event == studio.EVENTS.FUNDS_SET then
		self:updateText()
	end
end

function fundsHUDElement:think()
	fundsHUDElement.baseClass.think(self)
	
	if self.requiresCreation and self:canDraw() then
		self:createTextDisplay()
	end
end

function fundsHUDElement:queueTextDisplay(change)
	if change == 0 then
		return 
	end
	
	self.fundChange = self.fundChange + change
	
	if self.fundChange ~= 0 then
		self.requiresCreation = true
	else
		self.requiresCreation = false
	end
end

function fundsHUDElement:hide()
	fundsHUDElement.baseClass.hide(self)
	
	if self.floatingFundDisplay and self.floatingFundDisplay:isValid() then
		self.floatingFundDisplay:hide()
	end
end

function fundsHUDElement:show()
	fundsHUDElement.baseClass.show(self)
	
	if self.floatingFundDisplay and self.floatingFundDisplay:isValid() then
		self.floatingFundDisplay:show()
	end
end

function fundsHUDElement:createTextDisplay()
	if not self.floatingFundDisplay or not self.floatingFundDisplay:isValid() then
		self.floatingFundDisplay = gui.create("TimedTextDisplay")
		
		self.floatingFundDisplay:addText(self:getFundChangeText(self.fundChange), self.font, self.fundChange < 0 and game.UI_COLORS.RED or game.UI_COLORS.GREEN, 0, 500)
		self.floatingFundDisplay:setDieTime(2)
		self.floatingFundDisplay:setMoveRate(3)
		self.floatingFundDisplay:setFadeInTime(0.5)
		self.floatingFundDisplay:setFadeOutTime(0.5)
		self.floatingFundDisplay:overwriteDepth(5000)
		self:updateFundDisplayPosition()
		
		self.requiresCreation = false
		self.fundChange = 0
	end
end

function fundsHUDElement:kill()
	fundsHUDElement.baseClass.kill(self)
	
	if self.floatingFundDisplay and self.floatingFundDisplay:isValid() then
		self.floatingFundDisplay:kill()
	end
end

function fundsHUDElement:getFundDisplayPosition()
	local ownX, ownY = self:getPos()
	local x
	
	if self.nearbyTextSide == gui.SIDES.LEFT then
		x = ownX - (self.floatingFundDisplay.w + _S(self.nearbyTextSpacing))
	else
		x = ownX + self.textX
	end
	
	local y = ownY
	local text
	
	if not self:isMouseOver() then
		x = x + _S(15)
		y = y - self.floatingFundDisplay.h * 0.5
		text = self.text
	else
		text = self.nearbyText
	end
	
	y = y + self.fontObject:getTextHeight(text) * 0.5 + self.textY
	x = x + self.fontObject:getWidth(text)
	
	return x, y
end

function fundsHUDElement:updateFundDisplayPosition()
	if self.floatingFundDisplay and self.floatingFundDisplay:isValid() then
		local progX, progY = self.floatingFundDisplay:getProgress()
		local x, y = self:getFundDisplayPosition()
		
		if progY == 0 then
			self.floatingFundDisplay:setStartPos(x, y + _S(24))
		end
		
		self.floatingFundDisplay:setPos(x, y + _S(24) * (1 - progY))
		self.floatingFundDisplay:setFinishPos(x, y)
	end
end

function fundsHUDElement:onMouseEntered()
	fundsHUDElement.baseClass.onMouseEntered(self)
	self:queueSpriteUpdate()
	self:updateFundDisplayPosition()
end

function fundsHUDElement:onMouseLeft()
	fundsHUDElement.baseClass.onMouseLeft(self)
	self:queueSpriteUpdate()
	self:updateFundDisplayPosition()
end

function fundsHUDElement:getFundChangeText(change)
	if change > 0 then
		return string.easyformatbykeys(_T("POSITIVE_FUND_CHANGE", "+CHANGE"), "CHANGE", string.roundtobigcashnumber(change))
	elseif change == 0 then
		return _T("NO_FUND_CHANGE", "$0")
	else
		return string.easyformatbykeys(_T("NEGATIVE_FUND_CHANGE", "-CHANGE"), "CHANGE", string.roundtobigcashnumber(math.abs(change)))
	end
end

function fundsHUDElement:_updateText()
	self.text = string.easyformatbykeys(_T("FUND_DISPLAY", "FUNDS\nMonth: CHANGE"), "FUNDS", studio:getFundsText(), "CHANGE", self:getFundChangeText(studio:getFundChange()))
end

function fundsHUDElement:setCanClick(canClick)
	fundsHUDElement.baseClass.setCanClick(self, canClick)
	
	if not canClick then
		self:setNearbyText(_T("CURRENT_FINANCIAL_SITUATION", "Current financial situation"))
	end
end

function fundsHUDElement:onClick()
	if self.canClick then
		monthlyCost.createMenu()
	end
end

function fundsHUDElement:updateSprites()
	fundsHUDElement.baseClass.updateSprites(self)
	self:setupIconColor()
	
	self.fundsSprite = self:allocateSprite(self.fundsSprite, "wad_of_cash", _S(9), _S(8), 0, 44, 44)
end

gui.register("FundsHUDElement", fundsHUDElement, "CircleImageButtonText")

local projectsHUDElement = {}

projectsHUDElement.circleImageSize = 40
projectsHUDElement.handleEvent = false

function projectsHUDElement:init()
	projectsHUDElement.baseClass.init(self)
	self:setNearbyText(_T("PROJECTS", "Projects"))
end

function projectsHUDElement:onClick()
	projectsMenu:open()
end

function projectsHUDElement:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.projectSprite = self:allocateSprite(self.projectSprite, "hud_menu_projects", _S(8), _S(8), 0, self.rawW - 12, nil)
end

gui.register("ProjectsHUDElement", projectsHUDElement, "CircleImageButton")

local employeesHUDElement = {}

employeesHUDElement.circleImageSize = 40
employeesHUDElement.handleEvent = false

function employeesHUDElement:init()
	self:setNearbyText(_T("EMPLOYEES", "Employees"))
end

function employeesHUDElement:onMouseEntered()
	self:setNearbyText(_format(_T("EMPLOYEES_WITH_COUNTER", "Employees (EMPLOYEES)"), "EMPLOYEES", #studio:getEmployees()))
	employeesHUDElement.baseClass.onMouseEntered(self)
end

function employeesHUDElement:canShowNearbyText()
	return not self.buttonFadeIn
end

function employeesHUDElement:fadeOutNearbyButtons()
	employeesHUDElement.baseClass.fadeOutNearbyButtons(self)
	
	self.buttonFadeIn = false
end

function employeesHUDElement:onClick()
	self:killDescBox()
	
	self.buttonFadeIn = not self.buttons or #self.buttons == 0
	
	if not self.buttonFadeIn then
		self:fadeOutNearbyButtons()
	else
		self:expandOptions()
	end
end

function employeesHUDElement:expandOptions()
	self:clearNearbyButtons()
	
	local hireEmployeesButton = gui.create("NewEmployeesHUDElement")
	
	hireEmployeesButton:setSize(32, 32)
	hireEmployeesButton:setID(mainHUD.JOB_SEEKERS_MENU_ID)
	self:addNearbyButton(hireEmployeesButton)
	
	local manageEmployeesElement = gui.create("ManageEmployeesHUDElement")
	
	manageEmployeesElement:setSize(32, 32)
	self:addNearbyButton(manageEmployeesElement)
	sound:play("hud_buttons_show")
	events:fire(mainHUD.EVENTS.SHOWING_EMPLOYEE_BUTTONS)
end

function employeesHUDElement:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.employeesSprite = self:allocateSprite(self.employeesSprite, "hud_employees", _S(10), _S(6), 0, self.rawW - 14, nil)
end

gui.register("EmployeesHUDElement", employeesHUDElement, "CircleImageButton")

local newEmployeesHUDElement = {}

newEmployeesHUDElement.circleImageSize = 32

function newEmployeesHUDElement:init()
	self:setNearbyText(_T("HIRE_EMPLOYEES", "Hire employees"))
	self:setAlpha(0)
end

function newEmployeesHUDElement:onMouseEntered()
	self:setNearbyText(_format(_T("HIRE_EMPLOYEES_COUNTER", "Hire employees (EMPLOYEES)"), "EMPLOYEES", #employeeCirculation:getJobSeekers()))
	newEmployeesHUDElement.baseClass.onMouseEntered(self)
end

function newEmployeesHUDElement:onClick()
	employeeCirculation:toggleMenu()
	events:fire(mainHUD.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

function newEmployeesHUDElement:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.employeeSprite = self:allocateSprite(self.employeeSprite, "hud_hire_employees", _S(4), _S(4), 0, 24, nil)
end

gui.register("NewEmployeesHUDElement", newEmployeesHUDElement, "CircleImageButton")

local manageEmployeesHUDElement = {}

manageEmployeesHUDElement.circleImageSize = 32

function manageEmployeesHUDElement:init()
	self:setNearbyText(_T("EMPLOYEE_MANAGEMENT_AND_ACTIVITIES", "Employee management & activities"))
	self:setAlpha(0)
end

function manageEmployeesHUDElement:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.employeeSprite = self:allocateSprite(self.employeeSprite, "hud_employee_management", _S(2), _S(5), 0, 30, nil)
end

function manageEmployeesHUDElement:onClick()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = game.createTeamManagementMenu()
	
	events:fire(mainHUD.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

gui.register("ManageEmployeesHUDElement", manageEmployeesHUDElement, "CircleImageButton")

local propertyHUDElement = {}

propertyHUDElement.circleImageSize = 40

function propertyHUDElement:init()
	self:setFont("pix24")
	self:updateNearbyText()
end

function propertyHUDElement:handleEvent(event)
	if event == studio.EVENTS.REPUTATION_CHANGED or event == studio.EVENTS.REPUTATION_SET then
		self:updateText()
	elseif event == rivalGameCompanies.EVENTS.LOCKED or event == rivalGameCompanies.EVENTS.UNLOCKED then
		self:updateNearbyText()
	end
end

function propertyHUDElement:canDisplayText()
	return not self.buttonFadeIn and propertyHUDElement.baseClass.canDisplayText(self)
end

function propertyHUDElement:updateNearbyText()
	if rivalGameCompanies:isLocked() then
		self:setNearbyText(_T("PROPERTY", "Property"))
	else
		self:setNearbyText(_T("PROPERTY_AND_RIVALS", "Property & rivals"))
	end
end

function propertyHUDElement:canShowNearbyText()
	return not self.buttonFadeIn
end

function propertyHUDElement:fadeOutNearbyButtons()
	propertyHUDElement.baseClass.fadeOutNearbyButtons(self)
	
	self.buttonFadeIn = false
	
	self:queueSpriteUpdate()
end

function propertyHUDElement:onClick()
	self:killDescBox()
	
	self.buttonFadeIn = not self.buttons or #self.buttons == 0
	
	if not self.buttonFadeIn then
		self:fadeOutNearbyButtons()
	else
		self:expandOptions()
		events:fire(mainHUD.EVENTS.SHOWING_PROPERTY_BUTTONS)
	end
end

function propertyHUDElement:expandOptions()
	self:clearNearbyButtons()
	
	local propertyButton = gui.create("PropertyOptionHUDElement")
	
	propertyButton:setSize(32, 32)
	propertyButton:setID(mainHUD.PROPERTY_BUTTON_ID)
	self:addNearbyButton(propertyButton)
	
	local assignment = gui.create("EmployeeAssignmentHUDElement")
	
	assignment:setSize(32, 32)
	self:addNearbyButton(assignment)
	
	local rivalsButton = gui.create("RivalsOptionHUDElement")
	
	rivalsButton:setSize(32, 32)
	rivalsButton:setID(mainHUD.RIVALS_BUTTON_ID)
	self:addNearbyButton(rivalsButton)
	sound:play("hud_buttons_show")
end

function propertyHUDElement:updateSprites()
	propertyHUDElement.baseClass.updateSprites(self)
	self:setCircleSprite()
	self:setupIconColor()
	
	self.propertySprite = self:allocateSprite(self.propertySprite, "hud_property", _S(6), _S(6), 0, self.rawW - 12, nil)
end

function propertyHUDElement:_updateText()
	local repText = string.roundtobignumber(studio:getReputation())
	
	if type(repText) == "number" then
		repText = math.round(repText)
	end
	
	self.text = string.easyformatbykeys(_T("REPUTATION_DISPLAY", "Reputation: REPUTATION"), "REPUTATION", repText)
end

gui.register("PropertyHUDElement", propertyHUDElement, "CircleImageButtonText")

local propertyOption = {}

propertyOption.circleImageSize = 32

function propertyOption:init()
	self:setNearbyText(_T("EXPAND_OFFICE", "Expand office"))
	self:setAlpha(0)
end

function propertyOption:onClick()
	studio.expansion:createMenu()
	events:fire(mainHUD.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

function propertyOption:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.expansionSprite = self:allocateSprite(self.expansionSprite, "expansion", _S(3), _S(3), 0, 24, 24)
end

gui.register("PropertyOptionHUDElement", propertyOption, "CircleImageButton")

local employeeAssignmentHUD = {}

employeeAssignmentHUD.circleImageSize = 32

function employeeAssignmentHUD:init()
	self:setNearbyText(_T("EMPLOYEE_ASSIGNMENT_BUTTON", "Assign employees"))
	self:setAlpha(0)
end

function employeeAssignmentHUD:onClick()
	employeeAssignment:enter()
	events:fire(mainHUD.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

function employeeAssignmentHUD:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.employeeSprite = self:allocateSprite(self.employeeSprite, "employees", _S(5), _S(3), 0, 24, 24)
end

gui.register("EmployeeAssignmentHUDElement", employeeAssignmentHUD, "CircleImageButton")

local rivalsOption = {}

rivalsOption.circleImageSize = 32

function rivalsOption:init()
	self:setNearbyText(_T("VIEW_RIVAL_GAME_COMPANIES", "View rivals"))
	self:setAlpha(0)
end

function rivalsOption:onClick()
	rivalGameCompanies:createMenu()
	events:fire(mainHUD.EVENTS.NEARBY_BUTTON_CLICKED, self)
end

function rivalsOption:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.rivalSprite = self:allocateSprite(self.rivalSprite, "rivals", _S(4), _S(3), 0, 24, 24)
end

gui.register("RivalsOptionHUDElement", rivalsOption, "CircleImageButton")

local officePreferencesHUDElement = {}

officePreferencesHUDElement.circleImageSize = 40

function officePreferencesHUDElement:init()
	self:setNearbyText(_T("OFFICE_PREFERENCES", "Office preferences"))
end

function officePreferencesHUDElement:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.preferencesSprite = self:allocateSprite(self.preferencesSprite, "hud_office_preferences", _S(6), _S(9), 0, self.rawW - 12, nil)
end

function officePreferencesHUDElement:onClick()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = preferences:createPopup()
end

gui.register("OfficePreferencesHUDElement", officePreferencesHUDElement, "CircleImageButton")

local objectivesHUDElement = {}

objectivesHUDElement.circleImageSize = 40
objectivesHUDElement.CATCHABLE_EVENTS = {
	objectiveHandler.EVENTS.FILLED_OBJECTIVES
}

function objectivesHUDElement:init()
	self:setNearbyText(_T("OBJECTIVES", "Objectives"))
end

function objectivesHUDElement:handleEvent(event)
	if event == objectiveHandler.EVENTS.FILLED_OBJECTIVES then
		if #objectiveHandler:getObjectives() == 0 then
			self:disableRendering()
			self.hudContainer:repositionAllButtons()
		else
			self:enableRendering()
			self.hudContainer:repositionAllButtons()
		end
	end
end

function objectivesHUDElement:onClick()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = game.createObjectivesMenu()
end

function objectivesHUDElement:updateSprites()
	self:setCircleSprite()
	self:setupIconColor()
	
	self.objectivesSprite = self:allocateSprite(self.objectivesSprite, "hud_objectives", _S(9), _S(4), 0, self.rawW - 18)
end

gui.register("ObjectivesHUDElement", objectivesHUDElement, "CircleImageButton")

local mainMenuButton = {}

mainMenuButton.circleImageSize = 40

function mainMenuButton:init()
	self:setNearbyText(_T("MAIN_MENU", "Main menu"))
end

function mainMenuButton:onClick()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = mainMenu:createInGameMenu()
end

function mainMenuButton:updateSprites()
	self:setCircleSprite()
	self:setNextSpriteColor(130, 158, 204, 255)
	self:setupIconColor()
	
	self.mainMenuSprite = self:allocateSprite(self.mainMenuSprite, "hud_main_menu", _S(3), _S(3), 0, self.rawW - 6, self.rawH - 6)
end

gui.register("MainMenuHUDElement", mainMenuButton, "CircleImageButton")
