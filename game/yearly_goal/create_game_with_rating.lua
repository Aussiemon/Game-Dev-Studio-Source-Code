local goal = {}

goal.id = "create_game_with_rating"
goal.CAN_PICK = true
goal.MINIMUM_REQUIRED_GAME_RATING = 5
goal.MAXIMUM_RATING = 9
goal.MINIMUM_LEVELS_GIVEN = 1
goal.MAX_LEVELS_GIVEN = 3
goal.CATCHABLE_EVENTS = {
	gameProject.EVENTS.NEW_REVIEW
}

function goal:init()
end

function goal:getHighestGameRating()
	local highest = 0
	local amountOfGames = 0
	
	for key, gameObj in ipairs(studio:getReleasedGames()) do
		local rating = gameObj:getRealRating()
		
		if highest < rating then
			highest = rating
			amountOfGames = 1
		elseif rating == highest then
			amountOfGames = amountOfGames + 1
		end
	end
	
	return highest, amountOfGames
end

function goal:getRewardedLevels()
	local delta = (self.requiredRating - goal.MINIMUM_REQUIRED_GAME_RATING) / (goal.MAXIMUM_RATING - goal.MINIMUM_REQUIRED_GAME_RATING)
	
	return math.max(goal.MINIMUM_LEVELS_GIVEN, goal.MAX_LEVELS_GIVEN * delta)
end

function goal:prepare()
	local highestRating, gamesWithRating = self:getHighestGameRating()
	local curEmployees = studio:getEmployees()
	
	if math.random(1, 2) == 1 then
		self.requiredTheme = themes.registered[math.random(1, #themes.registered)].id
	else
		self.requiredGenre = genres.registered[math.random(1, #genres.registered)].id
	end
	
	local minRating = math.max(math.min(goal.MAXIMUM_RATING, highestRating + 2), goal.MINIMUM_REQUIRED_GAME_RATING)
	local maxRating = math.min(goal.MAXIMUM_RATING, minRating + gamesWithRating)
	
	self.requiredRating = math.floor(math.random(minRating, maxRating))
	self.currentYear = timeline:getYear()
end

function goal:getText()
	local baseText = _T("GAME_CREATION_GOAL_BASE_TEXT", "Create a game of the TYPE with a rating of at least RATING/10")
	local gameCreationTypeText
	
	if self.requiredTheme then
		gameCreationTypeText = string.easyformatbykeys(_T("THEME_GOAL_CREATION_TYPE", "'THEME' theme"), "THEME", themes.registeredByID[self.requiredTheme].display)
	else
		gameCreationTypeText = string.easyformatbykeys(_T("GENRE_GOAL_CREATION_TYPE", "'GENRE' genre"), "GENRE", genres.registeredByID[self.requiredGenre].display)
	end
	
	return string.easyformatbykeys(baseText, "TYPE", gameCreationTypeText, "RATING", self.requiredRating)
end

function goal:handleEvent(event, data, reviewObject)
	local projectObject = reviewObject:getProject()
	
	if projectObject:getOwner():isPlayer() and timeline:getYear(data:getReleaseDate()) == self.currentYear and reviewObject:getRating() >= self.requiredRating then
		if self.requiredTheme and projectObject:getTheme() == self.requiredTheme then
			yearlyGoalController:finishGoal(self)
		elseif self.requiredGenre and projectObject:getGenre() == self.requiredGenre then
			yearlyGoalController:finishGoal(self)
		end
	end
end

function goal:_updateDisplay(element)
	element:setText(self:getText())
end

function goal:save()
	local saved = goal.baseClass.save(self)
	
	saved.requiredTheme = self.requiredTheme
	saved.requiredGenre = self.requiredGenre
	saved.requiredRating = self.requiredRating
	saved.currentYear = self.currentYear
	
	return saved
end

function goal:load(data)
	self.requiredTheme = data.requiredTheme
	self.requiredGenre = data.requiredGenre
	self.requiredRating = data.requiredRating
	self.currentYear = data.currentYear
	
	goal.baseClass.load(self, data)
	self:updateDisplay(self.display)
end

yearlyGoalController:registerNew(goal, "goal_base")
