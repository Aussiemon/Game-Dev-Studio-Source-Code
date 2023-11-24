local levelSearchSlider = {}

function levelSearchSlider:setSearchData(data)
	self.searchData = data
end

function levelSearchSlider:onRelease()
	self.searchData.level = self.value
	
	events:fire(employeeCirculation.EVENTS.ADJUSTED_SEARCH_PARAMETER, self.searchData)
end

gui.register("LevelSearchAdjustmentSlider", levelSearchSlider, "Slider")
