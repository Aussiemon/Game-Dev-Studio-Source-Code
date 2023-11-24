local changeLoanButton = {}

function changeLoanButton:setChangeDirection(dir)
	self.changeDirection = dir
	
	if dir > 0 then
		self:setIcon("increase")
	elseif dir < 0 then
		self:setIcon("decrease")
	end
end

function changeLoanButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local loan = studio:getLoan()
		
		if self.changeDirection > 0 and loan >= monthlyCost.getMaxLoan() then
			return 
		elseif self.changeDirection < 0 and loan <= 0 then
			return 
		end
		
		studio:changeLoan(monthlyCost.getLoanChangeAmount() * self.changeDirection)
	end
end

function changeLoanButton:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function changeLoanButton:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

function changeLoanButton:onMouseEntered()
	changeLoanButton.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	local change = monthlyCost.getLoanChangeAmount()
	local text
	
	if self.changeDirection > 0 then
		text = _format(_T("LOAN_OUT_MONEY", "Loan out MONEY"), "MONEY", string.roundtobigcashnumber(change))
	elseif self.changeDirection < 0 then
		text = _format(_T("RETURN_LOAN", "Return LOAN loan"), "LOAN", string.roundtobigcashnumber(change))
	end
	
	self.descBox:addText(text, "bh20", nil, 0, 300, "question_mark", 22, 22)
	self.descBox:positionToMouse(-self.descBox.w - _S(10), -self.descBox.h - _S(10))
end

gui.register("ChangeLoanButton", changeLoanButton, "IconButton")
