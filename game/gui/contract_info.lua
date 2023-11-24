local contractInfo = {}

contractInfo.extraInfoColor = color(140, 180, 206, 255)
contractInfo.saleInfoColor = color(184, 206, 171, 255)
contractInfo.categoryColor = color(201, 206, 171, 255)

function contractInfo:showDisplay(projectObject)
	local contractor = projectObject:getContractor() or projectObject:getPublisher()
	local contractData = projectObject:getContractData()
	local saleMoney = contractData:getSaleMoney()
	local deadline = contractData:getDeadline()
	local isPublishing = contractData:isPublishing()
	
	self:addText(_T("CONTRACT_INFO", "Contract info"), "pix24", self.categoryColor, 5, 300)
	self:addText(_format(_T("CONTRACT_DEADLINE", "Deadline - YEAR/MONTH"), "YEAR", timeline:getYear(deadline), "MONTH", timeline:getMonth(deadline)), "pix20", nil, 4, 300, "clock_full", 20, 20)
	
	local releaseDate = projectObject:getReleaseDate()
	
	if releaseDate then
		self:addText(_format(_T("CONTRACT_GAME_RELEASE_DATE", "Released on - YEAR/MONTH"), "YEAR", timeline:getYear(releaseDate), "MONTH", timeline:getMonth(releaseDate)), "pix20", nil, 4, 300, "clock_full", 20, 20)
	end
	
	self:addText(_format(_T("CONTRACT_REACHED_MILESTONES", "Reached milestones: MILESTONES"), "MILESTONES", contractData:getReachedMilestones()), "pix20", nil, 4, 300, "checkmark", 20, 20)
	
	local reviewRating = projectObject:getReviewRating()
	
	if reviewRating ~= 0 then
		self:addText(_format(_T("CONTRACT_AVERAGE_RATING", "Average rating: CURRENT/MAXIMUM"), "CURRENT", reviewRating, "MAXIMUM", review.maxRating), "pix20", nil, 4, 300, "star", 20, 20)
	end
	
	self:addSpaceToNextText(8)
	self:addText(_T("CONTRACT_FINANCES_AND_PAYMENTS_INFO", "Financing & payments"), "pix24", self.categoryColor, 4, 300)
	
	local totalPayments = contractData:getMoneyGivenToStudio()
	
	if totalPayments > 0 then
		self:addText(_format(_T("CONTRACT_TOTAL_PAYMENTS", "Total payments: PAYMENTS"), "PAYMENTS", string.roundtobigcashnumber(totalPayments)), "pix20", nil, 4, 300, "wad_of_cash_plus", 20, 20)
	end
	
	local instaCash = contractData:getInstantCash()
	
	if instaCash then
		self:addText(_format(_T("CONTRACT_ADVANCE_PAYMENT", "Advance payment: PAYMENT"), "PAYMENT", string.roundtobigcashnumber(instaCash)), "pix20", nil, 4, 300, "wad_of_cash_plus", 20, 20)
	end
	
	if not contractData:getLastMilestoneReached() then
		local nextMilestone = contractData:getMilestoneDate()
		
		self:addText(_format(_T("CONTRACT_NEXT_MILESTONE", "Next milestone: YEAR/MONTH"), "YEAR", timeline:getYear(nextMilestone), "MONTH", timeline:getMonth(nextMilestone)), "pix20", nil, 4, 300, "clock_full", 20, 20)
	end
	
	self:addText(_format(_T("CONTRACT_COPY_PRICE", "Game price: $PRICE"), "PRICE", projectObject:getPrice()), "bh18", self.saleInfoColor, 4, 300, "game_copy_price", 20, 20)
	
	if saleMoney > 0 then
		self:addText(_format(_T("CONTRACT_SALES", "Sales: SALES"), "SALES", string.roundtobigcashnumber(saleMoney)), "bh18", self.saleInfoColor, 4, 300, "wad_of_cash", 20, 20)
		
		if not isPublishing then
			if contractData:hasEvaluatedProject() then
				self:addText(_format(_T("CONTRACT_YOUR_SHARE", "Your share: SHARE"), "SHARE", string.roundtobigcashnumber(contractData:getPlayersShare())), "bh18", self.saleInfoColor, 4, 300, "wad_of_cash_plus", 20, 20)
			else
				self:addText(_T("CONTRACT_YOUR_SHARE_UNKNOWN", "Your share: ???"), "bh18", self.saleInfoColor, 4, 300, "wad_of_cash_plus", 20, 20)
			end
		else
			self:addText(_format(_T("CONTRACT_YOUR_SHARE", "Your share: SHARE"), "SHARE", string.roundtobigcashnumber(projectObject:getShareMoney())), "bh18", self.saleInfoColor, 4, 300, "wad_of_cash_plus", 20, 20)
		end
	end
	
	self:addSpaceToNextText(8)
	self:addText(_T("CONTRACT_TERMS_AND_CONDITIONS", "Terms & conditions"), "pix24", self.categoryColor, 4, 300)
	
	local targetRating = contractData:getTargetRating()
	
	if targetRating then
		self:addText(_format(_T("CONTRACT_DESIRED_RATING", "Minimum rating - MINIMUM/MAXIMUM"), "MINIMUM", contractData:getTargetRating(), "MAXIMUM", review.maxRating), "pix20", nil, 0, 300, "star", 20, 20)
	end
	
	self:addText(_format(_T("CONTRACT_RECEIVED_RATING", "Received rating - RATING/MAXIMUM"), "RATING", projectObject:getReviewRating(), "MAXIMUM", review.maxRating), "pix20", nil, 0, 300, "star", 20, 20)
	
	local offeredShares = contractData:getOfferedShares()
	
	if offeredShares then
		self:addText(_format(_T("CONTRACT_SHARE_PER_SALE", "Share per sale: SHARE%"), "SHARE", math.round(offeredShares * 100)), "pix20", nil, 2, 300, "percentage", 20, 20)
	end
	
	self:addText(_format(_T("CONTRACT_MIN_SHARES", "Minimum shares: SHARE%"), "SHARE", math.round(contractor:getMinimumShares() * 100)), "pix20", nil, 2, 300, "percentage", 20, 20)
	
	local final = contractData:getFinalShares()
	local formatText = final > 0 and math.round(final * 100) or _T("THREE_QUESTION_MARKS", "???")
	
	self:addText(_format(_T("CONTRACT_FINAL_SHARES", "Final shares: SHARE%"), "SHARE", formatText), "pix20", nil, 2, 300, "percentage", 20, 20)
	self:show()
end

function contractInfo:hideDisplay()
	self:removeAllText()
	self:hide()
end

gui.register("ContractInfo", contractInfo, "GenericDescbox")
