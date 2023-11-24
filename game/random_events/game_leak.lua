local gameLeak = {}

gameLeak.id = "game_leak"
gameLeak.eventRequirement = timeline.EVENTS.NEW_WEEK
gameLeak.rollMin = 1
gameLeak.rollMax = 2000
gameLeak.cooldownFact = "game_leak_cooldown"
gameLeak.timeCooldown = timeline.DAYS_IN_YEAR * 3
gameLeak.occurChance = 1
gameLeak.leakableGames = {}
gameLeak.LOW_SCORE_DISTANCE = 4
gameLeak.AVERAGE_SCORE_DISTANCE = 6
gameLeak.HIGH_SCORE_DISTANCE = 8
gameLeak.NO_POPULARITY_LOSS_SCORE_DISTANCE = 2
gameLeak.QUALITY_TYPE = {
	LOW = 1,
	QUALITY = 3,
	AVERAGE = 2
}
gameLeak.PLAYER_RESPONSE_TYPE = {
	ASSERT = 2,
	THANK = 3,
	REASSURE = 1
}

function gameLeak:canOccur(event)
	local foundNonPlayerCharacter = false
	
	for key, employee in ipairs(studio:getEmployees()) do
		if not employee:isPlayerCharacter() then
			foundNonPlayerCharacter = true
			
			break
		end
	end
	
	if not foundNonPlayerCharacter then
		return false
	end
	
	local lastLeak = studio:getFact(self.cooldownFact)
	
	if not lastLeak or timeline.curTime > lastLeak + gameLeak.timeCooldown then
		return true
	end
	
	return false
end

function gameLeak.employeeCriteriaCheck(employee)
	return not employee:isPlayerCharacter()
end

function gameLeak.playerCharacterCriteriaCheck(employee)
	return not employee:isPlayerCharacter()
end

function gameLeak:getValidEmployeeForDialogue()
	local validEmployee = studio:getRandomEmployeeByCriteria(gameLeak.employeeCriteriaCheck)
	
	validEmployee = validEmployee or studio:getRandomEmployeeByCriteria(gameLeak.playerCharacterCriteriaCheck)
	
	return validEmployee
end

function gameLeak:occur()
	for key, projObj in ipairs(studio:getGames()) do
		if projObj.PROJECT_TYPE == gameProject.PROJECT_TYPE and not projObj:getReleaseDate() then
			self.leakableGames[#self.leakableGames + 1] = projObj
		end
	end
	
	local teams = studio:getTeams()
	
	for key, teamObj in ipairs(teams) do
		local projObj = teamObj:getProject()
		
		if projObj and projObj.PROJECT_TYPE == gameProject.PROJECT_TYPE and projObj:getEngine() then
			self.leakableGames[#self.leakableGames + 1] = projObj
		end
	end
	
	if #self.leakableGames == 0 then
		return 
	end
	
	local randomGame = self.leakableGames[math.random(1, #self.leakableGames)]
	local qualityScore = review:getCurrentGameVerdict(randomGame)
	local overallCompletion = randomGame:getOverallCompletion()
	local distToMax = math.dist(qualityScore, review.maxRating * overallCompletion)
	local reactionText = ""
	local finalQuality
	local popularityAffector = distToMax - gameLeak.NO_POPULARITY_LOSS_SCORE_DISTANCE
	local popularityLossPercentage = popularityAffector / review.maxRating
	local actualPopularityLoss = math.max(0, popularityLossPercentage)
	local validEmployee = self:getValidEmployeeForDialogue()
	local lostPopularity = randomGame:getPopularity() * actualPopularityLoss
	
	if lostPopularity == 0 then
		return 
	end
	
	randomGame:increasePopularity(-lostPopularity)
	
	if distToMax >= gameLeak.LOW_SCORE_DISTANCE then
		reactionText = _T("GAME_LEAK_REACTION_BAD", "Judging by what people are saying about the game on the internet, the game is not good.")
		finalQuality = gameLeak.QUALITY_TYPE.LOW
	elseif distToMax <= gameLeak.AVERAGE_SCORE_DISTANCE and distToMax > gameLeak.HIGH_SCORE_DISTANCE then
		reactionText = _T("GAME_LEAK_REACTION_OK", "Judging by what people are saying about the game on the internet, the game is average. About half of the people believe that it will get better by the time it will be finished.")
		finalQuality = gameLeak.QUALITY_TYPE.AVERAGE
	elseif distToMax <= gameLeak.HIGH_SCORE_DISTANCE then
		reactionText = _T("GAME_LEAK_REACTION_GOOD", "Judging by what people are saying about the game on the internet, the game is good. There are very few people that don't like what they've played.")
		finalQuality = gameLeak.QUALITY_TYPE.HIGH
	end
	
	local dialogueObject = dialogueHandler:addDialogue("game_leak_question_start", nil, validEmployee)
	
	dialogueObject:setFact("reaction_text", reactionText)
	dialogueObject:setFact("quality_id", finalQuality)
	dialogueObject:setFact("game_project_object", randomGame)
	dialogueObject:setFact("popularity_loss", lostPopularity)
	table.clear(self.leakableGames)
	studio:setFact(self.cooldownFact, timeline.curTime)
end

randomEvents:registerNew(gameLeak)
require("game/random_events/game_leak_dialogues")
