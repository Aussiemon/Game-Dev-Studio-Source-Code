local workDisplay = {}

function workDisplay:updateDisplay(projectObject)
	self:removeAllText()
	
	projectObject = projectObject or self.project
	
	self:addText(_T("PROJECT_WORK_BY_SKILL", "Work by skill"), "bh22", self.categoryColor, 4, 320)
	
	if not projectObject:isLastStage() then
		self:addText(_T("PROJECT_WORK_CURRENT_STAGE", "Current stage"), "bh20", nil, 0, 320)
		
		local total, bySkill, taskCount, finishedTaskCount = projectObject:getStageWorkAmount(select(1, projectObject:getStage()))
		
		self:addText(_format(_T("PROJECT_WORK_CURRENT_TASKS", "Current tasks: TASKS"), "TASKS", finishedTaskCount), "bh18", nil, 7, 320)
		self:showList(bySkill)
		self:addText(_T("PROJECT_WORK_REMAINDER", "Remainder"), "bh20", nil, 0, 320)
		
		local stageKey = projectObject:getStage()
		local remainingTasks = 0
		
		for key, stageObj in ipairs(projectObject:getCurrentStages()) do
			if stageKey < key then
				remainingTasks = remainingTasks + #stageObj:getTasks()
			end
		end
		
		self:addText(_format(_T("PROJECT_WORK_REMAINING_TASKS", "Remaining tasks: TASKS"), "TASKS", remainingTasks), "bh18", nil, 7, 320)
	end
	
	local workAmount, bySkill = projectObject:getRemainingWorkAmount()
	
	self:showList(bySkill)
	
	return true
end

function workDisplay:showList(list)
	for skillID, amount in pairs(list) do
		if amount > 0 then
			local skillData = skills.registeredByID[skillID]
			
			self:addText(_format(_T("PROJECT_WORK_BY_TYPE_SPECIFIC", "BASE SKILL points"), "BASE", string.comma(math.round(amount)), "SKILL", skillData.display), "pix18", nil, 0, 320, {
				{
					height = 22,
					icon = "profession_backdrop",
					width = 22
				},
				{
					width = 20,
					height = 20,
					y = 1,
					x = 1,
					icon = skillData.icon
				}
			})
		end
	end
end

gui.register("WorkAmountDisplay", workDisplay, "ProjectInfoDisplay")
