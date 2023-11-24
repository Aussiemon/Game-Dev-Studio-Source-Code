local gameSelect = {}

function gameSelect:onClick(x, y, key)
	frameController:pop()
end

gui.register("GenericFrameControllerPopButton", gameSelect, "Button")
