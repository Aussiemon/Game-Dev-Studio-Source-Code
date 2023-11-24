local massAdvertBudgetSlider = {}

massAdvertBudgetSlider.rounding = 1
massAdvertBudgetSlider.valueMult = 100

function massAdvertBudgetSlider:setConfirmationButton(button)
	self.button = button
end

function massAdvertBudgetSlider:onSetValue(oldvalue)
	if oldvalue ~= self.value then
		self.button:setBudgetPercentage(self.value)
		events:fire(advertisement:getData("mass_advertisement").EVENTS.BUDGET_CHANGED, self.value)
	end
end

gui.register("MassAdvertBudgetSlider", massAdvertBudgetSlider, "Slider")
