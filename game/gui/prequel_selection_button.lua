local prequelSelect = {}

prequelSelect.skinPanelFillColor = color(86, 104, 135, 255)
prequelSelect.skinPanelHoverColor = color(163, 176, 198, 255)
prequelSelect.skinPanelSelectColor = color(188, 204, 229, 255)
prequelSelect.skinPanelDisableColor = color(100, 100, 100, 255)
prequelSelect.skinTextFillColor = color(215, 215, 215, 255)
prequelSelect.skinTextHoverColor = color(255, 255, 255, 255)
prequelSelect.skinTextSelectColor = color(255, 255, 255, 255)
prequelSelect.skinTextDisableColor = color(200, 200, 200, 255)

function prequelSelect:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setPos(_S(4), _S(4))
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(5)
	self.descriptionBox:setFadeInSpeed(0)
end

function prequelSelect:setProject(proj)
	self.project = proj
end

function prequelSelect:handleEvent(event)
	if event == gameProject.EVENTS.SET_PREQUEL then
		self:queueSpriteUpdate()
	end
end

function prequelSelect:setPrequel(preq)
	self.prequel = preq
	
	for key, gameObj in ipairs(studio:getGames()) do
		if gameObj:getSequelTo() == self.prequel and gameObj:isNewGame() then
			self.hadSequelMade = gameObj
			
			break
		end
	end
	
	self:updateDescBox()
end

function prequelSelect:updateDescBox()
	self.descriptionBox:removeAllText()
	
	local projectObject = self.prequel
	
	self.descriptionBox:addText(projectObject:getName(), "bh26", nil, 4, capWidth, "project_stuff", 24, 24)
	self.descriptionBox:addText(_format(_T("SEQUEL_NAME_DISPLAY", "Sequel: SEQUEL"), "SEQUEL", self.hadSequelMade and self.hadSequelMade:getName() or _T("NO_SEQUEL", "none made")), "bh24", nil, 4, capWidth, "project_stuff", 24, 24)
	
	local genreID = projectObject:getGenre()
	
	self.descriptionBox:addText(_format(_T("THEME_GENRE_GAME", "THEME GENRE Game"), "THEME", themes:getName(projectObject:getTheme()), "GENRE", genres:getName(genreID)), "bh22", nil, 2, capWidth, genres:getGenreUIIconConfig(genres.registeredByID[genreID], 22, 22, 18))
	
	local rating = projectObject:getReviewRating()
	
	if rating == 0 then
		self.descriptionBox:addText(_T("NO_RATINGS_YET", "No ratings yet"), "bh22", nil, 2, capWidth, "star", 24, 24)
	else
		self.descriptionBox:addText(_format(_T("GAME_RATING", "Rating: RATING/MAX"), "RATING", math.round(rating, 1), "MAX", review.maxRating), "bh22", nil, 2, capWidth, "star", 24, 24)
	end
	
	self.descriptionBox:addText(_format(_T("PROJECT_RELEASED_TIME_AGO", "Released TIME ago"), "TIME", timeline:getTimePeriodText(timeline.curTime - projectObject:getReleaseDate())), "pix20", nil, 0, capWidth, "clock_full", 24, 24)
	self:setHeight(_US(self.descriptionBox:getRawHeight()) + 4)
end

function prequelSelect:setFont(font)
	self.font = font
end

function prequelSelect:updateText()
	if not self.font or not self.prequel then
		return 
	end
	
	local time = math.floor(timeline.curTime - self.prequel:getReleaseDate())
	local timeGroup
	
	if time == 1 then
		timeGroup = _T("DAY_AGO", "day ago")
	elseif time == 0 then
		time = ""
		timeGroup = _T("JUST NOW", "just now")
	else
		timeGroup = _T("DAYS_AGO", "days ago")
	end
	
	self.displayText = string.easyformatbykeys(_T("PREQUEL_SELECTION_TEXT_TEMPLATE", "PREQUEL_NAME\nSequel: SEQUEL\nReleased RELEASE_TIME TIMEGROUP"), "PREQUEL_NAME", self.prequel:getName(), "SEQUEL", self.hadSequelMade and self.hadSequelMade:getName() or _T("NONE", "None"), "RELEASE_TIME", time, "TIMEGROUP", timeGroup)
	self.textHeight = self.font:getHeight() * string.countlines(self.displayText)
	
	self:setHeight(self.textHeight + 2)
end

function prequelSelect:onClick(x, y, key)
	if key == gui.mouseKeys.RIGHT then
		self.project:setSequelTo(nil)
		self:queueSpriteUpdate()
	elseif self.project:getSequelTo() == self.prequel then
		self.project:setSequelTo(nil)
		self:queueSpriteUpdate()
	else
		self.project:setSequelTo(self.prequel)
		self:queueSpriteUpdate()
	end
	
	self._basePanel:kill()
end

function prequelSelect:isDisabled()
	return false
end

function prequelSelect:isOn()
	return self.project:getSequelTo() == self.prequel
end

function prequelSelect:onMouseEntered()
	self:queueSpriteUpdate()
end

function prequelSelect:onMouseLeft()
	self:queueSpriteUpdate()
end

function prequelSelect:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

gui.register("PrequelSelectionButton", prequelSelect)
