taskTypes:registerCategoryTitle("game_story", _T("STORY", "Story"), nil, nil, nil, nil, "category_story")

local linearStory = {}

linearStory.id = "linear_story"
linearStory.category = "game_story"
linearStory.platformWorkAffector = 0
linearStory.mmoContent = 7
linearStory.display = _T("LINEAR_STORY", "Linear story")
linearStory.workAmount = 60
linearStory.workField = "writing"
linearStory.multipleEmployees = true
linearStory.noIssues = true
linearStory.optionalForStandard = false
linearStory.optionCategory = "story_type"
linearStory.gameQuality = {
	story = 30
}
linearStory.qualityContribution = "story"
linearStory.taskID = "game_task"
linearStory.stage = 2

taskTypes:registerNew(linearStory)

local branchingStory = {}

branchingStory.id = "branching_story"
branchingStory.platformWorkAffector = 0
branchingStory.mmoContent = 10
branchingStory.category = "game_story"
branchingStory.display = _T("BRANCHING_STORY", "Branching story")
branchingStory.workAmount = 100
branchingStory.workField = "writing"
branchingStory.multipleEmployees = true
branchingStory.noIssues = true
branchingStory.optionalForStandard = false
branchingStory.optionCategory = "story_type"
branchingStory.gameQuality = {
	story = 80
}
branchingStory.qualityContribution = "story"
branchingStory.taskID = "game_task"
branchingStory.stage = 2

taskTypes:registerNew(branchingStory)

local backstories = {}

backstories.id = "indepth_backstories"
backstories.platformWorkAffector = 0
backstories.mmoContent = 5
backstories.category = "game_story"
backstories.display = _T("IN_DEPTH_BACKSTORIES", "In-depth backstories")
backstories.workAmount = 100
backstories.workField = "writing"
backstories.multipleEmployees = true
backstories.noIssues = true
backstories.gameQuality = {
	story = 50
}
backstories.qualityContribution = "story"
backstories.taskID = "game_task"
backstories.stage = 2

taskTypes:registerNew(backstories)

local multipleEndings = {}

multipleEndings.id = "multiple_endings"
multipleEndings.platformWorkAffector = 0
multipleEndings.category = "game_story"
multipleEndings.display = _T("MULTIPLE_ENDINGS", "Multiple endings")
multipleEndings.workAmount = 100
multipleEndings.workField = "writing"
multipleEndings.multipleEmployees = true
multipleEndings.noIssues = true
multipleEndings.gameQuality = {
	story = 50
}
multipleEndings.qualityContribution = "story"
multipleEndings.taskID = "game_task"
multipleEndings.stage = 2
multipleEndings.implementationTasks = {
	"multiple_endings_implementation"
}
multipleEndings.developmentType = gameProject.NEW_GAME_DEV_TYPES

taskTypes:registerNew(multipleEndings)

local multipleEndings = {}

multipleEndings.id = "multiple_endings_implementation"
multipleEndings.platformWorkAffector = 0.1
multipleEndings.category = "game_story"
multipleEndings.display = _T("MULTIPLE_ENDINGS_IMPLEMENTATION", "Multiple endings - implementation")
multipleEndings.specBoost = {
	id = "algorithms",
	boost = 1.15
}
multipleEndings.invisible = true
multipleEndings.workAmount = 100
multipleEndings.workField = "software"
multipleEndings.multipleEmployees = true
multipleEndings.noIssues = true
multipleEndings.taskID = "game_task"
multipleEndings.stage = 2

taskTypes:registerNew(multipleEndings)

local dynamicNarration = {}

dynamicNarration.id = "dynamic_narration"
dynamicNarration.category = "game_story"
dynamicNarration.mmoContent = 7
dynamicNarration.display = _T("DYNAMIC_NARRATION", "Dynamic narration")
dynamicNarration.platformWorkAffector = 0
dynamicNarration.workAmount = 100
dynamicNarration.workField = "writing"
dynamicNarration.noIssues = true
dynamicNarration.multipleEmployees = true
dynamicNarration.gameQuality = {
	story = 50
}
dynamicNarration.qualityContribution = "story"
dynamicNarration.taskID = "game_task"
dynamicNarration.stage = 2
dynamicNarration.implementationTasks = {
	"dynamic_narration_implementation"
}
dynamicNarration.requiresResearch = true
dynamicNarration.releaseDate = {
	year = 1994,
	month = 4
}

taskTypes:registerNew(dynamicNarration)

local dynamicNarration = {}

dynamicNarration.id = "dynamic_narration_implementation"
dynamicNarration.platformWorkAffector = 0.1
dynamicNarration.category = "game_story"
dynamicNarration.display = _T("DYNAMIC_NARRATION_IMPLEMENTATION", "Dynamic narration - implementation")
dynamicNarration.specBoost = {
	id = "algorithms",
	boost = 1.15
}
dynamicNarration.invisible = true
dynamicNarration.multipleEmployees = true
dynamicNarration.workAmount = 100
dynamicNarration.workField = "software"
dynamicNarration.noIssues = true
dynamicNarration.taskID = "game_task"
dynamicNarration.stage = 2

taskTypes:registerNew(dynamicNarration)

local cutscenes = {}

cutscenes.id = "cutscenes"
cutscenes.category = "game_story"
cutscenes.display = _T("CUTSCENES", "Cutscenes")
cutscenes.workAmount = 100
cutscenes.mmoContent = 7
cutscenes.workField = "writing"
cutscenes.noIssues = true
cutscenes.multipleEmployees = true
cutscenes.gameQuality = {
	story = 50
}
cutscenes.qualityContribution = "story"
cutscenes.taskID = "game_task"
cutscenes.stage = 2
cutscenes.implementationTasks = {
	"cutscenes_implementation"
}
cutscenes.requiresResearch = true
cutscenes.releaseDate = {
	year = 1996,
	month = 2
}

taskTypes:registerNew(cutscenes)

local cutscenes = {}

cutscenes.id = "cutscenes_implementation"
cutscenes.platformWorkAffector = 0.15
cutscenes.category = "game_story"
cutscenes.display = _T("CUTSCENES_IMPLEMENTATION", "Cutscenes - implementation")
cutscenes.specBoost = {
	id = "algorithms",
	boost = 1.15
}
cutscenes.invisible = true
cutscenes.multipleEmployees = true
cutscenes.workAmount = 200
cutscenes.workField = "software"
cutscenes.noIssues = true
cutscenes.taskID = "game_task"
cutscenes.stage = 2

taskTypes:registerNew(cutscenes)
