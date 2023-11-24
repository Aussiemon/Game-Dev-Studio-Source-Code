local platformDiscontinuePenalty = {}

platformDiscontinuePenalty.id = "platform_discontinue_penalty"
platformDiscontinuePenalty.inactive = true

function platformDiscontinuePenalty:validateEvent()
	return true
end

function platformDiscontinuePenalty:activate()
	platformDiscontinuePenalty.baseClass.activate(self)
	
	local repLoss = 0
	local life = self.life
	local time = self.time
	
	if time > 0 then
		local scalar = time / playerPlatform.TIME_UNTIL_NO_DISCONTINUE_PENALTY
		
		repLoss = playerPlatform.REP_LOSS_PER_SALE * scalar
	end
	
	local shutdownPenalty = false
	
	if self.platform:isEarlyDiscontinuation() then
		repLoss = math.max(playerPlatform.MIN_REP_LOSS, repLoss * playerPlatform.LIFE_SHUTDOWN_PENALTY_MULT)
		shutdownPenalty = true
	end
	
	if repLoss > 0 then
		local realRepLoss = math.min(studio:getReputation() * playerPlatform.LIFE_REPUTATION_LOSS, repLoss * self.sales)
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("MMO_SHUTDOWN_FANS_DISAPPOINTED_TITLE", "Fans Disappointed"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("PLATFORM_DISCONTINUE_FANS_DISAPPOINTED", "The recent discontinuation of 'PLATFORM' has left fans disappointed, since they weren't expecting a discontinuation this soon."), "PLATFORM", self.platform:getName()))
		popup:setShowSound("bad_jingle")
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("PLATFORM_DISCONTINUE_REPUTATION_LOSS", "This has cost you REPLOSS reputation points."), "REPLOSS", string.comma(realRepLoss)), "bh20", nil, 0, popup.rawW - 30, "exclamation_point_red", 22, 22)
		
		if shutdownPenalty then
			extra:addSpaceToNextText(5)
			extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("PLATFORM_EARLY_SHUTDOWN_PENALTY", "Discontinuing the platform shortly after release has cost you additional reputation points."), "REPLOSS", string.comma(realRepLoss)), "bh20", nil, 0, popup.rawW - 30, "exclamation_point_red", 22, 22)
		end
		
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		studio:decreaseReputation(realRepLoss)
	end
end

function platformDiscontinuePenalty:canActivateLoad()
	return false
end

function platformDiscontinuePenalty:canActivate()
	return timeline.curTime >= self.activationDate
end

function platformDiscontinuePenalty:setSales(sales)
	self.sales = sales
end

function platformDiscontinuePenalty:setLife(life)
	self.life = life
end

function platformDiscontinuePenalty:setPlatform(proj)
	self.platform = proj
end

function platformDiscontinuePenalty:setRemainingTime(time)
	self.time = time
end

function platformDiscontinuePenalty:setActivationDate(date)
	self.activationDate = date
end

function platformDiscontinuePenalty:save()
	local saved = platformDiscontinuePenalty.baseClass.save(self)
	
	saved.platID = self.platform:getID()
	saved.time = self.time
	saved.activationDate = self.activationDate
	saved.life = self.life
	saved.sales = self.sales
	
	return saved
end

function platformDiscontinuePenalty:load(data)
	self.platform = studio:getPlatformByID(data.platID)
	self.time = data.time
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
	self.life = data.life
	self.sales = data.sales
end

scheduledEvents:registerNew(platformDiscontinuePenalty)
