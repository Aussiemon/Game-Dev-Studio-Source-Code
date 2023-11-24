local monthlyExpenses = {}

function monthlyExpenses:init()
	self.employeeExpenses = studio:getMonthlyEmployeeSalaries()
	self.studioExpenses = studio:getMonthlyCostAmount()
	self.serverFee = serverRenting:getPlayerFee()
	self.serverCosts = serverRenting:getActiveMMOFee()
	self.customerSupport = serverRenting:getCustomerSupportCost()
	self.overallExpenses = studio:getOverallExpenses() + self.serverFee + self.serverCosts + self.customerSupport
	
	self:setCost(self.overallExpenses)
end

function monthlyExpenses:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	local wrapWidth = 400
	
	self.descBox:addText(_T("EXPENSES_BREAKDOWN", "Expenses breakdown"), "bh18", nil, 10, wrapWidth, "wad_of_cash_minus", 24, 24)
	self.descBox:addText(string.easyformatbykeys(_T("TOTAL_OFFICE_EXPENSES_DISPLAY", "Office expenses: $EXPENSE (PERCENTAGE%)"), "EXPENSE", string.comma(self.studioExpenses), "PERCENTAGE", math.round(self.studioExpenses / self.overallExpenses * 100, 1)), "bh18", nil, 0, wrapWidth)
	self.descBox:addText(string.easyformatbykeys(_T("EMPLOYEE_SALARIES", "Employee salaries: $SALARIES (PERCENTAGE%)"), "SALARIES", string.comma(self.employeeExpenses), "PERCENTAGE", math.round(self.employeeExpenses / self.overallExpenses * 100, 1)), "bh18", nil, 0, wrapWidth)
	
	if self.serverFee > 0 then
		self.descBox:addText(string.easyformatbykeys(_T("RENTED_SERVERS_COSTS", "Rented servers: $RENT (PERCENTAGE%)"), "RENT", string.comma(self.serverFee), "PERCENTAGE", math.round(self.serverFee / self.overallExpenses * 100, 1)), "bh18", nil, 0, wrapWidth)
	end
	
	if self.serverCosts > 0 then
		self.descBox:addText(string.easyformatbykeys(_T("MONTHLY_MMO_SERVER_COSTS", "Server running costs: $COST (PERCENTAGE%)"), "COST", string.comma(self.serverCosts), "PERCENTAGE", math.round(self.serverCosts / self.overallExpenses * 100, 1)), "bh18", nil, 0, wrapWidth)
	end
	
	if self.customerSupport > 0 then
		self.descBox:addText(string.easyformatbykeys(_T("MONTHLY_CUSTOMER_SUPPORT_COSTS", "Customer support costs: $COST (PERCENTAGE%)"), "COST", string.comma(self.customerSupport), "PERCENTAGE", math.round(self.customerSupport / self.overallExpenses * 100, 1)), "bh18", nil, 0, wrapWidth)
	end
	
	self.descBox:positionToMouse(_S(10), -(self.descBox.h + _S(10)))
end

function monthlyExpenses:getTextColor()
	return select(2, self:getStateColor())
end

gui.register("MonthlyExpensesDisplay", monthlyExpenses, "CostDisplay")
