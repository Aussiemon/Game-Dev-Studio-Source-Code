taskTypes:registerCategoryTitle("game_world_design", _T("WORLD_DESIGN", "World design"), nil, nil, nil, nil, "category_world_design")

local worldDesign_level1 = {}

worldDesign_level1.id = "world_design_1"
worldDesign_level1.platformWorkAffector = 0
worldDesign_level1.category = "game_world_design"
worldDesign_level1.optionCategory = "world_design_quality"
worldDesign_level1.display = _T("WORLD_DESIGN_1", "Basic world design")
worldDesign_level1.mmoContent = 4
worldDesign_level1.workAmount = 65
worldDesign_level1.workField = "concept"
worldDesign_level1.minimumLevel = 10
worldDesign_level1.noIssues = true
worldDesign_level1.multipleEmployees = true
worldDesign_level1.optionalForStandard = false
worldDesign_level1.qualityContribution = "world_design"
worldDesign_level1.taskID = "game_task"
worldDesign_level1.directKnowledgeContribution = {
	multiplier = 0.001,
	knowledge = "photography"
}
worldDesign_level1.gameQuality = {
	world_design = 32
}
worldDesign_level1.stage = 2

taskTypes:registerNew(worldDesign_level1)

local worldDesign_level2 = {}

worldDesign_level2.id = "world_design_2"
worldDesign_level2.platformWorkAffector = 0
worldDesign_level2.category = "game_world_design"
worldDesign_level2.display = _T("WORLD_DESIGN_2", "Advanced world design")
worldDesign_level2.optionCategory = "world_design_quality"
worldDesign_level2.mmoContent = 7
worldDesign_level2.workAmount = 100
worldDesign_level2.workField = "concept"
worldDesign_level2.minimumLevel = 30
worldDesign_level2.noIssues = true
worldDesign_level2.taskID = "game_task"
worldDesign_level2.requiresResearch = true
worldDesign_level2.multipleEmployees = true
worldDesign_level2.optionalForStandard = false
worldDesign_level2.releaseDate = {
	year = 1995,
	month = 3
}
worldDesign_level2.directKnowledgeContribution = {
	multiplier = 0.001,
	knowledge = "photography"
}
worldDesign_level2.qualityContribution = "world_design"
worldDesign_level2.gameQuality = {
	world_design = 50
}
worldDesign_level2.stage = 2

taskTypes:registerNew(worldDesign_level2)

local worldDesign_level3 = {}

worldDesign_level3.id = "world_design_3"
worldDesign_level3.platformWorkAffector = 0
worldDesign_level3.category = "game_world_design"
worldDesign_level3.display = _T("WORLD_DESIGN_3", "Expert world design")
worldDesign_level3.optionCategory = "world_design_quality"
worldDesign_level3.workAmount = 200
worldDesign_level3.workField = "concept"
worldDesign_level3.minimumLevel = 50
worldDesign_level3.noIssues = true
worldDesign_level3.taskID = "game_task"
worldDesign_level3.requiresResearch = true
worldDesign_level3.multipleEmployees = true
worldDesign_level3.optionalForStandard = false
worldDesign_level3.qualityContribution = "world_design"
worldDesign_level3.releaseDate = {
	year = 2000,
	month = 7
}
worldDesign_level3.directKnowledgeContribution = {
	multiplier = 0.001,
	knowledge = "photography"
}
worldDesign_level3.gameQuality = {
	world_design = 100
}
worldDesign_level3.stage = 2

taskTypes:registerNew(worldDesign_level3)

local detailedEnvironments = {}

detailedEnvironments.id = "detailed_environments"
detailedEnvironments.platformWorkAffector = 0
detailedEnvironments.mmoContent = 4
detailedEnvironments.category = "game_world_design"
detailedEnvironments.display = _T("DETAILED_ENVIRONMENTS", "Detailed environments")
detailedEnvironments.description = {
	{
		font = "pix20",
		text = _T("DETAILED_ENVIRONMENTS_DESCRIPTION_1", "Spend extra time adding various small details to levels.")
	},
	{
		font = "pix18",
		text = _T("DETAILED_ENVIRONMENTS_DESCRIPTION_2", "The little things make the entire experience that much more fun.")
	}
}
detailedEnvironments.workAmount = 100
detailedEnvironments.workField = "concept"
detailedEnvironments.minimumLevel = 30
detailedEnvironments.noIssues = true
detailedEnvironments.multipleEmployees = true
detailedEnvironments.taskID = "game_task"
detailedEnvironments.directKnowledgeContribution = {
	multiplier = 0.00025,
	knowledge = "photography"
}
detailedEnvironments.releaseDate = {
	year = 1991,
	month = 3
}
detailedEnvironments.qualityContribution = "world_design"
detailedEnvironments.gameQuality = {
	world_design = 50
}
detailedEnvironments.stage = 2

taskTypes:registerNew(detailedEnvironments)

local seamlessLevels = {}

seamlessLevels.id = "seamless_level_transitioning"
seamlessLevels.platformWorkAffector = 0.25
seamlessLevels.mmoContent = 6
seamlessLevels.category = "game_world_design"
seamlessLevels.display = _T("SEAMLESS_LEVEL_TRANSITIONING", "Seamless level transitioning")
seamlessLevels.specBoost = {
	id = "algorithms",
	boost = 1.15
}
seamlessLevels.description = {
	{
		font = "pix20",
		text = _T("SEAMLESS_LEVEL_TRANSITIONING_DESCRIPTION_1", "Implement a feature which allows for seamless transitioning of in-game levels.")
	}
}
seamlessLevels.workAmount = 150
seamlessLevels.workField = "software"
seamlessLevels.minimumLevel = 25
seamlessLevels.noIssues = true
seamlessLevels.multipleEmployees = true
seamlessLevels.taskID = "game_task"
seamlessLevels.requiresResearch = true
seamlessLevels.releaseDate = {
	year = 1996,
	month = 3
}
seamlessLevels.qualityContribution = "world_design"
seamlessLevels.gameQuality = {
	world_design = 75
}
seamlessLevels.stage = 2

taskTypes:registerNew(seamlessLevels)

local persistentWorld = {}

persistentWorld.id = "persistent_world"
persistentWorld.platformWorkAffector = 0.25
persistentWorld.mmoContent = 12
persistentWorld.category = "game_world_design"
persistentWorld.display = _T("PERSISTENT_WORLD", "Persistent world")
persistentWorld.specBoost = {
	id = "algorithms",
	boost = 1.15
}
persistentWorld.description = {
	{
		font = "pix20",
		text = _T("PERSISTENT_WORLD_DESCRIPTION", "A system which saves all the changes that have occured in the game world.")
	}
}
persistentWorld.workAmount = 70
persistentWorld.workField = "software"
persistentWorld.minimumLevel = 25
persistentWorld.noIssues = true
persistentWorld.multipleEmployees = true
persistentWorld.taskID = "game_task"
persistentWorld.requiresResearch = true
persistentWorld.releaseDate = {
	year = 1993,
	month = 1
}
persistentWorld.qualityContribution = "world_design"
persistentWorld.gameQuality = {
	world_design = 35
}
persistentWorld.stage = 2

taskTypes:registerNew(persistentWorld)

local dayNightCycle = {}

dayNightCycle.id = "day_night_cycle"
dayNightCycle.platformWorkAffector = 0.15
dayNightCycle.mmoContent = 4
dayNightCycle.category = "game_world_design"
dayNightCycle.display = _T("DAY_NIGHT_CYCLE", "Day-night cycle")
dayNightCycle.specBoost = {
	id = "algorithms",
	boost = 1.15
}
dayNightCycle.description = {
	{
		font = "pix20",
		text = _T("DAY_NIGHT_CYCLE_DESCRIPTION", "A dynamic switch in night and day helps immerse players in the game.")
	}
}
dayNightCycle.workAmount = 60
dayNightCycle.workField = "software"
dayNightCycle.minimumLevel = 20
dayNightCycle.noIssues = true
dayNightCycle.multipleEmployees = true
dayNightCycle.taskID = "game_task"
dayNightCycle.requiresResearch = true
dayNightCycle.releaseDate = {
	year = 1996,
	month = 2
}
dayNightCycle.qualityContribution = "world_design"
dayNightCycle.gameQuality = {
	world_design = 30
}
dayNightCycle.stage = 2

taskTypes:registerNew(dayNightCycle)

local weatherSystem = {}

weatherSystem.id = "weather_system"
weatherSystem.platformWorkAffector = 0.15
weatherSystem.mmoContent = 4
weatherSystem.category = "game_world_design"
weatherSystem.display = _T("WEATHER_SYSTEM", "Weather system")
weatherSystem.specBoost = {
	id = "algorithms",
	boost = 1.15
}
weatherSystem.description = {
	{
		font = "pix20",
		text = _T("WEATHER_SYSTEM_DESCRIPTION", "Whether it's snowing or the sun is shining - if it happens in real time while you're playing, it helps a lot with immersion.")
	}
}
weatherSystem.workAmount = 60
weatherSystem.workField = "software"
weatherSystem.minimumLevel = 20
weatherSystem.noIssues = true
weatherSystem.multipleEmployees = true
weatherSystem.taskID = "game_task"
weatherSystem.requiresResearch = true
weatherSystem.releaseDate = {
	year = 1998,
	month = 3
}
weatherSystem.qualityContribution = "world_design"
weatherSystem.gameQuality = {
	world_design = 30
}
weatherSystem.stage = 2

taskTypes:registerNew(weatherSystem)
