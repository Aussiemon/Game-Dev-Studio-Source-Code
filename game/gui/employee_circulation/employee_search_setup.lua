local employeeSearchSetup = {}

employeeSearchSetup.CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.SEARCH_STARTED
}

function employeeSearchSetup:init()
	self:initNewData()
	
	self.interestButtons = {}
end

function employeeSearchSetup:initNewData()
	self.searchData = employeeCirculation:createEmployeeSearchData()
end

function employeeSearchSetup:handleEvent()
	self:initNewData()
	self.levelSlider:setSearchData(self.searchData)
	self.levelSlider:setValue(1)
	self.expendituresSlider:setSearchData(self.searchData)
	self.expendituresSlider:setValue(employeeCirculation.MIN_SEARCH_BUDGET)
	self.roleSelectionButton:setSearchData(self.searchData)
	self.roleSelectionButton:setRole(nil)
	
	for key, button in ipairs(self.interestButtons) do
		button:setSearchData(self.searchData)
		button:setSelectedInterest(nil)
	end
	
	self.jobListingButton:setSearchData(self.searchData)
end

function employeeSearchSetup:onMouseLeft()
end

function employeeSearchSetup:onMouseEntered()
end

function employeeSearchSetup:updateSprites()
end

function employeeSearchSetup:createElements()
	local scaledThree = _S(3)
	
	self.levelSlider = gui.create("LevelSearchAdjustmentSlider", self)
	
	self.levelSlider:setFont("bh22")
	self.levelSlider:setText(_T("DESIRED_LEVEL", "Desired level: SLIDER_VALUE"))
	self.levelSlider:setMinMax(1, developer.MAX_LEVEL)
	self.levelSlider:setSize(self.rawW * 0.5 - 6, 38)
	self.levelSlider:setValue(1)
	self.levelSlider:setPos(scaledThree, scaledThree)
	self.levelSlider:setSearchData(self.searchData)
	self.levelSlider:setSliderGap(10, 3)
	
	self.expendituresSlider = gui.create("ExpendituresAdjustmentSlider", self)
	
	self.expendituresSlider:setFont("bh22")
	self.expendituresSlider:setText(_T("EXPENDITURES_AMOUNT", "Expenditures: $SLIDER_VALUE"))
	self.expendituresSlider:setMinMax(employeeCirculation.MIN_SEARCH_BUDGET, employeeCirculation.MAX_SEARCH_BUDGET)
	self.expendituresSlider:setSize(self.rawW * 0.5 - 6, 38)
	self.expendituresSlider:setValue(employeeCirculation.MIN_SEARCH_BUDGET)
	self.expendituresSlider:setPos(self.levelSlider.localX + self.levelSlider.w + scaledThree, self.levelSlider.localY)
	self.expendituresSlider:setSearchData(self.searchData)
	self.expendituresSlider:setIcon("wad_of_cash", 20, 20)
	
	local buttonY = self.levelSlider.localY + self.levelSlider.h + scaledThree
	local buttonX = scaledThree
	
	for i = 1, interests.MAX_INTERESTS do
		local button = gui.create("SearchDesiredInterest", self)
		
		button:setSize(self.rawW * 0.5 - 6, 30)
		button:setSearchData(self.searchData)
		button:setFont("pix24")
		button:setUnassignedText(_format(_T("INTEREST_COUNT", "Interest COUNT"), "COUNT", i))
		button:setPos(buttonX, buttonY)
		button:setSelectedInterest(nil)
		
		buttonX = buttonX + button.w + scaledThree
		
		table.insert(self.interestButtons, button)
	end
	
	local button = self.interestButtons[1]
	
	self.roleSelectionButton = gui.create("RoleSearchSelectionButton", self)
	
	self.roleSelectionButton:setSize(self.rawW * 0.5 - 6, 30)
	self.roleSelectionButton:setSearchData(self.searchData)
	self.roleSelectionButton:setFont("pix24")
	self.roleSelectionButton:setRole(nil)
	self.roleSelectionButton:setPos(self.levelSlider.localX, button.localY + button.h + scaledThree)
	
	self.jobListingButton = gui.create("AddJobListingButton", self)
	
	self.jobListingButton:setSize(self.rawW * 0.5 - 6, 30)
	self.jobListingButton:setSearchData(self.searchData)
	self.jobListingButton:setFont("bh24")
	self.jobListingButton:setPos(self.expendituresSlider.localX, button.localY + button.h + scaledThree)
end

gui.register("EmployeeSearchSetup", employeeSearchSetup, "GenericElement")
