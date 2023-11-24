local gtmatch = {}

function gtmatch:updateDisplay(themeID)
	self:show()
	self:removeAllText()
	print("helb?", themeID)
	gameProject:fillWithThemeGenreMatches(self, themeID, 300)
end

function gtmatch:hideDisplay()
	self:removeAllText()
	self:hide()
end

gui.register("ThemeGenreMatchDescbox", gtmatch, "GenericDescbox")
