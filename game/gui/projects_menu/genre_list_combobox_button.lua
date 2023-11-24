local function researchNewGenreCallback(self)
	game.attemptCreateDesignSelectionMenu()
end

local genreList = {}

genreList.CATCHABLE_EVENTS = {
	gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED,
	gameProject.EVENTS.CHANGED_GENRE
}

function genreList:init()
	events:addReceiver(self)
end

function genreList:kill()
	genreList.baseClass.kill(self)
	events:removeReceiver(self)
end

function genreList:handleEvent(event, project, newGenre)
	if project == self.project then
		self:queueSpriteUpdate()
		self:updateText()
	end
end

function genreList:isDisabled()
	return not self.project:isNewGame() or self.project:getContractor()
end

local sortedMatches = {
	positive = {},
	indifferent = {},
	negative = {}
}

function genreList:setupDescbox()
	if not self.project:isNewGame() then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("CANT_SELECT_GENRE_CONTENT_PACK", "Game genre can not be changed on content-pack type game projects."), "bh20", nil, 0, 400, "question_mark", 24, 24)
	elseif self.project:getContractor() then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("CANT_SELECT_GENRE_CONTRACT", "Game genre can not be changed on contract game projects."), "bh20", nil, 0, 400, "question_mark", 24, 24)
	end
	
	local platformList = self.project:getTargetPlatforms()
	local genreID = self.project:getGenre()
	
	if #platformList > 0 then
		if not self.descBox then
			self.descBox = gui.create("GenericDescbox")
		else
			self.descBox:addSpaceToNextText(10)
		end
		
		if not genreID then
			self.descBox:addText(_T("GENRE_PLATFORM_MATCHING_NO_GENRE", "Select a genre to view platform matching"), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, 400, "question_mark", 22, 22)
		else
			self.descBox:addText(_T("GENRE_PLATFORM_MATCHING", "Genre-platform matching"), "bh22", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, 400)
			
			for key, platformID in ipairs(platformList) do
				local obj = platformShare:getPlatformByID(platformID)
				local matching = obj:getGenreMatch()
				
				if matching and (obj.PLAYER or studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.PLATFORM_MATCHING, platformID, genreID, nil)) then
					local matchValue = matching[genreID]
					
					if matchValue > 1 then
						sortedMatches.positive[#sortedMatches.positive + 1] = platformID
					elseif matchValue == 1 then
						sortedMatches.indifferent[#sortedMatches.indifferent + 1] = platformID
					else
						sortedMatches.negative[#sortedMatches.negative + 1] = platformID
					end
				end
			end
			
			local addedGood = self:addMatchDisplay(self.descBox, genreID, sortedMatches.positive, _T("GOOD_PLATFORM_MATCHES", "Good match:"), nil, nil, "increase")
			local addedAvg = self:addMatchDisplay(self.descBox, genreID, sortedMatches.indifferent, _T("AVERAGE_PLATFORM_MATCHES", "Average match:"), nil, addedGood > 0 and 5, "tilde_yellow")
			local addedBad = self:addMatchDisplay(self.descBox, genreID, sortedMatches.negative, _T("BAD_PLATFORM_MATCHES", "Bad match:"), nil, addedAvg > 0 and 5, "decrease_red")
			
			table.clearArray(sortedMatches.positive)
			table.clearArray(sortedMatches.indifferent)
			table.clearArray(sortedMatches.negative)
			
			if addedGood == 0 and addedAvg == 0 and addedBad == 0 then
				self.descBox:addText(_T("NONE_KNOWN_YET", "None known yet"), "bh20", nil, 0, 400)
			end
		end
	end
	
	if not self.descBox then
		self.descBox = gui.create("GenericDescbox")
	else
		self.descBox:addSpaceToNextText(10)
	end
	
	if not trends:showAllGenreTrends(self.descBox, wrapWidth) then
		self.descBox:addText(_T("NO_GENRES_TRENDING_CURRENTLY", "No genres are currently trending"), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, 400, "question_mark", 22, 22)
	end
	
	if self.descBox then
		local x, y = self:getPos(true)
		
		self.descBox:setPos(x - self.descBox.w - _S(5), y)
	end
end

function genreList:onMouseEntered()
	genreList.baseClass.onMouseEntered(self)
	self:setupDescbox()
end

function genreList:addMatchDisplay(descbox, genreID, matchList, header, headerColor, spacing, icon)
	local added = 0
	
	if #matchList > 0 then
		if spacing then
			descbox:addSpaceToNextText(spacing)
		end
		
		descbox:addText(header, "pix18", headerColor, 0, 400, icon, 20, 20)
	end
	
	for key, platformID in ipairs(matchList) do
		local platformObj = platformShare:getPlatformByID(platformID)
		local match = platformObj:getGenreMatch()[genreID]
		local contributionSign, textColor = game.getContributionSign(1, match, 0.25, 3, nil, nil, false)
		
		descbox:addText(_format(_T("GENRE_AUDIENCE_CONTRIBUTION_LAYOUT", "CONTRIBUTION GENRE"), "CONTRIBUTION", contributionSign, "GENRE", platformObj:getName()), "pix18", textColor or game.UI_COLORS.IMPORTANT_1, 0, 400)
		
		added = added + 1
	end
	
	return added
end

function genreList:onMouseLeft()
	genreList.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function genreList:setGenre(genreID)
	self.project:setGenre(genreID)
end

function genreList:setSubgenre(subID)
	self.project:setSubgenre(subID)
end

function genreList:setProject(project)
	self.project = project
	
	self:updateText()
end

function genreList:getProject()
	return self.project
end

function genreList:onShow()
	self:updateText()
end

function genreList:updateText()
	local genreID = self.project:getGenre()
	
	if genreID then
		local genreData = genres.registeredByID[genreID]
		
		self:setText(genreData.display)
	else
		self:setText(_T("SELECT_GENRE", "Select genre"))
	end
end

function genreList:fillInteractionComboBox(object)
	local x, y = self:getPos(true)
	
	object:setPos(x, y + self.h)
	object:setOptionButtonType("GenreComboBoxOption")
	
	local projGenre = self.project:getGenre()
	
	for key, data in ipairs(self.genreList) do
		local optionObject = object:addOption(0, 0, self.rawW, 18, data.display, fonts.get("pix20"), nil)
		
		optionObject:setGenre(data.id)
		optionObject:setBaseButton(self)
		
		if data.id == projGenre then
			optionObject:highlight(true)
		end
	end
	
	if not genres:areAllGenresResearched() then
		object:setOptionButtonType("ComboBoxOption")
		
		local option = object:addOption(0, 0, self.rawW, 18, _T("DESIGN_NEW", "Design new"), fonts.get("pix20"), researchNewGenreCallback)
	end
	
	self.genreList = nil
	
	if projGenre then
		object:getOptionElements()[1]:attemptCreateSubgenreList()
	end
end

genreList.MENU_GENRE_COUNT = 6

function genreList:onClick()
	if not self.project:isNewGame() or self.project:getContractor() then
		return 
	end
	
	if interactionController:attemptHide(self) then
		if not self.descBox then
			self:setupDescbox()
		end
		
		return 
	end
	
	local resGenres = genres:getResearchedGenres()
	
	if #resGenres > 0 then
		if #resGenres >= genreList.MENU_GENRE_COUNT then
			self.project:createGenreSelectionMenu(resGenres)
		else
			self.genreList = resGenres
			
			interactionController:startInteraction(self)
		end
	else
		local popup = gui.create("Popup")
		
		popup:setWidth(600)
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(_T("NO_GENRES_AVAILABLE_TITLE", "No Genres Available"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setText(_T("NO_GENRES_AVAILABLE_DESCRIPTION", "You have no genres researched. You should hire a Designer and have him research genres to make games with."))
		popup:createOKButton(fonts.get("pix20"))
		popup:center()
		frameController:push(popup)
	end
	
	self:killDescBox()
end

gui.register("GenreListComboBoxButton", genreList, "Button")
require("game/gui/projects_menu/genre_combobox_option")
require("game/gui/projects_menu/subgenre_combobox_option")
