local reg = {}

function reg:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		gameAwards:createGameSelectionFrame()
	end
end

gui.register("RegisterGameAwardsButton", reg, "Button")
