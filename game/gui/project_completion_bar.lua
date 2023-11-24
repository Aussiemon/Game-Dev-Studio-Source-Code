local projectCompletionBar = {}

projectCompletionBar.completion = nil
projectCompletionBar.completionText = nil
projectCompletionBar.project = nil
projectCompletionBar.completionTextWidth = nil
projectCompletionBar.displayColor = nil
projectCompletionBar.skinTextFillColor = color(200, 200, 200, 255)
projectCompletionBar.skinTextHoverColor = color(220, 220, 220, 255)
projectCompletionBar.skinTextDisableColor = color(60, 60, 60, 255)
projectCompletionBar.BAR_COLORS = {
	UNFINISHED = color(207, 229, 117, 255),
	FINISHED_UNRELEASED = color(189, 229, 149, 255),
	FINISHED_RELEASED = color(160, 208, 219, 255)
}

function projectCompletionBar:init()
	projectCompletionBar.completionFont = fonts.get("pix20")
	projectCompletionBar.completionFontHeight = projectCompletionBar.completionFont:getHeight()
end

function projectCompletionBar:setProject(proj)
	self.project = proj
	
	self:updateBar()
end

function projectCompletionBar:updateBar()
	local project = self.project
	local relDate = project:getReleaseDate()
	local isFinished, completion = self.project:isFinished()
	
	self.completion = completion
	self.completionText = self.completion >= 1 and _T("PROJECT_FINISHED", "Finished") or string.easyformatbykeys(_T("COMPLETION_PERCENTAGE", "COMPLETION% complete"), "COMPLETION", math.round(self.completion * 100, 1))
	self.completionTextWidth = projectCompletionBar.completionFont:getWidth(self.completionText)
	
	if relDate then
		self.displayColor = projectCompletionBar.BAR_COLORS.FINISHED_RELEASED
	elseif self.completion >= 1 then
		self.displayColor = projectCompletionBar.BAR_COLORS.FINISHED_UNRELEASED
	else
		self.displayColor = projectCompletionBar.BAR_COLORS.UNFINISHED
	end
end

function projectCompletionBar:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(40, 40, 40, 255)
	love.graphics.rectangle("fill", 0, h - 2 - self.h, self.w, self.h)
	love.graphics.setColor(60, 60, 60, 255)
	love.graphics.rectangle("fill", 2, h - self.h, self.w - 4, self.h - 4)
	love.graphics.setColor(self.displayColor:unpack())
	love.graphics.rectangle("fill", 2, h - self.h, (self.w - 4) * self.completion, self.h - 4)
	love.graphics.setFont(projectCompletionBar.completionFont)
	love.graphics.printST(self.completionText, w * 0.5 - self.completionTextWidth * 0.5, h - 3 - projectCompletionBar.completionFontHeight, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("ProjectCompletionBar", projectCompletionBar)
