local newGame = {}

newGame.text = _T("START_NEW_GAME", "Start new game")

function newGame:init()
	self:setFont(fonts.get("pix24"))
end

function newGame:onClick(x, y, key)
	game.createNewGameMenu()
end

gui.register("StartNewGameButton", newGame, "Button")
