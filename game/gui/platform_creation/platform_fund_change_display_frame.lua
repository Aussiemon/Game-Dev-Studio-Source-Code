local platformFundChangeDisplayFrame = {}

platformFundChangeDisplayFrame.barDisplayClass = "PlatformFundChangeBarDisplay"
platformFundChangeDisplayFrame.skinPanelFillFlashColor = color(124, 150, 193, 230)
platformFundChangeDisplayFrame.redHappinessColorCutoff = 0.5

function platformFundChangeDisplayFrame:init(skipButton)
	self:initSubElements()
end

function platformFundChangeDisplayFrame:onSizeChanged()
end

function platformFundChangeDisplayFrame:onClick(x, y, key)
end

function platformFundChangeDisplayFrame:_updateDisplay()
	local made, spent = self.platform:getFundData()
	local net = made - spent
	local wrapW = self.w
	local total, thisMonth = self.platform:getGameMoney()
	local released = self.platform:isReleased()
	
	if not released then
		self.rightInfo:addText(string.roundtobigcashnumber(net), "bh16", self:getNetChangeColor(net), 0, wrapW)
	elseif self.lessInfo then
		self.rightInfo:addText(string.roundtobigcashnumber(net), "bh16", self:getNetChangeColor(net), 0, wrapW)
		self.rightInfo:addText(string.roundtobignumber(self.platform:getSales()), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(total), "bh16", nil, 0, wrapW)
	elseif not self.added then
		local hap = self.platform:getHappiness()
		
		self.rightInfo:addText(_format("HAP%", "HAP", math.round(hap * 100, 1)), "bh16", self:getHappinessColor(hap), 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(net), "bh16", self:getNetChangeColor(net), 0, wrapW)
		self.rightInfo:addText(string.roundtobignumber(self.platform:getSales()), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(total), "bh16", nil, 0, wrapW)
		self.rightInfo:addText(string.roundtobigcashnumber(thisMonth), "bh16", nil, 0, wrapW)
		
		self.added = true
	else
		local hap = self.platform:getHappiness()
		
		self.rightInfo:updateTextTable(_format("HAP%", "HAP", math.round(hap * 100, 1)), "bh16", 1, self:getHappinessColor(hap))
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(net), "bh16", 2, self:getNetChangeColor(net))
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(self.platform:getSales()), "bh16", 3, nil)
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(total), "bh16", 4, nil)
		self.rightInfo:updateTextTable(string.roundtobigcashnumber(thisMonth), "bh16", 5, nil)
	end
end

function platformFundChangeDisplayFrame:setupTitle()
	self.leftInfo:addText(_format(_T("PLATFORM_FINANCES_IN_QUOTE", "Finances - 'NAME'"), "NAME", self.platform:getName()), "bh18", nil, 0, self.rawW)
	
	local data = self.platform:getMonthFundChangeData()
	
	self.barDisplay:setFundChange(data)
end

gui.register("PlatformFundChangeDisplayFrame", platformFundChangeDisplayFrame, "PlatformSalesDisplayFrame")
