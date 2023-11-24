contractWork = {}
contractWork.registeredContractors = {}
contractWork.registeredContractorsByID = {}
contractWork.contractors = {}
contractWork.scoresByGenre = {}
contractWork.gameCountByGenre = {}
contractWork.avoidGenres = {}
contractWork.preferGenres = {}
contractWork.validContractors = {}
contractWork.BASE_WORK_DELAY = {
	2,
	3
}
contractWork.WORK_DELAY_DUE_TO_PROJECT = {
	1,
	2
}
contractWork.AVOID_GENRE_RATING = 6
contractWork.PREFER_GENRE_RATING = 8
contractWork.OFFER_WORK_CHANCE = 66
contractWork.OFFER_WORK_EVENT = timeline.EVENTS.NEW_MONTH
contractWork.IGNORE_GAMES_OLDER_THAN = timeline.DAYS_IN_YEAR * 5
contractWork.WORK_OFFER_COOLDOWN_REFUSED = timeline.DAYS_IN_MONTH * 6
contractWork.WORK_OFFER_COOLDOWN_FAILED = timeline.DAYS_IN_MONTH * 9
contractWork.WORK_OFFER_COOLDOWN_FINISHED = timeline.DAYS_IN_MONTH * 12
contractWork.RATING_TO_WEIGHT = 5
contractWork.TREND_MONTH_TO_WEIGHT = 2
contractWork.preferGenre = nil
contractWork.delayPeriod = nil
contractWork.cooldown = nil
contractWork.targetGenre = nil
contractWork.desiredGameScale = nil
contractWork.largestGameScale = nil
contractWork.recentGames = nil
contractWork.currentContractor = nil
contractWork.REFUSE_WORK_PREFERENCE = "refuse_contracts"
contractWork.CONTRACT_ACHIEVEMENTS = {
	achievements.ENUM.FIVE_CONTRACTS,
	achievements.ENUM.FIFTEEN_CONTRACTS
}

function contractWork.registerContractor(data)
	table.insert(contractWork.registeredContractors, data)
	
	contractWork.registeredContractorsByID[data.id] = data
	data.minimumGameCost = data.minimumGameCost or gameProject.PRICE_POINTS[1]
end

function contractWork:getContractorData(id)
	return self.registeredContractorsByID[id]
end

function contractWork:init()
	self:initEventHandler()
	
	self.cooldown = 0
	self.activeContractors = {}
	self.contractorCooldowns = {}
	self.contractorCooldownsMap = {}
	
	self:createContractors()
end

function contractWork:initEventHandler()
	events:addDirectReceiver(self, contractWork.CATCHABLE_EVENTS)
end

function contractWork:removeEventHandler()
	events:removeDirectReceiver(self, contractWork.CATCHABLE_EVENTS)
end

function contractWork:lock()
	self:removeEventHandler()
end

function contractWork:unlock()
	self:initEventHandler()
end

function contractWork:remove()
	self:removeEventHandler()
	self:removeContractors()
	
	for key, genreData in ipairs(genres.registered) do
		local id = genreData.id
		
		self.scoresByGenre[id] = 0
		self.gameCountByGenre[id] = 0
	end
end

function contractWork:advanceContractAchievements()
	local statID = achievements.STATS.COMPLETED_CONTRACTS
	
	for key, id in ipairs(contractWork.CONTRACT_ACHIEVEMENTS) do
		if not achievements:isUnlocked(id) then
			achievements:changeProgress(id, 1, statID)
		end
	end
end

function contractWork:createContractors()
	for key, contractorData in ipairs(contractWork.registeredContractors) do
		local contractorObj = contractor.new(contractorData.id)
		
		table.insert(self.contractors, contractorObj)
		
		self.activeContractors[#self.activeContractors + 1] = contractorObj
	end
end

function contractWork:removeContractors()
	for key, contractorObject in ipairs(self.contractors) do
		self.contractors[key] = nil
		
		contractorObject:remove()
	end
end

function contractWork:getContractors()
	return self.contractors
end

function contractWork:getContractorByID(id)
	for key, contractorObject in ipairs(self.contractors) do
		if contractorObject:getID() == id then
			return contractorObject
		end
	end
end

function contractWork:handleEvent(event, ...)
	if event == timeline.EVENTS.NEW_DAY then
		local index = 1
		
		for i = 1, #self.contractorCooldowns do
			local data = self.contractorCooldowns[index]
			
			data.time = data.time - 1
			
			if data.time <= 0 then
				table.remove(self.contractorCooldowns, index)
				
				self.contractorCooldownsMap[data.id] = nil
				
				self:addActiveContractor(data.id)
			else
				index = index + 1
			end
		end
	end
	
	if event == contractWork.OFFER_WORK_EVENT then
		self:attemptOfferWork()
	end
	
	for key, contractorObj in ipairs(self.contractors) do
		contractorObj:handleEvent(event, ...)
	end
end

function contractWork.acceptOfferOption(option)
	contractWork:acceptWorkOffer()
end

function contractWork.refuseOfferOption(option)
	contractWork:refuseWorkOffer()
end

function contractWork.refuseAllFutureOffersOption(option)
	contractWork:refuseWorkOffer()
	preferences:set(contractWork.REFUSE_WORK_PREFERENCE, true)
end

function contractWork:getCurrentContractor()
	return self.currentContractor
end

function contractWork:getCurrentProject()
	return self.currentContractor and self.currentContractor:getProjects()[1]
end

function contractWork:createContractWorkOfferPopup()
	local curContractor = self.currentContractor
	local timeDelay = curContractor:getDelayPeriod()
	local popup = gui.create("ContractWorkPopup")
	
	popup:setWidth(700)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("CONTRACT_WORK_OFFER_TITLE", "Contract Work Offer"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setText(string.easyformatbykeys(_T("CONTRACT_WORK_OFFER_TEXT", "You've received a contract work offer from CONTRACTOR. The details of the contract job are listed below."), "CONTRACTOR", curContractor:getName()))
	popup:setContractor(curContractor)
	popup:addBottomText(_format(_T("CONTRACT_ACCEPT_OR_REJECT", "If you accept this offer, they will get back to you in TIME.\nWould you like to accept or reject this offer?"), "TIME", timeline:getTimePeriodText(timeDelay * timeline.DAYS_IN_WEEK)), "pix24")
	popup:addButton(fonts.get("pix20"), _T("ACCEPT_OFFER", "Accept offer"), contractWork.acceptOfferOption)
	popup:addButton(fonts.get("pix20"), _T("REFUSE_OFFER", "Refuse offer"), contractWork.refuseOfferOption)
	popup:addButton(fonts.get("pix20"), _T("REFUSE_ALL_FUTURE_OFFERS", "Refuse all future offers"), contractWork.refuseAllFutureOffersOption)
	popup:hideCloseButton()
	popup:center()
	frameController:push(popup)
end

function contractWork:attemptOfferWork()
	if preferences:get(contractWork.REFUSE_WORK_PREFERENCE) then
		return 
	end
	
	if self.currentContractor or #studio:getEngines() + #studio:getPurchasedEngines() == 0 or #self.activeContractors == 0 then
		return 
	end
	
	if math.random(1, 100) <= contractWork.OFFER_WORK_CHANCE then
		self:buildGameLists()
		
		local ourRep = studio:getReputation()
		local employeeCount = #studio:getEmployees()
		
		for key, contractorObj in ipairs(self.activeContractors) do
			if not contractorObj:isGameBeingMadeFor() and contractorObj:meetsReputationRequirement(ourRep) and employeeCount >= contractorObj:getMinimumEmployees() and self:evaluateStudio(contractorObj) then
				table.insert(self.validContractors, contractorObj)
			end
		end
		
		local randomContractor = self.validContractors[math.random(1, #self.validContractors)]
		
		table.clearArray(self.validContractors)
		
		if randomContractor and randomContractor:prepareContractData() then
			self.currentContractor = randomContractor
			
			self:createContractWorkOfferPopup()
		end
	end
end

function contractWork:setCurrentContractor(contractor)
	self.currentContractor = contractor
end

function contractWork:refuseWorkOffer()
	self:setCooldown(self.currentContractor:getID(), contractWork.WORK_OFFER_COOLDOWN_REFUSED)
	self.currentContractor:refuseOffer()
	
	self.currentContractor = nil
end

function contractWork:acceptWorkOffer()
	self.currentContractor:acceptOffer()
	studio:getStats():changeStat("contract_jobs_taken", 1)
end

function contractWork:setCooldown(id, cooldown)
	if self.contractorCooldownsMap[id] then
		self.contractorCooldownsMap[id].time = cooldown
	else
		local data = {
			id = id,
			time = cooldown
		}
		
		table.insert(self.contractorCooldowns, data)
		
		self.contractorCooldownsMap[id] = data
		
		self:removeActiveContractor(id)
	end
end

function contractWork:getLargestGameScale()
	return self.largestGameScale
end

function contractWork:getTotalAverageRating()
	return self.totalRating / self.recentGames
end

function contractWork:buildGameLists()
	self.recentGames = 0
	self.largestGameScale = 0
	self.totalRating = 0
	
	local releasedGames = studio:getReleasedGames()
	local recentGamePeriod = curTime - contractWork.IGNORE_GAMES_OLDER_THAN
	
	for i = #releasedGames, 1, -1 do
		local gameObj = releasedGames[i]
		
		if recentGamePeriod <= gameObj:getReleaseDate() then
			self.largestGameScale = math.max(self.largestGameScale, gameObj:getScale())
			self.recentGames = self.recentGames + 1
			
			local rating = gameObj:getReviewRating()
			
			self.totalRating = self.totalRating + rating
			
			local genre = gameObj:getGenre()
			
			self.scoresByGenre[genre] = (self.scoresByGenre[genre] or 0) + rating
			self.gameCountByGenre[genre] = (self.gameCountByGenre[genre] or 0) + 1
		else
			break
		end
	end
end

function contractWork:evaluateStudio(contractor)
	contractor:clearEvaluationData()
	
	local preferGenres, avoidGenres = contractor:getPreferredGenres(), contractor:getAvoidedGenres()
	local preferGenre, preferRating = nil, -math.huge
	
	for genre, rating in pairs(self.scoresByGenre) do
		averageRating = rating / self.gameCountByGenre[genre]
		
		if averageRating < contractWork.AVOID_GENRE_RATING then
			avoidGenres[genre] = averageRating
		end
		
		if averageRating >= contractWork.PREFER_GENRE_RATING then
			if preferRating < averageRating then
				contractor:setMostPreferredGenre(genre)
				
				preferRating = averageRating
			end
			
			preferGenres[genre] = averageRating
		end
	end
	
	if table.count(preferGenres) == 0 and table.count(avoidGenres) >= 0 then
		contractor:clearAllContractData()
		
		return false
	end
	
	return true
end

function contractWork:addActiveContractor(id)
	for key, contractorObj in ipairs(self.contractors) do
		if contractorObj:getID() == id then
			table.insert(self.activeContractors, contractorObj)
		end
	end
end

function contractWork:removeActiveContractor(id)
	for key, contractorObj in ipairs(self.activeContractors) do
		if contractorObj:getID() == id then
			table.remove(self.activeContractors, key)
			
			return true
		end
	end
	
	return false
end

function contractWork:getDelayPeriod()
	local timeDelay = math.random(contractWork.BASE_WORK_DELAY[1], contractWork.BASE_WORK_DELAY[2])
	
	for key, teamObj in ipairs(studio:getTeams()) do
		local project = teamObj:getProject()
		
		if project and project.PROJECT_TYPE == gameProject.PROJECT_TYPE then
			timeDelay = timeDelay + math.random(contractWork.WORK_DELAY_DUE_TO_PROJECT[1], contractWork.WORK_DELAY_DUE_TO_PROJECT[2])
			
			break
		end
	end
	
	return timeDelay * timeline.WEEKS_IN_MONTH
end

function contractWork:save()
	local savedContractors = {}
	
	for key, contractorObj in ipairs(self.contractors) do
		savedContractors[#savedContractors + 1] = contractorObj:save()
	end
	
	return {
		cooldown = self.cooldown,
		contractors = savedContractors,
		contractorCooldowns = self.contractorCooldowns,
		currentContractor = self.currentContractor and self.currentContractor:getID()
	}
end

function contractWork:load(data)
	self.cooldown = data.cooldown
	self.contractorCooldowns = data.contractorCooldowns or self.contractorCooldowns
	
	for key, data in ipairs(self.contractorCooldowns) do
		self.contractorCooldownsMap[data.id] = data
		
		self:removeActiveContractor(data.id)
	end
	
	for key, contractorData in ipairs(data.contractors) do
		local contractor = self:getContractorByID(contractorData.id)
		
		if contractor then
			contractor:load(contractorData)
		else
			error("fail to load contractor - REMOVE ME ON RELEASE")
		end
	end
	
	self.currentContractor = data.currentContractor and self:getContractorByID(data.currentContractor)
end

preferences:registerNew({
	id = contractWork.REFUSE_WORK_PREFERENCE,
	display = _T("REFUSE_CONTRACT_OFFERS", "Refuse contract project offers"),
	description = _T("REFUSE_CONTRACT_OFFERS_DESCRIPTION", "With this enabled, all contract work offers will be refused.")
})
require("game/contract_work/contractors")
require("game/contract_work/contractor")
require("game/contract_work/contract_data")
