local projTask = {}

projTask.id = "project_task"
projTask.randomIssues = {}
projTask.MIN_ISSUE_DISCOVER_CHANCE = 3
projTask.MAX_CHANCE_DISCOVERED_ISSUES_AMOUNT = 10
projTask.EXP_INCREASE_PER_OVER_LIMIT = 0.005
projTask.FINAL_CHANCE_DEC_MULTIPLIER = 0.5
projTask.COLLECTIVE_SKILL_AFFECTOR = 0.05
projTask.MAX_COLLECTIVE_SKILL_AFFECTOR_BOOST = 5
projTask.ASSIGN_PROGRESS_DELAY_TIME = 0.33
projTask.timeToProgress = 1
projTask.FAIL_REASONS = {
	LACKS_COMPUTER_HARDWARE = "lacksComputerHardware",
	LACKS_SKILL = "lacksSkill"
}

function projTask:init()
	projTask.baseClass.init(self)
	
	self.finishedWork = 0
	self.progressTime = 0
	self.progressDelay = 0
end

function projTask:initIssues()
	if self.noIssues or self.totalIssues then
		return 
	end
	
	local totalIssues, discoveredIssues, fixedIssues, accumulatedFixes = issues:initIssues()
	
	self.totalIssues = totalIssues
	self.discoveredIssues = discoveredIssues
	self.fixedIssues = fixedIssues
	self.devDiscoveredIssues = {}
	self.accumulatedFixes = accumulatedFixes
	self.totalDiscoveredIssues = 0
	self.totalFixedIssues = 0
	
	for key, data in ipairs(issues.registered) do
		self.devDiscoveredIssues[data.id] = 0
	end
end

function projTask:canReassign(desiredEmployee)
	if self.assignee and desiredEmployee:getSkillLevel(self.workField) > self.assignee:getSkillLevel(self.workField) then
		return true
	end
	
	return false
end

function projTask:canStopToResearch()
	return false
end

function projTask:canSave()
	return false
end

function projTask:canCancel()
	return false
end

function projTask:addIssue(type)
	self.totalIssues[type] = self.totalIssues[type] + 1
	
	self.project:onCreateIssue(type)
end

function projTask:discoverIssue(type, devDiscovered)
	self.discoveredIssues[type] = self.discoveredIssues[type] + 1
	
	self.project:onDiscoverIssue(type, self)
	
	self.totalDiscoveredIssues = self.totalDiscoveredIssues + 1
	
	if devDiscovered then
		self.devDiscoveredIssues[type] = self.devDiscoveredIssues[type] + 1
	end
	
	return type
end

function projTask:fixIssue(type)
	if self.accumulateFixes then
		self.accumulatedFixes[type] = self.accumulatedFixes[type] + 1
	else
		self.fixedIssues[type] = self.fixedIssues[type] + 1
	end
	
	self.totalFixedIssues = self.totalFixedIssues + 1
	
	issues:attemptDetectIssue(self, assignee, 1)
	self.project:onFixIssue(type, self)
end

function projTask:setAccumulateFixes(accum)
	self.accumulateFixes = accum
	self.accumulatedFixesHistory = self.accumulatedFixesHistory or {}
	
	for key, data in ipairs(issues.registered) do
		self.accumulatedFixesHistory[data.id] = self.accumulatedFixes[data.id]
	end
end

function projTask:revertAccumulatedFixes()
	if self.accumulatedFixesHistory then
		for key, data in ipairs(issues.registered) do
			self.accumulatedFixes[data.id] = self.accumulatedFixesHistory[data.id]
			self.accumulatedFixesHistory[data.id] = 0
		end
	end
end

function projTask:accumulatesFixes()
	return self.accumulateFixes
end

function projTask:getDiscoveredIssues()
	return self.discoveredIssues
end

function projTask:getAccumulatedFixes()
	return self.accumulatedFixes
end

function projTask:getFixedIssues()
	return self.fixedIssues
end

function projTask:getAllDiscoveredUnfixedIssues()
	local total = 0
	
	for key, data in ipairs(issues.registered) do
		total = total + self:getDiscoveredUnfixedIssueCount(data.id)
	end
	
	return total
end

function projTask:getDiscoveredUnfixedIssueCount(type)
	if not self.totalIssues then
		return 0
	end
	
	return self.discoveredIssues[type] - self.fixedIssues[type] - self.accumulatedFixes[type]
end

function projTask:hasAtLeastOneUndiscoveredUnfixedIssue()
	local total = self.totalIssues
	local discovered = self.discoveredIssues
	
	for key, data in ipairs(issues.registered) do
		local id = data.id
		
		if total[id] - discovered[id] > 0 then
			return true
		end
	end
	
	return false
end

local discoverableTypes = {}

function projTask:getDiscoverableIssueTypes()
	table.clearArray(discoverableTypes)
	
	local issueCount = 0
	local total = self.totalIssues
	local discovered = self.discoveredIssues
	
	for key, data in ipairs(issues.registered) do
		local id = data.id
		local delta = total[id] - discovered[id]
		
		if delta > 0 then
			discoverableTypes[#discoverableTypes + 1] = id
			issueCount = issueCount + delta
		end
	end
	
	return discoverableTypes, issueCount
end

function projTask:getUndiscoveredUnfixedIssueCount(type)
	if not self.totalIssues then
		return 0
	end
	
	return self.totalIssues[type] - self.discoveredIssues[type]
end

function projTask:getUnfixedIssueCount(type)
	if not self.totalIssues then
		return 0
	end
	
	return self.totalIssues[type] - self.fixedIssues[type] - self.accumulatedFixes[type]
end

function projTask:setCanHaveIssues(can)
	if can then
		self:initIssues()
	end
end

function projTask:canHaveIssues()
	return self.discoveredIssues ~= nil
end

function projTask:areAllIssuesFixed()
	if not self.discoveredIssues then
		return true
	end
	
	return self.totalFixedIssues >= self.totalDiscoveredIssues
end

function projTask:areIssuesFixed(category)
	if not self.discoveredIssues then
		return true
	end
	
	return self.fixedIssues[category] + self.accumulatedFixes[category] == self.discoveredIssues[category]
end

function projTask:canHaveIssues()
	return self.discoveredIssues ~= nil
end

function projTask:getCompletionDisplay()
	if self.fixInProgress then
		return 1 - self.progressTime / self.issueFixTime
	else
		return self:getCompletion()
	end
end

function projTask:calculateRequiredWork(taskTypeData, projectObject)
	return math.ceil(taskTypeData.workAmount * projectObject:getScale())
end

function projTask:getScale()
	return self.projectScale
end

function projTask:isWorkOnDone()
	return self.finishedWork >= self.requiredWork
end

function projTask:canCrossContribute()
	return false
end

function projTask:isDone()
	return self:isWorkOnDone() and self:areAllIssuesFixed()
end

function projTask:canImprove()
	return self.qualityID ~= nil
end

function projTask:getQualityID()
	return self.qualityID
end

function projTask:setTaskType(taskType)
	projTask.baseClass.setTaskType(self, taskType)
	self:addTrainedSkill(self.taskTypeData.workField)
	
	if self.totalIssues then
		self:addTrainedSkill("testing")
	end
	
	self.computerLevelRequirement = self.taskTypeData.computerLevelRequirement
	self.multipleEmployees = self.taskTypeData.multipleEmployees
end

function projTask:getTrainedSkill(skillID)
	for key, task in ipairs(self.trainedSkills) do
		if task:getPracticeSkill() == skillID then
			return task
		end
	end
	
	return nil
end

function projTask:addTrainedSkill(skillID, expMin, expMax, practiceMin, practiceMax)
	self.trainedSkills = self.trainedSkills or {}
	
	if self:getTrainedSkill(skillID) then
		return 
	end
	
	expMin = expMin or game.PROJECT_EXP_GAIN_MIN
	expMax = expMax or game.PROJECT_EXP_GAIN_MAX
	practiceMin = practiceMin or game.PROJECT_EXP_GAIN_TIME_MIN
	practiceMax = practiceMax or game.PROJECT_EXP_GAIN_TIME_MAX
	
	local practice = game.createPracticeTask(skillID, expMin, expMax, practiceMin, practiceMax, -1)
	
	practice:setBarVisible(false)
	practice:setSkillIncreaseDivider(2)
	
	if self.assignee then
		practice:setAssignee(self.assignee)
	end
	
	table.insert(self.trainedSkills, practice)
end

function projTask:updateSkillTrainAssignee()
	for key, skillObj in ipairs(self.trainedSkills) do
		skillObj:setAssignee(self.assignee)
	end
end

function projTask:validateIssueState()
	local taskTypeData = taskTypes:getData(self.taskType)
	
	if self:isWorkOnDone() and not self:areAllIssuesFixed() then
		local text = taskTypeData.displayFix
		
		text = text or string.easyformatbykeys(_T("TASK_NAME_DISPLAY_WITH_FIXES", "NAME - fixes"), "NAME", taskTypeData.display)
		
		self:setText(text)
	else
		self:setText(taskTypeData.display)
	end
end

function projTask:setupIssueFixTime(issueType)
	local issueData = issues:getIssueData(issueType)
	
	self.progressTime = issues:getFixTime(issueData)
	self.issueFixTime = self.progressTime
	self.fixInProgress = issueType
end

function projTask:beginFixingIssue()
	self.fixInProgress = nil
	
	for key, issueType in ipairs(issues.priority) do
		local discoveredIssues = self.discoveredIssues[issueType]
		local delta = discoveredIssues - self.fixedIssues[issueType] - self.accumulatedFixes[issueType]
		
		if delta > 0 then
			self:setupIssueFixTime(issueType)
			
			return true
		end
	end
	
	return false
end

function projTask:getRandomUnfixedIssue()
	local index = 1
	local randomIssues = projTask.randomIssues
	
	for key, issueData in ipairs(issues.registered) do
		local type = issueData.id
		
		if self.totalIssues[type] - self.discoveredIssues[type] > 0 then
			randomIssues[index] = type
			index = index + 1
		else
			table.remove(randomIssues, index)
		end
	end
	
	return randomIssues[math.random(1, #randomIssues)]
end

function projTask:onCreate()
	local taskTypeData = taskTypes:getData(self.taskType)
	
	if taskTypeData.qualityContribution then
		self:setQuality(taskTypeData.qualityContribution)
	end
end

function projTask:_createExtraTasks(list)
	local proj = self.project
	local stage = proj:getTaskStage(self)
	
	for key, taskType in ipairs(list) do
		projectTypes:createAndAddStageTask(proj, taskType, stage)
	end
end

function projTask:setProgressDelay(delay)
	self.progressDelay = delay
end

function projTask:setAssignee(assignee)
	if assignee then
		if self.assignee ~= assignee and self.lastAssignee ~= assignee then
			self:setProgressDelay(projTask.ASSIGN_PROGRESS_DELAY_TIME)
		end
		
		if not self.initDevSkillPractice then
			self:addTrainedSkill("development", developer.PRACTICE_EXP_MIN, developer.PRACTICE_EXP_MAX, developer.PRACTICE_TIME_MIN, developer.PRACTICE_TIME_MAX)
			
			self.initDevSkillPractice = true
		end
	end
	
	if not assignee then
		self.lastAssignee = self.assignee
	end
	
	self.assignee = assignee
	self.specBoost = 1
	
	if assignee then
		self.team = assignee:getTeam()
		self.devBoosts = assignee:getDevSpeedBoosts()
		
		self:updateSpecializationBoost()
		self:queueProgressUpdate()
	else
		self.team = nil
	end
	
	for key, practice in ipairs(self.trainedSkills) do
		practice:setAssignee(assignee)
	end
	
	self:onSetAssignee()
end

function projTask:updateSpecializationBoost()
	local specBoost = self.taskTypeData.specBoost
	
	if specBoost then
		local specID = self.assignee:getSpecialization()
		
		if specID == specBoost.id then
			self.specBoost = specBoost.boost
		end
	end
end

function projTask:setQuality(qualityID)
	self.qualityID = qualityID
end

function projTask:onProjectFinished()
	if self.accumulateFixes then
		for id, fixAmount in pairs(self.accumulatedFixes) do
			self.fixedIssues[id] = self.fixedIssues[id] + fixAmount
			self.accumulatedFixes[id] = 0
		end
		
		self.accumulateFixes = false
	end
end

function projTask:getWasFinished()
	return self.wasFinished
end

function projTask:onFinish()
	projTask.baseClass.onFinish(self)
	self.project:onTaskFinished(self)
	
	self.wasFinished = true
	self.lastAssignee = nil
	self.assignee = nil
end

function projTask:getIssueDiscoverChance(baseChance, issueType, discoverer)
	if discoverer then
		local delta = self.devDiscoveredIssues[issueType] - math.round(projTask.MAX_CHANCE_DISCOVERED_ISSUES_AMOUNT * self.projectScale)
		
		if delta > 0 then
			baseChance = math.max(baseChance - delta^(1 + projTask.EXP_INCREASE_PER_OVER_LIMIT * delta) * projTask.FINAL_CHANCE_DEC_MULTIPLIER, projTask.MIN_ISSUE_DISCOVER_CHANCE)
		end
	end
	
	return baseChance
end

function projTask:queueProgressUpdate()
	self.progressUpdateQueue = true
end

function projTask:updateProgressAmount()
	local assignee = self.assignee
	local assigneeTeam = self.team
	local boosts = self.devBoosts
	
	self.progressValue = assignee.speedDevBoost * assigneeTeam.managementBoost * boosts.development * boosts[self.workField] * assignee.driveDevAffector * assignee.traitSpeedModifier * assignee.developSpeedMultiplier * assignee:getDevSpeedAffectorFromNoManagement() * assigneeTeam.teamworkDevSpeedAffector * assignee.officeDevSpeedMult * assigneeTeam.interOfficeMultiplier * assignee.familiarity[self.familiarityID] * self.specBoost * DEV_SPEED_MULTIPLIER
end

function projTask:adjustProgressAmount(assignee, progress)
	return progress * self.progressValue
end

function projTask:setStage(stageID)
	self.stage = stageID
end

function projTask:getStage()
	return self.stage
end

function projTask:progress(delta, progress, assignee)
	if self.progressUpdateQueue then
		self:updateProgressAmount()
		
		self.progressUpdateQueue = false
	end
	
	self.progressDelay = self.progressDelay - delta
	
	if self.progressDelay > 0 then
		return 
	end
	
	for key, practice in ipairs(self.trainedSkills) do
		practice:progress(delta, progress, assignee)
	end
	
	local baseProgress = progress
	
	progress = self:adjustProgressAmount(assignee, progress)
	
	local workField = self.workField
	
	if self.multipleEmployees then
		progress = progress + baseProgress * self.team:getSkillDevSpeedAffector(workField)
	end
	
	local progressTime = self.timeToProgress
	local requiredWork = self.requiredWork
	local progressIncreased = 0
	local proj = self.project
	
	while true do
		if progress > 0 then
			local realProgress = math.min(self.progressTime, progress)
			
			if realProgress == self.progressTime then
				self.progressTime = progressTime
				
				if not self:isWorkOnDone() then
					local oldWork = self.finishedWork
					local newWork = math.min(requiredWork, self.finishedWork + 1)
					
					self.finishedWork = newWork
					
					proj:addCompletion(workField, newWork - oldWork)
					self:onWorkProgressed(realProgress, assignee)
					
					progressIncreased = progressIncreased + 1
				elseif not self:areAllIssuesFixed() then
					if self.fixInProgress then
						self:fixIssue(self.fixInProgress)
					end
					
					self:beginFixingIssue()
				else
					break
				end
			else
				self.progressTime = self.progressTime - realProgress
			end
			
			progress = progress - realProgress
		else
			break
		end
	end
	
	if progressIncreased > 0 then
		self:postWorkProgressed(progressIncreased)
	end
end

function projTask:onWorkProgressed(progress, assignee)
end

function projTask:postWorkProgressed(progressTimes)
end

function projTask:canAssign(assignee)
	if not assignee:getEmployer():isPlayer() then
		return true
	end
	
	if self.taskTypeData.minimumLevel and assignee:getSkillLevel(self.workField) < self.taskTypeData.minimumLevel then
		return false
	end
	
	if self.computerLevelRequirement and assignee:getWorkplace():getProgression() < self.computerLevelRequirement then
		return false, projTask.FAIL_REASONS.LACKS_COMPUTER_HARDWARE
	end
	
	return true
end

function projTask:setProject(project)
	self.noIssues = not project:getOwner():isPlayer()
	self.project = project
	self.projectScale = project:getScale()
	self.familiarityID = self.project:getFamiliarityUniqueID()
end

function projTask:getProject()
	return self.project
end

function projTask:getTargetProject()
	return self.project:getTargetProject()
end

function projTask:save()
	local saved = projTask.baseClass.save(self)
	
	saved.fixedIssues = self.fixedIssues
	saved.discoveredIssues = self.discoveredIssues
	saved.devDiscoveredIssues = self.devDiscoveredIssues
	saved.totalIssues = self.totalIssues
	saved.accumulatedFixes = self.accumulatedFixes
	saved.accumulateFixes = self.accumulateFixes
	saved.boostAttribute = self.boostAttribute
	saved.skillRequirement = self.skillRequirement
	saved.qualityID = self.qualityID
	saved.qualityProgress = self.qualityProgress
	saved.project = self.project:getUniqueID()
	saved.progressDelay = self.progressDelay
	saved.progressTime = self.progressTime
	saved.issueFixTime = self.progressTime
	saved.fixInProgress = self.issueType
	saved.wasFinished = self.wasFinished
	saved.totalDiscoveredIssues = self.totalDiscoveredIssues
	saved.totalFixedIssues = self.totalFixedIssues
	saved.stage = self.stage
	saved.initDevSkillPractice = self.initDevSkillPractice
	saved.accumulatedFixesHistory = self.accumulatedFixesHistory
	
	if self.lastAssignee then
		saved.lastAssignee = self.lastAssignee:getUniqueID()
	end
	
	return saved
end

function projTask:load(data)
	self.fixedIssues = data.fixedIssues
	self.discoveredIssues = data.discoveredIssues
	self.totalIssues = data.totalIssues
	self.accumulatedFixes = data.accumulatedFixes
	
	projTask.baseClass.load(self, data)
	
	self.accumulateFixes = data.accumulateFixes
	self.wasFinished = data.wasFinished
	self.totalDiscoveredIssues = data.totalDiscoveredIssues
	self.totalFixedIssues = data.totalFixedIssues
	self.stage = data.stage
	self.initDevSkillPractice = data.initDevSkillPractice
	self.accumulatedFixesHistory = data.accumulatedFixesHistory
	
	if data.lastAssignee then
		self.lastAssignee = self.project:getOwner():getEmployeeByUniqueID(data.lastAssignee)
	end
	
	self.devDiscoveredIssues = data.devDiscoveredIssues
	self.boostAttribute = data.boostAttribute
	self.skillRequirement = data.skillRequirement
	self.qualityID = data.qualityID
	self.qualityProgress = data.qualityProgress
	self.progressDelay = data.progressDelay
	self.progressTime = data.progressTime
	self.issueFixTime = data.progressTime
	self.fixInProgress = data.issueType
end

task:registerNew(projTask, "progress_bar_task")

project.TASK_CLASS = projTask
