local audienceButton = {}

function audienceButton:onMouseLeft()
	audienceButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function audienceButton:setProject(projectObject)
	self.project = projectObject
end

function audienceButton:setAudienceID(id)
	self.audienceID = id
	self.audienceData = audience.registeredByID[self.audienceID]
end

function audienceButton:onMouseEntered()
	audienceButton.baseClass.onMouseEntered(self)
	
	local x, y = self:getPos(true)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("GENRE_AUDIENCE_MATCHING", "Genre-audience matching"), "pix20", nil, 5, 400)
	self.descBox:setPos(x + self.w + _S(5), y)
	
	local added = false
	local goodMatch, avgMatch, badMatch = audience:getSortedMatches(self.audienceID)
	local audienceData = audience.registeredByID[self.audienceID]
	local addedGood = self:addContents(goodMatch, _T("GOOD_AUDIENCE_MATCHES", "Good match:"), nil, nil, "increase")
	local addedAvg = self:addContents(avgMatch, _T("AVERAGE_AUDIENCE_MATCHES", "Average match:"), nil, addedGood > 0 and 5, "tilde_yellow")
	local addedBad = self:addContents(badMatch, _T("BAD_AUDIENCE_MATCHES", "Bad match:"), nil, addedAvg > 0 and 5, "decrease_red")
	
	if addedGood == 0 and addedAvg == 0 and addedBad == 0 then
		self.descBox:addText(_T("NONE_KNOWN_YET", "None known yet"), "bh20", nil, 0, 400)
	end
	
	self.descBox:setDepth(200)
end

function audienceButton:addContents(matchList, header, headerColor, spacing, icon)
	local added = 0
	
	if #matchList > 0 then
		if spacing then
			self.descBox:addSpaceToNextText(spacing)
		end
		
		self.descBox:addText(header, "bh18", headerColor, 0, 400, icon, 20, 20)
		self.descBox:addSpaceToNextText(3)
	end
	
	for key, genreID in ipairs(matchList) do
		local genreData = genres.registeredByID[genreID]
		local match = self.audienceData.genreMatching[genreData.id]
		local contributionSign, textColor = game.getContributionSign(1, match, 0.05, 3, nil, nil, false)
		
		self.descBox:addText(_format(_T("GENRE_AUDIENCE_CONTRIBUTION_LAYOUT", "CONTRIBUTION GENRE"), "CONTRIBUTION", contributionSign, "GENRE", genreData.display), "pix18", textColor or game.UI_COLORS.IMPORTANT_1, 0, 400, genres:getGenreUIIconConfig(genreData, 24, 24, 20))
		
		added = added + 1
	end
	
	return added
end

function audienceButton:onHide()
	self:killDescBox()
end

gui.register("AudienceComboboxButton", audienceButton, "ComboBoxOption")
