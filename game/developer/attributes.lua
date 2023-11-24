attributes = {}
attributes.registered = {}
attributes.registeredByID = {}
attributes.DEFAULT_MIN = 0
attributes.DEFAULT_MAX = 10
attributes.DEFAULT_ATTRIBUTE_POINTS_TO_INCREASE = 1
attributes.DEFAULT_START = 0
attributes.EVENTS = {
	INCREASED_ATTRIBUTE = events:new()
}

local baseAttributeFuncs = {}

baseAttributeFuncs.mtindex = {
	__index = baseAttributeFuncs
}

function baseAttributeFuncs:init()
end

function baseAttributeFuncs:fillInteractionComboBox(employee, comboBox)
end

function baseAttributeFuncs:onChanged(employee, level)
end

function attributes:getRequiredAttributePoints(employee, desiredAttribute)
	return attributes.DEFAULT_ATTRIBUTE_POINTS_TO_INCREASE
end

function attributes:registerNew(data)
	table.insert(attributes.registered, data)
	
	attributes.registeredByID[data.id] = data
	data.minLevel = data.minLevel or attributes.DEFAULT_MIN
	data.maxLevel = data.maxLevel or attributes.DEFAULT_MAX
	data.startLevel = data.startLevel or attributes.DEFAULT_START
	data.icon = data.icon or "employee"
	
	setmetatable(data, baseAttributeFuncs.mtindex)
end

function attributes:getData(attributeID)
	return attributes.registeredByID[attributeID]
end

function attributes:getMaxLevel(attributeID)
	return attributes.registeredByID[attributeID].maxLevel
end

function attributes:getPercentageToMax(level, attributeID)
	return level / attributes.registeredByID[attributeID].maxLevel
end

function attributes:initAttributes(target)
	local newAttributes = {}
	
	for key, data in ipairs(attributes.registered) do
		newAttributes[data.id] = data.startLevel
		
		data:init(target)
	end
	
	target:setAttributes(newAttributes)
end

function attributes:canProgress(target, statID)
	local targetAttributes = target:getAttributes()
	local curAttribute = targetAttributes[statID]
	local attributeData = attributes.registeredByID[statID]
	
	return curAttribute < attributeData.maxLevel
end

function attributes:increaseAttribute(target, statID, amount)
	local targetAttributes = target:getAttributes()
	local curAttribute = targetAttributes[statID]
	local attributeData = attributes.registeredByID[statID]
	
	amount = amount or 1
	targetAttributes[statID] = math.clamp(curAttribute + amount, attributeData.minLevel, attributeData.maxLevel)
	
	attributeData:onChanged(target, targetAttributes[statID])
	skills:updateSkillDevSpeedAffector(target)
	events:fire(attributes.EVENTS.INCREASED_ATTRIBUTE, target)
end

require("game/developer/basic_attributes")
require("game/developer/attribute_profiler")
