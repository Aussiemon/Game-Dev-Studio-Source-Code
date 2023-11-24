local reviewDescription = {}

reviewDescription.showRectSprites = false

function reviewDescription:setReview(reviewObj)
	self.review = reviewObj
	
	self:updateDisplay()
end

function reviewDescription:getReview()
	return self.review
end

function reviewDescription:updateDisplay()
	local wrapWidth = self.w - _S(10)
	local gameProj = self.review:getProject()
	
	self:addText(_format(projectReview.FINAL_SCORE_TEXT[math.random(1, #projectReview.FINAL_SCORE_TEXT)], "SCORE", self.review:getRating()), "pix28", nil, 0, wrapWidth)
	self:addSpaceToNextText(10)
	
	local matchReveals, featureReveals, conclusions = self.review:getMatchReveals(), self.review:getFeatureReveals(), self.review:getConclusions()
	local newInsights = false
	
	if matchReveals then
		newInsights = true
		
		local revealShadowColor, revealColor
		local contrib = studio.CONTRIBUTION_REVEAL_TYPES
		
		for revealType, list in pairs(matchReveals) do
			if revealType == contrib.THEME_MATCHING then
				self:addText(_T("NEW_THEME_GENRE_MATCH", "Theme-genre match discovered!"), "pix20", revealColor, 0, wrapWidth, "exclamation_point", 24, 24, revealShadowColor)
			elseif revealType == contrib.GAME_QUALITY then
				local genre = gameProj:getGenre()
				
				for key, qualityID in ipairs(list) do
					self:addText(_format(_T("NEW_ASPECT_GENRE_MATCH", "Discovered role of ASPECT in GENRE genre games!"), "ASPECT", gameQuality.registeredByID[qualityID].display, "GENRE", genres.registeredByID[genre].display), "pix20", revealColor, 0, wrapWidth, "exclamation_point", 24, 24, revealShadowColor)
				end
			elseif revealType == contrib.PERSPECTIVE_MATCHING then
				self:addText(_T("NEW_PERSPECTIVE_GENRE_MATCH", "Perspective-genre match discovered!"), "pix20", revealColor, 0, wrapWidth, "exclamation_point", 24, 24, revealShadowColor)
			elseif revealType == contrib.AUDIENCE_MATCHING then
				self:addText(_T("NEW_AUDIENCE_GENRE_MATCH", "Audience-genre match discovered!"), "pix20", revealColor, 0, wrapWidth, "exclamation_point", 24, 24, revealShadowColor)
			elseif revealType == contrib.PLATFORM_MATCHING then
				self:addText(_T("NEW_PLATFORM_GENRE_MATCH", "Platform-genre match discovered!"), "pix20", revealColor, 0, wrapWidth, "exclamation_point", 24, 24, revealShadowColor)
			elseif revealType == contrib.SUBGENRE_MATCHING then
				self:addText(_T("NEW_SUBGENRE_MATCH", "Sub-genre match discovered!"), "pix20", revealColor, 0, wrapWidth, "exclamation_point", 24, 24, revealShadowColor)
			end
		end
	end
	
	if featureReveals then
		newInsights = true
		
		local genericRevealText = _T("REVEALED_FEATURE_IMPORTANCE", "Discovered importance of FEATURE!")
		
		for featureID, list in pairs(featureReveals) do
			local featureData = taskTypes.registeredByID[featureID]
			local revealText = featureData:getRevealText() or _format(genericRevealText, "FEATURE", featureData.display)
			
			self:addText(revealText, "pix20", revealColor, 0, wrapWidth, "exclamation_point", 24, 24, revealShadowColor)
		end
	end
	
	if conclusions then
		newInsights = true
		
		for key, conclusionID in ipairs(conclusions) do
			projectReview.registeredConclusionsByID[conclusionID]:addToDescbox(self, wrapWidth)
		end
	end
	
	if not newInsights then
		if self.review:hasRevealedNothingNew() then
			self:addText(_T("NO_NEW_INFO_FROM_REVIEW", "This review does not provide any new insights."), "pix22", nil, 0, wrapWidth, "question_mark", 24, 24)
		else
			self:addText(_T("NO_INFO_FROM_REVIEW", "This review does not provide any insights."), "pix22", nil, 0, wrapWidth, "question_mark", 24, 24)
		end
	end
end

gui.register("ReviewDescription", reviewDescription, "GenericDescbox")
