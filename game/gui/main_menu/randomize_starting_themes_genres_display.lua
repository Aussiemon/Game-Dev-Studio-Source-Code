local randomizeStartingThemesGenres = {}

randomizeStartingThemesGenres.state = game.RANDOMIZATION_STATES.STARTING_GENRES

function randomizeStartingThemesGenres:setupDescbox()
	self.descBox:positionToMouse(_S(10), _S(10))
	self.descBox:addText(_T("PLAYTHROUGH_RANDOMIZE_STARTING_THEMES_GENRES", "This will randomize the themes & genres you start out with."), "pix18", nil, 0, wrapwidth)
end

gui.register("RandomizeStartingThemesGenresDisplay", randomizeStartingThemesGenres, "RandomizePlaythroughDisplay")
