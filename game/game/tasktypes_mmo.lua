local genericMMOWarning = {
	font = "bh18",
	icon = "exclamation_point",
	iconHeight = 20,
	iconWidth = 20,
	text = _T("MMO_TASK_WARNING", "Be careful, as not all MMO-specific tasks work well with every single genre.")
}, taskTypes:registerCategoryTitle("game_mmo_progression", _T("GAME_CATEGORY_MMO_PROGRESSION", "MMO - Progression"), false, {
	{
		font = "pix18",
		lineSpace = 5,
		text = _T("MMO_PROGRESSION_DESCRIPTION", "Select the player progression type.")
	},
	genericMMOWarning
}, true, nil, "category_progression")

taskTypes:registerCategoryTitle("game_mmo_difficulty", _T("GAME_CATEGORY_MMO_DIFFICULTY", "MMO - Progression difficulty"), false, {
	{
		font = "pix18",
		lineSpace = 5,
		text = _T("MMO_DIFFICULTY_DESCRIPTION", "Select the overall difficulty of the game.")
	},
	genericMMOWarning
}, true, nil, "category_progression_difficulty")
taskTypes:registerCategoryTitle("game_mmo_death_penalty", _T("GAME_CATEGORY_MMO_DEATH_PENALTY", "MMO - Death penalty"), false, {
	{
		font = "pix18",
		lineSpace = 5,
		text = _T("MMO_DEATH_PENALTY_DESCRIPTION", "Select how harsh the death penalty should be.")
	},
	genericMMOWarning
}, true, nil, "category_death_penalty")
taskTypes:registerCategoryTitle("game_mmo_combat", _T("GAME_CATEGORY_MMO_COMBAT", "MMO - Combat"), false, {
	{
		font = "pix18",
		lineSpace = 5,
		text = _T("MMO_COMBAT_DESCRIPTION", "Select the combat types the game should have.")
	},
	genericMMOWarning
}, true, nil, "category_combat")
taskTypes:registerCategoryTitle("game_mmo_misc", _T("GAME_CATEGORY_MMO_MISC", "MMO - Miscellaneous"), false, {
	{
		font = "pix18",
		lineSpace = 2,
		text = _T("MMO_MISC_DESCRIPTION", "Select various optional additional content for the MMO.")
	},
	{
		font = "bh18",
		lineSpace = 5,
		text = _T("MMO_MISC_DESCRIPTION_2", "Tasks in this category are optional."),
		color = game.UI_COLORS.LIGHT_BLUE
	},
	genericMMOWarning
}, true, nil, "category_miscellan")

gameProject.MMO_AFFECTOR_GOOD = 1.05
gameProject.MMO_AFFECTOR_VGOOD = 1.1
gameProject.MMO_AFFECTOR_UGOOD = 1.15
gameProject.MMO_AFFECTOR_BAD = 0.85
gameProject.MMO_AFFECTOR_VBAD = 0.75
gameProject.MMO_AFFECTOR_UBAD = 0.65
gameProject.MMO_AFFECTOR_NEUTRAL = 1
gameProject.MMO_MATCHES_FACT = "mmo_match"

function gameProject.isMMOMatchKnown(taskID, genreID)
	local matches = studio:getFact(gameProject.MMO_MATCHES_FACT)
	
	if not matches or not matches[taskID] then
		return false
	end
	
	return matches[taskID][genreID]
end

function gameProject.revealMMOMatch(taskID, genreID)
	local matches = studio:getFact(gameProject.MMO_MATCHES_FACT)
	
	if not matches then
		matches = {}
		
		studio:setFact(gameProject.MMO_MATCHES_FACT, matches)
	end
	
	if not matches[taskID] then
		matches[taskID] = {}
	end
	
	matches[taskID][genreID] = true
end

taskTypes:registerNew({
	id = "mmo_base_task",
	display = "base mmo task",
	stage = 1,
	MAX_SIGNS = 3,
	developmentType = {
		[gameProject.DEVELOPMENT_TYPE.MMO] = true
	},
	onFinish = function(self, taskObj)
		local proj = taskObj:getProject()
		
		if proj then
			proj:addMMOTask(self.id)
		end
	end,
	SIGN_SECTION = {
		0.05,
		0.15
	},
	setupDescbox = function(self, descBox, wrapWidth, projObj)
		local negativePresent = false
		local insertedHeader = false
		local signSection = self.SIGN_SECTION
		local maxSigns = self.MAX_SIGNS
		local match = self.mmoMatch
		
		for key, genreData in ipairs(genres.registered) do
			local genreID = genreData.id
			
			if gameProject.isMMOMatchKnown(self.id, genreID) then
				local impact = match[genreID]
				
				if impact then
					local baseMult = 1
					
					if impact ~= baseMult then
						if not insertedHeader then
							descBox:addText(_T("MMO_TASK_GENRE_MATCHING", "Genre matching:"), "bh20", nil, 5, wrapWidth)
							
							insertedHeader = true
						end
						
						local signs, color = game.getContributionSign(baseMult, impact, signSection, maxSigns, nil, nil, nil)
						
						descBox:addText(table.concatEasy(" ", signs, genreData.display), "pix18", color, 0, wrapWidth, genres:getGenreUIIconConfig(genreData, 20, 20, 18))
					end
					
					if impact < baseMult then
						negativePresent = true
					end
				end
			end
		end
		
		if not insertedHeader then
			descBox:addSpaceToNextText(4)
			descBox:addText(_T("NO_GENRE_MATCHES_KNOWN", "No genre matches known."), "bh18", nil, 0, wrapWidth, "question_mark", 20, 20)
		end
		
		if negativePresent then
			descBox:addSpaceToNextText(10)
			descBox:addText(_T("NEGATIVE_CONTRIBUTION_EXPLANATION_MMO", "A negative contributor indicates that this will negatively affect the enjoyment of the MMO."), "bh18", nil, 0, wrapWidth, "exclamation_point_yellow", 20, 20)
		end
	end
})
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 150,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_progression",
	qualityContribution = "gameplay",
	category = "game_mmo_progression",
	id = "mmo_progression_activity",
	platformWorkAffector = 0.1,
	display = _T("MMO_PROGRESSION_ACTIVITY_BASED", "Activity-based"),
	displayResearch = _T("MMO_PROGRESSION_ACTIVITY_BASED_FULL", "Activity-based progression"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_PROGRESSION_ACTIVITY_BASED_DESC", "Players will progress their characters by performing various actions related to their abilities.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_VGOOD,
		adventure = gameProject.MMO_AFFECTOR_GOOD,
		horror = gameProject.MMO_AFFECTOR_VGOOD,
		fighting = gameProject.MMO_AFFECTOR_GOOD,
		simulation = gameProject.MMO_AFFECTOR_VBAD,
		strategy = gameProject.MMO_AFFECTOR_UBAD,
		rpg = gameProject.MMO_AFFECTOR_UGOOD,
		sandbox = gameProject.MMO_AFFECTOR_VGOOD,
		racing = gameProject.MMO_AFFECTOR_BAD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_progression_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_progression_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 150,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_PROGRESSION_IMPLEMENTATION", "Progression - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 150,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_progression",
	qualityContribution = "gameplay",
	category = "game_mmo_progression",
	id = "mmo_progression_time",
	platformWorkAffector = 0.1,
	display = _T("MMO_PROGRESSION_TIME_BASED", "Time-based"),
	displayResearch = _T("MMO_PROGRESSION_TIME_BASED_FULL", "Time-based progression"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_PROGRESSION_TIME_BASED_DESC", "Players will progress their characters by queueing actions which take a long while to complete, and waiting for them to finish.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_UBAD,
		adventure = gameProject.MMO_AFFECTOR_BAD,
		horror = gameProject.MMO_AFFECTOR_UBAD,
		fighting = gameProject.MMO_AFFECTOR_BAD,
		simulation = gameProject.MMO_AFFECTOR_UGOOD,
		strategy = gameProject.MMO_AFFECTOR_UGOOD,
		rpg = gameProject.MMO_AFFECTOR_BAD,
		sandbox = gameProject.MMO_AFFECTOR_BAD,
		racing = gameProject.MMO_AFFECTOR_GOOD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_progression_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 150,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_progression",
	qualityContribution = "gameplay",
	category = "game_mmo_progression",
	id = "mmo_progression_currency",
	platformWorkAffector = 0.1,
	display = _T("MMO_PROGRESSION_CURRENCY_BASED", "Currency-based"),
	displayResearch = _T("MMO_PROGRESSION_CURRENCY_BASED_FULL", "Currency-based progression"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_PROGRESSION_CURRENCY_BASED_DESC", "Players will progress their characters by spending in-game money to progress.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_VGOOD,
		adventure = gameProject.MMO_AFFECTOR_BAD,
		horror = gameProject.MMO_AFFECTOR_VBAD,
		fighting = gameProject.MMO_AFFECTOR_VGOOD,
		simulation = gameProject.MMO_AFFECTOR_UBAD,
		strategy = gameProject.MMO_AFFECTOR_GOOD,
		rpg = gameProject.MMO_AFFECTOR_NEUTRAL,
		sandbox = gameProject.MMO_AFFECTOR_BAD,
		racing = gameProject.MMO_AFFECTOR_UGOOD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_progression_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 150,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_difficulty",
	qualityContribution = "gameplay",
	category = "game_mmo_difficulty",
	id = "mmo_difficulty_solo",
	platformWorkAffector = 0.1,
	display = _T("MMO_PROGRESSION_DIFFICULTY_SOLO_ORIENTED", "Solo-oriented"),
	displayResearch = _T("MMO_PROGRESSION_DIFFICULTY_SOLO_ORIENTED_FULL", "Solo-oriented difficulty"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_PROGRESSION_DIFFICULTY_SOLO_ORIENTED_DESC", "The difficulty of progression will be balanced in a way to promote solo playstyles.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_GOOD,
		adventure = gameProject.MMO_AFFECTOR_BAD,
		horror = gameProject.MMO_AFFECTOR_UGOOD,
		fighting = gameProject.MMO_AFFECTOR_GOOD,
		simulation = gameProject.MMO_AFFECTOR_VBAD,
		strategy = gameProject.MMO_AFFECTOR_UBAD,
		rpg = gameProject.MMO_AFFECTOR_BAD,
		sandbox = gameProject.MMO_AFFECTOR_BAD,
		racing = gameProject.MMO_AFFECTOR_VGOOD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_difficulty_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_difficulty_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 50,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_PROGRESSION_DIFFICULTY_IMPLEMENTATION", "Difficulty - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 150,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_difficulty",
	qualityContribution = "gameplay",
	category = "game_mmo_difficulty",
	id = "mmo_difficulty_group",
	platformWorkAffector = 0.1,
	display = _T("MMO_DIFFICULTY_SOLO_ORIENTED", "Group-oriented"),
	displayResearch = _T("MMO_DIFFICULTY_SOLO_ORIENTED_FULL", "Group-oriented difficulty"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_DIFFICULTY_SOLO_ORIENTED_DESC", "The difficulty of progression will be balanced in a way to promote playing with other players, but with solo playstyles still being possible.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_GOOD,
		adventure = gameProject.MMO_AFFECTOR_GOOD,
		horror = gameProject.MMO_AFFECTOR_VBAD,
		fighting = gameProject.MMO_AFFECTOR_VGOOD,
		simulation = gameProject.MMO_AFFECTOR_GOOD,
		strategy = gameProject.MMO_AFFECTOR_GOOD,
		rpg = gameProject.MMO_AFFECTOR_GOOD,
		sandbox = gameProject.MMO_AFFECTOR_GOOD,
		racing = gameProject.MMO_AFFECTOR_VBAD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_difficulty_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_penalty",
	qualityContribution = "gameplay",
	category = "game_mmo_death_penalty",
	id = "mmo_death_penalty_none",
	platformWorkAffector = 0.1,
	display = _T("MMO_DEATH_PENALTY_NONE", "No penalty"),
	displayResearch = _T("MMO_DEATH_PENALTY_NONE_FULL", "No death penalty"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_DEATH_PENALTY_NONE_DESC", "Players will experience no setbacks when they die in-game.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_NEUTRAL,
		adventure = gameProject.MMO_AFFECTOR_VBAD,
		horror = gameProject.MMO_AFFECTOR_UBAD,
		fighting = gameProject.MMO_AFFECTOR_BAD,
		simulation = gameProject.MMO_AFFECTOR_UBAD,
		strategy = gameProject.MMO_AFFECTOR_UBAD,
		rpg = gameProject.MMO_AFFECTOR_VBAD,
		sandbox = gameProject.MMO_AFFECTOR_UBAD,
		racing = gameProject.MMO_AFFECTOR_NEUTRAL
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_death_penalty_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_death_penalty_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 50,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_DEATH_PENALTY_IMPLEMENTATION", "Death penalty - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_penalty",
	qualityContribution = "gameplay",
	category = "game_mmo_death_penalty",
	id = "mmo_death_penalty_light",
	platformWorkAffector = 0.1,
	display = _T("MMO_DEATH_PENALTY_LIGHT", "Light penalty"),
	displayResearch = _T("MMO_DEATH_PENALTY_LIGHT_FULL", "Light death penalty"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_DEATH_PENALTY_LIGHT_DESC", "Players will be lightly penalized for dying in-game.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_BAD,
		adventure = gameProject.MMO_AFFECTOR_BAD,
		horror = gameProject.MMO_AFFECTOR_BAD,
		fighting = gameProject.MMO_AFFECTOR_NEUTRAL,
		simulation = gameProject.MMO_AFFECTOR_VBAD,
		strategy = gameProject.MMO_AFFECTOR_VBAD,
		rpg = gameProject.MMO_AFFECTOR_NEUTRAL,
		sandbox = gameProject.MMO_AFFECTOR_BAD,
		racing = gameProject.MMO_AFFECTOR_NEUTRAL
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_death_penalty_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	stage = 1,
	optionalForStandard = true,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionCategory = "mmo_penalty",
	qualityContribution = "gameplay",
	category = "game_mmo_death_penalty",
	id = "mmo_death_penalty_heavy",
	platformWorkAffector = 0.1,
	display = _T("MMO_DEATH_PENALTY_HEAVY", "Heavy penalty"),
	displayResearch = _T("MMO_DEATH_PENALTY_HEAVY_FULL", "Heavy death penalty"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_DEATH_PENALTY_HEAVY_DESC", "Players will be heavily penalized for dying in-game, putting emphasis on strategic thinking.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_BAD,
		adventure = gameProject.MMO_AFFECTOR_BAD,
		horror = gameProject.MMO_AFFECTOR_BAD,
		fighting = gameProject.MMO_AFFECTOR_NEUTRAL,
		simulation = gameProject.MMO_AFFECTOR_VBAD,
		strategy = gameProject.MMO_AFFECTOR_VBAD,
		rpg = gameProject.MMO_AFFECTOR_NEUTRAL,
		sandbox = gameProject.MMO_AFFECTOR_BAD,
		racing = gameProject.MMO_AFFECTOR_NEUTRAL
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_death_penalty_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	mmoComplexity = 1.5,
	optionalForStandard = true,
	stage = 1,
	workAmount = 125,
	qualityContribution = "gameplay",
	category = "game_mmo_combat",
	id = "mmo_combat_pve",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_COMBAT_PVE", "Player vs. Environment"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_COMBAT_PVE_DESC", "Players will have the ability to fight against AI-controlled opponents.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_GOOD,
		adventure = gameProject.MMO_AFFECTOR_GOOD,
		horror = gameProject.MMO_AFFECTOR_GOOD,
		fighting = gameProject.MMO_AFFECTOR_GOOD,
		simulation = gameProject.MMO_AFFECTOR_GOOD,
		strategy = gameProject.MMO_AFFECTOR_GOOD,
		rpg = gameProject.MMO_AFFECTOR_GOOD,
		sandbox = gameProject.MMO_AFFECTOR_GOOD,
		racing = gameProject.MMO_AFFECTOR_VBAD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_combat_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_combat_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 100,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_COMBAT_IMPLEMENTATION", "PvE - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	mmoComplexity = 1.5,
	optionalForStandard = true,
	stage = 1,
	workAmount = 125,
	qualityContribution = "gameplay",
	category = "game_mmo_combat",
	id = "mmo_combat_pvp",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_COMBAT_PVP", "Player vs. Player"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_COMBAT_PVP_DESC", "Players will have the ability to fight other players.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_VGOOD,
		adventure = gameProject.MMO_AFFECTOR_VBAD,
		horror = gameProject.MMO_AFFECTOR_UGOOD,
		fighting = gameProject.MMO_AFFECTOR_VGOOD,
		simulation = gameProject.MMO_AFFECTOR_VGOOD,
		strategy = gameProject.MMO_AFFECTOR_VGOOD,
		rpg = gameProject.MMO_AFFECTOR_VGOOD,
		sandbox = gameProject.MMO_AFFECTOR_VGOOD,
		racing = gameProject.MMO_AFFECTOR_VGOOD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_pvp_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_pvp_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 100,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_PVP_IMPLEMENTATION", "PvP - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	mmoComplexity = 1.5,
	optionalForStandard = true,
	stage = 1,
	workAmount = 150,
	qualityContribution = "gameplay",
	category = "game_mmo_misc",
	id = "mmo_territorial_wars",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_TERRITORIAL_WARS", "Territorial wars"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_TERRITORIAL_WARS_DESC", "Add lands that can be contested for between players.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_VGOOD,
		adventure = gameProject.MMO_AFFECTOR_VBAD,
		horror = gameProject.MMO_AFFECTOR_UBAD,
		fighting = gameProject.MMO_AFFECTOR_VGOOD,
		simulation = gameProject.MMO_AFFECTOR_UGOOD,
		strategy = gameProject.MMO_AFFECTOR_UGOOD,
		rpg = gameProject.MMO_AFFECTOR_VGOOD,
		sandbox = gameProject.MMO_AFFECTOR_UBAD,
		racing = gameProject.MMO_AFFECTOR_BAD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_territorial_wars_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_territorial_wars_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 200,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_TERRITORIAL_WARS_IMPLEMENTATION", "Territorial wars - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	mmoComplexity = 1.5,
	optionalForStandard = true,
	stage = 1,
	workAmount = 100,
	qualityContribution = "gameplay",
	category = "game_mmo_misc",
	id = "mmo_guild_base_construction",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_GUILD_BASE_CONSTRUCTION", "Guild base construction"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_GUILD_BASE_CONSTRUCTION_DESC", "Add the ability for players to construct bases in the game world for their guilds.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_BAD,
		adventure = gameProject.MMO_AFFECTOR_VBAD,
		horror = gameProject.MMO_AFFECTOR_UBAD,
		fighting = gameProject.MMO_AFFECTOR_VGOOD,
		simulation = gameProject.MMO_AFFECTOR_UGOOD,
		strategy = gameProject.MMO_AFFECTOR_GOOD,
		rpg = gameProject.MMO_AFFECTOR_VGOOD,
		sandbox = gameProject.MMO_AFFECTOR_NEUTRAL,
		racing = gameProject.MMO_AFFECTOR_NEUTRAL
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_guild_base_construction_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_guild_base_construction_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 250,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_GUILD_BASE_CONSTRUCTION_IMPLEMENTATION", "Guild base construction - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	mmoComplexity = 1,
	optionalForStandard = true,
	stage = 1,
	workAmount = 125,
	qualityContribution = "gameplay",
	category = "game_mmo_misc",
	id = "mmo_personal_home",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_PERSONAL_HOME", "Personal home"),
	description = {
		{
			font = "pix18",
			text = _T("MMO_PERSONAL_HOME_DESC", "Add a personal home that players can decorate and improve upon over time, as they progress in the game world. A safe space, if you will.")
		}
	},
	mmoMatch = {
		action = gameProject.MMO_AFFECTOR_VBAD,
		adventure = gameProject.MMO_AFFECTOR_VGOOD,
		horror = gameProject.MMO_AFFECTOR_GOOD,
		fighting = gameProject.MMO_AFFECTOR_GOOD,
		simulation = gameProject.MMO_AFFECTOR_VBAD,
		strategy = gameProject.MMO_AFFECTOR_VBAD,
		rpg = gameProject.MMO_AFFECTOR_VGOOD,
		sandbox = gameProject.MMO_AFFECTOR_VBAD,
		racing = gameProject.MMO_AFFECTOR_VGOOD
	},
	gameQuality = {
		gameplay = 10
	},
	implementationTasks = {
		"mmo_personal_home_implementation"
	}
}, nil, "mmo_base_task")
taskTypes:registerNew({
	id = "mmo_personal_home_implementation",
	workField = "software",
	multipleEmployees = true,
	stage = 2,
	invisible = true,
	workAmount = 150,
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("MMO_PERSONAL_HOME_IMPLEMENTATION", "Personal home - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 10
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "software",
	noIssues = true,
	stage = 1,
	workAmount = 100,
	category = "mandatory_mmo_stage1",
	id = "mmo_server_backend_design",
	taskID = "game_task",
	platformWorkAffector = 0,
	requiresResearch = false,
	display = _T("SERVER_BACKEND_DESIGN", "Server back-end design")
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "software",
	noIssues = true,
	stage = 1,
	workAmount = 100,
	category = "mandatory_mmo_stage1",
	id = "mmo_client_backend_design",
	taskID = "game_task",
	platformWorkAffector = 0,
	requiresResearch = false,
	display = _T("CLIENT_BACKEND_DESIGN", "Client back-end design")
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "software",
	noIssues = true,
	stage = 2,
	workAmount = 150,
	category = "mandatory_mmo_stage2",
	id = "mmo_server_backend",
	taskID = "game_task",
	platformWorkAffector = 0,
	requiresResearch = false,
	display = _T("SERVER_BACKEND", "Server back-end")
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "software",
	noIssues = true,
	stage = 2,
	workAmount = 150,
	category = "mandatory_mmo_stage2",
	id = "mmo_server_frontend",
	taskID = "game_task",
	platformWorkAffector = 0,
	requiresResearch = false,
	display = _T("SERVER_FRONTEND", "Server front-end")
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "software",
	noIssues = true,
	stage = 2,
	workAmount = 150,
	category = "mandatory_mmo_stage2",
	id = "mmo_client_backend",
	taskID = "game_task",
	platformWorkAffector = 0,
	requiresResearch = false,
	display = _T("CLIENT_BACKEND", "Client back-end")
})

gameProject.MMO_RESEARCH_TASK = "mmo_research"

taskTypes:registerNew({
	noIssues = true,
	workField = "software",
	invisible = true,
	workAmount = 200,
	taskID = "game_task",
	platformWorkAffector = 0,
	requiresResearch = true,
	id = gameProject.MMO_RESEARCH_TASK,
	category = taskTypes.INVISIBLE_RESEARCHABLE_CATEGORY,
	display = _T("MMO_FULL", "Massively Multiplayer Online"),
	releaseDate = {
		year = 1996,
		month = 9
	}
})
