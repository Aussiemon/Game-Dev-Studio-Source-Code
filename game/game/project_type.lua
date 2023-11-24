local gameProject = {}

gameProject.id = "game_project"
gameProject.category = "game"
gameProject.isGame = true
gameProject.stages = {
	{
		tasks = {}
	},
	{
		tasks = {}
	},
	{
		tasks = {}
	}
}

projectTypes:registerNew(gameProject)
