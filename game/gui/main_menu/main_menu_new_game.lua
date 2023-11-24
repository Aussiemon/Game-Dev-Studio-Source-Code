local mainMenuNewGame = {}

mainMenuNewGame.regularSprite = "main_menu_new_game"
mainMenuNewGame.hoverSprite = "main_menu_new_game_outlined"
mainMenuNewGame.regularSize = {
	160,
	136
}
mainMenuNewGame.hoverSize = {
	168,
	144
}
mainMenuNewGame.hoverOffset = {
	-4,
	-4
}
mainMenuNewGame.hoverText = {
	{
		font = "bh24",
		text = _T("START_NEW_GAME", "Start new game")
	}
}
mainMenuNewGame.onClickSound = "main_menu_new_game"

function mainMenuNewGame:onClicked(key)
	game.createNewGameMenu()
end

gui.register("MainMenuNewGame", mainMenuNewGame, "MainMenuObject")
