local gameCompletion = {}

gameCompletion.barHeight = 12
gameCompletion.iconSize = 20
gameCompletion.skinPanelFillColor = color(86, 104, 135, 255)
gameCompletion.skinPanelHoverColor = color(179, 194, 219, 255)

function gameCompletion:init()
	self.descboxOnHover = true
end

function gameCompletion:initVisual()
	self.fontObject = fonts.get("pix22")
	self.fontHeight = self.fontObject:getHeight()
end

function gameCompletion:setDescboxOnHover(state)
	self.descboxOnHover = state
end

function gameCompletion:setHoverDescbox(descbox)
	self.hoverDescbox = descbox
end

function gameCompletion:onMouseEntered()
	self:queueSpriteUpdate()
	
	if self.descboxOnHover and self.completion < 1 then
		self.descBox = gui.create("WorkAmountDisplay")
		
		self.descBox:setProject(self.project)
		self.descBox:showDisplay()
		self.descBox:centerToElement(self)
		self.descBox:bringUp()
	end
end

function gameCompletion:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function gameCompletion:setProject(proj)
	self.project = proj
	self.completion = self.project:getOverallCompletion()
	self.completionText = _format(_T("GAME_COMPLETION_TEXT", "COMPLETION% complete"), "COMPLETION", math.round(self.completion * 100, 1))
	
	local work = self.project:getRemainingWorkAmount()
	
	self.remainingWorkText = _format(_T("REMAINING_WORK_POINTS", "POINTS work points left"), "POINTS", string.comma(math.abs(math.ceil(work))))
	
	self:updateTextPositions()
end

function gameCompletion:onSizeChanged()
	self:updateTextPositions()
end

function gameCompletion:updateTextPositions()
	if self.completionText then
		self.completionTextX = _S(gameCompletion.iconSize + 10)
		self.remainingWorkTextX = self.w - _S(gameCompletion.iconSize + 10) - self.fontObject:getWidth(self.remainingWorkText)
	end
end

function gameCompletion:updateSprites()
	local pCol = self:getStateColor()
	
	if self.descboxOnHover then
		self:setNextSpriteColor(pCol:unpack())
	else
		self:setNextSpriteColor(self.skinPanelFillColor:unpack())
	end
	
	self.rectangleSprites = self:allocateRoundedRectangle(self.rectangleSprites, 0, 0, self.rawW, self.rawH, 4, -0.25)
	self.wrenchIcon = self:allocateSprite(self.wrenchIcon, "wrench", _S(4), _S(4), 0, self.iconSize, self.iconSize, 0, 0, -0.2)
	self.hammerIcon = self:allocateSprite(self.hammerIcon, "demolition_blue", self.w - _S(self.iconSize + 4), _S(4), 0, self.iconSize, self.iconSize, 0, 0, -0.2)
	self.progressBarSprites = self:allocateProgressBar(self.progressBarSprites, _S(4), self.h - _S(gameCompletion.barHeight + 4), self.rawW - 8, gameCompletion.barHeight, self.completion, game.UI_COLORS.DARK_LIGHT_BLUE, -0.1)
end

function gameCompletion:draw(w, h)
	local scaledY = _S(2)
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.completionText, self.completionTextX, scaledY, 255, 255, 255, 255, 0, 0, 0, 255)
	love.graphics.printST(self.remainingWorkText, self.remainingWorkTextX, scaledY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("GameCompletionProgressBar", gameCompletion, "Panel")
