local mainMenuNewGame = {}

mainMenuNewGame.regularSprite = "main_menu_mods"
mainMenuNewGame.hoverSprite = "main_menu_mods_outlined"
mainMenuNewGame.regularSize = {
	188,
	116
}
mainMenuNewGame.hoverSize = {
	192,
	124
}
mainMenuNewGame.hoverOffset = {
	-4,
	-4
}
mainMenuNewGame.hoverText = {
	{
		font = "bh24",
		text = _T("MODDING", "Modding")
	}
}
mainMenuNewGame.onClickSound = nil

function mainMenuNewGame:onClicked(key)
	mainMenu:createModMenu()
end

gui.register("MainMenuModding", mainMenuNewGame, "MainMenuObject")
