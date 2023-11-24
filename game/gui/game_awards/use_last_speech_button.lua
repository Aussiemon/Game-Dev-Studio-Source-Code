local button = {}

function button:updateState()
	self:setCanClick(gameAwards:hasPreviousSpeech())
end

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		gameAwards:restoreLastSpeech()
	end
end

gui.register("UseLastSpeechButton", button, "Button")
