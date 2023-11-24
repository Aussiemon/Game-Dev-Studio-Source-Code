local taskTypeSelection = {}

taskTypeSelection.skinPanelFillColor = color(86, 104, 135, 255)
taskTypeSelection.skinPanelHoverColor = color(175, 160, 75, 255)
taskTypeSelection.skinPanelSelectColor = color(106, 128, 165, 255)
taskTypeSelection.skinPanelDisableColor = color(45, 55, 71, 255)
taskTypeSelection.skinTextFillColor = color(220, 220, 220, 255)
taskTypeSelection.skinTextHoverColor = color(240, 240, 240, 255)
taskTypeSelection.skinTextSelectColor = color(255, 255, 255, 255)
taskTypeSelection.skinTextDisableColor = color(100, 100, 100, 255)
taskTypeSelection.OUTDATED_TECH_TEXT_COLOR = color(255, 200, 200, 255)
taskTypeSelection.EVENTS = {
	MOUSE_OVER_OPTION_CATEGORY = events:new(),
	MOUSE_LEFT_OPTION_CATEGORY = events:new()
}
taskTypeSelection.CATCHABLE_EVENTS = {
	complexProject.EVENTS.ON_CONFLICTING_FEATURES_DISABLED,
	project.EVENTS.DESIRED_TEAM_SET,
	complexProject.EVENTS.ADDED_DESIRED_FEATURE,
	taskTypeSelection.EVENTS.MOUSE_LEFT_OPTION_CATEGORY,
	taskTypeSelection.EVENTS.MOUSE_OVER_OPTION_CATEGORY,
	project.EVENTS.DESIRED_TEAM_UNSET
}

function taskTypeSelection:init()
	self.currentColor = color(255, 255, 255, 255)
end

function taskTypeSelection:setCostFont(fontObj)
	self.costFontObject = fontObj
end

function taskTypeSelection:setProject(project)
	self.project = project
end

function taskTypeSelection:getProject()
	return self.project
end

function taskTypeSelection:handleEvent(event, data, taskType)
	if event == complexProject.EVENTS.ON_CONFLICTING_FEATURES_DISABLED or event == project.EVENTS.DESIRED_TEAM_SET then
		self:updateAvailability()
	elseif event == complexProject.EVENTS.ADDED_DESIRED_FEATURE and self.featureID ~= taskType then
		self:updateAvailability()
	elseif event == taskTypeSelection.EVENTS.MOUSE_LEFT_OPTION_CATEGORY and self:isValidOptionCategory(data) then
		self.mouseOverOptionCategory = false
		
		self:queueSpriteUpdate()
	elseif event == taskTypeSelection.EVENTS.MOUSE_OVER_OPTION_CATEGORY and self:isValidOptionCategory(data) then
		self.mouseOverOptionCategory = true
		
		self:queueSpriteUpdate()
	elseif event == project.EVENTS.DESIRED_TEAM_UNSET and data == self.project then
		self:updateAvailability()
	end
end

function taskTypeSelection:isValidOptionCategory(taskData)
	return taskData ~= self.taskData and taskData.optionCategory == self.taskData.optionCategory and self.canHaveFeature
end

function taskTypeSelection:updateAvailability()
	local oldCan = self.canHaveFeature
	local oldActive = self.active
	
	self.canHaveFeature = self.project:canHaveFeature(self.featureID)
	self.active = self:isActive()
	
	if (oldCan ~= self.canHaveFeature or oldActive ~= self.active) and not self.hidden then
		self:queueSpriteUpdate()
	end
end

function taskTypeSelection:setNotSelectable(state)
	self.notSelectable = state
end

function taskTypeSelection:setFeatureID(id)
	self.featureID = id
	self.taskData = taskTypes.registeredByID[self.featureID]
	
	if self.taskData.optionCategory then
		for key, taskData in ipairs(taskTypes:getTasksByOptionCategory(self.taskData.optionCategory)) do
			if taskData ~= self.taskData and taskData:wasReleased() and taskTypes:isFeatureUnlocked(taskData.id) then
				self.showOptionCategory = true
				
				break
			end
		end
	end
	
	self.canHaveFeature = self.project:canHaveFeature(self.featureID)
	self.active = self:isActive()
end

function taskTypeSelection:getFeatureID()
	return self.featureID
end

function taskTypeSelection:onClick()
	if self.notSelectable then
		return 
	end
	
	if self.project and self.featureID and self.canHaveFeature then
		self.taskData:setDesiredFeature(self.project, not self.project:hasDesiredFeature(self.featureID))
		
		if self.project:hasDesiredFeature(self.featureID) then
			sound:play("feature_selected", nil, nil, nil)
		else
			sound:play("feature_deselected", nil, nil, nil)
		end
		
		self.active = self:isActive()
	end
end

function taskTypeSelection:isActive()
	if not self.project:getDesiredTeam() then
		return false
	end
	
	if self.project and self.project:hasDesiredFeature(self.featureID) or self.isAlwaysOn then
		return true
	end
end

function taskTypeSelection:isOn()
	return self.active
end

function taskTypeSelection:isDisabled()
	if self.notSelectable then
		return false
	end
	
	if not self.project:getDesiredTeam() then
		return true
	end
	
	return (not self.project or not self.canHaveFeature) and true
end

function taskTypeSelection:onKill()
	if self.descBox and self.descBox:isValid() then
		self.descBox:kill()
		
		self.descBox = nil
	end
end

function taskTypeSelection:hide()
	taskTypeSelection.baseClass.hide(self)
	self:killDescBox()
end

function taskTypeSelection:setupWorkAmountDisplay(descBox, maxWidth)
	local featureData = self.taskData
	
	descBox:addText(_format(_T("TASK_WORK_AMOUNT", "Work amount: POINTS points"), "POINTS", self.project:getTaskClass():calculateRequiredWork(featureData, self.project)), "pix20", game.UI_COLORS.LIGHT_BLUE, 0, maxWidth, "wrench", 24, 24)
	
	if featureData.workField then
		local skillData = skills:getData(featureData.workField)
		
		descBox:addText(string.easyformatbykeys(_T("TASK_RELATED_SKILL", "Related skill: SKILL"), "SKILL", skillData.display), "pix20", game.UI_COLORS.LIGHT_BLUE, 0, maxWidth, {
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
	end
	
	self:addKnowledgeContributionDisplay(descBox, maxWidth)
	
	if featureData.computerLevelRequirement then
		descBox = descBox or gui.create("GenericDescbox")
		
		descBox:addText(_format(_T("TASK_REQUIRES_COMPUTER_LEVEL", "This task requires computer level LEVEL."), "LEVEL", featureData.computerLevelRequirement), "bh20", nil, 0, maxWidth, "question_mark", 24, 24)
	end
end

function taskTypeSelection:addKnowledgeContributionDisplay(descBox, maxWidth)
	local featureData = self.taskData
	
	if featureData.directKnowledgeContribution then
		local text, icon, font, clr
		local data = knowledge.registeredByID[featureData.directKnowledgeContribution.knowledge]
		
		if featureData.directKnowledgeContribution.mandatory then
			text = _format(_T("TASK_KNOWLEDGE_REQUIREMENT", "Requires at least POINTS points of KNOWLEDGE knowledge!"), "POINTS", math.round(knowledge.MAXIMUM_KNOWLEDGE * featureData.directKnowledgeContribution.mandatory * taskTypes.KNOWLEDGE_TO_EXTRA_QUALITY), "KNOWLEDGE", data.display)
			font = "bh20"
			icon = "exclamation_point_yellow"
			clr = game.UI_COLORS.IMPORTANT_1
		else
			text = _format(_T("TASK_KNOWLEDGE_CONTRIBUTION", "Benefits from KNOWLEDGE knowledge"), "KNOWLEDGE", data.display)
			font = "pix20"
			icon = "increase"
			clr = game.UI_COLORS.LIGHT_BLUE
		end
		
		descBox:addText(text, font, clr, 0, maxWidth, icon, 24, 24)
	end
end

function taskTypeSelection:createDescbox()
	if not self.descBox then
		local maxWidth = 500
		local featureData = self.taskData
		local descBox
		local description = featureData:getDescription(self.project)
		
		if description then
			local x, y = self:getPos(true)
			
			descBox = descBox or gui.create("GenericDescbox")
			
			for key, entry in ipairs(description) do
				descBox:addText(entry.text, entry.font, entry.color, entry.spacing, maxWidth, entry.icon, entry.iconWidth, entry.iconHeight)
			end
			
			local releaseDate = featureData.releaseDate
			
			if featureData.taskID == "engine_task" and releaseDate then
				local curDateTime = timeline:getDateTime(timeline:getYear(), timeline:getMonth())
				local releaseTime = timeline:getDateTime(releaseDate.year, releaseDate.month)
				
				if not featureData.neverOutdated and curDateTime - releaseTime >= featureData:getOutdatedTechTime() then
					descBox:addText(_T("OUTDATED_TECH_POSSIBILITY", "This technology may be outdated."), "pix24", taskTypeSelection.OUTDATED_TECH_TEXT_COLOR, 0, maxWidth)
				end
			end
		end
		
		if self.project.DEVELOPMENT_TYPE == gameProject.DEVELOPMENT_TYPE and self.project:getGameType() == gameProject.DEVELOPMENT_TYPE.MMO then
			descBox = descBox or gui.create("GenericDescbox")
			
			local firstSpace = false
			local priority = self.project:getCategoryPriority(featureData.category)
			local complex = featureData.mmoComplexity
			
			if complex then
				if not firstSpace then
					descBox:addSpaceToNextText(4)
					
					firstSpace = true
				end
				
				descBox:addText(_format(_T("PROJECT_SERVER_COMPLEXITY", "Server complexity: COMPLEX pts."), "COMPLEX", self.project:finalizeMMOComplexity(complex * priority)), "pix20", nil, 0, maxWidth, "projects_finished", 22, 22)
			end
			
			local mmoContent = featureData:getMMOContent()
			
			if mmoContent > 0 then
				if not firstSpace then
					descBox:addSpaceToNextText(4)
					
					firstSpace = true
				end
				
				descBox:addText(_format(_T("PROJECT_MMO_CONTENT", "MMO Content: CONTENT pts."), "CONTENT", math.round(mmoContent * logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID):getRealScaleMultiplier(self.project:getScale()) * priority, 1)), "pix20", nil, 0, maxWidth, "content", 22, 22)
			end
		end
		
		if featureData.setupDescbox then
			descBox = descBox or gui.create("GenericDescbox")
			
			featureData:setupDescbox(descBox, maxWidth, self.project)
		end
		
		if featureData.optionCategory then
			local currentFeature
			
			for key, data in ipairs(taskTypes:getTasksByOptionCategory(featureData.optionCategory)) do
				if self.project:hasFeature(data.id) then
					currentFeature = data
					
					break
				end
			end
			
			if currentFeature then
				descBox = descBox or gui.create("GenericDescbox")
				
				local text = _format(_T("PROJECT_CURRENT_FEATURE_IMPLEMENTED", "The project currently has FEATURE implemented"), "FEATURE", currentFeature.display)
				local textWidth = fonts.get("bh20"):getWidth(text)
				
				descBox:addTextLine(textWidth, game.UI_COLORS.LIGHT_BLUE_TEXT, nil, "weak_gradient_horizontal")
				descBox:addText(text, "bh20", nil, 0, maxWidth, "exclamation_point", 24, 24)
			end
		end
		
		if descBox and #descBox:getTextEntries() > 0 then
			descBox:addSpaceToNextText(10)
		end
		
		descBox = descBox or gui.create("GenericDescbox")
		
		self:setupWorkAmountDisplay(descBox, maxWidth)
		
		local goal = yearlyGoalController:getGoal()
		
		if goal then
			local text, font, textColor = goal:onHoverTaskInfoDescBox(featureData)
			
			if text then
				descBox = descBox or gui.create("GenericDescbox")
				
				descBox:addText(text, font, textColor, 0, maxWidth)
			end
		end
		
		local specBoost = featureData:getSpecializationBoost()
		
		if specBoost then
			descBox = descBox or gui.create("GenericDescbox")
			
			descBox:addText(_format(_T("TASK_BOOSTED_BY_SPECIALIZATION", "Boosted by specialization in SPEC"), "SPEC", attributes.profiler.specializationsByID[specBoost.id].display), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, maxWidth, "exclamation_point", 24, 24)
		end
		
		local canHave, unavailabilityState, lowestSkillLevel, missingRequirements, presentIncompatibilities = self.project:canHaveFeature(self.featureID)
		
		if not canHave then
			local wasPresent = descBox ~= nil
			
			descBox = descBox or gui.create("GenericDescbox")
			
			local listOfText = self.project:formulateUnavailabilityText(self.featureID, unavailabilityState, lowestSkillLevel, missingRequirements, presentIncompatibilities)
			
			if wasPresent then
				descBox:addSpaceToNextText(_S(10))
			end
			
			for key, data in ipairs(listOfText) do
				descBox:addText(data.text, data.font or "pix20", data.textColor, 0, maxWidth)
			end
		end
		
		if descBox then
			descBox:positionToMouse(_S(10), _S(10))
			
			self.descBox = descBox
		end
	end
end

function taskTypeSelection:onMouseEntered()
	self.appearDelay = 0.3
	
	self:queueSpriteUpdate()
	
	if self.showOptionCategory then
		self.mouseOverOptionCategory = true
		
		events:fire(taskTypeSelection.EVENTS.MOUSE_OVER_OPTION_CATEGORY, self.taskData)
	end
end

function taskTypeSelection:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
	
	self.appearDelay = nil
	
	if self.showOptionCategory then
		self.mouseOverOptionCategory = false
		
		events:fire(taskTypeSelection.EVENTS.MOUSE_LEFT_OPTION_CATEGORY, self.taskData)
	end
end

function taskTypeSelection:think()
	if self.currentColor:lerpAction(self.targetColor, frameTime * 15) then
		self:queueSpriteUpdate()
	end
	
	if self.appearDelay and self.appearDelay > 0 then
		self.appearDelay = self.appearDelay - frameTime
		
		if self.appearDelay <= 0 then
			self:createDescbox()
		end
	end
end

function taskTypeSelection:updateSprites()
	local pcol
	local mouseOver = self:isMouseOver()
	
	if (self.active and not mouseOver or not self.active and not mouseOver) and self.mouseOverOptionCategory then
		pcol = game.UI_COLORS.LIGHT_GREEN
	else
		pcol = self:getStateColor()
	end
	
	local oldTarget = self.targetColor
	
	self.targetColor = pcol
	
	if not oldTarget then
		self.currentColor:setColor(self.targetColor.r, self.targetColor.g, self.targetColor.b, self.targetColor.a)
	end
	
	self:setNextSpriteColor(self.currentColor:unpack())
	
	local quadName = not (not self.active and not mouseOver) and "vertical_gradient_75" or "vertical_gradient_60"
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, quadName, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	if not self.notSelectable then
		local checkboxQuad = self.showOptionCategory and (self.active and "radio_on" or "radio_off") or self.active and "checkbox_on" or "checkbox_off"
		
		self.checkboxSprite = self:allocateSprite(self.checkboxSprite, checkboxQuad, _S(2), _S(2), 0, self.rawH - 4, self.rawH - 4, 0, 0, -0.5)
		
		if self.taskData:getCost(nil, self.project) > 0 then
			local size = math.min(self.rawW, self.rawH) - 2
			
			self.wadOfCashSprite, self.sb = self:allocateSprite(self.wadOfCashSprite, "wad_of_cash", self.w - 2 - _S(size), 1, 0, size, size, 0, 0, -0.4)
		end
		
		self.textX = _S(5) + self.h
	else
		self.textX = _S(5)
	end
end

function taskTypeSelection:draw(w, h)
	local canHaveFeature = self.project and self.featureID and self.project:canHaveFeature(self.featureID)
	local taskTypeData = self.taskData
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, self.textX, 0, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
	
	local cost = taskTypeData:getCost(nil, self.project)
	
	if cost > 0 then
		local costText = _format(_T("COST", "$COST"), "COST", cost)
		local costWidth = self.costFontObject:getWidth(costText)
		
		love.graphics.setFont(self.costFontObject)
		love.graphics.printST(costText, w - costWidth - _S(24), 0, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
	end
end

gui.register("TaskTypeSelection", taskTypeSelection, "Label")
