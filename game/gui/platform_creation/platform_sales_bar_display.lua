local platformSalesBarDisplay = {}

platformSalesBarDisplay.costBarColor = game.UI_COLORS.IMPORTANT_1

function platformSalesBarDisplay:init()
	self.costSpriteIDs = {}
end

function platformSalesBarDisplay:setExpensesData(data)
	self.expensesData = data
end

function platformSalesBarDisplay:updateVisualBars()
	self:_updateVisualBars(self.displayData, self.backdropSpriteIDs, self.spriteIDs, 0, 0, self.barColor)
	self:_updateVisualBars(self.expensesData, nil, self.costSpriteIDs, 0.05, -_S(2), self.costBarColor, true)
end

function platformSalesBarDisplay:getHighestValue()
	local highestValue = 0
	local data = self.displayData
	local costData = self.expensesData
	
	for i = self.displayRange, #self.displayData do
		highestValue = math.max(highestValue, data[i], costData[i])
	end
	
	self.highestValue = highestValue
end

gui.register("PlatformSalesBarDisplay", platformSalesBarDisplay, "BarDisplay")
