local totalProgress = {}

totalProgress.BAR_COLOR_UNFINISHED = color(150, 225, 150, 255)
totalProgress.BAR_COLOR_FINISHED = color(113, 175, 226, 255)
totalProgress.skinPanelFillColor = color(65, 65, 65, 255)
totalProgress.skinPanelHoverColor = color(100, 100, 100, 255)
totalProgress.skinTextFillColor = color(220, 220, 220, 255)
totalProgress.skinTextHoverColor = color(240, 240, 240, 255)

function totalProgress:init()
end

function totalProgress:setFont(font)
	self.font = font
	self.fontHeight = font:getHeight()
end

function totalProgress:isDisabled()
	return false
end

function totalProgress:setProject(proj)
	self.project = proj
	self.completion = self.project:getOverallCompletion()
	self.progressText = string.easyformatbykeys(_T("DEVELOPMENT_PROGRESS", "Overall progress - PROGRESS%"), "PROGRESS", math.round(self.completion * 100, 1))
	self.drawColor = self.completion == 1 and totalProgress.BAR_COLOR_FINISHED or totalProgress.BAR_COLOR_UNFINISHED
end

function totalProgress:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)
	love.graphics.rectangle("fill", 0, 0, w, h)
	
	local basePos = 0
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.progressText, 5, basePos, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
	
	local baseRectPos = basePos + self.fontHeight
	
	love.graphics.setColor(90, 90, 90, 255)
	love.graphics.rectangle("fill", 5, baseRectPos, w - 10, h - baseRectPos - 4)
	love.graphics.setColor(45, 45, 45, 255)
	love.graphics.rectangle("fill", 7, baseRectPos + 2, w - 14, h - baseRectPos - 8)
	
	local drawColor = self.drawColor
	
	love.graphics.setColor(drawColor.r, drawColor.g, drawColor.b, drawColor.a)
	love.graphics.rectangle("fill", 7, baseRectPos + 2, (w - 14) * self.completion, h - baseRectPos - 8)
end

gui.register("TotalProjectProgressBar", totalProgress)
