local ratingsDisplay = {}

ratingsDisplay.costBarColor = game.UI_COLORS.IMPORTANT_1
ratingsDisplay.maxBarsToDisplay = 10
ratingsDisplay.canMouseOverBar = true
ratingsDisplay.mouseOverBarColor = game.UI_COLORS.GREEN

function ratingsDisplay:init()
	self.hoverBox = gui.create("GenericDescbox")
	
	self.hoverBox:tieVisibilityTo(self)
	self.hoverBox:overwriteDepth(5000)
	self.hoverBox:hide()
end

function ratingsDisplay:setRatingData(data)
	self.displayData = {}
	
	for i = 1, review.maxRating do
		self.displayData[i] = data[i] or 0
	end
end

function ratingsDisplay:updateVisualBars()
	self:_updateVisualBars(self.displayData, self.backdropSpriteIDs, self.spriteIDs, 0, 0, self.barColor, true)
end

function ratingsDisplay:onMouseEnteredBar(index)
	local wrapW = 300
	local amount = self.displayData[index]
	
	self.hoverBox:removeAllText()
	self.hoverBox:show()
	self.hoverBox:setWidth(wrapW)
	self.hoverBox:addSpaceToNextText(4)
	self.hoverBox:addText(_format(_T("PLATFORM_GAMES_OF_RATING", "RATING/MAX games: AMOUNT"), "RATING", index, "MAX", review.maxRating, "AMOUNT", amount), "bh20", nil, 0, wrapW)
	self.hoverBox:positionToMouse(_S(10), _S(10))
	
	self.prevIndex = index
	
	self:queueSpriteUpdate()
end

function ratingsDisplay:onMouseLeftBar(index)
	self.hoverBox:removeAllText()
	self.hoverBox:hide()
	
	self.prevIndex = nil
	
	self:queueSpriteUpdate()
end

gui.register("PlatformGameRatingsBarDisplay", ratingsDisplay, "BarDisplay")
