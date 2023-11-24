local hairColor = {}

function hairColor:getPart()
	return self:getParent():getEmployee():getPortrait():getHairColor()
end

function hairColor:clickedCallback(portrait)
	portrait:setHairColor(self:advanceStep().id)
end

gui.register("HairColorAdjustmentButton", hairColor, "AppearanceAdjustmentButton")
