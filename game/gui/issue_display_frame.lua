local issueDisplayFrame = {}

function issueDisplayFrame:init()
	self:setDisplayText(_T("ISSUES", "Issues"))
	
	self.quadBatch = spriteBatchController:newSpriteBatch("issue_display_frame", "textures/generic_quad.png", 8, "static", 100, false, true, false, true)
	self.spritebatch = spriteBatchController:newSpriteBatch("issue_display_sprites", "textures/spritesheets/ui_icons.png", 8, "static", 100, false, true, false, true)
end

function issueDisplayFrame:setupDisplay()
	local maxWidth = self.w
	local rowCount = 0
	local curH = self.mainTextFontHeight + self.verticalFontSpacing + self.iconSpacing
	
	self.quadBatch:resetContainer()
	self.spritebatch:resetContainer()
	self.text:clear()
	
	local qualityTypeCount = #gameQuality.registered
	
	for key, issueData in ipairs(issues.registered) do
		local element = gui.create("IssueDisplay", self)
		
		element:setBaseFrame(self)
		element:setIssueID(issueData.id)
		element:addDepth(5)
		
		curH = curH + self.iconSpacing
		
		element:setupDisplay(self.iconSpacing, curH, self.baseDisplayWidth, self.baseDisplayHeight)
		element:setPos(self.iconSpacing, curH)
		
		curH = curH + self.baseDisplayHeight
	end
	
	self.w = self.baseDisplayWidth + self.iconSpacing * 2
	self.h = curH + self.iconSpacing
	self.qualityTextY = _S(2)
end

gui.register("IssueDisplayFrame", issueDisplayFrame, "QualityPointFrame")
