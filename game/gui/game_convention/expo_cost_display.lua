local expoCostDisplay = {}

expoCostDisplay.displayOwnFunds = true

function expoCostDisplay:setConventionData(data)
	self.conventionData = data
	
	self:setPreviousPayment(self.conventionData:getPaidFee())
end

function expoCostDisplay:setupDescBox()
	local total, entryFee, boothCost, staffCost, realFee = self.conventionData:getDesiredFee()
	
	self.descBox = gui.create("GenericDescbox")
	
	local wrapWidth = 320
	
	if total > 0 then
		if realFee ~= total then
			if realFee < 0 then
				self.descBox:addText(string.easyformatbykeys(_T("EXPO_COST_TOTAL_WITH_REIMBURSEMENT", "Total cost: COST (REAL reimbursement)"), "COST", string.roundtobigcashnumber(total), "REAL", string.roundtobigcashnumber(math.abs(realFee))), "pix20", nil, 0, wrapWidth)
			else
				self.descBox:addText(string.easyformatbykeys(_T("EXPO_COST_TOTAL_WITH_RAISE", "Total cost: COST (REAL)"), "COST", string.roundtobigcashnumber(total), "REAL", string.roundtobigcashnumber(realFee)), "pix20", nil, 0, wrapWidth)
			end
		else
			self.descBox:addText(string.easyformatbykeys(_T("EXPO_COST_TOTAL", "Total cost: COST"), "COST", string.roundtobigcashnumber(total)), "pix20", nil, 0, wrapWidth)
		end
		
		if realFee ~= total then
			self.descBox:addSpaceToNextText(3)
			self.descBox:addText(string.easyformatbykeys(_T("EXPO_COST_ALREADY_PAID_BEFORE", "You have already paid AMOUNT prior to this."), "AMOUNT", string.roundtobigcashnumber(self.conventionData:getPaidFee())), "pix18", game.UI_COLORS.IMPORTANT_1, 0, wrapWidth)
		end
		
		if not studio:hasFunds(self:getRealCost()) then
			self.descBox:addText(_T("EXPO_COST_NOT_ENOUGH_MONEY", "You do not have enough money."), "pix18", self.notEnoughMoneyColor, 0, wrapWidth)
		end
		
		self.descBox:addSpaceToNextText(3)
		self.descBox:addText(string.easyformatbykeys(_T("EXPO_COST_ENTRY", "Entry fee: COST"), "COST", string.roundtobigcashnumber(entryFee)), "pix18", game.UI_COLORS.IMPORTANT_3, 0, wrapWidth)
		self.descBox:addText(string.easyformatbykeys(_T("EXPO_COST_BOOTH", "Booth space rental & construction: COST"), "COST", string.roundtobigcashnumber(boothCost)), "pix18", game.UI_COLORS.IMPORTANT_3, 0, wrapWidth)
		self.descBox:addText(string.easyformatbykeys(_T("EXPO_COST_STAFF", "External staff: COST"), "COST", string.roundtobigcashnumber(staffCost)), "pix18", game.UI_COLORS.IMPORTANT_3, 0, wrapWidth)
		
		if staffCost > 0 then
			self.descBox:addSpaceToNextText(5)
			self.descBox:addText(_T("EXPO_COST_STAFF_HINT", "You can lower staff cost to zero by filling out the booth staff with your own employees."), "bh16", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "question_mark", 20, 20)
		end
	else
		self.descBox:addText(_T("PLEASE_SELECT_EXPO_BOOTH", "Please select the booth size first."), "pix20", nil, 0, wrapWidth)
	end
	
	self.descBox:centerToElement(self)
end

function expoCostDisplay:handleEvent(event)
	if event == gameConventions.EVENTS.BOOTH_CHANGED or event == gameConventions.EVENTS.PARTICIPANT_ADDED or event == gameConventions.EVENTS.PARTICIPANT_REMOVED or event == gameConventions.EVENTS.GAME_TO_PRESENT_ADDED or event == gameConventions.EVENTS.GAME_TO_PRESENT_REMOVED or event == gameConventions.EVENTS.BOOTH_CHANGED then
		self:updateCost()
	end
end

function expoCostDisplay:updateCost()
	self:setCost(self.conventionData:getDesiredFee())
end

gui.register("ExpoCostDisplay", expoCostDisplay, "CostDisplay")
