local qualityPointDisplay = {}

qualityPointDisplay.BASE_CONTRIBUTION_MULTIPLIER = 1
qualityPointDisplay.MAX_CONTRIBUTION_SIGNS = 3
qualityPointDisplay.SIGN_SECTION = 0.25
qualityPointDisplay.AVERAGE_MATCH_COLOR = color(200, 200, 200, 255)

function qualityPointDisplay:setData(data, qualityAmount)
	self.qualityData = data
	self.qualityID = data.id
	self.realQualityPoints = qualityAmount
	self.qualityPoints = math.floor(qualityAmount)
	self.text = string.roundtobignumber(self.qualityPoints)
	self.textWidth = self.fontObject:getWidth(self.text)
end

function qualityPointDisplay:setProject(proj)
	self.project = proj
end

function qualityPointDisplay:onMouseEntered()
	qualityPointDisplay.baseClass.onMouseEntered(self)
	
	local qualityData = gameQuality.registeredByID[self.qualityID]
	local wrapWidth = 300
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_format(_T("QUALITY_TITLE_LAYOUT", "QUALITY - POINTS points"), "QUALITY", qualityData.display, "POINTS", string.comma(self.qualityPoints)), "pix22", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, wrapWidth)
	self.descBox:addText(qualityData.description, "pix16", nil, 6, wrapWidth)
	
	local added = false
	
	if self.project:getReleaseDate() and #self.project:getReviews() then
		if not self.project:getRealReviewStandard() then
			review:setupRealReviewStandard(self.project)
		end
		
		if added then
			self.descBox:addSpaceToNextText(10)
		end
		
		added = true
		
		local requiredPoints = review:getFinalDesiredQualityLevel(self.qualityID, self.project:getFact(review.standardLevelFact), self.project)
		local displayReqPoints = string.comma(requiredPoints)
		
		if requiredPoints < self.realQualityPoints then
			local owner = self.project:getOwner()
			
			if owner:isPlayer() then
				self.descBox:addText(_format(_T("GAME_REVIEW_STANDARD_SET", "You've set a new TYPE standard with this game. (prev standard: STANDARD pts.)"), "TYPE", self.qualityData.display, "STANDARD", displayReqPoints), "bh16", game.UI_COLORS.LIGHT_BLUE_TEXT, 0, wrapWidth, "exclamation_point", 22, 22)
			else
				self.descBox:addText(_format(_T("GAME_REVIEW_STANDARD_SET_RIVAL", "'RIVAL' set a new TYPE standard with this game. (prev standard: STANDARD pts.)"), "TYPE", self.qualityData.display, "STANDARD", displayReqPoints, "RIVAL", owner:getName()), "bh16", game.UI_COLORS.LIGHT_BLUE_TEXT, 0, wrapWidth, "exclamation_point", 22, 22)
			end
		else
			self.descBox:addText(_format(_T("GAME_REVIEW_STANDARD", "The game needed POINTS TYPE points to reach 100% in TYPE."), "POINTS", displayReqPoints, "TYPE", self.qualityData.display), "bh16", nil, 0, wrapWidth, "question_mark", 22, 22)
		end
	end
	
	local highestScoreData = studio:getHighestQualityScoreGame(self.qualityID)
	
	if highestScoreData.game and highestScoreData.game ~= self.project then
		if added then
			self.descBox:addSpaceToNextText(10)
		end
		
		local text = _format(_T("HIGHEST_QUALITY_GAME", "'GAME' had the highest QUALITY score of SCORE points."), "GAME", highestScoreData.game:getName(), "QUALITY", qualityData.display, "SCORE", string.roundtobignumber(highestScoreData.game:getQuality(self.qualityID)))
		local releaseDate = highestScoreData.game:getReleaseDate()
		
		self.descBox:addText(text, "bh18", nil, 0, wrapWidth, "question_mark", 22, 22)
	end
	
	if added then
		self.descBox:addSpaceToNextText(6)
	end
	
	self.descBox:addText(_T("GENRE_MATCHING", "Genre matching:"), "bh18", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, wrapWidth)
	
	local added = false
	
	for key, genreID in ipairs(gameQuality.registeredByID[self.qualityID].genreContributionImportanceList) do
		if studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY, self.qualityID, genreID) then
			local genreData = genres.registeredByID[genreID]
			local signs, color = game.getContributionSign(qualityPointDisplay.BASE_CONTRIBUTION_MULTIPLIER, genreData.scoreImpact[self.qualityID], qualityPointDisplay.SIGN_SECTION, qualityPointDisplay.MAX_CONTRIBUTION_SIGNS, nil, nil, nil)
			
			color = color or qualityPointDisplay.AVERAGE_MATCH_COLOR
			
			self.descBox:addText(table.concatEasy(" ", signs, genreData.display, _T("GENRE_LOWERCASE", "genre")), "pix16", color, 0, wrapWidth, genres:getGenreUIIconConfig(genreData, 22, 22, 18))
			
			added = true
		end
	end
	
	if not added then
		self.descBox:addText(_T("NONE_KNOWN_YET", "None known yet"), "pix18", nil, 0, wrapWidth)
	end
	
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y)
end

function qualityPointDisplay:getIcon()
	return self.qualityData.icon
end

function qualityPointDisplay:onMouseLeft()
	qualityPointDisplay.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("QualityPointDisplay", qualityPointDisplay, "GenericPointDisplay")
