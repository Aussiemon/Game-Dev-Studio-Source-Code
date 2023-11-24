local topic = {}

topic.id = "high_price"
topic.factCheck = "highest_game_pricepoint"
topic.pricing = {
	price = 24,
	type = "greater"
}
topic.display = _T("INTERVIEW_HIGH_PRICE", "Interview - High price")
topic.description = _T("INTERVIEW_FIRST_TIME_HIGH_PRICE", "This is your first time working on a project priced at $PRICE, what is the reason behind such a high price?")
topic.answerOptions = {
	{
		answerScore = -30,
		text = _T("INTERVIEW_HIGH_PRICE_ANSWER1", "We're in a tough financial spot")
	},
	{
		answerScore = 0,
		text = _T("INTERVIEW_HIGH_PRICE_ANSWER2", "We've got more employees")
	},
	{
		answerScore = 10,
		text = _T("INTERVIEW_HIGH_PRICE_ANSWER3", "This is a big project")
	}
}

function topic:getDescription(interviewObj)
	local targetProject = interviewObj:getTargetProject()
	
	return string.easyformatbykeys(self.description, "PRICE", targetProject:getPrice())
end

function topic:onAnswered(interviewObj)
	self.baseTopicFuncs.onAnswered(self, interviewObj)
	studio:setFact(self.factCheck, interviewObj:getTargetProject():getPrice())
end

function topic:checkEligibility(interviewObj)
	local factValue = studio:getFact(self.factCheck)
	
	if factValue and factValue > interviewObj:getTargetProject():getPrice() then
		return false
	end
	
	return true
end

interviewTopics:registerNew(topic)

local topic = {}

topic.id = "estimated_dev_time"
topic.daysWorkedOn = {
	days = 0,
	type = "any"
}
topic.facts = {
	maximumFacts = 0,
	minimumFacts = 0,
	factIDs = {
		"asked_about_dev_time"
	}
}
topic.display = _T("INTERVIEW_DEV_TIME_ESTIMATION", "Interview - Dev time estimation")
topic.description = _T("INTERVIEW_ESTIMATED_DEV_TIME", "Fans would like to know - how soon will the game be released?")
topic.answerOptions = {
	{
		answerScore = -10,
		text = _T("INTERVIEW_DEV_TIME_ESTIMATION_ANSWER1", "We don't know yet")
	},
	{
		answerScore = 0,
		text = _T("INTERVIEW_DEV_TIME_ESTIMATION_ANSWER2", "When it's done")
	},
	{
		answerScore = 10,
		text = _T("INTERVIEW_DEV_TIME_ESTIMATION_ANSWER3", "You will soon find out")
	}
}

function topic:checkEligibility(interviewObj)
	if interviewObj:getTargetProject():getReleaseDate() then
		return false
	end
	
	return true
end

function topic:onAnswered(interviewObj)
	studio:setFact(topic.facts.factIDs[1], true)
end

interviewTopics:registerNew(topic)

local newFeature = {}

newFeature.id = "new_engine_feature_question"
newFeature.display = _T("INTERVIEW_NEW_FEATURE", "Interview - New feature")
newFeature.description = _T("INTERVIEW_NEW_FEATURE_DISCUSSION", "This is your first time making use of 'FEATURE', was it a challenge to implement?")
newFeature.baseFactName = "asked_about_"
newFeature.validFeatures = {}
newFeature.featureRelevanceTime = timeline.DAYS_IN_MONTH * 6
newFeature.answerOptions = {
	{
		answerScore = 10,
		text = _T("INTERVIEW_NEW_FEATURE_ANSWER3", "Nothing we can't deal with")
	},
	{
		answerScore = -10,
		text = _T("INTERVIEW_NEW_FEATURE_ANSWER1", "Definitely")
	},
	{
		answerScore = 0,
		text = _T("INTERVIEW_NEW_FEATURE_ANSWER2", "Absolutely not")
	}
}

function newFeature:isFeatureRelevant(taskData)
	if taskData.releaseDate and platforms:reachedReleaseTime(taskData) then
		local baseTime = timeline:yearToTime(taskData.releaseDate.year)
		
		if taskData.releaseDate.month then
			baseTime = baseTime + timeline:monthToTime(taskData.releaseDate.month)
		end
		
		return timeline.curTime < baseTime + newFeature.featureRelevanceTime
	end
	
	return false
end

function newFeature:applyData(topicInst)
	topicInst.featureToAskAbout = self.featureToAskAbout
end

function newFeature:getFeatureToAskAbout(interviewObj)
	local engineObj = interviewObj:getTargetProject():getEngine()
	
	table.clear(self.validFeatures)
	
	for featureID, state in pairs(engineObj:getFeatures()) do
		local taskData = taskTypes:getData(featureID)
		
		if taskData.canAskAbout and platforms:reachedReleaseTime(taskData) and self:isFeatureRelevant(taskData) then
			local factName = self.baseFactName .. featureID
			
			if not studio:getFact(factName) then
				table.insert(self.validFeatures, featureID)
			end
		end
	end
	
	if #self.validFeatures > 0 then
		self.featureToAskAbout = self.validFeatures[math.random(1, #self.validFeatures)]
	else
		self.featureToAskAbout = nil
	end
	
	table.clearArray(self.validFeatures)
end

function newFeature:checkEligibility(interviewObj)
	self.featureToAskAbout = nil
	
	self:getFeatureToAskAbout(interviewObj)
	
	return self.featureToAskAbout ~= nil
end

function newFeature:getDescription(interviewObj)
	local taskData = taskTypes:getData(self.featureToAskAbout)
	local text = self.description
	
	if taskData.interviewQuestion then
		text = taskData.interviewQuestion
	end
	
	return string.easyformatbykeys(text, "FEATURE", taskData.display)
end

function newFeature:onAnswered(interviewObj)
	studio:setFact(self.baseFactName .. self.featureToAskAbout, true)
	
	self.featureToAskAbout = nil
end

interviewTopics:registerNew(newFeature)

local newGenre = {}

newGenre.id = "new_genre_question"
newGenre.display = _T("INTERVIEW_NEW_GENRE", "Interview - New genre")
newGenre.description = _T("INTERVIEW_NEW_GENRE_DESC", "This is your first time working on a game of the GENRE genre, what can you tell us about the development process?")
newGenre.baseFactName = "asked_about_genre_"
newGenre.answerOptions = {
	{
		answerScore = 0,
		text = _T("INTERVIEW_NEW_GENRE_ANSWER1", "It can be a challenge")
	},
	{
		answerScore = -10,
		text = _T("INTERVIEW_NEW_GENRE_ANSWER2", "It's boring")
	},
	{
		answerScore = 10,
		text = _T("INTERVIEW_NEW_GENRE_ANSWER3", "It's a fun experience")
	}
}

function newGenre:getGenreToTalkAbout(interviewObj)
	local projectGenre = interviewObj:getTargetProject():getGenre()
	
	if studio:getFact(self.baseFactName .. projectGenre) or studio:getGamesByGenre(genreID) then
		return nil
	end
	
	self.genreToAskAbout = projectGenre
end

function newGenre:applyData(topicInst)
	topicInst.genreToAskAbout = self.genreToAskAbout
end

function newGenre:checkEligibility(interviewObj)
	self.genreToAskAbout = nil
	
	self:getGenreToTalkAbout(interviewObj)
	
	return self.genreToAskAbout ~= nil
end

function newGenre:onNotPicked(interviewObj)
	self.genreToAskAbout = nil
end

function newGenre:getDescription(interviewObj)
	local genreData = genres:getData(self.genreToAskAbout)
	local text = self.description
	
	if genreData.interviewQuestion then
		text = genreData.interviewQuestion
	end
	
	return string.easyformatbykeys(text, "GENRE", genreData.display)
end

function newGenre:onAnswered(interviewObj)
	studio:setFact(self.baseFactName .. self.genreToAskAbout, true)
	
	self.genreToAskAbout = nil
end

interviewTopics:registerNew(newGenre)

local newSequel = {}

newSequel.id = "new_sequel_question"
newSequel.display = _T("INTERVIEW_NEW_SEQUEL", "Interview - New sequel")
newSequel.description = _T("INTERVIEW_NEW_SEQUEL_DESC", "It has been a while since you've made a game related to 'GAME', do you have any plans to return to it any time in the future?")
newSequel.baseFactName = "asked_about_game_sequels"
newSequel.answerOptions = {
	{
		answerScore = 5,
		text = _T("INTERVIEW_NEW_SEQUEL_ANSWER1", "We will, stay tuned")
	},
	{
		answerScore = 0,
		text = _T("INTERVIEW_NEW_SEQUEL_ANSWER2", "We never intended to make a sequel")
	},
	{
		answerScore = -5,
		text = _T("INTERVIEW_NEW_SEQUEL_ANSWER3", "Can't say anything about that")
	}
}
newSequel.validGames = {}
newSequel.talkableGameAge = timeline.DAYS_IN_YEAR * 5
newSequel.untalkableGameAge = timeline.DAYS_IN_YEAR * 15
newSequel.talkableTypes = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true,
	[gameProject.DEVELOPMENT_TYPE.MMO] = true
}

function newSequel:getGameToTalkAbout(interviewObj)
	for key, gameObject in ipairs(studio:getReleasedGames()) do
		if self:canTalkAboutGame(gameObject) and not gameObject:wasSequelMade() then
			self.validGames[#self.validGames + 1] = gameObject
		end
	end
	
	if #self.validGames > 0 then
		local randomGame = self.validGames[math.random(1, #self.validGames)]
		
		table.clearArray(self.validGames)
		
		self.gameToTalkAbout = randomGame
	end
end

function newSequel:canTalkAboutGame(gameProj)
	if not self.talkableTypes[gameProj:getGameType()] then
		return false
	end
	
	local releaseDate = gameProj:getReleaseDate()
	local curTime = timeline.curTime
	local list = studio:getFact(self.baseFactName)
	
	return (not list or list[gameProj:getUniqueID()]) and curTime > releaseDate + self.talkableGameAge and curTime < releaseDate + self.untalkableGameAge
end

function newSequel:applyData(topicInst)
	topicInst.gameToTalkAbout = self.gameToTalkAbout
end

function newSequel:checkEligibility(interviewObj)
	self.gameToTalkAbout = nil
	
	self:getGameToTalkAbout(interviewObj)
	
	return self.gameToTalkAbout ~= nil
end

function newSequel:getDescription(interviewObj)
	return string.easyformatbykeys(self.description, "GAME", self.gameToTalkAbout:getName())
end

function newSequel:onAnswered(interviewObj)
	local list = studio:getFact(self.baseFactName) or {}
	
	list[self.gameToTalkAbout:getUniqueID()] = true
	
	studio:setFact(self.baseFactName, list)
	
	self.gameToTalkAbout = nil
end

interviewTopics:registerNew(newSequel)

local newTech = {}

newTech.id = "new_sequel_features_question"
newTech.display = _T("INTERVIEW_NEW_GAME_FEATURES", "Interview - New features")
newTech.description = _T("INTERVIEW_NEW_GAME_FEATURES_DESC", "The gaming industry has gone quite a way since you've last made a game. Our readers are interested in what kind of game-related tech you will be showing in your new game.")
newTech.answerOptions = {}
newTech.baseScorePerAnswer = 10
newTech.highestContributors = {}
newTech.averageContributors = {}
newTech.unneededContributors = {}

function newTech:checkEligibility(interviewObj)
	self.featureToTalkAbout = nil
	
	self:checkForFeatures(interviewObj:getTargetProject())
	
	return self:hasEnoughFeatures(self.highestContributors, self.averageContributors, self.unneededContributors)
end

function newTech:onAddToInterview(interviewObj)
	table.clear(self._answerOptions)
	self:attemptCreateOption(self.highestContributors, self.highestContribution)
	self:attemptCreateOption(self.averageContributors, self.averageContribution)
	self:attemptCreateOption(self.unneededContributors, self.lowestContribution)
	table.clear(self.highestContributors)
	table.clear(self.averageContributors)
	table.clear(self.unneededContributors)
	
	self.highestContribution, self.averageContribution, self.lowestContribution = nil
end

function newTech:attemptCreateOption(taskList, scoreMultiplier)
	local randomTask = taskList[math.random(1, #taskList)]
	
	if randomTask then
		self._answerOptions[#self._answerOptions + 1] = {
			text = randomTask.display,
			answerScore = self.baseScorePerAnswer * scoreMultiplier
		}
	end
end

function newTech:hasEnoughFeatures(...)
	local total = 0
	
	for i = 1, select("#", ...) do
		local list = select(i, ...)
		
		if #list > 0 then
			total = total + 1
		end
	end
	
	return total >= 2
end

function newTech:checkForFeatures(projectObj)
	local relatedGame = projectObj:getSequelTo()
	
	if not relatedGame then
		return false
	end
	
	local scoreImpact = genres:getScoreImpact(projectObj)
	
	self.highestContribution, self.averageContribution, self.lowestContribution = -math.huge, 1, math.huge
	
	local highestContributionType, averageContributionType, lowestContributionType
	
	for qualityID, impactMult in pairs(scoreImpact) do
		if impactMult > self.averageContribution and impactMult > self.highestContribution then
			self.highestContribution = impactMult
			highestContributionType = qualityID
		elseif impactMult == self.averageContribution then
			averageContributionType = qualityID
		elseif impactMult < self.averageContribution and impactMult < self.lowestContribution then
			self.lowestContribution = impactMult
			lowestContributionType = qualityID
		end
	end
	
	local releaseDate = relatedGame:getReleaseDate()
	local releaseYear, releaseMonth = timeline:getYear(releaseDate), timeline:getMonth(releaseDate)
	local gameTasks = taskTypes:getTasksByTaskID("game_task")
	
	for key, taskData in ipairs(gameTasks) do
		if taskData.releaseDate and releaseYear < taskData.releaseDate.year and releaseMonth < taskData.releaseDate.month and projectObj:hasFeature(taskData.id) then
			if taskData.gameQuality and taskData.gameQuality[highestContributionType] or taskData.qualityContribution == highestContributionType then
				self.highestContributors[#self.highestContributors + 1] = taskData
			elseif taskData.gameQuality and taskData.gameQuality[averageContributionType] or taskData.qualityContribution == averageContributionType then
				self.averageContributors[#self.averageContributors + 1] = taskData
			elseif taskData.gameQuality and taskData.gameQuality[lowestContributionType] or taskData.qualityContribution == lowestContributionType then
				self.unneededContributors[#self.unneededContributors + 1] = taskData
			end
		end
	end
end

interviewTopics:registerNew(newTech)

local mainFocus = {}

mainFocus.id = "main_focus_question"
mainFocus.display = _T("INTERVIEW_MAIN_FOCUS", "Interview - Main focus")
mainFocus.description = _T("INTERVIEW_MAIN_FOCUS_DESCRIPTION", "People would like to know - what aspect of the game are you focusing the most on?")
mainFocus.answerOptions = {}
mainFocus.baseScorePerAnswer = 15
mainFocus.optionsToShow = 3
mainFocus.mostRelevant = {}

function mainFocus:checkEligibility(interviewObj)
	return true
end

local answerOptions = {}

function mainFocus:onAddToInterview(interviewObj)
	local projectObject = interviewObj:getTargetProject()
	
	table.clearArray(self._answerOptions)
	self:findBiggestContributors(projectObject)
	
	for aspect, impact in pairs(self.mostRelevant) do
		local multiplier = math.max(0, (impact - 1) / (self.largestImpact - 1))
		
		self:attemptCreateOption(aspect, multiplier)
	end
	
	for i = 1, #answerOptions do
		local randomIndex = math.random(1, #answerOptions)
		
		self._answerOptions[#self._answerOptions + 1] = answerOptions[randomIndex]
		
		table.remove(answerOptions, randomIndex)
	end
	
	table.clearArray(answerOptions)
	table.clear(self.mostRelevant)
end

function mainFocus:attemptCreateOption(qualityID, scoreMultiplier)
	answerOptions[#answerOptions + 1] = {
		text = gameQuality:getData(qualityID).displayHeader,
		answerScore = self.baseScorePerAnswer * scoreMultiplier
	}
end

function mainFocus:findBiggestContributors(projectObject)
	local genreData = genres.registeredByID[projectObject:getGenre()]
	
	self.largestImpact = -math.huge
	
	for i = 1, self.optionsToShow do
		local highest = -math.huge
		local biggestContributor
		
		for aspect, impact in pairs(genreData.scoreImpact) do
			if not self.mostRelevant[aspect] and highest < impact then
				biggestContributor = aspect
				highest = impact
			end
		end
		
		self.largestImpact = math.max(self.largestImpact, highest)
		self.mostRelevant[biggestContributor] = highest
	end
end

interviewTopics:registerNew(mainFocus)

local hypeCounter = {}

hypeCounter.id = "hype_counter_question"
hypeCounter.invisible = true
hypeCounter.display = _T("INTERVIEW_HYPE_COUNTER", "Interview - Expectations")
hypeCounter.description = _T("INTERVIEW_HYPE_COUNTER_DESCRIPTION", "People are always on the lookout for great games, is there anything additional you'd like to mention in regard to the game?")
hypeCounter.answerOptions = {
	{
		answerScore = 0,
		text = _T("INTERVIEW_HYPE_COUNTER_ANSWER_1", "We don't want to make false promises")
	},
	{
		answerScore = 15,
		text = _T("INTERVIEW_HYPE_COUNTER_ANSWER_2", "It'll be a fun ride"),
		answerCallback = function(self, interviewObj, topic)
			interviewObj:increaseHypeCounter()
		end
	}
}

function hypeCounter:checkEligibility(interviewObj)
	local hypeCounter = interviewObj:getTargetProject():getHypeCounter()
	
	return not hypeCounter or hypeCounter < gameProject.MAX_HYPE_COUNTERS
end

interviewTopics:registerNew(hypeCounter)

local genreThemeMatch = {}

genreThemeMatch.id = "genre_theme_match_question"
genreThemeMatch.display = _T("INTERVIEW_SETTING", "Interview - Setting")
genreThemeMatch.description = _T("INTERVIEW_SETTING_DESCRIPTION", "You're making a THEME GENRE game, which is definitely an interesting combination. What can you tell us about it?")
genreThemeMatch.praiseAnswerText = _T("INTERVIEW_SETTING_ANSWER_1", "We think it'll be great fun")
genreThemeMatch.safeAnswerText = _T("INTERVIEW_SETTING_ANSWER_2", "We'll let the players decide")
genreThemeMatch.answerOptions = {}
genreThemeMatch.scoreOffset = -1
genreThemeMatch.scorePerMatchValue = 50

function genreThemeMatch:onAddToInterview(interviewObj)
	local projectObj = interviewObj:getTargetProject()
	
	table.clearArray(self._answerOptions)
	
	local score = (themes:getMatch(projectObj) + self.scoreOffset) * self.scorePerMatchValue
	
	table.insert(self._answerOptions, {
		text = self.praiseAnswerText,
		answerScore = score
	})
	table.insert(self._answerOptions, {
		answerScore = 0,
		text = self.safeAnswerText
	})
end

function genreThemeMatch:getDescription(interviewObj)
	local projectObj = interviewObj:getTargetProject()
	local theme, genre = themes.registeredByID[projectObj:getTheme()], genres.registeredByID[projectObj:getGenre()]
	
	return string.easyformatbykeys(self.description, "THEME", theme.display, "GENRE", genre.display)
end

interviewTopics:registerNew(genreThemeMatch)
