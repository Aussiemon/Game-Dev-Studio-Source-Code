local researchAll = {}

function researchAll:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		studio:beginAutoResearch()
	end
end

gui.register("ResearchAllTechButton", researchAll, "Button")
