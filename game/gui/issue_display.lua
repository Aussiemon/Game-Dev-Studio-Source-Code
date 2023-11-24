local issueDisplay = {}

issueDisplay.baseTextColorInactive = color(200, 200, 200, 255)
issueDisplay.baseTextColor = color(255, 255, 255, 255)
issueDisplay.baseColorInactive = color(103, 122, 91, 255)
issueDisplay.baseColor = color(126, 150, 112, 255)
issueDisplay.underIconColor = color(0, 0, 0, 100)

function issueDisplay:setData(issueData, issueAmount)
	self.issueData = issueData
	self.issueAmount = issueAmount
	self.text = self.issueAmount
	self.textWidth = self.fontObject:getWidth(self.issueAmount)
end

function issueDisplay:onMouseEntered()
	local wrapWidth = 350
	
	self.descBox = gui.create("GenericDescbox")
	
	local baseText = self.issueAmount == 1 and _T("ISSUE_DESCRIPTION_LAYOUT", "ISSUE - COUNT issue") or _T("ISSUE_DESCRIPTION_LAYOUT_PLURAL", "ISSUE - COUNT issues")
	
	self.descBox:addText(string.easyformatbykeys(baseText, "ISSUE", self.issueData.display, "COUNT", self.issueAmount), "bh24", nil, 5, wrapWidth)
	self.descBox:addText(self.issueData.description, "pix18", nil, 0, wrapWidth)
	
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y)
	self:queueSpriteUpdate()
end

function issueDisplay:getIcon()
	return self.issueData.icon
end

gui.register("IssueDisplay", issueDisplay, "QualityPointDisplay")
