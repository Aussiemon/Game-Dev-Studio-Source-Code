local randomizePlatformStats = {}

randomizePlatformStats.state = game.RANDOMIZATION_STATES.PLATFORM_STATS

function randomizePlatformStats:setupDescbox()
	self.descBox:positionToMouse(_S(10), _S(10))
	self.descBox:addText(_T("PLAYTHROUGH_RANDOMIZE_PLATFORM_STATS", "This will randomize various platform stats."), "pix18", nil, 0, wrapwidth)
end

gui.register("RandomizePlatformStatsDisplay", randomizePlatformStats, "RandomizePlaythroughDisplay")
