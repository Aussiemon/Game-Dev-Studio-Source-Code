gameQuality = {}
gameQuality.registered = {}
gameQuality.registeredByID = {}

function gameQuality:registerNew(data)
	table.insert(gameQuality.registered, data)
	
	gameQuality.registeredByID[data.id] = data
	data.quad = quadLoader:load(data.icon)
	data.genreContributionImportanceList = {}
end

function gameQuality:getData(id)
	return self.registeredByID[id]
end

function gameQuality:getReviewText(id, qualityID)
	local qualityData = self.registeredByID[id]
	
	if qualityData then
		return qualityData.reviewText[qualityID]
	end
	
	return nil
end

gameQuality.currentSortQualityID = nil

function gameQuality.sortByHighestContribution(a, b)
	return genres.registeredByID[a].scoreImpact[gameQuality.currentSortQualityID] > genres.registeredByID[b].scoreImpact[gameQuality.currentSortQualityID]
end

function gameQuality:rebuildContributionImportanceLists()
	for key, qualityData in ipairs(gameQuality.registered) do
		table.clearArray(qualityData.genreContributionImportanceList)
	end
	
	for key, qualityData in ipairs(gameQuality.registered) do
		for key, genreData in ipairs(genres.registered) do
			qualityData.genreContributionImportanceList[#qualityData.genreContributionImportanceList + 1] = genreData.id
		end
		
		gameQuality.currentSortQualityID = qualityData.id
		
		table.sort(qualityData.genreContributionImportanceList, gameQuality.sortByHighestContribution)
	end
end

gameQuality:registerNew({
	id = "graphics",
	icon = "quality_graphics",
	display = _T("GRAPHICS", "Graphics"),
	displayHeader = _T("GRAPHICS_HEADER", "The graphics"),
	description = _T("GRAPHICS_DESCRIPTION", "A renderer is as important as the artistic vision if you wish to impress the players with visuals."),
	reviewText = {
		[projectReview.FEATURES_TYPE.BEST] = {
			_T("REVIEW_GRAPHICS_RESULT_BEST1", "the visuals were superb"),
			_T("REVIEW_GRAPHICS_RESULT_BEST2", "graphics in this game are a sight to behold"),
			_T("REVIEW_GRAPHICS_RESULT_BEST3", "I think this game may have the best graphics I've seen yet")
		},
		[projectReview.FEATURES_TYPE.AVG] = {
			_T("REVIEW_GRAPHICS_RESULT_AVERAGE1", "graphics were OK"),
			_T("REVIEW_GRAPHICS_RESULT_AVERAGE2", "the graphics were ordinary"),
			_T("REVIEW_GRAPHICS_RESULT_AVERAGE3", "nothing about the graphics was good nor bad")
		},
		[projectReview.FEATURES_TYPE.WORST] = {
			_T("REVIEW_GRAPHICS_RESULT_WORST1", "the graphics desperately needed more work"),
			_T("REVIEW_GRAPHICS_RESULT_WORST2", "this game is lacking in the visual side of things"),
			_T("REVIEW_GRAPHICS_RESULT_WORST3", "I can't imagine the developers were very fond of the graphics themselves")
		}
	}
})
gameQuality:registerNew({
	id = "sound",
	icon = "quality_sound",
	display = _T("SOUND", "Sound"),
	displayHeader = _T("SOUND_HEADER", "The sound"),
	description = _T("SOUND_DESCRIPTION", "A game that looks good, but sounds bad will not leave a good impression."),
	reviewText = {
		[projectReview.FEATURES_TYPE.BEST] = {
			_T("REVIEW_SOUND_RESULT_BEST1", "the sound design was fantastic"),
			_T("REVIEW_SOUND_RESULT_BEST2", "we think the sound quality was great"),
			_T("REVIEW_SOUND_RESULT_BEST3", "the developers did a great job on the sound of the game")
		},
		[projectReview.FEATURES_TYPE.AVG] = {
			_T("REVIEW_SOUND_RESULT_AVERAGE1", "the sounds were alright"),
			_T("REVIEW_SOUND_RESULT_AVERAGE2", "the sound design was OK"),
			_T("REVIEW_SOUND_RESULT_AVERAGE3", "nothing about the sound design was exceptional")
		},
		[projectReview.FEATURES_TYPE.WORST] = {
			_T("REVIEW_SOUND_RESULT_WORST1", "we think the sound design was bad"),
			_T("REVIEW_SOUND_RESULT_WORST2", "the sounds seem to have been made by amateurs"),
			_T("REVIEW_SOUND_RESULT_WORST3", "we think the sound design was a weak point of the game")
		}
	}
})
gameQuality:registerNew({
	id = "gameplay",
	icon = "quality_gameplay",
	display = _T("GAMEPLAY", "Gameplay"),
	displayHeader = _T("GAMEPLAY_HEADER", "The gameplay"),
	description = _T("GAMEPLAY_DESCRIPTION", "Gameplay is the meat of the game. What good is a game if it has poor controls and game mechanics that aren't satisfying at all?"),
	reviewText = {
		[projectReview.FEATURES_TYPE.BEST] = {
			_T("REVIEW_GAMEPLAY_RESULT_BEST1", "the gameplay was fantastic"),
			_T("REVIEW_GAMEPLAY_RESULT_BEST2", "in terms of gameplay, this game is great"),
			_T("REVIEW_GAMEPLAY_RESULT_BEST3", "the gameplay is so good, I think I'll replay the game in its entirety")
		},
		[projectReview.FEATURES_TYPE.AVG] = {
			_T("REVIEW_GAMEPLAY_RESULT_AVERAGE1", "the gameplay was mostly OK"),
			_T("REVIEW_GAMEPLAY_RESULT_AVERAGE2", "some gameplay design choices were strange"),
			_T("REVIEW_GAMEPLAY_RESULT_AVERAGE3", "the gameplay side of things was tolerable")
		},
		[projectReview.FEATURES_TYPE.WORST] = {
			_T("REVIEW_GAMEPLAY_RESULT_WORST1", "unfortunately, the gameplay was just not good"),
			_T("REVIEW_GAMEPLAY_RESULT_WORST2", "I can't imagine a lot of people will enjoy the way the game plays"),
			_T("REVIEW_GAMEPLAY_RESULT_WORST3", "to put it bluntly - the gameplay design choices were bad")
		}
	}
})
gameQuality:registerNew({
	id = "story",
	icon = "quality_story",
	display = _T("STORY", "Story"),
	displayHeader = _T("STORY_HEADER", "The story"),
	description = _T("STORY_DESCRIPTION", "Mindless shooters can be fun for only so long, so it's important to have a good storyline."),
	reviewText = {
		[projectReview.FEATURES_TYPE.BEST] = {
			_T("REVIEW_STORY_RESULT_BEST1", "the story was really captivating"),
			_T("REVIEW_STORY_RESULT_BEST2", "the writers did an excellent job with the story"),
			_T("REVIEW_STORY_RESULT_BEST3", "the story was interesting, unpredictable and generally well-written")
		},
		[projectReview.FEATURES_TYPE.AVG] = {
			_T("REVIEW_STORY_RESULT_AVERAGE1", "the story was alright"),
			_T("REVIEW_STORY_RESULT_AVERAGE2", "the story did its job, but wasn't anything special"),
			_T("REVIEW_STORY_RESULT_AVERAGE3", "the story was OK")
		},
		[projectReview.FEATURES_TYPE.WORST] = {
			_T("REVIEW_STORY_RESULT_WORST1", "there were glaring plot holes in the story"),
			_T("REVIEW_STORY_RESULT_WORST2", "what is going on in the story of this game? It's awful!"),
			_T("REVIEW_STORY_RESULT_WORST3", "whoever wrote the story should put their pen down")
		}
	}
})
gameQuality:registerNew({
	id = "dialogue",
	icon = "quality_dialogue",
	display = _T("DIALOGUE", "Dialogue"),
	displayHeader = _T("DIALOGUE_HEADER", "The dialogue"),
	description = _T("DIALOGUE_DESCRIPTION", "While not necessary in shooter-type games, a good dialogue system with a well-acted voice-over can complement any game that prides itself on a good story."),
	reviewText = {
		[projectReview.FEATURES_TYPE.BEST] = {
			_T("REVIEW_DIALOGUE_RESULT_BEST1", "the dialogue between the characters was very nicely done"),
			_T("REVIEW_DIALOGUE_RESULT_BEST2", "there is nothing off or weird about the character dialogues"),
			_T("REVIEW_DIALOGUE_RESULT_BEST3", "the dialogue was great")
		},
		[projectReview.FEATURES_TYPE.AVG] = {
			_T("REVIEW_DIALOGUE_RESULT_AVERAGE1", "the dialogue was OK"),
			_T("REVIEW_DIALOGUE_RESULT_AVERAGE2", "the dialogue was a bit spotty"),
			_T("REVIEW_DIALOGUE_RESULT_AVERAGE3", "interactions between characters were a bit weird in terms of their spoken dialogue")
		},
		[projectReview.FEATURES_TYPE.WORST] = {
			_T("REVIEW_DIALOGUE_RESULT_WORST1", "the dialogue was not good"),
			_T("REVIEW_DIALOGUE_RESULT_WORST2", "the dialogue was poorly written"),
			_T("REVIEW_DIALOGUE_RESULT_WORST3", "the quality of the dialogue makes me think a child wrote it")
		}
	}
})
gameQuality:registerNew({
	id = "world_design",
	icon = "quality_world_design",
	display = _T("WORLD_DESIGN", "World design"),
	displayHeader = _T("WORLD_DESIGN_HEADER", "The world design"),
	description = _T("WORLD_DESIGN_QUALITY", "Designing a world, or its levels, is no easy task, but do both well - and people will love playing the game."),
	reviewText = {
		[projectReview.FEATURES_TYPE.BEST] = {
			_T("REVIEW_WORLD_DESIGN_RESULT_BEST1", "the world design was fantastic"),
			_T("REVIEW_WORLD_DESIGN_RESULT_BEST2", "the locations within the game are beautifully crafted"),
			_T("REVIEW_WORLD_DESIGN_RESULT_BEST3", "the world of the game is amazing")
		},
		[projectReview.FEATURES_TYPE.AVG] = {
			_T("REVIEW_WORLD_DESIGN_RESULT_AVERAGE1", "the locations were alright"),
			_T("REVIEW_WORLD_DESIGN_RESULT_AVERAGE2", "we think the world design was OK, but could have been done better"),
			_T("REVIEW_WORLD_DESIGN_RESULT_AVERAGE3", "the world design side of things does its job")
		},
		[projectReview.FEATURES_TYPE.WORST] = {
			_T("REVIEW_WORLD_DESIGN_RESULT_WORST1", "the world design is bad, really bad"),
			_T("REVIEW_WORLD_DESIGN_RESULT_WORST2", "world design is a weak point of this game"),
			_T("REVIEW_WORLD_DESIGN_RESULT_WORST3", "what's up with the world design? The locations are ugly and don't flow together well")
		}
	}
})
