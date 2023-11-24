local newMod = {}

function newMod:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		workshop:createNewModMenu()
	end
end

gui.register("WorkshopNewModButton", newMod, "Button")
