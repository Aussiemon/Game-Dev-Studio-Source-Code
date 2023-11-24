local goal = {}

goal.id = "have_n_employees"
goal.EXTRA_EMPLOYEES_RANGE = {
	5,
	10
}
goal.EMPLOYEE_COUNT_ROUNDING = 5
goal.EMPLOYEE_TIME_PERIOD = {
	3,
	9
}
goal.REWARD_LEVELS_PER_EMPLOYEE = 0.025
goal.REWARD_LEVELS_PER_MONTH = 1.5 / goal.EMPLOYEE_TIME_PERIOD[2]
goal.REWARD_MIN_LEVELS = 1
goal.REWARD_MAX_LEVELS = 3
goal.BASE_PRIORITY = 30
goal.PRIORITY_LOSS = 25
goal.PEAK_UNTIL_EMPLOYEE_COUNT = 100
goal.CAN_PICK = true
goal.UPDATE_DISPLAY_EVENTS = {
	[studio.EVENTS.EMPLOYEE_COUNT_CHANGED] = true
}
goal.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_MONTH,
	studio.EVENTS.EMPLOYEE_COUNT_CHANGED
}

function goal:init()
	self.validMonths = 0
end

function goal:getRewardedLevels()
	return math.max(goal.REWARD_MIN_LEVELS, math.min(goal.REWARD_MAX_LEVELS, self.requiredEmployees * goal.REWARD_LEVELS_PER_EMPLOYEE + self.requiredMonths * goal.REWARD_LEVELS_PER_MONTH))
end

function goal:prepare()
	local curEmployees = #studio:getEmployees()
	
	self.requiredEmployees = math.ceil((curEmployees + math.random(goal.EXTRA_EMPLOYEES_RANGE[1], goal.EXTRA_EMPLOYEES_RANGE[2])) / goal.EMPLOYEE_COUNT_ROUNDING) * goal.EMPLOYEE_COUNT_ROUNDING
	self.requiredMonths = math.random(goal.EMPLOYEE_TIME_PERIOD[1], goal.EMPLOYEE_TIME_PERIOD[2])
end

function goal:getPriority()
	return goal.BASE_PRIORITY - goal.PRIORITY_LOSS * (math.min(#studio:getEmployees(), goal.PEAK_UNTIL_EMPLOYEE_COUNT) / goal.PEAK_UNTIL_EMPLOYEE_COUNT)
end

function goal:getText()
	return string.easyformatbykeys(_T("HAVE_N_EMPLOYEES_GOAL_DESCRIPTION", "Have COUNT employees for MONTHS months."), "COUNT", self.requiredEmployees, "MONTHS", self.requiredMonths)
end

function goal:handleEvent(event)
	if event == timeline.EVENTS.NEW_MONTH then
		if #studio:getEmployees() >= self.requiredEmployees then
			self.validMonths = self.validMonths + 1
			
			if self.validMonths >= self.requiredMonths then
				yearlyGoalController:finishGoal(self)
			end
		elseif self.requiredMonths > timeline.MONTHS_IN_YEAR - (timeline:getMonth() + self.validMonths) then
			yearlyGoalController:failGoal(self)
		end
		
		self:updateDisplay(self.display)
	elseif self.UPDATE_DISPLAY_EVENTS[event] then
		self:updateDisplay(self.display)
	end
end

function goal:_updateDisplay(element)
	local text = self:getText()
	
	text = text .. string.easyformatbykeys(_T("HAVE_N_EMPLOYEES_PROGRESS_TEXT", "\n - CUR_EMPLOYEES/REQUIRED_EMPLOYEES employees\n - MONTHS_PASSED/REQUIRED_MONTHS months passed"), "CUR_EMPLOYEES", #studio:getEmployees(), "REQUIRED_EMPLOYEES", self.requiredEmployees, "MONTHS_PASSED", self.validMonths, "REQUIRED_MONTHS", self.requiredMonths)
	
	element:setText(text)
end

function goal:save()
	local saved = goal.baseClass.save(self)
	
	saved.requiredMonths = self.requiredMonths
	saved.requiredEmployees = self.requiredEmployees
	saved.validMonths = self.validMonths
	
	return saved
end

function goal:load(data)
	goal.baseClass.load(self, data)
	
	self.requiredMonths = data.requiredMonths
	self.requiredEmployees = data.requiredEmployees
	self.validMonths = data.validMonths
	
	self:updateDisplay(self.display)
end

yearlyGoalController:registerNew(goal, "goal_base")
