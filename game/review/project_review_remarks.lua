projectReview:registerRemark({
	notGoodMatchValue = 1,
	goodMatchValue = 1.25,
	perfectMatchValue = 1.75,
	id = "generic_game_remarks",
	greatMatchValue = 1.5,
	aspectIsBad = {
		_T("LOW_CONTRIBUTING_ASPECT_1", "for a game genre that mostly relies on ASPECT, it does a poor job in that district."),
		_T("LOW_CONTRIBUTING_ASPECT_2", "despite relying very heavily on ASPECT, the developers seem to have completely forgotten about it."),
		_T("LOW_CONTRIBUTING_ASPECT_3", "the developers should have put more time and effort into ASPECT."),
		_T("LOW_CONTRIBUTING_ASPECT_4", "a game of this genre desperately needed more work done on ASPECT.")
	},
	goodMatchText = {
		_T("GOOD_THEME_GENRE_MATCH_1", "the theme and the genre complemented each other very nicely."),
		_T("GOOD_THEME_GENRE_MATCH_2", "a game of the GENRE genre goes well with a THEME theme")
	},
	greatMatchText = {
		_T("GREAT_THEME_GENRE_MATCH_1", "the mix of the GENRE genre with the THEME theme was a great combination.")
	},
	perfectMatchText = {
		_T("PERFECT_THEME_GENRE_MATCH_1", "the THEME setting is the perfect pick for a GENRE type game.")
	},
	badMatchText = {
		_T("BAD_THEME_GENRE_MATCH_1", "the GENRE genre does not go well with the THEME theme.")
	},
	averageMatchText = {
		_T("AVERAGE_THEME_GENRE_MATCH_1", "the GENRE genre works just fine with in a THEME setting.")
	},
	types = {
		THEME_GENRE_MATCHING = "theme_genre_matching",
		ASPECT = "aspect",
		DIFFERENT_GENRE = "different_genre",
		DIFFERENT_THEME = "different_theme",
		EXPANSION = "expansion"
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local relatedGame = project:getSequelTo()
		
		if relatedGame then
			local devType = project:getGameType()
			local isGoodGame = reviewObject:getRating() >= projectReview.GOOD_GAME_RATING_CUTOFF
			
			if devType == gameProject.DEVELOPMENT_TYPE.NEW then
				if relatedGame:getGenre() ~= project:getGenre() then
					table.insert(remarksTable, {
						type = self.types.DIFFERENT_GENRE,
						isGoodGame = isGoodGame
					})
				end
				
				if relatedGame:getTheme() ~= project:getTheme() then
					local genreThemeMatch = themes:getMatch(project)
					
					table.insert(remarksTable, {
						type = self.types.DIFFERENT_THEME,
						isGoodGame = isGoodGame,
						isGoodGenreMatch = genreThemeMatch >= 1
					})
				end
			else
				local avgRelatedScore = relatedGame:getReviewRating()
				
				table.insert(remarksTable, {
					type = self.types.EXPANSION,
					isPreviousGameGood = avgRelatedScore >= projectReview.GOOD_GAME_RATING_CUTOFF,
					isExpansionGood = isGoodGame
				})
			end
		end
		
		local worstAspect, worstAspectQuality = nil, math.huge
		
		for qualityID, multiplier in pairs(genres:getScoreImpact(project)) do
			if multiplier > 1 then
				local qualityScore = review:getQualityScore(qualityID, project)
				
				if qualityScore < worstAspectQuality then
					worstAspectQuality = qualityScore
					worstAspect = qualityID
				end
			end
		end
		
		if worstAspectQuality < projectReview.CON_QUALITY_CUTOFF then
			table.insert(remarksTable, {
				type = self.types.ASPECT,
				revealType = studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY,
				reveal = worstAspect
			})
		end
		
		remarksTable.weight = 40
		
		local theme = project:getTheme()
		local themeMatch = themes:getMatch(project)
		local structure = {
			type = self.types.THEME_GENRE_MATCHING,
			revealType = studio.CONTRIBUTION_REVEAL_TYPES.THEME_MATCHING,
			theme = theme,
			genre = project:getGenre(),
			match = themeMatch
		}
		local validTable = self:pickTextTable(themeMatch)
		
		structure.textID = math.random(1, #validTable)
		
		table.insert(remarksTable, structure)
	end,
	pickTextTable = function(self, matchValue)
		if matchValue >= themes.MATCH_GOOD and matchValue < themes.MATCH_VERY_GOOD then
			return self.goodMatchText
		elseif matchValue >= themes.MATCH_VERY_GOOD then
			return self.greatMatchText
		elseif matchValue >= themes.MATCH_PERFECT then
			return self.perfectMatchText
		elseif matchValue == 1 then
			return self.averageMatchText
		end
		
		return self.badMatchText
	end,
	pickText = function(self, reviewObject, remarksTable)
		local remark = remarksTable[math.random(1, #remarksTable)]
		
		if remark.type == self.types.DIFFERENT_GENRE then
			local qualityRemark
			
			if remark.isGoodGame then
				qualityRemark = _T("DIFFERENT_GENRE_GOOD_GAME", "but the game is very well done.")
			else
				qualityRemark = _T("DIFFERENT_GENRE_LET_DOWN_GAME", "but the game is a let-down. It seems like the developers did not know what they were doing.")
			end
			
			return string.easyformatbykeys(_T("DIFFERENT_PREQUEL_GENRE", "we don't understand what caused the sudden shift from their previous games OLD_GENRE genre to a NEW_GENRE style game, QUALITY_REMARK"), "OLD_GENRE", reviewObject:getProject():getSequelTo():getGenre(), "NEW_GENRE", reviewObject:getProject():getGenre(), "QUALITY_REMARK", qualityRemark)
		elseif remark.type == self.types.DIFFERENT_THEME then
			if remark.isGoodGame then
				if not remark.isGoodGenreMatch then
					return _T("DIFFERENT_THEME_GOOD_GAME", "despite the sudden switch of the theme, the game is still good.")
				else
					return _T("DIFFERENT_THEME_GOOD_MATCH_GOOD_GAME", "the switch in the theme of the game did this sequel a lot of good.")
				end
			elseif not remark.isGoodGenreMatch then
				return _T("DIFFERENT_THEME_LET_DOWN_GAME", "we believe the switch in theme did this game more harm than good.")
			else
				return _T("DIFFERENT_THEME_GOOD_MATCH_LET_DOWN", "the genre and the setting matched very well, yet the game itself was not that good.")
			end
		elseif remark.type == self.types.EXPANSION then
			if not remark.isPreviousGameGood then
				if not remark.isExpansionGood then
					return _T("BAD_FULL_GAME_BAD_EXPANSION", "just like the original game, the expansion is not that good.")
				else
					return _T("BAD_FULL_GAME_GOOD_EXPANSION", "it is a rare sight to see an expansion for a bad game fix so many problems and make the game so much more enjoyable.")
				end
			elseif not remark.isExpansionGood then
				return _T("GOOD_FULL_GAME_BAD_EXPANSION", "while the original game was good, the expansion does not hold a candle to it.")
			else
				return _T("GOOD_FULL_GAME_GOOD_EXPANSION", "just like the original game, the expansion is well-made and is a pleasure to play.")
			end
		elseif remark.type == self.types.ASPECT then
			local isNew = studio:revealGameQualityMatching(studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY, remark.reveal, reviewObject:getProject())
			
			reviewObject:markNewReveal(isNew)
			
			if isNew then
				reviewObject:logReveal(studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY, remark.reveal)
			end
			
			return string.easyformatbykeys(self.aspectIsBad[math.random(1, #self.aspectIsBad)], "ASPECT", gameQuality.registeredByID[remark.reveal].display)
		elseif remark.type == self.types.THEME_GENRE_MATCHING then
			local isNew = studio:revealGameQualityMatching(studio.CONTRIBUTION_REVEAL_TYPES.THEME_MATCHING, nil, reviewObject:getProject())
			
			reviewObject:markNewReveal(isNew)
			
			if isNew then
				reviewObject:logReveal(studio.CONTRIBUTION_REVEAL_TYPES.THEME_MATCHING)
			end
			
			local validTable = self:pickTextTable(remark.match)
			
			remark.textID = math.min(remark.textID, #validTable)
			
			return string.easyformatbykeys(validTable[remark.textID], "GENRE", genres.registeredByID[remark.genre].display, "THEME", themes.registeredByID[remark.theme].display)
		end
	end
})
projectReview:registerRemark({
	id = "subgenre_remark",
	veryBadMatch = {
		_T("SUBGENRE_MATCH_VERY_BAD", "the sub-genre was an awful pick for the genre of the game.")
	},
	badMatch = {
		_T("SUBGENRE_MATCH_BAD", "the sub-genre did not work well with the genre of the game.")
	},
	avgMatch = {
		_T("SUBGENRE_MATCH_AVERAGE", "the sub-genre didn't change the game neither for the better, nor for the worse.")
	},
	goodMatch = {
		_T("SUBGENRE_MATCH_GOOD", "the sub-genre definitely makes the game better when coupled with its genre.")
	},
	veryGoodMatch = {
		_T("SUBGENRE_MATCH_VERY_GOOD", "the sub-genre was a great choice for the genre of the game.")
	},
	pickTextTable = function(self, matchVal)
		if matchVal < genres.SUBGENRE_MATCH_BAD then
			return self.veryBadMatch
		elseif matchVal < genres.SUBGENRE_MATCH_NORMAL then
			return self.badMatch
		elseif matchVal == genres.SUBGENRE_MATCH_NORMAL then
			return self.avgMatch
		elseif matchVal <= genres.SUBGENRE_MATCH_GOOD then
			return self.goodMatch
		elseif matchVal > genres.SUBGENRE_MATCH_GOOD then
			return self.veryGoodMatch
		end
	end,
	attemptAdd = function(self, reviewObj, remarksTable)
		local proj = reviewObj:getProject()
		local subg = proj:getSubgenre()
		
		if subg then
			local genre = proj:getGenre()
			
			if studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.SUBGENRE_MATCHING, subg, genre) then
				remarksTable.weight = 30
			else
				remarksTable.weight = 50
			end
			
			local list = self:pickTextTable(genres.subgenreMatches[genre][subg])
			
			table.insert(remarksTable, math.random(1, #list))
		end
	end,
	pickText = function(self, reviewObject, remarkData)
		local proj = reviewObject:getProject()
		local genre, subg = proj:getGenre(), proj:getSubgenre()
		local textTable = self:pickTextTable(genres.subgenreMatches[genre][subg])
		local isNew = studio:revealGameQualityMatching(studio.CONTRIBUTION_REVEAL_TYPES.SUBGENRE_MATCHING, subg, proj)
		
		reviewObject:markNewReveal(isNew)
		
		if isNew then
			reviewObject:logReveal(studio.CONTRIBUTION_REVEAL_TYPES.SUBGENRE_MATCHING)
		end
		
		return textTable[remarkData[1]]
	end
})
projectReview:registerRemark({
	id = "performance_remarks",
	remarksText = {
		bad = {
			_T("LOW_PERFORMANCE_TEXT_1", "the performance was very poor, and I find it difficult to enjoy a game that can't maintain a stable framerate.")
		},
		good = {
			_T("HIGH_PERFORMANCE_TEXT_1", "the performance was great.")
		}
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local stats = project:getEngineRevisionStats()
		local goodPerformance = stats.performance > review.lowPerformanceRemark
		
		table.insert(remarksTable, goodPerformance)
		
		if goodPerformance then
			remarksTable.weight = 10
		else
			remarksTable.weight = 20
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		if remarksTable[1] == false then
			remarkList = self.remarksText.bad
		else
			remarkList = self.remarksText.good
		end
		
		return remarkList[math.random(1, #remarkList)]
	end
})
projectReview:registerRemark({
	id = "genre_perspective_matching_remark",
	text = {
		badMatch = {
			_T("GENRE_PERSPECTIVE_BAD_MATCH_1", "a game of the 'GENRE' genre does not go well with the PERSPECTIVE perspective."),
			_T("GENRE_PERSPECTIVE_BAD_MATCH_2", "PERSPECTIVE doesn't mix well with a game of the 'GENRE' genre.")
		},
		goodMatch = {
			_T("GENRE_PERSPECTIVE_GOOD_MATCH_1", "the games PERSPECTIVE perspective went hand-in-hand with its' 'GENRE' genre."),
			_T("GENRE_PERSPECTIVE_GOOD_MATCH_2", "going with a PERSPECTIVE perspective was a good choice for a game of the 'GENRE' genre.")
		}
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local perspectiveData = taskTypes:getData(project:getFact("perspective"))
		
		if not perspectiveData then
			error("no perspective data for " .. project:getName() .. " related game: " .. tostring(project:getSequelTo()))
		end
		
		local genreMatch = perspectiveData:getGenreMatch(project)
		
		if genreMatch ~= 1 then
			local wasGoodMatch = genreMatch > 1
			local textList
			
			if wasGoodMatch then
				textList = self.text.goodMatch
			else
				textList = self.text.badMatch
			end
			
			table.insert(remarksTable, {
				wasGoodMatch = wasGoodMatch,
				textIndex = math.random(1, #textList)
			})
			
			remarksTable.weight = 10
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		if remarksTable[1].wasGoodMatch then
			remarkList = self.text.goodMatch
		else
			remarkList = self.text.badMatch
		end
		
		local isNew = studio:revealGameQualityMatching(studio.CONTRIBUTION_REVEAL_TYPES.PERSPECTIVE_MATCHING, nil, reviewObject:getProject())
		
		reviewObject:markNewReveal(isNew)
		
		if isNew then
			reviewObject:logReveal(studio.CONTRIBUTION_REVEAL_TYPES.PERSPECTIVE_MATCHING)
		end
		
		local project = reviewObject:getProject()
		local remark = remarkList[remarksTable[1].textIndex]
		
		remark = string.easyformatbykeys(remark, "GENRE", genres.registeredByID[project:getGenre()].display, "PERSPECTIVE", taskTypes.registeredByID[project:getFact("perspective")].display)
		
		return remark
	end
})
projectReview:registerRemark({
	id = "issue_amount_remark",
	text = {
		[gameProject.ISSUE_COMPLAINTS.LOW] = {
			_T("REVIEW_REMARK_ISSUE_COUNT_LOW_1", "the game had some issues, which made the experience a bit less exciting."),
			_T("REVIEW_REMARK_ISSUE_COUNT_LOW_2", "some minor issues made the game less enjoyable.")
		},
		[gameProject.ISSUE_COMPLAINTS.MEDIUM] = {
			_T("REVIEW_REMARK_ISSUE_COUNT_MEDIUM_1", "the game had a moderate amount of issues, which hurt the overall experience."),
			_T("REVIEW_REMARK_ISSUE_COUNT_MEDIUM_2", "if the game had less issues, then it would have been a lot more enjoyable.")
		},
		[gameProject.ISSUE_COMPLAINTS.HIGH] = {
			_T("REVIEW_REMARK_ISSUE_COUNT_HIGH_1", "the game was very buggy, and it's hard to enjoy a game like that."),
			_T("REVIEW_REMARK_ISSUE_COUNT_HIGH_2", "no amount of graphical or gameplay excellence can save this game from the sheer amount of bugs.")
		}
	},
	conclusions = {
		[gameProject.ISSUE_COMPLAINTS.LOW] = "issue_affector_low",
		[gameProject.ISSUE_COMPLAINTS.MEDIUM] = "issue_affector_medium",
		[gameProject.ISSUE_COMPLAINTS.HIGH] = "issue_affector_high"
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local level = project:getIssueComplaintsLevel()
		local textList = self.text[level]
		
		if textList then
			table.insert(remarksTable, {
				complaintLevel = level,
				textIndex = math.random(1, #textList)
			})
			
			remarksTable.weight = 100
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		local remark = self.text[remarksTable[1].complaintLevel][remarksTable[1].textIndex]
		
		reviewObject:addConclusion(self.conclusions[remarksTable[1].complaintLevel])
		
		return remark
	end
})
projectReview:registerConclusion({
	id = "issue_affector_low",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_ISSUES_LOW", "Issues are slightly affecting the review score & sales"), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerConclusion({
	id = "issue_affector_medium",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_ISSUES_MODERATE", "Issues are affecting the review score & sales"), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerConclusion({
	id = "issue_affector_high",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_ISSUES_HIGH", "Issues are heavily affecting the review score & sales"), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerRemark({
	id = "audience_match_remark",
	matchType = {
		BAD = 3,
		GOOD = 1,
		AVERAGE = 2
	},
	text = {
		{
			_T("REVIEW_REMARK_AUDIENCE_GOOD_MATCH_1", "the chosen target audience did well for the game in all of its aspects"),
			_T("REVIEW_REMARK_AUDIENCE_GOOD_MATCH_2", "the chosen target audience was definitely a good pick")
		},
		{
			_T("REVIEW_REMARK_AUDIENCE_AVERAGE_MATCH_1", "the chosen target audience did not hinder the game in terms of creative freedom"),
			_T("REVIEW_REMARK_AUDIENCE_AVERAGE_MATCH_2", "the chosen target audience allowed for just enough creative freedom")
		},
		{
			_T("REVIEW_REMARK_AUDIENCE_BAD_MATCH_1", "the things that the game tries to do is severely let down by the chosen age audience")
		}
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local audienceMatch = audience:getGenreMatching(project)
		local matchType
		
		if audienceMatch > 1 then
			matchType = self.matchType.GOOD
		elseif audienceMatch == 1 then
			matchType = self.matchType.AVERAGE
		else
			matchType = self.matchType.BAD
		end
		
		local textList = self.text
		
		if textList then
			table.insert(remarksTable, {
				matchType = matchType,
				textIndex = math.random(1, #self.text[matchType])
			})
			
			remarksTable.weight = 20
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		local remark = self.text[remarksTable[1].matchType][remarksTable[1].textIndex]
		local isNew = studio:revealGameQualityMatching(studio.CONTRIBUTION_REVEAL_TYPES.AUDIENCE_MATCHING, nil, reviewObject:getProject())
		
		reviewObject:markNewReveal(isNew)
		
		if isNew then
			reviewObject:logReveal(studio.CONTRIBUTION_REVEAL_TYPES.AUDIENCE_MATCHING)
		end
		
		return remark
	end
})
projectReview:registerRemark({
	largeKnowledgeContribution = 150,
	minorKnowledgeContribution = 15,
	id = "knowledge_contribution_remark",
	averageKnowledgeContribution = 70,
	contribution = {
		MINOR = 1,
		AVERAGE = 2,
		LARGE = 3
	},
	text = {
		{
			_T("KNOWLEDGE_CONTRIBUTION_MINOR_1", "there was some research done on KNOWLEDGE, which helped ASPECT"),
			_T("KNOWLEDGE_CONTRIBUTION_MINOR_2", "in terms of KNOWLEDGE this game was a bit accurate, every little bit of it helps ASPECT")
		},
		{
			_T("KNOWLEDGE_CONTRIBUTION_AVERAGE_1", "the team seems to have done a decent amount of research on KNOWLEDGE, which made the games' ASPECT more enjoyable"),
			_T("KNOWLEDGE_CONTRIBUTION_AVERAGE_2", "the game had a welcome amount of accuracy in terms of KNOWLEDGE for its' ASPECT")
		},
		{
			_T("KNOWLEDGE_CONTRIBUTION_LARGE_1", "the developers seem to be really interested in KNOWLEDGE, which made the game's ASPECT a lot more enjoyable"),
			_T("KNOWLEDGE_CONTRIBUTION_LARGE_2", "I was baffled by how accurate KNOWLEDGE was in the game in regard to ASPECT, that alone makes the game a lot more fun")
		}
	},
	biggestContributor = {},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local qualityContribution, qualityFromKnowledge = project:getKnowledgeQuality()
		local qualityLevel, highestQuality = -math.huge
		
		for qualityID, amount in pairs(qualityFromKnowledge) do
			if qualityLevel < amount then
				highestQuality = qualityID
				qualityLevel = amount
			end
		end
		
		if not highestQuality then
			return false
		end
		
		for knowledgeID, subList in pairs(qualityContribution) do
			for qualityID, contribution in pairs(subList) do
				if qualityID == highestQuality then
					self.biggestContributor[knowledgeID] = (self.biggestContributor[knowledgeID] or 0) + contribution
				end
			end
		end
		
		local highest, highestKnowledge = -math.huge
		
		for knowledgeID, amount in pairs(self.biggestContributor) do
			if highest < amount then
				highest = amount
				highestKnowledge = knowledgeID
			end
		end
		
		local contrType
		
		if qualityLevel >= self.largeKnowledgeContribution then
			contrType = self.contribution.LARGE
		elseif qualityLevel >= self.averageKnowledgeContribution then
			contrType = self.contribution.AVERAGE
		elseif qualityLevel >= self.minorKnowledgeContribution then
			contrType = self.contribution.MINOR
		end
		
		table.clear(self.biggestContributor)
		
		if not contrType then
			return false
		end
		
		table.insert(remarksTable, {
			knowledgeID = highestKnowledge,
			qualityID = highestQuality,
			contributionType = contrType,
			textIndex = math.random(1, #self.text[contrType])
		})
		
		remarksTable.weight = 15
	end,
	pickText = function(self, reviewObject, remarksTable)
		local data = remarksTable[1]
		local remark = self.text[data.contributionType][data.textIndex]
		
		return _format(remark, "KNOWLEDGE", knowledge:getData(data.knowledgeID).display, "ASPECT", gameQuality:getData(data.qualityID).display)
	end
})
projectReview:registerRemark({
	id = "new_standard_remark",
	text = {
		_T("NEW_STANDARD_1", "the ASPECT of this game is in a whole different league compared to other games"),
		_T("NEW_STANDARD_2", "the developers definitely broke new grounds in terms of ASPECT"),
		_T("NEW_STANDARD_3", "it's not often you see a game set a new standard for some aspect, and this game does just that for its ASPECT")
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local loggedStandards = project:getNewStandards()
		
		if not loggedStandards then
			return 
		end
		
		local quality, randomID = table.random(loggedStandards)
		
		table.insert(remarksTable, {
			qualityID = randomID,
			textIndex = math.random(1, #self.text)
		})
		
		remarksTable.weight = 15
	end,
	pickText = function(self, reviewObject, remarksTable)
		local data = remarksTable[1]
		
		return _format(self.text[data.textIndex], "ASPECT", gameQuality:getData(data.qualityID).display)
	end
})
projectReview:registerRemark({
	id = "expansion_pack_worth_remark",
	types = {
		VERY_LOW = 3,
		OK = 1,
		LOW = 2
	},
	levels = {
		VERY_LOW = 0.3,
		OK = 0.9,
		LOW = 0.65
	},
	text = {
		{
			_T("EXPANSION_WORTH_OK_1", "the amount of content there was compared to the price was OK"),
			_T("EXPANSION_WORTH_OK_2", "there was enough content in relation to the price, but there could have been more")
		},
		{
			_T("EXPANSION_WORTH_LOW_1", "we found the content amount to be lacking when looking at the price"),
			_T("EXPANSION_WORTH_LOW_2", "the amount of content was not enough to justify the price tag")
		},
		{
			_T("EXPANSION_WORTH_VERY_LOW_1", "there isn't enough content to justify such a high price"),
			_T("EXPANSION_WORTH_VERY_LOW_2", "the price-content relation is ridiculous, in a bad way")
		}
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local contentAffector = project:getContentPriceAffector()
		
		if not contentAffector then
			return 
		end
		
		local lowest, id = math.huge
		
		for key, level in pairs(self.levels) do
			if level < lowest and contentAffector < level then
				lowest = level
				id = key
			end
		end
		
		if not id then
			return 
		end
		
		local index = self.types[id]
		
		table.insert(remarksTable, {
			type = index,
			textIndex = math.random(1, #self.text[index])
		})
		
		remarksTable.weight = 15
	end,
	pickText = function(self, reviewObject, remarksTable)
		local data = remarksTable[1]
		
		return self.text[data.type][data.textIndex]
	end
})
projectReview:registerRemark({
	distance = 0.25,
	id = "genre_platform_matching",
	text = {
		[-2] = {
			_T("GENRE_PLATFORM_MATCH_VERY_BAD_1", "GENRE games work really badly on the PLATFORM"),
			_T("GENRE_PLATFORM_MATCH_VERY_BAD_2", "the PLATFORM is a really bad pick if you're making a GENRE game")
		},
		[-1] = {
			_T("GENRE_PLATFORM_MATCH_BAD_1", "GENRE games don't work well on the PLATFORM, this game wasn't an exception"),
			_T("GENRE_PLATFORM_MATCH_BAD_2", "we came to the conclusion that GENRE games, including this one, don't work well on PLATFORM")
		},
		[0] = {
			_T("GENRE_PLATFORM_MATCH_AVERAGE_1", "the GENRE genre worked well enough on the PLATFORM"),
			_T("GENRE_PLATFORM_MATCH_AVERAGE_2", "we think GENRE games work just OK on the PLATFORM")
		},
		{
			_T("GENRE_PLATFORM_MATCH_GOOD_1", "we found the game, being of the GENRE genre, worked good on PLATFORM"),
			_T("GENRE_PLATFORM_MATCH_GOOD_2", "we think the PLATFORM is a good pick for a GENRE game")
		},
		{
			_T("GENRE_PLATFORM_MATCH_VERY_GOOD_1", "a game of the GENRE genre played great on the PLATFORM"),
			_T("GENRE_PLATFORM_MATCH_VERY_GOOD_2", "GENRE games seem to work great on the PLATFORM")
		}
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local platformList = project:getTargetPlatforms()
		
		if #platformList == 0 then
			return 
		end
		
		local platformID = platformList[math.random(1, #platformList)]
		local obj = platformShare:getPlatformByID(platformID)
		local match = obj:getGenreMatch()[project:getGenre()] - 1
		local textKey = 0
		
		if match < 0 then
			textKey = math.min(2, math.max(-2, math.floor(match / self.distance)))
		elseif match > 0 then
			textKey = math.min(2, math.max(-2, math.ceil(match / self.distance)))
		end
		
		table.insert(remarksTable, {
			platformID = platformID,
			type = textKey,
			textIndex = math.random(1, #self.text[textKey])
		})
		
		remarksTable.weight = 15
	end,
	pickText = function(self, reviewObject, remarksTable)
		local data = remarksTable[1]
		local isNew = studio:revealGameQualityMatching(studio.CONTRIBUTION_REVEAL_TYPES.PLATFORM_MATCHING, data.platformID, reviewObject:getProject())
		
		reviewObject:markNewReveal(isNew)
		
		if isNew then
			reviewObject:logReveal(studio.CONTRIBUTION_REVEAL_TYPES.PLATFORM_MATCHING)
		end
		
		local platformName = platformShare:getPlatformByID(data.platformID):getName()
		
		return _format(self.text[data.type][data.textIndex], "GENRE", genres.registeredByID[reviewObject:getProject():getGenre()].display, "PLATFORM", platformName)
	end
})
projectReview:registerRemark({
	id = "saturation_remarks",
	largeSaturationCutoff = 0.4,
	text = {
		theme = {
			slight = {
				_T("THEME_SATURATION_REMARK_SLIGHT_1", "the market for THEME themed games on the PLATFORM is somewhat saturated right now, and we think the sales will be hurt due to that"),
				_T("THEME_SATURATION_REMARK_SLIGHT_2", "the saturation of THEME themed games on the PLATFORM is a bit higher than usual, so we think the game will sell a bit worse due to that")
			},
			large = {
				_T("THEME_SATURATION_REMARK_LARGE_1", "there are so many THEME themed games on the PLATFORM right now, that we think the game sales will suffer greatly due to that"),
				_T("THEME_SATURATION_REMARK_LARGE_2", "with how saturated the PLATFORM is with THEME games we think this game will sell less than it could have")
			}
		},
		genre = {
			slight = {
				_T("GENRE_SATURATION_REMARK_SLIGHT_1", "in terms of GENRE games - the PLATFORM is somewhat saturated by them, and we believe the game's sales will be lower due to that"),
				_T("GENRE_SATURATION_REMARK_SLIGHT_2", "the slight abundance of GENRE games on the PLATFORM will most likely affect the sales")
			},
			large = {
				_T("GENRE_SATURATION_REMARK_LARGE_1", "there are so many GENRE games on the 'PLATFORM' right now, that we think the game sales will suffer greatly due to that"),
				_T("GENRE_SATURATION_REMARK_LARGE_2", "with how saturated the PLATFORM is with GENRE games we think this game will sell much less than it could have")
			}
		}
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local ourGenre, ourTheme = project:getGenre(), project:getTheme()
		local platformList = project:getTargetPlatforms()
		local genreSaturationLevel, themeSaturationLevel, mostSaturatedPlatform = -math.huge, -math.huge
		local minCutoff = platform.MARKET_SATURATION_BOOST_CUTOFF
		
		for key, platformID in ipairs(platformList) do
			local platformObj = platformShare:getPlatformByID(platformID)
			local genreSaturation, themeSaturation = platformObj:getMarketSaturation()
			
			if minCutoff < genreSaturation[ourGenre] and genreSaturationLevel < genreSaturation[ourGenre] then
				genreSaturationLevel = genreSaturation[ourGenre]
				mostSaturatedPlatform = platformID
			end
			
			if minCutoff < themeSaturation[ourTheme] and themeSaturationLevel < themeSaturation[ourTheme] then
				themeSaturationLevel = themeSaturation[ourTheme]
				mostSaturatedPlatform = platformID
			end
		end
		
		if not mostSaturatedPlatform then
			return 
		end
		
		local genreSaturation = false
		local saturationLevel = 0
		
		if themeSaturationLevel < genreSaturationLevel then
			genreSaturation = true
			saturationLevel = genreSaturationLevel
		else
			saturationLevel = themeSaturationLevel
		end
		
		saturationLevel = (saturationLevel - platform.MARKET_SATURATION_BOOST_CUTOFF) / (platform.MARKET_SATURATION_PENALTY_CUTOFF - platform.MARKET_SATURATION_BOOST_CUTOFF)
		
		local greatSaturation = saturationLevel >= self.largeSaturationCutoff
		local textIndex = 1
		local targetList = self:getTargetList(genreSaturation, greatSaturation)
		
		table.insert(remarksTable, {
			genreSaturation = genreSaturation,
			platformID = mostSaturatedPlatform,
			greatSaturation = greatSaturation,
			textIndex = math.random(1, #targetList)
		})
		
		remarksTable.weight = 15
	end,
	getTargetList = function(self, genreSaturation, greatSaturation)
		if genreSaturation then
			if greatSaturation then
				return self.text.genre.large, "GENRE"
			else
				return self.text.genre.slight, "GENRE"
			end
		elseif greatSaturation then
			return self.text.theme.large, "THEME"
		else
			return self.text.theme.slight, "THEME"
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		local data = remarksTable[1]
		local targetList, formatKey = self:getTargetList(data.genreSaturation, data.greatSaturation)
		local replacement
		
		if data.genreSaturation then
			replacement = genres.registeredByID[reviewObject:getProject():getGenre()].display
		else
			replacement = themes.registeredByID[reviewObject:getProject():getTheme()].display
		end
		
		local platformName = platformShare:getPlatformByID(data.platformID):getName()
		
		return _format(targetList[data.textIndex], formatKey, replacement, "PLATFORM", platformName)
	end
})

local validFeatures = {}

projectReview:registerRemark({
	id = "feature_absent",
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local features = project:getFeatures()
		local engineFeatures = project:getEngineRevisionFeatures()
		local expansion = project:getGameType() == gameProject.DEVELOPMENT_TYPE.EXPANSION
		
		if expansion then
			local baseFeatures = project:getSequelTo():getFeatures()
			
			for key, featureData in ipairs(taskTypes.registeredAbsenceCheck) do
				if featureData:canPenalizeForAbsense(project) then
					local id = featureData.id
					
					if not features[id] and not baseFeatures[id] and not engineFeatures[id] then
						local data = taskTypes.registeredByID[id]
						
						if data:absenseCheck(project) then
							validFeatures[#validFeatures + 1] = id
						end
					end
				end
			end
		else
			for key, featureData in ipairs(taskTypes.registeredAbsenceCheck) do
				if featureData:canPenalizeForAbsense(project) then
					local id = featureData.id
					
					if not features[id] and not engineFeatures[id] then
						local data = taskTypes.registeredByID[id]
						
						if data:absenseCheck(project) then
							validFeatures[#validFeatures + 1] = id
						end
					end
				end
			end
		end
		
		if #validFeatures == 0 then
			return false
		end
		
		local randomFeature = validFeatures[math.random(1, #validFeatures)]
		
		table.clear(validFeatures)
		table.insert(remarksTable, randomFeature)
		
		remarksTable.weight = 30
	end,
	pickText = function(self, reviewObject, remarksTable)
		local feature = remarksTable[1]
		local isNew = studio:revealFeature(feature)
		
		reviewObject:markNewReveal(isNew)
		
		if isNew then
			reviewObject:logReveal(feature, nil, true)
		end
		
		return taskTypes.registeredByID[feature]:getAbsenseText(reviewObject:getProject())
	end
})
projectReview:registerRemark({
	id = "price_too_high",
	text = {
		{
			_T("PRICE_TOO_HIGH_REMARK_1", "we think the price is too high for the amount of content it offers"),
			_T("PRICE_TOO_HIGH_REMARK_2", "the content amount does not justify the pricetag")
		},
		{
			_T("PRICE_GAME_IS_A_STEAL_1", "we think the game is a steal at its current price-point"),
			_T("PRICE_GAME_IS_A_STEAL_2", "the game is definitely worth the money the developers are asking for")
		}
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		
		if not project:isNewGame() then
			return false
		end
		
		local scalePriceRelation = project:getScalePriceRelationAffector()
		local priceIsBad = false
		local textTable
		
		if scalePriceRelation < 0.8 then
			badPrice = true
			textTable = self.text[1]
		elseif scalePriceRelation > 1.3 then
			textTable = self.text[2]
		end
		
		if not textTable then
			return 
		end
		
		table.insert(remarksTable, {
			badPrice = badPrice,
			textID = math.random(1, #textTable)
		})
	end,
	pickText = function(self, reviewObject, remarksTable)
		local data = remarksTable[1]
		
		if data.badPrice then
			reviewObject:addConclusion("price_too_high")
			
			return self.text[1][data.textID]
		end
		
		reviewObject:addConclusion("game_is_a_steal")
		
		return self.text[2][data.textID]
	end
})
projectReview:registerConclusion({
	id = "price_too_high",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_PRICE_TOO_HIGH", "Price too high in relation to the game scale, sales lowered"), "bh18", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 22, 22)
	end
})
projectReview:registerConclusion({
	id = "game_is_a_steal",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_GAME_IS_A_STEAL", "Increased sales due to positive price-to-scale relation!"), "bh18", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 22, 22)
	end
})
projectReview:registerRemark({
	id = "expansion_pack_released_too_late",
	text = {
		_T("EXPANSION_PACK_RELEASED_TOO_LATE_1", "the expansion pack seems to have been released a bit too late"),
		_T("EXPANSION_PACK_RELEASED_TOO_LATE_2", "we think if the expansion pack had come out earlier it would have done better sale-wise")
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		
		if project:isNewGame() then
			return false
		end
		
		local divider = project:getExpansionSaleDivider()
		
		if divider > 1 then
			remarksTable.weight = 20
			
			table.insert(remarksTable, {
				textID = math.random(1, #self.text)
			})
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		reviewObject:addConclusion("expansion_pack_released_too_late")
		
		return self.text[remarksTable[1].textID]
	end
})
projectReview:registerConclusion({
	id = "expansion_pack_released_too_late",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_EXPANSION_PACK_LATE", "Sales decreased due to late expansion pack"), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerRemark({
	id = "features_vs_price_vs_scale_too_low",
	text = {
		_T("FEATURES_VS_PRICE_VS_SCALE_TOO_LOW_1", "keeping the price & the amount of features in the project in mind, we think it's priced too high"),
		_T("FEATURES_VS_PRICE_VS_SCALE_TOO_LOW_2", "we think the price is too high for the amount of features there are in the game")
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local affector = project:getFeatureCountSaleAffector()
		
		if affector < 1 then
			remarksTable.weight = 30
			
			table.insert(remarksTable, {
				textID = math.random(1, #self.text)
			})
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local engineFeaturePercentage, featurePercentage = project:getEngineFeatureCountSaleAffector(), project:getGameFeatureCountSaleAffector()
		
		if featurePercentage < 1 and engineFeaturePercentage < 1 then
			reviewObject:addConclusion("features_vs_price_vs_scale_too_low")
		elseif featurePercentage < 1 then
			reviewObject:addConclusion("game_features_vs_price_vs_scale_too_low")
		elseif engineFeaturePercentage < 1 then
			reviewObject:addConclusion("engine_features_vs_price_vs_scale_too_low")
		end
		
		return self.text[remarksTable[1].textID]
	end
})
projectReview:registerConclusion({
	id = "features_vs_price_vs_scale_too_low",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_FEATURES_VS_PRICE_TOO_LOW", "Sales decreased due to lack of features in engine and game compared to price."), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerConclusion({
	id = "game_features_vs_price_vs_scale_too_low",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_GAME_FEATURES_VS_PRICE_TOO_LOW", "Sales decreased due to lack of game features compared to price."), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerConclusion({
	id = "engine_features_vs_price_vs_scale_too_low",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_ENGINE_FEATURES_VS_PRICE_TOO_LOW", "Sales decreased due to lack of engine features compared to price."), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerRemark({
	id = "mmo_fee_too_high",
	text = {
		_T("MMO_FEE_TOO_HIGH_REVIEW_REMARK_1", "the subscription fee is definitely too high in comparison to the game scale."),
		_T("MMO_FEE_TOO_HIGH_REVIEW_REMARK_2", "we think the monthly subscription fee is too high when compared to the game scale and will negatively affect the game sales.")
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local affector = project.mmoSaleAffector
		
		if affector and affector < 1 then
			remarksTable.weight = 30
			
			table.insert(remarksTable, {
				textID = math.random(1, #self.text)
			})
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		
		reviewObject:addConclusion("mmo_fee_too_high")
		
		return self.text[remarksTable[1].textID]
	end
})
projectReview:registerConclusion({
	id = "mmo_fee_too_high",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_MMO_FEE_TOO_HIGH", "Sales decreased due to high subscription fee compared to game scale."), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerRemark({
	id = "mmo_feature_match_remark",
	text = {
		_T("MMO_FEATURE_MATCH_REMARK_1", "for a MMO, some of the gameplay decisions didn't seem to work right with the game's genre."),
		_T("MMO_FEATURE_MATCH_REMARK_2", "the general design of the MMO doesn't seem to work that well, considering the genre that was picked for it.")
	},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local affector = project:getFact(gameProject.MMO_ATTRACTIVENESS_FACT)
		
		if affector and affector < 1 then
			remarksTable.weight = 30
			
			table.insert(remarksTable, {
				textID = math.random(1, #self.text)
			})
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		reviewObject:addConclusion("mmo_feature_match_bad")
		
		return self.text[remarksTable[1].textID]
	end
})
projectReview:registerConclusion({
	id = "mmo_feature_match_bad",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.UI_PENALTY_LINE)
		descBox:addText(_T("CONCLUSION_MMO_FEATURES_MATCH_BAD", "The picked MMO features don't work very well with the selected genre."), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
})
projectReview:registerRemark({
	id = "game_edition_desire_remark",
	text = {
		_T("GAME_EDITION_DESIRE_REMARK_1", "fans of the GENRE genre will be pleased to find out that the 'EDITION' has PART inside."),
		_T("GAME_EDITION_DESIRE_REMARK_2", "fans of the GENRE genre will be delighted to find out that the 'EDITION' has PART inside."),
		_T("GAME_EDITION_DESIRE_REMARK_3", "fans of the GENRE genre will be absolutely thrilled to find out that the 'EDITION' has PART inside."),
		_T("GAME_EDITION_DESIRE_REMARK_4", "the games 'EDITION' has PART inside, but we don't think a lot of people that enjoy the GENRE genre will find it that interesting.")
	},
	desireToTextIndex = {
		gameEditions.DESIRE_LOW,
		gameEditions.DESIRE_MODERATE,
		gameEditions.DESIRE_HIGH
	},
	validParts = {},
	attemptAdd = function(self, reviewObject, remarksTable)
		local project = reviewObject:getProject()
		local edits = project:getEditions()
		local editKey = math.random(1, #edits)
		local randomEdit = edits[editKey]
		local parts = randomEdit:getParts()
		local genre = project:getGenre()
		local validParts = self.validParts
		
		for key, partData in ipairs(parts) do
			if not studio:isEditionMatchRevealed(partData.id, genre) then
				validParts[#validParts + 1] = partData
			end
		end
		
		if #validParts > 0 then
			local randomPart = validParts[math.random(1, #validParts)]
			local desire = randomPart:getDesire(genre)
			local textIdx = 4
			
			for key, iDesire in ipairs(self.desireToTextIndex) do
				if desire == iDesire then
					textIdx = key
				end
			end
			
			remarksTable.weight = 30
			
			table.insert(remarksTable, {
				textID = textIdx,
				partID = randomPart.id,
				editionKey = editKey
			})
			table.clearArray(validParts)
		end
	end,
	pickText = function(self, reviewObject, remarksTable)
		local remarkData = remarksTable[1]
		local project = reviewObject:getProject()
		local genre = project:getGenre()
		local isNew = studio:revealEditionMatch(remarkData.partID, genre)
		
		reviewObject:markNewReveal(isNew)
		
		if isNew then
			reviewObject:addConclusion("game_edition_desire", remarkData.partID)
		end
		
		local edition = project:getEditions()[remarkData.editionKey]
		
		return _format(self.text[remarksTable[1].textID], "EDITION", edition:getName(), "GENRE", genres.registeredByID[genre].display, "PART", gameEditions.registeredPartsByID[remarkData.partID].displaySingular)
	end
})
projectReview:registerConclusion({
	id = "game_edition_desire",
	addToDescbox = function(self, descBox, wrapWidth)
		descBox:addTextLine(wrapWidth, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		
		local reviewObj = descBox:getReview()
		local data = reviewObj:getConclusionData()
		local project = reviewObj:getProject()
		
		descBox:addText(_format(_T("GAME_EDITION_PART_DESIRE_DISCOVERED", "Discovered player desire for PART in GENRE games."), "GENRE", genres.registeredByID[project:getGenre()].display, "PART", gameEditions.registeredPartsByID[data[self.id]].displaySingular), "bh20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
	end
})
