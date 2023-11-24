local expendituresSlider = {}

function expendituresSlider:formatText(value)
	if value then
		self:setText(string.easyformatbykeys(self.baseText, "SLIDER_VALUE", string.comma(value * self.valueMult)))
	end
end

function expendituresSlider:onRelease()
	self.searchData.budget = self.value
	
	events:fire(employeeCirculation.EVENTS.ADJUSTED_SEARCH_PARAMETER, self.searchData)
end

function expendituresSlider:getTextColor()
	if studio:getFunds() < self.searchData.budget then
		return game.UI_COLORS.RED
	end
	
	return select(2, self:getStateColor())
end

gui.register("ExpendituresAdjustmentSlider", expendituresSlider, "LevelSearchAdjustmentSlider")
