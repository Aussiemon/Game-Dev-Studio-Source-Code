local rivalFrame = {}

function rivalFrame:onKill()
	rivalFrame.baseClass.onKill(self)
	gui:getElementByID(rivalGameCompanies.EXTRA_RIVAL_INFO_PANEL_ID):kill()
end

function rivalFrame:onHide()
	gui:getElementByID(rivalGameCompanies.EXTRA_RIVAL_INFO_PANEL_ID):hideDisplay()
end

gui.register("RivalFrame", rivalFrame, "Frame")
