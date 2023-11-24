local deselectInterest = {}

deselectInterest.skinPanelHoverColor = game.UI_COLORS.IMPORTANT_2

deselectInterest.skinPanelHoverColor:lerp(0.15, 0, 0, 0, 255)

deselectInterest.skinPanelFillColor = deselectInterest.skinPanelHoverColor:duplicate()

deselectInterest.skinPanelFillColor:lerp(0.25, 0, 0, 0, 255)

function deselectInterest:setSelectionElement(data)
	self.selectionElement = data
end

function deselectInterest:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.selectionElement:onDeselectInterest()
		self.basePanel:kill()
	end
end

gui.register("InterestDeselectButton", deselectInterest, "Button")
