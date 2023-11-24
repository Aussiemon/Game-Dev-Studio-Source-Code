attributes.profiler = {}
attributes.profiler.roles = {}
attributes.profiler.rolesByID = {}
attributes.profiler.specializations = {}
attributes.profiler.specializationsByID = {}
attributes.profiler.visibleRoles = {}
attributes.profiler.femaleRoles = {}
attributes.profiler.prevStats = {}
attributes.profiler.highestAttributes = {}
attributes.profiler.PREFERRED_GENRE_CHANCE = 50
attributes.profiler.DEFAULT_LOW_RELEVANCE_ADVANCE_MODIFIER = 0.5
attributes.profiler.DEFAULT_SKILL_ADVANCE_MODIFIER = 1
attributes.profiler.DEFAULT_SPECIALIZATION_LEVEL = 60

local attributeProfiler = attributes.profiler
local baseSpecFuncs = {}

baseSpecFuncs.mtindex = {
	__index = baseSpecFuncs
}

function baseSpecFuncs:applyToDeveloper(dev)
end

function baseSpecFuncs:setupDescbox(descBox, wrapWidth, scaledWrapWidth)
	descBox:addSpaceToNextText(15)
	
	local totalBySpec = studio:getTotalEmployeesBySpecialization(self.id)
	local text
	
	if totalBySpec == 0 then
		text = _format(_T("NO_EMPLOYEES_SPECCED", "You have no employees specialized in SPEC"), "SPEC", self.display)
	elseif totalBySpec == 1 then
		text = _format(_T("ONE_EMPLOYEES_SPECCED", "You have 1 employee specialized in SPEC"), "SPEC", self.display)
	else
		text = _format(_T("AMOUNT_OF_EMPLOYEES_SPECCED", "You have COUNT employees specialized in SPEC"), "COUNT", totalBySpec, "SPEC", self.display)
	end
	
	descBox:addText(text, "bh20", nil, 0, wrapWidth, "question_mark", 22, 22)
end

local baseRoleFuncs = {}

baseRoleFuncs.mtindex = {
	__index = baseRoleFuncs
}

function baseRoleFuncs:init(employee)
end

function baseRoleFuncs:onHired(employee)
end

function baseRoleFuncs:onLeftStudio(employee)
end

function baseRoleFuncs:onEvent(employee, event, ...)
end

function baseRoleFuncs:fillInteractionComboBox(employee, comboBox)
end

function baseRoleFuncs:setRoom(employee, roomObject)
end

function baseRoleFuncs:setWorkplace(employee, workplaceObject)
end

function baseRoleFuncs:fillSuggestionList(employee, list, dialogueObject)
end

function baseRoleFuncs:fillConversationOptions(employee, list, dialogueObject)
end

function baseRoleFuncs:onAway(employee, time)
end

function baseRoleFuncs:onMainSkillProgressed(dev, newLevel)
	self:checkSpecializationPopup(dev, newLevel)
end

function baseRoleFuncs:checkSpecializationPopup(dev, skillLevel)
	if self.specializations and not dev:getSpecialization() and skillLevel >= self.specSkillLevel then
		local employer = dev:getEmployer()
		
		if employer and employer:isPlayer() then
			self:createSpecializationSelectionPopup(dev)
		else
			attributeProfiler:pickRandomSpecialization(dev)
		end
	end
end

function baseRoleFuncs:getMainSkill()
	return self.mainSkill
end

function baseRoleFuncs:addRoleEmploymentInfo(descBox, wrapWidth, employeeCount)
	local shouldAddSpace = #descBox:getTextEntries() > 0
	
	if self.showEmployeeCount then
		if shouldAddSpace then
			descBox:addSpaceToNextText(10)
		end
		
		self:addRoleEmploymentText(descBox, wrapWidth, employeeCount)
	end
	
	if self.showSkillInfo then
		if shouldAddSpace then
			descBox:addSpaceToNextText(6)
		end
		
		local skillData = skills.registeredByID[self.mainSkill]
		
		skillData:addHighestSkillLevelText(descBox, wrapWidth, math.min(skillData.maxLevel, studio:getHighestSkillLevel(self.mainSkill)))
		
		if studio:getEmployeeCountByRole(self.id) > 1 then
			skillData:addAverageSkillLevelText(descBox, wrapWidth, studio:getAverageSkillLevel(self.mainSkill))
		end
	end
end

function baseRoleFuncs:addRoleEmploymentText(descBox, wrapWidth, employeeCount, baseText)
	baseText = baseText or _T("TOTAL_ROLE_MEMBERS", "ROLE employed - AMOUNT")
	
	descBox:addText(_format(baseText, "ROLE", self.displayPlural, "AMOUNT", employeeCount), "bh20", nil, 0, wrapWidth, {
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
			icon = self.roleIcon
		}
	})
end

function baseRoleFuncs:getRoleIconConfig(size)
	return {
		{
			icon = "profession_backdrop",
			width = size,
			height = size
		},
		{
			y = 1,
			x = 1,
			icon = self.roleIcon,
			width = size - 2,
			height = size - 2
		}
	}
end

function baseRoleFuncs:createSpecializationSelectionPopup(dev)
	local popup = gui.create("SpecializationPopup")
	
	popup:setWidth(400)
	popup:setFont("pix24")
	popup:setTitle(_T("SELECT_SPECIALIZATION_TITLE", "Select Specialization"))
	popup:setTextFont("pix20")
	popup:setText(_format(dev:getRoleData().specDescription, "EMPLOYEE", dev:getFullName(true)))
	popup:setEmployee(dev)
	popup:setRoleData(self)
	popup:hideCloseButton()
	popup:addConfirmButton()
	popup:center()
	frameController:push(popup)
end

function baseRoleFuncs:addSpecialization(spec)
	table.insert(attributeProfiler.specializations, spec)
	
	attributeProfiler.specializationsByID[spec.id] = spec
	self.specializations = self.specializations or {}
	self.specializationMap = self.specializationMap or {}
	
	table.insert(self.specializations, spec)
	
	self.specializationMap[spec.id] = spec
	spec.baseClass = baseSpecFuncs
	
	setmetatable(spec, baseSpecFuncs.mtindex)
end

function baseRoleFuncs:getSpecializations()
	return self.specializations
end

local increasableAttributes = {}

function baseRoleFuncs:getIncreasableAttribute(dev)
	for key, data in ipairs(self.skillAdvanceModifierSorted) do
		local attribute = skills.registeredByID[data.id]:getAutoSpendableAttribute(dev)
		
		if attribute then
			return attribute
		end
	end
	
	return nil
end

local function sortAdvanceModifiers(a, b)
	return a.modifier > b.modifier
end

function attributeProfiler:registerRole(data)
	table.insert(self.roles, data)
	
	self.rolesByID[data.id] = data
	
	if not data.invisible then
		table.insert(self.visibleRoles, data)
		
		if data.femaleChance then
			table.insert(self.femaleRoles, data)
		end
	end
	
	if data.showSkillInfo == nil and data.mainSkill then
		data.showSkillInfo = true
	end
	
	if data.showEmployeeCount == nil then
		data.showEmployeeCount = true
	end
	
	data.specSkillLevel = data.specSkillLevel or attributeProfiler.DEFAULT_SPECIALIZATION_LEVEL
	data.highestSkillDevMod = 0
	data.skillAdvanceModifierSorted = {}
	
	local highestSkill, highestID = -math.huge
	
	for key, skillData in ipairs(skills.registered) do
		data.skillAdvanceModifier[skillData.id] = data.skillAdvanceModifier[skillData.id] or 1
		data.highestSkillDevMod = math.max(data.highestSkillDevMod, data.skillAdvanceModifier[skillData.id])
		
		local mult = data.skillAdvanceModifier[skillData.id]
		
		if highestSkill < mult then
			highestSkill = mult
			highestID = skillID
		end
		
		data.skillAdvanceModifierSorted[#data.skillAdvanceModifierSorted + 1] = {
			id = skillData.id,
			modifier = data.skillAdvanceModifier[skillData.id]
		}
	end
	
	table.sort(data.skillAdvanceModifierSorted, sortAdvanceModifiers)
	
	data.skillAdvanceOverallModifier = data.skillAdvanceOverallModifier or attributes.profiler.DEFAULT_SKILL_ADVANCE_MODIFIER
	data.highestSkillAdvanceModifier = highestSkill
	data.lowRelevanceAdvanceModifier = data.lowRelevanceAdvanceModifier or attributes.profiler.DEFAULT_LOW_RELEVANCE_ADVANCE_MODIFIER
	
	if not data.maxSkillLevels then
		data.maxSkillLevels = {}
		
		for key, skillData in ipairs(skills.registered) do
			data.maxSkillLevels[skillData.id] = skills.DEFAULT_MAX
		end
	else
		local defaultLevel = data.maxSkillLevels.DEFAULT_TO
		
		if defaultLevel then
			for key, skillData in ipairs(skills.registered) do
				data.maxSkillLevels[skillData.id] = data.maxSkillLevels[skillData.id] or defaultLevel
			end
		end
	end
	
	data.roleIcon = data.roleIcon or "icon_software_engineer"
	
	setmetatable(data, baseRoleFuncs.mtindex)
	
	return data
end

function attributeProfiler:getIndividualDisplay(roleID)
	return attributeProfiler.rolesByID[roleID].personDisplay
end

function attributeProfiler:saveRoleData(employee)
	local roleData = self.rolesByID[employee:getRole()]
	
	if roleData.save then
		return roleData:save(employee)
	end
	
	return nil
end

function attributeProfiler:loadRoleData(employee, loadRoleData)
	local role = employee:getRole()
	
	self.rolesByID[role]:init(employee)
	
	if loadRoleData then
		local roleData = self.rolesByID[role]
		
		if roleData.load then
			roleData:load(employee, loadRoleData)
		end
	end
end

function attributeProfiler:fillInteractionComboBox(employee, comboBox)
	local role = employee:getRole()
	local roleData = self.rolesByID[role]
	
	roleData:fillInteractionComboBox(employee, comboBox)
end

function attributeProfiler:rollPreferredGenres(employee)
	if math.random(1, 100) <= attributes.profiler.PREFERRED_GENRE_CHANCE then
		local state, genre = table.random(studio:getResearchedGenres())
		
		if genre then
			employee:addPreferredGameGenre(genre)
		end
	end
end

function attributeProfiler:getAttributeAmount(target)
	return target:getLevel() * developer.ATTRIBUTE_POINTS_PER_LEVEL + developer.BASE_ATTRIBUTE_POINTS
end

function attributeProfiler:distributeAttributePoints(target, amount)
	amount = amount or self:getAttributeAmount(target)
	
	local targetAttributes = target:getAttributes()
	local role = self:getRandomRole(target)
	
	for key, data in ipairs(role.startingAttribute) do
		amount = self:assignAttributePoints(target, data[1], amount, data[2])
	end
	
	table.clear(self.prevStats)
	
	for attribute, value in pairs(targetAttributes) do
		self.prevStats[attribute] = true
	end
	
	while amount > 0 do
		local level, key = table.random(self.prevStats)
		
		amount = self:assignAttributePoints(target, key, amount)
		
		if targetAttributes[key] == attributes.registeredByID[key].maxLevel then
			self.prevStats[key] = nil
		end
	end
end

function attributeProfiler:assignAttributePoints(target, attribute, maxPoints, assignAmount)
	local targetAttributes = target:getAttributes()
	local attributeData = attributes.registeredByID[attribute]
	
	assignAmount = assignAmount and math.min(assignAmount, maxPoints) or math.random(0, math.min(attributeData.maxLevel - targetAttributes[attribute], maxPoints))
	targetAttributes[attribute] = targetAttributes[attribute] + assignAmount
	
	return maxPoints - assignAmount
end

function attributeProfiler:getRoleData(roleID)
	return self.rolesByID[roleID]
end

function attributeProfiler:getRoleName(roleID)
	return self.rolesByID[roleID].display
end

function attributeProfiler:handleEvent(employee, event, ...)
	self.rolesByID[employee:getRole()]:onEvent(employee, event, ...)
end

function attributeProfiler:getMainSkill(roleData)
	if roleData.mainSkill then
		return roleData.mainSkill
	end
	
	local fastest = roleData.skillAdvanceModifierSorted[1]
	
	return fastest.id, fastest.modifier
end

function attributeProfiler:getRole(assignee)
	local curRole = assignee:getRole()
	
	if curRole then
		return self.rolesByID[curRole]
	end
	
	return self:getRandomRole(assignee)
end

function attributeProfiler:getRandomRole(assignee)
	local finalRole = assignee:getRole() and self.rolesByID[assignee:getRole()]
	
	if not finalRole then
		if assignee:isFemale() then
			for key, roleData in ipairs(self.femaleRoles) do
				if math.random(1, 100) <= roleData.femaleChance then
					finalRole = roleData
					
					break
				end
			end
			
			if not finalRole then
				finalRole = self.visibleRoles[math.random(1, #self.visibleRoles)]
			end
		else
			finalRole = self.visibleRoles[math.random(1, #self.visibleRoles)]
		end
	end
	
	assignee:setRole(finalRole.id)
	self.rolesByID[finalRole.id]:init(assignee)
	
	return finalRole
end

function attributeProfiler.attributeSortFunc(a, b)
	return a.level > b.level
end

function attributeProfiler:getDominantAttributes(target)
	table.clear(self.highestAttributes)
	
	local highest, attribute = -math.huge
	
	for attribute, level in pairs(target:getAttributes()) do
		if highest <= level then
			highest = level
		end
	end
	
	return attribute, highest
end

function attributeProfiler:distributeSkillPoints(target)
	table.clear(self.prevStats)
	
	for key, data in ipairs(skills.registered) do
		if data.distributionDependency then
			table.insert(self.prevStats, data)
		end
		
		if data.distribute then
			data:distribute(target)
		end
	end
	
	local targetAttributes = target:getAttributes()
	local percentageToMaxLevel = target:getLevel() / developer.MAX_LEVEL
	local levelModifier = 0.2 + 0.8 * percentageToMaxLevel
	local roleData = self.rolesByID[target:getRole()]
	
	for key, data in ipairs(self.prevStats) do
		local finalValue = 0
		
		for attribute, list in pairs(data.distributionDependency) do
			local times = math.max(targetAttributes[attribute], 1)
			local roleModifier = roleData.skillAdvanceModifier[data.id]
			
			if roleModifier < roleData.highestSkillAdvanceModifier then
				roleModifier = roleModifier * roleData.lowRelevanceAdvanceModifier
			end
			
			for i = 1, times do
				finalValue = finalValue + math.randomf(list[1], list[2]) * levelModifier * roleModifier * roleData.skillAdvanceOverallModifier
			end
		end
		
		finalValue = math.clamp(math.round(finalValue), 0, roleData.maxSkillLevels and roleData.maxSkillLevels[data.id] or skills:getData(data.id).maxLevel)
		
		target:setSkill(data.id, finalValue)
	end
	
	local roleData = target:getRoleData()
	local mainSkill = target:getMainSkill()
	
	if roleData.specializations and mainSkill and target:getSkillLevel(mainSkill) >= roleData.specSkillLevel then
		self:pickRandomSpecialization(target)
	end
end

function attributeProfiler:pickRandomSpecialization(target)
	local roleData = target:getRoleData()
	
	if roleData.specializations then
		local randomSpec = roleData.specializations[math.random(1, #roleData.specializations)]
		
		target:setSpecialization(randomSpec.id)
		randomSpec:applyToDeveloper(target)
	end
end

function attributeProfiler:distributePoints(amount)
	local points = math.random(1, amount)
	
	return points
end

local mainRoleSkills = {}

function attributeProfiler:getMainRoleSkills(role)
	table.clear(mainRoleSkills)
	
	local data = attributeProfiler.rolesByID[role]
	local highest = 0
	
	for skillID, mult in pairs(data.skillAdvanceModifier) do
		highest = math.max(highest, mult)
	end
	
	for skillID, mult in pairs(data.skillAdvanceModifier) do
		if mult == highest then
			mainRoleSkills[#mainRoleSkills + 1] = skillID
		end
	end
	
	return mainRoleSkills
end

local mainRoleAttributes = {}

function attributeProfiler:getMainRoleAttributes(role)
	table.clear(mainRoleAttributes)
	
	local mainSkills = self:getMainRoleSkills(role)
	
	for key, skillID in ipairs(mainSkills) do
		local data = skills.registeredByID[skillID]
		
		if data.attributeBoost then
			for attributeID, mult in pairs(data.attributeBoost) do
				mainRoleAttributes[attributeID] = true
			end
		end
	end
	
	return mainRoleAttributes
end

function attributeProfiler:getRoleSkillAdvanceModifier(target, skillID)
	return attributeProfiler.rolesByID[target:getRole()].skillAdvanceModifier[skillID] * target:getOverallSkillProgressionMultiplier()
end

require("game/developer/roles")
