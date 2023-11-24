local quitGame = {}

quitGame.text = _T("QUIT_GAME", "Quit game")

function quitGame:init()
	self:setFont(fonts.get("pix24"))
end

function quitGame:onClick(x, y, key)
	game.quit()
end

gui.register("QuitGameButton", quitGame, "Button")
