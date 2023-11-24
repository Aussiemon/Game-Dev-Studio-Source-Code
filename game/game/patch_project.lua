patchProject = {}
patchProject.mtindex = {
	__index = patchProject
}
patchProject.PROJECT_TYPE = "gamePatch"
patchProject.projectType = patchProject.PROJECT_TYPE
patchProject.EVENTS = {
	FINISHED = events:new(),
	CANCELLED = events:new()
}

setmetatable(patchProject, project.mtindex)

function patchProject.new(owner)
	local new = {}
	
	setmetatable(new, patchProject.mtindex)
	new:init(owner)
	
	return new
end

function patchProject:init(owner)
	project.init(self, owner)
	
	self.fixedIssues = {}
	self.totalFixedIssues = 0
end

function patchProject:setPatchedProject(projectObject)
	self.patchedProject = projectObject
	
	local stage = projectObject:getStageObject(2)
	
	if stage then
		table.insert(self.stages, stage)
		
		local wasPresent = true
		
		if not self.totalFixedIssuesAtBeginning then
			self.totalFixedIssuesAtBeginning = 0
			wasPresent = false
		end
		
		for key, taskObject in ipairs(stage:getTasks()) do
			if taskObject:canHaveIssues() then
				taskObject:setAccumulateFixes(true)
				
				if not wasPresent then
					for type, amount in pairs(taskObject:getFixedIssues()) do
						self.totalFixedIssuesAtBeginning = self.totalFixedIssuesAtBeginning + amount
					end
				end
			end
		end
	end
end

function patchProject:verifyName()
	self.validName = true
end

function patchProject:setupInfoDescbox(descBox, wrapW)
	descBox:addText(_T("QA_TOTAL_ISSUES", "Remaining unfixed issues:"), "bh20", nil, 10, wrapW)
	
	local idxs = #issues.registered
	
	for key, data in ipairs(issues.registered) do
		local count = self:getDiscoveredUnfixedIssueCount(data.id)
		
		if count > 0 then
			descBox:addText(_format("TYPE - AMOUNT", "TYPE", data.display, "AMOUNT", count), "bh16", nil, key < idxs and 3 or 0, wrapW, data.icon, 20, 20)
		end
	end
end

function patchProject:getDiscoveredUnfixedIssueCount(type)
	return self.patchedProject:getDiscoveredUnfixedIssueCount(type)
end

function patchProject:getFamiliarityUniqueID()
	return self.patchedProject:getFamiliarityUniqueID()
end

function patchProject:onFixIssue(issueType)
	self.fixedIssues[issueType] = (self.fixedIssues[issueType] or 0) + 1
	self.totalFixedIssues = self.totalFixedIssues + 1
end

function patchProject:getFixedIssues()
	return self.fixedIssues
end

function patchProject:getPatchedProject()
	return self.patchedProject
end

function patchProject:releasePatchCallback()
	self.project:finish()
end

function patchProject:cancelPatchCallback()
	self.project:cancel()
end

function patchProject:fillInteractionComboBox(comboBox)
	if self.totalFixedIssues > 0 then
		comboBox:addOption(0, 0, 0, 24, _T("RELEASE_PATCH", "Release patch"), fonts.get("pix20"), patchProject.releasePatchCallback).project = self
	end
	
	if not self.team then
		local option = comboBox:addOption(0, 0, 0, 24, _T("ASSIGN_TEAM", "Assign team"), fonts.get("pix20"), gameProject.assignTeamCallback)
		
		option.project = self
		option.titleText = _T("SELECT_PATCH_DEV_TEAM", "Select patch dev team")
	else
		local option = comboBox:addOption(0, 0, 0, 24, _T("CHANGE_TEAM", "Change team"), fonts.get("pix20"), gameProject.assignTeamCallback)
		
		option.project = self
		option.titleText = _T("SELECT_PATCH_DEV_TEAM", "Select patch dev team")
	end
	
	comboBox:addOption(0, 0, 0, 24, _T("CANCEL_PATCH", "Cancel patch"), fonts.get("pix20"), patchProject.cancelPatchCallback).project = self
end

function patchProject:setProjectType(projectType, skipStageCreation)
end

function patchProject:getPatchProgress()
	local total, pending = 0, 0
	
	for key, taskObject in ipairs(self.stages[1].tasks) do
		if taskObject:accumulatesFixes() then
			local discoveredIssues = taskObject:getDiscoveredIssues()
			local fixedIssues = taskObject:getFixedIssues()
			local accumulatedFixes = taskObject:getAccumulatedFixes()
			
			for key, data in ipairs(issues.registered) do
				total = total + discoveredIssues[data.id]
				pending = pending + fixedIssues[data.id] + accumulatedFixes[data.id]
			end
		end
	end
	
	return (pending - self.totalFixedIssuesAtBeginning) / (total - self.totalFixedIssuesAtBeginning)
end

function patchProject:getName()
	return self.patchedProject:getName()
end

function patchProject:getTargetProject()
	return self.patchedProject
end

function patchProject:setStage(stage)
	if self.team then
		self.team:unassignEmployees()
	end
	
	if self.stage ~= stage then
		for key, task in ipairs(self.stages[stage]:getTasks()) do
			task:onBeginWork()
		end
	end
	
	self.stage = stage
	self.stageObject = self.stages[self.stage]
	
	if self.team then
		self.team:assignFreeEmployees()
	end
end

function patchProject:isLastStage()
	return true
end

function patchProject:isDone()
	return self:isStageDone(1)
end

function patchProject:cancel()
	for key, taskObj in ipairs(self.stages[1]:getTasks()) do
		taskObj:revertAccumulatedFixes()
	end
	
	if self.team then
		self.team:setProject(nil)
		self:setTeam(nil)
	end
	
	self.patchedProject:cancelPatch()
	events:fire(patchProject.EVENTS.CANCELLED, self)
end

function patchProject:setTeam(teamObj)
	project.setTeam(self, teamObj)
end

eventBoxText:registerNew({
	id = "finished_patch",
	getText = function(self, data)
		return _format(_T("GAME_FINISHED_FIXING_ISSUES", "Finished fixing issues present in 'GAME'!"), "GAME", data)
	end
})
eventBoxText:registerNew({
	id = "released_patch",
	getText = function(self, data)
		return _format(_T("GAME_PATCH_FINISHED", "Finished & released patch for 'GAME'!"), "GAME", data)
	end
})

function patchProject:onFinish()
	project.onFinish(self)
	self.patchedProject:finishCreatingPatch()
	
	if not self.patchedProject:getReleaseDate() then
		game.addToEventBox("finished_patch", self.patchedProject:getName(), 1)
	else
		game.addToEventBox("released_patch", self.patchedProject:getName(), 1)
	end
	
	events:fire(patchProject.EVENTS.FINISHED, self)
end

function patchProject:shouldSaveTasks()
	return false
end

function patchProject:shouldLoadTasks()
	return false
end

function patchProject:shouldAddToProjectList()
	return false
end

function patchProject:save()
	local saved = project.save(self)
	
	saved.totalFixedIssuesAtBeginning = self.totalFixedIssuesAtBeginning
	saved.patchedProject = self.patchedProject:getUniqueID()
	saved.totalFixedIssues = self.totalFixedIssues
	saved.fixedIssues = self.fixedIssues
	
	return saved
end

function patchProject:load(data)
	self.patchedProject = data.patchedProject
	
	self:setPatchedProject(self.owner:getProjectByUniqueID(self.patchedProject))
	project.load(self, data)
	
	self.totalFixedIssuesAtBeginning = data.totalFixedIssuesAtBeginning or self.totalFixedIssuesAtBeginning
	self.totalFixedIssues = data.totalFixedIssues or self.totalFixedIssues
	self.fixedIssues = data.fixedIssues or self.fixedIssues
end

function patchProject:postLoad()
end
