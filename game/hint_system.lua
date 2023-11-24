hintSystem = {}
hintSystem.registered = {}
hintSystem.registeredByID = {}
hintSystem.hintCooldowns = {}
hintSystem.shownHints = {}
hintSystem.DEFAULT_HINT_COOLDOWN_DURATION = 30
hintSystem.DEFAULT_WEIGHT = 1

local defaultHintFuncs = {}

defaultHintFuncs.mtindex = {
	__index = defaultHintFuncs
}

function defaultHintFuncs:isCooldownOver()
	return game.time > (hintSystem.hintCooldowns[self.id] or 0)
end

function defaultHintFuncs:isEligible()
	return true
end

function defaultHintFuncs:getWeight()
	return self.weight
end

function defaultHintFuncs:getCooldownDuration()
	return self.cooldown
end

function defaultHintFuncs:postDisplay()
end

function defaultHintFuncs:getDisplayText()
	if type(self.displayText) == "table" then
		return self.displayText[math.random(1, #self.displayText)]
	end
	
	return self.displayText
end

function hintSystem.registerNew(data, inherit)
	hintSystem.registeredByID[data.id] = data
	
	table.insert(hintSystem.registered, data)
	
	if inherit then
		setmetatable(data, hintSystem.registeredByID[inherit].mtindex)
	else
		setmetatable(data, defaultHintFuncs.mtindex)
	end
	
	data.cooldown = data.cooldown or hintSystem.DEFAULT_HINT_COOLDOWN_DURATION
	data.weight = data.weight or hintSystem.DEFAULT_WEIGHT
end

function hintSystem:init()
end

function hintSystem:remove()
	table.clear(self.hintCooldowns)
	table.clear(self.shownHints)
end

function hintSystem:addCooldown(hintID, cooldown)
	self.hintCooldowns[hintID] = game.time + cooldown
end

function hintSystem:attemptShowHint()
	local hint = self:pickBestHint()
	
	if hint then
		self:addCooldown(hint.id, hint:getCooldownDuration())
		
		self.shownHints[hint.id] = (self.shownHints[hint.id] or 0) + 1
		
		hint:postDisplay()
		
		return hint:getDisplayText()
	end
	
	return nil
end

function hintSystem:pickBestHint()
	local bestHint
	local highestWeight = -math.huge
	
	for key, hintData in ipairs(hintSystem.registered) do
		if hintData:isCooldownOver() and hintData:isEligible() then
			local weight = hintData:getWeight()
			
			if highestWeight < weight then
				bestHint = hintData
				highestWeight = weight
			end
		end
	end
	
	return bestHint
end

function hintSystem:getShownHintTimes(hintID)
	return self.shownHints[hintID] or 0
end

function hintSystem:isHintEligible(hintID)
	return hintSystem.registeredByID[hintID]:isEligible()
end

function hintSystem:save()
	return {
		shownHints = self.shownHints
	}
end

function hintSystem:load(data)
	if data then
		self.shownHints = data.shownHints or self.shownHints
	end
end

hintSystem.registerNew({
	requiredWorkplaces = 1,
	id = "make_workplaces",
	weight = 20,
	displayText = {
		_T("NO_WORKPLACES_HINT_1", "It seems your office is empty, consider setting up a few workplaces."),
		_T("NO_WORKPLACES_HINT_2", "Your office is empty, the first step to starting a game development studio would be to set up workplaces.")
	},
	isEligible = function(self)
		local totalWorkplaces = 0
		
		for key, object in ipairs(studio:getOwnedObjects()) do
			if object.objectType == "workplace" and object:isValidForWork() then
				totalWorkplaces = totalWorkplaces + 1
				
				if totalWorkplaces >= self.requiredWorkplaces then
					break
				end
			end
		end
		
		return totalWorkplaces < self.requiredWorkplaces
	end
})
hintSystem.registerNew({
	id = "build_restrooms",
	weight = 10,
	displayText = {
		_T("NO_RESTROOMS_HINT_1", "Your office has no restrooms, that should be taken care of."),
		_T("NO_RESTROOMS_HINT_2", "You should construct a restroom in your office, as they are mandatory.")
	},
	isEligible = function(self)
		return studio:getValidRoomTypeCount(studio.ROOM_TYPES.TOILET) <= 0
	end
})
hintSystem.registerNew({
	id = "place_water_dispensers",
	weight = 10,
	displayText = {
		_T("NO_WATER_DISPENSERS_1", "Your office could use a water dispenser or two."),
		_T("NO_WATER_DISPENSERS_2", "A water dispenser is a must have in any office.")
	},
	isEligible = function(self)
		return studio:getOwnedObjectCountByClass("water_dispenser") <= 0
	end
})
hintSystem.registerNew({
	id = "hire_employees",
	weight = 5,
	displayText = {
		_T("HIRE_EMPLOYEES_1", "Your office is empty, you should hire some developers."),
		_T("HIRE_EMPLOYEES_2", "To do any kind of game development you will need to hire developers. Do so now.")
	},
	isEligible = function(self)
		return not hintSystem:isHintEligible("make_workplaces") and #studio:getEmployees() == 0
	end
})
hintSystem.registerNew({
	id = "assign_employees_to_workplaces",
	weight = 5,
	displayText = {
		_T("ASSIGN_TO_WORKPLACES_1", "Some of your employees are without a workplace."),
		_T("ASSIGN_TO_WORKPLACES_2", "You have employees without a workplace.")
	},
	isEligible = function(self)
		local employees = studio:getEmployees()
		
		if #employees == 0 then
			return 
		end
		
		local noWorkplaceEmployees = 0
		
		for key, employeeObj in ipairs(employees) do
			if not employeeObj:hasWorkplace() then
				return true
			end
		end
		
		return false
	end
})
hintSystem.registerNew({
	id = "get_a_game_engine",
	weight = 10,
	displayText = {
		_T("NO_GAME_ENGINES_1", "Your next step would be to acquire a game engine - either make one or purchase a license for one."),
		_T("NO_GAME_ENGINES_2", "You need a game engine to develop games, you can buy a license for one, or make one yourself.")
	},
	isEligible = function(self)
		return #studio:getEmployees() > 0 and not hintSystem:isHintEligible("assign_employees_to_workplaces") and #studio:getPurchasedEngines() == 0 and #studio:getEngines() == 0
	end
})
hintSystem.registerNew({
	id = "make_your_first_game",
	weight = 10,
	displayText = {
		_T("MAKE_YOUR_FIRST_GAME_1", "Now you're all set for making a game! Begin doing this by opening the Projects menu."),
		_T("MAKE_YOUR_FIRST_GAME_2", "Ready to start making games! Open up the Projects menu.")
	},
	isEligible = function(self)
		if #studio:getPurchasedEngines() == 0 and #studio:getEngines() == 0 or #studio:getReleasedGames() > 0 then
			return false
		end
		
		for key, teamObj in ipairs(studio:getTeams()) do
			local proj = teamObj:getProject()
			
			if proj and proj.PROJECT_TYPE == gameProject.PROJECT_TYPE then
				return false
			end
		end
		
		return true
	end
})
hintSystem.registerNew({
	id = "hire_manager",
	weight = 10,
	displayText = {
		_T("HIRE_A_MANAGER_1", "Consider hiring and assigning a manager to a team to increase your project development speed."),
		_T("HIRE_A_MANAGER_2", "A boost in development speed can be provided if you hire and assign a manager to a team.")
	},
	isEligible = function(self)
		if studio:getEmployeeCountByRole("manager") == 0 then
			return true
		end
		
		return false
	end
})
hintSystem.registerNew({
	id = "hire_designer",
	weight = 10,
	displayText = {
		_T("HIRE_A_DESIGNER_1", "In order to design new themes and genres you will need to hire a Designer."),
		_T("HIRE_A_DESIGNER_2", "Hiring one, or several, designers will allow you to research new themes and genres for use in games.")
	},
	isEligible = function(self)
		if studio:getEmployeeCountByRole("designer") == 0 then
			return true
		end
		
		return false
	end
})
hintSystem.registerNew({
	id = "many_idle_employees",
	tasklessPercentage = 0.25,
	weight = 10,
	displayText = {
		_T("MANY_IDLE_EMPLOYEES_1", "Some of your employees are idling without a task."),
		_T("MANY_IDLE_EMPLOYEES_2", "Tell idle employees to practice their skills or research new tech.")
	},
	isEligible = function(self)
		if #studio:getPurchasedEngines() == 0 and #studio:getEngines() == 0 or #studio:getReleasedGames() == 0 then
			return false
		end
		
		local employees = studio:getEmployees()
		local tasklessEmployees = 0
		
		for key, employee in ipairs(employees) do
			if not employee:getTask() then
				tasklessEmployees = tasklessEmployees + 1
			end
		end
		
		return tasklessEmployees / #employees > self.tasklessPercentage
	end
})
hintSystem.registerNew({
	id = "qa_reminder",
	weight = 15,
	displayText = {
		_T("QA_REMINDER_HINT_1", "Don't forget to hire an outside QA firm to test your game projects."),
		_T("QA_REMINDER_HINT_2", "Hiring a QA firm to perform extensive testing on your projects is necessary to produce a mostly bug-free product.")
	},
	isEligible = function(self)
		return #studio:getReleasedGames() >= 2
	end
})
hintSystem.registerNew({
	id = "manufacturers",
	weight = 1,
	displayText = {
		_T("MANUFACTURERS_HINT_1", "Platform manufacturers are affected by the games you release.")
	}
})
hintSystem.registerNew({
	id = "platform_share_migration",
	weight = 1,
	displayText = {
		_T("PLATFORM_MIGRATION_HINT_1", "Users will migrate from one platform to another if the latter has games of higher quality.")
	}
})
hintSystem.registerNew({
	id = "feature_selection",
	weight = 1,
	displayText = {
		_T("FEATURE_SELECTION_HINT_1", "Selecting a lot of features is not necessary for a good game, but it is necessary for an expensive one.")
	}
})
hintSystem.registerNew({
	id = "remaining_loan",
	weight = 20,
	displayText = _T("REMAINING_LOAN_HINT", "You still have a loan of LOAN that you have to return."),
	isEligible = function(self)
		return studio:getLoan() > 0
	end,
	getDisplayText = function(self)
		return _format(self.displayText, "LOAN", string.roundtobigcashnumber(studio:getLoan()))
	end
})
