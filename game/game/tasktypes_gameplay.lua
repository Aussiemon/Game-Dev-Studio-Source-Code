taskTypes:registerCategoryTitle("game_gameplay", _T("GAMEPLAY", "Gameplay"), nil, nil, nil, nil, "category_gameplay")

local saveGame = {}

saveGame.id = "save_game"
saveGame.category = "game_gameplay"
saveGame.display = _T("FEATURE_SAVE_GAME", "Save game")
saveGame.specBoost = {
	id = "algorithms",
	boost = 1.15
}
saveGame.multipleEmployees = true
saveGame.platformWorkAffector = 0.2
saveGame.workAmount = 60
saveGame.workField = "software"
saveGame.minimumLevel = 15
saveGame.taskID = "game_task"
saveGame.gameQuality = {
	gameplay = 30
}
saveGame.qualityContribution = "gameplay"
saveGame.stage = 2
saveGame.maxScaleBeforePenalty = 5
saveGame.maxPenaltyAtScale = 15
saveGame.maxPenalty = 0.1
saveGame.developmentType = gameProject.NEW_GAME_DEV_TYPES
saveGame.skipPenalty = {
	[gameProject.DEVELOPMENT_TYPE.MMO] = true,
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = true
}

function saveGame:shouldApplyPenalty(projectObject)
	return not self.skipPenalty[projectObject:getGameType()] and projectObject:getScale() > self.maxScaleBeforePenalty
end

function saveGame:absenseCheck(projectObject, reviewObject)
	return self:shouldApplyPenalty(projectObject)
end

function saveGame:getPenalty(scale)
	return math.lerp(0, self.maxPenalty, math.min(1, (scale - self.maxScaleBeforePenalty) / (scale - self.maxScaleBeforePenalty)))
end

function saveGame:absenseScoreAdjust(projectObject, curScore)
	if self:shouldApplyPenalty(projectObject) then
		local scale = projectObject:getScale()
		
		curScore = curScore - self:getPenalty(scale)
	end
	
	return curScore
end

function saveGame:getAbsenseText(gameProj)
	local penalty = self:getPenalty(gameProj:getScale())
	
	if penalty == self.maxPenalty then
		return _T("SAVEGAME_ABSENT_REMARK_MAX", "enjoying a game of this scale is nearly impossible, due to the lack of a save game feature")
	elseif penalty >= self.maxPenalty * 0.6 then
		return _T("SAVEGAME_ABSENT_REMARK_MEDIUM", "a save game feature in a game of this scale is mandatory, and we have no clue why the developers didn't add it")
	end
	
	return _T("SAVEGAME_ABSENT_REMARK_LOW", "we think that a game of this scale should have had a save game feature")
end

function saveGame:setupDescbox(descbox, wrapWidth, projectObj)
	if studio:isFeatureRevealed(self.id) then
		descbox:addSpaceToNextText(4)
		descbox:addText(_format(_T("SAVEGAME_PENALTY_NOTICE", "Must-have for projects with a project scale of xSCALE"), "SCALE", self.maxScaleBeforePenalty), "bh20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
	end
end

taskTypes:registerNew(saveGame)

local selectableDifficulty = {}

selectableDifficulty.id = "selectable_difficulty"
selectableDifficulty.category = "game_gameplay"
selectableDifficulty.display = _T("SELECTABLE_DIFFICULTY", "Selectable difficulty")
selectableDifficulty.specBoost = {
	id = "algorithms",
	boost = 1.15
}
selectableDifficulty.platformWorkAffector = 0.2
selectableDifficulty.multipleEmployees = true
selectableDifficulty.workAmount = 60
selectableDifficulty.workField = "software"
selectableDifficulty.minimumLevel = 10
selectableDifficulty.gameQuality = {
	gameplay = 30
}
selectableDifficulty.qualityContribution = "gameplay"
selectableDifficulty.taskID = "game_task"
selectableDifficulty.stage = 2
selectableDifficulty.maxScaleBeforePenalty = 6
selectableDifficulty.penalty = 0.015
selectableDifficulty.penaltyYear = 1989
selectableDifficulty.developmentType = gameProject.NEW_GAME_DEV_TYPES
selectableDifficulty.penalizeGenres = {
	strategy = true,
	rpg = true,
	action = true,
	sandbox = true
}
selectableDifficulty.directKnowledgeContribution = {
	multiplier = 0.0005,
	knowledge = "machine_learning"
}
selectableDifficulty.genresConcatTable = {}
selectableDifficulty.fact = "sd_revealed_genres"
selectableDifficulty.skipPenalty = {
	[gameProject.DEVELOPMENT_TYPE.MMO] = true,
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = true
}

function selectableDifficulty:shouldApplyPenalty(projectObject)
	return not self.skipPenalty[projectObject:getGameType()] and timeline:getYear(projectObject:getReleaseDate()) >= self.penaltyYear and projectObject:getScale() > self.maxScaleBeforePenalty and self.penalizeGenres[projectObject:getGenre()]
end

function selectableDifficulty:absenseCheck(projectObject, reviewObject)
	return self:shouldApplyPenalty(projectObject)
end

function selectableDifficulty:absenseScoreAdjust(projectObject, curScore)
	if self:shouldApplyPenalty(projectObject) then
		local scale = projectObject:getScale()
		
		curScore = curScore - self.penalty
	end
	
	return curScore
end

function selectableDifficulty:getAbsenseText(gameProj)
	local revealedGenres = studio:getFact(self.fact) or {}
	local genre = gameProj:getGenre()
	
	revealedGenres[genre] = true
	
	studio:setFact(self.fact, revealedGenres)
	
	return _format(_T("SELECTABLE_DIFFICULTY_ABSENT_REMARK", "it would be nice to have the ability to select the difficulty, especially for a game of the GENRE genre"), "GENRE", genres:getData(genre).display)
end

function selectableDifficulty:setupDescbox(descbox, wrapWidth, projectObj)
	if studio:isFeatureRevealed(self.id) then
		descbox:addSpaceToNextText(4)
		
		local revealedGenres = studio:getFact(self.fact)
		
		for genreID, state in pairs(revealedGenres) do
			self.genresConcatTable[#self.genresConcatTable + 1] = genres:getData(genreID).display
		end
		
		descbox:addText(_format(_T("SELECTABLE_DIFFICULTY_PENALTY_NOTICE", "Must-have for GENRES genre projects with a project scale of xSCALE"), "SCALE", self.maxScaleBeforePenalty, "GENRES", table.concat(self.genresConcatTable, ", ")), "bh20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
		table.clear(self.genresConcatTable)
	end
end

taskTypes:registerNew(selectableDifficulty)

local tipsAndHints = {}

tipsAndHints.id = "tips_and_hints"
tipsAndHints.category = "game_gameplay"
tipsAndHints.mmoComplexity = 0.3
tipsAndHints.specBoost = {
	id = "algorithms",
	boost = 1.15
}
tipsAndHints.mmoContent = 5
tipsAndHints.display = _T("TIPS_AND_HINTS", "Tips and hints")
tipsAndHints.platformWorkAffector = 0.2
tipsAndHints.multipleEmployees = true
tipsAndHints.workAmount = 50
tipsAndHints.workField = "software"
tipsAndHints.minimumLevel = 10
tipsAndHints.gameQuality = {
	gameplay = 25
}
tipsAndHints.qualityContribution = "gameplay"
tipsAndHints.taskID = "game_task"
tipsAndHints.stage = 2
tipsAndHints.description = {
	{
		font = "pix20",
		text = _T("TIPS_AND_HINTS_DESC", "Create a hint system to provide the player with tips during gameplay to ensure a good first time user experience.")
	}
}

taskTypes:registerNew(tipsAndHints)
taskTypes:registerNew({
	stage = 1,
	mmoContent = 20,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "accurate_guns",
	platformWorkAffector = 0.1,
	display = _T("ACCURATE_GUNS", "Accurate gun mechanics"),
	mmoComplexity = gameProject.MMO_BASE_COMPLEXITY_VALUE,
	description = {
		{
			font = "pix20",
			text = _T("ACCURATE_GUNS_DESC", "Design the gameplay & gunplay to be highly accurate to the real world.\nThis task will be of no use if the required knowledge is low.")
		}
	},
	gameQuality = {
		gameplay = 1
	},
	directKnowledgeContribution = {
		mandatory = 1,
		multiplier = 0.001,
		knowledge = "firearms"
	},
	implementationTasks = {
		"accurate_guns_implementation"
	}
})
taskTypes:registerNew({
	workField = "software",
	stage = 2,
	invisible = true,
	workAmount = 100,
	id = "accurate_guns_implementation",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("ACCURATE_GUNS_IMPLEMENTATION", "Gun mechanics - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 4
	}
})
taskTypes:registerNew({
	stage = 1,
	mmoContent = 20,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "freedom_of_movement",
	platformWorkAffector = 0.1,
	display = _T("FREEDOM_OF_MOVEMENT", "Freedom of Movement"),
	mmoComplexity = gameProject.MMO_BASE_COMPLEXITY_VALUE,
	description = {
		{
			font = "pix20",
			text = _T("FREEDOM_OF_MOVEMENT_DESC", "Design & develop a movement system that allows to climb walls, vault over obstacles and perform other various movements.\nThis task will be of no use if the required knowledge is low.")
		}
	},
	gameQuality = {
		gameplay = 1
	},
	directKnowledgeContribution = {
		mandatory = 1,
		multiplier = 0.001,
		knowledge = "parkour"
	},
	implementationTasks = {
		"freedom_of_movement_implementation"
	}
})
taskTypes:registerNew({
	workField = "software",
	stage = 2,
	invisible = true,
	workAmount = 100,
	id = "freedom_of_movement_implementation",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("FREEDOM_OF_MOVEMENT_IMPLEMENTATION", "Freedom of Movement - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 4
	}
})
taskTypes:registerNew({
	stage = 1,
	mmoContent = 20,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "accurate_martial_arts",
	platformWorkAffector = 0.1,
	display = _T("ACCURATE_MARTIAL_ARTS", "Accurate martial arts"),
	mmoComplexity = gameProject.MMO_BASE_COMPLEXITY_VALUE,
	description = {
		{
			font = "pix20",
			text = _T("ACCURATE_MARTIAL_ARTS_DESC", "Design & develop a melee fighting system.\nThis task will be of no use if the required knowledge is low.")
		}
	},
	gameQuality = {
		gameplay = 1
	},
	directKnowledgeContribution = {
		mandatory = 1,
		multiplier = 0.001,
		knowledge = "fighting"
	},
	implementationTasks = {
		"accurate_martial_arts_implementation"
	}
})
taskTypes:registerNew({
	workField = "software",
	stage = 2,
	invisible = true,
	workAmount = 100,
	id = "accurate_martial_arts_implementation",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("ACCURATE_MARTIAL_ARTS_IMPLEMENTATION", "Accurate martial arts - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 4
	}
})
taskTypes:registerNew({
	stage = 1,
	mmoContent = 20,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "stealth_and_sneaking",
	platformWorkAffector = 0.1,
	display = _T("STEALTH_AND_SNEAKING", "Stealth & Sneaking"),
	mmoComplexity = gameProject.MMO_BASE_COMPLEXITY_VALUE,
	description = {
		{
			font = "pix20",
			text = _T("STEALTH_AND_SNEAKING_DESC", "Design & develop a stealth system.\nThis task will be of no use if the required knowledge is low.")
		}
	},
	gameQuality = {
		gameplay = 1
	},
	directKnowledgeContribution = {
		mandatory = 1,
		multiplier = 0.001,
		knowledge = "stealth"
	},
	implementationTasks = {
		"stealth_and_sneaking_implementation"
	}
})
taskTypes:registerNew({
	workField = "software",
	stage = 2,
	invisible = true,
	workAmount = 100,
	id = "stealth_and_sneaking_implementation",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("STEALTH_AND_SNEAKING_IMPLEMENTATION", "Stealth & Sneaking - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 4
	}
})
taskTypes:registerNew({
	stage = 1,
	mmoContent = 20,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "accurate_swordfighting",
	platformWorkAffector = 0.1,
	display = _T("ACCURATE_SWORDFIGHTING", "Accurate Swordfighting"),
	mmoComplexity = gameProject.MMO_BASE_COMPLEXITY_VALUE,
	description = {
		{
			font = "pix20",
			text = _T("ACCURATE_SWORDFIGHTING_DESC", "Design & develop a close-to-real-life swordfighting system.\nThis task will be of no use if the required knowledge is low.")
		}
	},
	gameQuality = {
		gameplay = 1
	},
	directKnowledgeContribution = {
		mandatory = 1,
		multiplier = 0.001,
		knowledge = "medieval_fighting"
	},
	implementationTasks = {
		"accurate_swordfighting_implementation"
	}
})
taskTypes:registerNew({
	workField = "software",
	stage = 2,
	invisible = true,
	workAmount = 100,
	id = "accurate_swordfighting_implementation",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("ACCURATE_SWORDFIGHTING_IMPLEMENTATION", "Accurate Swordfighting - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 4
	}
})
taskTypes:registerNew({
	stage = 1,
	mmoContent = 20,
	multipleEmployees = true,
	workAmount = 100,
	taskID = "game_task",
	workField = "concept",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "thirst_and_hunger",
	platformWorkAffector = 0.1,
	display = _T("THIRST_AND_HUNGER", "Thirst & Hunger"),
	mmoComplexity = gameProject.MMO_BASE_COMPLEXITY_VALUE,
	description = {
		{
			font = "pix20",
			text = _T("THIRST_AND_HUNGER_DESC", "Design & develop a system for simulating thirst and hunger.\nThis task will be of no use if the required knowledge is low.")
		}
	},
	gameQuality = {
		gameplay = 1
	},
	directKnowledgeContribution = {
		mandatory = 1,
		multiplier = 0.001,
		knowledge = "survival"
	},
	implementationTasks = {
		"accurate_swordfighting_implementation"
	}
})
taskTypes:registerNew({
	workField = "software",
	stage = 2,
	invisible = true,
	workAmount = 100,
	id = "accurate_swordfighting_implementation",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	display = _T("ACCURATE_SWORDFIGHTING_IMPLEMENTATION", "Accurate Swordfighting - implementation"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	gameQuality = {
		gameplay = 4
	}
})

local virtualRealityImplementation = {}

virtualRealityImplementation.id = "game_virtual_reality"
virtualRealityImplementation.mmoComplexity = 1
virtualRealityImplementation.requiresImplementation = true
virtualRealityImplementation.multipleEmployees = true
virtualRealityImplementation.mmoContent = 20
virtualRealityImplementation.specBoost = {
	id = "algorithms",
	boost = 1.15
}
virtualRealityImplementation.category = "game_gameplay"
virtualRealityImplementation.display = _T("GAME_VIRTUAL_REALITY", "Virtual reality")
virtualRealityImplementation.platformWorkAffector = 0.2
virtualRealityImplementation.workAmount = 150
virtualRealityImplementation.workField = "software"
virtualRealityImplementation.minimumLevel = 10
virtualRealityImplementation.gameQuality = {
	gameplay = 75,
	graphics = 75
}
virtualRealityImplementation.qualityContribution = "gameplay"
virtualRealityImplementation.taskID = "game_task"
virtualRealityImplementation.stage = 2
virtualRealityImplementation.implementationTasks = {
	"game_virtual_reality_design"
}
virtualRealityImplementation.description = {
	{
		font = "pix20",
		text = _T("GAME_VIRTUAL_REALITY_DESCRIPTION", "Having virtual reality in your game is no drag'n'drop task. Extra time must be taken to design the gameplay & mechanics for it.")
	}
}

taskTypes:registerNew(virtualRealityImplementation, "virtual_reality")

local virtualRealityImplementation = {}

virtualRealityImplementation.id = "game_virtual_reality_design"
virtualRealityImplementation.multipleEmployees = true
virtualRealityImplementation.invisible = true
virtualRealityImplementation.category = "game_gameplay"
virtualRealityImplementation.display = _T("GAME_VIRTUAL_REALITY_DESIGN", "VR - design")
virtualRealityImplementation.platformWorkAffector = 0.1
virtualRealityImplementation.workAmount = 100
virtualRealityImplementation.workField = "concept"
virtualRealityImplementation.minimumLevel = 10
virtualRealityImplementation.gameQuality = {
	gameplay = 50
}
virtualRealityImplementation.qualityContribution = "gameplay"
virtualRealityImplementation.taskID = "game_task"
virtualRealityImplementation.stage = 1

taskTypes:registerNew(virtualRealityImplementation)
taskTypes:registerNew({
	multipleEmployees = true,
	noIssues = false,
	stage = 2,
	workAmount = 70,
	taskID = "game_task",
	requiresResearch = true,
	workField = "software",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "multiplayer",
	platformWorkAffector = 0.3,
	minimumLevel = 25,
	developmentType = gameProject.NEW_GAME_DEV_TYPES,
	display = _T("MULTIPLAYER", "Multiplayer"),
	releaseDate = {
		year = 1991,
		month = 3
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	issues = {
		"p0",
		"p1"
	},
	gameQuality = {
		gameplay = 35
	},
	description = {
		{
			font = "pix20",
			text = _T("MULTIPLAYER_DESCRIPTION", "Add a LAN multiplayer to your game.\nAllows for more multiplayer-related tech once it becomes available.")
		}
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	noIssues = false,
	stage = 2,
	workAmount = 100,
	taskID = "game_task",
	requiresResearch = true,
	workField = "software",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "multiplayer_splitscreen",
	platformWorkAffector = 0.3,
	minimumLevel = 30,
	developmentType = gameProject.NEW_GAME_DEV_TYPES,
	display = _T("SPLITSCREEN", "Split-screen"),
	releaseDate = {
		year = 1992,
		month = 7
	},
	specBoost = {
		id = "rendering",
		boost = 1.15
	},
	issues = {
		"p0",
		"p1"
	},
	gameQuality = {
		gameplay = 50
	},
	requirements = {
		multiplayer = true
	},
	description = {
		{
			font = "pix20",
			text = _T("SPLITSCREEN_DESCRIPTION", "Adds the ability to play the game with multiple people at the same time on one system.")
		}
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	noIssues = false,
	stage = 2,
	workAmount = 100,
	taskID = "game_task",
	requiresResearch = true,
	workField = "software",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	category = "game_gameplay",
	id = "multiplayer_coop",
	platformWorkAffector = 0.3,
	minimumLevel = 40,
	developmentType = gameProject.NEW_GAME_DEV_TYPES,
	display = _T("COOP", "Co-op"),
	releaseDate = {
		year = 1993,
		month = 5
	},
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	issues = {
		"p0",
		"p1"
	},
	gameQuality = {
		gameplay = 50
	},
	requirements = {
		multiplayer = true
	},
	description = {
		{
			font = "pix20",
			text = _T("COOP_DESCRIPTION", "Co-op support can add a lot to the gameplay and even change how games are played.")
		}
	}
})
