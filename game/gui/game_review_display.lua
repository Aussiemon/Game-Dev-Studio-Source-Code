local projectReview = {}

projectReview.skinPanelFillColor = color(86, 104, 135, 255)
projectReview.skinPanelHoverColor = color(179, 194, 219, 255)
projectReview.skinTextFillColor = color(240, 240, 240, 255)
projectReview.skinTextHoverColor = color(255, 255, 255, 255)

function projectReview:init()
	projectReview.font = fonts.get("bh20")
end

function projectReview:setReviewProject(reviewObj, project)
	self.review = reviewObj
	self.reviewer = reviewObj:getReviewer()
	self.icon = self.reviewer:getIcon()
	self.project = project
	self.displayText = string.easyformatbykeys(_T("GAME_REVIEW_TEMPLATE", "REVIEWER\nTheir rating: RATING/10"), "REVIEWER", self.reviewer:getName(), "RATING", reviewObj:getRating())
	
	self:setHeight(_US(string.countlines(self.displayText) * projectReview.font:getHeight()) + 3)
end

function projectReview:getProject()
	return self.project
end

function projectReview:getPlatform()
	return self.platform
end

function projectReview:fillInteractionComboBox(comboBox)
	self.review:fillInteractionComboBox(comboBox)
end

function projectReview:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x - _S(10), y - _S(10))
	
	comboBox.baseButton = self
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	interactionController:setInteractionObject(self, nil, nil, true)
end

function projectReview:onSizeChanged()
	self.smallestAxis = math.min(self.rawW, self.rawH)
end

function projectReview:onMouseEntered()
	self:queueSpriteUpdate()
end

function projectReview:onMouseLeft()
	self:queueSpriteUpdate()
end

function projectReview:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
	
	local bgIconSize = self.smallestAxis - 4
	local quadName = self.icon
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(bgIconSize - 4)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local baseIconX = _S(5)
	local baseX, baseY = baseIconX - _S(2), _S(2)
	local underSize = self.smallestAxis
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, _S(2), _S(2), underSize - 4, underSize - 4, 2, -0.1)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_FILL_2:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", _S(3), _S(3), 0, underSize - 5, underSize - 5, 0, 0, -0.09)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, baseX + _S(bgIconSize * 0.5 - w * 0.5), baseY + _S(bgIconSize * 0.5 - h * 0.5), 0, w, h, 0, 0, -0.05)
end

function projectReview:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setFont(projectReview.font)
	love.graphics.printST(self.displayText, h + 5, 0, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

gui.register("GameReviewDisplay", projectReview)
