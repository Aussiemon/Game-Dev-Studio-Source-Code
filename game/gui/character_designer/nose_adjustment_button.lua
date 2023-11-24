local noseAdjustment = {}

function noseAdjustment:getPart()
	return self:getParent():getEmployee():getPortrait():getNose()
end

function noseAdjustment:clickedCallback(portrait)
	portrait:setNose(self:advanceStep().id)
end

gui.register("NoseAdjustmentButton", noseAdjustment, "AppearanceAdjustmentButton")
