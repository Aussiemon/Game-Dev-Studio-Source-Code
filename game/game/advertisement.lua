advertisement = {}
advertisement.registered = {}
advertisement.registeredByID = {}
advertisement.WHITE = color(255, 255, 255, 255)
advertisement.EVENTS = {
	STARTED_ADVERTISEMENT = events:new(),
	FINISHED_ADVERTISEMENT = events:new()
}

local baseAdvertFuncs = {}

baseAdvertFuncs.mtindex = {
	__index = baseAdvertFuncs
}

function baseAdvertFuncs:onSelected(gameProj)
	return true
end

function baseAdvertFuncs:canSelect(gameProj)
	return true
end

function baseAdvertFuncs:handleEvent(gameProj, event)
end

function baseAdvertFuncs:fillInteractionComboBox(comboBox, gameProj)
end

function baseAdvertFuncs:setupDescbox(gameProj, descBox, wrapWidth)
end

function baseAdvertFuncs:isAvailable(gameProj)
	return true
end

function baseAdvertFuncs:postRelease(gameProj, amount)
end

function baseAdvertFuncs:onOffMarket(gameProj)
end

function baseAdvertFuncs:onLoad(gameProj)
end

function baseAdvertFuncs:onScrapped(gameProj)
end

function advertisement:registerNew(data)
	table.insert(self.registered, data)
	
	self.registeredByID[data.id] = data
	
	for key, descData in ipairs(data.description) do
		descData.font = descData.font or "pix20"
		descData.color = descData.color or self.WHITE
		descData.lineSpace = descData.lineSpace or 0
	end
	
	setmetatable(data, baseAdvertFuncs.mtindex)
end

function advertisement:handleEvent(gameProj, ...)
	for key, data in ipairs(advertisement.registered) do
		data:handleEvent(gameProj, ...)
	end
end

function advertisement:fillInteractionComboBox(comboBox)
end

function advertisement:getData(id)
	return advertisement.registeredByID[id]
end

local bribe = {}

bribe.id = "bribe"
bribe.icon = "advert_bribe_reviewer"
bribe.display = _T("BRIBE_REVIEWER", "Bribe reviewer")
bribe.description = {
	{
		font = "pix24",
		text = _T("BRIBE_DESC_1", "Bribe a reviewer to get a higher score on release.")
	},
	{
		font = "pix20",
		text = _T("BRIBE_DESC_2", "Very risky, but at the same time can give you an extra bit of sales at the release of a game title due to a higher score.")
	}
}
bribe.acceptChance = 65
bribe.revealChance = 5
bribe.pointBelowGeneralScoreMultiplier = 0.2
bribe.basePointDifferenceAmount = 1
bribe.popularityExponent = 1.4
bribe.popularityLossFromRevealation = 1.5
bribe.baseRepLoss = 500
bribe.baseRepLossMultiplier = 1
bribe.increasedRepLossMultiplier = 3
bribe.refusedFact = "refused_bribe"
bribe.refusedRevealedFact = "refused_reveal_bribe"
bribe.maxDamageControlRepLoss = -1000
bribe.baseDamageControlRepRegain = 300
bribe.damageControlRegainLossPerBribeReveal = 150
bribe.maxInvolvementRepMult = 0.15
bribe.involvementMultPerDay = 0.01
bribe.maximumRepRegain = 0.9
bribe.minimumBribe = 1000
bribe.maximumBribe = 15000
bribe.opinionLossPerBribeReveal = 20
bribe.INCREASED_BRIBE_REP_LOSS_UNLOCK = "increased_bribe_rep_loss"
bribe.EVENTS = {
	BRIBE_SIZE_CHANGED = events:new()
}

function bribe:performReputationLoss(gameProj)
	local popularity = gameProj:getPopularity()
	local avgScore = gameProj:getReviewRating()
	local generalScore = review:getCurrentGameVerdict(gameProj)
	local revealedBribeCount = studio:getFact("revealed_bribes")
	local delta = generalScore - avgScore
	local totalLoss = self.baseRepLoss
	local extraMultiplier = unlocks:isAvailable(bribe.INCREASED_BRIBE_REP_LOSS_UNLOCK) and bribe.increasedRepLossMultiplier or bribe.baseRepLossMultiplier
	
	if delta >= self.basePointDifferenceAmount then
		local mult = 1 + self.pointBelowGeneralScoreMultiplier * delta
		local popularityLoss = popularity^self.popularityExponent
		
		totalLoss = (totalLoss + popularityLoss) * mult
	end
	
	totalLoss = totalLoss * extraMultiplier
	
	if revealedBribeCount > 0 then
		totalLoss = totalLoss * revealedBribeCount^self.popularityLossFromRevealation
	end
	
	totalLoss = math.round(totalLoss)
	
	studio:decreaseReputation(totalLoss)
	
	return totalLoss
end

function bribe:canSelect(gameProj)
	return not gameProj:getReleaseDate()
end

local function onChangeBribeSize(self, newValue)
	self.confirmBribeButton:setBribeSize(newValue)
end

function bribe:offerBribe(target, amount, gameProject)
	gameProject:addAdvertisement(self.id)
	
	if target:offerBribe(amount, gameProject) then
		target:setBribeChancesRevealed(true)
		events:fire(advertisement.EVENTS.FINISHED_ADVERTISEMENT, gameProject, self.id)
		
		return true
	end
	
	return false
end

function bribe:onSelected(gameProj)
	local frame = gui.create("Frame")
	
	frame:setSize(430, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setText(_T("SELECT_BRIBE_TARGET", "Select bribe target"))
	
	local confirmBribeButton = gui.create("BribeConfirmButton", frame)
	
	confirmBribeButton:setPos(_S(5), _S(570))
	confirmBribeButton:setSize(420, 25)
	confirmBribeButton:setProject(gameProj)
	
	local bribeSizeSlider = gui.create("BribeSizeSlider", frame)
	
	bribeSizeSlider:setPos(_S(5), _S(535))
	bribeSizeSlider:setSize(420, 32)
	bribeSizeSlider:setFont("pix20")
	bribeSizeSlider:setBaseText(_T("BRIBE_SIZE", "Bribe size: $SLIDER_VALUE"))
	bribeSizeSlider:setConfirmationButton(confirmBribeButton)
	bribeSizeSlider:setMin(self.minimumBribe)
	bribeSizeSlider:setMax(self.maximumBribe)
	bribeSizeSlider:setSegmentRound(100)
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setSize(420, 500)
	scrollbar:setPos(_S(5), _S(30))
	scrollbar:setPadding(4, 4)
	scrollbar:setSpacing(4)
	scrollbar:setAdjustElementPosition(true)
	
	local title = gui.create("Category")
	
	title:setFont(fonts.get("pix24"))
	title:setText(_T("SELECT_BRIBE_TARGET", "Select bribe target"))
	title:setHeight(25)
	scrollbar:addItem(title)
	
	for key, reviewerObj in ipairs(review:getReviewers()) do
		if reviewerObj:canOfferBribeTo(gameProj) then
			local reviewerElement = gui.create("BribeReviewerSelectionButton")
			
			reviewerElement:setWidth(400)
			reviewerElement:setConfirmationButton(confirmBribeButton)
			reviewerElement:setReviewer(reviewerObj)
			reviewerElement:setProject(gameProj)
			reviewerElement:addComboBoxOption("bribe")
			scrollbar:addItem(reviewerElement)
		end
	end
	
	frame:center()
	frameController:push(frame)
end

function bribe:getFittingWeight(employee, gameProj)
	return self:getDamageControlEfficiency(gameProj, employee)
end

function bribe:getDamageControlEfficiency(gameProj, employee, skipInvolvement)
	local total = 0
	local daysInvolved = employee:getProjectInvolvement(gameProj)
	local involvementAffector = 0
	
	if daysInvolved > 0 and not skipInvolvement then
		involvementAffector = math.min(daysInvolved * self.involvementMultPerDay, self.maxInvolvementRepMult)
		total = total + involvementAffector
	end
	
	local charismaAffector = attributes:getData("charisma"):getDamageControlEfficiencyMultiplier(employee)
	
	total = total + charismaAffector
	
	local traitAffector = 0
	
	for key, trait in ipairs(employee:getTraits()) do
		local traitData = traits:getData(trait)
		
		if traitData.damageControlEfficiencyMultiplier then
			total = total + traitData.damageControlEfficiencyMultiplier
			traitAffector = traitAffector + traitData.damageControlEfficiencyMultiplier
		end
	end
	
	return total, involvementAffector, charismaAffector, traitAffector
end

local function damageControlCallback(self)
	self.bribeData:performDamageControl(self.gameProject, self.lostReputation)
end

local function assignManagerCallback(self)
	self.bribeData:performManagerDamageControl(self.gameProject, self.gameProject:getTeam():getManager())
end

function bribe:performDamageControl(gameProj, lostReputation)
	local revealedBribes = studio:getFact("revealed_bribes") - 1
	local bribeRevealRepDecrease = revealedBribes * self.damageControlRegainLossPerBribeReveal
	local owner = gameProj:getOwner()
	local regain = self:getFinalDamageControlEfficiency(gameProj, owner:getPlayerCharacter(), true) - bribeRevealRepDecrease
	local highestEfficiency, bestManager = -math.huge
	local managerCount = 0
	
	for key, teamObj in ipairs(owner:getTeams()) do
		local manager = teamObj:getManager()
		
		if manager then
			managerCount = managerCount + 1
			
			local managerEfficiency = self:getFinalDamageControlEfficiency(gameProj, manager) - bribeRevealRepDecrease
			
			if highestEfficiency < managerEfficiency then
				highestEfficiency = managerEfficiency
				bestManager = manager
			end
		end
	end
	
	local change = math.min(lostReputation * self.maximumRepRegain, math.max(regain, highestEfficiency, self.maxDamageControlRepLoss))
	local preferManager = change < highestEfficiency
	
	studio:increaseReputation(change)
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("DAMAGE_CONTROL_TITLE", "Damage Control"))
	
	local baseString = _T("DAMAGE_CONTROL_RESULT_LAYOUT", "MANAGER\n\nRESULT")
	local resultText
	
	if preferManager then
		if change < 0 then
			resultText = _T("MANAGER_DAMAGE_CONTROL_DESC_LOST_REPUTATION", "The general public did not believe whatever the manager had to say.")
		else
			resultText = _format(_T("MANAGER_DAMAGE_CONTROL_DESC_REGAINED_REPUTATION", "The general public seems to have calmed down after MANAGER performed the damage control."), "MANAGER", bestManager:getFullName(true))
		end
	elseif change < 0 then
		resultText = _T("DAMAGE_CONTROL_DESC_LOST_REPUTATION", "The general public did not believe whatever you had to say.")
	else
		resultText = _T("DAMAGE_CONTROL_DESC_UNCHANGED_REPUTATION", "The general public seems to have calmed down after you performed the damage control.")
	end
	
	local managerText
	
	if managerCount > 0 then
		if regain < highestEfficiency then
			managerText = _format(_T("DAMAGE_CONTROL_LET_MANAGER_DO_IT", "You've consulted all available managers within the studio, and have decided it would be best if MANAGER took care of this."), "MANAGER", bestManager:getFullName(true))
		else
			managerText = _T("DAMAGE_CONTROL_DO_IT_YOURSELF", "You've consulted all available managers within the studio, and you all decided it would be best if you took care of this.")
		end
	else
		managerText = _T("DAMAGE_CONTROL_NO_CONSULTING_DO_IT_YOURSELF", "Since you have no managers to consult with, there isn't much you can do except to take this matter into your own hands.")
	end
	
	baseString = _format(baseString, "MANAGER", managerText, "RESULT", resultText)
	
	local extra = popup:getExtraInfoDescbox()
	local wrapWidth = popup.rawW - 30
	
	extra:addSpaceToNextText(5)
	
	if change < 0 then
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("BRIBE_REVEALED_REP_LOSS", "Lost REPUTATION reputation points"), "REPUTATION", string.roundtobignumber(math.abs(change))), "bh20", nil, 0, wrapWidth, "exclamation_point_red", 24, 24)
	elseif change > 0 then
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("BRIBE_REVEALED_REP_REGAIN", "Regained REPUTATION reputation points"), "REPUTATION", string.roundtobignumber(change)), "bh20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
	else
		extra:addText(_T("BRIBE_REVEALED_NO_REP_REGAIN", "No reputation has been regained"), "bh20", nil, 0, wrapWidth, "question_mark", 24, 24)
	end
	
	popup:setText(baseString)
	popup:addOKButton(fonts.get("pix20"))
	popup:center()
	frameController:push(popup)
end

function bribe:getFinalDamageControlEfficiency(gameProj, manager, skipInvolvement)
	if not manager then
		return nil
	end
	
	local totalRegain = self.baseDamageControlRepRegain
	local total, involvementAffector, charismaAffector, traitAffector = self:getDamageControlEfficiency(gameProj, manager, skipInvolvement)
	local randomAffector = math.round(math.randomf(0.5, 1.5), 1)
	local multiplier = 1 + total
	
	totalRegain = math.max(totalRegain * total * randomAffector, 0)
	
	return totalRegain
end

local bribeRevealingReviewers = {}

function bribe:handleEvent(gameProj, event)
	if gameProj:getReleaseDate() and event == timeline.EVENTS.NEW_WEEK then
		local validReviewers, reviewedReviewers = 0, 0
		
		for key, reviewerObj in ipairs(review:getReviewers()) do
			if reviewerObj:canReview(gameProj) then
				validReviewers = validReviewers + 1
				
				if gameProj:getReview(reviewerObj:getID()) then
					reviewedReviewers = reviewedReviewers + 1
				end
				
				if reviewerObj:shouldRevealBribe(gameProj) then
					bribeRevealingReviewers[#bribeRevealingReviewers + 1] = reviewerObj
				end
			end
		end
		
		if validReviewers <= reviewedReviewers then
			if #bribeRevealingReviewers > 0 then
				local totalReveals = 0
				local opinionLoss = 0
				local randomRevealer
				
				for key, reviewerObj in ipairs(bribeRevealingReviewers) do
					studio:revealBribe(gameProj)
					
					if not reviewerObj:getBribeChancesRevealed() then
						reviewerObj:setBribeChancesRevealed(true)
						
						totalReveals = totalReveals + 1
						opinionLoss = opinionLoss + bribe.opinionLossPerBribeReveal
						randomRevealer = reviewerObj
					end
				end
				
				self:revealBribeOffer(gameProj, bribeRevealingReviewers, totalReveals, randomRevealer)
				gameProj:getOwner():changeOpinion(-opinionLoss)
				table.clearArray(bribeRevealingReviewers)
			else
				gameProj:removeActiveAdvertisement(self.id)
			end
		end
	end
end

function bribe:revealBribeOffer(gameProj, bribeRevealers, bribeChanceRevealers, randomRevealer)
	local repLoss = self:performReputationLoss(gameProj)
	local revealedBribeCount = gameProj:getFact(gameProject.REVEALED_BRIBE_COUNT_FACT) or 0
	local frame = gui.create("DescboxPopup")
	
	frame:setWidth(500)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("BRIBE_REVEALED_TITLE", "Bribe Revealed"))
	frame:setTextFont(fonts.get("pix20"))
	frame:setShowSound("bad_jingle")
	frame:hideCloseButton()
	
	local extraDescbox = frame:getExtraInfoDescbox()
	local text
	
	if revealedBribeCount > 1 then
		text = string.easyformatbykeys(_T("SEVERAL_BRIBES_REVEALED_DESC", "Several communities we had offered bribes to have revealed our bribe offers to the general public. This has cost you REPUTATION reputation points."), "REPUTATION", string.roundtobignumber(repLoss))
	else
		text = string.easyformatbykeys(_T("BRIBE_REVEALED_DESC", "One of the communities we had offered a bribe to has revealed our bribe offer to the general public. This has cost you REPUTATION reputation points."), "REPUTATION", string.roundtobignumber(repLoss))
	end
	
	extraDescbox:addTextLine(frame.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
	extraDescbox:addText(_format(_T("BRIBE_REVEALED_REP_LOSS", "Lost REPUTATION reputation points"), "REPUTATION", string.roundtobignumber(repLoss)), "bh20", nil, 0, 470, "exclamation_point_red", 24, 24)
	
	if bribeChanceRevealers > 0 then
		extraDescbox:addSpaceToNextText(5)
		
		if bribeChanceRevealers == 1 then
			extraDescbox:addText(_format(_T("DISCOVERED_REVIEWER_BRIBE_CHANCES", "Discovered bribe accept & reveal chances for 'REVIEWER'!"), "REVIEWER", randomRevealer:getName()), "bh20", nil, 0, 470, "question_mark", 24, 24)
		else
			extraDescbox:addText(_format(_T("DISCOVERED_REVIEWERS_BRIBE_CHANCES", "Discovered bribe accept & reveal chances for REVIEWERS reviewers!"), "REVIEWERS", bribeChanceRevealers), "bh20", nil, 0, 470, "question_mark", 24, 24)
		end
	end
	
	extraDescbox:addSpaceToNextText(10)
	extraDescbox:addText(_T("BRIBE_REVEALED_YOUR_RESPONSE", "How would you like to respond?"), "pix20", nil, 0, 470)
	frame:setText(text)
	
	local doNothing = frame:addButton(fonts.get("pix20"), _T("BRIBE_REVEALED_DO_NOTHING", "Do nothing"))
	local damageControl = frame:addButton(fonts.get("pix20"), _T("BRIBE_REVEALED_DAMAGE_CONTROL", "Attempt damage control"), damageControlCallback)
	
	damageControl.bribeData = self
	damageControl.gameProject = gameProj
	damageControl.lostReputation = repLoss
	
	frame:center()
	frameController:push(frame)
	gameProj:removeActiveAdvertisement(self.id)
end

game.registerTimedPopup(bribe.INCREASED_BRIBE_REP_LOSS_UNLOCK, _T("REVIEWER_BRIBING_NOW_RISKIER", "Bribing reviewers now riskier"), _T("REVIEWER_BRIBING_NOW_RISKIER_DESC", "Before the mass commercialisation of the internet getting away with bribe revelations was easy.\nNow, with there being so many forums & various gaming websites, anyone can spread information regarding games easily, and if it's something big or isn't against the interests of gamers, then it will spread like fire.\n\nDue to that, a revealed bribe attempt will now impact your reputation a lot more than it did in the past."), "bh24", "pix20", {
	year = 2003,
	month = 2
}, nil, bribe.INCREASED_BRIBE_REP_LOSS_UNLOCK)
advertisement:registerNew(bribe)

local invite = {}

invite.id = "invite_for_interview"
invite.icon = "advert_interview"
invite.display = _T("INVITE_FOR_INTERVIEW", "Invite for interview")
invite.description = {
	{
		font = "pix24",
		text = _T("INVITE_FOR_INTERVIEW_1", "Invite a reviewer for an interview.")
	},
	{
		font = "pix20",
		text = _T("INVITE_FOR_INTERVIEW_2", "No risk involved, but it might be tricky to get an interviewer to come to you.")
	}
}

function invite:onSelected(gameProj)
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setText(_T("SELECT_INVITATION_TARGET", "Invite reviewer"))
	
	local confirmInviteButton = gui.create("ConfirmInviteButton", frame)
	
	confirmInviteButton:setPos(_S(5), _S(570))
	confirmInviteButton:setSize(390, 25)
	confirmInviteButton:setProject(gameProj)
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setSize(390, 530)
	scrollbar:setPos(_S(5), _S(30))
	scrollbar:setPadding(4, 4)
	scrollbar:setSpacing(4)
	scrollbar:addDepth(100)
	scrollbar:setAdjustElementPosition(true)
	
	if not gameProj then
		local title = gui.create("Category")
		
		title:setFont(fonts.get("pix24"))
		title:setText(_T("SELECT_GAME_PROJECT", "Select game project"))
		title:setHeight(25)
		scrollbar:addItem(title)
		
		for key, gameObj in ipairs(studio:getGames()) do
			if not gameObj:getFact(gameProject.RELEASED_GAME) then
				local gameElement = gui.create("GameSelectionButton")
				
				gameElement:setProject(gameObj)
				gameElement:setHeight(25)
				gameElement:setConfirmationButton(confirmInviteButton)
				scrollbar:addItem(gameElement)
			end
		end
	end
	
	local title = gui.create("Category")
	
	title:setFont(fonts.get("pix24"))
	title:setText(_T("SELECT_REVIEWERS", "Select reviewers"))
	title:setHeight(25)
	scrollbar:addItem(title)
	
	for key, reviewerObj in ipairs(review:getReviewers()) do
		local reviewerElement = gui.create("InterviewReviewerSelectionButton")
		
		reviewerElement:setSize(370, 25)
		reviewerElement:setConfirmationButton(confirmInviteButton)
		reviewerElement:setReviewer(reviewerObj)
		reviewerElement:setProject(gameProj)
		scrollbar:addItem(reviewerElement)
	end
	
	frame:center()
	frameController:push(frame)
end

function invite:canSelect(gameProj)
	return not gameProj:getReleaseDate()
end

advertisement:registerNew(invite)

local campaign = {}

campaign.icon = "advert_mass_advert"
campaign.id = "mass_advertisement"
campaign.display = _T("ADVERTISEMENT_MASS_ADVERTISEMENT", "Mass advertisement")
campaign.dataFact = "campaign_data"
campaign.campaignDuration = timeline.DAYS_IN_WEEK * timeline.WEEKS_IN_MONTH
campaign.maxEvents = campaign.campaignDuration * 0.5
campaign.maxDelayBetweenEvent = 5
campaign.description = {
	{
		font = "pix24",
		text = _T("CAMPAIGN_DESC_1", "Begin an advertisement campaign of a specific scale.")
	},
	{
		font = "pix20",
		text = _T("CAMPAIGN_DESC_2", "No risk involved, can amass popularity for a specific game project.")
	},
	{
		font = "pix20",
		text = _T("CAMPAIGN_DESC_3", "Usually a good idea to begin a campaign after the game was in development for a specific amount time.")
	}
}
campaign.additionalAdvertOptionsByID = {}
campaign.additionalAdvertOptions = {}
campaign.revealEfficiencyChance = 25
campaign.revealEffiecincyChancePerAdvertisement = 10
campaign.revealedAdvertisementsFact = "revealed_advertisements"
campaign.maxRepGainPerAdvertType = 400
campaign.noRepGainCutoff = 20000
campaign.minProjectCompletion = 0.4
campaign.lowCompletionPenalty = 0.7
campaign.marketingSpecBoost = 1.2
campaign.minimumFamiliarity = 0.8
campaign.minBudget = 0.5
campaign.maxBudget = 1
campaign.minRounds = 1
campaign.maxRounds = 5
campaign.EVENTS = {
	BUDGET_CHANGED = events:new(),
	ROUNDS_CHANGED = events:new()
}
campaign.resultText = {
	{
		amount = 0,
		text = _T("ADVERT_RESULT_FAILURE", "The campaign was a complete failure, noone even knew it happened.")
	},
	{
		amount = 1000,
		text = _T("ADVERT_RESULT_TINY", "The campaign has raised only a tiny amount of interest towards the game.")
	},
	{
		amount = 5000,
		text = _T("ADVERT_RESULT_SMALL", "The campaign has raised a small amount of interest towards the game.")
	},
	{
		amount = 12000,
		text = _T("ADVERT_RESULT_MODERATE", "The campaign has raised a moderate amount of interest towards the game.")
	},
	{
		amount = 30000,
		text = _T("ADVERT_RESULT_HIGH", "The campaign was well-received, and as a result, the game has gained a high amount of interest.")
	},
	{
		amount = 80000,
		text = _T("ADVERT_RESULT_VERY_HIGH", "The campaign was a big success, and a very high amount of people have become interested in it.")
	},
	{
		amount = 150000,
		text = _T("ADVERT_RESULT_INSANE", "The campaign was an insane success, a huge amount of people have taken interest in it.")
	}
}

function campaign:registerAdvertOption(data)
	table.insert(campaign.additionalAdvertOptions, data)
	
	campaign.additionalAdvertOptionsByID[data.id] = data
end

function campaign:canSelect(gameProj)
	local data = gameProj:getFact(self.dataFact)
	
	if not data then
		return true
	end
	
	if timeline.curTime < data.lastsUntil then
		return false
	end
	
	return true
end

function campaign:applyCampaignDataToGame(gameProj, advertTypes, totalCost, budgetPercentage, rounds)
	local data = {
		totalPopularityGained = 0,
		totalReputationGained = 0,
		startedOn = timeline.curTime,
		lastsUntil = timeline.curTime + self.campaignDuration * rounds,
		lastCampaignEvent = timeline.curTime,
		advertTypeAmount = #advertTypes,
		moneySpent = totalCost,
		advertTypes = advertTypes,
		allAdvertTypes = table.copy(advertTypes),
		budgetPercentage = budgetPercentage,
		totalRounds = rounds,
		rounds = rounds,
		performedAdvertTypes = {}
	}
	
	gameProj:setFact(self.dataFact, data)
	gameProj:addAdvertisement(self.id)
end

function campaign:abort(gameProj)
	self:finishCampaign(gameProj, true, true)
end

function campaign:stopMassAdvertOption()
	campaign:abort(self.project)
end

function campaign:fillInteractionComboBox(comboBox, gameProj)
	if gameProj:getFact(self.dataFact) then
		local option = comboBox:addOption(0, 0, 0, 0, _T("CANCEL_ADVERTISEMENT", "Stop mass advertisement"), fonts.get("pix20"), campaign.stopMassAdvertOption)
		
		option.project = gameProj
	end
end

local unrevealedAdvertTypes = {}

function campaign:removeAdvertData(gameProj)
	gameProj:setFact(self.dataFact, nil)
	gameProj:removeActiveAdvertisement(self.id)
end

function campaign:finishCampaign(gameProj, suppressEfficiencyReveal, wasAborted)
	if not gameProj:getOwner():isPlayer() then
		self:removeAdvertData(gameProj)
		
		return 
	end
	
	local data = gameProj:getFact(self.dataFact)
	local amountOfAdvertisements = 0
	local totalPop = data.totalPopularityGained
	
	for advertType, amount in pairs(data.performedAdvertTypes) do
		amountOfAdvertisements = amountOfAdvertisements + 1
	end
	
	local randomRevealedAdvertType
	
	if not suppressEfficiencyReveal and math.random(1, 100) <= self.revealEfficiencyChance + amountOfAdvertisements * self.revealEffiecincyChancePerAdvertisement then
		local revealedAdvertTypes = studio:getFact(campaign.revealedAdvertisementsFact) or {}
		
		for advertType, amount in pairs(data.performedAdvertTypes) do
			if not revealedAdvertTypes[advertType] then
				unrevealedAdvertTypes[#unrevealedAdvertTypes + 1] = advertType
			end
		end
		
		if #unrevealedAdvertTypes > 0 then
			randomRevealedAdvertType = unrevealedAdvertTypes[math.random(1, #unrevealedAdvertTypes)]
			revealedAdvertTypes[randomRevealedAdvertType] = true
			
			table.clear(unrevealedAdvertTypes)
		end
		
		studio:setFact(campaign.revealedAdvertisementsFact, revealedAdvertTypes)
	end
	
	local highest = -math.huge
	local fitting
	
	for key, data in ipairs(self.resultText) do
		if totalPop >= data.amount and highest < data.amount then
			highest = data.amount
			fitting = data
		end
	end
	
	local displayText = fitting.text
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("ADVERT_RESULT_TITLE", "Mass Advert Result"))
	popup:setText(displayText)
	
	local leftBox, rightBox, extra = popup:getDescboxes()
	
	leftBox:addSpaceToNextText(10)
	rightBox:addSpaceToNextText(10)
	
	local wrapWidth = popup.rawW - 10
	
	leftBox:addText(_format(_T("MASS_ADVERT_POPULARITY_GAINED", "Popularity gained: POPULARITY"), "POPULARITY", string.roundtobignumber(totalPop)), "bh22", nil, 0, wrapWidth, "star", 26, 26)
	leftBox:addText(_format(_T("MASS_ADVERT_REPUTATION_GAINED", "Reputation gained: REP pts."), "REP", string.roundtobignumber(data.totalReputationGained)), "bh22", nil, 0, wrapWidth, "star", 26, 26)
	rightBox:addText(_format(_T("MASS_ADVERT_MONEY_SPENT", "Money spent: MONEY"), "MONEY", string.roundtobigcashnumber(data.moneySpent or 0)), "bh22", nil, 0, wrapWidth, {
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
	rightBox:addText(_format(_T("MASS_ADVERT_COMPLETED_IN", "Completed in TIME"), "TIME", timeline:getTimePeriodText(timeline.curTime - data.startedOn)), "bh22", nil, 0, wrapWidth, {
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
	
	local spacingAdded = false
	
	if randomRevealedAdvertType then
		extra:addSpaceToNextText(4)
		
		spacingAdded = true
		
		extra:addText(_format(_T("DISCOVERED_CAMPAIGN_TYPE_EFFICIENCY", "Discovered efficiency of ADVERT!"), "ADVERT", campaign.additionalAdvertOptionsByID[randomRevealedAdvertType].display), "pix20", nil, 0, wrapWidth, "exclamation_point", 24, 24)
	end
	
	if wasAborted then
		extra:addSpaceToNextText(4)
		extra:addText(_T("ABORTED_ADVERTISEMENT_INFORM", "The campaign has been aborted. No efficiency info will be revealed and maximum campaign efficiency has not been reached."), "pix20", nil, 0, wrapWidth, "question_mark", 24, 24)
	end
	
	if data.marketingBoost then
		extra:addText(_T("MASS_ADVERT_MARKETING_BOOST", "Increased efficiency due to Marketing specialist."), "bh22", nil, 0, wrapWidth, "exclamation_point", 24, 24)
	end
	
	if data.sufferedPenalty then
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.UI_PENALTY_LINE)
		extra:addText(_T("MASS_ADVERT_EFFICIENCY_SUFFERED", "Lower efficiency due to early stages of development."), "bh22", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
	end
	
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"))
	popup:center()
	frameController:push(popup)
	self:removeAdvertData(gameProj)
	events:fire(advertisement.EVENTS.FINISHED_ADVERTISEMENT, gameProj, self.id)
end

eventBoxText:registerNew({
	id = "mass_advert_performed",
	getText = function(self, data)
		return _format(_T("PERFORMED_MASS_ADVERT_TYPE", "'TYPE' advertisement performed. 'PROJECT' has gained POPULARITY Hype points."), "TYPE", campaign.additionalAdvertOptionsByID[data.advertID].display, "PROJECT", data.game, "POPULARITY", string.roundtobignumber(data.popGain))
	end
})

function campaign:getAdvertDelay(advertAmount)
	return math.max(math.floor(math.min(self.campaignDuration / advertAmount, self.maxDelayBetweenEvent)), 1)
end

function campaign:getDuration(adCount, rounds)
	return rounds * adCount * self:getAdvertDelay(adCount)
end

function campaign:getDurationText(adCount, rounds)
	return timeline:getTimePeriodText(self:getDuration(adCount, rounds))
end

function campaign:getPopularityGain(advertData, budgetPercentage, rounds)
	local value
	
	if advertData.getPopularityGain then
		value = advertData:getPopularityGain(advertData)
	else
		value = advertData.popularityGain
	end
	
	return math.round(value * budgetPercentage * rounds)
end

function campaign:handleEvent(gameProj, event)
	if event == timeline.EVENTS.NEW_DAY then
		local data = gameProj:getFact(self.dataFact)
		
		if data then
			local curTime = timeline.curTime
			local delta = self:getAdvertDelay(data.advertTypeAmount)
			local timeUntil = curTime - (data.lastCampaignEvent + delta)
			
			if timeUntil >= 0 then
				local totalOwners = platformShare:getPlatformUsers()
				local projCompletion = gameProj:getOverallCompletion()
				local multiplier = 1
				local team = gameProj:getTeam()
				
				if team then
					local marketers = team:getMembersBySpecialization("marketing")
					local ourID = gameProj:getUniqueID()
					
					for key, dev in ipairs(marketers) do
						if dev:getFamiliarityAffector(ourID) >= self.minimumFamiliarity then
							multiplier = multiplier * self.marketingSpecBoost
							data.marketingBoost = true
							
							break
						end
					end
				end
				
				if projCompletion < self.minProjectCompletion then
					multiplier = multiplier * self.lowCompletionPenalty
					data.sufferedPenalty = true
				end
				
				if #data.advertTypes > 0 then
					local advertType = table.remove(data.advertTypes, math.random(1, #data.advertTypes))
					local advertData = self.additionalAdvertOptionsByID[advertType]
					local maxPopGain = math.max(totalOwners - data.totalPopularityGained, 0)
					local basePopGain, gainedReputation, realPopGain = advertData:perform(gameProj, multiplier * (data.budgetPercentage or 1), maxPopGain)
					
					data.performedAdvertTypes[advertType] = realPopGain
					data.totalPopularityGained = data.totalPopularityGained + realPopGain
					data.totalReputationGained = data.totalReputationGained + gainedReputation
					data.lastCampaignEvent = curTime
					
					if gameProj:getOwner():isPlayer() then
						game.addToEventBox("mass_advert_performed", {
							advertID = advertType,
							game = gameProj:getName(),
							popGain = realPopGain
						}, 1)
					end
				end
				
				if #data.advertTypes == 0 then
					if not data.rounds or data.rounds == 0 then
						self:finishCampaign(gameProj)
					else
						data.rounds = data.rounds - 1
						
						if data.rounds == 0 then
							self:finishCampaign(gameProj)
						else
							self:fillAdvertTable(data)
						end
					end
				end
			end
		end
	end
end

function campaign:fillAdvertTable(data)
	for key, type in ipairs(data.allAdvertTypes) do
		data.advertTypes[key] = type
	end
end

function campaign:canHaveAdvertOption(optionData)
	if optionData.unlockRequired then
		return unlocks:isAvailable(optionData.unlockRequired)
	end
	
	return true
end

function campaign:onSelected(gameProj)
	local frame = gui.create("Frame")
	
	frame:setSize(400, 570)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("SELECT_ADVERT_TYPES_TITLE", "Select Advertisement"))
	
	local scrollBarPanel = gui.create("ScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(5), _S(30))
	scrollBarPanel:setSize(390, 455)
	scrollBarPanel:setSpacing(4)
	scrollBarPanel:setPadding(4, 4)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:addDepth(50)
	
	local costDisplay = gui.create("CostDisplay", frame)
	
	costDisplay:setSize(220, 27)
	costDisplay:setPos(_S(5), frame.h - _S(5) - costDisplay.h)
	costDisplay:setFont("pix24")
	
	local confirmButton = gui.create("ConfirmMassAdvertButton", frame)
	
	confirmButton:setSize(165, costDisplay.rawH)
	confirmButton:setFont("pix24")
	confirmButton:setPos(frame.w - _S(5) - confirmButton.w, costDisplay.y)
	confirmButton:setProject(gameProj)
	confirmButton:setCostDisplay(costDisplay)
	
	local budgetSlider = gui.create("MassAdvertBudgetSlider", frame)
	
	budgetSlider:setConfirmationButton(confirmButton)
	budgetSlider:setSize(200, 40)
	budgetSlider:setPos(scrollBarPanel.localX, scrollBarPanel.localY + scrollBarPanel.h + _S(5))
	budgetSlider:setFont("bh22")
	budgetSlider:setText(_T("MASS_ADVERT_SLIDER_PERCENTAGE", "Campaign budget: SLIDER_VALUE%"))
	budgetSlider:setMinMax(self.minBudget, self.maxBudget)
	budgetSlider:setValue(1)
	
	local roundSlider = gui.create("MassAdvertRoundSlider", frame)
	
	roundSlider:setConfirmationButton(confirmButton)
	roundSlider:setSize(180, 40)
	roundSlider:setPos(budgetSlider.localX + budgetSlider.w + _S(5), budgetSlider.localY)
	roundSlider:setFont("bh22")
	roundSlider:setText(_T("MASS_ADVERT_ROUNDS_SLIDER", "Rounds: SLIDER_VALUE"))
	roundSlider:setMinMax(self.minRounds, self.maxRounds)
	roundSlider:setValue(self.minRounds)
	roundSlider:setSliderGap(self.maxRounds, 4)
	
	for key, option in ipairs(self.additionalAdvertOptions) do
		if self:canHaveAdvertOption(option) then
			local element = gui.create("MassAdvertSelection")
			
			element:setSize(370, 95)
			element:setOption(option)
			element:setConfirmationButton(confirmButton)
			scrollBarPanel:addItem(element)
		end
	end
	
	frame:center()
	
	local dbox = gui.create("MassAdvertInfoDescbox")
	
	dbox:setPos(frame.x + frame.w + _S(5), frame.y)
	dbox:tieVisibilityTo(frame)
	confirmButton:setDescbox(dbox)
	frameController:push(frame)
end

function campaign:getReputationGainScaler(owner)
	local rep = studio:getReputation()
	local cutoff = self.noRepGainCutoff
	
	if cutoff <= rep then
		return 0
	end
	
	return (1 - rep / cutoff) * gameProject.DEFAULT_POPULARITY_TO_REPUTATION_MULT
end

campaign:registerAdvertOption({
	cost = 500000,
	unlockRequired = "cgi_trailer",
	minimalHypePrevGameScore = 5,
	repToPopularity = 0.1,
	prevGameScoreBoost = 7,
	popularityGain = 14500,
	hypeIncreasePerDelta = 0.05,
	hypeDecreasePerDelta = 0.15,
	uiIcon = "advert_cgi_trailer",
	id = "cgi_trailer",
	display = _T("CGI_TRAILER", "CGI trailer"),
	description = _T("ADVERT_CGI_TRAILER", "Hire an outside studio to create a CGI trailer.\nSequels benefit most from this advertisement type."),
	perform = function(self, gameProj, multiplier, maxPopGain)
		local owner = gameProj:getOwner()
		local sequel = gameProj:getSequelTo()
		local basePopGain = owner:getReputation() * self.repToPopularity + self.popularityGain
		
		if sequel then
			local prevGame = owner:getGameByUniqueID(sequel:getUniqueID())
			
			if prevGame then
				local avgScore = sequel:getReviewRating()
				local minHype = self.minimalHypePrevGameScore
				local minBoost = self.prevGameScoreBoost
				
				if avgScore <= minHype then
					local delta = minHype - avgScore
					
					basePopGain = basePopGain * (delta * self.hypeDecreasePerDelta)
				elseif minBoost <= avgScore then
					local delta = avgScore - minBoost
					
					basePopGain = basePopGain * (delta * self.hypeIncreasePerDelta)
				end
			end
		end
		
		basePopGain = basePopGain * multiplier
		basePopGain = math.min(basePopGain, maxPopGain)
		
		local scaler = campaign:getReputationGainScaler(owner)
		local repGain, realPopGain = gameProj:increasePopularity(basePopGain, scaler > 0 and scaler, campaign.maxRepGainPerAdvertType)
		
		return basePopGain, repGain, realPopGain
	end
})
campaign:registerAdvertOption({
	cost = 35000,
	uiIcon = "advert_gameplay_trailer",
	popGainRating = 7000,
	repToPopularity = 0.005,
	ratingIssueAffector = 0.1,
	popularityGain = 1000,
	id = "gameplay_trailer",
	display = _T("ADVERT_GAMEPLAY_TRAILER", "Gameplay trailer"),
	description = _T("ADVERT_GAMEPLAY_TRAILER_DESC", "Hire an editor to create a gameplay trailer out of game footage.\nThe results of this advertisement type depend heavily on the quality of the game."),
	ratingPopGainLog = math.log(8000, 10),
	getPopularityGain = function(self, gameProj)
		return self.popularityGain + self.popGainRating
	end,
	perform = function(self, gameProj, multiplier, maxPopGain)
		local basePopGain = (gameProj:getOwner():getReputation() * self.repToPopularity + self.popularityGain + review:getCurrentGameVerdict(gameProj, self.ratingIssueAffector)^self.ratingPopGainLog) * multiplier
		
		basePopGain = math.min(basePopGain, maxPopGain)
		
		local owner = gameProj:getOwner()
		local scaler = campaign:getReputationGainScaler(owner)
		local repGain, realPopGain = gameProj:increasePopularity(basePopGain, scaler > 0 and scaler, campaign.maxRepGainPerAdvertType)
		
		return basePopGain, repGain, realPopGain
	end
})
game.registerTimedPopup("unlock_cgi_trailer", _T("NEW_MASS_ADVERTISEMENT_TYPE", "New mass advert type"), _T("CGI_TRAILER_UNLOCKED", "Computer-generated imagery has become somewhat popular in the mainstream media, and the video game industry is no stranger to this technology.\n\nWhen starting a mass advertisement campaign you can now select the CGI trailer option."), "pix24", "pix20", {
	year = 1993,
	month = 1
}, nil, "cgi_trailer")
campaign:registerAdvertOption({
	cost = 100000,
	unlockRequired = "ads_on_websites",
	uiIcon = "advert_ads_on_websites",
	repToPopularity = 0.05,
	popularityGain = 6000,
	id = "ads_on_websites",
	display = _T("ADS_ON_WEBSITES", "Ads on websites"),
	description = _T("ADVERT_ADS_ON_WEBSITES", "Advertise the game on various gaming sites."),
	perform = function(self, gameProj, multiplier, maxPopGain)
		local basePopGain = (gameProj:getOwner():getReputation() * self.repToPopularity + self.popularityGain) * multiplier
		
		basePopGain = math.min(basePopGain, maxPopGain)
		
		local owner = gameProj:getOwner()
		local scaler = campaign:getReputationGainScaler(owner)
		local repGain, realPopGain = gameProj:increasePopularity(basePopGain, scaler > 0 and scaler, campaign.maxRepGainPerAdvertType)
		
		return basePopGain, repGain, realPopGain
	end
})
game.registerTimedPopup("unlock_ads_on_websites", _T("NEW_MASS_ADVERTISEMENT_TYPE", "New mass advert type"), _T("ADS_ON_WEBSITES_UNLOCKED", "The internet has become very widespread in the general public and with the rise of game industry popularity, and profitability, it has become a welcome place for advertising games.\n\nWhen starting a mass advertisement campaign you can now select the Ads on websites option."), "pix24", "pix20", {
	year = 1996,
	month = 1
}, nil, "ads_on_websites")
campaign:registerAdvertOption({
	cost = 400000,
	uiIcon = "advert_tv_ads",
	id = "tv_ad",
	repToPopularity = 0.1,
	popularityGain = 15000,
	display = _T("TV_AD", "TV advertisement"),
	description = _T("ADVERT_TV_AD", "Advertise the game on television."),
	perform = function(self, gameProj, multiplier, maxPopGain)
		local basePopGain = (gameProj:getOwner():getReputation() * self.repToPopularity + self.popularityGain) * multiplier
		
		basePopGain = math.min(basePopGain, maxPopGain)
		
		local owner = gameProj:getOwner()
		local scaler = campaign:getReputationGainScaler(owner)
		local repGain, realPopGain = gameProj:increasePopularity(basePopGain, scaler > 0 and scaler, campaign.maxRepGainPerAdvertType)
		
		return basePopGain, repGain, realPopGain
	end
})
campaign:registerAdvertOption({
	cost = 200000,
	uiIcon = "advert_public_event",
	id = "public_event",
	repToPopularity = 0.01,
	popularityGain = 9000,
	display = _T("PUBLIC_EVENT", "Public event"),
	description = _T("ADVERT_PUBLIC_EVENT", "Hire actors to perform a public event related to the game."),
	perform = function(self, gameProj, multiplier, maxPopGain)
		local basePopGain = (gameProj:getOwner():getReputation() * self.repToPopularity + self.popularityGain) * multiplier
		
		basePopGain = math.min(basePopGain, maxPopGain)
		
		local owner = gameProj:getOwner()
		local scaler = campaign:getReputationGainScaler(owner)
		local repGain, realPopGain = gameProj:increasePopularity(basePopGain, scaler > 0 and scaler, campaign.maxRepGainPerAdvertType)
		
		return basePopGain, repGain, realPopGain
	end
})
campaign:registerAdvertOption({
	cost = 500000,
	uiIcon = "advert_snack_promotion",
	id = "snack_promotion",
	repToPopularity = 0.0001,
	popularityGain = 20000,
	display = _T("SNACK_PROMOTION", "Snack promotion"),
	description = _T("ADVERT_SNACK_PROMOTION", "Partner with snack companies to provide various game codes with snacks."),
	perform = function(self, gameProj, multiplier, maxPopGain)
		local basePopGain = (gameProj:getOwner():getReputation() * self.repToPopularity + self.popularityGain) * multiplier
		
		basePopGain = math.min(basePopGain, maxPopGain)
		
		local owner = gameProj:getOwner()
		local scaler = campaign:getReputationGainScaler(owner)
		local repGain, realPopGain = gameProj:increasePopularity(basePopGain, scaler > 0 and scaler, campaign.maxRepGainPerAdvertType)
		
		return basePopGain, repGain, realPopGain
	end
})
campaign:registerAdvertOption({
	cost = 150000,
	unlockRequired = "ads_on_radio_stations",
	uiIcon = "advert_ads_on_radio",
	repToPopularity = 0.005,
	popularityGain = 4000,
	id = "ads_on_radio_stations",
	display = _T("RADIO_STATION_ADS", "Radio station ads"),
	description = _T("RADIO_STATION_ADS_DESCRIPTION", "Advertise your game on radio stations."),
	perform = function(self, gameProj, multiplier, maxPopGain)
		local basePopGain = (gameProj:getOwner():getReputation() * self.repToPopularity + self.popularityGain) * multiplier
		
		basePopGain = math.min(basePopGain, maxPopGain)
		
		local owner = gameProj:getOwner()
		local scaler = campaign:getReputationGainScaler(owner)
		local repGain, realPopGain = gameProj:increasePopularity(basePopGain, scaler > 0 and scaler, campaign.maxRepGainPerAdvertType)
		
		return basePopGain, repGain, realPopGain
	end
})
game.registerTimedPopup("unlock_radio_ads", _T("NEW_MASS_ADVERTISEMENT_TYPE", "New mass advert type"), _T("RADIO_STATION_ADS_UNLOCKED", "People listen to various radio stations every day, and a lot of information can be carried across that way. Spreading awareness about an upcoming game is no exception.\n\nWhen starting a mass advertisement campaign you can now select the Radio station ads option."), "pix24", "pix20", {
	year = 1998,
	month = 1
}, nil, "ads_on_radio_stations")
advertisement:registerNew(campaign)

local screenshots = {}

screenshots.icon = "advert_release_screenshots"
screenshots.id = "screenshots"
screenshots.display = _T("ADVERTISEMENT_SCREENSHOTS", "Release screenshots")
screenshots.evaluatingFact = "evaluating_screenshots"
screenshots.timeFact = "screenshot_time"
screenshots.minEfficiencyAt = 5
screenshots.minEfficiency = 0.15
screenshots.maxEfficiency = 1
screenshots.basePopGain = 1000
screenshots.repToPopLog = math.log(1000, 16000)
screenshots.popGainCutoff = 5
screenshots.reducedEfficiencyTime = timeline.DAYS_IN_MONTH * 2
screenshots.log = math.log(screenshots.minEfficiency, screenshots.minEfficiencyAt)
screenshots.description = {
	{
		font = "pix20",
		wrapWidth = 400,
		lineSpace = 10,
		text = _T("SCREENSHOTS_DESC_1", "Release screenshots of the game.")
	},
	{
		font = "bh18",
		wrapWidth = 400,
		iconWidth = 22,
		lineSpace = 10,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("SCREENSHOTS_DESC_2", "The response depends entirely on the quality of the game. Issues won't affect the response by a lot."),
		color = game.UI_COLORS.LIGHT_BLUE
	},
	{
		font = "bh18",
		wrapWidth = 400,
		iconHeight = 22,
		icon = "exclamation_point_yellow",
		iconWidth = 22,
		text = _T("SCREENSHOTS_DESC_3", "This advertisement type is effective only several times, and its effectiveness drops if repeated often with very short breaks between each batch of screenshots."),
		color = game.UI_COLORS.IMPORTANT_3
	}
}

function screenshots:isAvailable(gameProj)
	return not gameProj:getReleaseDate()
end

function screenshots:_evaluate(gameProj, scheduledEvent)
	local efficiency = 1
	local times = gameProj:getTimesAdvertised(self.id)
	local rating = scheduledEvent:getRating()
	
	if times > 0 then
		if times < self.minEfficiencyAt then
			efficiency = 1 - (self.minEfficiencyAt + 1 - times)^self.log
		else
			efficiency = self.minEfficiency
		end
	end
	
	local popGainCutoff = self.popGainCutoff
	
	if rating < popGainCutoff then
		efficiency = -efficiency * ((popGainCutoff - rating) / (popGainCutoff - review.minRating))
	else
		efficiency = efficiency * ((rating - popGainCutoff) / popGainCutoff)
		
		local time = gameProj:getFact(self.timeFact)
		
		if time then
			local delta = timeline.curTime - time
			local redEffTime = self.reducedEfficiencyTime
			
			if delta < redEffTime then
				efficiency = efficiency * (delta / redEffTime)
			end
		end
	end
	
	return (self.basePopGain + gameProj:getOwner():getReputation()^self.repToPopLog) * efficiency
end

function screenshots:evaluate(gameProj, scheduledEvent)
	gameProj:removeFact(self.evaluatingFact)
	
	local popChange = self:_evaluate(gameProj, scheduledEvent)
	local text
	
	if popChange > 0 then
		text = _format(_T("SCREENSHOTS_EVAL_POSITIVE", "The screenshots elicited a positive response from the audience for 'GAME'."), "GAME", gameProj:getName())
	else
		text = _format(_T("SCREENSHOTS_EVAL_NEGATIVE", "The screenshots elicited a negative response from the audience for 'GAME'."), "GAME", gameProj:getName())
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("SCREENSHOTS_RESULT", "Screenshot Response"))
	popup:setTextFont("pix20")
	popup:setText(text)
	
	local left, right, extra = popup:getDescboxes()
	local wrapW = popup.rawW - 24
	
	if popChange > 0 then
		local repGain, popGain = gameProj:increasePopularity(popChange)
		
		popChange = popGain
		
		popup:setShowSound("good_jingle")
		extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("GENERIC_EVAL_POPULARITY_GAINED_AMOUNT", "The project gained POPULARITY Popularity points."), "POPULARITY", string.roundtobignumber(popChange)), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "exclamation_point", 22, 22)
	elseif popChange <= 0 then
		popup:setShowSound("bad_jingle")
		extra:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("DEMO_EVAL_POPULARITY_LOST_AMOUNT", "The project lost POPULARITY Popularity points."), "POPULARITY", string.roundtobignumber(math.abs(popChange))), "bh20", game.UI_COLORS.RED, 0, wrapW, "exclamation_point_red", 22, 22)
		gameProj:decreasePopularity(-popChange)
	end
	
	popup:addOKButton("pix24")
	popup:center()
	frameController:push(popup)
	gameProj:addAdvertisement(self.id, true)
	gameProj:setFact(self.timeFact, timeline.curTime)
end

function screenshots:resetFacts(gameProj)
	gameProj:removeFact(self.evaluatingFact)
end

function screenshots:canSelect(gameProj)
	return not gameProj:getFact(self.evaluatingFact)
end

eventBoxText:registerNew({
	id = "screenshots_posted",
	getText = function(self, data)
		return _format(_T("SCREENSHOTS_RELEASED", "Screenshots for 'GAME' posted. A result on what people think of it will become available shortly."), "GAME", data)
	end
})

function screenshots:onSelected(gameProj)
	local event = scheduledEvents:instantiateEvent("screenshots_evaluation")
	
	event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
	event:setRating(review:getCurrentGameVerdict(gameProj, 0))
	event:setProject(gameProj)
	
	local own = gameProj:getOwner()
	
	if own:isPlayer() then
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(_T("SCREENSHOTS_RELEASED_TITLE", "Screenshots Released"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setText(_format(_T("SCREENSHOTS_RELEASED_DESCRIPTION", "You've released screenshots for 'GAME'. A result on what people think of it will become available shortly."), "GAME", gameProj:getName()))
		popup:setShowSound("generic_jingle")
		
		local wrapW = popup.rawW - 24
		local left, right, extra = popup:getDescboxes()
		
		extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_T("SCREENSHOTS_DESC_2", "The response depends entirely on the quality of the game. Issues won't affect the response by a lot."), "bh20", game.UI_COLORS.LIGHT_BLUE, 10, wrapW, "question_mark", 22, 22)
		extra:addTextLine(-1, game.UI_COLORS.IMPORTANT_3, nil, "weak_gradient_horizontal")
		extra:addText(_T("SCREENSHOTS_DESC_3", "This advertisement type is effective only several times, and its effectiveness drops if repeated often with very short breaks between each batch of screenshots."), "bh20", game.UI_COLORS.IMPORTANT_3, 0, wrapW, "exclamation_point_yellow", 22, 22)
		popup:addOKButton("pix24")
		popup:center()
		frameController:push(popup)
		
		local elem = game.addToEventBox("screenshots_posted", gameProj:getName(), 1, nil, "exclamation_point")
		
		elem:setFlash(true, true)
	end
	
	gameProj:setFact(self.evaluatingFact, true)
end

advertisement:registerNew(screenshots)

local shill = {}

shill.id = "shilling"
shill.icon = "advert_shilling"
shill.display = _T("ADVERTISEMENT_SHILL_ON_THE_WEB", "Shill on the web")
shill.dataFact = "shilling_data"
shill.maxDelayBetweenRepGain = 10
shill.description = {
	{
		font = "pix24",
		text = _T("SHILLING_DESC_1", "Hire a marketing company to generate fake hype about the game.")
	},
	{
		font = "pix20",
		text = _T("SHILLING_DESC_2", "Risk depends on how obvious your shilling is.")
	},
	{
		font = "pix20",
		text = _T("SHILLING_DESC_3", "A good idea is to start shilling after the game has been announced.")
	}
}
shill.shillSitesByID = {}
shill.shillSites = {}
shill.shillTimePeriod = 3
shill.bustedFact = "busted_on_sites"
shill.requiredUnlock = "shilling"
shill.baseBustedRange = 10000
shill.baseBustedChance = 5
shill.bustChanceIncreasePerExtraSite = 5
shill.bustChanceIncreasePerExtraSiteExponent = 1.1
shill.bustChanceIncreasePerBustedSite = 20
shill.bustChanceIncreasePerDay = 2
shill.minimumShillEfficiency = 0.5
shill.shillEfficiencyDropPerBustedSite = 0.05
shill.bustedShillEfficiency = 0.1
shill.regularShillEfficiency = 1
shill.bustedCooldown = timeline.DAYS_IN_YEAR
shill.marketShareToPopularityGainCorrelation = 0.004
shill.affectedPeopleToPopularity = 0.3
shill.marketShareToPopularityGainCorrelationRandom = {
	0.75,
	1.1
}
shill.costPerDay = 0.005
shill.reputationDropPerDay = 6
shill.bustedAmountForRepLoss = 1
shill.repLossPerEachExtraBust = 6
shill.repLossMultiplierPerRep = 2000
shill.overallMarketShareMultiplier = 0.1
shill.priceRoundingSegment = 50
shill.efficiencyAfterReleaseMaxDays = timeline.DAYS_IN_MONTH * 5
shill.minEfficiencyAfterRelease = 0.1
shill.minEfficiencyFromPopularity = 0.25
shill.popGainDivider = 0.4
shill.maxPopGainOfRep = {
	0.15,
	0.25
}
shill.minimumUpperCeilingPopGain = 1000
shill.opinionLossBusted = 5
shill.EVENTS = {
	CHANGED_DURATION = events:new(),
	CHANGED_SHILLING_TYPE = events:new(),
	CHANGED_SHILLING_SITES = events:new(),
	PROGRESSED = events:new(),
	FINISHED = events:new()
}
shill.durationOptions = {
	timeline.DAYS_IN_MONTH,
	timeline.DAYS_IN_MONTH * 2,
	timeline.DAYS_IN_MONTH * 3
}
shill.bustedOn = {}
shill.bustedOnConcatTable = {}
shill.types = {
	{
		bustedChanceMultiplier = 1,
		popularityMultiplier = 1,
		costMultiplier = 1,
		text = _T("LIGHT_SHILLING", "Light shilling")
	},
	{
		bustedChanceMultiplier = 1.6,
		popularityMultiplier = 1.2,
		costMultiplier = 1.5,
		text = _T("MODERATE_SHILLING", "Moderate shilling")
	},
	{
		bustedChanceMultiplier = 2.2,
		popularityMultiplier = 1.4,
		costMultiplier = 2,
		text = _T("HEAVY_SHILLING", "Heavy shilling")
	}
}
shill.resultText = {
	{
		amount = 0,
		text = _T("SHILL_RESULT_FAILURE", "The shilling campaign didn't work - an insignificant amount of interest was gained.")
	},
	{
		amount = 1000,
		text = _T("SHILL_RESULT_TINY", "The shilling campaign saw limited success with only a small amount of people taking interest in the game.")
	},
	{
		amount = 5000,
		text = _T("SHILL_RESULT_SMALL", "The shilling campaign has received a bit of attention in response.")
	},
	{
		amount = 12000,
		text = _T("SHILL_RESULT_MODERATE", "The shilling campaign has raised a moderate amount of interest towards the game.")
	},
	{
		amount = 30000,
		text = _T("SHILL_RESULT_HIGH", "The shilling campaign worked well, and a large amount of people have noticed the game.")
	},
	{
		amount = 80000,
		text = _T("SHILL_RESULT_VERY_HIGH", "The shilling campaign has been a success, with a very large amount of people becoming interested.")
	},
	{
		amount = 150000,
		text = _T("SHILL_RESULT_INSANE", "The shilling campaign has garnered an insane amount of interest - a huge amount of people are talking about it.")
	}
}

function shill:isAvailable()
	return unlocks:isAvailable(self.requiredUnlock)
end

game.registerTimedPopup("unlock_shilling", _T("NEW_ADVERTISEMENT_TYPE", "New advert type"), _T("SHILLING_UNLOCKED", "The internet is undergoing mass commercialization, which means that gaming websites will soon be springing up like mushrooms after rain.\nAdditional advertisement agencies are now available to heavily market, or shill, on such websites.\n\nIt's not foolproof, and therefore, if shilled too hard, can end up with the agency getting busted."), "pix24", "pix20", {
	year = 1996,
	month = 3
}, nil, shill.requiredUnlock)

local defaultSiteFuncs = {}

defaultSiteFuncs.mtindex = {
	__index = defaultSiteFuncs
}
defaultSiteFuncs.costIncreasePerVisitors = 15000
defaultSiteFuncs.costIncrease = 1000

function defaultSiteFuncs:getMarketSharePercentage()
	return self.marketSharePercentage
end

function defaultSiteFuncs:getUserCount()
	return math.floor(self.marketSharePercentage * platformShare:getTotalUsers())
end

function defaultSiteFuncs:getCost()
	local cost = self.cost
	local extraCost = math.floor(self:getUserCount() / self.costIncreasePerVisitors) * self.costIncrease
	
	return math.max(cost, extraCost + cost + math.ceil(cost * (self.realMarketShare / shill.totalMarketShareValue) / shill.priceRoundingSegment) * shill.priceRoundingSegment)
end

function defaultSiteFuncs:getProgressionTowardsMaxShare()
	local releaseTime = timeline:getDateTime(self.availabilityDate.year, self.availabilityDate.month)
	local fullShareTime = timeline:getDateTime(self.fullShareTime.year, self.fullShareTime.month)
	local time = timeline.curTime
	
	if time < fullShareTime then
		local timeDiff = fullShareTime - releaseTime
		
		return (fullShareTime - (fullShareTime - time)) / timeDiff
	end
	
	return 1
end

function defaultSiteFuncs:updateMarketShare()
	local share = self.marketShare
	
	if self.maxMarketShareTime then
		share = math.lerp(self.startMarketShare, share, self:getProgressionTowardsMaxShare())
	end
	
	self.realMarketShare = share
end

function defaultSiteFuncs:getMarketShare()
	local share = self.marketShare
	
	if self.maxMarketShareTime then
		share = math.lerp(self.startMarketShare, share, self:getProgressionTowardsMaxShare())
	end
	
	return share
end

function defaultSiteFuncs:canSelect(gameProj)
	local fact = studio:getFact(shill.bustedFact)
	
	if fact and fact[self.id] and timeline.curTime < fact[self.id] + shill.bustedCooldown then
		return false
	end
	
	return true
end

function shill:registerSite(data)
	table.insert(shill.shillSites, data)
	
	shill.shillSitesByID[data.id] = data
	data.startMarketShare = data.startMarketShare or 0
	data.cost = data.cost or 5000
	
	setmetatable(data, defaultSiteFuncs.mtindex)
	
	data.desciption = data.desciption or {}
	
	table.insert(data.description, {
		font = "pix20",
		text = string.easyformatbykeys(_T("WEBSITE_RELEASE_DATE", "This website has been formed on YEAR"), "YEAR", data.availabilityDate.year)
	})
	self:recalculateMarketSharePercentages()
end

function shill:getTotalSiteCost(sites)
	local total = 0
	local sitesByID = shill.shillSitesByID
	
	for key, siteID in ipairs(sites) do
		local cost = sitesByID[siteID]:getCost()
		
		total = total + cost
	end
	
	return total
end

function shill:getCost(sites, type, duration)
	if #sites == 0 then
		return 0, 0, 0, 0
	end
	
	local siteCost = self:getTotalSiteCost(sites)
	local durationCost = siteCost * self.costPerDay * duration
	local heavinessCostMult = shill.types[type].costMultiplier
	
	return (siteCost + durationCost) * heavinessCostMult, siteCost, durationCost, heavinessCostMult
end

function shill:stopShillingOption()
	shill:abort(self.project)
end

function shill:fillInteractionComboBox(comboBox, gameProj)
	if gameProj:getFact(self.dataFact) then
		local option = comboBox:addOption(0, 0, 0, 0, _T("STOP_SHILLING", "Stop shilling"), fonts.get("pix20"), shill.stopShillingOption)
		
		option.project = gameProj
	end
end

function shill:canShillOnSite(siteData)
	return self:isSiteAvailable(siteData)
end

function shill:recalculateMarketSharePercentages()
	self.totalMarketShareValue = 0
	
	for key, siteData in ipairs(self.shillSites) do
		siteData:updateMarketShare()
		
		self.totalMarketShareValue = self.totalMarketShareValue + siteData.realMarketShare
	end
	
	for key, siteData in ipairs(self.shillSites) do
		siteData.marketSharePercentage = siteData.realMarketShare / self.totalMarketShareValue * self.overallMarketShareMultiplier
	end
	
	self.averageMarketShareValue = self.totalMarketShareValue / #self.shillSites
end

function shill:getTotalMarketSharePercentage(ourMarketShare, excludeSite)
	local totalMarketShareValue = 0
	
	for key, siteData in ipairs(shill.shillSites) do
		if not excludeSite or excludeSite and siteData ~= excludeSite then
			totalMarketShareValue = totalMarketShareValue + siteData.marketShare
		end
	end
	
	return ourMarketShare / totalMarketShareValue
end

function shill:canSelect(gameProj)
	return gameProj:getFact(gameProject.ANNOUNCED_FACT) and not gameProj:getFact(self.dataFact)
end

function shill:calculateScaleAffector(gameProj)
	return gameProj:getScale() / platformShare:getMaxGameScale()
end

function shill:applyShillingDataToGame(gameProj, shillSites, shillType, shillDuration, moneySpent)
	local data = {
		foundOutShillingCount = 0,
		affectedPeople = 0,
		currentShillEfficiency = 1,
		shillType = shillType,
		startedOn = timeline.curTime,
		lastsUntil = timeline.curTime + shillDuration,
		lastShillTime = timeline.curTime,
		shillSiteAmount = table.count(shillSites),
		interestPerWeek = {},
		shillSites = shillSites,
		foundOutShilling = {},
		scaleAffector = self:calculateScaleAffector(gameProj),
		moneySpent = moneySpent
	}
	
	gameProj:setFact(self.dataFact, data)
	gameProj:addAdvertisement(self.id)
	self:createShillDataDisplay(gameProj)
end

local unrevealedAdvertTypes = {}

function shill:getBustedChance(shillData, gameProj, site)
	local chance = shill.baseBustedChance + shill.shillSitesByID[site].bustedChance
	
	chance = chance + shillData.foundOutShillingCount * shill.bustChanceIncreasePerBustedSite
	chance = chance + (shill.bustChanceIncreasePerExtraSite * shillData.shillSiteAmount)^shill.bustChanceIncreasePerExtraSiteExponent
	chance = chance + (timeline.curTime - shillData.startedOn) * shill.bustChanceIncreasePerDay
	
	return chance
end

function shill:getShillEfficiency(shillData, site)
	local efficiency = self.bustedShillEfficiency
	
	if not shillData.foundOutShilling[site] then
		efficiency = self.regularShillEfficiency
	end
	
	efficiency = efficiency * shill.types[shillData.shillType].popularityMultiplier
	
	return efficiency * shillData.currentShillEfficiency * shill.shillSitesByID[site]:getMarketSharePercentage()
end

function shill:bustedShillOnSite(shillData, siteID)
	shillData.currentShillEfficiency = math.max(shillData.currentShillEfficiency - self.shillEfficiencyDropPerBustedSite, self.minimumShillEfficiency)
	shillData.foundOutShilling[siteID] = true
	shillData.foundOutShillingCount = shillData.foundOutShillingCount + 1
	self.bustedOn[#self.bustedOn + 1] = shill.shillSitesByID[siteID]
	
	local bustedSiteTimestamps = studio:getFact(self.bustedFact) or {}
	
	bustedSiteTimestamps[siteID] = timeline.curTime
	
	studio:setFact(self.bustedFact, bustedSiteTimestamps)
end

function shill:getGainedPopularity(shillData, siteID, baseValue)
	return baseValue * self:getShillEfficiency(shillData, siteID) * math.random(shill.marketShareToPopularityGainCorrelationRandom[1], shill.marketShareToPopularityGainCorrelationRandom[2])
end

function shill:abort(gameProj)
	self:finishShilling(gameProj, nil, true)
end

function shill:finishShilling(gameProj, bustedEverywhere, aborted)
	local data = gameProj:getFact(self.dataFact)
	local totalPop = data.affectedPeople
	local highest = -math.huge
	local fitting
	
	for key, data in ipairs(self.resultText) do
		if totalPop >= data.amount and highest < data.amount then
			highest = data.amount
			fitting = data
		end
	end
	
	local text = _T("SHILL_RESULT_POPUP_TEXT", "MAIN_TEXT POPULARITY_REPORT")
	local mainText = ""
	
	if bustedEverywhere then
		mainText = _T("SHILL_CAMPAIGN_ENDED_DUE_TO_BEING_BUSTED", "The campaign had to be ended early, because the agency was busted on every single site and there wasn't much point in going further. ")
	end
	
	if aborted then
		mainText = _T("SHILL_CAMPAIGN_ABORTED", "The campaign has been aborted as per request of the studio, as such maximum shilling efficiency has not been reached.")
	end
	
	text = string.easyformatbykeys(text, "MAIN_TEXT ", mainText, "POPULARITY_REPORT", fitting.text)
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("SHILLING_RESULT_TITLE", "Shilling Result"))
	popup:setText(text)
	
	local wrapWidth = (popup.rawW - 20) * 0.5
	local left, right, extra = popup:getDescboxes()
	
	left:addText(_format(_T("SHILLING_POPULARITY_GAINED", "Popularity gained: POP"), "POP", string.comma(totalPop)), "bh20", nil, 0, wrapWidth, "star", 24, 24)
	left:addText(_format(_T("SHILLING_MONEY_SPENT", "Money spent: $MONEY"), "MONEY", string.comma(data.moneySpent or 0)), "bh20", nil, 0, wrapWidth, "star", 24, 24)
	
	local bustedColor = data.foundOutShillingCount > 0 and game.UI_COLORS.RED
	
	right:addText(_format(_T("SHILLING_SITES_BUSTED_ON", "Sites busted on: BUSTED"), "BUSTED", data.foundOutShillingCount), "bh20", bustedColor, 0, wrapWidth, "exclamation_point_red", 24, 24)
	right:addText(_format(_T("SHILLING_CAMPAIGN_DURATION", "Duration: DURATION"), "DURATION", timeline:getTimePeriodText(data.lastsUntil - data.startedOn)), "bh20", nil, 0, wrapWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			height = 20,
			icon = "clock_full",
			width = 20,
			x = 2
		}
	})
	
	if data.foundOutShillingCount > 0 then
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.UI_PENALTY_LINE)
		extra:addText(_T("BUSTED_ON_SITES_WARNING", "Getting busted while shilling will hurt your reputation."), "bh20", game.UI_COLORS.RED, 4, popup.rawW - 20, "exclamation_point_red", 22, 22)
		extra:addText(_T("BUSTED_ON_SITES_WARNING_DESC", "Shilling duration, heaviness & site amount increase the chance of being busted."), "bh18", nil, 0, popup.rawW - 20, "question_mark", 22, 22)
	end
	
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"))
	popup:center()
	frameController:push(popup)
	gameProj:setFact(self.dataFact, nil)
	gameProj:removeActiveAdvertisement(self.id)
	
	gameProj.shillingDataDisplay = nil
	
	events:fire(advertisement.EVENTS.FINISHED_ADVERTISEMENT, gameProj, self.id)
	events:fire(shill.EVENTS.FINISHED, gameProj)
end

function shill:handleEvent(gameProj, event)
	if event == timeline.EVENTS.NEW_DAY then
		local data = gameProj:getFact(self.dataFact)
		
		if data then
			if timeline.curTime >= data.lastsUntil then
				self:finishShilling(gameProj, false)
			else
				local curTime = timeline.curTime
				
				if curTime >= data.lastShillTime then
					self:recalculateMarketSharePercentages()
					
					local gainedPopularity = 0
					local lostOpinion = 0
					
					gameProj:getOwner():changeOpinion(-shill.opinionLossBusted * lostOpinion)
					
					for key, siteID in ipairs(data.shillSites) do
						if not data.foundOutShilling[siteID] and math.random(1, self.baseBustedRange) <= self:getBustedChance(data, gameProj, siteID) then
							self:bustedShillOnSite(data, siteID)
							
							lostOpinion = lostOpinion + 1
						end
					end
					
					local allPeople = platformShare:getTotalUsers()
					local timeAffector = 1
					local releaseDate = gameProj:getReleaseDate()
					
					if releaseDate then
						local time = timeline.curTime
						local distance = math.min(1, (time - releaseDate) / shill.efficiencyAfterReleaseMaxDays)
						
						timeAffector = math.lerp(1, shill.minEfficiencyAfterRelease, distance)
					end
					
					if not data.scaleAffector then
						data.scaleAffector = self:calculateScaleAffector(gameProj)
					end
					
					local basevalue = platformShare:getTotalUsers() * shill.marketShareToPopularityGainCorrelation
					local curHype = gameProj:getMomentPopularity() + gameProj:getPopularity()
					local hypeAffector = math.lerp(1, self.minEfficiencyFromPopularity, math.min(1, curHype / basevalue))
					local finalMult = shill.affectedPeopleToPopularity * timeAffector * hypeAffector * data.scaleAffector
					local gainRange = shill.maxPopGainOfRep
					local maxGain = math.max(studio:getReputation(), self.minimumUpperCeilingPopGain) * math.randomf(gainRange[1], gainRange[2]) / #data.shillSites
					
					for key, siteID in ipairs(data.shillSites) do
						local desiredPopularity = math.floor(self:getGainedPopularity(data, siteID, basevalue) * finalMult)
						local affectedPeople = math.min(allPeople - data.affectedPeople, desiredPopularity, maxGain)
						local repGain, realPop = gameProj:increasePopularity(affectedPeople, nil, nil, self.popGainDivider)
						
						gainedPopularity = gainedPopularity + realPop
						data.affectedPeople = data.affectedPeople + realPop
					end
					
					if data.foundOutShillingCount >= data.shillSiteAmount then
						self:finishShilling(gameProj, true)
					end
					
					data.interestPerWeek[#data.interestPerWeek + 1] = gainedPopularity
					data.lastShillTime = curTime + shill.shillTimePeriod
					
					events:fire(shill.EVENTS.PROGRESSED, gameProj)
				end
			end
			
			local delta = data.foundOutShillingCount - self.bustedAmountForRepLoss
			
			if delta >= 0 then
				studio:decreaseReputation((self.reputationDropPerDay + self.repLossPerEachExtraBust * delta) * (1 + studio:getReputation() / self.repLossMultiplierPerRep))
			end
		end
	end
end

function shill:isSiteAvailable(siteData)
	if siteData.availabilityDate then
		return timeline:hasDateBeenReached(siteData.availabilityDate.year, siteData.availabilityDate.month)
	end
	
	return true
end

function shill:onLoad(gameProj)
	self:createShillDataDisplay(gameProj)
end

function shill:createShillDataDisplay(gameProj)
	if not gameProj.shillingDataDisplay then
		local shillingDataDisplay = gui.create("ShillingDisplayFrame")
		
		game.addToProjectScroller(shillingDataDisplay, gameProj)
		
		gameProj.shillingDataDisplay = true
	end
end

function shill:onSelected(gameProj)
	self:recalculateMarketSharePercentages()
	
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("SELECT_WEBSITES_TO_SHILL_ON_TITLE", "Select Websites"))
	
	local scrollBarPanel = gui.create("ScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(5), _S(65))
	scrollBarPanel:setSize(390, 500)
	scrollBarPanel:setSpacing(4)
	scrollBarPanel:setPadding(4, 4)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:addDepth(100)
	
	local costDisplay = gui.create("ShillingCostDisplay", frame)
	
	costDisplay:setSize(220, 25)
	costDisplay:setPos(_S(5), _S(570))
	costDisplay:setFont("pix24")
	costDisplay:setCost(0)
	
	local confirmButton = gui.create("ConfirmShillingButton", frame)
	
	confirmButton:setPos(costDisplay.x + _S(5) + costDisplay.w, _S(570))
	confirmButton:setSize(frame.rawW - _US(costDisplay.x + costDisplay.w) - 10, 25)
	confirmButton:setCostDisplay(costDisplay)
	confirmButton:setProject(gameProj)
	confirmButton:setText(_T("BEGIN_SHILLING", "Start shilling"))
	costDisplay:setConfirmButton(confirmButton)
	
	local typeSelection = gui.create("ShillingTypeComboBoxButton", frame)
	
	typeSelection:setPos(_S(5), _S(35))
	typeSelection:setSize(193, 25)
	typeSelection:setFont(fonts.get("pix24"))
	typeSelection:setConfirmationButton(confirmButton)
	
	local durationSelection = gui.create("ShillingDurationComboBoxButton", frame)
	
	durationSelection:setPos(_S(202), _S(35))
	durationSelection:setSize(193, 25)
	durationSelection:setFont(fonts.get("pix24"))
	durationSelection:setConfirmationButton(confirmButton)
	
	for key, siteData in ipairs(self.shillSites) do
		if self:canShillOnSite(siteData) then
			local element = gui.create("ShillingSelectionButton")
			
			element:setWidth(370)
			element:setSite(siteData)
			element:setConfirmationButton(confirmButton)
			scrollBarPanel:addItem(element)
		end
	end
	
	frame:center()
	frameController:push(frame)
end

shill:registerSite({
	marketShare = 10,
	cost = 12500,
	id = "4chinz",
	bustedChance = 100,
	display = _T("4CHINS", "4chins"),
	description = {
		{
			font = "pix24",
			text = _T("4CHINS_DESCRIPTION1", "An anonymous image board website like this is no doubt a magnet for people.")
		},
		{
			font = "pix20",
			text = _T("4CHINS_DESCRIPTION2", "The amount of people posting on the video game board is definitely impressive.")
		},
		{
			font = "pix20",
			text = _T("4CHINS_DESCRIPTION_SHILLING", "However the people here are very observant and hate shilling with a passion.")
		}
	},
	availabilityDate = {
		year = 2003,
		month = 10
	},
	fullShareTime = {
		year = 2015,
		month = 4
	}
})
shill:registerSite({
	marketShare = 16,
	cost = 19000,
	id = "pleb_pit",
	bustedChance = 40,
	display = _T("PLEB_PIT", "Pleb Pit"),
	description = {
		{
			font = "pix24",
			text = _T("PLEB_PIT_DESCRIPTION1", "This site seems to be the next big thing online, with tons of people posting here.")
		},
		{
			font = "pix20",
			text = _T("PLEB_PIT_DESCRIPTION2", "The moderators here seem to be somewhat easy to strike a deal with, so it might be easy to shill here.")
		}
	},
	availabilityDate = {
		year = 2005,
		month = 6
	},
	fullShareTime = {
		year = 2013,
		month = 7
	}
})
advertisement:registerNew(shill)
shill:registerSite({
	marketShare = 7,
	cost = 9000,
	id = "igw",
	bustedChance = 20,
	display = _T("IGW", "IGW"),
	description = {
		{
			font = "pix24",
			text = _T("IGW_DESCRIPTION1", "A site dedicated for games.")
		},
		{
			font = "pix20",
			text = _T("IGW_DESCRIPTION2", "Moderation here seems to only revolve around swearwords.")
		}
	},
	availabilityDate = {
		year = 1996,
		month = 9
	},
	fullShareTime = {
		year = 2010,
		month = 6
	}
})
shill:registerSite({
	marketShare = 3.5,
	cost = 4500,
	id = "tactical_gamer",
	bustedChance = 20,
	display = _T("TACTICAL_GAMER", "Tactical Gamer"),
	description = {
		{
			font = "pix24",
			text = _T("TACTICAL_GAMER_DESCRIPTION1", "A site dedicated for games.")
		},
		{
			font = "pix20",
			text = _T("TACTICAL_GAMER_DESCRIPTION2", "Moderation here seems to only revolve around swearwords.")
		}
	},
	availabilityDate = {
		year = 1996,
		month = 2
	},
	fullShareTime = {
		year = 2009,
		month = 4
	}
})
shill:registerSite({
	marketShare = 3,
	cost = 4000,
	id = "gameespionage",
	bustedChance = 20,
	display = _T("GAME_ESPIONAGE", "GameEspionage"),
	description = {
		{
			font = "pix24",
			text = _T("GAME_ESPIONAGE_DESCRIPTION1", "A site dedicated for games.")
		},
		{
			font = "pix20",
			text = _T("GAME_ESPIONAGE_DESCRIPTION2", "Moderation here seems to only revolve around swearwords.")
		}
	},
	availabilityDate = {
		year = 1996,
		month = 3
	},
	fullShareTime = {
		year = 2008,
		month = 1
	}
})
shill:registerSite({
	marketShare = 4,
	cost = 5500,
	id = "gamedeluge",
	bustedChance = 20,
	display = _T("GAME_DELUGE", "Game Deluge"),
	description = {
		{
			font = "pix24",
			text = _T("GAME_ESPIONAGE_DESCRIPTION1", "A site dedicated for games.")
		},
		{
			font = "pix20",
			text = _T("GAME_ESPIONAGE_DESCRIPTION2", "Moderation here seems to only revolve around swearwords.")
		}
	},
	availabilityDate = {
		year = 2008,
		month = 8
	},
	fullShareTime = {
		year = 2009,
		month = 4
	}
})
shill:registerSite({
	marketShare = 8,
	cost = 9000,
	id = "videocenter",
	bustedChance = 25,
	display = _T("VIDEO_CENTER", "VideoCenter"),
	description = {
		{
			font = "pix24",
			text = _T("VIDEO_CENTER_DESCRIPTION1", "A site made for sharing videos easily.")
		},
		{
			font = "pix20",
			text = _T("VIDEO_CENTER_DESCRIPTION2", "Traffic here is quite large and you can find a lot of gaming videos.")
		},
		{
			font = "pix20",
			text = _T("VIDEO_CENTER_DESCRIPTION3", "Game developers upload their game trailers here.")
		},
		{
			font = "pix20",
			text = _T("VIDEO_CENTER_DESCRIPTION4", "Shilling here would be practically undetectable.")
		}
	},
	availabilityDate = {
		year = 2005,
		month = 2
	},
	fullShareTime = {
		year = 2011,
		month = 4
	}
})

local letsPlays = {}

letsPlays.icon = "advert_lets_play"
letsPlays.id = "lets_plays"
letsPlays.display = _T("ADVERTISEMENT_PLAYTHROUGH_VIDEOS", "Playthrough videos")
letsPlays.description = {
	{
		font = "pix20",
		text = _T("PLAYTHOUGH_VIDEOS_DESC_1", "Hire a video game enthusiast that makes videos online.")
	},
	{
		font = "pix18",
		text = _T("PLAYTHOUGH_VIDEOS_DESC_2", "The game will be played and showcased online, which means it needs to be in a playable, and ideally, bug-free state.")
	},
	{
		font = "bh18",
		text = _T("PLAYTHOUGH_VIDEOS_DESC_3", "Showcasing unfinished games is not a good idea.")
	}
}
letsPlays.viewsToPopularity = 0.01
letsPlays.dataFact = "lets_plays"
letsPlays.extraVideosTutorialFact = "extra_videos_tutorial_fact"
letsPlays.viewDropPerVideo = 0.05
letsPlays.viewCountDropOffRating = 8
letsPlays.viewCountIncreasePerRatingOverDropOff = 0.015
letsPlays.ratingDeltaViewCountDivider = 10
letsPlays.minimumViewsPerVideo = 0.1
letsPlays.viewerBaseMultiplier = 0.001
letsPlays.gameCompletionPenalty = 0.8
letsPlays.unlockID = "lets_players"
letsPlays.issueScoreAffector = 0.5
letsPlays.minimumCompletion = 0.4
letsPlays.popGainDivider = 40
letsPlays.viewsToPopCap = 5
letsPlays.viewsPerLPerFact = "views_per_lper"
letsPlays.registered = {}
letsPlays.registeredByID = {}
letsPlays.EVENTS = {
	ADDED_DESIRED_LETS_PLAYER = events:new(),
	REMOVED_DESIRED_LETS_PLAYER = events:new(),
	PLAYTHROUGH_OVER = events:new(),
	PLAYTHROUGH_PROGRESSED = events:new(),
	PLAYTHROUGH_EXTENDED = events:new()
}

game.registerTimedPopup(letsPlays.unlockID, _T("LETS_PLAYS_NOW_AVAILABLE", "Playthrough videos now available"), _T("LETS_PLAYS_NOW_AVAILABLE_DESC", "A new online phenomenon is the emergence of online personalities that create game playthrough videos and upload them on the internet.\n\nSeeing as that is a good way to advertise games it is now possible to sign a contract with such personalities and have them create playthroughs of whatever game it is that you're making."), "bh24", "pix20", {
	year = 2006,
	month = 7
}, nil, letsPlays.unlockID)

function letsPlays:isAvailable(gameProj)
	return unlocks:isAvailable(letsPlays.unlockID)
end

function letsPlays:onOffMarket(gameProj)
	gameProj:removeFact(letsPlays.viewsPerLPerFact)
	
	local lpData = gameProj:getFact(self.dataFact)
	
	for key, lpEr in ipairs(lpData.active) do
		letsPlayers:getLetsPlayer(lpEr.id):onOffMarket(gameProj)
		
		lpData.active[key] = nil
	end
	
	gameProj.letsPlayViewDisplay = false
	
	gameProj:removeFact(self.dataFact)
end

function letsPlays:canSelect(gameProj)
	return gameProj:getOverallCompletion() >= self.minimumCompletion
end

function letsPlays:setupDescbox(gameProj, descBox, wrapWidth)
	if not self:canSelect(gameProj) then
		descBox:addSpaceToNextText(5)
		descBox:addText(_format(_T("PLAYTHOUGH_VIDEOS_DESC_4", "The game must be at least COMPLETION% complete for this advertisement."), "COMPLETION", self.minimumCompletion * 100), "bh18", game.UI_COLORS.IMPORTANT_1, 0, wrapWidth, "exclamation_point_yellow", 22, 22)
	end
end

function letsPlays:calculateScaleAffector(gameProj)
	return gameProj:getScale() / platformShare:getMaxGameScale()
end

function letsPlays:addLetsPlayers(gameProj)
	local data = gameProj:getFact(self.dataFact) or {
		active = {},
		viewData = {}
	}
	local viewData = gameProj:getFact(letsPlays.viewsPerLPerFact) or {}
	local advertActive = gameProj:isAdvertisementActive(self.id)
	
	if not advertActive then
		data.scaleAffector = self:calculateScaleAffector(gameProj)
		data.totalViews = 0
		data.peakViews = 0
		data.totalVideos = 0
		data.extraVideoCount = 0
		data.extraVideoContributors = 0
		data.totalPopularityGained = 0
		data.totalLetsPlayers = 0
		data.remainingVideos = 0
		data.completionPenalty = false
	end
	
	local gameRating = review:getCurrentGameVerdict(gameProj, letsPlays.issueScoreAffector)
	
	for key, id in ipairs(self.listOfLetsPlayers) do
		local letsPlayer = letsPlayers:getLetsPlayer(id)
		
		letsPlayer:increaseVideosMade()
		
		data.totalLetsPlayers = data.totalLetsPlayers + 1
		
		local struct = self:initLetsPlayerStructure(id, gameRating, gameProj)
		
		data.remainingVideos = data.remainingVideos + struct.videosLeftToMake
		
		table.insert(data.active, struct)
		letsPlayer:addGame(gameProj, gameRating)
		
		viewData[id] = viewData[id] or 0
	end
	
	gameProj:setFact(self.dataFact, data)
	gameProj:setFact(self.viewsPerLPerFact, viewData)
	
	self.listOfLetsPlayers = nil
	
	if not advertActive then
		gameProj:addAdvertisement(self.id)
	end
	
	self:createViewDataDisplay(gameProj)
end

function letsPlays:onLoad(gameProj)
	self:createViewDataDisplay(gameProj)
end

function letsPlays:createViewDataDisplay(gameProj)
	if not gameProj.letsPlayViewDisplay then
		local lpViewDisplay = gui.create("LetsPlayDisplayFrame")
		
		game.addToProjectScroller(lpViewDisplay, gameProj)
		
		gameProj.letsPlayViewDisplay = true
	else
		events:fire(letsPlays.EVENTS.PLAYTHROUGH_EXTENDED, gameProj)
	end
end

function letsPlays:getListOfLetsPlayers()
	return self.listOfLetsPlayers
end

function letsPlays:getDesiredLetsPlayerCost()
	local cost = 0
	
	for key, id in ipairs(self.listOfLetsPlayers) do
		cost = cost + letsPlayers:getLetsPlayer(id):getPrice()
	end
	
	return cost
end

function letsPlays:isMakingLetsPlay(gameProj, letsPlayerID)
	local data = gameProj:getFact(self.dataFact)
	
	if not data then
		return false
	end
	
	for key, data in ipairs(data.active) do
		if data.id == letsPlayerID then
			return true
		end
	end
	
	return false
end

function letsPlays:addDesiredLetsPlayer(id)
	table.insert(self.listOfLetsPlayers, id)
	events:fire(letsPlays.EVENTS.ADDED_DESIRED_LETS_PLAYER, id, self.listOfLetsPlayers)
end

function letsPlays:removeDesiredLetsPlayer(id)
	if table.removeObject(self.listOfLetsPlayers, id) then
		events:fire(letsPlays.EVENTS.REMOVED_DESIRED_LETS_PLAYER, id, self.listOfLetsPlayers)
	end
end

function letsPlays:initLetsPlayerStructure(id, gameRating, gameProj)
	local letsPlayer = letsPlayers:getLetsPlayer(id)
	
	return {
		views = 0,
		videosMade = 0,
		extraVideosMade = false,
		id = id,
		overallGameCompletion = gameProj:getOverallCompletion(),
		videosLeftToMake = letsPlayer:getMaxVideos(),
		gameRating = gameRating
	}
end

function letsPlays:performVideo(data, lpData)
	local letsPlayer = letsPlayers:getLetsPlayer(data.id)
	local viewerbase = letsPlayer:getViewerbase()
	local delta = self.viewCountDropOffRating - data.gameRating
	local videoAffector = data.videosMade * self.viewDropPerVideo
	local multiplier = 1
	
	if delta > 0 then
		delta = delta / self.ratingDeltaViewCountDivider
		multiplier = multiplier - delta
	else
		videoAffector = videoAffector - data.videosMade * self.viewCountIncreasePerRatingOverDropOff
	end
	
	local completionPenalty = 1
	
	if data.overallGameCompletion < self.gameCompletionPenalty then
		completionPenalty = 1 - data.overallGameCompletion / self.gameCompletionPenalty
		lpData.completionPenalty = true
	end
	
	multiplier = math.min(1, math.max(multiplier - videoAffector, self.minimumViewsPerVideo))
	
	local views = math.ceil(viewerbase * multiplier * completionPenalty * lpData.scaleAffector)
	
	data.videosMade = data.videosMade + 1
	data.views = data.views + views
	
	return views, letsPlayer, viewerbase
end

eventBoxText:registerNew({
	id = "free_extra_videos",
	getText = function(self, data)
		return _format(_T("FREE_EXTRA_VIDEOS_SHORT", "'LETSPLAYER' will make EXTRA more videos, free of charge, for your 'GAME' game."), "LETSPLAYER", data.letsPlayer:getName(), "EXTRA", data.letsPlayer:getExtraVideos(), "GAME", data.game)
	end,
	saveData = function(self, data)
		return {
			letsPlayer = data.letsPlayer:getID(),
			game = data.game
		}
	end,
	loadData = function(self, targetElement, data)
		data.letsPlayer = letsPlayers:getLetsPlayer(data.letsPlayer)
		
		return data
	end
})

function letsPlays:handleEvent(gameProj, event)
	if event == timeline.EVENTS.NEW_WEEK then
		local lpData = gameProj:getFact(self.dataFact)
		
		if lpData then
			if not lpData.scaleAffector then
				lpData.scaleAffector = self:calculateScaleAffector(gameProj)
			end
			
			local viewsThisWeek = 0
			local index = 1
			local viewData = gameProj:getFact(letsPlays.viewsPerLPerFact)
			
			if not viewData then
				viewData = {}
				
				gameProj:setFact(letsPlays.viewsPerLPerFact, viewData)
			end
			
			for i = 1, #lpData.active do
				local data = lpData.active[index]
				local lpViews, letsPlayer, viewerbase = self:performVideo(data, lpData)
				
				viewsThisWeek = viewsThisWeek + lpViews
				lpData.totalViews = lpData.totalViews + lpViews
				
				local prevViews = viewData[data.id] or 0
				
				viewData[data.id] = prevViews + lpViews
				
				local popularity = math.round(lpViews * self.viewsToPopularity / math.max(1, prevViews / (viewerbase * letsPlays.viewsToPopCap) * letsPlays.popGainDivider))
				local repGain, realPopGain = gameProj:increasePopularity(popularity, false)
				
				lpData.totalPopularityGained = lpData.totalPopularityGained + realPopGain
				data.videosLeftToMake = data.videosLeftToMake - 1
				lpData.remainingVideos = lpData.remainingVideos - 1
				lpData.totalVideos = lpData.totalVideos + 1
				
				if data.videosLeftToMake <= 0 then
					local genre = gameProj:getGenre()
					
					if letsPlayer:isGenrePreferred(genre) and letsPlayer:getFreeExtraVideosRating() <= data.gameRating and not data.extraVideosMade then
						local extraVids = letsPlayer:getExtraVideos()
						
						data.videosLeftToMake = data.videosLeftToMake + extraVids
						data.extraVideosMade = true
						
						letsPlayer:onFinish()
						
						lpData.extraVideoCount = lpData.extraVideoCount + extraVids
						lpData.extraVideoContributors = lpData.extraVideoContributors + 1
						lpData.remainingVideos = lpData.remainingVideos + extraVids
						
						if not studio:getFact(self.extraVideosTutorialFact) then
							local popup = game.createPopup(600, _T("FREE_EXTRA_VIDEOS_TITLE", "Free Extra Videos"), string.easyformatbykeys(_T("FREE_EXTRA_VIDEOS_DESC", "'LETSPLAYER' has finished making their 'Let's Play' video series for your 'GAME' game project, but has said that since they love GENRE games, and your game especially, they will make EXTRA more videos free of charge."), "LETSPLAYER", letsPlayer:getName(), "GAME", gameProj:getName(), "GENRE", genres.registeredByID[genre].display, "EXTRA", letsPlayer:getExtraVideos()), fonts.get("pix24"), fonts.get("pix20"))
							
							popup:setShowSound("good_jingle")
							popup:hideCloseButton()
							frameController:push(popup)
							studio:setFact(self.extraVideosTutorialFact, true)
						else
							game.addToEventBox("free_extra_videos", {
								letsPlayer = letsPlayer,
								game = gameProj:getName()
							}, 1)
						end
						
						index = index + 1
					else
						letsPlayer:removeGame(gameProj)
						table.remove(lpData.active, index)
					end
				else
					index = index + 1
				end
			end
			
			lpData.viewData[#lpData.viewData + 1] = viewsThisWeek
			lpData.peakViews = math.max(lpData.peakViews, viewsThisWeek)
			
			if #lpData.active == 0 then
				local popup = gui.create("DescboxPopup")
				
				popup:setWidth(600)
				
				local wrapWidth = popup.rawW - 20
				
				popup:setFont("pix24")
				popup:setTextFont("pix20")
				popup:setTitle(_T("LETS_PLAY_RESULTS_TITLE", "'Let's Play' Results"))
				popup:setText(_format(_T("LETS_PLAY_RESULTS_DESC", "The online video makers you've contacted have finished making their playthrough video series for your 'GAME' game."), "GAME", gameProj:getName()))
				
				local left, right, extra = popup:getDescboxes()
				
				left:addSpaceToNextText(10)
				right:addSpaceToNextText(10)
				left:addText(_format(_T("LETS_PLAY_TOTAL_VIEWS", "Total views: VIEWS"), "VIEWS", string.roundtobignumber(lpData.totalViews)), "bh20", nil, 0, wrapWidth)
				left:addText(_format(_T("LETS_PLAY_PEAK_VIEWS", "Peak views: VIEWS"), "VIEWS", string.roundtobignumber(lpData.peakViews)), "bh20", nil, 5, wrapWidth)
				left:addText(_format(_T("LETS_PLAY_EXTRA_VIDEOS", "Extra videos: EXTRA"), "EXTRA", lpData.extraVideoCount), "bh20", nil, 0, wrapWidth, "increase", 22, 22)
				right:addText(_format(_T("LETS_PLAY_TOTAL_LPS", "Total LPs: TOTAL"), "TOTAL", lpData.totalVideos), "bh20", nil, 0, wrapWidth)
				right:addText(_format(_T("LETS_PLAY_POPULARITY_GAIN", "Popularity gain: POP pts."), "POP", string.roundtobignumber(lpData.totalPopularityGained)), "bh20", nil, 0, wrapWidth)
				right:addText(_format(_T("LETS_PLAY_TOTAL_CHANNELS", "Total channels: CHANNELS"), "CHANNELS", lpData.totalLetsPlayers), "bh20", nil, 0, wrapWidth)
				
				if lpData.completionPenalty then
					extra:addTextLine(popup.w - _S(20), game.UI_COLORS.UI_PENALTY_LINE)
					extra:addText(_T("LETS_PLAY_COMPLETION_PENALTY", "Lower efficiency due to incomplete game"), "bh20", game.UI_COLORS.RED, 0, wrapWidth, "exclamation_point_red", 22, 22)
				end
				
				gameProj:setFact(self.dataFact, nil)
				gameProj:removeActiveAdvertisement(self.id)
				events:fire(letsPlays.EVENTS.PLAYTHROUGH_OVER, gameProj)
				
				gameProj.letsPlayViewDisplay = nil
				
				popup:addOKButton("pix20")
				popup:center()
				frameController:push(popup)
			else
				events:fire(letsPlays.EVENTS.PLAYTHROUGH_PROGRESSED, gameProj)
			end
		end
	end
end

function letsPlays:clearLetsPlayers()
	self.listOfLetsPlayers = nil
end

local function lpFramePostKill(self)
	letsPlays:clearLetsPlayers()
end

function letsPlays:onSelected(gameProj)
	local frame = gui.create("Frame")
	
	frame:setSize(535, 600)
	frame:setFont("pix24")
	frame:setTitle(_T("PLAYTHROUGH_VIDEOS_TITLE", "Playthrough Videos"))
	
	frame.postKill = lpFramePostKill
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(525, 525)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setAdjustElementSize(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:addDepth(100)
	
	self.listOfLetsPlayers = {}
	
	for key, letsPlayer in ipairs(letsPlayers:getLetsPlayers()) do
		letsPlayer:updateBusyState()
		
		local selection = gui.create("LetsPlayerSelection")
		
		selection:setSize(525, 0)
		selection:setProject(gameProj)
		selection:setLetsPlayer(letsPlayer)
		selection:setList(self.listOfLetsPlayers)
		scrollbar:addItem(selection)
	end
	
	local baseY = scrollbar.y + _S(5) + scrollbar.h
	local costDisplay = gui.create("LetsPlayCostDisplay", frame)
	
	costDisplay:setSize(scrollbar.rawW * 0.5 - 5, 30)
	costDisplay:setFont("bh24")
	costDisplay:setPos(_S(5), baseY)
	costDisplay:setCost(0)
	
	local confirmButton = gui.create("ConfirmLetsPlayButton", frame)
	
	confirmButton:setSize(scrollbar.rawW * 0.5 - 5, 30)
	confirmButton:setFont("bh26")
	confirmButton:setText(_T("CONFIRM", "Confirm"))
	confirmButton:setPos(costDisplay.x + _S(5) + costDisplay.w, baseY)
	confirmButton:setProject(gameProj)
	costDisplay:setConfirmButton(confirmButton)
	confirmButton:setCostDisplay(costDisplay)
	frame:center()
	frameController:push(frame)
end

advertisement:registerNew(letsPlays)
