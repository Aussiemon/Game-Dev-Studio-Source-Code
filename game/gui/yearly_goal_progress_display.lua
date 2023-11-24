local yearlyGoalProgress = {}

yearlyGoalProgress.text = "no text is set my friend!"
yearlyGoalProgress.outlineColor = color(0, 0, 0, 100)
yearlyGoalProgress.headerRectColor = color(86, 104, 135, 255)
yearlyGoalProgress.headerFailColor = color(204, 62, 40, 255)
yearlyGoalProgress.headerSucceedColor = color(149, 204, 138, 255)
yearlyGoalProgress.bgColor = color(65, 79, 102, 200)
yearlyGoalProgress.trackButtonPad = 2
yearlyGoalProgress.timeToDisappear = 7
yearlyGoalProgress._scaleVert = false
yearlyGoalProgress._inheritScalingState = false

function yearlyGoalProgress:init()
	yearlyGoalProgress.titleFont = fonts.get("bh20")
	yearlyGoalProgress.font = fonts.get("bh18")
	self.titleFontHeight = self.titleFont:getHeight() + _S(3)
	self.yearlyGoalText = _T("YEARLY_GOAL", "Yearly goal")
	
	self:setText(self.text)
	
	self.currentHeaderColor = self.headerRectColor:duplicate()
	self.canFold = true
end

function yearlyGoalProgress:makeHUDElement()
	game.addHUDElement(self)
	
	self.hudElement = true
end

function yearlyGoalProgress:kill()
	yearlyGoalProgress.baseClass.kill(self)
	
	if self.hudElement then
		game.removeHUDElement(self)
	end
	
	events:fire(yearlyGoalController.EVENTS.DISPLAY_REMOVED, self)
end

function yearlyGoalProgress:createTrackCheckbox()
	self.trackCheckbox = gui.create("YearlyGoalTrackCheckbox", self)
	
	self.trackCheckbox:setScalingState(true, true)
	self.trackCheckbox:setFont("pix22")
	self.trackCheckbox:setText(_T("TRACK", "Track"))
	self:updateCheckbox()
end

function yearlyGoalProgress:onSizeChanged()
	self:updateCheckbox()
end

function yearlyGoalProgress:updateCheckbox()
	if self.trackCheckbox then
		local scaledPad = _S(self.trackButtonPad)
		local size = _US(self.titleFontHeight) - self.trackButtonPad * 2
		
		self.trackCheckbox:setSize(size, size)
		self.trackCheckbox:setPos(self.w - scaledPad - self.trackCheckbox.w, scaledPad)
	end
end

function yearlyGoalProgress:setCanFold(can)
	self.canFold = can
end

function yearlyGoalProgress:fail()
	self.failed = true
	
	self:updateHeaderText()
	
	self.removeTime = game.time + self.timeToDisappear
end

function yearlyGoalProgress:succeed()
	self.succeeded = true
	
	self:updateHeaderText()
	
	self.removeTime = game.time + self.timeToDisappear
end

function yearlyGoalProgress:think()
	if self.removeTime and game.time > self.removeTime then
		self:kill()
	end
end

function yearlyGoalProgress:updateDimensions()
	self:setHeight(self.titleFontHeight + _S(5) * (self.folded and 0 or 1) + self.font:getHeight() * string.countlines(self.text) * (self.folded and 0 or 1))
	
	self.foldText = self.folded and "+" or "-"
	self.foldTextWidth = self.titleFont:getWidth(self.foldText)
end

function yearlyGoalProgress:updateHeaderText()
	if self.failed then
		self.yearlyGoalText = _T("YEARLY_GOAL_FAILED", "Yearly goal - FAILED!")
		self.targetHeaderColor = self.headerFailColor
	elseif self.succeeded then
		self.yearlyGoalText = _T("YEARLY_GOAL_SUCCEEDED", "Yearly goal - SUCCESS!")
		self.targetHeaderColor = self.headerSucceedColor
	end
end

function yearlyGoalProgress:setText(text)
	local wrappedText = string.wrap(text, self.font, self.w - 8)
	
	self.text = wrappedText
	
	self:updateDimensions()
end

function yearlyGoalProgress:fold()
	if not self.canFold then
		return 
	end
	
	self.folded = true
	
	self:updateDimensions()
end

function yearlyGoalProgress:onShow()
	yearlyGoalController:setCurrentGoalElement(self)
end

function yearlyGoalProgress:unfold()
	self.folded = false
	
	self:updateDimensions()
end

function yearlyGoalProgress:onClick()
	if self.folded then
		self:unfold()
	else
		self:fold()
	end
end

function yearlyGoalProgress:draw(w, h)
	if self.targetHeaderColor then
		self.currentHeaderColor:lerpColor(self.targetHeaderColor, frameTime * 10)
	end
	
	love.graphics.setColor(self.currentHeaderColor:unpack())
	love.graphics.rectangle("fill", 0, 0, w, self.titleFontHeight)
	
	if not self.folded then
		love.graphics.setColor(yearlyGoalProgress.bgColor:unpack())
		love.graphics.rectangle("fill", 0, self.titleFontHeight, w, h - self.titleFontHeight)
		love.graphics.setFont(self.font)
		love.graphics.printST(self.text, _S(4), self.titleFontHeight + _S(2), 255, 255, 255, 255, 0, 0, 0, 255)
	end
	
	love.graphics.setColor(yearlyGoalProgress.outlineColor:unpack())
	love.graphics.rectangle("line", 0, 0, w, h)
	love.graphics.setFont(self.titleFont)
	love.graphics.printST(self.yearlyGoalText, 5, 1, 255, 255, 255, 255, 0, 0, 0, 255)
	
	if self.canFold then
		love.graphics.printST(self.foldText, self.w - self.foldTextWidth - 10, 1, 255, 255, 255, 255, 0, 0, 0, 255)
	end
end

gui.register("YearlyGoalProgressDisplay", yearlyGoalProgress)
