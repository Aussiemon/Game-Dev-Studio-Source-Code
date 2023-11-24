local beginButton = {}

beginButton.icon = "platform_begin_work"
beginButton.hoverTextAvailable = {
	{
		font = "bh20",
		icon = "question_mark",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("BEGIN_WORK_ON_PLATFORM", "Begin work on a new platform")
	}
}
beginButton.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.COST_SET,
	playerPlatform.EVENTS.NAME_SET
}

function beginButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		platformParts:beginWork()
		frameController:pop()
	end
end

function beginButton:handleEvent(event, platObj)
	if platObj == platformParts:getPlatformObject() then
		self:updateState()
	end
end

function beginButton:updateState()
	local wasClick = self:getCanClick()
	local reasons = platformParts:getPlatformObject():getPlatformWorkState()
	
	if reasons then
		self:setCanClick(false)
		self:setHoverText(reasons)
		
		if wasClick and self.descBox then
			self:updateDescbox()
		end
	else
		self:setCanClick(true)
		self:setHoverText(self.hoverTextAvailable)
		
		if not wasClick and self.descBox then
			self:updateDescbox()
		end
	end
end

function beginButton:setupDescbox()
	self.descBox:addSpaceToNextText(6)
	beginButton.baseClass.setupDescbox(self)
end

function beginButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w - self.descBox.w, y - self.descBox.h - _S(5))
end

gui.register("BeginPlatformDevButton", beginButton, "IconButton")
