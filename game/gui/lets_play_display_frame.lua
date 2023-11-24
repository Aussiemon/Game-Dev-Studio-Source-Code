local letsPlayDisplayFrame = {}
local lpData = advertisement:getData("lets_plays")

letsPlayDisplayFrame.CATCHABLE_EVENTS = {
	lpData.EVENTS.PLAYTHROUGH_OVER,
	lpData.EVENTS.PLAYTHROUGH_PROGRESSED,
	lpData.EVENTS.PLAYTHROUGH_EXTENDED,
	project.EVENTS.SCRAPPED_PROJECT,
	gameProject.EVENTS.GAME_OFF_MARKET
}

function letsPlayDisplayFrame:handleEvent(event, gameProj)
	if gameProj == self.project then
		if event == lpData.EVENTS.PLAYTHROUGH_OVER and self.letsPlayData.remainingVideos <= 0 or event == project.EVENTS.SCRAPPED_PROJECT or event == gameProject.EVENTS.GAME_OFF_MARKET then
			self:kill()
		else
			self:updateDisplay()
		end
	end
end

function letsPlayDisplayFrame:_updateDisplay()
	local wrapW = self.w
	
	self.rightInfo:addText(string.roundtobignumber(self.letsPlayData.totalViews), "bh16", nil, 0, wrapW)
	self.rightInfo:addText(self.letsPlayData.totalVideos, "bh16", nil, 0, wrapW)
	self.rightInfo:addText(self.letsPlayData.remainingVideos, "bh16", nil, 0, wrapW)
	self.rightInfo:addText(string.roundtobignumber(self.letsPlayData.viewData[#self.letsPlayData.viewData] or 0), "bh16", nil, 0, wrapW)
end

function letsPlayDisplayFrame:setData(gameProj)
	self.project = gameProj
	self.letsPlayData = gameProj:getFact(advertisement:getData("lets_plays").dataFact)
	
	self.barDisplay:setDisplayData(self.letsPlayData.viewData)
	
	local scaledWrapWidth = self.w - _S(10)
	
	self.leftInfo:addText(_format(_T("GAME_NAME_IN_QUOTES", "'NAME'"), "NAME", string.cutToWidth(self.project:getName(), fonts.get("bh18"), self.w - _S(5))), "bh18", nil, 0, self.rawW)
	self.rightInfo:setY(self.leftInfo.h - _S(2))
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("TOTAL_VIEWS", "Total views"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "views",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("VIDEOS_MADE", "Videos made"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "story_quality",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("REMAINING_VIDEOS", "Remaining videos"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "increase",
			x = 1
		}
	})
	self:cycleLineColor(self.leftInfo, scaledWrapWidth)
	self.leftInfo:addText(_T("VIEWS_THIS_WEEK", "Views this week"), "bh16", nil, 0, self.rawW, {
		{
			width = 12,
			height = 12,
			y = 0,
			icon = "views",
			x = 1
		}
	})
	self.leftInfo:setY(5)
	self.barDisplay:setSize(self.rawW - 11, 40)
	self.barDisplay:setPos(_S(5), self.leftInfo.y + self.leftInfo.h + _S(3))
	self:setHeight(_US(self.barDisplay.y + self.barDisplay.h) + 5)
	self:updateDisplay()
end

gui.register("LetsPlayDisplayFrame", letsPlayDisplayFrame, "ProjectInfoBarDisplayFrame")
