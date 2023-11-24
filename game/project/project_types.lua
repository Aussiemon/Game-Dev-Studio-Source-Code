projectTypes = {}
projectTypes.registered = {}
projectTypes.registeredByCategory = {}
projectTypes.registeredByID = {}

function projectTypes:registerNew(data)
	table.insert(projectTypes.registered, data)
	
	projectTypes.registeredByID[data.id] = data
	projectTypes.registeredByCategory[data.category] = projectTypes.registeredByCategory[data.category] or {}
	
	table.insert(projectTypes.registeredByCategory[data.category], data)
end

function projectTypes:getProjectStages(typeID)
	return projectTypes.registeredByID[typeID].stages
end

function projectTypes:getProjectType(typeID)
	return projectTypes.registeredByID[typeID]
end

function projectTypes:createStageTasks(proj, stage)
	stage = stage or proj:getStage()
	
	local stages = proj:getProjectStages()
	local curStage = stages[stage]
	
	if curStage.onAttemptCreateStageTasks then
		curStage:onAttemptCreateStageTasks(proj)
	end
	
	self:createMandatoryStageTasks(proj, stage)
	
	for key, taskData in ipairs(curStage.tasks) do
		self:createAndAddStageTask(proj, taskData.type, stage)
	end
	
	if curStage.postAttemptCreateStageTasks then
		curStage:postAttemptCreateStageTasks(proj)
	end
end

function projectTypes:createAndAddStageTask(projObj, taskType, stage, taskID)
	local newTask = self:createStageTask(taskType, taskID, projObj)
	
	newTask:onCreate()
	projObj:addTask(newTask, stage)
	
	return newTask
end

function projectTypes:createStageTask(taskType, taskID, projObj)
	local taskTypeData = taskTypes:getData(taskType)
	
	if not projObj then
		error("attempt to create stage task without a provided project object")
	end
	
	local newTask = task.new(taskID or taskTypeData.taskID)
	
	newTask:setProject(projObj)
	newTask:setTaskType(taskType)
	newTask:setText(taskTypeData.display)
	
	return newTask
end

local existingStageTasks = {}

function projectTypes:createMandatoryStageTasks(proj, stage)
	stage = stage or proj:getStage()
	
	local taskCategories = proj:getMandatoryStageTasks(stage)
	
	if taskCategories then
		local allStages = proj:getCurrentStages()
		local stageObject = allStages[stage]
		local stageTasks = stageObject:getTasks()
		
		for key, taskObj in ipairs(stageTasks) do
			existingStageTasks[taskObj.taskType] = true
		end
		
		if taskCategories then
			for key, category in ipairs(taskCategories) do
				local tasks = taskTypes:getTasksByCategory(category)
				
				if tasks then
					for key, taskData in ipairs(tasks) do
						if not existingStageTasks[taskData.id] then
							self:createAndAddStageTask(proj, taskData.id, stage)
						end
					end
				end
			end
		end
		
		table.clear(existingStageTasks)
	end
end
