local ambientSlider = {}

function ambientSlider:init()
	self:setVolumeType(sound.VOLUME_TYPES.AMBIENT)
	self:setBaseText(_T("AMBIENT_VOLUME_LEVEL", "Ambient sound volume level SLIDER_VALUE%"))
end

gui.register("AmbientVolumeAdjustmentSlider", ambientSlider, "VolumeAdjustmentSlider")
