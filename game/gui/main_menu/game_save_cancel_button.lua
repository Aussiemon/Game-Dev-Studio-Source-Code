local button = {}

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		frameController:pop()
	end
end

gui.register("GameSaveCancelButton", button, "Button")
