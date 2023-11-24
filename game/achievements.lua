achievements = {}
achievements.LIST = {
	"HAVE_10_EMPLOYEES",
	"HAVE_20_EMPLOYEES",
	"HAVE_50_EMPLOYEES",
	"HAVE_100_EMPLOYEES",
	"FIVE_CONTRACTS",
	"FIFTEEN_CONTRACTS",
	"ONE_MILLION",
	"HUNDRED_MILLION",
	"ONE_BILLION",
	"ONE_TRILLION",
	"ONE_OUT_OF_TEN",
	"TEN_OUT_OF_TEN",
	"TUTORIAL",
	"BACK_IN_THE_GAME",
	"PAY_DEBTS",
	"RAVIOLI_AND_PEPPERONI",
	"BUYOUT_RIVAL",
	"RELEASE_CONSOLE",
	"ENGINE_STATS_MAXED",
	"PURCHASE_LICENSE",
	"RIVAL_PEACE",
	"GO_TO_COURT",
	"WIN_COURT",
	"START_SLANDER",
	"NO_EMPLOYEES_LEAVE_5_YEARS",
	"SCENARIO_NORMAL_DIFFICULTY",
	"NEW_STANDARD",
	"CONSOLE_DOMINATION"
}
achievements.ENUM = {}

for key, id in ipairs(achievements.LIST) do
	achievements.ENUM[id] = id
end

achievements.PREVENT_EXCLUSION = {
	[achievements.ENUM.TUTORIAL] = true
}
achievements.STATS = {
	COMPLETED_CONTRACTS = "completed_contracts",
	PASSED_MONTHS = "passed_months"
}
achievements.REQ_PROGRESS = {
	[achievements.ENUM.FIVE_CONTRACTS] = 5,
	[achievements.ENUM.FIFTEEN_CONTRACTS] = 15,
	[achievements.ENUM.NO_EMPLOYEES_LEAVE_5_YEARS] = 60
}
achievements.STAT_BOUNDARIES = {
	[achievements.STATS.COMPLETED_CONTRACTS] = 15,
	[achievements.STATS.PASSED_MONTHS] = 60
}

function achievements:init()
	self.progress = {}
	
	if not self.stats then
		self.stats = {}
	end
	
	if not self.unlocked then
		self.unlocked = {}
	end
	
	for key, id in ipairs(achievements.LIST) do
		self.progress[id] = 0
	end
end

function achievements:setStatData(data)
	if not steam then
		return 
	end
	
	self.stats = {}
	
	for i = 1, #data, 2 do
		local id = data[i]
		local value = data[i + 1]
		
		self.stats[id] = value
	end
end

function achievements:attemptSetStat(id, value, achvID)
	if not steam then
		return 
	end
	
	if game.curGametype:preventAchievements() then
		return 
	end
	
	if self.stats then
		steam.SetStat(id, value)
		
		local prevVal = self.stats[id]
		local req = self.STAT_BOUNDARIES[id]
		
		if type(achvID) == "table" then
			for key, id in ipairs(achvID) do
				if not self.unlocked[achvID] then
					self:_advanceProgress(value, prevVal, id, req)
				end
			end
		else
			self:_advanceProgress(value, prevVal, achvID, req)
		end
		
		local newVal = math.min(req, value)
		
		self.stats[id] = math.max(prevVal, newVal)
		
		steam.SetStat(id, newVal)
	end
end

function achievements:_advanceProgress(newValue, oldValue, achvID, req)
	self:_indicateProgress(newvalue, oldValue, achvID)
	
	if req <= newValue then
		steam.SetAchievement(achvID)
	end
end

function achievements:_indicateProgress(newValue, oldValue, achvID)
	local req = self.REQ_PROGRESS[achvID]
	
	if oldValue < newValue then
		local oldScalar, newScalar = math.floor(oldValue / req * 10) / 10, math.floor(newValue / req * 10) / 10
		
		if oldScalar < newScalar then
			steam.IndicateAchievementProgress(achvID, newValue, req)
		end
	end
end

function achievements:attemptGetStat(id)
	if not steam then
		return 0
	end
	
	if self.stats then
		return self.stats[id]
	end
end

function achievements:remove()
	if not steam then
		return 
	end
	
	table.clear(self.progress)
end

function achievements:getRequiredProgress(id)
	return self.REQ_PROGRESS[id]
end

function achievements:canUnlock(id)
	return self.progress[id] >= self.REQ_PROGRESS[id]
end

function achievements:changeProgress(id, prog, statID)
	if not steam then
		return 
	end
	
	if game.curGametype:preventAchievements() then
		return 
	end
	
	local req = self.REQ_PROGRESS[id]
	local newVal = math.min(self.progress[id] + prog, req)
	
	self.progress[id] = newVal
	
	if statID then
		local oldVal = self.stats[statID] or 0
		
		self.stats[statID] = math.max(oldVal, newVal)
		
		steam.SetStat(statID, newVal)
		self:_indicateProgress(newVal, oldVal, id)
	end
	
	if req <= newVal then
		steam.SetAchievement(id)
		
		return true
	end
	
	return false
end

function achievements:setProgress(id, prog)
	if not steam then
		return 
	end
	
	local req = self.REQ_PROGRESS[id]
	local newVal = math.min(req, prog)
	
	self.progress[id] = newVal
	
	if req <= newVal then
		steam.SetAchievement(id)
		
		return true
	end
	
	return false
end

function achievements:attemptSetAchievement(id)
	if not steam then
		return 
	end
	
	if game.curGametype:preventAchievements() and not achievements.PREVENT_EXCLUSION[id] then
		return 
	end
	
	if not self.unlocked[id] then
		steam.SetAchievement(id)
	end
end

function achievements:getProgress(id)
	if not steam then
		return 0
	end
	
	return self.progress[id]
end

function achievements:getAllProgress()
	return self.progress
end

function achievements:setAchievements(data)
	for i = 1, #data, 2 do
		local id = data[i]
		local achieved = data[i + 1]
		
		self.unlocked[id] = achieved
	end
end

function achievements:isUnlocked(id)
	return self.unlocked[id]
end

function achievements:setAchievement(id)
	self.unlocked[id] = true
end

function achievements:save()
	return {
		progress = self.progress
	}
end

function achievements:load(data)
	self.progress = data.progress
end

achievements:init()
