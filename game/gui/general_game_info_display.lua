local gameInfoDisplay = {}

gameInfoDisplay.skinPanelFillColor = color(86, 104, 135, 255)
gameInfoDisplay.skinPanelHoverColor = gameInfoDisplay.skinPanelFillColor
gameInfoDisplay.extraInfoColor = color(140, 180, 206, 255)
gameInfoDisplay.saleInfoColor = color(184, 206, 171, 255)
gameInfoDisplay.categoryColor = color(201, 206, 171, 255)

function gameInfoDisplay:init()
	self.topDescbox = gui.create("GenericDescbox", self)
	
	self.topDescbox:setPos(0, _S(3))
	self.topDescbox:setShowRectSprites(false)
	self.topDescbox:overwriteDepth(5)
	self.topDescbox:setFadeInSpeed(0)
	
	self.leftDescbox = gui.create("GenericDescbox", self)
	
	self.leftDescbox:setShowRectSprites(false)
	self.leftDescbox:overwriteDepth(5)
	self.leftDescbox:setFadeInSpeed(0)
	
	self.rightDescbox = gui.create("GenericDescbox", self)
	
	self.rightDescbox:setShowRectSprites(false)
	self.rightDescbox:overwriteDepth(5)
	self.rightDescbox:setFadeInSpeed(0)
end

function gameInfoDisplay:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function gameInfoDisplay:setProject(projObject)
	self.project = projObject
	
	self:updateDisplay()
end

function gameInfoDisplay:canShow()
	return self.project ~= nil
end

function gameInfoDisplay:updateDisplay()
	local projectObject = self.project
	local owner = projectObject:getOwner()
	local ownerIsPlayer = owner:isPlayer()
	
	self.topDescbox:removeAllText()
	self.leftDescbox:removeAllText()
	self.rightDescbox:removeAllText()
	
	local capWidth = self.w
	local textLineWidth = capWidth * 0.7
	
	if ownerIsPlayer then
		self.topDescbox:addTextLine(textLineWidth, gui.genericGradientColor, _S(28), "weak_gradient_horizontal")
		self.topDescbox:addText(projectObject:getName(), "bh26", nil, 4, capWidth, "project_stuff", 24, 24)
	end
	
	self.topDescbox:addTextLine(textLineWidth, gui.genericGradientColor, _S(22), "weak_gradient_horizontal")
	self.topDescbox:addText(projectObject:getProjectTypeText(), "pix20", nil, 4, capWidth, genres:getGenreUIIconConfig(genres:getData(projectObject:getGenre()), 20, 20, 18))
	
	local gameTypeText
	
	if projectObject:isNewGame() then
		local prequel = projectObject:getSequelTo()
		
		if prequel then
			gameTypeText = _format(_T("SEQUEL_TO", "Sequel to 'GAME'"), "GAME", prequel:getName())
		end
	else
		local prequel = projectObject:getSequelTo()
		
		if prequel then
			gameTypeText = _format(_T("EXPANSION_PACK_FOR", "Expansion pack for 'EXPANSION'"), "EXPANSION", prequel:getName())
		end
	end
	
	if gameTypeText then
		self.topDescbox:addText(gameTypeText, "bh18", nil, 4, capWidth)
	end
	
	if projectObject:getReleaseDate() then
		self.topDescbox:addSpaceToNextText(2)
		self.topDescbox:addTextLine(textLineWidth, gui.genericGradientColor, _S(22), "weak_gradient_horizontal")
		
		if ownerIsPlayer then
			if #projectObject:getReviews() > 0 then
				self.topDescbox:addText(_format(_T("GAME_RATING_DISPLAY", "RATING/MAX average rating"), "RATING", math.round(projectObject:getReviewRating(), 1), "MAX", review.maxRating), "pix20", game.UI_COLORS.LIGHT_BLUE, 4, capWidth, "star", 22, 22)
			else
				self.topDescbox:addText(_T("NO_REVIEWS_YET", "No reviews yet"), "pix20", game.UI_COLORS.LIGHT_BLUE, 4, capWidth, "star", 22, 22)
			end
		else
			self.topDescbox:addText(_format(_T("GAME_REVIEW_RATING", "RATING/MAX average rating"), "RATING", math.round(projectObject:getReviewRating(), 1), "MAX", review.maxRating), "pix20", game.UI_COLORS.LIGHT_BLUE, 4, capWidth, "star", 22, 22)
		end
	end
	
	self.leftDescbox:setPos(0, self.topDescbox.y + self.topDescbox.h)
	self.rightDescbox:setPos(self.w * 0.5, self.topDescbox.y + self.topDescbox.h)
	
	local textLineWidth = capWidth * 0.5 - _S(10)
	local textLineHeight = _S(28)
	
	self.leftDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.leftDescbox:addText(_format(_T("COST_PER_SALE", "$PRICE/copy (TAX% tax)"), "PRICE", projectObject:getPrice(), "TAX", math.round((1 - gameProject.SALE_POST_TAX_PERCENTAGE) * 100, 1)), "pix20", self.categoryColor, 6, capWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			width = 19,
			height = 19,
			y = 0,
			icon = "game_copy_price",
			x = 3
		}
	})
	self.leftDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.leftDescbox:addText(_format(_T("GAME_SALE_AMOUNT", "COPIES copies sold"), "COPIES", string.roundtobignumber(projectObject:getSales())), "bh18", self.categoryColor, 4, capWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			width = 19,
			height = 19,
			y = 0,
			icon = "game_copies_sold",
			x = 3
		}
	})
	
	if ownerIsPlayer then
		self.leftDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.leftDescbox:addText(_format(_T("GAME_CASH_EARNED", "CASH earned"), "CASH", string.roundtobigcashnumber(projectObject:getMoneyMade(nil))), "bh18", self.categoryColor, 4, capWidth, {
			{
				height = 24,
				icon = "generic_backdrop",
				width = 24
			},
			{
				width = 19,
				height = 19,
				y = 0,
				icon = "money_made",
				x = 3
			}
		})
		
		local moneySpent = projectObject:getMoneySpent()
		
		self.leftDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		
		if moneySpent >= 0 then
			self.leftDescbox:addText(_format(_T("GAME_DEVELOPMENT_COSTS", "Development costs: COST"), "COST", string.roundtobigcashnumber(projectObject:getMoneySpent())), "bh18", self.categoryColor, 4, capWidth, {
				{
					height = 24,
					icon = "generic_backdrop",
					width = 24
				},
				{
					width = 19,
					height = 19,
					y = 0,
					icon = "money_lost",
					x = 3
				}
			})
		else
			self.leftDescbox:addText(_format(_T("GAME_DEVELOPMENT_FUNDING", "Funding: COST"), "COST", string.roundtobigcashnumber(math.abs(projectObject:getMoneySpent()))), "bh18", self.categoryColor, 4, capWidth, {
				{
					height = 24,
					icon = "generic_backdrop",
					width = 24
				},
				{
					width = 19,
					height = 19,
					y = 0,
					icon = "wad_of_cash_minus",
					x = 3
				}
			})
		end
	end
	
	self.rightDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.rightDescbox:addText(_format(_T("GAME_SCALE", "Game scale: xSCALE"), "SCALE", math.round(projectObject:getScale(), 2)), "bh20", self.categoryColor, 4, capWidth, "game_scale", 24, 24)
	
	local releaseDate = projectObject:getReleaseDate()
	local releaseText = releaseDate and _format(_T("GAME_RELEASED_ON", "Released on YEAR/MONTH"), "YEAR", timeline:getYear(releaseDate), "MONTH", timeline:getMonth(releaseDate)) or _T("NOT_RELEASED_YET", "Not released yet")
	
	if not releaseDate then
		self.rightDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		
		if projectObject:wasAnnounced() then
			self.rightDescbox:addText(_T("PROJECT_WAS_ANNOUNCED", "Project announced"), "bh20", nil, 4, capWidth, "exclamation_point", 24, 24)
		else
			self.rightDescbox:addText(_T("PROJECT_NOT_ANNOUNCED", "Project not yet announced"), "bh20", nil, 4, capWidth, "question_mark", 24, 24)
		end
	end
	
	self.rightDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.rightDescbox:addText(releaseText, "pix20", nil, 0, capWidth, "clock_full", 24, 24)
	
	if ownerIsPlayer then
		self.rightDescbox:addSpaceToNextText(5)
		
		local days = projectObject:getDaysWorkedOn()
		local daysText = days == 1 and _T("DAY_WORKED_ON_PROJECT", "Worked on for 1 day") or _format(_T("DAYS_WORKED_ON_PROJECT", "Worked on for DAYS"), "DAYS", timeline:getTimePeriodText(days))
		
		self.rightDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.rightDescbox:addText(daysText, "bh18", self.categoryColor, 4, capWidth, "clock_full", 24, 24)
		self.rightDescbox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.rightDescbox:addText(_format(_T("TOTAL_QA_SESSIONS", "QA Sessions: SESSIONS"), "SESSIONS", projectObject:getFact(gameProject.QA_SESSIONS_FACT) or 0), "bh18", self.categoryColor, 0, capWidth, "project_stuff", 24, 24)
	end
	
	self:setHeight(math.max(_US(self.leftDescbox.y + self.leftDescbox.h), _US(self.rightDescbox.y + self.rightDescbox.h)) - 5)
end

gui.register("GeneralGameInfoDisplay", gameInfoDisplay)
