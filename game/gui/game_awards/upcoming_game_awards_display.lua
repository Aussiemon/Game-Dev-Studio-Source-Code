local upcomingGameAwards = {}

upcomingGameAwards.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_MONTH
}

function upcomingGameAwards:createBarDisplay()
end

function upcomingGameAwards:setData(dat)
end

function upcomingGameAwards:loadData(data)
	self:fullSetup()
end

function upcomingGameAwards:registerCallback()
	gameAwards:createGameSelectionFrame()
end

function upcomingGameAwards:fillInteractionComboBox(cbox)
	gameAwards:fillInteractionComboBox(cbox)
	
	local x, y = self:getPos(true)
	
	cbox:setPos(x - _S(5) - cbox.w, y)
end

function upcomingGameAwards:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self)
	end
end

function upcomingGameAwards:handleEvent(event, contractorObj)
	if event == timeline.EVENTS.NEW_WEEK then
		self:updateDisplay()
	elseif event == timeline.EVENTS.NEW_MONTH and gameAwards:shouldDestroyUpcomingDisplay() then
		self:kill()
	end
end

function upcomingGameAwards:fullSetup()
	self.leftInfo:removeAllText()
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_T("UPCOMING_GAME_AWARDS", "Upcoming game awards"), "bh18", nil, 4, self.rawW)
	self.rightInfo:setY(self.leftInfo.h)
	self.leftInfo:addTextLine(scaledWrapWidth, game.UI_COLORS.LINE_COLOR_ONE)
	self.leftInfo:addText(_T("UPCOMING_GAME_AWARDS_TIME_UNTIL", "Time until"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "clock_full",
			x = 1
		}
	})
	self:setHeight(_US(self.leftInfo:getHeight()) + 5)
	self:updateDisplay()
	self.rightInfo:setX(self.w - self.rightInfo.w - _S(2))
end

function upcomingGameAwards:updateDisplay()
	local time = gameAwards:getStartTime()
	
	self.rightInfo:removeAllText()
	self.rightInfo:addText(timeline:getTimePeriodText(time - timeline.curTime), "bh16", nil, 0, self.rawW)
end

gui.register("UpcomingGameAwardsDisplay", upcomingGameAwards, "BarDisplayFrame")
