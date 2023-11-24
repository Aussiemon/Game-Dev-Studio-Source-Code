local shillingDisplayFrame = {}
local shillingData = advertisement:getData("shilling")

shillingDisplayFrame.CATCHABLE_EVENTS = {
	shillingData.EVENTS.PROGRESSED,
	shillingData.EVENTS.FINISHED,
	project.EVENTS.SCRAPPED_PROJECT,
	timeline.EVENTS.NEW_DAY
}
shillingDisplayFrame.UPDATE_ALL_EVENTS = {
	[shillingData.EVENTS.PROGRESSED] = true,
	[shillingData.EVENTS.FINISHED] = true,
	[project.EVENTS.SCRAPPED_PROJECT] = true
}

function shillingDisplayFrame:handleEvent(event, gameProj)
	if shillingDisplayFrame.UPDATE_ALL_EVENTS[event] then
		if gameProj == self.project then
			if event == shillingData.EVENTS.PROGRESSED then
				self:updateDisplay()
			else
				self:kill()
			end
		end
	elseif event == timeline.EVENTS.NEW_DAY then
		self.rightInfo:updateTextTable(math.round(self.shillData.lastsUntil - timeline.curTime), "bh16", 3)
	end
end

function shillingDisplayFrame:_updateDisplay()
	local wrapW = self.w
	
	self.rightInfo:addText(string.roundtobignumber(self.shillData.affectedPeople), "bh16", nil, 0, wrapW)
	self.rightInfo:addText(string.roundtobignumber(self.shillData.interestPerWeek[#self.shillData.interestPerWeek] or 0), "bh16", nil, 0, wrapW)
	self:updateDurationDisplay(wrapW)
	
	local bustedColor
	
	if self.shillData.foundOutShillingCount > 0 then
		self.rightInfo:addText(self.shillData.foundOutShillingCount, "bh16", game.UI_COLORS.RED, 0, wrapW, "exclamation_point_red", 12, 12)
	else
		self.rightInfo:addText(self.shillData.foundOutShillingCount, "bh16", nil, 0, wrapW)
	end
end

function shillingDisplayFrame:updateDurationDisplay(wrapW)
	self.rightInfo:addText(math.max(0, math.round(self.shillData.lastsUntil - timeline.curTime)), "bh16", nil, 0, wrapW)
end

function shillingDisplayFrame:setData(gameProj)
	self.project = gameProj
	self.shillData = gameProj:getFact(shillingData.dataFact)
	
	self.barDisplay:setDisplayData(self.shillData.interestPerWeek)
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_format(_T("SHILLING_GAME_NAME_IN_QUOTES", "Shilling - 'NAME'"), "NAME", self.project:getName()), "bh18", nil, 0, self.rawW)
	self.rightInfo:setY(self.leftInfo.h - _S(2))
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("SHILLING_POPULARITY_GAIN", "Popularity gain"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "views",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("SHILLING_GAIN_THIS_WEEK", "Gain this week"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "views",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("SHILLING_REMAINING_DAYS", "Remaining days"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "clock_full",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("SHILLING_BUSTED_ON_SITES", "Sites busted on"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "unavailable",
			x = 1
		}
	})
	self.leftInfo:setY(5)
	self.barDisplay:setSize(self.rawW - 11, 40)
	self.barDisplay:setPos(_S(5), self.leftInfo.y + self.leftInfo.h + _S(3))
	self:setHeight(_US(self.barDisplay.y + self.barDisplay.h) + 5)
	self:updateDisplay()
end

gui.register("ShillingDisplayFrame", shillingDisplayFrame, "ProjectInfoBarDisplayFrame")
