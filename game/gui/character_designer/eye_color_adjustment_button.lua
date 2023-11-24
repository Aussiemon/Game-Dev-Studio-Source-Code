local hairColor = {}

function hairColor:getPart()
	return self:getParent():getEmployee():getPortrait():getEyeColor()
end

function hairColor:clickedCallback(portrait)
	portrait:setEyeColor(self:advanceStep().id)
end

gui.register("EyeColorAdjustmentButton", hairColor, "AppearanceAdjustmentButton")
