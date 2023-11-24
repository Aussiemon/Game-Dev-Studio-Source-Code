audience = {}
audience.registered = {}
audience.registeredByID = {}
audience.DEFAULT_MATCH_VALUE = 1

function audience:registerNew(data)
	table.insert(audience.registered, data)
	
	audience.registeredByID[data.id] = data
	
	for key, gData in ipairs(genres.registered) do
		self:verifyMatchForGenre(gData)
	end
end

function audience:getGenreMatching(gameProj)
	local projAudience = gameProj:getAudience()
	
	if not projAudience then
		return 1
	end
	
	return audience.registeredByID[projAudience].genreMatching[gameProj:getGenre()]
end

function audience:addGenreMatching(audienceID, genreID, matchMult)
	audience.registeredByID[audienceID].genreMatching[genreID] = matchMult
end

local sortedMatches = {
	positive = {},
	indifferent = {},
	negative = {}
}

function audience:getSortedMatches(audienceID)
	local data = audience.registeredByID[audienceID]
	
	for key, sublist in pairs(sortedMatches) do
		table.clearArray(sublist)
	end
	
	for genreID, matchValue in pairs(data.genreMatching) do
		if studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.AUDIENCE_MATCHING, audienceID, genreID, nil) then
			if matchValue > 1 then
				sortedMatches.positive[#sortedMatches.positive + 1] = genreID
			elseif matchValue == 1 then
				sortedMatches.indifferent[#sortedMatches.indifferent + 1] = genreID
			else
				sortedMatches.negative[#sortedMatches.negative + 1] = genreID
			end
		end
	end
	
	return sortedMatches.positive, sortedMatches.indifferent, sortedMatches.negative
end

function audience:verifyMatchForGenre(data)
	local matchVal = audience.DEFAULT_MATCH_VALUE
	
	for key, audData in ipairs(audience.registered) do
		if not audData.genreMatching[data.id] then
			audData.genreMatching[data.id] = matchVal
			
			print(_format("[WARNING] audience 'AUDIENCE' does not have a match for genre 'GENRE'. Setting default match value of MATCH.", "AUDIENCE", audData.id, "GENRE", data.id, "MATCH", matchVal))
		end
	end
end

audience.MATCH_VBAD = 0.5
audience.MATCH_BAD = 0.75
audience.MATCH_NORMAL = 1
audience.MATCH_GOOD = 1.05
audience.MATCH_VGOOD = 1.15

audience:registerNew({
	id = "everyone",
	display = _T("AUDIENCE_EVERYONE", "Everyone"),
	genreMatching = {
		action = audience.MATCH_NORMAL,
		adventure = audience.MATCH_GOOD,
		horror = audience.MATCH_VBAD,
		simulation = audience.MATCH_VBAD,
		fighting = audience.MATCH_BAD,
		strategy = audience.MATCH_VBAD,
		rpg = audience.MATCH_BAD,
		sandbox = audience.MATCH_VGOOD,
		racing = audience.MATCH_VGOOD
	}
})
audience:registerNew({
	id = "teen",
	display = _T("AUDIENCE_TEEN", "Teen"),
	genreMatching = {
		adventure = 1.15,
		action = audience.MATCH_GOOD,
		horror = audience.MATCH_NORMAL,
		simulation = audience.MATCH_VGOOD,
		fighting = audience.MATCH_VGOOD,
		strategy = audience.MATCH_VGOOD,
		rpg = audience.MATCH_NORMAL,
		sandbox = audience.MATCH_GOOD,
		racing = audience.MATCH_GOOD
	}
})
audience:registerNew({
	id = "mature",
	display = _T("AUDIENCE_MATURE", "Mature"),
	genreMatching = {
		action = audience.MATCH_NORMAL,
		adventure = audience.MATCH_NORMAL,
		horror = audience.MATCH_VGOOD,
		simulation = audience.MATCH_NORMAL,
		fighting = audience.MATCH_GOOD,
		strategy = audience.MATCH_NORMAL,
		rpg = audience.MATCH_VGOOD,
		sandbox = audience.MATCH_NORMAL,
		racing = audience.MATCH_NORMAL
	}
})
