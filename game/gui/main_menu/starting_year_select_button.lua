local startingYearSelect = {}

function startingYearSelect:setGametypeData(data)
	self.gametypeData = data
end

function startingYearSelect:setYearList(list)
	self.yearList = list
end

function startingYearSelect:onSelectOptionCallback()
	self.tree.baseButton:setStartingYear(self.configKey)
end

function startingYearSelect:fillInteractionComboBox(comboBox)
	comboBox.baseButton = self
	
	for key, year in ipairs(self.yearList) do
		local option = comboBox:addOption(0, 0, self.rawW, 18, year, fonts.get("pix20"), startingYearSelect.onSelectOptionCallback)
		
		option.configKey = key
	end
	
	local x, y = self:getPos(true)
	
	comboBox:setPos(x, y + self.h)
end

function startingYearSelect:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, 0, 0)
	end
end

function startingYearSelect:setStartingYear(yearID)
	self.gametypeData:setStartingYear(yearID)
	self:updateText()
end

function startingYearSelect:updateText()
	local yearIndex = self.gametypeData:getStartingYear()
	
	if yearIndex then
		self:setText(_format(_T("STARTING_YEAR", "Starting year: YEAR"), "YEAR", self.yearList[yearIndex]))
	else
		self:setText(_T("SELECT_STARTING_YEAR", "Select start year"))
	end
end

gui.register("StartingYearSelectButton", startingYearSelect, "Button")
