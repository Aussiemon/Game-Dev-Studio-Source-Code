issues = {}
issues.registered = {}
issues.registeredByID = {}
issues.priority = {}

function issues.prioritySortFunc(a, b)
	return issues.registeredByID[a].priority > issues.registeredByID[b].priority
end

function issues:registerNew(data)
	issues.registered[#issues.registered + 1] = data
	issues.registeredByID[data.id] = data
	data.quad = quadLoader:load(data.icon)
	data.index = #issues.registered
	
	table.clear(self.priority)
	
	for key, data in ipairs(issues.registered) do
		table.insert(self.priority, data.id)
	end
	
	table.sort(self.priority, issues.prioritySortFunc)
end

function issues:getIssueData(issueID)
	return issues.registeredByID[issueID]
end

function issues:initIssues()
	local totalIssues = {}
	local discoveredIssues = {}
	local fixedIssues = {}
	local accumulatedFixes = {}
	
	for key, data in ipairs(issues.registered) do
		totalIssues[data.id] = 0
		discoveredIssues[data.id] = 0
		fixedIssues[data.id] = 0
		accumulatedFixes[data.id] = 0
	end
	
	return totalIssues, discoveredIssues, fixedIssues, accumulatedFixes
end

function issues:getFixTime(issue)
	if type(issue.fixTime) == "table" then
		return math.randomf(issue.fixTime.min, issue.fixTime.max)
	end
	
	return issue.fixTime
end

function issues:attemptGenerateIssue(task, assignee, genRange)
	if task:canHaveIssues() then
		assignee = assignee or task:getAssignee()
		
		local taskTypeData = taskTypes:getData(task:getTaskType())
		local taskIssues = taskTypeData.issues
		
		if taskIssues then
			local issueGenChanceMul = assignee:getIssueGenerateChanceMultiplier()
			local issueList = issues.registeredByID
			local issueCount = #taskIssues
			
			for i = 1, genRange do
				local randomIssue = issueList[taskIssues[math.random(1, issueCount)]]
				local genChance = randomIssue.generateChance
				
				if math.randomf(1, 100) <= genChance * issueGenChanceMul then
					task:addIssue(randomIssue.id)
				end
			end
		end
	end
end

function issues:getIssueDiscoverChance(task, issueType, assignee)
	return task:getIssueDiscoverChance(issues.registeredByID[issueType].discoverChance * assignee:getIssueDiscoverChanceMultiplier(), issueType, assignee)
end

function issues:attemptDetectIssueQA(task, discoverChance)
	local randomIssue = task:getRandomUnfixedIssue()
	
	if randomIssue then
		if discoverChance >= math.random(1, 100) then
			return task:discoverIssue(randomIssue, false)
		else
			return false
		end
	end
	
	return nil
end

function issues:attemptDetectIssue(task, assignee, detectRange)
	if task:canHaveIssues() then
		assignee = assignee or task:getAssignee()
		
		local devDiscoveredIssue = assignee ~= nil
		local issueMap = issues.registeredByID
		
		for i = 1, detectRange do
			local randomIssue = task:getRandomUnfixedIssue()
			
			if randomIssue then
				local issueData = issueMap[randomIssue]
				local detected = false
				
				if math.random(1, 100) <= self:getIssueDiscoverChance(task, randomIssue, assignee) and task:discoverIssue(randomIssue, devDiscoveredIssue) then
					detected = true
				end
				
				return detected
			else
				break
			end
		end
	end
	
	return false
end

require("game/project/issues_types")
