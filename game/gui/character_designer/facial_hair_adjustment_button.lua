local facialHairAdjustment = {}

function facialHairAdjustment:getPart()
	return self:getParent():getEmployee():getPortrait():getBeard()
end

function facialHairAdjustment:clickedCallback(portrait)
	local res = self:advanceStep()
	
	portrait:setBeard(res and res.id)
end

gui.register("FacialHairAdjustmentButton", facialHairAdjustment, "AppearanceAdjustmentButton")
