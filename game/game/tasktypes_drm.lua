taskTypes:registerCategoryTitle(gameProject.DRM_CATEGORY, _T("DRM_CATEGORY_TITLE", "Digital Rights Management"), nil, nil, true, gameProject.PRIORITY_MIN)

local drm = {}

drm.id = gameProject.DRM_TASK
drm.category = gameProject.DRM_CATEGORY
drm.display = _T("TASK_DRM_ANTI_PIRACY_MEASURES", "Anti-piracy measures")
drm.description = {
	{
		font = "pix20",
		text = _T("TASK_DRM_ANTI_PIRACY_MEASURES_DESC_1", "Implement anti-piracy measures into the game, which will offset the time until the game is cracked.")
	},
	{
		font = "bh18",
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("TASK_DRM_ANTI_PIRACY_MEASURES_DESC_2", "The category Priority value determines how heavy the measures will be. Keep in mind that customers might not be very happy about heavy DRM."),
		color = game.UI_COLORS.LIGHT_BLUE
	}
}
drm.platformWorkAffector = 0.5
drm.multipleEmployees = true
drm.workAmount = 100
drm.workField = "software"
drm.minimumLevel = 5
drm.specBoost = {
	id = "algorithms",
	boost = 1.15
}
drm.optionCategory = "drm"
drm.optionalForStandard = true
drm.taskID = "game_task"
drm.stage = 2
drm.cost = 300000
drm.baseDRMValue = 0.25
drm.drmValue = 1

function drm:onFinish(taskObject)
	local proj = taskObject:getProject()
	
	proj:increaseDRMValue(self.baseDRMValue + self.drmValue * proj:getCategoryPriority(gameProject.DRM_CATEGORY))
end

taskTypes:registerNew(drm)
