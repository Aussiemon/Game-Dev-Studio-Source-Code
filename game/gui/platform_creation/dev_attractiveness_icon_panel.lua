local devAtt = {}

devAtt.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.LICENSE_COST_SET,
	playerPlatform.EVENTS.COST_SET
}

function devAtt:handleEvent(event, data1, data2)
	if event == playerPlatform.EVENTS.COST_SET and data1 == self.platform then
		self:updateText()
	elseif event == playerPlatform.EVENTS.LICENSE_COST_SET and data2 == self.platform then
		self:updateText()
	end
end

function devAtt:setPlatform(plat)
	self.platform = plat
	
	self:updateHoverText()
end

function devAtt:updateHoverText()
	self.hoverText[3].text = _format(_T("PLATFORM_DEV_ATTRACT_DESC_3", "Maximum developers at once: MAX"), "MAX", self.platform:getMaxDevs())
end

devAtt.hoverText = {
	{
		font = "bh18",
		wrapWidth = 350,
		lineSpace = 5,
		text = _T("PLATFORM_DEV_ATTRACT_DESC_1", "Indicates how attractive the platform is to game developers.")
	},
	{
		iconHeight = 22,
		wrapWidth = 350,
		icon = "question_mark",
		iconWidth = 22,
		font = "bh18",
		lineSpace = 6,
		text = _T("PLATFORM_DEV_ATTRACT_DESC_2", "A higher value means more developers will be interested in making games for your platform."),
		textColor = game.UI_COLORS.LIGHT_BLUE
	},
	{
		font = "bh18",
		iconHeight = 22,
		wrapWidth = 350,
		iconWidth = 22,
		icon = "employees"
	}
}

function devAtt:updateText()
	local attr = self.platform:getDeveloperAttractiveness()
	local prev = self.prevAttr
	
	if prev then
		if prev < attr then
			self:flickerGradient(game.UI_COLORS.GREEN, 2)
		elseif attr < prev then
			self:flickerGradient(game.UI_COLORS.RED, 2)
		end
	end
	
	self:setText(_format(_T("PLATFORM_DEVELOPER_ATTRACTIVENESS", "Developer attractiveness: ATTR pts."), "ATTR", math.round(attr, 1)))
	self:updateHoverText()
	
	self.prevAttr = attr
end

gui.register("DevAttractivenessIconPanel", devAtt, "GradientIconPanel")
