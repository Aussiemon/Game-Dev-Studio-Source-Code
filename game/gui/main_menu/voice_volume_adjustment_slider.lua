local voiceSlider = {}

function voiceSlider:init()
	self:setVolumeType(sound.VOLUME_TYPES.AMBIENT)
	self:setBaseText(_T("VOICE_VOLUME_LEVEL", "Voice volume level SLIDER_VALUE%"))
end

gui.register("VoiceVolumeAdjustmentSlider", voiceSlider, "VolumeAdjustmentSlider")
