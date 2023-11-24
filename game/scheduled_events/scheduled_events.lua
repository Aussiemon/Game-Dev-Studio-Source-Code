scheduledEvents = {}
scheduledEvents.registered = {}
scheduledEvents.registeredByID = {}
scheduledEvents.bufferedEventsByYear = {}
scheduledEvents.bufferedEventsByYearOrder = {}
scheduledEvents.bufferedEvents = {}
scheduledEvents.activatedEvents = {}
scheduledEvents.cancelledEvents = {}
scheduledEvents.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_YEAR
}
scheduledEvents.TYPE = {
	BUFFERED = 2,
	SCHEDULED = 1
}

local defaultEventFuncs = {}

defaultEventFuncs.mtindex = {
	__index = defaultEventFuncs
}

function defaultEventFuncs:init()
end

function defaultEventFuncs:initEventHandler()
	if self.CATCHABLE_EVENTS then
		events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
	end
end

function defaultEventFuncs:removeEventHandler()
	if self.CATCHABLE_EVENTS then
		events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
	end
end

function defaultEventFuncs:remove()
	self:removeEventHandler()
end

function defaultEventFuncs:validateEvent()
	if self.factToSet and studio:getFact(self.factToSet) then
		return true
	end
	
	return false
end

function defaultEventFuncs:canActivateLoad()
	return self:canActivate()
end

function defaultEventFuncs:canActivate()
	if self.date then
		local curTime = timeline:yearToTime(timeline:getYear()) + timeline:monthToTime(timeline:getMonth())
		local eventTime = 0
		
		if self.date.year then
			eventTime = eventTime + timeline:yearToTime(self.date.year)
		end
		
		if self.date.month then
			eventTime = eventTime + timeline:monthToTime(self.date.month)
		end
		
		if curTime < eventTime then
			return false
		end
	end
	
	return true
end

function defaultEventFuncs:cancel()
	scheduledEvents.cancelledEvents[self.id] = true
	
	self:onCancel()
end

function defaultEventFuncs:onCancel()
end

function defaultEventFuncs:isCancelled()
	return scheduledEvents.cancelledEvents[self.id]
end

function defaultEventFuncs:activate()
	scheduledEvents.activatedEvents[self.id] = true
	
	if self.factToSet then
		studio:setFact(self.factToSet, true)
	end
end

function defaultEventFuncs:getID()
	return self.id
end

defaultEventFuncs.CAN_SAVE = false

function defaultEventFuncs:canSave()
	return defaultEventFuncs.CAN_SAVE
end

function defaultEventFuncs:save()
	return {
		id = self.id
	}
end

function defaultEventFuncs:load()
	error("calling 'load' on a scheduledEvent object without a proper 'load' method")
end

function scheduledEvents:registerNew(data, inherit)
	table.insert(scheduledEvents.registered, data)
	
	scheduledEvents.registeredByID[data.id] = data
	data.mtindex = {
		__index = data
	}
	
	if data.inactive == nil then
		data.inactive = false
	end
	
	if inherit then
		local class = scheduledEvents.registeredByID[inherit]
		
		setmetatable(data, class.mtindex)
		
		data.baseClass = class
	else
		setmetatable(data, defaultEventFuncs.mtindex)
		
		data.baseClass = defaultEventFuncs
	end
end

function scheduledEvents:getData(id)
	return scheduledEvents.registeredByID[id]
end

function scheduledEvents:instantiateEvent(id)
	local data = scheduledEvents.registeredByID[id]
	local new = {}
	
	setmetatable(new, data.mtindex)
	new:init()
	new:initEventHandler()
	
	new.CAN_SAVE = true
	self.bufferedEvents[#self.bufferedEvents + 1] = new
	
	return new
end

function scheduledEvents:init()
	table.clear(self.bufferedEvents)
	table.clear(self.bufferedEventsByYear)
	table.clear(self.activatedEvents)
	table.clear(self.cancelledEvents)
	events:addDirectReceiver(self, scheduledEvents.CATCHABLE_EVENTS)
end

function scheduledEvents:remove()
	events:removeDirectReceiver(self, scheduledEvents.CATCHABLE_EVENTS)
	
	for key, event in ipairs(self.bufferedEvents) do
		event:remove()
		
		self.bufferedEvents[key] = nil
	end
	
	for key, yearList in pairs(self.bufferedEventsByYear) do
		for key, monthList in pairs(yearList) do
			for key, event in ipairs(monthList) do
				event:remove()
				
				monthList[key] = nil
			end
			
			yearList[key] = nil
		end
		
		self.bufferedEventsByYear[key] = nil
	end
	
	table.clear(self.bufferedEventsByYear)
	table.clear(self.activatedEvents)
	table.clear(self.cancelledEvents)
	table.clearArray(self.bufferedEventsByYearOrder)
end

function scheduledEvents:handleEvent(event)
	self:attemptToActivateEvent()
end

function scheduledEvents:attemptToActivateEvent()
	local year = timeline:getYear()
	local eventsThisTime = self.bufferedEventsByYear[year]
	local activated = false
	
	if eventsThisTime then
		eventsThisTime = eventsThisTime[timeline:getMonth()]
		
		if eventsThisTime then
			activated = self:_attemptToActivateEvent(eventsThisTime)
		end
	end
	
	local buffActive = self:_attemptToActivateEvent(self.bufferedEvents)
	
	if activated or buffActive then
		studio:postScheduledEventActivated(self.isQuiet)
	end
	
	self.isQuiet = nil
end

function scheduledEvents:removeBufferedEvent(eventObj)
	eventObj:remove()
	
	return table.removeObject(self.bufferedEvents, eventObj)
end

function scheduledEvents:_attemptToActivateEvent(eventList, loading)
	local realKey = 1
	local activated = false
	
	if loading then
		for key = 1, #eventList do
			local eventData = eventList[realKey]
			
			if eventData:canActivateLoad() then
				eventData:activate()
				
				activated = true
				
				if eventData:validateEvent() then
					eventData:remove()
					table.remove(eventList, realKey)
				else
					realKey = realKey + 1
				end
			end
		end
	else
		for key = 1, #eventList do
			local eventData = eventList[realKey]
			
			if eventData:canActivate() then
				eventData:activate()
				
				activated = true
				
				if eventData:validateEvent() then
					eventData:remove()
					table.remove(eventList, realKey)
				else
					realKey = realKey + 1
				end
			end
		end
	end
	
	return activated
end

local function sortByYear(a, b)
	return a < b
end

function scheduledEvents:fillActiveEvents()
	table.clearArray(self.bufferedEventsByYearOrder)
	
	for key, eventData in ipairs(scheduledEvents.registered) do
		if not eventData.inactive and not eventData:validateEvent() then
			local dateData = eventData.date
			
			if dateData then
				local year = dateData.year
				local yearList = self.bufferedEventsByYear[year]
				
				if not yearList then
					yearList = {}
					self.bufferedEventsByYear[year] = yearList
					self.bufferedEventsByYearOrder[#self.bufferedEventsByYearOrder + 1] = year
				end
				
				local month = dateData.month and dateData.month or 1
				local monthList = yearList[month] or {}
				
				yearList[month] = monthList
				monthList[#monthList + 1] = eventData
			else
				self.bufferedEvents[#self.bufferedEvents + 1] = eventData
			end
		end
	end
	
	table.sort(self.bufferedEventsByYearOrder, sortByYear)
end

function scheduledEvents:save()
	local saved = {
		events = {},
		activatedEvents = self.activatedEvents,
		cancelledEvents = self.cancelledEvents
	}
	
	for key, eventData in ipairs(self.bufferedEvents) do
		if eventData.CAN_SAVE then
			table.insert(saved.events, eventData:save())
		end
	end
	
	return saved
end

function scheduledEvents:load(data)
	self.activatedEvents = data.activatedEvents or self.activatedEvents
	self.cancelledEvents = data.cancelledEvents or self.cancelledEvents
	
	for key, eventData in ipairs(data.events) do
		local object = self:instantiateEvent(eventData.id)
		
		object:load(eventData)
	end
end

function scheduledEvents:getEventByID(id)
	local eventData = self.registeredByID[id]
	
	if eventData.date then
		local dateData = eventData.date
		
		if self.bufferedEventsByYear[dateData.year] and self.bufferedEventsByYear[dateData.year][dateData.month] then
			local event, eventKey
			
			for key, eventData in ipairs(self.bufferedEventsByYear[dateData.year][dateData.month]) do
				if eventData.id == id then
					eventKey = key
					event = eventData
					
					break
				end
			end
			
			if event then
				return event, scheduledEvents.TYPE.SCHEDULED, eventKey
			end
		end
	end
	
	for key, event in ipairs(self.bufferedEvents) do
		if event.id == eventData.id then
			return event, scheduledEvents.TYPE.BUFFERED, key
		end
	end
	
	return nil
end

function scheduledEvents:wasActivated(id)
	return self.activatedEvents[id]
end

function scheduledEvents:cancel(id)
	local event, eventType, key = scheduledEvents:getEventByID(id)
	
	if event then
		event:cancel()
		
		if eventType == scheduledEvents.TYPE.SCHEDULED then
			local dateData = event.date
			
			table.remove(self.bufferedEventsByYear[dateData.year][dateData.month], key)
		elseif eventType == scheduledEvents.TYPE.BUFFERED then
			table.remove(self.bufferedEvents, key)
		end
	end
end

function scheduledEvents:activateInactiveEvents(quiet)
	self.isQuiet = quiet
	
	self:fillActiveEvents()
	
	local curYear = timeline:getYear()
	local curMonth = timeline:getMonth()
	local activated
	local eventList = self.bufferedEventsByYear
	
	for key, year in ipairs(self.bufferedEventsByYearOrder) do
		for month, dataList in pairs(eventList[year]) do
			local result = self:_attemptToActivateEvent(dataList, true)
			
			activated = activated or result
		end
	end
	
	local result = self:_attemptToActivateEvent(self.bufferedEvents, true)
	
	activated = activated or result
	
	if activated then
		studio:postScheduledEventActivated(self.isQuiet)
	end
end

require("game/scheduled_events/scheduled_tech_release_date_base")
require("game/scheduled_events/game_leak_response_event")
require("game/scheduled_events/timed_unlock")
require("game/scheduled_events/generic_timed_popup")
require("game/scheduled_events/release_platform_event")
require("game/scheduled_events/convention_availability")
require("game/scheduled_events/lets_player_availability")
require("game/scheduled_events/delayed_reputation_drop")
require("game/scheduled_events/cancelled_game_disappointment")
require("game/scheduled_events/mmo_evaluate_sub_fee")
require("game/scheduled_events/mmo_shutdown_penalty")
require("game/scheduled_events/mmo_expansion_cooldown")
require("game/scheduled_events/server_capacity_increase")
require("game/scheduled_events/platform_dev_search")
require("game/scheduled_events/platform_impression_result")
require("game/scheduled_events/platform_discontinue_penalty")
require("game/scheduled_events/platform_part_advance")
require("game/scheduled_events/platform_cost_evaluation")
require("game/scheduled_events/word_of_mouth")
require("game/scheduled_events/generic_knowledge_popularity_boost")
require("game/scheduled_events/demo_evaluation")
require("game/scheduled_events/screenshots_evaluation")
require("game/scheduled_events/game_edition_reaction")
