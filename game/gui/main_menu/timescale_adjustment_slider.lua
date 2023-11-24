local timeSlider = {}

timeSlider.hoverText = {
	{
		font = "bh20",
		wrapWidth = 400,
		lineSpace = 6,
		icon = "question_mark",
		iconSize = 22,
		text = _T("TIMESCALE_ADJUSTMENT_DESCRIPTION_1", "Adjust the pace at which game time passes by."),
		textColor = game.UI_COLORS.LIGHT_BLUE
	},
	{
		font = "pix18",
		wrapWidth = 400,
		text = _T("TIMESCALE_ADJUSTMENT_DESCRIPTION_2", "Reducing the timescale will make time go by slower, but the speed at which your employees work will not be affected, allowing you to do more in less time, but making the game easier.")
	}
}

function timeSlider:clickCallback(value)
	timeline:setTimescaleMultiplier(value)
end

function timeSlider:onMouseEntered()
	timeSlider.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	for key, data in ipairs(self.hoverText) do
		self.descBox:addText(data.text, data.font, data.textColor, data.lineSpace, data.wrapWidth, data.icon, data.iconSize, data.iconSize)
	end
	
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x, y - self.descBox.h - _S(5))
end

function timeSlider:onMouseLeft()
	timeSlider.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("TimescaleAdjustmentSlider", timeSlider, "Slider")
