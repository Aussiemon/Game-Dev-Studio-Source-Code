knowledge = {}
knowledge.registered = {}
knowledge.registeredByID = {}
knowledge.RANDOM_STARTING_KNOWLEDGE = {
	5,
	40
}
knowledge.MAXIMUM_KNOWLEDGE = 1000

local defaultKnowledgeFuncs = {}

defaultKnowledgeFuncs.mtindex = {
	__index = defaultKnowledgeFuncs
}

function defaultKnowledgeFuncs:addContributionType(genreID, themeID, amount)
	for key, data in ipairs(self.contributions) do
		if data.genre == genreID and data.theme == themeID then
			return 
		end
	end
	
	table.insert(self.contributions, {
		genre = genreID,
		theme = themeID,
		contribution = amount
	})
end

function defaultKnowledgeFuncs:setupDescbox(descBox, employee, wrapWidth)
	local result = knowledge:setupContributionDisplay(self.contributions, descBox, wrapWidth)
	
	if self.taskCount > 0 then
		descBox:addSpaceToNextText(10)
		descBox:addText(_T("KNOWLEDGE_CONTRIBUTES_TO_TASKS", "This knowledge adds extra Quality points in certain tasks."), "pix18", nil, 4, math.max(200, wrapWidth * 0.75))
		descBox:addText(_format(_T("CONTRIBUTES_TO_TASKS_COUNTER", "Tasks contributing to: COUNTER"), "COUNTER", self.taskCount), "bh20", game.UI_COLORS.DARK_LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		
		result = true
	end
	
	return result
end

function knowledge.sortByThemeID(a, b)
	return a.theme < b.theme
end

function knowledge:sortContributionsByAlphabet(contributionList)
	table.sort(contributionList, self.sortByThemeID)
end

function knowledge:onGameStarted()
	for key, data in ipairs(knowledge.registered) do
		if #data.contributions > 0 then
			self:sortContributionsByAlphabet(data.contributions)
		end
	end
	
	interests:setupContributionLists()
end

function knowledge:setupContributionDisplay(contribList, descBox, wrapWidth)
	if #contribList > 0 then
		descBox:addSpaceToNextText(5)
		descBox:addText(_T("KNOWLEDGE_CONTRIBUTES_TO", "Contributes to:"), "bh20", nil, 0, wrapWidth)
		descBox:addSpaceToNextText(2)
		
		for key, data in ipairs(contribList) do
			descBox:addText(_format(_T("THEME_GENRE_GAMES", "\tTHEME GENRE games"), "THEME", themes.registeredByID[data.theme].display, "GENRE", genres.registeredByID[data.genre].display), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
		end
		
		return true
	end
	
	return false
end

function knowledge:registerNew(data)
	table.insert(knowledge.registered, data)
	
	knowledge.registeredByID[data.id] = data
	data.maximum = data.maximum or knowledge.MAXIMUM_KNOWLEDGE
	data.icon = data.icon or "employee"
	data.contributions = {}
	data.taskCount = 0
	data.baseClass = defaultKnowledgeFuncs
	
	setmetatable(data, defaultKnowledgeFuncs.mtindex)
end

function knowledge:getData(id)
	return self.registeredByID[id]
end

function knowledge:getMaximumKnowledge(knowledgeID)
	return knowledge.registeredByID[knowledgeID].maximum
end

function knowledge:assignFromInterests(employee)
	local startKnowledge = knowledge.RANDOM_STARTING_KNOWLEDGE
	
	for key, interest in ipairs(employee:getInterests()) do
		local data = interests:getData(interest)
		
		if data.knowledgeProgression then
			for key, progress in ipairs(data.knowledgeProgression) do
				local final = 0
				
				for i = 1, employee:getLevel() do
					final = final + math.random(startKnowledge[1], startKnowledge[2]) + self:getProgressAmount(progress)
				end
				
				employee:addKnowledge(progress.id, final)
			end
		end
	end
end

function knowledge:progress(employee)
	for key, interest in ipairs(employee:getInterests()) do
		local data = interests:getData(interest)
		
		if data.knowledgeProgression then
			for key, progress in ipairs(data.knowledgeProgression) do
				employee:addKnowledge(progress.id, self:getProgressAmount(progress))
			end
		end
	end
end

function knowledge:getProgressAmount(data)
	return data.min and math.round(math.randomf(data.min, data.max), 1) or data.amount
end

function knowledge:getPercentageToMax(curLevel, knowledgeID)
	return curLevel / knowledge.registeredByID[knowledgeID].maximum
end

require("game/developer/basic_knowledge")
