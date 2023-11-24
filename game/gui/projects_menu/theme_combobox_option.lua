local themeOption = {}

function themeOption:onMouseLeft()
	themeOption.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function themeOption:onMouseEntered()
	themeOption.baseClass.onMouseEntered(self)
	
	local themeGenreMatching = genres:getRevealedThemeMatching(self.themeID)
	local x, y = self:getPos(true)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("THEME_GENRE_MATCHING", "Theme-genre matching:"), "pix20", nil, 10, 700)
	self.descBox:setPos(x + _S(5) + self.w, y)
	
	local themeMatching = themes:getData(self.themeID).match
	
	for key, genreData in ipairs(themeGenreMatching) do
		local genreMatching = themeMatching[genreData.id]
		local signs, color = game.getContributionSign(1, genreMatching, 0.05, 3, nil, nil, nil)
		
		self.descBox:addText(signs .. " " .. genreData.display, "pix18", color, 0, 700, genres:getGenreUIIconConfig(genreData, 24, 24, 20))
	end
	
	if #themeGenreMatching == 0 then
		self.descBox:addText(_T("NONE_KNOWN_YET", "None known yet"), "bh20", nil, 0, 700)
	end
	
	trends:setupThemeTrendDescbox(self.descBox, self.themeID, 700)
	self.descBox:setDepth(200)
end

function themeOption:onHide()
	self:killDescBox()
end

function themeOption:kill()
	themeOption.baseClass.kill(self)
	self:killDescBox()
end

function themeOption:setTheme(themeID)
	self.themeID = themeID
end

gui.register("ThemeComboBoxOption", themeOption, "ComboBoxOption")
