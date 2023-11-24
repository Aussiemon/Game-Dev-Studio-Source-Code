local playButton = {}

function playButton:init()
	self:setText(_T("VIEW_STATS", "View stats"))
end

function playButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		game.createStatsPopup()
	end
end

gui.register("PlaythroughStatsButton", playButton, "Button")
