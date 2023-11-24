themes = {}
themes.registered = {}
themes.registeredByID = {}

function themes:registerNew(data)
	table.insert(themes.registered, data)
	
	themes.registeredByID[data.id] = data
end

function themes:registerGenreMatch(themeID, genreID, matchMultiplier)
	themes.registeredByID[themeID].match[genreID] = matchMultiplier
end

function themes:registerGenreReviewAffector(themeID, genreID, reviewAffector)
	themes.registeredByID[themeID].reviewAffector[genreID] = reviewAffector
end

function themes:postLoadedMods()
	for key, genreData in ipairs(genres.registered) do
		local id = genreData.id
		
		for key, themeData in ipairs(self.registered) do
			if not themeData.match[id] then
				themeData.match[id] = 1
			end
			
			if not themeData.reviewAffector[id] then
				themeData.reviewAffector[id] = 1
			end
		end
	end
end

function themes:verifyMatchForGenre(genreData)
	local id = genreData.id
	
	for key, themeData in ipairs(self.registered) do
		if not themeData.match[id] then
			themeData.match[id] = 1
		end
		
		if not themeData.reviewAffector[id] then
			themeData.reviewAffector[id] = 1
		end
	end
end

function themes:getName(themeID)
	return themes.registeredByID[themeID].display
end

function themes:getData(themeID)
	return themes.registeredByID[themeID]
end

function themes:getMatch(gameProj)
	local genre, theme = gameProj:getGenre(), gameProj:getTheme()
	local themeData = themes.registeredByID[theme]
	
	return themeData.match[genre]
end

local revealedGenre = {}

function themes:getRevealedGenreMatching(genre)
	table.clearArray(revealedGenre)
	
	for key, themeData in ipairs(themes.registered) do
		if studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.THEME_MATCHING, themeData.id, genre) then
			revealedGenre[#revealedGenre + 1] = themeData
		end
	end
	
	return revealedGenre
end

local researchedThemes = {}

function themes:getResearchedThemes()
	table.clearArray(researchedThemes)
	
	for key, themeData in ipairs(themes.registered) do
		if studio:isThemeResearched(themeData.id) then
			researchedThemes[#researchedThemes + 1] = themeData
		end
	end
	
	return researchedThemes
end

local unresearchedThemes = {}

function themes:getUnresearchedThemes()
	table.clearArray(unresearchedThemes)
	
	for key, themeData in ipairs(themes.registered) do
		if not studio:isThemeResearched(themeData.id) then
			unresearchedThemes[#unresearchedThemes + 1] = themeData
		end
	end
	
	return unresearchedThemes
end

local inUseResearchThemes = {}

function themes:getValidResearchThemes()
	local designTask = task:getData("design_task")
	
	for key, employeeObj in ipairs(studio:getEmployees()) do
		local task = employeeObj:getTask()
		
		if task and task:getID() == designTask.id and task:getDesignType() == designTask.TYPES.THEME then
			inUseResearchThemes[task:getResearchID()] = true
		end
	end
	
	table.clearArray(unresearchedThemes)
	
	for key, themeData in ipairs(themes.registered) do
		if not studio:isThemeResearched(themeData.id) and not inUseResearchThemes[themeData.id] then
			unresearchedThemes[#unresearchedThemes + 1] = themeData
		end
	end
	
	table.clear(inUseResearchThemes)
	
	return unresearchedThemes
end

function themes:areAllThemesResearched()
	for key, themeData in ipairs(themes.registered) do
		if not studio:isThemeResearched(themeData.id) then
			return false
		end
	end
	
	return true
end

function themes:preserveOriginalMatches()
	self.originalMatches = {}
	
	for key, data in ipairs(themes.registered) do
		self.originalMatches[data.id] = {}
		
		local matchList = self.originalMatches[data.id]
		local matching = data.match
		
		for key, genreData in ipairs(genres.registered) do
			matchList[genreData.id] = matching[genreData.id]
		end
	end
end

function themes:restoreMatches()
	for key, data in ipairs(themes.registered) do
		local matchList = self.originalMatches[data.id]
		local matching = data.match
		
		for key, genreData in ipairs(genres.registered) do
			matching[genreData.id] = matchList[genreData.id]
		end
	end
end

function themes:randomizeMatches()
	self:preserveOriginalMatches()
	
	local keyList, matchList, genreMatchCorrelationList = {}, {}, {}
	
	for key, data in ipairs(themes.registered) do
		for key, genreData in ipairs(genres.registered) do
			keyList[#keyList + 1] = genreData.id
			matchList[#matchList + 1] = data.match[genreData.id]
			genreMatchCorrelationList[#genreMatchCorrelationList + 1] = genreData.id
		end
		
		data.replacedMatches = {}
		
		while #keyList > 0 do
			local randomGenre = table.remove(keyList, math.random(1, #keyList))
			local randomMatchIndex = math.random(1, #matchList)
			local randomMatch = table.remove(matchList, randomMatchIndex)
			local selectedGenreReplacement = table.remove(genreMatchCorrelationList, randomMatchIndex)
			
			data.match[randomGenre] = randomMatch
			data.replacedMatches[#data.replacedMatches + 1] = {
				from = selectedGenreReplacement,
				to = randomGenre
			}
		end
	end
end

function themes:saveMatches()
	local saved = {}
	
	for key, data in ipairs(themes.registered) do
		saved[#saved + 1] = {
			id = data.id,
			replacedMatches = data.replacedMatches
		}
	end
	
	return saved
end

function themes:loadMatches(data)
	self:preserveOriginalMatches()
	
	for key, themeData in ipairs(data) do
		local targetTheme = themes.registeredByID[themeData.id]
		
		if targetTheme then
			local originalMatches = self.originalMatches[themeData.id]
			
			if themeData.replacedMatches then
				for key, replacementData in ipairs(themeData.replacedMatches) do
					targetTheme.match[replacementData.to] = originalMatches[replacementData.from]
				end
				
				targetTheme.replacedMatches = themeData.replacedMatches
			end
		end
	end
end

themes.MATCH_GOOD = 1.1
themes.MATCH_VERY_GOOD = 1.25
themes.MATCH_PERFECT = 1.35
themes.REVIEW_MATCH_NORMAL = 0
themes.REVIEW_MATCH_GOOD = 0.05
themes.REVIEW_MATCH_VERY_GOOD = 0.1

themes:registerNew({
	id = "military",
	display = _T("THEME_MILITARY", "Military"),
	match = {
		fighting = 1,
		racing = 1,
		sandbox = 0.75,
		horror = 1,
		adventure = 1,
		rpg = 0.75,
		action = themes.MATCH_VERY_GOOD,
		simulation = themes.MATCH_GOOD,
		strategy = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_VERY_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_GOOD,
		strategy = themes.REVIEW_MATCH_GOOD,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "government",
	display = _T("THEME_GOVERNMENT", "Government"),
	match = {
		fighting = 1,
		racing = 1,
		action = 1,
		sandbox = 0.75,
		strategy = 0.75,
		horror = 1,
		rpg = 0.75,
		adventure = themes.MATCH_VERY_GOOD,
		simulation = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_VERY_GOOD,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_GOOD,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "undercover",
	display = _T("THEME_UNDERCOVER", "Spy thriller"),
	match = {
		fighting = 1,
		racing = 1,
		sandbox = 0.75,
		strategy = 1,
		simulation = 1,
		horror = 1,
		rpg = 0.75,
		action = themes.MATCH_VERY_GOOD,
		adventure = themes.MATCH_VERY_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_VERY_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_VERY_GOOD,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "medieval",
	display = _T("THEME_MEDIEVAL", "Medieval"),
	match = {
		fighting = 0.75,
		racing = 0.75,
		sandbox = 1,
		simulation = 1,
		horror = 1,
		action = themes.MATCH_GOOD,
		adventure = themes.MATCH_GOOD,
		strategy = themes.MATCH_GOOD,
		rpg = themes.MATCH_VERY_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_GOOD,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_GOOD,
		rpg = themes.REVIEW_MATCH_VERY_GOOD,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "scifi",
	display = _T("THEME_SCIFI", "Sci-fi"),
	match = {
		fighting = 1,
		racing = 0.9,
		action = 1,
		sandbox = 1,
		adventure = 0.75,
		horror = themes.MATCH_GOOD,
		simulation = themes.MATCH_GOOD,
		strategy = themes.MATCH_VERY_GOOD,
		rpg = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_GOOD,
		simulation = themes.REVIEW_MATCH_GOOD,
		strategy = themes.REVIEW_MATCH_VERY_GOOD,
		rpg = themes.REVIEW_MATCH_GOOD,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "fantasy",
	display = _T("THEME_FANTASY", "Fantasy"),
	match = {
		fighting = 1,
		racing = 1,
		action = 1,
		sandbox = 1,
		simulation = 1,
		horror = 1,
		adventure = themes.MATCH_GOOD,
		strategy = themes.MATCH_VERY_GOOD,
		rpg = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_GOOD,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_VERY_GOOD,
		rpg = themes.REVIEW_MATCH_GOOD,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "hospital",
	display = _T("THEME_HOSPITAL", "Hospital"),
	match = {
		fighting = 0.75,
		racing = 0.75,
		action = 0.75,
		sandbox = 0.5,
		adventure = 1,
		rpg = 0.75,
		horror = themes.MATCH_VERY_GOOD,
		simulation = themes.MATCH_GOOD,
		strategy = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_VERY_GOOD,
		simulation = themes.REVIEW_MATCH_GOOD,
		strategy = themes.REVIEW_MATCH_GOOD,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "wilderness",
	display = _T("THEME_WILDERNESS", "Wilderness"),
	match = {
		fighting = 0.75,
		racing = 1,
		action = 0.75,
		strategy = 1,
		simulation = 0.75,
		adventure = 1,
		rpg = 0.75,
		horror = themes.MATCH_GOOD,
		sandbox = themes.MATCH_VERY_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_GOOD,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_VERY_GOOD,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "postapoc",
	display = _T("THEME_POSTAPOCALYPTIC", "Post-apocalyptic"),
	match = {
		fighting = 1,
		racing = 1,
		strategy = 1,
		simulation = 1,
		adventure = 1,
		action = themes.MATCH_GOOD,
		horror = themes.MATCH_GOOD,
		rpg = themes.MATCH_GOOD,
		sandbox = themes.MATCH_VERY_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_GOOD,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_GOOD,
		sandbox = themes.REVIEW_MATCH_VERY_GOOD,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "urban",
	display = _T("THEME_URBAN", "Urban"),
	match = {
		fighting = 1,
		strategy = 1,
		horror = 0.75,
		adventure = 1,
		action = themes.MATCH_GOOD,
		simulation = themes.MATCH_VERY_GOOD,
		rpg = themes.MATCH_GOOD,
		sandbox = themes.MATCH_GOOD,
		racing = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_VERY_GOOD,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_GOOD,
		sandbox = themes.REVIEW_MATCH_GOOD,
		racing = themes.REVIEW_MATCH_GOOD
	}
})
themes:registerNew({
	id = "worldwar",
	display = _T("THEME_WORLD_WAR", "World war"),
	match = {
		fighting = 0.75,
		racing = 0.75,
		sandbox = 1,
		simulation = 1,
		rpg = 1,
		action = themes.MATCH_VERY_GOOD,
		adventure = themes.MATCH_GOOD,
		horror = themes.MATCH_GOOD,
		strategy = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_VERY_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_GOOD,
		horror = themes.REVIEW_MATCH_GOOD,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_GOOD,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "gamedev",
	display = _T("THEME_GAME_DEV", "Game dev"),
	match = {
		fighting = 0.75,
		racing = 0.75,
		action = 1,
		sandbox = 1,
		rpg = 0.75,
		adventure = themes.MATCH_GOOD,
		horror = themes.MATCH_VERY_GOOD,
		simulation = themes.MATCH_VERY_GOOD,
		strategy = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_GOOD,
		horror = themes.REVIEW_MATCH_VERY_GOOD,
		simulation = themes.REVIEW_MATCH_VERY_GOOD,
		strategy = themes.REVIEW_MATCH_GOOD,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "cyberpunk",
	display = _T("THEME_CYBERPUNK", "Cyberpunk"),
	match = {
		fighting = 0.75,
		racing = 0.75,
		sandbox = 1,
		strategy = 1,
		simulation = 1,
		horror = 1,
		action = themes.MATCH_GOOD,
		adventure = themes.MATCH_GOOD,
		rpg = themes.MATCH_VERY_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_GOOD,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_VERY_GOOD,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "steampunk",
	display = _T("THEME_STEAMPUNK", "Steampunk"),
	match = {
		fighting = 0.75,
		racing = 0.6,
		sandbox = 1,
		simulation = 1,
		horror = 1,
		adventure = 1,
		action = themes.MATCH_GOOD,
		strategy = themes.MATCH_GOOD,
		rpg = themes.MATCH_VERY_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_GOOD,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_GOOD,
		rpg = themes.REVIEW_MATCH_VERY_GOOD,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "ancient",
	display = _T("THEME_ANCIENT", "Ancient"),
	match = {
		fighting = 0.75,
		racing = 0.5,
		action = 1,
		sandbox = 1,
		horror = 1,
		adventure = 1,
		simulation = themes.MATCH_GOOD,
		strategy = themes.MATCH_VERY_GOOD,
		rpg = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_GOOD,
		strategy = themes.REVIEW_MATCH_VERY_GOOD,
		rpg = themes.REVIEW_MATCH_GOOD,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "bizarre",
	display = _T("THEME_BIZARRE", "Bizarre"),
	match = {
		racing = 1,
		sandbox = 1,
		strategy = 0.75,
		simulation = 0.75,
		adventure = 1,
		rpg = 1,
		action = themes.MATCH_GOOD,
		fighting = themes.MATCH_GOOD,
		horror = themes.MATCH_VERY_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_GOOD,
		fighting = themes.REVIEW_MATCH_GOOD,
		adventure = themes.REVIEW_MATCH_NORMAL,
		horror = themes.REVIEW_MATCH_VERY_GOOD,
		simulation = themes.REVIEW_MATCH_NORMAL,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_NORMAL,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
themes:registerNew({
	id = "casino",
	display = _T("THEME_CASINO", "Casino"),
	match = {
		fighting = 1,
		racing = 0.5,
		action = 1,
		strategy = 1,
		horror = 0.75,
		rpg = 0.75,
		adventure = themes.MATCH_GOOD,
		simulation = themes.MATCH_VERY_GOOD,
		sandbox = themes.MATCH_GOOD
	},
	reviewAffector = {
		action = themes.REVIEW_MATCH_NORMAL,
		fighting = themes.REVIEW_MATCH_NORMAL,
		adventure = themes.REVIEW_MATCH_GOOD,
		horror = themes.REVIEW_MATCH_NORMAL,
		simulation = themes.REVIEW_MATCH_VERY_GOOD,
		strategy = themes.REVIEW_MATCH_NORMAL,
		rpg = themes.REVIEW_MATCH_NORMAL,
		sandbox = themes.REVIEW_MATCH_GOOD,
		racing = themes.REVIEW_MATCH_NORMAL
	}
})
