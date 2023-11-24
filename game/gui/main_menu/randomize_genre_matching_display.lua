local randomizeGenreMatching = {}

randomizeGenreMatching.state = game.RANDOMIZATION_STATES.THEME_GENRE_MATCHING

function randomizeGenreMatching:setupDescbox()
	self.descBox:positionToMouse(_S(10), _S(10))
	self.descBox:addText(_T("PLAYTHROUGH_RANDOMIZE_THEME_GENRE_MATCHING", "This will randomize theme-genre matching."), "pix18", nil, 0, wrapwidth)
end

gui.register("RandomizeGenreMatchingDisplay", randomizeGenreMatching, "RandomizePlaythroughDisplay")
