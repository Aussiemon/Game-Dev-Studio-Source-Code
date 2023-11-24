local objectiveTaskHUDDisplay = {}

objectiveTaskHUDDisplay.backgroundColor = color(73, 89, 114, 200)
objectiveTaskHUDDisplay.backgroundProgressColor = color(116, 141, 178, 255)
objectiveTaskHUDDisplay.completionIconSpacing = 2
objectiveTaskHUDDisplay.textSpacing = 5
objectiveTaskHUDDisplay.completedTextColor = color(181, 216, 153, 255)
objectiveTaskHUDDisplay.CATCHABLE_EVENTS = {
	objectiveHandler.EVENTS.UPDATE_PROGRESS_DISPLAY,
	objectiveHandler.EVENTS.TASK_FINISHED,
	studio.expansion.EVENTS.ENTER_EXPANSION_MODE,
	studio.expansion.EVENTS.LEAVE_EXPANSION_MODE
}

function objectiveTaskHUDDisplay:init()
	self.newFlash = math.pi * 2 * 3
	self.progressFlash = 0
end

function objectiveTaskHUDDisplay:canShow()
	return studio.expansion:isActive()
end

function objectiveTaskHUDDisplay:initVisual()
	self.fontObject = fonts.get("bh20")
	self.fontHeight = self.fontObject:getHeight()
	
	if not self:canShow() then
		self:hide()
	end
end

function objectiveTaskHUDDisplay:handleEvent(event, obj)
	if event == studio.expansion.EVENTS.LEAVE_EXPANSION_MODE then
		self:hide()
	elseif event == studio.expansion.EVENTS.ENTER_EXPANSION_MODE then
		self:show()
	elseif event == objectiveHandler.EVENTS.TASK_FINISHED and obj == self.task then
		self:kill()
	elseif obj == self.task then
		self:updateDisplayData()
	end
end

function objectiveTaskHUDDisplay:scaleToText()
	self:setWidth(self.rawH + _US(self.fontObject:getWidth(self.displayData.text)) + 10)
	self.task:positionTrackingElement(self)
end

function objectiveTaskHUDDisplay:setTask(obj)
	self.task = obj
	self.allDisplayData = {}
	
	self:updateDisplayData()
end

function objectiveTaskHUDDisplay:updateDisplayData()
	table.clearArray(self.allDisplayData)
	self.task:getConfig():getProgressData(self.allDisplayData, self.task)
	
	self.displayData = self.allDisplayData[1]
	
	self:scaleToText()
	
	self.progressFlash = 1
end

function objectiveTaskHUDDisplay:onMouseEntered()
	if self.displayData.description then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.displayData.description) do
			self.descBox:addText(data.text, data.font, data.color, data.lineSpace, 500)
		end
		
		self.descBox:centerToElement(self)
	end
end

function objectiveTaskHUDDisplay:onMouseLeft()
	self:killDescBox()
end

function objectiveTaskHUDDisplay:think()
	if self.newFlash > 0 then
		self:queueSpriteUpdate()
	elseif self.progressFlash > 0 then
		self:queueSpriteUpdate()
	end
end

function objectiveTaskHUDDisplay:updateSprites()
	if self.newFlash > 0 then
		self:setNextSpriteColor(212, 255, 204, 150 * math.max(0, math.sin(self.newFlash)))
		
		self.underFlash = self:allocateSprite(self.underFlash, "generic_1px", -_S(15), -_S(15), 0, self.rawW + 30, self.rawH + 30, 0, 0, -0.15)
		self.newFlash = self.newFlash - frameTime * 3
	end
	
	if self.progressFlash > 0 then
		self:setNextSpriteColor(self.backgroundColor:lerpResult(self.progressFlash, self.backgroundProgressColor:unpack()))
		
		self.progressFlash = math.max(0, self.progressFlash - frameTime * 3)
	else
		self:setNextSpriteColor(objectiveTaskHUDDisplay.backgroundColor:unpack())
	end
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local smallest = math.min(self.rawW, self.rawH)
	local scaledSpacing = _S(objectiveTaskHUDDisplay.completionIconSpacing)
	
	self.checkboxSprite = self:allocateSprite(self.checkboxSprite, "checkbox_off", 0, 0, 0, smallest, smallest, 0, 0, -0.1)
	
	local icon
	
	if self.displayData.icon then
		icon = self.displayData.icon
	else
		icon = self.displayData.completed and "checkmark" or "close_button"
	end
	
	if self.displayData.iconColor then
		self:setNextSpriteColor(self.displayData.iconColor:unpack())
	end
	
	self.stateSprite = self:allocateSprite(self.stateSprite, icon, scaledSpacing, scaledSpacing, 0, smallest - objectiveTaskHUDDisplay.completionIconSpacing * 2, smallest - objectiveTaskHUDDisplay.completionIconSpacing * 2, 0, 0, -0.1)
	self.textX = _S(smallest + objectiveTaskHUDDisplay.textSpacing)
	self.textY = self.h * 0.5 - self.fontHeight * 0.5
end

function objectiveTaskHUDDisplay:draw(w, h)
	local tCol
	
	if self.displayData.completed then
		tCol = self.completedTextColor
	else
		tCol = game.UI_COLORS.WHITE
	end
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.displayData.text, self.textX, self.textY, tCol.r, tCol.g, tCol.b, tCol.a, 0, 0, 0, 255)
end

gui.register("ObjectiveTaskHUDDisplay", objectiveTaskHUDDisplay)
