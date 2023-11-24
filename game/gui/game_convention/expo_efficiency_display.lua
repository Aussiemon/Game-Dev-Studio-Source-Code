local expoEfficiencyDisplay = {}

expoEfficiencyDisplay.barXOffset = 3
expoEfficiencyDisplay.barYOffset = 3
expoEfficiencyDisplay.textVerticalOffset = 1

function expoEfficiencyDisplay:setConventionData(data)
	self.conventionData = data
	
	self:updateText()
end

function expoEfficiencyDisplay:handleEvent(event)
	if event == gameConventions.EVENTS.PARTICIPANT_ADDED or event == gameConventions.EVENTS.PARTICIPANT_REMOVED or event == gameConventions.EVENTS.BOOTH_CHANGED then
		self:updateText()
		self:queueSpriteUpdate()
	end
end

function expoEfficiencyDisplay:updateText()
	self.text = string.easyformatbykeys(_T("BOOTH_EFFICIENCY", "Booth efficiency: EFFICIENCY%"), "EFFICIENCY", math.round(self.conventionData:calculateDesiredEmployeeBoost() * 100))
end

function expoEfficiencyDisplay:getProgress()
	return self.conventionData:calculateDesiredEmployeeBoost() / gameConventions:getMaxEmployeeBoost()
end

function expoEfficiencyDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	for key, data in ipairs(developer.expoEfficiencyDescriptionTextTable) do
		self.descBox:addText(data.text, data.font or "pix20", data.textColor, data.lineSpace, 600)
	end
	
	self.descBox:centerToElement(self)
end

function expoEfficiencyDisplay:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

gui.register("ExpoEfficiencyBarDisplay", expoEfficiencyDisplay, "ProgressBarWithText")
