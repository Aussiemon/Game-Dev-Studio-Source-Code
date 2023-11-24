local butt = {}

function butt:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		gameAwards:viewCompetitors()
	end
end

gui.register("GameAwardsCompetitorsButton", butt, "Button")
