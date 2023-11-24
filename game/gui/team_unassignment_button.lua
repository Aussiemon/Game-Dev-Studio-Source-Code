local teamUnass = {}

function teamUnass:unassignCallback()
	self.teamObj:unassignFromWorkplaces()
	self.baseButton:updateDescbox()
end

function teamUnass:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - _S(20), y - _S(10), true)
end

function teamUnass:fillInteractionComboBox(combobox)
	local button = combobox:addOption(0, 0, 0, 24, _T("UNASSIGN_ALL_MEMBERS", "Unassign all members"), fonts.get("pix20"), teamUnass.unassignCallback)
	
	button.teamObj = self.team
	button.baseButton = self
end

gui.register("TeamUnassignmentButton", teamUnass, "TeamButton")
