gameProject.MMO_BASE_COMPLEXITY_VALUE = 0.4

taskTypes:registerCategoryTitle("game_world_design", _T("WORLD_DESIGN_CATEGORY_TITLE", "World design"))
taskTypes:registerCategoryTitle("game_content", _T("CONTENT_TYPE_CATEGORY_TITLE", "Content type"))
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "graphics",
	noIssues = true,
	stage = 1,
	workAmount = 50,
	qualityContribution = "graphics",
	category = "mandatory_game_stage1",
	id = "graphics_art_style",
	taskID = "game_task",
	platformWorkAffector = 0,
	requiresResearch = false,
	display = _T("ART_STYLE", "Art style"),
	mmoContent = taskTypes.MANDATORY_MMO_CONTENT,
	gameQuality = {
		graphics = 25
	},
	knowledgeContribution = {
		adventure = {
			scifi = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			fantasy = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			wilderness = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			bizarre = {
				{
					id = "stylizing",
					amount = 0.002
				}
			}
		},
		fighting = {
			scifi = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			fantasy = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			bizarre = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			fantasy = {
				{
					id = "stylizing",
					amount = 0.002
				}
			}
		},
		strategy = {
			scifi = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			fantasy = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			bizarre = {
				{
					id = "stylizing",
					amount = 0.002
				}
			}
		},
		rpg = {
			scifi = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			fantasy = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			wilderness = {
				{
					id = "stylizing",
					amount = 0.002
				}
			},
			bizarre = {
				{
					id = "stylizing",
					amount = 0.002
				}
			}
		}
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	noIssues = true,
	stage = 1,
	workAmount = 50,
	qualityContribution = "gameplay",
	category = "mandatory_game_stage1",
	id = "gameplay_design",
	taskID = "game_task",
	platformWorkAffector = 0.25,
	requiresResearch = false,
	display = _T("GAMEPLAY_DESIGN", "Gameplay design"),
	mmoContent = taskTypes.MANDATORY_MMO_CONTENT,
	gameQuality = {
		gameplay = 25
	},
	knowledgeContribution = {
		action = {
			military = {
				{
					id = "firearms",
					amount = 0.001
				},
				{
					id = "military_jargon",
					amount = 0.0005
				},
				{
					id = "fighting",
					amount = 0.0005
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.002
				}
			},
			undercover = {
				{
					id = "stealth",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			government = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			scifi = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			},
			urban = {
				{
					id = "parkour",
					amount = 0.002
				}
			},
			cyberpunk = {
				{
					id = "parkour",
					amount = 0.002
				}
			}
		},
		fighting = {
			military = {
				{
					id = "military_jargon",
					amount = 0.0005
				},
				{
					id = "fighting",
					amount = 0.0015
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			undercover = {
				{
					id = "stealth",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			government = {
				{
					id = "firearms",
					amount = 0.0005
				},
				{
					id = "military_jargon",
					amount = 0.0005
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			scifi = {
				{
					id = "fighting",
					amount = 0.005
				}
			},
			bizarre = {
				{
					id = "fighting",
					amount = 0.005
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			}
		},
		adventure = {
			undercover = {
				{
					id = "stealth",
					amount = 0.001
				},
				{
					id = "parkour",
					amount = 0.001
				}
			},
			wilderness = {
				{
					id = "parkour",
					amount = 0.002
				}
			},
			fantasy = {
				{
					id = "parkour",
					amount = 0.002
				}
			},
			urban = {
				{
					id = "parkour",
					amount = 0.002
				}
			},
			cyberpunk = {
				{
					id = "parkour",
					amount = 0.002
				}
			}
		},
		simulation = {
			military = {
				{
					id = "firearms",
					amount = 0.0008
				},
				{
					id = "military_jargon",
					amount = 0.0008
				},
				{
					id = "fighting",
					amount = 0.0004
				}
			},
			medieval = {
				{
					id = "primitive_technology",
					amount = 0.001
				},
				{
					id = "medieval_fighting",
					amount = 0.001
				}
			},
			wilderness = {
				{
					id = "photography",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			}
		},
		strategy = {
			military = {
				{
					id = "military_jargon",
					amount = 0.001
				},
				{
					id = "photography",
					amount = 0.001
				}
			},
			medieval = {
				{
					id = "primitive_technology",
					amount = 0.001
				},
				{
					id = "medieval_fighting",
					amount = 0.001
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			}
		},
		rpg = {
			military = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			}
		},
		sandbox = {
			wilderness = {
				{
					id = "photography",
					amount = 0.002
				}
			},
			wilderness = {
				{
					id = "parkour",
					amount = 0.002
				}
			},
			fantasy = {
				{
					id = "parkour",
					amount = 0.002
				}
			},
			urban = {
				{
					id = "parkour",
					amount = 0.002
				}
			}
		},
		racing = {
			steampunk = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			cyberpunk = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			},
			worldwar = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			urban = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			postapoc = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			cyberpunk = {
				{
					id = "vehicles",
					amount = 0.002
				}
			}
		}
	}
})

local engineTaskType = {}

engineTaskType.id = "engine_features"
engineTaskType.platformWorkAffector = 0.25
engineTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
engineTaskType.taskID = "game_task"
engineTaskType.category = "mandatory_game_stage2"
engineTaskType.display = _T("ENGINE_FEATURES", "Engine features")
engineTaskType.multipleEmployees = true
engineTaskType.workAmount = 30
engineTaskType.workField = "software"
engineTaskType.qualityContribution = "gameplay"
engineTaskType.gameQuality = {
	gameplay = 15
}
engineTaskType.issues = {
	"p0",
	"p1"
}
engineTaskType.stage = 2

taskTypes:registerNew(engineTaskType)

local gameplayTaskType = {}

gameplayTaskType.id = "gameplay_implementation"
gameplayTaskType.platformWorkAffector = 0.1
gameplayTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
gameplayTaskType.multipleEmployees = true
gameplayTaskType.taskID = "game_task"
gameplayTaskType.category = "mandatory_game_stage2"
gameplayTaskType.display = _T("GAMEPLAY_IMPLEMENTATION", "Gameplay implementation")
gameplayTaskType.qualityContribution = "gameplay"
gameplayTaskType.workAmount = 50
gameplayTaskType.workField = "software"
gameplayTaskType.issues = {
	"p0",
	"p1"
}
gameplayTaskType.gameQuality = {
	gameplay = 25
}
gameplayTaskType.stage = 2
gameplayTaskType.knowledgeContribution = {
	action = {
		military = {
			{
				id = "firearms",
				amount = 0.001
			}
		}
	},
	simulation = {
		military = {
			{
				id = "firearms",
				amount = 0.001
			}
		}
	}
}

taskTypes:registerNew(gameplayTaskType)

local graphicsTaskType = {}

graphicsTaskType.id = "graphics"
graphicsTaskType.platformWorkAffector = 0.1
graphicsTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
graphicsTaskType.taskID = "game_task"
graphicsTaskType.multipleEmployees = true
graphicsTaskType.category = "mandatory_game_stage2"
graphicsTaskType.display = _T("VISUAL_ASSETS", "Visual assets")
graphicsTaskType.workAmount = 100
graphicsTaskType.gameQuality = {
	graphics = 40
}
graphicsTaskType.workField = "graphics"
graphicsTaskType.qualityContribution = "graphics"
graphicsTaskType.issues = {
	"p2"
}
graphicsTaskType.gameQuality = {
	graphics = 50
}
graphicsTaskType.stage = 2

taskTypes:registerNew(graphicsTaskType)

local soundTaskType = {}

soundTaskType.id = "sound"
soundTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
soundTaskType.platformWorkAffector = 0.05
soundTaskType.taskID = "game_task"
soundTaskType.multipleEmployees = true
soundTaskType.category = "mandatory_game_stage2"
soundTaskType.display = _T("AUDIO_ASSETS", "Audio assets")
soundTaskType.workAmount = 80
soundTaskType.workField = "sound"
soundTaskType.gameQuality = {
	sound = 40
}
soundTaskType.qualityContribution = "sound"
soundTaskType.issues = {
	"p2"
}
soundTaskType.stage = 2

taskTypes:registerNew(soundTaskType)

local rendererTaskType = {}

rendererTaskType.id = "renderer"
rendererTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
rendererTaskType.platformWorkAffector = 0.15
rendererTaskType.multipleEmployees = true
rendererTaskType.taskID = "game_task"
rendererTaskType.category = "mandatory_game_stage2"
rendererTaskType.display = _T("RENDERER", "Renderer")
rendererTaskType.workAmount = 80
rendererTaskType.workField = "software"
rendererTaskType.gameQuality = {
	graphics = 40
}
rendererTaskType.qualityContribution = "graphics"
rendererTaskType.issues = {
	"p1",
	"p2"
}
rendererTaskType.stage = 2

taskTypes:registerNew(rendererTaskType)
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	noIssues = true,
	stage = 1,
	workAmount = 50,
	qualityContribution = "graphics",
	category = "mandatory_game_stage_content_pack_1",
	id = "graphics_content_drafts",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	requiresResearch = false,
	display = _T("CONTENT_DRAFTS", "Content drafts"),
	mmoContent = taskTypes.MANDATORY_MMO_CONTENT,
	developmentType = gameProject.EXPANSION_DEV_TYPES,
	gameQuality = {
		graphics = 25
	}
})
taskTypes:registerNew({
	multipleEmployees = true,
	workField = "concept",
	noIssues = true,
	stage = 1,
	workAmount = 50,
	qualityContribution = "gameplay",
	category = "mandatory_game_stage_content_pack_1",
	id = "content_design",
	taskID = "game_task",
	platformWorkAffector = 0.1,
	requiresResearch = false,
	display = _T("CONTENT_DESIGN", "Content design"),
	mmoContent = taskTypes.MANDATORY_MMO_CONTENT,
	developmentType = gameProject.EXPANSION_DEV_TYPES,
	gameQuality = {
		gameplay = 25
	},
	knowledgeContribution = {
		action = {
			military = {
				{
					id = "firearms",
					amount = 0.001
				},
				{
					id = "military_jargon",
					amount = 0.0005
				},
				{
					id = "fighting",
					amount = 0.0005
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.002
				}
			},
			undercover = {
				{
					id = "stealth",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			government = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			scifi = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			}
		},
		fighting = {
			military = {
				{
					id = "military_jargon",
					amount = 0.0005
				},
				{
					id = "fighting",
					amount = 0.0015
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			undercover = {
				{
					id = "stealth",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			government = {
				{
					id = "firearms",
					amount = 0.0005
				},
				{
					id = "military_jargon",
					amount = 0.0005
				},
				{
					id = "fighting",
					amount = 0.001
				}
			},
			scifi = {
				{
					id = "fighting",
					amount = 0.005
				}
			},
			bizarre = {
				{
					id = "fighting",
					amount = 0.005
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.001
				},
				{
					id = "fighting",
					amount = 0.001
				}
			}
		},
		adventure = {
			undercover = {
				{
					id = "stealth",
					amount = 0.002
				}
			}
		},
		simulation = {
			military = {
				{
					id = "firearms",
					amount = 0.0008
				},
				{
					id = "military_jargon",
					amount = 0.0008
				},
				{
					id = "fighting",
					amount = 0.0004
				}
			},
			medieval = {
				{
					id = "primitive_technology",
					amount = 0.001
				},
				{
					id = "medieval_fighting",
					amount = 0.001
				}
			},
			wilderness = {
				{
					id = "photography",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			}
		},
		strategy = {
			military = {
				{
					id = "military_jargon",
					amount = 0.0005
				},
				{
					id = "photography",
					amount = 0.0005
				},
				{
					id = "machine_learning",
					amount = 0.001
				}
			},
			medieval = {
				{
					id = "primitive_technology",
					amount = 0.0003
				},
				{
					id = "medieval_fighting",
					amount = 0.0007
				},
				{
					id = "machine_learning",
					amount = 0.001
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.001
				},
				{
					id = "machine_learning",
					amount = 0.001
				}
			},
			worldwar = {
				{
					id = "machine_learning",
					amount = 0.002
				}
			},
			scifi = {
				{
					id = "machine_learning",
					amount = 0.002
				}
			},
			government = {
				{
					id = "machine_learning",
					amount = 0.002
				}
			}
		},
		rpg = {
			military = {
				{
					id = "firearms",
					amount = 0.002
				}
			},
			medieval = {
				{
					id = "medieval_fighting",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			}
		},
		sandbox = {
			wilderness = {
				{
					id = "photography",
					amount = 0.002
				}
			}
		},
		racing = {
			steampunk = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			cyberpunk = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			ancient = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			},
			worldwar = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			urban = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			postapoc = {
				{
					id = "vehicles",
					amount = 0.002
				}
			},
			cyberpunk = {
				{
					id = "primitive_technology",
					amount = 0.002
				}
			}
		}
	}
})

local gameplayTaskType = {}

gameplayTaskType.id = "content_pack_gameplay_implementation"
gameplayTaskType.platformWorkAffector = 0.1
gameplayTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
gameplayTaskType.taskID = "game_task"
gameplayTaskType.category = "mandatory_game_stage_content_pack_2"
gameplayTaskType.multipleEmployees = true
gameplayTaskType.developmentType = gameProject.EXPANSION_DEV_TYPES
gameplayTaskType.display = _T("GAMEPLAY_IMPLEMENTATION", "Gameplay implementation")
gameplayTaskType.qualityContribution = "gameplay"
gameplayTaskType.workAmount = 50
gameplayTaskType.workField = "software"
gameplayTaskType.issues = {
	"p0",
	"p1"
}
gameplayTaskType.gameQuality = {
	gameplay = 25
}
gameplayTaskType.stage = 2
gameplayTaskType.knowledgeContribution = {
	action = {
		military = {
			{
				id = "firearms",
				amount = 0.001
			}
		}
	},
	simulation = {
		military = {
			{
				id = "firearms",
				amount = 0.001
			}
		}
	}
}

taskTypes:registerNew(gameplayTaskType)

local graphicsTaskType = {}

graphicsTaskType.id = "content_pack_graphics"
graphicsTaskType.platformWorkAffector = 0.1
graphicsTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
graphicsTaskType.taskID = "game_task"
graphicsTaskType.multipleEmployees = true
graphicsTaskType.developmentType = gameProject.EXPANSION_DEV_TYPES
graphicsTaskType.category = "mandatory_game_stage_content_pack_2"
graphicsTaskType.display = _T("VISUAL_ASSETS", "Visual assets")
graphicsTaskType.workAmount = 100
graphicsTaskType.workField = "graphics"
graphicsTaskType.qualityContribution = "graphics"
graphicsTaskType.gameQuality = {
	graphics = 50
}
graphicsTaskType.issues = {
	"p2"
}
graphicsTaskType.stage = 2

taskTypes:registerNew(graphicsTaskType)

local soundTaskType = {}

soundTaskType.id = "content_pack_sound"
soundTaskType.platformWorkAffector = 0.05
soundTaskType.mmoContent = taskTypes.MANDATORY_MMO_CONTENT
soundTaskType.taskID = "game_task"
soundTaskType.multipleEmployees = true
soundTaskType.developmentType = gameProject.EXPANSION_DEV_TYPES
soundTaskType.category = "mandatory_game_stage_content_pack_2"
soundTaskType.display = _T("AUDIO_ASSETS", "Audio assets")
soundTaskType.workAmount = 80
soundTaskType.workField = "sound"
soundTaskType.qualityContribution = "sound"
soundTaskType.gameQuality = {
	sound = 50
}
soundTaskType.issues = {
	"p2"
}
soundTaskType.stage = 2

taskTypes:registerNew(soundTaskType)

local baseExpansionTask = {}

baseExpansionTask.id = "base_expansion_task"

function baseExpansionTask:onSelected(gameProj)
	gameProj:changeSelectedContentAmount(1)
end

function baseExpansionTask:onDeselected(gameProj)
	gameProj:changeSelectedContentAmount(-1)
end

taskTypes:registerNew(baseExpansionTask)

local extraCampaign = {}

extraCampaign.id = "extra_campaign"
extraCampaign.platformWorkAffector = 0
extraCampaign.mmoContent = 70
extraCampaign.category = "game_content"
extraCampaign.display = _T("CONTENT_NEW_CAMPAIGN", "New campaign")
extraCampaign.workAmount = 100
extraCampaign.workField = "writing"
extraCampaign.multipleEmployees = true
extraCampaign.noIssues = true
extraCampaign.optionalForStandard = true
extraCampaign.gameQuality = {
	story = 50
}
extraCampaign.contentPoints = {
	campaign = 50
}
extraCampaign.qualityContribution = "story"
extraCampaign.taskID = "game_task"
extraCampaign.developmentType = gameProject.EXPANSION_DEV_TYPES
extraCampaign.stage = 1
extraCampaign.implementationTasks = {
	"extra_campaign_software",
	"extra_campaign_graphic",
	"extra_campaign_sound"
}

function extraCampaign:canHaveTask(gameProj)
	return gameProj:getSequelTo():getGameType() ~= gameProject.DEVELOPMENT_TYPE.MMO
end

taskTypes:registerNew(extraCampaign, nil, "base_expansion_task")

local extraCampaign = {}

extraCampaign.id = "extra_campaign_software"
extraCampaign.platformWorkAffector = 0
extraCampaign.multipleEmployees = true
extraCampaign.optionalForStandard = true
extraCampaign.display = _T("CONTENT_NEW_CAMPAIGN_SOFTWARE", "New campaign - implementation")
extraCampaign.workAmount = 100
extraCampaign.gameQuality = {
	gameplay = 50
}
extraCampaign.workField = "software"
extraCampaign.qualityContribution = "gameplay"
extraCampaign.noIssues = true
extraCampaign.taskID = "game_task"
extraCampaign.developmentType = gameProject.EXPANSION_DEV_TYPES
extraCampaign.stage = 2

taskTypes:registerNew(extraCampaign)

local extraCampaign = {}

extraCampaign.id = "extra_campaign_graphic"
extraCampaign.platformWorkAffector = 0
extraCampaign.multipleEmployees = true
extraCampaign.optionalForStandard = true
extraCampaign.display = _T("CONTENT_NEW_CAMPAIGN_GRAPHICS", "New campaign - visual assets")
extraCampaign.workAmount = 100
extraCampaign.workField = "graphics"
extraCampaign.gameQuality = {
	graphics = 50
}
extraCampaign.qualityContribution = "graphics"
extraCampaign.noIssues = true
extraCampaign.taskID = "game_task"
extraCampaign.developmentType = gameProject.EXPANSION_DEV_TYPES
extraCampaign.stage = 2

taskTypes:registerNew(extraCampaign)

local extraCampaign = {}

extraCampaign.id = "extra_campaign_sound"
extraCampaign.platformWorkAffector = 0
extraCampaign.multipleEmployees = true
extraCampaign.optionalForStandard = true
extraCampaign.display = _T("CONTENT_NEW_CAMPAIGN_AUDIO", "New campaign - audio assets")
extraCampaign.workAmount = 100
extraCampaign.gameQuality = {
	sound = 50
}
extraCampaign.workField = "sound"
extraCampaign.qualityContribution = "sound"
extraCampaign.noIssues = true
extraCampaign.taskID = "game_task"
extraCampaign.developmentType = gameProject.EXPANSION_DEV_TYPES
extraCampaign.stage = 2

taskTypes:registerNew(extraCampaign)

local newGameplayMechanics = {}

newGameplayMechanics.id = "new_gameplay_mechanics"
newGameplayMechanics.category = "game_content"
newGameplayMechanics.platformWorkAffector = 0
newGameplayMechanics.mmoContent = 50
newGameplayMechanics.multipleEmployees = true
newGameplayMechanics.optionalForStandard = true
newGameplayMechanics.display = _T("CONTENT_NEW_GAMEPLAY_MECHANICS", "New gameplay mechanics")
newGameplayMechanics.workAmount = 60
newGameplayMechanics.workField = "concept"
newGameplayMechanics.noIssues = true
newGameplayMechanics.gameQuality = {
	gameplay = 30
}
newGameplayMechanics.contentPoints = {
	gameplay = 50
}
newGameplayMechanics.qualityContribution = "gameplay"
newGameplayMechanics.taskID = "game_task"
newGameplayMechanics.developmentType = gameProject.EXPANSION_DEV_TYPES
newGameplayMechanics.stage = 1
newGameplayMechanics.implementationTasks = {
	"new_gameplay_mechanics_software"
}

taskTypes:registerNew(newGameplayMechanics, nil, "base_expansion_task")

local newGameplayMechanics = {}

newGameplayMechanics.id = "new_gameplay_mechanics_software"
newGameplayMechanics.platformWorkAffector = 0
newGameplayMechanics.multipleEmployees = true
newGameplayMechanics.optionalForStandard = true
newGameplayMechanics.display = _T("CONTENT_NEW_GAMEPLAY_MECHANICS_SOFTWARE", "New gameplay mechanics - implementation")
newGameplayMechanics.workAmount = 100
newGameplayMechanics.workField = "software"
newGameplayMechanics.qualityContribution = "gameplay"
newGameplayMechanics.gameQuality = {
	gameplay = 50
}
newGameplayMechanics.noIssues = true
newGameplayMechanics.taskID = "game_task"
newGameplayMechanics.developmentType = gameProject.EXPANSION_DEV_TYPES
newGameplayMechanics.stage = 2

taskTypes:registerNew(newGameplayMechanics)

local newCosmeticItems = {}

newCosmeticItems.id = "new_cosmetic_items"
newCosmeticItems.category = "game_content"
newCosmeticItems.mmoContent = 25
newCosmeticItems.platformWorkAffector = 0
newCosmeticItems.multipleEmployees = true
newCosmeticItems.optionalForStandard = true
newCosmeticItems.display = _T("CONTENT_NEW_COSMETIC_ITEMS", "New cosmetic items")
newCosmeticItems.workAmount = 40
newCosmeticItems.workField = "concept"
newCosmeticItems.noIssues = true
newCosmeticItems.gameQuality = {
	graphics = 10
}
newCosmeticItems.contentPoints = {
	cosmetics = 40
}
newCosmeticItems.qualityContribution = "graphics"
newCosmeticItems.taskID = "game_task"
newCosmeticItems.developmentType = gameProject.EXPANSION_DEV_TYPES
newCosmeticItems.stage = 1
newCosmeticItems.implementationTasks = {
	"new_cosmetic_items_graphics",
	"new_cosmetic_items_software"
}

taskTypes:registerNew(newCosmeticItems, nil, "base_expansion_task")

local newCosmeticItems = {}

newCosmeticItems.id = "new_cosmetic_items_graphics"
newCosmeticItems.platformWorkAffector = 0
newCosmeticItems.multipleEmployees = true
newCosmeticItems.optionalForStandard = true
newCosmeticItems.display = _T("CONTENT_NEW_COSMETIC_ITEMS_GRAPHICS", "New cosmetic items - graphics")
newCosmeticItems.workAmount = 60
newCosmeticItems.workField = "graphics"
newCosmeticItems.qualityContribution = "graphics"
newCosmeticItems.gameQuality = {
	graphics = 10
}
newCosmeticItems.noIssues = true
newCosmeticItems.taskID = "game_task"
newCosmeticItems.developmentType = gameProject.EXPANSION_DEV_TYPES
newCosmeticItems.stage = 2

taskTypes:registerNew(newCosmeticItems, nil)

local newCosmeticItems = {}

newCosmeticItems.id = "new_cosmetic_items_software"
newCosmeticItems.platformWorkAffector = 0
newCosmeticItems.multipleEmployees = true
newCosmeticItems.optionalForStandard = true
newCosmeticItems.display = _T("CONTENT_NEW_COSMETIC_ITEMS_IMPLEMENTATION", "New cosmetic items - implementation")
newCosmeticItems.workAmount = 20
newCosmeticItems.workField = "software"
newCosmeticItems.qualityContribution = "gameplay"
newCosmeticItems.gameQuality = {
	gameplay = 15
}
newCosmeticItems.noIssues = true
newCosmeticItems.taskID = "game_task"
newCosmeticItems.developmentType = gameProject.EXPANSION_DEV_TYPES
newCosmeticItems.stage = 2

taskTypes:registerNew(newCosmeticItems)

local newUsableItems = {}

newUsableItems.id = "new_usable_items"
newUsableItems.category = "game_content"
newUsableItems.mmoContent = 35
newUsableItems.platformWorkAffector = 0
newUsableItems.multipleEmployees = true
newUsableItems.optionalForStandard = true
newUsableItems.display = _T("CONTENT_NEW_USABLE_ITEMS", "New usable items")
newUsableItems.workAmount = 60
newUsableItems.workField = "concept"
newUsableItems.noIssues = true
newUsableItems.gameQuality = {
	graphics = 10
}
newUsableItems.contentPoints = {
	gameplay = 40
}
newUsableItems.qualityContribution = "graphics"
newUsableItems.taskID = "game_task"
newUsableItems.developmentType = gameProject.EXPANSION_DEV_TYPES
newUsableItems.stage = 1
newUsableItems.implementationTasks = {
	"new_usable_items_graphics",
	"new_usable_items_software"
}

taskTypes:registerNew(newUsableItems, nil, "base_expansion_task")

local newUsableItems = {}

newUsableItems.id = "new_usable_items_graphics"
newUsableItems.platformWorkAffector = 0
newUsableItems.multipleEmployees = true
newUsableItems.optionalForStandard = true
newUsableItems.display = _T("CONTENT_NEW_USABLE_ITEMS_GRAPHICS", "New usable items - graphics")
newUsableItems.workAmount = 80
newUsableItems.workField = "graphics"
newUsableItems.qualityContribution = "graphics"
newUsableItems.gameQuality = {
	graphics = 15
}
newUsableItems.noIssues = true
newUsableItems.taskID = "game_task"
newUsableItems.developmentType = gameProject.EXPANSION_DEV_TYPES
newUsableItems.stage = 2

taskTypes:registerNew(newUsableItems, nil)

local newUsableItems = {}

newUsableItems.id = "new_usable_items_software"
newUsableItems.platformWorkAffector = 0
newUsableItems.multipleEmployees = true
newUsableItems.optionalForStandard = true
newUsableItems.display = _T("CONTENT_NEW_USABLE_ITEMS_IMPLEMENTATION", "New usable items - implementation")
newUsableItems.workAmount = 100
newUsableItems.workField = "software"
newUsableItems.qualityContribution = "gameplay"
newUsableItems.gameQuality = {
	gameplay = 15
}
newUsableItems.noIssues = true
newUsableItems.taskID = "game_task"
newUsableItems.developmentType = gameProject.EXPANSION_DEV_TYPES
newUsableItems.stage = 2

taskTypes:registerNew(newUsableItems)

local newMultiplayerMaps = {}

newMultiplayerMaps.id = "new_multiplayer_maps"
newMultiplayerMaps.category = "game_content"
newMultiplayerMaps.mmoContent = 25
newMultiplayerMaps.platformWorkAffector = 0
newMultiplayerMaps.multipleEmployees = true
newMultiplayerMaps.optionalForStandard = true
newMultiplayerMaps.display = _T("CONTENT_NEW_MULTIPLAYER_MAPS", "New multiplayer maps")
newMultiplayerMaps.workAmount = 100
newMultiplayerMaps.workField = "concept"
newMultiplayerMaps.noIssues = true
newMultiplayerMaps.gameQuality = {
	gameplay = 40
}
newMultiplayerMaps.contentPoints = {
	gameplay = 60
}
newMultiplayerMaps.qualityContribution = "graphics"
newMultiplayerMaps.taskID = "game_task"
newMultiplayerMaps.developmentType = gameProject.EXPANSION_DEV_TYPES
newMultiplayerMaps.stage = 1
newMultiplayerMaps.implementationTasks = {
	"new_multiplayer_maps_graphics",
	"new_multiplayer_maps_implementation"
}

function newMultiplayerMaps:canHaveTask(gameProj)
	return gameProj:hasFeature("multiplayer")
end

taskTypes:registerNew(newMultiplayerMaps, nil, "base_expansion_task")

local newMultiplayerMaps = {}

newMultiplayerMaps.id = "new_multiplayer_maps_graphics"
newMultiplayerMaps.platformWorkAffector = 0
newMultiplayerMaps.multipleEmployees = true
newMultiplayerMaps.optionalForStandard = true
newMultiplayerMaps.display = _T("CONTENT_NEW_MULTIPLAYER_MAPS_GRAPHICS", "New multiplayer maps - graphics")
newMultiplayerMaps.workAmount = 100
newMultiplayerMaps.workField = "graphics"
newMultiplayerMaps.qualityContribution = "graphics"
newMultiplayerMaps.gameQuality = {
	graphics = 30
}
newMultiplayerMaps.noIssues = true
newMultiplayerMaps.taskID = "game_task"
newMultiplayerMaps.developmentType = gameProject.EXPANSION_DEV_TYPES
newMultiplayerMaps.stage = 2

taskTypes:registerNew(newMultiplayerMaps, nil)

local newMultiplayerMaps = {}

newMultiplayerMaps.id = "new_multiplayer_maps_implementation"
newMultiplayerMaps.platformWorkAffector = 0
newMultiplayerMaps.multipleEmployees = true
newMultiplayerMaps.optionalForStandard = true
newMultiplayerMaps.display = _T("CONTENT_NEW_MULTIPLAYER_MAPS_IMPLEMENTATION", "New multiplayer maps - implementation")
newMultiplayerMaps.workAmount = 60
newMultiplayerMaps.workField = "software"
newMultiplayerMaps.qualityContribution = "gameplay"
newMultiplayerMaps.gameQuality = {
	gameplay = 15
}
newMultiplayerMaps.noIssues = true
newMultiplayerMaps.taskID = "game_task"
newMultiplayerMaps.developmentType = gameProject.EXPANSION_DEV_TYPES
newMultiplayerMaps.stage = 2

taskTypes:registerNew(newMultiplayerMaps)

local npp = {}

npp.id = "new_playable_area"
npp.category = "game_content"
npp.mmoContent = 100
npp.platformWorkAffector = 0
npp.multipleEmployees = true
npp.optionalForStandard = true
npp.display = _T("CONTENT_NEW_PLAYABLE_AREA", "New playable area")
npp.workAmount = 150
npp.workField = "concept"
npp.noIssues = true
npp.gameQuality = {
	gameplay = 40
}
npp.contentPoints = {
	gameplay = 100,
	cosmetics = 100,
	campaign = 100
}
npp.qualityContribution = "graphics"
npp.taskID = "game_task"
npp.developmentType = gameProject.EXPANSION_DEV_TYPES
npp.stage = 1
npp.implementationTasks = {
	"new_playable_area_graphics",
	"new_playable_area_sound",
	"new_playable_area_world_design",
	"new_playable_area_story",
	"new_playable_area_dialogue",
	"new_playable_area_implementation"
}

function npp:canHaveTask(gameProj)
	return gameProj:getSequelTo():getGameType() == gameProject.DEVELOPMENT_TYPE.MMO
end

taskTypes:registerNew(npp, nil, "base_expansion_task")

local npp = {}

npp.id = "new_playable_area_sound"
npp.platformWorkAffector = 0
npp.multipleEmployees = true
npp.optionalForStandard = true
npp.display = _T("CONTENT_NEW_PLAYABLE_AREA_SOUND", "New playable area - audio")
npp.workAmount = 150
npp.workField = "sound"
npp.qualityContribution = "sound"
npp.gameQuality = {
	sound = 30
}
npp.noIssues = true
npp.taskID = "game_task"
npp.developmentType = gameProject.EXPANSION_DEV_TYPES
npp.stage = 2

taskTypes:registerNew(npp, nil)

local npp = {}

npp.id = "new_playable_area_world_design"
npp.platformWorkAffector = 0
npp.multipleEmployees = true
npp.optionalForStandard = true
npp.display = _T("CONTENT_NEW_PLAYABLE_AREA_WORLD_DESIGN", "New playable area - world design")
npp.workAmount = 200
npp.workField = "concept"
npp.qualityContribution = "world_design"
npp.gameQuality = {
	world_design = 30
}
npp.noIssues = true
npp.taskID = "game_task"
npp.developmentType = gameProject.EXPANSION_DEV_TYPES
npp.stage = 2

taskTypes:registerNew(npp, nil)

local npp = {}

npp.id = "new_playable_area_story"
npp.platformWorkAffector = 0
npp.multipleEmployees = true
npp.optionalForStandard = true
npp.display = _T("CONTENT_NEW_PLAYABLE_AREA_STORY", "New playable area - story")
npp.workAmount = 100
npp.workField = "writing"
npp.qualityContribution = "story"
npp.gameQuality = {
	story = 30
}
npp.noIssues = true
npp.taskID = "game_task"
npp.developmentType = gameProject.EXPANSION_DEV_TYPES
npp.stage = 2

taskTypes:registerNew(npp, nil)

local npp = {}

npp.id = "new_playable_area_dialogue"
npp.platformWorkAffector = 0
npp.multipleEmployees = true
npp.optionalForStandard = true
npp.display = _T("CONTENT_NEW_PLAYABLE_AREA_DIALOGUES", "New playable area - dialogues")
npp.workAmount = 200
npp.workField = "writing"
npp.qualityContribution = "dialogue"
npp.gameQuality = {
	dialogue = 30
}
npp.noIssues = true
npp.taskID = "game_task"
npp.developmentType = gameProject.EXPANSION_DEV_TYPES
npp.stage = 2

taskTypes:registerNew(npp, nil)

local npp = {}

npp.id = "new_playable_area_graphics"
npp.platformWorkAffector = 0
npp.multipleEmployees = true
npp.optionalForStandard = true
npp.display = _T("CONTENT_NEW_PLAYABLE_AREA_GRAPHICS", "New playable area - graphics")
npp.workAmount = 200
npp.workField = "graphics"
npp.qualityContribution = "graphics"
npp.gameQuality = {
	graphics = 30
}
npp.noIssues = true
npp.taskID = "game_task"
npp.developmentType = gameProject.EXPANSION_DEV_TYPES
npp.stage = 2

taskTypes:registerNew(npp, nil)

local npp = {}

npp.id = "new_playable_area_implementation"
npp.platformWorkAffector = 0
npp.multipleEmployees = true
npp.optionalForStandard = true
npp.display = _T("CONTENT_NEW_PLAYABLE_AREA_IMPLEMENTATION", "New playable area - implementation")
npp.workAmount = 200
npp.workField = "software"
npp.qualityContribution = "gameplay"
npp.gameQuality = {
	gameplay = 15
}
npp.noIssues = true
npp.taskID = "game_task"
npp.developmentType = gameProject.EXPANSION_DEV_TYPES
npp.stage = 2

taskTypes:registerNew(npp)
require("game/game/tasktypes_audio")
require("game/game/tasktypes_story")
require("game/game/tasktypes_graphics")
require("game/game/tasktypes_gameplay")
require("game/game/tasktypes_dialogue")
require("game/game/tasktypes_world_design")
require("game/game/tasktypes_perspective")
require("game/game/tasktypes_microtransactions")
require("game/game/tasktypes_mmo")
require("game/game/tasktypes_drm")
