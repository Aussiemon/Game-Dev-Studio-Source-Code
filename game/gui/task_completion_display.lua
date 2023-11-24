local taskCompletionDisplay = {}

taskCompletionDisplay.finishedText = _T("FINISHED", "TASK - Finished")
taskCompletionDisplay.assigneeText = _T("ASSIGNEE_LAYOUT", "TASK - ASSIGNEE")
taskCompletionDisplay.skinPanelFillColor = color(80, 80, 80, 255)
taskCompletionDisplay.skinPanelHoverColor = color(140, 140, 140, 255)
taskCompletionDisplay.skinTextFillColor = color(180, 180, 180, 255)
taskCompletionDisplay.skinTextHoverColor = color(245, 245, 245, 255)

function taskCompletionDisplay:init()
	self.font = fonts.get("pix20")
	self.fontHeight = self.font:getHeight()
end

function taskCompletionDisplay:setAssignee(assignee)
	self.assignee = assignee
end

function taskCompletionDisplay:setTask(task)
	self.task = task
	
	self:setupText()
end

function taskCompletionDisplay:setupText()
	local assigneeText
	
	if self.assignee then
		assigneeText = self.assignee:getFullName(true)
	else
		assigneeText = _T("UNASSIGNED", "Unassigned")
	end
	
	local completion = self.task:getCompletionDisplay()
	
	if completion >= 1 then
		self.statusText = string.easyformatbykeys(self.finishedText, "TASK", self.task:getName())
	else
		self.statusText = string.easyformatbykeys(self.assigneeText, "TASK", self.task:getName(), "ASSIGNEE", assigneeText)
	end
end

function taskCompletionDisplay:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setFont(self.font)
	love.graphics.printST(self.statusText, 4, 2, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	
	local progressBarX = 2
	local progressBarW = w - 4
	local progressBarY = 5 + self.fontHeight
	local progressBarH = h - 7 - self.fontHeight
	
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("fill", progressBarX, progressBarY, progressBarW, progressBarH)
	love.graphics.setColor(40, 40, 40, 255)
	love.graphics.rectangle("fill", progressBarX + 2, progressBarY + 2, progressBarW - 4, progressBarH - 4)
	love.graphics.setColor(150, 225, 150, 255)
	love.graphics.rectangle("fill", progressBarX + 2, progressBarY + 2, (progressBarW - 4) * self.task:getCompletionDisplay(), progressBarH - 4)
end

gui.register("TaskCompletionDisplay", taskCompletionDisplay)
