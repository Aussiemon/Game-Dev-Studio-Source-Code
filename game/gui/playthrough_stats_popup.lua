local playthroughStatsPopup = {}

playthroughStatsPopup.skinPanelFillColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
playthroughStatsPopup.skinPanelHoverColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR

function playthroughStatsPopup:think()
	local h, m, s = string.SecondsToClock(timeline:getTimePlayed())
	
	self.rightDescbox:updateTextTable(string.format("%.2d:%.2d:%.2d", h, m, s), nil, 1, nil, nil, self.descboxWidth - _S(10))
end

function playthroughStatsPopup:setupDisplay()
	local left, right, extra = self:getDescboxes()
	
	right:setAlignToRight(true)
	
	local scaledLineWidth = _S(383)
	
	left:addTextLine(scaledLineWidth, game.UI_COLORS.STAT_LINE_COLOR_ONE)
	left:addText(_T("TOTAL_PLAYTHROUGH_TIME", "Total playthrough time"), "bh20", nil, 0, 390)
	right:addText(os.date("!%H:%M:%S", timeline:getTimePlayed()), "bh20", nil, 0, 390)
	
	local stats = studio:getStats()
	
	for key, data in ipairs(playthroughStats.registeredStats) do
		left:addTextLine(scaledLineWidth, key % 2 == 0 and game.UI_COLORS.STAT_LINE_COLOR_ONE or game.UI_COLORS.STAT_LINE_COLOR_TWO)
		left:addText(data.display, "bh20", nil, 0, 390)
		right:addText(tostring(data:getDisplayText(stats:getStat(data.id))), "bh20", nil, 0, 390)
	end
	
	self.rightWidth = right.w
	
	self:addButton("pix20", _T("CLOSE", "Close", nil))
end

gui.register("PlaythroughStatsPopup", playthroughStatsPopup, "DescboxPopup")
