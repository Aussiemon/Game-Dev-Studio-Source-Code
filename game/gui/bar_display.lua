local barDisplay = {}

barDisplay.skinPanelFillColor = color(86, 104, 135, 255)
barDisplay.skinPanelHoverColor = color(163, 176, 198, 255)
barDisplay.barColor = color(168, 201, 255, 255)
barDisplay.maxBarsToDisplay = 12
barDisplay.spaceBetweenBars = 6
barDisplay.baseBarOffset = 5
barDisplay.barTopOffset = 3
barDisplay.minimumBarHeight = 3
barDisplay.canMouseOverBar = nil
barDisplay.mouseOverBarColor = nil

function barDisplay:init()
	self.spriteIDs = {}
	self.backdropSpriteIDs = {}
	self.currentBarProgress = {}
end

function barDisplay:think()
	self:queueSpriteUpdate()
	
	if self.canMouseOverBar and self:isMouseOver() then
		local index = self:isMouseOverBar(self.displayData)
		
		if self.prevIndex then
			if index then
				if index ~= self.prevIndex then
					self:onMouseEnteredBar(index)
				end
			else
				self:onMouseLeftBar(index)
			end
		elseif index then
			self:onMouseEnteredBar(index)
		end
	end
end

function barDisplay:setDisplayData(list)
	self.displayData = list
end

function barDisplay:onShow()
	self.forceUpdate = true
end

function barDisplay:updateSprites()
	self:setNextSpriteColor(255, 255, 255, 50)
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.2)
	
	if #self.displayData > 0 then
		self:updateVisualBars(self.displayData, self.backdropSpriteIDs, self.spriteIDs, -0.1, 0)
		
		self.forceUpdate = false
	end
end

function barDisplay:updateVisualBars()
	self:_updateVisualBars(self.displayData, self.backdropSpriteIDs, self.spriteIDs, 0, 0, self.barColor)
end

function barDisplay:onMouseLeft()
	barDisplay.baseClass.onMouseLeft(self)
	
	if self.prevIndex then
		self:onMouseLeftBar()
	end
end

function barDisplay:onMouseEnteredBar(index)
end

function barDisplay:onMouseLeftBar(index)
end

function barDisplay:isMouseOverBar(data)
	local spaceBetweenBars = _S(self.barWidth + self.spaceBetweenBars)
	local barX = _S(self.baseBarOffset)
	local barW = _S(self.barWidth)
	local x = self.x
	local mouseX = camera.mouseX
	local localX = mouseX - x
	
	for i = self.displayRange, #data do
		if barX <= localX and localX <= barX + barW then
			return i
		end
		
		barX = barX + spaceBetweenBars
	end
	
	return nil
end

function barDisplay:setInstantProgress(insta)
	self.instantProgress = insta
end

function barDisplay:_updateVisualBars(data, spriteListBack, spriteListFront, priorityOffset, xOff, color, reuseProgress)
	local spaceBetweenBars = _S(self.barWidth + self.spaceBetweenBars)
	local spriteID = 1
	local barX = _S(self.baseBarOffset)
	local r, g, b, a = color:unpack()
	local br, bg, bb, ba = self.skinPanelFillColor:unpack()
	local topOff = barDisplay.barTopOffset
	local rawH = self.rawH
	local highestValue = self.highestValue
	local barProg = self.currentBarProgress
	local minHeight = self.minimumBarHeight
	local appRate = frameTime * 2
	local priority = -0.1 + priorityOffset
	local h = self.h
	local barW = self.barWidth
	local mouseIndex = self.prevIndex
	local insta = self.instantProgress
	local curR, curG, curB, curA
	
	for i = self.displayRange, self.maxRange do
		local res
		
		if reuseProgress then
			res = data[i] / highestValue
		else
			if not barProg[i] then
				barProg[i] = 0
			end
			
			res = math.approach(barProg[i], data[i] / highestValue, appRate)
			barProg[i] = res
		end
		
		local barHeight = math.max(minHeight, res * rawH - topOff)
		
		self:setNextSpriteColor(br, bg, bb, ba)
		
		local backdropHeight = math.max(0, barHeight - 1)
		
		if spriteListBack then
			spriteListBack[spriteID] = self:allocateSprite(spriteListBack[spriteID], "horizontal_gradient_75", barX + 2 + xOff, h - _S(backdropHeight), 0, barW, backdropHeight, 0, 0, -0.15)
		end
		
		if mouseIndex and mouseIndex == i then
			curR, curG, curB, curA = self.mouseOverBarColor:unpack()
		else
			curR, curG, curB, curA = r, g, b, a
		end
		
		self:setNextSpriteColor(curR, curG, curB, curA)
		
		spriteListFront[spriteID] = self:allocateSprite(spriteListFront[spriteID], "horizontal_gradient_75", barX + xOff, h - _S(barHeight), 0, barW, barHeight, 0, 0, priority)
		barX = barX + spaceBetweenBars
		spriteID = spriteID + 1
	end
end

function barDisplay:updateBars()
	local widthPerBar = (self.rawW - self.baseBarOffset - self.maxBarsToDisplay * self.spaceBetweenBars) / self.maxBarsToDisplay
	
	self.barWidth = widthPerBar
	self.displayRange = math.max(1, #self.displayData - (self.maxBarsToDisplay - 1))
	self.maxRange = #self.displayData
	
	self:getHighestValue()
	self:queueSpriteUpdate()
end

function barDisplay:getHighestValue()
	local highestValue = 0
	local data = self.displayData
	
	for i = self.displayRange, #self.displayData do
		highestValue = math.max(highestValue, data[i])
	end
	
	self.highestValue = highestValue
end

function barDisplay:updateHighestValue(newVal)
	self.highestValue = math.max(self.highestValue, newVal)
end

gui.register("BarDisplay", barDisplay)
