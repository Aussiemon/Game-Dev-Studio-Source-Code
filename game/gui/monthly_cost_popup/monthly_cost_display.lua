local costDisplay = {}

costDisplay.skinTextFillColor = game.UI_COLORS.IMPORTANT_2
costDisplay.skinTextHoverColor = game.UI_COLORS.IMPORTANT_2

function costDisplay:init()
	costDisplay.font = fonts.get("bh24")
	self.cost = 0
	self.text = love.graphics.newText(self.font)
end

function costDisplay:setCost(amount)
	self.cost = amount
	
	self:updateCostText()
end

function costDisplay:updateCostText()
	if self.cost and self.costName then
		self.costText = self.costName
		self.costAmount = _format(_T("MONTHLY_COST_DISPLAY", "$COST/month"), "COST", self.cost)
		self.costAmountWidth = self.font:getWidth(self.costAmount)
		self.costTextY = self.h * 0.5 - self.font:getHeight() * 0.5
	end
end

function costDisplay:onSizeChanged()
	self:readjustText()
end

function costDisplay:readjustText()
	if self.cost and self.costName then
		local smallest, offset = self:getSmallestAxis()
		
		self.text:clear()
		self.text:addShadowed(self.costText, game.UI_COLORS.WHITE, _S(5 + offset), self.costTextY, 1)
		self.text:addShadowed(self.costAmount, game.UI_COLORS.IMPORTANT_1, self.w - _S(5) - self.costAmountWidth, self.costTextY, 1)
	end
end

function costDisplay:getSmallestAxis()
	local smallest = math.min(self.rawW, self.rawH)
	
	return smallest, smallest + 4
end

function costDisplay:setCostType(id)
	self.costID = id
	self.costData = monthlyCost.getCostData(id)
	self.costName = self.costData.display
	self.barColor = self.costData.barColor
	
	self:updateCostText()
end

function costDisplay:setHighestCost(highestCost)
	self.highestCost = highestCost
	self.correlation = self.cost / self.highestCost
end

function costDisplay:onKill()
	self:killDescBox()
end

function costDisplay:updateSprites()
	local smallest, offset = self:getSmallestAxis()
	
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.rectangleSprites = self:allocateRoundedRectangle(self.rectangleSprites, 0, 0, smallest, smallest, 4, -0.5)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.costData.iconQuad, _S(3), _S(3), 0, smallest - 6, smallest - 6, 0, 0, 0)
	
	local r, g, b, a = game.UI_COLORS.STAT_POPUP_PANEL_COLOR:unpack()
	
	self:setNextSpriteColor(r, g, b, 100)
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "generic_1px", _S(offset), 0, 0, self.rawW - offset, self.rawH, 0, 0, -0.5)
	
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.bgSprite3 = self:allocateSprite(self.bgSprite3, "generic_1px", _S(2 + offset), _S(2), 0, self.rawW - 4 - offset, self.rawH - 4, 0, 0, -0.5)
	
	local barColor = self.barColor
	
	self:setNextSpriteColor(barColor:unpack())
	
	self.progressGradientSprite = self:allocateSprite(self.progressGradientSprite, "vertical_gradient_75", _S(2 + offset), _S(2), 0, (self.rawW - 4 - offset) * self.correlation, self.rawH - 4, 0, 0, -0.5)
end

function costDisplay:onMouseEntered()
	if not self.descBox then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(self.costData.display, "pix20", nil, nil, 400)
		self.descBox:addSpaceToNextText(_S(10))
		self.descBox:addText(self.costData.description, "pix20", nil, nil, 400)
		self.descBox:centerToElement(self)
	end
end

function costDisplay:onMouseLeft()
	self:killDescBox()
end

function costDisplay:draw(w, h)
	if self.cost > 0 then
		local barColor = self.barColor
	end
	
	local smallest, offset = self:getSmallestAxis()
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.draw(self.text, 0, 0)
end

gui.register("MonthlyCostDisplay", costDisplay)
