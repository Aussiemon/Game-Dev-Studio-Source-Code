project = {}
project.mtindex = {
	__index = project
}
project.EVENTS = {
	STAGE_COMPLETE = events:new(),
	NEW_STAGE = events:new(),
	PROJECT_COMPLETE = events:new(),
	BEGIN_WORK = events:new(),
	LOADED_PROJECT = events:new(),
	SCRAPPED_PROJECT = events:new(),
	TEAM_UNASSIGNED = events:new(),
	TEAM_ASSIGNED = events:new(),
	DESIRED_TEAM_SET = events:new(),
	DESIRED_TEAM_UNSET = events:new(),
	NAME_SET = events:new()
}
project.ON_FINISHED_FIRE_EVENT = project.EVENTS.PROJECT_COMPLETE
project.SCALE = {
	HUGE = 4,
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3
}
project.PROJECT_TYPE = "miscellaneous"
project.SCALE_MIN = 1
project.SCALE_MAX = 20
project.SCALE_TRANSLATIONS = {
	[project.SCALE.SMALL] = _T("PROJECT_SCALE_SMALL", "Small-scale project"),
	[project.SCALE.MEDIUM] = _T("PROJECT_SCALE_MEDIUM", "Medium-scale project"),
	[project.SCALE.LARGE] = _T("PROJECT_SCALE_LARGE", "Large-scale project"),
	[project.SCALE.HUGE] = _T("PROJECT_SCALE_HUGE", "Huge project")
}

function project.new()
	local new = {}
	
	setmetatable(new, project.mtindex)
	new:init()
	
	return new
end

function project:init(owner)
	self.stages = {}
	self.facts = {}
	self.requiredWork = {}
	self.finishedWork = {}
	self.totalRequiredWork = 0
	self.totalFinishedWork = 0
	self.owner = owner
	self.timeLimit = nil
	self.reward = 0
	self.penalty = 0
	self.scale = 1
	self.stage = 1
	self.lastFinishedStage = 0
	self.daysWorkedOn = 0
	self.moneySpent = 0
end

function project:setupInfoDescbox()
end

function project:getTargetProject()
	return self
end

function project:onCreateIssue(issueType)
end

function project:onDiscoverIssue(issueType, taskObject)
	self.stages[taskObject:getStage()]:onDiscoverIssue()
end

function project:onFixIssue(issueType, taskObject)
	self.stages[taskObject:getStage()]:onFixIssue()
end

function project:setOwner(owner)
	self.owner = owner
end

function project:getOwner()
	return self.owner
end

function project:isPlayerOwned()
	return self.owner == studio
end

function project:setFact(fact, value)
	local t = type(value)
	
	if t == "function" or t == "userdata" then
		error("attempt to set a fact of type " .. type)
	end
	
	self.facts[fact] = value
end

function project:getFact(fact)
	return self.facts[fact]
end

function project:removeFact(fact)
	self.facts[fact] = nil
end

function project:getTaskStage(taskObj)
	for stageNumber, stage in ipairs(self.stages) do
		for taskKey, task in ipairs(stage:getTasks()) do
			if task == taskObj then
				return stageNumber, taskKey
			end
		end
	end
end

function project:hasAtLeastOneTask()
	for stageNumber, stage in ipairs(self.stages) do
		if #stage:getTasks() > 0 then
			return true
		end
	end
	
	return false
end

function project:setDaysWorkedOn(days)
	self.daysWorkedOn = days
end

function project:getDaysWorkedOn()
	return self.daysWorkedOn
end

function project:handleEvent(event)
	if event == timeline.EVENTS.NEW_DAY then
		self.daysWorkedOn = self.daysWorkedOn + 1
	end
end

function project:areAllStagesDone()
	for key, stage in ipairs(self.stages) do
		for key, task in ipairs(stage:getTasks()) do
			if not task:isDone() then
				return false
			end
		end
	end
	
	return true
end

function project:areSpecificStagesDone(...)
	for i = 1, select("#", ...) do
		if not self:isStageDone(select(i, ...)) then
			return false
		end
	end
	
	return true
end

function project:getFamiliarityUniqueID()
	return self.uniqueID
end

project.teamInfoDescboxID = "project_info_descbox"

function project:createTeamAssignmentMenu(confirmButtonClass, confirmButtonText, titleText)
	titleText = titleText or _format(_T("SELECT_TEAM_FOR_PROJECT", "Select team for 'PROJECT'"), "PROJECT", self.name)
	
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(titleText)
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(32))
	scrollbar:setSize(frame.rawW - 10, frame.rawH - (_US(frame:getFont():getHeight()) + 45))
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	
	local category = gui.create("Category")
	
	category:setHeight(30)
	category:setFont(fonts.get("pix24"))
	category:setText(_T("ALL_TEAMS", "All teams"))
	category:assumeScrollbar(scrollbar)
	
	confirmButtonClass = confirmButtonClass or "ProjectTeamSelectionConfirmation"
	
	local confirmButton = gui.create(confirmButtonClass, frame)
	
	confirmButton:setPos(_S(5), scrollbar.h + scrollbar.y + _S(3))
	confirmButton:setSize(frame.rawW - 10, 30)
	confirmButton:setFont(fonts.get("pix24"))
	confirmButton:setProject(self)
	confirmButton:setText(confirmButtonText)
	scrollbar:addItem(category)
	
	for key, teamObj in ipairs(self.owner:getTeams()) do
		local element = gui.create("ProjectTeamSelection")
		
		element:setSize(scrollbar.rawW - 10, 30)
		element:setConfirmationButton(confirmButton)
		element:setProject(self)
		element:setTeam(teamObj)
		element:updateDescbox()
		category:addItem(element)
	end
	
	frame:center()
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(project.teamInfoDescboxID)
	teamDescbox:tieVisibilityTo(frame)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	frameController:push(frame)
end

function project:getTaskByID(taskTypeID)
	for key, stageObj in ipairs(self.stages) do
		for key, taskObj in ipairs(stageObj:getTasks()) do
			if taskObj:getTaskType() == taskTypeID then
				return taskObj
			end
		end
	end
end

function project:isStageDone(stage)
	stage = stage or self.stage
	
	return self.stages[stage]:isDone()
end

function project:getDevType()
	return self.curDevType
end

function project:unassignTeam()
	if self.team then
		self.team:unassignEmployees(true)
		self.team:setProject(nil)
		self:setTeam(nil)
	end
end

function project:setDesiredTeam(teamObj)
	local prevTeam = self.desiredTeam
	
	self.desiredTeam = teamObj
	
	if prevTeam and not teamObj then
		events:fire(project.EVENTS.DESIRED_TEAM_UNSET, self, prevTeam)
	elseif teamObj then
		events:fire(project.EVENTS.DESIRED_TEAM_SET, self, teamObj)
	end
end

function project:getDesiredTeam()
	return self.desiredTeam
end

function project:setTeam(teamObj)
	if not teamObj and self.team then
		self.lastAssignedTeam = self.team:getUniqueID()
		
		events:fire(project.EVENTS.TEAM_UNASSIGNED, self, self.team)
	elseif teamObj then
		events:fire(project.EVENTS.TEAM_ASSIGNED, self, teamObj)
	end
	
	self.team = teamObj
end

function project:removeEventReceiver()
	events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function project:addEventReceiver()
	events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function project:scrap()
	self.scrapped = true
	
	if self.team then
		self.team:scrapProject()
	end
	
	self.owner:removeProject(self)
	self:removeEventReceiver()
	events:fire(project.EVENTS.SCRAPPED_PROJECT, self)
end

function project:isScrapped()
	return self.scrapped
end

function project:getTeam()
	return self.team
end

function project:getLastAssignedTeam()
	return self.lastAssignedTeam
end

function project:isAssignedToTeam()
	return self.team ~= nil or self.desiredTeam ~= nil
end

function project:isLastStage()
	return self.projectStages[self.stage + 1] == nil
end

function project:isDone()
	if not self:isLastStage() then
		return false
	end
	
	return self:isStageDone(#self.projectStages)
end

function project:hasTask(taskObj, stage)
	if not stage then
		for iterStage = 1, #self.stages do
			if self:_hasTask(taskObj, self.stages[iterStage]) then
				return true
			end
		end
	elseif self:_hasTask(taskObj, self.stages[stage]) then
		return true
	end
	
	return false
end

function project:assignUniqueID(uniqueID)
	if self.uniqueID then
		return 
	end
	
	self.uniqueID = uniqueID or game.assignUniqueProjectID()
end

function project:getUniqueID()
	return self.uniqueID
end

function project:_hasTask(taskObj, stageObject)
	for key, curTask in ipairs(stageObject:getTasks()) do
		if curTask == taskObj then
			return true
		end
	end
	
	return nil
end

function project:setProjectType(projectType, skipStageCreation)
	if not projectType then
		return 
	end
	
	self.projectType = projectType
	self.projectStages = projectTypes:getProjectStages(projectType)
	
	if not skipStageCreation and #self.stages == 0 then
		for key, value in ipairs(self.projectStages) do
			table.insert(self.stages, devStage.new())
		end
	end
end

function project:addStage()
	table.insert(self.stages, devStage.new())
end

function project:getCurrentTasks()
	return self.stages[self.stage]:getTasks()
end

function project:getCurrentStages()
	return self.stages
end

function project:getCurrentStage()
	return self.stages[self.stage]
end

function project:getStageObject(stageID)
	return self.stages[stageID]
end

function project:getStageTasks(stage)
	stage = stage or self.stage
	
	return self.projectStages[stage].tasks
end

function project:getProjectType()
	return self.projectType
end

function project:getProjectStages()
	return self.projectStages
end

function project:onTaskFinished(taskObject)
end

function project:getStage()
	return self.stage, self.stageObject
end

function project:createStageTasks()
	if not self.createdStageTasks then
		for i = 1, #self.stages do
			projectTypes:createStageTasks(self, i)
		end
		
		self.createdStageTasks = true
	end
end

function project:setStage(stage)
	self:createStageTasks()
	
	if self.stage ~= stage then
		for key, task in ipairs(self.stages[stage]:getTasks()) do
			task:onBeginWork()
		end
	end
	
	self.stage = stage
	self.stageObject = self.stages[stage]
	
	if self.team then
		self.team:assignFreeEmployees()
	end
end

function project:advanceStage()
	events:fire(project.EVENTS.STAGE_COMPLETE, self)
	
	self.lastFinishedStage = math.max(self.lastFinishedStage, self.stage)
	
	self:setStage(self.stage + 1)
	events:fire(project.EVENTS.NEW_STAGE, self)
end

function project:removeStageTasks(stage)
	stage = stage or 1
	
	local stageObj = self.stages[stage]
	local tasks = stageObj:getTasks()
	
	for key, task in ipairs(tasks) do
		task:remove()
		
		tasks[key] = nil
	end
	
	stageObj:resetWorkData()
end

function project:getStageCompletion()
	return self.stages[self.stage]:getCompletion()
end

function project:getTotalFinishedWork()
	return self.totalFinishedWork
end

function project:getOverallCompletion()
	return self.totalFinishedWork / self.totalRequiredWork
end

function project:getWorkRemainder()
	return self.totalRequiredWork - self.totalFinishedWork
end

function project:getTotalRequiredWork()
	return self.totalRequiredWork
end

function project:getRealDevType()
	return self.devType
end

function project:resetCompletion()
	self.totalFinishedWork = 0
	self.totalRequiredWork = 0
end

function project:getCompletion()
	return self.totalFinishedWork / self.totalRequiredWork
end

function project:isFinished()
	local completion = self:getOverallCompletion()
	
	return completion >= 1, completion
end

function project:getStageTasksWorkInfo(tasks)
	local totalRequiredProgress, totalProgress, completedTasks, uncompletedTasks = 0, 0, 0, 0
	
	for key, task in ipairs(tasks) do
		totalRequiredProgress = totalRequiredProgress + task:getRequiredWork()
		totalProgress = totalProgress + task:getFinishedWork()
		
		if task:isWorkOnDone() then
			completedTasks = completedTasks + 1
		else
			uncompletedTasks = uncompletedTasks + 1
		end
	end
	
	return totalProgress, totalRequiredProgress, completedTasks, uncompletedTasks
end

function project:isStageCompleted()
	return self:getStageCompletion() == 1
end

function project:getMandatoryStageTasks()
	return nil
end

function project:isProjectCompleted()
	return self:getOverallCompletion() == 1
end

local missingStuff = {}

function project:getMissingSelectionTextTable()
	return missingStuff
end

function project:setTimeLimit(time)
	self.timeLimit = time
end

function project:getTimeLimit()
	return self.timeLimit
end

function project:setReward(reward)
	self.reward = reward
end

function project:getReward()
	return self.reward
end

function project:setPenalty(penalty)
	self.penalty = penalty
end

function project:getPenalty(penalty)
	return self.penalty
end

function project:fail()
	if self.penalty > 0 then
		self.owner:deductFunds(self.penalty, nil, "penalties")
	end
end

function project:succeed()
	if self.reward > 0 then
		self.owner:addFunds(self.reward)
	end
end

function project:setScale(scale)
	self.scale = scale
end

function project:getScale()
	return self.scale
end

function project:verifyStage(stageID)
	if not self.stages[stageID] then
		self.stages[stageID] = devStage.new()
		
		return false
	end
	
	return true
end

function project:getTaskClass()
	return self.TASK_CLASS
end

function project:addTask(task, stageID)
	task:setStage(stageID)
	task:setProject(self)
	task:setupRequiredWork()
	self.stages[stageID]:addTask(task)
	
	local workField = task:getWorkField()
	local requiredWork = task:getRequiredWork()
	
	if not self.requiredWork[workField] then
		self.requiredWork[workField] = requiredWork
		self.finishedWork[workField] = 0
	else
		self.requiredWork[workField] = self.requiredWork[workField] + requiredWork
	end
	
	self.totalRequiredWork = self.totalRequiredWork + requiredWork
end

function project:addRequiredWork(workField, amount)
	self.requiredWork[workField] = self.requiredWork[workField] + amount
	self.totalRequiredWork = self.totalRequiredWork + amount
end

function project:addCompletion(workField, amount)
	self.finishedWork[workField] = self.finishedWork[workField] + amount
	self.totalFinishedWork = self.totalFinishedWork + amount
	
	self.stageObject:addFinishedWork(amount)
end

function project:reset()
	self.reward = nil
	self.penalty = nil
	self.timeLimit = nil
	self.scale = nil
	
	table.clear(self.stages)
end

function project:setName(name)
	self.name = name
	
	self:verifyName()
	events:fire(project.EVENTS.NAME_SET, self)
end

function project:verifyName()
	self.validName = string.withoutspaces(self.name) ~= ""
end

function project:getName(name)
	return self.name
end

function project:hasName()
	return self.name and self.validName
end

function project:changeMoneySpent(change)
	self.moneySpent = self.moneySpent + change
end

function project:getMoneySpent()
	return self.moneySpent
end

function project:progress(dt, pt)
	local stage = self.stages[1]
	
	if self:isStageDone() then
		if not self:isLastStage() then
			self:advanceStage()
		else
			self:finish()
		end
	end
end

function project:onEmployeesReassigned(recentlyFinishedEmployees)
	return false
end

function project:finish()
	self.lastFinishedStage = math.max(self.lastFinishedStage, self.stage)
	
	local canFire = self:canFireFinishedEvent()
	
	if canFire then
		events:fire(project.EVENTS.PROJECT_COMPLETE, self)
	end
	
	self:onFinish()
	
	if canFire then
		events:fire(self.ON_FINISHED_FIRE_EVENT, self)
	end
end

function project:canFireFinishedEvent()
	return true
end

function project:onFinish()
	for key, stageObject in ipairs(self.stages) do
		stageObject:onProjectFinished()
	end
	
	if self.timeLimit then
		self:succeed()
	end
end

function project:beginWork(stage, devType)
	stage = stage or self.stage
	devType = devType or self.devType
	
	self:setStage(stage)
	
	self.devType = devType
	
	self.owner:addProject(self)
	events:fire(project.EVENTS.BEGIN_WORK, self)
end

function project:remove()
	self:removeEventReceiver()
end

function project:shouldAddToProjectList()
	return true
end

function project:shouldSaveTasks()
	return true
end

function project:shouldLoadTasks()
	return true
end

function project:draw()
end

function project:save()
	local saved = {
		name = self.name,
		uniqueID = self.uniqueID,
		stages = {},
		stage = self.stage,
		devType = self.devType,
		team = self.team and self.team:getUniqueID() or nil,
		projectType = self.projectType,
		facts = self.facts,
		scale = self.scale,
		lastAssignedTeam = self.lastAssignedTeam,
		createdStageTasks = self.createdStageTasks,
		scrapped = self.scrapped,
		lastFinishedStage = self.lastFinishedStage,
		moneySpent = self.moneySpent,
		daysWorkedOn = self.daysWorkedOn,
		requiredWork = self.requiredWork,
		finishedWork = self.finishedWork,
		totalRequiredWork = self.totalRequiredWork,
		totalFinishedWork = self.totalFinishedWork
	}
	
	if self:shouldSaveTasks() then
		for key, stage in ipairs(self.stages) do
			table.insert(saved.stages, stage:save())
		end
	end
	
	saved.PROJECT_TYPE = self.PROJECT_TYPE
	
	return saved
end

function project:load(data)
	self.name = data.name
	
	self:verifyName()
	
	self.uniqueID = data.uniqueID
	self.stage = data.stage
	self.devType = data.devType
	self.facts = data.facts
	self.projectType = data.projectType
	self.scale = data.scale or self.scale
	self.createdStageTasks = data.createdStageTasks
	self.lastAssignedTeam = data.lastAssignedTeam
	self.lastFinishedStage = data.lastFinishedStage
	self.moneySpent = data.moneySpent or self.moneySpent
	self.daysWorkedOn = data.daysWorkedOn or self.daysWorkedOn
	self.requiredWork = data.requiredWork or self.requiredWork
	self.finishedWork = data.finishedWork or self.finishedWork
	self.totalRequiredWork = data.totalRequiredWork or self.totalRequiredWork
	self.totalFinishedWork = data.totalFinishedWork or self.totalFinishedWork
	
	if self.owner then
		self.owner:addProject(self)
	end
	
	if data.team then
		self.team = self.owner:getTeamByUniqueID(data.team)
	end
	
	if self:shouldLoadTasks() then
		for key, stageData in ipairs(data.stages) do
			local newStage = devStage.new()
			
			newStage:load(stageData, self)
			table.insert(self.stages, newStage)
		end
	end
	
	self:setProjectType(data.projectType, true)
end

function project:onFinishLoad()
end

require("game/project/project_types")
require("game/project/issues")
require("game/project/stage")
require("game/project/project_task")
require("game/project/test_project_task")
