consoleManufacturers = {}
consoleManufacturers.registered = {}
consoleManufacturers.registeredByID = {}
consoleManufacturers.manufacturers = {}
consoleManufacturers.manufacturersByID = {}
consoleManufacturers.closedDownManufacturers = {}
consoleManufacturers.SHARE_PERCENTAGE_DEATH_HITPOINTS = 0.07
consoleManufacturers.SHARE_PERCENTAGE_MAX_HITPOINTS = 0.25
consoleManufacturers.SHARE_PERCENTAGE_TO_LOSE_HITPOINTS = 0.1
consoleManufacturers.ADVERTISEMENT_SHARE_PERCENTAGE = 0.1
consoleManufacturers.ADVERTISEMENT_TEXT = {
	_T("PLATFORM_ADVERTISEMENT_1", "MANUFACTURER has taken policy decisions, which made a lot of gamers happy, for their PLATFORM platform.\n\nAn increase in popularity of the platform is expected."),
	_T("PLATFORM_ADVERTISEMENT_2", "MANUFACTURER has recently begun heavy marketing for their PLATFORM platform.\n\nAn increase in popularity of the platform is expected."),
	_T("PLATFORM_ADVERTISEMENT_3", "Rivals of MANUFACTURER have recently made some bad policy decisions in regards to their competing platforms, which has painted PLATFORM in a good light.\n\nAn increase in popularity of the platform is expected."),
	_T("PLATFORM_ADVERTISEMENT_4", "MANUFACTURER has announced some policy changes for their PLATFORM platform, which were met positively by gamers all around the world.\n\nAn increase in popularity of the platform is expected.")
}
consoleManufacturers.ADVERTISEMENT_TEXT_SHORT = _T("PLATFORM_ADVERTISEMENT_SHORT", "An increase in popularity of 'PLATFORM' is expected.")
consoleManufacturers.ADVERTISEMENT_DURATION = {
	timeline.DAYS_IN_MONTH,
	timeline.DAYS_IN_MONTH * 2
}
consoleManufacturers.ADVERTISEMENT_COOLDOWN = timeline.DAYS_IN_MONTH * 6
consoleManufacturers.ADVERTISEMENT_ATTRACTIVENESS_BOOST = {
	1.5,
	4
}
consoleManufacturers.ADVERTISEMENT_CHANCE = 15
consoleManufacturers.HITPOINTS_LOST = 1
consoleManufacturers.SHARE_PERCENTAGE_TO_GAIN_HITPOINTS = 0.2
consoleManufacturers.HITPOINTS_GAINED = 0.5
consoleManufacturers.MAX_HITPOINTS = 200
consoleManufacturers.START_HITPOINTS = 100
consoleManufacturers.DEATH_HITPOINTS = 0
consoleManufacturers.FULL_EXCLUSIVITY_BONUS = 1
consoleManufacturers.PARTIAL_EXCLUSIVITY_BONUS = 2
consoleManufacturers.EXCLUSIVITY_TYPE = {
	FULL = 2,
	PARTIAL = 1,
	NONE = 0
}
consoleManufacturers.EXCLUSIVITY_TYPE_TEXT = {
	[consoleManufacturers.EXCLUSIVITY_TYPE.NONE] = _T("NO_EXCLUSIVITY_BONUS", "No exclusivity bonus"),
	[consoleManufacturers.EXCLUSIVITY_TYPE.PARTIAL] = _T("PARTIAL_EXCLUSIVITY_BONUS", "Partial exclusivity bonus"),
	[consoleManufacturers.EXCLUSIVITY_TYPE.FULL] = _T("FULL_EXCLUSIVITY_BONUS", "Full exclusivity bonus")
}
consoleManufacturers.EXCLUSIVITY_TYPE_ICONS = {
	[consoleManufacturers.EXCLUSIVITY_TYPE.NONE] = "exclamation_point",
	[consoleManufacturers.EXCLUSIVITY_TYPE.PARTIAL] = "increase",
	[consoleManufacturers.EXCLUSIVITY_TYPE.FULL] = "increase"
}

function consoleManufacturers:registerNew(data)
	table.insert(consoleManufacturers.registered, data)
	
	consoleManufacturers.registeredByID[data.id] = data
	data.scheduledPlatformEvents = {}
	data.minimumRatingOffsetForBonus = data.minimumRatingOffsetForBonus or 0
	data.platforms = data.platforms or {}
end

function consoleManufacturers:getExclusivityType(manufacCount)
	if manufacCount <= consoleManufacturers.FULL_EXCLUSIVITY_BONUS then
		return consoleManufacturers.EXCLUSIVITY_TYPE.FULL
	elseif manufacCount <= consoleManufacturers.PARTIAL_EXCLUSIVITY_BONUS then
		return consoleManufacturers.EXCLUSIVITY_TYPE.PARTIAL
	end
	
	return consoleManufacturers.EXCLUSIVITY_TYPE.NONE
end

function consoleManufacturers:getExclusivityTypeText(type)
	return consoleManufacturers.EXCLUSIVITY_TYPE_TEXT[type], consoleManufacturers.EXCLUSIVITY_TYPE_ICONS[type]
end

function consoleManufacturers:getData(id)
	return consoleManufacturers.registeredByID[id]
end

function consoleManufacturers:addScheduledPlatformEvent(id, eventID)
	table.insert(consoleManufacturers.registeredByID[id].scheduledPlatformEvents, eventID)
end

function consoleManufacturers:init()
	self:createManufacturers()
end

function consoleManufacturers:destroy()
	self:destroyAllManufacturers()
end

function consoleManufacturers:getPlatformAdvertisementText(manufacturer, platform)
	local data = manufacturer:getData()
	
	return _format(consoleManufacturers.ADVERTISEMENT_TEXT[math.random(1, #consoleManufacturers.ADVERTISEMENT_TEXT)], "MANUFACTURER", data.display, "PLATFORM", platforms.registeredByID[platform].display)
end

eventBoxText:registerNew({
	id = "platform_advertisement",
	getText = function(self, data)
		return _format(consoleManufacturers.ADVERTISEMENT_TEXT_SHORT, "PLATFORM", platforms.registeredByID[data].display)
	end
})

consoleManufacturers.FIRST_TIME_CONSOLE_ADVERT_POPUP_FACT = "first_time_console_advert_popup"

function consoleManufacturers:handleEvent(event, ...)
	if event == timeline.EVENTS.NEW_WEEK then
		local totalUsers = platformShare.totalUsers
		local realUsers = totalUsers - platformShare:getFreeShare()
		local curTime = timeline.curTime
		local popupCreated, eventBoxPrinted = false, false
		local hpLoss = consoleManufacturers.HITPOINTS_LOST
		local hpGain = consoleManufacturers.HITPOINTS_GAINED
		local deathHp, maxHp = consoleManufacturers.SHARE_PERCENTAGE_DEATH_HITPOINTS, consoleManufacturers.SHARE_PERCENTAGE_MAX_HITPOINTS
		local healthForAdvert = consoleManufacturers.ADVERTISEMENT_SHARE_PERCENTAGE
		local canAdvertise = game.curGametype.allowPlatformAdvertisement
		
		for key, manufacturer in ipairs(self.manufacturers) do
			if manufacturer:getReleasedPlatformCount() > 0 then
				local health = manufacturer:getHealth()
				local percentage = health / realUsers
				
				if manufacturer:canGoBankrupt() then
					local delta = math.max(0, math.min(percentage, maxHp) - deathHp) / (maxHp - deathHp)
					local maxHealth = math.round(consoleManufacturers.MAX_HITPOINTS * delta)
					local hpDiff = maxHealth - manufacturer:getHitpoints()
					local hpChange = math.min(hpGain, math.max(-hpLoss, hpDiff))
					
					if hpChange ~= 0 then
						manufacturer:changeHitpoints(hpChange)
					end
				end
				
				if canAdvertise and healthForAdvert <= percentage and curTime > manufacturer:getAdvertisementCooldown() and math.random(1, 100) <= consoleManufacturers.ADVERTISEMENT_CHANCE then
					local range = consoleManufacturers.ADVERTISEMENT_ATTRACTIVENESS_BOOST
					local multiplier = math.round(math.randomf(range[1], range[2]), 1)
					local range = consoleManufacturers.ADVERTISEMENT_DURATION
					local duration = math.random(range[1], range[2])
					local mostRecentPlatform = manufacturer:getMostRecentPlatform()
					
					if mostRecentPlatform then
						if not studio:getFact(consoleManufacturers.FIRST_TIME_CONSOLE_ADVERT_POPUP_FACT) then
							if not popupCreated then
								local popup = game.createPopup(600, _T("PLATFORM_POPULARITY_INCREASE_TITLE", "Platform Popularity Boost"), self:getPlatformAdvertisementText(manufacturer, mostRecentPlatform), "pix24", "pix20")
								
								frameController:push(popup)
								
								popupCreated = true
								
								studio:setFact(consoleManufacturers.FIRST_TIME_CONSOLE_ADVERT_POPUP_FACT, true)
							end
						elseif not eventBoxPrinted then
							game.addToEventBox("platform_advertisement", mostRecentPlatform, 1)
							
							eventBoxPrinted = true
						end
						
						manufacturer:setAdvertisementInfo(multiplier, duration, mostRecentPlatform)
					end
				end
			end
		end
	end
end

function consoleManufacturers:createManufacturers()
	for key, manufacturerData in ipairs(consoleManufacturers.registered) do
		local id = manufacturerData.id
		
		if not self:hasManufacturer(id) and not self.closedDownManufacturers[id] then
			local obj = self:createManufacturer(id)
			
			table.insert(self.manufacturers, obj)
			
			self.manufacturersByID[id] = obj
		end
	end
end

function consoleManufacturers:destroyAllManufacturers()
	table.clear(self.closedDownManufacturers)
	
	for key, manufacturer in ipairs(self.manufacturers) do
		manufacturer:destroy()
		
		self.manufacturers[key] = nil
		self.manufacturersByID[manufacturer:getID()] = nil
	end
end

function consoleManufacturers:hasManufacturer(id)
	return self.manufacturersByID[id] ~= nil
end

function consoleManufacturers:createManufacturer(id)
	local manufacturer = consoleManufacturer.new(consoleManufacturers.registeredByID[id])
	
	if not self.closedDownManufacturers[id] then
		manufacturer:startReceivingEvents()
	end
	
	return manufacturer
end

function consoleManufacturers:closeDown(manufacturer)
	for key, otherManufacturer in ipairs(self.manufacturers) do
		if otherManufacturer == manufacturer then
			table.remove(self.manufacturers, key)
			
			local id = manufacturer:getID()
			
			self.closedDownManufacturers[id] = true
			self.manufacturersByID[id] = nil
			
			platformShare:removeManufacturerPlatforms(id)
			
			return true
		end
	end
	
	return true
end

function consoleManufacturers:hasManufacturerClosedDown(id)
	return self.closedDownManufacturers[id]
end

function consoleManufacturers:changeHealth(id, amount)
	local manufacturer = self:getManufacturerByID(id)
	
	if manufacturer then
		manufacturer:changeHealth(amount)
	end
end

function consoleManufacturers:getManufacturers()
	return self.manufacturers
end

function consoleManufacturers:getManufacturerByID(id)
	for key, manufacturer in ipairs(self.manufacturers) do
		if manufacturer:getID() == id then
			return manufacturer
		end
	end
	
	return nil
end

function consoleManufacturers:save()
	local saved = {
		manufacturers = {},
		closedDownManufacturers = self.closedDownManufacturers
	}
	
	for key, manufacturer in ipairs(self.manufacturers) do
		table.insert(saved.manufacturers, manufacturer:save())
	end
	
	return saved
end

function consoleManufacturers:load(data)
	self:destroy()
	
	self.closedDownManufacturers = data.closedDownManufacturers
	
	for key, manufacturerData in ipairs(data.manufacturers) do
		local id = manufacturerData.id
		local obj = self:getManufacturerByID(id) or self:createManufacturer(id)
		
		obj:load(manufacturerData)
		table.insert(self.manufacturers, obj)
		
		self.manufacturersByID[id] = obj
	end
	
	self:init()
end

function consoleManufacturers:postLoad(data)
	for key, object in ipairs(self.manufacturers) do
		object:postLoad()
	end
end

function consoleManufacturers:buildPlatformList()
	for key, platformData in ipairs(platforms.registered) do
		if platformData.manufacturer then
			consoleManufacturers.registeredByID[platformData.manufacturer].platforms = consoleManufacturers.registeredByID[platformData.manufacturer].platforms or {}
			
			table.insert(consoleManufacturers.registeredByID[platformData.manufacturer].platforms, platformData.id)
		end
	end
end

consoleManufacturers:registerNew({
	exclusivityBonusGameCount = 4,
	ratingOffsetRemoveBonus = -5,
	startHealth = 0,
	id = "cexpi",
	exclusivityBonusGameRating = 7,
	fullExclusivityCutReduction = 0,
	partialExclusivityCutReduction = 0.5,
	display = _T("CEXPI", "C-EXPI")
})
consoleManufacturers:registerNew({
	exclusivityBonusGameCount = 6,
	ratingOffsetRemoveBonus = -4,
	startHealth = 0,
	id = "hardmacro",
	exclusivityBonusGameRating = 7,
	fullExclusivityCutReduction = 0,
	partialExclusivityCutReduction = 0.5,
	display = _T("HARDMACRO", "HardMacro")
})
consoleManufacturers:registerNew({
	exclusivityBonusGameCount = 5,
	ratingOffsetRemoveBonus = -2,
	startHealth = 0,
	id = "mintmendo",
	exclusivityBonusGameRating = 8,
	fullExclusivityCutReduction = 0,
	partialExclusivityCutReduction = 0.5,
	display = _T("MINTMENDO", "Mintmendo")
})
consoleManufacturers:registerNew({
	fullExclusivityCutReduction = 0,
	noBankruptcy = true,
	startHealth = 0,
	ratingOffsetRemoveBonus = -5,
	exclusivityBonusGameRating = 6,
	exclusivityBonusGameCount = 3,
	id = "pineapple",
	partialExclusivityCutReduction = 0.5,
	display = _T("PINEAPPLE", "Pineapple")
})
consoleManufacturers:registerNew({
	exclusivityBonusGameCount = 3,
	ratingOffsetRemoveBonus = -5,
	startHealth = 0,
	id = "mega",
	exclusivityBonusGameRating = 7.5,
	fullExclusivityCutReduction = 0,
	partialExclusivityCutReduction = 0.5,
	display = _T("MANUFACTURER_MEGA", "Mega")
})
consoleManufacturers:registerNew({
	exclusivityBonusGameCount = 5,
	ratingOffsetRemoveBonus = -5,
	startHealth = 0,
	id = "agari",
	exclusivityBonusGameRating = 7,
	fullExclusivityCutReduction = 0,
	partialExclusivityCutReduction = 0.5,
	display = _T("MANUFACTURER_AGARI", "Agari")
})
require("game/platform/platform_manufacturer")
