local mmoFeeSlider = {}

mmoFeeSlider.rounding = 2

function mmoFeeSlider:setProject(projObj)
	self.barIndex = 1
	self.project = projObj
	self.knownPrices = projObj:isIdealPriceKnown()
	self.bestPrice = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID):getBestFee(projObj)
end

function mmoFeeSlider:finalizeSliderValue(mouseX)
	local pricePoints = gameProject.SUBSCRIPTION_PRICE_POINTS
	local count = #pricePoints
	
	return pricePoints[math.max(1, math.min(count, math.ceil(count * self:getSliderMousePercentage(mouseX))))]
end

function mmoFeeSlider:getPieceColor(index)
	if self.knownPrices then
		if self.bestPrice >= gameProject.SUBSCRIPTION_PRICE_POINTS[index] then
			return game.UI_COLORS.GREEN
		else
			return game.UI_COLORS.RED
		end
	end
	
	return self:getBarColor()
end

function mmoFeeSlider:onSetValue()
	self.project:setFact(gameProject.MMO_SUBSCRIPTION_FEE_FACT, self.value)
	
	for key, fee in ipairs(gameProject.SUBSCRIPTION_PRICE_POINTS) do
		if fee == self.value then
			self.barIndex = key
		end
	end
end

function mmoFeeSlider:getActiveSliderPieces(displayPercentage)
	return self.barIndex
end

gui.register("MMOSubscriptionFeeSlider", mmoFeeSlider, "Slider")
