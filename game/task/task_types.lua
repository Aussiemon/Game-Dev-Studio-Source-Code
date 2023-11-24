taskTypes = {}
taskTypes.registered = {}
taskTypes.registeredAbsenceCheck = {}
taskTypes.registeredAbsenseScoreAdjust = {}
taskTypes.registeredByID = {}
taskTypes.registeredByCategory = {}
taskTypes.registeredByTaskID = {}
taskTypes.registeredByFactRequirement = {}
taskTypes.registeredByOptionCategory = {}
taskTypes.registeredBySkill = {}
taskTypes.yearsWithTech = {}
taskTypes.categoriesByQuality = {}
taskTypes.lastUnlockedFeatures = {}
taskTypes.lastFeatureTime = {
	year = 0,
	month = 0
}
taskTypes.taskTypeRegistration = {}
taskTypes.implementationLink = {}
taskTypes.WORK_AMOUNT_MULTIPLIER = 1
taskTypes.OVERRIDE_UNLOCKS = false
taskTypes.BASE_RELEASE_TEXT = _T("FEATURE_RELEASED", "'FEATURE' is now available.")
taskTypes.STANDARD_CALCULATION_MULTIPLIER = 1.2
taskTypes.DEFAULT_QUALITY_FOR_STANDARD_MULTIPLIER = 1
taskTypes.DEFAULT_OPTIONAL_FOR_STANDARD = true
taskTypes.KNOWLEDGE_TO_EXTRA_QUALITY = 0.3
taskTypes.DEFAULT_MMO_CONTENT = 10
taskTypes.MANDATORY_MMO_CONTENT = 3
taskTypes.MMO_COMPLEXITY_MULTIPLIER = 0.8
taskTypes.INVISIBLE_RESEARCHABLE_CATEGORY = "invisible_research"
taskTypes.KNOWLEDGE_MANDATORY_START = 1993
taskTypes.KNOWLEDGE_MANDATORY_FINISH = 2006

local defaultTaskTypeFuncs = {}

defaultTaskTypeFuncs.mtindex = {
	__index = defaultTaskTypeFuncs
}
defaultTaskTypeFuncs.RECENT_RELEASE_DATE_TIME_PERIOD = timeline.DAYS_IN_MONTH * 6
defaultTaskTypeFuncs.cost = nil

function defaultTaskTypeFuncs:applyKnowledgeContribution(projectObj, teamKnowledge, qualityID)
	local contribution = teamKnowledge[self.directKnowledgeContribution.knowledge] * self.directKnowledgeContribution.multiplier
	
	projectObj:addKnowledgeQuality(qualityID, self.directKnowledgeContribution.knowledge, contribution)
	
	return contribution
end

function defaultTaskTypeFuncs:verifyLogicPiece(gameProj)
end

function defaultTaskTypeFuncs:applyGenreThemeKnowledgeBoost(projectObject, contributors, teamKnowledge, qualityID)
	local contrib = 0
	
	for key, data in ipairs(contributors) do
		local contribution = teamKnowledge[data.id] * data.amount
		
		contrib = contrib + contribution
		
		projectObject:addKnowledgeQuality(qualityID, data.id, contribution)
	end
	
	return contrib
end

function defaultTaskTypeFuncs:getSpecializationBoost()
	return self.specBoost
end

function defaultTaskTypeFuncs:isOptionalForStandard()
	return self.optionalForStandard
end

function defaultTaskTypeFuncs:getContributingKnowledge(projectObject, contributionList)
	local theme, genre = projectObject.theme, projectObject.genre
	
	if self.knowledgeContribution and self.knowledgeContribution[genre] and self.knowledgeContribution[genre][theme] then
		for key, data in ipairs(self.knowledgeContribution[genre][theme]) do
			self:_addContributingKnowledge(data.id, contributionList)
		end
	end
	
	if self.directKnowledgeContribution then
		self:_addContributingKnowledge(self.directKnowledgeContribution.knowledge, contributionList)
	end
end

function defaultTaskTypeFuncs:_addContributingKnowledge(knowledgeID, contributionList)
	if not table.find(contributionList, knowledgeID) then
		table.insert(contributionList, knowledgeID)
	end
end

function defaultTaskTypeFuncs:canBeSelected()
	return true
end

function defaultTaskTypeFuncs:getContentPointIncrease(gameProj)
	if self.contentPoints then
		local gameScale = gameProj:getScale()
		
		for pointType, amount in pairs(self.contentPoints) do
			data.realContentPoints[pointType] = amount * gameScale * gameProj:getCategoryPriority(self.category)
		end
		
		return data.realContentPoints
	end
	
	return nil
end

function defaultTaskTypeFuncs:getAbsenseText()
	return self.absenseText
end

function defaultTaskTypeFuncs:getRevealText()
	return nil
end

function defaultTaskTypeFuncs:applyContentPoints(gameProj)
	if self.contentPoints then
		local gameScale = gameProj:getScale()
		
		for pointType, amount in pairs(self.contentPoints) do
			gameProj:addContentPoints(pointType, amount * gameScale * gameProj:getCategoryPriority(self.category))
		end
	end
end

function defaultTaskTypeFuncs:getComputerLevelRequirement()
	return self.computerLevelRequirement
end

function defaultTaskTypeFuncs:getOutdatedTechTime()
	return self.outdatedTechTime or engine.OUTDATED_TECH_TIME_AMOUNT
end

function defaultTaskTypeFuncs:getResearchWorkField()
	return self.researchWorkField or self.workField
end

function defaultTaskTypeFuncs:canHaveTask(projectObject)
	return true
end

function defaultTaskTypeFuncs:onSelected(gameProj)
end

function defaultTaskTypeFuncs:onDeselected(gameProj)
end

function defaultTaskTypeFuncs:canPenalizeForAbsense(proj)
	local devTypes = self.developmentTypes
	
	if devTypes and not devTypes[proj:getGameType()] then
		return false
	end
	
	return true
end

function defaultTaskTypeFuncs:canResearch(employee)
	if not self.requiresResearch then
		return false
	end
	
	if not employee:getWorkplace() then
		return _format(_T("EMPLOYEE_WITHOUT_WORKPLACE_FOR_RESEARCH", "EMPLOYEE is without a workplace and therefore can not research TECH."), "EMPLOYEE", employee:getFullName(true), "TECH", self.display)
	end
	
	local researchSkill = self:getResearchWorkField()
	
	if self.minimumLevel and not employee:isSkillHighEnough(researchSkill, self.minimumLevel) then
		return string.easyformatbykeys(_T("EMPLOYEE_NOT_SKILLED_ENOUGH", "EMPLOYEE is not skilled enough to research TECH. It requires a SKILL skill of at least level MINIMUM, SKILL skill of EMPLOYEE is level LEVEL."), "EMPLOYEE", employee:getFullName(true), "TECH", self.display, "SKILL", skills.registeredByID[researchSkill].display, "MINIMUM", self.minimumLevel, "LEVEL", employee:getSkillLevel(researchSkill))
	end
	
	return true
end

function defaultTaskTypeFuncs:getTaskID()
	return self.taskID
end

function defaultTaskTypeFuncs:getCost(cost, project)
	cost = cost or self.cost
	
	if self.cost and self.cost > 0 and self.category then
		cost = cost * project:getCategoryPriority(self.category)
	end
	
	return cost and math.round(cost) or 0
end

function defaultTaskTypeFuncs:getPlatformWorkAmountAffector(projectObject)
	return projectObject:getPlatformWorkAmountAffector() * self.platformWorkAffector
end

function defaultTaskTypeFuncs:getMinimumLevel()
	return self.minimumLevel
end

function defaultTaskTypeFuncs:hasReleaseDate()
	return self.releaseDate ~= nil
end

function defaultTaskTypeFuncs:isInvisible()
	return self.invisible
end

function defaultTaskTypeFuncs:wasReleased()
	return studio:getFact(self.releaseDateFact) or not self.releaseDateFact
end

function defaultTaskTypeFuncs:wasReleasedRecently()
	if not self.releaseDate or not self:wasReleased() then
		return false
	end
	
	return timeline:getDateTime(self.releaseDate.year, self.releaseDate.month) + self.RECENT_RELEASE_DATE_TIME_PERIOD - timeline.curTime > 0
end

function defaultTaskTypeFuncs:getGameQualityPointIncrease(projectObject, time)
	return self.gameQuality
end

function defaultTaskTypeFuncs:getDescription()
	return self.description
end

function defaultTaskTypeFuncs:adjustReviewScore(gameProj, curScore)
	return curScore
end

function defaultTaskTypeFuncs:adjustQualityScore(gameProj, qualityID, level)
	return level
end

function defaultTaskTypeFuncs:onProjectFinish(taskObject)
end

function defaultTaskTypeFuncs:getInvalidityText(projectObject)
end

function defaultTaskTypeFuncs:onDesired(projectObject)
end

function defaultTaskTypeFuncs:onUndesired(projectObject)
end

function defaultTaskTypeFuncs:getMMOContent()
	return self:_getMMOContent(self)
end

function defaultTaskTypeFuncs:_getMMOContent(data)
	local val = 0
	
	if data.mmoContent then
		val = val + data.mmoContent
	end
	
	if data.implementationTasks then
		local map = taskTypes.registeredByID
		
		for key, id in ipairs(data.implementationTasks) do
			val = val + self:_getMMOContent(map[id])
		end
	end
	
	return val
end

function defaultTaskTypeFuncs:setDesiredFeature(projectObject, state, skipDisable)
	projectObject:setDesiredFeature(self.id, state, skipDisable)
	
	if self.implementationTasks then
		self:_setDesiredFeatures(self.implementationTasks, projectObject, state, skipDisable)
	end
	
	if self.extraTasks then
		local themeTasks = self.extraTasks.theme[projectObject:getTheme()]
		
		if themeTasks then
			self:_setDesiredFeatures(themeTasks, projectObject, state, skipDisable)
		end
		
		local genreTasks = self.extraTasks.genre[projectObject:getGenre()]
		
		if genreTasks then
			self:_setDesiredFeatures(genreTasks, projectObject, state, skipDisable)
		end
	end
end

function defaultTaskTypeFuncs:_setDesiredFeatures(list, projectObject, state, skipDisable)
	for key, taskID in ipairs(list) do
		taskTypes.registeredByID[taskID]:setDesiredFeature(projectObject, state, skipDisable)
	end
end

function defaultTaskTypeFuncs:onFinish(taskObject)
end

taskTypes.requiresManualImplementationLayout = {
	font = "pix24",
	implementationText = true,
	text = _T("REQUIRES_MANUAL_IMPLEMENTATION", "This feature requires implementation on a per-game basis."),
	color = color(200, 200, 255, 255)
}

function taskTypes:addKnowledgeQualityContributor(taskID, knowledgeID, multiplier, genreID, themeID)
	local taskData = taskTypes.registeredByID[taskID]
	
	taskData.knowledgeContribution = taskData.knowledgeContribution or {}
	taskData.knowledgeContribution[genreID] = taskData.knowledgeContribution[genreID] or {}
	taskData.knowledgeContribution[genreID][themeID] = taskData.knowledgeContribution[genreID][themeID] or {}
	
	table.insert(taskData.knowledgeContribution[genreID][themeID], {
		id = knowledgeID,
		amount = multiplier
	})
end

function taskTypes:registerNew(data, nameDescInheritance, classInheritance)
	if classInheritance then
		local inheritClass = taskTypes.registeredByID[classInheritance]
		
		data.baseClass = inheritClass
		
		setmetatable(data, inheritClass.mtindex)
	else
		data.baseClass = defaultTaskTypeFuncs
		
		setmetatable(data, defaultTaskTypeFuncs.mtindex)
	end
	
	taskTypes.registeredByID[data.id] = data
	
	table.insert(taskTypes.registered, data)
	
	if data.taskID then
		if not taskTypes.registeredByTaskID[data.taskID] then
			taskTypes.registeredByTaskID[data.taskID] = {}
		end
		
		table.insert(taskTypes.registeredByTaskID[data.taskID], data)
	end
	
	data.canAskAbout = true
	
	if nameDescInheritance then
		local base = taskTypes.registeredByID[nameDescInheritance]
		
		data.display = base.display
		data.description = data.description or {}
		
		if base.description then
			for key, iterData in ipairs(base.description) do
				if not iterData.implementationText then
					table.insert(data.description, iterData)
				end
			end
		end
	end
	
	if data.category then
		self:validateCategory(data.category)
		table.insert(taskTypes.registeredByCategory[data.category].taskTypes, data)
	end
	
	if data.taskID == "engine_task" then
		data.licensingAttractiveness = data.licensingAttractiveness or engine.DEFAULT_LICENSING_ATTRACTIVENESS
		data.isEngineTask = true
	elseif data.taskID == "game_task" then
		data.isGameTask = true
		
		if not data.mmoContent then
			data.mmoContent = taskTypes.DEFAULT_MMO_CONTENT
		end
		
		if data.mmoComplexity then
			data.mmoComplexity = data.mmoComplexity * taskTypes.MMO_COMPLEXITY_MULTIPLIER
		end
	end
	
	if data.platformWorkAffector == nil then
		data.platformWorkAffector = 1
	end
	
	if data.absenseCheck then
		table.insert(taskTypes.registeredAbsenceCheck, data)
	end
	
	if data.absenseScoreAdjust then
		table.insert(taskTypes.registeredAbsenseScoreAdjust, data)
	end
	
	if data.gameQuality then
		data.totalQuality = 0
		
		for qualityID, amount in pairs(data.gameQuality) do
			data.totalQuality = data.totalQuality + amount
		end
	else
		data.totalQuality = 0
	end
	
	if data.contentPoints then
		data.realContentPoints = {}
	end
	
	if data.releaseDate then
		data.releaseDate.month = data.releaseDate.month or 1
		
		local releaseDateID = "released_" .. data.id
		
		scheduledEvents:registerNew({
			id = releaseDateID,
			factToSet = releaseDateID,
			date = data.releaseDate
		}, "scheduled_tech_release_date_base")
		
		data.releaseDateFact = releaseDateID
		data.factRequirement = releaseDateID
		taskTypes.lastFeatureTime.year = math.max(taskTypes.lastFeatureTime.year, data.releaseDate.year)
		taskTypes.lastFeatureTime.month = math.max(taskTypes.lastFeatureTime.month, data.releaseDate.month)
		taskTypes.yearsWithTech[data.releaseDate.year] = taskTypes.yearsWithTech[data.releaseDate.year] or {}
	end
	
	if data.knowledgeContribution then
		for genreID, list in pairs(data.knowledgeContribution) do
			for theme, list2 in pairs(list) do
				for key, data in ipairs(list2) do
					if not knowledge.registeredByID[data.id] then
						error("invalid knowledge id " .. data.id)
					end
				end
			end
		end
	end
	
	if data.factRequirement then
		taskTypes.registeredByFactRequirement[data.factRequirement] = data
	end
	
	if data.optionCategory then
		taskTypes.registeredByOptionCategory[data.optionCategory] = taskTypes.registeredByOptionCategory[data.optionCategory] or {}
		
		table.insert(taskTypes.registeredByOptionCategory[data.optionCategory], data)
	end
	
	if data.implementation then
		data.description = data.description or {}
		
		table.insert(data.description, taskTypes.requiresManualImplementationLayout)
	end
	
	if data.workAmount then
		data.workAmountOriginal = data.workAmount
		data.workAmount = math.round(data.workAmount * taskTypes.WORK_AMOUNT_MULTIPLIER)
	end
	
	data.mtindex = {
		__index = data
	}
	
	local registerMethod = taskTypes.taskTypeRegistration[data.taskID]
	
	if registerMethod then
		registerMethod(data)
	end
end

function taskTypes:setRequiredWorkAmount(amount)
	self.WORK_AMOUNT_MULTIPLIER = amount
	
	for key, data in ipairs(taskTypes.registered) do
		if data.workAmount then
			data.workAmount = math.round(data.workAmountOriginal * self.WORK_AMOUNT_MULTIPLIER)
		end
	end
end

function taskTypes:buildFeatureCounts()
	for key, data in ipairs(taskTypes.registered) do
		if data.workAmount then
			data.totalFeatureCounter = 1
			data.totalWork = 0
			
			self:increaseWorkCounter(data, data)
			
			if data.implementationTasks then
				self:_buildFeatureCounts(data, data.implementationTasks)
			end
		end
	end
end

function taskTypes:increaseWorkCounter(baseData, data)
	baseData.totalWork = (baseData.totalWork or 0) + data.workAmount
	
	if data.stage == 2 and data.taskID == "game_task" then
		baseData.totalWork = baseData.totalWork + data.workAmount * gameProject.POLISH_TASK_CLASS.WORK_OVERALL_MULTIPLIER
	end
end

function taskTypes:_buildFeatureCounts(baseData, taskList)
	baseData.totalFeatureCounter = baseData.totalFeatureCounter + #taskList
	
	for key, task in ipairs(taskList) do
		local data = taskTypes.registeredByID[task]
		
		data.IMPLEMENTATION_TASK = true
		data.totalWork = 0
		
		self:increaseWorkCounter(baseData, data)
		
		if data.implementationTasks then
			self:_buildFeatureCounts(baseData, data.implementationTasks)
		end
	end
end

function taskTypes:addTaskTypeRegisterCallback(taskID, method)
	taskTypes.taskTypeRegistration[taskID] = method
end

function taskTypes:registerCategoryTitle(category, title, invisible, description, noQualityHeader, priorityValue, icon)
	self:validateCategory(category)
	
	local data = taskTypes.registeredByCategory[category]
	
	data.title = title
	data.invisible = invisible
	data.description = description
	data.noQualityHeader = noQualityHeader
	data.priority = priorityValue or 1
	data.icon = icon
end

function taskTypes:registerCategoryDescription(category, description)
	self:validateCategory(category)
	
	taskTypes.registeredByCategory[category].description = description
end

function taskTypes:validateCategory(category)
	taskTypes.registeredByCategory[category] = taskTypes.registeredByCategory[category] or {
		taskTypes = {}
	}
end

function taskTypes:onStartedBuild()
	self:buildMainQualityList()
	self:buildKnowledgeContribution()
	self:buildFeatureCounts()
end

local contributionByTask = {}

function taskTypes:buildMainQualityList()
	for qualityID, categoryList in ipairs(taskTypes.categoriesByQuality) do
		table.clearArray(categoryList)
	end
	
	for category, data in pairs(taskTypes.registeredByCategory) do
		if not data.noQualityHeader then
			for key, taskData in ipairs(data.taskTypes) do
				if taskData.qualityContribution then
					contributionByTask[taskData.qualityContribution] = (contributionByTask[taskData.qualityContribution] or 0) + 1
				end
				
				if taskData.gameQuality then
					for qualityType, amount in pairs(taskData.gameQuality) do
						contributionByTask[qualityType] = (contributionByTask[qualityType] or 0) + 1
					end
				end
			end
			
			local highest, mainQuality = -math.huge
			
			for qualityType, taskAmount in pairs(contributionByTask) do
				if highest < taskAmount then
					highest = taskAmount
					mainQuality = qualityType
				end
			end
			
			data.mainQuality = mainQuality
			
			if mainQuality then
				taskTypes.categoriesByQuality[mainQuality] = taskTypes.categoriesByQuality[mainQuality] or {}
				
				table.insert(taskTypes.categoriesByQuality[mainQuality], category)
			end
			
			table.clear(contributionByTask)
		end
	end
end

function taskTypes:unlockTechOfDate(year, month)
	local dateTime = timeline:getDateTime(year, month)
	
	for key, data in ipairs(taskTypes.registered) do
		if data.requiresResearch and (not data.releaseDate or dateTime >= timeline:getDateTime(data.releaseDate.year, data.releaseDate.month)) then
			studio:addFeature(data.id)
		end
	end
end

function taskTypes:buildKnowledgeContribution()
	for key, taskData in ipairs(taskTypes.registeredByTaskID.game_task) do
		if taskData.knowledgeContribution then
			for genre, themeList in pairs(taskData.knowledgeContribution) do
				for theme, contributorList in pairs(themeList) do
					for key, data in ipairs(contributorList) do
						knowledge.registeredByID[data.id]:addContributionType(genre, theme, data.amount)
					end
				end
			end
		end
		
		local data = taskData.directKnowledgeContribution
		
		if data then
			local knowData = knowledge.registeredByID[data.knowledge]
			
			knowData.taskCount = knowData.taskCount + 1
		end
	end
end

function taskTypes:getCategoriesOfQuality(qualityID)
	return taskTypes.categoriesByQuality[qualityID]
end

function taskTypes:getCategoryQualityType(categoryID)
	return taskTypes.registeredByCategory[categoryID].mainQuality
end

function taskTypes:getTaskByFactRequirement(fact)
	return taskTypes.registeredByFactRequirement[fact]
end

function taskTypes:getTasksByOptionCategory(optionCategory)
	return taskTypes.registeredByOptionCategory[optionCategory]
end

function taskTypes:getTasksByTaskID(taskID)
	return taskTypes.registeredByTaskID[taskID]
end

function taskTypes:getTasksByCategory(category)
	return taskTypes.registeredByCategory[category] and taskTypes.registeredByCategory[category].taskTypes
end

function taskTypes:getTaskCategory(category)
	return taskTypes.registeredByCategory[category]
end

local foundFeatures = {}

function taskTypes:getReleasedFeaturesBetween(start, finish, taskIDs, into)
	into = into or foundFeatures
	
	table.clearArray(into)
	
	for key, taskType in ipairs(taskTypes.registered) do
		if taskIDs[taskType.taskID] and taskType.releaseDate then
			local dateTime = timeline:getDateTime(taskType.releaseDate.year, taskType.releaseDate.month)
			
			if start <= dateTime and dateTime <= finish then
				into[#into + 1] = taskType
			end
		end
	end
	
	return foundFeatures
end

function taskTypes:canDisplayCategory(category)
	return not taskTypes.registeredByCategory[category].invisible
end

local availableTasks = {}

function taskTypes:getAvailableCategoryTasks(category, projectObject)
	table.clearArray(availableTasks)
	
	local catTasks = taskTypes.registeredByCategory[category]
	
	if not catTasks.invisible then
		for key, taskData in ipairs(catTasks.taskTypes) do
			if self:canHaveTask(taskData, projectObject) and not taskData:isInvisible() then
				availableTasks[#availableTasks + 1] = taskData
			end
		end
	end
	
	return availableTasks
end

function taskTypes:getTotalAvailableTasks(categories, projectObject)
	local total, totalAvailable = 0, 0
	
	for key, category in ipairs(categories) do
		local catTasks = taskTypes.registeredByCategory[category]
		
		for key, taskData in ipairs(catTasks.taskTypes) do
			total = total + 1
			
			if self:canHaveTask(taskData, projectObject) then
				totalAvailable = totalAvailable + 1
			end
		end
	end
	
	return totalAvailable, total
end

function taskTypes:passesFactRequirement(taskData)
	if taskData.factRequirement and not studio:getFact(taskData.factRequirement) then
		return false
	end
	
	return true
end

function taskTypes:canHaveTask(taskData, projectObject)
	if not self:passesFactRequirement(taskData) then
		return false
	end
	
	if not taskData:canHaveTask(projectObject) then
		return false
	end
	
	if taskData.requiresResearch and not studio:isFeatureResearched(taskData.id) then
		return false
	end
	
	if taskData.requiresImplementation then
		return false
	end
	
	return true
end

function taskTypes:getReleaseText(taskData)
	if taskData.releaseText then
		return taskData.releaseText
	end
	
	return string.easyformatbykeys(taskTypes.BASE_RELEASE_TEXT, "FEATURE", taskData.display)
end

function taskTypes:getData(taskTypeID)
	return taskTypes.registeredByID[taskTypeID]
end

function taskTypes:isFeatureUnlocked(featureID)
	if taskTypes.OVERRIDE_UNLOCKS then
		return true
	end
	
	if taskTypes.registeredByID[featureID].requiresResearch then
		return studio:isFeatureResearched(featureID)
	end
	
	return true
end

function taskTypes:getSkillRequirement(taskID)
	return taskTypes.registeredByID[taskID].minimumLevel
end

function taskTypes:countUnlockedCategoryFeatures(category)
	local total = 0
	
	for key, taskType in ipairs(taskTypes.registeredByCategory[category].taskTypes) do
		if self:isFeatureUnlocked(taskType.id) then
			total = total + 1
		end
	end
	
	return total
end

function taskTypes:getUnlockedCategoryFeatures(category)
	table.clearArray(self.lastUnlockedFeatures)
	
	for key, taskType in ipairs(taskTypes.registeredByCategory[category].taskTypes) do
		if self:isFeatureUnlocked(taskType.id) then
			table.insert(self.lastUnlockedFeatures, taskType)
		end
	end
	
	return self.lastUnlockedFeatures
end

function taskTypes:getResearchableCategoryFeatures(category)
	table.clearArray(self.lastUnlockedFeatures)
	
	for key, taskType in ipairs(taskTypes.registeredByCategory[category].taskTypes) do
		if taskType.requiresResearch and not self:isFeatureUnlocked(taskType.id) and self:passesFactRequirement(taskType) then
			table.insert(self.lastUnlockedFeatures, taskType)
		end
	end
	
	return self.lastUnlockedFeatures
end

function taskTypes:getResearchedCategoryFeatures(category)
	table.clearArray(self.lastUnlockedFeatures)
	
	for key, taskType in ipairs(taskTypes.registeredByCategory[category].taskTypes) do
		if taskType.requiresResearch and self:isFeatureUnlocked(taskType.id) then
			table.insert(self.lastUnlockedFeatures, taskType)
		end
	end
	
	return self.lastUnlockedFeatures
end

function taskTypes:getQualityFromKnowledgeTimeAffector()
	local curYear = timeline:getYear()
	
	if curYear < taskTypes.KNOWLEDGE_MANDATORY_START then
		return 0
	end
	
	local startTime = timeline:getDateTime(taskTypes.KNOWLEDGE_MANDATORY_START, 1)
	local finishTime = timeline:getDateTime(taskTypes.KNOWLEDGE_MANDATORY_FINISH, 1)
	local delta = timeline.curTime - startTime
	
	return math.min(delta / (finishTime - startTime), 1)
end

function taskTypes:getDesiredQualityFromKnowledge(taskData, multiplier)
	return multiplier * taskData.workAmount * taskTypes.KNOWLEDGE_TO_EXTRA_QUALITY * knowledge.MAXIMUM_KNOWLEDGE
end

local function standardQualityMultiplierApply(data)
	data.standardQualityMultiplier = data.standardQualityMultiplier or taskTypes.DEFAULT_QUALITY_FOR_STANDARD_MULTIPLIER
	
	if data.optionalForStandard == nil then
		data.optionalForStandard = taskTypes.DEFAULT_OPTIONAL_FOR_STANDARD
	end
	
	if data.implementation then
		taskTypes.implementationLink[data.implementation] = data
	end
	
	if data.taskID == "engine_task" then
		data.ENGINE_TASK = true
	end
end

local function gameTaskRegisterCallback(data)
	if not data.standardQualityMultiplier then
		data.standardQualityMultiplier = 1
		
		if data.gameQuality then
			local totalQuality = 0
			
			for qualityID, amount in pairs(data.gameQuality) do
				totalQuality = totalQuality + amount
			end
			
			if data.qualityContribution then
				local extraMultiplier = gameProject.TASK_CLASS:getSkillQualityIncrease(skills.DEFAULT_MAX) / totalQuality * data.workAmount * taskTypes.STANDARD_CALCULATION_MULTIPLIER
				
				data.standardQualityMultiplier = data.standardQualityMultiplier + extraMultiplier
			end
			
			if data.directKnowledgeContribution and data.directKnowledgeContribution.mandatory then
				local knowledgeContribMult = taskTypes:getDesiredQualityFromKnowledge(data, data.directKnowledgeContribution.multiplier) / totalQuality * data.directKnowledgeContribution.mandatory
				
				data.standardQualityMultiplier = data.standardQualityMultiplier + knowledgeContribMult
				data.standardQualityMultiplierKnowledge = knowledgeContribMult
			end
		end
	end
	
	standardQualityMultiplierApply(data)
	
	data.developmentType = data.developmentType or gameProject.DEFAULT_DEV_TYPES
end

taskTypes:addTaskTypeRegisterCallback("engine_task", standardQualityMultiplierApply)
taskTypes:addTaskTypeRegisterCallback("game_task", gameTaskRegisterCallback)
taskTypes:registerCategoryTitle(taskTypes.INVISIBLE_RESEARCHABLE_CATEGORY, _T("CATEGORY_MISCELLANEOUS", "Miscellaneous"), nil, nil, nil, nil, "category_miscellan")
