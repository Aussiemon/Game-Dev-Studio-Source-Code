local customerSup = {}

function customerSup:handleEvent()
	self:queueSpriteUpdate()
	self:updateText()
end

function customerSup:getProgress()
	return math.min(1, studio:getCustomerSupportUsePercentage())
end

function customerSup:getBarColor()
	if self.overloaded then
		return game.UI_COLORS.RED
	end
	
	return self:isMouseOver() and self.progressBarHoverColor or self.progressBarColor
end

function customerSup:onMouseEntered()
	customerSup.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("CUSTOMER_SUPPORT_DESCRIPTION_1", "The customer support availability, as well as its use. Increases with MMO subscriptions."), "pix20", nil, 3, 400, "question_mark", 22, 22)
	self.descBox:addText(_T("CUSTOMER_SUPPORT_DESCRIPTION_2", "If the subscriptions exceed customer support, your players will begin losing happiness."), "bh18", nil, 0, 400)
	self.descBox:centerToElement(self)
end

function customerSup:onMouseLeft()
	customerSup.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function customerSup:updateText()
	local use, capacity = studio:getCustomerSupportUse(), studio:getCustomerSupportValue()
	
	if capacity < use then
		self.overloaded = true
	else
		self.overloaded = false
	end
	
	self.text = _format(_T("CUSTOMER_SUPPORT_DISPLAY", "Cust. support: CUR/MAX"), "CUR", string.roundtobignumber(use), "MAX", string.roundtobignumber(capacity))
	
	self:setIcon("customer_support", 16, 16)
end

gui.register("CustomerSupportBar", customerSup, "ProgressBarWithText")
