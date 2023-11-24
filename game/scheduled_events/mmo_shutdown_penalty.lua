local mmoShutdownPenalty = {}

mmoShutdownPenalty.id = "mmo_shutdown_penalty"
mmoShutdownPenalty.inactive = true
mmoShutdownPenalty.maxPenaltyLoss = 0.9

function mmoShutdownPenalty:validateEvent()
	return true
end

function mmoShutdownPenalty:activate()
	mmoShutdownPenalty.baseClass.activate(self)
	
	local logic = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
	local cutoff, repLoss = 0, 0
	local longevity = self.longevity
	
	if self.shutdownAnnounced then
		cutoff = logic.SHUTDOWN_NO_PENALTY_CUTOFF_ANNOUNCED
		repLoss = logic.SHUTDOWN_REP_LOSS_PER_SUB_ANNOUNCED
	else
		cutoff = logic.SHUTDOWN_NO_PENALTY_CUTOFF
		repLoss = logic.SHUTDOWN_REP_LOSS_PER_SUB
	end
	
	local extraPenaltyLoss = 0
	local shutdownPenalty = false
	
	if longevity / logic.OVERALL_LONGEVITY >= logic.LONGEVITY_SHUTDOWN_PENALTY then
		cutoff = 0
		repLoss = repLoss * logic.LONGEVITY_SHUTDOWN_PENALTY_MULT
		extraPenaltyLoss = logic.LONGEVITY_SHUTDOWN_PENALTY_BASE_LOSS
		shutdownPenalty = true
	end
	
	if cutoff < self.subscribers or extraPenaltyLoss > 0 then
		local realRepLoss = math.min(studio:getReputation() * self.maxPenaltyLoss, (self.subscribers - cutoff) * repLoss + extraPenaltyLoss)
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("MMO_SHUTDOWN_FANS_DISAPPOINTED_TITLE", "Fans Disappointed"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("MMO_SHUTDOWN_FANS_DISAPPOINTED", "The recent shutdown of game servers for 'GAME' has left the players disappointed, since they weren't expecting a shutdown this soon."), "GAME", self.project:getName()))
		popup:setShowSound("bad_jingle")
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("MMO_SHUTDOWN_REPUTATION_LOSS", "This has cost you REPLOSS reputation points."), "REPLOSS", string.comma(realRepLoss)), "bh20", nil, 0, popup.rawW - 30, "exclamation_point_red", 22, 22)
		
		if shutdownPenalty then
			extra:addSpaceToNextText(5)
			extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("MMO_EARLY_SHUTDOWN_PENALTY", "Shutting down the game servers shortly after release has cost you additional reputation points."), "REPLOSS", string.comma(realRepLoss)), "bh20", nil, 0, popup.rawW - 30, "exclamation_point_red", 22, 22)
		end
		
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		studio:decreaseReputation(realRepLoss)
	end
end

function mmoShutdownPenalty:canActivate()
	return timeline.curTime >= self.activationDate
end

function mmoShutdownPenalty:setLongevity(long)
	self.longevity = long
end

function mmoShutdownPenalty:setProject(proj)
	self.project = proj
end

function mmoShutdownPenalty:setSubsAtShutdown(subs)
	self.subscribers = subs
end

function mmoShutdownPenalty:setShutdownAnnounced(ann)
	self.shutdownAnnounced = ann
end

function mmoShutdownPenalty:setActivationDate(date)
	self.activationDate = date
end

function mmoShutdownPenalty:save()
	local saved = mmoShutdownPenalty.baseClass.save(self)
	
	saved.shutdownAnnounced = self.shutdownAnnounced
	saved.gameID = self.project:getUniqueID()
	saved.subscribers = self.subscribers
	saved.activationDate = self.activationDate
	saved.longevity = self.longevity
	
	return saved
end

function mmoShutdownPenalty:load(data)
	self.shutdownAnnounced = data.shutdownAnnounced
	self.project = studio:getProjectByUniqueID(data.gameID)
	self.subscribers = data.subscribers
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
	self.longevity = data.longevity
end

scheduledEvents:registerNew(mmoShutdownPenalty)
