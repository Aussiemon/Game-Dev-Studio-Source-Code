local studioInfo = {}

studioInfo.headerText = _T("EMPLOYEES_IN_OFFICE", "Employees in studio")

function studioInfo:handleEvent(event, element)
	if event == employeeCirculation.EVENTS.JOB_OFFER_SENT or event == employeeCirculation.EVENTS.CANDIDATE_HIRED then
		self:updateDisplay()
	elseif self.showEmployeeOverview then
		if event == element.EVENTS.MOUSE_OVER then
			self:showEmployeeOverviewDescbox(element)
		elseif event == element.EVENTS.MOUSE_LEFT then
			self:hideEmployeeOverviewDescbox(element)
		end
	end
end

function studioInfo:bringUp()
	self:addDepth(1000)
end

function studioInfo:setHeaderText(text)
	self.headerText = text
end

function studioInfo:setShowEmployeeOverview(state)
	self.showEmployeeOverview = state
	self.employeeOverview = gui.create("EmployeeStatsOverview")
	
	self.employeeOverview:tieVisibilityTo(self)
	self.employeeOverview:overwriteDepth(2000)
	self.employeeOverview:hide()
end

function studioInfo:showEmployeeOverviewDescbox(element)
	if not self:canDraw() then
		return 
	end
	
	self.employeeOverview:setEmployee(element:getEmployee())
	
	local x, y = self:getPos(true)
	
	self.employeeOverview:setPos(x, y + self.h + _S(10))
end

function studioInfo:hideEmployeeOverviewDescbox()
	self.employeeOverview:removeEmployee()
end

function studioInfo:updateDisplay()
	if not self.employeeExpenses then
		self.employeeExpenses = studio:getMonthlyEmployeeSalaries()
	end
	
	self:removeAllText()
	self:addText(self.headerText, "pix24", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 10, 320)
	
	for key, data in ipairs(attributes.profiler.roles) do
		local count = studio:getEmployeeCountByRole(data.id)
		
		if count > 0 then
			self:addText(_format(_T("ROLE_AND_EMPLOYEE_COUNT", "ROLE - COUNT"), "ROLE", data.display, "COUNT", count), "bh20", nil, 2, 320, {
				{
					height = 22,
					icon = "profession_backdrop",
					width = 22
				},
				{
					width = 20,
					height = 20,
					y = 1,
					x = 1,
					icon = data.roleIcon
				}
			})
		end
	end
	
	self:addText(_format(_T("STUDIO_TOTAL_SALARIES", "Salaries: SALARIES"), "SALARIES", string.roundtobigcashnumber(self.employeeExpenses)), "bh20", nil, 0, 320, "money_lost", 22, 22)
	
	local hireable, workplaces = studio:getHireableEmployeeCount()
	
	self:addText(_format(_T("FREE_WORKPLACES", "Free workplaces: WORKPLACES"), "WORKPLACES", workplaces or 0), "bh20", nil, 0, 320)
	self:addText(_format(_T("HIREABLE_EMPLOYEES", "Hireable employees: EMPLOYEES"), "EMPLOYEES", hireable), "bh20", nil, 3, 320)
end

gui.register("StudioEmploymentInfoDescbox", studioInfo, "GenericDescbox")
require("game/gui/employee_stats_overview")
