letsPlayers = {}
letsPlayers.registered = {}
letsPlayers.registeredByID = {}
letsPlayers.MAX_VIEWERBASE_OF_MARKETSHARE = 0.005
letsPlayers.VIEWERBASE_TO_INCREASE_MULTIPLIER = 0.0001
letsPlayers.EXTRA_VIEWER_GAIN_PER_GAME_QUALITY = 0.5
letsPlayers.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_WEEK
}
letsPlayers.COOLDOWN = math.floor(timeline.WEEKS_IN_MONTH * 1.5)
letsPlayers.RANDOM_COOLDOWN = {
	2,
	6
}
letsPlayers.DEFAULT_BUSY_CHANCE = 25

local letsPlayer = {}

letsPlayer.mtindex = {
	__index = letsPlayer
}

function letsPlayer:init(id)
	self.id = id
	self.data = letsPlayers.registeredByID[id]
	self.viewerbase = 0
	self.cooldown = 0
	self.videosMade = 0
	self.totalGameRating = 0
	self.totalVideoRating = 0
	self.gamesInProgress = {}
end

function letsPlayer:remove()
end

function letsPlayer:getID()
	return self.id
end

function letsPlayer:getPrice()
	if self.viewerbase > self.data.minimumViewerBaseForPaidVideos then
		local normalized = self.viewerbase - self.data.minimumViewerBaseForPaidVideos
		
		return self.data.baseVideoPrice + self.data.extraPerSection * math.floor(normalized / self.data.extraPriceSection)
	end
	
	return 0
end

function letsPlayer:getIcon()
	return self.data.icon
end

function letsPlayer:updateViewerbase(changeInUsers)
	if changeInUsers > 0 then
		local old = self.viewerbase
		local increase = math.floor((self.viewerbase + changeInUsers * letsPlayers.MAX_VIEWERBASE_OF_MARKETSHARE + math.min(changeInUsers, self.viewerbase * letsPlayers.VIEWERBASE_TO_INCREASE_MULTIPLIER) + math.floor(letsPlayers.EXTRA_VIEWER_GAIN_PER_GAME_QUALITY * self.totalVideoRating)) * math.randomf(0.8, 1.2)) * self.data.viewerIncreaseMult
		
		self.viewerbase = math.min(letsPlayers.maxViewerBase * self.data.maxViewerbaseMult, self.viewerbase + increase)
		
		letsPlayers:changeTotalViewers(self.viewerbase - old)
	end
end

function letsPlayer:onOffMarket(gameProj)
	for key, data in ipairs(self.gamesInProgress) do
		if data.game == gameProj then
			table.remove(self.gamesInProgress, key)
			
			break
		end
	end
end

function letsPlayer:getGamesInProgress()
	return self.gamesInProgress
end

function letsPlayer:onFinish()
	self.cooldown = letsPlayers.COOLDOWN
end

function letsPlayer:increaseVideosMade()
	self.videosMade = self.videosMade + 1
end

function letsPlayer:getTotalVideosMade()
	return self.videosMade
end

function letsPlayer:setCooldown(cooldown)
	self.cooldown = cooldown
end

function letsPlayer:getCooldown()
	return self.cooldown
end

function letsPlayer:getName()
	return self.data.display
end

function letsPlayer:isGenrePreferred(genreID)
	return self.data.preferredGenres[genreID]
end

function letsPlayer:updateBusyState()
	if not self.cooldownSetThisWeek then
		if math.random(1, 100) <= self.data:getBusyChance(letsPlayer) then
			self.cooldown = math.random(letsPlayers.RANDOM_COOLDOWN[1], letsPlayers.RANDOM_COOLDOWN[2])
		end
		
		self.cooldownSetThisWeek = true
	end
end

function letsPlayer:handleNewWeek(changeInUsers)
	if self.cooldown > 0 then
		self.cooldown = self.cooldown - 1
	else
		self.cooldownSetThisWeek = false
	end
	
	self:updateViewerbase(changeInUsers)
end

function letsPlayer:getMaxVideos()
	return self.data.maxVideos
end

function letsPlayer:setupDescbox(descBox, wrapWidth)
	descBox:addText(self.data.description, "pix20", nil, 0, wrapWidth)
	self.data:setupDescbox(self, descBox, wrapWidth)
end

function letsPlayer:getFreeExtraVideosRating()
	return self.data.freeExtraVideosRating
end

function letsPlayer:getExtraVideos()
	return self.data.freeExtraVideos
end

function letsPlayer:addGame(game, rating)
	local data
	
	for key, iterData in ipairs(self.gamesInProgress) do
		if iterData.game == game then
			data = iterData
			
			break
		end
	end
	
	if data then
		self.totalGameRating = self.totalGameRating - data.rating
		data.rating = rating
	else
		self.gamesInProgress[#self.gamesInProgress + 1] = {
			game = game,
			rating = rating
		}
	end
	
	self.totalGameRating = self.totalGameRating + rating
	self.totalVideoRating = self.totalGameRating / #self.gamesInProgress
end

function letsPlayer:removeGame(game)
	local gameData
	
	for key, data in ipairs(self.gamesInProgress) do
		if data.game == game then
			gameData = data
			
			table.remove(self.gamesInProgress, key)
			
			break
		end
	end
	
	if gameData then
		self.totalGameRating = self.totalGameRating - gameData.rating
		
		if #self.gamesInProgress > 0 then
			self.totalVideoRating = self.totalGameRating / #self.gamesInProgress
		else
			self.totalGameRating = 0
			self.totalVideoRating = 0
		end
	end
end

function letsPlayer:getViewerbase()
	return self.viewerbase
end

function letsPlayer:save()
	local saved = {
		id = self.id,
		viewerbase = self.viewerbase,
		cooldown = self.cooldown,
		videosMade = self.videosMade,
		gamesInProgress = {}
	}
	
	for key, data in ipairs(self.gamesInProgress) do
		saved.gamesInProgress[#saved.gamesInProgress + 1] = {
			game = data.game:getUniqueID(),
			rating = data.rating
		}
	end
	
	return saved
end

function letsPlayer:load(data)
	self.viewerbase = data.viewerbase
	self.cooldown = data.cooldown
	self.videosMade = data.videosMade
	
	for key, data in ipairs(data.gamesInProgress) do
		local gameObj = studio:getGameByUniqueID(data.game)
		
		if gameObj then
			self:addGame(gameObj, data.rating)
		end
	end
end

function letsPlayers:init()
	self.letsPlayers = {}
	self.letsPlayersByID = {}
	self.totalViewers = 0
	self.previousPlatformUsers = 0
	
	events:addDirectReceiver(self, letsPlayers.CATCHABLE_EVENTS)
end

function letsPlayers:remove()
	for key, obj in ipairs(self.letsPlayers) do
		self.letsPlayers[key] = nil
		self.letsPlayersByID[obj.id] = nil
		
		obj:remove()
	end
	
	events:removeDirectReceiver(self, letsPlayers.CATCHABLE_EVENTS)
end

function letsPlayers:getLetsPlayers()
	return self.letsPlayers
end

function letsPlayers:getLetsPlayer(id)
	return self.letsPlayersByID[id]
end

local baseLetsPlayerDataMethods = {}

baseLetsPlayerDataMethods.mtindex = {
	__index = baseLetsPlayerDataMethods
}

function baseLetsPlayerDataMethods:setupDescbox(letsPlayer, descBox, wrapWidth)
end

function baseLetsPlayerDataMethods:getBusyChance(letsPlayer)
	return self.busyChance
end

function letsPlayers:registerNew(data)
	table.insert(letsPlayers.registered, data)
	
	letsPlayers.registeredByID[data.id] = data
	
	setmetatable(data, baseLetsPlayerDataMethods.mtindex)
	
	data.baseClass = baseLetsPlayerDataMethods
	data.description = data.description or "description not set for this LPer!"
	data.preferredGenres = data.preferredGenres or {}
	data.busyChance = data.busyChance or letsPlayers.DEFAULT_BUSY_CHANCE
	
	local eventID = "unlock_lets_player_" .. data.id
	
	scheduledEvents:registerNew({
		inactive = false,
		id = eventID,
		letsPlayerID = data.id,
		date = data.availability
	}, "lets_player_availability")
end

function letsPlayers:initLetsPlayer(id)
	local newLetsPlayer = {}
	
	setmetatable(newLetsPlayer, letsPlayer.mtindex)
	newLetsPlayer:init(id)
	table.insert(self.letsPlayers, newLetsPlayer)
	
	self.letsPlayersByID[id] = newLetsPlayer
	
	return newLetsPlayer
end

function letsPlayers:handleEvent(event)
	self.maxViewerBase = math.round(platformShare:getTotalUsers() * letsPlayers.MAX_VIEWERBASE_OF_MARKETSHARE)
	
	self:updateViewerbase()
end

function letsPlayers:changeTotalViewers(change)
	self.totalViewers = self.totalViewers + change
end

function letsPlayers:updateViewerbase()
	local curUsers = platformShare:getPlatformUsers()
	local changeInUsers = curUsers - self.previousPlatformUsers
	
	for key, letsPlayer in ipairs(self.letsPlayers) do
		letsPlayer:handleNewWeek(changeInUsers)
	end
	
	self.previousPlatformUsers = curUsers
end

function letsPlayers:save()
	local saved = {
		letsPlayers = {},
		totalViewers = self.totalViewers,
		previousPlatformUsers = self.previousPlatformUsers
	}
	
	for key, obj in ipairs(self.letsPlayers) do
		saved.letsPlayers[#saved.letsPlayers + 1] = obj:save()
	end
	
	return saved
end

function letsPlayers:load(data)
	self.totalViewers = data.totalViewers or self.totalViewers
	self.previousPlatformUsers = self.previousPlatformUsers or self.previousPlatformUsers
	
	for key, savedData in ipairs(data.letsPlayers) do
		local object = self:initLetsPlayer(savedData.id)
		
		object:load(savedData)
	end
end

require("game/basic_lets_players")
