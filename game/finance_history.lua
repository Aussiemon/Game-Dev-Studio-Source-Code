financeHistory = {}
financeHistory.mtindex = {
	__index = financeHistory
}
financeHistory.registered = {}
financeHistory.registeredByID = {}
financeHistory.registeredTranslation = {}
financeHistory.registeredTranslationByID = {}
financeHistory.maxHistory = 5

function financeHistory.new()
	local new = {}
	
	setmetatable(new, financeHistory.mtindex)
	new:init()
	
	return new
end

function financeHistory.registerNew(data)
	financeHistory.registered[#financeHistory.registered + 1] = data
	financeHistory.registeredByID[data.id] = data
end

function financeHistory:init()
	self.months = {}
	self.monthMap = {}
end

function financeHistory:onStartNewGame()
	self:beginNewMonth()
end

function financeHistory:beginNewMonth()
	local month = timeline:getMonth()
	
	self.months[#self.months + 1] = {
		month = month,
		values = {}
	}
	self.monthMap[month] = self.months[#self.months]
	
	self:_initValues(self.monthMap[month].values)
	
	local monthCount = #self.months
	
	if monthCount > self.maxHistory then
		while monthCount > self.maxHistory do
			local data = self.months[1]
			
			self.monthMap[data.month] = nil
			
			table.remove(self.months, 1)
			
			monthCount = monthCount - 1
		end
	end
end

function financeHistory:initValues()
	for key, monthData in ipairs(self.months) do
		self:_initValues(monthData.values)
	end
end

function financeHistory:_initValues(list)
	for key, data in ipairs(financeHistory.registered) do
		list[data.id] = list[data.id] or 0
	end
end

function financeHistory:getMonthID()
	return self.months[#self.months].month
end

function financeHistory:getMonths()
	return self.months
end

function financeHistory:changeValue(month, id, value)
	month = month or self:getMonthID()
	id = id or "misc"
	
	if not self.monthMap[month] then
		self:beginNewMonth()
	end
	
	self.monthMap[month].values[id] = self.monthMap[month].values[id] + value
end

function financeHistory:setValue(month, id, value)
	month = month or self:getMonthID()
	self.monthMap[month].values[id] = value
end

function financeHistory:getValue(month, id)
	month = month or self:getMonthID()
	
	return self.monthMap[month].values[id]
end

function financeHistory:getValues(month)
	month = month or self:getMonthID()
	
	return self.monthMap[month]
end

financeHistory.getMonthData = financeHistory.getValues

function financeHistory:save()
	return {
		months = self.months
	}
end

function financeHistory:load(data)
	self.months = data.months
	
	for key, data in ipairs(self.months) do
		self.monthMap[data.month] = data
	end
	
	if not self.monthMap[timeline:getMonth()] then
		self:beginNewMonth()
	end
	
	self:initValues()
end

financeHistory.registerNew({
	id = "paychecks",
	display = _T("FINANCE_HISTORY_SALARIES", "Salaries")
})
financeHistory.registerNew({
	id = "activities",
	display = _T("FINANCE_HISTORY_ACTIVITIES", "Team activities")
})
financeHistory.registerNew({
	id = "marketing",
	display = _T("FINANCE_HISTORY_MARKETING", "Marketing")
})
financeHistory.registerNew({
	id = "game_projects",
	display = _T("FINANCE_HISTORY_NEW_GAME_PROJECTS", "Game projects")
})
financeHistory.registerNew({
	id = "contracts",
	display = _T("FINANCE_HISTORY_CONTRACTS", "Contracts")
})
financeHistory.registerNew({
	id = "penalties",
	display = _T("FINANCE_HISTORY_PENALTIES", "Penalties")
})
financeHistory.registerNew({
	id = "engine_licensing",
	display = _T("FINANCE_HISTORY_ENGINE_LICENSING", "Engine licenses")
})
financeHistory.registerNew({
	id = "platform_licensing",
	display = _T("FINANCE_HISTORY_PLATFORM_LICENSING", "Platform licenses")
})
financeHistory.registerNew({
	id = "office_expansion",
	display = _T("FINANCE_HISTORY_OFFICE_EXPANSION", "Office expansion")
})
financeHistory.registerNew({
	id = "server_expenses",
	display = _T("FINANCE_HISTORY_SERVER_EXPENSES", "Server expenses")
})
financeHistory.registerNew({
	id = "loans",
	display = _T("FINANCE_HISTORY_LOANS", "Loans")
})
financeHistory.registerNew({
	id = "misc",
	display = _T("FINANCE_HISTORY_MISCELLANEOUS", "Miscellaneous")
})
