local button = {}

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		gameAwards:finishSpeechPrep()
		frameController:pop()
	end
end

gui.register("FinishSpeechPrepButton", button, "Button")
