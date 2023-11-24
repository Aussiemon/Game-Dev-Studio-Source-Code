local slanderFrame = {}

function slanderFrame:onKill()
	slanderFrame.baseClass.onKill(self)
	gui:getElementByID(rivalGameCompanies.SLANDER_INFO_PANEL_ID):kill()
end

function slanderFrame:onHide()
	gui:getElementByID(rivalGameCompanies.SLANDER_INFO_PANEL_ID):hideDisplay()
end

gui.register("SlanderSelectionFrame", slanderFrame, "Frame")
