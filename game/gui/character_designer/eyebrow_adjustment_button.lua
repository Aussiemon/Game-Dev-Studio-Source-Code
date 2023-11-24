local eyebrowAdjustment = {}

function eyebrowAdjustment:getPart()
	return self:getParent():getEmployee():getPortrait():getEyebrows()
end

function eyebrowAdjustment:clickedCallback(portrait)
	local res = self:advanceStep().id
	
	portrait:setEyebrows(res)
end

gui.register("EyebrowAdjustmentButton", eyebrowAdjustment, "AppearanceAdjustmentButton")
