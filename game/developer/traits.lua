traits = {}
traits.registered = {}
traits.registeredByID = {}
traits.lastFittingTraits = {}
traits.MIN_PER_DEVELOPER = 0
traits.MAX_PER_DEVELOPER = 2
traits.DEFAULT_CHANCE = 100
traits.maxDiscoveryLevel = 0
traits.descboxWrapWidth = 400

local defaultTraitFuncs = {}

defaultTraitFuncs.mtindex = {
	__index = defaultTraitFuncs
}

function defaultTraitFuncs:canHaveInterest(target, interestID)
	return true
end

function defaultTraitFuncs:assignTrait(target)
end

function defaultTraitFuncs:onEvent(...)
end

function defaultTraitFuncs:formatDescriptionText(descBox, employee, wrapWidth, font)
end

function defaultTraitFuncs:onRoomChanged(target)
end

function defaultTraitFuncs:fillSuggestionList(employee, list, dialogueObject)
end

function defaultTraitFuncs:adjustMotivationalSpeechScore(speaker, baseScore)
	return baseScore
end

function defaultTraitFuncs:adjustGameConventionScore(employee, baseScore)
	return baseScore
end

function traits:registerNew(data, inherit)
	if inherit then
		setmetatable(data, traits.registeredByID[inherit].mtindex)
	else
		setmetatable(data, defaultTraitFuncs.mtindex)
	end
	
	data.chance = data.chance or traits.DEFAULT_CHANCE
	
	table.insert(traits.registered, data)
	
	traits.registeredByID[data.id] = data
	
	if data.discoveryLevel then
		self.maxDiscoveryLevel = math.max(self.maxDiscoveryLevel, data.discoveryLevel)
	end
	
	if data.description then
		data.hoverText = rawget(data, "hoverText") or {
			{
				font = "pix20",
				text = data.description,
				wrapWidth = traits.descboxWrapWidth
			}
		}
	end
	
	if data.selectableForPlayer == nil then
		data.selectableForPlayer = true
	end
	
	data.quad = data.quad or "employee"
	data.mtindex = {
		__index = data
	}
end

require("game/developer/basic_traits")

function traits:assignFittingTraits(target)
	local fittingTraits = self:getFittingTraits(target)
	local traitsToAssign = math.min(math.random(traits.MIN_PER_DEVELOPER, traits.MAX_PER_DEVELOPER), #fittingTraits)
	
	while traitsToAssign > 0 and #fittingTraits > 0 do
		local randIndex = math.random(1, #fittingTraits)
		local traitData = fittingTraits[randIndex]
		
		if math.random(1, 100) <= traitData.chance then
			if not self:isConflicting(traitData, target) then
				target:addTrait(traitData.id)
				table.remove(fittingTraits, randIndex)
				self:assignTraitValues(target)
				
				traitsToAssign = traitsToAssign - 1
			else
				table.remove(fittingTraits, randIndex)
			end
		else
			table.remove(fittingTraits, randIndex)
		end
	end
	
	table.clear(self.lastFittingTraits)
end

function traits:assignTraitValues(target)
	local curIndex = 1
	local targetTraits = target:getTraits()
	
	for i = 1, #targetTraits do
		local curTrait = targetTraits[curIndex]
		local traitData = traits.registeredByID[curTrait]
		
		if traitData then
			if traitData.assignTrait then
				traitData:assignTrait(target)
			end
			
			curIndex = curIndex + 1
		else
			table.remove(targetTraits, curIndex)
		end
	end
end

function traits:getFittingTraits(target)
	table.clear(self.lastFittingTraits)
	
	for key, data in ipairs(traits.registered) do
		if self:isTraitFitting(target, data) then
			table.insert(self.lastFittingTraits, data)
		end
	end
	
	return self.lastFittingTraits
end

function traits:isConflicting(traitData, target)
	if traitData.conflictingTraits then
		for incompatibility, state in pairs(traitData.conflictingTraits) do
			if target:hasTrait(incompatibility) then
				return true
			end
		end
	end
	
	return false
end

function traits:isConflictingWith(traitData, otherTraitID)
	if traitData.conflictingTraits then
		return traitData.conflictingTraits[otherTraitID]
	end
	
	return false
end

function traits:canPlayerSelectTrait(traitData, target, currentTraitID)
	local regTraits = traits.registeredByID
	
	if traitData.selectableForPlayer and not target:hasTrait(traitData.id) then
		for key, id in ipairs(target:getTraits()) do
			local data = regTraits[id]
			
			if self:isConflictingWith(traitData, id) then
				return false
			end
		end
		
		local conflictPresent = traits:isConflicting(traitData, target)
		
		if not conflictPresent or conflictPresent and self:isConflictingWith(traitData, currentTraitID) then
			return true
		end
	end
	
	return false
end

function traits:isTraitFitting(target, traitData)
	if traitData.roleRequirement and not traitData.roleRequirement[target:getRole()] then
		return false
	end
	
	if self:isConflicting(traitData, target) then
		return false
	end
	
	if traitData.attributeRequirements then
		local anyMatchingAttribute = traitData.attributeRequirementMode == "any"
		local isValid = false
		
		for attributeID, requiredLevel in pairs(traitData.attributeRequirements) do
			if requiredLevel > target:getAttribute(attributeID) then
				return false
			elseif anyMatchingAttribute then
				isValid = true
			end
		end
		
		if anyMatchingAttribute and not isValid then
			return false
		end
	end
	
	if traitData.levelRequirement and target:getLevel() < traitData.levelRequirement then
		return false
	end
	
	return true
end

function traits:getData(id)
	return traits.registeredByID[id]
end
