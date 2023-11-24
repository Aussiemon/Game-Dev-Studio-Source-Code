local faceAdjust = {}

function faceAdjust:getPart()
	return self:getParent():getEmployee():getPortrait():getFace()
end

function faceAdjust:clickedCallback(portrait)
	portrait:setFace(self:advanceStep().id)
end

gui.register("FaceAdjustmentButton", faceAdjust, "AppearanceAdjustmentButton")
