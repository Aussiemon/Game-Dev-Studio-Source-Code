local reviewerSelect = {}

reviewerSelect.skinPanelFillColor = color(86, 104, 135, 255)
reviewerSelect.skinPanelHoverColor = color(163, 176, 198, 255)
reviewerSelect.skinPanelSelectColor = color(125, 175, 125, 255)
reviewerSelect.skinPanelDisableColor = color(40, 40, 40, 255)
reviewerSelect.skinTextFillColor = color(220, 220, 220, 255)
reviewerSelect.skinTextHoverColor = color(240, 240, 240, 255)
reviewerSelect.skinTextSelectColor = color(255, 255, 255, 255)
reviewerSelect.skinTextDisableColor = color(150, 150, 150, 255)
reviewerSelect.EVENTS = {
	ON_SELECTED = events:new()
}

local advertData = advertisement:getData("bribe")

function reviewerSelect:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(200)
	self.descriptionBox:setFadeInSpeed(0)
end

function reviewerSelect:setReviewer(reviewer)
	self.reviewer = reviewer
	self.bribeChancesRevealed = self.reviewer:getBribeChancesRevealed()
	self.icon = reviewer:getIcon()
	
	self:_setReviewer()
end

function reviewerSelect:_setReviewer()
	self:updateDescbox()
	self:setHeight(_US(self.descriptionBox:getHeight()))
end

function reviewerSelect:onSizeChanged()
	self.smallestAxis = math.min(self.rawH, self.rawW)
end

function reviewerSelect:updateSprites()
	reviewerSelect.baseClass.updateSprites(self)
	
	local bgIconSize = self.smallestAxis - 10
	local quadName = self.icon
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(bgIconSize - 10)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local baseIconX = _S(5)
	local baseX, baseY = baseIconX - _S(2), _S(5)
	
	self:setNextSpriteColor(14, 16, 21, 200)
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", baseX, baseY, 0, bgIconSize, bgIconSize, 0, 0, 0.5)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, baseX + _S(bgIconSize * 0.5 - w * 0.5), baseY + _S(bgIconSize * 0.5 - h * 0.5), 0, w, h, 0, 0, 0.5)
end

function reviewerSelect:updateDescbox()
	self.descriptionBox:removeAllText()
	
	local wrapWidth = self.rawW - 50
	
	self.descriptionBox:addSpaceToNextText(3)
	
	local lineWidth = self.w - _S(50)
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericMainGradientColor, _S(24), "weak_gradient_horizontal")
	self.descriptionBox:addText(self.reviewer:getName(), "pix24", nil, 7, wrapWidth)
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, _S(26), "weak_gradient_horizontal")
	
	if self.bribeChancesRevealed then
		local data = self.reviewer:getData()
		
		self.descriptionBox:addText(_format(_T("BRIBE_ACCEPT_CHANCE", "Bribe accept chance: CHANCE% + EXTRA%"), "CHANCE", data.bribeAcceptChance, "EXTRA", math.round(self.reviewer:getData():getExtraBribeAcceptChance(self.confirmButton:getBribeSize()), 1)), "bh20", game.UI_COLORS.LIGHT_BLUE, 1, wrapWidth, {
			{
				width = 24,
				icon = "percentage",
				x = 2,
				height = 24
			}
		})
		self.descriptionBox:addText(_format(_T("BRIBE_REVEAL_CHANCE", "Bribe reveal chance: CHANCE%"), "CHANCE", data.bribeRevealChance), "bh20", nil, 0, wrapWidth, "efficiency", 24, 24)
	else
		self.descriptionBox:addText(_T("BRIBE_ACCEPT_CHANCES_UNKNOWN", "Bribe accept & refusal chances unknown"), "bh20", nil, 0, wrapWidth, {
			{
				width = 24,
				icon = "question_mark",
				x = 2,
				height = 24
			}
		})
	end
	
	self.descriptionBox:setX(self.descriptionBox.h - _S(8))
end

function reviewerSelect:setConfirmationButton(button)
	self.confirmButton = button
end

function reviewerSelect:handleEvent(event)
	if event == reviewerSelect.EVENTS.ON_SELECTED and reviewerObject ~= self.reviewer then
		self:queueSpriteUpdate()
	elseif event == advertData.EVENTS.BRIBE_SIZE_CHANGED and self.bribeChancesRevealed then
		self:updateDescbox()
	end
end

function reviewerSelect:setProject(proj)
	self.project = proj
end

function reviewerSelect:onClick(x, y, key)
	local curTarget = self.confirmButton:getTarget()
	
	if curTarget and curTarget == self.reviewer then
		self.confirmButton:setTarget(nil)
		events:fire(reviewerSelect.EVENTS.ON_SELECTED, self.reviewer)
	else
		self.confirmButton:setTarget(self.reviewer)
		events:fire(reviewerSelect.EVENTS.ON_SELECTED, self.reviewer)
	end
end

function reviewerSelect:kill()
	reviewerSelect.baseClass.kill(self)
	self:killDescBox()
end

function reviewerSelect:isOn()
	return self.confirmButton:getTarget() == self.reviewer
end

function reviewerSelect:setupHoverDescBox()
	for key, descData in ipairs(self.reviewer:getDescription()) do
		self.descBox:addText(descData.text, descData.font, descData.color, descData.lineSpace, 500)
	end
end

function reviewerSelect:onMouseEntered()
	reviewerSelect.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self:setupHoverDescBox()
	self.descBox:centerToElement(self)
end

function reviewerSelect:onMouseLeft()
	reviewerSelect.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function reviewerSelect:draw(w, h)
end

gui.register("BribeReviewerSelectionButton", reviewerSelect, "ComboBoxOptionBuffer")
