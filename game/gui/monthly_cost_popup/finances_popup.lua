local financesFrame = {}

financesFrame.entryFont = "bh18"
financesFrame.totalFont = "bh20"
financesFrame.headerWidth = 150
financesFrame.entryWidth = 110
financesFrame.monthSpacing = 0
financesFrame.totalSpacing = 16
financesFrame.skinPanelFillColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR
financesFrame.skinPanelHoverColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR

function financesFrame:init()
	self.baseTypeDisplay = gui.create("GenericDescbox", self)
	
	self.baseTypeDisplay:setShowRectSprites(false)
	self.baseTypeDisplay:setFadeInSpeed(0)
	
	local baseY = _S(34)
	local fontHeight = fonts.get(self.entryFont):getHeight()
	local monthSpacing = _S(self.monthSpacing)
	
	self.baseTypeDisplay:setPos(_S(5), baseY + fontHeight + monthSpacing)
	
	local width = self.headerWidth + self.entryWidth * financeHistory.maxHistory
	local scaledEntryWidth = _S(self.entryWidth)
	local lineWidth = _S(width - 10)
	
	for key, data in ipairs(financeHistory.registered) do
		self.baseTypeDisplay:addTextLine(lineWidth, self:cycleTextLineColor())
		self.baseTypeDisplay:addText(data.display, self.entryFont, nil, 0, self.headerWidth)
	end
	
	self.baseTypeDisplay:addTextLine(lineWidth, self:cycleTextLineColor())
	self.baseTypeDisplay:addSpaceToNextText(self.totalSpacing)
	self.baseTypeDisplay:addText(_T("FINANCES_TOTAL", "Total"), self.totalFont, game.UI_COLORS.IMPORTANT_3, 0, self.headerWidth)
	
	self.history = studio:getFinanceHistory()
	
	local months = self.history:getMonths()
	local x = self.baseTypeDisplay.localX + self.baseTypeDisplay.w
	
	self.negative, self.positive, self.unchanged = _T("FINANCE_NEGATIVE", "-$VALUE"), _T("FINANCE_POSITIVE", "$VALUE"), _T("FINANCE_UNCHANGED", "$0")
	
	for key, monthData in ipairs(months) do
		local values = monthData.values
		local display = gui.create("GenericDescbox", self)
		
		display:setShowRectSprites(false)
		display:setPos(x, baseY)
		display:setFadeInSpeed(0)
		display:addText(timeline.MONTH_NAMES[monthData.month], "bh18", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, self.monthSpacing, self.entryWidth)
		
		local total = 0
		
		for key, data in ipairs(financeHistory.registered) do
			local value = values[data.id]
			local text, textColor = self:finalizeValue(value)
			
			display:addText(text, self.entryFont, textColor, 0, self.entryWidth)
			
			total = total + value
		end
		
		x = x + scaledEntryWidth
		
		local text, textColor = self:finalizeValue(total)
		
		display:addSpaceToNextText(self.totalSpacing)
		display:addText(text, self.totalFont, textColor, 0, self.entryWidth)
	end
	
	self:setSize(width + 10, _US(self.baseTypeDisplay.h) + 40 + _US(fontHeight) + self.monthSpacing)
end

function financesFrame:finalizeValue(value)
	local text, textColor
	
	if value < 0 then
		text = _format(self.negative, "VALUE", string.comma(math.abs(value)))
		textColor = game.UI_COLORS.RED
	elseif value > 0 then
		text = _format(self.positive, "VALUE", string.comma(value))
		textColor = game.UI_COLORS.GREEN
	else
		text = self.unchanged
	end
	
	return text, textColor
end

function financesFrame:cycleTextLineColor()
	self.other = not self.other
	
	return self.other and game.UI_COLORS.STAT_LINE_COLOR_ONE or game.UI_COLORS.STAT_LINE_COLOR_TWO
end

gui.register("FinancesFrame", financesFrame, "Frame")
