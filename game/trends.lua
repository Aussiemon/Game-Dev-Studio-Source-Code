trends = {}
trends.currentThemes = {}
trends.currentGenres = {}
trends.currentThemesMap = {}
trends.currentGenresMap = {}
trends.newGenreThread = nil
trends.newThemeTrend = nil
trends.FIRST_TIME_TRENDS_FACT = "first_time_trends_shown"
trends.MAX_TRENDING_THEMES = 2
trends.MAX_TRENDING_GENRES = 2
trends.CHANCE_FOR_TREND = 30
trends.DURATION = {
	15,
	36
}
trends.REQUIRED_RATING_FOR_CONTRIBUTION = 7
trends.MAX_RATING_DELTA = review.maxRating - trends.REQUIRED_RATING_FOR_CONTRIBUTION
trends.RATING_MAX_BOOST = 0.25
trends.GAMES_PER_RIVAL = 2
trends.TREND_TYPES = {
	GENRE = 2,
	THEME = 1
}
trends.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_MONTH
}
trends.EVENTS = {
	TREND_OVER = events:new(),
	TREND_START = events:new()
}

function trends:init()
	events:addDirectReceiver(self, trends.CATCHABLE_EVENTS)
	
	self.validGenres = {}
	self.validThemes = {}
	self.justStoppedThemeTrend = {}
	self.justStoppedGenreTrend = {}
end

function trends:remove()
	events:removeDirectReceiver(self, trends.CATCHABLE_EVENTS)
	
	for key, id in ipairs(self.currentThemes) do
		self.currentThemes[key] = nil
		self.currentThemesMap[id] = nil
	end
	
	for key, id in ipairs(self.currentGenres) do
		self.currentGenres[key] = nil
		self.currentGenresMap[id] = nil
	end
	
	self.newThemeTrend = nil
	self.newGenreTrend = nil
end

function trends:lock()
	events:removeDirectReceiver(self, trends.CATCHABLE_EVENTS)
end

function trends:unlock()
	events:addDirectReceiver(self, trends.CATCHABLE_EVENTS)
end

function trends:handleEvent(event)
	self:decreaseDuration(self.currentThemes, 1, trends.TREND_TYPES.THEME)
	self:decreaseDuration(self.currentGenres, 1, trends.TREND_TYPES.GENRE)
	self:attemptStartTrend()
	table.clearArray(self.validGenres)
	table.clearArray(self.validThemes)
end

function trends:getThemeTrends()
	return self.currentThemes
end

function trends:isThemeTrending(themeID)
	for key, data in ipairs(self.currentThemes) do
		if data.id == themeID then
			return true
		end
	end
	
	return false
end

function trends:getGenreTrends()
	return self.currentGenres
end

function trends:isGenreTrending(genreID)
	for key, data in ipairs(self.currentGenres) do
		if data.id == genreID then
			return true
		end
	end
	
	return false
end

function trends:findValidTrends()
	local gamesByGenre, gamesByTheme = platformShare:getMarketSaturation()
	local maxGames = trends.GAMES_PER_RIVAL * (#rivalGameCompanies:getCompanies() + 1)
	
	for key, data in ipairs(genres.registered) do
		if not self.justStoppedGenreTrend[data.id] and not self.currentGenresMap[data.id] then
			if maxGames > gamesByGenre[data.id] then
				table.insert(self.validGenres, data.id)
			end
		else
			self.justStoppedGenreTrend[data.id] = nil
		end
	end
	
	for key, data in ipairs(themes.registered) do
		if not self.justStoppedThemeTrend[data.id] and not self.currentThemesMap[data.id] then
			if maxGames > gamesByTheme[data.id] then
				table.insert(self.validThemes, data.id)
			end
		else
			self.justStoppedThemeTrend[data.id] = nil
		end
	end
end

function trends:attemptStartTrend()
	self:findValidTrends()
	
	if #self.validThemes > 0 and #self.currentThemes < trends.MAX_TRENDING_THEMES and math.random(1, 100) <= trends.CHANCE_FOR_TREND then
		self.newThemeTrend = self:pickRandomTrend(self.validThemes, self.currentThemes, self.currentThemesMap)
		
		self:showNewTrends()
		
		return 
	end
	
	if #self.validGenres > 0 and #self.currentGenres < trends.MAX_TRENDING_GENRES and math.random(1, 100) <= trends.CHANCE_FOR_TREND then
		self.newGenreTrend = self:pickRandomTrend(self.validGenres, self.currentGenres, self.currentGenresMap)
		
		self:showNewTrends()
		
		return 
	end
end

function trends:_makeAllTrend()
	for key, data in ipairs(themes.registered) do
		if not table.find(self.currentThemes, data.id) then
			self.currentThemes[#self.currentThemes + 1] = self:setupTrendStructure(data.id)
		end
	end
	
	for key, data in ipairs(genres.registered) do
		if not table.find(self.currentGenres, data.id) then
			self.currentGenres[#self.currentGenres + 1] = self:setupTrendStructure(data.id)
		end
	end
end

trends.trendFormatMethods = {
	ru = function(type, trendID)
		if type == trends.TREND_TYPES.THEME then
			return string.format("Тематика '%s' теперь популярна. Создав хорошую игру с этой темой вы получите дополнительные продажи.\n\nНо если игра не будет хорошей, то бонус не будет получен", themes.registeredByID[trendID].display)
		end
		
		return string.format("Жанр '%s' теперь популярен. Создав хорошую игру этого жанра вы получите дополнительные продажи.\n\nНо если игра не будет хорошей, то бонус не будет получен", genres.registeredByID[trendID].display)
	end
}

function trends:createTrendingPopup(trendType, trendID)
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("NEW_TREND_TITLE", "New Trend"))
	
	local method = trends.trendFormatMethods[translation.currentLanguage]
	
	if method then
		popup:setText(method(trendType, trendID))
	else
		local trendTypeText, trendText
		
		if trendType == trends.TREND_TYPES.THEME then
			trendTypeText = _T("THEME_LOWERCASE", "theme")
			trendText = themes.registeredByID[trendID].display
		elseif trendType == trends.TREND_TYPES.GENRE then
			trendTypeText = _T("GENRE_LOWERCASE", "genre")
			trendText = genres.registeredByID[trendID].display
		end
		
		popup:setText(string.easyformatbykeys(_T("FIRST_TIME_TREND_EXPLANATION", "The 'TREND' TYPE is now trending. Creating a good game of this TYPE will yield extra sales.\n\nHowever if a game is not good, the trend factor will not yield any extra sales."), "TREND", trendText, "TYPE", trendTypeText))
	end
	
	popup:addOKButton(fonts.get("pix24"))
	popup:center()
	frameController:push(popup)
end

eventBoxText:registerNew({
	id = "new_theme_trend",
	getText = function(self, data)
		return _format(_T("NEW_THEME_TRENDING", "Games of the 'THEME' theme are now trending."), "THEME", themes.registeredByID[data].display)
	end
})
eventBoxText:registerNew({
	id = "new_genre_trend",
	getText = function(self, data)
		return _format(_T("NEW_GENRE_TRENDING", "Games of the 'GENRE' genre are now trending."), "GENRE", genres.registeredByID[data].display)
	end
})

function trends:showNewTrends()
	if not studio:getFact(trends.FIRST_TIME_TRENDS_FACT) then
		local trendType, trendID
		
		if self.newThemeTrend then
			trendType = trends.TREND_TYPES.THEME
			trendID = self.newThemeTrend
		elseif self.newGenreTrend then
			trendType = trends.TREND_TYPES.GENRE
			trendID = self.newGenreTrend
		end
		
		self:createTrendingPopup(trendType, trendID)
		studio:setFact(trends.FIRST_TIME_TRENDS_FACT, true)
	end
	
	if self.newThemeTrend then
		local element = game.addToEventBox("new_theme_trend", self.newThemeTrend, 1, "EventBoxTrendElement", "exclamation_point")
		
		element:setTrendData(trends.TREND_TYPES.THEME, self.newThemeTrend)
		events:fire(trends.EVENTS.TREND_OVER, trends.TREND_TYPES.THEME, self.newThemeTrend)
		
		self.newThemeTrend = nil
	end
	
	if self.newGenreTrend then
		local element = game.addToEventBox("new_genre_trend", self.newGenreTrend, 1, "EventBoxTrendElement", "exclamation_point")
		
		element:setTrendData(trends.TREND_TYPES.GENRE, self.newGenreTrend)
		events:fire(trends.EVENTS.TREND_OVER, trends.TREND_TYPES.GENRE, self.newGenreTrend)
		
		self.newGenreTrend = nil
	end
end

function trends:setupThemeTrendDescbox(descbox, themeID, wrapWidth)
	if self:isThemeTrending(themeID) then
		descbox:addSpaceToNextText(10)
		descbox:addText(_T("CURRENTLY_TRENDING", "Currently trending."), "bh20", game.UI_COLORS.LIGHT_BLUE, 3, wrapWidth, "star", 22, 22)
		descbox:addText(_T("THEME_IS_TRENDING_DESCRIPTION", "Creating a good game of this theme will yield extra sales."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 22, 22)
	end
end

function trends:setupGenreTrendDescbox(descbox, genreID, wrapWidth)
	if self:isGenreTrending(genreID) then
		descbox:addSpaceToNextText(10)
		descbox:addText(_T("CURRENTLY_TRENDING", "Currently trending."), "bh20", game.UI_COLORS.LIGHT_BLUE, 3, wrapWidth, "star", 22, 22)
		descbox:addText(_T("THEME_IS_TRENDING_DESCRIPTION", "Creating a good game of this theme will yield extra sales."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 22, 22)
	end
end

function trends:showAllGenreTrends(descbox, wrapWidth)
	if #self.currentGenres > 0 then
		descbox:addText(_T("CURRENTLY_TRENDING_GENRES", "Currently trending genres:"), "bh20", game.UI_COLORS.LIGHT_BLUE, 3, wrapWidth, "star", 22, 22)
		
		for key, trendData in ipairs(self.currentGenres) do
			local data = genres.registeredByID[trendData.id]
			
			descbox:addText(data.display, "bh18", nil, 3, wrapWidth, genres:getGenreUIIconConfig(data, 22, 22, 18))
		end
		
		return true
	end
	
	return false
end

local trendingConcat = {}

function trends:showAllThemeTrends(descbox, wrapWidth)
	if #self.currentThemes > 0 then
		descbox:addText(_T("CURRENTLY_TRENDING_THEMES", "Currently trending themes:"), "bh20", game.UI_COLORS.LIGHT_BLUE, 3, wrapWidth, "star", 22, 22)
		
		for key, trendData in ipairs(self.currentThemes) do
			trendingConcat[#trendingConcat + 1] = themes.registeredByID[trendData.id].display
		end
		
		descbox:addText(table.concat(trendingConcat, ", "), "bh18", nil, 3, wrapWidth)
		table.clearArray(trendingConcat)
		
		return true
	end
	
	return false
end

function trends:getContribution(gameProj)
	return self:getThemeSaleContribution(gameProj) * self:getGenreSaleContribution(gameProj)
end

function trends:getRatingBonus(rating)
	if rating <= trends.REQUIRED_RATING_FOR_CONTRIBUTION then
		return 1
	end
	
	return (rating - trends.REQUIRED_RATING_FOR_CONTRIBUTION) / trends.MAX_RATING_DELTA * trends.RATING_MAX_BOOST + 1
end

function trends:getThemeSaleContribution(gameProj)
	if self:isThemeTrending(gameProj:getTheme()) then
		return self:getRatingBonus(gameProj:getMergedRating())
	end
	
	return 1
end

function trends:getGenreSaleContribution(gameProj)
	if self:isGenreTrending(gameProj:getGenre()) then
		return self:getRatingBonus(gameProj:getMergedRating())
	end
	
	return 1
end

function trends:setupTrendStructure(id)
	return {
		id = id,
		time = math.random(trends.DURATION[1], trends.DURATION[2])
	}
end

function trends:pickRandomTrend(from, to, map)
	local random = from[math.random(1, #from)]
	local structure = self:setupTrendStructure(random)
	
	table.insert(to, structure)
	
	map[structure.id] = structure
	
	return random
end

eventBoxText:registerNew({
	id = "theme_trend_over",
	getText = function(self, data)
		return _format(_T("THEME_TREND_OVER", "The 'THEME' theme is no longer trending."), "THEME", themes.registeredByID[data].display)
	end
})
eventBoxText:registerNew({
	id = "genre_trend_over",
	getText = function(self, data)
		return _format(_T("GENRE_TREND_OVER", "The 'GENRE' genre is no longer trending."), "GENRE", genres.registeredByID[data].display)
	end
})

function trends:decreaseDuration(list, amount, trendType)
	local key = 1
	
	for i = 1, #list do
		local data = list[key]
		
		data.time = data.time - amount
		
		if data.time <= 0 then
			table.remove(list, key)
			
			local id = data.id
			
			if trendType == trends.TREND_TYPES.THEME then
				self.justStoppedThemeTrend[id] = true
				self.currentThemesMap[id] = nil
				
				game.addToEventBox("theme_trend_over", id, 1, nil, "exclamation_point")
			else
				self.justStoppedGenreTrend[id] = true
				self.currentGenresMap[id] = nil
				
				game.addToEventBox("genre_trend_over", id, 1, nil, "exclamation_point")
			end
			
			events:fire(trends.EVENTS.TREND_OVER, trendType, id)
		else
			key = key + 1
		end
	end
end

function trends:buildMaps()
	for key, data in ipairs(self.currentThemes) do
		self.currentThemesMap[data.id] = data
	end
	
	for key, data in ipairs(self.currentGenres) do
		self.currentGenresMap[data.id] = data
	end
end

function trends:save()
	local saved = {}
	
	saved.currentThemes = self.currentThemes
	saved.currentGenres = self.currentGenres
	
	return saved
end

function trends:load(data)
	if data then
		self.currentThemes = data.currentThemes or self.currentThemes
		self.currentGenres = data.currentGenres or self.currentGenres
		
		self:buildMaps()
	end
end
