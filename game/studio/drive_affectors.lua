studio.driveAffectors = {}

local driveAffectors = studio.driveAffectors

driveAffectors.registered = {}
driveAffectors.registeredByID = {}
driveAffectors.currentAffectors = {}
driveAffectors.negativeAffectors = {}
driveAffectors.totalAffector = 0
driveAffectors.botherDelay = 7
driveAffectors.FRUSTRATION_LOSS_PER_DAY = -1
driveAffectors.EVENTS = {
	FORCE_RECALCULATE = events:new()
}
driveAffectors.RECALCULATE_ON_EVENT = {
	[driveAffectors.EVENTS.FORCE_RECALCULATE] = true,
	[studio.EVENTS.EMPLOYEE_HIRED] = true,
	[studio.EVENTS.EMPLOYEE_FIRED] = true,
	[studio.EVENTS.EMPLOYEE_LEFT] = true
}
driveAffectors.CATCHABLE_EVENTS = {
	driveAffectors.EVENTS.FORCE_RECALCULATE,
	studio.EVENTS.EMPLOYEE_HIRED,
	studio.EVENTS.EMPLOYEE_FIRED,
	studio.EVENTS.EMPLOYEE_LEFT,
	studio.expansion.EVENTS.EXPANDED_OFFICE,
	studio.expansion.EVENTS.POST_PLACED_OBJECT,
	studio.expansion.EVENTS.POST_REMOVED_OBJECT,
	timeline.EVENTS.NEW_DAY
}
driveAffectors.EMPLOYEE_EVENTS = {
	[studio.EVENTS.EMPLOYEE_HIRED] = true,
	[studio.EVENTS.EMPLOYEE_FIRED] = true,
	[studio.EVENTS.EMPLOYEE_LEFT] = true
}
driveAffectors.OBJECT_EVENTS = {
	[studio.expansion.EVENTS.POST_PLACED_OBJECT] = true,
	[studio.expansion.EVENTS.POST_REMOVED_OBJECT] = true
}

local defaultDriveAffectorFuncs = {}

defaultDriveAffectorFuncs.mtindex = {
	__index = defaultDriveAffectorFuncs
}

function defaultDriveAffectorFuncs:createDriveBoostDisplay(officeObject)
	local display = gui.create("DriveAffectorBoostDisplay")
	
	display:setHeight(34)
	display:setDriveAffector(self.id)
	display:setIcon(self.icon)
	display:setFont("pix22")
	display:setOffice(officeObject)
	
	local affector = officeObject:getDriveAffector(self.id) or 0
	
	if affector < 0 and self.boostTextNotEnough then
		display:setIcon("attention", 1, 1)
		display:addText(self.boostTextNotEnough, game.UI_COLORS.IMPORTANT_2, nil, nil)
		display:addText(string.easyformatbykeys(_T("DRIVE_BOOST_POINT_LOSS", "POINTS points"), "POINTS", affector), game.UI_COLORS.RED, nil, nil)
	else
		display:setIcon("increase", 1, 1)
		
		if self.mandatory then
			display:addText(self.boostTextEnough, nil, nil, nil)
		elseif affector > 0 then
			display:addText(self.boostText, nil, nil, nil)
			display:addText(string.easyformatbykeys(_T("DRIVE_BOOST_POINT_INCREASE", "POINTS points"), "POINTS", affector), display:getBoostTextColor(), nil, nil)
		else
			display:addText(self.boostTextNotMandatory, nil, nil, nil)
		end
	end
	
	return display
end

function defaultDriveAffectorFuncs:formatDescriptionText(officeObject, descBox, wrapWidth)
	local affectors, drivePoints = officeObject:getDriveAffectors()
	local driveChange = math.min(self.driveAffectionMax, drivePoints[self.id] or 0)
	
	if driveChange ~= 0 then
		descBox:addSpaceToNextText(5)
		
		local text, textColor, icon
		
		if driveChange < 0 then
			icon = "decrease_red"
			textColor = game.UI_COLORS.RED
			text = _format(_T("DRAINS_DRIVE_BY", "Drains drive by POINTS points."), "POINTS", math.round(math.abs(driveChange), 2))
		elseif driveChange > 0 then
			icon = "increase"
			textColor = game.UI_COLORS.LIGHT_BLUE
			text = _format(_T("BOOSTS_DRIVE_BY", "Boosts drive by POINTS points."), "POINTS", math.round(driveChange, 2))
		end
		
		descBox:addText(text, "bh20", textColor, 0, wrapWidth, icon, 22, 22)
	end
end

function defaultDriveAffectorFuncs:isEnoughOf(officeObject)
	if self.mandatory or self.allowNegative then
		local affector = officeObject:getDriveAffector(self.id) or 0
		
		if affector < 0 then
			return false, affector
		end
		
		return true, affector
	end
	
	return true, 0
end

function defaultDriveAffectorFuncs:getNotEnoughText()
	return self.notEnoughText
end

function driveAffectors:registerNew(data)
	table.insert(driveAffectors.registered, data)
	
	driveAffectors.registeredByID[data.id] = data
	
	setmetatable(data, defaultDriveAffectorFuncs.mtindex)
	
	data.baseClass = defaultDriveAffectorFuncs
	data.driveAffectionMin = data.driveAffectionMin or -math.huge
	data.perEmployee = data.perEmployee or 0
	data.driveAffectionMultiplierExponent = data.driveAffectionMultiplierExponent or 1
	data.basePointValue = data.basePointValue or 0
	
	if data.mandatory or data.allowNegative then
		table.insert(developer.STUDIO_REQUIREMENTS, {
			id = data.id,
			perEmployee = data.perEmployee
		})
	end
end

function driveAffectors:init()
	events:addDirectReceiver(self, driveAffectors.CATCHABLE_EVENTS)
	
	self.botherTime = 0
end

function driveAffectors:remove()
	events:removeDirectReceiver(self, driveAffectors.CATCHABLE_EVENTS)
end

function driveAffectors:getData(affectorID)
	return driveAffectors.registeredByID[affectorID]
end

eventBoxText:registerNew({
	id = "negative_drive_affector",
	getText = function(self, data)
		return _format(driveAffectors.registeredByID[data.affector].negativeEffectText, "OFFICE", data.building:getName())
	end,
	saveData = function(self, data)
		return {
			affector = data.affector,
			building = data.building:getID()
		}
	end,
	loadData = function(self, targetElement, data)
		data.building = game.worldObject:getBuildingByID(data.building)
		
		return data
	end
})

function driveAffectors:handleEvent(event, object)
	if driveAffectors.RECALCULATE_ON_EVENT[event] then
		local officeObject
		
		if driveAffectors.EMPLOYEE_EVENTS[event] or driveAffectors.OBJECT_EVENTS[event] then
			officeObject = object:getOffice()
		elseif event == studio.expansion.EVENTS.EXPANDED_OFFICE then
			officeObject = object
		end
		
		if officeObject then
			self:calculateDriveAffection(officeObject)
		end
	end
	
	if event == timeline.EVENTS.NEW_DAY then
		local id, highest, office = nil, -math.huge
		
		for key, officeObject in ipairs(studio:getOwnedBuildings()) do
			local curID, amount = self:getHighestNegativeContributor(officeObject)
			
			if curID and highest < amount then
				highest = amount
				id = curID
				office = officeObject
			end
		end
		
		if id and timeline.curTime > self.botherTime then
			local data = driveAffectors.registeredByID[id]
			
			if data.mandatory then
				game.addToEventBox("negative_drive_affector", {
					affector = id,
					building = office
				}, gui.getElementType("EventBox").IMPORTANCE.HIGH)
				
				self.botherTime = timeline.curTime + driveAffectors.botherDelay
			end
		end
	end
end

function driveAffectors:calculateDriveAffection(officeObject)
	if studio._updatingRooms or game.worldObject:isFinishingLoad() or not officeObject:isPlayerOwned() then
		return 
	end
	
	local affectorPoints, affectorValues = officeObject:getDriveAffectors()
	
	for key, data in ipairs(driveAffectors.registered) do
		local baseValue = data.basePointValue
		
		affectorPoints[data.id] = baseValue
		affectorValues[data.id] = baseValue * data.driveAffectionMultiplier
	end
	
	local totalAffector = 0
	local employees = officeObject:getEmployees()
	local employeeCount = #employees
	
	for key, data in ipairs(developer.STUDIO_REQUIREMENTS) do
		affectorPoints[data.id] = affectorPoints[data.id] + data.perEmployee * -employeeCount
	end
	
	for key, object in ipairs(officeObject:getObjects()) do
		if object:canBeUsed() then
			for key, data in ipairs(object:getDriveAffector()) do
				local affector, amount = data[1], data[2]
				local cur = affectorPoints[affector]
				
				if cur then
					affectorPoints[affector] = cur + amount
				else
					affectorPoints[affector] = amount
				end
			end
		end
	end
	
	local frustrationChange = 0
	
	for key, data in ipairs(driveAffectors.registered) do
		local affector, amount = data.id, affectorPoints[data.id]
		
		if amount then
			local value = self:calculateAffectionAmount(affector, amount, employeeCount)
			
			affectorValues[affector] = value
			totalAffector = totalAffector + value
			
			local data = driveAffectors.registeredByID[affector]
			
			if value < 0 and data.mandatory then
				frustrationChange = frustrationChange + data.frustration
			end
		end
	end
	
	if frustrationChange == 0 then
		frustrationChange = driveAffectors.FRUSTRATION_LOSS_PER_DAY
	end
	
	officeObject:setTotalDriveAffector(totalAffector)
	officeObject:setFrustrationChange(frustrationChange)
end

function driveAffectors:getNegativeContributors(officeObject)
	table.clear(self.negativeAffectors)
	
	local affectors, affectorValues = officeObject:getDriveAffectors()
	
	for contributor, amount in pairs(affectorValues) do
		if amount < 0 then
			self.negativeAffectors[#self.negativeAffectors + 1] = contributor
		end
	end
	
	return self.negativeAffectors
end

function driveAffectors:getHighestNegativeContributor(officeObject)
	local highest, id = math.huge
	
	for contributor, amount in pairs(officeObject:getDriveAffectors()) do
		if driveAffectors.registeredByID[contributor].mandatory and amount < 0 and amount < highest then
			highest = amount
			id = contributor
		end
	end
	
	return id, highest
end

function driveAffectors:calculateAffectionAmount(affector, amount, employeeCount)
	local data = driveAffectors.registeredByID[affector]
	local affection = amount
	
	if data.subtractByEmployeeCount then
		affection = affection - employeeCount
	end
	
	if data.divideByEmployeeCount then
		affection = affection / employeeCount
	end
	
	local wasNegative = affection < 0
	local affection = math.abs(affection)^data.driveAffectionMultiplierExponent * data.driveAffectionMultiplier
	
	affection = wasNegative and -affection or affection
	affection = math.clamp(affection, data.driveAffectionMin, data.driveAffectionMax)
	
	return affection
end

local sanitary = {
	driveAffectionMax = 0,
	mandatory = true,
	driveAffectionMultiplierExponent = 1.3,
	driveAffectionMultiplier = 0.1,
	employeeInquirySuggestion = "drive_affector_not_enough_restrooms",
	id = "sanitary",
	frustration = 2,
	perEmployee = 1,
	description = _T("SANITARY_DRIVE_AFFECTOR_DESCRIPTION", "Restrooms are mandatory for any type of building.\nThere might be a forest outside, but that doesn't mean your employees should go there."),
	negativeEffectText = _T("OFFICE_COULD_USE_MORE_RESTROOMS", "'OFFICE' could use more restrooms."),
	notEnoughText = _T("NOT_ENOUGH_RESTROOMS", "Not enough restrooms"),
	affectorText = _T("SANITARY_AFFECTOR_TEXT", "Allows for CHANGE more employees"),
	frustrationLeaveText = _T("SANITARY_FRUSTRATION_LEAVE", "The office does not have enough restrooms. I don't know about you, but I don't want to go relieve myself outside the office under a tree."),
	boostTextNotEnough = _T("NOT_ENOUGH_RESTROOMS", "Not enough restrooms"),
	boostTextEnough = _T("ENOUGH_RESTROOMS", "Restrooms OK")
}

function sanitary:formatDescriptionText(officeObject, descBox, wrapWidth)
	local enough, delta = self:isEnoughOf(officeObject)
	
	delta = math.floor(delta / self.perEmployee)
	
	descBox:addSpaceToNextText(4)
	
	if not enough then
		descBox:addText(_T("OFFICE_NOT_ENOUGH_RESTROOMS", "The office does not have enough restrooms."), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	elseif delta == 1 then
		descBox:addText(_T("ENOUGH_RESTROOMS_FOR_1_PERSON", "The office has enough restrooms for 1 more employee."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 24, 24)
	elseif delta == 0 then
		descBox:addText(_T("ENOUGH_RESTROOMS_LIMIT", "You will need to construct more restrooms if you plan on hiring more people."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 24, 24)
	else
		descBox:addText(_format(_T("ENOUGH_RESTROOMS_FOR_NUMBER_PEOPLE", "The office has enough restrooms for EMPLOYEES more employees."), "EMPLOYEES", delta), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 24, 24)
	end
	
	sanitary.baseClass.formatDescriptionText(self, officeObject, descBox, wrapWidth)
end

driveAffectors:registerNew(sanitary)
dialogueHandler.registerQuestion({
	id = "drive_affector_not_enough_restrooms",
	text = _T("DRIVE_AFFECTOR_NOT_ENOUGH_RESTROOMS", "There aren't enough restrooms in the office, I don't know about you, but the idea of going outside to relieve myself doesn't seem right."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})

local water = {
	driveAffectionMax = 0,
	mandatory = true,
	driveAffectionMultiplierExponent = 1.1,
	driveAffectionMultiplier = 0.1,
	employeeInquirySuggestion = "drive_affector_not_enough_water_sources",
	id = "water",
	frustration = 1,
	perEmployee = 0.75,
	description = _T("WATER_DRIVE_AFFECTOR_DESCRIPTION", "A source of clean drinking water is necessary for any building, game development studios included.\nPlace water dispensers to supply your employees with drinking water."),
	negativeEffectText = _T("OFFICE_COULD_USE_MORE_WATER", "'OFFICE' could use more some more water dispensers."),
	notEnoughText = _T("NOT_ENOUGH_WATER_DISPENSERS", "Not enough water dispensers"),
	affectorText = _T("WATER_AFFECTOR_TEXT", "Provides water for CHANGE employees"),
	frustrationLeaveText = _T("WATER_FRUSTRATION_LEAVE", "The office doesn't have enough drinking water sources, and I'm constantly thirsty due to that."),
	boostTextNotEnough = _T("NOT_ENOUGH_WATER_SOURCES", "Not enough water sources"),
	boostTextEnough = _T("ENOUGH_WATER_SOURCES", "Water sources OK")
}

function water:formatDescriptionText(officeObject, descBox, wrapWidth)
	local enough, delta = self:isEnoughOf(officeObject)
	
	delta = math.floor(delta / self.perEmployee)
	
	descBox:addSpaceToNextText(4)
	
	if not enough then
		descBox:addText(_T("NOT_ENOUGH_DRINKING_WATER", "The office needs more drinking water sources."), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	elseif delta == 1 then
		descBox:addText(_T("ENOUGH_DRINKING_WATER_FOR_1_PERSON", "The office has enough drinking water sources for 1 more employee."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 24, 24)
	elseif delta < 1 then
		descBox:addText(_T("ENOUGH_DRINKING_WATER_LIMIT", "You will need place more drinking water sources if you plan on hiring more people."), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 24, 24)
	else
		descBox:addText(_format(_T("ENOUGH_DRINKING_WATER_FOR_PERSONS", "The office has drinking water sources for EMPLOYEES more employees."), "EMPLOYEES", delta), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 24, 24)
	end
	
	water.baseClass.formatDescriptionText(self, officeObject, descBox, wrapWidth)
end

driveAffectors:registerNew(water)
dialogueHandler.registerQuestion({
	id = "drive_affector_not_enough_water_sources",
	text = _T("DRIVE_AFFECTOR_NOT_ENOUGH_WATER_SOURCES", "We could use more water dispensers in the office."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
driveAffectors:registerNew({
	driveAffectionMax = 3,
	driveAffectionMin = 0,
	driveAffectionMultiplierExponent = 1,
	subtractByEmployeeCount = true,
	driveAffectionMultiplier = 0.05,
	id = "food",
	divideByEmployeeCount = false,
	description = _T("FOOD_DRIVE_AFFECTOR_DESCRIPTION", "Food is not necessary for the office, but it provides a boost to employee drive levels.\nPlace objects related to food to increase this boost."),
	affectorText = _T("FOOD_AFFECTOR_TEXT", "+CHANGE pts. to Food boost"),
	boostText = _T("FOOD_BOOST", "Food boost"),
	boostTextNotMandatory = _T("NO_FOOD_BOOST_PRESENT", "No food boost")
})
driveAffectors:registerNew({
	allowNegative = true,
	perEmployee = 0.75,
	driveAffectionMax = 2,
	driveAffectionMultiplier = 0.1,
	driveAffectionMultiplierExponent = 1,
	id = "comfort",
	employeeInquirySuggestion = "drive_affector_uncomfortable_office",
	driveAffectionMin = -1,
	basePointValue = 2,
	divideByEmployeeCount = false,
	description = _T("COMFORT_DRIVE_AFFECTOR_DESCRIPTION", "Employees won't leave your studio if an office is uncomfortable, but a comfortable office is better to work in."),
	affectorText = _T("COMFORT_AFFECTOR_TEXT", "+CHANGE pts. to Comfort boost"),
	notEnoughText = _T("UNCOMFORTABLE_OFFICE", "Uncomfortable office"),
	boostText = _T("COMFORT_BOOST", "Comfort boost"),
	boostTextNotEnough = _T("UNCOMFORTABLE_OFFICE", "Uncomfortable office"),
	boostTextNotMandatory = _T("NO_COMFORT_BOOST", "No comfort boost")
})
dialogueHandler.registerQuestion({
	id = "drive_affector_uncomfortable_office",
	text = _T("DRIVE_AFFECTOR_UNCOMFORTABLE_OFFICE", "Our office isn't very comfortable, if it was more comfortable, we wouldn't get tired out so quickly."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
driveAffectors:init()
