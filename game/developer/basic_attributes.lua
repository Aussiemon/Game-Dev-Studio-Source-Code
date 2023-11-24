local int = {}

int.id = "intelligence"
int.display = _T("INTELLIGENCE", "Intelligence")
int.description = _T("INTELLIGENCE_DESCRIPTION", "Affects efficiency at Software, Management and Testing skills.")
int.minLevel = 0
int.maxLevel = 10
int.startLevel = 0
int.icon = "attribute_intelligence"

function int:formatDescriptionText(descBox, employee, wrapWidth)
	local employeeLevels = employee:getAttributes()
	
	for key, skillData in ipairs(skills.registered) do
		if skillData.attributeBoost and skillData.attributeBoost[self.id] then
			local boostString = skillData:getSkillBoostString()
			
			if boostString then
				local boost = math.round(skills:getBoostFromAttribute(employeeLevels, skillData, self, 0) * 100, 1)
				local nextLevel = math.round(skills:getBoostFromAttribute(employeeLevels, skillData, self, 1) * 100, 1)
				
				descBox:addText(_format(boostString, "BOOST", boost, "SKILL", skillData.display, "NEXT", nextLevel), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
			end
		end
	end
end

attributes:registerNew(int)

local vis = {}

vis.id = "vision"
vis.display = _T("VISION", "Vision")
vis.description = _T("VISION_DESCRIPTION", "Affects efficiency at Writing, Concept, Sound, Management, Development and Testing skills.")
vis.minLevel = 0
vis.maxLevel = 10
vis.startLevel = 0
vis.icon = "attribute_vision"
vis.formatDescriptionText = int.formatDescriptionText

attributes:registerNew(vis)

local char = {}

char.id = "charisma"
char.display = _T("CHARISMA", "Charisma")
char.description = _T("CHARISMA_DESCRIPTION", "Affects efficiency at Management, Teamwork, increases efficiency at game expos and benefits of motivational speeches when performing one.")
char.minLevel = 0
char.maxLevel = 10
char.startLevel = 0
char.damageControlMultPerPoint = 0.03
char.icon = "attribute_charisma"

function char:formatDescriptionText(descBox, employee, wrapWidth)
	int.formatDescriptionText(self, descBox, employee, wrapWidth)
	
	local curLevel = employee:getAttribute(self.id)
	local nextLevel = math.min(self.maxLevel, curLevel + 1)
	
	descBox:addText(_format(_T("TEAMWORK_CHARISMA_AFFECTOR", "+BOOST% teamwork speed boost (next: NEXT%)"), "BOOST", math.round(team:getBaseCharismaTeamworkAffector(curLevel) * 100, 1), "NEXT", math.round(team:getBaseCharismaTeamworkAffector(nextLevel) * 100, 1)), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
	descBox:addText(_format(_T("GAME_CONVENTIONS_CHARISMA_AFFECTOR", "+BOOST% game convention efficiency (next: NEXT%)"), "BOOST", math.round(gameConventions:getCharismaBoost(curLevel) * 100, 1), "NEXT", math.round(gameConventions:getCharismaBoost(nextLevel) * 100, 1)), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
	
	local maxMotivation = motivationalSpeeches:getMaxSpeechScore()
	
	if employee:isPlayerCharacter() then
		descBox:addText(_format(_T("MOTIVATIONAL_SPEECHES_CHARISMA_AFFECTOR", "+BOOST% motivational speech efficiency (next: NEXT%)"), "BOOST", math.round(motivationalSpeeches:getCharismaScore(curLevel) / maxMotivation * 100, 1), "NEXT", math.round(motivationalSpeeches:getCharismaScore(nextLevel) / maxMotivation * 100, 1)), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
		descBox:addText(_T("CONTEXTUAL_ACTION_CHARISMA_AFFECTOR", "Improved interaction with employees in specific contexts"), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
	end
end

function char:getDamageControlEfficiencyMultiplier(employee)
	return employee:getAttribute(self.id) * self.damageControlMultPerPoint
end

attributes:registerNew(char)

local spd = {}

spd.id = "speed"
spd.display = _T("SPEED", "Speed")
spd.description = _T("SPEED_DESCRIPTION", "Provides an overall development time bonus to all skills.")
spd.minLevel = 0
spd.maxLevel = 10
spd.startLevel = 0
spd.devSpeedMultiplier = 0.5
spd.icon = "attribute_speed"

function spd:formatDescriptionText(descBox, employee, wrapWidth)
	local curLevel = employee:getAttribute(self.id)
	local nextLevel = math.min(self.maxLevel, curLevel + 1)
	
	descBox:addText(_format(_T("SPEED_DEVELOPMENT_BOOST", "BOOST% faster overall development speed (next: NEXT%)"), "BOOST", math.round((self:getSpeedBoost(curLevel) - 1) * 100, 1), "NEXT", math.round((self:getSpeedBoost(nextLevel) - 1) * 100, 1)), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth)
end

function spd:getSpeedBoost(level)
	return 1 + level / self.maxLevel * self.devSpeedMultiplier
end

function spd:onChanged(employee, newLevel)
	employee:setSpeedBoost(self:getSpeedBoost(newLevel))
end

attributes:registerNew(spd)
