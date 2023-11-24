contractor = {}
contractor.mtindex = {
	__index = contractor
}
contractor.preferredGenres = nil
contractor.avoidedGenres = nil
contractor.mostPreferredGenre = nil
contractor.delayPeriod = nil
contractor.targetGenre = nil
contractor.acceptedOffer = nil
contractor.INSTANT_CASH_ROUNDING_SEGMENT = 10000
contractor.FUNDING_ROUNDING_SEGMENT = 1000
contractor.TIME_TO_EVALUATE_PROJECT_SUCCESS = timeline.DAYS_IN_MONTH
contractor.FIRST_TIME_CONTRACTOR_SALE_FACT = "first_time_contractor_sale"
contractor.FIRST_TIME_LATE_MILESTONE_FACT = "first_time_late_milestone"
contractor.FIRST_TIME_MILESTONE_DELIVERED_FACT = "first_time_milestone_delivered"
contractor.FIRST_TIME_MILESTONE_FACT = "first_time_milestone_fact"
contractor.EVALUATED_GAME_PUBLISHING = "evaluted_game_publishers"
contractor.BASE_PROJECT_DEADLINE_TIME_AMOUNT = 4
contractor.SCALE_TO_DEADLINE_TIME = 3
contractor.PASSED_YEARS_TO_DEADLINE_TIME = 2
contractor.EMPLOYEE_COUNT_TO_DEADLINE_TIME_REDUCTION = 0.15
contractor.DEFAULT_SHARE_LOSS_PER_DAY_OVER_DEADLINE = 0.02
contractor.DEFAULT_MAX_EXTRA_TIME_AFTER_DEADLINE = timeline.DAYS_IN_MONTH * 4
contractor.FAILED_PROJECT_REPUTATION_LOSS_PER_MONEY_SPENT = 70
contractor.FAILED_PROJECT_REPUTATION_LOSS_PER_MONEY_SPENT_PUBLISHED = 50
contractor.FAILED_PROJECT_MONEY_REPAYMENT_PERCENTAGE = 2
contractor.MILESTONE_EARLY_COMPLETION_TIME = timeline.DAYS_IN_WEEK * 2
contractor.MILESTONE_EARLY_COMPLETION_BONUS_BASE_AMOUNT = 1000
contractor.MILESTONE_EARLY_COMPLETION_BONUS_PER_SCALE = 10000
contractor.MILESTONE_DEADLINE_REDUCE_AMOUNT = 0.9
contractor.REPUTATION_LOSS_FROM_MISSED_MILESTONE = 2
contractor.REPUTATION_GAIN_FROM_AHEAD_OF_TIME_MILESTONE = 10
contractor.REPUTATION_GAIN_FROM_AHEAD_OF_TIME_MILESTONE_SCALE_MULTIPLIER = 5
contractor.SCRAP_PUBLISHED_GAME_PENALTY_MULTIPLIER = 2
contractor.GAME_PUBLISHING_EVALUATION_TIME = {
	3,
	5
}
contractor.CONTRACT_TYPES = {
	PUBLISHED = 2,
	REGULAR = 1
}
contractor.EVALUATION_STATES = {
	EVALUATING = 1,
	EVALUATED = 2,
	NONE = 0
}
contractor.PUBLISHING_EVALUATION_STATES = {
	EVALUATING = 4,
	DECLINED = 1,
	PLAYER_DECLINED = 2,
	ACCEPTED = 3
}
contractor.EVENTS = {
	NEW_MILESTONE = events:new(),
	MILESTONE_REACHED = events:new(),
	LOADED = events:new(),
	BEGUN_PROJECT_SETUP = events:new()
}

function contractor.new(id)
	local new = {}
	
	setmetatable(new, contractor.mtindex)
	new:init(id)
	
	return new
end

function contractor:init(id)
	self.id = id
	self.developmentFunding = 0
	self.contractCount = 0
	
	self:setData(id)
	
	self.preferredGenres = {}
	self.avoidedGenres = {}
	self.projectsToEvaluate = {}
	self.gameProjects = {}
	self.gamesToEvaluatePublish = {}
end

function contractor:setData(id)
	self.data = contractWork.registeredContractorsByID[id]
end

function contractor:getData()
	return self.data
end

function contractor:getName()
	return self.data.display
end

function contractor:getLogo()
	return self.data.logo
end

function contractor:getID()
	return self.data.id
end

function contractor:getDevCostMultiplier()
	return self.data.coverFunding
end

function contractor:getPenaltyMultiplier()
	return self.data.returnFundingAmount
end

function contractor:remove()
end

function contractor:isGameBeingMadeFor()
	return self.delayPeriod ~= nil or #self.gameProjects > 0
end

eventBoxText:registerNew({
	id = "contractor_funding_received",
	getText = function(self, data)
		return _format(_T("RECEIVED_CONTRACTOR_FUNDING", "Contractor funding of $MONEY received."), "MONEY", string.comma(data))
	end
})

function contractor:provideFunding(gameProj)
	local data = gameProj:getContractData()
	local funding = data:getMonthlyFunding()
	
	if funding then
		self:giveMoneyToStudio(funding, gameProj, data)
		gameProj:addToFundingCosts(funding)
		game.addToEventBox("contractor_funding_received", funding, 2, nil, "wad_of_cash")
	end
end

function contractor:giveMoneyToStudio(amount, gameProj, contractDataObject)
	contractDataObject:addMoneyGivenToStudio(amount)
	
	if gameProj then
		gameProj:changeMoneySpent(-amount)
	end
	
	studio:addFunds(amount, nil, "contracts")
end

function contractor:getMaxExtraTimeAfterDeadline()
	return self.data.maxExtraTimeAfterDeadline or contractor.DEFAULT_MAX_EXTRA_TIME_AFTER_DEADLINE
end

function contractor:meetsReputationRequirement(rep)
	if rep < self.data.minimumReputation or self.data.maximumReputation and rep >= self.data.maximumReputation then
		return false
	end
	
	return true
end

function contractor:getMinimumReputation()
	return self.data.minimumReputation
end

function contractor:getMaximumReputation()
	return self.data.maximumReputation
end

function contractor:getMinimumEmployees()
	return self.data.minimumEmployees
end

function contractor:shouldStartWork()
	return self.acceptedOffer and not self.playerWorking
end

eventBoxText:registerNew({
	id = "early_milestone_bonus",
	getText = function(self, data)
		return _format(_T("MILESTONE_BONUS", "Received bonus of $BONUS for early 'GAME' milestone."), "BONUS", string.comma(data.bonus), "GAME", data.game)
	end
})

function contractor:handleEvent(event, gameObj)
	if event == timeline.EVENTS.NEW_WEEK and self.delayPeriod and self.acceptedOffer then
		self.delayPeriod = self.delayPeriod - 1
		
		if self.delayPeriod <= 0 then
			self:createBeginWorkPopup()
		end
	end
	
	if event == timeline.EVENTS.NEW_DAY then
		local curKey = 1
		
		for key, data in ipairs(self.projectsToEvaluate) do
			local data = self.projectsToEvaluate[curKey]
			
			data.time = data.time - 1
			
			if data.time <= 0 then
				self:evaluateProjectSuccess(data.project)
				table.remove(self.projectsToEvaluate, curKey)
			else
				curKey = curKey + 1
			end
		end
		
		local curKey = 1
		
		for key, data in ipairs(self.gamesToEvaluatePublish) do
			local data = self.gamesToEvaluatePublish[curKey]
			
			data.time = data.time - 1
			
			if data.time <= 0 then
				self:evaluateGamePublishingRisk(data.project)
				table.remove(self.gamesToEvaluatePublish, curKey)
			else
				curKey = curKey + 1
			end
		end
	elseif event == project.EVENTS.SCRAPPED_PROJECT then
		for key, data in ipairs(self.gamesToEvaluatePublish) do
			if data.project == gameObj then
				table.remove(self.gamesToEvaluatePublish, key)
				
				break
			end
		end
	end
	
	if #self.gameProjects > 0 then
		if event == timeline.EVENTS.NEW_DAY then
			for key, gameProj in ipairs(self.gameProjects) do
				local data = gameProj:getContractData()
				
				if timeline.curTime > data:getDeadline() then
					data:addDaysOverDeadline(1)
					
					local maxSharePenaltyDate = data:getMaxSharePenaltyDate()
					
					if not maxSharePenaltyDate then
						if self:hasReachedMaximumPenalty(gameProj) then
							data:setMaxSharePenaltyDate(timeline.curTime)
						end
					elseif timeline.curTime > maxSharePenaltyDate + self:getMaxExtraTimeAfterDeadline() then
						self:failContract(nil, gameProj)
					end
				end
				
				local currentCompletion = gameProj:getOverallCompletion()
				local milestone, last = data:getMilestone(), data:getLastMilestone()
				
				if milestone <= currentCompletion and last < milestone then
					last = currentCompletion
					
					local timeDelta = data:getMilestoneDate() - timeline.curTime
					
					if not studio:getFact(contractor.FIRST_TIME_MILESTONE_DELIVERED_FACT) then
						local popup = game.createPopup(600, _T("MILESTONE_REACHED_TITLE", "Milestone Reached"), _T("MILESTONE_REACHED_DESCRIPTION", "You've reached your first contract project milestone. Congratulations!\nDelivering milestones ahead of schedule will yield you bonus cash and reputation."))
						
						frameController:push(popup)
						studio:setFact(contractor.FIRST_TIME_MILESTONE_DELIVERED_FACT, true)
					end
					
					if timeDelta >= contractor.MILESTONE_EARLY_COMPLETION_TIME then
						data:setDeadline(data:getDeadline() - timeDelta * contractor.MILESTONE_DEADLINE_REDUCE_AMOUNT)
						
						local bonus = contractor.MILESTONE_EARLY_COMPLETION_BONUS_BASE_AMOUNT + data:getScale() * contractor.MILESTONE_EARLY_COMPLETION_BONUS_PER_SCALE
						
						self:giveMoneyToStudio(bonus, gameProj, gameProj:getContractData())
						game.addToEventBox("early_milestone_bonus", {
							bonus = bonus,
							game = gameProj:getName()
						}, 2, nil, "wad_of_cash")
						studio:increaseReputation(contractor.REPUTATION_GAIN_FROM_AHEAD_OF_TIME_MILESTONE + data:getScale() * contractor.REPUTATION_GAIN_FROM_AHEAD_OF_TIME_MILESTONE_SCALE_MULTIPLIER)
					end
					
					self:applyMilestone(gameProj)
					gameProj:getContractData():addReachedMilestones(1)
				elseif timeline.curTime > data:getMilestoneDate() then
					studio:decreaseReputation(contractor.REPUTATION_LOSS_FROM_MISSED_MILESTONE)
					
					if not studio:getFact(contractor.FIRST_TIME_LATE_MILESTONE_FACT) then
						local popup = game.createPopup(600, _T("MILESTONE_IS_LATE_TITLE", "Milestone is Late"), _T("MILESTONE_IS_LATE_DESCRIPTION", "You have not delivered the milestone on time. Due to that, you will lose reputation on a daily basis until the milestone has been reached."))
						
						frameController:push(popup)
						studio:setFact(contractor.FIRST_TIME_LATE_MILESTONE_FACT, true)
					end
				end
			end
		elseif event == timeline.EVENTS.NEW_WEEK then
			for key, gameProj in ipairs(self.gameProjects) do
				self:addProjectPopularity(gameProj)
			end
		elseif event == timeline.EVENTS.NEW_MONTH then
			for key, gameProj in ipairs(self.gameProjects) do
				self:provideFunding(gameProj)
			end
		elseif event == studio.EVENTS.RELEASED_GAME and gameObj:getOwner():isPlayer() and table.find(self.gameProjects, gameObj) then
			self:updateRecoupAmount(gameObj)
			
			local data = gameObj:getContractData()
			
			if data:getContractType() == contractor.CONTRACT_TYPES.REGULAR then
				self:addProjectToEvaluate(gameObj, contractor.TIME_TO_EVALUATE_PROJECT_SUCCESS)
			end
			
			self.contractCount = self.contractCount + 1
			
			studio:getStats():changeStat("contract_jobs_finished", 1)
			contractWork:setCooldown(self.data.id, contractWork.WORK_OFFER_COOLDOWN_FINISHED)
			table.removeObject(self.gameProjects, gameObj)
		elseif event == gameProject.EVENTS.GAME_OFF_MARKET and table.find(self.gameProjects, gameObj) then
			if not self:hasEvaluatedProject(gameObj) then
				self:evaluateProjectSuccess(gameObj)
			end
			
			local funding = gameObj:getFundingCosts()
			
			if gameObj:getContractData():getSaleMoney() < funding * self.data.coverFunding then
				self:penalizePlayer(funding, gameObj)
			end
			
			self:createGameSalesOverPopup()
			self:clearAllContractData()
		end
	end
end

function contractor:penalizePlayer(developmentCosts, gameObj)
	local popup = gui.create("DescboxPopup")
	
	popup:setFont("pix24")
	popup:setTitle(_T("CONTRACTOR_DISAPPOINTED_TITLE", "Contractor Disappointed"))
	popup:setTextFont("pix20")
	popup:setWidth(600)
	popup:setText(_format(_T("CONTRACTOR_DISAPPOINTED_DESCRIPTION", "'GAME' has gone off-market, but the game has not made enough sales and the contractor was left disappointed due to that.\nAs it was stated in the contract, you will now have to pay out a reparatory sum of money."), "GAME", gameObj:getName()))
	popup:setShowSound("bad_jingle")
	
	local left, right, extra = popup:getDescboxes()
	
	left:addText(_format(_T("PENALTY_DEVELOPMENT_COSTS", "Development cost: $COST"), "COST", string.comma(developmentCosts)), "bh20", nil, 4, popup.rawW * 0.5 - 5, {
		{
			height = 26,
			icon = "generic_backdrop",
			width = 26
		},
		{
			width = 20,
			height = 20,
			y = 1,
			icon = "wad_of_cash",
			x = 3
		}
	})
	left:addText(_format(_T("PENALTY_SUM_TO_COVER", "Sum to cover: $COST"), "COST", string.comma(developmentCosts * self.data.coverFunding)), "bh20", nil, 0, popup.rawW * 0.5 - 5, {
		{
			height = 26,
			icon = "generic_backdrop",
			width = 26
		},
		{
			width = 20,
			height = 20,
			y = 1,
			icon = "wad_of_cash",
			x = 3
		}
	})
	right:addText(_format(_T("PENALTY_MONEY_MADE", "Money made: $MONEY"), "MONEY", string.comma(gameObj:getContractData():getSaleMoney())), "bh20", nil, 4, popup.rawW * 0.5 - 5, "percentage", 26, 26)
	
	local penaltySize = math.round(developmentCosts * self.data.returnFundingAmount + gameObj:getContractData():getInstantCash())
	local penalty = string.comma(penaltySize)
	
	right:addText(_format(_T("PENALTY_PENALTY", "Penalty: $PENALTY"), "PENALTY", penalty), "bh20", nil, 0, popup.rawW * 0.5 - 5, {
		{
			height = 26,
			icon = "generic_backdrop",
			width = 26
		},
		{
			width = 20,
			height = 20,
			y = 1,
			icon = "wad_of_cash_minus",
			x = 3
		}
	})
	extra:addText(_format(_T("PENALTY_YOU_HAVE_PAID_OUT", "Obliged by the contract, you've paid out the $PENALTY penalty."), "PENALTY", penalty), "bh22", nil, 0, popup.rawW - 10, "question_mark", 24, 24)
	popup:addOKButton("pix24")
	popup:center()
	frameController:push(popup)
	studio:deductFunds(penaltySize, nil, "penalties")
end

function contractor:getContractCount()
	return self.contractCount
end

function contractor:addProjectPopularity(gameProj)
	local data = gameProj:getContractData()
	local advertStrength = data:getAdvertisementStrength()
	
	if advertStrength then
		local cost = data:getAdvertisementCosts()
		
		gameProj:increasePopularity(advertStrength)
		gameProj:addToFundingCosts(cost)
	else
		local advert = self.data.advertisement
		
		gameProj:increasePopularity(advert.baseWeeklyGain + advert.gainPerScalePoint * self.currentContractData:getScale() + advert.gainPerMinimumRating * self.currentContractData:getTargetRating())
	end
end

function contractor:updateRecoupAmount(gameObj)
	gameObj:setRecoupAmount(self.developmentFunding)
end

function contractor:releaseGame(gameProj)
	gameProj:release()
end

function contractor:getOverDeadlineReputationLoss(gameProj)
	return math.floor(gameProj:getContractData():getMoneyGivenToStudio() / contractor.FAILED_PROJECT_REPUTATION_LOSS_PER_MONEY_SPENT)
end

function contractor:getOverDeadlineMoneyPenalty(gameProj)
	local cdata = gameProj:getContractData()
	
	return math.floor(contractor.FAILED_PROJECT_MONEY_REPAYMENT_PERCENTAGE * cdata:getMoneyGivenToStudio())
end

function contractor:getScrapGameMoneyPenalty(gameProj)
	local total = 0
	
	total = total + self:getOverDeadlineMoneyPenalty(gameProj)
	
	local data = gameProj:getContractData()
	
	if data:getContractType() == contractor.CONTRACT_TYPES.PUBLISHED then
		total = total + gameProj:getFundingCosts() * contractor.SCRAP_PUBLISHED_GAME_PENALTY_MULTIPLIER
	end
	
	return total
end

function contractor:onScrapProject(gameProj)
	if table.find(self.gameProjects, gameProj) then
		local lostReputation, lostMoney = self:applyScrapPenalty(gameProj)
		local popup = gui.create("Popup")
		
		popup:setWidth(600)
		popup:setFont(fonts.get("pix24"))
		popup:setTextFont(fonts.get("pix20"))
		popup:hideCloseButton()
		popup:setTitle(_T("PUBLISHED_PROJECT_ABORTED_TITLE", "Contract Project Aborted"))
		popup:setText(string.easyformatbykeys(_T("PUBLISHED_PROJECT_ABORTED_DESCRIPTION", "You've scrapped a game project which was under a publishing contract. This has cost you a penalty of $MONEY_PENALTY, and REPUTATION reputation points."), "MONEY_PENALTY", string.comma(lostMoney), "REPUTATION", string.comma(lostReputation)))
		popup:addOKButton(fonts.get("pix20"))
		self:removeProject(gameProj)
		self:clearAllContractData()
		contractWork:setCooldown(self.data.id, contractWork.WORK_OFFER_COOLDOWN_FAILED)
		studio:removeContractorGame(gameProj)
		popup:center()
		frameController:push(popup)
	end
end

function contractor:applyScrapPenalty(gameProj)
	local lostReputation = self:getOverDeadlineReputationLoss(gameProj)
	local lostMoney = self:getScrapGameMoneyPenalty(gameProj)
	local divider
	local data = gameProj:getContractData()
	
	if data:getContractType() == contractor.CONTRACT_TYPES.PUBLISHED then
		divider = contractor.FAILED_PROJECT_REPUTATION_LOSS_PER_MONEY_SPENT_PUBLISHED
	else
		divider = contractor.FAILED_PROJECT_REPUTATION_LOSS_PER_MONEY_SPENT
	end
	
	lostReputation = lostReputation + math.floor(gameProj:getFundingCosts() / divider)
	
	studio:decreaseReputation(lostReputation)
	studio:deductFunds(lostMoney, nil, "penalties")
	
	return lostReputation, lostMoney
end

function contractor:applyCancelPenalty(gameProj)
	local lostReputation = self:getOverDeadlineReputationLoss(gameProj)
	local lostMoney = self:getScrapGameMoneyPenalty(gameProj)
	
	studio:decreaseReputation(lostReputation)
	studio:deductFunds(lostMoney, nil, "penalties")
	
	return lostReputation, lostMoney
end

function contractor:removeProject(proj)
	table.removeObject(self.gameProjects, proj)
	
	for key, data in ipairs(self.projectsToEvaluate) do
		if data.project == proj then
			table.remove(self.projectsToEvaluate, key)
		end
	end
end

function contractor.releaseTheGameOption(option)
	option.contractor:releaseGame(option.project)
end

function contractor.cancelTheProjectOption(option)
	option.contractor:failContract(true, option.project)
end

function contractor:failContract(aborted, gameProj)
	local popup = gui.create("Popup")
	
	popup:setWidth(600)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:hideCloseButton()
	
	if not gameProj:canReleaseGame() or aborted then
		local lostReputation, lostMoney = self:applyCancelPenalty(gameProj)
		
		popup:setTitle(_T("CONTRACT_PROJECT_ABORTED_TITLE", "Contract Project Aborted"))
		popup:setText(string.easyformatbykeys(_T("CONTRACT_PROJECT_ABORTED_DESCRIPTION", "The contractor was not happy with how much time the project was taking to finish, and has aborted the project. This has cost you a penalty of $MONEY_PENALTY, and REPUTATION reputation points."), "MONEY_PENALTY", string.comma(lostMoney), "REPUTATION", string.comma(lostReputation)))
		popup:addOKButton(fonts.get("pix20"))
		self:removeProject(gameProj)
		studio:removeContractorGame(gameProj)
		gameProj:scrap()
		self:clearAllContractData()
		contractWork:setCooldown(self.data.id, contractWork.WORK_OFFER_COOLDOWN_FAILED)
	else
		popup:setTitle(_T("CONTRACT_PROJECT_IN_TROUBLE_TITLE", "Contract Project in Trouble"))
		popup:setText(string.easyformatbykeys(_T("CONTRACT_PROJECT_ABORT_OR_RELEASE_DESCRIPTION", "The contractor is not happy that the game is taking too much time to finish, and has presented you with 2 choices: release the project in its current state, or cancel the project, but then you'll have to pay a penalty of PENALTY. You will also lose REPUTATION_LOSS reputation points."), "PENALTY", string.roundtobigcashnumber(self:getOverDeadlineMoneyPenalty(gameProj)), "REPUTATION_LOSS", string.roundtobignumber(self:getOverDeadlineReputationLoss(gameProj))))
		
		local button = popup:addButton(fonts.get("pix20"), _T("RELEASE_THE_GAME", "Release the game"), contractor.releaseTheGameOption)
		
		button.contractor = self
		button.project = gameProj
		
		local button = popup:addButton(fonts.get("pix20"), _T("CANCEL_THE_PROJECT", "Cancel the project"), contractor.cancelTheProjectOption)
		
		button.project = gameProj
		button.contractor = self
	end
	
	popup:center()
	frameController:push(popup)
end

function contractor.beginWorkOption(option)
	local contractorObj = option.contractor
	
	contractorObj:beginWork()
end

function contractor:applyMilestone(gameProj)
	local data = gameProj:getContractData()
	local milestone = data:getMilestone()
	
	if milestone == 1 then
		data:setLastMilestoneReached(true)
	end
	
	local nextMilestoneProgress = math.round(math.randomf(0.15, 0.3), 1)
	local milestone = math.min(1, milestone + nextMilestoneProgress)
	
	data:setMilestone(milestone)
	data:setMilestoneDate(math.lerp(data:getStartOfWork(), data:getDeadline(), milestone))
	
	if not studio:getFact(contractor.FIRST_TIME_MILESTONE_FACT) then
		local popup = gui.create("Popup")
		
		popup:setWidth(600)
		popup:setFont("pix24")
		popup:setTitle(_T("CONTRACT_PROJECT_MILESTONES_TITLE", "Contract Project Milestones"))
		popup:setTextFont("pix20")
		popup:setText(_T("CONTRACT_PROJECT_MILESTONES_DESCRIPTION", "You've begun work on your first contract project! Congratulations!\nEach project will have its' own milestones that have to be completed on time. If they aren't, then you will lose reputation every day until they are reached.\n\nHowever if a milestone is reached greatly ahead of time, then you will receive extra reputation and a bonus payment."))
		popup:hideCloseButton()
		popup:addOKButton()
		popup:center()
		frameController:push(popup)
		studio:setFact(contractor.FIRST_TIME_MILESTONE_FACT, true)
	end
	
	events:fire(contractor.EVENTS.NEW_MILESTONE, self, data:getMilestoneDate())
end

function contractor:createGameSalesOverPopup()
end

function contractor:canPublishGame(gameObj)
	local list = gameObj:getFact(contractor.EVALUATED_GAME_PUBLISHING)
	
	return not list or list[self.id] == nil
end

function contractor:getPublishingState(gameObj)
	local list = gameObj:getFact(contractor.EVALUATED_GAME_PUBLISHING)
	
	return list and list[self.id]
end

function contractor:acceptPublishingContractCallback()
	self.contractor:acceptPublishingContract(self.project, self.contractData)
end

function contractor:declinePublishingContractCallback()
	self.contractor:declinePublishingContract(self.project)
end

function contractor:declinePublishingContract(gameProj)
	self:setPublishingEvaluationState(gameProj, contractor.PUBLISHING_EVALUATION_STATES.PLAYER_DECLINED)
end

function contractor:acceptPublishingContract(gameProj, contractData)
	self:setPublishingEvaluationState(gameProj, contractor.PUBLISHING_EVALUATION_STATES.ACCEPTED)
	contractData:setStartOfWork(timeline.curTime)
	gameProj:setContractData(contractData)
	gameProj:setPublisher(self)
	self:applyMilestone(gameProj)
	studio:addContractorGame(gameProj)
	table.insert(self.gameProjects, gameProj)
end

function contractor:createUpcomingContractDisplay()
	local element = gui.create("UpcomingContractDisplay")
	
	game.addToProjectScroller(element, self)
end

function contractor:queueGamePublishingEvaluation(gameProj, time)
	self:setPublishingEvaluationState(gameProj, contractor.PUBLISHING_EVALUATION_STATES.EVALUATING)
	
	local range = contractor.GAME_PUBLISHING_EVALUATION_TIME
	
	time = time or math.random(range[1], range[2])
	
	table.insert(self.gamesToEvaluatePublish, {
		project = gameProj,
		time = time
	})
end

function contractor:evaluateGamePublishingRisk(gameObj)
	local company = gameObj:getOwner()
	local data = self.data.publishing
	
	if gameObj:getReleaseDate() or gameObj:getPublisher() then
		self:setPublishingEvaluationState(gameObj, contractor.PUBLISHING_EVALUATION_STATES.DECLINED)
		
		return false
	end
	
	if company:getReputation() < data.minimumReputation then
		local popup = game.createPopup(500, _T("PUBLISHING_OFFER_DECLINED_TITLE", "Publisher Declined Offer"), _format(_T("PUBLISHER_DECLINED_REPUTATION", "PUBLISHER has declined your request regarding your 'GAME' project.\nThey say your reputation is too low for them to consider you a safe investment."), "PUBLISHER", self:getName(), "GAME", gameObj:getName()), "pix24", "pix20", nil)
		
		frameController:push(popup)
		self:setPublishingEvaluationState(gameObj, contractor.PUBLISHING_EVALUATION_STATES.DECLINED)
		
		return false
	end
	
	if #company:getEmployees() < self.data.minimumEmployees then
		local popup = game.createPopup(500, _T("PUBLISHING_OFFER_DECLINED_TITLE", "Publisher Declined Offer"), _format(_T("PUBLISHER_DECLINED_EMPLOYEE_COUNT", "PUBLISHER has declined your request regarding your 'GAME' project.\nThey say your company doesn't have enough employees to be a safe investment for them yet."), "PUBLISHER", self:getName(), "GAME", gameObj:getName()), "pix24", "pix20", nil)
		
		frameController:push(popup)
		self:setPublishingEvaluationState(gameObj, contractor.PUBLISHING_EVALUATION_STATES.DECLINED)
		
		return false
	end
	
	if gameObj:getScale() < data.minimumGameScale then
		local popup = game.createPopup(500, _T("PUBLISHING_OFFER_DECLINED_TITLE", "Publisher Declined Offer"), _format(_T("PUBLISHER_DECLINED_GAME_SCALE", "PUBLISHER has declined your request regarding your 'GAME' project.\nThey say the game project is too small scale to be a safe investment for them."), "PUBLISHER", self:getName(), "GAME", gameObj:getName()), "pix24", "pix20", nil)
		
		frameController:push(popup)
		self:setPublishingEvaluationState(gameObj, contractor.PUBLISHING_EVALUATION_STATES.DECLINED)
		
		return false
	end
	
	local avgRating = company:getAverageRatingOfGames(nil, true, data.maxEvaluationRange)
	
	if avgRating < data.noGoRating then
		local popup = game.createPopup(500, _T("PUBLISHING_OFFER_DECLINED_TITLE", "Publisher Declined Offer"), _format(_T("PUBLISHER_DECLINED_TRACK_RECORD", "PUBLISHER has declined your request regarding your 'GAME' project.\nThey say your game track record in the last TIME is not satisfactory for them, and if we wish to cooperate with them, then we will need to make better games first."), "PUBLISHER", self:getName(), "GAME", gameObj:getName(), "TIME", timeline:getTimePeriodText(data.maxEvaluationRange)), "pix24", "pix20", nil)
		
		frameController:push(popup)
		self:setPublishingEvaluationState(gameObj, contractor.PUBLISHING_EVALUATION_STATES.DECLINED)
		
		return false
	end
	
	local risk = 1 - math.dist(data.noGoRating, avgRating) / (review.maxRating - data.noGoRating)
	
	if risk < math.randomf(0, 1) then
		local contractData = self:getGamePublishingContract(gameObj, risk)
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("GAME_PUBLISHING_CONTRACT_OFFER_TITLE", "Game Publishing Contract"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("GAME_PUBLISHING_CONTRACT_OFFER_DESC", "CONTRACTOR is open to publish your 'GAME' game. Here is the contract under which they're willing to cooperate with you:"), "CONTRACTOR", self:getName(), "GAME", gameObj:getName()))
		popup:setShowSound("generic_jingle")
		
		local wrapWidth = popup.rawW - 20
		local halfWrapWidth = wrapWidth * 0.5
		local deadline = contractData:getDeadline()
		local left, right, extra = popup:getDescboxes()
		
		left:addText(_format(_T("PUBLISHING_DEADLINE", "Deadline: YEAR/MONTH"), "YEAR", timeline:getYear(deadline), "MONTH", timeline:getMonth(deadline)), "bh20", nil, 3, halfWrapWidth, {
			{
				height = 26,
				icon = "generic_backdrop",
				width = 26
			},
			{
				width = 20,
				height = 20,
				y = 1,
				icon = "clock_full",
				x = 3
			}
		})
		left:addText(_format(_T("PUBLISHING_SHARE_PER_SALE", "Share per sale: SHARE%"), "SHARE", math.round(contractData:getFinalShares() * 100, 1)), "bh20", nil, 0, halfWrapWidth, "percentage", 26, 26)
		right:addText(_format(_T("PUBLISHING_ADVERTISEMENT_COSTS", "Advert. cost: $COST/week"), "COST", string.comma(contractData:getAdvertisementCosts())), "bh20", nil, 3, halfWrapWidth, {
			{
				height = 26,
				icon = "generic_backdrop",
				width = 26
			},
			{
				width = 20,
				height = 20,
				y = 1,
				icon = "wad_of_cash_minus",
				x = 3
			}
		})
		right:addText(_format(_T("PUBLISHING_DEV_COSTS_TO_COVER", "Dev. costs to cover: COVER%"), "COVER", math.round(self.data.coverFunding * 100)), "bh20", nil, 4, halfWrapWidth, "percentage", 26, 26)
		extra:addText(_T("PUBLISHING_ADVERTISEMENT_EXPLANATION", "The publisher will advertise the game while you work on it, but the game sales will have to cover the expenses before you can receive your share."), "bh18", nil, 0, wrapWidth, "question_mark", 22, 22)
		extra:addText(_T("PUBLISHING_CANCELLING_PENALTY_EXPLANATION", "Scrapping the game under this contract will yield you a penalty of twice the development cost."), "bh18", nil, 0, wrapWidth, "exclamation_point", 22, 22)
		
		local button = popup:addButton(fonts.get("pix20"), _T("ACCEPT_PUBLISHING_CONTRACT", "Accept contract"), contractor.acceptPublishingContractCallback)
		
		button.contractor = self
		button.contractData = contractData
		button.project = gameObj
		
		local button = popup:addButton(fonts.get("pix20"), _T("DECLINE_PUBLISHING_CONTRACT", "Decline contract"), contractor.declinePublishingContractCallback)
		
		button.contractor = self
		button.project = gameObj
		
		popup:hideCloseButton()
		popup:center()
		frameController:push(popup)
	else
		local popup = game.createPopup(500, _T("PUBLISHING_OFFER_DECLINED", "Publisher Declined Offer"), _format(_T("PUBLISHER_DECLINED_RISKY_PROJECT", "PUBLISHER has declined your request regarding your 'GAME' project.\nThey say the game project is too much of a financial risk to be considered a good investment of money."), "PUBLISHER", self:getName(), "GAME", gameObj:getName()), "pix24", "pix20", nil)
		
		frameController:push(popup)
		self:setPublishingEvaluationState(gameObj, contractor.PUBLISHING_EVALUATION_STATES.DECLINED)
		
		return false
	end
end

function contractor:getGamePublishingContract(gameObj, riskRating)
	local publishData = self.data.publishing
	local scale = gameObj:getScale()
	local scale = scale - publishData.minimumGameScale
	local deadline = timeline.curTime + self:calculateDeadline(1 - gameObj:getOverallCompletion(), scale) * timeline.DAYS_IN_MONTH
	local rep = studio:getReputation()
	local strength = math.lerp(publishData.minAdvertisement, 1, math.min(1, scale / (publishData.maxAdvertAtGameScale - publishData.minimumGameScale))) * math.lerp(publishData.minReputationAdvert, 1, (rep - publishData.minimumReputation) / (publishData.maximumReputation - publishData.minimumReputation))
	local data = contractData.new()
	
	data:setContractType(contractor.CONTRACT_TYPES.PUBLISHED)
	data:setScale(gameObj:getScale())
	data:setDeadline(deadline)
	data:setAdvertisementStrength(math.lerp(publishData.popularityGainMin, publishData.popularityGainMax, strength))
	data:setAdvertisementCosts(math.lerp(publishData.advertisementCostMin, publishData.advertisementCostMax, strength))
	data:setFinalShares(math.lerp(publishData.minShare, publishData.maxShare, riskRating))
	data:setMilestone(math.round(gameObj:getOverallCompletion(), 1))
	
	return data
end

function contractor:setPublishingEvaluationState(gameObj, state)
	local list = gameObj:getFact(contractor.EVALUATED_GAME_PUBLISHING) or {}
	
	list[self.id] = state
	
	gameObj:setFact(contractor.EVALUATED_GAME_PUBLISHING, list)
end

function contractor:addProjectToEvaluate(gameProj, time)
	table.insert(self.projectsToEvaluate, {
		project = gameProj,
		time = time
	})
end

function contractor:doesProjectRequireEvaluation(gameProj)
	for key, data in ipairs(self.projectsToEvaluate) do
		if data.project == gameProj then
			return true
		end
	end
	
	return false
end

function contractor:getContractData()
	return self.currentContractData
end

function contractor:evaluateProjectSuccess(gameProj)
	local rating = gameProj:getReviewRating()
	local finalShare
	local minimumShares = self:getMinimumShares()
	local data = gameProj:getContractData()
	
	if rating >= data:getTargetRating() then
		local deadlinePenalty = self:getOverDeadlinePenalty(data)
		
		finalShare = math.max(data:getOfferedShares() - deadlinePenalty, minimumShares)
		
		if deadlinePenalty <= 0 then
			contractWork:advanceContractAchievements()
		end
	else
		finalShare = minimumShares
	end
	
	data:setFinalShares(finalShare)
	
	local popup = gui.create("ProjectEvaluationPopup")
	
	popup:setWidth(600)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("CONTRACT_PROJECT_EVALUATION_TITLE", "Contract Project Evaluation"))
	popup:setText(_format(_T("CONTRACT_PROJECT_EVALUATION_DESC", "A month has passed since the release of PROJECT, the contractor has gone over the ratings received from reviews, and here is their decision:"), "PROJECT", gameProj:getName()))
	popup:setProject(gameProj)
	popup:setContractor(self)
	popup:hideCloseButton()
	popup:addOKButton(fonts.get("pix20"))
	popup:center()
	frameController:push(popup)
	data:setEvaluationState(contractor.EVALUATION_STATES.EVALUATED)
	self:payOutExistingSales(gameProj)
	contractWork:setCurrentContractor(nil)
end

function contractor:getOverDeadlinePenalty(data)
	return math.min(self:_getOverDeadlinePenalty(data), self:getMinimumShares())
end

function contractor:_getOverDeadlinePenalty(data)
	return (self.data.shareLossPerDayOverDeadline or contractor.DEFAULT_SHARE_LOSS_PER_DAY_OVER_DEADLINE) * data:getDaysOverDeadline() * (data:getOfferedShares() or data:getFinalShares())
end

function contractor:hasReachedMaximumPenalty(gameProj)
	return self:getOverDeadlinePenalty(gameProj:getContractData()) >= self:getMinimumShares()
end

function contractor:payOutExistingSales(gameProj)
	local data = gameProj:getContractData()
	
	self:payShareMoney(data:getSaleMoney(), data:getTotalSales(), gameProj)
	events:fire(gameProject.EVENTS.UPDATE_SALE_DISPLAY, gameProj)
end

function contractor:createBeginWorkPopup()
	studio:addResearchedGenre(self.currentContractData:getDesiredGenre())
	
	local popup = gui.create("ContractWorkPopup")
	
	popup:setWidth(700)
	popup:setFont("pix24")
	popup:setTitle(_T("START_OF_CONTRACT_WORK_TITLE", "Start of Contract Work"))
	popup:setTextFont("pix20")
	popup:setText(string.easyformatbykeys(_T("START_OF_CONTRACT_WORK_DESC", "The contractor has gotten back to you and has transferred $INSTANT_CASH as agreed. You will now be redirected to the projects menu, where you will need to select whatever you think is necessary to make a good game.\n\nQuick reminder:"), "CONTRACTOR", self:getName(), "INSTANT_CASH", string.comma(self.currentContractData:getInstantCash())))
	popup:setShowSound("generic_jingle")
	popup:setContractor(self)
	
	popup:addButton(fonts.get("pix20"), _T("TAKE_ME_THERE", "Take me there"), contractor.beginWorkOption).contractor = self
	
	popup:hideCloseButton()
	popup:center()
	frameController:push(popup)
	
	self.delayPeriod = nil
	
	events:fire(contractor.EVENTS.BEGUN_PROJECT_SETUP, self)
end

eventBoxText:registerNew({
	id = "received_instant_cash",
	getText = function(self, data)
		return _format(_T("RECEIVED_INSTANT_CASH", "Received INSTANT_CASH from contractor."), "INSTANT_CASH", string.roundtobigcashnumber(data))
	end
})

function contractor:giveInstantCash(gameProj)
	local cash = self.currentContractData:getInstantCash()
	
	self:giveMoneyToStudio(cash, gameProj, self.currentContractData)
	game.addToEventBox("received_instant_cash", cash, 1, nil, "wad_of_cash")
end

function contractor:beginWork()
	projectsMenu:setClickableTabs(true, false, false, false, true, true)
	projectsMenu:createProjectsMenu()
	projectsMenu:switchToNewGameTab()
	projectsMenu:hideCloseButton()
	
	local gameProj = projectsMenu:getGameProjectObject()
	
	gameProj:setContractData(self.currentContractData)
	gameProj:setDeadline(self.currentContractData:getDeadline())
	gameProj:setContractor(self)
	table.insert(self.gameProjects, gameProj)
	self:giveInstantCash(gameProj)
	gameProj:getContractData():setStartOfWork(timeline.curTime)
	self:applyMilestone(gameProj)
	
	self.playerWorking = true
end

function contractor:getProjects()
	return self.gameProjects
end

function contractor:hasProject(projObj)
	return table.find(self.gameProjects, projObj)
end

function contractor:getShareFromMoney(amount, data)
	return math.ceil(amount * data:getFinalShares())
end

function contractor:hasEvaluatedProject(projectObject)
	return projectObject:getContractData():hasEvaluatedProject()
end

function contractor:addSaleMoney(money, saleAmount, gameProj)
	local data = gameProj:getContractData()
	local contractType = data:getContractType()
	
	if not studio:getFact(contractor.FIRST_TIME_CONTRACTOR_SALE_FACT) and contractType == contractor.CONTRACT_TYPES.REGULAR then
		local popup = gui.create("Popup")
		
		popup:setWidth(600)
		popup:setFont(fonts.get("pix24"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setTitle(_T("CONTRACT_PROJECT_SALES_TITLE", "Contract Project Sales"))
		popup:setText(string.easyformatbykeys(_T("CONTRACT_PROJECT_SALES_DESC", "'PROJECT' has just sold SALES copies and has made $MONEY_MADE, however since the publisher is still evaluating the success of the project, he will get back to you on the payments later.\n\nAll accumulated sales will be paid out once the contractor finishes the evaluation."), "PROJECT", gameProj:getName(), "SALES", string.comma(saleAmount), "MONEY_MADE", string.comma(money)))
		popup:addOKButton(fonts.get("pix20"))
		popup:center()
		frameController:push(popup)
		studio:setFact(contractor.FIRST_TIME_CONTRACTOR_SALE_FACT, true)
	end
	
	data:addSaleMoney(money)
	data:addTotalSales(saleAmount)
	
	if self:hasEvaluatedProject(gameProj) or contractType == contractor.CONTRACT_TYPES.PUBLISHED then
		self:payShareMoney(money, saleAmount, gameProj)
	end
end

eventBoxText:registerNew({
	id = "received_share_payout",
	getText = function(self, data)
		return _format(_T("RECEIVED_CONTRACTOR_SALE_SHARE", "Received contractor share payout of $MONEY from SALE_AMOUNT sales"), "MONEY", string.roundtobignumber(data.money), "SALE_AMOUNT", string.roundtobignumber(data.sales))
	end
})

function contractor:payShareMoney(amountOfMoney, saleAmount, projectObject)
	local recoup = projectObject:getRecoupAmount()
	local residue = recoup - amountOfMoney
	
	if residue > 0 then
		projectObject:setRecoupAmount(residue)
		
		return 
	else
		residue = math.abs(residue)
		
		projectObject:setRecoupAmount(math.min(0, residue))
	end
	
	local data = projectObject:getContractData()
	local saleMoney = self:getShareFromMoney(residue, data)
	
	data:addPlayersShare(saleMoney)
	projectObject:addShareMoney(saleMoney)
	self:giveMoneyToStudio(saleMoney, nil, data)
	game.addToEventBox("received_share_payout", {
		money = saleMoney,
		sales = saleAmount
	}, 2)
end

function contractor:refuseOffer()
	self:clearContractData()
	self:clearEvaluationData()
end

function contractor:acceptOffer()
	self.acceptedOffer = true
	
	self:createUpcomingContractDisplay()
end

function contractor:clearAllContractData()
	self:clearContractData()
	self:clearEvaluationData()
end

function contractor:clearContractData()
	self.delayPeriod = nil
	self.acceptedOffer = nil
	self.playerWorking = nil
	self.currentContractData = nil
end

function contractor:clearEvaluationData()
	table.clear(self.preferredGenres)
	table.clear(self.avoidedGenres)
	
	self.mostPreferredGenre = nil
end

function contractor:setDelayPeriod(delay)
	self.delayPeriod = delay
end

function contractor:getDelayPeriod()
	return self.delayPeriod
end

function contractor:getExtraScale()
	return math.randomf(self.data.extraScale.min, self.data.extraScale.max)
end

function contractor:pickDesiredGameType()
	return gameProject.DEVELOPMENT_TYPE.NEW
end

function contractor:getDesiredGameType()
	return self.currentContractData:getGameType()
end

function contractor:calculateDeadline(workRemainder, scale)
	workRemainder = workRemainder or 1
	scale = scale or self.currentContractData:getScale()
	
	return math.max(math.ceil(contractor.BASE_PROJECT_DEADLINE_TIME_AMOUNT + scale * contractor.SCALE_TO_DEADLINE_TIME + timeline:getPassedYears() * contractor.PASSED_YEARS_TO_DEADLINE_TIME - #studio:getEmployees() * contractor.EMPLOYEE_COUNT_TO_DEADLINE_TIME_REDUCTION) * self.data.overallDevelopmentTimeMultiplier * workRemainder, contractor.BASE_PROJECT_DEADLINE_TIME_AMOUNT)
end

function contractor:prepareContractData()
	local scale, cost = self:pickDesiredGameScale()
	
	if not scale then
		return false
	end
	
	self.delayPeriod = contractWork:getDelayPeriod()
	self.currentContractData = contractData.new()
	
	self.currentContractData:setContractType(contractor.CONTRACT_TYPES.REGULAR)
	
	local data = self.currentContractData
	
	data:setScale(scale)
	data:setPrice(cost)
	data:setGameType(self:pickDesiredGameType())
	data:setTargetRating(self:pickDesiredMinimumRating())
	data:setDeadline(self:pickDeadline())
	data:setInstantCash(self:pickInstantCash())
	data:setMonthlyFunding(self:pickMonthlyFunding())
	data:setDesiredGenre(self:pickPreferredGenre())
	data:setOfferedShares(self:pickShareAmount())
	
	return true
end

function contractor:pickDeadline()
	return math.ceil(timeline.curTime + self:calculateDeadline() * timeline.DAYS_IN_MONTH) + self.delayPeriod
end

function contractor:getDeadline()
	return self.currentContractData:getDeadline()
end

function contractor:calculateInstantCash()
	return math.ceil(self:getTargetRatingInstantCashAffector() * self:getInstantCashScaleMultiplier() * self:getYearsInstantCashAffector(self.data.instantCash.yearMultiplier) / contractor.INSTANT_CASH_ROUNDING_SEGMENT) * contractor.INSTANT_CASH_ROUNDING_SEGMENT
end

function contractor:getYearsInstantCashAffector(yearMultiplier)
	return math.max(1, (self.currentContractData:getDeadline() - timeline.curTime) / timeline.DAYS_IN_YEAR * yearMultiplier)
end

function contractor:getTargetRatingInstantCashAffector()
	return self.data.instantCash.ratingPoint * self.currentContractData:getTargetRating()
end

function contractor:getInstantCashScaleMultiplier()
	return 1 + self.currentContractData:getScale() * self.data.instantCash.scaleMultiplier
end

function contractor:pickInstantCash()
	return self:calculateInstantCash()
end

function contractor:getInstantCash()
	return self.currentContractData:getInstantCash()
end

function contractor:calculateMonthlyFunding()
	return math.ceil((self:getEmployeeCountFundingAffector() + self:getScaleFundingAffector() + self:getRatingFundingAffector()) * self:getYearsPassedMoneyAffector(self.data.monthlyFunding.yearMultiplier) / contractor.FUNDING_ROUNDING_SEGMENT) * contractor.FUNDING_ROUNDING_SEGMENT
end

function contractor:pickMonthlyFunding()
	return self:calculateMonthlyFunding()
end

function contractor:getMonthlyFunding()
	return self.currentContractData:getMonthlyFunding()
end

function contractor:getScaleFundingAffector()
	return self.currentContractData:getScale() * self.data.monthlyFunding.scaleMultiplier
end

function contractor:getEmployeeCountFundingAffector()
	return #studio:getEmployees() * self.data.monthlyFunding.perPerson
end

function contractor:getYearsPassedMoneyAffector(multiplier)
	return 1 + timeline:getPassedYears() * multiplier
end

function contractor:getRatingFundingAffector()
	return self.data.monthlyFunding.perRating * self.currentContractData:getTargetRating()
end

function contractor:pickDesiredMinimumRating()
	return math.random(self.data.targetRating.min, self.data.targetRating.max)
end

function contractor:getTargetRating()
	return self.currentContractData:getTargetRating()
end

function contractor:pickShareAmount()
	local avg = math.abs(self.data.minShareRating - math.max(math.min(contractWork:getTotalAverageRating(), self.data.maxShareRating), self.data.minShareRating)) / (self.data.maxShareRating - self.data.minShareRating)
	
	return math.round(math.lerp(self.data.shareBoundaries.min, self.data.shareBoundaries.max, avg), 2)
end

function contractor:getMinimumShares()
	return self.data.shareBoundaries.min
end

function contractor:pickPreferredGenre()
	local trendingGenres = trends:getGenreTrends()
	local highestWeight, bestGenre = -math.huge
	
	for key, data in ipairs(trendingGenres) do
		local rating = self.preferredGenres[data.id]
		
		if rating then
			local currentWeight = rating * contractWork.RATING_TO_WEIGHT + data.time * contractWork.TREND_MONTH_TO_WEIGHT
			
			if highestWeight < currentWeight then
				highestWeight = currentWeight
				bestGenre = data.id
			end
		end
	end
	
	if not bestGenre then
		local rating, genre = table.random(self.preferredGenres)
		
		return genre
	end
	
	return bestGenre
end

contractor.MAX_SCALE_SCALAR = 0.5

function contractor:pickDesiredGameScale()
	local scale = gameProject.SCALE[gameProject.DEVELOPMENT_TYPE.NEW]
	local finalScale = math.round(math.min(math.max(contractWork:getLargestGameScale() + self:getExtraScale(), scale[1]), scale[2]), 1)
	local largestScale = -math.huge
	local platMap = studio:getLicensedPlatformsMap()
	
	for key, plat in ipairs(platformShare:getOnMarketPlatforms()) do
		if platMap[plat:getID()] then
			largestScale = math.max(largestScale, plat:getMaxProjectScale())
		end
	end
	
	for key, object in ipairs(platformShare:getOnMarketPlatforms()) do
		if not object.PLAYER and platMap[object:getID()] then
			local curScale = object:getMaxProjectScale()
			
			if curScale / largestScale > contractor.MAX_SCALE_SCALAR then
				finalScale = math.min(finalScale, curScale)
			end
		end
	end
	
	local skillValue = 0
	
	for key, teamObj in ipairs(studio:getTeams()) do
		local skillLevels = teamObj:getTotalSkills()
		
		for key, skillData in ipairs(skills.registered) do
			skillValue = skillValue + skillLevels[skillData.id] * skillData.contractEvaluationWeight
		end
	end
	
	local scaleFromSkill = skillValue / self.data.skillValueForScale
	
	finalScale = math.round(math.min(finalScale, scaleFromSkill), 1)
	
	local maxScale = gameProject:calculateMaxPriceScale()
	local modifier = math.max(0, finalScale) / maxScale
	local index = math.max(1, math.ceil(#gameProject.PRICE_POINTS * modifier))
	local desiredCost = gameProject.PRICE_POINTS[index]
	
	if desiredCost < self.data.minimumGameCost then
		return false, false
	end
	
	local desiredCost = math.max(self.data.minimumGameCost, desiredCost)
	local cost = desiredCost
	
	return finalScale, cost
end

function contractor:getDesiredCost()
	return self.currentContractData:getPrice()
end

function contractor:getTargetGenre()
	return self.currentContractData:getDesiredGenre()
end

function contractor:getDesiredGameScale()
	return self.currentContractData:getScale()
end

function contractor:setMostPreferredGenre(genre)
	self.mostPreferredGenre = genre
end

function contractor:getPreferredGenres()
	return self.preferredGenres
end

function contractor:getAvoidedGenres()
	return self.avoidedGenres
end

function contractor:save()
	local data = {
		id = self.id,
		mostPreferredGenre = self.mostPreferredGenre,
		delayPeriod = self.delayPeriod,
		acceptedOffer = self.acceptedOffer,
		contractCount = self.contractCount,
		playerWorking = self.playerWorking,
		gameProjects = {},
		projectsToEvaluate = {},
		gamesToEvaluatePublish = {}
	}
	
	for key, gameProj in ipairs(self.gameProjects) do
		table.insert(data.gameProjects, gameProj:getUniqueID())
	end
	
	if self.currentContractData then
		data.currentContractData = self.currentContractData:save()
	end
	
	for key, evalData in ipairs(self.projectsToEvaluate) do
		data.projectsToEvaluate[#data.projectsToEvaluate + 1] = {
			id = evalData.project:getUniqueID(),
			time = evalData.time
		}
	end
	
	for key, evalData in ipairs(self.gamesToEvaluatePublish) do
		data.gamesToEvaluatePublish[#data.gamesToEvaluatePublish + 1] = {
			id = evalData.project:getUniqueID(),
			time = evalData.time
		}
	end
	
	return data
end

function contractor:load(data)
	self:setData(data.id)
	
	self.mostPreferredGenre = data.mostPreferredGenre
	self.delayPeriod = data.delayPeriod
	self.acceptedOffer = data.acceptedOffer
	self.contractCount = data.contractCount or self.contractCount
	self.playerWorking = data.playerWorking
	
	if not self.acceptedOffer then
		self.delayPeriod = nil
		self.currentContractData = nil
	end
	
	if data.currentContractData and self.acceptedOffer then
		self.currentContractData = contractData.new()
		
		self.currentContractData:load(data.currentContractData)
	end
	
	if data.gameProjects then
		for key, gameID in ipairs(data.gameProjects) do
			table.insert(self.gameProjects, studio:getProjectByUniqueID(gameID))
		end
	end
	
	if data.projectsToEvaluate then
		for key, projectData in ipairs(data.projectsToEvaluate) do
			self:addProjectToEvaluate(studio:getProjectByUniqueID(projectData.id), projectData.time)
		end
	end
	
	if data.gamesToEvaluatePublish then
		for key, projectData in ipairs(data.gamesToEvaluatePublish) do
			self:queueGamePublishingEvaluation(studio:getProjectByUniqueID(projectData.id), projectData.time)
		end
	end
	
	if self:shouldStartWork() and (not self.delayPeriod or self.delayPeriod and self.delayPeriod <= 0) then
		self:createBeginWorkPopup()
	end
	
	if self.delayPeriod then
		self:createUpcomingContractDisplay()
	end
	
	events:fire(contractor.EVENTS.LOADED, self)
end
