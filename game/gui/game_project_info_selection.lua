local gameInfoSelectionButton = {}

gameInfoSelectionButton.skinPanelFillColor = color(86, 104, 135, 255)
gameInfoSelectionButton.skinPanelHoverColor = color(179, 194, 219, 255)
gameInfoSelectionButton.skinPanelDisableColor = color(20, 20, 20, 255)
gameInfoSelectionButton.skinTextFillColor = color(200, 200, 200, 255)
gameInfoSelectionButton.skinTextHoverColor = color(220, 220, 220, 255)
gameInfoSelectionButton.skinTextDisableColor = color(60, 60, 60, 255)
gameInfoSelectionButton.completionBarHeight = 44
gameInfoSelectionButton.completionBarPad = 2
gameInfoSelectionButton.CATCHABLE_EVENTS = {
	project.EVENTS.SCRAPPED_PROJECT
}

function gameInfoSelectionButton:handleEvent(event, projObj)
	if projObj == self.project then
		projectsMenu:removeGameObjectElement(self.project)
	end
end

function gameInfoSelectionButton:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setPos(0, _S(4))
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(5)
	self.descriptionBox:setFadeInSpeed(0)
end

function gameInfoSelectionButton:onSizeChanged()
	if self.completionBar then
		self.completionBar:setWidth(self.rawW - 8)
		self.completionBar:setPos(_S(4), self.h - self.completionBar.h - _S(gameInfoSelectionButton.completionBarPad) - _S(4))
	end
end

function gameInfoSelectionButton:setProject(project)
	self.project = project
	
	self:updateDescBox()
end

function gameInfoSelectionButton:updateDescBox()
	local projectObject = self.project
	local ownerIsPlayer = projectObject:getOwner():isPlayer()
	local progressBarHeight = 0
	
	self.descriptionBox:removeAllText()
	
	if ownerIsPlayer and not projectObject:getReleaseDate() then
		if not self.completionBar then
			self.completionBar = gui.create("GameCompletionProgressBar", self)
			
			self.completionBar:setProject(projectObject)
			self.completionBar:setHeight(gameInfoSelectionButton.completionBarHeight)
			self.completionBar:setCanHover(false)
		end
		
		progressBarHeight = self.completionBar:getRawHeight() + 10
	end
	
	local capWidth = 500
	local lineWidth = self.w - _S(10)
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(projectObject:getName(), "bh26", nil, 4, capWidth, {
		{
			width = 24,
			icon = "profession_backdrop",
			x = 2,
			height = 24
		},
		{
			width = 22,
			height = 22,
			y = 0,
			icon = "project_stuff",
			x = 3
		}
	})
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(projectObject:getProjectTypeText(), "bh22", nil, 2, capWidth, genres:getGenreUIIconConfig(genres:getData(projectObject:getGenre()), 20, 20, 18))
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	
	if ownerIsPlayer then
		self.descriptionBox:addText(_format(_T("ENGINE_USED_FOR_GAME", "Engine used - ENGINE"), "ENGINE", projectObject:getEngine():getName()), "pix22", nil, 6, capWidth)
	else
		self.descriptionBox:addSpaceToNextText(3)
		self.descriptionBox:addText(_format(_T("GAME_REVIEW_RATING", "RATING/MAX average rating"), "RATING", math.round(projectObject:getReviewRating(), 1), "MAX", review.maxRating), "pix20", game.UI_COLORS.LIGHT_BLUE, 4, capWidth, "star", 22, 22)
	end
	
	local releaseDate = projectObject:getReleaseDate()
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	
	local releaseText = releaseDate and _format(_T("GAME_RELEASED_ON", "Released on YEAR/MONTH"), "YEAR", timeline:getYear(releaseDate), "MONTH", timeline:getMonth(releaseDate)) or _T("NOT_RELEASED_YET", "Not released yet")
	
	if not releaseDate then
		if projectObject:wasAnnounced() then
			self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
			self.descriptionBox:addText(_T("PROJECT_WAS_ANNOUNCED", "Project announced"), "bh20", nil, 4, capWidth, "exclamation_point", 24, 24)
		else
			self.descriptionBox:addTextLine(lineWidth, game.UI_COLORS.YELLOW, nil, "weak_gradient_horizontal")
			self.descriptionBox:addText(_T("PROJECT_NOT_ANNOUNCED", "Project not yet announced"), "bh20", nil, 4, capWidth, "question_mark", 24, 24)
		end
	elseif ownerIsPlayer then
		local moneyMade = projectObject:getMoneyMade()
		local moneySpent = projectObject:getMoneySpent()
		local delta = moneyMade - moneySpent
		
		if delta > 0 then
			self.descriptionBox:addTextLine(lineWidth, game.UI_COLORS.LIGHT_GREEN, nil, "weak_gradient_horizontal")
			self.descriptionBox:addText(_format(_T("PROJECT_MONEY_MADE_PROFIT", "Profit: MONEY (total: TOTAL)"), "MONEY", string.roundtobigcashnumber(delta), "TOTAL", string.roundtobigcashnumber(moneyMade)), "bh20", nil, 4, capWidth, "money_made", 24, 24)
		else
			self.descriptionBox:addTextLine(lineWidth, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
			self.descriptionBox:addText(_format(_T("PROJECT_MONEY_MADE_LOSS", "Loss: MONEY (total: TOTAL)"), "MONEY", string.roundtobigcashnumber(math.abs(delta)), "TOTAL", string.roundtobigcashnumber(moneyMade)), "bh20", nil, 4, capWidth, "money_lost", 24, 24)
		end
	end
	
	self.descriptionBox:addTextLine(lineWidth, gui.genericGradientColor, _S(26), "weak_gradient_horizontal")
	self.descriptionBox:addText(releaseText, "pix20", nil, 0, capWidth, "clock_full", 24, 24)
	self:setHeight(_US(self.descriptionBox:getRawHeight()) + progressBarHeight + 4)
end

function gameInfoSelectionButton:getProject()
	return self.project
end

function gameInfoSelectionButton:fillInteractionComboBox(comboBox)
	self.project:fillInteractionComboBox(comboBox)
end

function gameInfoSelectionButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local comboBox = gui.create("ComboBox")
	
	comboBox:setPos(x - 20, y)
	
	comboBox.baseButton = self
	
	comboBox:setDepth(150)
	comboBox:setAutoCloseTime(0.5)
	interactionController:setInteractionObject(self, nil, nil, true)
end

function gameInfoSelectionButton:isDisabled()
	return false
end

function gameInfoSelectionButton:onKill()
	if self.descBox and self.descBox:isValid() then
		self.descBox:kill()
		
		self.descBox = nil
	end
end

function gameInfoSelectionButton:isOn()
	return false
end

function gameInfoSelectionButton:hide()
	gameInfoSelectionButton.baseClass.hide(self)
	self:killDescBox()
end

function gameInfoSelectionButton:onMouseEntered()
	self:queueSpriteUpdate()
end

function gameInfoSelectionButton:onMouseLeft()
	self:queueSpriteUpdate()
end

function gameInfoSelectionButton:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

gui.register("GameProjectInfoSelection", gameInfoSelectionButton)
