local engineStatDisplay = {}

function engineStatDisplay:setStatID(id)
	self.statID = id
	self.statData = engineStats.registeredByID[id]
	
	self:setIcon(self.statData.icon, 16, 16)
end

function engineStatDisplay:onMouseEntered()
	engineStatDisplay.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(self.statData.description, "pix20", nil, 0, 500, "question_mark", 24, 24)
	self.descBox:centerToElement(self)
end

function engineStatDisplay:onMouseLeft()
	engineStatDisplay.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("EngineStatDisplay", engineStatDisplay, "ProgressBarWithText")
