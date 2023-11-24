local openWorkshop = {}

openWorkshop.hoverText = {
	{
		font = "bh20",
		wrapWidth = 350,
		text = _T("WORKSHOP_MODS_DESCRIPTION", "View your published and subscribed mods. Upload a new mod using this option too.")
	}
}

function openWorkshop:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		workshop:createMenu()
	end
end

gui.register("OpenWorkshopButton", openWorkshop, "Button")
