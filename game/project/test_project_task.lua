local testProjectTask = {}

testProjectTask.id = "test_project_task"
testProjectTask.testInterval = {
	max = 0.75,
	min = 0.5
}

function testProjectTask:init()
	testProjectTask.baseClass.init(self)
	self:addTrainedSkill("testing")
end

function testProjectTask:setAssignee(ass)
	self.assignee = ass
	
	if self.assignee then
		self.project:changeTesters(1)
	else
		self.project:changeTesters(-1)
	end
	
	for key, taskObj in ipairs(self.trainedSkills) do
		taskObj:setAssignee(self.assignee)
	end
	
	self:onSetAssignee()
end

function testProjectTask:cancel()
	testProjectTask.baseClass.cancel(self)
	self.project:changeTesters(-1)
end

function testProjectTask:onProjectScrapped(scrappedProj)
	if scrappedProj == self.project then
		self.assignee:cancelTask()
	end
end

function testProjectTask:canReassign()
	return false
end

function testProjectTask:setStage(stageIndex)
	self.stageIndex = stageIndex
	self.tasks = self.project:getStageObject(self.stageIndex):getTasks()
	
	self:rollTestInterval()
end

function testProjectTask:setProject(project)
	self.project = project
	
	self:setText(self:getName())
end

function testProjectTask:getProject()
	return self.project
end

function testProjectTask:setTestSessions(sessions)
	self.initialSessions = sessions
	self.testSessions = sessions
end

function testProjectTask:getTaskTypeText()
	return ""
end

function testProjectTask:rollTestInterval()
	self.testingTime = math.randomf(self.testInterval.min, self.testInterval.max)
	self.timeToTest = self.testingTime
end

function testProjectTask:getIssueDiscoverChance(baseChance, type, assignee)
	return self.randomTask:getIssueDiscoverChance(baseChance, type, assignee)
end

function testProjectTask:canHaveIssues()
	if self.randomTask then
		return self.randomTask:canHaveIssues()
	end
	
	return false
end

function testProjectTask:pickRandomTask()
	local randomTask = self.tasks[math.random(1, #self.tasks)]
	
	if randomTask:canHaveIssues() then
		self.randomTask = randomTask
	else
		self.randomTask = nil
	end
end

function testProjectTask:getRandomUnfixedIssue()
	local result = self.randomTask:getRandomUnfixedIssue()
	
	if not result then
		self.randomTask = nil
	end
	
	return result
end

function testProjectTask:discoverIssue(type, devDiscovered)
	self.randomTask:discoverIssue(type, devDiscovered)
	
	self.randomTask = nil
end

function testProjectTask:progress(delta, progress, assignee)
	local residue = self.timeToTest - progress
	
	self.timeToTest = residue
	
	if self.testSessions == 0 then
		return true
	end
	
	for key, taskObj in ipairs(self.trainedSkills) do
		taskObj:progress(delta, progress, assignee)
	end
	
	while residue <= 0 do
		self.testSessions = self.testSessions - 1
		
		self:pickRandomTask()
		issues:attemptDetectIssue(self, assignee, 1)
		
		if self.testSessions == 0 then
			break
		else
			residue = residue + self.timeToTest
			
			if residue > 0 then
				self.timeToTest = residue
				
				break
			else
				self:rollTestInterval()
			end
		end
	end
	
	return self.testSessions == 0
end

function testProjectTask:isDone()
	return self.testSessions <= 0
end

function testProjectTask:getCompletion()
	return 1 - self.testSessions / self.initialSessions
end

function testProjectTask:getName()
	return _format(_T("TESTING_PROJECT", "Testing 'PROJECT'"), "PROJECT", self.project:getName())
end

function testProjectTask:save()
	local saved = testProjectTask.baseClass.save(self)
	
	saved.timeToTest = self.timeToTest
	saved.testSessions = self.testSessions
	saved.project = self.project:getUniqueID()
	saved.stageIndex = self.stageIndex
	saved.testingTime = self.testingTime
	saved.initialSessions = self.initialSessions
	
	return saved
end

function testProjectTask:load(data, assignee)
	testProjectTask.baseClass.load(self, data)
	
	self.timeToTest = data.timeToTest
	self.testSessions = data.testSessions
	self.testingTime = data.testingTime
	self.initialSessions = data.initialSessions or self.testSessions
	
	self:setProject(assignee:getEmployer():getProjectByUniqueID(data.project))
	self:setStage(data.stageIndex)
end

task:registerNew(testProjectTask, "progress_bar_task")
