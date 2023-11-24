local changedSkills = {}

function changedSkills:setShowOverview(state)
	self.showOverview = state
end

function changedSkills:setEmployee(emp)
	self.employee = emp
	
	local roleData = self.employee:getRoleData()
	local wrapWidth = 400
	
	self:addText(roleData.display, "bh24", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 6, wrapWidth, {
		{
			height = 24,
			icon = "profession_backdrop",
			width = 24
		},
		{
			height = 22,
			width = 22,
			x = 1,
			icon = roleData.roleIcon
		}
	})
	self:addText(_format(_T("EMPLOYEE_LEVEL_TABBED", "Level LEVEL"), "LEVEL", self.employee:getLevel()), "pix20", nil, 3, wrapWidth, {
		{
			height = 24,
			icon = "profession_backdrop",
			width = 24
		},
		{
			width = 22,
			height = 22,
			icon = "arrow",
			x = 1,
			color = game.UI_COLORS.LIGHT_BLUE
		}
	})
	self:addText(_format(_T("EMPLOYEE_WORKED_FOR", "Worked for TIME"), "TIME", timeline:getTimePeriodText(self.employee:getTimeEmployed())), "pix20", nil, 3, wrapWidth, "clock_full", 24, 24)
	self:addText(_format(_T("EMPLOYEE_OLD_SALARY", "Current salary: $SALARY"), "SALARY", string.comma(self.employee:getSalary())), "pix20", nil, 3, wrapWidth, {
		{
			height = 24,
			icon = "profession_backdrop",
			width = 24
		},
		{
			height = 22,
			icon = "wad_of_cash",
			width = 22,
			x = 1
		}
	})
	
	if not self.showOverview then
		self:addText(_format(_T("EMPLOYEE_WISHES_FOR_NEW_SALARY", "Wishes for: $SALARY"), "SALARY", string.comma(self.employee:getNewSalary())), "pix20", nil, 3, wrapWidth, {
			{
				height = 24,
				icon = "profession_backdrop",
				width = 24
			},
			{
				height = 22,
				icon = "wad_of_cash_plus",
				width = 22,
				x = 1
			}
		})
	end
	
	local changeInfo, beforeRaise = self.employee:getChangedSkills(sort)
	local skillLevels = self.employee:getSkills()
	local mainSkill = self.employee:getMainSkill()
	local improvedSkills = #changeInfo.changed > 0
	
	self:addText(_T("EMPLOYEE_IMPROVED_SKILLS", "Improved skills"), "bh24", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 8, wrapWidth)
	
	if improvedSkills then
		for key, skillID in ipairs(changeInfo.changed) do
			local skillData = skills:getData(skillID)
			local font, textColor
			
			if skillID == mainSkill then
				font = "bh20"
				textColor = game.UI_COLORS.IMPORTANT_3
			else
				font = "pix20"
			end
			
			local level = skillLevels[skillID].level
			local text
			local maxLevel = self.employee:getMaxSkillLevel(skillID)
			
			if maxLevel < level then
				local masteryChange = 0
				local prevLevel = beforeRaise[skillID].level
				
				if maxLevel < prevLevel then
					masteryChange = level - prevLevel
				else
					masteryChange = level - maxLevel
				end
				
				text = _format(_T("CHANGED_SKILL_MASTERY_LEVEL", "SKILL - Mastery lv. LEVEL (+INCREASE)"), "SKILL", skillData.display, "LEVEL", level - maxLevel, "INCREASE", masteryChange)
			else
				text = _format(_T("CHANGED_SKILL_LEVEL", "SKILL - Lv. LEVEL (+INCREASE)"), "SKILL", skillData.display, "LEVEL", level, "INCREASE", level - beforeRaise[skillID].level)
			end
			
			self:addSpaceToNextText(4)
			self:addText(text, font, textColor, 0, wrapWidth, {
				{
					height = 24,
					icon = "profession_backdrop",
					width = 24
				},
				{
					height = 22,
					width = 22,
					x = 1,
					icon = skillData.icon
				}
			})
		end
	else
		mainSkill = mainSkill or self.employee:getHighestSkill()
		
		local skillData = skills:getData(mainSkill)
		local maxLevel = self.employee:getMaxSkillLevel(mainSkill)
		local level = skillLevels[mainSkill].level
		local text
		
		if maxLevel < level then
			text = _format(_T("MASTERY_SKILL_LEVEL", "SKILL - Mastery lv. LEVEL"), "SKILL", skillData.display, "LEVEL", level - maxLevel)
		else
			text = _format(_T("MAIN_SKILL_LEVEL", "SKILL - Lv. LEVEL"), "SKILL", skillData.display, "LEVEL", level)
		end
		
		self:addSpaceToNextText(4)
		self:addText(text, "bh20", game.UI_COLORS.IMPORTANT_3, 0, wrapWidth, {
			{
				height = 24,
				icon = "profession_backdrop",
				width = 24
			},
			{
				height = 22,
				width = 22,
				x = 1,
				icon = skillData.icon
			}
		})
	end
	
	table.clearArray(changeInfo.changed)
end

gui.register("ChangedSkillsDisplay", changedSkills, "GenericDescbox")
