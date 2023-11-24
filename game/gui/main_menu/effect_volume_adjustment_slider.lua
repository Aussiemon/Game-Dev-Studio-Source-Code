local effectSlider = {}

function effectSlider:init()
	self:setVolumeType(sound.VOLUME_TYPES.EFFECTS)
	self:setBaseText(_T("EFFECT_VOLUME_LEVEL", "Effect volume level SLIDER_VALUE%"))
end

gui.register("EffectVolumeAdjustmentSlider", effectSlider, "VolumeAdjustmentSlider")
