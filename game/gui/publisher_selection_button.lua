local publisher = {}

publisher.skinTextFillColor = color(220, 220, 220, 255)
publisher.skinTextHoverColor = color(240, 240, 240, 255)
publisher.skinTextSelectColor = color(255, 255, 255, 255)
publisher.skinTextDisableColor = color(150, 150, 150, 255)
publisher.EVENTS = {
	ON_SELECTED = events:new()
}

function publisher:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(200)
	self.descriptionBox:setPos(0, _S(3))
end

function publisher:setProject(proj)
	self.project = proj
end

function publisher:setContractor(contractor)
	self.contractor = contractor
	
	self:updateDescbox()
	self:setHeight(_US(self.descriptionBox:getHeight()) + 6)
end

function publisher:isDisabled()
	return not self.contractor:canPublishGame(self.project)
end

function publisher:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
end

function publisher:selectPublisherCallback()
	frameController:pop()
	self.contractor:queueGamePublishingEvaluation(self.project)
	
	local popup = game.createPopup(600, _T("SENT_REQUEST_TO_PUBLISHER_TITLE", "Sent Request to Publisher"), _format(_T("SENT_REQUEST_TO_PUBLISHER_DESC", "You've sent a game publishing offer to PUBLISHER. Expect a reply within a couple of days."), "PUBLISHER", self.contractor:getName()), "pix24", "pix20", nil)
	
	frameController:push(popup)
end

function publisher:fillInteractionComboBox(comboBox)
	local option = comboBox:addOption(0, 0, 0, 24, _T("SELECT", "Select"), fonts.get("pix20"), publisher.selectPublisherCallback)
	
	option.contractor = self.contractor
	option.project = self.project
end

function publisher:updateDescbox()
	local textColor = self:isDisabled() and game.UI_COLORS.GREY or game.UI_COLORS.WHITE
	local wrapWidth = 375
	local lineWidth = _S(wrapWidth)
	
	self.descriptionBox:removeAllText()
	self.descriptionBox:addTextLine(lineWidth, gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.contractor:getName(), "pix24", textColor, 6, wrapWidth)
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("PUBLISHER_MINIMUM_REPUTATION", "Minimum reputation: REP"), "REP", string.comma(self.contractor:getData().publishing.minimumReputation)), "bh20", textColor, 0, wrapWidth, "star", 24, 24)
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("PUBLISHER_MINIMUM_EMPLOYEES", "Minimum employees: EMP"), "EMP", self.contractor:getMinimumEmployees()), "bh20", textColor, 0, wrapWidth, "employees", 24, 24)
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("PUBLISHER_CONTRACT_COUNT", "Past contracts: CONTRACTS"), "CONTRACTS", self.contractor:getContractCount()), "bh20", textColor, 0, wrapWidth)
	
	if self:isDisabled() then
		local publishState = self.contractor:getPublishingState(self.project)
		
		if publishState == contractor.PUBLISHING_EVALUATION_STATES.EVALUATING then
			self.descriptionBox:addSpaceToNextText(5)
			self.descriptionBox:addTextLine(lineWidth, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
			self.descriptionBox:addText(_T("PUBLISHER_WAITING_FOR_REPLY", "Waiting for reply"), "bh20", nil, 0, wrapWidth, "question_mark", 26, 26)
		else
			self.descriptionBox:addSpaceToNextText(5)
			self.descriptionBox:addTextLine(lineWidth, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
			self.descriptionBox:addText(_T("PUBLISHER_CONTRACT_NOT_POSSIBLE", "Contract not possible"), "bh20", nil, 0, wrapWidth, "exclamation_point_red", 26, 26)
		end
	end
end

function publisher:onMouseEntered()
	publisher.baseClass.onMouseEntered(self)
	
	if self:isDisabled() then
		local publishState = self.contractor:getPublishingState(self.project)
		
		self.descBox = gui.create("GenericDescbox")
		
		if publishState == contractor.PUBLISHING_EVALUATION_STATES.DECLINED then
			self.descBox:addText(_T("PUBLISHER_DECLINED", "This publisher is not willing to publish your game."), "bh20", nil, 0, 500)
		elseif publishState == contractor.PUBLISHING_EVALUATION_STATES.PLAYER_DECLINED then
			self.descBox:addText(_T("PUBLISHER_PLAYER_DECLINED", "You've declined this publisher's contract."), "bh20", nil, 0, 500)
		end
		
		self.descBox:centerToElement(self)
	end
end

function publisher:onMouseLeft()
	publisher.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("PublisherSelectionButton", publisher, "GenericElement")
