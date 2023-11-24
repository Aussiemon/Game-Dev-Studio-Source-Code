local traitOption = {}

function traitOption:setTraitData(traitData)
	self.traitData = traitData
	
	self:setHoverText(self.traitData.hoverText)
end

function traitOption:getTraitData()
	return self.traitData
end

function traitOption:setEmployee(employee)
	self.employee = employee
end

function traitOption:onMouseEntered()
	traitOption.baseClass.onMouseEntered(self)
	self.traitData:formatDescriptionText(self.descBox, self.employee, traits.descboxWrapWidth, "bh20")
end

gui.register("TraitSelectionComboBoxOption", traitOption, "ComboBoxOption")
