local activeTaskElement = {}
local designTask = task:getData("design_task")

activeTaskElement.CATCHABLE_EVENTS = {
	designTask.EVENTS.REMOVE_DISPLAY,
	designTask.EVENTS.UPDATE_DISPLAY
}

function activeTaskElement:init(panelColor, textColor, textShadowColor)
	self.panelColor = panelColor
	self.textColor = textColor or activeTaskElement.textColor
	self.textShadowColor = textShadowColor or activeTaskElement.textShadowColor
	self.alpha = 1
end

function activeTaskElement:cancelTaskCallback()
	self.task:getAssignee():cancelTask()
end

function activeTaskElement:fillInteractionComboBox(comboBox)
	comboBox:addOption(0, 0, 0, 18, _T("CANCEL", "Cancel"), fonts.get("pix20"), activeTaskElement.cancelTaskCallback).task = self.task
end

function activeTaskElement:setTask(taskObj)
	self.task = taskObj
	
	self:createWorkPointsDisplay()
end

function activeTaskElement:getTargetObject()
	return self.task
end

function activeTaskElement:setTargetObject(object)
	self.task = object
	
	self:onTargetObjectSet()
end

function activeTaskElement:updateWorkPoints()
	local remainder = self.task:getRemainingWork()
	
	if remainder < 10000 then
		self.workPointsDisplay:setText(string.comma(remainder))
	else
		self.workPointsDisplay:setText(string.roundtobignumber(remainder))
	end
end

function activeTaskElement:updateWorkCompletion()
	self.workCompletionDisplay:setText(_format("COMPLETION%", "COMPLETION", math.round(self:getCompletion() * 100, 1)))
end

function activeTaskElement:getText()
	return self.task:getProjectBoxText()
end

function activeTaskElement:getCompletion()
	return self.task:getCompletionDisplay()
end

function activeTaskElement:updateColor()
	self.barColor = activeTaskElement.barColor
	
	self:setOverrideAlphaLevels(false)
end

function activeTaskElement:handleEvent(event, object)
	if event == designTask.EVENTS.REMOVE_DISPLAY then
		if object == self.task then
			self:kill()
		end
	elseif event == designTask.EVENTS.UPDATE_DISPLAY then
		self:updateText(self:getText())
	end
end

gui.register("ActiveTaskElement", activeTaskElement, "ActiveProjectElement")
