local reviewerSelect = {}

reviewerSelect.skinPanelFillColor = color(86, 104, 135, 255)
reviewerSelect.skinPanelHoverColor = color(163, 176, 198, 255)
reviewerSelect.skinPanelSelectColor = color(125, 175, 125, 255)
reviewerSelect.skinPanelDisableColor = color(40, 40, 40, 255)
reviewerSelect.skinTextFillColor = color(220, 220, 220, 255)
reviewerSelect.skinTextHoverColor = color(240, 240, 240, 255)
reviewerSelect.skinTextSelectColor = color(255, 255, 255, 255)
reviewerSelect.skinTextDisableColor = color(150, 150, 150, 255)
reviewerSelect.EVENTS = {
	ON_SELECTED = events:new()
}

function reviewerSelect:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	self.confirmButton:setTarget(self.reviewer, not self.confirmButton:isInvited(self.reviewer))
	
	self.active = self.confirmButton:isInvited(self.reviewer)
	
	self:queueSpriteUpdate()
	events:fire(reviewerSelect.EVENTS.ON_SELECTED, self.reviewer)
end

function reviewerSelect:isDisabled()
	return timeline.curTime < self.reviewer:getInterviewInviteCooldown() or not self.reviewer:canOfferInterview(self.project)
end

function reviewerSelect:isOn()
	return self.active
end

function reviewerSelect:updateSprites()
	reviewerSelect.baseClass.updateSprites(self)
	
	self.checkboxSprite = self:allocateSprite(self.checkboxSprite, self.active and "checkbox_on" or "checkbox_off", self.w - _S(28), _S(5), 0, 22, 22, 0, 0, -0.4)
end

function reviewerSelect:updateDescbox()
	local textColor = self:isDisabled() and game.UI_COLORS.GREY or game.UI_COLORS.WHITE
	
	self.descriptionBox:removeAllText()
	
	local wrapWidth = self.rawW - 80
	local lineWidth = self.w - _S(80)
	
	self.descriptionBox:addSpaceToNextText(3)
	self.descriptionBox:addTextLine(self.w - _S(110), gui.genericMainGradientColor, _S(24), "weak_gradient_horizontal")
	self.descriptionBox:addText(self.reviewer:getName(), "pix24", textColor, 7, wrapWidth)
	
	local textLineHeight = _S(26)
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("INTERVIEW_CHANCE", "Interview chance: CHANCE%"), "CHANCE", math.round(self.reviewer:getInterviewChance(), 1)), "bh20", textColor, 1, wrapWidth, {
		{
			width = 24,
			icon = "percentage",
			x = 2,
			height = 24
		}
	})
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("INTERVIEW_POPULARITY", "Popularity: POPULARITY%"), "POPULARITY", math.round(self.reviewer:getData().popularity * 100)), "bh20", textColor, 0, wrapWidth, {
		{
			width = 24,
			icon = "efficiency",
			x = 2,
			height = 24
		}
	})
	self.descriptionBox:setX(self.descriptionBox.h - _S(8))
end

function reviewerSelect:setupHoverDescBox()
	for key, descData in ipairs(self.reviewer:getDescription()) do
		self.descBox:addText(descData.text, descData.font, descData.color, descData.lineSpace, 500)
	end
	
	if not self.reviewer:canOfferInterview(self.project) then
		self.descBox:addSpaceToNextText(5)
		self.descBox:addText(_T("INTERVIEW_ALREADY_INVITED", "You already have an interview booked with this community."), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, 500, "question_mark", 24, 24)
	elseif self:isDisabled() then
		self.descBox:addSpaceToNextText(5)
		self.descBox:addText(_format(_T("INTERVIEW_INVITE_COOLDOWN", "You must wait TIME before inviting this community for an interview again."), "TIME", timeline:getTimePeriodText(self.reviewer:getInterviewInviteCooldown() - timeline.curTime)), "bh20", game.UI_COLORS.RED, 0, 500, "question_mark", 24, 24)
	end
end

gui.register("InterviewReviewerSelectionButton", reviewerSelect, "BribeReviewerSelectionButton")
