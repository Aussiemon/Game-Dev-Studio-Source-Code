local gameTask = {}

gameTask.id = "game_task"
gameTask.BASE_EASE_OF_USE_AFFECTOR = -40
gameTask.EASE_OF_USE_MULTIPLIER = 0.005
gameTask.SKILL_TO_QUALITY = 0.003
gameTask.FEATURE_QUALITY_POINT_CONTRIBUTION = 1
gameTask.GAME_SCALE_TO_EXTRA_QUALITY_MULTIPLIER = 1
gameTask.MAX_QUALITY_CONTRIBUTION = 50
gameTask.timeToProgress = 1

local projectTask = task:getData("project_task")

function gameTask:onFinish()
	if not self.wasFinished then
		local data = taskTypes:getData(self.taskType)
		local quality = data:getGameQualityPointIncrease(self.project)
		
		if quality then
			local scaler = self:getProjectScaleScoreMultiplier(self.project) * self.project:getCategoryPriority(self.taskTypeData.category)
			
			for qualityType, amount in pairs(quality) do
				local totalQuality = amount * scaler
				
				self.project:addQualityPoint(qualityType, totalQuality, false, nil, self.taskTypeData.id)
			end
		end
		
		data:applyContentPoints(self.project)
	end
	
	projectTask.onFinish(self)
	self.project:addFeature(self.taskType)
end

function gameTask:onCreate()
	gameTask.baseClass.onCreate(self)
	
	self.knowledgeContributed = 0
end

function gameTask:getProjectScaleScoreMultiplier(gameProj)
	return 1 + (gameProj:getScale() - project.SCALE_MIN) * gameTask.GAME_SCALE_TO_EXTRA_QUALITY_MULTIPLIER
end

function gameTask:setAssignee(...)
	self.progressMultiplier = (1 + (gameTask.BASE_EASE_OF_USE_AFFECTOR + self.project:getEngine():getStat("easeOfUse")) * gameTask.EASE_OF_USE_MULTIPLIER) * self.project:getDevelopmentSpeedMultiplier()
	
	gameTask.baseClass.setAssignee(self, ...)
	
	if self.assignee then
		self.team = self.assignee:getTeam()
		
		local owner = self.team:getOwner()
		
		self.teamKnowledge = owner:getCollectiveKnowledge()
		self.employeeCount = #owner:getEmployees()
	else
		self.team = nil
		self.teamKnowledge = nil
		self.employeeCount = nil
	end
end

function gameTask:setupRequiredWork()
	local total, platformPoints = self:calculateRequiredWork(self.taskTypeData, self.project)
	
	self:setRequiredWork(total)
	
	self.platformWorkAffector = platformPoints / total + 1
end

gameTask.setProject = projectTask.setProject

function gameTask:setProject(projectObject)
	projectTask.setProject(self, projectObject)
end

function gameTask:setTaskType(data)
	gameTask.baseClass.setTaskType(self, data)
	
	if self.project then
		self.project:setupPointContribution(self.taskTypeData.id)
		self:setupKnowledgeContributionList()
	end
end

function gameTask:setupKnowledgeContributionList()
	if self.taskTypeData.knowledgeContribution then
		local subData = self.taskTypeData.knowledgeContribution[self.project:getGenre()]
		
		if subData then
			self.knowledgeContributors = subData[self.project:getTheme()]
		end
	end
end

function gameTask:updateProgressAmount()
	projectTask.updateProgressAmount(self)
	
	self.progressValue = self.progressValue * self.progressMultiplier
end

function gameTask:onWorkProgressed(progress, assignee)
end

function gameTask:postWorkProgressed(progressAmount)
	if self.qualityID then
		self.project:addQualityPoint(self.qualityID, self:getQualityIncreaseAmount() * progressAmount, true, nil, self.taskTypeData.id)
	end
	
	local assignee = self.assignee
	
	issues:attemptGenerateIssue(self, assignee, progressAmount)
	
	if issues:attemptDetectIssue(self, assignee, progressAmount) then
		self:validateIssueState()
	end
end

function gameTask:getQualityIncreaseAmount()
	local prevContr = self.knowledgeContributed
	local contribution = 0
	local proj = self.project
	local teamKnow, qualityID = self.teamKnowledge, self.qualityID
	
	if self.taskTypeData.directKnowledgeContribution then
		contribution = contribution + self.taskTypeData:applyKnowledgeContribution(proj, teamKnow, qualityID)
	end
	
	if self.knowledgeContributors then
		self.taskTypeData:applyGenreThemeKnowledgeBoost(proj, self.knowledgeContributors, teamKnow, qualityID)
	end
	
	self.knowledgeContributed = math.min(gameTask.MAX_QUALITY_CONTRIBUTION * proj:getScale(), prevContr + contribution)
	
	local increase = self.assignee:getSkillLevel(self.workField) * gameTask.SKILL_TO_QUALITY / self.platformWorkAffector + (self.knowledgeContributed - prevContr)
	
	return increase
end

function gameTask:getSkillQualityIncrease(skillLevel)
	return skillLevel * gameTask.SKILL_TO_QUALITY
end

function gameTask:save()
	local saved = gameTask.baseClass.save(self)
	
	saved.categoryPriority = self.categoryPriority
	saved.knowledgeContributed = self.knowledgeContributed
	saved.platformWorkAffector = self.platformWorkAffector
	
	return saved
end

gameTask.SUBGENRE_EXTRA_WORK = 1.15

function gameTask:calculateRequiredWork(taskTypeData, projectObject)
	local final = taskTypeData.workAmount * projectObject:getScale() * projectObject:getCategoryPriority(taskTypeData.category)
	local platformPoints = math.ceil(final * taskTypeData:getPlatformWorkAmountAffector(projectObject))
	
	final = final + platformPoints
	
	if projectObject:getSubgenre() then
		final = final * gameTask.SUBGENRE_EXTRA_WORK
	end
	
	return math.ceil(final), platformPoints
end

function gameTask:load(data)
	gameTask.baseClass.load(self, data)
	
	self.categoryPriority = data.categoryPriority
	self.knowledgeContributed = data.knowledgeContributed
	self.platformWorkAffector = data.platformWorkAffector or 1
	
	if self.project then
		self.project:setupPointContribution(self.taskTypeData.id)
	end
end

task:registerNew(gameTask, "engine_task")

gameProject.TASK_CLASS = gameTask
