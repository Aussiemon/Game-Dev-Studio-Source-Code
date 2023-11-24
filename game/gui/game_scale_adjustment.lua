projectScale = {}
projectScale.baseText = _T("GAME_PROJECT_SCALE", "Game project scale xSLIDER_VALUE (SCALE_TEXT)")
projectScale.valueMult = 1
projectScale.rounding = 1
projectScale.centerTextX = true
projectScale.centerTextY = true
projectScale.switchToMinValueOnBoundsChanged = false
projectScale.CATCHABLE_EVENTS = {
	gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED,
	gameProject.EVENTS.SCALE_CHANGED,
	gameProject.EVENTS.PLATFORM_STATE_CHANGED,
	gameProject.EVENTS.INHERITED_PROJECT_SETUP
}

function projectScale:init()
	self.maxGameScale = platformShare:getMaxGameScale()
end

function projectScale:handleEvent(event, data)
	if data == self.project then
		if event == gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED or event == gameProject.EVENTS.PLATFORM_STATE_CHANGED or event == gameProject.EVENTS.INHERITED_PROJECT_SETUP then
			self:updateScaleBounds(true)
			self:queueSpriteUpdate()
		elseif event == gameProject.EVENTS.SCALE_CHANGED then
			self:setValue(self.project:getScale())
		end
	end
end

function projectScale:setProject(proj)
	self.project = proj
	
	self:setFont("pix20")
	self:updateScaleBounds()
end

function projectScale:setupDescbox()
end

function projectScale:updateScaleBounds(skipResetToMin)
	local bounds = self.project:getScaleBounds(self.project:getGameType() or gameProject.DEVELOPMENT_TYPE.NEW)
	local maxBound = math.min(bounds[2], self.project:getPlatformScaleBoundary(), self.maxGameScale)
	
	self:setMin(bounds[1])
	self:setMax(maxBound)
	
	if skipResetToMin then
		self:setValue(self:getValue())
	else
		self:setValue(bounds[1])
	end
end

function projectScale:updateText()
	local value = self.value - self.minValue
	local maxVal = self.maxValue - self.minValue
	local percentage = value / self.maxGameScale
	local translations = project.SCALE_TRANSLATIONS
	
	self:setText(string.easyformatbykeys(projectScale.baseText, "SLIDER_VALUE", math.round(self.value, 1), "SCALE_TEXT", translations[math.max(1, math.ceil(percentage * #translations))]))
end

function projectScale:onSetValue()
	if self.value ~= self.project:getScale() then
		self.project:setScale(self.value)
		self:queueSpriteUpdate()
	end
end

gui.register("GameScaleAdjustment", projectScale, "TaskCategoryPriorityAdjustment")
