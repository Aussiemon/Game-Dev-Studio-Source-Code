local mainMenuLoadGame = {}

mainMenuLoadGame.regularSprite = "main_menu_load_game"
mainMenuLoadGame.hoverSprite = "main_menu_load_game_outlined"
mainMenuLoadGame.regularSize = {
	88,
	160
}
mainMenuLoadGame.hoverSize = {
	96,
	168
}
mainMenuLoadGame.hoverOffset = {
	-4,
	-4
}
mainMenuLoadGame.hoverText = {
	{
		font = "bh24",
		text = _T("LOAD_GAME", "Load game")
	}
}
mainMenuLoadGame.onClickSound = "main_menu_load_game"

function mainMenuLoadGame:onClicked(key)
	mainMenu:createLoadMenu(nil, game.getSavedGames(), game.SAVE_DIRECTORY, nil, nil, true)
end

gui.register("MainMenuLoadGame", mainMenuLoadGame, "MainMenuObject")
