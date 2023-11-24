local musicSlider = {}

function musicSlider:init()
	self:setVolumeType(sound.VOLUME_TYPES.MUSIC)
	self:setBaseText(_T("MUSIC_VOLUME_LEVEL", "Music volume level SLIDER_VALUE%"))
end

gui.register("MusicVolumeAdjustmentSlider", musicSlider, "VolumeAdjustmentSlider")
