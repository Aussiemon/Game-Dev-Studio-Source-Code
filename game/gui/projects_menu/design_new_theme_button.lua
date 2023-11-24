local designNew = {}

function designNew:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		game.attemptCreateDesignSelectionMenu()
	end
end

gui.register("DesignNewThemeButton", designNew, "Button")
