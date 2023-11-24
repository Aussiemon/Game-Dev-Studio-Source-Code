local subEvents = {}

gameProject.subEvents = subEvents
subEvents.onRatingChange = {}
subEvents.onGameRelease = {}
subEvents.registered = {}
subEvents.registeredByID = {}

function subEvents:registerNew(data, inherit)
	table.insert(subEvents.registered, data)
	
	subEvents.registeredByID[data.id] = data
	
	if data.onRatingChanged then
		table.insert(subEvents.onRatingChange, data)
	end
	
	if data.onGameReleased then
		table.insert(subEvents.onGameRelease, data)
	end
	
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		data.baseClass = subEvents.registeredByID[inherit]
		
		setmetatable(data, data.baseClass.mtindex)
	end
end

function subEvents:get(id)
	return self.registeredByID[id]
end

function subEvents:onRatingChanged(gameProj)
	local subEvents = gameProj:getPerformedSubEvents()
	
	for key, data in ipairs(self.onRatingChange) do
		if not subEvents[data.id] then
			data:onRatingChanged(gameProj)
		end
	end
end

function subEvents:onGameReleased(gameProj)
	local subEvents = gameProj:getPerformedSubEvents()
	
	for key, data in ipairs(self.onGameRelease) do
		if not subEvents[data.id] then
			data:onGameReleased(gameProj)
		end
	end
end

local wordOfMouth = {
	maxRating = 10,
	minRating = 8,
	id = "word_of_mouth",
	chance = {
		75,
		100
	},
	ratingBoost = {
		3000,
		7000
	},
	reputationBoost = {
		boost = 2000,
		base = 0.5,
		every = 10000
	}
}

wordOfMouth.ratingDelta = wordOfMouth.maxRating - wordOfMouth.minRating

function wordOfMouth:getRatingDelta(project)
	local rating = project:getRealRating()
	local dt = rating - self.minRating
	
	if dt > 0 then
		return dt / self.ratingDelta
	end
	
	return -1
end

function wordOfMouth:onRatingChanged(project)
	local dt = self:getRatingDelta(project)
	local chance = self.chance
	
	if dt > 0 and math.random(1, 100) <= math.lerp(chance[1], chance[2], dt) then
		project:markSubEvent(self)
		self:setupEvent(project)
	end
end

function wordOfMouth:setupEvent(project)
	local event = scheduledEvents:instantiateEvent("word_of_mouth")
	
	event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
	event:setProject(project)
end

function wordOfMouth:perform(project)
	local dt = self:getRatingDelta(project)
	
	if dt > 0 then
		local repBoost = self.reputationBoost
		local ratingBoost = self.ratingBoost
		local owner = project:getOwner()
		local popChange = math.lerp(ratingBoost[1], ratingBoost[2], dt) + owner:getReputation() / repBoost.every * repBoost.boost * (repBoost.base + (1 - repBoost.base) * dt)
		local repGain, popGain = project:increasePopularity(popChange)
		
		if owner:isPlayer() and popGain > 0 then
			local popup = gui.create("DescboxPopup")
			
			popup:setWidth(500)
			popup:setFont("pix24")
			popup:setTitle(_T("WORD_OF_MOUTH_TITLE", "Word of Mouth"))
			popup:setTextFont("pix20")
			popup:setText(_format(_T("WORD_OF_MOUTH_DESC", "Your 'GAME' game is so good that people can't stop talking about it! The word of your game is spreading through people talking about it so much that you can expect the game sales to improve!"), "GAME", project:getName()))
			popup:setShowSound("good_jingle")
			
			local left, right, extra = popup:getDescboxes()
			
			extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
			extra:addText(project:formatPopularityBonusText(popGain), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, popup.rawW - 25, "star", 24, 24)
			popup:addOKButton("pix20")
			popup:center()
			frameController:push(popup)
		end
	end
end

subEvents:registerNew(wordOfMouth)

local gunNutEnthusiasm = {
	targetKnowledge = "firearms",
	popBoost = 5,
	id = "gun_nut_enthusiasm",
	minKnowledge = 200,
	occurTime = timeline.DAYS_IN_WEEK,
	occurTitle = _T("GUN_NUT_ENTHUSIASM_TITLE", "Gun Nut Enthusiasm"),
	occurText = _T("GUN_NUT_ENTHUSIASM_DESCRIPTION", "Your 'GAME' is highly rated by people interested in firearms due to the high accuracy it portrays when it comes to rifles, pistols, and all sorts of guns!")
}

function gunNutEnthusiasm:calculateKnowledge(proj)
	local knowBoost = proj:getKnowledgeQuality()
	local total = 0
	
	if knowBoost then
		local map = knowBoost[self.targetKnowledge]
		
		if map then
			for quality, knowContr in pairs(map) do
				total = total + knowContr
			end
		end
	end
	
	return total / proj:getScale()
end

function gunNutEnthusiasm:onGameReleased(project)
	local total = self:calculateKnowledge(project)
	
	if total >= self.minKnowledge then
		self:setupEvent(project)
	end
end

function gunNutEnthusiasm:calculatePopularityGain(project)
	local total = self:calculateKnowledge(project)
	
	if total >= self.minKnowledge then
		return total * self.popBoost
	end
	
	return 0
end

function gunNutEnthusiasm:setupEvent(project)
	local event = scheduledEvents:instantiateEvent("generic_knowledge_popularity_boost")
	
	event:setActivationDate(math.floor(timeline.curTime + self.occurTime))
	event:setProject(project)
	event:setSubEvent(self)
end

function gunNutEnthusiasm:getTitle(project)
	return self.occurTitle
end

function gunNutEnthusiasm:getText(project)
	return _format(self.occurText, "GAME", project:getName())
end

function gunNutEnthusiasm:perform(project)
	local popChange = self:calculatePopularityGain(project)
	
	if popChange > 0 then
		local repGain, popGain = project:increasePopularity(popChange)
		
		if project:getOwner():isPlayer() and popGain > 0 then
			local popup = gui.create("DescboxPopup")
			
			popup:setWidth(500)
			popup:setFont("pix24")
			popup:setTitle(self:getTitle(project))
			popup:setTextFont("pix20")
			popup:setText(self:getText(project))
			popup:setShowSound("good_jingle")
			
			local left, right, extra = popup:getDescboxes()
			
			extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
			extra:addText(project:formatPopularityBonusText(popGain), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, popup.rawW - 25, "star", 24, 24)
			popup:addOKButton("pix20")
			popup:center()
			frameController:push(popup)
		end
	end
end

subEvents:registerNew(gunNutEnthusiasm)
subEvents:registerNew({
	targetKnowledge = "machine_learning",
	popBoost = 5,
	id = "ai_bonanza",
	minKnowledge = 300,
	occurTime = timeline.DAYS_IN_WEEK,
	occurTitle = _T("ARTIFICIAL_INTELLIGENCE_BONANZA_TITLE", "AI Bonanza"),
	occurText = _T("ARTIFICIAL_INTELLIGENCE_BONANZA_DESC", "Gamers are praising the artificial intelligence of 'GAME' and are amazed at how adaptive, and human-like the AI is thanks to the use of machine learning!")
}, "gun_nut_enthusiasm")
subEvents:registerNew({
	targetKnowledge = "photography",
	popBoost = 5,
	id = "breathtaking_photorealism",
	minKnowledge = 300,
	occurTime = timeline.DAYS_IN_WEEK,
	occurTitle = _T("BREATHTAKING_PHOTOREALISM_TITLE", "Breathtaking Photorealism"),
	occurText = _T("BREATHTAKING_PHOTOREALISM_DESC", "The visuals in 'GAME' don't fail to impress people playing it, all thanks to a ton of high-quality reference material provided by employees interested in Photography!")
}, "gun_nut_enthusiasm")
subEvents:registerNew({
	targetKnowledge = "stylizing",
	popBoost = 5,
	id = "aging_like_wine",
	minKnowledge = 300,
	occurTime = timeline.DAYS_IN_WEEK,
	occurTitle = _T("AGING_LIKE_WINE_TITLE", "Aging like Wine"),
	occurText = _T("AGING_LIKE_WINE_DESC", "People that are playing 'GAME' are amazed by how good the art style is! It will definitely age like fine wine, and look good for years to come regardless of the technology advancements.")
}, "gun_nut_enthusiasm")
