local engineProject = {}

engineProject.id = "engine_project"
engineProject.category = "engine"
engineProject.stages = {
	{
		tasks = {}
	}
}

projectTypes:registerNew(engineProject)

local revampProject = {}

revampProject.id = "engine_revamp_project"
revampProject.category = "engine"
revampProject.stages = {
	{
		tasks = {}
	}
}

projectTypes:registerNew(revampProject)
