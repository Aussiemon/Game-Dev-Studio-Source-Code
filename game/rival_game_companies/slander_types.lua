local baseSlanderFuncs = {}

baseSlanderFuncs.mtindex = {
	__index = baseSlanderFuncs
}

function baseSlanderFuncs:getSlanderSuccessChance(slanderer)
	return math.min(100, math.max(self.minimumSuccessChance, math.round(self.baseSuccessChance - slanderer:getSlanderSuspicion() * self.chanceDropPerSuspicion)))
end

function baseSlanderFuncs:getTargetAffectChance(slanderer)
	return math.min(100, math.round(self.baseAngerChance + self.angerChancePerSuspicion * slanderer:getSlanderSuspicion()))
end

function baseSlanderFuncs:getCost()
	return self.cost
end

function baseSlanderFuncs:calculateReputationDrop(target)
	return math.max(math.random(self.reputationDrop[1], self.reputationDrop[2]), target:getReputation() * self.reputationPercentageDrop)
end

function baseSlanderFuncs:getAngerChange()
	return self.angerChange
end

function baseSlanderFuncs:getIntimidationChange()
	return self.intimidationChange
end

function baseSlanderFuncs:getReputationDrop()
	return self.reputationDrop
end

function baseSlanderFuncs:getReputationPercentageDrop()
	return self.reputationPercentageDrop
end

function baseSlanderFuncs:getSuspicionIncrease()
	return self.suspicionIncrease
end

function baseSlanderFuncs:getName()
	return self.display
end

function baseSlanderFuncs:getDescription()
	return self.description
end

function baseSlanderFuncs:finishSlander(slanderer, target)
	local success = math.random(1, 100) <= self:getSlanderSuccessChance(slanderer)
	local reputationDrop = 0
	
	if success then
		reputationDrop = self:calculateReputationDrop(target)
		
		target:decreaseReputation(reputationDrop)
		target:logSlanderReputationLoss(reputationDrop, slanderer)
	end
	
	local chance = self:getTargetAffectChance(slanderer)
	
	if target:isPlayer() then
		chance = chance * slanderer:getPlayerRivalSlanderDiscoveryChanceMultiplier()
	end
	
	local foundOut = chance >= math.random(1, 100)
	
	if foundOut then
		if not target:isPlayer() then
			target:changeAnger(self:getAngerChange(), rivalGameCompany.ANGER_CHANGE_REASON.SLANDER)
			target:changeIntimidation(self:getIntimidationChange())
			
			if target:getAnger() >= target:getAngerForLegalAction() then
				target:scheduleLegalAction()
			end
		end
		
		if target:isPlayer() then
			target:logSlanderKnowledge(slanderer)
		else
			target:changeRelationship(self.relationshipChange)
		end
	end
	
	slanderer:changeSlanderSuspicion(self.suspicionIncrease)
	
	return success, foundOut, reputationDrop
end

function rivalGameCompanies.registerSlander(data, baseClass)
	table.insert(rivalGameCompanies.registeredSlander, data)
	
	rivalGameCompanies.registeredSlanderByID[data.id] = data
	data.mtindex = {
		__index = data
	}
	
	if baseClass then
		setmetatable(data, rivalGameCompanies.registeredSlanderByID[data.id].mtindex)
	else
		setmetatable(data, baseSlanderFuncs.mtindex)
	end
end

rivalGameCompanies.registerSlander({
	angerChancePerSuspicion = 1,
	cost = 0,
	baseAngerChance = 5,
	unusableByRivals = true,
	reputationPercentageDrop = 0.01,
	suspicionIncrease = 5,
	relationshipChange = -2,
	angerChange = 5,
	minimumSuccessChance = 5,
	id = "shitpost_online",
	baseSuccessChance = 20,
	intimidationChange = 2,
	display = _T("SHITPOST_ONLINE", "Spread misinformation"),
	description = _T("SHITPOST_ONLINE_DESCRIPTION", "Make up the craziest lies about the rival game studio in your free time. Some people might be gullible enough to believe it."),
	chanceDropPerSuspicion = 130 / rivalGameCompanies.SUSPICION_MAX,
	reputationDrop = {
		15,
		25
	},
	getBeginSlanderText = function(self, rivalObject)
		return _T("PLAYER_SHITPOSTING_STARTED", "You've begun writing slander about 'RIVAL' whenever you have some free time.\n\nThe results of your efforts will become known to you on the start of the next week.")
	end,
	getSlanderResultText = function(self, success, repLoss, rivalObj)
		if success then
			return _format(_T("PLAYER_SHITPOSTING_FINISHED_DETAILED_SUCCESS", "The lies you made up online were effective - some people believed them, and, 'RIVAL' has lost REPLOSS."), "REPLOSS", repLoss, "RIVAL", rivalObj:getName())
		else
			return _format(_T("PLAYER_SHITPOSTING_FINISHED_DETAILED_FAILURE", "The lies you made up online weren't effective, noone believed them. 'RIVAL' has not lost any reputation."), "RIVAL", rivalObj:getName())
		end
	end
})
rivalGameCompanies.registerSlander({
	baseAngerChance = 20,
	angerChange = 20,
	suspicionIncrease = 25,
	cost = 10000,
	angerChancePerSuspicion = 1,
	intimidationChange = 4,
	minimumSuccessChance = 5,
	reputationPercentageDrop = 0.05,
	id = "light_slander",
	baseSuccessChance = 90,
	relationshipChange = -10,
	display = _T("LIGHT_SLANDER", "Light slander"),
	description = _T("LIGHT_SLANDER_DESCRIPTION", "Spread facts laced with little lies about the rival game company, slightly impacting its reputation."),
	chanceDropPerSuspicion = 90 / rivalGameCompanies.SUSPICION_MAX,
	reputationDrop = {
		200,
		300
	}
})
rivalGameCompanies.registerSlander({
	baseAngerChance = 40,
	angerChange = 50,
	suspicionIncrease = 40,
	cost = 20000,
	angerChancePerSuspicion = 1,
	intimidationChange = 10,
	minimumSuccessChance = 2,
	reputationPercentageDrop = 0.1,
	id = "medium_slander",
	baseSuccessChance = 75,
	relationshipChange = -20,
	display = _T("MEDIUM_SLANDER", "Moderate slander"),
	description = _T("MEDIUM_SLANDER_DESCRIPTION", "Morph facts into lies about the rival game company and its games, moderately impacting its reputation."),
	chanceDropPerSuspicion = 85 / rivalGameCompanies.SUSPICION_MAX,
	reputationDrop = {
		750,
		1100
	}
})
rivalGameCompanies.registerSlander({
	baseAngerChance = 60,
	angerChange = 100,
	suspicionIncrease = 70,
	cost = 40000,
	angerChancePerSuspicion = 1,
	intimidationChange = 20,
	minimumSuccessChance = 0,
	reputationPercentageDrop = 0.15,
	id = "heavy_slander",
	baseSuccessChance = 60,
	relationshipChange = -30,
	display = _T("HEAVY_SLANDER", "Heavy slander"),
	description = _T("HEAVY_SLANDER_DESCRIPTION", "Spread near-complete misinformation about the rival game company, its games and the employees, heavily impacting its reputation."),
	chanceDropPerSuspicion = 80 / rivalGameCompanies.SUSPICION_MAX,
	reputationDrop = {
		1600,
		2400
	}
})
