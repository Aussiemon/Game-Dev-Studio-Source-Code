monthlyCost.addCostText({
	iconQuad = "monthly_cost_water",
	id = "water",
	display = _T("MONTHLY_COST_WATER", "Water"),
	description = _T("MONTHLY_COST_WATER_DESCRIPTION", "The monthly fee for use of water.\nObjects like water dispensers increase monthly water cost."),
	barColor = color(135, 199, 255, 255)
})
monthlyCost.addCostText({
	iconQuad = "monthly_cost_food",
	id = "food",
	display = _T("MONTHLY_COST_FOOD", "Food"),
	description = _T("MONTHLY_COST_FOOD_DESCRIPTION", "The amount of money spent on purchasing food for the office.\nCost increases with each free food dispenser type object purchased."),
	barColor = color(255, 178, 127, 255)
})
monthlyCost.addCostText({
	iconQuad = "monthly_cost_electricity",
	id = "electricity",
	display = _T("MONTHLY_COST_ELECTRICITY", "Electricity"),
	description = _T("MONTHLY_COST_ELECTRICITY_DESCRIPTION", "The monthly fee for use of electricity used to power things including, but not limited to: the lights, AC units and computers."),
	barColor = color(255, 203, 114, 255)
})
monthlyCost.addCostText({
	iconQuad = "monthly_cost_communal",
	id = "communal",
	display = _T("MONTHLY_COST_COMMUNAL", "Communal"),
	description = _T("MONTHLY_COST_COMMUNAL_DESCRIPTION", "The monthly fee for communal services, including, but not limited to: cleaning.\nCost depends on office size and employee count."),
	barColor = color(176, 204, 128, 255)
})
monthlyCost.addCostText({
	iconQuad = "monthly_cost_misc",
	skipFinanceHistoryRegister = true,
	financeHistoryID = "misc",
	id = "miscellaneous",
	display = _T("MONTHLY_COST_MISCELLANEOUS", "Miscellaneous"),
	description = _T("MONTHLY_COST_MISCELLANEOUS_DESCRIPTION", "The monthly fee for various office items, like paper."),
	barColor = color(176, 204, 128, 255)
})
