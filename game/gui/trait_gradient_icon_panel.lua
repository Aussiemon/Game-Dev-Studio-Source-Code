local traitPanel = {}

function traitPanel:setTraitData(traitData)
	self.traitData = traitData
	
	self:setHoverText(traitData.hoverText)
end

function traitPanel:setEmployee(employee)
	self.employee = employee
end

function traitPanel:canInitDescBox()
	return self.hoverText or self.traitData
end

function traitPanel:onMouseEntered()
	traitPanel.baseClass.onMouseEntered(self)
	
	if self.traitData then
		self.traitData:formatDescriptionText(self.descBox, self.employee, self.descBoxWrapWidth, "bh20")
	end
end

gui.register("TraitGradientIconPanel", traitPanel, "GradientIconPanel")
