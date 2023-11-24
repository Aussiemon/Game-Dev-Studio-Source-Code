local sgmatch = {}

function sgmatch:updateDisplay(genreID)
	self:show()
	self:removeAllText()
	gameProject:fillWithSubgenreMatches(self, genreID, 300)
end

function sgmatch:hideDisplay()
	self:removeAllText()
	self:hide()
end

gui.register("SubgenreMatchDescbox", sgmatch, "GenericDescbox")
