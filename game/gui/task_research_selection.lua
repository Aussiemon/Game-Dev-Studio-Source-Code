local taskTypeResearchSelection = {}

taskTypeResearchSelection.skinPanelFillColor = color(86, 104, 135, 255)
taskTypeResearchSelection.skinPanelHoverColor = color(175, 160, 75, 255)
taskTypeResearchSelection.skinPanelSelectColor = color(140, 170, 219, 255)
taskTypeResearchSelection.skinPanelDisableColor = color(45, 55, 71, 255)
taskTypeResearchSelection.skinTextFillColor = color(220, 220, 220, 255)
taskTypeResearchSelection.skinTextHoverColor = color(240, 240, 240, 255)
taskTypeResearchSelection.skinTextSelectColor = color(255, 255, 255, 255)
taskTypeResearchSelection.skinTextDisableColor = color(150, 150, 150, 255)
taskTypeResearchSelection.OUTDATED_TECH_TEXT_COLOR = color(255, 200, 200, 255)
taskTypeResearchSelection.PROGRESS_BAR_WIDTH = 150

local data = task:getData("research_task")

taskTypeResearchSelection.CATCHABLE_EVENTS = {
	data.EVENTS.BEGIN
}

local function cancelResearchOption(self)
	self.task:getAssignee():cancelTask()
	self.option:cancelResearch()
end

local function notBusyFilter(employee)
	return employee:canResearch() and employee:getWorkplace()
end

local function autoResearchOption(self)
	local taskData = taskTypes:getData(self.featureID)
	local employee, highest = studio:getMostExperiencedInSkill(nil, taskData:getResearchWorkField(), notBusyFilter)
	
	if employee and taskData:canResearch(employee) == true then
		local researchTask = game.createResearchTask(self.featureID)
		
		employee:setTask(researchTask)
	end
end

local function manualResearchOption(self)
	game.createFeatureResearchMenu(self.featureID)
end

local function instantResearchOption(self)
	local task = game.createResearchTask(self.featureID)
	
	task:setAssignee(self.assignee)
	self.assignee:cancelTask()
	self.assignee:setTask(task)
end

function taskTypeResearchSelection:cancelResearch()
	self:getParent():getScrollbarPanel():removeFromInProgress(self)
	
	self.researchState = nil
	self.progress = nil
	self.task = nil
end

function taskTypeResearchSelection:init()
end

function taskTypeResearchSelection:handleEvent(event, taskObj)
	if taskObj:getTaskType() == self.featureID then
		self:setTask(taskObj)
		self.parent:getScrollbarPanel():moveToInProgress(self)
	end
end

function taskTypeResearchSelection:isDisabled()
	return self.researchState and self.researchState ~= true
end

function taskTypeResearchSelection:isOn()
	return false
end

function taskTypeResearchSelection:setFeatureID(id)
	self.featureID = id
	self.displayText = taskTypes.registeredByID[id].display
	
	self:updateResearchAvailability()
end

function taskTypeResearchSelection:getCategory()
	return taskTypes.registeredByID[self.featureID].category
end

function taskTypeResearchSelection:isGameFeature()
	return taskTypes.registeredByID[self.featureID].taskID == "game_task"
end

function taskTypeResearchSelection:getFeatureID()
	return self.featureID
end

function taskTypeResearchSelection:setProgress(progress)
	self.progress = progress
end

function taskTypeResearchSelection:setTaskID(id)
	self.taskID = id
end

function taskTypeResearchSelection:setTask(taskObj)
	self.task = taskObj
	
	self:setCurrentAssignee(taskObj:getAssignee())
	self:setProgress(taskObj:getCompletion())
	self:setFeatureID(taskObj:getTaskType())
	self:setTaskID(taskObj:getID())
end

function taskTypeResearchSelection:getTask()
	return self.task
end

function taskTypeResearchSelection:setCurrentAssignee(cur)
	self.curAssignee = cur
	
	self:updateResearchAvailability()
	self:queueSpriteUpdate()
end

function taskTypeResearchSelection:setDesiredAssignee(desire)
	self.desiredAssignee = desire
	
	self:updateResearchAvailability()
	self:queueSpriteUpdate()
end

function taskTypeResearchSelection:updateResearchAvailability()
	local target = self.desiredAssignee or self.curAssignee
	
	if target and taskTypes.registeredByID[self.featureID] then
		self.researchState = taskTypes.registeredByID[self.featureID]:canResearch(target)
	end
end

function taskTypeResearchSelection:getFeatureID()
	return self.featureID
end

function taskTypeResearchSelection:isAvailable()
	if self.researchState ~= nil and self.researchState ~= true then
		return false
	end
	
	return not studio:isFeatureResearched(self.featureID)
end

taskTypeResearchSelection.formatFuncs = {
	ru = {
		multiple = function(amt)
			return _format("PEOPLE могут это исследовать", "PEOPLE", translation.conjugateRussianText(amt, "%s людей", "%s человека", "%s человек"))
		end
	}
}

function taskTypeResearchSelection:onMouseEntered()
	if self.researchState ~= nil then
		if self.researchState ~= true then
			self.descBox = self.descBox or gui.create("GenericDescbox")
			
			self.descBox:addText(self.researchState, "pix20", nil, 0, 600)
			self.descBox:centerToElement(self)
		end
	elseif not studio:isFeatureResearched(self.featureID) then
		local taskData = taskTypes:getData(self.featureID)
		
		self.descBox = self.descBox or gui.create("GenericDescbox")
		
		if taskData.description then
			for key, entry in ipairs(taskData.description) do
				self.descBox:addText(entry.text, entry.font, entry.color, entry.spacing)
			end
		end
		
		local workField = taskData:getResearchWorkField()
		
		self.descBox:addSpaceToNextText(4)
		
		if taskData.minimumLevel then
			self.descBox:addText(string.easyformatbykeys(_T("RESEARCH_REQUIRES_LEVEL", "Requires SKILL level MINIMUM for research."), "SKILL", skills.registeredByID[workField].display, "MINIMUM", taskData.minimumLevel), "pix20", game.UI_COLORS.IMPORTANT_1, 0, 600, "question_mark", 24, 24)
			
			if studio:getHighestSkillLevel(workField) >= taskData.minimumLevel then
				local busy = true
				local skilledEnough = 0
				
				for key, employee in ipairs(studio:getEmployees()) do
					if employee:getSkillLevel(workField) >= taskData.minimumLevel and employee:canResearch() and employee:getWorkplace() then
						busy = false
						skilledEnough = skilledEnough + 1
					end
				end
				
				if busy then
					self.descBox:addText(_T("RESEARCH_NOT_POSSIBLE_EVERYONE_BUSY", "At least one employee is skilled enough to research this, but they're busy."), "pix22", game.UI_COLORS.RED, 0, 600, "question_mark", 24, 24)
				elseif skilledEnough == 1 then
					self.descBox:addText(_T("RESEARCH_POSSIBLE_SINGLE_EMPLOYEE", "1 employee is skilled enough to research this."), "pix22", game.UI_COLORS.LIGHT_BLUE, 0, 600, "exclamation_point", 24, 24)
				else
					local methods = taskTypeResearchSelection.formatFuncs[translation.currentLanguage]
					local text
					
					if methods and methods.multiple then
						text = methods.multiple(skilledEnough)
					else
						text = _format(_T("RESEARCH_POSSIBLE_MULTIPLE_EMPLOYEES", "AMOUNT employees are skilled enough to research this."), "AMOUNT", skilledEnough)
					end
					
					self.descBox:addText(text, "pix22", game.UI_COLORS.LIGHT_BLUE, 0, 600, "exclamation_point", 24, 24)
				end
			else
				self.descBox:addText(_T("RESEARCH_NOT_POSSIBLE", "No employee is skilled enough to research this."), "pix22", game.UI_COLORS.RED, 0, 600)
			end
		else
			self.descBox:addText(_T("FEATURE_CAN_BE_RESEARCHED_BY_ANYONE", "This feature can be researched by anyone"), "pix20", game.UI_COLORS.LIGHT_BLUE, 0, 600, "question_mark", 24, 24)
		end
		
		local releaseDate = taskData.releaseDate
		
		if taskData.taskID == "engine_task" and releaseDate then
			local curDateTime = timeline:getDateTime(timeline:getYear(), timeline:getMonth())
			local releaseTime = timeline:getDateTime(releaseDate.year, releaseDate.month)
			
			if curDateTime - releaseTime >= engine.OUTDATED_TECH_TIME_AMOUNT then
				self.descBox:addText(_T("OUTDATED_TECH_POSIBILITY", "This technology may be outdated."), "pix24", taskTypeResearchSelection.OUTDATED_TECH_TEXT_COLOR)
			end
		end
		
		self.descBox:centerToElement(self)
	end
	
	self:queueSpriteUpdate()
end

function taskTypeResearchSelection:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function taskTypeResearchSelection:onClick(x, y, key)
	if not self:isAvailable() or interactionController:attemptHide(self) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	comboBox:setPos(x - 20, y - 10)
	
	comboBox.baseButton = self
	
	local option
	
	if self.task then
		option = comboBox:addOption(0, 0, 0, 24, _T("CANCEL_RESEARCH", "Cancel research"), fonts.get("pix20"), cancelResearchOption)
		option.task = self.task
		option.option = self
	elseif self.curAssignee then
		option = comboBox:addOption(0, 0, 0, 24, _T("BEGIN_RESEARCH", "Begin research"), fonts.get("pix20"), instantResearchOption)
		option.assignee = self.curAssignee
		option.option = self
	else
		local auto = comboBox:addOption(0, 0, 0, 24, _T("AUTO_ASSIGN", "Auto-assign"), fonts.get("pix20"), autoResearchOption)
		
		auto.option = self
		auto.featureID = self.featureID
		comboBox:addOption(0, 0, 0, 24, _T("SELECT_ASSIGNEE", "Manual assign"), fonts.get("pix20"), manualResearchOption).featureID = self.featureID
	end
	
	if option then
		option.featureID = self.featureID
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
end

function taskTypeResearchSelection:isDisabled()
	return not self:isAvailable()
end

function taskTypeResearchSelection:onKill()
	if self.descBox and self.descBox:isValid() then
		self.descBox:kill()
		
		self.descBox = nil
	end
end

function taskTypeResearchSelection:hide()
	taskTypeResearchSelection.baseClass.hide(self)
	self:killDescBox()
end

function taskTypeResearchSelection:updateSprites()
	local pcol, tcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	local quadName = not (not self:isOn() and not self:isMouseOver()) and "vertical_gradient_75" or "vertical_gradient_60"
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, quadName, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	if self.progress then
		local width = taskTypeResearchSelection.PROGRESS_BAR_WIDTH
		local baseX = self.w - _S(2) - _S(width)
		local baseY = _S(2)
		
		self:setNextSpriteColor(20, 20, 20, 255)
		
		self.backProgressSprite = self:allocateSprite(self.backProgressSprite, "generic_1px", baseX, baseY, 0, width, self.rawH - 4, 0, 0, -0.45)
		
		self:setNextSpriteColor(35, 35, 35, 255)
		
		self.underProgressSprite = self:allocateSprite(self.underProgressSprite, "generic_1px", baseX + _S(2), baseY + _S(2), 0, width - 4, self.rawH - 8, 0, 0, -0.4)
		
		self:setNextSpriteColor(204, 204, 144.8, 255)
		
		self.progressBarSprite = self:allocateSprite(self.progressBarSprite, "generic_1px", baseX + _S(2), baseY + _S(2), 0, (width - 4) * self.progress, self.rawH - 8, 0, 0, -0.4)
	elseif self.backProgressSprite then
		self.backProgressSprite = self:allocateSprite(self.backProgressSprite, "generic_1px", 0, 0, 0, 0, 0, 0, 0, -0.45)
		self.underProgressSprite = self:allocateSprite(self.underProgressSprite, "generic_1px", 0, 0, 0, 0, 0, 0, 0, -0.4)
		self.progressBarSprite = self:allocateSprite(self.progressBarSprite, "generic_1px", 0, 0, 0, 0, 0, 0, 0, -0.4)
	end
end

function taskTypeResearchSelection:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, 5, 0, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("TaskTypeResearchSelection", taskTypeResearchSelection, "Label")
