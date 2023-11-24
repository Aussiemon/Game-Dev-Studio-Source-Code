local randomizeGenreMatching = {}

randomizeGenreMatching.state = game.RANDOMIZATION_STATES.GENRE_QUALITY_MATCHING

function randomizeGenreMatching:setupDescbox()
	self.descBox:positionToMouse(_S(10), _S(10))
	self.descBox:addText(_T("PLAYTHROUGH_RANDOMIZE_GENRE_QUALITY_MATCHING", "This will randomize genre-quality matching."), "pix18", nil, 0, wrapwidth)
end

gui.register("RandomizeGenreQualityDisplay", randomizeGenreMatching, "RandomizePlaythroughDisplay")
