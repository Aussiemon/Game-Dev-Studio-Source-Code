skills = {}
skills.registered = {}
skills.registeredByID = {}
skills.developmentSkills = {}
skills.DEFAULT_MIN = 0
skills.DEFAULT_MAX = 100
skills.MASTERY_CUTOFF = 100
skills.DEFAULT_START = 0
skills.DEFAULT_START_EXPERIENCE = 0
skills.DEFAULT_SKILL_BOOST_STRING = _T("ATTRIBUTE_SKILL_BOOST", "BOOST% faster SKILL skill (next: NEXT%)")
skills.EXPERIENCE_CURVE = {}

local expPerLevel = 10
local baseExp = 50
local expPerLevelExponent = 1.4
local segmentRound = 10

for i = 0, 100 do
	local requiredExp = baseExp + (expPerLevel * i)^expPerLevelExponent
	
	requiredExp = math.ceil(requiredExp / segmentRound) * segmentRound
	skills.EXPERIENCE_CURVE[i] = requiredExp
end

skills.EXPERIENCE_CURVE_LEVELS = #skills.EXPERIENCE_CURVE

local baseSkillFuncs = {}

baseSkillFuncs.mtindex = {
	__index = baseSkillFuncs
}

function baseSkillFuncs:onEvent(employee, event, ...)
end

function baseSkillFuncs:init(employee)
end

function baseSkillFuncs:postInit(employee)
end

function baseSkillFuncs:fillInteractionComboBox(employee, comboBox)
end

function baseSkillFuncs:onSkillProgressed(employee, skillID, experience)
end

function baseSkillFuncs:getIconConfig(w, h, iconOffX, iconOffY)
	return {
		{
			icon = "profession_backdrop",
			width = w,
			height = h
		},
		{
			icon = self.icon,
			width = w - iconOffX * 2,
			height = h - iconOffX * 2,
			x = iconOffX,
			y = iconOffX
		}
	}
end

function baseSkillFuncs:getSkillLevelText(dev)
	local masteryLevel = dev:getSkillMasteryLevel(self.id)
	
	if not self.noMastery and masteryLevel > 0 then
		return _format("NAME - MASTERY", "NAME", self.display, "MASTERY", _format(_T("SKILL_MASTERY_INFO_LAYOUT", "Mastery level LEVEL"), "LEVEL", masteryLevel))
	end
	
	return _format(_T("SKILL_TITLE_LEVEL_LAYOUT", "SKILLNAME - Level LEVEL/MAX"), "SKILLNAME", self.display, "LEVEL", dev:getSkillLevel(self.id), "MAX", dev:getMaxSkillLevel(self.id))
end

function baseSkillFuncs:addHighestSkillLevelText(descBox, wrapWidth, skillLevel)
	descBox:addText(_format(_T("HIGHEST_SKILL_LEVEL", "Highest SKILL level - LEVEL"), "SKILL", self.display, "LEVEL", skillLevel), "bh20", nil, 0, wrapWidth, {
		{
			height = 24,
			icon = "profession_backdrop",
			width = 24
		},
		{
			width = 22,
			height = 22,
			y = 1,
			x = 1,
			icon = self.icon
		}
	})
end

function baseSkillFuncs:addAverageSkillLevelText(descBox, wrapWidth, skillLevel)
	descBox:addText(_format(_T("AVERAGE_SKILL_LEVEL", "Average SKILL level - LEVEL"), "SKILL", self.display, "LEVEL", skillLevel), "bh20", nil, 0, wrapWidth, {
		{
			height = 24,
			icon = "profession_backdrop",
			width = 24
		},
		{
			width = 22,
			height = 22,
			y = 1,
			x = 1,
			icon = self.icon
		}
	})
end

function baseSkillFuncs:fillSkillInfoDescbox(employee, descBox, wrapWidth)
	if self.displaySpeedBoost then
		descBox:addText(_format(_T("GENERIC_SKILL_SPEED_INCREASE_DESC", "PERCENTAGE% work speed on FIELD tasks"), "PERCENTAGE", self:getDevSpeedBoost(employee) * 100, "FIELD", self.display), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
		descBox:addText(_format(_T("GENERIC_SKILL_DEV_SPEED_BOOST_DESC", "\tPERCENTAGE% boost by skill"), "PERCENTAGE", skills:getBoostFromSkill(employee:getSkillLevel(self.id), self) * 100), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
		
		local employeeAttributes = employee:getAttributes()
		
		for key, data in ipairs(self.attributeBoostNumeric) do
			local attributeData = attributes.registeredByID[data.id]
			
			descBox:addText(_format(_T("GENERIC_ATTRIBUTE_DEV_SPEED_BOOST_DESC", "\tPERCENTAGE% boost by ATTRIBUTE"), "PERCENTAGE", skills:getBoostFromAttribute(employeeAttributes, self, attributeData, 0) * 100, "ATTRIBUTE", attributeData.display), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
		end
	end
	
	if self.displayQualityBoost then
		if self.displaySpeedBoost then
			descBox:addSpaceToNextText(6)
		end
		
		descBox:addText(_format(_T("GENERIC_QUALITY_BOOST_DESC", "+QUALITY Quality pts. per 100 Work pts. on related tasks"), "QUALITY", math.round(gameProject.TASK_CLASS.SKILL_TO_QUALITY * employee:getSkillLevel(self.id) * 100, 1)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
	end
end

function baseSkillFuncs:getSkillBoostString()
	return self.skillBoostString
end

local highestContributors = {}

function baseSkillFuncs:getAutoSpendableAttribute(target)
	local mostContributing = -math.huge
	
	for key, data in ipairs(self.attributeBoostNumeric) do
		local attributeData = attributes.registeredByID[data.id]
		
		if target:getAttribute(data.id) < attributeData.maxLevel then
			mostContributing = math.max(mostContributing, data.boost)
		end
	end
	
	if mostContributing == -math.huge then
		return nil
	end
	
	for key, data in ipairs(self.attributeBoostNumeric) do
		local attributeData = attributes.registeredByID[data.id]
		
		if target:getAttribute(data.id) < attributeData.maxLevel and mostContributing <= data.boost then
			highestContributors[#highestContributors + 1] = data.id
		end
	end
	
	local randomID = highestContributors[math.random(1, #highestContributors)]
	
	return randomID
end

function skills:registerNew(data)
	table.insert(skills.registered, data)
	
	skills.registeredByID[data.id] = data
	data.minLevel = data.minLevel or skills.DEFAULT_MIN
	data.maxLevel = data.maxLevel or skills.DEFAULT_MAX
	data.startLevel = data.startLevel or skills.DEFAULT_START
	data.startExperience = data.startExperience or skills.DEFAULT_START_EXPERIENCE
	data.attributeBoostNumeric = {}
	data.highestAttributeBoost = 0
	data.rivalWeight = data.rivalWeight or 1
	
	for attributeID, boost in pairs(data.attributeBoost) do
		data.highestAttributeBoost = math.max(data.highestAttributeBoost, boost)
		data.attributeBoostNumeric[#data.attributeBoostNumeric + 1] = {
			id = attributeID,
			boost = boost
		}
	end
	
	if data.skillBoostString ~= false then
		data.skillBoostString = data.skillBoostString or skills.DEFAULT_SKILL_BOOST_STRING
	end
	
	if data.developmentSkill then
		table.insert(skills.developmentSkills, data)
	end
	
	data.icon = data.icon or "icon_software_engineer"
	data.baseClass = baseSkillFuncs
	
	if MAIN_THREAD then
		data.iconQuad = quadLoader:load(data.icon)
	end
	
	setmetatable(data, baseSkillFuncs.mtindex)
end

function skills:getData(skillID)
	return self.registeredByID[skillID]
end

function skills:getName(skillID)
	return self.registeredByID[skillID].display
end

function skills:shouldIgnoreWhenSorting(skillID)
	return self.registeredByID[skillID].ignoreDuringSort
end

function skills:getDevSpeedBoost(target)
	return self.registeredByID[skillID]:getDevSpeedBoost(target)
end

function skills:getMaxLevel(skillID)
	return self.registeredByID[skillID].maxLevel
end

function skills:getPercentageToMax(employee, level, skillID)
	return level / math.min(employee:getMaxSkillLevel(skillID), self.registeredByID[skillID].maxLevel)
end

function skills:getLevelUpProgress(target, skillID)
	return target:getSkillExperience(skillID) / self.EXPERIENCE_CURVE[math.min(self.EXPERIENCE_CURVE_LEVELS, target:getSkillLevel(skillID))]
end

function skills:updateSkillDevSpeedAffector(target, increasedSkill)
	local team = target:getTeam()
	
	if team then
		if increasedSkill then
			team:removeSkillDevSpeedAffector(target, increasedSkill)
			self:_updateSkillDevSpeedAffector(target, increasedSkill)
			team:addSkillDevSpeedAffector(target, increasedSkill)
		else
			team:removeBothSkillDevSpeedAffectors(target)
			self:_updateSkillDevSpeedAffectors(target)
			team:addBothSkillDevSpeedAffectors(target)
		end
	elseif increasedSkill then
		self:_updateSkillDevSpeedAffector(target, increasedSkill)
	else
		self:_updateSkillDevSpeedAffectors(target)
	end
	
	target:onDevSpeedAffectorsUpdated()
end

function skills:_updateSkillDevSpeedAffector(target, increasedSkill)
	target:getDevSpeedBoosts()[increasedSkill] = self.registeredByID[increasedSkill]:getDevSpeedBoost(target)
end

function skills:updateSkillDevSpeedAffectors(target)
	self:_updateSkillDevSpeedAffectors(target)
end

function skills:_updateSkillDevSpeedAffectors(target)
	local devSpeedAffectors = target:getDevSpeedBoosts()
	
	for key, skillData in ipairs(self.registered) do
		devSpeedAffectors[skillData.id] = skillData:getDevSpeedBoost(target)
	end
	
	target:onDevSpeedAffectorsUpdated()
end

function skills:getBoostFromSkill(skillLevel, skillData)
	return math.min(skillData.boost, skillLevel / skillData.maxLevel * skillData.boost)
end

function skills:getBoostFromAttribute(attributeLevels, skillData, attributeData, attributeOffset)
	local id = attributeData.id
	local maxLevel = attributeData.maxLevel
	
	return math.min(maxLevel, attributeLevels[id] + attributeOffset) / maxLevel * skillData.attributeBoost[id]
end

function skills:getBoostFromAttributes(target, skillData)
	local empAttributes = target:getAttributes()
	local finalBoost = 0
	local attrs = attributes.registeredByID
	
	for key, data in ipairs(skillData.attributeBoostNumeric) do
		finalBoost = finalBoost + self:getBoostFromAttribute(empAttributes, skillData, attrs[data.id], 0)
	end
	
	return finalBoost
end

skills.sortedByRoleRelevance = {}
skills.curSortedEmployee = nil
skills.curRoleData = nil

function skills.sortSkillsByRoleRelevance(a, b)
	local skillAdvanceModifiers = skills.curRoleData.skillAdvanceModifier
	
	return skillAdvanceModifiers[a.id] > skillAdvanceModifiers[b.id]
end

function skills:getSkillsSortedByRelevance(employee)
	table.clearArray(self.sortedByRoleRelevance)
	
	for key, skillData in ipairs(self.registered) do
		skills.sortedByRoleRelevance[#self.sortedByRoleRelevance + 1] = skillData
	end
	
	self.curRoleData = attributes.profiler.rolesByID[employee:getRole()]
	self.curSortedEmployee = employee
	
	table.sort(self.sortedByRoleRelevance, self.sortSkillsByRoleRelevance)
	
	return self.sortedByRoleRelevance
end

function skills:initSkills(target)
	local newProgressMultipliers = {}
	local newSkills = {}
	
	for key, data in ipairs(self.registered) do
		newSkills[data.id] = {
			level = data.startLevel,
			experience = data.startExperience
		}
		newProgressMultipliers[data.id] = 1
		
		data:init(target)
	end
	
	target:setSkills(newSkills, true)
	target:setSkillProgressionMultipliers(newProgressMultipliers)
	
	for key, data in ipairs(self.registered) do
		data:postInit(target)
	end
end

function skills:canProgress(target, skillID)
	return true
end

function skills:getRequiredExperience(level)
	return self.EXPERIENCE_CURVE[math.min(self.EXPERIENCE_CURVE_LEVELS, level)]
end

function skills:getMaxSkillLevel(skillID)
	return self.registeredByID[skillID].maxLevel
end

function skills:progressSkill(target, skillID, experience)
	local targetSkills = target:getSkills()
	local curSkill = targetSkills[skillID]
	local skillData = self.registeredByID[skillID]
	
	if skillData.noMastery and curSkill.level >= target.roleData.maxSkillLevels[skillID] then
		return 
	end
	
	for key, skillData in ipairs(self.registered) do
		skillData:onSkillProgressed(target, skillID, experience)
	end
	
	experience = experience * attributes.profiler:getRoleSkillAdvanceModifier(target, skillID)
	
	local oldLevel = curSkill.level
	local gainedLevels = 0
	
	while experience > 0 do
		local required = self:getRequiredExperience(curSkill.level)
		local expToLevel = required - curSkill.experience
		
		if expToLevel < experience then
			experience = experience - expToLevel
			curSkill.experience = 0
			curSkill.level = curSkill.level + 1
			gainedLevels = gainedLevels + 1
		else
			curSkill.experience = curSkill.experience + experience
			
			break
		end
	end
	
	if gainedLevels > 0 then
		self:updateSkillDevSpeedAffector(target, skillID)
		target:skillIncreased(skillID, curSkill.level, gainedLevels)
		
		if skillID == target:getMainSkill() then
			target:getRoleData():onMainSkillProgressed(target, target:getSkillLevel(skillID))
		end
		
		events:fire(developer.EVENTS.SKILL_INCREASED, target, skillID, curSkill.level, oldLevel)
	end
end

require("game/developer/basic_skills")
