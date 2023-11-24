engine = {}
engine.mtindex = {
	__index = engine
}
engine.DEVELOPMENT_CATEGORIES = {
	"projection",
	"visual_features",
	"audio",
	"input",
	"development",
	"platform_support"
}
engine.DEVELOPMENT_TYPE = {
	UPDATE = "engine_update",
	NEW = "new_engine",
	REVAMP = "engine_revamp"
}
engine.REVAMP_WORK_SCALE = 0.3
engine.PROJECT_TYPE = "engine"
engine.PROJECT_TASK_CLASS = "engine_task"
engine.EVENTS = {
	FINISHED_ENGINE = events:new(),
	REVAMP_FINISHED = events:new(),
	UPDATE_FINISHED = events:new(),
	FEATURE_ADDED = events:new(),
	BEGAN_WORK = events:new(),
	UPDATE_CANCELLED = events:new()
}
engine.ON_FINISH_FIRE_EVENT = engine.EVENTS.FINISHED_ENGINE
engine.DEFAULT_LICENSING_ATTRACTIVENESS = 1
engine.LEAST_ATTRACTIVE_TIMESTAMP_FACT = "least_attractive_timestamp"
engine.SOFTWARE_TO_INTEGRITY_DELTA_MULTIPLIER = 0.2
engine.TASKS_UPDATE_INTEGRITY_AFFECTOR_MULTIPLIER = 0.2
engine.OUTDATED_TECH_TIME_AMOUNT = timeline.DAYS_IN_YEAR * 5
engine.MINIMUM_PERFORMANCE_LEVEL = 10
engine.MINIMUM_PERFORMANCE_LEVEL_INCREASE = 1
engine.MINIMUM_PERFORMANCE_LEVEL_AFFECTOR_FROM_SOFTWARE = 10
engine.MAXIMUM_PERFORMANCE_LEVEL = 100
engine.NEW_FEATURE_PERFORMANCE_LOSS_AFFECTOR = 2
engine.REVAMP_PERFORMANCE_STAT_INCREASE_BASE = 0.2
engine.REVAMP_PERFORMANCE_STAT_INCREASE_SOFTWARE = 0.6
engine.lastMissingFeatures = {}
engine.visionToPerformance = 0.05
engine.visionToEaseOfUse = 0.15
engine.visionToIntegrity = 0.1
engine.intelligenceToPerformance = 0.15
engine.intelligenceToEaseOfUse = 0.05
engine.intelligenceToIntegrity = 0.1
engine.softwareToBaseStat = 0.8
engine.minimumStat = 0.1
engine.maximumStat = 1
engine.totalAttractiveness = nil
engine.cost = nil
engine.featureCount = nil

setmetatable(engine, complexProject.mtindex)

function engine.new(owner)
	local new = {}
	
	setmetatable(new, engine.mtindex)
	new:init(owner)
	
	return new
end

function engine:addDevelopmentCategory(category)
	table.insert(self.DEVELOPMENT_CATEGORIES, category)
end

function engine:setIsLicenseableEngine(is)
	self.licenseable = is
end

function engine:isLicenseable()
	return self.licenseable
end

function engine:init(owner)
	complexProject.init(self, owner)
	
	self.licensesSold = 0
	self.moneyMade = 0
	self.featureCount = 0
	self.revision = 0
	self.revisionData = {}
	self.allRevisionFeatures = {}
end

function engine:finish()
	local isUpdate = self.curDevType == engine.DEVELOPMENT_TYPE.UPDATE
	
	if self:getEngine() == self then
		self:updateStats(isUpdate)
	end
	
	if self.curDevType == engine.DEVELOPMENT_TYPE.NEW then
		events:fire(engine.EVENTS.FINISHED_ENGINE, self)
		self.owner:addEngine(self)
		self.owner:getStats():changeStat("engines_created", 1)
	elseif self.curDevType == engine.DEVELOPMENT_TYPE.UPDATE then
		self:updateFinished()
	elseif self.curDevType == engine.DEVELOPMENT_TYPE.REVAMP then
		self:revampFinished()
	end
	
	self:removeStageTasks(1)
	self:unassignTeam()
	self:calculateLicensingAttractiveness()
	project.finish(self)
	
	self.curDevType = nil
	self.devType = nil
	self.lastValidRevision = nil
end

function engine:updateFinished()
	if self.team then
		self.team:setProject(nil)
		events:fire(engine.EVENTS.UPDATE_FINISHED, self)
	end
end

function engine:revampFinished()
	if self.team then
		self.team:setProject(nil)
		events:fire(engine.EVENTS.REVAMP_FINISHED, self)
	end
end

function engine:findMissingFeatures(category)
	table.clearArray(engine.lastMissingFeatures)
	
	for key, taskType in ipairs(category.taskTypes) do
		if not self.features[taskType.id] then
			table.insert(engine.lastMissingFeatures, taskType)
		end
	end
	
	return engine.lastMissingFeatures
end

function engine:setReleaseDate(date)
	self.releaseDate = date
end

function engine:getReleaseDate()
	return self.releaseDate
end

function engine:getProjectAge()
	return timeline.curTime - self.releaseDate
end

function engine:findMissingAvailableFeatures(category)
	table.clearArray(engine.lastMissingFeatures)
	
	for key, taskType in ipairs(taskTypes:getAvailableCategoryTasks(category, self)) do
		if not self.features[taskType.id] and self:canHaveFeature(taskType.id, true, false, true) then
			if taskType.optionCategory then
				local ourTime = taskType.releaseDate and timeline:getDateTime(taskType.releaseDate.year, taskType.releaseDate.month or 1) or 0
				local canHave = true
				local curFeat
				
				for key, otherData in ipairs(taskTypes.registeredByOptionCategory[taskType.optionCategory]) do
					if otherData ~= taskType and self.features[otherData.id] then
						curFeat = otherData
					end
				end
				
				if curFeat then
					local theirTime = curFeat.releaseDate and timeline:getDateTime(curFeat.releaseDate.year, curFeat.releaseDate.month or 1) or 0
					
					if theirTime < ourTime then
						table.insert(engine.lastMissingFeatures, taskType)
					end
				else
					table.insert(engine.lastMissingFeatures, taskType)
				end
			else
				table.insert(engine.lastMissingFeatures, taskType)
			end
		end
	end
	
	return engine.lastMissingFeatures
end

function engine:removePreviousOptionCategoryTask(newTaskID)
	local taskData = taskTypes.registeredByID[newTaskID]
	
	if taskData.optionCategory then
		for key, otherData in ipairs(taskTypes:getTasksByOptionCategory(taskData.optionCategory)) do
			if otherData ~= taskData and self.features[otherData.id] then
				self.features[otherData.id] = nil
				
				if self:getEngine() == self then
					self:removeFeatureFromRevision(otherData.id)
				end
				
				break
			end
		end
	end
end

function engine:addFeature(feature)
	if not self.features[feature] then
		self.featureCount = self.featureCount + 1
		
		self:addFeatureToRevision(feature)
	end
	
	self:removePreviousOptionCategoryTask(feature)
	
	self.features[feature] = true
	
	events:fire(engine.EVENTS.FEATURE_ADDED, self, feature)
end

function engine:addFeatureToRevision(feature)
	local revTable = self.revisionData[self.revision]
	
	revTable.features[feature] = true
	revTable.featureCount = revTable.featureCount + 1
end

function engine:removeFeatureFromRevision(feature)
	local revTable = self.revisionData[self.revision]
	
	revTable.features[feature] = nil
	revTable.featureCount = revTable.featureCount - 1
end

function engine:getFeatureCount()
	return self.featureCount
end

function engine:getRevisionFeatures(revisionNumber)
	table.clear(self.allRevisionFeatures)
	
	for index = 1, revisionNumber do
		local revisionData = self.revisionData[index].features
		
		for featureID, state in pairs(revisionData) do
			self.allRevisionFeatures[featureID] = true
		end
	end
	
	return self.allRevisionFeatures
end

function engine:canBeginWorkOn()
	return complexProject.canBeginWorkOn(self) and self:hasName()
end

function engine:getMissingSelectionTextTable()
	local missingStuff = complexProject.getMissingSelectionTextTable(self)
	
	if not self:hasAtLeastOneDesiredFeature() then
		table.insert(missingStuff, _T("NO_FEATURES_SELECTED", "No features selected."))
	end
	
	if not self:getDesiredTeam() then
		table.insert(missingStuff, _T("NO_TEAM_SELECTED", "No team selected."))
	end
	
	if not self:hasName() then
		table.insert(missingStuff, _T("NO_PROJECT_NAME_ENTERED", "No project name entered."))
	end
	
	return missingStuff
end

function engine:getRevisionStats(revisionNumber)
	return self.revisionData[revisionNumber].stats
end

function engine:getRevision()
	return self.lastValidRevision or self.revision
end

function engine:getRevisionCount()
	return #self.revisionData
end

function engine:getRevisionData(index)
	return self.revisionData[index]
end

function engine:getFeatures()
	return self.features
end

function engine:getFeatureCount()
	return self.featureCount
end

function engine:hasFeature(featureID)
	return self.features[featureID]
end

function engine:createAttractivenessDisplay(list)
	local attractivenessDisplay = gui.create("GradientIconPanel", list)
	
	attractivenessDisplay:setFont("pix20")
	attractivenessDisplay:setIcon("star_yellow")
	attractivenessDisplay:setText(self:getAttractivenessText())
	
	return attractivenessDisplay
end

function engine:getAttractivenessText()
	if self.totalAttractiveness then
		return _format(_T("ENGINE_ATTRACTIVENESS_DISPLAY", "Attractiveness: POINTS pts."), "POINTS", math.round(self.totalAttractiveness, 1))
	else
		return _T("ENGINE_ATTRACTIVENESS_NOT_AVAILABLE_DISPLAY", "Attractiveness: N/A")
	end
end

function engine:createCostDisplay(list)
	local costDisplay = gui.create("GradientIconPanel", list)
	
	costDisplay:setFont("pix20")
	costDisplay:setIcon("wad_of_cash")
	
	local cost = self.cost
	
	costDisplay:setText(self:getCostText())
	
	return costDisplay
end

function engine:getCostText()
	local cost = self.cost
	
	if cost then
		if cost == 0 then
			return _T("ENGINE_FREE", "Free!")
		else
			return _format(_T("ENGINE_COST", "Cost: $COST"), "COST", string.comma(cost))
		end
	else
		return _T("ENGINE_COST_NOT_AVAILABLE", "Cost: N/A")
	end
end

function engine:getFeatureCountText()
	if self.featureCount then
		if self.featureCount == 1 then
			return _T("ENGINE_ONE_FEATURE", "1 Feature")
		else
			return _format(_T("ENGINE_FEATURE_COUNT", "FEATURES Features"), "FEATURES", self.featureCount)
		end
	else
		return _T("ENGINE_FEATURES_NOT_AVAILABLE", "Features: N/A")
	end
end

function engine:fillSaleDescboxInfo(descBox, font, wrapWidth)
	descBox:addText(self:getAttractivenessText(), "bh20", game.UI_COLORS.IMPORTANT_1, 4, wrapWidth, "star_yellow", 23, 21)
	descBox:addText(_format(_T("ENGINE_MONEY_EARNED", "EARNED Earned"), "EARNED", string.roundtobigcashnumber(self.moneyMade)), font, nil, 4, wrapWidth, "wad_of_cash_plus", 22, 22)
	
	local text
	
	if self.licensesSold == 1 then
		text = _T("ONE_ENGINE_LICENSE_SOLD", "1 License sold")
	else
		text = _format(_T("MULTIPLE_ENGINE_LICENSES_SOLD", "LICENSES Licenses sold"), "LICENSES", self.licensesSold)
	end
	
	if studio:getSoldEngine() == self and self.cost then
		descBox:addText(_format(_T("ENGINE_CURRENT_PRICE", "Price: PRICE"), "PRICE", string.roundtobigcashnumber(self.cost)), font, nil, 4, wrapWidth, "wad_of_cash_minus", 22, 22)
	end
	
	descBox:addText(text, font, nil, 0, wrapWidth)
end

function engine:createEngineInfoDisplay()
	local frame = gui.create("Frame")
	
	frame:setSize(500, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("ENGINE_INFO_TITLE", "Engine Info"))
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(30))
	scrollbar:setSize(490, 460)
	scrollbar:setSpacing(2)
	scrollbar:setPadding(2, 2)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:addDepth(50)
	
	local engineStatDisplay = gui.create("EngineStatsDisplay", frame)
	
	engineStatDisplay:setPos(_S(5), _S(495))
	engineStatDisplay:setSize(490, 96)
	engineStatDisplay:setEngine(self)
	
	local engineFeatures = self:getFeatures()
	
	for key, categoryName in ipairs(engine.DEVELOPMENT_CATEGORIES) do
		local categoryData = taskTypes:getTaskCategory(categoryName)
		local categoryTitle
		
		for key, taskData in ipairs(categoryData.taskTypes) do
			if engineFeatures[taskData.id] then
				if not categoryTitle then
					categoryTitle = gui.create("Category")
					
					categoryTitle:setFont(fonts.get("bh28"))
					categoryTitle:setText(categoryData.title)
					categoryTitle:assumeScrollbar(scrollbar)
					scrollbar:addItem(categoryTitle)
				end
				
				local taskSelection = gui.create("TaskTypeSelection")
				
				taskSelection:setProject(self)
				taskSelection:setFeatureID(taskData.id)
				taskSelection:setFont(fonts.get("pix20"))
				taskSelection:setText(taskData.display)
				taskSelection:setHeight(20)
				taskSelection:setCanClick(false)
				categoryTitle:addItem(taskSelection)
			end
		end
	end
	
	frame:center()
	
	return frame
end

function engine:setCost(cost)
	self.cost = cost
end

function engine:getCost()
	return self.cost
end

function engine:getStat(statID, revision)
	revision = revision or self.revision
	
	return self.revisionData[revision].stats[statID]
end

function engine:calculateLicensingAttractiveness()
	self.totalAttractiveness = 0
	self.featureAttractiveness = 0
	self.statAttractiveness = 0
	
	local stats = self.revisionData[self.revision].stats
	
	for key, data in ipairs(engineStats.registered) do
		local value = stats[data.id]
		local increase = math.round(value * data.attractiveness, 2)
		
		self.totalAttractiveness = self.totalAttractiveness + increase
		self.statAttractiveness = self.statAttractiveness + increase
	end
	
	for featureID, state in pairs(self.features) do
		local data = taskTypes.registeredByID[featureID]
		
		self.totalAttractiveness = self.totalAttractiveness + data.licensingAttractiveness
		self.featureAttractiveness = self.featureAttractiveness + data.licensingAttractiveness
	end
	
	return self.totalAttractiveness, self.featureCount, self.featureAttractiveness, self.statAttractiveness
end

function engine:getAttractivenessStats()
	return self.totalAttractiveness, self.featureCount, self.featureAttractiveness, self.statAttractiveness
end

function engine:calculateDevelopmentSpeedMultiplier(features)
	local multiplier = 1
	
	for featureID, state in pairs(features) do
		local taskTypeData = taskTypes.registeredByID[featureID]
		
		if taskTypeData.devSpeedMultiplier then
			multiplier = multiplier + taskTypeData.devSpeedMultiplier
		end
	end
	
	return multiplier
end

function engine:getLicensingAttractiveness()
	return self.totalAttractiveness
end

function engine:getDevelopmentType()
	return self.curDevType
end

function engine:getLicensesSold()
	return self.licensesSold
end

function engine:increaseLicensesSold(amt)
	self.licensesSold = self.licensesSold + amt
end

function engine:increaseMoneyMade(amt)
	self.moneyMade = self.moneyMade + amt
end

function engine:getMoneyMade()
	return self.moneyMade
end

function engine:adjustStat(id, amount, revision)
	revision = revision or self.revision
	
	if not self.revisionData[self.revision].stats[id] then
		return 
	end
	
	if amount < 0 and id == "performance" then
		amount = amount * engine.NEW_FEATURE_PERFORMANCE_LOSS_AFFECTOR
	end
	
	self.revisionData[self.revision].stats[id] = math.clamp(self.revisionData[self.revision].stats + amount / 100, engine.minimumStat, engine.maximumStat)
end

function engine:setStat(id, amount, revision)
	revision = revision or self.revision
	self.revisionData[self.revision].stats[id] = math.min(amount, engine.maximumStat)
end

function engine:shouldSaveTasks()
	return self.curDevType ~= nil
end

function engine:shouldLoadTasks()
	return self.curDevType ~= nil
end

function engine:save()
	local saved = complexProject.save(self)
	
	saved.cost = self.cost
	saved.curDevType = self.curDevType
	saved.revisionData = self.revisionData
	saved.revision = self.revision
	saved.licenseable = self.licenseable
	saved.releaseDate = self.releaseDate
	saved.featureCount = self.featureCount
	saved.paidDesiredFeaturesCost = self.paidDesiredFeaturesCost
	saved.lastValidRevision = self.lastValidRevision
	saved.licensesSold = self.licensesSold
	saved.moneyMade = self.moneyMade
	
	return saved
end

function engine:load(data)
	self.revision = data.revision
	self.cost = data.cost
	self.curDevType = data.curDevType
	self.revisionData = data.revisionData
	self.licenseable = data.licenseable
	self.releaseDate = data.releaseDate
	self.featureCount = data.featureCount
	self.paidDesiredFeaturesCost = data.paidDesiredFeaturesCost or 0
	self.lastValidRevision = data.lastValidRevision
	self.licensesSold = data.licensesSold or 0
	self.moneyMade = data.moneyMade or 0
	
	if self:getEngine() == self then
		if self.revisionData[self.revision].stats then
			for key, data in ipairs(engineStats.registered) do
				local value = self.revisionData[self.revision].stats[data.id] or data.startLevel
				
				if value > 1 then
					self.revisionData[self.revision].stats[data.id] = value > 0 and math.min(value / 100, 1)
				else
					self.revisionData[self.revision].stats[data.id] = value
				end
			end
		else
			self.revisionData[self.revision].stats = engineStats:initializeStatStructure(self, {})
		end
	end
	
	complexProject.load(self, data)
	
	if self.PROJECT_TYPE == engine.PROJECT_TYPE then
		self:calculateLicensingAttractiveness()
	end
	
	if self.curDevType and self:getEngine() == self then
		events:fire(project.EVENTS.LOADED_PROJECT, self)
	end
end

function engine:getEngine()
	return self
end

function engine:calculateMinimumRevampRequirement()
	local min = 0
	
	for featureID, state in pairs(self.features) do
		if state then
			local featureData = taskTypes:getData(featureID)
			
			min = math.min(min, featureData.minimumLevel)
		end
	end
	
	self:setMinimumRevampRequirement(min)
end

function engine:setMinimumRevampRequirement(level)
	self.minRevampLevel = level
end

function engine:getMinimumRevampRequirement()
	return self.minRevampLevel
end

function engine:updateStats(newFeatures, revision)
	local isNewEngine = self.curDevType == engine.DEVELOPMENT_TYPE.NEW
	
	revision = revision or self.revision
	
	if not newFeatures then
		local highestPerformanceGain = 0
		local highestEaseOfUse = 0
		local highestIntegrity = 0
		local targetStats = self.revisionData[revision].stats
		
		for key, dev in ipairs(self.owner:getEmployees()) do
			local attr = dev:getAttributes()
			local vision, intelligence = attr.vision, attr.intelligence
			local software = dev:getSkill("software")
			local softwareLevel = software.level
			local intelligenceScalar = attributes:getPercentageToMax(intelligence, "intelligence")
			local visionScalar = attributes:getPercentageToMax(vision, "vision")
			local softwareScalar = skills:getPercentageToMax(dev, softwareLevel, "software")
			local performance = engine.visionToPerformance * visionScalar + engine.intelligenceToPerformance * intelligenceScalar + softwareScalar * engine.softwareToBaseStat
			local easeOfUse = engine.visionToEaseOfUse * visionScalar + engine.intelligenceToEaseOfUse * intelligenceScalar + softwareScalar * engine.softwareToBaseStat
			local integrity = engine.visionToIntegrity * visionScalar + engine.intelligenceToIntegrity * intelligenceScalar + softwareScalar * engine.softwareToBaseStat
			
			highestPerformanceGain = math.max(highestPerformanceGain, self:calculatePerformanceStat(dev, not isNewEngine))
			highestEaseOfUse = math.max(highestEaseOfUse, easeOfUse, engine.minimumStat)
			highestIntegrity = math.max(highestIntegrity, integrity, engine.minimumStat)
		end
		
		targetStats.performance = math.min(targetStats.performance + highestPerformanceGain, engine.maximumStat)
		targetStats.integrity = math.min(engine.maximumStat, math.max(highestIntegrity, targetStats.integrity))
		targetStats.easeOfUse = math.min(engine.maximumStat, math.max(highestEaseOfUse, targetStats.easeOfUse))
		
		local valid = true
		
		for key, data in ipairs(engineStats.registered) do
			if targetStats[data.id] < 1 then
				valid = false
				
				break
			end
		end
		
		if valid then
			achievements:attemptSetAchievement(achievements.ENUM.ENGINE_STATS_MAXED)
		end
	else
		local featureCount = #self.stages[self.stage]:getTasks()
		local avgSoftwareSkill = self.team:getAverageSkill("software") / 100
		local targetStats = self.revisionData[revision].stats
		
		if featureCount > 1 and avgSoftwareSkill < targetStats.integrity then
			local delta = (targetStats.integrity - avgSoftwareSkill) * engine.SOFTWARE_TO_INTEGRITY_DELTA_MULTIPLIER
			local featureAffector = math.ceil(math.ceil(featureCount * engine.TASKS_UPDATE_INTEGRITY_AFFECTOR_MULTIPLIER) * delta) / 100
			
			targetStats.integrity = math.max(engine.minimumStat, targetStats.integrity - featureAffector)
		end
	end
	
	self:calculateMinimumRevampRequirement()
end

function engine:calculatePerformanceStat(employee, isRevamp)
	local softwareLevel = employee:getSkillLevel("software")
	local mult = isRevamp and engine.REVAMP_PERFORMANCE_STAT_INCREASE_BASE + engine.REVAMP_PERFORMANCE_STAT_INCREASE_SOFTWARE * (softwareLevel / skills.DEFAULT_MAX) or 1
	local minimumPerformanceLevel = engine.MINIMUM_PERFORMANCE_LEVEL + softwareLevel / engine.MINIMUM_PERFORMANCE_LEVEL_AFFECTOR_FROM_SOFTWARE * engine.MINIMUM_PERFORMANCE_LEVEL_INCREASE
	
	return math.random(minimumPerformanceLevel, engine.MAXIMUM_PERFORMANCE_LEVEL) / 100 * mult
end

function engine:advanceRevision()
	if self:getEngine() ~= self then
		assert(false, "advanceRevision called on object that inherits engine class (only engines should call this), this should not happen")
		
		return 
	end
	
	self.revision = self.revision + 1
	
	local stats = self.revisionData[self.revision - 1] and table.copy(self.revisionData[self.revision - 1].stats) or engineStats:initializeStatStructure(self, {})
	local prevRevision = self.revisionData[self.revision - 1]
	
	self.revisionData[self.revision] = self.revisionData[self.revision] or {
		features = {},
		featureCount = self.featureCount,
		stats = stats
	}
end

function engine:revertRevision()
	table.remove(self.revisionData[self.revision])
	
	self.revision = self.revision - 1
end

function engine:assignTeamCallback()
	self.project:createTeamAssignmentMenu(nil, _T("APPLY_TEAM_CHANGE", "Apply team change"))
end

function engine:fillInteractionComboBox(comboBox)
	if self.curDevType == engine.DEVELOPMENT_TYPE.NEW then
		if interactionRestrictor:canPerformAction("generic_project_interaction") then
			self:addScrapProjectOption(comboBox, _T("SCRAP_ENGINE", "Scrap engine"))
		end
	elseif interactionRestrictor:canPerformAction("generic_project_interaction") then
		local text
		
		if self.curDevType == engine.DEVELOPMENT_TYPE.UPDATE then
			text = _T("CANCEL_UPDATE", "Cancel update")
		elseif self.curDevType == engine.DEVELOPMENT_TYPE.REVAMP then
			text = _T("CANCEL_REVAMP", "Cancel revamp")
		end
		
		comboBox:addOption(0, 0, 0, 24, text, fonts.get("pix20"), engine.cancelUpdateCallback).project = self
	end
	
	if not self.team then
		comboBox:addOption(0, 0, 0, 24, _T("ASSIGN_TEAM", "Assign team"), fonts.get("pix20"), engine.assignTeamCallback).project = self
	else
		comboBox:addOption(0, 0, 0, 24, _T("CHANGE_TEAM", "Change team"), fonts.get("pix20"), engine.assignTeamCallback).project = self
	end
end

function engine:finishProjectScrapCallback()
	self.project:scrap()
end

function engine:cancelUpdateCallback()
	local project = self.project
	local popup = gui.create("Popup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("SCRAP_ENGINE_UPDATE_TITLE", "Scrap Engine Update?"))
	popup:setWidth(500)
	popup:setText(_T("WANT_TO_SCRAP_ENGINE_UPDATE", "Are you sure you want to scrap this engine update? All progress will be lost."))
	
	local button = popup:addButton(fonts.get("pix20"), "Yes", engine.finishCancelUpdateCallback)
	
	button.project = project
	
	popup:addButton(fonts.get("pix20"), "No")
	popup:center()
	frameController:push(popup)
end

function engine:finishCancelUpdateCallback()
	self.project:cancelUpdate()
end

function engine:cancelUpdate()
	self:removeStageTasks(1)
	self:resetCompletion()
	self:revertRevision()
	self:unassignTeam()
	
	self.curDevType = nil
	self.lastValidRevision = nil
	
	events:fire(engine.EVENTS.UPDATE_CANCELLED, self)
end

function engine:scrap()
	complexProject.scrap(self)
	self.owner:removeEngine(self)
	self:recoupPaidDesiredFeatureCost()
end

function engine:scrapProjectCallback()
	local project = self.project
	local popup = gui.create("Popup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("SCRAP_PROJECT_TITLE", "Scrap Project?"))
	popup:setWidth(500)
	popup:setText(_T("WANT_TO_SCRAP_PROJECT", "Are you sure you want to scrap this project? All progress will be lost."))
	
	local button = popup:addButton(fonts.get("pix20"), "Yes", engine.finishProjectScrapCallback)
	
	button.project = project
	
	popup:addButton(fonts.get("pix20"), "No")
	popup:center()
	frameController:push(popup)
end

function engine:addScrapProjectOption(comboBox, scrapText)
	local option = comboBox:addOption(0, 0, 0, 24, scrapText, fonts.get("pix20"), self.scrapProjectCallback)
	
	option.project = self
	
	return option
end

function engine:getRevampWorkScale()
	return engine.REVAMP_WORK_SCALE
end

function engine:payDesiredFeaturesCost(cost)
	self.paidDesiredFeaturesCost = cost
	
	self:changeMoneySpent(cost)
	self.owner:deductFunds(cost, nil, "game_projects")
end

function engine:getPaidDesiredFeatureCost()
	return self.paidDesiredFeaturesCost
end

function engine:recoupPaidDesiredFeatureCost()
	if self.paidDesiredFeaturesCost and self.paidDesiredFeaturesCost > 0 then
		self.owner:addFunds(self.paidDesiredFeaturesCost)
	end
end

function engine:addDesiredFeatures()
	for feature, state in pairs(self.desiredFeatures) do
		if state then
			local taskData = taskTypes:getData(feature)
			local taskStage = taskData.stage or 1
			
			projectTypes:createAndAddStageTask(self, feature, taskStage)
		end
		
		self.desiredFeatures[feature] = nil
	end
end

function engine:beginWork(stage, devType)
	self:addEventReceiver()
	
	stage = stage or self.stage
	devType = devType or self.devType
	
	if not self.createdStageTasks then
		local cost = self:getFullWorkCost()
		
		self:payDesiredFeaturesCost(cost)
	end
	
	self.begunWorkOn = true
	
	if devType == engine.DEVELOPMENT_TYPE.NEW or devType == engine.DEVELOPMENT_TYPE.UPDATE then
		if devType == engine.DEVELOPMENT_TYPE.UPDATE then
			self:verifyStage(1)
			
			if self.curDevType ~= devType then
				self:removeStageTasks(1)
				
				self.lastValidRevision = self.revision
				
				self:advanceRevision()
				self:resetCompletion()
				self:addDesiredFeatures()
			end
		else
			self:advanceRevision()
			self:addDesiredFeatures()
		end
	elseif devType == engine.DEVELOPMENT_TYPE.REVAMP and self.curDevType ~= devType then
		self:verifyStage(1)
		self:removeStageTasks(1)
		
		self.lastValidRevision = self.revision
		
		self:advanceRevision()
		self:resetCompletion()
		
		for feature, state in pairs(self.features) do
			if state then
				local newTask = projectTypes:createStageTask(feature, "engine_revamp_task", self)
				
				self:addTask(newTask, 1)
			end
		end
	end
	
	self.curDevType = devType
	
	complexProject.beginWork(self, stage, devType)
	events:fire(engine.EVENTS.BEGAN_WORK, self)
end

function engine:setupInfoDescbox(descBox, wrapW)
	descBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	descBox:addText(_format(_T("REMAINING_WORK_POINTS", "POINTS work points left"), "POINTS", string.comma(math.round(self:getWorkRemainder()))), "bh18", game.UI_COLORS.LIGHT_BLUE, 3, wrapW, "wrench", 22, 22)
	descBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	descBox:addText(_format(_T("GAME_COMPLETION_TEXT", "COMPLETION% complete"), "COMPLETION", math.round(self:getOverallCompletion() * 100, 1)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "percentage", 22, 22)
end

function engine:getRevampWorkInfo()
	local total, workByWorkField = self:getThoroughWorkInfo(self.features)
	local workScale = self:getRevampWorkScale()
	
	for skillID, amount in pairs(workByWorkField) do
		workByWorkField[skillID] = amount * workScale
	end
	
	total = total * workScale
	
	return total, workByWorkField
end

function engine:isDone()
	if self:getFact(engineLicensing.GENERATED_ENGINE_FACT) or not self.curDevType then
		return true
	end
	
	return complexProject.isDone(self)
end

function engine:postLoad(data)
	if self:isDone() then
		self:removeEventReceiver()
	end
	
	self:calculateMinimumRevampRequirement()
end

require("game/engine/engine_task")
require("game/engine/engine_tasktypes")
require("game/engine/engine_project")
require("game/engine/engine_stats")
require("game/engine/engine_licensing")
