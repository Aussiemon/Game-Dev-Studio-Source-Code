taskTypes:registerCategoryTitle(gameProject.PERSPECTIVE_CATEGORY, _T("PERSPECTIVE", "Perspective"), false, {
	{
		font = "bh18",
		icon = "question_mark",
		iconHeight = 20,
		lineSpace = 6,
		iconWidth = 20,
		text = _T("PERSPECTIVE_DESCRIPTION_1", "A game can not have development started on it without a set perspective in mind.")
	},
	{
		font = "pix18",
		text = _T("PERSPECTIVE_DESCRIPTION_2", "Be careful, as not all game genres work well with every perspective.")
	}
}, true, nil, "category_perspective")

local firstPerson = {}

firstPerson.id = "first_person_perspective"
firstPerson.platformWorkAffector = 0.1
firstPerson.mmoContent = 5
firstPerson.category = gameProject.PERSPECTIVE_CATEGORY
firstPerson.optionCategory = gameProject.PERSPECTIVE_CATEGORY
firstPerson.display = _T("FIRST_PERSON_PERSPECTIVE", "First person")
firstPerson.multipleEmployees = true
firstPerson.workAmount = 60
firstPerson.noIssues = true
firstPerson.workField = "concept"
firstPerson.taskID = "game_task"
firstPerson.gameQuality = {
	gameplay = 30
}
firstPerson.qualityContribution = "gameplay"
firstPerson.stage = 2
firstPerson.doesNotCountAsFeature = true
firstPerson.qualityScaleByGenre = {
	fighting = 1.2,
	racing = 1.5,
	action = 1.1,
	sandbox = 1,
	strategy = 0.7,
	simulation = 1,
	horror = 1.1,
	adventure = 1,
	rpg = 1
}

function firstPerson:onFinish(taskObject)
	taskObject:getProject():setFact("perspective", self.id)
end

function firstPerson:getGenreMatch(projectObject)
	return self.qualityScaleByGenre[projectObject:getGenre()]
end

function firstPerson:onProjectFinish(taskObject)
	local projectObject = taskObject:getProject()
	local level = projectObject:getQuality(self.qualityContribution)
	
	projectObject:addQualityPoint(self.qualityContribution, level * (self.qualityScaleByGenre[gameProj:getGenre()] or 1) - level, false, false)
end

function firstPerson:adjustQualityScore(gameProj, qualityID, level)
	if qualityID == "gameplay" then
		return level * self.qualityScaleByGenre[gameProj:getGenre()] or 1
	end
	
	return level
end

function firstPerson:getDescription(projectObject)
	local description = {}
	local validKnowledge = false
	
	for key, genreData in ipairs(genres.registered) do
		if studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.PERSPECTIVE_MATCHING, genreData.id, self.id) then
			local quality = self.qualityScaleByGenre[genreData.id]
			
			if quality ~= 1 then
				local sign, color = game.getContributionSign(1, quality, 0.1, 3, nil, nil, false)
				local finalText = _format(_T("GENRE_NAME_PERSPECTIVE_MATCH", "SIGN GENRE"), "SIGN", sign, "GENRE", genreData.display)
				
				table.insert(description, {
					font = "pix18",
					text = finalText,
					color = color,
					icon = genres:getGenreUIIconConfig(genreData, 22, 22, 20)
				})
				
				validKnowledge = true
			else
				table.insert(description, {
					font = "pix18",
					text = _format(_T("GENRE_PERSPECTIVE_MATCH_NEUTRAL", "GENRE - neutral"), "GENRE", genreData.display),
					icon = genres:getGenreUIIconConfig(genreData, 22, 22, 20)
				})
			end
		end
	end
	
	table.insert(description, 1, {
		font = "pix20",
		spacing = 10,
		text = _T("GENRE_PERSPECTIVE_MATCHING", "Genre-perspective matching:")
	})
	
	if not validKnowledge then
		table.insert(description, {
			font = "pix18",
			text = _T("NO_KNOWN_GENRE_PERSPECTIVE_MATCHING", "None known yet")
		})
	end
	
	return description
end

taskTypes:registerNew(firstPerson)

local thirdPerson = {}

thirdPerson.id = "third_person_perspective"
thirdPerson.platformWorkAffector = 0.1
thirdPerson.mmoContent = 5
thirdPerson.category = gameProject.PERSPECTIVE_CATEGORY
thirdPerson.optionCategory = gameProject.PERSPECTIVE_CATEGORY
thirdPerson.display = _T("THIRD_PERSON_PERSPECTIVE", "Third person")
thirdPerson.workAmount = 60
thirdPerson.noIssues = true
thirdPerson.workField = "concept"
thirdPerson.taskID = "game_task"
thirdPerson.gameQuality = {
	gameplay = 30
}
thirdPerson.qualityContribution = "gameplay"
thirdPerson.stage = 2
thirdPerson.qualityScaleByGenre = {
	fighting = 1.5,
	racing = 1.25,
	action = 1,
	sandbox = 1,
	strategy = 0.7,
	simulation = 1,
	horror = 0.85,
	adventure = 1,
	rpg = 1.2
}

taskTypes:registerNew(thirdPerson, nil, "first_person_perspective")

local topDown = {}

topDown.id = "top_down_perspective"
topDown.platformWorkAffector = 0.1
topDown.mmoContent = 5
topDown.category = gameProject.PERSPECTIVE_CATEGORY
topDown.optionCategory = gameProject.PERSPECTIVE_CATEGORY
topDown.display = _T("TOP_DOWN_PERSPECTIVE", "Top-down")
topDown.workAmount = 60
topDown.workField = "concept"
topDown.taskID = "game_task"
topDown.gameQuality = {
	gameplay = 30
}
topDown.qualityContribution = "gameplay"
topDown.stage = 2
topDown.qualityScaleByGenre = {
	fighting = 1,
	racing = 1,
	action = 1,
	sandbox = 1,
	strategy = 1,
	simulation = 1.1,
	horror = 0.5,
	adventure = 1,
	rpg = 1
}

taskTypes:registerNew(topDown, nil, "first_person_perspective")
