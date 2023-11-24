local massAdvertRoundSlider = {}

massAdvertRoundSlider.rounding = 0
massAdvertRoundSlider.valueMult = 1
massAdvertRoundSlider.barXOffset = 3

function massAdvertRoundSlider:setConfirmationButton(button)
	self.button = button
end

function massAdvertRoundSlider:onSetValue(oldvalue)
	if oldvalue ~= self.value then
		self.button:setRounds(self.value)
		events:fire(advertisement:getData("mass_advertisement").EVENTS.ROUNDS_CHANGED, self.value)
	end
end

gui.register("MassAdvertRoundSlider", massAdvertRoundSlider, "Slider")
