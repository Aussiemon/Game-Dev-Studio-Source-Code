local projectEvPopup = {}

function projectEvPopup:setProject(proj)
	self.project = proj
end

function projectEvPopup:setContractor(curContractor)
	local wrapWidth = self.rawW
	local data = self.project:getContractData()
	local minimum, offered, real = curContractor:getMinimumShares(), data:getOfferedShares(), data:getFinalShares()
	
	self.leftDescbox:addText(_format(_T("CONTRACT_MINIMUM_RATING", "Minimum rating - RATING/MAX"), "RATING", data:getTargetRating(), "MAX", review.maxRating), "pix20", nil, 0, wrapWidth, "star", 26, 26)
	self.leftDescbox:addText(_format(_T("CONTRACT_REVIEW_RATING", "Review rating - RATING/MAX"), "RATING", self.project:getReviewRating(), "MAX", math.round(review.maxRating)), "pix20", nil, 0, wrapWidth, "star", 26, 26)
	
	local overDeadlinePenalty = curContractor:getOverDeadlinePenalty(data)
	
	if overDeadlinePenalty > 0 then
		self.leftDescbox:addText(_format(_T("CONTRACT_OVER_DEADLINE", "Late by TIME"), "TIME", timeline:getTimePeriodText(data:getDaysOverDeadline())), "pix20", game.UI_COLORS.LIGHT_RED, 0, wrapWidth, "red_cross", 26, 26)
		self.leftDescbox:addText(_format(_T("CONTRACT_DEADLINE_PENALTY", "Share penalty: PENALTY%"), "PENALTY", math.round(overDeadlinePenalty * 100, 1)), "pix20", game.UI_COLORS.LIGHT_RED, 0, wrapWidth, {
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
	else
		self.leftDescbox:addText(_T("CONTRACT_DEADLINE_ON_TIME", "Released on time"), "pix20", nil, 0, wrapWidth, "checkmark", 26, 26)
	end
	
	self.rightDescbox:addText(_format(_T("CONTRACT_MIN_SHARES", "Minimum shares: SHARE%"), "SHARE", math.round(minimum * 100, 1)), "pix20", nil, 0, wrapWidth, "percentage_red", 26, 26)
	self.rightDescbox:addText(_format(_T("CONTRACT_OFFERED_SHARES", "Offered shares: SHARE%"), "SHARE", math.round(offered * 100, 1)), "pix20", nil, 0, wrapWidth, "percentage", 26, 26)
	self.rightDescbox:addText(_format(_T("CONTRACT_FINAL_SHARES", "Final shares: SHARE%"), "SHARE", math.round(real * 100, 1)), "pix20", nil, 0, wrapWidth, "percentage", 26, 26)
	
	local shareText
	
	if real == minimum then
		shareText = _T("CONTRACTOR_WILL_PAY_MINIMUM_SHARES", "The contractor will pay you a minimum of SHARE% per sale, as agreed.")
	elseif offered <= real then
		shareText = _T("CONTRACTOR_WILL_PAY_MAXIMUM_SHARES", "The contractor is happy and will pay you SHARE% per sale, as agreed.")
	else
		shareText = _T("CONTRACTOR_WILL_PAY_LESS_SHARES", "The contractor will pay you SHARE% per each sale.")
	end
	
	self.extraInfo:addSpaceToNextText(10)
	
	shareText = _format(shareText, "SHARE", math.round(real * 100, 1))
	
	self.extraInfo:addText(shareText, "bh22", nil, 0, wrapWidth - 10)
	self.extraInfo:addSpaceToNextText(10)
	self.extraInfo:addText(_T("SHARES_WILL_BE_PAID_OUT_ON_RECOUP", "The contractor will pay shares out once the game sales cover development funding costs."), "bh20", nil, 0, wrapWidth - 10, "question_mark", 24, 24)
end

gui.register("ProjectEvaluationPopup", projectEvPopup, "DescboxPopup")
