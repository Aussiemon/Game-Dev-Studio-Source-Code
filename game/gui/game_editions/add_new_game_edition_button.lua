local addNew = {}

function addNew:fillInteractionComboBox(comboBox)
	comboBox.project = self.project
	
	gameEditions:fillWithEditionOptions(comboBox)
	
	local x, y = self:getPos(true)
	
	comboBox:setPos(x + self.w * 0.5 - comboBox.w * 0.5, y - comboBox.h)
end

function addNew:setProject(proj)
	self.project = proj
end

function addNew:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:startInteraction(self)
end

gui.register("AddNewGameEditionButton", addNew, "Button")
