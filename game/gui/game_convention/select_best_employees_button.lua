local bestButton = {}

bestButton.icon = "increase"
bestButton.hoverText = {
	{
		font = "bh22",
		lineSpace = 4,
		text = _T("SELECT_BEST_EMPLOYEES", "Select best employees")
	},
	{
		font = "pix18",
		text = _T("SELECT_BEST_EMPLOYEES_DESCRIPTION", "Clicking will select the most-fitting employees for the convention")
	}
}

function bestButton:setConvention(conv)
	self.convention = conv
	self.sortedByEfficiency = conv:getSortedByEfficiencyList()
end

function bestButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local convention = self.convention
		
		convention:removeDesiredEmployees()
		
		for key, employee in ipairs(self.sortedByEfficiency) do
			if convention:canEmployeeBeBooked(employee) then
				convention:addDesiredEmployee(employee)
			end
		end
	end
end

gui.register("SelectBestEmployeesButton", bestButton, "IconButton")
