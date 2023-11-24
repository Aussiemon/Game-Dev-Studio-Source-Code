local upcomingContract = {}

function upcomingContract:createBarDisplay()
end

function upcomingContract:setData(contractorObj)
	self.contractor = contractorObj
	
	self:fullSetup()
end

function upcomingContract:saveData(saved)
	saved.contractor = self.contractor
	
	return saved
end

function upcomingContract:loadData(data)
	self:setData(data.contractor)
end

function upcomingContract:handleEvent(event, contractorObj)
	if event == contractor.EVENTS.BEGUN_PROJECT_SETUP and contractorObj == self.contractor then
		self:kill()
		
		return 
	end
	
	local period = self.contractor:getDelayPeriod()
	
	if not period or period == 0 then
		self:kill()
	else
		self:updateDisplay()
	end
end

function upcomingContract:fullSetup()
	self.leftInfo:removeAllText()
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_T("UPCOMING_CONTRACT", "Upcoming contract project"), "bh18", nil, 4, self.rawW)
	self.rightInfo:setY(self.leftInfo.h - _S(4))
	self.leftInfo:addTextLine(scaledWrapWidth, game.UI_COLORS.LINE_COLOR_ONE)
	self.leftInfo:addText(_T("UPCOMING_PROJECT_TIME_UNTIL", "Time until"), "bh16", nil, 0, self.rawW, {
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

function upcomingContract:updateDisplay()
	self.rightInfo:removeAllText()
	self.rightInfo:addText(timeline:getTimePeriodText(self.contractor:getDelayPeriod() * timeline.DAYS_IN_WEEK), "bh16", nil, 0, self.rawW)
end

gui.register("UpcomingContractDisplay", upcomingContract, "BarDisplayFrame")
