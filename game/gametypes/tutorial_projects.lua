local tutProjects = {}

tutProjects.id = "tutorial_projects"
tutProjects.trackCompletion = true
tutProjects.display = _T("TUTORIAL_PROJECTS", "Tutorial - Projects")
tutProjects.description = _T("TUTORIAL_PROJECTS_DESCRIPTION", "A part of the main 'Construction' tutorial, which starts after employees have been explained, and the game moves on to explain the basics of engines and game projects.")
tutProjects.orderWeight = 0.2
tutProjects.objectiveList = {
	"tutorial_projects_1"
}
tutProjects.startTime = timeline.DAYS_IN_MONTH * 4
tutProjects.THE_INVESTOR_STRING_NAME = _T("INVESTOR_NAME", "The Investor")
tutProjects.map = "tutorial"
tutProjects.rivals = {}
tutProjects.catchableEvents = {
	objectiveHandler.EVENTS.CLAIMED_OBJECTIVE
}
tutProjects.startingHUDVisibility = 3
tutProjects.achievementOnFinish = achievements.ENUM.TUTORIAL
tutProjects.tutorial = true
tutProjects.checkTutorial = false
tutProjects.startMoney = 2000000

local hireTime = {
	year = {
		1988,
		1988
	},
	month = {
		1,
		4
	}
}

tutProjects.startingEmployees = {
	{
		role = "software_engineer",
		level = {
			3,
			5
		},
		hireTime = hireTime
	},
	{
		role = "software_engineer",
		level = {
			3,
			5
		},
		hireTime = hireTime
	},
	{
		role = "designer",
		level = {
			3,
			5
		},
		hireTime = hireTime
	},
	{
		role = "manager",
		level = {
			3,
			5
		},
		hireTime = hireTime
	},
	{
		role = "sound_engineer",
		level = {
			3,
			5
		},
		hireTime = hireTime
	},
	{
		role = "artist",
		level = {
			3,
			5
		},
		hireTime = hireTime
	}
}

function tutProjects:startCallback()
	tutProjects.baseClass.startCallback(self)
	self:giveStartingEmployees()
end

tutProjects.hudRestrictions = {}

game.registerGameType(tutProjects, "tutorial_employees")
