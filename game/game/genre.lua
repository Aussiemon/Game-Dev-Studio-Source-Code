genres = {}
genres.registered = {}
genres.registeredByID = {}
genres.subgenreMatches = {}
genres.allowImportanceListRebuilding = false
genres.SUBGENRE_DEFAULT_MATCH = 1
genres.SUBGENRE_MATCH_NORMAL = 1
genres.SUBGENRE_MATCH_BETTER = 1.1
genres.SUBGENRE_MATCH_GOOD = 1.25
genres.SUBGENRE_MATCH_VERY_GOOD = 1.35
genres.SUBGENRE_MATCH_BAD = 0.75
genres.SUBGENRE_MATCH_VERY_BAD = 0.5

function genres:registerNew(data)
	table.insert(genres.registered, data)
	
	genres.registeredByID[data.id] = data
	data.icon = data.icon or "gameplay_quality"
	data.scoreDivider = 0
	
	for key, qualityType in ipairs(gameQuality.registered) do
		if not data.scoreImpact[qualityType.id] then
			data.scoreImpact[qualityType.id] = 1
		end
		
		data.scoreDivider = data.scoreDivider + data.scoreImpact[qualityType.id]
	end
	
	if genres.allowImportanceListRebuilding then
		gameQuality:rebuildContributionImportanceLists()
		themes:verifyMatchForGenre(data)
		audience:verifyMatchForGenre(data)
		
		if not genres.subgenreMatches[data.id] then
			local target = {}
			
			genres.subgenreMatches[data.id] = target
			
			for key, genreData in ipairs(genres.registered) do
				if genreData.id ~= data.id then
					target[genreData.id] = genres.SUBGENRE_DEFAULT_MATCH
					genres.subgenreMatches[genreData.id][data.id] = genres.SUBGENRE_DEFAULT_MATCH
				end
			end
		end
	else
		genres.subgenreMatches[data.id] = {}
	end
end

function genres:getSubgenreMatch(genre, subgenre)
	return genres.subgenreMatches[genre][subgenre]
end

function genres:registerSubgenreMatch(genreOne, genreTwo, match)
	genres.subgenreMatches[genreOne][genreTwo] = match
	genres.subgenreMatches[genreTwo][genreOne] = match
end

function genres:registerSubgenreMatches(genreID, genreList)
	local subgenreMatches = genres.subgenreMatches
	local target = subgenreMatches[genreID]
	
	for otherGenre, match in pairs(genreList) do
		target[otherGenre] = match
		subgenreMatches[otherGenre][genreID] = match
	end
end

genres.DEFAULT_MMO_MATCH = 1

function genres:postLoadedMods()
	local genreList = self.registered
	
	for key, data in ipairs(taskTypes:getTasksByCategory(gameProject.PERSPECTIVE_CATEGORY)) do
		local qualityScale = data.qualityScaleByGenre
		
		if qualityScale then
			for key, gData in ipairs(genreList) do
				if not qualityScale[gData.id] then
					qualityScale[gData.id] = 1
				end
			end
		end
	end
	
	for key, data in ipairs(platformParts.registeredByPartType[platformParts.TYPES.CONTROLLER]) do
		local genreMatch = data.genreMatch
		
		for key, gData in ipairs(genreList) do
			if not genreMatch[gData.id] then
				genreMatch[gData.id] = 1
			end
		end
	end
	
	local default = genres.DEFAULT_MMO_MATCH
	
	for key, data in ipairs(taskTypes.registered) do
		local mmoMatch = data.mmoMatch
		
		if mmoMatch then
			for key, genreData in ipairs(genreList) do
				if not mmoMatch[genreData.id] then
					mmoMatch[genreData.id] = default
					
					print(_format("WARNING: missing MMO match value for genre 'GENRE', applying default value of DEFAULT", "GENRE", genreData.id, "DEFAULT", default))
				end
			end
		end
	end
	
	for key, platformData in ipairs(platforms.registered) do
		local genreMatch = platformData.genreMatching
		
		for key, gData in ipairs(genreList) do
			if not genreMatch[gData.id] then
				genreMatch[gData.id] = platforms.DEFAULT_PLATFORM_MATCH
			end
		end
	end
end

function genres:getName(genreid)
	return genres.registeredByID[genreid].display
end

function genres:getData(id)
	return genres.registeredByID[id]
end

function genres:getScoreImpact(project)
	return genres.registeredByID[project:getGenre()].scoreImpact
end

function genres:findMostContributingAspect(genre)
	local highest, id = -math.huge
	
	for quality, multiplier in pairs(genres.registeredByID[genre].scoreImpact) do
		if highest < multiplier then
			highest = multiplier
			id = quality
		end
	end
	
	return id, highest
end

local revealedTheme = {}

function genres:getRevealedThemeMatching(theme)
	table.clearArray(revealedTheme)
	
	local themeMatch = studio.CONTRIBUTION_REVEAL_TYPES.THEME_MATCHING
	
	for key, genreData in ipairs(genres.registered) do
		if studio:isGameQualityMatchRevealed(themeMatch, theme, genreData.id) then
			revealedTheme[#revealedTheme + 1] = genreData
		end
	end
	
	return revealedTheme
end

local revealedSubgenres = {}

function genres:getRevealedSubgenreMatching(subgenreID)
	table.clearArray(revealedSubgenres)
	
	local subgenreMatch = studio.CONTRIBUTION_REVEAL_TYPES.SUBGENRE_MATCHING
	
	for key, genreData in ipairs(genres.registered) do
		if genreData.id ~= subgenreID and studio:isGameQualityMatchRevealed(subgenreMatch, subgenreID, genreData.id) then
			revealedSubgenres[#revealedSubgenres + 1] = genreData
		end
	end
	
	return revealedSubgenres
end

local researchedGenres = {}

function genres:getResearchedGenres()
	table.clearArray(researchedGenres)
	
	for key, genreData in ipairs(genres.registered) do
		if studio:isGenreResearched(genreData.id) then
			researchedGenres[#researchedGenres + 1] = genreData
		end
	end
	
	return researchedGenres
end

local unresearchedGenres = {}

function genres:getUnresearchedGenres()
	table.clearArray(unresearchedGenres)
	
	for key, genreData in ipairs(genres.registered) do
		if not studio:isGenreResearched(genreData.id) then
			unresearchedGenres[#unresearchedGenres + 1] = genreData
		end
	end
	
	return unresearchedGenres
end

local inUseResearchGenres = {}

function genres:getValidResearchGenres()
	local designTask = task:getData("design_task")
	
	for key, employeeObj in ipairs(studio:getEmployees()) do
		local task = employeeObj:getTask()
		
		if task and task:getID() == designTask.id and task:getDesignType() == designTask.TYPES.GENRE then
			inUseResearchGenres[task:getResearchID()] = true
		end
	end
	
	table.clearArray(unresearchedGenres)
	
	for key, genreData in ipairs(genres.registered) do
		if not studio:isGenreResearched(genreData.id) and not inUseResearchGenres[genreData.id] then
			unresearchedGenres[#unresearchedGenres + 1] = genreData
		end
	end
	
	table.clear(inUseResearchGenres)
	
	return unresearchedGenres
end

function genres:areAllGenresResearched()
	for key, genreData in ipairs(genres.registered) do
		if not studio:isGenreResearched(genreData.id) then
			return false
		end
	end
	
	return true
end

function genres:getIconUISize(data, backdropW, backdropH, iconSize)
	local qData = quadLoader:getQuadStructure(data.icon)
	local scaler = qData:getScaleToSize(iconSize)
	local iconW, iconH = qData.w * scaler, qData.h * scaler
	local iconX = backdropW * 0.5 - iconW * 0.5
	
	return iconX, iconW, iconH
end

function genres:getGenreUIIconConfig(data, backdropW, backdropH, iconSize)
	local iconX, iconW, iconH = self:getIconUISize(data, backdropW, backdropH, iconSize)
	
	return {
		{
			icon = "profession_backdrop",
			width = backdropW,
			height = backdropH
		},
		{
			y = 0,
			icon = data.icon,
			width = iconW,
			height = iconH,
			x = iconX
		}
	}
end

function genres:preserveScoreImpacts()
	self.originalScoreImpacts = {}
	
	for key, data in ipairs(genres.registered) do
		self.originalScoreImpacts[data.id] = {}
		
		local matchList = self.originalScoreImpacts[data.id]
		local matching = data.scoreImpact
		
		for key, qualityData in ipairs(gameQuality.registered) do
			matchList[qualityData.id] = matching[qualityData.id]
		end
	end
end

function genres:restoreScoreImpacts()
	for key, data in ipairs(genres.registered) do
		local matchList = self.originalScoreImpacts[data.id]
		local matching = data.scoreImpact
		
		for key, qualityData in ipairs(gameQuality.registered) do
			matching[qualityData.id] = matchList[qualityData.id]
		end
	end
end

function genres:randomizeScoreImpact()
	self:preserveScoreImpacts()
	
	local keyList, matchList, qualityMatchCorrelationList = {}, {}, {}
	
	for key, data in ipairs(genres.registered) do
		for key, qualityData in ipairs(gameQuality.registered) do
			keyList[#keyList + 1] = qualityData.id
			matchList[#matchList + 1] = data.scoreImpact[qualityData.id]
			qualityMatchCorrelationList[#qualityMatchCorrelationList + 1] = qualityData.id
		end
		
		data.replacedScoreImpacts = {}
		
		while #keyList > 0 do
			local randomQuality = table.remove(keyList, math.random(1, #keyList))
			local randomMatchIndex = math.random(1, #matchList)
			local randomMatch = table.remove(matchList, randomMatchIndex)
			local selectedQualityReplacement = table.remove(qualityMatchCorrelationList, randomMatchIndex)
			
			data.scoreImpact[randomQuality] = randomMatch
			data.replacedScoreImpacts[#data.replacedScoreImpacts + 1] = {
				from = selectedQualityReplacement,
				to = randomQuality
			}
		end
	end
end

function genres:saveScoreImpacts()
	local saved = {}
	
	for key, data in ipairs(genres.registered) do
		saved[#saved + 1] = {
			id = data.id,
			replacedScoreImpacts = data.replacedScoreImpacts
		}
	end
	
	return saved
end

function genres:loadScoreImpacts(data)
	self:preserveScoreImpacts()
	
	for key, genreData in ipairs(data) do
		local targetGenre = genres.registeredByID[genreData.id]
		
		if targetGenre then
			local originalScoreImpacts = self.originalScoreImpacts[genreData.id]
			
			if genreData.replacedScoreImpacts then
				for key, replacementData in ipairs(genreData.replacedScoreImpacts) do
					targetGenre.scoreImpact[replacementData.to] = originalScoreImpacts[replacementData.from]
				end
				
				targetGenre.replacedScoreImpacts = genreData.replacedScoreImpacts
			end
		end
	end
end

genres:registerNew({
	id = "action",
	icon = "genre_action",
	display = _T("GENRE_ACTION", "Action"),
	scoreImpact = {
		graphics = 1.25,
		world_design = 1.5,
		gameplay = 1.5,
		sound = 1,
		dialogue = 0.75,
		story = 0.75
	}
})
genres:registerNew({
	id = "adventure",
	icon = "genre_adventure",
	display = _T("GENRE_ADVENTURE", "Adventure"),
	scoreImpact = {
		graphics = 1,
		world_design = 1.25,
		gameplay = 0.75,
		sound = 1.25,
		dialogue = 1.25,
		story = 1.5
	}
})
genres:registerNew({
	id = "horror",
	icon = "genre_horror",
	display = _T("GENRE_HORROR", "Horror"),
	scoreImpact = {
		graphics = 1.25,
		world_design = 1.25,
		gameplay = 1.25,
		sound = 1.5,
		dialogue = 0.75,
		story = 1
	}
})
genres:registerNew({
	id = "fighting",
	icon = "genre_fighting",
	display = _T("GENRE_FIGHTING", "Fighting"),
	scoreImpact = {
		graphics = 1.25,
		world_design = 1,
		gameplay = 1.75,
		sound = 1.25,
		dialogue = 0.25,
		story = 0.1
	}
})
genres:registerNew({
	id = "simulation",
	icon = "genre_simulation",
	display = _T("GENRE_SIMULATION", "Simulation"),
	scoreImpact = {
		graphics = 1.25,
		world_design = 1,
		gameplay = 1.5,
		sound = 1,
		dialogue = 0.75,
		story = 0.5
	}
})
genres:registerNew({
	id = "strategy",
	icon = "genre_strategy",
	display = _T("GENRE_STRATEGY", "Strategy"),
	scoreImpact = {
		graphics = 1.25,
		world_design = 1.5,
		gameplay = 1.5,
		sound = 1,
		dialogue = 0.5,
		story = 0.75
	}
})
genres:registerNew({
	noSuffix = true,
	id = "rpg",
	icon = "genre_rpg",
	display = _T("GENRE_ROLEPLAYING", "Role-playing"),
	scoreImpact = {
		graphics = 1,
		world_design = 1.5,
		gameplay = 1.2,
		sound = 1,
		dialogue = 1.25,
		story = 1.5
	}
})
genres:registerNew({
	id = "sandbox",
	icon = "genre_sandbox",
	display = _T("GENRE_SANDBOX", "Sandbox"),
	scoreImpact = {
		graphics = 1.25,
		world_design = 1.5,
		gameplay = 1.5,
		sound = 1,
		dialogue = 0.5,
		story = 0.75
	}
})
genres:registerNew({
	id = "racing",
	icon = "genre_racing",
	display = _T("GENRE_RACING", "Racing"),
	scoreImpact = {
		graphics = 1.3,
		world_design = 1.25,
		gameplay = 1.5,
		sound = 1.35,
		dialogue = 0.75,
		story = 0.5
	}
})
genres:registerSubgenreMatches("action", {
	adventure = genres.SUBGENRE_MATCH_NORMAL,
	horror = genres.SUBGENRE_MATCH_GOOD,
	fighting = genres.SUBGENRE_MATCH_GOOD,
	simulation = genres.SUBGENRE_MATCH_BAD,
	strategy = genres.SUBGENRE_MATCH_BAD,
	rpg = genres.SUBGENRE_MATCH_GOOD,
	sandbox = genres.SUBGENRE_MATCH_GOOD,
	racing = genres.SUBGENRE_MATCH_BAD
})
genres:registerSubgenreMatches("adventure", {
	horror = genres.SUBGENRE_MATCH_VERY_GOOD,
	fighting = genres.SUBGENRE_MATCH_NORMAL,
	simulation = genres.SUBGENRE_MATCH_BAD,
	strategy = genres.SUBGENRE_MATCH_BAD,
	rpg = genres.SUBGENRE_MATCH_NORMAL,
	sandbox = genres.SUBGENRE_MATCH_NORMAL,
	racing = genres.SUBGENRE_MATCH_BAD
})
genres:registerSubgenreMatches("horror", {
	fighting = genres.SUBGENRE_MATCH_NORMAL,
	simulation = genres.SUBGENRE_MATCH_BAD,
	strategy = genres.SUBGENRE_MATCH_VERY_BAD,
	rpg = genres.SUBGENRE_MATCH_BETTER,
	sandbox = genres.SUBGENRE_MATCH_BAD,
	racing = genres.SUBGENRE_MATCH_VERY_BAD
})
genres:registerSubgenreMatches("fighting", {
	simulation = genres.SUBGENRE_MATCH_GOOD,
	strategy = genres.SUBGENRE_MATCH_NORMAL,
	rpg = genres.SUBGENRE_MATCH_BETTER,
	sandbox = genres.SUBGENRE_MATCH_NORMAL,
	racing = genres.SUBGENRE_MATCH_VERY_BAD
})
genres:registerSubgenreMatches("simulation", {
	strategy = genres.SUBGENRE_MATCH_NORMAL,
	rpg = genres.SUBGENRE_MATCH_NORMAL,
	sandbox = genres.SUBGENRE_MATCH_BETTER,
	racing = genres.SUBGENRE_MATCH_VERY_GOOD
})
genres:registerSubgenreMatches("strategy", {
	rpg = genres.SUBGENRE_MATCH_NORMAL,
	sandbox = genres.SUBGENRE_MATCH_GOOD,
	racing = genres.SUBGENRE_MATCH_NORMAL
})
genres:registerSubgenreMatches("rpg", {
	sandbox = genres.SUBGENRE_MATCH_GOOD,
	racing = genres.SUBGENRE_MATCH_BETTER
})
genres:registerSubgenreMatches("sandbox", {
	racing = genres.SUBGENRE_MATCH_VERY_GOOD
})

genres.allowImportanceListRebuilding = true
