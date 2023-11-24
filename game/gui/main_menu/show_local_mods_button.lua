local localMods = {}

localMods.hoverText = {
	{
		font = "bh20",
		wrapWidth = 350,
		text = _T("LOCAL_MODS_DESCRIPTION", "View a list of mods loaded locally.")
	}
}

function localMods:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		workshop:createLocalModMenu()
	end
end

gui.register("ShowLocalModsButton", localMods, "Button")
