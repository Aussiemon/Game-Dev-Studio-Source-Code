local loadGame = {}

loadGame.text = _T("LOAD_GAME", "Load game")

function loadGame:init()
	self:setFont(fonts.get("pix24"))
end

function loadGame:onClick(x, y, key)
	mainMenu:createLoadMenu(nil, game.getSavedGames(), game.SAVE_DIRECTORY, nil, nil, true)
end

gui.register("LoadGameButton", loadGame, "Button")
