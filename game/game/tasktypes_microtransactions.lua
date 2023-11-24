taskTypes:registerCategoryTitle(gameProject.MICROTRANSACTIONS_CATEGORY, _T("CATEGORY_MICROTRANSACTIONS", "Microtransactions"), false, {
	{
		font = "bh18",
		icon = "question_mark",
		iconHeight = 20,
		lineSpace = 6,
		iconWidth = 20,
		text = _T("MICROTRANSCATIONS_DESCRIPTION_1", "Microtransactions can provide a source of income after game sales are over, provided you do not push them too hard.")
	},
	{
		font = "pix18",
		text = _T("MICROTRANSCATIONS_DESCRIPTION_2", "Increasing the priority will increase the total amount of microtransactions, which can increase money earned, provided the platform owners do not get frustrated.")
	}
}, true, gameProject.PRIORITY_MIN)
taskTypes:registerNew({
	noIssues = false,
	mmoComplexity = 1,
	stage = 2,
	logicID = "microtransactions_logic_piece",
	workAmount = 100,
	multipleEmployees = true,
	taskID = "game_task",
	requiresResearch = true,
	workField = "software",
	optionalForStandard = true,
	qualityContribution = "gameplay",
	id = "in_app_purchases",
	platformWorkAffector = 0.45,
	minimumLevel = 20,
	category = gameProject.MICROTRANSACTIONS_CATEGORY,
	display = _T("IN_APP_PURCHASES", "In-app purchases"),
	specBoost = {
		id = "algorithms",
		boost = 1.15
	},
	releaseDate = {
		year = 2003,
		month = 3
	},
	issues = {
		"p0",
		"p1"
	},
	onFinish = function(self, taskObject)
		local projObj = taskObject:getProject()
		
		if projObj then
			projObj:addPendingLogicPiece(self.id)
		end
	end,
	verifyLogicPiece = function(self, gameProj)
		local piece = logicPieces.create(self.logicID)
		
		piece:setupLongevity(gameProj)
		gameProj:addLogicPiece(piece)
	end,
	canHaveTask = function(self, gameProj)
		return gameProject.MICROTRANSACTIONS_DEV_CATEGORIES[gameProj:getGameType()]
	end
})
game.registerTimedPopup("in_app_purchases_available", _T("MICROTRANSACTIONS_NOW_AVAILABLE", "Microtransactions now available"), _T("MICROTRANSACTIONS_NOW_AVAILABLE_DESC", "Game developers, especially businessmen, are abuzz about a new potential idea for further monetization of video games - microtransactions.\n\nYou can now implement in-app purchases into your games, which can serve as an additional source of income, provided the game is good and you don't push microtransactions too hard."), "bh24", "pix20", {
	year = 2003,
	month = 3
}, nil, nil)
