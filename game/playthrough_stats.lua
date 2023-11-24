playthroughStats = {}
playthroughStats.registeredStats = {}
playthroughStats.registeredStatsByID = {}
playthroughStats.mtindex = {
	__index = playthroughStats
}

local defaultStatFuncs = {}

defaultStatFuncs.mtindex = {
	__index = defaultStatFuncs
}

function defaultStatFuncs:getDisplayText(value)
	return value
end

function playthroughStats.new()
	local new = {}
	
	setmetatable(new, playthroughStats.mtindex)
	new:init()
	
	return new
end

function playthroughStats.registerNew(statData)
	table.insert(playthroughStats.registeredStats, statData)
	
	playthroughStats.registeredStatsByID[statData.id] = statData
	
	setmetatable(statData, defaultStatFuncs.mtindex)
end

function playthroughStats:init()
	self.values = {}
	
	for key, statData in ipairs(playthroughStats.registeredStats) do
		self.values[statData.id] = 0
	end
end

function playthroughStats:changeStat(statID, change)
	self.values[statID] = self.values[statID] + change
end

function playthroughStats:setStat(statID, value)
	self.values[statID] = value
end

function playthroughStats:getStat(statID)
	return self.values[statID]
end

function playthroughStats:save()
	return {
		values = self.values
	}
end

function playthroughStats:load(data)
	for statKey, value in pairs(data.values) do
		self.values[statKey] = value
	end
end

playthroughStats.registerNew({
	id = "money_earned",
	display = _T("STAT_MONEY_EARNED", "Money earned"),
	getDisplayText = function(self, value)
		return string.roundtobigcashnumber(value)
	end
})
playthroughStats.registerNew({
	id = "money_spent",
	display = _T("STAT_MONEY_SPENT", "Money spent"),
	getDisplayText = function(self, value)
		return string.roundtobigcashnumber(value)
	end
})
playthroughStats.registerNew({
	id = "worst_financial_situation",
	display = _T("STAT_WORST_FINANCIAL_SITUATION", "Worst financial situation"),
	getDisplayText = function(self, value)
		return string.roundtobigcashnumber(value)
	end
})
playthroughStats.registerNew({
	id = "best_financial_situation",
	display = _T("STAT_BEST_FINANCIAL_SITUATION", "Best financial situation"),
	getDisplayText = function(self, value)
		return string.roundtobigcashnumber(value)
	end
})
playthroughStats.registerNew({
	id = "engines_created",
	display = _T("STAT_ENGINES_CREATED", "Engines created")
})
playthroughStats.registerNew({
	id = "games_developed",
	display = _T("STAT_GAMES_DEVELOPED", "Games developed")
})
playthroughStats.registerNew({
	id = "games_released",
	display = _T("STAT_GAMES_RELEASED", "Games released")
})
playthroughStats.registerNew({
	id = "games_published",
	display = _T("STAT_GAMES_PUBLISHED", "Games released under a publisher")
})
playthroughStats.registerNew({
	id = "contract_jobs_taken",
	display = _T("STAT_CONTRACT_JOBS_TAKEN", "Contract game jobs taken")
})
playthroughStats.registerNew({
	id = "contract_jobs_finished",
	display = _T("STAT_CONTRACT_JOBS_FINISHED", "Contract game jobs finished")
})
playthroughStats.registerNew({
	id = "most_employees_at_once",
	display = _T("STAT_MOST_EMPLOYEES_AT_ONCE", "Most employees at once")
})
playthroughStats.registerNew({
	id = "employees_stolen_from_rivals",
	display = _T("STAT_EMPLOYEES_STOLEN_FROM_RIVALS", "Employees stolen from rivals")
})
playthroughStats.registerNew({
	id = "employees_stolen_from_you",
	display = _T("STAT_EMPLOYEES_STOLEN_FROM_YOU", "Employees stolen from you")
})
playthroughStats.registerNew({
	id = "10_of_10_games_released",
	display = _T("STAT_TEN_OUT_OF_TEN_GAMES_RELEASED", "10/10 games released")
})
playthroughStats.registerNew({
	id = "1_of_10_games_released",
	display = _T("STAT_ONE_OUT_OF_TEN_GAMES_RELEASED", "1/10 games released")
})
