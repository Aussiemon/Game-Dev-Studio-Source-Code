local ContractWorkPopup = {}

function ContractWorkPopup:addBottomText(text, font)
	self.extraInfo:addText(text, font, nil, 0, self.w - 10)
end

function ContractWorkPopup:setContractor(curContractor)
	self.contractor = curContractor
	
	local data = curContractor:getContractData()
	local deadline = data:getDeadline()
	local timeDelay = curContractor:getDelayPeriod()
	local wrapWidth = self.rawW - 10
	
	self.leftDescbox:addText(_format(_T("CONTRACT_GENRE", "Genre - GENRE"), "GENRE", genres:getData(data:getDesiredGenre()).display), "pix20", nil, 0, wrapWidth, {
		{
			height = 26,
			icon = "generic_backdrop",
			width = 26
		},
		{
			width = 20,
			height = 20,
			y = 1,
			icon = "gameplay_quality",
			x = 3
		}
	})
	self.leftDescbox:addText(_format(_T("CONTRACT_SCALE", "Game scale - xSCALE"), "SCALE", data:getScale()), "pix20", nil, 0, wrapWidth, "efficiency", 26, 26)
	self.leftDescbox:addText(_format(_T("CONTRACT_MINIMUM_RATING", "Minimum rating - RATING/MAX"), "RATING", data:getTargetRating(), "MAX", review.maxRating), "pix20", nil, 0, wrapWidth, "star", 26, 26)
	self.leftDescbox:addText(_format(_T("CONTRACT_DEADLINE", "Deadline - YEAR/MONTH"), "YEAR", timeline:getYear(deadline), "MONTH", timeline:getMonth(deadline)), "pix20", nil, 0, wrapWidth, {
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
	self.leftDescbox:addText(_format(_T("CONTRACT_GAME_COPY_PRICE", "Game copy price - $PRICE"), "PRICE", data:getPrice()), "pix20", nil, 0, wrapWidth, {
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
	
	local instantCash = string.comma(data:getInstantCash())
	
	self.rightDescbox:addText(_format(_T("CONTRACT_INSTANT_CASH", "Instant cash - $CASH"), "CASH", instantCash), "pix20", nil, 0, wrapWidth, {
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
	self.rightDescbox:addText(_format(_T("CONTRACT_MONTHLY_FUNDING", "Funding - $CASH/month"), "CASH", string.comma(data:getMonthlyFunding())), "pix20", nil, 0, wrapWidth, {
		{
			height = 26,
			icon = "generic_backdrop",
			width = 26
		},
		{
			width = 20,
			height = 20,
			y = 1,
			icon = "wad_of_cash_plus",
			x = 3
		}
	})
	self.rightDescbox:addText(_format(_T("CONTRACT_MAXIMUM_SHARES", "Your share - SHARE%"), "SHARE", math.round(data:getOfferedShares() * 100, 1)), "pix20", nil, 0, wrapWidth, "percentage", 26, 26)
	self.rightDescbox:addText(_format(_T("CONTRACT_MINIMUM_SHARES", "Minimum share - SHARE%"), "SHARE", math.round(curContractor:getMinimumShares() * 100, 1)), "pix20", nil, 0, wrapWidth, "percentage_red", 26, 26)
	self.rightDescbox:addText(_format(_T("CONTRACT_PENALTY_PAYOUT", "Penalty: $INSTANTCASH + MULT% of dev. cost"), "INSTANTCASH", instantCash, "MULT", math.round(curContractor:getPenaltyMultiplier() * 100)), "pix20", nil, 0, wrapWidth, "percentage_red", 26, 26)
	self.extraInfo:addText(_format(_T("CONTRACT_PENALTY_INFO", "The penalty will only be applied if the game sales don't cover MULT% of the development costs."), "MULT", math.round(curContractor:getDevCostMultiplier() * 100)), "bh22", nil, 0, wrapWidth, "question_mark", 26, 26)
end

gui.register("ContractWorkPopup", ContractWorkPopup, "DescboxPopup")
