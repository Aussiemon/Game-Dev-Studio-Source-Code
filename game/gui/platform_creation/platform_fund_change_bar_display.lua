local platformFundChange = {}

platformFundChange.costBarColor = game.UI_COLORS.IMPORTANT_1
platformFundChange.canMouseOverBar = true

function platformFundChange:init()
	self.hoverBox = gui.create("GenericDescbox")
	
	self.hoverBox:tieVisibilityTo(self)
	self.hoverBox:overwriteDepth(4000)
	self.hoverBox:hide()
end

function platformFundChange:setFundChange(data)
	self.displayData = data
end

function platformFundChange:getHighestValue()
	local highestValue = -math.huge
	local lowestValue = math.huge
	local data = self.displayData
	
	for i = self.displayRange, #data do
		local val = data[i][2]
		
		highestValue = math.max(highestValue, val)
		lowestValue = math.min(lowestValue, val)
	end
	
	self.lowestValue = lowestValue
	self.highestValue = highestValue
end

function platformFundChange:onMouseEnteredBar(index)
	local wrapW = 300
	local data = self.displayData[index]
	local net = data[2]
	
	self.hoverBox:removeAllText()
	self.hoverBox:show()
	self.hoverBox:setWidth(wrapW)
	self.hoverBox:addSpaceToNextText(4)
	self.hoverBox:addText(timeline:getMonthName(data[1]), "bh22", nil, 10, wrapW)
	
	local icon, clr
	
	if net < 0 then
		icon = "wad_of_cash_minus"
		clr = game.UI_COLORS.RED
	else
		icon = "wad_of_cash_plus"
		clr = game.UI_COLORS.GREEN
	end
	
	local icon = net < 0 and "wad_of_cash_minus" or "wad_of_cash_plus"
	
	self.hoverBox:addTextLine(_S(130), clr, nil, "weak_gradient_horizontal")
	self.hoverBox:addText(_format(_T("PLATFORM_MONTH_NET_CHANGE", "Net change: CHANGE"), "CHANGE", string.roundtobigcashnumber(net)), "bh20", clr, 0, wrapW, icon, 22, 22)
	self.hoverBox:setPos(self.x, self.y + self.h + _S(5))
	
	self.prevIndex = index
	
	self:queueSpriteUpdate()
end

function platformFundChange:onMouseLeftBar(index)
	self.hoverBox:removeAllText()
	self.hoverBox:hide()
	
	self.prevIndex = nil
	
	self:queueSpriteUpdate()
end

function platformFundChange:_updateVisualBars(data, spriteListBack, spriteListFront, priorityOffset, xOff, color, reuseProgress)
	local spaceBetweenBars = _S(self.barWidth + self.spaceBetweenBars)
	local spriteID = 1
	local barX = _S(self.baseBarOffset)
	local br, bg, bb, ba = self.skinPanelFillColor:unpack()
	local topOff = platformFundChange.barTopOffset
	local rawH = self.rawH * 0.5
	local barProg = self.currentBarProgress
	local minHeight = self.minimumBarHeight
	local priority = -0.1 + priorityOffset
	local h = self.h * 0.5
	local barW = self.barWidth
	local mouseIndex = self.prevIndex
	local lineClr = game.UI_COLORS.LIGHT_BLUE
	local r, g, b = lineClr.r, lineClr.g, lineClr.b
	
	self:setNextSpriteColor(r, g, b, 100)
	
	self.backLine = self:allocateSprite(self.backLine, "generic_1px", barX, h - _S(2), 0, self.rawW - self.baseBarOffset * 2, 4, 0, 0, -0.2)
	
	for i = self.displayRange, #data do
		local res
		local val = data[i][2]
		local max = 0
		local negative = false
		local clr
		
		if val < 0 then
			max = self.lowestValue
			negative = true
			
			if mouseIndex and mouseIndex == i then
				clr = game.UI_COLORS.LIGHT_BLUE
			else
				clr = game.UI_COLORS.RED
			end
		elseif val == 0 then
			max = 1
			
			if mouseIndex and mouseIndex == i then
				clr = game.UI_COLORS.LIGHT_BLUE
			else
				clr = game.UI_COLORS.IMPORTANT_2
			end
		else
			max = self.highestValue
			
			if mouseIndex and mouseIndex == i then
				clr = game.UI_COLORS.LIGHT_BLUE
			else
				clr = game.UI_COLORS.GREEN
			end
		end
		
		local barHeight = math.max(minHeight, val / max * rawH - topOff)
		
		self:setNextSpriteColor(br, bg, bb, ba)
		
		local yOffset = negative and 0 or barHeight
		local backdropHeight = math.max(0, barHeight - 1)
		
		if spriteListBack then
			spriteListBack[spriteID] = self:allocateSprite(spriteListBack[spriteID], "horizontal_gradient_75", barX + 2 + xOff, h - _S(yOffset), 0, barW, backdropHeight, 0, 0, -0.15)
		end
		
		self:setNextSpriteColor(clr.r, clr.g, clr.b, clr.a)
		
		spriteListFront[spriteID] = self:allocateSprite(spriteListFront[spriteID], "horizontal_gradient_75", barX + xOff, h - _S(yOffset), 0, barW, barHeight, 0, 0, priority)
		barX = barX + spaceBetweenBars
		spriteID = spriteID + 1
	end
end

gui.register("PlatformFundChangeBarDisplay", platformFundChange, "BarDisplay")
