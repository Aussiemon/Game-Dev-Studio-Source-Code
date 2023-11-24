local speechSlider = {}

function speechSlider:init()
	self:setVolumeType(sound.VOLUME_TYPES.SPEECH)
	self:setBaseText(_T("SPEECH_VOLUME_LEVEL", "Speech volume level SLIDER_VALUE%"))
end

gui.register("SpeechVolumeAdjustmentSlider", speechSlider, "VolumeAdjustmentSlider")
