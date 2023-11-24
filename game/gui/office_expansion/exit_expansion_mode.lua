local exitExpansionButton = {}

exitExpansionButton.icon = "new_exit_mode"
exitExpansionButton.hoverIcon = "new_exit_mode_hover"
exitExpansionButton.hoverText = {
	{
		font = "bh24",
		text = _T("EXIT_EXPANSION_MODE", "Exit expansion mode")
	}
}

function exitExpansionButton:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h * 0.5 - self.descBox.h * 0.5)
end

function exitExpansionButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		studio.expansion:attemptLeave()
	end
end

gui.register("ExitExpansionModeButton", exitExpansionButton, "IconButton")

exitExpansionButton.regularIconColor = exitExpansionButton.mouseOverIconColor
