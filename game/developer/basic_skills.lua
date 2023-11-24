local dev = {}

dev.id = "development"
dev.display = _T("SKILL_DEVELOPMENT", "Development")
dev.description = _T("SKILL_DEVELOPMENT_DESCRIPTION", "Determines the ability to develop quickly in all work fields.")
dev.boost = 1
dev.amountPerLevel = 8
dev.amountDeviation = {
	max = 30,
	min = 10
}
dev.deviationLevelScaling = 1
dev.icon = "skill_development"
dev.skillBoostString = _T("DEVELOPMENT_SKILL_BOOST_STRING", "BOOST% faster project development (next: NEXT%)")
dev.noMastery = true
dev.contractEvaluationWeight = 0.25
dev.attributeBoost = {
	vision = 0.25,
	intelligence = 0.25
}

function dev:fillSkillInfoDescbox(employee, descBox, wrapWidth)
	descBox:addText(_format(_T("DEVELOPMENT_SPEED_BOOST_DESC", "PERCENTAGE% faster overall work speed"), "PERCENTAGE", skills:getBoostFromSkill(employee:getSkillLevel(self.id), self) * 100), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
end

function dev:distribute(target)
	local level = target:getLevel()
	local amount = level * self.amountPerLevel
	local percentage = level / developer.MAX_LEVEL
	local minRange = math.random(0, self.amountDeviation.min)
	local maxRange = math.random(self.amountDeviation.min, self.amountDeviation.max)
	
	amount = amount + math.round(math.random(minRange, maxRange) * percentage)
	
	local roleData = target:getRoleData()
	
	amount = math.clamp(amount, 0, roleData.maxSkillLevels and roleData.maxSkillLevels[self.id] or self.maxLevel)
	
	target:setSkill(self.id, amount)
end

function dev:setupDescbox(descBox, wrapWidth)
	local taskClass = task:getData("game_task"):getSkillQualityIncrease()
	
	self.descBox:addText(self.skillData.description, "pix18", nil, 10, wrapWidth)
end

function dev:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

skills:registerNew(dev)

local soft = {}

soft.id = "software"
soft.display = _T("SKILL_SOFTWARE", "Software")
soft.description = _T("SKILL_SOFTWARE_DESCRIPTION", "Determines the ability to design and develop various systems for game engines and games.")
soft.canPractice = true
soft.boost = 2.25
soft.rivalWeight = 1
soft.contractEvaluationWeight = 1
soft.icon = "skill_software"
soft.developmentSkill = true
soft.displaySpeedBoost = true
soft.displayQualityBoost = true
soft.distributionDependency = {
	intelligence = {
		8,
		9
	},
	vision = {
		-1,
		0
	}
}
soft.attributeBoost = {
	intelligence = 0.5
}

function soft:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

skills:registerNew(soft)

local sound = {}

sound.id = "sound"
sound.display = _T("SKILL_SOUND", "Sound")
sound.description = _T("SKILL_SOUND_DESCRIPTION", "Affects sound asset creation speed and quality.")
sound.canPractice = true
sound.rivalWeight = 0.7
sound.contractEvaluationWeight = 0.5
sound.icon = "quality_sound"
sound.developmentSkill = true
sound.displaySpeedBoost = true
sound.displayQualityBoost = true
sound.distributionDependency = {
	vision = {
		8,
		9
	},
	intelligence = {
		-1,
		0
	}
}
sound.boost = 2.25
sound.attributeBoost = {
	vision = 0.5
}

function sound:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

skills:registerNew(sound)

local gfx = {}

gfx.id = "graphics"
gfx.display = _T("SKILL_GRAPHICS", "Graphics")
gfx.description = _T("SKILL_GRAPHICS_DESCRIPTION", "Affects graphic asset creation speed and quality.")
gfx.canPractice = true
gfx.boost = 2.25
gfx.rivalWeight = 0.7
gfx.contractEvaluationWeight = 0.5
gfx.icon = "quality_graphics"
gfx.developmentSkill = true
gfx.displaySpeedBoost = true
gfx.displayQualityBoost = true
gfx.distributionDependency = {
	vision = {
		8,
		9
	},
	intelligence = {
		-1,
		0
	}
}
gfx.attributeBoost = {
	vision = 0.5
}

function gfx:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

skills:registerNew(gfx)

local conc = {}

conc.id = "concept"
conc.display = _T("SKILL_CONCEPT", "Concept")
conc.description = _T("SKILL_CONCEPT_DESCRIPTION", "Determines the ability to come up with interesting gameplay systems for games, boosts game development speed.")
conc.canPractice = true
conc.boost = 2.25
conc.rivalWeight = 0.5
conc.icon = "attribute_vision"
conc.contractEvaluationWeight = 0.5
conc.developmentSkill = true
conc.displaySpeedBoost = true
conc.displayQualityBoost = true
conc.distributionDependency = {
	vision = {
		8,
		9
	},
	intelligence = {
		-1,
		0
	}
}
conc.attributeBoost = {
	vision = 0.5
}

function conc:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

skills:registerNew(conc)

local manag = {}

manag.id = "management"
manag.display = _T("SKILL_MANAGEMENT", "Management")
manag.icon = "skills_management"
manag.developmentSkill = true
manag.displaySpeedBoost = true
manag.displayQualityBoost = true
manag.description = _T("SKILL_MANAGEMENT_DESCRIPTION", "Affects development speed, amount of manageable people in a team, team managing efficiency, damage control and PR efficiency.")
manag.boost = 2.25
manag.rivalWeight = 0.2
manag.contractEvaluationWeight = 0.33
manag.boostLossPerEmployeeOverLimit = 0.02
manag.managementAttributeBoost = 0.1
manag.skillBoostToManagementBoost = 0.2
manag.basePeopleManagedAmount = 3
manag.additionalPeoplePerLevel = 0.6
manag.distributionDependency = {
	charisma = {
		3,
		5
	},
	vision = {
		3,
		5
	},
	intelligence = {
		-1,
		0
	}
}
manag.attributeBoost = {
	vision = 0.25,
	charisma = 0.25
}

function manag:getManageablePeopleAmount(target)
	local baseAmount = self.basePeopleManagedAmount + target:getSkillLevel(self.id) * self.additionalPeoplePerLevel
	local realAmount = baseAmount * target.managementBoost
	
	return math.ceil(realAmount), math.ceil(baseAmount)
end

function manag:isOverloaded(target)
	local skillLevel = target:getSkillLevel(self.id)
	local manageablePeopleCount = self:getManageablePeopleAmount(target)
	
	return manageablePeopleCount < target:getManagedMemberCount()
end

function manag:fillSkillInfoDescbox(employee, descBox, wrapWidth)
	manag.baseClass.fillSkillInfoDescbox(self, employee, descBox, wrapWidth)
	
	if employee:getRole() == "manager" then
		local currentManageable, baseManageable = self:getManageablePeopleAmount(employee)
		local distance = currentManageable - baseManageable
		
		descBox:addText(_format(_T("MANAGEMENT_MAX_MANAGED_PEOPLE", "PEOPLE max. managed people"), "PEOPLE", currentManageable), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
		
		if distance > 0 then
			descBox:addText(_format(_T("MANAGEMENT_MAX_MANAGED_BOOST", "\t+PEOPLE boost by environment"), "PEOPLE", distance), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
		end
	end
end

function manag:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

function manag:getManagementBoost(target)
	local boost = 0
	
	boost = boost + skills:getBoostFromSkill(target:getSkillLevel(self.id), self) * self.skillBoostToManagementBoost
	boost = boost + skills:getBoostFromAttributes(target, self) * self.managementAttributeBoost
	
	local memberCount = target:getManagedMemberCount()
	local skillLevel = target:getSkillLevel(self.id)
	local manageablePeopleCount = self:getManageablePeopleAmount(target)
	local dist = memberCount - manageablePeopleCount
	
	if dist > 0 then
		boost = boost - dist * self.boostLossPerEmployeeOverLimit
	end
	
	boost = boost + 1
	
	return math.max(boost, 1)
end

skills:registerNew(manag)

local writing = {}

writing.id = "writing"
writing.display = _T("SKILL_WRITING", "Writing")
writing.icon = "skills_writing"
writing.description = _T("SKILL_WRITING_DESCRIPTION", "Affects game story quality, as well as the speed at which the plot is written.")
writing.canPractice = true
writing.boost = 2.25
writing.rivalWeight = 0.6
writing.contractEvaluationWeight = 0.5
writing.developmentSkill = true
writing.displaySpeedBoost = true
writing.displayQualityBoost = true
writing.distributionDependency = {
	vision = {
		5,
		6
	},
	intelligence = {
		3,
		4
	}
}
writing.attributeBoost = {
	vision = 0.4,
	intelligence = 0.25
}

function writing:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

skills:registerNew(writing)

local teamwork = {}

teamwork.id = "teamwork"
teamwork.display = _T("SKILL_TEAMWORK", "Teamwork")
teamwork.description = _T("SKILL_TEAMWORK_DESCRIPTION", "Provides a bonus to fields covered by all other skills when not working alone.")
teamwork.skillBoostString = false
teamwork.ignoreDuringSort = true
teamwork.boost = 0.2
teamwork.contractEvaluationWeight = 0
teamwork.noMastery = true
teamwork.icon = "skill_teamwork"
teamwork.skillToTeamworkCorrelation = 0.6
teamwork.baselineExpGain = 0.5
teamwork.expGainedPerPersonInTeam = 0.1
teamwork.expGainedPerPersonInTeamOverMax = 0.02
teamwork.maxExpGainMultiplier = 1.2
teamwork.nonProgressiveSkills = {
	development = true,
	teamwork = true
}
teamwork.distributionDependency = {
	charisma = {
		6,
		8
	}
}
teamwork.attributeBoost = {
	charisma = 0.2
}
teamwork.excludedTaskIDs = {
	practice_skill = true,
	research_task = true
}

function teamwork:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

function teamwork:onSkillProgressed(employee, skillID, experience)
	local teamObj = employee:getTeam()
	
	if teamObj then
		local memberCount = teamObj:getMemberCount() - 1
		local task = employee:getTask()
		
		if memberCount > 0 and task and not self.excludedTaskIDs[task:getID()] then
			local multiplier = 1 / self.expGainedPerPersonInTeam
			local overMax = memberCount - (multiplier - multiplier * self.baselineExpGain)
			local baseMult = math.min(math.min(self.baselineExpGain + self.expGainedPerPersonInTeam * memberCount, 1) + math.max(overMax * self.expGainedPerPersonInTeamOverMax, 0), self.maxExpGainMultiplier)
			
			if not self.nonProgressiveSkills[skillID] then
				skills:progressSkill(employee, self.id, experience * self.skillToTeamworkCorrelation * baseMult)
			end
		end
	end
end

skills:registerNew(teamwork)

local testing = {}

testing.id = "testing"
testing.display = _T("SKILL_TESTING", "Testing")
testing.description = _T("SKILL_TESTING_DESCRIPTION", "Affects amount of bugs found during development by the developer.")
testing.ignoreDuringSort = true
testing.skipDistribution = true
testing.bugFindChanceMultiplierPerPoint = 0.01
testing.bugFindChancePerIntelligencePoint = 0.1
testing.bugFindChancePerVisionPoint = 0.1
testing.contractEvaluationWeight = 0
testing.boost = 0.2
testing.icon = "skill_testing"
testing.noMastery = true
testing.distributionDependency = {
	intelligence = {
		1,
		2
	},
	vision = {
		3,
		5
	}
}
testing.attributeBoost = {
	vision = 0.2,
	intelligence = 0.2
}

function testing:getDevSpeedBoost(target)
	return 1 + skills:getBoostFromAttributes(target, self) + skills:getBoostFromSkill(target:getSkillLevel(self.id), self)
end

function testing:fillSkillInfoDescbox(employee, descBox, wrapWidth)
	local skill, intelligence, vision = self:getSkillChanceBoost(employee), self:getIntelligenceChanceBoost(employee), self:getVisionChanceBoost(employee)
	
	descBox:addText(_format(_T("TESTING_ISSUE_DISCOVER_CHANCE", "xPERCENTAGE issue discover chance"), "PERCENTAGE", math.round(skill + intelligence + vision, 2)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
	descBox:addText(_format(_T("TESTING_SKILL_BOOST", "\txBOOST boost by skill"), "BOOST", math.round(skill, 2)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
	descBox:addText(_format(_T("TESTING_INTELLIGENCE_BOOST", "\txBOOST boost by Intelligence"), "BOOST", math.round(intelligence, 2)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
	descBox:addText(_format(_T("TESTING_VISION_BOOST", "\txBOOST boost by Vision"), "BOOST", math.round(vision, 2)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
end

function testing:getIntelligenceChanceBoost(target)
	return target:getAttribute("intelligence") * testing.bugFindChancePerIntelligencePoint
end

function testing:getVisionChanceBoost(target)
	return target:getAttribute("vision") * testing.bugFindChancePerVisionPoint
end

function testing:getSkillChanceBoost(target)
	return target:getSkillLevel(self.id) * testing.bugFindChanceMultiplierPerPoint
end

function testing:calculateIssueDiscoverChance(target)
	return self:getSkillChanceBoost(target) + self:getIntelligenceChanceBoost(target) + self:getVisionChanceBoost(target)
end

function testing:postInit(target)
	target:setIssueDiscoverChanceMultiplier(self.id, 1 + self:calculateIssueDiscoverChance(target))
end

skills:registerNew(testing)
