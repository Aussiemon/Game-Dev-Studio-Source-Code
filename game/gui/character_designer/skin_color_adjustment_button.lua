local noseAdjustment = {}

function noseAdjustment:getPart()
	return self:getParent():getEmployee():getPortrait():getSkinColor()
end

function noseAdjustment:clickedCallback(portrait)
	portrait:setSkinColor(self:advanceStep().id)
end

gui.register("SkinColorAdjustmentButton", noseAdjustment, "AppearanceAdjustmentButton")
