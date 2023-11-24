local eyeAdjustment = {}

function eyeAdjustment:getPart()
	return self:getParent():getEmployee():getPortrait():getEye()
end

function eyeAdjustment:clickedCallback(portrait)
	local res = self:advanceStep().id
	
	portrait:setEye(res)
end

gui.register("EyeAdjustmentButton", eyeAdjustment, "AppearanceAdjustmentButton")
