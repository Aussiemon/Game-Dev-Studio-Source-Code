local mainMenuOptions = {}

mainMenuOptions.regularSprite = "main_menu_options"
mainMenuOptions.hoverSprite = "main_menu_options_outlined"
mainMenuOptions.regularSize = {
	152,
	304
}
mainMenuOptions.hoverSize = {
	160,
	312
}
mainMenuOptions.hoverOffset = {
	-4,
	-4
}
mainMenuOptions.hoverText = {
	{
		font = "bh24",
		text = _T("OPEN_SETTINGS_MENU", "Open settings menu")
	}
}
mainMenuOptions.onClickSound = "main_menu_options"

function mainMenuOptions:onClicked(key)
	mainMenu:createOptionsMenu()
end

gui.register("MainMenuOptions", mainMenuOptions, "MainMenuObject")
