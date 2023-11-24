randomEvents = {}
randomEvents.registered = {}
randomEvents.registeredByCategory = {}
randomEvents.registeredByID = {}
randomEvents.registeredByEvent = {}
randomEvents.allCategories = {}
randomEvents.allCategoriesNumeric = {}
randomEvents.DEFAULT_CATEGORY = "misc"
randomEvents.DEFAULT_ROLL_MIN_MAX = {
	1,
	1000
}
randomEvents.CATCHABLE_EVENTS = {}

function randomEvents:init()
	events:addDirectReceiver(self, randomEvents.CATCHABLE_EVENTS)
end

function randomEvents:remove()
	events:removeDirectReceiver(self, randomEvents.CATCHABLE_EVENTS)
end

function randomEvents:registerNew(data)
	table.insert(randomEvents.registered, data)
	
	randomEvents.registeredByID[data.id] = data
	
	if type(data.eventRequirement) ~= "table" then
		randomEvents.registeredByEvent[data.eventRequirement] = randomEvents.registeredByEvent[data.eventRequirement] or {}
		
		table.insert(randomEvents.registeredByEvent[data.eventRequirement], data)
		
		if not table.find(randomEvents.CATCHABLE_EVENTS, data.eventRequirement) then
			table.insert(randomEvents.CATCHABLE_EVENTS, data.eventRequirement)
		end
	else
		for event, state in pairs(data.eventRequirement) do
			randomEvents.registeredByEvent[event] = randomEvents.registeredByEvent[event] or {}
			
			table.insert(randomEvents.registeredByEvent[event], data)
			
			if not table.find(randomEvents.CATCHABLE_EVENTS, event) then
				table.insert(randomEvents.CATCHABLE_EVENTS, event)
			end
		end
	end
	
	if not data.rollMin then
		data.rollMin = randomEvents.DEFAULT_ROLL_MIN_MAX[1]
	end
	
	if not data.rollMax then
		data.rollMax = randomEvents.DEFAULT_ROLL_MIN_MAX[2]
	end
	
	data.category = data.category or randomEvents.DEFAULT_CATEGORY
	randomEvents.registeredByCategory[data.category] = randomEvents.registeredByCategory[data.category] or {}
	
	table.insert(randomEvents.registeredByCategory[data.category], data)
	
	if not randomEvents.allCategories[data.category] then
		randomEvents.allCategories[data.category] = true
		
		table.insert(randomEvents.allCategoriesNumeric, data.category)
	end
end

function randomEvents:getData(eventID)
	return randomEvents.registeredByID[eventID]
end

function randomEvents:handleEvent(event, ...)
	self:rollEvent(event, ...)
end

function randomEvents:rollEvent(event, ...)
	local eventList = randomEvents.registeredByEvent[event]
	
	if eventList then
		for key, data in ipairs(eventList) do
			if self:canEventOccur(data, event, ...) and math.random(data.rollMin, data.rollMax) <= data.occurChance then
				data:occur(...)
				
				if data.breakCategoryLoop then
					break
				end
			end
		end
	end
end

function randomEvents:canEventOccur(eventData, event, ...)
	if eventData.eventRequirement then
		if type(eventData.eventRequirement) ~= "table" then
			if eventData.eventRequirement ~= event then
				return false
			end
		elseif not eventData.eventRequirement[event] then
			return false
		end
	end
	
	if eventData.canOccur and not eventData:canOccur(event, ...) then
		return false
	end
	
	return true
end

require("game/random_events/employees")
require("game/random_events/game_leak")
require("game/random_events/fan_wants_to_work")
