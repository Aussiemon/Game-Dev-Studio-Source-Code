local actSelection = {}

actSelection.lastTime = _T("ACTIVITY_NEVER_HELD", "Never held")
actSelection.enjoymentText = _T("ACTIVITY_ENJOYMENT", "Enjoyment")
actSelection.enjoymentNumber = "???"

function actSelection:init()
	self.titleFont = fonts.get("bh24")
	self.titleFontHeight = self.titleFont:getHeight()
	self.generalFont = fonts.get("pix20")
end

function actSelection:setActivity(data)
	self.activityData = data
	self.costPerEmployee = _format(_T("COST_PER_EMPLOYEE", "Per employee: $COST"), "COST", data.costPerEmployee)
	
	local curTime = timeline.curTime
	local lastTime = studio:getActivityTime(data.id)
	
	if lastTime then
		self.lastTime = _format(_T("ACTIVITY_LAST_HELD", "Held TIME ago"), "TIME", timeline:getTimePeriodText(curTime - lastTime))
		self.enjoymentNumber = math.round(data.baseEnjoymentRating / activities.HIGHEST_ENJOYMENT * 100) .. "%"
		self.enjoyment = data.baseEnjoymentRating
	end
	
	self.lastTimeWidth = fonts.get("pix20"):getWidth(self.lastTime)
	self.enjoymentTextWidth = fonts.get("pix18"):getWidth(self.enjoymentText)
	self.enjoymentNumberWidth = fonts.get("pix18"):getWidth(self.enjoymentNumber)
end

function actSelection:isComboBoxValid()
	return self.comboBox and self.comboBox:isValid()
end

function actSelection:onKill()
	if self:isComboBoxValid() then
		self.comboBox:close()
	end
	
	self:killDescBox()
end

function actSelection:onClick(x, y, key)
	activities:createActivityConfirmationMenu(self.activityData.id)
end

function actSelection:onHide()
	self:killDescBox()
end

function actSelection:onKill()
	self:killDescBox()
end

function actSelection:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	self.activityData:setupInfoDescbox(self.descBox, 500, false)
	self.descBox:centerToElement(self)
end

function actSelection:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function actSelection:onSizeChanged()
	self.textX = _S(5) + self.h
end

function actSelection:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
	
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.enjoymentBackRect = self:allocateSprite(self.enjoymentBackRect, "generic_1px", self.w - _S(124), _S(20), 0, 120, 18, 0, 0, -0.1)
	
	if self.enjoyment then
		self:setNextSpriteColor(168, 211, 255, 255)
		
		self.enjoymentFillRect = self:allocateSprite(self.enjoymentFillRect, "vertical_gradient_75", self.w - _S(123), _S(21), 0, 118 * (self.enjoyment / activities.HIGHEST_ENJOYMENT), 16, 0, 0, -0.1)
	end
	
	local baseX, baseY = _S(2), _S(2)
	local rawH = self.rawH
	local underIconSize = rawH - 4
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, baseX, baseY, underIconSize, underIconSize, 2, -0.09)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_FILL_2:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", baseX + _S(1), baseY + _S(1), 0, underIconSize - 2, underIconSize - 2, 0, 0, -0.09)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.activityData.icon, _S(3), _S(3), 0, rawH - 6, rawH - 6, 0, 0, -0.09)
	
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.textGradientSprite = self:allocateSprite(self.textGradientSprite, "weak_gradient_horizontal", _S(2 + (self.rawH - 4)), _S(2), 0, self.rawW - 50, self.rawH - 4, 0, 0, -0.09)
end

function actSelection:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	local x = self.textX
	
	love.graphics.setFont(self.titleFont)
	love.graphics.printST(self.activityData.display, x, 0, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	love.graphics.setFont(self.generalFont)
	love.graphics.printST(self.costPerEmployee, x, self.titleFontHeight, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	love.graphics.printST(self.lastTime, w - 5 - self.lastTimeWidth, 0, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	love.graphics.setFont(fonts.get("pix18"))
	love.graphics.printST(self.enjoymentNumber, w - _S(8) - self.enjoymentNumberWidth, _S(20), textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	love.graphics.printST(self.enjoymentNumber, w - _S(8) - self.enjoymentNumberWidth, _S(20), textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	love.graphics.printST(self.enjoymentText, w - _S(120), _S(20), textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

gui.register("ActivitySelectionButton", actSelection, "Button")
