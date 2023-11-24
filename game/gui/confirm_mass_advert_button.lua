local massAdvert = {}

function massAdvert:init()
	self:setFont(fonts.get("pix20"))
	self:setText(_T("CONFIRM", "Confirm"))
	
	self.activeAdvertTypes = 0
	self.totalCost = 0
	self.budgetPercentage = 1
	self.rounds = 1
	self.advertTypes = {}
end

function massAdvert:setTarget(target)
	self.inviteTarget = target
end

function massAdvert:getTarget()
	return self.inviteTarget
end

function massAdvert:setProject(proj)
	self.project = proj
end

function massAdvert:setCostDisplay(display)
	self.costDisplay = display
	
	self.costDisplay:setCost(0)
end

function massAdvert:setBudgetPercentage(perc)
	self.budgetPercentage = perc
	
	self:updateTotalCost()
end

function massAdvert:setRounds(rounds)
	self.rounds = rounds
	
	self:updateTotalCost()
end

function massAdvert:toggleAdvertTypeState(advertType, state)
	if state ~= nil then
		self:setAdvertTypeState(advertType, state)
		
		return 
	end
	
	if not table.find(self.advertTypes, advertType) then
		self:setAdvertTypeState(advertType, true)
	else
		self:setAdvertTypeState(advertType, false)
	end
end

function massAdvert:getAdvertTypes()
	return self.advertTypes
end

function massAdvert:isAdvertTypeOn(adID)
	return table.find(self.advertTypes, adID)
end

function massAdvert:setAdvertTypeState(advertType, state)
	if state then
		table.insert(self.advertTypes, advertType)
	else
		table.removeObject(self.advertTypes, advertType)
	end
	
	self:updateTotalCost()
end

function massAdvert:updateTotalCost()
	self.totalCost = 0
	self.revealedBasePopularity = 0
	
	local advert = advertisement:getData("mass_advertisement")
	local additionalAdvertOptionsByID = advert.additionalAdvertOptionsByID
	local budget = self.budgetPercentage
	local rounds = self.rounds
	local revealedAdverts = studio:getFact(advert.revealedAdvertisementsFact)
	local revealedTypes = 0
	
	for key, adType in ipairs(self.advertTypes) do
		local data = additionalAdvertOptionsByID[adType]
		
		self.totalCost = self.totalCost + math.floor(data.cost * budget)
		
		if revealedAdverts and revealedAdverts[data.id] then
			self.revealedBasePopularity = self.revealedBasePopularity + advert:getPopularityGain(data, budget, rounds)
			revealedTypes = revealedTypes + 1
		end
	end
	
	self.revealedAdvertTypes = revealedTypes
	self.totalCost = self.totalCost * rounds
	self.activeAdvertTypes = #self.advertTypes
	
	self.costDisplay:setCost(self.totalCost)
	
	if self.infoDescbox then
		self.infoDescbox:updateDisplay()
	end
end

function massAdvert:getRevealedAdvertTypes()
	return self.revealedAdvertTypes
end

function massAdvert:setDescbox(box)
	self.infoDescbox = box
	
	self.infoDescbox:setConfirmButton(self)
	self.infoDescbox:updateDisplay()
end

function massAdvert:getRevealedBasePopularity()
	return self.revealedBasePopularity
end

function massAdvert:getTotalCost()
	return self.totalCost
end

function massAdvert:getActiveAdvertTypes()
	return self.activeAdvertTypes
end

function massAdvert:getRounds()
	return self.rounds
end

function massAdvert:isDisabled()
	if not self.project or self.activeAdvertTypes == 0 or studio:getFunds() < self.totalCost then
		return true
	end
	
	return false
end

function massAdvert:onMouseEntered()
	massAdvert.baseClass.onMouseEntered(self)
	
	if not studio:hasFunds(self.totalCost) then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("CANT_AFFORD_MASS_ADVERTISEMENT", "Can not afford the selected advertisement campaign."), "pix22", game.UI_COLORS.RED, 4, 600, "question_mark_red", 24, 24)
		self.descBox:addText(_format(_T("MISSING_AMOUNT_OF_MONEY", "You are missing AMOUNT."), "AMOUNT", string.roundtobigcashnumber(self.totalCost - studio:getFunds())), "pix20", game.UI_COLORS.LIGHT_RED, 0, 600, "wad_of_cash_minus", 24, 24)
		self.descBox:centerToElement(self)
	end
end

function massAdvert:onMouseLeft()
	massAdvert.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function massAdvert:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	local data = advertisement:getData("mass_advertisement")
	
	data:applyCampaignDataToGame(self.project, self.advertTypes, self.totalCost, self.budgetPercentage, self.rounds)
	
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("CAMPAIGN_STARTED_TITLE", "Campaign Started"))
	popup:setText(_format(_T("CAMPAIGN_STARTED_DESC", "A mass advertisement campaign has been started. \nThe game will amass popularity over the course of TIME."), "TIME", data:getDurationText(#self.advertTypes, self.rounds)))
	popup:setOnKillCallback(game.genericClearFrameControllerCallback)
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"), nil)
	popup:center()
	frameController:push(popup)
	studio:deductFunds(self.totalCost, nil, "marketing")
	self.project:changeMoneySpent(self.totalCost)
end

function massAdvert:draw(w, h)
	massAdvert.baseClass.draw(self, w, h)
end

gui.register("ConfirmMassAdvertButton", massAdvert, "Button")
