review = {}
review.basePerformanceScoreImpact = -5
review.performanceToScore = 10
review.maxPerformanceRange = 5
review.averagePerformanceAffector = 1
review.aspectRatingVisualDisplayOffset = {
	-7,
	3
}
review.performanceScoreAffector = 0.5
review.worstFeatureLerpAmount = 0.15
review.minimumDistanceForScoreLerp = 0.15
review.scoreImpactExponent = 1.5
review.scoreDistanceForNoMaximumRating = 0.15
review.maxRating = 10
review.minRating = 1
review.minRatingOnLargeScoreDistance = review.maxRating - 1
review.validReviewers = {}
review.reviewers = {}
review.reviewTimeline = 14
review.baseDailyReviewChance = 100
review.dailyReviewChanceDecayPerDay = 1.7857142857142858
review.maxReviewsPerDay = 10
review.maxAspectScalar = 1.1
review.randomRange = -3
review.randomRangeReduction = 10
review.randomRangeSegment = 0.2
review.playerbaseSuspicionReviewRatingDiscrepancy = 1.25
review.reputationDecreasePerSale = 0.1
review.extraRepLossPerReputationPoints = 0.0004
review.opinionLossPerSale = 0.0001
review.opinionLossCap = -100
review.reputationIncreasePerSale = 0.01
review.suspicionTimePeriod = timeline.DAYS_IN_MONTH * 2
review.lowPerformanceRemark = 0.4
review.highPerformanceRemark = 0.8
review.basePopularityGain = 5
review.popularityGainScoreExponent = 2
review.popGainScaleDependency = 0.45
review.standardLerp = 0.6
review.maxStandardFeatureQualityOffset = 4
review.maxStandardQualityOffset = 10
review.maxStandardQualityOffsetDec = -20
review.standardLevelFact = "review_standard"
review.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_YEAR
}

function review:init()
	self.interviewCooldown = 0
	
	table.clearArray(self.validReviewers)
	table.clearArray(self.reviewers)
	self:initHighestQualityPoints()
	self:createReviewers()
	events:addDirectReceiver(self, review.CATCHABLE_EVENTS)
end

local function sortAscending(a, b)
	return a < b
end

function review:setInterviewCooldown(cooldown)
	self.interviewCooldown = timeline.curTime + cooldown
end

function review:getInterviewCooldown()
	return self.interviewCooldown
end

function review:buildStandardsByYear()
	local numericYearTable = {}
	
	for year, state in pairs(taskTypes.yearsWithTech) do
		table.insert(numericYearTable, year)
	end
	
	table.sort(numericYearTable, sortAscending)
	
	local evaluatedOCTasks = {}
	
	self.standardsByYear = {}
	self.currentYearStandard = 1
	
	for key, year in ipairs(numericYearTable) do
		self:createYearStandard(year, evaluatedOCTasks)
	end
	
	self:createYearStandard(numericYearTable[#numericYearTable] + 1, evaluatedOCTasks)
end

local seenEngineTasks = {}

function review:createYearStandard(year, evaluatedOCTasks)
	self.standardsByYear[#self.standardsByYear + 1] = {
		engineTaskCount = 0,
		year = year,
		levels = {},
		workAmounts = {}
	}
	
	local yearTable = self.standardsByYear[#self.standardsByYear]
	
	for key, devType in ipairs(gameProject.DEVELOPMENT_TYPE_ORDER) do
		local totalWork = 0
		
		yearTable.levels[devType] = {
			standard = {},
			features = {}
		}
		yearTable.workAmounts[devType] = 0
		
		local levelTable = yearTable.levels[devType]
		local standardTable = levelTable.standard
		local featureTable = levelTable.features
		
		for key, data in ipairs(gameQuality.registered) do
			standardTable[data.id] = 0
		end
		
		for key, data in ipairs(taskTypes.registered) do
			if not data.developmentType or data.developmentType[devType] then
				local taskData = self:_evaluateTask(data, year, evaluatedOCTasks)
				
				if taskData and (taskData.totalQuality > 0 or data.knowledgeContribution or data.directKnowledgeContribution) then
					local qualityIncrease = taskData:getGameQualityPointIncrease(nil, timeline:yearToTime(year))
					
					for qualityID, amount in pairs(qualityIncrease) do
						standardTable[qualityID] = standardTable[qualityID] + amount * taskData.standardQualityMultiplier
					end
					
					table.insert(featureTable, taskData)
					
					if data.taskID == "game_task" then
						if not data.IMPLEMENTATION_TASK then
							totalWork = totalWork + taskData.totalWork
						end
					elseif data.taskID == "engine_task" and not seenEngineTasks[data.id] then
						yearTable.engineTaskCount = yearTable.engineTaskCount + 1
						seenEngineTasks[data.id] = true
					end
				end
			end
		end
		
		yearTable.workAmounts[devType] = totalWork
		
		table.clear(evaluatedOCTasks)
	end
	
	table.clear(seenEngineTasks)
end

function review:_evaluateTask(data, currentYear, evaluatedOCTasks)
	if data.invisible then
		return nil
	end
	
	if data.releaseDate then
		if data.optionCategory then
			if not evaluatedOCTasks[data.optionCategory] then
				local bestTask = self:_evaluateOptionCategory(taskTypes.registeredByOptionCategory[data.optionCategory], currentYear)
				
				if bestTask then
					evaluatedOCTasks[bestTask.optionCategory] = true
					
					return bestTask
				else
					return nil
				end
			else
				return nil
			end
		elseif currentYear > data.releaseDate.year then
			return data
		end
	elseif data.optionCategory then
		if not evaluatedOCTasks[data.optionCategory] then
			local bestTask = self:_evaluateOptionCategory(taskTypes.registeredByOptionCategory[data.optionCategory], currentYear)
			
			if bestTask then
				evaluatedOCTasks[bestTask.optionCategory] = true
				
				return bestTask
			else
				return nil
			end
		else
			return nil
		end
	else
		return data
	end
end

function review:_evaluateOptionCategory(categoryTasks, currentYear)
	local mostValid, mostRecent, highestScore = nil, 0, 0
	local releaseDateBased = false
	
	for key, otherData in ipairs(categoryTasks) do
		local releaseDate = otherData.releaseDate
		
		if releaseDate then
			if currentYear > releaseDate.year and mostRecent < releaseDate.year then
				releaseDateBased = true
				
				if highestScore < otherData.totalQuality then
					mostValid = otherData
					mostRecent = releaseDate.year
					highestScore = otherData.totalQuality
				end
			end
		elseif highestScore < otherData.totalQuality then
			mostValid = otherData
			highestScore = otherData.totalQuality
		end
	end
	
	if not mostValid and not releaseDateBased then
		mostValid = categoryTasks[1]
	end
	
	return mostValid
end

function review:attemptAdvanceYearStandard()
	local nextStandard = self.standardsByYear[self.currentYearStandard + 1]
	
	if nextStandard and timeline:getYear() >= nextStandard.year then
		self:setYearStandard(self.currentYearStandard + 1)
	end
end

function review:setYearStandard(index)
	self.currentYearStandard = index
	self.currentYearStandardTable = self.standardsByYear[self.currentYearStandard]
	self.currentStandardTable = self.standardsByYear[self.currentYearStandard].levels
end

function review:getCurrentStandardTable(gameType)
	return self.currentStandardTable[gameType]
end

function review:getCurrentYearStandard()
	return self.currentYearStandardTable
end

function review:findLatestStandardByYear(year)
	local currentYear = timeline:getYear()
	
	self:setYearStandard(self:getLatestStandardByYear(currentYear or year))
end

function review:getLatestStandardByYear(year)
	local latest = 1
	
	for key, standardData in ipairs(self.standardsByYear) do
		if year >= standardData.year and latest < key then
			latest = key
		end
	end
	
	return latest, self.standardsByYear[latest]
end

function review:initHighestQualityPoints()
	self.highestQualityPoints = table.reuse(self.highestQualityPoints)
	self.currentStandard = 0
	self.standards = table.reuse(self.standards)
	
	for key, qualityData in ipairs(gameQuality.registered) do
		self.highestQualityPoints[qualityData.id] = 0
	end
	
	self:createEmptyStandard()
end

function review:createReviewers()
	for key, reviewerData in ipairs(reviewers.registered) do
		local newReviewer = reviewer.new(reviewerData)
		
		table.insert(self.reviewers, newReviewer)
	end
end

function review:remove()
	self.interviewCooldown = 0
	
	self:removeReviewers()
	events:removeDirectReceiver(self, review.CATCHABLE_EVENTS)
end

function review:removeReviewers()
	for key, reviewer in ipairs(self.reviewers) do
		reviewer:remove()
		
		self.reviewers[key] = nil
	end
end

function review:getReviewers()
	return self.reviewers
end

function review:getReviewer(id)
	for key, reviewerObj in ipairs(self.reviewers) do
		if reviewerObj:getID() == id then
			return reviewerObj
		end
	end
end

function review:handleEvent(event)
	if event == timeline.EVENTS.NEW_DAY then
		local time = timeline.curTime
		local releasedGames = studio:getReleasedGames()
		local iteration = #releasedGames
		local totalReviews = 0
		
		while true do
			local gameObj = releasedGames[iteration]
			
			if gameObj then
				local releaseDate = gameObj:getReleaseDate()
				local delta = time - releaseDate
				
				if delta < review.reviewTimeline then
					local reviewers = self:getValidReviewers(gameObj)
					local reviewerCount = #reviewers
					
					if reviewerCount > 0 then
						local validReviewer = reviewers[math.random(1, reviewerCount)]
						
						self:createReview(gameObj, validReviewer)
						
						totalReviews = totalReviews + 1
						
						if totalReviews >= review.maxReviewsPerDay then
							break
						end
					end
				else
					break
				end
			else
				break
			end
			
			iteration = iteration - 1
		end
	elseif event == timeline.EVENTS.NEW_WEEK then
		local releasedGames = studio:getReleasedGames()
		local iteration = #releasedGames
		local time = timeline.curTime
		local reputationAffector = 1 + studio:getReputation() * review.extraRepLossPerReputationPoints
		local suspicionTimePeriod, ratingDiscrepancy, repDecreasePerSale = review.suspicionTimePeriod, review.playerbaseSuspicionReviewRatingDiscrepancy, review.reputationDecreasePerSale
		
		while true do
			local gameObj = releasedGames[iteration]
			
			if gameObj and time < gameObj:getReleaseDate() + suspicionTimePeriod then
				local delta = gameObj:getReviewRating() - gameObj:getRealRating()
				local sales = gameObj:getLastSales()
				
				if ratingDiscrepancy < delta then
					local lostRep = sales * repDecreasePerSale * reputationAffector
					
					if lostRep > 0 then
						studio:decreaseReputation(lostRep)
						studio:changeOpinion(math.max(review.opinionLossCap, -sales * review.opinionLossPerSale))
						
						if not gameObj:getFact(gameProject.NOTIFIED_OF_REVIEW_REP_DROP) then
							local popup = gui.create("DescboxPopup")
							
							popup:setFont("pix24")
							popup:setWidth(600)
							popup:setTitle(_T("PLAYERS_SUSPICIOUS_OF_REVIEWS_TITLE", "Players Suspicious of Reviews"))
							popup:setTextFont("pix20")
							popup:setText(_format(_T("PLAYERS_SUSPICIOUS_OF_REVIEWS_DESC", "The people who've bought 'GAME' are highly suspicious of the reviews it got. They think the game is not as good as the reviewers say it is."), "GAME", gameObj:getName()))
							
							local left, right, extra = popup:getDescboxes()
							local lineWidth = popup.w - _S(20)
							
							extra:addTextLine(lineWidth, game.UI_COLORS.UI_PENALTY_LINE)
							extra:addText(_format(_T("PLAYERS_SUSPICIOUS_OF_REVIEWS_LOST_REP", "This has cost you REPLOSS reputation points."), "REPLOSS", string.comma(lostRep)), "bh20", game.UI_COLORS.RED, 4, popup.rawW - 20, "exclamation_point_red", 22, 22)
							extra:addTextLine(lineWidth, game.UI_COLORS.UI_PENALTY_LINE)
							extra:addText(_T("BRIBE_TOO_MANY_HINT", "Bribing too many reviewers can lead to great reputation loss."), "bh18", game.UI_COLORS.RED, 0, popup.rawW - 20, "question_mark_red", 22, 22)
							popup:addOKButton("pix20")
							popup:center()
							frameController:push(popup)
							gameObj:setFact(gameProject.NOTIFIED_OF_REVIEW_REP_DROP, true)
						end
					end
				end
				
				iteration = iteration - 1
			else
				break
			end
		end
	elseif event == timeline.EVENTS.NEW_YEAR then
		self:attemptAdvanceYearStandard()
	end
end

function review:setupRealReviewStandard(gameObj)
	gameObj:setRealReviewStandard(self:calculateRealReviewStandard(gameObj))
end

function review:validateRealReviewStandard(gameObj)
	if not gameObj:getRealReviewStandard() then
		gameObj:setRealReviewStandard(self:calculateRealReviewStandard(gameObj))
	end
end

review._featuresByQuality = {}

function review:calculateRealReviewStandard(gameObj)
	self.knowledgeQualityTimeAffector = taskTypes:getQualityFromKnowledgeTimeAffector()
	
	local year = timeline:getYear(gameObj:getReleaseDate())
	local yearTime = timeline:yearToTime(year)
	local standardKey, standardTable = self:getLatestStandardByYear(timeline:getYear(gameObj:getReleaseDate()))
	local gameType = gameObj:getGameType()
	local standardByGameType = standardTable.levels[gameType]
	local adaptiveStandard = self.standards[gameObj:getFact(review.standardLevelFact) or #self.standards]
	local realStandard = {}
	local genre, theme = gameObj:getGenre(), gameObj:getTheme()
	local isExpansionPack = not gameObj:isNewGame()
	
	for key, data in ipairs(gameQuality.registered) do
		realStandard[data.id] = 0
		
		if isExpansionPack then
			review._featuresByQuality[data.id] = 0
		end
	end
	
	local evaluatedOCTasks = {}
	local adaptiveStandardFeatures = adaptiveStandard.features
	local engineObj = gameObj:getEngine()
	local ourDevType = gameObj:getDevelopmentType()
	
	for key, featureData in ipairs(standardByGameType.features) do
		local wasAdded = false
		local gameHasFeature, engineHasFeature = gameObj:hasFeature(featureData.id), engineObj:hasFeature(featureData.id)
		
		if (gameHasFeature or engineHasFeature) and featureData.category then
			wasAdded = true
		end
		
		local optional = featureData:isOptionalForStandard()
		local canContinue = false
		
		if not optional then
			canContinue = true
		elseif gameHasFeature or engineHasFeature then
			canContinue = true
		elseif featureData.optionCategory then
			for key, taskData in ipairs(taskTypes.registeredByOptionCategory[featureData.optionCategory]) do
				if gameObj:hasFeature(taskData.id) or engineObj:hasFeature(taskData.id) then
					canContinue = true
					
					break
				end
			end
		end
		
		if canContinue then
			local canContinue = true
			local adaptiveStandardLevel = adaptiveStandardFeatures[featureData.id]
			local qualityIncrease = featureData:getGameQualityPointIncrease(gameObj, yearTime)
			
			for qualityID, amount in pairs(qualityIncrease) do
				local realAmount = amount * featureData.standardQualityMultiplier
				
				if adaptiveStandardLevel then
					local adaptiveLevel = adaptiveStandardLevel[qualityID]
					
					if adaptiveLevel then
						realAmount = math.max(adaptiveLevel, realAmount)
					end
				end
				
				realStandard[qualityID] = realStandard[qualityID] + realAmount
				
				if isExpansionPack then
					review._featuresByQuality[qualityID] = review._featuresByQuality[qualityID] + 1
				end
			end
			
			if featureData.knowledgeContribution then
				self:_addQualityFromKnowledgeToStandard(realStandard, featureData, genre, theme)
			end
		end
	end
	
	if isExpansionPack then
		for key, data in ipairs(gameQuality.registered) do
			if review._featuresByQuality[data.id] == 0 then
				realStandard[data.id] = 0
			end
			
			review._featuresByQuality[data.id] = 0
		end
	end
	
	gameObj:setupWorkAmountFeatureSaleAffector(standardTable.workAmounts[gameType])
	gameObj:setupFeatureCountSaleAffector(standardTable.engineTaskCount)
	
	self.knowledgeQualityTimeAffector = nil
	
	return realStandard
end

function review:_addQualityFromKnowledgeToStandard(standardList, featureData, genre, theme)
	if timeline:getYear() < taskTypes.KNOWLEDGE_MANDATORY_START then
		return 
	end
	
	local subList = featureData.knowledgeContribution[genre]
	
	if subList then
		local contribList = subList[theme]
		
		if contribList then
			local qualContrib = featureData.qualityContribution
			
			for key, data in ipairs(contribList) do
				standardList[qualContrib] = standardList[qualContrib] + taskTypes:getDesiredQualityFromKnowledge(featureData, data.amount) * self.knowledgeQualityTimeAffector
			end
		end
	end
end

function review:createReview(gameObj, reviewerObj)
	gameObj:verifyReviewStandard()
	
	local reviewObj = projectReview.new(reviewerObj)
	local rating = self:getIndividualGameVerdict(gameObj, reviewerObj)
	
	reviewObj:setRating(rating)
	
	local popGain = (rating * review.basePopularityGain)^review.popularityGainScoreExponent
	local realPopGain = popGain * (1 - review.popGainScaleDependency) + popGain * (gameObj:getScale() / platformShare:getMaxGameScale()) * review.popGainScaleDependency
	
	realPopGain = realPopGain + realPopGain * reviewerObj:getData().popularity
	
	gameObj:increasePopularity(realPopGain)
	reviewObj:setProject(gameObj)
	gameObj:addReview(reviewObj, reviewerObj)
end

function review:setReviewStandard(gameProj)
	if not gameProj:getFact(review.standardLevelFact) then
		gameProj:setFact(review.standardLevelFact, self.currentStandard)
		
		return true
	end
	
	return false
end

function review:evaluateGameStandard(gameObj)
	local wasHigherLevel = self:logHighestQualityPoints(gameObj)
	
	if wasHigherLevel then
		self:createNewStandard(gameObj)
		
		if gameObj:getOwner():isPlayer() then
			achievements:attemptSetAchievement(achievements.ENUM.NEW_STANDARD)
		end
	else
		self:adjustExistingStandard(gameObj)
	end
end

function review:createEmptyStandard()
	self.currentStandard = self.currentStandard + 1
	self.standards[self.currentStandard] = self:createAdaptiveStandardTable()
	
	local standard = self.standards[self.currentStandard]
	
	for key, qualityData in ipairs(gameQuality.registered) do
		standard.quality[qualityData.id] = 0
	end
end

function review:createAdaptiveStandardTable()
	return {
		quality = {},
		features = {}
	}
end

review.newFeatQualTable = {}

function review:adjustExistingStandard(gameObj)
	local standards = self.standards
	local prevStandard = self.currentStandard - 1
	local prevStandardTable = standards[prevStandard]
	local prevQuality = prevStandardTable and prevStandardTable.quality
	local curStandard = standards[self.currentStandard]
	local curQuality = curStandard.quality
	local realStandard = gameObj.realReviewStandard
	local gameScale = gameObj:getScale()
	local maxQualityOffDec = review.maxStandardQualityOffsetDec
	
	for qualityID, level in pairs(self.highestQualityPoints) do
		local baseQuality = realStandard[qualityID]
		local curLevel = curQuality[qualityID]
		local startingPoint
		
		if prevQuality then
			startingPoint = math.max(baseQuality, prevQuality[qualityID])
		else
			startingPoint = baseQuality
		end
		
		if curLevel then
			curQuality[qualityID] = math.max(baseQuality, curLevel - math.min(math.dist(level, curLevel), -maxQualityOffDec * gameScale))
		else
			curQuality[qualityID] = startingPoint
		end
	end
	
	local featureList = curStandard.features
	local qualityByTasks = gameObj:getQualityByTasks()
	local taskData = task:getData("game_task")
	local scaleScoreMult = taskData:getProjectScaleScoreMultiplier(gameObj)
	local scale = gameObj:getScale()
	local maxOff = self.maxStandardFeatureQualityOffset
	local newFeatQualTable = self.newFeatQualTable
	
	for featureID, value in pairs(gameObj:getFeatures()) do
		featureList[featureID] = featureList[featureID] or {}
		
		local featureQualityLevels = featureList[featureID]
		
		for qualityID, amount in pairs(qualityByTasks[featureID].employee) do
			newFeatQualTable[qualityID] = (newFeatQualTable[qualityID] or 0) + amount / scale
		end
		
		for qualityID, amount in pairs(qualityByTasks[featureID].feature) do
			newFeatQualTable[qualityID] = (newFeatQualTable[qualityID] or 0) + amount / scaleScoreMult
		end
		
		for qual, amt in pairs(newFeatQualTable) do
			local cur = featureQualityLevels[qual]
			
			if cur then
				local delta = amt - cur
				
				if delta > 0 then
					featureQualityLevels[qual] = featureQualityLevels[qual] + math.min(delta, maxOff)
				else
					featureQualityLevels[qual] = math.max(0, featureQualityLevels[qual] - math.min(-delta, maxOff))
				end
			else
				featureQualityLevels[qual] = amt
			end
			
			newFeatQualTable[qual] = nil
		end
	end
end

function review:createNewStandard(gameObj)
	self.currentStandard = self.currentStandard + 1
	self.standards[self.currentStandard] = self:createAdaptiveStandardTable()
	
	local prevStandard = self.currentStandard - 1
	local prevStandardTable = self.standards[prevStandard]
	local prevQuality = prevStandardTable.quality
	local newStandard = self.standards[self.currentStandard]
	local standardQuality = newStandard.quality
	local gameScale = gameObj:getScale()
	local realStandard = gameObj.realReviewStandard
	local standardLerp, maxQualityOff, maxQualityOffDec = review.standardLerp, review.maxStandardQualityOffset, review.maxStandardQualityOffsetDec
	
	for qualityID, level in pairs(self.highestQualityPoints) do
		local baseQuality = realStandard[qualityID]
		
		if baseQuality < level then
			local startingPoint
			
			if prevStandardTable then
				startingPoint = math.max(baseQuality, prevQuality[qualityID])
			else
				startingPoint = baseQuality
			end
			
			local maxOffset
			
			standardQuality[qualityID] = math.max(baseQuality, startingPoint + math.min(math.lerp(startingPoint, level, standardLerp) - startingPoint, maxQualityOff * gameScale))
			
			local newStandard = standardQuality[qualityID]
			
			if startingPoint < newStandard then
				gameObj:logNewStandard(qualityID, newStandard)
			end
		else
			standardQuality[qualityID] = level
		end
	end
	
	local featureList = newStandard.features
	local qualityByTasks = gameObj:getQualityByTasks()
	local taskData = task:getData("game_task")
	local scaleScoreMult = taskData:getProjectScaleScoreMultiplier(gameObj)
	local scale = gameObj:getScale()
	
	for featureID, value in pairs(gameObj:getFeatures()) do
		featureList[featureID] = {}
		
		local featureQualityLevels = featureList[featureID]
		
		for qualityID, amount in pairs(qualityByTasks[featureID].employee) do
			featureQualityLevels[qualityID] = (featureQualityLevels[qualityID] or 0) + amount / scale
		end
		
		for qualityID, amount in pairs(qualityByTasks[featureID].feature) do
			featureQualityLevels[qualityID] = (featureQualityLevels[qualityID] or 0) + amount / scaleScoreMult
		end
	end
end

function review:logHighestQualityPoints(gameProj)
	local wasHigher = false
	local scale = gameProj:getScale()
	local taskData = task:getData("game_task")
	local scaleScoreMult = taskData:getProjectScaleScoreMultiplier(gameProj)
	local qualityPoints = gameProj:getQualityPoints()
	local realReviewStandard = gameProj.realReviewStandard
	
	for key, data in ipairs(gameQuality.registered) do
		local qualityID = data.id
		local level = qualityPoints[qualityID]
		local employeeContrib = gameProj:getEmployeeQualityContribution(qualityID) or 0
		local featureContrib = gameProj:getFeatureQualityContribution(qualityID) or 0
		
		level = level - (employeeContrib - employeeContrib / scale) - (featureContrib - featureContrib / scaleScoreMult)
		
		if level > self.highestQualityPoints[qualityID] then
			self.highestQualityPoints[qualityID] = level
			
			if level > realReviewStandard[qualityID] then
				wasHigher = true
			end
		end
	end
	
	return wasHigher
end

function review:getValidReviewers(gameObj)
	table.clearArray(self.validReviewers)
	
	for key, reviewerObj in ipairs(self.reviewers) do
		if not gameObj:getReviewerScore(reviewerObj) then
			self.validReviewers[#self.validReviewers + 1] = reviewerObj
		end
	end
	
	return self.validReviewers
end

function review:getPerformanceScoreImpact(gameProj)
	local engine = gameProj:getEngine()
	local affector = review.basePerformanceScoreImpact + math.round(engine:getStat("performance") * 100 / review.performanceToScore)
	
	if affector < 0 then
		return math.lerp(review.averagePerformanceAffector, review.performanceScoreAffector, affector / review.maxPerformanceRange)
	end
	
	return review.averagePerformanceAffector
end

function review:getIndividualGameVerdict(gameProj, reviewerObj, issueAffectorMultiplier)
	local score, distance, lowerThanDesired = self:calculateScore(gameProj, reviewerObj, issueAffectorMultiplier)
	
	return self:calculateIndividualRating(self:calculateRating(score, gameProj, reviewerObj), distance, lowerThanDesired)
end

function review:getCurrentGameVerdict(gameProj, issueAffectorMultiplier)
	if not gameProj:getRealReviewStandard() then
		local requiresFactRemoval = self:setReviewStandard(gameProj)
		
		self:setupRealReviewStandard(gameProj)
		
		local gameRating = self:getGameVerdict(gameProj, true, issueAffectorMultiplier)
		
		if not gameProj:getReleaseDate() then
			gameProj:setRealReviewStandard(nil)
		end
		
		if requiresFactRemoval then
			gameProj:setFact(review.standardLevelFact, nil)
		end
		
		return gameRating
	else
		return self:getGameVerdict(gameProj, true, issueAffectorMultiplier)
	end
end

function review:getGameVerdict(gameProj, noRounding, issueAffectorMultiplier)
	local score = self:calculateScore(gameProj, nil, issueAffectorMultiplier)
	local rating = self:calculateRating(score, gameProj)
	
	if noRounding then
		return math.min(math.max(rating, review.minRating), review.maxRating), score
	end
	
	return math.round(rating, 1), score
end

function review:getFinalDesiredQualityLevel(qualityID, standardID, gameObj)
	standardID = standardID or #self.standards
	
	local standardLevel
	
	if gameObj and gameObj.realReviewStandard then
		standardLevel = gameObj.realReviewStandard[qualityID] or self.currentStandardTable[gameObj.curDevType][qualityID]
	else
		standardLevel = math.max(self.standards[standardID].quality[qualityID] or 0, self.currentStandardTable[gameObj.curDevType][qualityID])
	end
	
	return standardLevel * gameObj:getScale()
end

function review:getMaxQualityScore(genre, qualityID)
	return review.maxAspectScalar * genres.registeredByID[genre].scoreImpact[qualityID]
end

function review:getQualityScore(qualityID, gameProj)
	local scoreImpactor = genres.registeredByID[gameProj.genre].scoreImpact[qualityID]
	local qualityLevel = gameProj:getQuality(qualityID)
	local approachedDesiredQuality = self:getFinalDesiredQualityLevel(qualityID, gameProj:getFact(review.standardLevelFact), gameProj)
	
	return math.min(self:getMaxQualityScore(gameProj.genre, qualityID), qualityLevel / approachedDesiredQuality * scoreImpactor), approachedDesiredQuality, scoreImpactor
end

function review:getProjectQualityScoreAffector(gameProj)
	return self:_getProjectQualityScores(gameProj)
end

function review:getProjectQualityScores(output, gameProj)
	return self:_getProjectQualityScores(gameProj, output)
end

function review:_getProjectQualityScores(gameProj, tableToFill)
	local totalScore = 0
	local lowestScore, highestScore, lowestID = math.huge, -math.huge
	local genreData = genres.registeredByID[gameProj.genre]
	local scoreImpact = genreData.scoreImpact
	local totalDivider = 0
	local lowerThanDesired = false
	local largestDistance = -math.huge
	local points = gameProj:getQualityPoints()
	
	for key, data in ipairs(gameQuality.registered) do
		local qualityID = data.id
		local level = points[qualityID]
		
		if level then
			local calculatedScore, approachedDesiredQuality, targetScore = self:getQualityScore(qualityID, gameProj)
			local distance = 1 - calculatedScore / targetScore
			
			largestDistance = math.max(distance, largestDistance)
			
			if approachedDesiredQuality > 0 then
				totalDivider = totalDivider + scoreImpact[qualityID]
				totalScore = totalScore + calculatedScore
				
				if calculatedScore < lowestScore then
					lowestScore = calculatedScore
					lowestID = qualityID
				end
				
				if calculatedScore < targetScore then
					lowerThanDesired = true
				end
				
				highestScore = math.max(highestScore, calculatedScore)
				
				if tableToFill then
					tableToFill[qualityID] = calculatedScore
				end
			end
		end
	end
	
	totalScore = totalScore / totalDivider
	
	if highestScore - lowestScore > review.minimumDistanceForScoreLerp then
		local impact = genres.registeredByID[gameProj:getGenre()].scoreImpact[lowestID]
		
		totalScore = math.lerp(totalScore, lowestScore, review.worstFeatureLerpAmount * impact^(impact > 1 and review.scoreImpactExponent or 1))
	end
	
	if not tableToFill then
		return totalScore, lowestScore, highestScore, lowerThanDesired, largestDistance
	end
	
	return tableToFill, totalScore, lowestScore, highestScore, lowerThanDesired, largestDistance
end

function review:getThoroughReviewInfo(gameProj)
	local totalScore = 0
	local rawQualityScores, requiredQualityLevels = {}, {}
	
	for qualityID, level in pairs(gameProj:getQualityPoints()) do
		local calculatedScore, requiredAspectQuality = self:getQualityScore(qualityID, gameProj)
		
		if requiredAspectQuality > 0 then
			totalScore = totalScore + calculatedScore
			rawQualityScores[qualityID] = calculatedScore
			requiredQualityLevels[qualityID] = requiredAspectQuality
		end
	end
	
	return rawQualityScores, requiredQualityLevels, totalScore
end

function review:getIssueScoreAffector(gameProj)
	local totalAffector = 1
	local unfixedIssues, undiscoveredIssues = gameProj:getIssueCount()
	local opinionLoss = 0
	
	for key, issueData in ipairs(issues.registered) do
		local totalIssues = unfixedIssues[issueData.id]
		local totalIssues = totalIssues + math.round(undiscoveredIssues[issueData.id] * (issueData.discoverChance / 100))
		
		if totalIssues > 0 then
			totalAffector = totalAffector + math.max((totalIssues * issueData.scoreImpact)^issueData.scoreImpactExponent, issueData.scoreImpact)
			opinionLoss = opinionLoss + totalIssues * issueData.opinionLoss
		end
	end
	
	return totalAffector, opinionLoss
end

function review:calculateScore(gameProj, reviewerObj, issueAffectorMultiplier)
	local curScore = 0
	
	issueAffectorMultiplier = issueAffectorMultiplier or 1
	
	local totalScore, lowestQuality, highestQuality, lowerThanDesired, largestDistance = self:getProjectQualityScoreAffector(gameProj)
	
	curScore = curScore + totalScore
	curScore = curScore / math.max(1, self:getIssueScoreAffector(gameProj) * issueAffectorMultiplier)
	curScore = curScore * self:getPerformanceScoreImpact(gameProj)
	
	local features = gameProj:getFeatures()
	
	for featureID, state in pairs(features) do
		if state then
			local data = taskTypes.registeredByID[featureID]
			
			if data then
				curScore = data:adjustReviewScore(gameProj, curScore)
			end
		end
	end
	
	local engineFeatures = gameProj:getEngineRevisionFeatures() or self.engine:getRevisionFeatures(self.engineRevision)
	local expansion = gameProj:getGameType() == gameProject.DEVELOPMENT_TYPE.EXPANSION
	
	if expansion then
		local baseFeatures = gameProj:getSequelTo():getFeatures()
		
		for key, featureData in ipairs(taskTypes.registeredAbsenceCheck) do
			if featureData:canPenalizeForAbsense(gameProj) then
				local id = featureData.id
				
				if not features[id] and not baseFeatures[id] and not engineFeatures[id] then
					curScore = featureData:absenseScoreAdjust(gameProj, curScore)
				end
			end
		end
	else
		for key, featureData in ipairs(taskTypes.registeredAbsenceCheck) do
			if featureData:canPenalizeForAbsense(gameProj) then
				local id = featureData.id
				
				if not features[id] and not engineFeatures[id] then
					curScore = featureData:absenseScoreAdjust(gameProj, curScore)
				end
			end
		end
	end
	
	curScore = curScore + themes:getData(gameProj:getTheme()).reviewAffector[gameProj:getGenre()]
	
	if reviewerObj then
		curScore = reviewerObj:calculateScore(curScore, gameProj)
	end
	
	curScore = math.min(curScore, review.maxRating)
	
	return curScore, largestDistance, lowerThanDesired
end

function review:calculateIndividualRating(rating, bestWorstDistance, lowerThanDesired)
	local randomRange = math.min(0, self.randomRange * math.max(0, 1 - rating / self.randomRangeReduction))
	local randomRangeSegment = self.randomRangeSegment
	local rolledValue = math.ceil(math.randomf(0, randomRange + math.max(0, rating - self.maxRating)) / randomRangeSegment) * randomRangeSegment
	local final = math.round(math.min(math.max(rating + rolledValue, self.minRating), self.maxRating), 1)
	
	if bestWorstDistance >= self.scoreDistanceForNoMaximumRating and lowerThanDesired then
		final = math.min(final, self.minRatingOnLargeScoreDistance)
	end
	
	return final
end

function review:calculateRating(score, gameObj, reviewerObj)
	if reviewerObj then
		score = reviewerObj:calculateRating(score, gameObj)
	end
	
	return score * review.maxRating
end

function review:save()
	local saved = {}
	
	saved.currentStandard = self.currentStandard
	saved.standards = self.standards
	saved.highestQualityPoints = self.highestQualityPoints
	saved.reviewers = {}
	saved.interviewCooldown = self.interviewCooldown
	
	for key, reviewerObj in ipairs(self.reviewers) do
		table.insert(saved.reviewers, reviewerObj:save())
	end
	
	return saved
end

function review:load(data)
	self:init()
	
	self.highestQualityPoints = data.highestQualityPoints or self.highestQualityPoints
	self.standards = data.standards or self.standards
	self.currentStandard = data.currentStandard
	self.interviewCooldown = data.interviewCooldown or 0
	
	for key, qualityData in ipairs(gameQuality.registered) do
		self.highestQualityPoints[qualityData.id] = self.highestQualityPoints[qualityData.id] or 0
		
		for standardID, standardData in ipairs(self.standards) do
			standardData[qualityData.id] = standardData[qualityData.id] or 0
		end
	end
	
	for key, reviewerData in ipairs(data.reviewers) do
		local reviewerObj = self:getReviewer(reviewerData.id)
		
		reviewerObj:load(reviewerData)
	end
end

function review:postLoad(data)
	for key, reviewerObj in ipairs(self.reviewers) do
		reviewerObj:postLoad()
	end
end

require("game/review/reviewer")
require("game/review/reviewers")
require("game/review/project_review")
