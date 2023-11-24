local shirtAdjust = {}

function shirtAdjust:getPart()
	return self:getParent():getEmployee():getPortrait():getShirt()
end

function shirtAdjust:clickedCallback(portrait)
	portrait:setShirt(self:advanceStep().id)
end

gui.register("ShirtAdjustmentButton", shirtAdjust, "AppearanceAdjustmentButton")
