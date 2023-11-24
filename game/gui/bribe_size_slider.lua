local bribeSlider = {}

function bribeSlider:setConfirmationButton(button)
	self.confirmationButton = button
end

function bribeSlider:clickCallback(newValue)
	self.confirmationButton:setBribeSize(newValue)
end

gui.register("BribeSizeSlider", bribeSlider, "Slider")
