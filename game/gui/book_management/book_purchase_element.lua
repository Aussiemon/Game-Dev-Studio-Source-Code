local bookPurchase = {}

bookPurchase.buttonPadVertical = 3
bookPurchase.buttonPadHorizontal = 4

function bookPurchase:onSizeChanged()
	bookPurchase.baseClass.onSizeChanged(self)
	
	if not self.bookBuy then
		self:createButtons()
	end
	
	self:positionButtons()
end

function bookPurchase:setBookData(bookData)
	bookPurchase.baseClass.setBookData(self, bookData)
	self:updateButtons()
end

function bookPurchase:getButtonY()
	return _S(self.gradientHeight) + _S(self.bookPad) + _S(self.buttonPadVertical) * 2
end

function bookPurchase:getButtonSize()
	local buttonY = self:getButtonY()
	local buttonHeight = _US(self.h - buttonY)
	local gradientX = self:getGradientStartPosition()
	local buttonWidth = _US(self.w - gradientX - self.buttonPadVertical * 4) / 2
	
	return buttonWidth, buttonHeight
end

function bookPurchase:positionButtons()
	local w, h = self:getButtonSize()
	local startX = self:getGradientStartPosition()
	local buttonY = self:getButtonY() - _S(self.buttonPadVertical)
	
	self.bookBuy:setPos(startX, buttonY)
	self.bookBuy:setSize(w, h)
	
	startX = startX + self.bookBuy.w + _S(self.buttonPadHorizontal)
	
	self.bookBuyPlace:setPos(startX, buttonY)
	self.bookBuyPlace:setSize(w, h)
end

function bookPurchase:onMouseEntered()
	bookPurchase.baseClass.onMouseEntered(self)
	
	local average, highest = bookController:getSkillLevelInfo()
	
	if self.bookData.skillBoost then
		local skillID = self.bookData.skillBoost.id
		local employeeCount, validRoleData = 0
		
		for key, employee in ipairs(bookController:getCurrentBookshelfObject():getOffice():getEmployees()) do
			local roleData = employee:getRoleData()
			
			if roleData:getMainSkill() == skillID then
				employeeCount = employeeCount + 1
				validRoleData = validRoleData or roleData
			end
		end
		
		local skillData = skills.registeredByID[skillID]
		local wrapWidth = 350
		
		self.descBox = gui.create("GenericDescbox")
		
		if employeeCount > 0 then
			validRoleData:addRoleEmploymentText(self.descBox, wrapWidth, employeeCount, _T("EMPLOYEE_COUNT_BY_ROLES_COUNT", "ROLE in office - AMOUNT"))
			self.descBox:addSpaceToNextText(6)
		end
		
		skillData:addHighestSkillLevelText(self.descBox, wrapWidth, highest[skillID])
		
		if average[skillID] ~= 0 then
			skillData:addAverageSkillLevelText(self.descBox, wrapWidth, average[skillID])
		end
		
		self.descBox:positionToMouse(_S(10), _S(10))
	end
end

function bookPurchase:onMouseLeft()
	bookPurchase.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function bookPurchase:createButtons()
	self.bookBuy = gui.create("BookBuyButton", self)
	
	self.bookBuy:setFont(fonts.get("pix16"))
	
	self.bookBuyPlace = gui.create("BookBuyAndPlaceButton", self)
	
	self.bookBuyPlace:setFont(fonts.get("pix16"))
	self.bookBuyPlace:updateClickability()
end

function bookPurchase:updateButtons()
	if self.bookBuy then
		self.bookBuy:updateText()
		self.bookBuyPlace:updateText()
	end
end

gui.register("BookPurchaseElement", bookPurchase, "BookDisplayElement")
