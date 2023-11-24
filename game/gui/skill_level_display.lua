local skillLevelDisplay = {}

skillLevelDisplay.skinTextFillColor = color(240, 240, 240, 255)
skillLevelDisplay.skinTextHoverColor = color(255, 255, 255, 255)
skillLevelDisplay.baseColorInactiveMainSkill = game.UI_COLORS.NEW_HUD_HOVER_DESATURATED
skillLevelDisplay.baseColorInactive = game.UI_COLORS.NEW_HUD_FILL_3
skillLevelDisplay.baseColor = game.UI_COLORS.NEW_HUD_HOVER
skillLevelDisplay.underIconColor = color(0, 0, 0, 100)
skillLevelDisplay.progressBarColor = color(190, 226, 145, 255)
skillLevelDisplay.progressBarHeight = 8
skillLevelDisplay.font = "bh24"
skillLevelDisplay.canPracticeSkillTextColor = color(200, 255, 200, 255)

function skillLevelDisplay:practiceSkillOption()
	local taskObj = game.createPracticeTask(self.skillID, developer.PRACTICE_EXP_MIN, developer.PRACTICE_EXP_MAX, developer.PRACTICE_TIME_MIN, developer.PRACTICE_TIME_MAX, developer.PRACTICE_SESSIONS)
	
	taskObj:setSkillLevelExperienceIncreaseMultiplier(developer.PRACTICE_LEVEL_EXP_MULTIPLIER)
	self.assignee:setTask(taskObj)
end

function skillLevelDisplay:init()
	self:updateFont()
end

function skillLevelDisplay:updateFont()
	self.fontObject = fonts.get(self.font)
	self.fontHeight = self.fontObject:getHeight()
end

function skillLevelDisplay:setScalingState(hor, vert)
	skillLevelDisplay.baseClass.setScalingState(self, true, true)
end

function skillLevelDisplay:setEmployee(employee)
	self.employee = employee
end

function skillLevelDisplay:setData(data)
	self.skillData = data
	self.isMainSkill = attributes.profiler:getRoleData(self.employee:getRole()).mainSkill == self.skillData.id
	self.skillLevel = self.employee:getSkillLevel(data.id)
	self.skillLevelText = string.easyformatbykeys(_T("LEVEL_DISPLAY_SHORT", "Lv. LEVEL"), "LEVEL", math.min(self.skillLevel, skills.registeredByID[self.skillData.id].maxLevel))
end

function skillLevelDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:setWidth(500)
	
	local skillNameDisplay
	
	if self.isMainSkill then
		skillNameDisplay = string.easyformatbykeys(_T("MAIN_SKILL_DISPLAY", "SKILLNAME (Main skill)"), "SKILLNAME", self.skillData.display)
	else
		skillNameDisplay = self.skillData.display
	end
	
	local wrapWidth = 320
	local maxLevel = self.employee:getMaxSkillLevel(self.skillData.id)
	local masteryLevel = self.employee:getSkillMasteryLevel(self.skillData.id)
	local skillLevel = self.employee:getSkillLevel(self.skillData.id)
	
	self.descBox:addText(string.easyformatbykeys(_T("SKILL_TITLE_LEVEL_LAYOUT", "SKILLNAME - Level LEVEL/MAX"), "SKILLNAME", skillNameDisplay, "LEVEL", self.employee:getSkillLevelDisplay(self.skillData.id), "MAX", maxLevel), "bh20", nil, 10, wrapWidth)
	
	local nextLevelExpText
	
	if not self.skillData.noMastery and masteryLevel >= 0 then
		self.descBox:addText(string.easyformatbykeys(_T("SKILL_MASTERY_INFO_LAYOUT", "Mastery level LEVEL"), "LEVEL", masteryLevel), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "star", 24, 24)
		
		nextLevelExpText = _T("EXP_TO_NEXT_MASTERY_LEVEL", "Next mastery level exp: CUREXP/TARGETEXP EXP")
	else
		nextLevelExpText = _T("EXP_TO_NEXT_SKILL_LEVEL", "Next level experience: CUREXP/TARGETEXP EXP")
	end
	
	self.descBox:addText(self.skillData.description, "pix18", nil, 10, wrapWidth)
	self.skillData:fillSkillInfoDescbox(self.employee, self.descBox, wrapWidth)
	self.descBox:addSpaceToNextText(4)
	self.descBox:addText(string.easyformatbykeys(nextLevelExpText, "CUREXP", math.round(self.employee:getSkillExperience(self.skillData.id)), "TARGETEXP", skills:getRequiredExperience(self.employee:getSkillLevel(self.skillData.id))), "bh18", nil, 0, wrapWidth)
	
	local trainText = self:getTrainText()
	
	if trainText then
		self.descBox:addSpaceToNextText(5)
		self.descBox:addText(trainText, "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 24, 24)
	end
	
	self.descBox:setPos(self.x + _S(5), self.y)
end

function skillLevelDisplay:getTrainText()
	if not self.employee:isHired() then
		return nil
	end
	
	if self.employee:getSkillLevel(self.skillData.id) < skills:getMaxLevel(self.skillData.id) then
		if self.employee:isAvailable() then
			local finalText
			local task = self.employee:getTask()
			
			if not task or task and task:canCancel() then
				return _T("SKILL_IS_TRAINABLE", "This skill can be practiced.")
			else
				return _T("SKILL_IS_TRAINABLE_BUSY", "This skill can be practiced when the employee is not busy.")
			end
		end
	else
		return string.easyformatbykeys(_T("SKILL_NOT_TRAINABLE_MAXED", "Skill maxed out, can not practice."), "NAME", self.employee:getFullName(true))
	end
	
	return nil
end

function skillLevelDisplay:onClick(x, y, key)
	if self.employee:isHired() and self.employee:isAvailable() and self.employee:getSkillLevel(self.skillData.id) < skills:getMaxLevel(self.skillData.id) and self.employee:getWorkplace() then
		self:killDescBox()
		
		local task = self.employee:getTask()
		
		if not task or task and task:canCancel() then
			local comboBox = gui.create("ComboBox")
			
			comboBox:setDepth(150)
			comboBox:setAutoCloseTime(0.5)
			comboBox:setPos(x - 20, y - 10)
			
			comboBox.baseButton = self
			
			local option
			
			option = comboBox:addOption(0, 0, 0, 24, _T("PRACTICE_SKILL", "Practice skill"), fonts.get("pix20"), skillLevelDisplay.practiceSkillOption)
			option.assignee = self.employee
			option.skillID = self.skillData.id
			
			interactionController:setInteractionObject(self, x - 20, y - 10, true)
		end
	end
end

function skillLevelDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function skillLevelDisplay:getIconSize()
	return self.rawH - (4 + skillLevelDisplay.progressBarHeight)
end

function skillLevelDisplay:getIcon()
	return self.skillData.icon
end

function skillLevelDisplay:getLevelText()
	return self.skillLevelText
end

function skillLevelDisplay:getProgress()
	return self.employee:getSkillProgressPercentage(self.skillData.id)
end

function skillLevelDisplay:getBaseNonHoverColor()
	return self.isMainSkill and skillLevelDisplay.baseColorInactiveMainSkill or skillLevelDisplay.baseColorInactive
end

function skillLevelDisplay:updateSprites()
	local underColor = self:isMouseOver() and skillLevelDisplay.baseColor or self:getBaseNonHoverColor()
	
	self:setNextSpriteColor(underColor:unpack())
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local scaledProgressBarHeight = _S(skillLevelDisplay.progressBarHeight)
	local iconSize = self:getIconSize()
	local scaledTwo = _S(2)
	local scaledFour = _S(4)
	
	self:setNextSpriteColor(skillLevelDisplay.underIconColor:unpack())
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	self.iconSprite = self:allocateSprite(self.iconSprite, self:getIcon(), scaledTwo, scaledTwo, 0, iconSize, iconSize, 0, 0, -0.1)
	
	local realBarWidth = self.rawW - 4
	local realBarHeight = skillLevelDisplay.progressBarHeight - 2
	
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.underProgressbarSprite = self:allocateSprite(self.underProgressbarSprite, "generic_1px", scaledTwo, self.h - scaledTwo - _S(realBarHeight), 0, realBarWidth, realBarHeight, 0, 0, -0.1)
	
	self:setNextSpriteColor(skillLevelDisplay.progressBarColor:unpack())
	
	self.progressBarSprite = self:allocateSprite(self.progressBarSprite, "generic_1px", scaledFour, self.h - _S(realBarHeight), 0, (realBarWidth - 4) * self:getProgress(), realBarHeight - 4, 0, 0, -0.1)
end

function skillLevelDisplay:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self:getLevelText(), _S(self:getIconSize() + 8), _S(1), tcol.r, tcol.g, tcol.b, tcol.a)
end

gui.register("SkillLevelDisplay", skillLevelDisplay)
