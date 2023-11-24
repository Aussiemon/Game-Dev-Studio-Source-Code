contractData = {}
contractData.mtindex = {
	__index = contractData
}

function contractData.new()
	local new = {}
	
	setmetatable(new, contractData.mtindex)
	new:init()
	
	return new
end

function contractData:init()
	self.saleMoney = 0
	self.totalSales = 0
	self.finalShares = 0
	self.moneyGivenToStudio = 0
	self.reachedMilestones = 0
	self.playersShare = 0
	self.daysOverDeadline = 0
	self.milestone = 0
	self.advertCost = 0
	self.evaluationState = contractor.EVALUATION_STATES.NONE
end

function contractData:setStartOfWork(work)
	self.startOfWork = work
end

function contractData:getStartOfWork()
	return self.startOfWork
end

function contractData:setScale(scale)
	self.gameScale = scale
end

function contractData:getScale()
	return self.gameScale
end

function contractData:setPrice(price)
	self.price = price
end

function contractData:getPrice()
	return self.price
end

function contractData:setMonthlyFunding(fund)
	self.monthlyFunding = fund
end

function contractData:getMonthlyFunding()
	return self.monthlyFunding
end

function contractData:setGameType(type)
	self.gameType = type
end

function contractData:getGameType()
	return self.gameType
end

function contractData:setDesiredGenre(genre)
	self.genre = genre
end

function contractData:getDesiredGenre()
	return self.genre
end

function contractData:setDeadline(dead)
	self.deadline = dead
end

function contractData:getDeadline(dead)
	return self.deadline
end

function contractData:setInstantCash(cash)
	self.instantCash = cash
end

function contractData:getInstantCash(cash)
	return self.instantCash
end

function contractData:addMoneyGivenToStudio(money)
	self.moneyGivenToStudio = self.moneyGivenToStudio + money
end

function contractData:setMoneyGivenToStudio(money)
	self.moneyGivenToStudio = money
end

function contractData:getMoneyGivenToStudio(money)
	return self.moneyGivenToStudio
end

function contractData:addReachedMilestones(add)
	self.reachedMilestones = self.reachedMilestones + add
end

function contractData:setReachedMilestones(milestones)
	self.reachedMilestones = milestones
end

function contractData:getReachedMilestones(milestones)
	return self.reachedMilestones
end

function contractData:setOfferedShares(share)
	self.sharePerSale = share
end

function contractData:getOfferedShares()
	return self.sharePerSale
end

function contractData:setFinalShares(share)
	self.finalShares = share
end

function contractData:getFinalShares()
	return self.finalShares
end

function contractData:setTargetRating(rat)
	self.targetRating = rat
end

function contractData:getTargetRating()
	return self.targetRating
end

function contractData:setContractType(type)
	self.type = type
end

function contractData:getContractType()
	return self.type
end

function contractData:isPublishing()
	return self.type == contractor.CONTRACT_TYPES.PUBLISHED
end

function contractData:addSaleMoney(saleMoney)
	self.saleMoney = self.saleMoney + saleMoney
end

function contractData:setSaleMoney(saleMoney)
	self.saleMoney = saleMoney
end

function contractData:getSaleMoney()
	return self.saleMoney
end

function contractData:addTotalSales(sales)
	self.totalSales = self.totalSales + sales
end

function contractData:setTotalSales(sales)
	self.totalSales = sales
end

function contractData:getTotalSales()
	return self.totalSales
end

function contractData:setEvaluationState(eval)
	self.evaluationState = eval
end

function contractData:getEvaluationState()
	return self.evaluationState
end

function contractData:addPlayersShare(share)
	self.playersShare = self.playersShare + share
end

function contractData:setPlayersShare(share)
	self.playersShare = share
end

function contractData:getPlayersShare()
	return self.playersShare
end

function contractData:addDaysOverDeadline(days)
	self.daysOverDeadline = self.daysOverDeadline + days
end

function contractData:getDaysOverDeadline()
	return self.daysOverDeadline
end

function contractData:setMaxSharePenaltyDate(date)
	self.maxSharePenaltyDate = date
end

function contractData:getMaxSharePenaltyDate()
	return self.maxSharePenaltyDate
end

function contractData:setMilestone(milestone)
	self.lastMilestone = self.milestone
	self.milestone = milestone
end

function contractData:getMilestone()
	return self.milestone
end

function contractData:getLastMilestone()
	return self.lastMilestone
end

function contractData:setMilestoneDate(date)
	self.milestoneDate = date
end

function contractData:getMilestoneDate()
	return self.milestoneDate
end

function contractData:setLastMilestoneReached(reach)
	self.lastMilestoneReached = reach
end

function contractData:getLastMilestoneReached()
	return self.lastMilestoneReached
end

function contractData:getMilestoneData()
	return self.milestoneDate, self.milestone, self.lastMilestoneReached
end

function contractData:isEvaluatingProject()
	return self.evaluationState == contractor.EVALUATION_STATES.EVALUATING
end

function contractData:hasEvaluatedProject()
	return self.evaluationState == contractor.EVALUATION_STATES.EVALUATED
end

function contractData:setAdvertisementStrength(strength)
	self.advertStrength = strength
end

function contractData:getAdvertisementStrength()
	return self.advertStrength
end

function contractData:setAdvertisementCosts(cost)
	self.advertCost = cost
end

function contractData:getAdvertisementCosts()
	return self.advertCost
end

function contractData:save()
	return {
		deadline = self.deadline,
		instantCash = self.instantCash,
		moneyGivenToStudio = self.moneyGivenToStudio,
		reachedMilestones = self.reachedMilestones,
		sharePerSale = self.sharePerSale,
		targetRating = self.targetRating,
		saleMoney = self.saleMoney,
		playersShare = self.playersShare,
		gameScale = self.gameScale,
		price = self.price,
		gameType = self.gameType,
		genre = self.genre,
		monthlyFunding = self.monthlyFunding,
		evaluationState = self.evaluationState,
		totalSales = self.totalSales,
		finalShares = self.finalShares,
		daysOverDeadline = self.daysOverDeadline,
		maxSharePenaltyDate = self.maxSharePenaltyDate,
		milestone = self.milestone,
		lastMilestone = self.lastMilestone,
		lastMilestoneReached = self.lastMilestoneReached,
		startOfWork = self.startOfWork,
		milestoneDate = self.milestoneDate,
		advertCost = self.advertCost,
		advertStrength = self.advertStrength,
		type = self.type
	}
end

function contractData:load(data)
	self.deadline = data.deadline
	self.instantCash = data.instantCash
	self.moneyGivenToStudio = data.moneyGivenToStudio
	self.reachedMilestones = data.reachedMilestones
	self.sharePerSale = data.sharePerSale
	self.targetRating = data.targetRating
	self.saleMoney = data.saleMoney
	self.playersShare = data.playersShare
	self.gameScale = data.gameScale
	self.price = data.price
	self.gameType = data.gameType
	self.genre = data.genre
	self.monthlyFunding = data.monthlyFunding
	self.evaluationState = data.evaluationState
	self.totalSales = data.totalSales
	self.finalShares = data.finalShares
	self.daysOverDeadline = data.daysOverDeadline
	self.maxSharePenaltyDate = data.maxSharePenaltyDate
	self.milestone = data.milestone
	self.lastMilestone = data.lastMilestone
	self.lastMilestoneReached = data.lastMilestoneReached
	self.startOfWork = data.startOfWork
	self.milestoneDate = data.milestoneDate
	self.advertCost = data.advertCost
	self.advertStrength = data.advertStrength
	self.type = data.type
end
