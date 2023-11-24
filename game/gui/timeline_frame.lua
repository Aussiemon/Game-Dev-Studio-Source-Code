local timelineFrame = {}

function timelineFrame:onKill()
	timelineFrame.baseClass.onKill(self)
	gui:getElementByID(game.EXTRA_CONTRACT_INFO_PANEL_ID):kill()
end

gui.register("TimelineFrame", timelineFrame, "Frame")
