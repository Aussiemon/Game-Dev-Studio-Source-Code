local capBar = {}

function capBar:handleEvent()
	self:queueSpriteUpdate()
	self:updateText()
end

function capBar:getProgress()
	return math.min(1, studio:getServerUse() / studio:getRealServerCapacity())
end

function capBar:getBarColor()
	if self.overloaded then
		return game.UI_COLORS.RED
	end
	
	return self:isMouseOver() and self.progressBarHoverColor or self.progressBarColor
end

function capBar:onMouseEntered()
	capBar.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("SERVER_USE_DESCRIPTION_1", "The current server use, as well as the maximum server capacity."), "pix20", nil, 3, 400, "question_mark", 22, 22)
	self.descBox:addText(_T("SERVER_USE_DESCRIPTION_2", "If the server use exceeds the capacity, your MMO players will start losing happiness."), "bh18", nil, 0, 400)
	self.descBox:centerToElement(self)
end

function capBar:onMouseLeft()
	capBar.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function capBar:updateText()
	local use, capacity = studio:getServerUse(), studio:getRealServerCapacity()
	
	if capacity < use then
		self.text = _format(_T("SERVER_USE_DISPLAY_OVERLOADED", "Server use: CUR/MAX - OVERLOADED!"), "CUR", string.roundtobignumber(use), "MAX", string.roundtobignumber(capacity))
		self.overloaded = true
	else
		self.text = _format(_T("SERVER_USE_DISPLAY", "Server use: CUR/MAX"), "CUR", string.roundtobignumber(use), "MAX", string.roundtobignumber(capacity))
		self.overloaded = false
	end
	
	self:setIcon("server_load_full", 16, 16)
end

gui.register("ServerCapacityBar", capBar, "ProgressBarWithText")
