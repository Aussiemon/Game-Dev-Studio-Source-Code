monthlyCost = {}
monthlyCost.text = {}
monthlyCost.textByID = {}
monthlyCost.mtindex = {
	__index = monthlyCost
}
monthlyCost.COST_PER_EMPLOYEE_FOR_COMMUNAL = 30
monthlyCost.LOAN_INTEREST_RATE = 0.006666666666666666
monthlyCost.LOAN_CHANGE_AMOUNT = 50000
monthlyCost.MAX_LOAN = 500000

function monthlyCost.new(water, electricity, communal)
	local new = {}
	
	setmetatable(new, monthlyCost.mtindex)
	new:init(water, electricity, communal)
	
	return new
end

function monthlyCost.addCostText(data)
	table.insert(monthlyCost.text, data)
	
	monthlyCost.textByID[data.id] = data
	data.iconQuad = data.iconQuad or "electricity"
	data.financeHistoryID = data.financeHistoryID or data.id
	
	if not data.skipFinanceHistoryRegister then
		financeHistory.registerNew({
			id = data.financeHistoryID,
			display = data.display
		})
	end
end

function monthlyCost.getInterestForLoan(loan)
	return loan * monthlyCost.LOAN_INTEREST_RATE
end

function monthlyCost.getMaxLoan()
	return monthlyCost.MAX_LOAN
end

function monthlyCost.getLoanChangeAmount()
	return monthlyCost.LOAN_CHANGE_AMOUNT
end

function monthlyCost.getCostData(type)
	return monthlyCost.textByID[type]
end

function monthlyCost.createMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(450, 600)
	frame:setTitle(_T("EXPENSES_AND_BOOSTS_TITLE", "Expenses & Boosts"))
	frame:setFont(fonts.get("pix24"))
	frame:center()
	frame:setCloseKey(keyBinding:getCommandKey(keyBinding.COMMANDS.EXPENSES))
	
	local sheet = gui.create("PropertySheet", frame)
	
	sheet:setPos(_S(5), _S(33))
	sheet:setTabOffset(4, 4)
	sheet:setSize(440, 486)
	sheet:setFont(fonts.get("bh24"))
	
	local officePanel = gui.create("Panel")
	
	officePanel.shouldDraw = false
	
	officePanel:setSize(440, 456)
	
	local scrollBarPanel = gui.create("ScrollbarPanel", officePanel)
	
	scrollBarPanel:setSize(440, 456)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setSpacing(4)
	scrollBarPanel:setPadding(4, 4)
	scrollBarPanel:addDepth(100)
	
	local owned = gui.create("Category")
	
	owned:setIcon("exclamation_point")
	owned:setFont("pix26")
	owned:setText(_T("OWNED_OFFICES", "Owned offices"))
	owned:assumeScrollbar(scrollBarPanel)
	scrollBarPanel:addItem(owned)
	
	local upForSale = gui.create("Category")
	
	upForSale:setIcon("exclamation_point_yellow")
	upForSale:setFont("pix26")
	upForSale:setText(_T("BUILDINGS_UP_FOR_SALE", "Up for sale"))
	upForSale:assumeScrollbar(scrollBarPanel)
	scrollBarPanel:addItem(upForSale)
	
	local buttonWidth = scrollBarPanel.rawW - 15
	
	for key, officeObject in ipairs(game.worldObject:getBuildings()) do
		if not officeObject:isPedestrianBuilding() and not officeObject:getReserved() and not officeObject:getRivalOwner() then
			local button = gui.create("OfficeInfoButton")
			
			button:setSize(buttonWidth, 30)
			button:setFont("pix24")
			button:setOffice(officeObject)
			
			if officeObject:isPlayerOwned() then
				owned:addItem(button, true)
			else
				upForSale:addItem(button, true)
			end
		end
	end
	
	local button = sheet:addItem(officePanel, _T("OFFICES", "Offices"), 193, 26)
	
	button:addHoverText(_T("OFFICES_TAB_DESCRIPTION", "View a list of offices present on the map."), "pix20")
	
	local employeesPanel = gui.create("Panel")
	
	employeesPanel.shouldDraw = false
	
	employeesPanel:setSize(440, 456)
	
	local scrollBarPanel = gui.create("ScrollbarPanel", employeesPanel)
	
	scrollBarPanel:setSize(440, 456)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setSpacing(4)
	scrollBarPanel:setPadding(4, 4)
	scrollBarPanel:addDepth(200)
	
	local employees = studio:getEmployees()
	
	if #employees == 0 then
		local title = gui.create("Category")
		
		title:setFont("pix26")
		title:setText(_T("NO_EMPLOYEES", "No employees"))
		scrollBarPanel:addItem(title)
	else
		for key, employee in ipairs(studio:getEmployees()) do
			local managementButton = gui.create("EmployeeTeamAssignmentButton")
			
			managementButton:setFont(fonts.get("pix20"))
			managementButton:setSize(392, 40)
			managementButton:setEmployee(employee)
			managementButton:setThoroughDescription(true)
			scrollBarPanel:addItem(managementButton)
		end
	end
	
	local button = sheet:addItem(employeesPanel, _T("EMPLOYEES", "Employees"), 193, 26)
	
	button:addHoverText(_T("EMPLOYEE_EXPENSES_TAB_DESCRIPTION", "Check the amount of funds spent on employee salaries each month."), "pix20")
	
	local expenses = gui.create("MonthlyExpensesDisplay", frame)
	
	expenses:setPos(_S(5), _S(525))
	expenses:setSize(215, 30)
	expenses:setFont("bh24")
	
	local openFinancesButton = gui.create("FinancesPopupButton", frame)
	
	openFinancesButton:setSize(215, 30)
	openFinancesButton:setPos(frame.w - _S(5) - openFinancesButton.w, _S(525))
	openFinancesButton:setFont("pix26")
	openFinancesButton:setText(_T("FINANCES_REPORT", "Finance report"))
	
	local x, y = expenses:getPos()
	local loanDisplay = gui.create("LoanDisplay", frame)
	
	loanDisplay:setPos(_S(5), y + expenses.h + _S(5))
	loanDisplay:setSize(368, 30)
	loanDisplay:setFont("bh26")
	loanDisplay:updateText()
	
	local x, y = loanDisplay:getPos()
	local incLoan = gui.create("ChangeLoanButton", frame)
	
	incLoan:setSize(30, 30)
	incLoan:setChangeDirection(1)
	incLoan:setPos(x + loanDisplay.w + _S(5), y)
	
	local x, y = incLoan:getPos()
	local decLoan = gui.create("ChangeLoanButton", frame)
	
	decLoan:setSize(30, 30)
	decLoan:setChangeDirection(-1)
	decLoan:setPos(x + incLoan.w + _S(5), y)
	frameController:push(frame)
end

local teams, teamlessPeople = {}, {}

function monthlyCost:switchToPeopleWithinOfficeCallback()
	self.filterer:show()
end

function monthlyCost.createOfficeMenu(officeObject)
	local frame = gui.create("Frame")
	
	frame:setSize(450, 600)
	frame:setTitle(_T("OFFICE_INFO_TITLE", "Office Info"))
	frame:setFont(fonts.get("pix24"))
	frame:center()
	
	local sheet = gui.create("PropertySheet", frame)
	
	sheet:setPos(_S(5), _S(33))
	sheet:setTabOffset(4, 4)
	sheet:setSize(440, 575)
	sheet:setFont(fonts.get("bh24"))
	
	local officePanel = gui.create("Panel")
	
	officePanel.shouldDraw = false
	
	officePanel:setSize(440, 530)
	
	local scrollBarPanel = gui.create("ScrollbarPanel", officePanel)
	
	scrollBarPanel:setSize(440, 530)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setSpacing(4)
	scrollBarPanel:setPadding(4, 4)
	scrollBarPanel:addDepth(100)
	
	local highestID, highestAmount = officeObject:getHighestMonthlyCost()
	local category = gui.create("Category")
	
	category:setHeight(28)
	category:setFont(fonts.get("pix28"))
	category:setText(_T("OFFICE_EXPENSES", "Office expenses"))
	category:assumeScrollbar(scrollBarPanel)
	scrollBarPanel:addItem(category)
	
	for key, data in ipairs(monthlyCost.text) do
		local officeCost = officeObject:getMonthlyCost(data.id) or 0
		local costDisplay = gui.create("MonthlyCostDisplay")
		
		costDisplay:setHeight(30)
		costDisplay:setCost(officeCost)
		costDisplay:setCostType(data.id)
		costDisplay:setHighestCost(highestAmount)
		category:addItem(costDisplay)
	end
	
	local category = gui.create("Category")
	
	category:setHeight(28)
	category:setFont(fonts.get("pix28"))
	category:setText(_T("DRIVE_BOOSTS", "Drive affectors"))
	category:assumeScrollbar(scrollBarPanel)
	scrollBarPanel:addItem(category)
	
	for interestID, boostLevel in pairs(officeObject:getInterestBoosts()) do
		local boostDisplay = gui.create("InterestBoostDisplay")
		
		boostDisplay:setHeight(34)
		boostDisplay:setOffice(officeObject)
		boostDisplay:setInterestData(interestID, boostLevel)
		category:addItem(boostDisplay)
	end
	
	for key, affectorData in ipairs(studio.driveAffectors.registered) do
		local display = affectorData:createDriveBoostDisplay(officeObject)
		
		category:addItem(display)
	end
	
	local category = gui.create("Category")
	
	category:setHeight(28)
	category:setFont(fonts.get("pix28"))
	category:setText(_T("EXPERIENCE_BOOSTS", "Experience boosts"))
	category:assumeScrollbar(scrollBarPanel)
	scrollBarPanel:addItem(category)
	
	for key, skillData in ipairs(skills.registered) do
		if bookController.totalMaximumBoosts[skillData.id] then
			local display = gui.create("BookExperienceBoostDisplay")
			
			display:setHeight(34)
			display:setOffice(officeObject)
			display:setSkillID(skillData.id)
			category:addItem(display)
		end
	end
	
	local button = sheet:addItem(officePanel, _T("OFFICE_OVERVIEW", "Overview"), 193, 26)
	local peoplePanel = gui.create("Panel")
	
	peoplePanel.shouldDraw = false
	
	peoplePanel:setSize(440, 530)
	
	local peopleScrollbar = gui.create("RoleScrollbarPanel", peoplePanel)
	
	peopleScrollbar:setSize(440, 530)
	peopleScrollbar:setAdjustElementPosition(true)
	peopleScrollbar:setSpacing(4)
	peopleScrollbar:setPadding(4, 4)
	peopleScrollbar:addDepth(100)
	
	local filterer = game.createRoleFilter(peopleScrollbar, true)
	
	filterer:setPos(frame.x - filterer.w - _S(10), frame.y)
	peopleScrollbar:setRoleFilterList(filterer)
	filterer:tieVisibilityTo(peoplePanel)
	filterer:hide()
	
	for key, employee in ipairs(officeObject:getEmployees()) do
		local team = employee:getTeam()
		
		if team then
			teams[team] = teams[team] or {}
			
			table.insert(teams[team], employee)
		else
			teamlessPeople[#teamlessPeople + 1] = employee
		end
	end
	
	for teamObj, employeeList in pairs(teams) do
		monthlyCost.addPeopleToCategory(_format(_T("OFFICE_TEAM_MEMBERS", "People from team 'TEAM'"), "TEAM", teamObj:getName()), peopleScrollbar, employeeList, teamObj)
	end
	
	monthlyCost.addPeopleToCategory(_T("UNASSIGNED_EMPLOYEES", "Unassigned employees"), peopleScrollbar, teamlessPeople, "none")
	table.clear(teams)
	table.clear(teamlessPeople)
	
	local button = sheet:addItem(peoplePanel, _T("PEOPLE_WITHIN_OFFICE", "People within"), 193, 26, monthlyCost.switchToPeopleWithinOfficeCallback)
	
	button.filterer = filterer
	
	frameController:push(frame)
end

function monthlyCost.addPeopleToCategory(categoryTitle, scrollbar, peopleList, teamObj)
	local category = gui.create("Category")
	
	category:setHeight(28)
	category:setFont(fonts.get("pix26"))
	category:setText(categoryTitle)
	category:assumeScrollbar(scrollbar)
	
	category.teamObj = teamObj
	
	scrollbar:addItem(category)
	
	for key, employee in ipairs(peopleList) do
		local memberPanel = gui.create("EmployeeTeamAssignmentButton")
		
		memberPanel:setSize(410, 20)
		memberPanel:addComboBoxOption("unassign", "assignworkplace", "fire", "fillroleoptions", "info")
		memberPanel:setFont(fonts.get("pix20"))
		memberPanel:setShortDescription(true)
		memberPanel:setEmployee(employee)
		memberPanel:setTeam(teamObj)
		category:addItem(memberPanel)
		scrollbar:addEmployeeItem(memberPanel, true)
	end
end

function monthlyCost:init(water, electricity, communal)
	self.costs = {}
	self.costList = {}
	
	self:setCostType("water", water)
	self:setCostType("electricity", electricity)
	self:setCostType("communal", communal)
end

function monthlyCost:setCostType(type, cost)
	if not self.costs[type] then
		self.costList[#self.costList + 1] = type
	end
	
	self.costs[type] = cost or 0
end

function monthlyCost:setCostTypes(...)
	local index = 1
	
	for i = 1, select("#", ...) * 0.5 do
		local costType = select(index, ...)
		local cost = select(index + 1, ...)
		
		self.costs[costType] = cost
		index = index + 2
	end
end

function monthlyCost:getCostType(type)
	local cost = self.costs[type]
	
	return cost and cost or 0
end

function monthlyCost:getCostTypeList()
	return self.costList
end

function monthlyCost:getCostTypes()
	return self.costs
end

function monthlyCost:getTotalCost()
	local total = 0
	
	for type, cost in pairs(self.costs) do
		total = total + cost
	end
	
	return total
end

function monthlyCost:hasCostType(type)
	return self.costs[type] ~= nil
end

require("game/basic_monthly_costs")
