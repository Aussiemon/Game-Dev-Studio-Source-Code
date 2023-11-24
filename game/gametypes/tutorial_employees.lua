local tutEmployees = {}

tutEmployees.id = "tutorial_employees"
tutEmployees.trackCompletion = true
tutEmployees.display = _T("TUTORIAL_EMPLOYEES", "Tutorial - Employees")
tutEmployees.description = _T("TUTORIAL_EMPLOYEES_DESCRIPTION", "A part of the main 'Construction' tutorial, which starts after construction is explained, and the game moves on to explain the basics of employees.")
tutEmployees.orderWeight = 0.1
tutEmployees.achievementOnFinish = achievements.ENUM.TUTORIAL
tutEmployees.objectiveList = {
	"tutorial_employees_1",
	"tutorial_employees_projects"
}
tutEmployees.startTime = timeline.DAYS_IN_MONTH * 4
tutEmployees.THE_INVESTOR_STRING_NAME = _T("INVESTOR_NAME", "The Investor")
tutEmployees.map = "tutorial"
tutEmployees.rivals = {}
tutEmployees.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}
tutEmployees.startingHUDVisibility = 2
tutEmployees.objects = {
	{
		class = "workplace",
		pos = {
			34,
			42
		},
		rotation = walls.UP
	},
	{
		class = "workplace",
		pos = {
			36,
			42
		},
		rotation = walls.UP
	},
	{
		class = "workplace",
		pos = {
			38,
			42
		},
		rotation = walls.UP
	},
	{
		class = "workplace",
		pos = {
			40,
			42
		},
		rotation = walls.UP
	},
	{
		class = "workplace",
		pos = {
			36,
			49
		},
		rotation = walls.DOWN
	},
	{
		class = "workplace",
		pos = {
			38,
			49
		},
		rotation = walls.DOWN
	},
	{
		class = "workplace",
		pos = {
			40,
			49
		},
		rotation = walls.DOWN
	},
	{
		class = "light_source",
		pos = {
			35,
			45
		},
		rotation = walls.UP
	},
	{
		class = "light_source",
		pos = {
			40,
			45
		},
		rotation = walls.UP
	},
	{
		class = "light_source",
		pos = {
			38,
			48
		},
		rotation = walls.UP
	},
	{
		class = "water_dispenser",
		pos = {
			35,
			50
		},
		rotation = walls.DOWN
	},
	{
		class = "toilet",
		pos = {
			43,
			50
		},
		rotation = walls.DOWN
	},
	{
		class = "sink",
		pos = {
			42,
			50
		},
		rotation = walls.DOWN
	},
	{
		class = "toilet_paper",
		pos = {
			43,
			49
		},
		rotation = walls.RIGHT
	},
	{
		class = "light_source",
		pos = {
			42,
			49
		},
		rotation = walls.UP
	}
}
tutEmployees.tutorial = true
tutEmployees.checkTutorial = false
tutEmployees.startMoney = 1000000

game.registerGameType(tutEmployees, "tutorial_construction")
