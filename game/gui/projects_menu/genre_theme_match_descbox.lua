local gtmatch = {}

function gtmatch:updateDisplay(genreID)
	self:show()
	self:removeAllText()
	gameProject:fillWithGenreThemeMatches(self, genreID, 300)
end

function gtmatch:hideDisplay()
	self:removeAllText()
	self:hide()
end

gui.register("GenreThemeMatchDescbox", gtmatch, "GenericDescbox")
