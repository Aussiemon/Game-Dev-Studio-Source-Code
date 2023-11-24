local button = {}

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		gameAwards:setDefaultSpeech()
	end
end

gui.register("SetDefaultSpeechButton", button, "Button")
