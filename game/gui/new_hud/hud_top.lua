local hudTop = {}

hudTop.scaler = "new_hud"
hudTop._scaleVert = true
hudTop._scaleHor = false
hudTop.extensionWidth = 250
hudTop._propagateScalingState = false
hudTop.SPEED_PAUSE_ID = "speed_pause"
hudTop.SPEED_BASE_ID = "speed_"
hudTop.SPEED_ONE_ID = "speed_1"

function hudTop:initElements()
	self.mainMenuButton = gui.create("HUDMainMenuButton", self)
	
	self.mainMenuButton:setSize(32, 32)
	self.mainMenuButton:setPos(_S(10, self.scaler), _S(8, self.scaler))
	
	self.timeDisplay = gui.create("HUDTimeBox", self)
	
	self.timeDisplay:setSize(248, 54)
	self.timeDisplay:setPos(self.w * 0.5 - self.timeDisplay.w * 0.5 + _S(20, self.scaler), _S(5, self.scaler))
	
	local offset = _S(48, self.scaler)
	
	self.opinionDisplay = gui.create("HUDOpinionDisplay", self)
	
	self.opinionDisplay:setSize(180, 41)
	self.opinionDisplay:setPos(self.timeDisplay.x - self.opinionDisplay.w - _S(32, self.scaler), _S(7, self.scaler))
	
	self.reputationDisplay = gui.create("HUDReputationDisplay", self)
	
	self.reputationDisplay:setSize(180, 41)
	self.reputationDisplay:setPos(self.opinionDisplay.x - self.reputationDisplay.w - offset, self.opinionDisplay.y)
	
	self.fundDisplay = gui.create("HUDFundDisplay", self)
	
	self.fundDisplay:setSize(180, 41)
	self.fundDisplay:setPos(self.reputationDisplay.x - self.fundDisplay.w - offset, self.reputationDisplay.y)
	
	self.timeControl = {}
	
	local x = self.timeDisplay.x + self.timeDisplay.w + _S(15, self.scaler)
	local y = _S(16, self.scaler)
	local controlPad = _S(16, self.scaler)
	
	for i = 0, 5 do
		local control = gui.create("HUDTimeControl", self)
		
		control:setPos(x, y)
		control:setSpeed(i)
		
		x = x + control.w + controlPad
		
		table.insert(self.timeControl, control)
	end
	
	local last = self.timeControl[#self.timeControl]
	local buttonY = _S(2, self.scaler)
	
	self.hintButton = gui.create("HUDHintButton", self)
	
	self.hintButton:setSize(44, 44)
	self.hintButton:setPos(last.x + last.w + _S(30, self.scaler), buttonY)
	
	local zoomY = _S(1, self.scaler)
	
	self.floorUpButton = gui.create("HUDFloorButton", self)
	
	self.floorUpButton:setSize(44, 44)
	self.floorUpButton:setPos(self.hintButton.x + self.hintButton.w + _S(32, self.scaler), zoomY)
	self.floorUpButton:setDirection(1)
	
	self.curFloorDisplay = gui.create("HUDFloorDisplay", self)
	
	self.curFloorDisplay:setSize(38, 38)
	self.curFloorDisplay:setPos(self.floorUpButton.x + self.floorUpButton.w + _S(10, self.scaler), self.floorUpButton.y + self.floorUpButton.h * 0.5 - self.curFloorDisplay.h * 0.5)
	self.curFloorDisplay:setupText()
	
	self.floorDownButton = gui.create("HUDFloorButton", self)
	
	self.floorDownButton:setSize(44, 44)
	self.floorDownButton:setPos(self.curFloorDisplay.x + self.curFloorDisplay.w + _S(10, self.scaler), zoomY)
	self.floorDownButton:setDirection(-1)
	
	self.zoomInButton = gui.create("HUDZoomButton", self)
	
	self.zoomInButton:setSize(44, 44)
	self.zoomInButton:setPos(self.floorDownButton.x + self.floorDownButton.w + _S(32, self.scaler), zoomY)
	self.zoomInButton:setDirection(1)
	
	self.zoomOutButton = gui.create("HUDZoomButton", self)
	
	self.zoomOutButton:setSize(44, 44)
	self.zoomOutButton:setPos(self.zoomInButton.x + self.zoomInButton.w + _S(60, self.scaler), zoomY)
	self.zoomOutButton:setDirection(-1)
end

function hudTop:kill()
	self.remainOnPopup = false
	
	hudTop.baseClass.kill(self)
end

function hudTop:makeTimeAlwaysDisplay()
	self.remainOnPopup = true
end

function hudTop:canHide()
	return not self.remainOnPopup
end

function hudTop:disableClicks(disableAll, keepDisabled)
	if keepDisabled then
		self.keepDisabled = keepDisabled
	end
	
	if disableAll then
		for key, child in ipairs(self.children) do
			child:setCanClick(false)
			child:setCanHover(false)
		end
	else
		for key, child in ipairs(self.children) do
			if child.disableOnFrame then
				child:setCanClick(false)
				child:setCanHover(false)
			end
		end
	end
end

function hudTop:enableClicks(reenable)
	if self.keepDisabled then
		if not reenable then
			return 
		else
			self.keepDisabled = false
		end
	end
	
	for key, child in ipairs(self.children) do
		if child.disableOnFrame then
			child:setCanClick(true)
			child:setCanHover(true)
		end
	end
end

function hudTop:updateSprites()
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.baseBar = self:allocateSprite(self.baseBar, "hud_new_top_bar", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local extW = math.floor(_S(self.extensionWidth, self.scaler))
	local midX = self.w * 0.5 - extW * 0.5
	local borderW = math.ceil(_S(4, self.scaler))
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.extensionL = self:allocateSprite(self.extensionL, "hud_new_top_bar_bottom_extension_l", midX, 0, 0, borderW, 63, 0, 0, -0.45)
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.extensionMid = self:allocateSprite(self.extensionMid, "hud_new_top_bar_bottom_extension_mid", midX + borderW, 0, 0, extW - borderW * 2, 63, 0, 0, -0.45)
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.extensionR = self:allocateSprite(self.extensionR, "hud_new_top_bar_bottom_extension_r", midX + extW - borderW, 0, 0, borderW, 63, 0, 0, -0.45)
end

gui.register("HUDTop", hudTop)

local hudTextDisplayer = {}

hudTextDisplayer.font = "bh20"
hudTextDisplayer.text = "declare :_updateText()"
hudTextDisplayer.flashSpeed = 4
hudTextDisplayer.textColor = game.UI_COLORS.WHITE

function hudTextDisplayer:initVisual()
	self.curFlashColor = color(255, 255, 255, 255)
	self.textFont = fonts.get(self.font)
	self.textObj = self:createTextObject(self.textFont, nil)
	
	self:updateText()
end

function hudTextDisplayer:flashColor(startC, endC)
	self.startColor = startC
	self.endColor = endC
	
	self.curFlashColor:lerpFromTo(0, startC, endC)
	self.textObj:clear()
	self:insertText()
	
	self.flashProgress = 0
	self.flashHold = 0.5
end

function hudTextDisplayer:think()
	if self.startColor then
		if self.flashHold > 0 then
			self.flashHold = self.flashHold - frameTime
		else
			self.curFlashColor:lerpFromTo(self.flashProgress, self.startColor, self.endColor)
			self.textObj:clear()
			self:insertText()
			
			if self.flashProgress == 1 then
				self.startColor = nil
				self.endColor = nil
				self.flashProgress = 0
				self.flashHold = 0.2
			else
				self.flashProgress = math.approach(self.flashProgress, 1, frameTime * self.flashSpeed)
			end
		end
	end
end

function hudTextDisplayer:updateText()
	self:_updateText()
	self.textObj:clear()
	self:insertText()
	self:setupTextPosition()
end

function hudTextDisplayer:getFlashColor()
	if self.startColor then
		return self.curFlashColor
	end
	
	return nil
end

function hudTextDisplayer:getTextColor()
	return self:getFlashColor() or self.textColor
end

function hudTextDisplayer:insertText()
	self.textObj:addShadowed(self.text, self:getTextColor(), 0, 0, 1)
end

function hudTextDisplayer:_updateText()
end

function hudTextDisplayer:setupTextPosition()
	self.textX, self.textY = 0, 0
end

function hudTextDisplayer:draw(w, h)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.textObj, self.textX, self.textY)
end

gui.register("HUDTextDisplayer", hudTextDisplayer)

local hudFloatingText = {}

hudFloatingText.moveSpeed = 20
hudFloatingText.horMoveSpeed = 10
hudFloatingText.horMoveSpeedFrequency = 4
hudFloatingText.textShowTime = 2
hudFloatingText.alphaApproachSpeed = 2

function hudFloatingText:init()
	self.moveProgress = math.pi * 0.5
	self.yOff = 0
	self.lifetime = self.textShowTime
	self.alpha = 1
end

function hudFloatingText:setBaseX(x)
	self.baseX = x
	self.baseY = self.y
end

function hudFloatingText:getBasePos()
	return self.baseX, self.baseY
end

function hudFloatingText:think()
	local baseX, baseY = self:getBasePos()
	local newX = baseX + math.sin(self.moveProgress * self.horMoveSpeedFrequency) * self.horMoveSpeed - self.textW * 0.5
	local dt = frameTime
	
	self.yOff = self.yOff + self.moveSpeed * dt
	
	if self.lifetime <= 0 then
		self.alpha = math.approach(self.alpha, 0, dt * self.alphaApproachSpeed)
		
		if self.alpha <= 0 then
			self:kill()
		end
	else
		self.lifetime = self.lifetime - dt
	end
	
	self:setPos(newX, baseY + self.yOff)
	
	self.moveProgress = self.moveProgress + dt
	
	local prog = self.moveProgress
	
	if prog >= math.pi then
		self.moveProgress = prog - math.pi
	end
end

function hudFloatingText:setColor(clr)
	self.color = clr
end

function hudFloatingText:setFont(font)
	self.fontObj = fonts.get(font)
end

function hudFloatingText:setText(text, textColor)
	self.text = text
	self.textObj = self:createTextObject(self.fontObj, nil)
	
	self.textObj:addShadowed(text, textColor, 0, 0, 1, 0)
	
	self.textW = self.fontObj:getWidth(self.text)
end

function hudFloatingText:draw(w, h)
	love.graphics.setColor(255, 255, 255, 255 * self.alpha)
	love.graphics.draw(self.textObj, 0, 0)
end

gui.register("HUDFloatingText", hudFloatingText)

local hudFloatingCashDisplay = {}

function hudFloatingCashDisplay:setBasePos(x, y)
	self.baseX = x
	self.baseY = y
end

function hudFloatingCashDisplay:getBasePos()
	return camera:convertToScreen(self.baseX, self.baseY)
end

gui.register("HUDFloatingCashDisplay", hudFloatingCashDisplay, "HUDFloatingText")

local hudTopBox = {}

hudTopBox.font = "bh20"
hudTopBox.scaler = "new_hud"
hudTopBox.icon = "hud_new_icon_opinion"
hudTopBox.iconSize = {
	32,
	32
}
hudTopBox.iconPad = 5
hudTopBox.windowW = 141
hudTopBox.iconYOff = 0
hudTopBox.disableOnFrame = true

function hudTopBox:insertText()
	self.textObj:setNextTextColor(self:getTextColor():unpack())
	self.textObj:add(self.text, 0, 0)
end

function hudTopBox:updateSprites()
	local size = self.iconSize
	local pad = self.iconPad
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, -_S(size[1] + pad, self.scaler), _S(self.iconYOff, self.scaler), 0, size[1], size[2], 0, 0, -0.45)
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.boxSprite = self:allocateSprite(self.boxSprite, "hud_new_window_small", 0, 0, 0, 180, 41, 0, 0, -0.4)
end

function hudTopBox:setupTextPosition()
	self.textX = _S(8, self.scaler)
	self.textY = _S(5, self.scaler)
end

function hudTopBox:hide()
	hudTopBox.baseClass.hide(self)
	self:killDescBox()
end

function hudTopBox:onMouseEntered()
	self:setupDescbox()
	self:positionDescbox()
end

function hudTopBox:onMouseLeft()
	self:killDescBox()
end

function hudTopBox:setupDescbox()
	self.descBox = gui.create("GenericDescbox")
end

function hudTopBox:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self:onClicked()
		
		return true
	end
end

function hudTopBox:onClicked()
end

function hudTopBox:positionDescbox()
	if self.descBox then
		local x, y = self:getPos(true)
		local midX = x + self.w * 0.5 - self.descBox.w * 0.5 - _S(32, self.scaler)
		local descX
		
		if midX < 0 then
			descX = x
		else
			descX = midX
		end
		
		self.descBox:setPos(descX, y + _S(60, self.scaler))
	end
end

gui.register("HUDTopBox", hudTopBox, "HUDTextDisplayer")

local hudTimeBox = {}

hudTimeBox.scaler = "new_hud"
hudTimeBox.font = "bh24"
hudTimeBox.timeBarPos = {
	8,
	8
}
hudTimeBox.timeBarSize = {
	192,
	31
}
hudTimeBox.fillColor = color(220, 234, 255, 255)
hudTimeBox.disableOnFrame = true
hudTimeBox.CATCHABLE_EVENTS = {
	timeline.EVENTS.SPEED_CHANGED,
	timeline.EVENTS.NEW_TIMELINE
}

function hudTimeBox:handleEvent()
	self:updateText()
end

function hudTimeBox:think()
	self:queueSpriteUpdate()
end

function hudTimeBox:_updateText()
	self.text = string.easyformatbykeys(_T("TIME_DISPLAY_LAYOUT", "YEAR/MONTH W WEEK"), "YEAR", timeline:getYear(), "MONTH", timeline:getMonth(), "WEEK", math.max(1, timeline:getWeek() or 1))
end

function hudTimeBox:setupTextPosition()
	self.textX = _S(103, self.scaler) - self.textFont:getWidth(self.text) * 0.5
	self.textY = _S(5, self.scaler)
end

function hudTimeBox:insertText()
	self.textObj:addShadowed(self.text, self.textColor, 0, 0, 1)
end

function hudTimeBox:updateSprites()
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.boxSprite = self:allocateSprite(self.boxSprite, "hud_new_window_time", 0, 0, 0, 248, 54, 0, 0, -0.4)
	
	local pos = self.timeBarPos
	local size = self.timeBarSize
	local x, y = _S(pos[1], self.scaler), _S(pos[2], self.scaler)
	
	self:setNextSpriteColor(self.fillColor:unpack())
	
	self.progressSprite = self:allocateSprite(self.progressSprite, "generic_1px", x, y, 0, size[1] * (1 - timeline:getWeekProgress()), size[2], 0, 0, -0.3)
end

gui.register("HUDTimeBox", hudTimeBox, "HUDTextDisplayer")

local hudFundDisplay = {}

hudFundDisplay.icon = "hud_new_icon_funds"
hudFundDisplay.iconSize = {
	30,
	27
}
hudFundDisplay.iconYOff = 6
hudFundDisplay.CATCHABLE_EVENTS = {
	studio.EVENTS.FUNDS_CHANGED,
	studio.EVENTS.FUNDS_SET
}

function hudFundDisplay:init()
	self.fundChange = 0
end

function hudFundDisplay:handleEvent(event, change)
	self:updateText()
	
	if event == studio.EVENTS.FUNDS_CHANGED then
		self.fundChange = self.fundChange + change
	end
end

function hudFundDisplay:think()
	hudFundDisplay.baseClass.think(self)
	
	local change = self.fundChange
	
	if change ~= 0 then
		if change > 0 then
			self:flashColor(game.UI_COLORS.GREEN, self.textColor)
		else
			self:flashColor(game.UI_COLORS.RED, self.textColor)
		end
		
		local elem = gui.create("HUDFloatingText")
		local x, y = self:getPos(true)
		
		elem:setPos(x, y + _S(30, self.scaler))
		elem:setBaseX(x + _S(141, self.scaler) * 0.5)
		elem:setFont("bh20")
		elem:setText(string.roundtobigcashnumber(change), change < 0 and game.UI_COLORS.RED or game.UI_COLORS.GREEN)
		elem:addDepth(10000)
		
		self.fundChange = 0
	end
end

function hudFundDisplay:_updateText()
	self.text = studio:getFundsText()
end

function hudFundDisplay:getFundChangeText(change)
	if change > 0 then
		return string.easyformatbykeys(_T("POSITIVE_FUND_CHANGE", "+CHANGE"), "CHANGE", string.roundtobigcashnumber(change))
	elseif change == 0 then
		return _T("NO_FUND_CHANGE", "$0")
	else
		return string.easyformatbykeys(_T("NEGATIVE_FUND_CHANGE", "-CHANGE"), "CHANGE", string.roundtobigcashnumber(math.abs(change)))
	end
end

function hudFundDisplay:onClicked()
	game.createFinancesPopup()
end

function hudFundDisplay:setupDescbox()
	self.descBox = gui.create("GenericDescbox")
	
	local wrapW = 450
	local change = studio:getFundChange()
	local icon = change < 0 and "money_lost" or "money_made"
	
	self.descBox:addText(_format(_T("HUD_FUNDS_DESC_1", "Change this month: CHANGE"), "CHANGE", self:getFundChangeText(change)), "bh16", nil, 3, wrapW, icon, 22, 22)
	self.descBox:addText(_T("HUD_FUNDS_DESC_2", "Click to view full report."), "bh16", nil, 0, wrapW, "question_mark", 22, 22)
end

gui.register("HUDFundDisplay", hudFundDisplay, "HUDTopBox")

local hudRepDisplay = {}

hudRepDisplay.icon = "hud_icon_new_reputation"
hudRepDisplay.iconSize = {
	32,
	31
}
hudRepDisplay.iconYOff = 4
hudRepDisplay.CATCHABLE_EVENTS = {
	studio.EVENTS.REPUTATION_CHANGED,
	studio.EVENTS.REPUTATION_SET
}

function hudRepDisplay:handleEvent()
	self:updateText()
end

function hudRepDisplay:setupDescbox()
	self.descBox = gui.create("GenericDescbox")
	
	local wrapW = 450
	
	self.descBox:addText(_T("HUD_REPUTATION_DESC_1", "Your Reputation level."), "bh16", nil, 3, wrapW, "question_mark", 22, 22)
	self.descBox:addText(_T("HUD_REPUTATION_DESC_2", "Every point of Reputation is a potential sale of any game you release."), "bh16", nil, 0, wrapW)
end

function hudRepDisplay:_updateText()
	local repText = string.roundtobignumber(studio:getReputation())
	
	if type(repText) == "number" then
		repText = math.round(repText)
	end
	
	self.text = repText
end

gui.register("HUDReputationDisplay", hudRepDisplay, "HUDTopBox")

local hudOpiDisplay = {}

hudOpiDisplay.icon = "hud_new_icon_opinion"
hudOpiDisplay.iconSize = {
	32,
	32
}
hudOpiDisplay.iconYOff = 4
hudOpiDisplay.CATCHABLE_EVENTS = {
	studio.EVENTS.OPINION_CHANGED
}
hudOpiDisplay.barXOff = 8
hudOpiDisplay.barYOff = 8
hudOpiDisplay.barW = 126
hudOpiDisplay.barH = 22
hudOpiDisplay.fillColor = color(220, 234, 255, 255)
hudOpiDisplay.textColor = color(45, 127, 174, 255)

function hudOpiDisplay:handleEvent()
	self:updateText()
	self:queueSpriteUpdate()
end

function hudOpiDisplay:_updateText()
	self.text = math.round(studio:getOpinion())
end

function hudOpiDisplay:getTextColor()
	return self:getFlashColor() or self.textColor
end

function hudOpiDisplay:insertText()
	self.textObj:setNextTextColor(self.fillColor:unpack())
	self.textObj:addShadowed(self.text, self:getTextColor(), 0, 0, 1)
end

function hudOpiDisplay:setupDescbox()
	self.descBox = gui.create("GenericDescbox")
	
	local wrapW = 300
	
	self.descBox:addText(_T("HUD_OPINION_DESC_1", "Your Opinion level. The lower the value, the more likely people are to pirate your games."), "bh16", nil, 3, wrapW, "question_mark", 22, 22)
	self.descBox:addText(_format(_T("HUD_OPINION_DESC_3", "Piracy increase below level: MINIMUM"), "MINIMUM", math.floor(gameProject:calculateMinimumOpinion(studio:getReputation()))), "bh16", nil, 0, wrapW, "exclamation_point", 22, 22)
end

function hudOpiDisplay:updateSprites()
	hudOpiDisplay.baseClass.updateSprites(self)
	
	local x, y = _S(self.barXOff, self.scaler), _S(self.barYOff, self.scaler)
	
	self:setNextSpriteColor(self.fillColor:unpack())
	
	local opiBounds = studio.OPINION
	local max = opiBounds[2] - opiBounds[1]
	local opi = studio:getOpinion() - opiBounds[1]
	
	self.barFill = self:allocateSprite(self.barFill, "generic_1px", x, y, 0, self.barW * math.min(1, opi / max), self.barH, 0, 0, -0.35)
end

function hudOpiDisplay:setupTextPosition()
	self.textX = _S(self.windowW * 0.5, self.scaler) - self.textFont:getWidth(self.text) * 0.5
	self.textY = _S(5, self.scaler)
end

gui.register("HUDOpinionDisplay", hudOpiDisplay, "HUDTopBox")

local hudMainMenuButton = {}

hudMainMenuButton.scaler = "new_hud"
hudMainMenuButton.icon = "hud_new_main_menu"
hudMainMenuButton.hoverIcon = "hud_new_main_menu_hover"
hudMainMenuButton.iconW, hudMainMenuButton.iconH = 32, 32
hudMainMenuButton.mouseOverIconColor = color(255, 255, 255, 255)
hudMainMenuButton.regularIconColor = hudMainMenuButton.mouseOverIconColor
hudMainMenuButton.disableOnFrame = true

function hudMainMenuButton:onClick(x, y, key)
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = mainMenu:createInGameMenu()
end

gui.register("HUDMainMenuButton", hudMainMenuButton, "IconButton")

local hudHintButton = {}

hudHintButton.scaler = "new_hud"
hudHintButton.icon = "hud_new_hint"
hudHintButton.hoverIcon = "hud_new_hint_hover"
hudHintButton.iconW, hudHintButton.iconH = 44, 44
hudHintButton.mouseOverIconColor = color(255, 255, 255, 255)
hudHintButton.regularIconColor = hudHintButton.mouseOverIconColor
hudHintButton.HINT_DISPLAY_TIME = 10
hudHintButton.disableOnFrame = true

function hudHintButton:onClick(x, y, key)
	if self:isMouseOver() then
		if self.descBox then
			self:killDescBox()
			
			return 
		end
		
		local hint = hintSystem:attemptShowHint()
		
		if hint then
			self.descBox = gui.create("GenericDescbox")
			
			self.descBox:addText(hint, "bh18", nil, 0, 400, "question_mark", 22, 22)
			
			local x, y = self:getPos(true)
			
			self.descBox:setPos(x + self.w * 0.5 - self.descBox.w * 0.5, y + self.h + _S(30, self.scaler))
			self.descBox:bringUp()
			
			self.descBoxLifetime = game.time + hudHintButton.HINT_DISPLAY_TIME
		end
	end
end

gui.register("HUDHintButton", hudHintButton, "IconButton")

local hudTimeControl = {}

hudTimeControl.activeColor = color(220, 234, 255, 255)
hudTimeControl.inactiveColor = color(45, 127, 174, 255)
hudTimeControl.hoverColor = color(255, 227, 199, 255)
hudTimeControl.disableOnFrame = true
hudTimeControl.icons = {
	[0] = "hud_new_pause",
	"hud_new_speed_1",
	"hud_new_speed_2",
	"hud_new_speed_3",
	"hud_new_speed_4",
	"hud_new_speed_5"
}
hudTimeControl.CATCHABLE_EVENTS = {
	timeline.EVENTS.SPEED_CHANGED,
	timeline.EVENTS.UNPAUSED_TIMELINE
}

function hudTimeControl:handleEvent(event)
	self:queueSpriteUpdate()
end

function hudTimeControl:getSpriteColor()
	if timeline:isPaused() then
		if self:isMouseOver() then
			return self.hoverColor, self.inactiveColor
		elseif self.speed == 0 then
			return self.activeColor, self.inactiveColor
		end
	elseif self:isMouseOver() then
		return self.hoverColor, self.inactiveColor
	elseif timeline:getSpeed() == self.speed then
		return self.activeColor, self.inactiveColor
	end
	
	return self.inactiveColor, self.activeColor
end

function hudTimeControl:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		timeline:attemptSetSpeed(self.speed)
	end
end

function hudTimeControl:onMouseEntered()
	self:setupDescbox()
	self:queueSpriteUpdate()
end

function hudTimeControl:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function hudTimeControl:hide()
	self:killDescBox()
	hudTimeControl.baseClass.hide(self)
end

function hudTimeControl:setupDescbox()
	self.descBox = gui.create("GenericDescbox")
	
	if self.speed == 0 then
		self.descBox:addText(_format(_T("HUD_TIME_CONTROL_PAUSE", "Pause the game."), "KEY", self.speed), "bh18", nil, 0, 400, "question_mark", 22, 22)
		self.descBox:addText(_format(_T("HUD_TIME_CONTROL_SHORTCUT", "Key binding: KEY"), "KEY", keyBinding:getNiceCommandDisplay(keyBinding.COMMANDS.TOGGLE_TIME)), "bh18", nil, 0, 400, "time_adjustment_keys", 70, 22)
	else
		self.descBox:addText(_format(_T("HUD_TIME_CONTROL_SPEED", "Set speed to xSPEED"), "SPEED", self.speed), "bh18", nil, 0, 400, "question_mark", 22, 22)
		self.descBox:addText(_format(_T("HUD_TIME_CONTROL_SHORTCUT", "Key binding: KEY"), "KEY", self.speed), "bh18", nil, 0, 400, "time_adjustment_keys", 70, 22)
	end
	
	self.descBox:setPos(self.x + self.w * 0.5 - self.descBox.w * 0.5, self.y + _S(60, self.scaler))
end

function hudTimeControl:setSpeed(speed)
	self.speed = speed
	self.icon = self.icons[speed]
	
	local quadData = quadLoader:getQuadStructure(self.icon)
	
	self.iconW, self.iconH = quadData.w, quadData.h
	
	self:setSize(self.iconW, self.iconH)
	
	if speed == 0 then
		self:setID(hudTop.SPEED_PAUSE_ID)
	else
		self:setID(hudTop.SPEED_BASE_ID .. speed)
	end
end

function hudTimeControl:updateSprites()
	local clr, clrUnder = self:getSpriteColor()
	local pixel = math.max(1, _S(1, self.scaler))
	
	self:setNextSpriteColor(clrUnder:unpack())
	
	self.spriteUnder = self:allocateSprite(self.spriteUnder, self.icon, pixel, pixel, 0, self.iconW, self.iconH, 0, 0, -0.3)
	
	self:setNextSpriteColor(clr:unpack())
	
	self.sprite = self:allocateSprite(self.sprite, self.icon, 0, 0, 0, self.iconW, self.iconH, 0, 0, -0.3)
end

gui.register("HUDTimeControl", hudTimeControl)

local hudZoomButton = {}

hudZoomButton.scaler = "new_hud"
hudZoomButton.iconW, hudZoomButton.iconH = 85, 47
hudZoomButton.mouseOverIconColor = color(255, 255, 255, 255)
hudZoomButton.regularIconColor = hudZoomButton.mouseOverIconColor
hudZoomButton.disableOnFrame = false

function hudZoomButton:setDirection(dir)
	self.direction = dir
	
	if dir == 1 then
		self.icon = "hud_new_zoom_in"
		self.hoverIcon = "hud_new_zoom_in_hover"
	else
		self.icon = "hud_new_zoom_out"
		self.hoverIcon = "hud_new_zoom_out_hover"
	end
end

function hudZoomButton:onClickDown()
end

function hudZoomButton:playClickSound(onClickState)
end

function hudZoomButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and camera:changeZoomLevel(self.direction) then
		if self.direction < 0 then
			sound:play("zoom_out", nil, nil, nil)
		else
			sound:play("zoom_in", nil, nil, nil)
		end
	end
end

gui.register("HUDZoomButton", hudZoomButton, "IconButton")

local hudFloorButton = {}

hudFloorButton.scaler = "new_hud"
hudFloorButton.iconW, hudFloorButton.iconH = 44, 44
hudFloorButton.mouseOverIconColor = color(255, 255, 255, 255)
hudFloorButton.regularIconColor = hudFloorButton.mouseOverIconColor
hudFloorButton.disableOnFrame = false

function hudFloorButton:setDirection(dir)
	self.direction = dir
	
	if dir == 1 then
		self.icon = "hud_new_floor_up"
		self.hoverIcon = "hud_new_floor_up_hover"
	else
		self.icon = "hud_new_floor_down"
		self.hoverIcon = "hud_new_floor_down_hover"
	end
end

function hudFloorButton:onClickDown()
end

function hudFloorButton:playClickSound(onClickState)
end

function hudFloorButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		camera:changeFloor(self.direction)
	end
end

function hudFloorButton:setupDescbox()
	self.descBox = gui.create("GenericDescbox")
	
	local wrapW = 300
	local key
	
	if self.direction == 1 then
		self.descBox:addText(_T("HUD_FLOOR_UP", "Floor up."), "bh16", nil, 0, wrapW, "question_mark", 22, 22)
		
		key = keyBinding.COMMANDS.FLOOR_UP
	else
		self.descBox:addText(_T("HUD_FLOOR_DOWN", "Floor down."), "bh16", nil, 0, wrapW, "question_mark", 22, 22)
		
		key = keyBinding.COMMANDS.FLOOR_DOWN
	end
	
	self.descBox:addText(_format(_T("HUD_FLOOR_KEY_BINDING", "Key binding: KEY"), "KEY", keyBinding:getNiceCommandDisplay(key)), "bh16", nil, 0, wrapW, "time_adjustment_keys", 70)
	self.descBox:setPos(self.x + self.w * 0.5 - self.descBox.w * 0.5, self.y + _S(60, self.scaler))
end

function hudFloorButton:onMouseEntered()
	self:setupDescbox()
	self:queueSpriteUpdate()
end

function hudFloorButton:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function hudFloorButton:hide()
	self:killDescBox()
	hudTimeControl.baseClass.hide(self)
end

gui.register("HUDFloorButton", hudFloorButton, "IconButton")

local hudFloorDisplay = {}

hudFloorDisplay.CATCHABLE_EVENTS = {
	camera.EVENTS.FLOOR_VIEW_CHANGED
}
hudFloorDisplay.icon = "hud_new_floor_box"
hudFloorDisplay.hoverIcon = "hud_new_floor_box"
hudFloorDisplay.mouseOverIconColor = game.UI_COLORS.WHITE
hudFloorDisplay.regularIconColor = hudZoomButton.mouseOverIconColor
hudFloorDisplay.textColor = color(220, 234, 255, 255)

function hudFloorDisplay:init()
	self.text = love.graphics.newText(fonts.get("bh24"))
end

function hudFloorDisplay:handleEvent()
	self:setupText()
end

function hudFloorDisplay:setupText()
	self.displayText = camera:getViewFloor()
	
	self.text:clear()
	self.text:setNextTextColor(self.textColor:unpack())
	self.text:add(self.displayText, 0, 0)
	
	self.textX, self.textY = math.round(self.w * 0.5 - self.text:getWidth() * 0.5), math.round(self.h * 0.5 - self.text:getHeight() * 0.5)
end

function hudFloorDisplay:draw(w, h)
	love.graphics.draw(self.text, self.textX, self.textY)
end

gui.register("HUDFloorDisplay", hudFloorDisplay, "IconButton")
