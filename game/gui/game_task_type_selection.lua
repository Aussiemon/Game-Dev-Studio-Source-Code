local gameTaskType = {}
local concat = {}

gameTaskType.relatedGamePanelColor = color(229, 153, 98, 255)

function gameTaskType:getPanelFillColor()
	if self:hasPrequelFeature() then
		return gameTaskType.relatedGamePanelColor
	end
	
	return gameTaskType.baseClass.getPanelFillColor(self)
end

function gameTaskType:hasPrequelFeature()
	local preq = self.prequel
	
	return preq and preq:hasFeature(self.taskData.id)
end

function gameTaskType:setProject(project)
	gameTaskType.baseClass.setProject(self, project)
	
	self.prequel = self.project:getSequelTo()
end

function gameTaskType:setupWorkAmountDisplay(descBox, maxWidth)
	self.workFields = self.workFields or {}
	self.polishTask = task:getData("polish_project_task")
	self.totalWorkAmount = 0
	self.totalPolishAmount = 0
	self.totalTaskAmount = 1
	
	self:getWorkAmountData(self.taskData.id)
	
	if self:hasPrequelFeature() then
		descBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		descBox:addText(_T("GAME_TASK_WAS_IN_SELECTED_GAME", "This feature was implemented in the selected related game."), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, maxWidth, "exclamation_point", 24, 24)
	end
	
	descBox:addText(_format(_T("GAME_TASK_WORK_AMOUNT", "Work amount: BASE + POLISH points"), "BASE", string.comma(self.totalWorkAmount), "POLISH", string.comma(self.totalPolishAmount)), "pix20", game.UI_COLORS.LIGHT_BLUE, 0, maxWidth, "wrench", 24, 24)
	
	if #self.workFields == 1 then
		local skillData = skills:getData(self.workFields[1])
		
		descBox:addText(_format(_T("TASK_RELATED_SKILL", "Related skill: SKILL"), "SKILL", skillData.display), "pix20", game.UI_COLORS.LIGHT_BLUE, 0, maxWidth, {
			{
				height = 24,
				icon = "profession_backdrop",
				width = 24
			},
			{
				height = 22,
				width = 22,
				icon = skillData.icon
			}
		})
	elseif #self.workFields > 1 then
		for key, skillID in ipairs(self.workFields) do
			local skillData = skills:getData(skillID)
			
			concat[#concat + 1] = skillData.display
		end
		
		descBox:addText(_format(_T("TASK_RELATED_SKILLS", "Related skills: SKILLS"), "SKILLS", table.concat(concat, ", ")), "pix20", game.UI_COLORS.LIGHT_BLUE, 0, maxWidth, {
			{
				height = 24,
				icon = "profession_backdrop",
				width = 24
			},
			{
				height = 22,
				width = 22,
				icon = skills:getData(self.workFields[1]).icon
			}
		})
		table.clear(concat)
	end
	
	self:addKnowledgeContributionDisplay(descBox, maxWidth)
	
	if self.totalTaskAmount > 1 then
		descBox:addText(_format(_T("TASK_IS_MULTI_TASK", "This task consists of TASKS sub-tasks."), "TASKS", self.totalTaskAmount), "bh20", nil, 0, maxWidth, "question_mark", 24, 24)
	end
	
	table.clear(self.workFields)
end

function gameTaskType:getWorkAmountData(featureID)
	local taskData = taskTypes.registeredByID[featureID]
	
	self.totalWorkAmount = self.totalWorkAmount + gameProject.TASK_CLASS:calculateRequiredWork(taskData, self.project)
	
	if taskData.stage ~= 1 then
		self.totalPolishAmount = self.totalPolishAmount + gameProject.POLISH_TASK_CLASS:calculateRequiredWork(taskData, self.project)
	end
	
	if not table.find(self.workFields, taskData.workField) then
		table.insert(self.workFields, taskData.workField)
	end
	
	if taskData.implementationTasks then
		self.totalTaskAmount = self.totalTaskAmount + #taskData.implementationTasks
		
		for key, taskID in ipairs(taskData.implementationTasks) do
			self:getWorkAmountData(taskID)
		end
	end
end

gui.register("GameTaskTypeSelection", gameTaskType, "TaskTypeSelection")
