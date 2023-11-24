game.DIFFICULTY_SETTINGS = {}
game.DIFFICULTY_SETTINGS_BY_ID = {}

function game.registerDifficulty(data, inherit)
	if inherit then
		local inData = game.DIFFICULTY_SETTINGS_BY_ID[inherit]
		
		setmetatable(data, inData.mtindex)
	end
	
	table.insert(game.DIFFICULTY_SETTINGS, data)
	
	game.DIFFICULTY_SETTINGS_BY_ID[data.id] = data
	data.mtindex = {
		__index = data
	}
end

function game.resetDifficulty()
	if game.difficultyID then
		local data = game.DIFFICULTY_SETTINGS_BY_ID[game.difficultyID]
		
		if data.resetDifficulty then
			data:resetDifficulty()
		end
		
		game.difficultyID = nil
	end
end

function game.applyDifficulty(id)
	local data = game.DIFFICULTY_SETTINGS_BY_ID[id]
	
	if data.applyDifficulty then
		data:applyDifficulty()
	end
	
	game.difficultyID = id
end

game.registerDifficulty({
	saleMult = 1.5,
	devSpeedMult = 1.6,
	id = "ultra_easy",
	salaryMult = 0.5,
	display = _T("DIFFICULTY_ULTRA_EASY", "Very easy"),
	descText = _T("DIFFICULTY_ULTRA_EASY_DESCRIPTION", "60% faster development\n50% lower salaries\n50% more game sales"),
	applyDifficulty = function(self)
		DEV_SPEED_MULTIPLIER = self.devSpeedMult
		EMPLOYEE_SALARY_MULTIPLIER = self.salaryMult
		SALE_MULTIPLIER = self.saleMult
	end,
	resetDifficulty = function(self)
		DEV_SPEED_MULTIPLIER = 1
		EMPLOYEE_SALARY_MULTIPLIER = 1
		SALE_MULTIPLIER = 1
	end,
	setupDescbox = function(self, descbox)
		descbox:addText(self.descText, "bh20", nil, 0, 350, "question_mark", 22, 22)
	end
})
game.registerDifficulty({
	saleMult = 1.3,
	id = "very_easy",
	salaryMult = 0.7,
	devSpeedMult = 1.35,
	display = _T("DIFFICULTY_VERY_EASY", "Easy"),
	descText = _T("DIFFICULTY_VERY_EASY_DESCRIPTION", "35% faster development\n30% lower salaries\n30% more game sales")
}, "ultra_easy")
game.registerDifficulty({
	saleMult = 1.15,
	id = "easy",
	salaryMult = 0.8,
	devSpeedMult = 1.15,
	display = _T("DIFFICULTY_EASY", "Normal"),
	descText = _T("DIFFICULTY_EASY_DESCRIPTION", "15% faster development\n20% lower salaries\n15% more game sales")
}, "ultra_easy")
game.registerDifficulty({
	saleMult = 1,
	id = "normal",
	salaryMult = 1,
	devSpeedMult = 1,
	display = _T("DIFFICULTY_NORMAL", "Hard"),
	descText = _T("DIFFICULTY_NORMAL_DESCRIPTION", "The original difficulty, play and experience the game the way it is meant to be experienced.")
}, "ultra_easy")
