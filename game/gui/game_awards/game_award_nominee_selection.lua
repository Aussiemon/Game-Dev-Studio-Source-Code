local nominee = {}

function nominee:onClick(x, y, key)
	if self.gameProject:getReviewRating() < gameAwards:getMinimumParticipationRating() then
		return 
	end
	
	if gameAwards:getDesiredPlayerGame() == self.gameProject then
		gameAwards:setDesiredPlayerGame(nil)
	else
		gameAwards:setDesiredPlayerGame(self.gameProject)
	end
	
	self:queueSpriteUpdate()
	self:killDescBox()
end

function nominee:getBasePanelColor()
	if gameAwards:getDesiredPlayerGame() == self.gameProject then
		if self:isMouseOver() then
			return nominee.selectedHoverPanelColor
		end
		
		return nominee.selectedPanelColor
	end
	
	if self:isMouseOver() then
		return nominee.hoverPanelColor
	end
	
	return nominee.basePanelColor
end

function nominee:createInfoLists()
	self.leftList = gui.create("List", self)
	
	self.leftList:setPanelColor(developer.employeeMenuListColor)
	self.leftList:setCanHover(false)
	
	self.leftList.shouldDraw = false
	
	local baseElementSize = self.rawW * 0.5 - self.panelHorizontalSpacing * 2
	local font = "bh22"
	local nameDisplay = gui.create("GradientPanel", self.leftList)
	
	nameDisplay:setFont(font)
	nameDisplay:setText(string.cutToWidth(self.gameProject:getName(), fonts.get(font), _S(baseElementSize)))
	nameDisplay:setHeight(28)
	nameDisplay:setGradientColor(nominee.gradientColor)
	
	local ratingDisplay = self.gameProject:createRatingDisplay(self.leftList, "bh20", true)
	
	ratingDisplay:setBaseSize(baseElementSize, 0)
	ratingDisplay:setIconSize(25, 25)
	ratingDisplay:setBackdropSize(27)
	ratingDisplay:setBackdropVisible(false)
	ratingDisplay:setIconOffset(1, 1)
	ratingDisplay:setTextColor(game.UI_COLORS.LIGHT_GREEN)
	ratingDisplay:setGradientColor(nominee.gradientColor)
	
	local genreData = genres:getData(self.gameProject:getGenre())
	local x, w, h = genres:getIconUISize(genreData, 27, 27, 25)
	local genreDisplay = gui.create("GradientIconPanel", self.leftList)
	
	genreDisplay:setFont("bh20")
	
	local subGenre = self.gameProject:getSubgenre()
	
	if subGenre then
		genreDisplay:setText(string.cutToWidth(_format("MAIN SUB", "MAIN", genreData.display, "SUB", genres:getData(subGenre).display), fonts.get("bh20"), _S(baseElementSize)))
	else
		genreDisplay:setText(string.cutToWidth(genreData.display, fonts.get("bh20"), _S(baseElementSize)))
	end
	
	genreDisplay:setHeight(28)
	genreDisplay:setGradientColor(nominee.gradientColor)
	genreDisplay:setTextColor(game.UI_COLORS.LIGHT_GREEN)
	genreDisplay:setIcon(genreData.icon)
	genreDisplay:setBackdropSize(27)
	genreDisplay:setIconSize(w, h)
	genreDisplay:centerIcon()
	self.leftList:updateLayout()
	
	self.rightList = gui.create("List", self)
	
	self.rightList:setPos(self.leftList.x + self.leftList.w)
	self.rightList:setPanelColor(developer.employeeMenuListColor)
	self.rightList:setCanHover(false)
	
	self.rightList.shouldDraw = false
	
	local issueDisplay = self.gameProject:createTotalIssueDisplay(self.rightList, "pix22", true)
	
	issueDisplay:setBaseSize(baseElementSize, 0)
	issueDisplay:setIconSize(25, 25)
	issueDisplay:setBackdropSize(27)
	issueDisplay:setIconOffset(1, 1)
	
	local qualityDisplay = self.gameProject:createQualityPointsDisplay(self.rightList, "pix20", true)
	
	qualityDisplay:setBaseSize(baseElementSize, 0)
	qualityDisplay:setIconSize(24, 24, 26)
	qualityDisplay:setIconOffset(2, 1)
	qualityDisplay:setGradientColor(nominee.gradientColor)
	qualityDisplay:setTextColor(game.UI_COLORS.LIGHT_GREEN)
	
	local timeDisplay = gui.create("GradientIconPanel", self.rightList)
	
	timeDisplay:setFont("bh20")
	timeDisplay:setText(string.cutToWidth(_format(_T("PROJECT_RELEASED_TIME_AGO", "Released TIME ago"), "TIME", timeline:getTimePeriodText(timeline.curTime - self.gameProject:getReleaseDate())), fonts.get("bh20"), _S(baseElementSize)))
	timeDisplay:setHeight(28)
	timeDisplay:setGradientColor(nominee.gradientColor)
	timeDisplay:setTextColor(game.UI_COLORS.LIGHT_GREEN)
	timeDisplay:setIcon("clock_full")
	timeDisplay:setBackdropSize(27)
	timeDisplay:setIconSize(25, 25)
	timeDisplay:centerIcon()
	self.rightList:updateLayout()
	self:setHeight(math.max(self.rightList:getRawHeight(), self.leftList:getRawHeight()))
	self.leftList:alignToBottom(0)
	self.rightList:alignToBottom(0)
end

gui.register("GameAwardNomineeSelection", nominee, "GameToPresentSelection")
